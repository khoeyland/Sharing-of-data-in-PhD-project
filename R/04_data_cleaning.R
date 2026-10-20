# Cleaning of imported data ------------------------------------------------

# Class of variables ---------------------------------------------------------

# comment is read as logical when the column is empty (all NA), but is free text when used
hfr_tdi_calibr_cases_data_long <- hfr_tdi_calibr_cases_data_long |>
  mutate(comment = as.character(comment))


# Codebook ---------------------------------------------------------------------

# The variable_name column is sparsely filled in Excel (the name only appears on the first row of each group of values). fill() recovers the full mapping.
# make_clean_names() is applied to UNIQUE names only, to avoid the deduplication side-effect (_2, _3 suffixes) that would occur on a column with repeated values.
# This also turns e.g. "hfr_tdi-iq" into "hfr_tdi_iq" and "gr-case_nr" into "gr_case_nr", which are the names used in the data frames.

hfr_tdi_codebook <- hfr_tdi_data_codebook |>
  clean_names() |>
  fill(variable_name)

codebook_raw_names <- unique(na.omit(hfr_tdi_codebook$variable_name))
codebook_name_map <- setNames(make_clean_names(codebook_raw_names), codebook_raw_names)

hfr_tdi_codebook <- hfr_tdi_codebook |>
  mutate(
    variable_name_raw = variable_name,
    variable_name = unname(codebook_name_map[variable_name_raw])
  )
