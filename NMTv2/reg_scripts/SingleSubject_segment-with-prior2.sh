SUB=$1

# create segment volumes
# 01 csf 
# 02 gm 
# 03 subcortex 04 wm 

BASEFLD=/Users/chris/Dropbox/Transfer
SSFLD=${BASEFLD}/aligned_${SUB}
cp ${SSFLD}/NMT_v2.0_sym_segmentation_in_${SUB}.nii.gz ${SSFLD}/NMT_v2.0_sym_segmentation_in_${SUB}2.nii.gz

SEG=${SSFLD}/NMT_v2.0_sym_segmentation_in_${SUB}2.nii.gz
fslcpgeom ${SSFLD}/${SUB}.nii.gz ${SEG}

fslmaths ${SEG} -thr 0.9 -uthr 1.1 -bin ${SSFLD}/tmp_01.nii.gz 
fslmaths ${SEG} -thr 1.9 -uthr 2.1 -bin ${SSFLD}/tmp_02.nii.gz
fslmaths ${SEG} -thr 2.9 -uthr 4.1 -bin ${SSFLD}/tmp_03.nii.gz

cp ${SSFLD}/${SUB}_mask.nii.gz ${SSFLD}/${SUB}_mask2.nii.gz
fslcpgeom ${SSFLD}/${SUB}.nii.gz ${SSFLD}/${SUB}_mask2.nii.gz

antsAtroposN4.sh -d 3 -a ${SSFLD}/${SUB}.nii.gz \
	-x ${SSFLD}/${SUB}_mask2.nii.gz \
	-c 3 \
	-p ${SSFLD}/tmp_%02d.nii.gz \
	-o ${SSFLD}/${SUB}_seg_
	
mv ${SSFLD}/${SUB}_seg_01.nii.gz ${SSFLD}/${SUB}_seg_csf.nii.gz
mv ${SSFLD}/${SUB}_seg_02.nii.gz ${SSFLD}/${SUB}_seg_gm.nii.gz
mv ${SSFLD}/${SUB}_seg_03.nii.gz ${SSFLD}/${SUB}_seg_wm.nii.gz

fslmaths ${SUB}_seg_csf.nii.gz \
	-add ${SUB}_seg_gm.nii.gz -add ${SUB}_seg_gm.nii.gz \
	-add ${SUB}_seg_wm.nii.gz -add ${SUB}_seg_wm.nii.gz -add ${SUB}_seg_wm.nii.gz \
	${SUB}_seg_3class.nii.gz

# clean up
rm ${SSFLD}/${SUB}_mask2.nii.gz
rm ${SSFLD}/${SUB}_seg_01.nii.gz
rm ${SSFLD}/${SUB}_seg_02.nii.gz
rm ${SSFLD}/${SUB}_seg_03.nii.gz
rm ${SSFLD}/${SUB}_seg_Segmentation0N4.nii.gz
rm ${SSFLD}/${SUB}_seg_SegmentationConvergence.txt
rm ${SEG}