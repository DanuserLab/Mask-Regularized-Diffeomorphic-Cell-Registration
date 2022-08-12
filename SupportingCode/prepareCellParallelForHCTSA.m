function prepareCellParallelForHCTSA(cellTimeSeries,matNonNanSeries,strOutputFolderPath,varargin)
%prepareCellForHCTSA saves an INP.mat file for intitializing HCTSA analysis
%with default set of operations
%   Detailed explanation goes here

ip = inputParser;
ip.CaseSensitive = false;
ip.addRequired('cellTimeSeries');
ip.addRequired('matNonNanSeries');
ip.addRequired('strOutputFolderPath');
ip.addParameter('SpecifyKeyword','Jaewon_cdc42_toTarget');
ip.addParameter('SpecifyFileOutName','testINP');
ip.addParameter('MaxTimeSeriesPerFile',500);
ip.parse(cellTimeSeries,matNonNanSeries,strOutputFolderPath,varargin{:});

%intitialize storage matricies
timeSeriesData = cell(ip.Results.MaxTimeSeriesPerFile,1);
labels = cell(ip.Results.MaxTimeSeriesPerFile,1);
keywords = cell(ip.Results.MaxTimeSeriesPerFile,1);

%filter out cell time series and store in format for HCTSA package
vecCellIndicies = find(matNonNanSeries == 1);
counter = 1;
counter2 = 0;
%loop through all mapped movie pixels
for i = vecCellIndicies'
    timeSeriesData{counter} = cellTimeSeries{i};
    labels{counter} = int2str(i);
    keywords{counter} = ip.Results.SpecifyKeyword;
    
    counter = counter + 1;
    
    if counter == ip.Results.MaxTimeSeriesPerFile + 1 ...
            || i == vecCellIndicies(end)
        
        counter = 1;%reset counter
        counter2 = counter2 + 1;
        
        %clear empty rows for the last file
        timeSeriesData = timeSeriesData(~cellfun('isempty',timeSeriesData));
        labels = labels(~cellfun('isempty',labels));
        keywords = keywords(~cellfun('isempty',keywords));
        
        %save the INP.mat file
        save([strOutputFolderPath,'/',ip.Results.SpecifyFileOutName,...
            int2str(counter2),'.mat'],'timeSeriesData','labels',...
            'keywords');
        
        %reinitialize storage matricies
        timeSeriesData = cell(ip.Results.MaxTimeSeriesPerFile,1);
        labels = cell(ip.Results.MaxTimeSeriesPerFile,1);
        keywords = cell(ip.Results.MaxTimeSeriesPerFile,1);
    end
end
end

