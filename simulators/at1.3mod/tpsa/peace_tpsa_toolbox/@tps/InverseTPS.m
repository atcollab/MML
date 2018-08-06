function r = InverseTPS(t)
% function r = InverseTPS(tps)
% Return 1/tps
% Note: the constant term of the given tps should not be 0.
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 11-Dec-2002
% Last Updated Date:  12-Feb-2004
% Source Files: TPSA/@TPS/InverseTPS.m
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%-------------------------------------------------------------------------------
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = InverseTPS(t) == 1/t = (1/t.c(1))*(1/(1+g))
%------------------------------------------------------------------------------
global OSIP
[index,order,k] = NonZeroMinOrderTPS(t);

if index == 0
   error('Inverse of 0 is not defined.')
elseif index == 1 % constant term is not zero
   if length(k) < 2 % TPS is a constant
      r = TPS;
      r.c = 1/t.c(1);
   else % 1/(1+g)/t.c(1) with g = t.c/t.c(1)-1
      id = k(2);
      OSIP.MonomialPowerVector(id);
      od = sum(OSIP.MonomialPowerVector(id));
      od = floor(OSIP.MaximumOrder/od);
      g = t;
      g.c = g.c/t.c(1);
      g.c(1) = 0;
      % 1/(1+g) = 1+OSIP.CoeOfInv(i)*g^i
      id = OSIP_NumberOfMonomials(t.n,OSIP.MaximumOrder);
      r = TPS(OSIP.MaximumOrder,zeros(1,id));
      h = g;
      id = OSIP_NumberOfMonomials(t.n,h.o);
      r.c(1:id) = h.c(1:id)*OSIP.CoeOfInv(1);
      for i = 2:od
          h = h*g;
          id = OSIP_NumberOfMonomials(t.n,h.o);
          r.c(1:id) = r.c(1:id)+h.c(1:id)*OSIP.CoeOfInv(i);
      end
      r.c(1) = r.c(1)+1.0;
      r.c = r.c/t.c(1);
      clear id od g h i
   end
else
   error('Inverse a TPS with 0 constant term?')
end
clear index order k
