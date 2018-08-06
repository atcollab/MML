function r = cosTPS(t)
% function r = cosTPS(tps)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 06-May-2003
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/cosTPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = cosTPS(t) 
%------------------------------------------------------------------------------
global OSIP
g = t;
g.c(1) = 0;
[index,order,k] = NonZeroMinOrderTPS(g);
if index <= 1
   r = TPS;
   r.c(1) = 1;
else
   f = g*g;
   h = f;
   r = h*OSIP.CoeOfSinCos(2)+1;
   expo = ceil(OSIP.MaximumOrder/order);
   for i=4:2:expo
       h = h*f;
       r = r+h*OSIP.CoeOfSinCos(i);
   end
   clear i
end
clear index order k f g h