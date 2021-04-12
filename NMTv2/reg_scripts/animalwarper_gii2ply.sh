#!/bin/bash

# call with subject name as argument

SUB=$1

BASE=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym
SS_FLD=$BASE/aligned_$SUB
SURF_FLD=$SS_FLD/surfaces

# cycle over surface folders
for dir in $SURF_FLD/*; do
    echo $dir
    # cycle over gii files
    #for gii in $sf/*.gii
done
