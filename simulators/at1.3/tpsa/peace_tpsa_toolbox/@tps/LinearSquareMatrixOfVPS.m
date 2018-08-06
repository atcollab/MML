function m = LinearSquareMatrixOfVPS(vps)
% function m = LinearSquareMatrixOfVPS(vps)
% Return the extended Jacobian matrix  of a given vps as a square matrix
% The dimension of square matrix is max(length(vps),OSIP.NumberOfVariables).
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 27-May-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  @TPS/LinearSquareMatrixOfVPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  vps(i) = exp(:tps:) u(i)
%  m = LinearSquareMarixOfVPS(vps)
%------------------------------------------------------------------------------
global OSIP
n = length(vps);
if n > OSIP.NumberOfVariables
    maxi = n;
    maxj = OSIP.NumberOfVariables;
    m = zeros(n);
else
    maxi = OSIP.NumberOfVariables;
    maxj = n;
    m = eye(OSIP.NumberOfVariables);
end
for i=1:n
    [index,order,k] = NonZeroMinOrderTPS(vps(i));
    if order > 0
        j = 1:OSIP.NumberOfVariables;
        m(i,j) = vps(i).c(1+j);
    end
end
clear i j maxi maxj n