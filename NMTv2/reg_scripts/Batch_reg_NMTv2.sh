
#!/bin/bash

fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts
#fld=/home/chris/Documents/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

declare -a SUBS=(
	Martin2021
	)

for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Registering template and atlases to ${S}
	echo '========================================='
	${fld}/SingleSubject_reg_NMTv2.sh ${S}
	wait
	${fld}/animalwarper_gii2ply.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done