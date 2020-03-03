#!/bin/bash
./extract_roi.sh $1
cp ../../atlases/D99_atlas/D99_label* ../$1/
./create_xml.sh $1