#!/bin/bash

FILE=${1}
MAXPROCS=${2}
if [ "x$MAXPROCS" == "x" ]; then
    MAXPROCS=1
fi

#parallel implementation
cat ${FILE} | xargs -n 1 -P ${MAXPROCS} -I sub /nfs/turbo/ahrb-data/AROMA/scripts/AROMA.sh /nfs/turbo/ahrb-data/work_dir/sub/func/resting/run_01/s5w2.4uprun_01.nii
