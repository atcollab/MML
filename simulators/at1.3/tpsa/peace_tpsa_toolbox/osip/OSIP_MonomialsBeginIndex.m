function MonomialsBeginIndex = OSIP_MonomialsBeginIndex(NumberOfVariables,Order)
% function MBI = OSIP_MonomialsBeginIndex(n,o)
% Return the beginning index of the o-order terms in NOM(n,o).
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 11-Dec-2002
% Updated Date:
%  03-Jun-2003
% Source Files:
%  OSIP_MonomialsBeginIndex.m
% Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%------------------------------------------------------------------------------
% Fileds-Names:
%  MonomialsBeginIndex (MBI == nmob)
%  MonomialsBeginIndex(n,o) = the begin-index of the o-th order monomials
%  MBI(n,o) = NOM(n,o-1)+1+I 
%------------------------------------------------------------------------------
% Note: Monomials of Power Series Expansion of Multi-variables Polynomial
% Definitions:
%  IndexShift == I, -0 for FORTRAN, MATHLAB and -1 for C/C++.
%  NumberOfVariables == n > 0
%  Variables, Ex. x_(1+I) x_(2+I) x_(3+I)
%  Order == o >= 0
%  NumberOfMonomials(n,o) = number of monomials with orders from 0 up to o
%  nmo == NOM(n,o) = nchoosek((n+o),o) = (n+o)!/n!/o!
%------------------------------------------------------------------------------
% Reference: TPSA_OSIP_Note.doc
%------------------------------------------------------------------------------
% MonomialsBeginIndex(:,0) = 1+I
% MonomialsBeginIndex(:,1) = MonomialsBeginIndex(:,0)+1+I = 2+I
% MonomialsBeginIndex(:,j) = NumberOfMonomials(:,j-1)+1+I
global OSIP
if Order == 0
    MonomialsBeginIndex = 1;
elseif Order == 1
    MonomialsBeginIndex = 2;
else
    MonomialsBeginIndex = OSIP.NumberOfMonomials(NumberOfVariables,Order-1)+1;
end