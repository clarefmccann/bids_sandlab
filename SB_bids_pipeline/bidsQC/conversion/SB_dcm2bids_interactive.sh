#!/bin/bash

# Saché M. Coury & Clare F. McCann
# Notes: 1) activate conda environment $conda activate dcm2bids 2) make sure relevant timepoint is selected 3) make sure correct subjects list is specified 
# Usage: bash dcm2bids.sh 


silvers=/u/project/silvers/data
tp=T5 #T4 #T5
#subject=SB004 # --> single subject
#t4_subject_list=${silvers}/SB/dicom/${tp}/t4_bids_subjects.txt
subject_list=${silvers}/bids/SB_bids_pipeline/bidsQC/conversion/t5_bids_subjects.txt

for subject in $(cat "$subject_list"); do

	#dcm=${silvers}/bids/SB_bids_pipeline/bids_data/tmp_dcm2bids/tmp_dcm/${subject}/PRISMA_FIT_MRC35343/*/SILVERSGROUP_SBCONT_1/
	dcm=${silvers}/SB/dicom/${tp}/${subject}/*PRISMA_FIT*/*/SILVERSGROUP*/

	# Prepare dicoms

	cd ${silvers}/SB/dicom/${tp}

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
	-c ${silvers}/bids/SB_bids_pipeline/bidsQC/conversion/study_config.json \
	-o ${silvers}/bids/SB_bids_pipeline/bids_data/SB-${tp} \
	--force_dcm2bids


	if [ -d ${silvers}/bids/SB_bids_pipeline/bids_data/sub-${subject} ]; then 
		echo "* ${subject} bids dir exists *"
		# cd ${silvers}/SB/dicom/${tp}
		# rm -r ${subject}
		cd ${silvers}/bids/SB_bids_pipeline/bids_data/tmp_dcm2bids
		rm -r sub-*
	else
		echo "* ${subject} bids dir does not exist, rerun *"
	fi

done






