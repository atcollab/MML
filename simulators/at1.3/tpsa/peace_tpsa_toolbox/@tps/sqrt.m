function r = sqrt(t)
% function r = sqrt(tps)
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
%  @TPS/sqrt.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = sqrt(t) 
%------------------------------------------------------------------------------
global OSIP
[index,order,k] = NonZeroMinOrderTPS(t);
if index == 0
   r = TPS;
elseif index == 1 % constant term is not zero
   if t.c(1) < 0
      error('sqrt(t): the const. term t.c(1) < 0 ?')
   end
   c = t.c(1);
   f = sqrt(c);
   g = t/c;
   g.c(1) = 0;
   h = g;
   [i,o,k] = NonZeroMinOrderTPS(g);
   if i == 0
      r = TPS;
      r.c(1) = f;
   else 
      r = g*OSIP.CoeOfSqrt(1)+1;
      ExpandOrder = ceil(OSIP.MaximumOrder/o);
%      if o > 0
%          ExpandOrder = ceil(OSIP.MaximumOrder/o);
%      else
%          ExpandOrder = OSIP.MaximumOrder;
%      end
      for j=2:ExpandOrder
          h = h*g;
          r = r+h*OSIP.CoeOfSqrt(j);
      end
      r = r*f;
      clear j
   end
   clear i ExpandOrder k c f g h
else
   error('Sqrt a TPS with 0 constant term?')
end
clear index order k i o j l c f g h
