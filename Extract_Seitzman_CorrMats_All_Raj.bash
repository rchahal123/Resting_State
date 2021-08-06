#!/usr/bin/env bash

#Script Author: Rajpreet Chahal 
#Script Date: August 5, 2021
#Script Description: This script invokes the Extract_Seitzman_CorrMats_Raj.bash script per individual depending on timepoint and fmriprep version

## job control
MAXJOBS=3
sleeptime=00
function waitforjobs {
	while [ $(jobs -p | wc -l) -ge $MAXJOBS ]; do
		echo "@$MAXJOBS jobs, sleeping $sleeptime s"
		jobs | sed 's/^/\t/'
		sleep $sleeptime
	done
}

scriptdir=$(cd $(dirname $0);pwd)

timepoint=$1
[-z "$timepoint" ] && echo "I need a timepoint to start (e.g., T1, T2, T3, T4)" $$ exit 1

version=$2
[-z "$version" ] && echo "I need an fMRIPrep version to start (e.g., 20.2.1)" && exit 1

timepointdir=/Volumes/iang/ELS_BIDS/ELS-"$timepoint"/derivatives/fmriprep-"$version"/fmriprep/

## Invoke Extract_Seitzman_CorrMats_Raj.bash on each subject in this directory

for subjELSdir  in $timepointdir/sub-*/; do
	subjdate=($(basename $subjELSdir))
 $scriptdir/Extract_Seitzman_CorrMats_Raj.bash $subjdate $timepoint $version &
	waitforjobs
 done

# wait for everything to finish before saying we're done
wait

