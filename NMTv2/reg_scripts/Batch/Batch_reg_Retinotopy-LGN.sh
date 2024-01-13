#!/bin/bash

# set the location of the scripts folder
script_path="$0"
script_dir="$(dirname "$script_path")"
ssreg_dir="$(dirname "$script_dir")"

# create an array with subject names to loop over
declare -a SUBS=(
	# Aston    
    # Brutus    
    # Danny    
    # Danny2021    
    # Danny2022
    # Dasheng    
    # Eddy    
    # Eddy2019    
    # Figaro  
    # Figaro_T2w 
    # Kwibus    
    # Kwibus2015    
    # Lick    
    # Martin    
    # Martin2021 
    # Martin2023
    # Martin2023_T2w
    # Mircen20221025
    # Mircen20230105
    # Mircen20230314   
    # MrNilson    
    # Ozzy    
    # Spike    
    # Toucan    
    # Tsitian    
    # Watson 
    # Scholes
    # Keane
    # Butch
    # Kid
    # Diego2018
    # Puck
    # Martin2023us
    # Martin2023_T2wus
    # Pitt_20230912
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping Retinotopy ${S}
	echo '========================================='
	# perform the affine registration
    ${ssreg_dir}/ssreg_aff_Retinotopy-LGN.sh ${S}
    # perform the nonlinear registration
    ${ssreg_dir}/ssreg_nlin_Retinotopy-LGN.sh ${S}
	echo 'DONE'
	echo '========================================='
done