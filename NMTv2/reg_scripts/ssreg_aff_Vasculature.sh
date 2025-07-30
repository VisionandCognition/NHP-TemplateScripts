#!/bin/bash

# Use the affine registration, e.g. to compensate for head-post drop-out

# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/TEMPLATES/Templates'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_sym'}
NMTTYPE2=${5:-'NMT_v2.0_sym'}

script_path="$0"
SCRIPTFLD="$(dirname "$script_path")"
# =========================
BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SSFLD=${BASEFLD}/SingleSubjects

# Identify files
AFF_S2T=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template.1D
AFF_T2S=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template_inv.1D

SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz

VASC_AFF_OUT=${SSFLD}/aligned_${SUB}/Vasculature/affine
TT=${SSFLD}/aligned_${SUB}/${NMTTYPE2}.nii.gz

# make folders
mkdir -p ${VASC_AFF_OUT}

declare -a subs=(
    Dasheng
    Tsitian
    )

for s in "${subs[@]}"
do
    3dAllineate \
        -source ${BASEFLD}/${NMTTYPE2}/supplemental_VASCULATURE/${s}_Vasculature-in-NMT_binary.nii.gz \
        -prefix ${VASC_AFF_OUT}/Vasc_${s}_in_${SUB}_bin.nii.gz \
        -master ${SS} \
        -1Dmatrix_apply ${AFF_T2S} \
        -interp NN -final NN -overwrite

    3dAllineate \
        -source ${BASEFLD}/${NMTTYPE2}/supplemental_VASCULATURE/${s}_Vasculature-in-NMT.nii.gz \
        -prefix ${VASC_AFF_OUT}/Vasc_${s}_in_${SUB}.nii.gz \
        -master ${SS} \
        -1Dmatrix_apply ${AFF_T2S} \
        -interp linear -final linear -overwrite
done

