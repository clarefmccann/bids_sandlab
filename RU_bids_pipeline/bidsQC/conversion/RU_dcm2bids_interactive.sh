#!/bin/bash

# Saché M. Coury 
# Notes: 1) activate conda environment $conda activate dcm2bids 2) make sure relevant timepoint is selected 3) make sure correct subjects list is specified 
# Usage: bash dcm2bids.sh 


silvers=/u/project/silvers/data
tp=T1
#subject=SB004 # --> single subject

subject_list=${silvers}/bids/RU_bids_pipeline/bidsQC/conversion/ru_bids_subjects.tsv

for subject in $(cat "${subject_list}"); do

	dcm=${silvers}/RU/dicom/${subject}/*Prisma_Fit*/*/Silvers_RiseUp*/

	# Prepare dicoms

	cd ${silvers}/RU/dicom

	if [ -d ${subject} ]; then
		echo "* ${subject} dir exists *"
	else
		echo "* ${subject} dir does not exist, uncompressing tar.gz *"
		tar -xvzf ${subject}.tar.gz #-C ${silvers}/bids/SB_bids_pipeline/bids_data/tmp_dcm2bids/tmp_dcm
	fi

	dcm2bids \
	-d ${dcm} \
	-p ${subject} \
	-s ${tp} \
	-c ${silvers}/bids/RU_bids_pipeline/bidsQC/conversion/study_config.json \
	-o ${silvers}/bids/RU_bids_pipeline/bids_data \
	--force_dcm2bids


	if [ -d ${silvers}/bids/RU_bids_pipeline/bids_data/sub-${subject} ]; then 
		echo "* ${subject} bids dir exists *"
		cd ${silvers}/bids/RU_bids_pipeline/bids_data/tmp_dcm2bids
		rm -r sub-*
		cd ${silvers}/RU/dicom
		tar -cvzf ${subject}.tar.gz ${subject}
	else
		echo "* ${subject} bids dir does not exist, rerun *"
	fi

done






