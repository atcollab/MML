function r = ConcatenateTPSbyMatrix(t,m)
%function r = ConcatenateTPSbyMatrix(tps,m)
% Concatenate a TPS tps by Matrix m
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 29-May-2003
% Updated Date:
%  29-May-2003
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
%  r = ConcatenateTPSbyMatrix(tps,m)
%------------------------------------------------------------------------------
global OSIP
Y = Matrix2VPS(TPS,m);
r = ConcatenateTPSbyVPS(t,Y,1);
clear Y