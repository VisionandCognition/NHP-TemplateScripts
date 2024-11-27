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
      # Diego2024
      Danny20231017
    )
      ;;
  T2w)
    declare -a SUBS=(
      # Figaro_T2w
      # Martin2023_T2w
	    # Martin2023_T2wus
      # Diego2024_T2w
      # Diego2024_T2wus
      Danny20231017_T2w
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
      Falck
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
      # Falk
      Danny20231017
      Danny20231017_T2w
	  )
    ;;
  current_t1)
    declare -a SUBS=(
      LXVI_T1w_nohp
      LXVI_T1w_hp
    )  
	  ;;
  current_t2)
    declare -a SUBS=(
      LXVI_T2w_nohp
      LXVI_T2w_hp
    )  
    ;;  
	*)
	  echo No valid subject type selected
	  ;;
esac

echo 'Subjects include:'
for S in "${SUBS[@]}"
do
  echo $S
done