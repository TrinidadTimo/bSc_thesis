# Load libraries
library(tidyverse)
library(rsample)     # bootstraps()
library(MASS)        # rlm()
library(broom)       # augment()
library(glue)        # nice subtitle
library(scales)      # label formatting
library(RANSAC)      # for RANSAC regression
library(ggrepel)     # for adding labels
library(purrr)

## Read data -------------------------------------------------------------------
# Loading TRENDY S3
trendy <- read_delim("data/iavar_trendy.txt", delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
colnames(trendy) <- c("Model", "IAVAR_GPP", "IAVAR_NBP")

# Loading CMIP6
cmip <- read_csv("data/iavar_cmip.txt", col_types = cols(IAVAR_GPP = col_number(), IAVAR_NBP = col_number()))

# Loading MsTMIP SG1
mstmip_sg1 <- read_csv("data/iavar_mstmip_sg1.csv")

# Loading MsTMIP SG3
mstmip_sg3 <- read_csv("data/iavar_mstmip_sg3.csv")

df <- trendy |>
  filter (!(Model %in% c("ISBA-CTRIP"))) |> # ISBA has 0 in both variables.
  bind_rows(cmip) |>
  bind_rows(mstmip_sg1) |>
  bind_rows(mstmip_sg3) |>
  mutate(
    source = c(rep("TRENDY, S3", 16), rep("CMIP6, historical", 21), rep("MsTMIP, SG1", 13), rep("MsTMIP, SG3", 12))
  )

## Bootstrapped robust regression ----------------------------------------------
# 2. Create prediction grid
grid <- tibble(IAVAR_GPP = seq(min(df$IAVAR_GPP), max(df$IAVAR_GPP), length.out = 100))

# 3. Create bootstrap resamples using rsample
n_boot <- 1000
boot_resamples <- bootstraps(df, times = n_boot)

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

# 6. Plot bootstrapped robust regression
ggplot() +
  geom_point(
    data = df,
    aes(IAVAR_GPP, IAVAR_NBP, color = source),
    alpha = 0.6,
    color = "black"
    ) +
  geom_ribbon(
    data = pred_summary,
    aes(x = IAVAR_GPP, ymin = y_lower, ymax = y_upper),
    fill = "royalblue",
    alpha = 0.2
    ) +
  geom_line(data = pred_summary, aes(x = IAVAR_GPP, y = y_mean), color = "royalblue", size = 1) +
  labs(
    title = "Robust Regression with Bootstrapped Confidence Intervals",
    subtitle = glue("rlm() + rsample bootstrapping (n = {n_boot})"),
    x = "GPP IAV",
    y = "NBP IAV",
    caption = "95% prediction intervals from bootstraps. Outliers added every 10th point."
  ) +
  theme_minimal() +
  scale_y_continuous(labels = label_number(accuracy = 0.1)) +
  theme(plot.title = element_text(face = "bold", size = 14))

## RANSAC Regression (non-bootstrapped) ----------------------------------------
threshold_boot <- 1.51058  # from analysis/outliers_detection
ransac_model <- ransac_reg(IAVAR_NBP ~ IAVAR_GPP, data = df, n_min = 2, tol = threshold_boot)
# ransac_model <- lm(y ~ x, data = as.data.frame(ransac_fit$best_data))
ransac_preds <- augment(ransac_model, newdata = grid) %>%
  dplyr::select(IAVAR_GPP, .fitted) %>%
  mutate(method = "RANSAC")

# --- OLS Regression (non-robust baseline) ---
ols_model <- lm(IAVAR_NBP ~ IAVAR_GPP, data = df)
ols_preds <- augment(ols_model, newdata = grid) %>%
  dplyr::select(IAVAR_GPP, .fitted) %>%
  mutate(method = "OLS")

# --- Combine all methods ---
line_preds <- bind_rows(
  pred_summary %>%
    mutate(method = "Bootstrap Robust (rlm)") |>
    dplyr::select(IAVAR_GPP, .fitted = y_mean, method),
  ransac_preds,
  ols_preds
)

ggplot() +
  geom_point(
    data = df,
    aes(IAVAR_GPP, IAVAR_NBP, shape = source),
    alpha = 0.6
  ) +
  # Add text labels using 'label' column
  geom_text_repel(
    aes(IAVAR_GPP, IAVAR_NBP, label = Model),
    data = df,
    size = 2,
    color = "grey50",
    max.overlaps = 20,
    segment.size = 0.2,     # finer line
    segment.color = "grey70", # grey color,
    min.segment.length = 0,
    ) +
  geom_ribbon(
    data = pred_summary,
    aes(x = IAVAR_GPP, ymin = y_lower, ymax = y_upper),
    fill = "royalblue",
    alpha = 0.2
  ) +
  geom_line(
    aes(x = IAVAR_GPP, y = .fitted, color = method),
    data = line_preds,
    size = 1
    ) +
  labs(
    title = "Robust Regression Comparison: Bootstrap vs RANSAC vs OLS",
    subtitle = glue("Bootstrap (n = {n_boot}), RANSAC (k = 100), OLS baseline"),
    x = "GPP IAV",
    y = "NBP IAV",
    color = "Method",
    caption = "Confidence interval shown only for rlm bootstrapped fit"
  ) +
  theme_classic() +
  scale_color_manual(values = c(
    "Bootstrap Robust (rlm)" = "royalblue",
    "RANSAC" = "tomato",
    "OLS" = "darkgreen"
  )) +
  theme(plot.title = element_text(face = "bold", size = 14))



