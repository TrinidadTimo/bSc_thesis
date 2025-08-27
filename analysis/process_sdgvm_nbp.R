library(readr)
library(pracma)
library(here)

glob <- read_csv("/home/ttrinidad/../../data_2/scratch/ttrinidad/data/trendy/S3/raw/SDGVM_S3_nbp.csv")[, 1:2] %>%
  rename("NBP" = "global") %>% filter(year %in% 1982:2011)
write_csv(glob, here("../data/trendy/S3/ann_glob_absolute/R/SDGVM_S3_nbp_GLOB_ABSOLUTE.csv"))


glob_detr <- glob %>% mutate(NBP = detrend(glob$NBP)) %>% mutate(NBP = map_dbl(NBP, 1))
write_csv(glob_detr, here("../data/trendy/S3/ann_glob_detr/R/SDGVM_S3_nbp_ANN_GLOB_DETR.csv"))

glob_detr_iav <- tibble("IAV_NBP" = var(glob_detr$NBP))
write_csv(glob_detr_iav, here("../data/trendy/S3/iavar/R/SDGVM_S3_nbp_VAR_GLOB.csv"))


## Coefficient of Variability
glob_gpp <- read_table("/data_2/scratch/ttrinidad/data/trendy/S3/ann_glob_absolute/R/as_txt/SDGVM_S3_gpp_GLOB_ABSOLUTE.txt")[,1:2]
colnames(glob_gpp) <- c("year", "gpp")

glob_detr_var_coef <- as.numeric(glob_detr_iav/mean(glob_gpp$gpp))
df_glob_detr_var_coef <- tibble("VAR_COEF" = glob_detr_var_coef)

write_csv(df_glob_detr_var_coef, here("../data/trendy/S3/var_coef/SDGVM_S3_nbp_var_coef.csv"))
