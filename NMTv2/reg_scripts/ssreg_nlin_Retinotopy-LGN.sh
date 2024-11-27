#!/bin/bash

# Use the nonlinear registration

# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/TEMPLATES/Templates'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_asym'}
NMTTYPE2=${5:-'NMT_v2.0_asym'}

script_path="$0"
SCRIPTFLD="$(dirname "$script_path")"
# =========================
BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SSFLD=${BASEFLD}/SingleSubjects

# Identify files
AFF_S2T=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template.1D
AFF_T2S=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template_inv.1D
NL_S2T=${SSFLD}/aligned_${SUB}/${SUB}_shft_WARP.nii.gz
NL_T2S=${SSFLD}/aligned_${SUB}/${SUB}_shft_WARPINV.nii.gz

fw_T2S=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_base2osh_WARP.nii.gz
fwsh_T2S=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_inv.1D
fw_S2T=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_osh2base_WARP.nii.gz
fwsh_S2T=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft.1D

SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
RETINOTOPY_NL_OUT=${SSFLD}/aligned_${SUB}/Retinotopy-LGN/nonlinear

TT=${SSFLD}/aligned_${SUB}/${NMTTYPE2}.nii.gz

# make folders
mkdir -p ${RETINOTOPY_NL_OUT}

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
            mkdir -p ${RETINOTOPY_NL_OUT}/${w}

            3dNwarpApply \
                -source ${BASEFLD}/${NMTTYPE2}/supplemental_RETINOTOPY/LGN/${w}/${d}_${h}.nii.gz \
                -prefix ${RETINOTOPY_NL_OUT}/${w}/${d}_${h}.nii.gz \
                -master ${SS} \
                -nwarp  ${fw_T2S} \
                -interp NN -overwrite  

            @Align_Centers -overwrite \
                    -no_cp \
                    -base ${TT} \
                    -dset ${RETINOTOPY_NL_OUT}/${w}/${d}_${h}.nii.gz \
                    -shift_xform_inv ${fwsh_T2S} 
        done
    done
done