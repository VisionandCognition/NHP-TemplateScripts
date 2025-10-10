#!/bin/bash

# set the location of the scripts folder
script_dir=$(realpath $(dirname $0)) 

# ${script_dir}/Batch_reg_prep.sh current_t1
# ${script_dir}/Batch_reg_prep.sh current_t2
# wait

# ${script_dir}/Batch_reg_NMTv2_T1w_parallel.sh current_t1
# ${script_dir}/Batch_reg_NMTv2_T2w_parallel.sh current_t2
# #${script_dir}/Batch_reg_NMTv2_T2w_MIRCen.sh
# wait

# # NB! make sure you have the relevant python dependencies on the path for the next step

# ${script_dir}/Batch_reg_rois_parallel.sh current_t1
# #${script_dir}/Batch_reg_rois.sh current_t1
# ${script_dir}/Batch_reg_rois_parallel.sh current_t2
# #${script_dir}/Batch_reg_rois.sh current_t2
# wait

# ${script_dir}/Batch_reg_Retinotopy.sh current_t1
# ${script_dir}/Batch_reg_Retinotopy-LGN.sh current_t1
# ${script_dir}/Batch_reg_Retinotopy.sh current_t2
# ${script_dir}/Batch_reg_Retinotopy-LGN.sh current_t2
# wait

# ${script_dir}/Batch_reg_ONPRC18.sh current_t1
# ${script_dir}/Batch_reg_ONPRC18.sh current_t2
# wait

${script_dir}/Batch_reg_Vasculature.sh current_t1
${script_dir}/Batch_reg_Vasculature.sh current_t2
wait

#${script_dir}/Batch_reg_precon_all_parallel.sh current
#${script_dir}/Batch_reg_precon_all.sh current


