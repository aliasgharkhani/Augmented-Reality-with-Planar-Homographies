function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
[~, ~, numberOfColorChannels] = size(I1);
if numberOfColorChannels > 1
    I1 = rgb2gray(I1);
end
[~, ~, numberOfColorChannels] = size(I2);
if numberOfColorChannels > 1
    I2 = rgb2gray(I2);
end
%% Detect features in both images
corners1 = detectFASTFeatures(I1);
corners2 = detectFASTFeatures(I2);

%% Obtain descriptors for the computed feature locations
[features1,validPoints1] = computeBrief(I1,corners1.Location); % 10
[features2,validPoints2] = computeBrief(I2,corners2.Location);
% [features1,validPoints1] = extractFeatures(I1,corners1); % 13
% [features2,validPoints2] = extractFeatures(I2,corners2);
%% Match features using the descriptors
indexPairs = matchFeatures(features1,features2, 'MatchThreshold', 11, 'MaxRatio', 0.71);
locs1 = validPoints1(indexPairs(:,1),:);
locs2 = validPoints2(indexPairs(:,2),:);
% figure; 
% showMatchedFeatures(I1,I2,locs1,locs2, 'montage');
end
