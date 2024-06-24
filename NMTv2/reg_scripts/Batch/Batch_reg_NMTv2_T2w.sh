#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)

# create an array with subject names to loop over
source ${ssreg_dir}/define_subjects.sh 'T2w'

# cost function: lpa for T1w, lpc for T2w
COST=lpc
ALLIGN=all

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	# perform the registration
	${ssreg_dir}/ssreg_NMTv2.sh ${S} ${COST} ${ALLIGN} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	wait
	# convert gifti surface files to meshes
	${ssreg_dir}/aw_gii2ply.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1}
	wait
	echo 'DONE'
	echo '========================================='
done
