Prosessing notes for transfer of calibration HFR TDI cases to be used for validation of ShearQ app

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------

Geneeral information:

Uploaded cases have been selected from project: Ultrasound for quantification of myocardial fibrosis in aortic stenosis (SAS-F-5)

Equipment used in the study: E95 scanner with SW version 204.100.1.Hercules build 15.
Cardiac views with HFR TDI data: PLAX, focused septum in A4C, standard A4C, A2C, and A3C. (Files from focused septum in A4C has not been uploaded here)
(There are also HFR plane wave and diverging wave 2D B-mode loops for all views, as well as HFR TDI-IQ)

HFR TDI loops have been acquired prospectively.

Cases will be of aortic stenosis patient with either their native aortic valve, or a prosthetic aortic valve after having undergone aortic valve replacement.
There will also be cases of healthy controls.

When upload of cases are completed, I will try to also upload some meta data about each case, if needed.
I have created a GitHub repository for the sharing of calibration cases, to support collaboration:

https://github.com/khoeyland/Sharing-of-data-in-PhD-project.git 

All uploaded files will be HFR TDI echo acquisitions from PLAX view and apical views (except focused septum in A4C). Files will be placed in subfolders depending on post-MVC shear wave velocities in either low (<3 m/s), normal  (3-8 m/s), or high (> 8m/s) velocity range. Decisions for post-MVC SW velocity range have been done based on manually measured velocities in the anteroseptal wall in PLAX view, which I assume is the primary cardiac event and myocardial wall of most interest. In some cases, the automatic measurement differs significantly and would in some cases reclassify velocity range status - if decision is instead based on the regression line. There will usually be two files per case, both from same PLAX or apical view, and acquired right after one another, so one can assume stable hemodynamics between repeated HFR acquisitions. In some cases, there will only be one file uploaded per case per cardiac view, most often because of poor shear wave quality in files not decided to upload. 


Project folder structure on ftp server:

HFR_TDI_calibration_cases_for_ShearQ/
├── 01_Low_SW_velocities/
│   ├── Case-[...]_ID-[...]/
│   │   ├── Data file 1
│   │   └── Data file 2
│   └── Case-[...]_ID-[...]/
│       ├── Data file 1
│       └── Data file 2
├── 02_Normal_SW_velocities/
│   └── Case-[...]_ID-[...]/
│       ├── Data file 1
│       └── Data file 2
├── 03_High_SW_velocities/
│   └── Case-[...]_ID-[...]/
│       ├── Data file 1
│       └── Data file 2
└── 2026-09_README_HFR-TDI_Calibration-cases.txt


Other notes:

Atypical PLAX files:
Uploaded cases include standard PLAX views only, with two exceptions: IDs 34929 and 47205 also have HFR TDI files acquired in an atypical PLAX position (one intercostal space lower than standard PLAX, making the interventricular septum appear more oblique). These files are named [original file name]_[ID]_PLAX_3 and _PLAX_4, while the standard PLAX files for the same IDs are named _PLAX_1 and _PLAX_2.

Definition of "uploaded file":
A file counts as uploaded if it is an HFR TDI file (not TDI-IQ) that has been transferred to the GEVU ftp server. In the meta data Excel file (one sheet per case), the column ftp_file_name is filled in for all prepared files, also for files that were NOT uploaded. Files not uploaded are marked in the comment column ("File not uploaded to FTP server ..."), and should be excluded. Focused septum A4C files and TDI-IQ files are not uploaded.
In the R project, uploaded files are collected in the data frame hfr_tdi_uploaded (R/03_import_data.R).

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------


2026-09-13 work done ---------------------------------------------

1. Added case with ID 5883 to normal velocity group. Two files uploaded.


2026-09-14 work done ---------------------------------------------

1. Added case with ID 13151 to normal velocity group. One file uploaded, one file with poor SW quality across most cycles and not uploaded.
2. Added case with ID 13633 to normal velocity group.


2026-09-18 work done ---------------------------------------------

1. Added case with ID 15587 to high velocity group. Suboptimal quality of shear waves.
2. Added case with ID 37725 to high velocity group. Suboptimal quality of shear waves.
3. Added case with ID 21443 to normal velocity group.
4. Added case with ID 27190 to normal velocity group. Suboptimal quality of shear waves.
5. Added case with ID 28734 to normal velocity group.


2026-09-19 work done ---------------------------------------------

1. Uploaded HFR TDI files for A4C, A2C and A3C for all uploaded cases. File names changed to: [original file name]_[ID]_[Cardiac view]_[sequence number].
    - I have analyzed only the HFR TDI files in PLAX, and the classification low, normal and high velocity is based on the PLAX view. 
    - I will analyze the A4C, A2C and A3C if capacity later, if apical views are to be included in calibration for ShearQ app.
2. Added case with ID 30404 to normal velocity group.
3. Added case with ID 34929 to low velocity group.


2026-09-26 work done ---------------------------------------------

1. Added case with ID 47205 to normal velocity group. Suboptimal quality of shear waves.


2026-09-27 work done ---------------------------------------------

1. Added case with ID 62875 to normal velocity group.

------------------------------------------------------------------
------------------------------------------------------------------


Status 27.09.26: 12 cases uploaded
- 2 cases in low-velocity group
- 8 cases in normal velocity group
- 2 cases in high velocity group

If more cases are needed, I can prepare more.