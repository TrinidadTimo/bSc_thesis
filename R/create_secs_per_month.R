library(terra)
library(lubridate)

dirin <- "/data_2/scratch/ttrinidad/data/trendy/raw/"
dirout <- "/data_2/scratch/bstocker/data/trendy/"

filnam <- paste0(dirin, "CABLE-POP_S3_gpp.nc")

# read monthly file
ref <- rast(filnam)

# get time vector from netcdf file
tvec <- time(ref)

# if not available create it yourself
tvec_clean <- seq(from = ymd("1701-01-01"), by = "month", length.out = length(tvec))

# Compute days per month for each date
days_per_month <- days_in_month(tvec)

# Convert to seconds
seconds_per_month <- days_per_month * 86400  # 86400 seconds/day

# Create a single-layer raster with same spatial extent and resolution
template <- ref[[1]]
time_raster <- rast(rep(template, length(seconds_per_month)))
time_raster[] <- rep(seconds_per_month, each = ncell(template))

# Set time dimension
time(time_raster) <- tvec_clean
names(time_raster) <- paste0("t", seq_along(tvec_clean))

writeCDF(
  time_raster,
  paste0(dirout, "seconds_per_month.nc"),
  varname = "seconds_per_month",
  overwrite = TRUE
  )
