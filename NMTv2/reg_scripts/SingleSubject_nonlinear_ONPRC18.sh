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
NL_S2T=${SSFLD}/aligned_${SUB}/${SUB}_shft_WARP.nii.gz
NL_T2S=${SSFLD}/aligned_${SUB}/${SUB}_shft_WARPINV.nii.gz


SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
SS_AFF_OUT=${SSFLD}/aligned_${SUB}/affine
SS_NL_OUT=${SSFLD}/aligned_${SUB}/nonlinear
TT=${SSFLD}/aligned_${SUB}/NMT_v2.0_sym.nii.gz

ONPRC_SUPP=${BASEFLD}/NMT_v2.0_sym/supplemental_ONPRC18 

# make folders
mkdir -p ${SS_NL_OUT}
mkdir -p ${SS_NL_OUT}/ONPRC18

# warp tensors ======================================================
IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_tensors_in_${SUB}_ro.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_tensors_in_${SUB}.nii.gz
OUT2=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_tensors_in_${SUB}_ro.nii.gz
TRANSFORM=${NL_T2S}
REF=${SS}
INTERP=Linear

echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3 \
                    -e 2
ReorientTensorImage 3 ${OUT} ${OUT2} ${TRANSFORM}


IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_b0_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_b0_in_${SUB}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3 \

IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_rgb_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_rgb_in_${SUB}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3 \

IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_fa_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_fa_in_${SUB}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3 \

IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_rd_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_rd_in_${SUB}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3 \

IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_ad_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_ad_in_${SUB}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3 \

IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_DTI_tr_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_DTI_tr_in_${SUB}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3 \



# warp labelmaps ======================================================
IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_GrayMatterLabelmap_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_GrayMatterLabelmap_in_${SUB}.nii.gz
INTERP=NearestNeighbor
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3

IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_ONPRC18_GrayMatterLabelmapCondensed_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_ONPRC18_GrayMatterLabelmapCondensed_in_${SUB}.nii.gz
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3

IN=${SS_AFF_OUT}/ONPRC18/ONPRC18_ONPRC18_GrayMatterWhiteMatterLabelmap_in_${SUB}.nii.gz
OUT=${SS_NL_OUT}/ONPRC18/ONPRC18_ONPRC18_GrayMatterWhiteMatterLabelmap_in_${SUB}.nii.gz
antsApplyTransforms -i ${IN} \
                    -r ${REF} \
                    -o ${OUT} \
                    -t ${TRANSFORM} \
                    -n ${INTERP} \
                    -d 3

# copy the LUTs too
echo Copying labelmaps
cp ${ONPRC_SUPP}/*.txt ${SS_NL_OUT}/ONPRC18/
cp ${ONPRC_SUPP}/*.tsv ${SS_NL_OUT}/ONPRC18/
