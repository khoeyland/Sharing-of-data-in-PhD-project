# Sharing-of-data-in-PhD-project

Sharing of cases for calibration of HFR TDI data analysis using ShearQ. HFR TDI echo files are shared with GE Vingmed Ultrasound (GEVU) through an FTP server, and this project holds the meta data and the R pipeline documenting what was shared.

The cases are selected from the long-term follow-up study (SAS-F-5): *Ultrasound for quantification of myocardial fibrosis in aortic stenosis*. Frame rates (fps) are taken from the `03_Five-year-fibrosis-data_v3` project.

Detailed processing notes (equipment, case selection, file naming, work log) are in [2026-09_README_HFR-TDI_Calibration-cases.txt](2026-09_README_HFR-TDI_Calibration-cases.txt). That file is also the README on the FTP server.

## Folder structure

```
.
├── R/                  Pipeline scripts (see below)
├── data/
│   ├── raw/            Excel files that are edited as new cases are prepared
│   └── frozen/<date>/  Timestamped snapshots with manifest.yml (used for analysis)
├── documentation/      Descriptive data on the HFR TDI acquisitions
├── output/
│   ├── tables/         Exported tables, e.g. fps for uploaded files
│   └── figures/
├── Data_handling_and_reporting_of_hfr_tdi_calibr_cases.qmd
└── 2026-09_README_HFR-TDI_Calibration-cases.txt
```

Source Excel files in `data/raw/`:

- `2026-09-13_hfr_tdi_calibration-cases_derived-from-SAS-F-5.xlsx`: shear wave measurements for the calibration cases (long format).
- `2026-09-13_hfr-tdi_meta-data-for-calibration-cases.xlsx`: one sheet per case, named `[screen_nr]_[ID]`, listing the HFR TDI files. The sheet `TDI files` is a template and is not imported.
- `2026-09-13_hfr-tdi-calibration-cases_codebook.xlsx`: codebook.

## Pipeline

| Script | Purpose |
|---|---|
| `00_load_packages.R` | Loads packages |
| `01_freeze_data.R` | `freeze_data()` copies the Excel files in `data/raw/` to `data/frozen/<today>/` with a manifest (SHA-256, file size) |
| `02_load_frozen_data.R` | `load_frozen(date)` reads a frozen snapshot |
| `03_import_data.R` | Imports the data. Collects all case sheets of the meta data file in `hfr_tdi_meta_data`, the files actually uploaded in `hfr_tdi_uploaded`, and fps in `hfr_tdi_fps_sasf5` |
| `04_data_cleaning.R` | Fixes variable classes and prepares the codebook (fills down variable names, cleans names to match the data) |
| `05_merging_of_data_frames.R` | Joins uploaded files with fps and exports `output/tables/<date>_hfr-tdi_fps-for-uploaded-files.xlsx`. Also creates `hfr_tdi_calibr_cases`, one row per shear wave measurement with file meta data, upload status and fps |
| `06_labelling_of_variables_and_values.R` | Labels variables and values from the codebook, plus manual labels for variables not in the codebook. Saves `data/clean/hfr_tdi_calibr_cases_labelled.rds` |
| `07_descriptive_statistics.R` | Summaries of cases by velocity group, fps by view and velocities |
| `08_write_shareable_metadata.R` | Writes de-identified CSV files (no screening numbers, dates or times) to `shared_metadata/`, the only data folder tracked in git |

### Running the pipeline

1. Update the Excel files in `data/raw/` when new cases have been prepared.
2. Run `source("R/00_load_packages.R")`, then `source("R/01_freeze_data.R")` and `freeze_data()`. This stops if a snapshot for today already exists.
3. Make sure the snapshot date in the paths in `R/03_import_data.R` matches the latest folder in `data/frozen/`.
4. Run scripts `R/03_import_data.R` to `R/08_write_shareable_metadata.R` in order.

The Quarto document `Data_handling_and_reporting_of_hfr_tdi_calibr_cases.qmd` runs the same steps.

### Notes

- `ftp_file_name` is filled in for all prepared files, also those not uploaded. Files not uploaded are marked in the `comment` column. Use `hfr_tdi_uploaded` for the files that were actually shared.
- The fps source (`03_Five-year-fibrosis-data_v3`) lies outside this repository, so the fps import in `03_import_data.R` can only be rerun on the project owner's machine. The fps per uploaded file is available in `shared_metadata/hfr_tdi_uploaded_files_fps.csv`.
