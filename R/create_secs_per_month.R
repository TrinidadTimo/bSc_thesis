# Discuss with Beni: CARDAMOM
# length(time(ref)) = 1682
# cdo sinfo -> time 240 steps, no values on time steps displayed
# ncdump -h: "monthly time steps of days since 2003-01-01"

# Latest Approach:


library(terra)
library(lubridate)


# get directions
dirin <- "/data_2/scratch/ttrinidad/data/trendy/S3/raw/"
dirout <- "/data_2/scratch/ttrinidad/data/trendy/S3/secs_per_month/"

filnam <- paste0(dirin, "LPJ-GUESS_S3_gpp.nc")

# read monthly file
ref <- rast(filnam)
ref

length(time(ref))

tvec <- time(ref) # -> clean!

# if not available create it yourself
tvec_clean <- seq(from = ymd("1701-01-01"), by = "month", length.out = length(tvec)) # length.out = length_out

# Compute days per month for each date
days_per_month <- days_in_month(tvec) #choose tvec_clean or t_vec depending on validity of time axis (however create both anyways for below)!!

# Convert to seconds
seconds_per_month <- days_per_month * 86400  # 86400 seconds/day

# Create a single-layer raster with same spatial extent and resolution
template <- ref[[1]]
time_raster <- rast(rep(template, length(seconds_per_month)))
time_raster[] <- rep(seconds_per_month, each = ncell(template))

# Set time dimension
time(time_raster) <- tvec
names(time_raster) <- paste0("t", seq_along(tvec))

writeCDF(
  time_raster,
  file.path(dirout,"LPJ-GUESS_seconds_per_month.nc"),
  varname = "seconds_per_month",
  overwrite = TRUE
  )


