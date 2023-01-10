function H2to1 = computeH(x1, x2)
% HOMOGRAPHY_SOLVE finds a homography from point pairs
%   x1 and x2 should be Nx2 matrices

if ~isequal(size(x1), size(x2))
    error('Points matrices different sizes');
end
if size(x1, 2) ~= 2
    error('Points matrices must have two columns');
end
n = size(x1, 1);
if n < 4
    error('Need at least 4 matching points');
end
% Solve equations using SVD
x = x2(:, 1); y = x2(:,2); X = x1(:, 1); Y = x1(:, 2);
rows0 = zeros(n, 3);
rowsxy = [x, y, ones(n, 1)];
hx = [-rowsxy, rows0, x.*X, y.*X, X];
hy = [rows0, -rowsxy, x.*Y, y.*Y, Y];
A = [hx; hy];
if n == 4
    [~, ~, V] = svd(A);
else
    [~, ~, V] = svd(A, 'econ');
end
H2to1 = (reshape(V(:,9), 3, 3)).';

end
