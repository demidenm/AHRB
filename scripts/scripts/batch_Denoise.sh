#!/bin/bash

# The denoise script is uses for input in Methods Core ConnTool which creates connectivity matricies after running Independent Component Analysis (ICA)- Automatic Removal of Motion Artifacts (AROMA), or ICA-AROMA.

# Denoise requires UNSMOOTHED & NORMALIZED file to extract CSF and WM confounds from. e.g., uprun_01.nii file after normalization
	# This prevents GM getting smoothed into the CSF or WM regions (which are the confoundFile variable).

# The batch script requires a *.txt file that has the directory/file.nii list of the normalized, unsmoothed files.
	# The script will then use xargs to run in parallel $2 number of subjects (limit of processors) using the subjects in$1	

cat $1 | xargs -n 1 -P $2 -I file /nfs/turbo/ahrb-data/AROMA/scripts/Denoise.sh file
