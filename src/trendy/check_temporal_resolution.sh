#!/bin/bash

check_temporal_resolution() {

    for file in ../data/trendy/raw/*.nc; do
        
        if [[ "$file" == *gpp.nc ]]; then
            echo "Verarbeite GPP-Datei: $file"
            unit=$(ncdump -h "$file" | grep gpp:units)
            echo  $file
	    echo $unit


        elif [[ "$file" == *nbp.nc ]]; then
            echo "Verarbeite NBP-Datei: $file"
            unit=$(ncdump -h "$file" | grep nbp:units)
            echo $file
	    echo $unit
        fi
    done
}

check_temporal_resolution
