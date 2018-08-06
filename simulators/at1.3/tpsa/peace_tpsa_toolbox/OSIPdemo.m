%OSIPdemo.m
% Purpose:
% 1) Test the functions related to the OSIP of TPSA.
% 2) Show you many examples of the usage of OSIP package for TPSA.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@srrc.gov.tw
% Created Date: 11-Dec-2002
% Updated Date:
%  08-May-2003
%  03-Jun-2003
% Source Files:
%  OSIP.m
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
% Description:
%  OSIP is the Nerve of TPSA and TPS is the basic class of TPSA.
%  The Nerve of TPSA, OSIP, is unique in one's program/package/projec.
%------------------------------------------------------------------------------
clear all
global OSIP

% Input arguments of a dynamics system
%display('CanonicalDimensions = 2;');
disp('CanonicalDimensions = 2;');
CanonicalDimensions = 2;
%display('NumberOfCanonicalVariables = 2*CanonicalDimensions;');
disp('NumberOfCanonicalVariables = 2*CanonicalDimensions;');
NumberOfCanonicalVariables = 2*CanonicalDimensions;
%display('NumberOfParameters = 1;');
disp('NumberOfParameters = 1;');
NumberOfParameters = 1;
%display('NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;');
disp('NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;');
NumberOfVariables = NumberOfCanonicalVariables+NumberOfParameters;
%display('MaximumOrder = 6;');
disp('MaximumOrder = 6;');
MaximumOrder = 6;

% Prepare the Nerves of OSIP
%display('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

% Test OSIP
OSIP
disp('OSIP.UnitVectors = '), disp(OSIP.UnitVectors);
disp('OSIP.PowerVector = '), disp(OSIP.PowerVector);
disp('OSIP.NumberOfMonomials = '), disp(OSIP.NumberOfMonomials);
disp('OSIP.MonomialPowerVector = '), disp(OSIP.MonomialPowerVector);
disp('OSIP.IndexByOrderOfVariables = '), disp(OSIP.IndexByOrderOfVariables);
disp('OSIP.MasterIndices=');
for i=0:OSIP.NumberOfVariables
    for j=0:OSIP.MaximumOrder
         disp(['OSIP_MasterIndices{' num2str(i) ',' num2str(j), '}(:) = ']);
         Tno = OSIP_MasterIndices(i,j);
         disp(Tno);
     end
 end
 clear i j

% Test OSIP data
disp('powervector = ones(1,OSIP.NumberOfVariables)');
powervector = ones(1,OSIP.NumberOfVariables)
disp('index = OSIP_PowerVector2Monomial(powervector)');
index = OSIP_PowerVector2Monomial(powervector)
if powervector == OSIP.MonomialPowerVector(index,:)
   disp('powervector == OSIP.MonomialPowerVector(index,:)');
else
   disp('powervector ~= OSIP.MonomialPowerVector(index,:)');
end

disp('powervector = [3 0 1 0 1]');
powervector = [3 0 1 0 1]
disp('index = OSIP_PowerVector2Monomial(powervector)');
index = OSIP_PowerVector2Monomial(powervector)
if powervector == OSIP.MonomialPowerVector(index,:)
   disp('powervector == OSIP.MonomialPowerVector(index,:)');
else
   disp('powervector ~= OSIP.MonomialPowerVector(index,:)');
end

disp('powervector = [0 0 2 1 1]');
powervector = [0 0 2 1 1]
disp('index = OSIP_PowerVector2Monomial(powervector)');
index = OSIP_PowerVector2Monomial(powervector)
if powervector == OSIP.MonomialPowerVector(index,:)
   disp('powervector == OSIP.MonomialPowerVector(index,:)');
else
   disp('powervector ~= OSIP.MonomialPowerVector(index,:)');
end
clear powervector index

% Test OSIP functions
disp('OSIP_NumberOfMonomials(3,3)');
OSIP_NumberOfMonomials(3,3)
disp('OSIP_NumberOfMonomials(1,0)');
OSIP_NumberOfMonomials(1,0)
disp('OSIP_NumberOfMonomials(1,6)');
OSIP_NumberOfMonomials(1,6)
disp('OSIP_NumberOfMonomials(5,1)');
OSIP_NumberOfMonomials(5,1)