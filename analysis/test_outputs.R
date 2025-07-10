library(terra)
library(dplyr)
library(ggplot2)

dirout <- "/data_2/scratch/ttrinidad/data/trendy/"

# seconds per month
filnam <- paste0(dirout, "secs_per_month/CABLE-POP_seconds_per_month.nc")
rasta <- rast(filnam)

plot(rasta[[1]])
31*24*60*60

plot(rasta[[2]])
28*24*60*60

# annual total -----------------------------------------------------------------
filnam <- paste0(dirout, "ann/R/CABLE-POP_S3_gpp_ANN.nc")
rasta <- rast(filnam)
plot(rasta[[1]])

# global total -----------------------------------------------------------------
## GPP ---------
filnam <- paste0(dirout, "ann_glob_absolute/R/CABLE-POP_S3_gpp_GLOB_ABSOLUTE.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, gpp)) +
  geom_line()

## NBP -------------
filnam <- paste0(dirout, "CABLE-POP_S3_nbp_GLOB.nc")
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
filnam <- paste0(dirout, "CABLE-POP_S3_gpp_DETR_GLOB.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, gpp)) +
  geom_line()


## NBP ------------
filnam <- paste0(dirout, "CABLE-POP_S3_nbp_DETR_GLOB.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp") |>
  mutate(time = time(rasta)) |>
  ggplot(aes(time, gpp)) +
  geom_line()


# variance of global total -----------------------------------------------------------------
## GPP ------------
filnam <- paste0(dirout, "CABLE-POP_S3_gpp_VAR_GLOB.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("gpp")

## NBP ------------
filnam <- paste0(dirout, "CABLE-POP_S3_nbp_VAR_GLOB.nc")
rasta <- rast(filnam)

as.data.frame(rasta) |>
  t() |>
  as_tibble() |>
  setNames("nbp")
