% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary
I = imread("../data/cv_cover.jpg");
[rows, columns, numberOfColorChannels] = size(I);
if numberOfColorChannels > 1
    I = rgb2gray(I);
end
%% Compute the features and descriptors
corners = detectFASTFeatures(I);
[features,validPoints] = computeBrief(I,corners.Location); % 10

% corners = detectSURFFeatures(I);
% [features,validPoints] = extractFeatures(I,corners, 'Method', 'SURF');


number_of_matched_features = [];
rotations = [];
for i = 0:36
    %% Rotate image
    J = imrotate(I,i*10);
    %% Compute features and descriptors
    corners1 = detectFASTFeatures(J);
    [features1,validPoints1] = computeBrief(J,corners1.Location); % 10
    
%     corners1 = detectSURFFeatures(J);
%     [features1,validPoints1] = extractFeatures(J,corners1, 'Method', 'SURF');
    %% Match features
    indexPairs = matchFeatures(features,features1, 'MatchThreshold', 11, "MaxRatio",0.71);
    %% Update histogram
    number_of_matched_features = [number_of_matched_features, size(indexPairs, 1)];
    rotations = [rotations, i*10];
end

%% Display histogram
bar(rotations, number_of_matched_features);