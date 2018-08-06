function [n,o,c] = GetTPS(t)
% function [n,o,c] = GetTPS(tps)
% Get the data of a given TPS.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 12-Dec-2002
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/TPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  [n o c] = GetTPS(t) Get TPS data.
%  n = NumberOfVariables of the TPS t.
%  o = Order of the TPS t.
%  c = Coefficients (array) of the TPS t.
%------------------------------------------------------------------------------
n = t.n;
o = t.o;
c = t.c;