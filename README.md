# Resting_State

All scripts in this repository were written by Rajpreet Chahal, Ph.D., postdoc in the SNAP Lab at Stanford University. 

1) 08/05/2021 - PostProcess_Rest_All_Raj.bash: calls the PostProcess_Rest_Raj.bash and confound_mot_prep_raj.R to post-process resting-state data that was preprocessed with fMRIPrep. These files take fMRIPrep preprocessed resting-state data and conduct post-processing steps, including 1) prepping nuisance regressors and motion outliers files, 2) trimming resting-state data, and 3) using 3dTproject to conduct simultaneous bandpass (25 regressors) and nuisance regression, 2mm smoothing, and motion censoring via interpolation. To change regressors, edit the .R script. This was used on T2 data in the ELS sample in the SNAP Lab at Stanford. 

2) 08/06/2021 - Extract_Seitzman_CorrMats_All_Raj.bash: calls the Extract_Seitzman_CorrMats_Raj.bash, seitzman_extract_raj.py, and Calculate_Network_Conn_Raj.R scripts to compute network connectivity values per individual using the 300 ROIs from Seitzman et al., (2020): https://www.sciencedirect.com/science/article/pii/S105381191930881X. The script completes the following steps: 1) transform post-processed data from Step 1 to MNI 2mm space; 2) extract timeseries and correlation matrices based on Seitzman ROIs; 3) compute average network connectivity values across most of the networks included in Seitzman study. 
 
