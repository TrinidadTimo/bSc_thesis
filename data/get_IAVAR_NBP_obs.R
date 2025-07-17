library(here)
library(pracma)
library(dplyr)

GCP_NBP_obs <- read.csv(here("data-raw/GCP/GCP_NBP_obs.csv"))

GCP_NBP_obs_detr <- GCP_NBP_obs |> mutate(NBP_obs= detrend(NBP_obs, tt = 'linear', bp = NULL))

IAV_NBP_obs <- as.numeric(var(GCP_NBP_obs_detr$NBP_obs))

write.csv(paste(IAV_NBP_obs, "GCB Res.", sep= ","), file = here("data/IAVAR_NBP_obs.csv") )
