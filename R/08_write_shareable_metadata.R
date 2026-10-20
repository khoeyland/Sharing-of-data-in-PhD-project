# Writing a de-identified meta data set for sharing on GitHub -----------------

# The repository must not contain screening numbers, examination dates/times, or the source Excel files (these are excluded in .gitignore). This script writes a reduced set of CSV files to shared_metadata/, which is tracked in git.
# Study IDs are kept, as they are part of the file names on the ftp server. Whether study IDs can be shared is decided by the project's data protection approval.

shared_dir <- here::here("shared_metadata")
dir.create(shared_dir, showWarnings = FALSE)

# Variables that must never be written to the shared files
identifying_vars <- c("screen_nr", "sheet_id", "sheet_name", "date", "time", "echo_date")

# File level: one row per uploaded HFR TDI file, with fps -----------------------
shared_files <- hfr_tdi_uploaded_fps |>
  left_join(
    hfr_tdi_calibr_cases |> distinct(id, case_vel_group),
    by = "id"
  ) |>
  select(id, dicom_seq, file_name, ftp_file_name, echo_view, fps_tdi,
         case_vel_group, file_comment = comment)

# Measurement level: shear wave measurements for uploaded files ----------------
shared_measurements <- hfr_tdi_calibr_cases |>
  filter(uploaded) |>
  select(id, dicom_seq, ftp_file_name, echo_view, sw_loc_mod, event, measurem_n,
         cycle_nr, manual_vel, regr_vel, regr_r_sq, sw_qual, sw_length,
         vel_group_man, vel_group_aut, case_vel_group, gr_case_nr, sw_other, comment)

# Codebook, without variables that are not shared ------------------------------
shared_codebook <- hfr_tdi_codebook |>
  filter(!variable_name %in% c(identifying_vars, "file_size_kb")) |>
  select(variable_name, value, value_label, variable_label, valid_range_format, comment)

# Safety check ------------------------------------------------------------------
stopifnot(
  !any(identifying_vars %in% names(shared_files)),
  !any(identifying_vars %in% names(shared_measurements)),
  !any(identifying_vars %in% shared_codebook$variable_name)
)

readr::write_csv(shared_files, file.path(shared_dir, "hfr_tdi_uploaded_files_fps.csv"))
readr::write_csv(shared_measurements, file.path(shared_dir, "hfr_tdi_sw_measurements.csv"))
readr::write_csv(shared_codebook, file.path(shared_dir, "hfr_tdi_codebook.csv"))
