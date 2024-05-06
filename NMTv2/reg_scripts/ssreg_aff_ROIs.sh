#!/bin/bash
# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/Template'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_asym'}
NMTTYPE2=${5:-'NMT_v2.0_asym'}

SCRIPTFLD=$(realpath $(dirname $0))
# =========================

doCHARM=0
doSARM=0
doD99=1

CREATEMESH=1
required_modules=("nibabel" "numpy" "igl" "skimage" "scipy")
for module in "${required_modules[@]}"; do
    if python -c "import $module" &> /dev/null; then
        echo "Module $module is available."
    else
        echo "Module $module is not available. Not creating meshes."
        CREATEMESH=0
    fi
done

if [ "${CREATEMESH}" -eq "1" ]; then
    # Continue with the rest of your script if all required modules are available
  echo "All required modules are available. Continuing with the script."

  BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
  SSFLD=${BASEFLD}/SingleSubjects

  # Identify files
  AFF_S2T=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template.1D
  AFF_T2S=${SSFLD}/aligned_${SUB}/${SUB}_composite_linear_to_template_inv.1D

  SS=${SSFLD}/aligned_${SUB}/${SUB}.nii.gz
  SS_AFF_OUT=${SSFLD}/aligned_${SUB}/affine
  TT=${SSFLD}/aligned_${SUB}/${NMTTYPE2}.nii.gz
  D99=${SSFLD}/aligned_${SUB}/D99v2_atlas_in_${NMTTYPE2}_in_${SUB}.nii.gz

  CHARM_SUPP=${BASEFLD}/${NMTTYPE2}/supplemental_CHARM
  SARM_SUPP=${BASEFLD}/${NMTTYPE2}/supplemental_SARM

  CHARM_LFLD=${BASEFLD}/tables_CHARM
  SARM_LFLD=${BASEFLD}/tables_SARM
  D99_LFLD=${BASEFLD}/tables_D99

  # make folders
  mkdir -p ${SS_AFF_OUT}
  mkdir -p ${SS_AFF_OUT}/CHARM
  mkdir -p ${SS_AFF_OUT}/SARM
  mkdir -p ${SS_AFF_OUT}/D99v2


  3dAllineate \
    -source ${SS} \
    -prefix ${SS_AFF_OUT}/${SUB}_aff2NMT.nii.gz \
    -master ${TT} \
    -1Dmatrix_apply ${AFF_S2T} \
    -interp linear -final cubic -overwrite
  3dAllineate \
    -source ${TT} \
    -prefix ${SS_AFF_OUT}/NMT_aff2${SUB}.nii.gz \
    -master ${SS} \
    -1Dmatrix_apply ${AFF_T2S} \
    -interp linear -final cubic -overwrite


  for LEVEL in 1 2 3 4 5 6
  do
    if [ "${doCHARM}" -eq 1 ]; then
      3dAllineate \
        -source ${CHARM_SUPP}/CHARM_${LEVEL}_in_${NMTTYPE2}.nii.gz \
        -prefix ${SS_AFF_OUT}/CHARM/CHARM_${LEVEL}_in_${SUB}.nii.gz \
        -master ${SS} \
        -1Dmatrix_apply ${AFF_T2S} \
        -interp NN -final NN -overwrite
    fi
    if [ "${doSARM}" -eq 1 ]; then
      3dAllineate \
        -source ${SARM_SUPP}/SARM_${LEVEL}_in_${NMTTYPE2}.nii.gz \
        -prefix ${SS_AFF_OUT}/SARM/SARM_${LEVEL}_in_${SUB}.nii.gz \
        -master ${SS} \
        -1Dmatrix_apply ${AFF_T2S} \
        -interp NN -final NN -overwrite
    fi
  done

  # Extract ROI & create meshes
  for LEVEL in 1 2 3 4 5 6
  do
      echo Processing level ${LEVEL}
      if [ "${doCHARM}" -eq 1 ]; then
        charmfld=${SS_AFF_OUT}/CHARM/ROI/Level_${LEVEL}
        charm_meshfld=${SS_AFF_OUT}/CHARM/ROIMESH/Level_${LEVEL}
        mkdir -p ${charmfld}
        mkdir -p ${charm_meshfld}
        labels="${CHARM_LFLD}/CHARM_key_${LEVEL}.txt"

        {
            read;
            while read -r line
            do
                set ${line}
                LABLENUM=${1}
                LABLENAME=${2}
                LABLENAME=${LABLENAME////-}
                # extract label as binary-mask
                fslmaths ${SS_AFF_OUT}/CHARM/CHARM_${LEVEL}_in_${SUB}.nii.gz \
                    -thr ${LABLENUM} -uthr ${LABLENUM} -bin ${charmfld}/${LABLENAME}.nii.gz
                if ((CREATEMESH == 1)); then
                  # convert binary mask to mesh
                  python ${SCRIPTFLD}/binarymask_to_mesh.py ${charmfld}/${LABLENAME}.nii.gz ${charm_meshfld}/${LABLENAME}.ply &
                fi
            done
        } < "${labels}"
      fi

      if [ "${doSARM}" -eq 1 ]; then
        sarmfld=${SS_AFF_OUT}/SARM/ROI/Level_${LEVEL}
        sarm_meshfld=${SS_AFF_OUT}/SARM/ROIMESH/Level_${LEVEL}
        mkdir -p ${sarmfld}
        mkdir -p ${sarm_meshfld}
        labels="${SARM_LFLD}/SARM_key_${LEVEL}.txt"

        {
            read;
            while read -r line
            do
                set ${line}
                LABLENUM=${1}
                LABLENAME=${2}
                LABLENAME=${LABLENAME////-}
                # extract label as binary-mask
                fslmaths ${SS_AFF_OUT}/SARM/SARM_${LEVEL}_in_${SUB}.nii.gz \
                  -thr ${LABLENUM} -uthr ${LABLENUM} -bin ${sarmfld}/${LABLENAME}.nii.gz
                if ((CREATEMESH == 1)); then
                  # convert binary mask to mesh
                  python ${SCRIPTFLD}/binarymask_to_mesh.py ${sarmfld}/${LABLENAME}.nii.gz ${sarm_meshfld}/${LABLENAME}.ply &
                fi
            done
        } < "${labels}"
      fi
  done

  if [ "${doD99}" -eq 1 ]; then
    d99fld=${SS_AFF_OUT}/D99v2/ROI
    d99_meshfld=${SS_AFF_OUT}/D99v2/ROIMESH
    mkdir -p ${d99fld}
    mkdir -p ${d99_meshfld}
    labels="${D99_LFLD}/D99_v2.0_labels_semicolon.txt"

    {
        while read -r line
        do
            LABLENUM=$(echo "$line" | cut -d';' -f1)
            LABLENAME=$(echo "$line" | cut -d';' -f2)
            LABLENAME=${LABLENAME////-}
            # extract label as binary-mask
            fslmaths ${D99} -thr ${LABLENUM} -uthr ${LABLENUM} -bin ${d99fld}/${LABLENAME}_id-${LABLENUM}.nii.gz
            if ((CREATEMESH == 1)); then
              # convert binary mask to mesh
              python ${SCRIPTFLD}/binarymask_to_mesh.py ${d99fld}/${LABLENAME}_id-${LABLENUM}.nii.gz ${d99_meshfld}/${LABLENAME}_id-${LABLENUM}.ply &
            fi
        done
    } < "${labels}"
  fi
else
  echo "Not all required modules are available. Quitting the script."
fi


