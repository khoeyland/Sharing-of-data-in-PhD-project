# Descriptive statistics for uploaded HFR TDI calibration cases -------------

# Using the labelled data frame. to_factor() turns value labels into factor levels.
hfr_tdi_uploaded_labelled <- hfr_tdi_calibr_cases_labelled |>
  filter(uploaded) |>
  labelled::to_factor()

# Cases by velocity group (case-level decision, case_vel_group) ---------------

# One row per uploaded case. This is the grouping used for the folders on the ftp server.
hfr_tdi_cases <- hfr_tdi_uploaded_labelled |>
  distinct(id, case_vel_group)

stopifnot(!anyDuplicated(hfr_tdi_cases$id))

hfr_tdi_cases_by_group <- hfr_tdi_cases |>
  count(case_vel_group, name = "n_cases")

hfr_tdi_cases_by_group

# Comparing the case-level decision with the median manual velocity. Based on post-MVC (event 3) in standard PLAX (sw_loc_mod 3), which is what the group decision is mainly based on according to the README. Cut-offs: < 3, 3-8, > 8 m/s.
hfr_tdi_case_group_check <- hfr_tdi_calibr_cases |>
  filter(uploaded, sw_loc_mod == 3, event == 3) |>
  group_by(id, case_vel_group) |>
  summarise(
    n_measurements = sum(!is.na(manual_vel)),
    median_manual_vel = median(manual_vel, na.rm = TRUE),
    n_in_assigned_group = sum(vel_group_man == case_vel_group, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    group_from_median = case_when(
      median_manual_vel < 3 ~ 1,
      median_manual_vel <= 8 ~ 2,
      median_manual_vel > 8 ~ 3
    ),
    agrees_with_median = group_from_median == as.numeric(case_vel_group)
  )

hfr_tdi_case_group_check

# Measurements by velocity group ------------------------------------------------

# Number of measurements, files and IDs by manually classified velocity group.
# vel_group_man is classified per measurement, so an ID can appear in more than one group and n_ids does not sum to the number of cases.
hfr_tdi_group_summary <- hfr_tdi_uploaded_labelled |>
  group_by(vel_group_man) |>
  summarise(
    n_measurements = n(),
    n_files = n_distinct(id, dicom_seq),
    n_ids = n_distinct(id),
    .groups = "drop"
  )

hfr_tdi_group_summary

# Frame rate by view, over uploaded files (from the per-file fps table in script 05)
hfr_tdi_fps_by_view <- hfr_tdi_uploaded_fps |>
  group_by(echo_view) |>
  summarise(
    n_files = n(),
    n_fps_missing = sum(fps_missing),
    fps_min = min(fps_tdi, na.rm = TRUE),
    fps_median = median(fps_tdi, na.rm = TRUE),
    fps_max = max(fps_tdi, na.rm = TRUE),
    .groups = "drop"
  )

hfr_tdi_fps_by_view

# Manual SW velocity (m/s) by event for uploaded files, per measurement location
hfr_tdi_velocity_summary <- hfr_tdi_uploaded_labelled |>
  group_by(sw_loc_mod, event) |>
  summarise(
    n_measurements = sum(!is.na(manual_vel)),
    median_manual_vel = median(manual_vel, na.rm = TRUE),
    min_manual_vel = min(manual_vel, na.rm = TRUE),
    max_manual_vel = max(manual_vel, na.rm = TRUE),
    .groups = "drop"
  )

hfr_tdi_velocity_summary

writexl::write_xlsx(
  list(
    "cases by velocity group" = hfr_tdi_cases_by_group,
    "case group check" = hfr_tdi_case_group_check,
    "measurements by vel group" = hfr_tdi_group_summary,
    "fps by view" = hfr_tdi_fps_by_view,
    "velocity summary" = hfr_tdi_velocity_summary
  ),
  path = here::here("output/tables", paste0(Sys.Date(), "_hfr-tdi_descriptive-summary.xlsx"))
)
