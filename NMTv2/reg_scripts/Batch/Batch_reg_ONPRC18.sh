#!/bin/bash

# set the location of the scripts folder
fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

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
	# Scholes
	# Keane
    # Butch
    # Kid
    # Diego2018
    Puck
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping ONPRC18 DTI template ${S}
	echo '========================================='
	# perform the affine tensor registration
	${fld}/ssreg_aff_ONPRC18.sh ${S} 
	wait
	# perform the nonlinear tensor registration
	${fld}/ssreg_nlin_ONPRC18.sh ${S} 
	wait
	echo 'DONE'
	echo '========================================='
done
