#!/bin/bash
# Apply transforms to ONPRC18
# Requires ANTs

TEMPLATEFLD=${1:-'/NHP_MRI/Template'}
NMTVERSION=${2:-'NMT_v2.0'}
NMTTYPE1=${3:-'NMT_v2.0_asym'}
NMTTYPE2=${4:-'NMT_v2.0_asym'}
NMTRheMap=${5:-'NMTv2.0-asym'}

# SET UP FOLDER PATHS ==========================
NMT_DEST_FLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}/${NMTTYPE2}
NMT_SRC_FLD=${TEMPLATEFLD}/${NMTVERSION}/NMT_v2.0_sym/NMT_v2.0_sym
RHEMAP_FLD=${TEMPLATEFLD}/RheMAP/warps/final
OUT_FLD=${NMT_FLD}/supplemental_ONPRC18

# RUN SPECIFIC WARPS ==========================
REF=${NMT_DEST_FLD}/${NMTTYPE2}_SS.nii.gz
TRANSFORM=${RHEMAP_FLD}/NMTv2.0-sym_to_${NMTRheMap}_CompositeWarp.nii.gz

mkdir -p ${NMT_DEST_FLD}/supplemental_RETINOTOPY

# KUL ---
declare -a F=(ecc pol_deg pol_rad)
mkdir -p ${NMT_DEST_FLD}/supplemental_RETINOTOPY/pe_ret_kul
for FF in "${F[@]}"
do
	INTERP=NearestNeighbor
	IN=${NMT_SRC_FLD}/supplemental_RETINOTOPY/pe_ret_kul/${FF}.nii.gz
  OUT=${NMT_DEST_FLD}/supplemental_RETINOTOPY/pe_ret_kul/${FF}.nii.gz
  antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3
done

# PRF ---
declare -a S=(m029 m030 m029m030)
declare -a F=(ecc r2 sigma x y pol_deg mask_rth_5)
mkdir -p ${NMT_DEST_FLD}/supplemental_RETINOTOPY/prf
for SS in "${S[@]}"
do
  for FF in "${F[@]}"
  do
	  INTERP=NearestNeighbor
	  IN=${NMT_SRC_FLD}/supplemental_RETINOTOPY/prf/${SS}/${FF}.nii.gz
    OUT=${NMT_DEST_FLD}/supplemental_RETINOTOPY/prf/${SS}/${FF}.nii.gz
    antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3
  done
done

# LGN ---
declare -a L=(aff nonlin nowarp)
declare -a F=(CELLS ECC INCL LAYERS mask)
declare -a h=(L R)
mkdir ${NMT_DEST_FLD}/supplemental_RETINOTOPY/LGN
for LL in "${L[@]}"
do
  FLD=${NMT_DEST_FLD}/supplemental_RETINOTOPY/LGN/LGN-Retmap_in_NMTv2.0_${LL}
  SRCFLD=${NMT_SRC_FLD}/supplemental_RETINOTOPY/LGN/LGN-Retmap_in_NMTv2.0_${LL}
  mkdir ${FLD}
  for FF in "${F[@]}"
  do
	  for H in "${h[@]}"
	  do
	    INTERP=NearestNeighbor
	    IN=${SRCFLD}/${FF}_${H}.nii.gz
      OUT=${FLD}/${FF}_${H}.nii.gz
      antsApplyTransforms -i ${IN} \
					-r ${REF} \
					-o ${OUT} \
					-t ${TRANSFORM} \
					-n ${INTERP} \
					-d 3
    done
  done
done
