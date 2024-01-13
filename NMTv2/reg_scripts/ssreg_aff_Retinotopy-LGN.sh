#!/bin/bash

# Use the affine registration, e.g. to compensate for head-post drop-out

# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/Template'}
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

RETINOTOPY_AFF_OUT=${SSFLD}/aligned_${SUB}/Retinotopy-LGN/affine
TT=${SSFLD}/aligned_${SUB}/${NMTTYPE2}.nii.gz

# make folders
mkdir -p ${RETINOTOPY_AFF_OUT}

declare -a wfld=(
    LGN-Retmap_in_NMTv2.0_nowarp
    LGN-Retmap_in_NMTv2.0_aff
    LGN-Retmap_in_NMTv2.0_nonlin
    )

declare -a hf=(L R)
declare -a dt=(
    mask
    CELLS
    ECC
    INCL
    LAYERS
    )

for w in "${wfld[@]}"
do
    for d in "${dt[@]}"
    do
        for h in "${hf[@]}"
        do
            mkdir -p ${RETINOTOPY_AFF_OUT}/${w}

            3dAllineate \
                -source ${BASEFLD}/${NMTTYPE1}/supplemental_RETINOTOPY/LGN/${w}/${d}_${h}.nii.gz \
                -prefix ${RETINOTOPY_AFF_OUT}/${w}/${d}_${h}.nii.gz \
                -master ${SS} \
                -1Dmatrix_apply ${AFF_T2S} \
                -interp NN -final NN -overwrite
            done
        done
    done
done