#!/bin/bash

script_path="$0"
script_dir="$(dirname "$script_path")"

${script_dir}/Batch_reg_prep.sh
wait
${script_dir}/Batch_reg_NMTv2_T1w.sh
#${script_dir}/Batch_reg_NMTv2_T2w.sh
#${script_dir}/Batch_reg_NMTv2_T2w_MIRCen.sh
wait
${script_dir}/Batch_reg_rois.sh
wait
${script_dir}/Batch_reg_Retinotopy.sh
wait
${script_dir}/Batch_reg_Retinotopy-LGN.sh
wait
${script_dir}/Batch_reg_ONPRC18.sh
wait
${script_dir}/Batch_reg_precon_all.sh

