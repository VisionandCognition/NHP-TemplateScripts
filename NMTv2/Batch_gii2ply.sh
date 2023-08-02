#!/bin/bash

fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

declare -a SUBS=(
	Dasheng
	Eddy
	Eddy2019
	Kwibus
	Kwibus2015
	Lick
	Martin
	MrNilson
	Ozzy
	Spike
	Tsitian
	)

for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	${fld}/animalwarper_gii2ply.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done
