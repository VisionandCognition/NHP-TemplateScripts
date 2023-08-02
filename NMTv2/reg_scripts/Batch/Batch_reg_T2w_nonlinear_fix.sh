#!/bin/bash

# set the location of the scripts folder
fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

# create an array with subject names to loop over
declare -a SUBS=(
    Scholes
    Keane
    Butch
    Kid
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '=============================================='
	echo Alligning center of scan to NMT: ${S}
	echo '=============================================='
	# run the preparation script
    ${fld}/ssreg_T2w_nonlinear_fix.sh ${S}
	echo 'DONE'
	echo '=============================================='
done

      