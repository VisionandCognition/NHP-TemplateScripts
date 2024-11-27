# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/TEMPLATES/Templates'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_sym'}
NMTTYPE2=${5:-'NMT_v2.0_sym'}

script_path="$0"
SCRIPTFLD="$(dirname "$script_path")"
# =========================
BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SSFLD=${BASEFLD}/SingleSubjects
ALFLD=${SSFLD}/aligned_${SUB}

# create segment volumes
# 01 csf 
# 02 gm 
# 03 subcortex 04 wm 

cp ${ALFLD}/${NMTTYPE2}_segmentation_in_${SUB}.nii.gz ${ALFLD}/${NMTTYPE2}_segmentation_in_${SUB}2.nii.gz

SEG=${ALFLD}/${NMTTYPE2}_segmentation_in_${SUB}2.nii.gz
fslcpgeom ${ALFLD}/${SUB}.nii.gz ${SEG}

fslmaths ${SEG} -thr 0.9 -uthr 1.1 -bin ${SSFLD}/tmp_01.nii.gz 
fslmaths ${SEG} -thr 1.9 -uthr 2.1 -bin ${SSFLD}/tmp_02.nii.gz
fslmaths ${SEG} -thr 2.9 -uthr 4.1 -bin ${SSFLD}/tmp_03.nii.gz

cp ${ALFLD}/${SUB}_mask.nii.gz ${ALFLD}/${SUB}_mask2.nii.gz
fslcpgeom ${ALFLD}/${SUB}.nii.gz ${ALFLD}/${SUB}_mask2.nii.gz

antsAtroposN4.sh -d 3 -a ${ALFLD}/${SUB}.nii.gz \
	-x ${ALFLD}/${SUB}_mask2.nii.gz \
	-c 3 \
	-p ${ALFLD}/tmp_%02d.nii.gz \
	-o ${ALFLD}/${SUB}_seg_
	
mv ${ALFLD}/${SUB}_seg_01.nii.gz ${ALFLD}/${SUB}_seg_csf.nii.gz
mv ${ALFLD}/${SUB}_seg_02.nii.gz ${ALFLD}/${SUB}_seg_gm.nii.gz
mv ${ALFLD}/${SUB}_seg_03.nii.gz ${ALFLD}/${SUB}_seg_wm.nii.gz

fslmaths ${SUB}_seg_csf.nii.gz \
	-add ${SUB}_seg_gm.nii.gz -add ${SUB}_seg_gm.nii.gz \
	-add ${SUB}_seg_wm.nii.gz -add ${SUB}_seg_wm.nii.gz -add ${SUB}_seg_wm.nii.gz \
	${SUB}_seg_3class.nii.gz

# clean up
rm ${ALFLD}/${SUB}_mask2.nii.gz
rm ${ALFLD}/${SUB}_seg_01.nii.gz
rm ${ALFLD}/${SUB}_seg_02.nii.gz
rm ${ALFLD}/${SUB}_seg_03.nii.gz
rm ${ALFLD}/${SUB}_seg_Segmentation0N4.nii.gz
rm ${ALFLD}/${SUB}_seg_SegmentationConvergence.txt
rm ${SEG}