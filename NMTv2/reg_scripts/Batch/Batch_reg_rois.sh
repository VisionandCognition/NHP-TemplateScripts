#!/bin/bash

# set the location of the scripts folder
fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

# create an array with subject names to loop over
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
    # Martin2023   
    # MrNilson    
    # Ozzy    
    # Spike    
    # Toucan    
    # Tsitian    
    # Watson 
    # Scholes
    # Keane
    # Butch
    # Kid  
    # Diego2018
    # Puck
    Martin2023_T2wus  
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Creating ROIs and ROI meshes ${S}
	echo '========================================='
	# perform the affine ROI registration
    ${fld}/ssreg_aff_ROIs.sh ${S} 
    # perform the nonlinear ROI registration
    ${fld}/ssreg_nlin_ROIs.sh ${S} 
	echo 'DONE'
	echo '========================================='
done
