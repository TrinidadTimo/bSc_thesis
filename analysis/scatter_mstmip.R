# Load libraries
library(here)
library(ggplot2)
library(dplyr)
library(readr)
library(MASS)
library(ggrepel)


## Read data -------------------------------------------------------------------
mstmip_sg1 <- read_csv("/home/ttrinidad/../../data_2/scratch/ttrinidad/bachelor_thesis/data/iavar_mstmip_sg1.csv")  %>%
  mutate("Simulation" = "SG1")
mstmip_sg3 <- read_csv("/home/ttrinidad/../../data_2/scratch/ttrinidad/bachelor_thesis/data/iavar_mstmip_sg3.csv") %>%
  mutate("Simulation" = "SG3")

mstmip <- mstmip_sg1 %>% bind_rows(mstmip_sg3)

## Preplot ----------------------------------------
ggplot(data= mstmip, aes(x= IAVAR_GPP, y= IAVAR_NBP, color= Simulation, label = Model)) +
  geom_abline(slope= 1, intercept= 0, alpha= 0.5) +
  geom_point() +
  geom_text_repel(size= 1.5) +
  scale_x_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0,4.5)) +
  scale_y_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0, 4.5) ) +
  coord_fixed(ratio= 1)

## Bootstrapped robust regression ----------------------------------------------

## SG1:
# Create prediction grid
grid <- tibble(IAVAR_GPP = seq(min(mstmip_sg1$IAVAR_GPP), max(mstmip_sg1$IAVAR_GPP), length.out = 100))

# Create bootstrap resamples using rsample
n_boot <- 1000
boot_resamples_sg1 <- bootstraps(mstmip_sg1, times = n_boot)

# Bootstrap Robust Regression (Huber)
boot_preds_sg1 <- boot_resamples_sg1 %>%
  mutate(
    model = map(splits, ~ rlm(IAVAR_NBP ~ IAVAR_GPP, data = analysis(.x), maxit = 100)),
    preds = map(model, ~ augment(.x, newdata = grid))
  ) |>
  tidyr::unnest(preds) %>%
  dplyr::select(id, IAVAR_GPP, .fitted)

# Summarize predictions: mean + 95% CI
pred_summary_sg1 <- boot_preds_sg1 %>%
  group_by(IAVAR_GPP) %>%
  summarise(
    y_mean = mean(.fitted),
    y_lower = quantile(.fitted, 0.025),
    y_upper = quantile(.fitted, 0.975),
    .groups = "drop"
  )
# Slope mean:
s_sg1 <- (pred_summary_sg1$y_mean[2] - pred_summary_sg1$y_mean[1])/(pred_summary_sg1$IAVAR_GPP[2] - pred_summary_sg1$IAVAR_GPP[1])
# intercept:
i_sg1 <- pred_summary_sg1$y_mean[1]



## SG3:
# Create prediction grid
grid <- tibble(IAVAR_GPP = seq(min(mstmip_sg3$IAVAR_GPP), max(mstmip_sg3$IAVAR_GPP), length.out = 100))

# Create bootstrap resamples using rsample
n_boot <- 1000
boot_resamples_sg3 <- bootstraps(mstmip_sg3, times = n_boot)

# Bootstrap Robust Regression (Huber)
boot_preds_sg3 <- boot_resamples_sg3 %>%
  mutate(
    model = map(splits, ~ rlm(IAVAR_NBP ~ IAVAR_GPP, data = analysis(.x), maxit = 100)),
    preds = map(model, ~ augment(.x, newdata = grid))
  ) |>
  tidyr::unnest(preds) %>%
  dplyr::select(id, IAVAR_GPP, .fitted)

# Summarize predictions: mean + 95% CI
pred_summary_sg3 <- boot_preds_sg3 %>%
  group_by(IAVAR_GPP) %>%
  summarise(
    y_mean = mean(.fitted),
    y_lower = quantile(.fitted, 0.025),
    y_upper = quantile(.fitted, 0.975),
    .groups = "drop"
  )
# Slope mean:
s_sg3 <- (pred_summary_sg3$y_mean[2] - pred_summary_sg3$y_mean[1])/(pred_summary_sg3$IAVAR_GPP[2] - pred_summary_sg3$IAVAR_GPP[1])
# intercept:
i_sg3 <- pred_summary_sg3$y_mean[1]

## Plotting -------------------------------------------------------------------

p_mstmip <- ggplot() +
  geom_ribbon(data = pred_summary_sg1, aes(x = IAVAR_GPP, ymin = y_lower, ymax = y_upper),
              fill = "cornflowerblue",
              alpha = 0.2
  ) +
  geom_ribbon(data = pred_summary_sg3, aes(x = IAVAR_GPP, ymin = y_lower, ymax = y_upper),
              fill = "green",
              alpha = 0.3
  ) +
  geom_point(data= mstmip_sg1, aes(x= IAVAR_GPP, y= IAVAR_NBP, color= "SG1"), shape= 17) +
  geom_point(data= mstmip_sg3, aes(x= IAVAR_GPP, y= IAVAR_NBP, color= "SG3"), shape= 15) +
  geom_line(data = pred_summary_sg1, aes(x = IAVAR_GPP, y = y_mean, linetype = "Slope SG1 = 0.17"), linewidth = 1, alpha= 0.8, color= "cornflowerblue") +
  geom_line(data = pred_summary_sg3, aes(x = IAVAR_GPP, y = y_mean, linetype = "Slope SG3 = 0.19"), linewidth = 1, color= "darkgreen") +
  geom_text_repel(data= mstmip, aes(x= IAVAR_GPP, y= IAVAR_NBP, label= Model), size = 2, max.overlaps = 20, color= "darkgrey") +
  scale_linetype_manual(
    name= "Bootstapped robust regression mean:",
    values= c(
      "Slope SG1 = 0.17" = "solid",
      "Slope SG3 = 0.19" = "solid"
    )
    )+
  scale_color_manual(
     name = NULL,
     values = c(
      "SG1" = "brown",
       "SG3" = "darkorange")
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
    legend.position = c(0.95, 0.8),
    legend.justification = c("right", "bottom"),
    legend.background = element_blank(),
    legend.box.background = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, size = 0.8)) +
  scale_x_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0,4.5)) +
  scale_y_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0, 3) ) +
  coord_fixed(ratio= 1)

# Save as R data to use in other scripts
saveRDS(p_mstmip, file = "data/scatter_mstmip.rds")

# Save image:
ggsave(here("figures/scatter_mstmip.png"), plot= p_mstmip,width = 14, height = 10, dpi = 300)


