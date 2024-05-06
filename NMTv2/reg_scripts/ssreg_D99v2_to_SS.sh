#!/bin/bash
# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/Template'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_asym'}
NMTTYPE2=${5:-'NMT_v2.0_asym'}

SCRIPTFLD=$(realpath $(dirname $0))
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
SS_AFF_OUT=${SSFLD}/aligned_${SUB}/affine
SS_NL_OUT=${SSFLD}/aligned_${SUB}/nonlinear
TT=${SSFLD}/aligned_${SUB}/${NMTTYPE2}.nii.gz

D99v2=${BASEFLD}/${NMTTYPE2}/D99v2_atlas_in_${NMTTYPE2}.nii.gz
D99v2_LFLD=${BASEFLD}/tables_D99

cp -R ${D99v2_LFLD} ${SSFLD}/aligned_${SUB}/

# affine ------------------
3dAllineate \
  -source ${D99v2} \
  -prefix ${SS_AFF_OUT}/D99v2_atlas_in_${NMTTYPE2}_aff2${SUB}.nii.gz \
  -master ${SS} \
  -1Dmatrix_apply ${AFF_T2S} \
  -interp NN -final NN -overwrite


# Nonlinear --------------------
3dNwarpApply \
    -source ${D99v2} \
    -prefix ${SS_NL_OUT}/D99v2_atlas_in_${NMTTYPE2}_nl2${SUB}.nii.gz \
    -master ${SS} \
    -nwarp  ${fw_T2S} \
    -interp NN -overwrite

@Align_Centers -overwrite \
          -no_cp \
          -base ${TT} \
          -dset ${SS_NL_OUT}/D99v2_atlas_in_${NMTTYPE2}_nl2${SUB}.nii.gz \
          -shift_xform_inv ${fwsh_T2S}

3dNwarpApply \
    -source ${D99v2} \
    -prefix ${SSFLD}/aligned_${SUB}/D99v2_atlas_in_${NMTTYPE2}_in_${SUB}.nii.gz \
    -master ${SS} \
    -nwarp  ${fw_T2S} \
    -interp NN -overwrite

@Align_Centers -overwrite \
          -no_cp \
          -base ${TT} \
          -dset ${SSFLD}/aligned_${SUB}/D99v2_atlas_in_${NMTTYPE2}_in_${SUB}.nii.gz \
          -shift_xform_inv ${fwsh_T2S}
