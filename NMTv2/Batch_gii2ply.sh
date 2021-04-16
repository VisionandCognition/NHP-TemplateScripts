
#!/bin/bash

fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

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
