#!/bin/bash
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

declare -a SUBS=(
	# Aston    
    # Brutus    
    # Danny    
    # Danny2021    
    # Dasheng    
    # Eddy    
    # Eddy2019    
    # Figaro   
    # Kwibus    
    # Kwibus2015    
    # Lick    
    # Martin    
    # Martin2021    
    # MircenCrop    
    # MrNilson    
    # Ozzy    
    Spike    
    Toucan    
    Tsitian    
    sWatson 
	)

for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Creating ROIs and ROI meshes ${S}
	echo '========================================='
	${fld}/SingleSubject_reg_affine_ROIs.sh ${S} 
	${fld}/SingleSubject_reg_nonlinear_ROIs.sh ${S} 
	echo 'DONE'
	echo '========================================='
done
