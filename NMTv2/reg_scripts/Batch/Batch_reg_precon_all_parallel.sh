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
  Figaro_T2w
	Martin2023_T2w
	Martin2023_T2wus
	# Pitt_20230912
	Scholes
  Keane
  Butch
  Kid
  1MM015
  CIA073
	)

# by default this is done on the nonlinear registration
# but you can also choose to do it either just on the affine 
# or on both the affine and non-linear
# If you want to include the affine, make sure that you run
# the ssreg_aff_ROIs.sh script first.
REGTYPE=nlin # [nlin]/aff/both

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'


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
    echo Performing precon_all for ${S}
    ${ssreg_dir}/ssreg_precon_all.sh ${S} ${REGTYPE} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1}
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
