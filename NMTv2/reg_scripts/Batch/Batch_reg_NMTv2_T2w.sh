#!/bin/bash

# set the location of the scripts folder
fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

# create an array with subject names to loop over
declare -a SUBS=(
	# Figaro_T2w
	# Scholes
    # Keane
    # Butch
    Kid
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
	${fld}/ssreg_NMTv2.sh ${S} ${COST}
	wait
	# convert gifti surface files to meshes
	${fld}/aw_gii2ply.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done
