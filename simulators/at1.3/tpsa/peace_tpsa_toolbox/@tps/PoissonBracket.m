function r = PoissonBracket(p,q)
% function r = PoissonBracket(p,q)
% Return r = [p,q]
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
%  @TPS/PoissonBracket.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  PoissonBracket(p,q) == [p,q]
%------------------------------------------------------------------------------
global OSIP
r.n = p.n;
r.o = min(OSIP.MaximumOrder,p.o+q.o-2);
r.c = zeros(1,OSIP_NumberOfMonomials(r.n,r.o));
r = class(r,'TPS');
for i=1:OSIP.CanonicalDimensions
      j = 2*i;
      k = j-1;
      r = r+DerivativeTPS(p,k)*DerivativeTPS(q,j)-DerivativeTPS(p,j)*DerivativeTPS(q,k);
end
clear i j k
