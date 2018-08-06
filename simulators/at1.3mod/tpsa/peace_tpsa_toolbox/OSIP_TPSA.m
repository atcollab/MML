% OSIP_TPSA.m
% Purpose: Test and show you the usage of functions related to the OSIP and the TPS for TPSA.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@srrc.gov.tw
% Created Date: 11-Dec-2002
% Updated Date: 01-Mar-2004
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description: OSIP is the Nerve of TPSA and TPS is the basic class of TPSA.
%------------------------------------------------------------------------------
clear all
global OSIP

% Input arguments of a dynamics system
disp('CanonicalDimensions = 2;');
CanonicalDimensions = 2;
disp('NumberOfCanonicalVariables = 2*CanonicalDimensions;');
NumberOfCanonicalVariables = 2*CanonicalDimensions;
disp('NumberOfParameters = 1;');
NumberOfParameters = 1;
disp('NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;');
NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;
disp('MaximumOrder = 6;');
MaximumOrder = 6;

% Prepare the Nerves of OSIP
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

% Test OSIP
OSIP

% TPS
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
for n=1:OSIP.NumberOfVariables
    X(n) = VariableOfTPS(TPS,n);
end
X
% method 3
Y = VariablesOfTPS(TPS,1:OSIP.NumberOfVariables)
Z = VariablesOfTPS(TPS,3:OSIP.NumberOfVariables)

% Test creating of TPS
% create zero TPS
a = TPS
a = a+1
a = a+x
a = a+px
a = a+y
a = a+py
a = a+delta
a = a^2
h = HomogeneousTPS(a,2) % homogeneous
a = sqrt(a)

