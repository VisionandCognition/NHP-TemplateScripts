#!/bin/bash
MONKEY=$1
mkdir -p ../${MONKEY}/ROI

filename="../../atlases/D99_atlas/D99_labeltable_reformat.txt"

while read -r line
do
    set ${line}
    LABLENUM=${1}
    LABLENAME=${2}
    echo "${MONKEY}: Creating ROI mask for ${LABLENAME}"
    fslmaths ../${MONKEY}/D99_in_${MONKEY}.nii.gz \
        -thr ${LABLENUM} \
        -uthr ${LABLENUM} \
        -bin ../${MONKEY}/ROI/${LABLENAME}.nii.gz
done < "${filename}"

