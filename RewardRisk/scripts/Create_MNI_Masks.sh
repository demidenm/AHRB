#!/bin/bash

# 		[This script was created by Michael Demidenko © 2019]
#	### The script is intended to be used with  FSL standard 2mm MNI brain  ###

#				####    Step 1   ####
# 	This script pulls MNI coordinates provided from .csv input file (field $1) and converts those coordinates into voxel coordinates. The voxel coordinate space calculations are verified using multiple online calculations from matlab and bash codes. To confirm their accuracy, MNI to Voxel coordinate convertion were tested and validated using FSLEYES. 

#						**Caveat**
# Under certain conditions, the voxel coordinate output will deviate by 0.5-1.0, as some conversions from MNI to voxel coordinates will deviate by a fraction. Since FSLEYES rounds, this may appear as a mismatch. However, for the bulk of the MNI <--> vox coordinate values, there is a 1-to-1 match between the script output and the information in fsleyes when viewing a point on an MNI standard 2mm brain


# 				#### Step 2 - 4 ####
# Once MNI coordinates are converted into voxel coordinates, they are saved into a file. Subsequently, there are using in a multi-step process to create ROI's. The steps used in this script are from Andrew Jahn [Blog post: May 2, 2017 -- https://www.andysbrainblog.com/andysbrainblog/2017/5/2/fmri-lab-roi-analysis-in-fsl ]

# Radius size used is 5, e.g., diameter of 10mm


#Step up file information
project=/nfs/turbo/ahrb-data

mnilist=$1
voxfile=$2
outdir=$project/Demidenko/HighLowRisk_Analyses/scripts
radius=5



echo "This script requires input of MNI coordinate list and a voxel coordinate output."
echo "		./CreateMNI_Masks.sh <MNI .csv> <vox coord .csv>"
echo "The MNI coordinate list should be a .csv file, with no headers, separated by commas."
echo "The MNI coordinate .csv should contain items in the following order:"
echo "	Column 1 = ROI name"
echo "	Column 2 = MNI x coordinate"
echo "	Column 3 = MNI y coordinate"
echo "	Column 4 = MNI z coordinate"
echo "	e.g., if you gedit <filename.csv>, it should appear as ROI,12,12,12"
echo "	You will need to edit modify the $outdir in the script"
echo "If your .csv file is not in that format, you will experience errors"
echo "Before you begin, to avoid a standard_in error, run the following on your .csv mni file:"
echo "		dos2unix <filename.csv>"
echo
sleep 2

echo

#confirm script is ready to proceed
echo -n "Do your files conform to the above in order to proceed? [yes = y; no = n] "
	read proceed
	# take the answer provided, cut to take only the first letter, upper and lowercase        
	answer=$(echo $proceed | cut -c 1 | tr '[A-Z]' '[a-z]')

		case $proceed in
		'y')
			echo
			echo "Beginning Script....."
			echo
		;;
		'e')
			echo                        
			echo "....Quitting"
                        exit 1
		;;
		esac


# Check in subdirectories exist in the output directory for points and spheres output
	[ -d $outdir/points ] || mkdir $outdir/points
	[ -d $outdir/spheres ] || mkdir $outdir/spheres


echo -e "ROI\tX\tY\tZ" > $voxfile

# Do not edit below this line
for list in $(cat $mnilist ) ; do
echo "### Starting next ROI ###"
echo "Step 1: MNI [${list}] coord to Voxel Coord."

		roi=$(echo $list | awk -F, '{ print $1}')
		#radius=$(echo $list | awk -F, '{ print $4 }')
		mni_x=$(echo $list | awk -F, '{ print $2 }')
		mni_y=$(echo $list | awk -F, '{ print $3 }')
		mni_z=$(echo $list | awk -F, '{ print $4 }')

		vox_x=$(echo "(${mni_x}/2) * -1 + 45" | bc)
		vox_y=$(echo "(${mni_y}/2) + 63" | bc )
		vox_z=$(echo "(${mni_z}/2) + 36" | bc )
		echo "...converted"
		echo "[MNI]: x=$mni_x y=$mni_y z=$mni_z ~~> [VOXEL] x=$vox_x y=$vox_y z=$vox_z"
		echo -e "${roi}\t${vox_x}\t${vox_y}\t${vox_z}" >> $voxfile

# Using fslmaths to create point for x,y,z coordinates in file provided. 
#	'-mul' multiplies MNI image by current value (0). 
#	'-add' adds a 1 to each voxel in that -mul image. 
#	'-odt' is output data type, which is default 'nii.gz'.

	echo "Step 2: Creating point for $roi (x=${vox_x},y=${vox_y},z=${vox_z})"
	
	fslmaths $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz -mul 0 -add 1 -roi $vox_x 1 $vox_y 1 $vox_z 1 0 1 ${outdir}/points/${roi}_point -odt float

	echo "	...done"

# Using fslmaths to create a sphere around the point created in step 2 (sphere 5 = 10 diameter)
#	'-kernel sphere <size>' voxels in a sphere of radius centered on target voxel
#	'-fmean' Mean filtering, kernel weighted (conventionally used with gauss kernel)
#	'-odt' is output data type, which is default 'nii.gz'

	echo "Step 3: Creating ROI sphere for: ${roi}_point"
	fslmaths ${outdir}/points/${roi}_point.nii.gz -kernel sphere $radius -fmean ${outdir}/spheres/${roi}_sphere.nii.gz -odt float

	echo "	...done"

# Using fslmaths to binarize the mask (e.g., assign a 1 to all voxels inside the mask, and 0 to those outside of the mask

	echo "Step 4: Creating final, binarized mask for: ${roi}_sphere"
	fslmaths ${outdir}/spheres/${roi}_sphere.nii.gz -bin $outdir/roi/${roi}.nii.gz
	echo "	...done"
	echo
done

	


