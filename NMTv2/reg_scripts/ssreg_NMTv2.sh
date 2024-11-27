#!/bin/bash
# NB! make sure the input volume is approximately centered on 0,0,0
# Run SingleSubject_reg_prep.sh to center align
# use COST=lpa for T1w
# use COST=lpc for T2w

# =========================
SUB=${1}
COST=${2}
ALIGN=${3}

TEMPLATEFLD=${4:-'/NHP_MRI/TEMPLATES/Templates'}
NMTVERSION=${5:-'NMT_v2.0'}
NMTTYPE1=${6:-'NMT_v2.0_sym'}
NMTTYPE2=${7:-'NMT_v2.0_sym'}

# =========================
BASENMT=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SUBT1=${BASENMT}/SingleSubjects/input_files/${SUB}.nii.gz

{
if [ ! -f $SUBT1 ]; then
    echo "The individual subject scan does not exist or isn't in the correct folder!"
    echo "Check whether the path below is actually correct and try again: "
    echo $SUBT1
    exit 0
fi
}

TEMPLATE=${BASENMT}/${NMTTYPE2}/${NMTTYPE2}.nii.gz
BMASK=${BASENMT}/${NMTTYPE2}/${NMTTYPE2}_brainmask.nii.gz

D99=${BASENMT}/${NMTTYPE2}/D99_atlas_in_${NMTTYPE2}.nii.gz
D99v2=${BASENMT}/${NMTTYPE2}/D99v2_atlas_in_${NMTTYPE2}.nii.gz
CHARM=${BASENMT}/${NMTTYPE2}/CHARM_in_${NMTTYPE2}.nii.gz
SARM=${BASENMT}/${NMTTYPE2}/SARM_in_${NMTTYPE2}.nii.gz

SEG=${BASENMT}/${NMTTYPE2}/${NMTTYPE2}_segmentation.nii.gz
GM=${BASENMT}/${NMTTYPE2}/${NMTTYPE2}_GM_cortical_mask.nii.gz
CEREBELLUM=${BASENMT}/${NMTTYPE2}/supplemental_masks/${NMTTYPE2}_cerebellum_mask.nii.gz
LR=${BASENMT}/${NMTTYPE2}/supplemental_masks/${NMTTYPE2}_LR_brainmask.nii.gz
VENTRICLES=${BASENMT}/${NMTTYPE2}/supplemental_masks/${NMTTYPE2}_ventricles.nii.gz

OUTBASE=${BASENMT}/SingleSubjects
mkdir -p ${OUTBASE}/aw_log

@animal_warper \
      -input  ${SUBT1} \
      -base   ${TEMPLATE} \
      -skullstrip ${BMASK} \
      -atlas ${D99} ${D99v2} ${CHARM} ${SARM} \
      -seg_followers ${SEG} ${GM} ${CEREBELLUM} ${LR} ${VENTRICLES} \
      -align_type ${ALIGN} \
      -ok_to_exist \
      -outdir ${OUTBASE}/aligned_${SUB} \
      -cost ${COST} \
      -aff_move_opt big_move
      #-align_centers_meth cm \
      #-supersize \
      |& tee ${OUTBASE}/aw_log/o.aw_${SUB}.txt

# copy the SARM/CHARM tables
cp -R ${BASENMT}/tables_* ${OUTBASE}/aligned_${SUB}/

# split the segmentation
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,0.9, 1.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_CSF_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,1.9, 2.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_GM-subcort_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,2.9, 3.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_GM-cort_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,3.9, 4.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_WM_in_${SUB}.nii.gz \
   -overwrite
3dcalc \
   -a ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_segmentation_in_${SUB}.nii.gz \
   -expr 'within(a,4.9, 5.1)' \
   -prefix ${OUTBASE}/aligned_${SUB}/${NMTTYPE2}_Vasculature_in_${SUB}.nii.gz \
   -overwrite

