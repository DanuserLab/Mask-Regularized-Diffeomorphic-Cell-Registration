function [ cellDeformationFields ] = fitDeformationFieldParallel( cellReferenceFrames,varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% read inputs and settings
ip = inputParser;
ip.CaseSensitive = false;
ip.addRequired('cellReferenceFrames')
ip.addParameter('SetRegistrationIterations',1000)
ip.addParameter('SetTarget',floor(length(cellReferenceFrames)/2))
ip.addParameter('SetStepSize',100)
ip.addParameter('SetAlpha',1)
ip.addParameter('SetWorkerNumber',2)
ip.parse(cellReferenceFrames,varargin{:});

%% initialize storage variables for deformation fields
cellDeformationFields = cell(length(cellReferenceFrames),2);

%% set keyframes based on step size
vecKeyFramesFwd = wrev(ip.Results.SetTarget:-ip.Results.SetStepSize:1);
vecKeyFramesRev = wrev(ip.Results.SetTarget:ip.Results.SetStepSize:length(cellReferenceFrames));

%% determine coordinate bases
[matMCoordBase,matNCoordBase] = meshgrid(1:size(cellReferenceFrames{1},2),1:size(cellReferenceFrames{1},1));

%% initialize parallel pool
parpool(ip.Results.SetWorkerNumber);
parfor i = 1:ip.Results.SetTarget
%for i = 1:ip.Results.SetTarget
    matMovingFrame = cellReferenceFrames{i};
    
    matDX = zeros(size(matMovingFrame));
    matDY = zeros(size(matMovingFrame));
    for j = vecKeyFramesFwd
        if i < j
            [matMovingFrame,matDX,matDY] = register2Imgs2D(matMovingFrame,cellReferenceFrames{j},'SetIterations',ip.Results.SetRegistrationIterations,'SetInitialDX',matDX,'SetInitialDY',matDY,'SetAlpha',ip.Results.SetAlpha);
        end
    end
    
    cellDeformationFields(i,:) = {matDX + matMCoordBase, matDY + matNCoordBase};    
end

vecK = length(cellReferenceFrames):-1:(ip.Results.SetTarget+1);
temp_cellDeformationFields = cell(length(vecK),2);
parfor k = 1:length(vecK)
    matMovingFrame = cellReferenceFrames{vecK(k)};
    
    matDX = zeros(size(matMovingFrame));
    matDY = zeros(size(matMovingFrame));
    
    for l = vecKeyFramesRev
        if vecK(k) > l
            [matMovingFrame,matDX,matDY] = register2Imgs2D(matMovingFrame,cellReferenceFrames{l},'SetIterations',ip.Results.SetRegistrationIterations,'SetInitialDX',matDX,'SetInitialDY',matDY,'SetAlpha',ip.Results.SetAlpha);
        end
    end
    
    temp_cellDeformationFields(k,:) = {matDX + matMCoordBase, matDY + matNCoordBase};
end

for l = 1:length(vecK)
    cellDeformationFields(vecK(l),:) = temp_cellDeformationFields(l,:);
end
end

