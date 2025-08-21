# Load libraries
library(here)

### Defining Overall Table Storing Analysis Data
df_analysis_data_gpp <- tibble("Statistic" =  c("Median Slope", "IQR Median", "Trend IQR", "Signif. Trend IQR"), "TRENDY" = as.double(NA), "CMIP" = as.double(NA), "MsTMIP SG1" = as.double(NA), "MsTMIP SG3" = as.double(NA))
df_analysis_data_nbp <- tibble("Statistic" =  c("Median Slope", "IQR Median", "Trend IQR", "Signif. Trend IQR"), "TRENDY" = as.double(NA), "CMIP" = as.double(NA), "MsTMIP SG1" = as.double(NA), "MsTMIP SG3" = as.double(NA))

### TRENDY ---------------------------------------------
## GPP
# Read Data:
trendy_gpp <- read_csv(here("data/trendy_S3_gpp_glob.csv"))

# Ensemble Statistics:
sum_stat_trendy_gpp <- tibble("year" <- 1982:2011)

sum_stat_trendy_gpp <- trendy_gpp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_gpp$TRENDY[1] <- summary(lm(med ~ year, data= sum_stat_trendy_gpp))$coefficient[2,1]

# IQR over time:
sum_stat_trendy_gpp <- sum_stat_trendy_gpp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_gpp$TRENDY[2] <- median(sum_stat_trendy_gpp$IQR)
df_analysis_data_gpp$TRENDY[3] <- summary(lm(IQR ~year, data= sum_stat_trendy_gpp))$coefficient[2,1]
df_analysis_data_gpp$TRENDY[4] <- summary(lm(IQR ~year, data= sum_stat_trendy_gpp))$coefficient[2,4]

plot(IQR ~ year, data= sum_stat_trendy_gpp, type= "l")
abline(lm(IQR ~year, data= sum_stat_trendy_gpp))

## NBP
# Read Data:
trendy_nbp <- read_csv(here("data/trendy_S3_nbp_glob.csv"))

# Ensemble Statistics:
sum_stat_trendy_nbp <- tibble("year" <- 1982:2011)

sum_stat_trendy_nbp <- trendy_nbp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_nbp$TRENDY[1] <- summary(lm(med ~ year, data= sum_stat_trendy_nbp))$coefficient[2,1]

# IQR over time:
sum_stat_trendy_nbp <- sum_stat_trendy_nbp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_nbp$TRENDY[2] <- median(sum_stat_trendy_nbp$IQR)
df_analysis_data_nbp$TRENDY[3] <- summary(lm(IQR ~year, data= sum_stat_trendy_nbp))$coefficient[2,1]
df_analysis_data_nbp$TRENDY[4] <- summary(lm(IQR ~year, data= sum_stat_trendy_nbp))$coefficient[2,4]

plot(IQR ~ year, data= sum_stat_trendy_nbp, type= "l")
abline(lm(IQR ~year, data= sum_stat_trendy_nbp))


### CMIP ---------------------------------------------
## GPP
# Read Data:
cmip_gpp <- read_csv(here("data/cmip_gpp_glob.csv"))

# Ensemble Statistics:
sum_stat_cmip_gpp <- tibble("year" <- 1982:2011)

sum_stat_cmip_gpp <- cmip_gpp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_gpp$CMIP[1] <- summary(lm(med ~ year, data= sum_stat_cmip_gpp))$coefficient[2,1]

# IQR over time:
sum_stat_cmip_gpp <- sum_stat_cmip_gpp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_gpp$CMIP[2] <- median(sum_stat_cmip_gpp$IQR)
df_analysis_data_gpp$CMIP[3] <- summary(lm(IQR ~year, data= sum_stat_cmip_gpp))$coefficient[2,1]
df_analysis_data_gpp$CMIP[4] <- summary(lm(IQR ~year, data= sum_stat_cmip_gpp))$coefficient[2,4]


plot(IQR ~ year, data= sum_stat_cmip_gpp, type= "l")
abline(lm(IQR ~year, data= sum_stat_cmip_gpp))

# NBP
# Read Data:
cmip_nbp <- read_csv(here("data/cmip_nbp_glob.csv"))

# Ensemble Statistics:
sum_stat_cmip_nbp <- tibble("year" <- 1982:2011)

sum_stat_cmip_nbp <- cmip_nbp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_nbp$CMIP[1] <- summary(lm(med ~ year, data= sum_stat_cmip_nbp))$coefficient[2,1]

# IQR over time:
sum_stat_cmip_nbp <- sum_stat_cmip_nbp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_nbp$CMIP[2] <- median(sum_stat_cmip_nbp$IQR)
df_analysis_data_nbp$CMIP[3] <- summary(lm(IQR ~year, data= sum_stat_cmip_nbp))$coefficient[2,1]
df_analysis_data_nbp$CMIP[4] <- summary(lm(IQR ~year, data= sum_stat_cmip_nbp))$coefficient[2,4]


plot(IQR ~ year, data= sum_stat_cmip_nbp, type= "l")
abline(lm(IQR ~year, data= sum_stat_cmip_nbp))



### MsTMIP SG1 ---------------------------------------------
## GPP
# Read Data:
mstmip_sg1_gpp <- read_csv(here("data/mstmip_sg1_gpp_glob.csv"))

# Ensemble Statistics:
sum_stat_mstmip_sg1_gpp <- tibble("year" <- 1982:2011)

sum_stat_mstmip_sg1_gpp <- mstmip_sg1_gpp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_gpp$`MsTMIP SG1`[1] <- summary(lm(med ~ year, data= sum_stat_mstmip_sg1_gpp))$coefficient[2,1]

# IQR over time:
sum_stat_mstmip_sg1_gpp <- sum_stat_mstmip_sg1_gpp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_gpp$`MsTMIP SG1`[2] <- median(sum_stat_mstmip_sg1_gpp$IQR)
df_analysis_data_gpp$`MsTMIP SG1`[3] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg1_gpp))$coefficient[2,1]
df_analysis_data_gpp$`MsTMIP SG1`[4] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg1_gpp))$coefficient[2,4]


plot(IQR ~ year, data= sum_stat_mstmip_sg1_gpp, type= "l")
abline(lm(IQR ~year, data= sum_stat_mstmip_sg1_gpp))


# NBP:
# Read Data:
mstmip_sg1_nbp <- read_csv(here("data/mstmip_sg1_nbp_glob.csv"))

# Ensemble Statistics:
sum_stat_mstmip_sg1_nbp <- tibble("year" <- 1982:2011)

sum_stat_mstmip_sg1_nbp <- mstmip_sg1_nbp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_nbp$`MsTMIP SG1`[1] <- summary(lm(med ~ year, data= sum_stat_mstmip_sg1_nbp))$coefficient[2,1]

# IQR over time:
sum_stat_mstmip_sg1_nbp <- sum_stat_mstmip_sg1_nbp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_nbp$`MsTMIP SG1`[2] <- median(sum_stat_mstmip_sg1_nbp$IQR)
df_analysis_data_nbp$`MsTMIP SG1`[3] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg1_nbp))$coefficient[2,1]
df_analysis_data_nbp$`MsTMIP SG1`[4] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg1_nbp))$coefficient[2,4]


plot(IQR ~ year, data= sum_stat_mstmip_sg1_nbp, type= "l")
abline(lm(IQR ~year, data= sum_stat_mstmip_sg1_nbp))

### MsTMIP SG3 ---------------------------------------------
## GPP
# Read Data:
mstmip_sg3_gpp <- read_csv(here("data/mstmip_sg3_gpp_glob.csv"))

# Ensemble Statistics:
sum_stat_mstmip_sg3_gpp <- tibble("year" <- 1982:2011)

sum_stat_mstmip_sg3_gpp <- mstmip_sg3_gpp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_gpp$`MsTMIP SG3`[1] <- summary(lm(med ~ year, data= sum_stat_mstmip_sg3_gpp))$coefficient[2,1]

# IQR over time:
sum_stat_mstmip_sg3_gpp <- sum_stat_mstmip_sg3_gpp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_gpp$`MsTMIP SG3`[2] <- median(sum_stat_mstmip_sg3_gpp$IQR)
df_analysis_data_gpp$`MsTMIP SG3`[3] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg3_gpp))$coefficient[2,1]
df_analysis_data_gpp$`MsTMIP SG3`[4] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg3_gpp))$coefficient[2,4]


plot(IQR ~ year, data= sum_stat_mstmip_sg3_gpp, type= "l")
abline(lm(IQR ~year, data= sum_stat_mstmip_sg3_gpp))


# NBP
# Read Data:
mstmip_sg3_nbp <- read_csv(here("data/mstmip_sg3_nbp_glob.csv"))

# Ensemble Statistics:
sum_stat_mstmip_sg3_nbp <- tibble("year" <- 1982:2011)

sum_stat_mstmip_sg3_nbp <- mstmip_sg3_nbp %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    p25 = quantile(c_across(where(is.numeric)), 0.25, na.rm = TRUE),
    med = quantile(c_across(where(is.numeric)), 0.50, na.rm = TRUE),
    p75 = quantile(c_across(where(is.numeric)), 0.75, na.rm = TRUE)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(year, p25, med, p75)

# Slope of median line:
df_analysis_data_nbp$`MsTMIP SG3`[1] <- summary(lm(med ~ year, data= sum_stat_mstmip_sg3_nbp))$coefficient[2,1]

# IQR over time:
sum_stat_mstmip_sg3_nbp <- sum_stat_mstmip_sg3_nbp %>% mutate("IQR" = (p75 - p25))

# Typical Model Spread and Change:
df_analysis_data_nbp$`MsTMIP SG3`[2] <- median(sum_stat_mstmip_sg3_nbp$IQR)
df_analysis_data_nbp$`MsTMIP SG3`[3] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg3_nbp))$coefficient[2,1]
df_analysis_data_nbp$`MsTMIP SG3`[4] <- summary(lm(IQR ~year, data= sum_stat_mstmip_sg3_nbp))$coefficient[2,4]


plot(IQR ~ year, data= sum_stat_mstmip_sg3_nbp, type= "l")
abline(lm(IQR ~year, data= sum_stat_mstmip_sg3_nbp))

