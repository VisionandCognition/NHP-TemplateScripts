#!/bin/bash
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

declare -a SUBS=(
	# Figaro_T2w
	)

# cost function lpa for T1w, lpc for T2w
COST=lpc

for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	${fld}/SingleSubject_reg_NMTv2.sh ${S} ${COST}
	wait
	${fld}/animalwarper_gii2ply.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done
