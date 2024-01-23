#!/bin/bash

# set the location of the scripts folder
script_path="$0"
script_dir="$(dirname "$script_path")"
ssreg_dir="$(dirname "$script_dir")"

# create an array with subject names to loop over
declare -a SUBS=(
	# Pitt_20230912
	1MM015
    CIA073
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping ONPRC18 DTI template ${S}
	echo '========================================='
	# perform the affine tensor registration
	${ssreg_dir}/ssreg_aff_ONPRC18.sh ${S}
	wait
	# perform the nonlinear tensor registration
	${ssreg_dir}/ssreg_nlin_ONPRC18.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done
