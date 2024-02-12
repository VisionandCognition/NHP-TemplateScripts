#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)

# create an array with subject names to loop over
declare -a SUBS=(
    # Pitt_20230912
    1MM015
    CIA073
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '=============================================='
	echo Alligning center of scan to NMT: ${S}
	echo '=============================================='
	# run the preparation script
    ${ssreg_dir}/ssreg_prep.sh ${S}
	echo 'DONE'
	echo '=============================================='
done

      