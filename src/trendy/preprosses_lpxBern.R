library(dplyr)
library(ncdf4)

nc_gpp <- nc_open("/data_2/scratch/ttrinidad/trendy_v12/LPX-Bern_S3_gpp.nc")
nc_nbp <- nc_open("/data_2/scratch/ttrinidad/trendy_v12/LPX-Bern_S3_nbp.nc")

gpp <- ncvar_get( nc_gpp, varid="gpp" )
nbp <- ncvar_get( nc_nbp, varid="nbp" )

lon <- nc_gpp$dim$longitude$vals
lat <- nc_gpp$dim$latitude$vals

lon_dim <- ncdim_def(name = "lon", units = "degrees_east", vals = lon)
lat_dim <- ncdim_def(name = "lat", units = "degrees_north", vals = lat)

nc_close(nc_gpp)
nc_close(nc_nbp)

## get time from a different file
nc_time_ref <- nc_open("/data_2/scratch/ttrinidad/trendy_v12/CLM5.0_S3_gpp.nc")
time_units <- nc_time_ref$dim$time$units
time <- nc_time_ref$dim$time$vals
time_dim <- ncdim_def("time", "days since 1700-01-01 00:00:00", 1:length(time), unlim = TRUE)
nc_close(nc_time_ref)


gpp_var <- ncvar_def(name = "gpp", 
                     units = "kg m-2 s-1", 
                     dim = list(lon_dim,lat_dim, time_dim),
                     missval =  -99999,
                     longname = "Gross primary productivity")
nbp_var <- ncvar_def(name = "nbp", 
                     units = "kg m-2 s-1", 
                     dim = list(lon_dim,lat_dim, time_dim),
                     longname = "Net Biome Production")


nc_file_gpp <- nc_create("LPX_Bern_S3_gpp_NICE.nc", gpp_var)
nc_file_nbp <- nc_create("LPX_Bern_S3_nbp_NICE.nc", nbp_var)

ncvar_put(nc_file_gpp, gpp_var, gpp)
ncvar_put(nc_file_nbp, nbp_var, nbp)







gpp <- array( gpp, dim = c(360,180,1,length(time)))
nbp <- array( nbp, dim = c(360,180,1,length(time)))


cdf.write( gpp, "gpp",
           lon, lat,
           filenam = "/data_2/scratch/ttrinidad/trendy_v12/LPX-Bern_S3_gpp_NICE.nc",
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = time_units,
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_lpx.R"
)



cdf.write( nbp, "nbp",
           lon, lat,
           filnam = "/data_2/scratch/ttrinidad/trendy_v12/LPX-Bern_S3_nbp_NICE.nc",
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = time_units,
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_lpx.R"
)


# -----------------------------
b = c()
for(i in A){
  b = A.split
}