function r = mpower(t,n)
% function r = mpower(tps,n) = (tps)^n
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 06-May-2003
% Updated Date:
%  13-May-2003
%  03-Jun-2003
% 12-Jun-2003 rename pow(t,n) to mpower(t,n)
% Source Files:
%  @TPS/mpower.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  In MATLAB, the index of array works FORTRAN-like.
%  Overloading Arithmetic Operators for TPS.
%  r = pow(t,n) where n must be integer
%------------------------------------------------------------------------------
global OSIP
if n == 0
   r = TPS(0,[1]);
else
   r = t;
   for i=2:abs(n)
       r = r*t;
   end
   if n < 0
      r = InverseTPS(r);
   end
end
