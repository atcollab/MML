function [index,order,k] = NonZeroMinOrderTPS(t)
% function [index,order,k] = NonZeroMinOrderTPS(t)
% Return the non-zero term information of a given TPS.
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
%  05-Jun-2003 Disable the display('...').
% Source Files:
%  @TPS/mrdivide.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  [index,order] = NonZeroMinOrderTPS(t)
%  return the first non-zero term's index and its minimum order in TPS t
%------------------------------------------------------------------------------
global OSIP
k = find(t.c);
if isempty(k)
   %display('No non-zero term is found in given TPS.')
   index = 0;
   order = 0;
else
   index = k(1);
   order = sum(OSIP.MonomialPowerVector(index,:));
end
