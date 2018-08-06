function r = uminus(p)
% function r = uminus(tps)
% Return - TPS 
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 11-Dec-2002
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/minus.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  UMINUS Subtraction for TPS objects.
%------------------------------------------------------------------------------
r = TPS(p.o,-p.c);
