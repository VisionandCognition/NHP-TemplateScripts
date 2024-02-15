#!/bin/bash

# call with subject name as argument
# =========================
SUB=$1
TEMPLATEFLD=${2:-'/NHP_MRI/Template'}
NMTVERSION=${3:-'NMT_v2.0'}
NMTTYPE1=${4:-'NMT_v2.0_sym'}
# =========================

BASEFLD=${TEMPLATEFLD}/${NMTVERSION}/${NMTTYPE1}

# set some locations
SS_FLD=${BASEFLD}/SingleSubjects/aligned_$SUB
SURF_FLD=${SS_FLD}/surfaces

echo -----------------------------
echo Subject ${SUB} - Creating ply
echo -----------------------------


# cycle over surface folders
for sf in ${SURF_FLD}/*/; do
    echo `basename $sf`
    # cycle over gii files
    for gii in $sf/*.gii; do
    	bn=`basename $gii .gii`
    	mkdir -p $sf/ply
    	ConvertSurface -i $gii -o $sf/ply/$bn.ply
    done
done
