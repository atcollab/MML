function MonomialsEndedIndex = OSIP_MonomialsEndedIndex(NumberOfVariables,Order)
% function MEI = OSIP_MonomialsBeginIndex(n,o)
% Return the ended index of the o-order terms in NOM(n,o).
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
%  MonomialsEndedIndex (MEI == nmoe)
%  MonomialsEndedIndex(n,o) = the ended-index of the oth order monomials
%  MEI(n,o) = NOM(n,o)+I
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
% MonomialsEndedIndex = NumberOfMonomials+I
global OSIP
if Order == 0
   MonomialsEndedIndex = 1;
else
   MonomialsEndedIndex = OSIP.NumberOfMonomials(NumberOfVariables,Order);
end