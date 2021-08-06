#!/usr/bin/env bash
# Script Author: Rajpreet Chahal
# Script Date: 08/05/2021
# Script Description: This script uses FSL and nilearn tools to 1) register the postprocessed resting-state data (from PostProcess_Raj.bash) to MNI 2mm space and 2) apply Seitzman et al., (2018) parcellation and time series extraction + correlation matrix computations, and finally 3) compute measures for within-network and between-network connectivity


set -xe

scriptdir=$(cd $(dirname $0);pwd)

subjdate=$1
[ -z "$subjdate" ] && echo "Please indicate subject ID to process (e.g., sub-003)" && exit 1

timepoint=$2
[ -z "$timepoint" ] && echo "Please indicate timepoint to start (e.g., T1)!" && exit 1

version=$3
[ -z "$version" ] && echo "Please indicate fmriprep version (e.g., 20.2.1)!" && exit 1

# Where to find the preprocessed data
restdir=/Volumes/iang/ELS_BIDS/ELS-"$timepoint"/derivatives/fmriprep-"$version"/fmriprep/"$subjdate"/ses-"$timepoint"/func

#Where to land the data when done (Don't junk up SherlOak
findir="$scriptdir"/seitzman/"$subjdate"_"$timepoint"
#[[-d $findir ]] ||  mkdir "$scriptdir"/"$subjdate"_"$timepoint"

mkdir -p "$scriptdir"/seitzman/"$subjdate"_"$timepoint"

echo "Beginning transformation+parcellation+matrix extraction on "$subjdate""

cd $restdir

rest="$subjdate"_rest_postprocessed_"$timepoint".nii.gz
mni="$scriptdir"/MNI152_T1_2mm_brain.nii.gz

#Delete files from the last run:
rm -f "$findir"/*_seitzman_timeseries.csv
rm -f "$findir"/*_seitzman_corrmat.csv
rm -f "$findir"/*_in_mni.nii.gz
rm -f "$restdir"/rest_postproc_mni.nii.gz

echo "Transforming "$subjdate" postprocessed rest to MNI space"
# Transform postprocessed file to MNI space
flirt -in $mni -ref $rest -omat mni2rest.mat
convert_xfm -omat rest2mni.mat -inverse mni2rest.mat
flirt -in $rest -ref $mni -applyxfm -init rest2mni.mat -out rest_postproc_mni.nii.gz

#Entering Python to use nilearn and run parcellation+timeseries extraction+correlation matrix extraction
# Copy the python script to run here
cp "$scriptdir"/seitzman_extract_raj.py "$restdir"/

echo "Running script to extract timeseries and connectivity matrix using Seitzman ROIs for "$subjdate"" 
python seitzman_extract_raj.py

echo "Cleaning up files"
mv seitzman_connectivity_matrix.csv "$subjdate"_"$timepoint"_seitzman_connectivity_matrix.csv
mv seitzman_timeseries.csv "$subjdate"_"$timepoint"_seitzman_timeseries.csv
mv "$subjdate"_"$timepoint"_seitzman_connectivity_matrix.csv "$findir"/
mv "$subjdate"_"$timepoint"_seitzman_timeseries.csv "$findir"/
rm "$restdir"/seitzman_extract_raj.py
rm "$restdir"/mni2rest.mat
rm "$restdir"/rest2mni.mat
cd $findir

echo "Using connectivity matrices to calculate within- and between-network connectivity values for "$subjdate""
#Now use matrices to calculate within- and between-network correlations
cp "$subjdate"_"$timepoint"_seitzman_connectivity_matrix.csv matrix.csv
Rscript $scriptdir/Calculate_Network_Conn_Raj.R

#The outputted file from Rscript should become a .txt file with subject name appended
echo "$subjdate" >SubID.txt
echo "$timepoint" >timepoint.txt
paste SubID.txt timepoint.txt Conn_Values.txt > "$subjdate"_"$timepoint"_connvals.txt

echo "Done with "$subjdate"; Don't forget to cat all subject files once done by navigating to "$scriptdir"/seitzman/ and using command cat sub-*/sub*_connvals.txt > All_Conn_Vals.txt"























