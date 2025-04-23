#!/bin/bash

temporal_aggregation() {
cd  ~
cd ../../data_2/scratch/ttrinidad/bachelor_thesis

for file in ../data/trendy/raw/*.nc; do

    if [[ "$file" == *IBIS_S3* || "$file" == *LPX-Bern_S3* ]]; then
	 echo "$file skiped"
         continue
    fi


    if [[ "$file" == *_gpp.nc ]]; then

	base_name=$(basename "$file" .nc)
	varname=$(cdo showname "$file" | awk '{print $1}')

	echo "File in loop: $base_name"

## temporal aggregation:
        ## multiply with seconds per day and convert from kg C to g C
        cdo mulc,86400000 -selname,gpp "$file" "${base_name}_SPD.nc"
        ## multiply with days per month
        cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
        ## aggregate to annual sums
        cdo yearsum "${base_name}_SPM.nc" "../data/trendy/ann/${base_name}_ANN.nc"
		
## detrending:
	cdo detrend -selname,gpp "../data/trendy/ann/${base_name}_ANN.nc" "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc"

## spatial aggregation: 	
	cdo gridarea "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" gridarea.nc
	cdo mulc,1 -seltimestep,1 "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp.nc
	cdo div tmp.nc tmp.nc ones.nc
	cdo selname,gpp ones.nc mask.nc
	cdo mul mask.nc gridarea.nc gridarea_masked.nc
	cdo mul gridarea_masked.nc "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp_2.nc
	cdo fldsum tmp_2.nc tmp_3.nc
	cdo mulc,1e-15 tmp_3.nc "../data/trendy/ann_glob/${base_name}_ANN_GLOB.nc"

    elif [[ "$file" == *_nbp.nc ]]; then
 
	base_name=$(basename "$file" .nc)
	varname=$(cdo showname "$file" | awk '{print $1}')

	echo "File in loop: $base_name" 

## temporal aggregation:
        ## multiply with seconds per day and convert from kg C to g C
        cdo mulc,86400000 -selname,nbp "$file" "${base_name}_SPD.nc"
        ## multiply with days per month
        cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
        ## aggregate to annual sums
        cdo yearsum "${base_name}_SPM.nc" "../data/trendy/ann/${base_name}_ANN.nc"

## detrending:
        cdo detrend -selname,nbp "../data/trendy/ann/${base_name}_ANN.nc" "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc"

## spatial aggregation:
        cdo gridarea "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" gridarea.nc
        cdo mulc,1 -seltimestep,1 "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp.nc
        cdo div tmp.nc tmp.nc ones.nc
        cdo selname,nbp ones.nc mask.nc
        cdo mul mask.nc gridarea.nc gridarea_masked.nc
        cdo mul gridarea_masked.nc "../data/trendy/ann_detr/${base_name}_ANN_DETR.nc" tmp_2.nc
        cdo fldsum tmp_2.nc tmp_3.nc
        cdo mulc,1e-15 tmp_3.nc "../data/trendy/ann_glob/${base_name}_ANN_GLOB.nc"

    fi

   rm *SPD.nc *_SPM.nc gridarea.nc tmp.nc ones.nc mask.nc gridarea_masked.nc tmp_2.nc tmp_3.nc

done
}

temporal_aggregation
