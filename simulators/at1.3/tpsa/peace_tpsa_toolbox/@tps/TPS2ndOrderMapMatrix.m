function m = TPS2ndOrderMapMatrix(t,cut)
% function m = TPS2ndOrderMapMatrix(tps)
% Return the linear matrix m of Lie transformation of a 2nd order homogeneous tps
% by exp(:tps:) u(i) = Sum_n{(:tps:)^n/n!} u(i) = Sum_j{m(i,j) u(j)} 
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 27-May-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  @TPS/TPS2ndOrderMapMatrix.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  vps(i) = exp(:t:) u(i) = Sum_n [(:t:)^n/n!] u(i)
%  vps = SingleLieTaylorMapVPS(t) == vps(1:2*OSIP.CanonicalDimensions)
%  m = LinearSquareMatrixOfVPS(vps)
%------------------------------------------------------------------------------
global OSIP
% It's found that the ko = 15 ~ 20 is enough for convergency.
%ko = max(20,cut);
ko = 0; ko = max(ko,cut);
n = 2^ko;
h = HomogeneousTPS(t,2);
h = h/n;
nPB = 30;
u = VariablesOfTPS(TPS,1:2*OSIP.CanonicalDimensions);
% 1PB
for i=1:2*OSIP.CanonicalDimensions
    vps(i) = PoissonBracket(h,u(i));
end
% nPB > 1PB
fac = 1;
for i=2:nPB
    fac = fac*i;
    for i=1:2*OSIP.CanonicalDimensions
        vps(i) = vps(i)+PoissonBracket(h,vps(i))/fac;
    end
end
% 0PB
for i=1:2*OSIP.CanonicalDimensions
    vps(i) = vps(i)+u(i);
end
m = LinearSquareMatrixOfVPS(vps);
for i=1:ko
    m = m*m;
end
clear ko n h u vps fac i nPB