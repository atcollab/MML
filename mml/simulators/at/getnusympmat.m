function nu = getnusympmat(M44)
%GETNUSYMPMAT - Calculate the tune from a symplectic one-turn matrix
%  nu = getnusympmat(M44)
%
%  INPUTS
%  1. M44 - 4 by 4 symplectic matrix
%
%  OUTPUTS
%  1. nu - Tunes

%  Written by Johan Bengtsson

if nargin < 1
    global THERING
    M44 = findm66(THERING);
end

n = 4;

M = M44(1:4, 1:4);
M = M - eye(4); detp = det(M); M = M + 2*eye(4); detm = det(M); M = M - eye(4);
b = (detp-detm)/16.0; c = (detp+detm)/8.0 - 1.0;
th = (M(1, 1)+M(2, 2))/2.0; tv = (M(3, 3)+M(4, 4))/2.0;
b2mc = b^2 - c;
if b2mc < 0.0
    nu = [-1.0; -1.0];
    disp('** Getnu: unstable in tune');
else
    if (th > tv)
        sgn = 1.0;
    else
        sgn = -1.0;
    end
    nu = [acos(sgn*sqrt(b2mc)-b)/(2.0*pi); acos(-b-sgn*sqrt(b2mc))/(2.0*pi)];
    for i = 1:n/2
        j = 2*i - 1;
        if (M(j,j+1) < 0.0)
            nu(i) = 1.0 - nu(i);
        end
    end
end
