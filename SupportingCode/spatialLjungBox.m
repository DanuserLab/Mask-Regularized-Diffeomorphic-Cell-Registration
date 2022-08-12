function [ matRandomSeries, matSeriesPVals, matNonNanSeries, cellTimeSeries ] = spatialLjungBox( cellSmoothedMovie )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

intTimeSeriesLength = size(cellSmoothedMovie,1);
intNumDataPoints = numel(cellSmoothedMovie{1});
%initialize output storage matricies
matRandomSeries = NaN(size(cellSmoothedMovie{1}));
matSeriesPVals = NaN(size(cellSmoothedMovie{1}));
matNonNanSeries = zeros(size(cellSmoothedMovie{1}));
cellTimeSeries = cell(size(cellSmoothedMovie{1}));

for i = 1:intNumDataPoints
    temp_vecTimeSeries = NaN(intTimeSeriesLength,1);
    for j = 1:intTimeSeriesLength
        temp_vecTimeSeries(j) = cellSmoothedMovie{j}(i);
    end
    
    cellTimeSeries{i} = temp_vecTimeSeries;
    %test if time series is mostly NaNs
    temp_intNumNans = sum(isnan(temp_vecTimeSeries));
    if temp_intNumNans < 0.1*intTimeSeriesLength
        temp_residuals = temp_vecTimeSeries - nanmean(temp_vecTimeSeries);
        [h,pValue] = lbqtest(temp_residuals);
        
        matRandomSeries(i) = h;
        matSeriesPVals(i) = pValue;
        matNonNanSeries(i) = 1;
    end
end
end

