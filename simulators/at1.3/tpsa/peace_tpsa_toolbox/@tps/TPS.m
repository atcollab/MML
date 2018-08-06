function t = TPS(o,c)
% function t = TPS(order,coef)
% The constructor function of class TPS, which create a TPS t with given arguments,
% order and coef. If no argument is given, a zero TPS t is generated and returned.
% Note: dimension of c is (OSIP.NumberOfVariables+o)!/OSIP.NumberOfVariables!/o!
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 12-Dec-2002
% Last Updated Date: 12-Feb-2004
% Source Files:
%  @TPS/TPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  TPS class constructor.
%  t = TPS returns a TPS object with empty fields.
%  t = TPS(o,c) create a TPS object t from the coefficient-array c and order o.
%  TPS structure:
%  TPS.NumberOfVariables == tps.n determined by OSIP.NumberOfVariables
%  TPS.Order == tps.o <= OSIP.MaximumOrder
%  TPS.Coefficients == tps.c[1:OSIP_NumberOfMonomials(tps.n,tps.o)]
%------------------------------------------------------------------------------
global OSIP
if isempty(OSIP)
    error('You must call OSIP_Nerv to build up OSIP before calling TPS.')
end
%nargin
%varargin{}
t.n = OSIP.NumberOfVariables;
if nargin == 0 % Default constructor
   t.o = 0;
   t.c = [0];
else
   lc = length(c);
   if lc ~= OSIP_NumberOfMonomials(t.n,o)
       error('length(c) ~= OSIP_NumberOfMonomials(OSIP.NumberOfVariables,o)].')
   end
   t.o = o;
   t.c = c;
end
t = class(t,'TPS');