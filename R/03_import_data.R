
# Importing Excel source data from data/frozen folder ---------------------

# Snapshot to import from. Set snapshot_date before sourcing this script to use a specific snapshot (e.g. snapshot_date <- "2026-10-20"), otherwise the latest snapshot in data/frozen is used.
if (!exists("snapshot_date")) {
  snapshot_date <- max(list.dirs("data/frozen", recursive = FALSE, full.names = FALSE))
}
snapshot_dir <- file.path("data/frozen", snapshot_date)
stopifnot(dir.exists(snapshot_dir))

# Importing data on HFR TDI calibration cases derived from SAS-F_5 (long-term follow-up study). The data is in long format
hfr_tdi_calibr_cases_data_long <- read_excel(file.path(snapshot_dir, "2026-09-13_hfr_tdi_calibration-cases_derived-from-SAS-F-5.xlsx"), sheet = "HFR TDI calibration cases",
                              na = c("NA", "NAA", ""))

# Importing HFR TDI meta data (primary Excel source is named 2026-09-13_hfr-tdi_meta-data-for-calibration-cases.xlsx. The sheets are named "TDI flies" (this is a sheet template that need not be imported, it will be copied to other sheets that will be renamed to "[scr-nr]_ID]"). The sheets to be imported are all other sheets than, and the number of sheets to be imported will increase as new HFR TDI claibration cases have been analysed and prepared for import into R. The code is commented out at the moment, as I will need help to create code for importing sheets. For now, I have written sheet = ",,,", but this will have to be changed somehow.)
hfr_tdi_meta_data_path <- file.path(snapshot_dir, "2026-09-13_hfr-tdi_meta-data-for-calibration-cases.xlsx")

# All sheets except the template are case sheets, so new sheets are picked up automatically.
# Sheets differ somewhat in columns, bind_rows() fills missing columns with NA.
hfr_tdi_meta_data <- setdiff(excel_sheets(hfr_tdi_meta_data_path), "TDI files") |>
  lapply(\(sheet) {
    read_excel(hfr_tdi_meta_data_path, sheet = sheet, na = c("NA", "NAA", "")) |>
      # Drop unnamed stray columns (read as ...10 etc.)
      select(-matches("^\\.\\.\\.")) |>
      mutate(
        sheet_name = sheet,
        # comment is logical in sheets where it is empty
        across(any_of("comment"), as.character)
      )
  }) |>
  bind_rows() |>
  clean_names() |>
  separate_wider_delim(sheet_name, "_", names = c("screen_nr", "sheet_id"),
                       cols_remove = FALSE)

# Importing codebook for hfr tdi data
hfr_tdi_data_codebook <- read_excel(file.path(snapshot_dir, "2026-09-13_hfr-tdi-calibration-cases_codebook.xlsx"), sheet = "Calibration codebook tidy",
                               na = c("NA", "NAA", ""))

# HFR TDI files that were actually uploaded to the GEVU ftp server -------------
# ftp_file_name is filled in for all prepared files, also those not uploaded. Not-uploaded files are marked in the comment column
# ("File not uploaded to FTP server ..."), so these are excluded here.
hfr_tdi_uploaded <- hfr_tdi_meta_data |>
  filter(
    data_level == "TDI",
    !is.na(ftp_file_name),
    !grepl("not uploaded", comment, ignore.case = TRUE)
  )

# Frame rates (fps) from the long-term follow-up project --------------------
# Source: "Clinical echo data" sheet in 03_Five-year-fibrosis-data_v3 (frozen snapshot). One row per ID, fps per view.
# Uses the latest snapshot in that project, unless sasf5_snapshot_date is set before sourcing this script.
sasf5_project_dir <- "C:/Users/kjellhoy/OneDrive - NTNU/Documents/PhD/05_Analyse-i-R/03_Five-year-fibrosis-data_v3"
if (!exists("sasf5_snapshot_date")) {
  sasf5_snapshot_date <- max(list.dirs(file.path(sasf5_project_dir, "data/frozen"),
                                       recursive = FALSE, full.names = FALSE))
}
sasf5_echo_path <- file.path(
  "C:/Users/kjellhoy/OneDrive - NTNU/Documents/PhD/05_Analyse-i-R/03_Five-year-fibrosis-data_v3",
  "data/frozen", sasf5_snapshot_date, "2026-04-20_SAS-F-5_echo-and-cmr-data.xlsx"
)

hfr_tdi_fps_sasf5 <- read_excel(sasf5_echo_path, sheet = "Clinical echo data",
                                na = c("NA", "NAA", "")) |>
  select(id, starts_with("fps_tdi")) |>
  pivot_longer(-id, names_to = "fps_variable", values_to = "fps_tdi") |>
  mutate(
    echo_view = recode(
      fps_variable,
      fps_tdi_plax = "plax",
      fps_tdi_septum_focused_apical = "focused septum",
      fps_tdi_a4c = "apical 4 chamber",
      fps_tdi_a2c = "apical 2 chamber",
      fps_tdi_a3c = "apical 3 chamber",
      fps_tdi_atyp_plax = "atypical plax"
    )
  )
