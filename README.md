# Mask-Regularized-Diffeomorphic-Cell-Registration

This is code used in [**Fine-grained, nonlinear registration of live cell movies reveals spatiotemporal organization of diffuse molecular processes**](https://doi.org/10.1371/journal.pcbi.1009667), *PLOS Computational Biology*, 2022, 18(12): e1009667, written by Xuexia Jiang, Tadamoto Isogai, Joseph Chi, [Gaudenz Danuser](https://www.danuserlab-utsw.org/).

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

## Danuser Lab Links
[Danuser Lab Website](https://www.danuserlab-utsw.org/)

[Software Links](https://github.com/DanuserLab/)
