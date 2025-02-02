#!/bin/bash

subjects=$1

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)
chmod +x ${ssreg_dir}/*.sh # make sure all scripts can be executed

# create an array with subject names to loop over
source ${ssreg_dir}/define_subjects.sh ${subjects}

TEMPLATEFLD='/NHP_MRI/TEMPLATES/Templates'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping Retinotopy ${S}
	echo '========================================='
	# perform the affine registration
    ${ssreg_dir}/ssreg_aff_Retinotopy-LGN.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
    # perform the nonlinear registration
    ${ssreg_dir}/ssreg_nlin_Retinotopy-LGN.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	echo 'DONE'
	echo '========================================='
done