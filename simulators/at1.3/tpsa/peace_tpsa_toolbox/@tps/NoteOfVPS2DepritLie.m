function g = NoteOfVPS2DepritLie(Wn1,n)
% function g = NoteOfVPS2DepritLie(Wn1,n)
% g = u(1:2*OSIP.CanonicalDimensions)*(-S)*Wn1/(n+1).
% It is used for the calculation of VPS2DepritLie.
% Ref. "The Use of Lie Algebra Methods to Analyze and Design Accelerator Beamlines"
% Author: Yiton T. Yan, SLAC
% Section. 3.6.2
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 02-Jun-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  @TPS/VPS2SingleLieTPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%------------------------------------------------------------------------------
global OSIP
CanonicalVariables = 2*OSIP.CanonicalDimensions;
dimension = length(Wn1);
if dimension ~= CanonicalVariables
   error('In NoteOfVPS2DepritLie(Wn1), dimension ~= CanonicalVariables.')
end
for i=1:2:CanonicalVariables % -S*Wnm
    SWn1(i+1) = -Wn1(i);
    SWn1(i) = Wn1(i+1);
end
g = LineIntegralDiagonalVPS(SWn1,CanonicalVariables,1); % lambda = 1;