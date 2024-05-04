#!/bin/bash

FLD=/NHP_MRI/Template
TARG=${FLD}/NMT_v2.0/NMT_v2.0_sym/NMT_v2.0_sym/NMT_v2.0_sym.nii.gz
D99v2_atlas=${FLD}/D99_v2.0/D99_atlas_v2.0.nii.gz
D99v2_in_TARG=${FLD}/NMT_v2.0/NMT_v2.0_sym/NMT_v2.0_sym/D99v2_atlas_in_NMT_v2.0_sym.nii.gz
D99v2_to_TARG=${FLD}/RheMAP/warps/final/D99_to_NMTv2.0-sym_CompositeWarp.nii.gz


antsApplyTransforms -i $D99v2_atlas -r $TARG -o $D99v2_in_TARG -t $D99v2_to_TARG -n NearestNeighbor
cp ${FLD}/D99_v2.0/D99_Suppl_Table_1.xlsx ${FLD}/NMT_v2.0/NMT_v2.0_sym/tables_D99/D99_Suppl_Table_1.xlsx
cp ${FLD}/D99_v2.0/D99_v2.0_labels_semicolon.txt ${FLD}/NMT_v2.0/NMT_v2.0_sym/tables_D99/D99_v2.0_labels_semicolon.txt

TARG=${FLD}/NMT_v2.0/NMT_v2.0_asym/NMT_v2.0_asym/NMT_v2.0_asym.nii.gz
D99v2_atlas=${FLD}/D99_v2.0/D99_atlas_v2.0.nii.gz
D99v2_in_TARG=${FLD}/NMT_v2.0/NMT_v2.0_asym/NMT_v2.0_asym/D99v2_atlas_in_NMT_v2.0_asym.nii.gz
D99v2_to_TARG=${FLD}/RheMAP/warps/final/D99_to_NMTv2.0-asym_CompositeWarp.nii.gz

antsApplyTransforms -i $D99v2_atlas -r $TARG -o $D99v2_in_TARG -t $D99v2_to_TARG -n NearestNeighbor
cp ${FLD}/D99_v2.0/D99_Suppl_Table_1.xlsx ${FLD}/NMT_v2.0/NMT_v2.0_asym/tables_D99/D99_Suppl_Table_1.xlsx
cp ${FLD}/D99_v2.0/D99_v2.0_labels_semicolon.txt ${FLD}/NMT_v2.0/NMT_v2.0_asym/tables_D99/D99_v2.0_labels_semicolon.txt

