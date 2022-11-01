# Mask-Regularized-Diffeomorphic-Cell-Registration

This is code used in ***Fine-grained, Nonlinear Image Registration of Live Cell Movies Reveals Spatiotemporal Organization of Diffuse Molecular Processes*** by Xuexia Jiang, Tadamoto Isogai, Joseph Chi, and Gaudenz Danuser. (bioRxiv preprint can be found [here](https://www.biorxiv.org/content/10.1101/2021.11.22.469497v1) – manuscript is accepted and link of the publication will be updated.)

Example data is provided [here](https://cloud.biohpc.swmed.edu/index.php/s/kQqJSdXNyCmqEdC/download).

[RegisterCell](https://github.com/DanuserLab/Mask-Regularized-Diffeomorphic-Cell-Registration/blob/master/RegisterCell.m) is the MATLAB script to run the [code](https://github.com/DanuserLab/Mask-Regularized-Diffeomorphic-Cell-Registration/tree/master/SupportingCode).


Script usage:
```Matlab
strFolderBase = ['/Path_of_folder_with_Example_data' filesep];
strDonor = 'Donor/20160318 Cell4 Cdc42 CFP_';
strRatio = 'Cdc42_Ratio/20160318 Cell4 Cdc42 Ratio_';
numFrames = 181;
outPath = '/Desired_out_path/out.mat';
RegisterCell(strFolderBase, strDonor, strRatio, numFrames, outPath)
```
