#!/bin/bash
NMTPATH="/media/DATA1/NHP_MRI/Template/NMT_v1.3"

#./extract_roi_NMTv1.3.sh $1 "${NMTPATH}"
cp ${NMTPATH}/D99_label* ${NMTPATH}/single_subject_scans/$1/
./create_xml_NMTv1.3.sh $1 "${NMTPATH}/"