%% lines_intersection
%
% Function to compute the intersection
% point between two lines of the 3D or 2D spaces.
%
% Author & support : nicolas.douillet (at) free.fr, 2020-2023.
%
%% Syntax
%
% [I, rc] = lines_intersection(M1, u1, M2, u2);
%
% [I, rc] = lines_intersection(M1, u1, M2, u2, verbose);
%
%% Description
%
% [I, rc] = lines_intersection(M1, u1, M2, u2) computes the intersection
% point of lines L1(M1,u1) and L2(M2,u2) and stores it in I. One unique
% intersction gives return code rc = 1, no intersection gives rc = 0, an
% infinity of intersections (case L1 = L2) gives rc = 2.
%
% [I, rc] = lines_intersection(M1, u1, M2, u2, verbose) set verbose mode ON
% when verbose is logical/1, and donesn't (verbose mode OFF)
% when verbose = *false/*0.
%
%% Principle
%
% Given L1 and L2 lines parametric equation systems :
%
% * x(t) = x1 + a1*t
% * y(t) = y1 + b1*t
% * z(t) = z1 + c1*t
%
% * x'(t) = x2 + a2*u
% * y'(t) = y2 + b2*u
% * z'(t) = z2 + c2*u
%
% we solve the system
%
% * x = x'
% * y = y'
% * z = z'
%
% Using Kramer technique, with t and u as the unknowns.
%
%% See also
%
% <https://fr.mathworks.com/matlabcentral/fileexchange/73760-line-plane-intersection-3d?s_tid=prof_contriblnk line_plane_intersection> |
% <https://fr.mathworks.com/matlabcentral/fileexchange/73853-planes-intersection?s_tid=prof_contriblnk planes_intersection> |
% <https://fr.mathworks.com/matlabcentral/fileexchange/73478-point-to-line-distance-3d-2d?s_tid=prof_contriblnk point_to_line_distance> |
% <https://fr.mathworks.com/matlabcentral/fileexchange/73490-point-to-plane-distance?s_tid=prof_contriblnk point_to_plane_distance> |
%
%% Input arguments
%
% - M1 : real row or column vector double, a point belonging to L1. 2 <= numel(M1) <= 3.
%
% - u1 : real row or column vector double, one L1 director. 2 <= numel(u1) <= 3.
%
% - M2 : real row or column vector double, a point belonging to L2. 2 <= numel(M2) <= 3.
%
% - u2 : real row or column vector double, one L1 director. 2 <= numel(u2) <= 3.
%
% - verbose : either logical *false/ true or numeric *0/1.
%
%% Output arguments
%
% - I : real vector double, The intersection point of lines L1 and L2. size(I) = size(u1).
%
% - rc : integer scalar double in the set {0,1,2}. Return code.
%
% * 0 : void intersection 
% * 1 : one unique intersection point
% * 2 : infinity of intersection points
%
%% Example #1
% 3D single point intersection
M1 = [6 6 6];
u1 = [1 1 1];
M2 = [1 0 2];
u2 = [0 1 -1];
[I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : I = [1 1 1], rc = 1

%% Example #2
% 2D single point intersection
M1 = [0 -1 0];
u1 = [2 1 0];
M2 = [0 4 0];
u2 = [1 -2 0];
[I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : I = [2 0 0], rc = 1

%% Example #3
% 3D void intersection
M1 = [7 11 13];
u1 = [2 3 5]; 
M2 = [17 19 23];
u2 = [7 11 13];
[I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : I = [], rc = 0

%% Example #4
% 3D, L1 = L2, column vectors
M1 = [-2 2 -2]';
u1 = [1 -1 1]'; 
M2 = [3 -3 3]';
u2 = [-1 1 -1]';
[I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : rc = 2