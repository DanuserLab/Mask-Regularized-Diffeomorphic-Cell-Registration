function saveMovieCellAsTiff( cellMovie,strPlotOutputFolderPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(cellMovie)
    tempFrame = cellMovie{i};
    tempFrame(isnan(tempFrame)) = 0;
    tempFrame = uint16(tempFrame);
    cellMovie{i} = tempFrame;
end

 for k = 1:length(cellMovie)
     imwrite(cellMovie{k},[strPlotOutputFolderPath,'\','out.tif'],'WriteMode','append');
 end
end

