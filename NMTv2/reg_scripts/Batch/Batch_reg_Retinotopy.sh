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
	echo Warping Retinotopy ${S}
	echo '========================================='
	# perform the affine ROI registration
    ${ssreg_dir}/ssreg_aff_Retinotopy.sh ${S}
    # perform the nonlinear ROI registration
    ${ssreg_dir}/ssreg_nlin_Retinotopy.sh ${S}
	echo 'DONE'
	echo '========================================='
done