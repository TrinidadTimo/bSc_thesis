# Load libraries
library(tidyverse)
library(rsample)     # bootstraps()
library(broom)       # augment()
library(MASS)        # rlm()
library(scales)      # label formatting
library(ggrepel)     # for adding labels

## Read data -------------------------------------------------------------------
# Loading TRENDY S3
trendy <- read_table(here("data/iavar_trendy.txt"), col_names = FALSE)
colnames(trendy) <- c("Model", "IAVAR_GPP", "IAVAR_NBP")

# Loading CMIP6
cmip <- read_csv(here("data/iavar_cmip.txt"), col_types = cols(IAVAR_GPP = col_number(), IAVAR_NBP = col_number()))

# Loading MsTMIP SG1
mstmip_sg1 <- read_csv(here("data/iavar_mstmip_sg1.csv"))

# Loading MsTMIP SG3
mstmip_sg3 <- read_csv(here("data/iavar_mstmip_sg3.csv"))

df <- trendy %>%
  filter (!(Model %in% c("ISBA-CTRIP"))) %>% # ISBA has 0 in both variables -> did not process properly.
  bind_rows(cmip) %>%
  bind_rows(mstmip_sg1) %>%
  bind_rows(mstmip_sg3) %>%
  mutate(
    source = c(rep("TRENDY, S3", 17), rep("CMIP6, historical", 21), rep("MsTMIP, SG1", 13), rep("MsTMIP, SG3", 12)))

# Loading fluxcom
fluxcom <- read_delim(here("data/iavar_fluxcom.txt"), delim = ";", escape_double = FALSE, trim_ws = TRUE) %>%
  mutate(Model = "Fluxcom")

# Loading P-Model
pMod <- read_csv(here("data/iavar_pMod.txt")) %>%
  mutate(Model = "P-Model")

# GCB SLAND Res.
gcb_sLand <- read_csv(here("data/iavar_gcb_sLand.csv")) %>% rename(IAVAR_NBP = `IAVAR Res. SLAND`) %>%
  mutate(Model = "GCB SLand Res.",
         IAVAR_GPP = NA)

df_lines <- fluxcom %>% bind_rows(pMod, gcb_sLand)


## Bootstrapped robust regression ----------------------------------------------
# 2. Create prediction grid
df_filtered <- df %>% filter(source != "MsTMIP, SG1") #exclude SG1

grid <- tibble(IAVAR_GPP = seq(min(df_filtered$IAVAR_GPP), max(df_filtered$IAVAR_GPP), length.out = 100))

# 3. Create bootstrap resamples using rsample
n_boot <- 1000
boot_resamples <-bootstraps(df_filtered, times = n_boot)

# 4. Bootstrap Robust Regression (Huber)
boot_preds <- boot_resamples %>%
  mutate(
    model = map(splits, ~ rlm(IAVAR_NBP ~ IAVAR_GPP, data = analysis(.x), maxit = 100)),
    preds = map(model, ~ augment(.x, newdata = grid))
  ) %>%
  tidyr::unnest(preds) %>%
  dplyr::select(id, IAVAR_GPP, .fitted)

# 5. Summarize predictions: mean + 95% CI
pred_summary <- boot_preds %>%
  group_by(IAVAR_GPP) %>%
  summarise(
    y_mean = mean(.fitted),
    y_lower = quantile(.fitted, 0.025),
    y_upper = quantile(.fitted, 0.975),
    .groups = "drop"
  )

# Slope mean:
s <- (pred_summary$y_mean[2] - pred_summary$y_mean[1])/(pred_summary$IAVAR_GPP[2] - pred_summary$IAVAR_GPP[1])
# intercept:
i <- pred_summary$y_mean[1]


# Plot

pred_summary$group <- "Linear Fit"
fluxcom$group <- "Fluxcom"
pMod$group <- "pMod"


p_constraint <- ggplot() +
  # Bootstrapped robust regression distribution
  ## 95% prediction interval:
  geom_ribbon(
    data = pred_summary,
    aes(x = IAVAR_GPP, ymin = y_lower, ymax = y_upper),
    fill = "cornflowerblue",
    alpha = 0.2
  ) +
  ## bootstrapped distribution mean:
  geom_line(data = pred_summary, aes(x = IAVAR_GPP, y = y_mean, linetype = "Bootstrapped robust regression, \nMedian (slope = 0.35)"), size = 0.75, color= "cornflowerblue") +
  geom_hline(yintercept= gcb_sLand$IAVAR_NBP, color= "coral2", size= 0.75, show.legend = FALSE) +
  geom_point(
    data = df,
    aes(x= IAVAR_GPP, y= IAVAR_NBP, shape = source, color = source),
    alpha = 0.7, size= 2
  ) +
  geom_vline(data= fluxcom, aes(xintercept= IAVAR_GPP), size= 0.75, linetype= "dashed", color= "cadetblue3") +
  geom_vline(data= pMod, aes(xintercept= IAVAR_GPP), size= 0.75, linetype= "dashed", color= "cadetblue4") +
  coord_fixed(ratio = 1) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.position = c(0.49, 0.78),
    legend.justification = c("right", "bottom"),
    legend.background = element_blank(),
    legend.box.background = element_blank(),
    legend.text = element_text(size = 13),
    legend.title = element_text(size = 10),
    panel.border = element_rect(color = "black", fill = NA, size = 0.8)) +
  labs(
    y = expression(IAV[NBP] ~(PgC~yr^{-1})),
    x = expression(IAV[GPP] ~(PgC~yr^{-1}))
  ) +
  scale_color_manual(
    name = NULL,
    values = c(
      "CMIP6, historical" = "black",
      "MsTMIP, SG1" = "brown",
      "MsTMIP, SG3" = "darkorange3",
      "TRENDY, S3" = "red"
    )
  ) +
  scale_linetype_manual(
    name = NULL,
    values = c(
      "Bootstrapped robust regression, \nMedian (slope = 0.35)" = "solid"
    )) +
  scale_shape_manual(
    name = NULL,
    values = c(
      "CMIP6, historical" = 16,
      "MsTMIP, SG1" = 17,
      "MsTMIP, SG3" = 15,
      "TRENDY, S3" = 3
    )) +
  geom_text(aes(x = pMod$IAVAR_GPP, y = 6.1,
                label = "P-MODEL"),
            angle = 90, vjust = 1.75, hjust = 0.5, size = 4, color = "cadetblue4") +
  geom_text(aes(x = fluxcom$IAVAR_GPP, y = 6.1,
                label = "FLUXCOM"),
            angle = 90, vjust = 1.75, hjust = 0.5, size = 4, color = "cadetblue3") +
  geom_text(aes(x = 9, y = gcb_sLand$IAVAR_NBP,
                label = "GCB Residual Land Sink"),
            angle = 0, vjust = -0.5, hjust = 0, size = 4, color = "coral2") +
  scale_x_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 15, by= 1.5)) +
  scale_y_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5) )

# Save as R data to use in other scripts:
saveRDS(p_constraint, file = here("data/constraint_plot.rds"))


# Save as Image:
ggsave(here("figures/emergent_constraint.png"), plot= p_constraint,width = 14, height = 10, dpi = 300)
