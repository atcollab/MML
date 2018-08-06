function r = LineIntegralDiagonalTPS(p,n,lambda)
% function r = LineIntegralDiagonalTPS(tps,n,lambda)
% It's used for the calculation of "generating function".
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
%  @TPS/LineIntegralDiagonalTPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  Reference: Yiton T. Yan, US Particle Accelerator School
%  The Use of Lie Algebra Methods to Analyze and Design Accelerator Beamline
%  Eqs. 5.7, 5.15, 5.16 (for lambda == 1.0)
%------------------------------------------------------------------------------
global OSIP
r = p;
%The indices of the array p.c that point to nonzero elements.
k = find(p.c);
l = length(k);
for i=1:l
    ppv = OSIP.MonomialPowerVector(k(i),:);
    o = sum(ppv(1:n));
    r.c(k(i)) = p.c(k(i))*lambda^(o+1)/(o+1);
end
clear k l i ppv o