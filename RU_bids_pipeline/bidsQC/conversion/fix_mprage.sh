#!/bin/bash

#Author: Saché M. Coury
#Notes: run this script to organize raw dicom directories and usable data for new SB subjects (warning: make sure you are feeding in correct timepoint and updated subject list) 
#Usage: bash fix_mprage.sh 

silvers=/u/project/silvers/data
tp=T5 #T4 #T5
#subject=SB004 # --> single subject
#t4_subject_list=${silvers}/SB/dicom/${tp}/t4_bids_subjects.txt
#t4_subject_list=${silvers}/bids/SB_bids_pipeline/bidsQC/conversion/t4_bids_subjects_02.23.24.txt
subject_list=${silvers}/bids/SB_bids_pipeline/bidsQC/conversion/t5_bids_subjects.txt

# Loop through each subject folder in the current directory
for subject in $(cat "$subject_list"); do

  # Navigate into the subject folder
  dcm=${silvers}/SB/dicom/${tp}/${subject}/*PRISMA_FIT*/*/SILVERSGROUP*/
  
  cd ${dcm}
  
  # Check if the 'unusable' directory does not exist
  if [ ! -d unusable ]; then
    # Create the 'unusable' directory
    mkdir unusable
  fi

  # Check if the 'T1W_MPR_5' directory exists
  if [ -d T1W_MPR_5 ]; then

    # Move the 'T1W_MPR_5' directory into the 'unusable' directory
    mv T1W_MPR_5 unusable/
    echo "Moved 'T1W_MPR_5' to 'unusable' for ${subject}"
  else
    echo "'T1W_MPR_5' not found for ${subject}"
  fi

  if [ "$(ls -A unusable)" ]; then
    mv ${dcm}/unusable ../
    echo "Moved 'unusable' directory up one level for ${subject}"
  else
    echo "'unusable' directory is empty or does not exist for ${subject}"
  fi

done