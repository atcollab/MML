% Combined_Function_Bending_Magnet_As.m (CFBM_As.m)
% Purpose: 
% 1) Use CFBM to test the functions of TPSA.
% 2) Show you the usage of TPSA package.
% 3) The results are compared with the formula of Linear Tranfer Matrix.
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Date: 29-May-2004
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
disp('MaximumOrder = 4;');
MaximumOrder = 4;

% Prepare the Nerves of OSIP
%display('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
%clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

% Sector-dipole's vector potential Ax and Ay are zero and only As is used.
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
Theta = AD.bending_angle; % pi/9
B0 = -1.43158772117763;
B1 = -0.37*Br;
Rho = Br/B0;
L = Theta*Br/B0;
Ax = 0; Ay = 0;
As =-B0*(X+0.5*X^2/Rho)+B1*(1+X/Rho)*0.5*(Y^2-X^2)+X^3*B1/Rho/6;
D1 = 1+Delta; D2 = D1*D1; PX2 = PX*PX; PY2 = PY*PY;
T1 = As/Br;
T2 = D2-PX2-PY2; T2 = sqrt(T2);
H = -T1-(1+X/Rho)*T2;
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
disp('dlTimes.f'), dlTimes.f
disp('dlTimes.R'), dlTimes.R

% Use TPS2SymplecticLie, SymplecticLieIntegrator and SymplecticLie2DepritLie (OK)
% Test result of case n = 2 is correct! (Peace Chang)
SlIntegrator = sl;
for i=2:n
    SlIntegrator = integrateSymplecticLie(SlIntegrator,hn);
end
dlIntegrator = SymplecticLie2DepritLie(SlIntegrator);
%disp('dlIntegrator.f'), dlIntegrator.f
disp('dlIntegrator.R'), dlIntegrator.R

% Calculate the linear transformation (2nd order of TPS) only
%M = TPS2ndOrderMapMatrix(h,20)

% Formula of Linear Transfer Matrix for Comparison
% K = 1/(Rho^2)+B1/Br
m = eye(OSIP.NumberOfVariables);
Kx = 1/(Rho^2)+B1/Br;
if Kx < 0
    absK = abs(Kx);
    k = sqrt(absK);
    kl = k*L;
    cn = cosh(kl);
    sn = sinh(kl);
    m(2,1) = k*sn;
    m(1,5) = (cn-1)/absK/Rho;
else
    k = sqrt(Kx);
    kl = k*L;
    cn = cos(kl);
    sn = sin(kl);
    m(2,1) = -k*sn;
    m(1,5) = (1-cn)/Kx/Rho;
end
m(1,1) = cn;
m(1,2) = sn/k;
m(2,2) = cn;
% Dispersion
% Ref. "An Introduction to the Physics of High Energy Accelerators", table 3.2 (K,e and f) in p.89.
% Authors: D.A. Edwards and M.J. Syphers, SSC Laboratory, Dallas, Texas
m(2,5) = sn/k/Rho;
Ky = -B1/Br;
if Ky < 0
    absK = abs(Ky);
    k = sqrt(absK);
    kl = k*L;
    cn = cosh(kl);
    sn = sinh(kl);
    m(4,3) = k*sn;
else
    k = sqrt(Ky);
    kl = k*L;
    cn = cos(kl);
    sn = sin(kl);
    m(4,3) = -k*sn;
end
m(3,3) = cn;
if k ~= 0
    m(3,4) = sn/k;
else
    m(3,4) = L;
end
m(4,4) = cn;
m