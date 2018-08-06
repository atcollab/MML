function sl = TPS2SymplecticLie(t)
% function sl = TPS2SymplecticLie(tps)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 22-May-2003
% Updated Date:
%  27-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/TPS2SymplecticLie.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  sl = M exp(:f:) N
%  tps = h+f where tps.o >= 2
%  h = HomogeneousTPS(tps,2);
%  Basic case: M = N = LinearSquareMartix of exp(:h:/2) u
%------------------------------------------------------------------------------
global OSIP
h = HomogeneousTPS(t,2);
sl.f = t-h;
hh = h*0.5;
%vps = SingleLieTaylorMapVPS(hh);
%sl.M = JacobianMatrixOfVPS(vps);
%sl.M = LinearSquareMatrixOfVPS(vps);
%clear vps
sl.M = TPS2ndOrderMapMatrix(hh,20);
sl.N = sl.M;
clear h hh