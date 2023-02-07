
#!/bin/bash

fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

declare -a SUBS=(
	Martin2021
	)

for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Creating ROIs and ROI meshes ${S}
	echo '========================================='
	#${fld}/SingleSubject_affine_ROIs.sh ${S} 
	${fld}/SingleSubject_nonlinear_ROIs.sh ${S} 
	echo 'DONE'
	echo '========================================='
done
