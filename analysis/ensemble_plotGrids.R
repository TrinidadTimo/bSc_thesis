library(here)
library(cowplot)

### Load Data:
load(here("data/annualTotals_plots_noLabel.RData"))
load(here("data/coefficientOfVariation_plots.RData"))

### Plot Grids for Paper by Ensemble:
# Spacer:
sp <- ggdraw() + theme_void()

## TRENDY --------------------------------------------------------
### Single rows:
annualTotals_trendy <- plot_grid(p_trendy_gpp_noLabel, sp, p_trendy_nbp_noLabel, nrow = 3,
                                 rel_heights = c(1.5, 0.05, 1.5)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.0), y = c(1.04, 0.54),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 18, r = 0, b = 0, l = 0))

coefVar_trendy <- plot_grid(p_trendy_gpp, p_trendy_nbp, nrow = 1, rel_heights = c(0.7,0.7)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.5), y = c(1.04, 1.04),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

### Combine Single rows to grid:
grid_trendy <- plot_grid(annualTotals_trendy, sp, coefVar_trendy, nrow= 3,
                         rel_heights = c(1.5, 0.01, 0.75)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("Verlauf jährlicher Absolutwerte", "Verteilung Variationskoeffizienten"),
                  x = c(0.00, 0.0), y = c(1.03, 0.34),
                  hjust = 0, size = 14, fontface = "bold") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

grid_trendy
### Save plot grid:
ggsave(filename = here("figures/plotGrid_trendy.png"), plot= grid_trendy, width= 210,
  height   = 279, units= "mm", dpi= 300, bg= "white", limitsize= FALSE)

## CMIP --------------------------------------------------------
### Single rows:
annualTotals_cmip <- plot_grid(p_cmip_gpp_noLabel, sp, p_cmip_nbp_noLabel, nrow = 3,
                               rel_heights = c(1.5, 0.05, 1.5)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.0), y = c(1.04, 0.54),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 18, r = 0, b = 0, l = 0))

coefVar_cmip <- plot_grid(p_cmip_gpp, p_cmip_nbp, nrow = 1, rel_heights = c(0.7,0.7)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.5), y = c(1.04, 1.04),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

### Combine Single rows to grid:
grid_cmip <- plot_grid(annualTotals_cmip, sp, coefVar_cmip, nrow= 3,
                       rel_heights = c(1.5, 0.01, 0.75)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("Verlauf jährlicher Absolutwerte", "Verteilung Variationskoeffizienten"),
                  x = c(0.00, 0.0), y = c(1.03, 0.34),
                  hjust = 0, size = 14, fontface = "bold") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

grid_cmip
### Save plot grid:
ggsave(filename = here("figures/plotGrid_cmip.png"), plot= grid_cmip, width= 210,
       height   = 279, units= "mm", dpi= 300, bg= "white", limitsize= FALSE)

## MsTMIP SG1 --------------------------------------------------------
### Single rows:
annualTotals_mstmip_sg1 <- plot_grid(p_mstmip_sg1_gpp_noLabel, sp, p_mstmip_sg1_nbp_noLabel, nrow = 3,
                                    rel_heights = c(1.5, 0.05, 1.5)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.0), y = c(1.04, 0.54),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 18, r = 0, b = 0, l = 0))

coefVar_mstmip_sg1 <- plot_grid(p_mstmip_sg1_gpp, p_mstmip_sg1_nbp, nrow = 1, rel_heights = c(0.7,0.7)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.5), y = c(1.04, 1.04),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

### Combine Single rows to grid:
grid_mstmip_sg1 <- plot_grid(annualTotals_mstmip_sg1, sp, coefVar_mstmip_sg1, nrow= 3,
                            rel_heights = c(1.5, 0.01, 0.75)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("Verlauf jährlicher Absolutwerte", "Verteilung Variationskoeffizienten"),
                  x = c(0.00, 0.0), y = c(1.03, 0.34),
                  hjust = 0, size = 14, fontface = "bold") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

grid_mstmip_sg1
### Save plot grid:
ggsave(filename = here("figures/plotGrid_mstmip_sg1.png"), plot= grid_mstmip_sg1, width= 210,
       height   = 279, units= "mm", dpi= 300, bg= "white", limitsize= FALSE)


## MsTMIP SG3 --------------------------------------------------------
### Single rows:
annualTotals_mstmip_sg3 <- plot_grid(p_mstmip_sg3_gpp_noLabel, sp, p_mstmip_sg3_nbp_noLabel, nrow = 3,
                                     rel_heights = c(1.5, 0.05, 1.5)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.0), y = c(1.04, 0.54),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 18, r = 0, b = 0, l = 0))

coefVar_mstmip_sg3 <- plot_grid(p_mstmip_sg3_gpp, p_mstmip_sg3_nbp, nrow = 1, rel_heights = c(0.7,0.7)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("GPP", "NBP"),
                  x = c(0.0, 0.5), y = c(1.04, 1.04),
                  hjust = 0, size = 12, fontface = "plain") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

### Combine Single rows to grid:
grid_mstmip_sg3 <- plot_grid(annualTotals_mstmip_sg3, sp, coefVar_mstmip_sg3, nrow= 3,
                             rel_heights = c(1.5, 0.01, 0.75)) %>%
  ggdraw(plot = .) +
  draw_plot_label(c("Verlauf jährlicher Absolutwerte", "Verteilung Variationskoeffizienten"),
                  x = c(0.00, 0.0), y = c(1.03, 0.34),
                  hjust = 0, size = 14, fontface = "bold") +
  theme(plot.margin = margin(t = 25, r = 0, b = 0, l = 0))

grid_mstmip_sg3
### Save plot grid:
ggsave(filename = here("figures/plotGrid_mstmip_sg3.png"), plot= grid_mstmip_sg3, width= 210,
       height   = 279, units= "mm", dpi= 300, bg= "white", limitsize= FALSE)
