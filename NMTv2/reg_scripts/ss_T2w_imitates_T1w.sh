#!/bin/bash

# This scripts does the nonlinear alignment again for T2w images (e.g., MIRCen). 
# It is needed as a workaround due to poor performance in @animal_warper

# =========================
SUB=$1
# =========================
BASEFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym
SSFLD=${BASEFLD}/SingleSubjects
org=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
#aff=${SSFLD}/aligned_${SUB}/affine/NMT_aff2${SUB}.nii.gz
aff=${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz
affbak=${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}_AFF.nii.gz

aff_1d=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template_inv.1D
fixfld=${SSFLD}/aligned_${SUB}/nonlinear_fix

mkdir -p ${fixfld}
# will be created
maff=${fixfld}/aff_mask.nii.gz
maffd=${fixfld}/aff_mask_dil.nii.gz

# affine transform the NMT brainmask
3dAllineate \
	-source ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_brainmask.nii.gz \
	-prefix ${maff} \
	-master ${org} \
	-1Dmatrix_apply ${aff_1d} \
	-interp linear -final cubic -overwrite

# dilate brain mask
3dmask_tool \
         -dilate_inputs -2 3 \
         -inputs ${maff}  \
         -prefix ${maffd} \
         -overwrite

# apply the mask
3dcalc \
    	-a       ${aff} \
      	-b       ${maffd} \
      	-expr    'a*step(b)' \
      	-prefix  ${fixfld}/NMT_aff2${SUB}_ns.nii.gz \
      	-overwrite
3dcalc \
    	-a       ${org} \
      	-b       ${maffd} \
      	-expr    'a*step(b)' \
      	-prefix  ${fixfld}/${SUB}_ns.nii.gz \
      	-overwrite

# invert T2w contrast to make it look like T1w
3dUnifize \
	-T2 -T2 \
	-input ${fixfld}/${SUB}_ns.nii.gz \
	-prefix ${fixfld}/${SUB}_ns_T2T1unif.nii.gz \
	-overwrite

# do the nonlinear registration between the two skullstripped brains
3dQwarp \
	-source ${fixfld}/NMT_aff2${SUB}_ns.nii.gz   \
    -base   ${fixfld}/${SUB}_ns_T2T1unif.nii.gz  \
    -prefix ${fixfld}/NMT_nl2${SUB}_fix.nii.gz \
    -maxlev 9 -workhard:0:2 \
    -lpa -iwarp -overwrite

# apply the warp to the full NMT
mv ${fixfld}/NMT_nl2${SUB}_fix.nii.gz ${fixfld}/NMT_nl2${SUB}_fix_ns.nii.gz 
3dNwarpApply \
    -source ${aff} \
    -prefix ${fixfld}/NMT_nl2${SUB}_fix.nii.gz \
    -master ${org} \
    -nwarp  ${fixfld}/NMT_nl2${SUB}_fix_WARP.nii.gz \
    -interp linear -overwrite  

## ====================================================

# Move the warps so we can continue @aw
cp ${fixfld}/NMT_nl2${SUB}_fix_WARPINV.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_shft_WARP.nii.gz

cp ${fixfld}/NMT_nl2${SUB}_fix_WARP.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_shft_WARPINV.nii.gz

# rename some old results that get in the way
mv ${SSFLD}/aligned_${SUB}/${SUB}_warp2std.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_warp2std_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${SUB}_warp2std_ns.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_warp2std_ns_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${SUB}_warp2std_nsu.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_warp2std_nsu_AFF.nii.gz

mv ${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${SUB}_mask.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_mask_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${SUB}_ns.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_ns_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${SUB}_nsu.nii.gz \
	${SSFLD}/aligned_${SUB}/${SUB}_nsu_AFF.nii.gz
# masks and segmentations
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_ventricles_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_ventricles_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_cerebellum_mask_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_cerebellum_mask_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_CSF_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_CSF_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_GM_cortical_mask_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_GM_cortical_mask_in_${SUB}_AFF.nii.gz	
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_GM-cort_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_GM-cort_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_GM-subcort_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_GM-subcort_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_LR_brainmask_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_LR_brainmask_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_segmentation_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_segmentation_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_Vasculature_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_Vasculature_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_WM_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/NMT_v2.0_sym_WM_in_${SUB}_AFF.nii.gz
# atlases
mv ${SSFLD}/aligned_${SUB}/CHARM_in_NMT_v2.0_sym_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/CHARM_in_NMT_v2.0_sym_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/SARM_in_NMT_v2.0_sym_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/SARM_in_NMT_v2.0_sym_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/D99_atlas_in_NMT_v2.0_sym_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/D99_atlas_in_NMT_v2.0_sym_in_${SUB}_AFF.nii.gz
# surfaces
mv ${SSFLD}/aligned_${SUB}/surfaces \
	${SSFLD}/aligned_${SUB}/surfaces_AFF.nii.gz