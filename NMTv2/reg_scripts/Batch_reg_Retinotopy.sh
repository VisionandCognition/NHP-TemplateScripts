#!/bin/bash

# set the location of the scripts folder
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

# create an array with subject names to loop over
declare -a SUBS=(
	Aston    
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
    # Spike    
    # Toucan    
    # Tsitian    
    # Watson 
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping Retinotopy ${S}
	echo '========================================='
	# perform the affine ROI registration
    ${fld}/SingleSubject_reg_affine_Retinotopy.sh ${S} 
    # perform the nonlinear ROI registration
    ${fld}/SingleSubject_reg_nonlinear_Retinotopy.sh ${S} 
	echo 'DONE'
	echo '========================================='
done
