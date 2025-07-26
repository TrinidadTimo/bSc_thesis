library(terra)
library(dplyr)
library(ggplot2)
library(here)

dirout <- here("../data/trendy/S3/")

# seconds per month
filnam <- paste0(dirout, "secs_per_month/LPJmL_seconds_per_month.nc")
rasta <- rast(filnam)

plot(rasta[[1]])
31*24*60*60

plot(rasta[[2]])
28*24*60*60

# annual total -----------------------------------------------------------------
filnam <- paste0(dirout, "ann/R/LPJmL_S3_gpp_ANN.nc")
rasta <- rast(filnam)
plot(rasta[[1]])

# global total -----------------------------------------------------------------
## GPP ---------
filnam <- paste0(dirout, "ann_glob_absolute/R/E3SM_S3_gpp_GLOB_ABSOLUTE.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, gpp)) +
  geom_line()

## NBP -------------
filnam <- paste0(dirout, "ann_glob_absolute/R/CABLE-POP_S3_nbp_GLOB_ABSOLUTE.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("nbp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, nbp)) +
  geom_line()

# detrended global total -----------------------------------------------------------------
## GPP ------------
par(mfrow = c(2, 2))
filnam <- paste0(dirout, "ann_glob_detr/R/CABLE-POP_S3_gpp_ANN_GLOB_DETR.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, gpp)) +
  geom_line()


filnam <- paste0(dirout, "ann_glob_detr/R/E3SM_S3_gpp_ANN_GLOB_DETR.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, gpp)) +
  geom_line()

## NBP ------------
library(patchwork)


filnam <- paste0(dirout,"ann_glob_detr/R/LPJ-GUESS_S3_nbp_ANN_GLOB_DETR.nc")
rasta <- rast(filnam)

`p_LPJ-GUESS` <- as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("nbp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, nbp)) +
  geom_line()

(p_CABLE | p_E3SM)/(p_LPJmL | `p_LPJ-GUESS`)

# variance of global total -----------------------------------------------------------------
## GPP ------------
filnam <- paste0(dirout, "iavar/R/E3SM_S3_gpp_VAR_GLOB.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp")

## NBP ------------
filnam <- paste0(dirout, "iavar/R/CABLE-POP_S3_nbp_VAR_GLOB.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("nbp")


