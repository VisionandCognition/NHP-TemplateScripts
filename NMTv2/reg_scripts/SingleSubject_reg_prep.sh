#!/bin/bash

# =========================
SUB=$1
INFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files/
MATFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files/1D
ORGFLD=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files/org
NMT=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/NMT_v2.0_sym/NMT_v2.0_sym.nii.gz

SS=${INFLD}/${SUB}.nii.gz
SSORG=${INFLD}/${SUB}_org.nii.gz

# =========================
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
