#!/bin/bash
MONKEY=$1
NMTPATH=$2
echo ${NMTPATH}

mkdir -p ${NMTPATH}/single_subject_scans/${MONKEY}/ROI
filename="${NMTPATH}/D99_labeltable_reformat.txt"

while read -r line
do
    set ${line}
    LABLENUM=${1}
    LABLENAME=${2}
    echo "${MONKEY}: Creating ROI mask for ${LABLENAME}"
    fslmaths ${NMTPATH}/single_subject_scans/${MONKEY}/D99_atlas_1.2a_al2NMT_in_${MONKEY}.nii.gz \
        -thr ${LABLENUM} \
        -uthr ${LABLENUM} \
        -bin ${NMTPATH}/single_subject_scans/${MONKEY}/ROI/${LABLENAME}.nii.gz
done < "${filename}"

