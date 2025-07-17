library(here)
library(pracma)
library(dplyr)
library(tibble)

GCP_NBP_obs <- read.csv(here("data-raw/GCP/GCP_NBP_obs.csv"))

GCP_NBP_obs_detr <- GCP_NBP_obs |> mutate(NBP_obs= detrend(NBP_obs, tt = 'linear', bp = NULL))

IAV_NBP_obs <- as.numeric(var(GCP_NBP_obs_detr$NBP_obs))

df <- tibble("Model" = "Global Carbon Budget residual SLand", "IAVAR Res. SLAND")

write.csv(df, file = here("data/iavar_gcb_sLand.csv") )
