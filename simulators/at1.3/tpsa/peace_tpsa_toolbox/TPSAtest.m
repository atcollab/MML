%TPSAtest.m
% Purpose:
% 1) Test the functions related to the TPS class for TPSA.
% 2) Show you many examples of the usage of TPS package for TPSA.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@srrc.gov.tw
% Created Date: 11-Dec-2002
% Updated Date:
%  12-May-2003
%  03-Jun-2003
% Terminology and Category:
%  Object Oriented Programming (OOP)
%  Truncated Power Series Algebra (TPSA)
%  Truncated Power Series (TPS): The basic class of TPSA.
%  One-Step Index Pointer (OSIP): The nerves of TPSA.
% Description:
%  OSIP is the nerves of TPSA and TPS class is the basic package of TPSA.
%  Note that the OSIP is unique in one's program/package/project.
%------------------------------------------------------------------------------
global OSIP
% info tpsa
% whatsnew tpsa
% helpwin tpsa
% doc tpsa
% methods tps

% Run OSIP.m
% OSIP

% Test TPS
%display('methods TPS');
disp('methods TPS');
methods TPS

% Create variables of TPS
% method 1
x = VariableOfTPS(TPS,1)
px = VariableOfTPS(TPS,2)
y = VariableOfTPS(TPS,3)
py = VariableOfTPS(TPS,4)
delta = VariableOfTPS(TPS,5)
% method 2
for n=1:OSIP.NumberOfVariables, X(n) = VariableOfTPS(TPS,n), end
% method 3
Y = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables)
Z = VariablesOfTPS(TPS,3:OSIP.NumberOfVariables)

% Test creating of TPS
% create zero TPS
a = TPS
% create a TPS
c = TPS(3,1:OSIP_NumberOfMonomials(OSIP.NumberOfVariables,3))
% assign a TPS by SetTPS
% case 1: in which the TPS a is not changed
b = SetTPS(a,2,0:OSIP_NumberOfMonomials(OSIP.NumberOfVariables,2)-1)
% case 2: in which the TPS a is updated
a = SetTPS(a,1,1:OSIP_NumberOfMonomials(OSIP.NumberOfVariables,1))

% get the data of TPS
[nv od ca] = GetTPS(c)
[index,od,k] = NonZeroMinOrderTPS(c)

% Test the overloading operators -TPS and +-*/ of TPS class
% uminus(-)
d = -a
clear d
% add(+)
d = a+b
clear d
% minus(-)
d = c-a
clear d
% mtimes(*)
d = a*b
clear d

% mrdivide(/)
tic, time0 = cputime
d = InverseTPS(a)
e = a*d
time1 = cputime, CPUtime = time1-time0, toc
clear d e

tic, time0 = cputime
e = a/a
time1 = cputime, CPUtime = time1-time0, toc
clear e

%tic, time0 = cputime
%e = -b/c
%time1 = cputime, CPUtime = time1-time0, toc
%clear e

%% Following will cause a error since const-term of b is 0!!!
%% e = b/b
d = a+2
d = a-6
d = a*5
d = a/3
d = a+b

g=d^3
g = sqrt(d)
g = exp(d)
d = d*5
g = log(d)
h = sin(d)
h = cos(d)
h = tan(d)
h = cot(d)
h = sec(d)
h = csc(d)
h = sinh(d)
h = cosh(d)
h = log10(d)
clear h

% homogeneous
h = HomogeneousTPS(d,2);