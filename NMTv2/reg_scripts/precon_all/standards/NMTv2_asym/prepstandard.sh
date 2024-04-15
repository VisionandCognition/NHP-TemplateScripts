#!/bin/bash

STANDARD=NMT_v2.0_asym
NMTFLD=/NHP_MRI/Template/NMT_v2.0

# copy these files to raw
mkdir -p raw
cp ${NMTFLD}/${STANDARD}/${STANDARD}_brainmask.nii.gz ./raw/
cp ${NMTFLD}/${STANDARD}/${STANDARD}_GM_cortical_mask.nii.gz ./raw/
cp ${NMTFLD}/${STANDARD}/supplemental_masks/${STANDARD}_LR_brainmask.nii.gz ./raw/
cp ${NMTFLD}/${STANDARD}/${STANDARD}_segmentation.nii.gz ./raw/
cp ${NMTFLD}/${STANDARD}/${STANDARD}_SS.nii.gz ./raw/
cp ${NMTFLD}/${STANDARD}/${STANDARD}.nii.gz ./raw/


# The extraction folder contains:
# A whole head T1 template named: <your_animal>_temp.nii.gz 
cp ./raw/${STANDARD}.nii.gz ./extraction/${STANDARD}_temp.nii.gz
   
# A brain mask aptly named: brain_mask.nii.gz 
cp ./raw/${STANDARD}_brainmask.nii.gz ./extraction/brain_mask.nii.gz 
    
# A brain extracted T1 template named: <animal>_brain.nii.gz
cp ./raw/${STANDARD}_SS.nii.gz ./extraction/${STANDARD}_brain.nii.gz
    
    
    
# The fill folder contains:
# A left and right hemisphere mask named: left_hem.nii.gz right_hem.nii.gz
fslmaths ./raw/${STANDARD}_LR_brainmask.nii.gz -thr 0.9 -uthr 1.1 -bin ./fill/right_hem.nii.gz
fslmaths ./raw/${STANDARD}_LR_brainmask.nii.gz -thr 1.9 -uthr 2.1 -bin ./fill/leftt_hem.nii.gz

# A subcortical structure mask named: sub_cort.nii.gz 
flirt -in ../NIMH_mac/NIMH_mac_brain.nii.gz -ref ./extraction/${STANDARD}_brain.nii.gz \
 -omat ./raw/NIMH2NMT -out ./raw/NIMH2NMT.nii.gz

flirt -in ../NIMH_mac/fill/sub_cort.nii.gz -ref ./extraction/${STANDARD}_brain.nii.gz \
 -applyxfm -init ./raw/NIMH2NMT -out ./fill/sub_cort.nii.gz

# A brain stem and cerebellar mask named: non_cort.nii.gz 
flirt -in ../NIMH_mac/fill/non_cort.nii.gz -ref ./extraction/${STANDARD}_brain.nii.gz \
 -applyxfm -init ./raw/NIMH2NMT -out ./fill/non_cort.nii.gz   


# The seg_priors folder contains:
# csf.nii.gz
fslmaths ./raw/${STANDARD}_segmentation.nii.gz -thr 0.9 -uthr 1.1 -bin ./seg_priors/csf.nii.gz
    
# gm.nii.gz
fslmaths ./raw/${STANDARD}_segmentation.nii.gz -thr 1.9 -uthr 2.1 -bin ./seg_priors/gm.nii.gz
  
# wm.nii.gz
fslmaths ./raw/${STANDARD}_segmentation.nii.gz -thr 3.9 -uthr 4.1 -bin ./seg_priors/wm.nii.gz

fslmaths ./raw/${STANDARD}_segmentation.nii.gz -thr 4.9 -uthr 5.1 -bin ./seg_priors/vessels.nii.gz
