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
    # Pitt_20230912
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '=============================================='
	echo Alligning center of scan to NMT: ${S}
	echo '=============================================='
	# run the preparation script
    ${ssreg_dir}/ssreg_prep.sh ${S}
	echo 'DONE'
	echo '=============================================='
done

      