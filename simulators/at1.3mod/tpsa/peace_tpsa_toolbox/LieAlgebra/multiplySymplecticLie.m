function sl = multiplySymplecticLie(sla,slb)
% function sl = multiplySymplecticLie(sla,slb)
% sl = sla*slb = {slb.M exp(:slb.f:) sb.N} {sla.M exp(:sla.f:) sla.N}
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 22-May-2003
% Updated Date: 02-Jul-2004
% Source Files: TPSA/LieAlgebra/multiplySymplecticLie.m
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%  Lie Algebra (LA)
%-------------------------------------------------------------------------------
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  {exp(hi)exp(fi)exp(hi)}{exp(hj)exp(fj)exp(hj)}
%  = exp(hi)exp(hi)exp(hj){exp(-hj)exp(-hi)exp(fi)exp(hi)exp(hj)}exp(fj)exp(hj)
%  = exp(hij)exp{[exp(hi)exp(hj)]^(-1)fi}exp(fj)exp(hj)
%  = exp(hij)exp(fij)exp(hj) = sl.M*exp(fij)*sl.N
%------------------------------------------------------------------------------
%global OSIP
sl.N = sla.N;
R = sla.M*slb.N;
sl.M = R*slb.M;
Rinv = inv(R);
Y = Matrix2VPS(Rinv);
slbF = ConcatenateTPSbyVPS(slb.f,Y,1);
sl.f = BCH99(slbF,sla.f);
clear R Rinv Y albF