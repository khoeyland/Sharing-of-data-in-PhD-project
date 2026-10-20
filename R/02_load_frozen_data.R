# Loading frozen data into R

library(readxl)
library(here)

load_frozen <- function(snapshot_date) {
  
  snap_dir <- here("data/frozen", snapshot_date)
  
  stopifnot(dir.exists(snap_dir))
  
  list(
    hfr_tdi_calibr_cases = read_xlsx(file.path(snap_dir, "2026-09-13_hfr_tdi_calibration-cases_derived-from-SAS-F-5.xlsx")),
    hfr_tdi_meta_data    = read_xlsx(file.path(snap_dir, "2026-09-13_hfr-tdi_meta-data-for-calibration-cases.xlsx")),
    hfr_tdi_calibr_codebook = read_xlsx(file.path(snap_dir, "2026-09-13_hfr-tdi-calibration-cases_codebook.xlsx"))
    #metadata  = read_xlsx(file.path(snap_dir, "....xlsx"))
  )
}