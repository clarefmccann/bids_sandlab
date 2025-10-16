#!/bin/bash

silvers=/u/project/silvers/data

for subject in IRA043 \
IRA044 \
IRA046 \
IRA047 \
IRA050 \
IRA051 \
IRA052 \
IRA053 \
IRA055 \
IRA056 \
IRA058 \
IRA059 \
IRA060 \
IRA061 \
IRA062 \
IRA063 \
IRA065 \
IRA066 \
IRA067 \
IRA068 \
IRA069 \
IRA070 \
IRA072 \
IRA073 \
IRA074 \
IRA075 \
IRA077 \
IRA078 \
IRA201; do

	anat_dir=${silvers}/bids/IR_bids_pipeline/bids_data/sub-${subject}/anat/
	json=sub-${subject}_T1w.json

	#cd ${anat_dir}
	#scp -r ${json} /Users/sachecoury/Library/CloudStorage/Box-Box/IR_anat_jsons/
	rclone copy ${anat_dir}/${json} box:/IR_anat_jsons/ --ignore-existing --progress

done 


