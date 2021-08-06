# Script Author: Rajpreet Chahal
# Script Date: 08/05/2021
# Script Description: This script conducts Seitzman et al., (2018) 300 ROI timeseries extraction and connectivity matrix creation

import nilearn
from nilearn import datasets
import numpy as np
from nilearn import input_data
from nilearn import image
from nilearn.connectome import ConnectivityMeasure
import numpy as np
from nilearn import plotting
from numpy import savetxt
import pandas as pd

#Prepare atlas

seitzman = datasets.fetch_coords_seitzman_2018()

print('Seitzman atlas comes with {0}.'.format(seitzman.keys()))

coords = np.vstack((seitzman.rois['x'], seitzman.rois['y'], seitzman.rois['z'])).T

spheres_masker = input_data.NiftiSpheresMasker(seeds=coords, smoothing_fwhm=0, radius=5., detrend=True, standardize=True, low_pass=0.1, high_pass=0.008, t_r=2, allow_overlap=True)

datz=nilearn.image.load_img("rest_postproc_mni.nii.gz", wildcards=False, dtype =None)

timeseries = spheres_masker.fit_transform(datz)

correlation_measure = ConnectivityMeasure(kind='correlation')

correlation_matrix = correlation_measure.fit_transform([timeseries])[0]

np.fill_diagonal(correlation_matrix, 0)

pd.DataFrame(correlation_matrix).to_csv("seitzman_connectivity_matrix.csv")

pd.DataFrame(timeseries).to_csv("seitzman_timeseries.csv")

exit()
