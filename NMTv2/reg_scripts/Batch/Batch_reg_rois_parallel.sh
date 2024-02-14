#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)

# create an array with subject names to loop over
declare -a SUBS=(
    Aston
    Brutus
    Danny
    Danny2021
    Danny2022
    Dasheng
    Eddy
    Eddy2019
    Figaro
    Kwibus
    Kwibus2015
    Lick
    Martin
    Martin2021
    Martin2023
    Martin2023us
    MrNilson
    Ozzy
    Puck
    Spike
    Toucan
    Tsitian
    Watson
    Diego2018
    #Figaro_T2w
    #Martin2023_T2w
	#Martin2023_T2wus
	# Pitt_20230912
	#Scholes
    #Keane
    #Butch
    #Kid
    #1MM015
    #CIA073
	)

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'

PARPROC=3


# Function to run the registration for a subject
run_rois() {
    # perform the affine ROI registration
    ${ssreg_dir}/ssreg_aff_ROIs.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
    # perform the nonlinear ROI registration
    ${ssreg_dir}/ssreg_nlin_ROIs.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
}

# Loop over subjects and run in parallel
for S in "${SUBS[@]}"; do
    # Run registration in background
    run_rois &
    pids+=($!)  # Store the process ID of the background process
    if [[ ${#pids[@]} -ge ${PARPROC} ]]; then
        # Wait for processes to finish
        for pid in "${pids[@]}"; do
            wait $pid
        done
        pids=()  # Reset the array of process IDs
    fi
done

# Wait for remaining processes to finish
for pid in "${pids[@]}"; do
    wait $pid
done
