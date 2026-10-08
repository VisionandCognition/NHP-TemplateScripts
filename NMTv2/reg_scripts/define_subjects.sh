#!/bin/bash
# T1w / T2w / MIRCen / current / all
SUBTYPE=$1

case $SUBTYPE in
  T1w)
    declare -a SUBS=(
      # Aston
      # Brutus
      # Brutus2025
      # Danny
      # Danny2021
      # Danny2022
      # Dasheng
      # Eddy
      # Eddy2019
      # Figaro
      # Galileo
      # Kwibus
      # Kwibus2015
      # Lick
      # Louie
      # Martin
      # Martin2021
      # Martin2023
      # Martin2023us
      # Mina
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
      # Danny20231017
      # Yoko
    )
      ;;
  T2w)
    declare -a SUBS=(
      # Brutus2025_T2w
      # Figaro_T2w
      # Martin2023_T2w
	    # Martin2023_T2wus
      # Diego2024_T2w
      # Diego2024_T2wus
      # Danny20231017_T2w
      # Galileo_T2w
      # Louie_T2w
	    )
	  ;;
	MIRCen)
	  declare -a SUBS=(
	    #Scholes
      #Keane
      #Butch
      #Kid
      #1MM015
      #CIA073
      #Falck
      #K002
      #DR145
      R19023
      R19025
      DU617
	  )
	  ;;
	all)
	  declare -a SUBS=(
      Brutus
      Brutus2025
      Brutus2025_T2w
      Butch
      Danny
      Danny2021
      Danny2022
      Danny20231017
      Danny20231017_T2w
      Dasheng
      Eddy
      Eddy2019
      Figaro
      Figaro_T2w
      Keane
      Kid
      Kwibus
      Kwibus2015
      Martin
      Martin2021
      Martin2023
      Martin2023us
      Martin2023_T2w
      Martin2023_T2wus
      MrNilson
      Ozzy
      Puck
      Scholes
      Spike
      Toucan
      Tsitian
      Watson
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
      # Diego2024
      # Diego2024_T2w
	  )
	  ;;
	current)
	  declare -a SUBS=(
      Dasheng_20260611_T1w
      Dasheng_20260611_T2w
      BPRC_21009_T1w
      BPRC_21009_T2w
      BPRC_21011_T1w
      BPRC_21011_T2w
	  )
    ;;
  current_t1)
    declare -a SUBS=(
      Dasheng_20260611_T1w
      BPRC_21009_T1w
      BPRC_21011_T1w
    )  
	  ;;
  current_t2)
    declare -a SUBS=(
      # Dasheng_20260611_T2w
      # BPRC_21009_T2w
      BPRC_21011_T2w
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