# Which models could be considered as outliers for the GPP-NBP-fit?

library(here)
library(readr)
library(dplyr)
library(RANSAC)

# Loading TRENDY IAVAR table
trendy <- read.delim(here("../data/trendy/S3/iavar/R/IAVAR_R.txt"), header=FALSE)
colnames(trendy) <- c("Model", "IAVAR_GPP", "IAVAR_NBP")

# Loading CMIP6 table
cmip <- read.csv(here("../data/CMIP6/IAVAR/IAVAR_CMIP6.csv"), dec=",")
cmip$IAVAR_GPP <- as.numeric(cmip$IAVAR_GPP)
cmip$IAVAR_NBP <- as.numeric(cmip$IAVAR_NBP)

df <- trendy |>
  filter (!(Model %in% c("ISBA-CTRIP"))) |> # ISBA has 0 in both variables.
  bind_rows(cmip)


fit_all <- lm(formula= IAVAR_GPP ~ IAVAR_NBP, data= df)
summary(fit_all) # -> yields an R^2 of 0.1518

# --- Cook's distance: ---
## AGDS: "Boundary regions for Cook’s distance equal to 0.5 (suspicious) and 1 (certainly influential) are drawn with a dashed line."
any(cooks.distance(fit_all) >= 0.5) # -> no outlier.
plot(fit_al, 5) # "MPI-ESM-1-2-HAM" with biggest cd (0.32) due to high residual (only GPP value seems to be outling, nbp in range)


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

outliers_q <- which(res_fit_all < lower | res_fit_allupper) # -> no outlier



# --- Robust Regression: ---
## Using the RANSAC-model; see
### https://developer.nvidia.com/blog/dealing-with-outliers-using-three-robust-linear-regression-models/
### https://cran.r-project.org/web/packages/RANSAC/RANSAC.pdf

### I'm setting
#### - n_min = 2 (minimal number to fit a line - default value and also what seems to be used regularly [https://stats.stackexchange.com/questions/322812/ransac-should-we-always-sample-with-the-minimal-number-of-data-points])
### For the tolerance threshold I'm using my bootstrapped distribution again:

residual_range <- upper - lower
threshold_boot <- mean(residual_range) # Threshold is given as the mean of the 95% intervals of the conditional residual distributions.

fit_ransac <- ransac_reg(IAVAR_GPP ~IAVAR_NBP, data= df,n_min= 2, tol = threshold_boot)

nrow(fit_ransac$model) # -> 5 models as outliers excluded
summary(fit_ransac) # R^2 = 0.5769

df_ransac_fit <- df %>%
  mutate(Inlier = if_else(rownames(df) %in% rownames(fit_ransac$model), "Inlier", "Outlier"))

ggplot(data= df_ransac_fit, aes(x= IAVAR_NBP, y= IAVAR_GPP, color= Inlier)) +
  geom_point()


