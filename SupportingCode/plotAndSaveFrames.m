function plotAndSaveFrames( cellMovie,strPlotOutputFolderPath )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
cmap = jet;
cmap(1:1,:) = zeros(1,3);
for i = 1:size(cellMovie,1)
    matFrame = cellMovie{i};
    %matFrame = imadjust(matFrame,stretchlim(matFrame),[]);
    %matFrame(matFrame == 0) = NaN;
    imagesc(matFrame);
    colormap(cmap)
    colorbar
    %colormap gray
    axis off
    title(['Frame ',int2str(i)])
    saveas(gcf,[strPlotOutputFolderPath,'\','Frame ',int2str(i),'.tif'])
end
end

