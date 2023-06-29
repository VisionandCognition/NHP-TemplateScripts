#!/bin/bash

# set the location of the scripts folder
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

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
    ${fld}/SingleSubject_reg_T2w_nonlinear_fix.sh ${S}
	echo 'DONE'
	echo '=============================================='
done

      