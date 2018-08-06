function display(t)
% function display(tps)
% Display the information of argument TPS.
% TPS = Sum_{\vec{k}} Coef(MonomialTermOf{\vec{k}) \vec{X}^{\vec{k}}
% where \vec{k} = (k1,k2,...,kn), \vec{X} = (X1,X2,...,Xn), and
% \vec{X}^{\vec{k}} = (X1^k1)*(X2^k2)*...*(Xn^kn)
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
%  11-Feb-2004
% Source Files:
%  @TPS/display.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  DISPLAY Command Window Display of TPS objects.
%------------------------------------------------------------------------------
global OSIP
l = length(t);
disp('TPS object information:')
for i = 1:l
     if l > 1
         disp([inputname(1) '(' num2str(i) ')'])
     else
         disp(inputname(1))
     end
     disp(['TPS.NumberOfVariables = ' num2str(t(i).n)])
     disp(['TPS.Order = ' num2str(t(i).o)])
     disp('nonzero-monomial-term) coefficient * power-vector-of-variables')
     k = find(t(i).c);
     lk = length(k);
     for j=1:lk
         disp([num2str(k(j)) ') ' num2str(t(i).c(k(j))) ' * ' num2str(OSIP.MonomialPowerVector(k(j),:))])
     end
     disp('----------')
%    disp(['TPS.Coefficients = ' num2str(t(i).c)])
 end
disp('TPS ===================')