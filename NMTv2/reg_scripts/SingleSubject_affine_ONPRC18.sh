#!/bin/bash

# Use the affine registration, e.g. to compensate for head-post drop-out

# =========================
SUB=$1
# =========================

BASEFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym
SSFLD=${BASEFLD}/SingleSubjects
SCRIPTFLD=${SSFLD}/reg_scripts

# Identify files
AFF_S2T=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template.1D
AFF_T2S=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template_inv.1D

SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
SS_AFF_OUT=${SSFLD}/aligned_${SUB}/affine
TT=${SSFLD}/aligned_${SUB}/NMT_v2.0_sym.nii.gz

ONPRC_SUPP=${BASEFLD}/NMT_v2.0_sym/supplemental_ONPRC18 

# make folders
mkdir -p ${SS_AFF_OUT}
mkdir -p ${SS_AFF_OUT}/ONPRC18

# warp tensors ======================================================
IN=${ONPRC_SUPP}/ONPRC18_DTI_tensors_in_NMT_v2.0_sym_ro.nii.gz
OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_tensors_in_${SUB}.nii.gz
OUT2=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_tensors_in_${SUB}_ro.nii.gz
TRANSFORM=${AFF_T2S}
REF=${SS}
INTERP=Linear

# echo Transforming ${IN}
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3 \
#                     -e 2
# ReorientTensorImage 3 ${OUT} ${OUT2} ${TRANSFORM}

# >> CHeck if this works?
3dAllineate \
    -source ${IN} \
    -prefix ${OUT} \
    -master ${REF} \
    -1Dmatrix_apply ${TRANSFORM} \
    -interp linear -final cubic -overwrite
ReorientTensorImage 3 ${OUT} ${OUT2} ${TRANSFORM}




# IN=${ONPRC_SUPP}/ONPRC18_DTI_b0_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_b0_in_${SUB}.nii.gz
# echo Transforming ${IN}
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3 \

# IN=${ONPRC_SUPP}/ONPRC18_DTI_rgb_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_rgb_in_${SUB}.nii.gz
# echo Transforming ${IN}
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3 \

# IN=${ONPRC_SUPP}/ONPRC18_DTI_fa_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_fa_in_${SUB}.nii.gz
# echo Transforming ${IN}
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3 \

# IN=${ONPRC_SUPP}/ONPRC18_DTI_rd_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_rd_in_${SUB}.nii.gz
# echo Transforming ${IN}
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3 \

# IN=${ONPRC_SUPP}/ONPRC18_DTI_ad_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_ad_in_${SUB}.nii.gz
# echo Transforming ${IN}
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3 \

# IN=${ONPRC_SUPP}/ONPRC18_DTI_tr_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_tr_in_${SUB}.nii.gz
# echo Transforming ${IN}
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3 \



# # warp labelmaps ======================================================
# IN=${ONPRC_SUPP}/ONPRC18_GrayMatterLabelmap_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_GrayMatterLabelmap_in_${SUB}.nii.gz
# INTERP=NearestNeighbor
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3

# IN=${ONPRC_SUPP}/ONPRC18_ONPRC18_GrayMatterLabelmapCondensed_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_ONPRC18_GrayMatterLabelmapCondensed_in_${SUB}.nii.gz
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3

# IN=${ONPRC_SUPP}/ONPRC18_ONPRC18_GrayMatterWhiteMatterLabelmap_in_NMT_v2.0_sym.nii.gz
# OUT=${SS_AFF_OUT}/ONPRC18/ONPRC18_ONPRC18_GrayMatterWhiteMatterLabelmap_in_${SUB}.nii.gz
# antsApplyTransforms -i ${IN} \
#                     -r ${REF} \
#                     -o ${OUT} \
#                     -t ${TRANSFORM} \
#                     -n ${INTERP} \
#                     -d 3

# # copy the LUTs too
# echo Copying labelmaps
# cp ${ONPRC_SUPP}/*.txt ${SS_AFF_OUT}/ONPRC18/
# cp ${ONPRC_SUPP}/*.tsv ${SS_AFF_OUT}/ONPRC18/
