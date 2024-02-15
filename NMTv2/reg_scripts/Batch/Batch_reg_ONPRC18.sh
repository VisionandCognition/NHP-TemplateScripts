#!/bin/bash

# set the location of the scripts folder
ssreg_dir=$(realpath $(dirname $0))

# create an array with subject names to loop over
declare -a SUBS=(
  	Aston
  	Brutus
  	Danny
  	Danny2021
  	Danny2022
  	Dasheng
  	Eddy
  	Eddy2019
  	Figaro
  	Kwibus
  	Kwibus2015
  	Lick
  	Martin
  	Martin2021
  	Martin2023
  	Martin2023us
  	MrNilson
  	Ozzy
  	Puck
  	Spike
  	Toucan
  	Tsitian
  	Watson
  	Diego2018
  	#Figaro_T2w
	#Martin2023_T2w
	#Martin2023_T2wus
	#Pitt_20230912
	#Scholes
  	#Keane
  	#Butch
  	#Kid
  	#1MM015
  	#CIA073
	)

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping ONPRC18 DTI template ${S}
	echo '========================================='
	# perform the affine tensor registration
	${ssreg_dir}/ssreg_aff_ONPRC18.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	wait
	# perform the nonlinear tensor registration
	${ssreg_dir}/ssreg_nlin_ONPRC18.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	wait
	echo 'DONE'
	echo '========================================='
done
