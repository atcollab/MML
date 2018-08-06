function dl = DepritLieTimes(TPS,dla,dlb)
% function dl = DepritLieTimes(TPS,dla,dlb)
% dl = dla*dlb = {dlb.R exp(:dlb.f:)} {dla.R exp(:dla.f:)}
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 23-Jul-2003
% Updated Date:
% Source Files:
%  @TPS/InverseSymplecticLie.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  dlb.R exp(dlb.f) dla.R exp(dla.f)
%  = {exp(hi)exp(fi)}{exp(hj)exp(fj)
%  = exp(hi)exp(hj){exp(-hj)exp(fi)exp(hj)}exp(fj)
%  = exp(hij)exp{[exp(hj)]^(-1)fi}exp(fj)
%  = exp(hij)exp(fij) = dl.R exp(dl.f)
%------------------------------------------------------------------------------
%global OSIP
dl.R = dla.R*dlb.R;
Rinv = inv(dla.R);
Y = Matrix2VPS(TPS,Rinv);
dlbF = ConcatenateTPSbyVPS(dlb.f,Y,1);
dl.f = BCH99(dlbF,dla.f);
clear Rinv Y dlbF