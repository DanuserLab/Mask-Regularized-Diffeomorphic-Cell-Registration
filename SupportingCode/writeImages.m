function writeImages(cellImages,strFolder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(cellImages)
imwrite(uint16(cellImages{i}),[strFolder,int2str(i),'.tif'])
end

end

