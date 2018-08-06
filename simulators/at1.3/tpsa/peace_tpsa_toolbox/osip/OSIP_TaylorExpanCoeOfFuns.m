function OSIP_TaylorExpanCoeOfFuns()
% function OSIP_TaylorExpanCoeOfFuns()
% Generate the Taylor expansion coefficients used for TPS calculations.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  No. 101, Hsin-ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 11-Dec-2002
% Updated Date:
%  03-Jun-2003
% Source Files:
%  OSIP_Zlib.m
% Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Prepare the coefficients of FUNCTIONs for Taylor expansion.
%------------------------------------------------------------------------------
global OSIP

OSIP.CoeOfSqrt = zeros(1,OSIP.MaximumOrder);   % sqrt(x)
OSIP.CoeOfInv = zeros(1,OSIP.MaximumOrder);    % 1/(1+x)
OSIP.CoeOfLn = zeros(1,OSIP.MaximumOrder);     % ln(1+x)
OSIP.CoeOfExp = zeros(1,OSIP.MaximumOrder);    % exp(x)
OSIP.CoeOfSinCos = zeros(1,OSIP.MaximumOrder); % sin(x) and cos(x)

OSIP.CoeOfSqrt(1) = 0.5;
OSIP.CoeOfInv(1) = -1.0;
for i = 2:OSIP.MaximumOrder
    OSIP.CoeOfSqrt(i) = -OSIP.CoeOfSqrt(i-1)*(1.0-1.5/i);
    OSIP.CoeOfInv(i) = -OSIP.CoeOfInv(i-1);
end
for i = 1:2:OSIP.MaximumOrder, OSIP.CoeOfLn(i) = 1.0/i; end
for i = 2:2:OSIP.MaximumOrder, OSIP.CoeOfLn(1) = -1.0/i; end
factorial = 1;
for i = 1:OSIP.MaximumOrder
    factorial = factorial*i;
    OSIP.CoeOfExp(i) = 1.0/factorial;
end
OSIP.CoeOfSinCos(1) = 1.0; % cos(x) = 1-x/1!+x^3/2!-...
factorial = 1;
sign = -1.0;
for i = 3:2:OSIP.MaximumOrder
    factorial = factorial*(i-1);
    OSIP.CoeOfSinCos(i-1) = sign/factorial;
    factorial = factorial*i;
    OSIP.CoeOfSinCos(i) = sign/factorial;
    sign = -sign;
end
if (i-OSIP.MaximumOrder) == 1
   factorial = factorial*OSIP.MaximumOrder;
   OSIP.CoeOfSinCos(OSIP.MaximumOrder) = sign/factorial;
end
clear i factorial sign