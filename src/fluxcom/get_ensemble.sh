#!/bin/bash
cd ../../data/rs_models/FLUXCOM/GPP

for year in $(seq 1980 2013); do
    echo "Processing Year: $year"

  # Calculating ensemble mean:
  cdo ensmean \
      MARS/GPP.MARS.CRUNCEPv6.annual.${year}.nc \
      RF/GPP.RF.CRUNCEPv6.annual.${year}.nc \
      ANN/GPP.ANN.CRUNCEPv6.annual.${year}.nc \
      ENS/GPP.ENS.CRUNCEPv6.annual.${year}.nc

done

echo "Fertig!"
