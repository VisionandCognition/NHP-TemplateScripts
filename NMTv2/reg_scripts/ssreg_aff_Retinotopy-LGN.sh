#!/bin/bash

# Use the affine registration, e.g. to compensate for head-post drop-out

# =========================
SUB=$1
# =========================

BASEFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym
SSFLD=${BASEFLD}/SingleSubjects
SCRIPTFLD=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

# Identify files
AFF_S2T=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template.1D
AFF_T2S=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template_inv.1D

SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz

RETINOTOPY_AFF_OUT=${SSFLD}/aligned_${SUB}/Retinotopy-LGN/affine
TT=${SSFLD}/aligned_${SUB}/NMT_v2.0_sym.nii.gz

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
                -source ${BASEFLD}/NMT_v2.0_sym/supplemental_RETINOTOPY/LGN/${w}/${d}_${h}.nii.gz \
                -prefix ${RETINOTOPY_AFF_OUT}/${w}/${d}_${h}.nii.gz \
                -master ${SS} \
                -1Dmatrix_apply ${AFF_T2S} \
                -interp NN -final NN -overwrite
            done
        done
    done
done