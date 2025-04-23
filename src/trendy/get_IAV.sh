#!/bin/bash


cd ~
cd ../../data_2/scratch/ttrinidad/data/trendy

for file in ann_glob/*.nc; do
	base_name=$(basename "$file" .nc)

	cdo timstd "$file" "iasd/${base_name}_IASD.nc"


done
