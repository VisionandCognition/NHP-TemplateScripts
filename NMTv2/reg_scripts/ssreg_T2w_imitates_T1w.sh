#!/bin/bash

# This scripts does the nonlinear alignment again for T2w images (e.g., MIRCen). 
# It is needed as a workaround due to poor performance in @animal_warper

# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/Template'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_asym'}
# =========================

BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SSFLD=${BASEFLD}/SingleSubjects
org=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
aff=${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz
fixfld=${SSFLD}/aligned_${SUB}/nonlinear_fix

mkdir -p ${fixfld}
# will be created
maff=${fixfld}/aff_mask.nii.gz
maffd=${fixfld}/aff_mask_dil.nii.gz

3dcalc \
	-a ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_LR_brainmask_in_${SUB}.nii.gz \
	-expr 'ispositive(a)' \
      -prefix ${maff} 

# dilate brain mask
3dmask_tool \
         -dilate_inputs -2 3 \
         -inputs ${maff}  \
         -prefix ${maffd} \
         -overwrite

# apply the mask
3dcalc \
    	-a ${aff} \
      -b ${maffd} \
      -expr 'a*step(b)' \
      -prefix ${fixfld}/NMT_aff2${SUB}_ns.nii.gz \
      -overwrite
3dcalc \
    	-a ${org} \
      -b ${maffd} \
      -expr 'a*step(b)' \
      -prefix ${fixfld}/${SUB}_ns.nii.gz \
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
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_ventricles_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_ventricles_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_cerebellum_mask_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_cerebellum_mask_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_CSF_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_CSF_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_GM_cortical_mask_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_GM_cortical_mask_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_GM-cort_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_GM-cort_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_GM-subcort_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_GM-subcort_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_LR_brainmask_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_LR_brainmask_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_segmentation_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_segmentation_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_Vasculature_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_Vasculature_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/${NMTTYPE1}_WM_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/${NMTTYPE1}_WM_in_${SUB}_AFF.nii.gz
# atlases
mv ${SSFLD}/aligned_${SUB}/CHARM_in_${NMTTYPE1}_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/CHARM_in_${NMTTYPE1}_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/SARM_in_${NMTTYPE1}_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/SARM_in_${NMTTYPE1}_in_${SUB}_AFF.nii.gz
mv ${SSFLD}/aligned_${SUB}/D99_atlas_in_${NMTTYPE1}_in_${SUB}.nii.gz \
	${SSFLD}/aligned_${SUB}/D99_atlas_in_${NMTTYPE1}_in_${SUB}_AFF.nii.gz
# surfaces
mv ${SSFLD}/aligned_${SUB}/surfaces \
	${SSFLD}/aligned_${SUB}/surfaces_AFF
