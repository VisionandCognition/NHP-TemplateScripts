#!/bin/bash

# set the location of the scripts folder
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

# create an array with subject names to loop over
declare -a SUBS=(
	# Figaro_T2w
	)

# cost function: lpa for T1w, lpc for T2w
COST=lpc

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	# perform the registration
	${fld}/SingleSubject_reg_NMTv2.sh ${S} ${COST}
	wait
	# convert gifti surface files to meshes
	${fld}/animalwarper_gii2ply.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done