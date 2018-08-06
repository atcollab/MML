function NumberOfMonomials = OSIP_NumberOfMonomials(n,o)
% function NOM = OSIP_NumberOfMonomials(n,o)
% Return the number of monomials terms with n variables and orders from 0 to o. 
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
%  OSIP_NumberOfMonomials.m
% Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%------------------------------------------------------------------------------
% Fileds-Names:
%  NumberOfMonomials (NOM == nmo)
%  NumberOfMonomials(n,o) = number of monomials with orders from 0 up to o
%  NOM(n,o) = nchoosek((n+o),o) = (n+o)!/n!/o!
%------------------------------------------------------------------------------
% Note: Monomials of Power Series Expansion of Multi-variables Polynomial
% Definitions:
%  IndexShift == I, -0 for FORTRAN, MATHLAB and -1 for C/C++.
%  NumberOfVariables == n > 0
%  Variables, Ex. x_(1+I) x_(2+I) x_(3+I)
%  Order == o >= 0
%------------------------------------------------------------------------------
% Reference: TPSA_OSIP_Note.doc
%------------------------------------------------------------------------------
% NumberOfMonomials(i,j) = (i+j)!/(i!j!) = nchoosek((i+j),j)
%------------------------------------------------------------------------------
global OSIP
%tic
%npo = n+o;
%NumberOfMonomials = nchoosek(npo,o);
%clear npo
NumberOfMonomials = nchoosek(n+o,o);
%toc

%tic
%if Order == 0
%   NumberOfMonomials = 1;
%else
%   NumberOfMonomials = OSIP.NumberOfMonomials(n,o);
%end
%toc