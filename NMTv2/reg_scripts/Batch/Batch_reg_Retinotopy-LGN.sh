#!/bin/bash

# set the location of the scripts folder
script_path="$0"
script_dir="$(dirname "$script_path")"
ssreg_dir="$(dirname "$script_dir")"

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
  Figaro_T2w
	Martin2023_T2w
	Martin2023_T2wus
	# Pitt_20230912
	Scholes
  Keane
  Butch
  Kid
  1MM015
  CIA073
	)

TEMPLATEFLD='/NHP_MRI/Template'
NMTVERSION='NMT_v2.0'
NMTTYPE1='NMT_v2.0_asym'
NMTTYPE2='NMT_v2.0_asym'

# loop over subjects
for S in "${SUBS[@]}"
do
	echo '========================================='
	echo Warping Retinotopy ${S}
	echo '========================================='
	# perform the affine registration
    ${ssreg_dir}/ssreg_aff_Retinotopy-LGN.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
    # perform the nonlinear registration
    ${ssreg_dir}/ssreg_nlin_Retinotopy-LGN.sh ${S} ${TEMPLATEFLD} ${NMTVERSION} ${NMTTYPE1} ${NMTTYPE2}
	echo 'DONE'
	echo '========================================='
done