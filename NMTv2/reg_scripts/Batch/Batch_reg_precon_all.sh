#!/bin/bash

# set the location of the scripts folder
fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

# create an array with subject names to loop over
declare -a SUBS=(
	# Brutus
	# Watson
	# Scholes
	# Keane
    # Butch
    # Kid	
	# Toucan
	# Ozzy
	# Danny
	# Danny2021
	Danny2022 
	# Aston
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
	# Martin2023_T2w
	# MrNilson
	# Spike
	# Tsitian
	# Diego2018
	# Puck
	)

# by default this is done on the nonlinear registration
# but you can also choose to do it either just on the affine 
# or on both the affine and non-linear
# If you want to include the affine, make sure that you run
# the ssreg_aff_ROIs.sh script first.
REGTYPE=aff # [nlin]/aff/both


# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Performing precon_all for ${S}
	echo '========================================='
	${fld}/ssreg_precon_all.sh ${S} ${REGTYPE} 
	wait
	echo 'DONE'
	echo '========================================='
done
