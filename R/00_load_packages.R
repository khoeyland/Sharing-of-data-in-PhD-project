# Loading packages relevant for the R project

library(dplyr)
library(tidyr)         # For separate_wider_delim() and pivoting
library(here)          # For project-relative paths
library(readr) 
library(readxl)        # For importing data from excel files
library(tidyxl)        # an alternative to library(readxl)
library(haven)         # For importing SPSS files (.sav)
library(lubridate)     # For handling of dates and time calculations
library(janitor)
library(sjlabelled)    # For labelling variables and values
library(labelled)      # For labelling
library(Hmisc)         # For labelling variables and values
library(vtable)        # For variable documentation
library(summarytools)  # For descriptive statistics
library(gtsummary)     # For statistics
library(vistime)       # For visualizing patient timelines
library(sjmisc)        # For descriptive statistics
library(skimr)         # For descriptive statistics
library(gridExtra)     # For converrting dataframes to tables into "graphical tables"
library(gtExtras)      # For making tables, it includes the gt package.
library(vistime)       # For visualizing patient timelines
library(ggplot2)       # For visualizations
library(scales)        # for label_number and pretty_breaks functions
library(quarto)        # For reporting in quarto format
library(report)        # For help to automate reports / rmarkdown
library(rstudioapi)
library(lintr)         # For code quality checks. Tells what is wrong, but does not fix it. Run lintr::lint("file.R")
library(styler)        # For code styling and linting. Use styler::style_active_file() to style the active file in RStudio. 
library(targets)       # For workflow management and reproducibility. Use targets::tar_make() to run the pipeline defined in _targets.R.
library(renv)          # For managing R package dependencies and ensuring reproducibility. Use renv::init(), renv::install(), renv::snapshot() and renv::restore() 
library(DT)            # DataTables package, used in quarto document in documentation folder, may have other uses in project also.
