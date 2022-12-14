function [cellReferenceFramesSegmented,cellMovieFramesSegmented] = segmentMovies(cellReferenceFrames,cellMovieFrames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
intThreshold = 109;

cellReferenceFramesSegmented = cell(length(cellReferenceFrames),1);
cellMovieFramesSegmented = cell(length(cellReferenceFrames),1);

for i = 1:length(cellReferenceFrames)
    i
    temp_matMask = imgaussfilt(cellMovieFrames{i}) > intThreshold;
    temp_matMask = imfill(temp_matMask,'holes');
    
    sctRegStat = regionprops(temp_matMask == 1,'Area','PixelIdxList'); 
    matAreas = [sctRegStat.Area];
    [~,vecIdxAreaSizes] = sort(matAreas,'descend');

    vecCellPixels = sctRegStat(vecIdxAreaSizes(1)).PixelIdxList;
    temp_matMask = temp_matMask.*0;
    temp_matMask(vecCellPixels) = 1;
    
    cellReferenceFramesSegmented{i} = cellReferenceFrames{i}.*temp_matMask;
    cellMovieFramesSegmented{i} = cellMovieFrames{i}.*temp_matMask;
end

end

