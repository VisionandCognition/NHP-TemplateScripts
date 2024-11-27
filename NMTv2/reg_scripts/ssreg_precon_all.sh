#!/bin/bash

# =========================
# get subject name
SUB=$1
# get regtype
REGTYPE=$2

# by default this is script runs on the nonlinear registration
# only, but you can also choose to do it either just on the affine 
# registration, or on both the affine and non-linear regs.
# If you want to include the affine, make sure that you run
# the ssreg_aff_ROIs.sh script first.
# =========================

TEMPLATEFLD=${3:-'/NHP_MRI/TEMPLATES/Templates'}
NMTVERSION=${4:-'NMT_v2.0'}
NMTTYPE1=${5:-'NMT_v2.0_asym'}

SCRIPTFLD="$(dirname "$(realpath "$0")")"


# set paths ----
BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SSFLD=${BASEFLD}/SingleSubjects
PWD=$(pwd)
cd ${SCRIPTFLD}

export PCP_PATH=${SCRIPTFLD}/precon_all
export PATH=${PATH}:${PCP_PATH}


# process regtype
if [ "$REGTYPE" == "nlin" ]; then
    do_nlin=true
    do_aff=false
elif [ "$REGTYPE" == "aff" ]; then
    do_nlin=false
    do_aff=true
elif [ "$REGTYPE" == "both" ]; then
    do_nlin=true
    do_aff=true
else # assume nlin
    do_nlin=true
    do_aff=true
fi

# make folders ----
mkdir -p ${SSFLD}/aligned_${SUB}/freesurfer
if [ "$do_nlin" = true ]; then
    cp ${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz \
        ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}.nii.gz 
fi
if [ "$do_aff" = true ]; then
    cp ${SSFLD}/aligned_${SUB}/affine/NMT_aff2${SUB}.nii.gz \
        ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}_aff.nii.gz 
fi

# run precon_all ----
# move to precon folder
echo Going to precon folder: ${SCRIPTFLD}/precon_all 
cd ${SCRIPTFLD}/precon_all

# run precon_all
if [ "$do_nlin" = true ]; then
    ./bin/surfing_safari.sh \
        -i ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}.nii.gz \
        -r precon_all -a NIMH_mac
fi
if [ "$do_aff" = true ]; then
    ./bin/surfing_safari.sh \
        -i ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}_aff.nii.gz \
        -r precon_all -a NIMH_mac
fi

# back to starting folder
echo Going back to ${PWD}
cd ${PWD}