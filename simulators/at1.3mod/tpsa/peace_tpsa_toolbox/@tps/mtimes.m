function r = mtimes(p,q)
% function r = mtimes(p,q)
% Return TPS p * TPS q.
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
%  @TPS/mtimes.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  mtimes(p,q) == p*q
%------------------------------------------------------------------------------
global OSIP
if strcmp('tps',class(p)) == 1 & strcmp('tps',class(q)) == 1
   order = min(p.o+q.o,OSIP.MaximumOrder);
   n = OSIP.NumberOfVariables;
   m = OSIP_NumberOfMonomials(n,order);
   c = zeros(1,m);
   r = TPS(order,c);
   %The indices of the array p.c that point to nonzero elements.
   k = find(p.c);
   l = length(k);
   pv = zeros(1,n);
   for i = 1:l
         power = OSIP.MonomialPowerVector(k(i),:);
         %The indices of the array q.c that point to nonzero elements.
         u = find(q.c);
         v = length(u);
         for j = 1:v
               pv(1:n) = power(1:n)+OSIP.MonomialPowerVector(u(j),1:n);
               order = sum(pv);
               if order <= r.o
                  w = OSIP_PowerVector2Monomial(pv);
                  r.c(w) = r.c(w)+p.c(k(i))*q.c(u(j));
               end
         end
   end
   clear c h i j k l m n order power pv u v w
elseif  strcmp('tps',class(p)) == 1 & strcmp('tps',class(q)) ~= 1 % q is double
   r = p;
   r.c(:) = r.c(:)*q;
elseif  strcmp('tps',class(p)) ~= 1 & strcmp('tps',class(q)) == 1 % p is double
    r = q;
    r.c(:) = r.c(:)*p;
else
    error('Non-TPS objects.')
end
