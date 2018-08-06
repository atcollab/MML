function dl = SymplecticLie2DepritLie(sl)
% function dl = SymplecticLie2DepritLie(sl)
% Transfer SymplecticLie sl to DepritLie dl.
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 29-May-2003
% Updated Date: 01-Jul-2004
% Source Files: TPSA/LieAlgebra/SymplecticLie2DepritLie.m
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
%------------------------------------------------------------------------------
%global OSIP
Ninv = inv(sl.N);
dl.f = ConcatenateTPSbyMatrix(sl.f,Ninv);
dl.R = sl.N*sl.M;
clear Ninv