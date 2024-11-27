#!/bin/bash
# Apply transforms to ONPRC18
# Requires ANTs

TEMPLATEFLD=${1:-'/NHP_MRI/TEMPLATES/Template'}
NMTVERSION=${2:-'NMT_v2.0'}
NMTTYPE1=${3:-'NMT_v2.0_asym'}
NMTTYPE2=${4:-'NMT_v2.0_asym'}
NMTRheMap=${5:-'NMTv2.0-asym'}

# SET UP FOLDER PATHS ==========================
ONPRC_FLD=${TEMPLATEFLD}/ONPRC18_atlas_v1
NMT_FLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}/${NMTTYPE2}
RHEMAP_FLD=${TEMPLATEFLD}/RheMAP/warps/final
OUT_FLD=${NMT_FLD}/supplemental_ONPRC
mkdir -p ${OUT_FLD}

# RUN SPECIFIC WARPS ==========================
REF=${NMT_FLD}/${NMTTYPE2}_SS.nii.gz
TRANSFORM=${RHEMAP_FLD}/ONPRC18_to_${NMTRheMap}_CompositeWarp.nii.gz
INTERP=Linear

# warp anatomy ======================================================
IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T2W.nii.gz
OUT=${OUT_FLD}/ONPRC18_T2W_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T2W_brain.nii.gz
OUT=${OUT_FLD}/ONPRC18_T2W_brain_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T1W.nii.gz
OUT=${OUT_FLD}/ONPRC18_T1W_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_T1W_brain.nii.gz
OUT=${OUT_FLD}/ONPRC18_T1W_brain_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

# warp dti ======================================================
IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_tensors.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_tensors_in_${NMTTYPE2}.nii.gz
OUT2=${OUT_FLD}/ONPRC18_DTI_tensors_in_${NMTTYPE2}_ro.nii.gz
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
OUT=${OUT_FLD}/ONPRC18_DTI_b0_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_rgb.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_rgb_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_fa.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_fa_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_rd.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_rd_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_ad.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_ad_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \

IN=${ONPRC_FLD}/ONPRC18_Templates/ONPRC18_DTI_tr.nii.gz
OUT=${OUT_FLD}/ONPRC18_DTI_tr_in_${NMTTYPE2}.nii.gz
echo Transforming ${IN}
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3 \


# warp labelmaps ======================================================
IN=${ONPRC_FLD}/ONPRC18_Labelmaps/ONPRC18_GrayMatterLabelmap.nii.gz
OUT=${OUT_FLD}/ONPRC18_GrayMatterLabelmap_in_${NMTTYPE2}.nii.gz
INTERP=NearestNeighbor
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Labelmaps/ONPRC18_GrayMatterLabelmapCondensed.nii.gz
OUT=${OUT_FLD}/ONPRC18_GrayMatterLabelmapCondensed_in_${NMTTYPE2}.nii.gz
antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3

IN=${ONPRC_FLD}/ONPRC18_Labelmaps/ONPRC18_GrayMatterWhiteMatterLabelmap.nii.gz
OUT=${OUT_FLD}/ONPRC18_GrayMatterWhiteMatterLabelmap_in_${NMTTYPE2}.nii.gz
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
