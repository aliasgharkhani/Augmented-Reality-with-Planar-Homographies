function y = homography_transform_backward(x, H)
%   x should be a 2xN matrix
%   H, represented as a 3x3 homogeneous matrix.
q = H * [x; ones(1, size(x,2))];
p = q(3, :);
y = [q(1,:)./p; q(2,:)./p];
end
