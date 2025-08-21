#!/bin/bash

ENSEMBLE_DIR="SG3"  # Anpassen für entsprechende Simulation (SG1 oder SG3)
IAVAR_DIR="${ENSEMBLE_DIR}/iavar"
ANN_GLOB_DIR="${ENSEMBLE_DIR}/ann_glob"
OUT_DIR="${ENSEMBLE_DIR}/varCoef"


# Rechne GPP: Var(gpp_detr) / Mean(gpp_abs) --------
for file in "${IAVAR_DIR}"/*_gpp_ann_glob_detr_iavar.nc; do
  model="$(basename "$file" _gpp_ann_glob_detr_iavar.nc)"
  gpp_abs="${ANN_GLOB_DIR}/${model}_gpp_ann_glob.nc"
  out="${OUT_DIR}/${model}_gpp_varCoef.nc"

  cdo -O div "$file" -timmean "$gpp_abs" "$out"
done

# Rechne NBP: Var(nbp_detr) / Mean(gpp_abs) (gleiches Modell) --------
for file in "${IAVAR_DIR}"/*_nbp_ann_glob_detr_iavar.nc; do
  model="$(basename "$file" _nbp_ann_glob_detr_iavar.nc)"
  gpp_abs="${ANN_GLOB_DIR}/${model}_gpp_ann_glob.nc"
  out="${OUT_DIR}/${model}_nbp_varCoef.nc"

  cdo -O div "$file" -timmean "$gpp_abs" "$out"
done
