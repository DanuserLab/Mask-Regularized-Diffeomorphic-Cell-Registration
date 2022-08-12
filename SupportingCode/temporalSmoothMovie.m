function [ cellSmoothedMovie ] = temporalSmoothMovie( cellMovieFrames,intSmoothingMag,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
ip = inputParser;
ip.CaseSensitive = false;
ip.addRequired('cellMovieFrames');
ip.addRequired('intSmoothingMag');
ip.addParameter('SetSmoothingMethod','Median');
ip.addParameter('SetDownsamplingFactor',1);
ip.parse(cellMovieFrames,intSmoothingMag,varargin{:});

cellSmoothedMovie = cell(size(cellMovieFrames));
%loop through all frames in movie
for i = 1:size(cellMovieFrames,1)
    
    temp_matNeighborFrames = NaN(size(cellMovieFrames{i},1),size(cellMovieFrames{i},2));
    counter = 1;
    for j = -intSmoothingMag:1:intSmoothingMag
        try
            temp_matNeighborFrames(:,:,counter) = cellMovieFrames{i+j};
        end
        counter = counter + 1;
    end
    temp_matNeighborFrames(temp_matNeighborFrames <= 0) = NaN;

    if strcmp(ip.Results.SetSmoothingMethod,'Median')
        matTimeAveraged = nanmedian(temp_matNeighborFrames,3);
        matNanFilledTimeAveraged = fillmissing(matTimeAveraged,'movmedian',2*intSmoothingMag + 1);
        cellSmoothedMovie{i} = imresize(matNanFilledTimeAveraged,ip.Results.SetDownsamplingFactor,'bilinear');
    elseif strcmp(ip.Results.SetSmoothingMethod,'Mean')
        matTimeAveraged = nanmean(temp_matNeighborFrames,3);
        matNanFilledTimeAveraged = fillmissing(matTimeAveraged,'movmean',2*intSmoothingMag + 1);
        cellSmoothedMovie{i} = imresize(matNanFilledTimeAveraged,ip.Results.SetDownsamplingFactor,'bilinear');
    end
end
end

