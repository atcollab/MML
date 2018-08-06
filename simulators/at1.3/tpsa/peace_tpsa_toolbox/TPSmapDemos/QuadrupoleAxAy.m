% QuadrupoleaAxAy.m
% Purpose: 
% 1) Use NSRRC's QD1 and QF2 to test the functions of TPSA.
% 2) Show you the usage of TPSA package.
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@srrc.gov.tw
%-------------------------------------------------------------------------------
% Created Date: 28-May-2003
% Updated Date: 09-Jul-2004
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
clear all
format long
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
disp('MaximumOrder = 3;');
MaximumOrder = 3;

% Prepare the Nerves of OSIP
%display('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

% Quadrupole with vector potential Ax, Ay and As = 0
U = tps_variables(1:OSIP.NumberOfVariables);
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
Si = 123.456;
Sf =Si+ L;
Cuts = 10;
dS = (Sf-Si)/Cuts;
%% 1) To match the continuity at S = Si,
%% it's convenient to set
%% Ax(Si-) = Ax(Si+)
%% Ay(Si-) = Ay(Si+).
%% The relation of
%% Mechanical momenta (X',Y') and
%% Canonical momenta (PX,PY) are
%% X' = PX-Ax/Br
%% Y' = PY-Ay/Br.
%% Now, we make
%% Ax(S) = B1*X*(S-Si)
%% Ay(S) = -B1*Y*(S-Si)
%% and then we have
%% Ax(Si-) = Ax(Si+) = Ax(Si) = 0
%% Ay(Si-) = Ay(Si+) = Ay(Si) = 0
%% such that X' = PX and Y' = PY at S = Si.
for S=Si:dS:Sf
    if S ~= Sf
       Ax = B1*X*(S-Si+dS/2);
       Ay = -B1*Y*(S-Si+dS/2);
       As = 0;
       D1 = 1+Delta; D2 = D1*D1;
       PX2 = PX-Ax/Br; PX2 = PX2*PX2;
       PY2 = PY-Ay/Br; PY2 = PY2*PY2;
       T1 = As/Br;
       T2 = D2-PX2-PY2; T2 = sqrt(T2);
       H = -T1-T2;
       H0 = HomogeneousTPS(H,0);
       H1 = HomogeneousTPS(H,1);
       H2 = HomogeneousTPS(H,2);
       Hs = H-H0-H1;
       hs = -dS*Hs;
       h = -dS*H2;
       f = -dS*(H-H2);
    end
    if S == Si
        sl = TPS2SymplecticLie(hs);
    elseif S == Sf
        dl = SymplecticLie2DepritLie(sl);
    else
        sl = integrateSymplecticLie(sl,hs);
    end    
end
%% 2) At S = Sf, we need to transfer
%% the Canonical momenta (PX,PY) to
%% the Mechanical momenta (X',Y') by
%% X' = PX-Ax/Br
%% Y' = PY-Ay/Br,
%% i.g., (X,PX,Y,PY,Delta) => (X,X',Y,Y',Delta)
%% Such that the obtained transformation
%% (X,X',Y,Y',Delta)_Si => (X,X',Y,Y',Delta)_Sf
%% can be compared with the well-known formula.
V = DepritLie2VPS(dl);
Ax = B1*V(1)*(Sf-Si);
Ay = -B1*V(3)*(Sf-Si);
V(2) = V(2)-Ax/Br;
V(4) = V(4)-Ay/Br;
dl = VPS2DepritLie(V);
disp('dl.R'), dl.R
disp('dl.f'), dl.f

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