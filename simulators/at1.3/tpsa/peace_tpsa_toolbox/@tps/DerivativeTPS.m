function r = DerivativeTPS(p,n)
% function r = DerivativeTPS(tps,n)
% r = (d tps)/(d x_n)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 01-May-2003
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/DerivativeTPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  DerivativeTPS(p,n) == \partial{p}{u_n}
%------------------------------------------------------------------------------
global OSIP
%if strcmp('tps',class(p)) == 1
%end
r.n = p.n;
r.o = max(0,p.o-1);
r.c = zeros(1,OSIP_NumberOfMonomials(r.n,r.o));
r = class(r,'TPS');
%The indices of the array p.c that point to nonzero elements.
k = find(p.c);
len = length(k);
for i=1:len
    ppv = OSIP.MonomialPowerVector(k(i),:);
    ppvn = ppv(n);
    if ppvn > 0
       ppv(n) = ppv(n)-1;
       rj = OSIP_PowerVector2Monomial(ppv);
       r.c(rj) = r.c(rj)+ppvn*p.c(k(i));
    end
end
clear k len i ppv ppvn rj
