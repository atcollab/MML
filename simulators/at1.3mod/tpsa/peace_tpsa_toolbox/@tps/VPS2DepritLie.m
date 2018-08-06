function dl = VPS2DepritLie(v)
% function dl = VPS2DepritLieFrom(vps)
% Convert VPS to DepritLie (linear-matrix M, non-linear-tps f)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 15-May-2003
% Updated Date:
%  27-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/VPS2DepritLie.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  vps(i) = exp(:t:) u(i)
%  vps = SingleLieTaylorOfTPS(t) == vps(1:2*OSIP.CanonicalDimensions)
%  dl = VPS2DepritLie(vps)
%------------------------------------------------------------------------------
%global OSIP

%dl.R = JacobianMatrixOfVPS(v);
dl.R = LinearSquareMatrixOfVPS(v);
Rinv = inv(dl.R);
u = ConcatenateVPSbyMatrix(v,Rinv);
dl.f = VPS2SingleLieTPS(u);
clear Rinv u