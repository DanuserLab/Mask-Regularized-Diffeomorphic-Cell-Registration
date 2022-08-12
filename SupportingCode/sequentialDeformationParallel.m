function [cellDeformedMovieFrames,cellDeformationFields] = sequentialDeformationParallel(cellReferenceFrames,cellMovieFrames,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% read inputs and settings
ip = inputParser;
ip.CaseSensitive = false;

% metaparameters
ip.addParameter('SetTarget',floor(length(cellReferenceFrames)/2))

% parameters for registration function
ip.addParameter('SetFrameStep',1);%time step size from start to end
ip.addParameter('SetIterations',200);%number of iterations to fit per step
ip.addParameter('SetAlpha',2);%the maximum step size is 1/(alpha*2) (0.7)
ip.addParameter('SetLocality',1);%spatial smoothening standard deviation
ip.addParameter('FlagDiagonalCorrection',1);

ip.parse(varargin{:});
%% storage variables
cellDeformedMovieFrames = cell(length(cellReferenceFrames),1);
cellDeformationFields = cell(length(cellReferenceFrames),2);
%% loop through all frames of movie in parallel[cellDeformedMovieFrames,cellDeformationFields] = sequentialDeformationParallel(cellReferenceFrames,cellMovieFrames);

idxTarget = ip.Results.SetTarget;
parfor i = 1:length(cellReferenceFrames) 
    i
    [matDX,matDY] = registerSequence2D(cellReferenceFrames,i,idxTarget,ip);
    matRegistered = deformMovieFrame(cellMovieFrames{i},matDX,matDY);
    
    cellDeformationFields(i,:) = {matDX, matDY};
    cellDeformedMovieFrames(i) = {matRegistered};
end
%% shutdown parpool
delete(gcp('nocreate'))
end

function matRegistered = deformMovieFrame(matMovieFrame,matDX,matDY)
[matMCoordBase,matNCoordBase]=meshgrid(1:size(matDX,2),1:size(matDY,1));
matRegistered = interp2(matMovieFrame,matDX+matMCoordBase,matDY+matNCoordBase,'nearest');
end

