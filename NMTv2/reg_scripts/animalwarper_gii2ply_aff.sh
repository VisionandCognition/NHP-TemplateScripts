#!/bin/bash

# call with subject name as argument
SUB=$1

# set some locations
BASE=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym
SS_FLD=$BASE/SingleSubjects/aligned_$SUB
SURF_FLD=$SS_FLD/surfaces
SURF_FLD_AFF=$SS_FLD/surfaces_aff


echo -----------------------------
echo Subject $SUB - Creating ply
echo -----------------------------
cp -r ${SURF_FLD} ${SURF_FLD_AFF}

# cycle over surface folders
for sf in $SURF_FLD_AFF/*/; do
    echo `basename $sf`
    # cycle over gii files
    for gii in $sf/*.gii; do
    	bn=`basename $gii .gii`
    	mkdir -p $sf/ply
    	ConvertSurface -i $gii -o $sf/ply/$bn.ply
    done
done
