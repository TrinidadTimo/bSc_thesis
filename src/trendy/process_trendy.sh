#!/bin/bash

proc_trendy_single (){
  ##-----------------------------
  ## argument 1: base file name (full path) of monthly file (gC m-2 s-1)
  ##-----------------------------
  ## 1. get annual total (gC m-2 yr-1)
  ## This requires seconds per month to be calculated beforehand, using R/create_secs_per_month.R
  cdo mulc,1000 -yearsum -mul ${1}_gpp.nc ${1}_seconds_per_month.nc ${1}_gpp_ANN.nc
  cdo mulc,1000 -yearsum -mul ${1}_nbp.nc ${1}_seconds_per_month.nc ${1}_nbp_ANN.nc

  ## 2. aggregate to global total (GtC yr-1)
  cdo mulc,1e-15 -fldsum -mul ${1}_gpp_ANN.nc -gridarea ${1}_gpp_ANN.nc ${1}_gpp_GLOB.nc
  cdo mulc,1e-15 -fldsum -mul ${1}_nbp_ANN.nc -gridarea ${1}_nbp_ANN.nc ${1}_nbp_GLOB.nc

  ## 3. For GPP, select 30-year period (1982-2011) detrend global time series GtC yr-1). XXX change period to most recent available
  cdo detrend -selyear,1982/2011 -selname,nbp ${1}_nbp_GLOB.nc ${1}_nbp_DETR_GLOB.nc
  cdo detrend -selyear,1982/2011 -selname,gpp ${1}_gpp_GLOB.nc ${1}_gpp_DETR_GLOB.nc

  ## 4. get variance of detrended global total (GtC yr-1)
  cdo timvar ${1}_nbp_DETR_GLOB.nc ${1}_nbp_VAR_GLOB.nc
  cdo timvar ${1}_gpp_DETR_GLOB.nc ${1}_gpp_VAR_GLOB.nc
}

# CABLE-POP
proc_trendy_single /data_2/scratch/ttrinidad/data/trendy/raw/CABLE-POP_S3

# Check outputs with analysis/test_outputs.R

# dirin="/data_2/scratch/ttrinidad/data/trendy/raw/"
# dirout="/data_2/scratch/bstocker/data/trendy/"
#
# ##-----------------------------
# ## argument 1: base file name of monthly file (gC m-2 s-1)
# ##-----------------------------
# ## 1. get annual total (gC m-2 yr-1)
# cdo mulc,1000 -yearsum -mul ${dirin}CABLE-POP_S3_gpp.nc ${dirout}seconds_per_month.nc ${dirout}CABLE-POP_S3_gpp_ANN.nc
# cdo mulc,1000 -yearsum -mul ${dirin}CABLE-POP_S3_nbp.nc ${dirout}seconds_per_month.nc ${dirout}CABLE-POP_S3_nbp_ANN.nc
#
# ## 2. aggregate to global total (GtC yr-1)
# cdo mulc,1e-15 -fldsum -mul ${dirout}CABLE-POP_S3_gpp_ANN.nc -gridarea ${dirout}CABLE-POP_S3_gpp_ANN.nc ${dirout}CABLE-POP_S3_gpp_GLOB.nc
# cdo mulc,1e-15 -fldsum -mul ${dirout}CABLE-POP_S3_nbp_ANN.nc -gridarea ${dirout}CABLE-POP_S3_nbp_ANN.nc ${dirout}CABLE-POP_S3_nbp_GLOB.nc
#
# ## 3. For GPP, select 30-year period (1982-2011) detrend global time series GtC yr-1). XXX change period to most recent available
# cdo detrend -selyear,1982/2011 -selname,nbp ${dirout}CABLE-POP_S3_nbp_GLOB.nc ${dirout}CABLE-POP_S3_nbp_DETR_GLOB.nc
# cdo detrend -selyear,1982/2011 -selname,gpp ${dirout}CABLE-POP_S3_gpp_GLOB.nc ${dirout}CABLE-POP_S3_gpp_DETR_GLOB.nc
#
# ## 4. get variance of detrended global total (GtC yr-1)
# cdo timvar ${dirout}CABLE-POP_S3_nbp_DETR_GLOB.nc ${dirout}CABLE-POP_S3_nbp_VAR_GLOB.nc
# cdo timvar ${dirout}CABLE-POP_S3_gpp_DETR_GLOB.nc ${dirout}CABLE-POP_S3_gpp_VAR_GLOB.nc


# temporal_aggregation() {
# cd  ~
# cd ../../data_2/scratch/ttrinidad/bachelor_thesis
#
# for file in ../data/trendy/raw/*.nc; do
#
#     if [[ "$file" == *IBIS_S3* || "$file" == *LPX-Bern_S3* ]]; then
# 	 echo "$file skiped"
#          continue
#     fi
#
#
#     if [[ "$file" == *_gpp.nc ]]; then
#
# 	base_name=$(basename "$file" .nc)
# 	varname=$(cdo showname "$file" | awk '{print $1}')
#
# 	echo "File in loop: $base_name"
#
# ## temporal aggregation:
#         ## multiply with seconds per day and convert from kg C to g C
#         cdo mulc,86400000 -selname,gpp "$file" "${base_name}_SPD.nc"
#         ## multiply with days per month
#         cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
#         ## aggregate to annual sums
#         cdo yearsum "${base_name}_SPM.nc" "../data/trendy/ann/${base_name}_ANN.nc"
#
# ## detrending:
# 	cdo detrend -selname,gpp "../data/trendy/ann/${base_name}_ANN.nc" "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc"
#
# ## spatial aggregation:
# 	cdo gridarea "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" gridarea.nc
# 	cdo mulc,1 -seltimestep,1 "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp.nc
# 	cdo div tmp.nc tmp.nc ones.nc
# 	cdo selname,gpp ones.nc mask.nc
# 	cdo mul mask.nc gridarea.nc gridarea_masked.nc
# 	cdo mul gridarea_masked.nc "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp_2.nc
# 	cdo fldsum tmp_2.nc tmp_3.nc
# 	cdo mulc,1e-15 tmp_3.nc "../data/trendy/ann_glob/${base_name}_ANN_GLOB.nc"
#
#     elif [[ "$file" == *_nbp.nc ]]; then
#
# 	base_name=$(basename "$file" .nc)
# 	varname=$(cdo showname "$file" | awk '{print $1}')
#
# 	echo "File in loop: $base_name"
#
# ## temporal aggregation:
#         ## multiply with seconds per day and convert from kg C to g C
#         cdo mulc,86400000 -selname,nbp "$file" "${base_name}_SPD.nc"
#         ## multiply with days per month
#         cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
#         ## aggregate to annual sums
#         cdo yearsum "${base_name}_SPM.nc" "../data/trendy/ann/${base_name}_ANN.nc"
#
# ## detrending:
#         cdo detrend -selname,nbp "../data/trendy/ann/${base_name}_ANN.nc" "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc"
#
# ## spatial aggregation:
#         cdo gridarea "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" gridarea.nc
#         cdo mulc,1 -seltimestep,1 "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp.nc
#         cdo div tmp.nc tmp.nc ones.nc
#         cdo selname,nbp ones.nc mask.nc
#         cdo mul mask.nc gridarea.nc gridarea_masked.nc
#         cdo mul gridarea_masked.nc "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp_2.nc
#         cdo fldsum tmp_2.nc tmp_3.nc
#         cdo mulc,1e-15 tmp_3.nc "../data/trendy/ann_glob/${base_name}_ANN_GLOB.nc"
#
#     fi
#
#    rm *SPD.nc *_SPM.nc gridarea.nc tmp.nc ones.nc mask.nc gridarea_masked.nc tmp_2.nc tmp_3.nc
#
# done
# }
#
# temporal_aggregation
