#!/usr/bin/env bash
# Script Author: Rajpreet Chahal. Post-processing decisions made by Rajpreet Chahal and Jackie Kirshenbaum
# Script Date: Originally written on 9/25/2020 and revised on 08/05/2021
# Script Description: This script conducts postprocessing on resting-state data that were preprocessed using fMRIPrep. The timepoint and fMRIPrep version are not hard-coded, however the nuisance regressors are and are prepped using the R script: confound_mot_prep_raj.R. If you want to edit the regressors, create a new version of the R script and change code in here.

# This script completes the following steps: 
# Prepare confound regressors file which includes the following
# WM (mean, deriv, power2, and deriv_power2 = 4)
# CSF (mean, deriv, power2, and deriv_power2 = 4)
# Trans (x,y,z = 3)
# Rot (x,y,z, =3)
# Trans deriv (=3)
# Rot deriv (=3)
# Trans power 2 (=3)
# Rot power 2 (=3)
# Trans deriv_power2 (=3)
# Rot deriv_power2 (=3)
# == 32 total regressors 

# 2) Prepare motion outliers file: Use 1dcat to select the column of volumes that were motion outliers (>5.mm) from confound_regressors.tsv file. The column index is 132 (motion_outlier00 = FD spikes). However, this file is in format 0=fine, 1=outlier. This script (by calling the R script) switches to 0=exclude, 1=keep for 3dTproject.

# Both the regressors and motion confound files trim the first 6 TRs. We then trim the first 6 TRs in the preprocessed rest data.

# 3) Run 3dTproject on the data to complete simultaneous nuisance regression + bandpass + motion censoring (interpolation) with 2mm smoothing and bandpass filtering of .008-.10 (like ABCD rest). For more information, see the 3dTproject page here: https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/programs/3dTproject_sphx.html and the ABCD rest paper here (see supplement for info about the preprocessing of rest data): https://www.biorxiv.org/content/10.1101/2020.08.21.257758v1.full.pdf


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

echo "Beginning post-processing on "$subjdate""

cd $restdir

rest="$subjdate"_ses-*_task-rest_space-*_res-2_desc-preproc_bold.nii.gz
mask="$subjdate"_ses-*_task-rest_space-*_res-2_desc-brain_mask.nii.gz
confound="$subjdate"_ses-*_task-rest_desc-confounds_timeseries.tsv

#Delete files from the last run:
rm -f rest_regressors.tsv
rm -f rest_regressors.1D
rm -f rest_motion_out.tsv
rm -f rest_motion_out_afni_final.tsv
rm -f rest_motion_out_afni.tsv
rm -f rest_motion_out.1D
rm -f *postprocess*
rm -f *postproces*
rm -f *preprocessed_trim*

# Prepare confound file
#This output file has first 6 TRs removed

echo "Preparing nuisance regressors and motion outlier files for "$subjdate""

cp $confound r_rest_confounds.tsv

Rscript $scriptdir/confound_mot_prep_raj.R

cp rest_regressors.tsv rest_regressors.1D

# Prepare motion outliers file
#This output file also has first 6 TRs removed

sed 's/0/keep/g;s/1/drop/g' rest_motion_out.tsv > rest_motion_out_afni.tsv

sed 's/keep/1/g;s/drop/0/g' rest_motion_out_afni.tsv > rest_motion_out_afni_final.tsv

1dcat rest_motion_out_afni_final.tsv > rest_motion_out.1D


echo "Trimming the rest data for "$subjdate""
#Trim the rest data 
fslroi $rest "$subjdate"_rest_preprocessed_trim.nii.gz 6 180

echo "Running 3dTProject post-processing on "$subjdate""

#New version of command (August 2021) that matches Jackie's version
3dTproject -input "$subjdate"_rest_preprocessed_trim.nii.gz -prefix "$subjdate"_rest_postprocessed_$timepoint.nii.gz -polort 0 -censor rest_motion_out.1D -cenmode NTRP -ort rest_regressors.1D -bandpass .008 .10 -blur 2 -mask $mask -verb

echo "Done post-processing "$subjdate""

