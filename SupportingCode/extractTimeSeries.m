function [ cellTimeSeries,vecLabels,cellMovie ] = extractTimeSeries( cellMovie_ini )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

intTimeSeriesLength = size(cellMovie_ini,1);

%set downsampling
numDS = 0.25;
cellMovie = cell(length(cellMovie_ini),1);
for k = 1:intTimeSeriesLength
    cellMovie{k} = imresize(cellMovie_ini{k},numDS);   
end

intNumDataPoints = numel(cellMovie{1});


%initialize output storage matricies
cellTimeSeries = {};
vecLabels = [];

counter = 1;
for i = 1:intNumDataPoints
    i
    temp_vecTimeSeries = NaN(intTimeSeriesLength,1);
    for j = 1:intTimeSeriesLength
        temp_vecTimeSeries(j) = cellMovie{j}(i);
    end
   
    if nnz(temp_vecTimeSeries) > 0.8*intTimeSeriesLength
        cellTimeSeries{counter} = temp_vecTimeSeries;
        vecLabels(counter) = i;
        counter = counter + 1;
    end
end
end

