library(here)
library(ggplot2)
library(dplyr)
library(ggpmisc)
library(readr)

# Loading TRENDY IAVAR table
trendy <- read.delim(here("../data/trendy/S3/iavar/R/IAVAR_R.txt"), header=FALSE)
colnames(trendy) <- c("Model", "IAVAR_GPP", "IAVAR_NBP")

# Loading CMIP6 table
cmip <- read.csv(here("../data/CMIP6/IAVAR/IAVAR_CMIP6.csv"), dec=",")
cmip$IAVAR_GPP <- as.numeric(cmip$IAVAR_GPP)
cmip$IAVAR_NBP <- as.numeric(cmip$IAVAR_NBP)

# Loading FLUXCOM GPP IAVAR
fluxcom <- read.csv(here("../data/rs_models/FLUXCOM/raw/GPP/ENS/processed/IAV.1982_2011.txt"), sep=";")

# Loading P-Mod S1b GPP IAVAR
p.mod <- read.csv("/data_2/scratch/ttrinidad/data/rs_models/P-Mod/IAVAR/s1b_fapar3g_v2_global.d.gpp_IAVAR.txt")
p.mod$IAVAR_NBP <- 0.05

# Loading (and extracting) GCP obs. NBP IAVAR
nbp_obs <- as.numeric(read_csv("/data_2/scratch/ttrinidad/data/GCP/IAVAR_NBP_obs.csv",
                          col_names = FALSE)[1,1])


# Building an overall table including TRENDY, CMIP6, (Fluxcom?)
trendy$Model.Group <- rep("TRENDY-v12 S3", nrow(trendy))
cmip$Model.Group <- rep("CMIP6, historical", nrow(cmip))

df <- trendy |>
  filter (!(Model %in% c("ISBA-CTRIP"))) |>
  bind_rows(cmip)

# Regression coefficients:
fit <- df |> filter( !(Model %in% c("MPI-ESM-1-2-HAM"))) |> lm(formula= IAVAR_GPP ~ IAVAR_NBP, data= _)
intercept <- coef(fit)[1]
slope <- coef(fit)[2]
rsq <- summary(fit)$r.squared
label_rsq <- bquote("linear fit, " ~ italic(R)^2 ~ "=" ~ .(round(rsq, 2)))

## Bootstrapping:
fit <- lm(formula= IAVAR_GPP ~ IAVAR_NBP, data= df)
res_df <- residuals(fit)
B <- 1000
n <- nrow(df)
residual_matrix <- matrix(NA, nrow = n, ncol = B)

set.seed(123)  # Reproduzierbarkeit

for (b in 1:B) {
  idx <- sample(1:n, size = n, replace = TRUE)
  df_b <- df[idx, ]
  model_b <- lm(formula= IAVAR_GPP ~ IAVAR_NBP, data = df_b)

  # Residuen am Original-Datensatz
  preds <- predict(model_b, newdata = df)
  residuals_b <- df$IAVAR_GPP - preds
  residual_matrix[, b] <- residuals_b
}

lower <- apply(residual_matrix, 1, quantile, probs = 0.025)
upper <- apply(residual_matrix, 1, quantile, probs = 0.975)

outliers_q <- which(res_df < lower | res_df > upper)





# Creating another df, which will be used for a clean legend in the following plot:
legend_df <- data.frame(
  type  = c("CMIP6, historical", "TRENDY-v12 S3", "P-Modell", "GCB SLAND"),
  x     = NA,   # Werte egal, da nur für Legende
  y     = NA,
  color = c("#F4A261", "#B96BA3", "black", "grey50"),
  shape = c(16, 17, 8, NA),
  linetype = c(NA, NA, NA, "dashed"),
  size  = c(1.5, 1.5, 2, 0.5)
)

# Plot
ggplot(df, aes(x = IAVAR_NBP, y = IAVAR_GPP)) +
  geom_point(aes(color = Model.Group, shape = Model.Group), size = 1.5) +
  # Regression TRENDY/CMIP GPP NBP:
  geom_abline(aes(slope= slope, intercept= intercept, linetype= "linear fit"),
              color= "red", size= 0.5) +
  # Confidence band:
  geom_smooth(data = df, aes(x = IAVAR_NBP, y = IAVAR_GPP),
              method = "lm", se = TRUE, level = 0.95,
              color = NA, fill = "pink", alpha = 0.3, show.legend = FALSE) +
  # GCB:
  geom_vline(aes(xintercept= nbp_obs, linetype= "GCB"), color= "darkgrey") +
  scale_linetype_manual(values = c("regression" = "solid", "GCB" = "dashed")) +

  # Legendenlabel dynamisch ersetzen
  scale_linetype_discrete(labels = c(
    "linear fit" = label_rsq,
    "GCB SLand" = "GCB"
  )) +
  # P-Mod:
  geom_point(data= p.mod, aes(x= IAVAR_NBP, y= IAVAR_GPP), shape = 8, size = 2, color = "black") +

  # Labs:
  labs(
    title = " ",
    x = expression(sigma[NBP]~(PgC~yr^{-1})),
    y = expression(sigma[GPP]~(PgC~yr^{-1})),
  ) +

  # Adjust Colors:
  scale_color_manual(values = c("CMIP6, historical" =  "#F4A261", "TRENDYv12 S3" = "#B96BA3")) +
  #Plot and Legend Theme:
  theme_bw() +
  theme(
    legend.text = element_text(size = 8),
    legend.position = c(0.8, 0.15),
    legend.background = element_blank(),
    legend.box.background = element_blank(),  # Kein Rahmen
    legend.title = element_blank(),
    panel.grid = element_blank()
  )




  # Axis scaling:
  coord_fixed(ratio = 1) +
  xlim(0,6) + ylim(0,6) +

  # Legend:
  scale_shape_manual(values = c("TRENDYv12 S3" = 16, "CMIP6, historical" = 17, "P-model" = 8)) +
  scale_color_manual(values = c("TRENDYv12 S3" = "#1f78b4", "CMIP6, historical" = "#33a02c", "P-model" = "black")) +
  scale_linetype_manual(name = "", values = c("Regression" = "solid"))
  labs(
    title = " ",
    x = expression(sigma[GPP]~(PgC~yr^{-1})),
    y = expression(sigma[NBP]~(PgC~yr^{-1})),
  ) +
  geom_smooth(method = "lm", aes(group = 1), fullrange= TRUE, se= TRUE, color = "black", linewidth= 0.5) +
  stat_poly_eq(
    aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~"), group = 1),
    formula = y ~ x, parse = TRUE,
    label.x.npc = 0.95,
    label.y.npc = 0.95,
    size = 3, color = "black"
  ) +
  geom_vline(xintercept= nbp_obs, color= "grey") +
  coord_cartesian(xlim = c(0,6), ylim = c(0,6)) +
  geom_hline(yintercept= p.mod[1,2], linetype= "dashed", color= "red") +
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    legend.position = c(0.8, 0.8),
    legend.title = element_blank(),
    legend.background = element_blank()
  )


# To DO
# - Title
# - Legend-Fit
# -
