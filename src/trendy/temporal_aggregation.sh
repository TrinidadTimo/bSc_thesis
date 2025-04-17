#!/bin/bash


temporal_aggregation() {

for file in "../data/trendy/raw"/*.nc; do

    if [[ "$file" == *IBIS_S3* || "$file" == *LPX-Bern_S3* ]]; then
	 echo "$file skiped"
         continue
    fi

    if [[ "$file" == *_gpp.nc ]]; then

        unit=$(ncdump -h "$file" | grep -E "gpp:units|gpp:Units|gpp:unit")
	base_name=$(basename "$file" .nc)
	echo "File in loop: $base_name"

        if [[ "$unit" == *s-1* || "$unit" == *s^-1* || "$unit" == *"s\$^{-1}\$"* ]]; then
            ## multiply with seconds per day and convert from kg C to g C
            cdo mulc,86400000 -selname,gpp "$file" "${base_name}_SPD.nc"
            ## multiply with days per month
            cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
            ## aggregate to annual sums
            cdo yearsum "${base_name}_SPM.nc" "${base_name}_ANN.nc"

        elif [[ "$unit" == *month-1* ]]; then
            ## convert from kg C to g C
	    cdo mulc,1000 -selname,gpp "$file" "${base_name}_G.nc"
	    ## aggregate to annual sums
            cdo yearsum "${base_name}_G.nc" "${base_name}_ANN.nc"
	    rm  *_G.nc

        else
            echo "Other resolution, adjust manually:"
            echo $file
            echo $unit
        fi



    elif [[ "$file" == *_nbp.nc ]]; then
        
	unit=$(ncdump -h "$file" | grep -E "nbp:units|nbp:Units|nbp:unit")
	base_name=$(basename "$file" .nc)
	echo "File in loop: $base_name"

	if [[ "$unit" == *s-1* || "$unit" == *s^-1* || "$unit" == *"s\$^{-1}\$"* ]]; then
            ## multiply with seconds per day and convert from kg C to g C
            cdo mulc,86400000 -selname,nbp "$file" "${base_name}_SPD.nc"
            ## multiply with days per month
            cdo muldpm "${base_name}_SPD.nc" "${base_name}_SPM.nc"
            ## aggregate to annual sums
            cdo yearsum "${base_name}_SPM.nc" "${base_name}_ANN.nc"
	    rm *_SPM.nc

        elif [[ "$unit" == *month-1* ]]; then
            ## convert from kg C to g C
            cdo mulc,1000 -selname,nbp "$file" "${base_name}_G.nc"
	    ## aggregate to annual sums
            cdo yearsum "${base_name}_G.nc" "${base_name}_ANN.nc"
	    rm *_G.nc

        else
            echo "Other resolution, adjust manually:"
            echo $file
            echo $unit
         fi
    fi

    ((t++))
done

echo $t
}

temporal_aggregation
