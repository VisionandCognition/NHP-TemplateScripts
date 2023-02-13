#!/bin/bash

# Apply transforms to ONPRC18
# Requires ANTs

# SET UP FOLDER PATHS ==========================
#ONPRC_FLD=/NHP_MRI/Template/ONPRC18
#RHEMAP_FLD=/NHP_MRI/RheMAP
ONPRC_FLD=/Users/chris/Dropbox/CURRENT_PROJECTS/NHP_MRI/Template/ONPRC18_atlas_v1
NMT_FLD=/Users/chris/Dropbox/CURRENT_PROJECTS/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/NMT_v2.0_sym
RHEMAP_FLD=/Users/chris/Dropbox/GIT_Support/RheMAP/warps/final
OUT_FLD=${NMT_FLD}/supplemental_ONPRC18


# RUN SPECIFIC WARPS ==========================
REF=${NMT_FLD}/NMT_v2.0_sym_SS.nii.gz
TRANSFORM=${RHEMAP_FLD}/ONPRC18_to_NMTv2.0-sym_CompositeWarp.nii.gz
INTERP=Linear


# warp anatomy ======================================================
IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T2W.nii.gz
OUT=${OUT_FLD}/ONPRC18_T2W_in_NMT_v2.0_sym.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T2W_brain.nii.gz
OUT=${OUT_FLD}/ONPRC18_T2W_brain_in_NMT_v2.0_sym.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T1W.nii.gz
OUT=${OUT_FLD}/ONPRC18_T1W_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T1W_brain.nii.gz
OUT=${OUT_FLD}/ONPRC18_T1W_brain_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3


# warp dti ======================================================
IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_tensors.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_tensors_in_NMT_v2.0_sym.nii.gz
OUT2=${OUT_FLD}/ONPRC18_DTI_tensors_in_NMT_v2.0_sym_ro.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \
					-e 2
ReorientTensorImage 3 ${OUT} ${OUT2} ${TRANSFORM}

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_b0.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_b0_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_rgb.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_rgb_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_fa.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_fa_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_rd.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_rd_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_ad.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_ad_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_tr.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_tr_in_NMT_v2.0_sym.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \


# warp labelmaps ======================================================
IN=${ONPRC_FLD}/ONPRC18_Labelmaps/ONPRC18_GrayMatterLabelmap.nii.gz
OUT=${OUT_FLD}/ONPRC18_GrayMatterLabelmap_in_NMT_v2.0_sym.nii.gz
INTERP=NearestNeighbor
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Labelmaps/ONPRC18_GrayMatterLabelmapCondensed.nii.gz
OUT=${OUT_FLD}/ONPRC18_GrayMatterLabelmapCondensed_in_NMT_v2.0_sym.nii.gz
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Labelmaps/ONPRC18_GrayMatterWhiteMatterLabelmap.nii.gz
OUT=${OUT_FLD}/ONPRC18_GrayMatterWhiteMatterLabelmap_in_NMT_v2.0_sym.nii.gz
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

# copy the LUTs too
echo Copying labelmaps
cp ${ONPRC_FLD}/ONPRC18_Labelmaps/*.txt ${OUT_FLD}/
cp ${ONPRC_FLD}/ONPRC18_Labelmaps/*.tsv ${OUT_FLD}/
