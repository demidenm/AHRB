This folder contains scripts and information used to create mean signal intensities for specified regions of interest. Certain folders missing (e.g., point and spheres) and need to be incorporated into the script or created manually scripts to work. For these to operate, please update reflecting your folder/file structure

################
### Scripts ####
################
1. Create_MNI_masks.sh
	To run the command, run ./Create_MNI_masks.sh <mni_list.csv> <vox_list_out.csv>
	This script utilizes a function that converts MNI coordinates into voxel space that are required in subsequent steps using fslmaths. The convertion is based on forum guidelines in FSL Archives (https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=FSL;ac19295e.0710). In order for this script to work file has to be specified that contains 4 colums: ROI_label, x, y, z. The sphere name is pulled from column 1, and coordinates (x-z) from 2-4, respectively. NOTABLY, in certain events, if the MNI list is generated outside of linux, this file may not be compatible with the calculation, an error that is seen by z-coordinate missing. To circumvent this error run $do2unix <filename.csv> on your file containing MNI coordinates.
	Subsequent steps use fslmaths to create a point for ROI_label using x, y, z, voxel coordinates. Then, creating a kernel sphere using a specified radii, e.g., 5mm radii = 10 mm diameter. This sphere is then binarized (E.g., all voxels in sphere = 1). More information about steps are described in Andrew Jahn fMRI fMRI tutorial #9 (https://andysbrainbook.readthedocs.io/en/latest/fMRI_Short_Course/fMRI_09_ROIAnalysis.html)

2. Calc_MEANroi.sh 
	Once the MNI masks are created, the Calc_MEANroi.sh script is used to calculate the mean signal in specified masks and feat output file. To run script, ./Calc_MEANroi.sh <subj_list.txt>. This will loop through and create mean signal intensity values within masks for a specified zstat.nii and export it into .csv file, for each subject and ROI. The script uses fslmeanths with an input file (-i) [model_path zstat] and mask (-m) ROI_mask.nii


################
### Folders ####
################

1. Files -
	Contains an example of MNI/vox coordinate in/out structure. Review files contains coordinates from review of several studies, and neursynth are peak coordinates off of neursynth. 

2. roi.zip - 
	roi.zip (compressed using $zip -r roi.zip roi) roi contains a list of ROI's from studies and Neurosynth used in compibation of steps in papers (to unzip on linux machine download and $unzip roi.zip)
