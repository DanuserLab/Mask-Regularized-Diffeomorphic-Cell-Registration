function [outputArg1,outputArg2] = plotAndSaveComparison(cellMapped,cellSource,strPlotOutputFolderPath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cmap = parula;
cmap(1:1,:) = zeros(1,3);
for i = 1:size(cellMapped,1)
    matMappedFrame = uint16(cellMapped{i});
    matSourceFrame = uint16(cellSource{i});
    
    matMappedFrame = imadjust(matMappedFrame,stretchlim(matMappedFrame),[]);
    matSourceFrame = imadjust(matSourceFrame,stretchlim(matSourceFrame),[]);
    %matFrame(matFrame == 0) = NaN;
    
    
    subplot(1,2,1);
    imagesc(matMappedFrame);
    colormap(cmap)
    %colormap gray
    axis off
    title(['Mapped Frame ',int2str(i)])
    pbaspect([1,1,2])
    
    subplot(1,2,2);
    imagesc(matSourceFrame);
    colormap(cmap)
    axis off
    title(['Source Frame ',int2str(i)])
    pbaspect([1,1,2])
    
    saveas(gcf,[strPlotOutputFolderPath,'\','Frame ',int2str(i),'.tif'])
end
end

