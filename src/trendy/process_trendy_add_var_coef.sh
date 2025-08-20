#!/bin/bash
# Adjust for respective variable

iavar_dir="../../../data/trendy/S3/iavar/R"
absolute_dir="../../../data/trendy/S3/ann_glob_absolute/R"
out_dir="../../../data/trendy/S3/var_coef"


for varfile in "${iavar_dir}"/*_S3_nbp_VAR_GLOB.nc; do
  base="$(basename "$varfile")"
  model="${base%%_S3_nbp_VAR_GLOB.nc}"  # Modellkürzel extrahieren

  absolute_file="${absolute_dir}/${model}_S3_gpp_GLOB_ABSOLUTE.nc"
  out_file="${out_dir}/${model}_S3_nbp_var_coef.nc"

  echo "$model: (Varianz) / (detrendeter Mittelwert) berechnen …"

  # Var/Mean
  cdo -O div "$varfile" -timmean "$absolute_file" "$out_file"

done
echo "Fertig. Ergebnisse in: $out_dir"
