function [I, rc] = lines_intersection(M1, u1, M2, u2, verbose)
%% lines_intersection : function to compute the intersection
% point between two lines of the 3D or 2D spaces.
%
% Author & support : nicolas.douillet (at) free.fr, 2020-2023.
%
%
% Syntax
%
% [I, rc] = lines_intersection(M1, u1, M2, u2);
% [I, rc] = lines_intersection(M1, u1, M2, u2, verbose);
%
%
% Description
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
%
% Principle
%
% Given L1 and L2 lines parametric equation systems :
%
% x(t) = x1 + a1*t
% y(t) = y1 + b1*t
% z(t) = z1 + c1*t
%
% x'(t) = x2 + a2*u
% y'(t) = y2 + b2*u
% z'(t) = z2 + c2*u
%
% we solve the system
%
% x = x'
% y = y'
% z = z'
%
% Using Kramer technique, with t and u as the unknowns.
%
%
% Input arguments
%
% - M1 : real row or column vector double, a point belonging to L1. numel(M1) = 3.
%
% - u1 : real row or column vector double, one L1 director. numel(u1) = 3.
%
% - M2 : real row or column vector double, a point belonging to L2. numel(M2) = 3.
%
% - u2 : real row or column vector double, one L1 director. numel(u2) = 3.
%
% - verbose : either logical *false/ true or numeric *0/1.
%
%
% Output arguments
%
% - I : real vector double, The intersection point of lines L1 and L2. size(I) = size(u1).
%
% - rc : integer scalar double in the set {0,1,2}. Return code.
%
%        0 : void intersection 
%        1 : one unique intersection point
%        2 : infinity of intersection points
%
%
% Example #1 : 3D single point intersection
%
% M1 = [2 3 -1];
% u1 = [3 5 7]; 
% M2 = [7 5 11];
% u2 = [-2 3 -5];
% [I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : I = [5 8 6], rc = 1
%
%
% Example #2 : 3D single point intersection, column vectors
%
% M1 = [6 6 6]';
% u1 = [1 1 1]';
% M2 = [1 0 2]';
% u2 = [0 1 -1]';
% [I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : I = [1 1 1], rc = 1
%
%
% Example #3 : 2D single point intersection
%
% M1 = [0 -1 0];
% u1 = [2 1 0];
% M2 = [0 4 0];
% u2 = [1 -2 0];
% [I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : I = [2 0 0], rc = 1
%
%
% Example #4 : 3D void intersection
%
% M1 = [2 3 5];
% u1 = [7 11 13]; 
% M2 = [3 5 2];
% u2 = [11 13 7];
% [I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : I = [], rc = 0
%
%
% Example #5 : 3D, L1 = L2
%
% M1 = [-2 2 -2];
% u1 = [1 -1 1]; 
% M2 = [3 -3 3];
% u2 = [-1 1 -1];
% [I, rc] = lines_intersection(M1, u1, M2, u2, true) % expected : rc = 2


%% Input parsing
assert(nargin > 3,'Not enough input arguments.');
assert(nargin < 6,'Too many input arguments.');

if nargin < 5
    
    verbose = true;
    
end

assert(isequal(size(u1),size(u2),size(M1),size(M2)),'All inputs vectors and points must have the same size.');
assert(isequal(numel(u1),numel(u2),numel(M1),numel(M2)),'All inputs vectors and points must have the same number of elements.');
assert(isequal(ndims(u1),ndims(u2),ndims(M1),ndims(M2),2),'All inputs vectors and points must have the same number of dimensions (2).');
assert(isreal(u1) && isreal(u2) && isreal(M1) && isreal(M2),'All inputs vectors and points must contain real numbers only.');

assert(numel(u1) > 1 && numel(u1) < 4,'Input vectors and points must have 2 or 3 elements.');


%% Body
msg = {'Lines 1 and 2 and have no intersection.';...
       'Lines 1 and 2 intersect in one single unique point.';...
       'L1 = L2 : lines 1 and 2 are actually a same one. '};

   
precision = 1e3*eps;
v = cross(u1,u2);
diff_pts = M2-M1;
catdim = find(size(M1)==1);
n = numel(M1);

% Segment cases
if norm(v) < precision
    
    if norm(cross(u1,diff_pts)) < precision && norm(cross(u2,diff_pts)) < precision
        
        I = M1;
        rc = 2;        
        
    else
        
        I = [];
        rc = 0;        
        
    end
    
else
    
    d = [-v(1) v(2) -v(3)];
    f = find(abs(d) > precision,1);
    
    d_pts = diff_pts(setdiff(1:n,f));    
    dt = det(cat(catdim,d_pts,-u2(setdiff(1:n,f))));
    du = det(cat(catdim,u1(setdiff(1:n,f)),d_pts));
    
    t = dt/d(f);
    u = du/d(f);
    
    if abs(M1+u1*t-M2-u2*u) < precision
        
        I = M1 + u1*t;        
        rc = 1;
        
    else
        
        I = [];
        rc = 0;
        
    end
    
end


if verbose
    
    disp(msg(1+rc));
    
end


end % lines_intersection