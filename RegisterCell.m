%% the purpose of this script is to run a registration on a set of Fret Images using Xuexia's algorithim. 

%% inputs
%strFolderBase: path of the folder that contains the fiducial and signal folders
%strFiducial: path of the subfolder containing the fiducial images
%strSignal: path of the subfolder containing the signal images
%num Frames: int indicating the number of frames in the folder
%%%make sure that the strFiducial and strSignal are written such that when a
% when the frame number is pasted, the correct file is read. 

%Example

%strFolderBase = '/project/bioinformatics/Danuser_lab/P01biosensor/analysis/Jaewon/Dan_OrthoDataFinal/MEF/Cdc42_WT/Cell5/';
%strFiducial = 'Donor/Donor0'
%strSignal = 'Cdc42_Ratio/Ratio0';
%numFrames = 180
%outPath = '/endosome/archive/bioinformatics/

function [] = RegisterCell(strFolderBase, strFiducial, strSignal, numFrames, outPath)

addpath('/PathTo/SupportingCode');

%% set image paths
vecFrameSelection = 1:1:numFrames;

%% load and process frames
cellMasks = cell(length(vecFrameSelection),1);
cellFiducial = cell(length(vecFrameSelection),1);
cellSignal = cell(length(vecFrameSelection),1);

counter = 1;
for i = vecFrameSelection
    matFiducial = imread([strFolderBase,strFiducial,num2str(i,'%03.f'),'.tif']);
    matSignal = imread([strFolderBase,strSignal,num2str(i,'%03.f'),'.tif']);

    matMask = matFiducial > 0;
    matMask = imfill(matMask,'holes');
    
    cellMasks{counter} = matMask;
    cellFiducial{counter} = imgaussfilt(double(matFiducial),1).*matMask;
    cellSignal{counter} = double(matSignal).*matMask;
    
counter = counter + 1;
end
 
%% transform
[~,cellDeformationFields] = sequentialDeformationParallel(cellFiducial,cellSignal,'FlagDiagonalCorrection',1);

cellFiducialT = transformImages(cellFiducial,cellDeformationFields);
cellSignalT = transformImages(cellSignal,cellDeformationFields);

save(outPath) % saves all variables from the current workspace in outPath

end
