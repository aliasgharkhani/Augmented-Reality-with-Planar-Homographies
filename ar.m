% Q3.3.1
mov1 = loadVid("../data/book.mov");
mov2 = loadVid("../data/ar_source.mov");
cv_img = imread('../data/cv_cover.jpg');
video = VideoWriter('ar.avi'); %create the video object
open(video); %open the file for writing
totalLength = min(length(mov1), length(mov2));
for i=1:totalLength
    disp(i);
    [locsMov1, locsCV] = matchPics(cv_img, mov1(i).cdata);
    if length(locsMov1)<4 || length(locsCV)<4
        continue
    end
    %% Compute homography using RANSAC
    [bestHCVto1, ~] = computeH_ransac(locsMov1, locsCV);
    %% Scale harry potter image to template size
    % Why is this is important?
    scaled_mov2_img = imresize(mov2(i).cdata(:, 176:463, :), [size(cv_img,1) size(cv_img,2)]);
    %% Display composite image
    I = compositeH(bestHCVto1, scaled_mov2_img, mov1(i).cdata);
    
    writeVideo(video,I); %write the image to file
    

end
close(video); %close the file