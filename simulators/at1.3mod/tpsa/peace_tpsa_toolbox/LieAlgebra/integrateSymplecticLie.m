function sl = integrateSymplecticLie(slb,t)
% function sl = integrateSymplecticLie(slb,tps)
% set sla = TPS2SymplecticLie(tps)
% sl = slb(tps) = sla*slb = multiplySymplecticLie(sla,slb);
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 22-May-2003
% Updated Date: 02-Jul-2004
% Source Files: TPSA/LieAlgebra/integrateSymplecticLie.m
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
sla = TPS2SymplecticLie(t);
sl = multiplySymplecticLie(sla,slb);
clear sla