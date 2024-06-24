#!/bin/bash
# T1w / T2w / MIRCen / current / all
SUBTYPE=$1

case $SUBTYPE in
  T1w)
    declare -a SUBS=(
      # Aston
      # Brutus
      # Danny
      # Danny2021
      # Danny2022
      # Dasheng
      # Eddy
      # Eddy2019
      # Figaro
      # Kwibus
      # Kwibus2015
      # Lick
      # Martin
      # Martin2021
      # Martin2023
      # Martin2023us
      # MrNilson
      # Ozzy
      # Puck
      # Spike
      # Toucan
      # Tsitian
      # Watson
      # Diego2018
      # Pitt_20230912
      Diego2024
    )
      ;;
  T2w)
    declare -a SUBS=(
      # Figaro_T2w
      # Martin2023_T2w
	    # Martin2023_T2wus
      Diego2024_T2w
	    )
	  ;;
	MIRCen)
	  declare -a SUBS=(
	    Scholes
      Keane
      Butch
      Kid
      1MM015
      CIA073
	  )
	  ;;
	all)
	  declare -a SUBS=(
      # Aston
      # Brutus
      # Danny
      # Danny2021
      # Danny2022
      # Dasheng
      # Eddy
      # Eddy2019
      # Figaro
      # Kwibus
      # Kwibus2015
      # Lick
      # Martin
      # Martin2021
      # Martin2023
      # Martin2023us
      # MrNilson
      # Ozzy
      # Puck
      # Spike
      # Toucan
      # Tsitian
      # Watson
      # Diego2018
      # Figaro_T2w
      # Martin2023_T2w
	    # Martin2023_T2wus
	    # Scholes
      # Keane
      # Butch
      # Kid
      # 1MM015
      # CIA073
      Diego2024
      Diego2024_T2w
	  )
	  ;;
	current)
	  declare -a SUBS=(
      subject
	  )
	  ;;
	*)
	  echo No valid subject type selected
	  ;;
esac

for S in "${SUBS[@]}"
do
  echo Subjects include $S
done