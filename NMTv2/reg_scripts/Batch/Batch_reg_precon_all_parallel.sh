#!/bin/bash

subjects=$1

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)
chmod +x ${ssreg_dir}/*.sh # make sure all scripts can be executed

# create an array with subject names to loop over
source ${ssreg_dir}/define_subjects.sh ${subjects}

# by default this is done on the nonlinear registration
# but you can also choose to do it either just on the affine 
# or on both the affine and non-linear
# If you want to include the affine, make sure that you run
# the ssreg_aff_ROIs.sh script first.
REGTYPE=nlin # [nlin]/aff/both

TEMPLATEFLD='/NHP_MRI/TEMPLATES/Templates'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'


# Define the number of parallel processes
PARPROC=3
echo '========================================='
echo 'Registering in parallel nproc '${PARPROC}
echo '========================================='

# Create an array to hold process IDs
declare -a pids=()

# Function to run the registration for a subject
run_registration() {
    echo Performing precon_all for ${S}
    ${ssreg_dir}/ssreg_precon_all.sh ${S} ${REGTYPE} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1}
}

# Loop over subjects and run in parallel
for S in "${SUBS[@]}"; do
    # Run registration in background
    run_registration &
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
