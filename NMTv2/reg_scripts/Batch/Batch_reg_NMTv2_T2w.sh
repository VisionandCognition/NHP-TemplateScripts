#!/bin/bash

# set the location of the scripts folder
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

# create an array with subject names to loop over
declare -a SUBS=(
	# Figaro_T2w
	# Scholes
    # Keane
    Butch
    # Kid
	)


# 1) do the affine part (we need a workaround for good nonlinear with T2w)
COST=lpc # cost function: lpa for T1w, lpc for T2w
ALLIGN=affine

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	# perform the registration
	${fld}/SingleSubject_reg_NMTv2.sh ${S} ${COST} ${ALLIGN}
	wait
	# convert gifti surface files to meshes
	${fld}/animalwarper_gii2ply_aff.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done


# 2) make the affine T2w look like T1w and get 3dQwarp result







# 3) do the non-linear part (we need a workaround for good nonlinear with T2w)
COST=lpa # cost function: lpa for T1w, lpc for T2w
ALLIGN=all

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	# perform the registration
	${fld}/SingleSubject_reg_NMTv2.sh ${S} ${COST} ${ALLIGN}
	wait
	# convert gifti surface files to meshes
	${fld}/animalwarper_gii2ply.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done

