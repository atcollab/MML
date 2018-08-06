function x = VariablesOfTPS(template,n)
% function x = VariablesOfTPS(TPS,n)
% Return the variables of TPS from x_1 up to x_n.
% Usage: Y = VariablesOfTPS(TPS,1:3);
% It also works: Z = VariablesOfTPS(TPS,[3 5 2 4 1]);
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 02-Dec-2002
% Last Updated Date: 12-Feb-2004
%  Source Files:
%    @TPS/VariablesOfTPS.m
% Terminology and Category:
%    Truncated Power Series Algebra (TPSA)
%    One-Step Index Pointer (OSIP)
%    Truncated Power Series (TPS)
%  Description:
%    In MATLAB, the index of array works FORTRAN-like.
%    Overloading Arithmetic Operators for TPS.
%    VariablesOfTPS(n) == x(n), i.e. x_n where n=i:j
%------------------------------------------------------------------------------
global OSIP
nlen = length(n);
if nlen < 1 | nlen > OSIP.NumberOfVariables
   error('length(n) < 1 | length(n) > OSIP.NumberOfVariables.')
else
   if (n(1) < 1) | (n(nlen) > OSIP.NumberOfVariables)
      error('n(1) < 1 | n(length(n)) > OSIP.NumberOfVariables.')
   end
end

for i=1:nlen
    x(i) = TPS(1,[0 OSIP.UnitVectors(n(i),:)]);
end
clear i nlen