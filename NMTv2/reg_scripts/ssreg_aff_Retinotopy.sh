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

RETINOTOPY_AFF_OUT=${SSFLD}/aligned_${SUB}/Retinotopy/affine
TT=${SSFLD}/aligned_${SUB}/${NMTTYPE2}.nii.gz

# make folders
mkdir -p ${RETINOTOPY_AFF_OUT}/pe

declare -a pe=(
    ecc
    pol_deg
    )

for p in "${pe[@]}"
do
    3dAllineate \
        -source ${BASEFLD}/${NMTTYPE2}/supplemental_RETINOTOPY/pe_ret_kul/${p}.nii.gz \
        -prefix ${RETINOTOPY_AFF_OUT}/pe/${p}.nii.gz \
        -master ${SS} \
        -1Dmatrix_apply ${AFF_T2S} \
        -interp NN -final NN -overwrite
done

declare -a subs=(
    m029
    m030
    m029m030
    )

declare -a maps=(
    ecc
    mask_r2th_5
    pol_deg
    r2
    sigma
    x
    y
    )

for s in "${subs[@]}"
do
    mkdir -p ${RETINOTOPY_AFF_OUT}/prf/${s}
    for m in "${maps[@]}"
    do
        3dAllineate \
            -source ${BASEFLD}/${NMTTYPE2}/supplemental_RETINOTOPY/prf/${s}/${m}.nii.gz \
            -prefix ${RETINOTOPY_AFF_OUT}/prf/${s}/${m}.nii.gz \
            -master ${SS} \
            -1Dmatrix_apply ${AFF_T2S} \
            -interp NN -final NN -overwrite
    done
done

# make one premasked folder at R2 > 5
declare -a maps=(
    ecc
    pol_deg
    r2
    sigma
    x
    y
    )

for s in "${subs[@]}"
do
    mkdir -p ${RETINOTOPY_AFF_OUT}/prf/${s}/th5
    for m in "${maps[@]}"
    do
        3dcalc -a ${RETINOTOPY_AFF_OUT}/prf/${s}/${m}.nii.gz -b ${RETINOTOPY_AFF_OUT}/prf/${s}/mask_r2th_5.nii.gz -expr "(a*b)+((b-1)*99)" \
            -prefix ${RETINOTOPY_AFF_OUT}/prf/${s}/th5/${m}.nii.gz -overwrite
    done
done