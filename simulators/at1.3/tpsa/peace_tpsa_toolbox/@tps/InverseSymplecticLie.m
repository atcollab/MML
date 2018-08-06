function ls = InverseSymplecticLie(sl)
% function ls = InverseSymplecticLie(sl)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 22-May-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  @TPS/InverseSymplecticLie.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%------------------------------------------------------------------------------
%global OSIP
ls.f = -sl.f;
ls.M = inv(sl.N);
ls.N = inv(sl.M);