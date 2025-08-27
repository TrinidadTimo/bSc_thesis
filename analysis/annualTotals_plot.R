# Load libraries
library(lubridate)
library(ggplot2)
library(dplyr)
library(here)
library(ggrepel)
library(scales)
library(viridisLite)


### TRENDY -------------------------------------------------------------------
## Read File Names
files_trendy_gpp <- (list.files(path= here("../data/trendy/S3/ann_glob_absolute/R/as_txt/"), pattern = "_gpp_.*\\.txt$"))[!list.files(path= here("../data/trendy/S3/ann_glob_absolute/R/as_txt/"), pattern = "_gpp_.*\\.txt$") %in% c("ISBA-CTRIP_S3_gpp_GLOB_ABSOLUTE.txt")]
files_trendy_nbp <- (list.files(path= here("../data/trendy/S3/ann_glob_absolute/R/as_txt/"), pattern = "_nbp_.*\\.txt$"))[!list.files(path= here("../data/trendy/S3/ann_glob_absolute/R/as_txt/"), pattern = "_nbp_.*\\.txt$") %in% c("ISBA-CTRIP_S3_nbp_GLOB_ABSOLUTE.txt")]

## Read Data
# GPP:
trendy_gpp <- data.frame("year" = 1700:2022)

for (file in files_trendy_gpp) {
  mod_name <- sub("_S3_gpp_GLOB_ABSOLUTE.txt", "", file)
  mod <- read.table(paste(here("../data/trendy/S3/ann_glob_absolute/R/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  trendy_gpp <- merge(trendy_gpp, mod, by = "year", all.x = TRUE)
}

trendy_gpp <- subset(trendy_gpp, year >= 1982 & year <= 2011)

# NBP:
trendy_nbp <- data.frame("year" = 1700:2022)

for (file in files_trendy_nbp) {
  mod_name <- sub("_S3_nbp_GLOB_ABSOLUTE.txt", "", file)
  mod <- read.table(paste(here("../data/trendy/S3/ann_glob_absolute/R/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  trendy_nbp <- merge(trendy_nbp, mod, by = "year", all.x = TRUE)
}

trendy_nbp <- trendy_nbp %>% filter(year >= 1982 & year <= 2011) %>% mutate("SDGVM" = read_csv(here("../data/trendy/S3/ann_glob_absolute/R/SDGVM_S3_nbp_GLOB_ABSOLUTE.csv"))$NBP)

# Including GCB SLand:
gcb_sland <- read_csv("data-raw/gcb_sland.csv")

## Creating Time Series Plots
# Getting Correct table format for plotting:
trendy_gpp_long <- pivot_longer(trendy_gpp, cols= -year, names_to = "Model", values_to = "GPP")

## Create Plot:
### GPP:
# Helping object for labels:
last_pts_trendy_gpp <- trendy_gpp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_trendy_gpp <- trendy_gpp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(GPP, .25, na.rm = TRUE),
            med = median(GPP, na.rm = TRUE),
            p75 = quantile(GPP, .75, na.rm = TRUE), .groups = "drop")


#---
p_trendy_gpp <- ggplot() +
  geom_point(data = last_pts_trendy_gpp, aes(x= year, y= GPP, color = Model), size = 0.5) +
  scale_color_viridis_d("D") +
  ggrepel::geom_text_repel(
    data = last_pts_trendy_gpp,
    aes(x= year, y= GPP, label = Model, color = Model),
    direction = "y", hjust = -0.7, nudge_x = 0.5, segment.size = 0.4, size = 2.5,
    min.segment.length = 0) +
  geom_ribbon(data = sum_stat_trendy_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = trendy_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_trendy_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2017, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 75, to= 200, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(70, 215), clip = "off")

ggsave(here("figures/annualTotals_trendy_gpp.png"), plot= p_trendy_gpp,width = 14, height = 10, dpi = 300)

### NBP:
trendy_nbp_long <- pivot_longer(trendy_nbp, cols= -year, names_to = "Model", values_to = "NBP")
# Helping object for labels:
last_pts_trendy_nbp <- trendy_nbp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_trendy_nbp <- trendy_nbp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(NBP, .25, na.rm = TRUE),
            med = median(NBP, na.rm = TRUE),
            p75 = quantile(NBP, .75, na.rm = TRUE), .groups = "drop")

#---
p_trendy_nbp <- ggplot() +
  geom_point(data = last_pts_trendy_nbp, aes(x= year, y= NBP, color = Model), size = 0.5) +
  scale_color_viridis_d("D") +
  ggrepel::geom_text_repel(
    data = last_pts_trendy_nbp,
    aes(x= year, y= NBP, label = Model, color = Model),
    direction = "y", hjust = -0.7, nudge_x = 0.5, segment.size = 0.4, size = 2.5,
    min.segment.length = 0) +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_trendy_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.35) +
  geom_line(data = trendy_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.8) +
  geom_line(data = sum_stat_trendy_nbp, aes(x= year, y= med), color= "blue", size= 0.7) +
  geom_line(data = gcb_sland, aes(x= Year, y= NBP_obs), color = "red", size = 0.7) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -4, to= 5, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(-3.5, 5.2), clip = "off")


ggsave(here("figures/annualTotals_trendy_nbp.png"), plot= p_trendy_nbp,width = 14, height = 10, dpi = 300)



### CMIP -------------------------------------------------------------------
## Read File Names
files_cmip_gpp <- (list.files(path= here("../data/CMIP6/ann_glob/as_txt/"), pattern = "_gpp_.*\\.txt$"))
files_cmip_nbp <- (list.files(path= here("../data/CMIP6/ann_glob/as_txt/"), pattern = "_nbp_.*\\.txt$"))

## Read Data
# GPP:
cmip_gpp <- data.frame("year" = 1700:2022)

for (file in files_cmip_gpp) {
  mod_name <- sub("_gpp_ann_glob.txt", "", file)
  mod <- read.table(paste(here("../data/CMIP6/ann_glob/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  cmip_gpp <- merge(cmip_gpp, mod, by = "year", all.x = TRUE)
}

cmip_gpp <- subset(cmip_gpp, year >= 1982 & year <= 2011) %>% dplyr::select(-`GISS-E2-2-H`)

# NBP:
cmip_nbp <- data.frame("year" = 1700:2022)

for (file in files_cmip_nbp) {
  mod_name <- sub("_nbp_ann_glob.txt", "", file)
  mod <- read.table(paste(here("../data/CMIP6/ann_glob/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  cmip_nbp <- merge(cmip_nbp, mod, by = "year", all.x = TRUE)
}

cmip_nbp <- cmip_nbp %>% filter(year >= 1982 & year <= 2011) %>% dplyr::select(-`GISS-E2-2-H`)


## Creating Time Series Plots
# Getting Correct table format for plotting:
cmip_gpp_long <- pivot_longer(cmip_gpp, cols= -year, names_to = "Model", values_to = "GPP")

## Create Plot:
### GPP:
# Helping object for labels:
last_pts_cmip_gpp <- cmip_gpp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_cmip_gpp <- cmip_gpp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(GPP, .25, na.rm = TRUE),
            med = median(GPP, na.rm = TRUE),
            p75 = quantile(GPP, .75, na.rm = TRUE), .groups = "drop")

#---
p_cmip_gpp <- ggplot() +
  geom_point(data = last_pts_cmip_gpp, aes(x= year, y= GPP, color = Model), size = 0.5) +
  scale_color_viridis_d(option = "D")  +
  ggrepel::geom_text_repel(
    data = last_pts_cmip_gpp,
    aes(x= year, y= GPP, label = Model, color = Model),
    direction = "y", hjust = -0.7, nudge_x = 0.5, segment.size = 0.4, size = 2,
    min.segment.length = 0) +
  geom_ribbon(data = sum_stat_cmip_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = cmip_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_cmip_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2011, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 100, to= 225, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(95, 230), clip = "off")

ggsave(here("figures/annualTotals_cmip_gpp.png"), plot= p_cmip_gpp,width = 14, height = 10, dpi = 300)


### NBP:
cmip_nbp_long <- pivot_longer(cmip_nbp, cols= -year, names_to = "Model", values_to = "NBP")
# Helping object for labels:
last_pts_cmip_nbp <- cmip_nbp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_cmip_nbp <- cmip_nbp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(NBP, .25, na.rm = TRUE),
            med = median(NBP, na.rm = TRUE),
            p75 = quantile(NBP, .75, na.rm = TRUE), .groups = "drop")

#---
p_cmip_nbp <- ggplot() +
  geom_point(data = last_pts_cmip_nbp, aes(x= year, y= NBP, color = Model), size = 0.5) +
  scale_color_viridis_d("E") +
  ggrepel::geom_text_repel(
    data = last_pts_cmip_nbp,
    aes(x= year, y= NBP, label = Model, color = Model),
    direction = "y", hjust = -0.7, nudge_x = 0.5, segment.size = 0.4, size = 2,
    min.segment.length = 0) +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_cmip_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.25) +
  geom_line(data = cmip_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.6) +
  geom_line(data = sum_stat_cmip_nbp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -7, to= 15, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(-6, 14), clip = "off")

ggsave(here("figures/annualTotals_cmip_nbp.png"), plot= p_cmip_nbp,width = 14, height = 10, dpi = 300)


### mstmip_sg3 -------------------------------------------------------------------
## Read File Names
files_mstmip_sg3_gpp <- (list.files(path= here("../data/mstmip/SG3/ann_glob/as_txt/"), pattern = "_gpp_.*\\.txt$"))
files_mstmip_sg3_nbp <- (list.files(path= here("../data/mstmip/SG3/ann_glob/as_txt/"), pattern = "_nbp_.*\\.txt$"))

## Read Data
# GPP:
mstmip_sg3_gpp <- data.frame("year" = 1700:2022)

for (file in files_mstmip_sg3_gpp) {
  mod_name <- sub("_gpp_ann_glob.txt", "", file)
  mod <- read.table(paste(here("../data/mstmip/SG3/ann_glob/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  mstmip_sg3_gpp <- merge(mstmip_sg3_gpp, mod, by = "year", all.x = TRUE)
}

mstmip_sg3_gpp <- subset(mstmip_sg3_gpp, year >= 1982 & year <= 2010)

# NBP:
mstmip_sg3_nbp <- data.frame("year" = 1700:2022)

for (file in files_mstmip_sg3_nbp) {
  mod_name <- sub("_nbp_ann_glob.txt", "", file)
  mod <- read.table(paste(here("../data/mstmip/SG3/ann_glob/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  mstmip_sg3_nbp <- merge(mstmip_sg3_nbp, mod, by = "year", all.x = TRUE)
}

mstmip_sg3_nbp <- mstmip_sg3_nbp %>% filter(year >= 1982 & year <= 2010)


## Creating Time Series Plots
# Getting Correct table format for plotting:
mstmip_sg3_gpp_long <- pivot_longer(mstmip_sg3_gpp, cols= -year, names_to = "Model", values_to = "GPP")

## Create Plot:
### GPP:
# Helping object for labels:
last_pts_mstmip_sg3_gpp <- mstmip_sg3_gpp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_mstmip_sg3_gpp <- mstmip_sg3_gpp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(GPP, .25, na.rm = TRUE),
            med = median(GPP, na.rm = TRUE),
            p75 = quantile(GPP, .75, na.rm = TRUE), .groups = "drop")

#---
p_mstmip_sg3_gpp <- ggplot() +
  geom_point(data = last_pts_mstmip_sg3_gpp, aes(x= year, y= GPP, color = Model), size = 0.5) +
  scale_color_viridis_d("D") +
  ggrepel::geom_text_repel(
    data = last_pts_mstmip_sg3_gpp,
    aes(x= year, y= GPP, label = Model, color = Model),
    direction = "y", hjust = -0.2, nudge_x = 0.5, segment.size = 0.4, size = 3,
    min.segment.length = 0) +
  geom_ribbon(data = sum_stat_mstmip_sg3_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = mstmip_sg3_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_mstmip_sg3_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 75, to= 225, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(70, 205), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg3_gpp.png"), plot= p_mstmip_sg3_gpp,width = 14, height = 10, dpi = 300)

### NBP:
mstmip_sg3_nbp_long <- pivot_longer(mstmip_sg3_nbp, cols= -year, names_to = "Model", values_to = "NBP")
# Helping object for labels:
last_pts_mstmip_sg3_nbp <- mstmip_sg3_nbp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_mstmip_sg3_nbp <- mstmip_sg3_nbp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(NBP, .25, na.rm = TRUE),
            med = median(NBP, na.rm = TRUE),
            p75 = quantile(NBP, .75, na.rm = TRUE), .groups = "drop")

#---
p_mstmip_sg3_nbp <- ggplot() +
  geom_point(data = last_pts_mstmip_sg3_nbp, aes(x= year, y= NBP, color = Model), size = 0.5) +
  ggrepel::geom_text_repel(
    data = last_pts_mstmip_sg3_nbp,
    aes(x= year, y= NBP, label = Model, color = Model),
    direction = "y", hjust = -0.3, nudge_x = 0.5, segment.size = 0.4, size = 3,
    min.segment.length = 0) +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_mstmip_sg3_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.25) +
  geom_line(data = mstmip_sg3_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.8) +
  geom_line(data = sum_stat_mstmip_sg3_nbp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  scale_color_viridis_d("D") +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -12, to= 15, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(-10.5, 3.5), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg3_nbp.png"), plot= p_mstmip_sg3_nbp,width = 14, height = 10, dpi = 300)


### mstmip_sg1 -------------------------------------------------------------------
## Read File Names
files_mstmip_sg1_gpp <- (list.files(path= here("../data/mstmip/SG1/ann_glob/as_txt/"), pattern = "_gpp_.*\\.txt$"))
files_mstmip_sg1_nbp <- (list.files(path= here("../data/mstmip/SG1/ann_glob/as_txt/"), pattern = "_nbp_.*\\.txt$"))

## Read Data
# GPP:
mstmip_sg1_gpp <- data.frame("year" = 1700:2022)

for (file in files_mstmip_sg1_gpp) {
  mod_name <- sub("_gpp_ann_glob.txt", "", file)
  mod <- read.table(paste(here("../data/mstmip/SG1/ann_glob/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  mstmip_sg1_gpp <- merge(mstmip_sg1_gpp, mod, by = "year", all.x = TRUE)
}

mstmip_sg1_gpp <- subset(mstmip_sg1_gpp, year >= 1982 & year <= 2010)

# NBP:
mstmip_sg1_nbp <- data.frame("year" = 1700:2022)

for (file in files_mstmip_sg1_nbp) {
  mod_name <- sub("_nbp_ann_glob.txt", "", file)
  mod <- read.table(paste(here("../data/mstmip/SG1/ann_glob/as_txt/"), file, sep= "/"), quote= "\"")
  colnames(mod) <- c("year", mod_name)

  mod$year <- as.integer(year(format(as.Date(mod$year, format = "%Y-%m-%d"))))
  mstmip_sg1_nbp <- merge(mstmip_sg1_nbp, mod, by = "year", all.x = TRUE)
}

mstmip_sg1_nbp <- mstmip_sg1_nbp %>% filter(year >= 1982 & year <= 2010)


## Creating Time Series Plots
# Getting Correct table format for plotting:
mstmip_sg1_gpp_long <- pivot_longer(mstmip_sg1_gpp, cols= -year, names_to = "Model", values_to = "GPP")

## Create Plot:
### GPP:
# Helping object for labels:
last_pts_mstmip_sg1_gpp <- mstmip_sg1_gpp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_mstmip_sg1_gpp <- mstmip_sg1_gpp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(GPP, .25, na.rm = TRUE),
            med = median(GPP, na.rm = TRUE),
            p75 = quantile(GPP, .75, na.rm = TRUE), .groups = "drop")

#---
p_mstmip_sg1_gpp <- ggplot() +
  geom_point(data = last_pts_mstmip_sg1_gpp, aes(x= year, y= GPP, color = Model), size = 0.5) +
  scale_color_viridis_d("D") +
  ggrepel::geom_text_repel(
    data = last_pts_mstmip_sg1_gpp,
    aes(x= year, y= GPP, label = Model, color = Model),
    direction = "y", hjust = -0.2, nudge_x = 0.5, segment.size = 0.4, size = 3,
    min.segment.length = 0) +
  geom_ribbon(data = sum_stat_mstmip_sg1_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = mstmip_sg1_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_mstmip_sg1_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 50, to= 225, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(48, 177), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg1_gpp.png"), plot= p_mstmip_sg1_gpp,width = 14, height = 10, dpi = 300)



### NBP:
mstmip_sg1_nbp_long <- pivot_longer(mstmip_sg1_nbp, cols= -year, names_to = "Model", values_to = "NBP")
# Helping object for labels:
last_pts_mstmip_sg1_nbp <- mstmip_sg1_nbp_long %>%
  group_by(Model) %>%
  slice_max(year, n = 1) %>%
  ungroup()
# Ensemble summary statistics:
sum_stat_mstmip_sg1_nbp <- mstmip_sg1_nbp_long %>%
  group_by(year) %>%
  summarise(p25 = quantile(NBP, .25, na.rm = TRUE),
            med = median(NBP, na.rm = TRUE),
            p75 = quantile(NBP, .75, na.rm = TRUE), .groups = "drop")

#---
p_mstmip_sg1_nbp <- ggplot() +
  geom_point(data = last_pts_mstmip_sg1_nbp, aes(x= year, y= NBP, color = Model), size = 0.5) +
  ggrepel::geom_text_repel(
    data = last_pts_mstmip_sg1_nbp,
    aes(x= year, y= NBP, label = Model, color = Model),
    direction = "y", hjust = -0.3, nudge_x = 0.5, segment.size = 0.4, size = 3,
    min.segment.length = 0) +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_mstmip_sg1_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.25) +
  geom_line(data = mstmip_sg1_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.8) +
  geom_line(data = sum_stat_mstmip_sg1_nbp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  scale_color_viridis_d("D") +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -12, to= 15, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2017), ylim = c(-3.2, 4.2), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg1_nbp.png"), plot= p_mstmip_sg1_nbp,width = 14, height = 10, dpi = 300)


# ---------
### Save all Plots as R data to have them available for other scripts:
save(p_trendy_gpp, p_trendy_nbp, p_cmip_gpp, p_cmip_nbp, p_mstmip_sg1_gpp, p_mstmip_sg1_nbp, p_mstmip_sg3_gpp, p_mstmip_sg3_nbp,
      file = here("data/annualTotals_plots_labeled.RData"))


# Plots without label for results chapter --------------------------------------------------

## TRENDY
### GPP:
p_trendy_gpp_noLabel <- ggplot() +
  geom_ribbon(data = sum_stat_trendy_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = trendy_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_trendy_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_color_grey(start= 0.3, end= 0.7) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2017, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 75, to= 200, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(70, 215), clip = "off")

ggsave(here("figures/annualTotals_trendy_gpp_noLabel.png"), plot= p_trendy_gpp_noLabel,width = 14, height = 10, dpi = 300)

### NBP:

p_trendy_nbp_noLabel <- ggplot() +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_trendy_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.35) +
  geom_line(data = trendy_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.8) +
  geom_line(data = sum_stat_trendy_nbp, aes(x= year, y= med), color= "blue", size= 0.7) +
  geom_line(data = gcb_sland, aes(x= Year, y= NBP_obs), color = "red", size = 0.7) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year") +
  scale_color_grey(start= 0.3, end= 0.7) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -4, to= 5, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(-3.5, 5.2), clip = "off")


ggsave(here("figures/annualTotals_trendy_nbp_noLabel.png"), plot= p_trendy_nbp_noLabel,width = 14, height = 10, dpi = 300)



### CMIP -------------------------------------------------------------------
### GPP:
p_cmip_gpp_noLabel <- ggplot() +
  geom_ribbon(data = sum_stat_cmip_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = cmip_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_cmip_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year") +
  scale_color_grey(start= 0.3, end= 0.7) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2011, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 100, to= 225, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(95, 230), clip = "off")

ggsave(here("figures/annualTotals_cmip_gpp_noLabel.png"), plot= p_cmip_gpp_noLabel,width = 14, height = 10, dpi = 300)


### NBP:
p_cmip_nbp_noLabel <- ggplot() +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_cmip_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.25) +
  geom_line(data = cmip_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.6) +
  geom_line(data = sum_stat_cmip_nbp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_color_grey(start= 0.3, end= 0.7) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -7, to= 15, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(-6, 14), clip = "off")

ggsave(here("figures/annualTotals_cmip_nbp_noLabel.png"), plot= p_cmip_nbp_noLabel,width = 14, height = 10, dpi = 300)


### mstmip_sg3 -------------------------------------------------------------------
### GPP:
p_mstmip_sg3_gpp_noLabel <- ggplot() +
  geom_ribbon(data = sum_stat_mstmip_sg3_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = mstmip_sg3_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_mstmip_sg3_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year") +
  scale_color_grey(start= 0.3, end= 0.7) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 75, to= 225, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(70, 205), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg3_gpp_noLabel.png"), plot= p_mstmip_sg3_gpp_noLabel,width = 14, height = 10, dpi = 300)

### NBP:
p_mstmip_sg3_nbp_noLabel <- ggplot() +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_mstmip_sg3_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.25) +
  geom_line(data = mstmip_sg3_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.8) +
  geom_line(data = sum_stat_mstmip_sg3_nbp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  scale_color_grey(start= 0.3, end= 0.7) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -12, to= 15, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(-10.5, 3.5), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg3_nbp_noLabel.png"), plot= p_mstmip_sg3_nbp_noLabel,width = 14, height = 10, dpi = 300)


### mstmip_sg1 -------------------------------------------------------------------
## GPP:
p_mstmip_sg1_gpp_noLabel <- ggplot() +
  geom_ribbon(data = sum_stat_mstmip_sg1_gpp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.15) +
  geom_line(data = mstmip_sg1_gpp_long, aes(x= year, y=  GPP, group = Model, color = Model)) +
  geom_line(data = sum_stat_mstmip_sg1_gpp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_color_grey(start= 0.3, end= 0.7) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= 50, to= 225, by= 25),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(48, 177), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg1_gpp_noLabel.png"), plot= p_mstmip_sg1_gpp_noLabel,width = 14, height = 10, dpi = 300)


### NBP:

p_mstmip_sg1_nbp_noLabel <- ggplot() +
  geom_hline(yintercept= 0, color= "black", size= 0.1) +
  geom_ribbon(data = sum_stat_mstmip_sg1_nbp, aes(year, ymin = p25, ymax = p75), fill = "blue", alpha = 0.25) +
  geom_line(data = mstmip_sg1_nbp_long, aes(x= year, y=  NBP, group = Model, color = Model), alpha = 0.8) +
  geom_line(data = sum_stat_mstmip_sg1_nbp, aes(x= year, y= med), color= "blue", size= 0.8) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = "none",
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)) +
  scale_color_grey(start= 0.3, end= 0.7) +
  labs(
    y = expression(~PgC~yr^{-1}),
    x = "Year"
  ) +
  scale_x_continuous(labels = label_number(accuracy = 1, big.mark= ""), breaks= seq(from= 1980, to= 2015, by= 5),
                     expand = c(0,0)) +
  scale_y_continuous(labels = label_number(accuracy = 1), breaks= seq(from= -12, to= 15, by= 1),
                     expand = c(0,0)) +
  coord_cartesian(xlim = c(1979, 2013), ylim = c(-3.2, 4.2), clip = "off")

ggsave(here("figures/annualTotals_mstmip_sg1_nbp_noLabel.png"), plot= p_mstmip_sg1_nbp_noLabel,width = 14, height = 10, dpi = 300)


#----------------
### Storing all plots as R data to have them available for other scripts:
save(p_trendy_gpp_noLabel, p_trendy_nbp_noLabel, p_cmip_gpp_noLabel, p_cmip_nbp_noLabel, p_mstmip_sg1_gpp_noLabel, p_mstmip_sg1_nbp_noLabel, p_mstmip_sg3_gpp_noLabel, p_mstmip_sg3_nbp_noLabel,
     file = here("data/annualTotals_plots_noLabel.RData"))
