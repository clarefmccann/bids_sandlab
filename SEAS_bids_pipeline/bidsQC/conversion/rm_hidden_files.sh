#!/bin/bash

# Base directory where the subject folders are located
base_dir="/u/project/silvers/data/bids/SB_bids_pipeline/bids_data/SB-T4"

# Loop through each subject's directory in the base directory
for subject_dir in "$base_dir"/sub-*; do
  # Define the path to the anatomy folder
  #anat_dir="${subject_dir}/ses-T4/anat"
  
  # # Check if the anatomy directory exists
  # if [ -d "$anat_dir" ]; then
  #   # Define the hidden file's path
  #   hidden_file="._sub-*_ses-T4_T1w.json"
    
  #   # Check if the hidden file exists and remove it
  #   if [ -f ${anat_dir}/${hidden_file} ]; then
  #     echo "Removing file: $hidden_file"
  #     rm ${hidden_file}
  #   else
  #     echo "File not found: $hidden_file"
  #   fi
  # else
  #   echo "Anatomy directory not found for: $subject_dir"
  # fi

  func_dir="${subject_dir}/ses-T4/func"

  # Check if the functional directory exists
  if [ -d "$func_dir" ]; then
    # Define the hidden file's path
    hidden_file="._sub-*_ses-T4*.json"
    
    # Check if the hidden file exists and remove it
    if [ -f ${func_dir}/${hidden_file} ]; then
      echo "Removing file: $hidden_file"
      rm ${hidden_file}
    else
      echo "File not found: $hidden_file"
    fi
  else
    echo "Functional directory not found for: $subject_dir"
  fi


done

echo "Script completed."


