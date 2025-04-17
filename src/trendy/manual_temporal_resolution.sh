#!/bin/bash


## Manual Temporal aggregation for files with resolution not captured by "temporal_aggregation"

## CLM5.0_S3 -> ??

    ## GPP 
    
    ## NBP


    
## IBIS_S3 -> resolution kg*m^2/s^1, but what's the fucking problem?
    ## GPP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/IBIS_S3_gpp.nc IBIS_S3_gpp_SPM.nc
    cdo yearsum IBIS_S3_gpp_SPM.nc IBIS_S3_gpp_ANN.nc
    rm IBIS_S3_gpp_SPM.nc
    
    ## NBP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/IBIS_S3_nbp.nc IBIS_S3_nbp_SPM.nc
    cdo yearsum IBIS_S3_nbp_SPM.nc IBIS_S3_nbp_ANN.nc
    rm IBIS_S3_nbp_SPM.nc
    
    
    
## LPX-Bern_S3 -> Resolution known, What's the fucking problem?!!
     ## GPP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/LPX-Bern_S3_gpp.nc LPX-Bern_S3_gpp_SPM.nc
    cdo yearsum LPX-Bern_S3_gpp_SPM.nc LPX-Bern_S3_gpp_ANN.nc
    rm LPX-Bern_S3_gpp_SPM.nc
    
    ## NBP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/LPX-Bern_S3_nbp.nc LPX-Bern_S3_nbp_SPM.nc
    cdo yearsum LPX-Bern_S3_nbp_SPM.nc LPX-Bern_S3_nbp_ANN.nc
    rm LPX-Bern_S3_nbp_SPM.nc
    
## LPJwsl_S3 -> check resolution [DONE]
    ## NBP
    cdo mulc,1000 -selname,nbp ./trendy_v12/LPJwsl_S3_nbp.nc LPJwsl_S3_nbp_G.nc
    cdo yearsum LPJwsl_S3_nbp_G.nc LPJwsl_S3_nbp_ANN.nc
    rm LPJwsl_S3_nbp_G.nc 
    
    
## ISAM_S3_nbp.nc 
    ## Written in description (ISAM_S0_nbp.nc),however file name is ISAM_S3_nbp.nc.Downloaded together with the other nbp S3 files. 
    ## -> What is correct??#!/bin/bash


## Manual Temporal aggregation for files with resolution not captured by "temporal_aggregation"

## CLM5.0_S3 -> ??

    ## GPP 
    
    ## NBP


    
## IBIS_S3 -> resolution kg*m^2/s^1, but what's the fucking problem?
    ## GPP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/IBIS_S3_gpp.nc IBIS_S3_gpp_SPM.nc
    cdo yearsum IBIS_S3_gpp_SPM.nc IBIS_S3_gpp_ANN.nc
    rm IBIS_S3_gpp_SPM.nc
    
    ## NBP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/IBIS_S3_nbp.nc IBIS_S3_nbp_SPM.nc
    cdo yearsum IBIS_S3_nbp_SPM.nc IBIS_S3_nbp_ANN.nc
    rm IBIS_S3_nbp_SPM.nc
    
    
    
## LPX-Bern_S3 -> Resolution known, What's the fucking problem?!!
     ## GPP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/LPX-Bern_S3_gpp.nc LPX-Bern_S3_gpp_SPM.nc
    cdo yearsum LPX-Bern_S3_gpp_SPM.nc LPX-Bern_S3_gpp_ANN.nc
    rm LPX-Bern_S3_gpp_SPM.nc
    
    ## NBP
    cdo mulc,86400000 -selname,gpp ./trendy_v12/LPX-Bern_S3_nbp.nc LPX-Bern_S3_nbp_SPM.nc
    cdo yearsum LPX-Bern_S3_nbp_SPM.nc LPX-Bern_S3_nbp_ANN.nc
    rm LPX-Bern_S3_nbp_SPM.nc
    
## LPJwsl_S3 -> check resolution [DONE]
    ## NBP
    cdo mulc,1000 -selname,nbp ./trendy_v12/LPJwsl_S3_nbp.nc LPJwsl_S3_nbp_G.nc
    cdo yearsum LPJwsl_S3_nbp_G.nc LPJwsl_S3_nbp_ANN.nc
    rm LPJwsl_S3_nbp_G.nc 
    
    
## ISAM_S3_nbp.nc 
    ## Written in description (ISAM_S0_nbp.nc),however file name is ISAM_S3_nbp.nc.Downloaded together with the other nbp S3 files. 
    ## -> What is correct??
