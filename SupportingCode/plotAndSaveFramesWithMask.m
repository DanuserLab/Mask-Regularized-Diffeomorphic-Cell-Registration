function plotAndSaveFramesWithMask(cellMovie,cellReferenceMovie,strPlotOutputFolderPath,vecFrameSelection)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

matTargetImageMask = cellReferenceMovie{floor(length(vecFrameSelection)/2)}>0;
matTargetImageMask = imfill(matTargetImageMask,8,'holes');
matTargetImageMask = bwareafilt(matTargetImageMask,1);
matTargetImageMask = imdilate(matTargetImageMask,strel('square',3));

%cmap = bone;
%cmap(1:6,:) = zeros(6,3);
%imagesc(cellMovieFrames{1})
cmap = jet;
cmap(1:3,:) = zeros(3,3);
%cmap = bone;
%cmap(1:1,:) = zeros(1,3);
for i = 1:size(cellMovie,1)
%     matFrame = cellMovie{i};
%     matFrame(matFrame == 0) = NaN;
%     matFrame(matEdge) = 2000;
    %myim = imadjust(uint16(cellMovie{i}),stretchlim(uint16(cellMovie{i})),[]);
    imagesc(cellMovie{i});
    %imagesc(myim);
    
    %colormap gray
    colormap(cmap)
    axis off
    %colorbar
    hold on
    [C,h] = contour(matTargetImageMask,[1,1]);
    h.LineWidth = 3;
    h.LineStyle = ':';
    h.LineColor = 'r';
    colorbar
    title(['Frame ',int2str(i)])
    saveas(gcf,[strPlotOutputFolderPath,'\','Frame ',int2str(i),'.tif'])
    hold off
end

end

