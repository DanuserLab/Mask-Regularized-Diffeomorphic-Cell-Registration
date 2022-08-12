function [matDX,matDY] = registerSequence2D(cellReferenceFrames,idxMoving,idxFixed,ip)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%% initialize 
matRegistered = cellReferenceFrames{idxMoving};
matDX = zeros(size(matRegistered));
matDY = zeros(size(matRegistered));

%% identify the sequence of frames to target
cellReferenceSequence = makeFrameSequence(cellReferenceFrames,idxMoving,idxFixed,ip.Results.SetFrameStep);
clear cellReferenceFrames

%% step from moving frame to final fixed frame
for i = 1:length(cellReferenceSequence)
    matTarget = cellReferenceSequence{i};
    [matDX,matDY] = register2Frames(matRegistered,matTarget,matDX,matDY,ip);
end
end

%function for making a sequence of frames to follow
function cellReferenceSequence = makeFrameSequence(cellReferenceFrames,idxMoving,idxFixed,intFrameStep)
if idxMoving <= idxFixed
    vecFrameIdx = [idxMoving + intFrameStep: intFrameStep: idxFixed - intFrameStep, idxFixed];
    cellReferenceSequence = cell(length(vecFrameIdx),1);
    for l = 1:length(vecFrameIdx)
        cellReferenceSequence{l} = cellReferenceFrames{vecFrameIdx(l)};
    end
else 
    vecFrameIdx = [idxMoving - intFrameStep: -intFrameStep: idxFixed + intFrameStep, idxFixed];
    cellReferenceSequence = cell(length(vecFrameIdx),1);
    for l = 1:length(vecFrameIdx)
        cellReferenceSequence{l} = cellReferenceFrames{vecFrameIdx(l)};
    end
end
end

%function for registering 2 frames
function [matDX,matDY] = register2Frames(matOriginal,matF,matDX,matDY,ip)
% Registration processed using only the target gradient information
%% make meshgrid base for interpolation
[matMCoordBase,matNCoordBase]=meshgrid(1:size(matDX,2),1:size(matDY,1));

%% identify current interation images and gradients
maskF = makeMasks(matF);
maskOriginal = makeMasks(matOriginal);
matM = interp2(matOriginal,matMCoordBase+matDX,matNCoordBase+matDY,'linear');
maskM = interp2(double(maskOriginal),matMCoordBase,matNCoordBase,'nearest') > 0;

[gradXF,gradYF] = gradient(matF);
[gradXMaskF,gradYMaskF] = makeMaskGradient(maskF);
%% loop for a set number of interations to achieve convergence
for i = 1:ip.Results.SetIterations
    %identify the difference of images
    matImDiff =  imgaussfilt(matM - matF,ip.Results.SetLocality);
    maskDiff = imgaussfilt(maskM - maskF,ip.Results.SetLocality);
    
    %demons forces
    matDX_update = (-matImDiff.*(gradXF./((gradXF.^2+gradYF.^2) + ip.Results.SetAlpha^2*matImDiff.^2)))...
        +(-maskDiff.*(gradXMaskF./((gradXMaskF.^2+gradYMaskF.^2) + ip.Results.SetAlpha^2*maskDiff.^2)));
    matDY_update = (-matImDiff.*(gradYF./((gradXF.^2+gradYF.^2) + ip.Results.SetAlpha^2*matImDiff.^2)))...
        +(-maskDiff.*(gradYMaskF./((gradXMaskF.^2+gradYMaskF.^2) + ip.Results.SetAlpha^2*maskDiff.^2)));
    
    [matDX,matDY,matMCoord,matNCoord] = processDisplacement(matDX_update, matDY_update, matDX, matDY, ip.Results.SetLocality, ip.Results.FlagDiagonalCorrection);
    
    %interpolate and update the moving image    
    matM = interp2(matOriginal,matMCoord,matNCoord,'nearest');
    maskM = interp2(double(maskOriginal),matMCoord,matNCoord,'nearest') > 0;

%% diagnostics
    %vec_iteration_difference(i) = sum(sum(maskDiff ~= 0));
end

%% diagnostics
% figure(1)
% plot(vec_iteration_difference)
% figure(2)
% showgrid(matDX,matDY,2)
% figure(3)
% imagesc(matM)
% drawnow
end

%guiding gradient function for masks based on distance transform
function [gradXMaskF,gradYMaskF] = makeMaskGradient(maskF)
[gradX_in,gradY_in] = gradient(bwdist(~maskF));
[gradX_out,gradY_out] = gradient(bwdist(maskF));
gradXMaskF = gradX_in.*bwdist(~maskF) - gradX_out.*bwdist(maskF);
gradYMaskF = gradY_in.*bwdist(~maskF) - gradY_out.*bwdist(maskF);
end

%masking function for movie frames
function [matMask] = makeMasks(matFrame)
matMask = imbinarize(matFrame,'adaptive');
matMask = imfill(matMask,'holes');
end

%regularization of the estimated displacement to achieve a diffeomorphism
function [matDX,matDY,matMCoord,matNCoord] = processDisplacement( matDX_update, matDY_update, matDX, matDY, numLocality, flagDiagonalCorrection)
%this test of diffeomorphism requires that the cell does not touch boundary

%% make meshgrid base for interpolation
[matMCoordBase,matNCoordBase]=meshgrid(1:size(matDX,2),1:size(matDY,1));

%% preprocess the calculated displacement matricies
matDX_update(isnan(matDX_update))=0;
matDY_update(isnan(matDY_update))=0;

%% update the displacements with the new step & eliminates folds
matDX = matDX + matDX_update;
matDY = matDY + matDY_update;
[matDX,matDY] = foldElimination(matDX,matDY,matMCoordBase,matNCoordBase,flagDiagonalCorrection);

%% smooths only the update component of diffeomorphism 
%matDX = imgaussfilt(matDX - matDX_current,numLocality) + matDX_current;
%matDY = imgaussfilt(matDY - matDY_current,numLocality) + matDY_current;
matDX = imgaussfilt(matDX,numLocality);
matDY = imgaussfilt(matDY,numLocality);

%% make indexing for interpolation
matMCoord = matMCoordBase + matDX;
matNCoord = matNCoordBase + matDY;
end

% eliminate folds in space through sorting
function [matDX,matDY] = foldElimination(matDX,matDY,matMCoordBase,matNCoordBase,flagDiagonalCorrection)
if flagDiagonalCorrection == 1
    matDX = imrotate(matDX,45,'crop');
    matDY = imrotate(matDY,45,'crop');
    
    [~,matDxSortIdx] = sort(matDX + matMCoordBase,2);
    [~,matDySortIdx] = sort(matDY + matNCoordBase,1);
    matDX = matDX(sub2ind(size(matDX),matNCoordBase,matDxSortIdx));
    matDY = matDY(sub2ind(size(matDX),matDySortIdx,matMCoordBase));
    
    matDX = imrotate(matDX,-45,'crop');
    matDY = imrotate(matDY,-45,'crop');
end
[~,matDxSortIdx] = sort(matDX + matMCoordBase,2);
[~,matDySortIdx] = sort(matDY + matNCoordBase,1);

matDX = matDX(sub2ind(size(matDX),matNCoordBase,matDxSortIdx));
matDY = matDY(sub2ind(size(matDX),matDySortIdx,matMCoordBase));
end