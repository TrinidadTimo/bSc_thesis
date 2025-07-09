library(here)
library(ggplot2)
library(dplyr)
library(ggpmisc)
library(readr)

# Loading TRENDY IAVAR table
trendy <- read_delim("data/iavar_trendy.txt", delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
colnames(trendy) <- c("Model", "IAVAR_GPP", "IAVAR_NBP")

# Loading CMIP6 table
cmip <- read_csv("data/iavar_cmip.txt", col_types = cols(IAVAR_GPP = col_number(), IAVAR_NBP = col_number()))

# Loading FLUXCOM GPP IAVAR
fluxcom <- read_delim("data/iavar_fluxcom.txt", delim = ";", escape_double = FALSE, trim_ws = TRUE)

# Loading P-Mod S1b GPP IAVAR
pMod <- read_csv("data/iavar_pMod.txt")
p.mod$IAVAR_NBP <- 0.05 # Defining an artificial NBP value to place in the plot.

# Loading (and extracting) GCP obs. NBP IAVAR
nbp_obs <- as.numeric(read_csv("data/iavar_gcb.txt",
                          col_names = FALSE)[1,1])


# Building an overall table including TRENDY, CMIP6, Fluxcom
trendy$Model.Group <- rep("TRENDY-v12 S3", nrow(trendy))
cmip$Model.Group <- rep("CMIP6, historical", nrow(cmip))
fluxcom$Model.Group <- rep("FLUXCOM", nrow(fluxcom))

df <- trendy |>
  filter (!(Model %in% c("ISBA-CTRIP"))) |> # ISBA has 0 value in both variables.
  bind_rows(cmip, fluxcom)

# Regression coefficients:
fit <- df |> filter( !(Model %in% c("MPI-ESM-1-2-HAM"))) |> lm(formula= IAVAR_GPP ~ IAVAR_NBP, data= _)
intercept <- coef(fit)[1]
slope <- coef(fit)[2]
rsq <- summary(fit)$r.squared
label_rsq <- bquote("linear fit, " ~ italic(R)^2 ~ "=" ~ .(round(rsq, 2)))
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
