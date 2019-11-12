#!/bin/bash

##################### Coverage Check Script ################################

# Purpose: This QC script calculates the individual coverage rates for all included masks and writes it out to a csv file.

# Create subject list.
dir=/nfs/turbo/ahrb-data/FSL_Analysis/models/mid_anticipation
mask_dir=/nfs/turbo/ahrb-data/Demidenko/HighLowRisk_Analyses/scripts/roi
out=/nfs/turbo/ahrb-data/Demidenko/HighLowRisk_Analyses/

# Specify mask files
masks="NS_ACC NS_Left_OFC NS_Right_Amydala NS_Right_PPC NS_Left_Amygdala NS_Left_PPC NS_Right_dlPFC NS_Right_VS NS_Left_dlPFC NS_Left_VS NS_Right_Insula NS_vmPFC NS_vmPFC_vc NS_Left_Insula NS_mPFC NS_Right_OFC"

for sub in $(cat $1 ) ; do
	echo "${sub}"
	for mask in ${masks} ; do
		echo "${mask}"
		# Calculate the possible number of voxels in the subject specific mask
		mask_vol=$(fslstats $mask_dir/${mask} -V | awk '{ print $1 }') 
		echo ${mask_vol}

		# Count the number of non-zero voxels in the subject specific mask given the data
		coverage=$(fslstats $dir/$sub/model/FirstLevel/run_01.feat/temp/mask_threshold_18.nii.gz -k $mask_dir/${mask} -V | awk '{ print $1 }')
		echo $coverage

		# Calculate the coverage percentage
		ratio=$(perl -e "print $coverage/${mask_vol}" | cut -c1-4)
		echo ${ratio}

		# Print out the results
		echo "${sub},${mask},${mask_vol},${coverage},${ratio}" >> $out_dir/coverage.csv
	done
done
