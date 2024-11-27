#!/bin/bash

# call with subject name as argument
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/TEMPLATES/Templates'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_sym'}
NMTTYPE2=${5:-'NMT_v2.0_sym'}

script_path="$0"
SCRIPTFLD="$(dirname "$script_path")"
# =========================
BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SS_FLD=${BASEFLD}/SingleSubjects/aligned_${SUB}

echo -----------------------------
echo Subject ${SUB} - Brain Extract
echo -----------------------------

echo == FSL masking ===
# use fsl masking
fslmaths ${SS_FLD}/${SUB}.nii.gz -mas ${SS_FLD}/${SUB}_mask.nii.gz ${SS_FLD}/${SUB}_brain.nii.gz
fslmaths ${SS_FLD}/NMT2_in_${SUB}.nii.gz -mas ${SS_FLD}/${SUB}_mask.nii.gz ${SS_FLD}/NMT2_in_${SUB}_brain.nii.gz

echo
echo '=== UNet brain extraction (needs some python) ==='
# use UNET
UNET_code=${SCRIPTFLD}/UNet_Model
mkdir -p ${SS_FLD}/UNet_brainextract

python3 ${UNET_code}/muSkullStrip.py -in ${SS_FLD}/${SUB}.nii.gz \
	-model ${UNET_code}/models/Site-All-T-epoch_36_update_with_Site_6_plus_7-epoch_39.model \
	-out ${SS_FLD}/UNet_brainextract

# use fsl masking
fslmaths ${SS_FLD}/${SUB}.nii.gz -mas ${SS_FLD}/UNet_brainextract/${SUB}_pre_mask.nii.gz \
	${SS_FLD}/UNet_brainextract/${SUB}_brain_unet.nii.gz
fslmaths ${SS_FLD}/NMT2_in_${SUB}.nii.gz -mas ${SS_FLD}/UNet_brainextract/${SUB}_pre_mask.nii.gz \
	${SS_FLD}/UNet_brainextract/NMT2_in_${SUB}_brain_unet.nii.gz