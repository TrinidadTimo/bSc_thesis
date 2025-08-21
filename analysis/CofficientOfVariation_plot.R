# Load libraries
library(ggplot2)
library(dplyr)
library(here)

### TRENDY -------------------------------------------------------------------
## Read File Names
files_trendy_gpp <- (list.files(path= here("../data/trendy/S3/var_coef/as_txt/"), pattern = "_gpp_.*\\.txt$"))[!list.files(path= here("../data/trendy/S3/var_coef/as_txt/"), pattern = "_gpp_.*\\.txt$") %in% c("ISBA-CTRIP_S3_gpp_var_coef.txt")]
files_trendy_nbp <- (list.files(path= here("../data/trendy/S3/var_coef/as_txt/"), pattern = "_nbp_.*\\.txt$"))[!list.files(path= here("../data/trendy/S3/var_coef/as_txt/"), pattern = "_nbp_.*\\.txt$") %in% c("ISBA-CTRIP_S3_nbp_var_coef.txt")]

## Create and Store Data Table
### GPP:
trendy_gpp <- tibble(Model = character(length(files_trendy_gpp)), Value = numeric(length(files_trendy_gpp)))

for (i in 1:length(files_trendy_gpp)){
  model  <- sub("_S3_gpp_var_coef.txt", "", files_trendy_gpp[i])
  value <- as.numeric(read_csv(here(paste("../data/trendy/S3/var_coef/as_txt/", files_trendy_gpp[i], sep = "")), col_names = FALSE)[1,1])
  trendy_gpp$Model[i] <- model
  trendy_gpp$Value[i] <- value
}

write_csv(trendy_gpp, here("data/coefVar_trendy_gpp.csv"))

### NBP:
trendy_nbp <- tibble(Model = character(length(files_trendy_nbp)), Value = numeric(length(files_trendy_nbp)))

for (i in 1:length(files_trendy_nbp)){
  model  <- sub("_S3_nbp_var_coef.txt", "", files_trendy_nbp[i])
  value <- read_csv(here(paste("../data/trendy/S3/var_coef/as_txt/", files_trendy_nbp[i], sep = "")), col_names = FALSE)[[1]][1]
  trendy_nbp$Model[i] <- model
  trendy_nbp$Value[i] <- value
}

trendy_nbp <- rbind(trendy_nbp, tibble(Model = "SDGVM", Value= as.numeric(read_csv("/home/ttrinidad/../../data_2/scratch/ttrinidad/data/trendy/S3/var_coef/SDGVM_S3_nbp_var_coef.csv")[1,1])))

write_csv(trendy_nbp, here("data/coefVar_trendy_nbp.csv"))

## Plotting Histograms and Density Distributions
### GPP:
#### Calculating the optimal binwidth based on Sturge's method:
x <- trendy_gpp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_trendy_gpp <- ggplot(data= trendy_gpp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth = bw, fill = "darkseagreen4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_trendy_gpp.png"), plot= p_trendy_gpp,width = 14, height = 10, dpi = 300)

### NBP:

#### Calculating the optimal binwidth based on Sturge's method:
x <- trendy_nbp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_trendy_nbp <- ggplot(data= trendy_nbp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth= bw, fill = "deepskyblue4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_trendy_nbp.png"), plot= p_trendy_nbp,width = 14, height = 10, dpi = 300)




### CMIP -------------------------------------------------------------------
## Read File Names
files_cmip_gpp <- (list.files(path= here("../data/CMIP6/var_coef/as_txt/"), pattern = "_gpp_.*\\.txt$"))[!list.files(path= here("../data/CMIP6/var_coef/as_txt/"), pattern = "_gpp_.*\\.txt$") %in% c("GISS-E2-2-H_gpp_var_coef.txt")]
files_cmip_nbp <- (list.files(path= here("../data/CMIP6/var_coef/as_txt/"), pattern = "_nbp_.*\\.txt$"))[!list.files(path= here("../data/CMIP6/var_coef/as_txt/"), pattern = "_nbp_.*\\.txt$") %in% c("GISS-E2-2-H_nbp_var_coef.txt")]

## Create and Store Data Table
### GPP:
cmip_gpp <- tibble(Model = character(length(files_cmip_gpp)), Value = numeric(length(files_cmip_gpp)))

for (i in 1:length(files_cmip_gpp)){
  model  <- sub("_S3_gpp_var_coef.txt", "", files_cmip_gpp[i])
  value <- as.numeric(read_csv(here(paste("../data/CMIP6/var_coef/as_txt/", files_cmip_gpp[i], sep = "")), col_names = FALSE)[1,1])
  cmip_gpp$Model[i] <- model
  cmip_gpp$Value[i] <- value
}

write_csv(cmip_gpp, here("data/coefVar_cmip_gpp.csv"))

### NBP:
cmip_nbp <- tibble(Model = character(length(files_cmip_nbp)), Value = numeric(length(files_cmip_nbp)))

for (i in 1:length(files_cmip_nbp)){
  model  <- sub("_S3_nbp_var_coef.txt", "", files_cmip_nbp[i])
  value <- read_csv(here(paste("../data/CMIP6/var_coef/as_txt/", files_cmip_nbp[i], sep = "")), col_names = FALSE)[[1]][1]
  cmip_nbp$Model[i] <- model
  cmip_nbp$Value[i] <- value
}

write_csv(cmip_nbp, here("data/coefVar_cmip_nbp.csv"))

## Plotting Histograms
### GPP:
#### Calculating the optimal binwidth based on Sturge's method:
x <- cmip_gpp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_cmip_gpp <- ggplot(data= cmip_gpp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth = bw, fill = "darkseagreen4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_cmip_gpp.png"), plot= p_cmip_gpp,width = 14, height = 10, dpi = 300)

### NBP:

#### Calculating the optimal binwidth based on Sturge's method:
x <- cmip_nbp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_cmip_nbp <- ggplot(data= cmip_nbp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth= bw, fill = "deepskyblue4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_cmip_nbp.png"), plot= p_cmip_nbp,width = 14, height = 10, dpi = 300)





### MsTMIP SG1 -------------------------------------------------------------------
# Load Data
mstmip_sg1_gpp <- read_csv("data/coefVar_mstmip_sg1_gpp.txt")
mstmip_sg1_nbp <- read_csv("data/coefVar_mstmip_sg1_nbp.txt")


## Plotting Histograms
### GPP:
#### Calculating the optimal binwidth based on Sturge's method:
x <- mstmip_sg1_gpp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_mstmip_sg1_gpp <- ggplot(data= mstmip_sg1_gpp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth = bw, fill = "darkseagreen4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_mstmip_sg1_gpp.png"), plot= p_mstmip_sg1_gpp,width = 14, height = 10, dpi = 300)

### NBP:

#### Calculating the optimal binwidth based on Sturge's method:
x <- mstmip_sg1_nbp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_mstmip_sg1_nbp <- ggplot(data= mstmip_sg1_nbp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth= bw, fill = "deepskyblue4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_mstmip_sg1_nbp.png"), plot= p_mstmip_sg1_nbp,width = 14, height = 10, dpi = 300)



### MsTMIP SG3 -------------------------------------------------------------------
# Load Data
mstmip_sg3_gpp <- read_csv("data/coefVar_mstmip_sg3_gpp.txt")
mstmip_sg3_nbp <- read_csv("data/coefVar_mstmip_sg3_nbp.txt")


## Plotting Histograms
### GPP:
#### Calculating the optimal binwidth based on Sturge's method:
x <- mstmip_sg3_gpp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_mstmip_sg3_gpp <- ggplot(data= mstmip_sg3_gpp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth = bw, fill = "darkseagreen4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_mstmip_sg3_gpp.png"), plot= p_mstmip_sg3_gpp,width = 14, height = 10, dpi = 300)

### NBP:

#### Calculating the optimal binwidth based on Sturge's method:
x <- mstmip_sg3_nbp$Value

k <- nclass.Sturges(x)
bw <- diff(range(x, na.rm = TRUE)) / k

p_mstmip_sg3_nbp <- ggplot(data= mstmip_sg3_nbp, aes(x= Value)) +
  geom_histogram(aes(y= after_stat(count / sum(count))), binwidth= bw, fill = "deepskyblue4", color = "black") +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)) +
  labs(
    y = "Density",
    x = expression(~PgC~yr^{-1})
  )

ggsave(here("figures/coefVar_mstmip_sg3_nbp.png"), plot= p_mstmip_sg3_nbp,width = 14, height = 10, dpi = 300)

