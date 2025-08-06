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

TEMPLATEFLD=${3:-'/NHP_MRI/Template'}
NMTVERSION=${4:-'NMT_v2.0'}
NMTTYPE1=${5:-'NMT_v2.0_asym'}

# Choose whether you would like to use the brain-mask previously acquired
# and skip brain-extraction or whether you would like precon to do bet
# 'Yes' = Use the previous extraction, 'No' = Let precon scripts perform brain extraction
BRAINEX=${6:-'No'}

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

# brain-extraction options
if [ "$BRAINEX" == "No" ]; then
	Brain=''
	BET_str='';
elif [ "$BRAINEX" == "Yes" ]; then
	Brain='_brain'
	BET_str=' -n'
	
	# Apply previously acquired mask
	if [ "$do_nlin" = true ]; then
	fslmaths ${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz \
	-mas ${SSFLD}/aligned_${SUB}/${SUB}_mask.nii.gz ${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}${Brain}.nii.gz
	fi
	
	if [ "$do_aff" = true ]; then
	fslmaths ${SSFLD}/aligned_${SUB}/affine/NMT_aff2${SUB}.nii.gz \
	-mas ${SSFLD}/aligned_${SUB}/${SUB}_mask.nii.gz ${SSFLD}/aligned_${SUB}/affine/NMT_aff2${SUB}${Brain}.nii.gz
	fi
	
	fslmaths ${SSFLD}/aligned_${SUB}/${SUB}.nii.gz \
	-mas ${SSFLD}/aligned_${SUB}/${SUB}_mask.nii.gz ${SSFLD}/aligned_${SUB}/${SUB}${BRAIN}.nii.gz
fi


# make folders ----
mkdir -p ${SSFLD}/aligned_${SUB}/freesurfer
if [ "$do_nlin" = true ]; then
    cp ${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}${Brain}.nii.gz \
        ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}${Brain}.nii.gz
fi

if [ "$do_aff" = true ]; then
    cp ${SSFLD}/aligned_${SUB}/affine/NMT_aff2${SUB}${Brain}.nii.gz \
        ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}${Brain}_aff.nii.gz 
fi

# Create folder for original volume
cp ${SSFLD}/aligned_${SUB}/${SUB}${Brain}.nii.gz \
    ${SSFLD}/aligned_${SUB}/freesurfer/${SUB}${Brain}.nii.gz

# run precon_all ----
# move to precon folder
echo Going to precon folder: ${SCRIPTFLD}/precon_all 
cd ${SCRIPTFLD}/precon_all

./bin/surfing_safari_steps.sh \
        -i ${SSFLD}/aligned_${SUB}/freesurfer/${SUB}${Brain}.nii.gz \
        -r precon_2 -a NIMH_mac$BET_str
                
if [ "$do_nlin" = true ]; then
    ./bin/surfing_safari_steps.sh \
        -i ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}${Brain}.nii.gz \
        -r precon_2 -a NIMH_mac$BET_str
fi
if [ "$do_aff" = true ]; then
    ./bin/surfing_safari.sh \
        -i ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}${Brain}_aff.nii.gz \
        -r precon_2 -a NIMH_mac$BET_str
fi

# back to starting folder
echo Going back to ${PWD}
cd ${PWD}
