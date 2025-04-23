library(ncdf4)
library(raster)

setwd("~")


# GPP:
nc <- nc_open("../../data_2/scratch/ttrinidad/data/trendy/raw/CARDAMOM_S3_gpp.nc")

time_units <- nc$dim$time$units
gpp_unit <- nc$var$gpp$units
time <- nc$dim$time$vals
gpp <- ncvar_get( nc, varid = "gpp")
nc_close(nc)


# temporal aggregation
## separate months and years axes
gpp <- array(gpp, dim = c(360, 180, 12, 20)) #Structure: lon, lat, months, years

## create weightening matrix:
days_months <- c(31,28,31,30,31,30,31,31,30,31,30,31) #calendar with no leap given
seconds_months <- days_months*(24*3600)
seconds_matrix <- matrix(rep(seconds_months, times = 20), nrow = 12, ncol = 20)

gpp_month <- gpp*array(seconds_matrix, dim = c(360,180,12,20))

## annual total GPP
gpp_annual <- apply(gpp_month, c(1,2,4), sum)

# detrending
gpp_annual_detr <- apply(gpp_annual, c(1,2), pracma::detrend, tt= "linear")

## adjust dimension order again:
dim(gpp_annual_detr)
gpp_annual_detr <- aperm(gpp_annual_detr, c(2,3,1))

# spatial aggregation
## Area weightening matrix:
pseudo_raster <- raster::raster(nrows = 180, ncols = 360, xmn = -179.5, xmx = 179.5, ymn = -89.5, ymx = 89.5)
area_raster <- (raster::area(pseudo_raster))*1e6 # returning filed areas, connverted from km2 to m2
area_matrix <- t(matrix(raster::getValues(area_raster), nrow= 180, ncol = 360)) # Need to transpose here as lon, lat are flipped in the pseudo_raster
area_array <- array(rep(area_matrix, times = dim(gpp_annual_detr)[3]),
                    dim = dim(gpp_annual_detr))

gpp_annual_global <- apply(area_array*gpp_annual_detr, 3, sum, na.rm = TRUE) # in kg*C

cardamom_gpp_annual_global <- gpp_annual_global*1e-12 #in Pg*C

# IAV of global annual GPP
cardamom_gpp_iav <- sd(cardamom_gpp_annual_global)



#NBP:

nc <- nc_open("../../data_2/scratch/ttrinidad/data/trendy/raw/CARDAMOM_S3_nbp.nc")

nbp_unit <- nc$var$nbp$units
nbp <- ncvar_get( nc, varid = "nbp")
nc_close(nc)

# temporal aggregation:
## separate months and years axes
nbp <- array(nbp, dim = c(360, 180, 12, 20))

## multiply weightening time matrix with nbp values
nbp_month <- nbp*(array(seconds_matrix, dim = c(360,180,12,20)))

## annual total nbp
nbp_annual <- apply(nbp_month, c(1,2,4), sum)


# detrending
nbp_annual_detr <- apply(nbp_annual, c(1,2), pracma::detrend, tt= "linear")

## adjust dimension order again:
dim(nbp_annual_detr)
nbp_annual_detr <- aperm(nbp_annual_detr, c(2,3,1))

# spatial aggregation:
nbp_annual_global <- apply(area_array*nbp_annual_detr, 3, sum, na.rm = TRUE) # in kg*C

cardamom_nbp_annual_global <- nbp_annual_global*1e-12 #in Pg*C

# IAV of global annual NBP
cardamom_nbp_iav <- sd(cardamom_nbp_annual_global)
