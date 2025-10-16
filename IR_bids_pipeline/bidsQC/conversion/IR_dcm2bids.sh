#!/bin/bash

# Saché Coury & Clare F. McCann
# Notes: 1) activate conda environment $conda activate dcm2bids 2) make sure correct subjects list is specified 
# Usage: bash IR_dcm2bids.sh 


silvers=/u/project/silvers/data
#subject_list=IRA205 # --> single subject
subject_list=${silvers}/bids/IR_bids_pipeline/bidsQC/conversion/subject_list.txt

for subject in $(cat "$subject_list"); do

	dcm=${silvers}/IR/dicom/${subject}/*Prisma*/*/Silvers*/

	# Prepare dicoms

	cd ${silvers}/IR/dicom/

	if [ -d ${subject} ]; then
		echo "* ${subject} dir exists *"
	else
		echo "* ${subject} dir does not exist, uncompressing tar.gz *"
		tar -xvzf ${subject}.tar.gz 
	fi


	dcm2bids \
	-d ${dcm} \
	-p ${subject} \
	-c ${silvers}/bids/IR_bids_pipeline/bidsQC/conversion/study_config.json \
	-o ${silvers}/bids/IR_bids_pipeline/bids_data \
	--force_dcm2bids


	#if [ -d ${silvers}/bids/IR_bids_pipeline/bids_data/sub-${subject} ]; then 
	#	echo "* ${subject} bids dir exists *"
	#	cd ${silvers}/IR/dicom/
	#	rm -r ${subject}
	#	cd ${silvers}/bids/IR_bids_pipeline/bids_data/tmp_dcm2bids
	#	rm -r sub-*
	#else
	#	echo "* ${subject} bids dir does not exist, rerun *"
	#fi

done

