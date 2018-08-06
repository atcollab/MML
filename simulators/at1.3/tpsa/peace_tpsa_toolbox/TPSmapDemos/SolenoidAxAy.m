% SolenoidAxAy.m
% Purpose: 
% 1) Use ideal solenoid to test the functions of TPSA.
% 2) Show you the usage of TPSA package.
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 03-Jun-2003
% Updated Date: 09-Jul-2004
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
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
disp('MaximumOrder = 3;');
MaximumOrder = 3;

% Prepare OSIP, the Nerves of TPSA
%display('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

% Solenoid with vector potential Ax, Ay and As = 0
%Bx = 0; By = 0; Bs = B0;
%U = tps_variables(1:OSIP.NumberOfVariables);
X = tps_variable(1);
PX = tps_variable(2);
Y = tps_variable(3);
PY = tps_variable(4);
Delta = tps_variable(5);

% From Lorentz force equation, mechanic momentum p = Q*Br > 0.
% p/r = QB, 1/(Br) = Q/p
% Br  (T-M) for NSRRC's 1.5 GeV electron Ring.
% Q = -e
Q = -1; Br = -5.00; L = 1.0;
B0 = 3;
g2 = B0/Br; % We define the S (in Helmut Wiedemann's Book) = 2g (in S.Y. Lee's Book) == g2
si = 123.456;
sf = si+L;
Cuts = 2;
ds = (sf-si)/Cuts;
%% 1) At s = si, referred to the reference orbit
%% (Xc,X'c,Yc,Y'c,Delta)_s = (0,0,0,0,0)_s, we have
%% Ax(at si) = -B0*Yc(at si)/2 = 0
%% Ay(at si) = B0*Xc(at si)/2 = 0.
%% By the formula, PX = X'+Ax/Br and PY = Y'+Ay/Br,
%% such that we have
%% (X,X',Y,Y',Delta)_si = (X,PX,Y,PY,Delta)_si.
for s=si:ds:sf
    if s ~= sf
       Ax = -B0*Y/2;
       Ay = B0*X/2;
       As = 0;
       D1 = 1+Delta; D2 = D1*D1;
       PX2 = PX-Ax/Br; PX2 = PX2*PX2;
       PY2 = PY-Ay/Br; PY2 = PY2*PY2;
       T1 = As/Br;
       T2 = D2-PX2-PY2; T2 = sqrt(T2);
       H = -T1-T2;
       H0 = HomogeneousTPS(H,0); % this part can be ignored without loss 
       H1 = HomogeneousTPS(H,1); % Lorentz force for calculation of the reference orbit
       H2 = HomogeneousTPS(H,2);
       Hs = H-H0-H1;
       hs = -ds*Hs;
       h = -ds*H2;
       f = -ds*(Hs-H2);
    end
    if s == si
        sl = TPS2SymplecticLie(hs);
    elseif s == sf
        dl = SymplecticLie2DepritLie(sl);
    else
        sl = integrateSymplecticLie(sl,hs);
    end    
end
%disp('dl.R'), dl.R
%disp('dl.f'), dl.f
%% 2) At s = sf, referred to the reference orbit
%% (Xc,X'c,Yc,Y'c,Delta)_s = (0,0,0,0,0)_s, we have
%% Ax(at sf) = -B0*Yc/2 = 0
%% Ay(at sf) = B0*Xc/2 = 0.
%% By the formula, PX = X'+Ax/Br and PY = Y'+Ay/Br,
%% such that we have
%% (X,X',Y,Y',Delta)_sf = (X,PX,Y,PY,Delta)_sf.
disp('dl.R'), dl.R
disp('dl.f'), dl.f
 
% Formula of Linear Transfer Matrix for Comparison
Phi = g2*L/2; % Phi = g*L (S.Y. Lee's Book) = S/2*L (Helmut Wiedemann's Book)
m = eye(OSIP.NumberOfVariables);
cn = cos(Phi); sn = sin(Phi); sn2 = sin(2*Phi);
m(1,1) = cn*cn; m(1,2) = sn2/g2; m(1,3) = cn*sn; m(1,4) = 2*sn*sn/g2;
m(2,1) = -g2*cn*sn/2; m(2,2) = m(1,1); m(2,3) = -g2*sn*sn/2; m(2,4) = cn*sn;
m(3,1) = -m(1,3); m(3,2) = -m(1,4); m(3,3) = m(1,1); m(3,4) = m(1,2);
m(4,1) = -m(2,3); m(4,2) = -m(1,3); m(4,3) = m(2,1); m(4,4) = m(1,1);
m