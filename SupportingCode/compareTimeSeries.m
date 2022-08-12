function [matMaxLag,matXVal,vecLabels2] = compareTimeSeries(cellTimeSeries,vecLabels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

matMaxLag = NaN(length(1:50:length(cellTimeSeries)),length(cellTimeSeries));
matXVal = NaN(length(1:50:length(cellTimeSeries)),length(cellTimeSeries));
vecLabels2 = zeros(length(1:50:length(cellTimeSeries)),1);

counter = 1;
for i = 1:50:length(cellTimeSeries)
    i
    vecLabels2(counter) = vecLabels(i);
    for j = 1:length(cellTimeSeries)
        TS1 = diff(cellTimeSeries{i});
        TS2 = diff(cellTimeSeries{j});
        
        [xcf,lags,bounds] = crosscorr(TS1,TS2);
        abs_xcf = xcf;%abs(xcf);
        if max(abs_xcf > bounds(1))
            matMaxLag(counter,j) = lags(abs_xcf == max(abs_xcf));
            matXVal(counter,j) = xcf(abs_xcf == max(abs_xcf));
        end
    end 
    counter = counter + 1;
end

end

