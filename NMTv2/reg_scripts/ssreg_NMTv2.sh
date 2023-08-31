#!/bin/bash

# NB! make sure the input volume is approximately centered on 0,0,0
# Run SingleSubject_reg_prep.sh to center align
# use COST=lpa for T1w
# use COST=lpc for T2w

# =========================
SUB=$1
COST=$2
ALLIGN=$3

SUBT1=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files/${SUB}.nii.gz
# =========================

BASEFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/NMT_v2.0_sym

TEMPLATE=${BASEFLD}/NMT_v2.0_sym.nii.gz
BMASK=${BASEFLD}/NMT_v2.0_sym_brainmask.nii.gz

D99=${BASEFLD}/D99_atlas_in_NMT_v2.0_sym.nii.gz
CHARM=${BASEFLD}/CHARM_in_NMT_v2.0_sym.nii.gz
SARM=${BASEFLD}/SARM_in_NMT_v2.0_sym.nii.gz

SEG=${BASEFLD}/NMT_v2.0_sym_segmentation.nii.gz
GM=${BASEFLD}/NMT_v2.0_sym_GM_cortical_mask.nii.gz
CEREBELLUM=${BASEFLD}/supplemental_masks/NMT_v2.0_sym_cerebellum_mask.nii.gz
LR=${BASEFLD}/supplemental_masks/NMT_v2.0_sym_LR_brainmask.nii.gz
VENTRICLES=${BASEFLD}/supplemental_masks/NMT_v2.0_sym_ventricles.nii.gz

OUTBASE=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects
mkdir -p ${OUTBASE}/aw_log

@animal_warper \
      -input  ${SUBT1} \
      -base   ${TEMPLATE} \
      -skullstrip ${BMASK} \
      -atlas ${D99} ${CHARM} ${SARM} \
      -seg_followers ${SEG} ${GM} ${CEREBELLUM} ${LR} ${VENTRICLES} \
      -align_type ${ALLIGN} \
      -ok_to_exist \
      -outdir ${OUTBASE}/aligned_${SUB} \
      -cost ${COST} \
      -align_centers_meth cm \
      -supersize \
      |& tee ${OUTBASE}/aw_log/o.aw_${SUB}.txt

# copy the SARM/CHARM tables
cp -R /NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/tables_* ${OUTBASE}/aligned_${SUB}/

# split the segmentation
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,0.9, 1.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_CSF_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,1.9, 2.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_GM-subcort_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,2.9, 3.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_GM-cort_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,3.9, 4.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_WM_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,4.9, 5.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/NMT_v2.0_sym_Vasculature_in_${SUB}.nii.gz \
   -overwrite

