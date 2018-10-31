#!/bin/bash

# Adding the run-aroma.sh command to the path
source /etc/profile.d/aroma.sh


DIR=`dirname ${1}`
FILE=`basename ${1}`
SUB=$(echo ${1} | awk -F/ '{print $6 }')
OUTDIR=/nfs/turbo/ahrb-data/AROMA/output/${SUB}
date=$(date '+%Y_%m_%d')

echo "Starting AROMA on ${SUB}....."

	if [ -d $OUTDIR/${SUB}/log/ ] ; then 
		echo "log output dir exists for ${SUB}, continuing..."
		else
		mkdir -p $OUTDIR/log
	fi

run-aroma.sh \
-in ${DIR}/${FILE} \
-out ${OUTDIR}/ICA_AROMA \
-mc ${DIR}/rp*.txt \
-m /nfs/turbo/ahrb-data/AROMA/scripts/rs_spm12_mni_mask.nii \
-tr .8 \
-overwrite


