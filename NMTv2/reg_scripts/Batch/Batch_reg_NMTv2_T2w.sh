#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)

# create an array with subject names to loop over
declare -a SUBS=(
	# Figaro_T2w
	# Scholes
    # Keane
    # Butch
    # Kid
    # Martin2023_T2wus
	)

# cost function: lpa for T1w, lpc for T2w
COST=lpc
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
