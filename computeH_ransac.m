function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
% locs1 and locs2 should be a marix of shape Nx2
%% Intialization
    N_pts = length(locs1); % total no. of points
    k = 4; %no. of correspondences
    e = 0.8; %outlier ratio = no. of outliers/total no. points
             %              = 1- no. of inliers/total no. of points
    p = 0.3; %probability that a point is an inlier
    N_iter = round(log10(1-p)/log10(1-(1-e)^k)); % no. of iterations
    %% Determination of Inliers
    maxnMatchedInliers = 0;
    for i = 1:N_iter
        %% Random sample
        randIndexes = randperm(N_pts,k);
        im1pts = locs1(randIndexes,:);
        im2pts = locs2(randIndexes,:);
        %% Homography Matrix estimation
        H = computeH_norm(im1pts, im2pts);
        %% Geometric Error Calculation
        %% Backward Transformation Error
        im1ptsForward  = homography_transform_forward(locs1',H)';
        errorForward = sum((im1ptsForward-locs2).^2,2).^0.5;
%         totalBackwardError = sum(errorForward);
        %% Forward Transformation Error
        im2ptsBackward = homography_transform_backward(locs2',H)';
        errorBackward = sum((im2ptsBackward-locs1).^2,2).^0.5;
%         totalForwardError = sum(errorBackward);
        %% Total Geometric Error
%         totalError = totalBackwardError + totalForwardError;
        %% Expected Error Distribution Std Dev
%         sigma = sqrt(totalError/(2*N_pts));
        %% Determining Threshold
%         distThreshold = sqrt(0.000000001)*sigma;
        distThreshold = 4;
        %% Determining no. of inliers
        logic1Inlier = errorForward<distThreshold;
        logic2Inlier = errorBackward<distThreshold;
        im1Inliers = logic1Inlier.*locs1;
        im2Inliers = logic2Inlier.*locs2;
        matchedInliers = im1Inliers(:,1)>0 & im2Inliers(:,1)>0;
        nMatchedInliers = nnz(matchedInliers); %number of matched inliers
        %% Updating Prarameters
        if nMatchedInliers > maxnMatchedInliers
            maxnMatchedInliers = nMatchedInliers;
            inliers = matchedInliers;
        end 
    end
%     disp(sum(inliers, "All"));
    bestH2to1 = computeH_norm(locs1(find(~all(inliers==0,2)), :), locs2(find(~all(inliers==0,2)), :));
%Q2.2.3
end
