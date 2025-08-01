library(ggplot2)
library(here)
library(tidyverse)
library(dplyr)
library(ggforce)

# TRENDY:
## GPP:
trendy_gpp_files <- list.files(path= here("../data/trendy/S3/ann_glob_absolute/R/as_txt"), pattern = "_gpp_.*\\.txt$")

df_trendy_gpp = data.frame("year" = 1700:2022)

for (file in trendy_gpp_files) {
  mod_name <- sub("_S3_gpp_GLOB_ABSOLUTE.txt", "", file)
  mod <- read.table(paste("../data/trendy/S3/ann_glob_absolute/R/as_txt", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_trendy_gpp <- merge(df_trendy_gpp, mod, by = "year", all.x = TRUE)
}

df_trendy_gpp %>% filter(year %in% 1982:2011) %>% select(-`ISBA-CTRIP`) %>% write.csv(file = here("data/trendy_S3_gpp_glob.csv"))

df_trendy_gpp_long <- df_trendy_gpp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "GPP")

for(i in 1:2) {
  p_trendy_gpp <- df_trendy_gpp_long |>
    filter(year %in% 1982:2011, Model != "ISBA-CTRIP") |>
    ggplot(mapping= aes(x= GPP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "darkgreen", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3) +
    labs(x= expression(GPP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_trendy_gpp_%01d.png"), i), plot = p_trendy_gpp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}


## NBP:
trendy_nbp_files <- list.files(path= here("../data/trendy/S3/ann_glob_absolute/R/as_txt"), pattern = "_nbp_.*\\.txt$")

df_trendy_nbp = data.frame("year" = 1700:2022)

for (file in trendy_nbp_files) {
  mod_name <- sub("_S3_nbp_GLOB_ABSOLUTE.txt", "", file)
  mod <- read.table(paste("../data/trendy/S3/ann_glob_absolute/R/as_txt", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_trendy_nbp <- merge(df_trendy_nbp, mod, by = "year", all.x = TRUE)
}

df_trendy_nbp %>% filter(year %in% 1982:2011) %>% select(-`ISBA-CTRIP`) %>% write.csv(file = here("data/trendy_S3_nbp_glob.csv"))

df_trendy_nbp_long <- df_trendy_nbp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "NBP")

for(i in 1:2) {
  p_trendy_nbp <- df_trendy_nbp_long |>
    filter(year %in% 1982:2011, Model != "ISBA-CTRIP") |>
    ggplot(mapping= aes(x= NBP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "blue", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(NBP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_trendy_nbp_%01d.png"), i), plot = p_trendy_nbp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}

# CMIP:
## GPP:
cmip_gpp_files <- list.files(path= here("../data/CMIP6/ann_glob/as_txt/"), pattern = "_gpp_.*\\.txt$")

df_cmip_gpp = data.frame("year" = 1982:2011)

for (file in cmip_gpp_files) {
  mod_name <- sub("_gpp_ann_glob.txt", "", file)
  mod <- read.table(paste("../data/CMIP6/ann_glob/as_txt/", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_cmip_gpp <- merge(df_cmip_gpp, mod, by = "year", all.x = TRUE)
}

df_cmip_gpp %>% filter(year %in% 1982:2011) %>% write.csv(file = here("data/cmip_gpp_glob.csv"))


df_cmip_gpp_long <- df_cmip_gpp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "GPP")

for(i in 1:3) {
  p_cmip_gpp <- df_cmip_gpp_long |>
    filter(Model != "GISS-E2-2-H") |>
    ggplot(mapping= aes(x= GPP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "darkgreen", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(GPP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_cmip_gpp_%01d.png"), i), plot = p_cmip_gpp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}


## NBP:
cmip_nbp_files <- list.files(path= here("../data/CMIP6/ann_glob/as_txt/"), pattern = "_nbp_.*\\.txt$")

df_cmip_nbp = data.frame("year" = 1982:2011)

for (file in cmip_nbp_files) {
  mod_name <- sub("_nbp_ann_glob.txt", "", file)
  mod <- read.table(paste("../data/CMIP6/ann_glob/as_txt/", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_cmip_nbp <- merge(df_cmip_nbp, mod, by = "year", all.x = TRUE)
}

df_cmip_nbp %>% filter(year %in% 1982:2011) %>% write.csv(file = here("data/cmip_nbp_glob.csv"))


df_cmip_nbp_long <- df_cmip_nbp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "NBP")

for(i in 1:3) {
  p_cmip_nbp <- df_cmip_nbp_long |>
    filter(Model != "GISS-E2-2-H") |>
    ggplot(mapping = aes(x= NBP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "blue", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(NBP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_cmip_nbp_%01d.png"), i), plot = p_cmip_nbp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}



# MsTMIP:
## SG1
### GPP:
mstmip_sg1_gpp_files <- list.files(path= here("../data/mstmip/SG1/ann_glob/as_txt/"), pattern = "_gpp_.*\\.txt$")

df_mstmip_sg1_gpp = data.frame("year" = 1982:2010)

for (file in mstmip_sg1_gpp_files) {
  mod_name <- sub("_gpp_ann_glob.txt", "", file)
  mod <- read.table(paste("../data/mstmip/SG1/ann_glob/as_txt/", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_mstmip_sg1_gpp <- merge(df_mstmip_sg1_gpp, mod, by = "year", all.x = TRUE)
}

write.csv(df_mstmip_sg1_gpp, file = here("data/mstmip_sg1_gpp_glob.csv"))

df_mstmip_sg1_gpp_long <- df_mstmip_sg1_gpp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "GPP")

for(i in 1:2) {
  p_mstmip_sg1_gpp <- df_mstmip_sg1_gpp_long |>
    ggplot(mapping= aes(x= GPP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "darkgreen", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(GPP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_mstmip_sg1_gpp_%01d.png"), i), plot = p_mstmip_sg1_gpp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}


### NBP:
mstmip_sg1_nbp_files <- list.files(path= here("../data/mstmip/SG1/ann_glob/as_txt/"), pattern = "_nbp_.*\\.txt$")

df_mstmip_sg1_nbp = data.frame("year" = 1982:2010)

for (file in mstmip_sg1_nbp_files) {
  mod_name <- sub("_nbp_ann_glob.txt", "", file)
  mod <- read.table(paste("../data/mstmip/SG1/ann_glob/as_txt/", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_mstmip_sg1_nbp <- merge(df_mstmip_sg1_nbp, mod, by = "year", all.x = TRUE)
}

write.csv(df_mstmip_sg1_nbp, file = here("data/mstmip_sg1_nbp_glob.csv"))

df_mstmip_sg1_nbp_long <- df_mstmip_sg1_nbp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "NBP")

for(i in 1:2) {
  p_mstmip_sg1_nbp <- df_mstmip_sg1_nbp_long |>
    ggplot(mapping= aes(x= NBP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "blue", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(NBP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_mstmip_sg1_nbp_%01d.png"), i), plot = p_mstmip_sg1_nbp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}


## SG3
### GPP:
mstmip_sg3_gpp_files <- list.files(path= here("../data/mstmip/SG3/ann_glob/as_txt/"), pattern = "_gpp_.*\\.txt$")

df_mstmip_sg3_gpp = data.frame("year" = 1982:2010)

for (file in mstmip_sg3_gpp_files) {
  mod_name <- sub("_gpp_ann_glob.txt", "", file)
  mod <- read.table(paste("../data/mstmip/SG3/ann_glob/as_txt/", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_mstmip_sg3_gpp <- merge(df_mstmip_sg3_gpp, mod, by = "year", all.x = TRUE)
}

write.csv(df_mstmip_sg3_gpp, file = here("data/mstmip_sg3_gpp_glob.csv"))

df_mstmip_sg3_gpp_long <- df_mstmip_sg3_gpp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "GPP")

for(i in 1:2) {
  p_mstmip_sg3_gpp <- df_mstmip_sg3_gpp_long |>
    ggplot(mapping= aes(x= GPP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "darkgreen", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(GPP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_mstmip_sg3_gpp_%01d.png"), i), plot = p_mstmip_sg3_gpp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}


### NBP:
mstmip_sg3_nbp_files <- list.files(path= here("../data/mstmip/SG3/ann_glob/as_txt/"), pattern = "_nbp_.*\\.txt$")

df_mstmip_sg3_nbp = data.frame("year" = 1982:2010)

for (file in mstmip_sg3_nbp_files) {
  mod_name <- sub("_nbp_ann_glob.txt", "", file)
  mod <- read.table(paste("../data/mstmip/SG3/ann_glob/as_txt/", file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  df_mstmip_sg3_nbp <- merge(df_mstmip_sg3_nbp, mod, by = "year", all.x = TRUE)
}

write.csv(df_mstmip_sg3_nbp, file = here("data/mstmip_sg3_nbp_glob.csv"))

df_mstmip_sg3_nbp_long <- df_mstmip_sg3_nbp |>
  pivot_longer(cols= -year,
               names_to = "Model",
               values_to = "NBP")

for(i in 2) {
  p_mstmip_sg3_nbp <- df_mstmip_sg3_nbp_long |>
    ggplot(mapping= aes(x= NBP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "blue", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(NBP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_mstmip_sg3_nbp_%01d.png"), i), plot = p_mstmip_sg3_nbp, width = 8.27, height = 11.69, units= "in", dpi = 300)

}


GPP-Models
## P-Model
pMod_gpp_glob <- read_table(here("data/pMod_gpp_glob.txt"), col_names= c("Year", "P-Model"), skip = 1)


## FLUXCOM
fluxcom_gpp_glob <- read_table(here("data/fluxcom_gpp_glob.txt"), col_names= c("Year", "Fluxcom"), skip = 1)


df_gpp <- pMod_gpp_glob %>% mutate("Fluxcom" = fluxcom_gpp_glob$Fluxcom)

df_gpp_long<- df_gpp |>
  pivot_longer(cols= -Year,
               names_to = "Model",
               values_to = "GPP")


for(i in 1) {
  p_pMod_fluxcom_gpp_glob <- df_gpp_long |>
    ggplot(mapping= aes(x= GPP, y= ..density..)) +
    geom_histogram(color= "lightgrey",fill= "darkgreen", binwidth = 1, size= 0.2) +
    geom_boxplot(aes(y = -0.02),
                 width = 0.01,
                 alpha = 0.3,
                 coef= 0,
                 outlier.shape= NA,
                 size= 0.3)+
    labs(x= expression(GPP~(PgC~yr^{-1})),
         y= "Density") +
    theme_bw() +
    theme(
      legend.position="none",
      panel.spacing = unit(0.3, "cm"),
      strip.text.x = element_text(size = 8),
      strip.background= element_blank(),
      strip.text = element_text(face = "bold")
    ) +
    facet_wrap_paginate(~Model, ncol= 3, nrow= 3, page= i)
  ggsave(sprintf(here("figures/distribution_pMod_fluxcom_gpp_%01d.png"), i), plot = p_pMod_fluxcom_gpp_glob, width = 8.27, height = 11.69, units= "in", dpi = 300)

}
