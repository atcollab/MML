function vps = Matrix2VPS(m)
%function vps = Matrix2VPS(m)
% Generate a VPS by the input Matrix m
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 26-May-2003
% Updated Date: 02-Jul-2004
% Source Files: TPSA/LieAlgebra/Matrix2VPS.m
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%  Lie Algebra (LA)
%-------------------------------------------------------------------------------
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  vps(i) = Sum_j m(i,j)*x_j   where i=1:column_of_m
%  vps(k) = x_k   where k=column_of_m+1:OSIP.NumberOfVariables
%------------------------------------------------------------------------------
global OSIP
row = length(m(:,1));
col = length(m(1,:));
j = 1:col;
for i=1:row
    vps(i) = TPS(1,[0 m(i,j)]);
end
for i=(row+1):OSIP.NumberOfVariables
    vps(i) = tps_variable(i);
end
clear i j row col