#!/bin/bash
fld=/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/reg_scripts

declare -a SUBS=(
	#Aston    
    #Brutus    
    #Danny    
    #Danny2021    
    #Dasheng    
    #Eddy    
    #Eddy2019    
    #Figaro   
    #Kwibus    
    #Kwibus2015    
    #Lick    
    #Martin    
    #Martin2021    
    #MircenCrop    
    #MrNilson    
    #Ozzy    
    Spike    
    Toucan    
    Tsitian    
    Watson 
	)

# cost function lpa for T1w, lpc for T2w
COST=lpa

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
