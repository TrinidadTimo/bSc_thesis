#!/bin/bash

# Ordner und Dateien
INPUT_FILE="../../data/rs_models/FLUXCOM/GPP/ENS/timeAxis_fixed/GPP.ENS.CRUNCEPv6.annual.1980_2013.lonlat.nc"

# 1) Calculateing grid area
echo "Computing grid area"
cdo gridarea "$INPUT_FILE" "processed/gridarea.nc"

# 2) GPP from gC/m²/d to gC/a
echo "Multiplying with days/year"
cdo mulc,365 "$INPUT_FILE" "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann.nc"

# 3) Multiplying with cell area (gC per cell per year)
echo "Multiplying with cell area..."
cdo mul "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann.nc" "processed/gridarea.nc" "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_cell.nc"

# 4) Getting grid sum (global annual values in gC)
echo "Getting grid sum"
cdo fldsum "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_cell.nc" "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_glob.nc"

# 5) Getting Petagramm C (global annual values in PgC)
echo "Changing to PgC"
cdo divc,1e15 "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_glob.nc" "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_glob_pgC.nc"

# 6) Detrending
echo "Detrending"
cdo detrend "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_glob_pgC.nc" "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_glob_pgC_detr.nc"

# 7) Selecting analysis periode and getting IAV:
cdo timvar -seldate,1992-01-01,2012-12-31 "processed/GPP.ENS.CRUNCEPv6.annual.1980_2013.ann_glob_pgC_detr.nc" "processed/IAV.1982_2011.nc"
echo "Finished!"
