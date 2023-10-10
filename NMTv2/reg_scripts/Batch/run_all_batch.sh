#!/bin/bash
fld=/MRI_ANALYSIS/NHP-TemplateScripts/NMTv2/reg_scripts

# ${fld}/Batch/Batch_reg_prep.sh
# wait
#${fld}/Batch/Batch_reg_NMTv2_T1w.sh
#${fld}/Batch/Batch_reg_NMTv2_T2w.sh
# wait
${fld}/Batch/Batch_reg_rois.sh
wait
#${fld}/Batch/Batch_reg_Retinotopy.sh
#wait
${fld}/Batch/Batch_reg_Retinotopy-LGN.sh
#wait
#${fld}/Batch/Batch_reg_ONPRC18.sh
#wait
#${fld}/Batch/Batch_reg_precon_all.sh

