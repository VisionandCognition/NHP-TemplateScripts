#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)
chmod +x ${ssreg_dir}/*.sh # make sure all scripts can be executed

# create an array with subject names to loop over
source ${ssreg_dir}/define_subjects.sh

TEMPLATEFLD='/NHP_MRI/TEMPLATES/Templates'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping ONPRC18 DTI template ${S}
	echo '========================================='
	# perform the affine tensor registration
	${ssreg_dir}/ssreg_aff_ONPRC18.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	wait
	# perform the nonlinear tensor registration
	${ssreg_dir}/ssreg_nlin_ONPRC18.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	wait
	echo 'DONE'
	echo '========================================='
done
