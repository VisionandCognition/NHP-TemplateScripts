#!/bin/bash

# set the location of the scripts folder
script_path="$0"
script_dir="$(dirname "$script_path")"
ssreg_dir="$(dirname "$script_dir")"

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
     # Pitt_20230912
	)

# cost function: lpa for T1w, lpc for T2w
COST=lpa
ALIGN=all

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'


# Define the number of parallel processes
PARPROC=8
echo '========================================='
echo 'Registering in parallel nproc '${PARPROC}
echo '========================================='

# Create an array to hold process IDs
declare -a pids=()

# Function to run the registration for a subject
run_registration() {
    S=$1
    echo Registering template and atlases to ${S}
    # perform the registration
    ${ssreg_dir}/ssreg_NMTv2.sh ${S} ${COST} ${ALIGN} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
    wait
    # convert gifti surface files to meshes
	  ${ssreg_dir}/aw_gii2ply.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1}
}

# Loop over subjects and run in parallel
for S in "${SUBS[@]}"; do
    # Run registration in background
    run_registration "$S" &
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