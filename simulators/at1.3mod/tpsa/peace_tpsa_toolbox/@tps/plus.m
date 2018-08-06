function r = plus(p,q)
% function r = plus(p,q)
% Return TPS r = p+q.
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 12-Dec-2002
% Updated Date: 03-Jun-2003
% Source Files: TPSA/@TPS/plus.m
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%-------------------------------------------------------------------------------
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  PLUS Addition for two TPS objects.
%------------------------------------------------------------------------------
global OSIP
if strcmp('tps',class(p)) == 1 & strcmp('tps',class(q)) == 1
   if p.n ~= q.n
      error('TPS variables must agree.')
   else
      if p.o >= q.o
         r = p;
         m = OSIP_NumberOfMonomials(q.n,q.o);
         if length(q.c) ~= m
             error('length(q.c) ~= m')
         end
         r.c(1:m) = r.c(1:m)+q.c(1:m);
      else
         r = q;
         m = OSIP_NumberOfMonomials(p.n,p.o);
         if length(p.c) ~= m
             error('length(p.c) ~= m')
         end
         r.c(1:m) = r.c(1:m)+p.c(1:m);
      end
      clear m
   end
elseif  strcmp('tps',class(p)) == 1 & strcmp('tps',class(q)) ~= 1 % q is double
   r = p;
   r.c(1) = r.c(1)+q;
elseif  strcmp('tps',class(p)) ~= 1 & strcmp('tps',class(q)) == 1 % p is double
    r = q;
    r.c(1) = r.c(1)+p;
else
    error('Non-TPS objects.')
end