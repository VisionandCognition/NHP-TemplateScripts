#!/bin/bash

# Get an affine registration to MNI for Brainsight

# =========================
SUB=$1
COST=$2
TEMPLATEFLD=${3:-'/NHP_MRI/Template'}
NMTVERSION=${4:-'NMT_v2.0'}
NMTTYPE1=${5:-'NMT_v2.0_sym'}
NMTTYPE2=${6:-'NMT_v2.0_sym'}

script_path="$0"
SCRIPTFLD="$(dirname "$script_path")"
# =========================
BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SSFLD=${BASEFLD}/SingleSubjects
SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
SSB=${SSFLD}/aligned_${SUB}/${SUB}_nsu.nii.gz
SST=${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz
SSTB=${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz

MNI=${TEMPLATEFLD}/MNI/macaque_25_model-MNI.nii.gz
MNIB=${TEMPLATEFLD}/MNI/macaque_25_model-MNI.nii.gz


# use the minc tools to align to MNI
minctracc -lsq9 indiv.mnc model.mnc align.xfm



# affine SS to MNI
3dAllineate \
    -source ${SSB} \
    -base ${MNIB} \
    -master ${MNIB} \
    -prefix ${SSFLD}/aligned_${SUB}/NMT2-${SUB}_in_MNI.nii.gz \
    -1Dmatrix_save ${SSFLD}/aligned_${SUB}/NMT2-${SUB}_to_MNI.1D \
    -cost ${COST} \
    -overwrite
