#!/bin/bash

# Use the affine registration, e.g. to compensate for head-post drop-out

# =========================
# get subject name
SUB=$1
# =========================

# set paths
BASEFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym
SSFLD=${BASEFLD}/SingleSubjects
SCRIPTFLD=${SSFLD}/reg_scripts

SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
SS_AFF_OUT=${SSFLD}/aligned_${SUB}/ONPRC18/affine
SS_NL_OUT=${SSFLD}/aligned_${SUB}/ONPRC18/nonlinear
ONPRC_SS=${SSFLD}/aligned_${SUB}/ONPRC18
ONPRC_SUPP=${BASEFLD}/NMT_v2.0_sym/supplemental_ONPRC18 

# make folders
mkdir -p ${SS_AFF_OUT}
mkdir -p ${SS_NL_OUT}

# warp =========
# We're going to pull a trick here and calculate the ANTs transforms between
# NMT and NMT_in_SingleSubject, then apply these to the ONPRC18_in_NMT

NMTi_aff=${SSFLD}/aligned_${SUB}/affine/NMT_aff2${SUB}.nii.gz
NMTi_nl=${SSFLD}/aligned_${SUB}/nonlinear/NMT_nl2${SUB}.nii.gz
NMT=${BASEFLD}/NMT_v2.0_sym/NMT_v2.0_sym_SS.nii.gz

if [ -f ${ONPRC_SS}/NMT2NMTi_0GenericAffine.mat ]
then
echo Registration transforms already present. Skip registration.
else
echo Performing ANTs registration. Will take a while...
antsRegistration \
    --dimensionality 3 \
    --float 0 \
    --output [${ONPRC_SS}/NMT2NMTi_,${ONPRC_SS}/NMT2NMTi_affine.nii.gz] \
    --interpolation Linear \
    --winsorize-image-intensities [0.05,0.95] \
    --use-histogram-matching 1 \
    --transform Affine[0.1] \
    --metric MI[$NMTi_aff,$NMT,1,32,Regular,0.25] \
    --convergence [1000x500x250x100,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox 
fi
echo Done. Now we will apply these transforms.

# warp tensor and anatomy =========

# Apply transforms
IN=${ONPRC_SUPP}/ONPRC18_DTI_tensors_in_NMT_v2.0_sym_ro.nii.gz
OUT=${SS_AFF_OUT}/ONPRC18_DTI_tensors_in_${SUB}_aff.nii.gz
OUT2=${SS_AFF_OUT}/ONPRC18_DTI_tensors_in_${SUB}_aff_ro.nii.gz
REF=${SS}
TRANSFORM=${ONPRC_SS}/NMT2NMTi_0GenericAffine.mat
INTERP=Linear

echo Transforming AFF ${IN}
antsApplyTransforms -i ${IN} \
    -r ${REF} \
    -o ${OUT} \
    -t ${TRANSFORM} \
    -n ${INTERP} \
    -d 3 \
    -e 2
ReorientTensorImage 3 ${OUT} ${OUT2} ${TRANSFORM}

# now do the others efficiently in a loop
declare -a PREFIXES=(
    DTI_b0    
    DTI_rgb    
    DTI_fa    
    DTI_rd 
    DTI_ad
    DTI_tr
    T1W
    T2W
    T1W_brain
    T2W_brain
    )

for PREFIX in "${PREFIXES[@]}"
do
    IN=${ONPRC_SUPP}/ONPRC18_${PREFIX}_in_NMT_v2.0_sym.nii.gz
    OUT=${SS_AFF_OUT}/ONPRC18_${PREFIX}_in_${SUB}_aff.nii.gz
    TRANSFORM=${ONPRC_SS}/NMT2NMTi_0GenericAffine.mat
    echo Transforming AFF ${IN}
    antsApplyTransforms -i ${IN} \
                        -r ${REF} \
                        -o ${OUT} \
                        -t ${TRANSFORM} \
                        -n ${INTERP} \
                        -d 3 
done

# warp labelmaps =========
declare -a PREFIXES=(
    GrayMatterLabelmap    
    GrayMatterLabelmapCondensed    
    GrayMatterWhiteMatterLabelmap    
    )

for PREFIX in "${PREFIXES[@]}"
do
    IN=${ONPRC_SUPP}/ONPRC18_${PREFIX}_in_NMT_v2.0_sym.nii.gz
    OUT=${SS_AFF_OUT}/ONPRC18_${PREFIX}_in_${SUB}_aff.nii.gz
    TRANSFORM=${ONPRC_SS}/NMT2NMTi_0GenericAffine.mat
    INTERP=NearestNeighbor
    echo Transforming AFF ${IN}
    antsApplyTransforms -i ${IN} \
                        -r ${REF} \
                        -o ${OUT} \
                        -t ${TRANSFORM} \
                        -n ${INTERP} \
                        -d 3 
done

# copy the LUTs too
echo Copying labelmaps
cp ${ONPRC_SUPP}/*.txt ${ONPRC_SS}/
cp ${ONPRC_SUPP}/*.tsv ${ONPRC_SS}/