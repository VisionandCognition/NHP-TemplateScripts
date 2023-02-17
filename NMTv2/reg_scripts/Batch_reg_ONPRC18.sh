#!/bin/bash

fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

declare -a SUBS=(
	Brutus
	# Danny
	# Dasheng
	# Eddy
	# Eddy2019
	# Figaro
	# Figaro_T2w
	# Kwibus
	# Kwibus2015
	# Martin
	# MircenCrop
	# MrNilson
	# Ozzy
	# Spike
	# Toucan
	# Tsitian
	# Watson
	# Martin2021
	# Aston
	# Lick
	)

for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping ONPRC18 DTI template ${S}
	echo '========================================='
	${fld}/SingleSubject_reg_affine_ONPRC18.sh ${S} 
	wait
	${fld}/SingleSubject_reg_nonlinear_ONPRC18.sh ${S} 
	wait
	echo 'DONE'
	echo '========================================='
done
