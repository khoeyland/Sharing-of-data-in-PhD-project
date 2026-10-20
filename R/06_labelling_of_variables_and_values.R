# Labelling of variables and values from the codebook -----------------------

# Starting from the merged measurement-level data frame created upstream
hfr_tdi_calibr_cases_labelled <- hfr_tdi_calibr_cases

# Function for checking for labels after major pipeline steps ---------------

check_labels <- function(data) {
  tibble::tibble(
    variable = names(data),
    # null_action = "na" ensures unlabelled columns show NA rather than ""
    label = labelled::var_label(data, unlist = TRUE, null_action = "na")
  )
}


# Variable labels from codebook ---------------------------------------------

# Only variables with exactly one distinct variable label are used. In the codebook, sw_loc_mod, vel_group_man and vel_group_aut have a different text on each value row (describing the value, not the variable). These are handled with manual labels below.
codebook_variable_labels <- hfr_tdi_codebook |>
  filter(!is.na(variable_label), variable_label != "") |>
  distinct(variable_name, variable_label) |>
  group_by(variable_name) |>
  filter(n() == 1) |>
  ungroup() |>
  deframe()

# Applying labels only for variables that exist in the data frame
variable_labels_existing <- codebook_variable_labels[
  names(codebook_variable_labels) %in% names(hfr_tdi_calibr_cases_labelled)
]

hfr_tdi_calibr_cases_labelled <- hfr_tdi_calibr_cases_labelled |>
  set_variable_labels(.labels = as.list(variable_labels_existing), .strict = FALSE)


# Value labels from codebook ------------------------------------------------

value_labels_list <- hfr_tdi_codebook |>
  filter(!is.na(value), !is.na(value_label), value_label != "") |>
  mutate(value_num = suppressWarnings(as.numeric(value))) |>
  filter(!is.na(value_num)) |>
  distinct(variable_name, value_num, value_label) |>
  group_by(variable_name) |>
  summarise(val_labels = list(setNames(value_num, value_label)), .groups = "drop") |>
  filter(variable_name %in% names(hfr_tdi_calibr_cases_labelled))

labels_named_list <- setNames(value_labels_list$val_labels, value_labels_list$variable_name)

# Matching code type to the column type (typeof() also works for already labelled columns)
labels_named_list_typed <- imap(labels_named_list, function(val_vec, var_name) {
  if (typeof(hfr_tdi_calibr_cases_labelled[[var_name]]) == "character") {
    setNames(as.character(val_vec), names(val_vec))
  } else {
    val_vec
  }
})

# All-NA columns are read as logical by readxl, and set_value_labels() requires numeric
cols_logical_with_labels <- names(labels_named_list_typed)[
  map_lgl(names(labels_named_list_typed), ~ is.logical(hfr_tdi_calibr_cases_labelled[[.x]]))
]
hfr_tdi_calibr_cases_labelled <- hfr_tdi_calibr_cases_labelled |>
  mutate(across(all_of(cols_logical_with_labels), as.double))

hfr_tdi_calibr_cases_labelled <- hfr_tdi_calibr_cases_labelled |>
  set_value_labels(!!!labels_named_list_typed)


# Manual variable labels ----------------------------------------------------

# For variables not in the codebook, with ambiguous codebook labels, or derived in the R pipeline. Consider adding these to the codebook Excel file, so that they are covered by the codebook step.
hfr_tdi_calibr_cases_labelled <- hfr_tdi_calibr_cases_labelled |>
  set_variable_labels(
    .strict = FALSE,
    event          = "Cardiac event for shear wave",
    sw_loc_mod     = "Shear wave location, imaging mode and analysis method",
    vel_group_man  = "Velocity group, manual measurement",
    vel_group_aut  = "Velocity group, automatic (regression) measurement",
    case_vel_group = "Velocity group assigned to the case (overall decision, post-MVC, PLAX)",
    sw_other       = "Other information on shear wave / file",
    gr_case_nr     = "Case number within velocity group",
    comment        = "Comment on shear wave measurement",
    file_comment   = "Comment on file (from file meta data)",
    uploaded       = "HFR TDI file uploaded to GEVU ftp server",
    fps_tdi        = "Frame rate for HFR TDI in the view (frames per second)"
  )


# Manual value labels -------------------------------------------------------

# case_vel_group uses the same coding as vel_group_man. Applied here until it has value labels in the codebook.
if (is.null(val_labels(hfr_tdi_calibr_cases_labelled$case_vel_group))) {
  val_labels(hfr_tdi_calibr_cases_labelled$case_vel_group) <-
    val_labels(hfr_tdi_calibr_cases_labelled$vel_group_man)
}

# Add value labels here for variables not covered by the codebook, or to override.
# Example:
# hfr_tdi_calibr_cases_labelled <- hfr_tdi_calibr_cases_labelled |>
#   set_value_labels(some_variable = c("Category A" = 1, "Category B" = 2))


# Check labels --------------------------------------------------------------

check_labels(hfr_tdi_calibr_cases_labelled) |>
  print(n = 40)

# Variables still without a label
check_labels(hfr_tdi_calibr_cases_labelled) |>
  filter(is.na(label))

# For interactive inspection:
# labelled::look_for(hfr_tdi_calibr_cases_labelled)


# Adding comment to derived dataset and saving ------------------------------

comment(hfr_tdi_calibr_cases_labelled) <- "HFR TDI calibration cases, one row per shear wave measurement, with file meta data and fps. Labelled from codebook, with manual additions."

saveRDS(hfr_tdi_calibr_cases_labelled, "data/clean/hfr_tdi_calibr_cases_labelled.rds")
