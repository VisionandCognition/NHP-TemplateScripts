#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)

# create an array with subject names to loop over
source ${ssreg_dir}/define_subjects.sh

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Doing a posthoc alignment of D99v2 for ${S}
	echo '========================================='
	# perform the registration
  ${ssreg_dir}/D99v2_to_SS.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	wait
	echo 'DONE'
	echo '========================================='
done

