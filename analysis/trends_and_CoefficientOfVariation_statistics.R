# Loading Libraries
library(here)

# TRENDY -------------------------------------
## Trends:
### Loading Data:
annualAbs_trendy_gpp <- read_csv("data/trendy_S3_gpp_glob.csv")[,-1]
annualAbs_trendy_nbp <- read_csv("data/trendy_S3_nbp_glob.csv")[,-c(1,2)]

### Extracting Slope Coefficient of linear regression for each Model & storing in df:
trends_trendy <- tibble("Model" = colnames(trendy_gpp)[-1], "GPP" = as.numeric(NA), "NBP" = as.numeric(NA))

#### GPP:
for(i in 2:ncol(trendy_gpp)) {
  trends_trendy$GPP[i-1] <- summary(lm(annualAbs_trendy_gpp[[i]] ~ annualAbs_trendy_gpp$year))$coefficients[2,1]
}

#### NBP:
for(i in 2:ncol(trendy_nbp)) {
  trends_trendy$NBP[i-1] <- summary(lm(annualAbs_trendy_nbp[[i]] ~ annualAbs_trendy_nbp$year))$coefficients[2,1]
}


### VarCoef:
coefVar_trendy_gpp <- read_csv(here("data/coefVar_trendy_gpp.csv"))
coefVar_trendy_nbp <- read_csv(here("data/coefVar_trendy_nbp.csv"))



# CMIP -------------------------------------------------------------
## Trends:
### Loading Data:
annualAbs_cmip_gpp <- read_csv("data/cmip_gpp_glob.csv")[,-1]
annualAbs_cmip_nbp <- read_csv("data/cmip_nbp_glob.csv")[,-1]

### Extracting Slope Coefficient of linear regression for each Model & storing in df:
trends_cmip <- tibble("Model" = colnames(annualAbs_cmip_gpp)[-1], "GPP" = as.numeric(NA), "NBP" = as.numeric(NA))

#### GPP:
for(i in 2:ncol(annualAbs_cmip_gpp)) {
  trends_cmip$GPP[i-1] <- summary(lm(annualAbs_cmip_gpp[[i]] ~ annualAbs_cmip_gpp$year))$coefficients[2,1]
}

trends_cmip[order(trends_cmip$GPP),]

#### NBP:
for(i in 2:ncol(annualAbs_cmip_nbp)) {
  trends_cmip$NBP[i-1] <- summary(lm(annualAbs_cmip_nbp[[i]] ~ annualAbs_cmip_nbp$year))$coefficients[2,1]
}

trends_cmip[order(trends_cmip$NBP),]

## VarCoef:

coefVar_cmip_gpp <- read_csv(here("data/coefVar_cmip_gpp.csv")) %>% dplyr::filter(!Model %in% "GISS-E2-2-H") %>% mutate(Model = sub("_gpp_var_coef\\.txt$", "", Model))
coefVar_cmip_nbp <- read_csv(here("data/coefVar_cmip_nbp.csv")) %>% dplyr::filter(!Model %in% "GISS-E2-2-H") %>% mutate(Model = sub("_nbp_var_coef\\.txt$", "", Model))

coefVar_cmip_gpp_sorted <- coefVar_cmip_gpp[order(-coefVar_cmip_gpp$Value),] %>% mutate("Rank_GPP" = 1:nrow(.))
coefVar_cmip_nbp_sorted <- coefVar_cmip_nbp[order(-coefVar_cmip_nbp$Value),] %>% mutate("Rank_NBP" = 1:nrow(.))

rank_cmp_cmip <- coefVar_cmip_gpp_sorted[, c(1,3)] %>% left_join(coefVar_cmip_nbp_sorted[ ,c(1,3)], by = "Model") %>% mutate( "Rank Dif." = Rank_GPP - Rank_NBP)

cor.test(x= rank_cmp_cmip$Rank_GPP, y= rank_cmp_cmip$Rank_NBP, method = "spearman")



# MsTMIP SG1 -----------------------------------------------------------------
## Trends:
### Loading Data:
annualAbs_mstmip_sg1_gpp <- read_csv("data/mstmip_sg1_gpp_glob.csv")[,-1]
annualAbs_mstmip_sg1_nbp <- read_csv("data/mstmip_sg1_nbp_glob.csv")[,-1]

### Extracting Slope Coefficient of linear regression for each Model & storing in df:
trends_mstmip_sg1 <- tibble("Model" = colnames(annualAbs_mstmip_sg1_gpp)[-1], "GPP" = as.numeric(NA), "NBP" = as.numeric(NA))

#### GPP:
for(i in 2:ncol(annualAbs_mstmip_sg1_gpp)) {
  trends_mstmip_sg1$GPP[i-1] <- summary(lm(annualAbs_mstmip_sg1_gpp[[i]] ~ annualAbs_mstmip_sg1_gpp$year))$coefficients[2,1]
}

trends_mstmip_sg1[order(trends_mstmip_sg1$GPP),]

#### NBP:
for(i in 2:ncol(annualAbs_mstmip_sg1_nbp)) {
  trends_mstmip_sg1$NBP[i-1] <- summary(lm(annualAbs_mstmip_sg1_nbp[[i]] ~ annualAbs_mstmip_sg1_nbp$year))$coefficients[2,1]
}


trends_mstmip_sg1[order(trends_mstmip_sg1$NBP),]

## VarCoef:

coefVar_mstmip_sg1_gpp <- read_csv(here("data/coefVar_mstmip_sg1_gpp.txt"))
coefVar_mstmip_sg1_nbp <- read_csv(here("data/coefVar_mstmip_sg1_nbp.txt"))

coefVar_mstmip_sg1_gpp_sorted <- coefVar_mstmip_sg1_gpp[order(-coefVar_mstmip_sg1_gpp$Value),] %>% mutate("Rank_GPP" = 1:nrow(.))
coefVar_mstmip_sg1_nbp_sorted <- coefVar_mstmip_sg1_nbp[order(-coefVar_mstmip_sg1_nbp$Value),] %>% mutate("Rank_NBP" = 1:nrow(.))

rank_cmp_mstmip_sg1 <- coefVar_mstmip_sg1_gpp_sorted[, c(1,3)] %>% left_join(coefVar_mstmip_sg1_nbp_sorted[ ,c(1,3)], by = "Model") %>% mutate( "Rank Dif." = Rank_GPP - Rank_NBP)

cor.test(x= rank_cmp_mstmip_sg1$Rank_GPP, y= rank_cmp_mstmip_sg1$Rank_NBP, method = "spearman")


# MsTMIP SG3 -----------------------------------------------------------------
## Trends:
### Loading Data:
annualAbs_mstmip_sg3_gpp <- read_csv("data/mstmip_sg3_gpp_glob.csv")[,-1]
annualAbs_mstmip_sg3_nbp <- read_csv("data/mstmip_sg3_nbp_glob.csv")[,-1]

### Extracting Slope Coefficient of linear regression for each Model & storing in df:
trends_mstmip_sg3 <- tibble("Model" = colnames(annualAbs_mstmip_sg3_gpp)[-1], "GPP" = as.numeric(NA), "NBP" = as.numeric(NA))

#### GPP:
for(i in 2:ncol(annualAbs_mstmip_sg3_gpp)) {
  trends_mstmip_sg3$GPP[i-1] <- summary(lm(annualAbs_mstmip_sg3_gpp[[i]] ~ annualAbs_mstmip_sg3_gpp$year))$coefficients[2,1]
}

trends_mstmip_sg3[order(trends_mstmip_sg3$GPP),]

#### NBP:
for(i in 2:ncol(annualAbs_mstmip_sg3_nbp)) {
  trends_mstmip_sg3$NBP[i-1] <- summary(lm(annualAbs_mstmip_sg3_nbp[[i]] ~ annualAbs_mstmip_sg3_nbp$year))$coefficients[2,1]
}


trends_mstmip_sg3[order(trends_mstmip_sg3$NBP),]

### VarCoef:
coefVar_mstmip_sg3_gpp <- read_csv(here("data/coefVar_mstmip_sg3_gpp.txt"))
coefVar_mstmip_sg3_nbp <- read_csv(here("data/coefVar_mstmip_sg3_nbp.txt"))

coefVar_mstmip_sg3_gpp_sorted <- coefVar_mstmip_sg3_gpp[order(-coefVar_mstmip_sg3_gpp$Value),] %>% mutate("Rank_GPP" = 1:nrow(.))
coefVar_mstmip_sg3_nbp_sorted <- coefVar_mstmip_sg3_nbp[order(-coefVar_mstmip_sg3_nbp$Value),] %>% mutate("Rank_NBP" = 1:nrow(.))

rank_cmp_mstmip_sg3 <- coefVar_mstmip_sg3_gpp_sorted[, c(1,3)] %>% left_join(coefVar_mstmip_sg3_nbp_sorted[ ,c(1,3)], by = "Model") %>% mutate( "Rank Dif." = Rank_GPP - Rank_NBP)

cor.test(x= rank_cmp_mstmip_sg3$Rank_GPP, y= rank_cmp_mstmip_sg3$Rank_NBP, method = "spearman")
