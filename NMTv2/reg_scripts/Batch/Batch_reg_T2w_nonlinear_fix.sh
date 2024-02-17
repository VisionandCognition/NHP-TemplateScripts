#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)
chmod +x ${ssreg_dir}/*.sh # make sure all scripts can be executed

# create an array with subject names to loop over
source ${ssreg_dir}/define_subjects.sh

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '=============================================='
	echo Alligning center of scan to NMT: ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1}
	echo '=============================================='
	# run the preparation script
    ${ssreg_dir}/ssreg_T2w_nonlinear_fix.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1}
	echo 'DONE'
	echo '=============================================='
done

      