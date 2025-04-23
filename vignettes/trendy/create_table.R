library(ncdf4)
library(tibble)

setwd("~/../../data_2/scratch/ttrinidad/data/trendy/iasd/")

iasd_trendy <- data.frame(model <- NA, gpp <- NA, nbp <- NA)

# CABLE-POP
## gpp:
nc <- nc_open("CABLE-POP_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("CABLE-POP_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[1,] <- c("CABLE-POP", gpp, nbp)


# CARDAMOM
iasd_trendy[2,] <- c("CARDAMOM", cardamom_gpp_iav, cardamom_nbp_iav)


# CLASSIC
## gpp:
nc <- nc_open("CLASSIC_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("CLASSIC_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[3,] <- c("CLASSIC", gpp, nbp)


# CLM

iasd_trendy[4,] <- c("CLM5.0", clm_gpp_iav, clm_nbp_iav)

# DLEM
iasd_trendy[5,] <- c("DLEM", dlem_gpp_iav, dlem_nbp_iav)

# EDv3
## gpp:
nc <- nc_open("EDv3_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("EDv3_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[6,] <- c("EDv3", gpp, nbp)

# E3SM
## gpp:
nc <- nc_open("E3SM_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("E3SM_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[7,] <- c("E3SM", gpp, nbp)


# IBIS
iasd_trendy[8,] <- c("IBIS", ibis_gpp_iav, ibis_nbp_iav)


# ISAM
## gpp:
nc <- nc_open("ISAM_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

iasd_trendy[9,] <- c("IBIS", gpp, isam_nbp_iav)


# ISBA-CTRIB
## gpp:
nc <- nc_open("ISBA-CTRIP_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("ISBA-CTRIP_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[10,] <- c("ISBA-CTRIP", gpp, nbp)

# JSBACH
## gpp:
nc <- nc_open("JSBACH_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("JSBACH_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[11,] <- c("JSBACH", gpp, nbp)

# JULES
## gpp:
nc <- nc_open("JULES_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("JULES_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[12,] <- c("JULES", gpp, nbp)


# LPJ-GUESS
## gpp:
nc <- nc_open("LPJ-GUESS_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("LPJ-GUESS_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[13,] <- c("LPJ-GUESS", gpp, nbp)

# LPJml
## gpp:
nc <- nc_open("LPJmL_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("LPJmL_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[14,] <- c("LPJmL", gpp, nbp)


# LPJwsl
## gpp:
nc <- nc_open("LPJwsl_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("LPJwsl_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[15,] <- c("LPJwsl", gpp, nbp)

# OCN
## gpp:
nc <- nc_open("OCN_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("OCN_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[16,] <- c("OCN", gpp, nbp)


# ORCHIDEE
## gpp:
nc <- nc_open("ORCHIDEE_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("ORCHIDEE_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[17,] <- c("ORCHIDEE", gpp, nbp)


# VISIT
## gpp:
nc <- nc_open("VISIT_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("VISIT_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[18,] <- c("VISIT", gpp, nbp)


# LPX-Bern
iasd_trendy[19,] <- c("LPX-Bern", lpx_gpp_iav, lpx_nbp_iav)


# SDGVM
## gpp:
nc <- nc_open("SDGVM_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("SDGVM_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbpAnnual")
nc_close(nc)

iasd_trendy[20,] <- c("SDGVM", gpp, nbp)



# Cleaning:
iasd_trendy$gpp <- as.numeric(iasd_trendy$gpp)
iasd_trendy$nbp <- as.numeric(iasd_trendy$nbp)


# Plot:
mod <- lm(iasd_trendy$nbp ~ iasd_trendy$gpp)

plot(y = iasd_trendy$nbp, x= iasd_trendy$gpp, xlab= "GPP", ylab = "NBP", main = "Interannual variability TRENDYv12 Models")
abline(mod)



