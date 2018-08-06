function ld = InverseDepritLie(dl)
% function ld = InverseDepritLie(dl)
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
%  @TPS/InverseDepritLie.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%------------------------------------------------------------------------------
%global OSIP
ld.R = inv(dl.R);
vps = Matrix2VPS(dl.R);
ld.f = ConcatenateOfTPS(dl.f,vps,1);
ld.f = -dl.f;