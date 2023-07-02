#!/bin/bash

# ./Batch_reg_prep.sh
# wait
# Batch_reg_NMTv2_T1w.sh
#./Batch_reg_NMTv2_T2w.sh
# wait
./Batch_reg_rois.sh
wait
./Batch_reg_Retinotopy.sh
wait
./Batch_reg_Retinotopy-LGN.sh
wait
./Batch_reg_ONPRC18.sh


