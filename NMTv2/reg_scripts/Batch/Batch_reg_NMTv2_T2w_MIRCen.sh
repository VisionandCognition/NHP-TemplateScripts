#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)

# create an array with subject names to loop over
declare -a SUBS=(
	 Scholes
   Keane
   Butch
   Kid
   1MM015
   CIA073
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	# 1) do the affine part (we need a workaround for good nonlinear with T2w)
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	COST=lpc # cost function: lpa for T1w, lpc for T2w
	ALLIGN=affine
	# perform the registration
	${ssreg_dir}/ssreg_NMTv2.sh ${S} ${COST} ${ALLIGN}
	wait
	# convert gifti surface files to meshes
	${ssreg_dir}/aw_gii2ply_aff.sh ${S}
	wait
	echo 'DONE'
	echo ''

	# 2) make the affine T2w look like T1w and get 3dQwarp result
	echo '========================================='
	echo Fixing T2w to look like T1w for ${S}
	echo '========================================='
	# run the procedure
	${ssreg_dir}/ssreg_T2w_imitates_T1w.sh ${S}
	wait
	echo 'DONE'
	echo ''

	# 3) do the non-linear part with the warps calculated in step 2
	COST=lpa # cost function: lpa for T1w, lpc for T2w
	ALLIGN=all

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
	echo ''
done

