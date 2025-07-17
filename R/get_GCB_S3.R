# Calculating the observed NBP
# Observed NBP is here understood as the budget resdiual of GCB 2023: SLand(Obs.) = E(FF) + E(LUC) - dAtmo - SOcean

library(here)
library(readr)


gcb <- read_delim(here("../../data/GCP/Global_Carbon_Budget_2023v1_BudgetSheet_ready.csv"),
                                                            delim = ";", escape_double = FALSE, trim_ws = TRUE)

# limiting to analysis periode
gcb <- subset(gcb, Year >= 1982 & Year <= 2011)

# Getting SLand(OBS)

SLand_obs <- gcb$`fossil emissions excluding carbonation` + gcb$`land-use change emissions` - gcb$`atmospheric growth` - gcb$`ocean sink` - gcb$`cement carbonation sink`

NBP_obs <- data_frame("Year" = seq(from= 1982, to= 2011, by= 1), "NBP_obs"= SLand_obs)

write_csv(NBP_obs, here("data-raw/GCP_NBP_obs.csv"))
