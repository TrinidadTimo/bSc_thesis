!/bin/bash


temporal_aggregation() {

for file in "../../../data/trendy/raw/*.nc"; do

    if [[ "$file" == *IBIS_S3* || "$file" == *LPX-Bern_S3* ]]; then
	 echo "$file skiped"
         continue
    fi


    if [[ "$file" == *_gpp.nc ]]; then

	base_name=$(basename "$file" .nc)
	echo "File in loop: $base_name"
 
        ## multiply with seconds per day and convert from kg C to g C
        cdo mulc,86400000 -selname,gpp "$file" "${base_name}_SPD.nc"
        ## multiply with days per month
        cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
        ## aggregate to annual sums
        cdo yearsum "${base_name}_SPM.nc" "../../../data/trendy/ann_totals/${base_name}_ANN.nc"


    elif [[ "$file" == *_nbp.nc ]]; then
 
	base_name=$(basename "$file" .nc)
	echo "File in loop: $base_name" 

        ## multiply with seconds per day and convert from kg C to g C
        cdo mulc,86400000 -selname,nbp "$file" "${base_name}_SPD.nc"
        ## multiply with days per month
        cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
        ## aggregate to annual sums
        cdo yearsum "${base_name}_SPM.nc" "../../../data/trendy/ann_totals/${base_name}_ANN.nc"

    fi

   rm *.nc

done
}

temporal_aggregation
