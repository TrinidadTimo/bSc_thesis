library(ncdf4)
library(raster)


# GPP:
nc <- nc_open("~/../../data_2/scratch/ttrinidad/data/trendy/raw/LPJ-GUESS_S3_gpp.nc")
time_units <- nc$dim$time$units
gpp <- ncvar_get( nc, varid = "gpp")
nc_close(nc)

# temporal aggregation:
## separate months and years axes
gpp <- array(gpp, dim = c(720, 360, 12, 323))

## create weightening matrix:
days_months <- c(31,28,31,30,31,30,31,31,30,31,30,31) #calendar with no leap given
seconds_months <- days_months*(24*3600)
seconds_matrix <- matrix(rep(seconds_months, times = 323), nrow = 12, ncol = 323)

## multiply weightening time matrix with nbp values
gpp_month <- gpp*(array(seconds_matrix, dim = c(720,360,12,323)))

## annual total GPP
gpp_annual <- apply(gpp_month, c(1,2,4), sum)


# detrending
gpp_annual_detr <- apply(gpp_annual, c(1,2), pracma::detrend, tt= "linear")

## adjust dimension order again:
dim(gpp_annual_detr)
gpp_annual_detr <- aperm(gpp_annual_detr, c(2,3,1))

# spatial aggregation
## area weightening matrix:
pseudo_raster <- raster::raster(nrows = 360, ncols = 720, xmn = -179.75, xmx = 179.75, ymn = -89.75, ymx = 89.75)
area_raster <- (raster::area(pseudo_raster))*1e6 # returning filed areas, connverted from km2 to m2
area_matrix <- t(matrix(raster::getValues(area_raster), nrow= 360, ncol = 720)) # Need to transpose here as lon, lat are flipped in the pseudo_raster
area_array <- array(rep(area_matrix, times = dim(gpp_annual_detr)[3]),
                    dim = dim(gpp_annual_detr))

gpp_annual_global <- apply(area_array*gpp_annual_detr, 3, sum, na.rm = TRUE) # in kg*C

lpjGuess_gpp_annual_global <- gpp_annual_global*1e-12 #in Pg*C

# IAV of global annual GPP
lpjGuess_gpp_iav <- sd(lpjGuess_gpp_annual_global)




#NBP:

nc <- nc_open("~/../../data_2/scratch/ttrinidad/data/trendy/raw/LPJ-GUESS_S3_nbp.nc")

nbp_unit <- nc$var$nbp$units
nbp <- ncvar_get( nc, varid = "nbp")
nc_close(nc)

# temporal aggregation:
## separate months and years axes
nbp_1 <- nbp
nbp <- array(nbp, dim = c(720, 360, 12, 323))

## multiply weightening time matrix with nbp values
nbp_month <- nbp*(array(seconds_matrix, dim = c(720,360,12,323)))

## annual total nbp
nbp_annual <- apply(nbp_month, c(1,2,4), sum)
nbp_annual_1 <- nbp_1*array(365*3600*24, dim= c(720,360, 323))

# detrending
nbp_annual_detr <- apply(nbp_annual, c(1,2), pracma::detrend, tt= "linear")
nbp_annual_detr_1 <- apply(nbp_annual_1, c(1,2), pracma::detrend, tt= "linear")

## adjust dimension order again:
dim(nbp_annual_detr)
nbp_annual_detr <- aperm(nbp_annual_detr, c(2,3,1))
nbp_annual_detr_1 <- aperm(nbp_annual_detr_1, c(2,3,1))
# spatial aggregation:
nbp_annual_global <- apply(area_array*nbp_annual_detr, 3, sum, na.rm = TRUE) # in kg*C
nbp_annual_global_1 <- apply(area_array*nbp_annual_detr_1, 3, sum, na.rm = TRUE)

lpjGuess_nbp_annual_global <- nbp_annual_global*1e-12 #in Pg*C
lpjGuess_nbp_annual_global_1 <- nbp_annual_global_1*1e-12 #in Pg*C

# IAV of global annual NBP
lpjGuess_nbp_iav <- sd(lpjGuess_nbp_annual_global)
lpjGuess_nbp_iav_1 <- sd(lpjGuess_nbp_annual_global_1)

