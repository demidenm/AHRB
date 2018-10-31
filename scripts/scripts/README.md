# AROMAexample
Shell scripts and example files to run FSL's ICA-AROMA motion denoising tool

File description of everything in AROMA directory:
1. AROMA.sh --> Shell script to easily run AROMA from the command line
2. Denoise.sh --> Use to create an unsmoothed version of the AROMA file (use if running MethodsCore CONNTool)
3. Evaluation_AROMA_Pruim_et_al.pdf --> Paper describing how AROMA works
4. ICA_AROMA.py --> Does the actual work. Shell script points to this python script
5. ICA_AROMA_functions.py --> The name says it all.
6. OfficialAROMAManual.pdf --> FSL's manual for running AROMA. Look here if you need more info than my protocol.
7. SaigesAROMAProtocol.txt --> Brief example of how I run AROMA
8. batch_AROMA.sh --> Shell script to run AROMA in parallel
9. example_file_list_to_use_for_batch_AROMA_script.txt --> Recreate this file list to match your subject's data
10. example_file_list_to_use_for_Denoise_script.txt --> Recreate this file list to match your subject's data
11. All *.nii.gz files --> brain masks