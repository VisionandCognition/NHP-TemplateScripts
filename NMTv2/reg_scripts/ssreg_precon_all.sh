#!/bin/bash

# =========================
# get subject name
SUB=$1
# =========================

# set paths
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts
SSFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects

# make folders
mkdir ${SSFLD}/aligned_${SUB}/freesurfer
cp ${SSFLD}/aligned_${SUB}/NMT2_in_${SUB}.nii.gz \
    ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}.nii.gz 

# run precon_all
${fld}/precon_all/bin/surfing_safari.sh \
    -i ${SSFLD}/aligned_${SUB}/freesurfer/NMT2_in_${SUB}.nii.gz \
    -r precon_all -a NIMH_mac
