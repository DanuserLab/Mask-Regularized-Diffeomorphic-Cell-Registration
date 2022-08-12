function [ cellMovieFrames ] = loadFrames( strMovieFilePath, vecFrameSelection )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
cellMovieFrames = cell(length(vecFrameSelection),1);
counter = 1;
for i = vecFrameSelection
    matTempFrame = double(imread(strMovieFilePath,i));
    cellMovieFrames{counter} = matTempFrame;
    counter = counter + 1;
end
end

