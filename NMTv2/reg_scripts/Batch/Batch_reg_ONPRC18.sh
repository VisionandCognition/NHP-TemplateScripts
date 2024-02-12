#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0))
ssreg_dir=$(dirname $script_dir)

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

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping ONPRC18 DTI template ${S}
	echo '========================================='
	# perform the affine tensor registration
	${ssreg_dir}/ssreg_aff_ONPRC18.sh ${S}
	wait
	# perform the nonlinear tensor registration
	${ssreg_dir}/ssreg_nlin_ONPRC18.sh ${S}
	wait
	echo 'DONE'
	echo '========================================='
done
