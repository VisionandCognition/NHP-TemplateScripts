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
    # Kwibus    
    # Kwibus2015    
    # Lick    
    # Martin    
    # Martin2021  
    # Martin2023  
    # MrNilson    
    # Ozzy    
    # Spike    
    # Toucan    
    # Tsitian    
    # Watson 
    # Diego2018
    # Puck
    # Martin2023us
    # Pitt_20230912
	)

# cost function: lpa for T1w, lpc for T2w
COST=lpa
ALLIGN=all

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	# perform the registration
    ${ssreg_dir}/ssreg_NMTv2.sh ${S} ${COST} ${ALLIGN}
	wait
    # convert gifti surface files to meshes
	${ssreg_dir}/aw_gii2ply.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done
