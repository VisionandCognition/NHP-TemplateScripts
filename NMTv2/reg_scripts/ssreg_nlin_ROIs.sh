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

fw_T2S=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_base2osh_WARP.nii.gz
fwsh_T2S=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_inv.1D
fw_S2T=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft_osh2base_WARP.nii.gz
fwsh_S2T=${SSFLD}/aligned_${SUB}/intermediate/${SUB}_shft.1D

SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
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


3dNwarpApply \
    -source ${SS} \
    -prefix ${SS_NL_OUT}/${SUB}_nl2NMT.nii.gz \
    -master ${TT} \
    -nwarp  ${fw_S2T} \
    -interp linear -overwrite  

@Align_Centers -overwrite \
          -no_cp \
          -base ${SS} \
          -dset ${SS_NL_OUT}/${SUB}_nl2NMT.nii.gz \
          -shift_xform_inv ${fwsh_S2T} 

3dNwarpApply \
    -source ${TT} \
    -prefix ${SS_NL_OUT}/NMT_nl2${SUB}.nii.gz \
    -master ${SS} \
    -nwarp  ${fw_T2S} \
    -interp linear -overwrite  

@Align_Centers -overwrite \
          -no_cp \
          -base ${TT} \
          -dset ${SS_NL_OUT}/NMT_nl2${SUB}.nii.gz \
          -shift_xform_inv ${fwsh_T2S} 


for LEVEL in 1 2 3 4 5 6
do
    3dNwarpApply \
        -source ${CHARM_SUPP}/CHARM_${LEVEL}_in_NMT_v2.0_sym.nii.gz \
        -prefix ${SS_NL_OUT}/CHARM/CHARM_${LEVEL}_in_${SUB}.nii.gz \
        -master ${SS} \
        -nwarp  ${fw_T2S} \
        -interp NN -overwrite

    @Align_Centers -overwrite \
          -no_cp \
          -base ${SS} \
          -dset ${SS_NL_OUT}/CHARM/CHARM_${LEVEL}_in_${SUB}.nii.gz \
          -shift_xform_inv ${fwsh_T2S} 

    3dNwarpApply \
        -source ${SARM_SUPP}/SARM_${LEVEL}_in_NMT_v2.0_sym.nii.gz \
        -prefix ${SS_NL_OUT}/SARM/SARM_${LEVEL}_in_${SUB}.nii.gz \
        -master ${SS} \
        -nwarp  ${fw_T2S} \
        -interp NN -overwrite

    @Align_Centers -overwrite \
          -no_cp \
          -base ${SS} \
          -dset ${SS_NL_OUT}/SARM/SARM_${LEVEL}_in_${SUB}.nii.gz \
          -shift_xform_inv ${fwsh_T2S} 
done





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