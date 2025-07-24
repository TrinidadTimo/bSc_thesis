# Load libraries
library(here)
library(ggplot2)
library(dplyr)
library(readr)
library(MASS)
library(ggrepel)


## Read data -------------------------------------------------------------------
trendy <- read_delim(here("data/iavar_trendy.txt"), delim = "\t", escape_double = FALSE, col_names = c("Model", "IAVAR_GPP", "IAVAR_NBP"), trim_ws = TRUE) %>% filter(Model != "ISBA-CTRIP")


## Bootstrapped robust regression ----------------------------------------------

### Raster für Vorhersagen
grid <- tibble(
  IAVAR_GPP = seq(min(trendy$IAVAR_GPP), max(trendy$IAVAR_GPP), length.out = 100)
)

### Hilfsfunktion: 1 Bootstrap → Rückgabe tibble(.fitted, id) ODER NULL
one_boot <- function(data, grid, id_tag) {
  boot <- bootstraps(data, times = 1)$splits[[1]]
  fit  <- rlm(IAVAR_NBP ~ IAVAR_GPP, data = analysis(boot), maxit = 100)
  preds <- augment(fit, newdata = grid) |>
    mutate(id = id_tag)

  # Gültigkeitskriterium: keine negativen Vorhersagen
  if (all(preds$.fitted >= 0))
    return(preds)
  else
    return(NULL)         # -> verwerfen
}

get_valid_preds <- function(df, grid, n_valid, group_name = "GROUP", seed = 123) {
  set.seed(seed)
  keep      <- list()
  n_kept    <- 0
  runningID <- 1

  while (n_kept < n_valid) {
    id_tag <- sprintf("%s_%04d", group_name, runningID)
    pred   <- one_boot(df, grid, id_tag)

    if (!is.null(pred)) {
      keep[[n_kept + 1]] <- pred
      n_kept <- n_kept + 1
    }
    runningID <- runningID + 1
  }
  bind_rows(keep)
}


## TRENDY:
boot_preds_trendy <- get_valid_preds(trendy, grid, n_valid = 1000, group_name = "TRENDY")

pred_summary_trendy <- boot_preds_trendy %>%
  group_by(IAVAR_GPP) %>%
  summarise(
    y_mean = mean(.fitted),
    y_lower = quantile(.fitted, 0.025),
    y_upper = quantile(.fitted, 0.975),
    .groups = "drop"
  )

## Plotting -------------------------------------------------------------------

ggplot() +
  geom_ribbon(data = pred_summary, aes(x = IAVAR_GPP, ymin = y_lower, ymax = y_upper),
              fill = "cornflowerblue",
              alpha = 0.2
  ) +
  geom_point(data= trendy, aes(x= IAVAR_GPP, y= IAVAR_NBP), shape= 3, color= "red") +
  geom_line(data = pred_summary_trendy, aes(x = IAVAR_GPP, y = y_mean, color = "Bootstrapped robust regression (median)"), size = 0.75) +
  geom_text_repel(data= trendy, aes(x= IAVAR_GPP, y= IAVAR_NBP, label= Model), size = 2.5, max.overlaps = 20, color= "darkgrey") +
  scale_color_manual(
    name = NULL,
    values = c(
      "Bootstrapped robust regression (median)" = "cornflowerblue")
  ) +
  labs(
    y = expression(IAV[NBP] ~(PgC~yr^{-1})),
    x = expression(IAV[GPP] ~(PgC~yr^{-1}))
  ) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey90", linewidth = 0.2),
    panel.background= element_rect(fill = "white"),
    legend.text= element_text(size= 12),
    legend.position = c(0.8, 0.89),
    legend.justification = c("right", "bottom"),
    legend.background = element_blank(),
    legend.box.background = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, size = 0.8)) +
  scale_x_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0,6.75)) +
  scale_y_continuous(labels = label_number(accuracy = 0.1), breaks= seq(from= 0, to= 9, by= 1.5), limits= c(0, 6) ) +
  coord_fixed(ratio= 1)


