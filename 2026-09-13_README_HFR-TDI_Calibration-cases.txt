Prosessing notes for transfer of calibration HFR TDI cases to be used for validation of ShearQ app

---------------------------------------------------------------------------------------------------------------------------------------
Geneeral information:

Uploaded cases have been selected from project: Ultrasound for quantification of myocardial fibrosis in aortic stenosis (SAS-F-5)

Equipment used in the study: E95 scanner with SW version 204.100.1.Hercules build 15.
Cardiac views with HFR TDI data: PLAX, focused septum in A4C, standard A4C, A2C, and A3C. 
(There are also HFR plane wave and diverging wave 2D B-mode loops for all views, as well as HFR TDI-IQ)

Cases will be of aortic stenosis patient with either their native aortic valve, or a prosthetic aortic valve after having undergone aortic valve replacement.
There will also be cases of healthy controls.

When upload of cases are completed, I will try to also upload some meta data about each case, if needed.

All uploaded files will be HFR TDI echo acquisitions from PLAX view. Files will be placed in subfolders depending of post-MVC shear wave velocities in either low (<3 m/s), normal  (3-8 m/s), or high (> 8m/s) velocity range. As of 13.09.26, there is only one case, with velocities in the normal range.

(If it is of interest, I can also upload HFR TDI data for the other cardiav views mentioned).

Project folder structure:

HFR_TDI_calibration_cases_for_ShearQ/
├── Low_SW_velocities/
│   ├── Case-[...]_ID-[...]/
│   │   ├── Data file 1
│   │   └── Data file 2
│   └── Case-[...]_ID-[...]/
│       ├── Data file 1
│       └── Data file 2
├── Normal_SW_velocities/
│   └── Case-[...]_ID-[...]/
│       ├── Data file 1
│       └── Data file 2
├── High_SW_velocities/
│   └── Case-[...]_ID-[...]/
│       ├── Data file 1
│       └── Data file 2
└── 2026-09-13_README_HFR-TDI_Calibration-cases.txt

-------------------------------------------------------------------------------------------------------------------------------------


2026-09-13 work done ---------------------------------------------

1. Added case with ID 5883. Two files.