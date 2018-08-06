% QuadrupoleAs.m
% Purpose: 
% 1) Use NSRRC's QD1 and QF2 to test the functions of TPSA.
% 2) Show you the usage of TPSA package.
% 3) The results are compared with the formula of Linear Tranfer Matrix.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@srrc.gov.tw
% Created Date: 28-May-2003 (Debug)
% Updated Date:
%  29-May-2003 (OK)
%  03-Jun-2003 (TPS2DepritLie OK)
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
clear all
global OSIP
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
disp('MaximumOrder = 3;');
MaximumOrder = 3;

% Prepare the Nerves of OSIP
%display('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

% Quadrupole's vector potential Ax and Ay are zero and only As is used.
%U = tps_variables(1:OSIP.NumberOfVariables);
X = tps_variable(1);
PX = tps_variable(2);
Y = tps_variable(3);
PY = tps_variable(4);
Delta = tps_variable(5);

% Load NSRRC/TLS Accelerator Data
AD = nsrrc_ad;

%Bx = 0; By = -B0; Bs = 0;
% Q = -e
Q = AD.e_particle; % -1
% From Lorentz force equation, mechanic momentum p = Q*Br > 0.
% p/r = QB, 1/(Br) = Q/p
% Br (T-M) for NSRRC's 1.5 GeV electron Ring. 
Br = AD.BRho; % -5.00346113763311

L = 0.35;
%K = -1.50815; % NSRRC's QD1(L=0.35 meter,K=-1.50815)
K = 2.870480; % NSRRC's QF2(L=0.35 meter,K=2.870480)
B1 = Br*K;
Ax = 0; Ay = 0; As = -0.5*B1*(X*X-Y*Y);
%Bx = B1*Y; By = B1*X; Bs = 0;
D1 = 1+Delta; D2 = D1*D1; PX2 = PX*PX; PY2 = PY*PY;
T1 = As/Br;
T2 = D2-PX2-PY2; T2 = sqrt(T2);
H = -T1-T2;
H0 = HomogeneousTPS(H,0);
H1 = HomogeneousTPS(H,1);
H2 = HomogeneousTPS(H,2);
Hs = H-H0-H1;
hs = -L*Hs;
h = -L*H2;
f = -L*(Hs-H2);

% Use TPS2DepritLie (OK)
% Since the minimum-order of hs < 3, it's inefficient by this way.
%DL = TPS2DepritLie(hs);
%disp('DL.R'), DL.R
%disp('DL.f'), DL.f

% Use TPS2SymplecticLie, SymplecticLieTimes and SymplecticLie2DepritLie (OK)
% Test results of cases, eg. n = 1 and 2, are correct! (Peace Chang)
n = 1;
hn = hs/n;
sl = TPS2SymplecticLie(hn);
SlTimes = sl;
for i=2:n
    SlTimes = multiplySymplecticLie(sl,SlTimes);
end
dlTimes = SymplecticLie2DepritLie(SlTimes);
disp('dlTimes.R'), dlTimes.R
disp('dlTimes.f'), dlTimes.f

% Use TPS2SymplecticLie, SymplecticLieIntegrator and SymplecticLie2DepritLie (OK)
% Test result of case n = 2 is correct! (Peace Chang)
SlIntegrator = sl;
for i=2:n
    SlIntegrator = integrateSymplecticLie(SlIntegrator,hn);
end
dlIntegrator = SymplecticLie2DepritLie(SlIntegrator);
disp('dlIntegrator.R'), dlIntegrator.R
disp('dlIntegrator.f'), dlIntegrator.f

% Calculate the linear transformation (2nd order of TPS) only
M = TPS2ndOrderMapMatrix(h,20)

% Formula of Linear Transfer Matrix for Comparison
m = eye(OSIP.NumberOfVariables);
if K > 0
    k = sqrt(K); kl = k*L; cn = cos(kl); sn = sin(kl); ch = cosh(kl); sh = sinh(kl);
    m(1,1) = cn; m(1,2) = sn/k; m(2,1) = -k*sn; m(2,2) = cn;
    m(3,3) = ch; m(3,4) = sh/k; m(4,3) = k*sh; m(4,4) = ch;
elseif K == 0
    m(1,2) = L; m(3,4) = L;
else
    k = -K; k = sqrt(k); kl = k*L; cn = cos(kl); sn = sin(kl); ch = cosh(kl); sh = sinh(kl);
    m(1,1) = ch; m(1,2) = sh/k; m(2,1) = k*sh; m(2,2) = ch;
    m(3,3) = cn; m(3,4) = sn/k; m(4,3) = -k*sn; m(4,4) = cn;
end
m