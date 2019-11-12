This folder contains contents of the non-parameteric whole brain analysis. The whole sample (104) is contained within the Permu_BW_zstat1 folder and the subsample (71) is contained within the sub_sample folder. The below commands were used for the Wave1 high vs avg risk comparision and the multi-wave stable high and stable average risk comparisions. For moredetails about using randomise command, see: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Randomise


#############
### STEPS ###
#############
1. Creating zstat1.nii.gz file from Second Level output from Feat for Anticipation Big Win > Neutral constrat. 
	Using a for loop, zstat1 files are copied and saved from second level .gfeat and saved in the specific folders (e.g. BWin_zstat)

	>>>	for subj in $(ls $dir ) ; do
		cp $dir/$subj/model/SecondLevel/second.gfeat/cope1.feat/stats/zstat1.nii.gz ./${subj}_zstat1.nii.gz
		done

	zstat files are merged using fslmerge to create a single file for randomise (e.g. BWin_104_zstat1.nii.gz)

	>>>	fslmerge -t <output_file.nii.gz> <subject*.nii.gz>


	In conjunction with .con, .mat and .grp files and mask created from Feat GUI for a group level analysis, run above 4D volume with randomise

	>>>	randomise -i {4D volume} -o {Permute_5k_{cond} -d design.mat -t design.con -n 5000 -m mask -T

 
	Output file *_tfce_coorp_tstat is the FWE-Corrected P threshold free cluster enhancement file. When opening in fsleyes, range is 0 - 1, set min to .95, everything above is p < .05 significance.

	Thus, if thresholdhing the output images at .99, that will be a significance level of < .01

	To pull significant (p < .05) clusters:
	>>> cluster --in=BWzstat1_104_5k_tfce_corrp_tstat2.nii.gz --thresh=.95
