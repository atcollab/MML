function r = ConcatenateVPSbyMatrix(vps,m)
%function r = ConcatenateVPSbyMatrix(vps,m)
% Concatenate each TPS of vps by Matrix m
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 26-May-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  @TPS/ConcatenateVPSbyMatrix.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = ConcatenateVPSbyMatrix(vps,m)
%------------------------------------------------------------------------------
global OSIP
Y = Matrix2VPS(TPS,m);
vlen = length(vps);
r = vps;
for i=1:vlen
    r(i) = ConcatenateTPSbyVPS(vps(i),Y,1);
end
clear i vlen Y