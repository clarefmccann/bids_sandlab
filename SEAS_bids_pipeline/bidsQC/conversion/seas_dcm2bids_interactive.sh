#!/bin/bash

# Saché M. Coury 
# Notes: 1) activate conda environment $conda activate dcm2bids 2) make sure relevant timepoint is selected 3) make sure correct subjects list is specified 
# Usage: bash seas_dcm2bids_interactive.sh 


silvers=/u/project/silvers/data
tp=pilot #T1 #T2
#subject=SEAS998 # --> single subject
subject_list=${silvers}/bids/SEAS_bids_pipeline/bidsQC/conversion/subject_list.tsv

for subject in $(cat "$subject_list"); do

	dcm=${silvers}/SEAS/dicom/${tp}/${subject}/*Prisma_Fit*/*/Silvers_SEAS*/

	# Prepare dicoms

	cd ${silvers}/SEAS/dicom/${tp}

	if [ -d ${subject} ]; then
		echo "* ${subject} dir exists *"
	else
		echo "* ${subject} dir does not exist, uncompressing tar.gz *"
		tar -xvzf ${subject}.tar.gz #-C ${silvers}/bids/SEAS_bids_pipeline/bids_data/tmp_dcm2bids/tmp_dcm
	fi

	dcm2bids \
	-d ${dcm} \
	-p ${subject} \
	-s ${tp} \
	-c ${silvers}/bids/SEAS_bids_pipeline/bidsQC/conversion/study_config.json \
	-o ${silvers}/bids/SEAS_bids_pipeline/bids_data/SEAS-${tp} \
	--force_dcm2bids


	if [ -d ${silvers}/bids/SEAS_bids_pipeline/bids_data/SEAS-${tp}/sub-${subject} ]; then 
		echo "* ${subject} bids dir exists *"
		# cd ${silvers}/SB/dicom/${tp}
		# rm -r ${subject}
		cd ${silvers}/bids/SEAS_bids_pipeline/bids_data/SEAS-${tp}/tmp_dcm2bids
		rm -r sub-*
	else
		echo "* ${subject} bids dir does not exist, rerun *"
	fi

done






