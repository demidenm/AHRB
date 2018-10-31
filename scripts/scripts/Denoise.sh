#!/bin/bash

FILE=`basename ${1}`
DIR=`dirname ${1}`

SUB=$(echo ${1} | awk -F/ '{print $6 }')
AROMA=/nfs/turbo/ahrb-data/AROMA/output


cd ${DIR}
export FSLOUTPUTTYPE=NIFTI
echo "denoise ${SUB}"

# file is the unsmooth data
# melodic_mix, update location of where aroma produces this output
# classified motion IC, the estimations that are regressed out that aroma produces
# out == output file name and directory

fsl_regfilt --in=${FILE} --design=${AROMA}/dpk16ahr200433_04570/ICA_AROMA/melodic.ica/melodic_mix --filter="`cat ${AROMA}/${SUB}/ICA_AROMA/classified_motion_ICs.txt`" --out=${AROMA}/${SUB}/ICA_AROMA/unsmoothed_denoised_func_data_nonaggr.nii

echo "Denoise complete for ${SUB}"
