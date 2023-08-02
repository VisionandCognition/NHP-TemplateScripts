#!/bin/bash

# set the location of the scripts folder
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts
SSFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects

# create an array with subject names to loop over
declare -a SUBS=(
	# Aston
	# Brutus
	# Danny
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
	Scholes
	Keane
    Butch
    Kid
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Performing precon_all for ${S}
	echo '========================================='
	# perform the precon_all to create freesurfer surfaces
	mkdir ${SSFLD}/aligned_${S}/freesurfer
	cp ${SSFLD}/aligned_${S}/NMT2_in_${S}.nii.gz \
		${SSFLD}/aligned_${S}/freesurfer/NMT2_in_${S}.nii.gz 

	${fld}/precon_all/bin/surfing_safari.sh \
		-i ${SSFLD}/aligned_${S}/freesurfer/NMT2_in_${S}.nii.gz \
		-r precon_all -a NIMH_mac
	wait
	echo 'DONE'
	echo '========================================='
done
