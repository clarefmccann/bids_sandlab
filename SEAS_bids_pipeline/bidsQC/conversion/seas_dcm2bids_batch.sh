#!/bin/bash

# Saché M. Coury 
# Notes: 1) activate conda environment $conda activate dcm2bids 2) make sure correct subjects list and timepoint is specified 
# Usage: qsub seas_dcm2bids_batch.sh 

#$ -cwd
# error = Merged with joblog
#$ -N dcm2bids_$SGE_TASK_ID
#$ -o /u/project/silvers/data/bids/SEAS_bids_pipeline/bidsQC/conversion/output/dcm2bids_$JOB_ID.out
#$ -j y
#$ -pe shared 2
#$ -l h_rt=24:00:00,h_data=16G
# Email address to notify
#$ -M $scoury@ucla.edu
# Notify when
#$ -m e
#$ -t 1-6:1

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module use /u/project/CCN/apps/modulefiles

module load python/3.9.6
module load anaconda3/2023.03

silvers=/u/project/silvers/data

# SPECIFY CORRECT SESSION HERE
tp=T1 #updated by notebook

dcm2bids_env=${silvers}/scripts/containers

# Create and activate the conda environment
cd ${dcm2bids_env}
conda activate dcm2bids

# SPECIFY SUBJECT LIST INFO HERE
#subject_list=SEAS004 # --> single subject
subject_list=${silvers}/bids/SEAS_bids_pipeline/bidsQC/conversion/seas_bids_subjects.txt # --> batch of subjects

# Read the subject ID corresponding to the task ID
subject=$(sed -n "${SGE_TASK_ID}p" "$subject_list")

dcm=${silvers}/SEAS/dicom/${tp}/${subject}/*Prisma_Fit*/*/Silvers_SEAS*/

# Prepare dicoms

cd ${silvers}/SEAS/dicom/${tp}

if [ -d ${subject} ]; then
    echo "* ${subject} dir exists *"
else
    echo "* ${subject} dir does not exist, uncompressing tar.gz *"
    tar -xvzf ${subject}.tar.gz 
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
    cd ${silvers}/bids/SEAS_bids_pipeline/bids_data/SEAS-${tp}/tmp_dcm2bids
    rm -r sub-${subject}*
    cd ${silvers}/SEAS/dicom/${tp}
    tar -cvzf ${subject}.tar.gz ${subject}
else
    echo "* ${subject} bids dir does not exist, rerun *"
fi

# Deactivate the conda environment
conda deactivate
