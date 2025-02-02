#!/bin/bash

subjects=$1

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)
chmod +x ${ssreg_dir}/*.sh # make sure all scripts can be executed
echo $ssreg_dir

# create an array with subject names to loop over
source ${ssreg_dir}/define_subjects.sh ${subjects}

# cost function: lpa for T1w, lpc for T2w
COST=lpa
# alignment option rigid / rigid_equiv / affine / all
ALIGN=all

TEMPLATEFLD='/NHP_MRI/TEMPLATES/Templates'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'


# Define the number of parallel processes
PARPROC=3
echo '========================================='
echo 'Registering in parallel nproc '${PARPROC}
echo '========================================='

# Create an array to hold process IDs
declare -a pids=()

# Function to run the registration for a subject
run_registration() {
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
