

#!/bin/bash

# Saché Coury & Clare F. McCann
# Notes: 1) activate conda environment $conda activate dcm2bids 2) make sure correct subjects list is specified 
# Usage: qsub IR_dcm2bids_batch.sh 

#$ -cwd
# error = Merged with joblog
#$ -N dcm2bids_$SGE_TASK_ID
#$ -o /u/project/silvers/data/bids/IR_bids_pipeline/bidsQC/conversion/output/dcm2bids_$JOB_ID.out
#$ -j y
#$ -pe shared 2
#$ -l h_rt=24:00:00,h_data=24G
# Email address to notify
#$ -M $clarefmccann@ucla.edu
# Notify when
#$ -m bea
#$ -t 1-2:1

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module use /u/project/CCN/apps/modulefiles

module load python/3.9.6
module load anaconda3/2023.03

silvers=/u/project/silvers/data

dcm2bids_env=${silvers}/scripts/containers

# Create and activate the conda environment
cd ${dcm2bids_env}
conda activate dcm2bids

#subject_list=IRA045 # --> single subject
subject_list=${silvers}/bids/IR_bids_pipeline/bidsQC/conversion/subject_list.txt

# Read the subject ID corresponding to the task ID
subject=$(sed -n "${SGE_TASK_ID}p" "$subject_list")

dcm=${silvers}/IR/dicom/${subject}/*Prisma*/*/

# Prepare dicoms

cd ${silvers}/IR/dicom/

if [ -d ${subject} ]; then
    echo "* ${subject} dir exists *"
else
    echo "* ${subject} dir does not exist, uncompressing tar.gz *"
    tar -xvzf ${subject}.tar.gz 
fi

dcm2bids -d ${dcm} -p ${subject} -c ${silvers}/bids/IR_bids_pipeline/bidsQC/conversion/study_config.json -o ${silvers}/bids/IR_bids_pipeline/bids_data --force_dcm2bids

#if [ -d ${silvers}/bids/IR_bids_pipeline/bids_data/sub-${subject} ]; then 
 #   echo "* ${subject} bids dir exists *"
  #  cd ${silvers}/IR/dicom/
   # rm -r ${subject}
#else
    #echo "* ${subject} bids dir does not exist, rerun *"
#fi

# Deactivate the conda environment
conda deactivate

