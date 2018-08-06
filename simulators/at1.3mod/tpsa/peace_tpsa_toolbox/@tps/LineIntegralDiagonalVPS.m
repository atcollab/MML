function r = LineIntegralDiagonalVPS(vps,n,lambda)
% function r = LineIntegralDiagonalVPS(vps,n,lambda)
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
%  @TPS/LineIntegralDiagonalVPS.m
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
dimension = length(vps);
if (n > OSIP.NumberOfVariables) | (n < 1)
   error('In LineIntegralDiagonalVPS(vps,n,lambda), n out of range [1,OSIP.NumberOfVariable].')
end
for i=1:dimension
    u(i) = LineIntegralDiagonalTPS(vps(i),n,lambda);
end
X = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables);
r = X(1)*u(1);
for i=2:dimension
    r = r+X(i)*u(i);
end
clear dimension i X u