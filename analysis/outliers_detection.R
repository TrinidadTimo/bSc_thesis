# Which models could be considered as outliers for the GPP-NBP-fit?

library(here)
library(readr)
library(dplyr)
library(ggplot2)
library(RANSAC)

# Loading TRENDY IAVAR table
trendy <- read_delim("data/iavar_trendy.txt", delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
colnames(trendy) <- c("Model", "IAVAR_GPP", "IAVAR_NBP")

# Loading CMIP6 table
cmip <- read_csv("data/iavar_cmip.txt", col_types = cols(IAVAR_GPP = col_number(), IAVAR_NBP = col_number()))

df <- trendy |>
  filter (!(Model %in% c("ISBA-CTRIP"))) |> # ISBA has 0 in both variables.
  bind_rows(cmip)

fit_all <- lm(formula = IAVAR_GPP ~ IAVAR_NBP, data= df)
summary(fit_all) # -> yields an R^2 of 0.1518

# --- Cook's distance: ---
## AGDS: "Boundary regions for Cook’s distance equal to 0.5 (suspicious) and 1 (certainly influential) are drawn with a dashed line."
any(cooks.distance(fit_all) >= 0.5) # -> no outlier.
plot(fit_all, 5) # "MPI-ESM-1-2-HAM" with biggest cd (0.32) due to high residual (only GPP value seems to be outling, nbp in range)


# --- Bootstrapping: ---
res_fit_all <- residuals(fit_all)
B <- 1000
n <- nrow(df)
residual_matrix <- matrix(NA, nrow = n, ncol = B)

set.seed(123)

for (b in 1:B) {
  idx <- sample(1:n, size = n, replace = TRUE)
  df_b <- df[idx, ]
  model_b <- lm(formula= IAVAR_GPP ~ IAVAR_NBP, data = df_b)

  # get residuals based on bootstrapped parameters but original data:
  preds <- predict(model_b, newdata = df)
  residuals_b <- df$IAVAR_GPP - preds
  residual_matrix[, b] <- residuals_b
}

lower <- apply(residual_matrix, 1, quantile, probs = 0.025)
upper <- apply(residual_matrix, 1, quantile, probs = 0.975)

outliers_q <- which(res_fit_all < lower | res_fit_all > upper) # -> no outlier

# --- Robust Regression: ---
## Using the RANSAC-model; see
### https://developer.nvidia.com/blog/dealing-with-outliers-using-three-robust-linear-regression-models/
### https://cran.r-project.org/web/packages/RANSAC/RANSAC.pdf

### I'm setting
#### - n_min = 2 (minimal number to fit a line - default value and also what seems to be used regularly [https://stats.stackexchange.com/questions/322812/ransac-should-we-always-sample-with-the-minimal-number-of-data-points])
### For the tolerance threshold I'm using my bootstrapped distribution again:

residual_range <- upper - lower
threshold_boot <- mean(residual_range) # Threshold is given as the mean of the 95% intervals of the conditional residual distributions.

fit_ransac <- ransac_reg(IAVAR_GPP ~ IAVAR_NBP, data = df, n_min = 2, tol = threshold_boot)

nrow(fit_ransac$model) # -> 5 models as outliers excluded
summary(fit_ransac) # R^2 = 0.5769

df_ransac_fit <- df %>%
  mutate(Inlier = if_else(df$IAVAR_GPP %in% fit_ransac$model$IAVAR_GPP, "Inlier", "Outlier"))

ggplot(data= df_ransac_fit, aes(x = IAVAR_GPP, y =  IAVAR_NBP, color = Inlier)) +
  geom_point()

plot(fit_ransac)
