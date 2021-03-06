#!/bin/bash

# Use the nonlinear registration

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

CHARM_SUPP=${BASEFLD}/NMT_v2.0_sym/supplemental_CHARM 
SARM_SUPP=${BASEFLD}/NMT_v2.0_sym/supplemental_SARM

CHARM_LFLD=${BASEFLD}/tables_CHARM
SARM_LFLD=${BASEFLD}/tables_SARM

# make folders
mkdir -p ${SS_NL_OUT}
mkdir -p ${SS_NL_OUT}/CHARM
mkdir -p ${SS_NL_OUT}/SARM

3dAllineate \
    -source ${SS} \
    -prefix ${SS_AFF_OUT}/${SUB}_aff2NMT.nii.gz \
    -master ${TT} \
    -1Dmatrix_apply ${AFF_S2T} \
    -interp linear -final cubic -overwrite
3dAllineate \
    -source ${TT} \
    -prefix ${SS_AFF_OUT}/NMT_aff2${SUB}.nii.gz \
    -master ${SS} \
    -1Dmatrix_apply ${AFF_T2S} \
    -interp linear -final cubic -overwrite

3dNwarpApply \
    -source ${SS_AFF_OUT}/${SUB}_aff2NMT.nii.gz \
    -prefix ${SS_NL_OUT}/${SUB}_nl2NMT.nii.gz \
    -master ${TT} \
    -nwarp ${NL_S2T} \
    -interp linear -overwrite   
3dNwarpApply \
    -source ${SS_AFF_OUT}/NMT_aff2${SUB}.nii.gz \
    -prefix ${SS_NL_OUT}/NMT_nl2${SUB}.nii.gz \
    -master ${SS} \
    -nwarp  ${NL_T2S} \
    -interp linear -overwrite   

# apply nonlinear to all affine aligned atlas levels at once
3dNwarpApply \
        -source ${SS_AFF_OUT}/CHARM/CHARM_1_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/CHARM/CHARM_2_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/CHARM/CHARM_3_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/CHARM/CHARM_4_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/CHARM/CHARM_5_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/CHARM/CHARM_6_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/SARM/SARM_1_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/SARM/SARM_2_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/SARM/SARM_3_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/SARM/SARM_4_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/SARM/SARM_5_in_${SUB}.nii.gz \
        ${SS_AFF_OUT}/SARM/SARM_6_in_${SUB}.nii.gz \
        -prefix ${SS_NL_OUT}/CHARM/CHARM_1_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/CHARM/CHARM_2_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/CHARM/CHARM_3_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/CHARM/CHARM_4_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/CHARM/CHARM_5_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/CHARM/CHARM_6_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/SARM/SARM_1_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/SARM/SARM_2_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/SARM/SARM_3_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/SARM/SARM_4_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/SARM/SARM_5_in_${SUB}.nii.gz \
        ${SS_NL_OUT}/SARM/SARM_6_in_${SUB}.nii.gz \
        -master ${SS} \
        -nwarp ${NL_T2S} \
        -interp NN -overwrite -short

# Extract ROI & create meshes
for LEVEL in 1 2 3 4 5 6
do
    echo Processing level ${LEVEL}
    charmfld=${SS_NL_OUT}/CHARM/ROI/Level_${LEVEL}
    charm_meshfld=${SS_NL_OUT}/CHARM/ROIMESH/Level_${LEVEL}
    mkdir -p ${charmfld}
    mkdir -p ${charm_meshfld}
    labels="${CHARM_LFLD}/CHARM_key_${LEVEL}.txt"

    {
        read;
        while read -r line
        do
            set ${line}
            LABLENUM=${1}
            LABLENAME=${2}
            LABLENAME=${LABLENAME////-}
            # extract label as binary-mask
            fslmaths ${SS_NL_OUT}/CHARM/CHARM_${LEVEL}_in_${SUB}.nii.gz \
        	   -thr ${LABLENUM} -uthr ${LABLENUM} -bin ${charmfld}/${LABLENAME}.nii.gz
            # convert binary mask to mesh
            python ${SCRIPTFLD}/binarymask_to_mesh.py ${charmfld}/${LABLENAME}.nii.gz ${charm_meshfld}/${LABLENAME}.ply &    
    done 
    } < "${labels}"

    sarmfld=${SS_NL_OUT}/SARM/ROI/Level_${LEVEL}
    sarm_meshfld=${SS_NL_OUT}/SARM/ROIMESH/Level_${LEVEL}
    mkdir -p ${sarmfld}
    mkdir -p ${sarm_meshfld}
    labels="${SARM_LFLD}/SARM_key_${LEVEL}.txt"

    {
        read;
        while read -r line
        do
            set ${line}
            LABLENUM=${1}
            LABLENAME=${2}
            LABLENAME=${LABLENAME////-}
            # extract label as binary-mask
            fslmaths ${SS_NL_OUT}/SARM/SARM_${LEVEL}_in_${SUB}.nii.gz \
                -thr ${LABLENUM} -uthr ${LABLENUM} -bin ${sarmfld}/${LABLENAME}.nii.gz
            # convert binary mask to mesh
            python ${SCRIPTFLD}/binarymask_to_mesh.py ${sarmfld}/${LABLENAME}.nii.gz ${sarm_meshfld}/${LABLENAME}.ply &    
        done
     } < "${labels}"
done