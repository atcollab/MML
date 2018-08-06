function m = JacobianMatrixOfVPS(vps)
% function m = JacobianMatrixOfVPS(vps)
% Return the Jacobian Matrix of a given vps
% Note: m = JacobinMatrixOfVPS(vps) == LinearMatrixOfVPS(vps)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 08-May-2003
% Updated Date:
%  27-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/JacobianMatrixOfVPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  vps(i) = exp(:tps:) u(i)
%  m = JacobianMarixOfVPS(vps)
%------------------------------------------------------------------------------
global OSIP
n = length(vps);
m = zeros(n,OSIP.NumberOfVariables);
j = 1:OSIP.NumberOfVariables;
for i=1:n
      m(i,j) = vps(i).c(1+j);
end
clear i j n