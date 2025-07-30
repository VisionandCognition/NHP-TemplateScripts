#!/bin/bash

# Use the nonlinear registration

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
NL_S2T=${SSFLD}/aligned_${SUB}/${SUB}_shft_WARP.nii.gz
NL_T2S=${SSFLD}/aligned_${SUB}/${SUB}_shft_WARPINV.nii.gz

fw_T2S=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_base2osh_WARP.nii.gz
fwsh_T2S=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_inv.1D
fw_S2T=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_osh2base_WARP.nii.gz
fwsh_S2T=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft.1D

SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
VASC_NL_OUT=${SSFLD}/aligned_${SUB}/Vasculature/nonlinear

TT=${SSFLD}/aligned_${SUB}/${NMTTYPE2}.nii.gz

# make folders
mkdir -p ${VASC_NL_OUT}

declare -a subs=(
    Dasheng
    Tsitian
    )

for s in "${subs[@]}"
do
    3dNwarpApply \
        -source ${BASEFLD}/${NMTTYPE1}/supplemental_VASCULATURE/${s}_Vasculature-in-NMT_binary.nii.gz \
        -prefix ${VASC_NL_OUT}/Vasc_${s}_in_${SUB}_bin.nii.gz \
        -master ${SS} \
        -nwarp  ${fw_T2S} \
        -interp NN -overwrite  

    @Align_Centers -overwrite \
        -no_cp \
        -base ${TT} \
        -dset ${VASC_NL_OUT}/Vasc_${s}_in_${SUB}_bin.nii.gz \
        -shift_xform_inv ${fwsh_T2S}

    3dNwarpApply \
        -source ${BASEFLD}/${NMTTYPE1}/supplemental_VASCULATURE/${s}_Vasculature-in-NMT.nii.gz \
        -prefix ${VASC_NL_OUT}/Vasc_${s}_in_${SUB}.nii.gz \
        -master ${SS} \
        -nwarp  ${fw_T2S} \
        -interp linear -overwrite  

    @Align_Centers -overwrite \
        -no_cp \
        -base ${TT} \
        -dset ${VASC_NL_OUT}/Vasc_${s}_in_${SUB}.nii.gz \
        -shift_xform_inv ${fwsh_T2S}
done
