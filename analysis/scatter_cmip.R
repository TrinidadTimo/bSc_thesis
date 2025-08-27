# Load libraries
library(here)
library(ggplot2)
library(dplyr)
library(readr)
library(MASS)
library(ggrepel)


## Read data -------------------------------------------------------------------
cmip <- read_csv("/home/ttrinidad/../../data_2/scratch/ttrinidad/bachelor_thesis/data/iavar_cmip.txt")

## Bootstrapped robust regression ----------------------------------------------
# 2. Create prediction grid
grid <- tibble(IAVAR_GPP = seq(min(cmip$IAVAR_GPP), max(cmip$IAVAR_GPP), length.out = 100))

# 3. Create bootstrap resamples using rsample
n_boot <- 1000
boot_resamples <- bootstraps(cmip, times = n_boot)

# 4. Bootstrap Robust Regression (Huber)
boot_preds <- boot_resamples %>%
  mutate(
    model = map(splits, ~ rlm(IAVAR_NBP ~ IAVAR_GPP, data = analysis(.x), maxit = 100)),
    preds = map(model, ~ augment(.x, newdata = grid))
  ) |>
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
s_cmip <- (pred_summary$y_mean[2] - pred_summary$y_mean[1])/(pred_summary$IAVAR_GPP[2] - pred_summary$IAVAR_GPP[1])
# intercept:
i_cmip <- pred_summary$y_mean[1]
## Plotting -------------------------------------------------------------------

p_cmip <-ggplot() +
  geom_ribbon(data = pred_summary, aes(x = IAVAR_GPP, ymin = y_lower, ymax = y_upper),
              fill = "cornflowerblue",
              alpha = 0.2
  ) +
  geom_point(data= cmip, aes(x= IAVAR_GPP, y= IAVAR_NBP), shape= 16, color= "black") +
  geom_line(data = pred_summary, aes(x = IAVAR_GPP, y = y_mean, color = "Bootstrapped robust regression mean (slope = 0.28)"), size = 0.75) +
  geom_text_repel(data= cmip, aes(x= IAVAR_GPP, y= IAVAR_NBP, label= Model), size = 2.5, max.overlaps = 20, color= "darkgrey") +
  scale_color_manual(
    name = NULL,
    values = c(
      "Bootstrapped robust regression mean (slope = 0.28)" = "cornflowerblue")
  ) +
  labs(
    y = expression(IAV[NBP] ~(PgC~yr^{-1})),
    x = expression(IAV[GPP] ~(PgC~yr^{-1}))
  ) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.text= element_text(size= 13),
    legend.position = c(0.9, 0.93),
    legend.justification = c("right", "bottom"),
    legend.background = element_blank(),
    legend.box.background = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, size = 0.8)) +
  scale_x_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0, 7.5)) +
  scale_y_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0, 7.5) ) +
  coord_fixed(ratio= 1)


# Save as R data to use in other scripts
saveRDS(p_cmip, file = "data/scatter_cmip.rds")

# Save image:
ggsave(here("figures/scatter_cmip.png"), plot= p_cmip,width = 14, height = 10, dpi = 300)

