#!/bin/bash

# from "ncdump -h": gpp values in gC m-2 d-1

cd ../../data/rs_models/P-Mod

INPUT="s1b_fapar3g_v2_global.d.gpp.nc"
VARNAME="gpp"

# Extract Base Name for correct naming afterwards
BASENAME="${INPUT%.gpp.nc}"  # yields "s1b_fapar3g_v2_global.d"

# Get Annual values (gC m-2 a-1)
cdo yearsum "$INPUT" "ann/${BASENAME}.${VARNAME}_ann.nc"

# Get Global Annual Totals (gc glob-1 a-1)
cdo gridarea "ann/${BASENAME}.${VARNAME}_ann.nc" cellarea.nc
cdo mul "ann/${BASENAME}.${VARNAME}_ann.nc" cellarea.nc temp_g.nc
cdo divc,1e15 temp_g.nc temp_pg.nc
cdo fldsum temp_pg.nc "ann_glob/${BASENAME}.${VARNAME}_ann_glob.nc"

# Remove Trend
cdo detrend "ann_glob/${BASENAME}.${VARNAME}_ann_glob.nc" "ann_glob_detr/${BASENAME}.${VARNAME}_ann_glob_detr.nc"

# IAV (over periode of analysis)
cdo timvar -selyear,1982/2011 "ann_glob_detr/${BASENAME}.${VARNAME}_ann_glob_detr.nc" "IAVAR/${BASENAME}.${VARNAME}_IAVAR.nc"


rm temp_*.nc cellarea.nc
