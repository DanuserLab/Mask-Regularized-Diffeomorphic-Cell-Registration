function [cellTransformed] = sumImageVolumes(cellImages,cellDeformationFields)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cellTransformed = cell(size(cellImages));
[matMCoordBase,matNCoordBase] = meshgrid(1:size(cellImages{1},2),1:size(cellImages{1},1));


for i = 1:length(cellImages)

    matMCoord = cellDeformationFields{i,1} + matMCoordBase;
    matNCoord = cellDeformationFields{i,2} + matNCoordBase;
    matMoving = cellImages{i};
    
    
    for j = 1:numel(matMoving)
        
    end
% cellTransformed{i} = interp2(double(cellImages{i}),matMCoordBase+...
%     cellDeformationFields{i,1},matNCoordBase+cellDeformationFields{i,2},'nearest');

end

end

