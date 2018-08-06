function vps = DepritLie2VPS(dl)
% function vps = DepritLie2VPS(dl)
% Convert DepritLie (linear-matrix M, non-linear-tps f) to VPS
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 15-May-2003
% Updated Date: 07-Jul-2004
% Source Files: TPSA/LieAlgebra/DepritLie2VPS.m
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
vf = TPS2VPSbyLieTransformation(dl.f);
vps = ConcatenateVPSbyMatrix(vf,dl.R);
clear vf