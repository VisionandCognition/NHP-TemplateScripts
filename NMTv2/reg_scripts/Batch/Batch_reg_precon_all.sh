#!/bin/bash

# set the location of the scripts folder
fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

# create an array with subject names to loop over
declare -a SUBS=(
	Brutus
	Watson
	Scholes
	Keane
    Butch
    Kid	
	Toucan
	Ozzy
	Danny
	Danny2021
	Aston
	Dasheng
	Eddy
	Eddy2019
	Figaro
	Figaro_T2w
	Kwibus
	Kwibus2015
	Lick
	Martin
	Martin2021
	Martin2023
	Martin2023_T2w
	MrNilson
	Spike
	Tsitian
	)

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Performing precon_all for ${S}
	echo '========================================='
	${fld}/ssreg_precon_all.sh ${S} 
	wait
	echo 'DONE'
	echo '========================================='
done
