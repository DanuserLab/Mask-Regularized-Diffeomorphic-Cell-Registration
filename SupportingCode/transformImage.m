function [matT] = transformImage(matM,matDX,matDY)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[matMCoordBase,matNCoordBase] = meshgrid(1:size(matM,2),1:size(matM,1));
matT = interp2(double(matM),matMCoordBase + matDX, matNCoordBase + matDY,'linear');
matT(isnan(matT)) = 0;

end

