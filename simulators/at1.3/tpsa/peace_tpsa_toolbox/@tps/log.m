function r = log(t)
% function r = log(tps)
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
%  @TPS/log.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = log(t) returns the natural logarithm of the TPS t.
%------------------------------------------------------------------------------
global OSIP
[index,order,k] = NonZeroMinOrderTPS(t);
if index == 0
   error('Log a zero TPS ?')
elseif index == 1 % constant term is not zero
   c = t.c(1);
   f = log(c);
   g = t/c;
   g.c(1) = 0;
   h = g;
   [i,o,j] = NonZeroMinOrderTPS(g);
   if i == 0
      r = TPS;
      r.c(1) = f;
   else 
      r = g*OSIP.CoeOfLn(1)+1;
      expo = ceil(OSIP.MaximumOrder/o);
      for l=2:expo
          h = h*g;
          r = r+h*OSIP.CoeOfLn(l);
      end
      r = r*f;
      clear l
   end
   clear i o j c f g h
else
   error('Exp a TPS with 0 constant term?')
end
clear index order k i o j l c f g h
