function Tno = OSIP_MasterIndices(n,o)
% function Tno = OSIP_MasterIndices(n,o)
% Let  == OSIP.NumberOfVariables, this function return
% the MasterIndices, Tno, with o-order and n-to-N, total  (N-n+1), variables.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 12-May-2003
% Updated Date:
%  03-Jun-2003
% Source Files:
%  OSIP_MasterIndices.m
% Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  OSIP is the nerves of TPSA and TPS is the basic class of TPSA.
%  Declare the OSIP data structure and use it as "global OSIP".
%  And then, build up the Nerve of TPSA, i.e. the database of OSIP.
%  Which is unique in one's program/package/project using TPSA.
%  In MATLAB, the index of array works FORTRAN-like.
%------------------------------------------------------------------------------
% OSIP.IndexByOrderOfVariables(1:OSIP.MaximumOrder,1:OSIP.NumberOfVariables)
% == the BeginIndex of A(o,i:n) for i = 1:n.
% N = OSIP.NumberOfVariables
% O = OSIP.MaximumOrder
% OSIP.MasterIndices{n=1:N,o=1:O}(1:OSIP_NumberOfMonomials(N-n,o))
% == Tno(1:OSIP_NumberOfMonomials(N-n,o))
%------------------------------------------------------------------------------
% Reference: ICFA Beam Dynamics Newsletter, No. 13, P.8, April, 1997.
%------------------------------------------------------------------------------
global OSIP

if (n < 0)  | (o < 0)
   error('Arguments n and o in Tno = OSIP_MasterIndices(n,o) must >= 0.')
elseif (n == 0) | (o == 0)
   Tno = 1; % return the index of constant term
else
   Tno = OSIP.MasterIndices{n,o};
end