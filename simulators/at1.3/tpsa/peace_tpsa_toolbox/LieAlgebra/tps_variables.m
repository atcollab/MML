function x = tps_variables(n)
% function x = tps_variables(n)
% Return the variables of TPS from x_1 up to x_n.
% Usage: Y = tps_variables(1:3);
% It also works: Z = tps_variables([3 5 2 4 1]);
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 02-Dec-2002
% Last Updated Date: 01-Jul-2004
% Source Files: TPSA/LieAlgebra/tps_variables.m
%-------------------------------------------------------------------------------
% Terminology and Category:
%    Truncated Power Series Algebra (TPSA)
%    One-Step Index Pointer (OSIP)
%    Truncated Power Series (TPS)
%    Lie Algebra (LA)
%-------------------------------------------------------------------------------
%  Description:
%    In MATLAB, the index of array works FORTRAN-like.
%    Overloading Arithmetic Operators for TPS.
%    tps_variables(n) == x(n), i.e. x_n where n=i:j
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