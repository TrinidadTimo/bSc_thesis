#!/bin/bash

cd ~
cd ../../data_2/scratch/ttrinidad/data/trendy

## temporal aggregation 

## multiply with seconds per year (of 365 days) -> yields kg*C/Ann*m^2
cdo mulc,31536000 raw/SDGVM_S3_nbp.nc ann/SDGVM_S3_nbp_ANN.nc


## detrending
cdo detrend ann/SDGVM_S3_nbp_ANN.nc ann_detr/SDGVM_S3_nbp_ANN_DETR.nc

## spatial aggregation
cdo gridarea ann_detr/SDGVM_S3_nbp_ANN_DETR.nc gridarea.nc
cdo mulc,1 -seltimestep,1 ann_detr/SDGVM_S3_nbp_ANN_DETR.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo mul ones.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc ann_detr/SDGVM_S3_nbp_ANN_DETR.nc tmp_2.nc
cdo fldsum tmp_2.nc tmp_3.nc
cdo mulc,1e-12 tmp_3.nc ann_glob/SDGVM_S3_nbp_ANN_GLOB.nc

rm gridarea.nc tmp.nc ones.nc gridarea_masked.nc tmp_2.nc tmp_3.nc
