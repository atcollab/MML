function a = SetTPS(t,o,c)
% function a = SetTPS(tps,order,coef)
% Create a TPS a by another TPS t with data order and coef. 
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 12-Dec-2002
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/display.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  a = SetTPS(t,o,c)
%------------------------------------------------------------------------------
global OSIP
t.o = o;
if length(c) ~= OSIP_NumberOfMonomials(OSIP.NumberOfVariables,o)
   error('length(c) does nor match the requirement')
end
t.c = c;
a = t;
