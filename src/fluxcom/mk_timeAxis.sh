#!/bin/bash
# Applied on ENS files
cd ../../data/rs_models/FLUXCOM/GPP

# Set Paths
INPUT_DIR="ENS/raw"
OUTPUT_DIR="ENS/timeAxis_fixed"
MERGED_FILE="${OUTPUT_DIR}/GPP.ENS.CRUNCEPv6.annual.1980_2013.nc"

# Set time axis for each annual file:
for year in {1980..2013}; do
  infile="$INPUT_DIR/GPP.ENS.CRUNCEPv6.annual.${year}.nc"
  outfile="${OUTPUT_DIR}/GPP.ENS.CRUNCEPv6.annual.fixed.${year}.nc"

    echo "Setting time axis for year $year"
    cdo settaxis,${year}-01-01,00:00,1year "$infile" "$outfile"
done

# Merge of all corrected annual files:
echo "Merging the corrected files"
cdo mergetime ${OUTPUT_DIR}/GPP.ENS.CRUNCEPv6.annual.fixed.????.nc "$MERGED_FILE"

#  Controll:
cdo showyear "$MERGED_FILE"
cdo ntime "$MERGED_FILE"
