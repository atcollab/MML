function vps = Matrix2VPS(template,m)
%function vps = Matrix2VPS(TPS,m)
% Generate a VPS by the input Matrix m
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 26-May-2003
% Updated Date:
%  29-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/Matrix2VPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  vps = Matrix2VPS(m)
%------------------------------------------------------------------------------
global OSIP
row = length(m(:,1));
col = length(m(1,:));
vps = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables);
j = 1:col;
for i=1:row
    vps(i).c(1+j) = m(i,j);
end
clear i j row col