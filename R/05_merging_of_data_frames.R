# Merging uploaded HFR TDI files with frame rate (fps) ---------------------

hfr_tdi_uploaded_fps <- hfr_tdi_uploaded |>
  left_join(hfr_tdi_fps_sasf5, by = c("id", "echo_view")) |>
  mutate(fps_missing = is.na(fps_tdi)) |>
  select(id, screen_nr, dicom_seq, file_name, ftp_file_name, echo_view,
         fps_tdi, fps_missing, comment) |>
  arrange(id, dicom_seq)

# Summary per ID and view
hfr_tdi_fps_summary <- hfr_tdi_uploaded_fps |>
  group_by(id, echo_view) |>
  summarise(n_files = n(), fps_tdi = first(fps_tdi), fps_missing = any(fps_missing),
            .groups = "drop")

writexl::write_xlsx(
  list(
    "fps per file" = hfr_tdi_uploaded_fps,
    "fps per ID and view" = hfr_tdi_fps_summary
  ),
  path = here::here("output/tables", paste0(Sys.Date(), "_hfr-tdi_fps-for-uploaded-files.xlsx"))
)


# Merging shear wave measurements with file meta data and fps ---------------

# One row per shear wave measurement (cycle), from hfr_tdi_calibr_cases_data_long.
# Meta data (view, ftp file name etc.) is joined by id + dicom_seq. Measurements for IDs without a meta data sheet get NA for the file variables.
# uploaded = TRUE if the file is in hfr_tdi_uploaded.

hfr_tdi_file_info <- hfr_tdi_meta_data |>
  select(id, dicom_seq, screen_nr, file_name, echo_view, data_level, image_nr,
         corresponding_hq_image, corresp_clin_echo_image, atyp_plax_coll,
         ftp_file_name, file_comment = comment)

hfr_tdi_calibr_cases <- hfr_tdi_calibr_cases_data_long |>
  left_join(hfr_tdi_file_info, by = c("id", "dicom_seq")) |>
  left_join(
    hfr_tdi_uploaded |> distinct(id, dicom_seq) |> mutate(uploaded = TRUE),
    by = c("id", "dicom_seq")
  ) |>
  left_join(hfr_tdi_fps_sasf5 |> select(id, echo_view, fps_tdi), by = c("id", "echo_view")) |>
  mutate(uploaded = coalesce(uploaded, FALSE))

stopifnot(nrow(hfr_tdi_calibr_cases) == nrow(hfr_tdi_calibr_cases_data_long))
