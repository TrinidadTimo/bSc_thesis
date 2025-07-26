library(readr)
library(dplyr)
library(pracma)

## Loading Data ----------------------------------------------
trendy_own <- read_csv("data/trendy_S3_nbp_glob.csv")

trendy_own_iav <- (read_delim("data/iavar_trendy.txt", delim = "\t", escape_double = FALSE, col_names = c("Model", "IAV_GPP", "IAV_NBP"), trim_ws = TRUE)[-2]) %>%
  pivot_wider(names_from= "Model", values_from = "IAV_NBP") %>%
  dplyr::select(-`ISBA-CTRIP`) %>%
  rename("JULES-ES" = "JULES", "LPJml" = "LPJmL", "OCNv2" = "OCN", "ORCHIDEE-v3" = "ORCHIDEE")


trendy_gcb <- read_delim("/data_2/scratch/ttrinidad/data/GCP/trendy_gcb_s3.csv",
                         delim = ";", escape_double = FALSE,
                         trim_ws = TRUE)[-21] %>% filter(YEAR %in% 1982:2011) %>% rename("EDv3" = "ED", "E3SM" = "ELM", "year" = "YEAR")

# Global Totals ----------------------------------------------
overlap_models <- (colnames(trendy_gcb)[colnames(trendy_gcb) %in% colnames(trendy_own)])[-1]

##### Abs Error ---------------------------
df_absolute_mean_abs_error <- tibble(Year = trendy_own$year)

for (name in overlap_models) {
  df_absolute_mean_abs_error[[name]] <- mean(abs(trendy_gcb[[name]] - trendy_own[[name]]), na.rm= TRUE)
}

df_absolute_mean_abs_error <- df_absolute_mean_abs_error[1,] %>% dplyr::select(-Year)

## IAV ----------------------------------------------

#### GCB IAV ---------------------------

trendy_gcb_var <- trendy_gcb %>%
  dplyr::select(all_of(overlap_models)) %>%
  apply(2, function(x) var(pracma::detrend(x))) %>%
  t() %>% as_tibble(.name_repair = "minimal")


#### Abs Error IAV ---------------------------

df_iav_abs_error <- trendy_own_iav

for (name in overlap_models) {
  df_iav_abs_error [[name]] <- abs(trendy_gcb_var[[name]] - trendy_own_iav[[name]])
}


df_iav_abs_error %>% pivot_longer(cols= everything(), names_to= "Models", values_to = "Absolute Difference") %>%
  ggplot(mapping= aes(x = `Absolute Difference`, y = Models)) +
  geom_point() +
  labs(title = "NBP IAV: Own Aggregation vs GCB",
       y = "Bedingungen",
       x = "Absolute Difference (PgC/yr)")


