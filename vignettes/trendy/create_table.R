library(ncdf4)
library(tibble)
library(ggplot2)

setwd("~/../../data_2/scratch/ttrinidad/data/trendy/iasd/")

iasd_trendy <- data.frame(model <- NA, gpp <- NA, nbp <- NA)

# CABLE-POP
##CDO
### gpp:
nc <- nc_open("CABLE-POP_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("CABLE-POP_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[1,] <- c("CABLE-POP", gpp, nbp)

##R
iasd_trendy[31,] <- c("CABLE-POP", cablePop_gpp_iav, cablePop_nbp_iav, "R")



# CARDAMOM
iasd_trendy[2,] <- c("CARDAMOM", cardamom_gpp_iav, cardamom_nbp_iav)


# CLASSIC
## CDO:
### gpp:
nc <- nc_open("CLASSIC_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("CLASSIC_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[3,] <- c("CLASSIC", gpp, nbp)

## R:
iasd_trendy[25,] <- c("CLASSIC", classic_gpp_iav, classic_nbp_iav, "R")



# CLM

iasd_trendy[4,] <- c("CLM5.0", clm_gpp_iav, clm_nbp_iav)

# DLEM
iasd_trendy[5,] <- c("DLEM", dlem_gpp_iav, dlem_nbp_iav)

# EDv3
## CDO
### gpp:
nc <- nc_open("EDv3_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("EDv3_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[6,] <- c("EDv3", gpp, nbp)

## R
iasd_trendy[33,] <- c("EDv3", edv3_gpp_iav, edv3_nbp_iav, "R")


# E3SM
## CDO
### gpp:
nc <- nc_open("E3SM_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("E3SM_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[7,] <- c("E3SM", gpp, nbp)

## R
iasd_trendy[29,] <- c("E3SM", e3sm_gpp_iav, e3sm_nbp_iav, "R")



# IBIS
iasd_trendy[8,] <- c("IBIS", ibis_gpp_iav, ibis_nbp_iav)


# ISAM
## gpp:
nc <- nc_open("ISAM_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

iasd_trendy[9,] <- c("ISAM", gpp, isam_nbp_iav)


# ISBA-CTRIB
iasd_trendy[10,] <- c("ISBA-CTRIP", isbaCtrip_gpp_iav, isbaCtrip_nbp_iav, "R")

# JSBACH
## CDO
### gpp:
nc <- nc_open("JSBACH_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

###nbp:
nc <- nc_open("JSBACH_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[11,] <- c("JSBACH", gpp, nbp)

## R
iasd_trendy[28,] <- c("JSBACH", jsbach_gpp_iav, jsbach_nbp_iav, "R")


# JULES
## CDO:
### gpp:
nc <- nc_open("JULES_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("JULES_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[12,] <- c("JULES", gpp, nbp)

## R
iasd_trendy[30,] <- c("JULES", jules_gpp_iav, jules_nbp_iav, "R")



# LPJ-GUESS
## CDO:
### gpp:
nc <- nc_open("LPJ-GUESS_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("LPJ-GUESS_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[13,] <- c("LPJ-GUESS", gpp, nbp)

## R
iasd_trendy[21,] <- c("LPJ-GUESS", lpjGuess_gpp_iav, lpjGuess_nbp_iav_1, "R")

# LPJmL
# CDO:
## gpp:
nc <- nc_open("LPJmL_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

## nbp:
nc <- nc_open("LPJmL_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[14,] <- c("LPJmL", gpp, nbp)

# R:
iasd_trendy[22,] <- c("LPJmL", lpjml_gpp_iav, lpjml_nbp_iav, "R")

# LPJwsl
## CDO:
### gpp:
nc <- nc_open("LPJwsl_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("LPJwsl_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[15,] <- c("LPJwsl", gpp, nbp)

## R:
iasd_trendy[26,] <- c("LPJwsl", lpjwsl_gpp_iav, lpjwsl_nbp_iav, "R")



# OCN
## CDO
### gpp:
nc <- nc_open("OCN_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("OCN_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[16,] <- c("OCN", gpp, nbp)

## R
iasd_trendy[32,] <- c("OCN", ocn_gpp_iav, ocn_nbp_iav, "R")


# ORCHIDEE
## CDO:
### gpp:
nc <- nc_open("ORCHIDEE_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("ORCHIDEE_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[17,] <- c("ORCHIDEE", gpp, nbp)

## R
iasd_trendy[23,] <- c("ORCHIDEE", orchidee_gpp_iav, orchidee_nbp_iav, "R")


# VISIT
## CDO:
### gpp:
nc <- nc_open("VISIT_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("VISIT_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbp")
nc_close(nc)

iasd_trendy[18,] <- c("VISIT", gpp, nbp)

## R:

iasd_trendy[18,] <- c("VISIT", gpp, nbp)


# LPX-Bern
iasd_trendy[27,] <- c("VISIT", visit_gpp_iav, visit_nbp_iav, "R")


# SDGVM
## CDO:
### gpp:
nc <- nc_open("SDGVM_S3_gpp_ANN_GLOB_IASD.nc")
gpp <- ncvar_get(nc, varid = "gpp")
nc_close(nc)

### nbp:
nc <- nc_open("SDGVM_S3_nbp_ANN_GLOB_IASD.nc")
nbp <- ncvar_get(nc, varid = "nbpAnnual")
nc_close(nc)

iasd_trendy[20,] <- c("SDGVM", gpp, nbp)

## R:
iasd_trendy[24,] <- c("SDGVM", sdgvm_gpp_iav, sdgvm_nbp_iav, "R")


# Cleaning:
iasd_trendy$gpp <- as.numeric(iasd_trendy$gpp)
iasd_trendy$nbp <- as.numeric(iasd_trendy$nbp)

## Adding Column indicating manual/cdo processing for separate plotting.
iasd_trendy[,4] <- rep(0, nrow(iasd_trendy))
colnames(iasd_trendy)[4] <- "R/CDO"
iasd_trendy[c(2,4,5,8,9,10,19),4] <- 1
iasd_trendy$`R/CDO`<- factanal(iasd_trendy$`R/CDO`, levels= c(0,1), labels = c("CDO", "R"))


# Plot:
par(mfrow = c(1, 1))
mod <- lm(nbp ~ gpp, data= subset(iasd_trendy, `R/CDO` == "R"))

plot(y = iasd_trendy$nbp[iasd_trendy$`R/CDO`== "R"], x= iasd_trendy$gpp[iasd_trendy$`R/CDO` == "R"], xlab= "GPP", ylab = "NBP", main = "Interannual Variability TRENDYv12 Models")
abline(mod)
legend("bottomright", legend = paste("RSQ =", round(summary(mod)$r.squared,2), collapse= " "), bty = "n")

ggplot(data= iasd_trendy, aes(x= gpp, y= nbp, colour = `R/CDO`, label = model)) +
  geom_point() +
  scale_x_continuous(labels = scales::number_format(accuracy = 0.1)) +
  geom_text(size = 0.5)


plot(y = iasd_trendy$nbp[iasd_trendy$`R/CDO`== "R"], x= iasd_trendy$gpp[iasd_trendy$`R/CDO` == "R"], xlab= "GPP", ylab = "NBP", main = "Interannual Variability TRENDYv12 Models")
abline(mod)
legend("bottomright", legend = paste("RSQ =", round(summary(mod)$r.squared,2), collapse= " "), bty = "n")


