#!/bin/bash

# NB! make sure the input volume is approximately centered on 0,0,0

# =========================
SUB=$1
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

@animal_warper \
      -input  ${SUBT1} \
      -base   ${TEMPLATE} \
      -skullstrip ${BMASK} \
      -atlas ${D99} ${CHARM} ${SARM} \
      -seg_followers ${SEG} ${GM} ${CEREBELLUM} ${LR} ${VENTRICLES} \
      -ok_to_exist \
      -outdir ${OUTBASE}/aligned_${SUB} \
      -cost lpc \
      -align_centers_meth cm \
      -supersize \
      |& tee ${OUTBASE}/o.aw_${SUB}.txt