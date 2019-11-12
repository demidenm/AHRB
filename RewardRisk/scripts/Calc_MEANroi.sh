#!/bin/bash

# 			[This script was created by Michael Demidenko © 2019]
# The function of this script is to use the zstat, preprocessed, files from fsl provided and pull a mean signal intensity for a specified list of ROIs.
# The scripts utilizes fslmeants, whereby an input image '-i' (e.g. zstat file) is masked with a binarized 3D mask '-m', and outputs the mean .txt into a mean_roi (which the script creates) subfolder in the location of the 4D input image provided '-o'.
# Subsequent to this script, please run 3_ROI_meanROI.sh to get list of each subjects mean_ROI


#Please modify the project direction, location of your masks, and output file for paths of mean intensity values created to be used in next script	
	proj=/nfs/turbo/ahrb-data
	model=$proj/FSL_Analysis/models/mid_anticipation
	mask=$proj/Demidenko/HighLowRisk_Analyses/scripts/roi
	output=$proj/Demidenko/HighLowRisk_Analyses/roi_output/Neurosynth_mean_ROI.csv


	

# Do Not Alter Values below this field, unless necessary.



echo "This script requires input of Regions of Interest mask file names ."
echo "Please provide a list with these subject list."
echo " 		example:  ./2.1_ROI_meanROI.sh <subject.txt> "
echo "These must be updated in the script; if not have done so, please end and update"
sleep 2
echo

echo -e "subject\tNS_Left_VS\tNS_Right_VS\tNS_Left_Amygdala\tNS_Right_Amygdala\tNS_Left_dlPFC\tNS_Right_dlPFC\tNS_Left_OFC\tNS_Right_OFC\tNS_Left_Insula\tNS_Right_Insula\tNS_Left_PPC\tNS_Right_PPC\tNS_vmPFC\tNS_ACC" > $output

for subj in $(cat $1 ) ; do
echo "## Beginning $subj"
#	for NS_roi in $(cat $2 ) ; do

# 	location of feat file being using
	model_path=$model/$subj/model/SecondLevel/second.gfeat/cope1.feat/stats/zstat1.nii.gz
	
	Left_VS=$(fslmeants -i  -m $mask/NS_Left_VS.nii.gz)
	Right_VS=$(fslmeants -i $model_path -m $mask/NS_Right_VS.nii.gz)
	Left_Amygdala=$(fslmeants -i $model_path -m $mask/NS_Left_Amygdala.nii.gz)
	Right_Amygdala=$(fslmeants -i $model_path -m $mask/NS_Right_Amygdala.nii.gz)
	Left_dlPFC=$(fslmeants -i $model_path -m $mask/NS_Left_dlPFC.nii.gz)
	Right_dlPFC=$(fslmeants -i $model_path -m $mask/NS_Right_dlPFC.nii.gz)
	Left_OFC=$(fslmeants -i $model_path -m $mask/NS_Left_OFC.nii.gz)
	Right_OFC=$(fslmeants -i $model_path -m $mask/NS_Right_OFC.nii.gz)
	Left_Insula=$(fslmeants -i $model_path -m $mask/NS_Left_Insula.nii.gz)
	Right_Insula=$(fslmeants -i $model_path -m $mask/NS_Right_Insula.nii.gz)
	Left_PPC=$(fslmeants -i $model_path -m $mask/NS_Left_PPC.nii.gz)
	Right_PPC=$(fslmeants -i $model_path -m $mask/NS_Right_PPC.nii.gz)
	vmPFC=$(fslmeants -i $model_path -m $mask/NS_vmPFC.nii.gz)
	ACC=$(fslmeants -i $model_path -m $mask/NS_ACC.nii.gz)



	echo "	Done!"
	echo -e "$subj\t$Left_VS\t$Right_VS\t$Left_Amygdala\t$Right_Amygdala\t$Left_dlPFC\t$Right_dlPFC\t$Left_OFC\t$Right_OFC\t$Left_Insula\t$Right_Insula\t$Left_PPC\t$Right_PPC\t$vmPFC\t$ACC" >> $output
	echo
#	done
done

echo
echo "**Complete paths of mean intensity values creates can be found in:**"
echo "	$output "




