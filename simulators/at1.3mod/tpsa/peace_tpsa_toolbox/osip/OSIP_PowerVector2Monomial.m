function index = OSIP_PowerVector2Monomial(PowerVector)
% function index = OSIP_PowerVector2Monomial(PowerVector)
% Return the index which point to the term specified by the given PowerVector.
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
%  OSIP_MonomialIndexOfPowerVector.m
% Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
% Description:
%  OSIP_PowerVector2Monomial() == indexMonomial() ~= jpek()
%  Input: PowerVector
%  Output: Monomial's index
%------------------------------------------------------------------------------
global OSIP
order = sum(PowerVector); % sum of the orders == js(0)
if (order < 0) | (order > OSIP.MaximumOrder)
   error('Sum of the input PowerVector out of [1,OSIP.MaximunOrder]');
else
   index = OSIP_MonomialsBeginIndex(OSIP.NumberOfVariables,order);
   for i = 1:OSIP.NumberOfVariables
       n = OSIP.NumberOfVariables-i;
       order = order-PowerVector(i);
       index = index+OSIP_MonomialsBeginIndex(n,order)-1;
   end
end