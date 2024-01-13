#!/bin/bash

# set the location of the scripts folder
script_path="$0"
script_dir="$(dirname "$script_path")"
ssreg_dir="$(dirname "$script_dir")"

# create an array with subject names to loop over
declare -a SUBS=(
    #Scholes
    #Keane
    #Butch
    #Kid
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '=============================================='
	echo Alligning center of scan to NMT: ${S}
	echo '=============================================='
	# run the preparation script
    ${ssreg_dir}/ssreg_T2w_nonlinear_fix.sh ${S}
	echo 'DONE'
	echo '=============================================='
done

      