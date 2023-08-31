#!/bin/bash

# call with subject name as argument
SUB=$1

# set some locations
BASE=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym
SS_FLD=$BASE/SingleSubjects/aligned_$SUB
SURF_FLD=$SS_FLD/surfaces

echo -----------------------------
echo Subject $SUB - Creating ply
echo -----------------------------


# cycle over surface folders
for sf in $SURF_FLD/*/; do
    echo `basename $sf`
    # cycle over gii files
    for gii in $sf/*.gii; do
    	bn=`basename $gii .gii`
    	mkdir -p $sf/ply
    	ConvertSurface -i $gii -o $sf/ply/$bn.ply
    done
done
