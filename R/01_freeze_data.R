# -------------------------------------------------------------------
# 
# A freeze script
# 
# This script:
#   
#   Copies all Excel files from data_raw/
#   
#   Creates a timestamped snapshot folder
# 
#   Writes a provenance manifest
# 
#   Requires no {targets}
#   
# -------------------------------------------------------------------

library(fs)
library(digest)
library(yaml)

freeze_data <- function(
    raw_dir = "data/raw",
    frozen_dir = "data/frozen"
) {
  
  stopifnot(dir_exists(raw_dir))
  
  stamp <- Sys.Date()
  out_dir <- path(frozen_dir, as.character(stamp))
  
  if (dir_exists(out_dir)) {
    stop("Snapshot for this date already exists.")
  }
  
  dir_create(out_dir)
  
  files <- dir_ls(raw_dir, glob = "*.xlsx")
  
  manifest <- list(
    frozen_at = Sys.time(),
    files = list()
  )
  
  for (f in files) {
    file_copy(f, out_dir)
    
    manifest$files[[path_file(f)]] <- list(
      sha256 = digest(file = f, algo = "sha256"),
      size = file_info(f)$size
    )
  }
  
  write_yaml(
    manifest,
    path(out_dir, "manifest.yml")
  )
  
  message("Data frozen to: ", out_dir)
}
