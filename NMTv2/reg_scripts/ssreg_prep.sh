#!/bin/bash
# =========================
# Argument handling
SUB=${1}
TEMPLATEFLD=${2:-'/NHP_MRI/Template'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_sym'}
NMTTYPE2=${5:-'NMT_v2.0_sym'}

# =========================
# Derived variables
BASENMT=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}
SSFLD=${BASENMT}/SingleSubjects
INFLD=${SSFLD}/input_files/
MATFLD=${SSFLD}/input_files/1D
ORGFLD=${SSFLD}/input_files/org
NMT=${BASENMT}/${NMTTYPE2}/${NMTTYPE2}.nii.gz
SS=${INFLD}/${SUB}.nii.gz
SSORG=${INFLD}/${SUB}_org.nii.gz
# =========================

{
if [ ! -f $SS ]; then
    echo "The individual subject scan does not exist or isn't in the correct folder!"
    echo "Check whether the path below is actually correct and try again: "
    echo $SS
    exit 0
fi
}

mkdir -p ${MATFLD}
mkdir -p ${ORGFLD}
cp ${SS} ${SSORG}

@Align_Centers \
    -no_cp \
    -overwrite \
    -base ${NMT} \
    -dset ${SS}

mv ${INFLD}/*_org.nii.gz ${ORGFLD}/
mv ./*.1D ${MATFLD}/
