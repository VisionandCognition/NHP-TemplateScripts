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

# by default this is done on the nonlinear registration
# but you can also choose to do it either just on the affine 
# or on both the affine and non-linear
# If you want to include the affine, make sure that you run
# the ssreg_aff_ROIs.sh script first.
REGTYPE=nlin # [nlin]/aff/both


# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Performing precon_all for ${S}
	echo '========================================='
	${ssreg_dir}/ssreg_precon_all.sh ${S} ${REGTYPE} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1}
	wait
	echo 'DONE'
	echo '========================================='
done
