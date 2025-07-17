#!/bin/bash

# Assuming given folder structure:
# ann/, ann_glob/, ann_glob_detr/


for VAR in gpp nbp; do
  for FILE in ../../data/CMIP6/raw/${VAR}_*.nc; do
    MODEL=$(basename "$FILE" | sed -E "s/^${VAR}_(.*)_historical_merged\.nc/\1/")
    echo "Procesed File: $MODEL | Variable: $VAR"

    # 1) Selecting periode of analysis:
    cdo seldate,1982-01-01,2011-12-31 "$FILE" tmp_0.nc

    # 2) Getting monthly totals in PgC (PgC/m^-2 m^-1):
    cdo muldpm tmp_0.nc tmp_1.nc
    cdo mulc,86400 tmp_1.nc tmp_2.nc
    cdo divc,1e12 tmp_2.nc tmp_3.nc

    # 3) Getting annual totals (PgC/m^-2 a^-1)
    cdo yearsum tmp_3.nc tmp_4.nc

    # 4) Getting Cell area
    cdo gridarea "$FILE" gridarea.nc

    # 5) Multiplying Cells with spatial extent (PgC/m^-2 a^-1)
    cdo mul tmp_4.nc gridarea.nc "ann/${MODEL}_${VAR}_ann.nc"
    rm gridarea.nc

    # 6) Getting global annual totals (PgC/glob^-1 a^-1)
    cdo fldsum "ann/${MODEL}_${VAR}_ann.nc" "ann_glob/${MODEL}_${VAR}_ann_glob.nc"

    # 7) Detrending
    cdo detrend "ann_glob/${MODEL}_${VAR}_ann_glob.nc" "ann_glob_detr/${MODEL}_${VAR}_ann_glob_detr.nc"

    # 8) Getting IAVAR
    cdo timvar "ann_glob_detr/${MODEL}_${VAR}_ann_glob_detr.nc" "IAVAR/${MODEL}_${VAR}_ann_glob_detr_iavar.nc"

    # Cleaning up
    rm tmp_*.nc

    echo "Finished $MODEL $VAR"
  done
done

echo "Processed all files"
