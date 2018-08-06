function r = HomogeneousTPS(p,o)
% function r = HomogeneousTPS(tps,o)
% Return the o-order homogeneous of a given TPS
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 12-May-2003
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% Source Files:
%  @TPS/HomogeneousTPS.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = HomogeneousTPS(p,o) is the o-order homogeneous of TPS p.
%------------------------------------------------------------------------------
global OSIP

if o > p.o
   r = TPS;
else
   r.n = p.n;
   r.o = o;
   r.c = zeros(1,OSIP_NumberOfMonomials(r.n,r.o));
   r = class(r,'TPS');
   i = OSIP_MonomialsBeginIndex(r.n,o);
   f = OSIP_MonomialsEndedIndex(r.n,o);
   r.c(i:f) = p.c(i:f);
   clear i f
end


