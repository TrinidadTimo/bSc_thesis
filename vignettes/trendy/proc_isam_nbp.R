library(ncdf4)
library(raster)

setwd("~")

# GPP:
nc <- nc_open("../../data_2/scratch/ttrinidad/data/trendy/raw/ISAM_S3_nbp.nc")

time_units <- nc$dim$time$units

time <- nc$dim$time$vals
nbp <- ncvar_get( nc, varid = "npp-rh+ld")
nc_close(nc)


# temporal aggregation:
## separate months and years axes
nbp <- array(nbp, dim = c(720, 360, 12, 323))

## create weightening matrix:
days_months <- c(31,28,31,30,31,30,31,31,30,31,30,31) #calendar with no leap given
seconds_months <- days_months*(24*3600)
seconds_matrix <- matrix(rep(seconds_months, times = 323), nrow = 12, ncol = 323)

## multiply weightening time matrix with nbp values
nbp_month <- nbp*(array(seconds_matrix, dim = c(720,360,12,323)))

## annual total nbp
nbp_annual <- apply(nbp_month, c(1,2,4), sum)


# detrending
nbp_annual_detr <- apply(nbp_annual, c(1,2), pracma::detrend, tt= "linear")

## adjust dimension order again:
dim(nbp_annual_detr)
nbp_annual_detr <- aperm(nbp_annual_detr, c(2,3,1))

# spatial aggregation
## area weightening matrix:
pseudo_raster <- raster::raster(nrows = 360, ncols = 720, xmn = -179.75, xmx = 179.75, ymn = -89.75, ymx = 89.75)
area_raster <- (raster::area(pseudo_raster))*1e6 # returning filed areas, connverted from km2 to m2
area_matrix <- t(matrix(raster::getValues(area_raster), nrow= 360, ncol = 720)) # Need to transpose here as lon, lat are flipped in the pseudo_raster
area_array <- array(rep(area_matrix, times = dim(nbp_annual_detr)[3]),
                    dim = dim(nbp_annual_detr))

nbp_annual_global <- apply(area_array*nbp_annual_detr, 3, sum, na.rm = TRUE) # in kg*C

# IAV of global annual NBP
nbp_iav <- sd(nbp_annual_global)
