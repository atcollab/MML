% SWLSatNSRRCnoOrbit.m
% It does not include H1 and H2.
% Purpose: 
% 1) Use SWLS of NSRRC to test the functions of TPSA.
% 2) Show you the usage of TPSA package.
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road
%  Hsinchu Science Park
%  Hsinchu 30077, Taiwan, R.O.C.
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 13-Jun-2003
% Updated Date: 13-May-2004
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
disp('MaximumOrder = 4;');
MaximumOrder = 4;

% Prepare OSIP, the Nerves of TPSA
%display('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
disp('OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);');
OSIP = OSIP_Nerve(NumberOfVariables,MaximumOrder,CanonicalDimensions);
clear CanonicalDimensions NumberOfCanonicalVariables NumberOfParameters NumberOfVariables MaximumOrder

U = tps_variables(1:OSIP.NumberOfVariables);
% U(1) = X = tps_variable(1);
% U(2) = PX = tps_variable(2);
% U(3) = Y = tps_variable(3);
% U(4) = PY = tps_variable(4);
% U(5) = Delta = tps_variable(5);

% Load NSRRC/TLS Accelerator Data
AD = nsrrc_ad;

%Bx = 0; By = -B0; Bs = 0;
% Q = -e
Q = AD.e_particle; % -1
% From Lorentz force equation, mechanic momentum p = Q*Br > 0.
% p/r = QB, 1/(Br) = Q/p
% Br (T-M) for NSRRC's 1.5 GeV electron Ring. 
Br = AD.BRho; % -5.00346113763311
hs = 0; % long straight section (1/r = 0)

% Get the data of SWLS in the 1.5 GeV TLS storage ring of NSRRC
CurrentOfMainPS = 260;
DataOfID = getIDofNSRRC('SWLS',CurrentOfMainPS);

Si = 1.5425; % The location of SWLS in TLS storage ring.
%Si = 0;
Sf = Si+DataOfID.L;

% Define the launching condition of reference orbit
% Uc(1:4)(Delta) (TPS)
% Xo = Uc(1)
% PXo = Uc(2)
% Yo = Uc(3)
% PYo = Uc(4)
% Delta = Uc(5) = U(5)
Uc = [TPS TPS TPS TPS U(5)]; % [0 0 0 0 Delta]
U0 = Uc;
%% At s = Si, referred to the reference orbit
%% (Xc,X'c,Yc,Y'c,Delta)_Si = (0,0,0,0,0)_Si,
%% Vector potential is required to be continuous at Si,
%% and each interface of pole-to-pole.
s = Si;
sShift = Si+0.5*DataOfID.L;
ss = s-sShift;
Cuts = 3;
k = 0;
j = Cuts;
[Em,Ep] = VectorPotentialCheck(DataOfID,Cuts,k,j);
if Em == Ep
    [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
else
    [Axm,Aym,Asm,Bxm,Bym,Bsm] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
    [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Ep*DataOfID.Amplitude);
    [dAx,dAy,dAs] = StepFuncShift(Axm,Aym,Asm,Ax,Ay,As);
    Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
end
i = 1; Sc(i) = s; Xc(i) = Uc(1); Yc(i) = Uc(3);
t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
dAxSc(i) = dAx;

NumberOfFullPole = DataOfID.NumberOfPoles-2*DataOfID.M;
Ds = DataOfID.PoleWidth/Cuts;
HalfDs = 0.5*Ds;
for k=1:DataOfID.NumberOfPoles
    deltaS = (k-1)*DataOfID.PoleWidth;
    for j=1:Cuts
         s = Si+deltaS+(j-1)*Ds;
         ss = s-sShift;
         % Dift
         [H,dUds] = getHamiltonian(Br,hs,Ax,Ay,As,Uc);
         Uc(1) = Uc(1); %+dUds(1)*HalfDs;
         Uc(3) = Uc(3); %+dUds(3)*HalfDs;
         sm = s+HalfDs;
         ss = sm-sShift;
         [Em,Ep] = VectorPotentialCheck(DataOfID,Cuts,k,j);
         [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
         % Kick
         [H,dUds] = getHamiltonian(Br,hs,Ax,Ay,As,Uc);
         Uc(2) = Uc(2); %+dUds(2)*HalfDs;
         Uc(4) = Uc(4); %+dUds(4)*HalfDs;
         [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
         i = i+1; Sc(i) = sm; Xc(i) = Uc(1); Yc(i) = Uc(3);
         t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
         t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
         dAxSc(i) = dAx;
         [Hs,dU0ds] = getHamiltonian(Br,hs,Ax,Ay,As,Uc);
         [H,dUds] = getHamiltonian(Br,hs,Ax,Ay,As,Uc);
         Uc(2) = Uc(2); %+dUds(2)*HalfDs;
         Uc(4) = Uc(4); %+dUds(4)*HalfDs;
         [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
         % Drift
         [H,dUds] = getHamiltonian(Br,hs,Ax,Ay,As,Uc);
         Uc(1) = Uc(1); %+dUds(1)*HalfDs;
         Uc(3) = Uc(3); %+dUds(3)*HalfDs;
         if j ~= Cuts
             s = s+Ds;
             ss = s-sShift;
             [Em,Ep] = VectorPotentialCheck(DataOfID,Cuts,k,j);
             if Em ~= Ep
                 disp('ERROR');
             else
                 [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
                 Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
                 i = i+1; Sc(i) = s; Xc(i) = Uc(1); Yc(i) = Uc(3);
                 t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
                 t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
                 dAxSc(i) = dAx;
             end
         end

         H0 = HomogeneousTPS(Hs,0); % this part can be ignored without loss 
         H1 = HomogeneousTPS(Hs,1); % Lorentz force for calculation of the reference orbit
         H2 = HomogeneousTPS(Hs,2); % Linear tranfer matrix
         Hs = Hs-H0-H1;
         H = -Ds*Hs;
         h = -Ds*H2;
         f = -Ds*(Hs-H2);

        if (k == 1) & (j == 1)
            sl = TPS2SymplecticLie(H);
        else
            sl = integrateSymplecticLie(sl,H);
        end
    end
    % j == Cuts
    s = Si+k*DataOfID.PoleWidth;
    ss = s-sShift;
    [Em,Ep] = VectorPotentialCheck(DataOfID,Cuts,k,j);
    if Em == Ep
         [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
    else
         [Axm,Aym,Asm,Bxm,Bym,Bsm] = getVectorPotential(DataOfID,ss,Uc,Em*DataOfID.Amplitude);
         [Ax,Ay,As,Bx,By,Bs] = getVectorPotential(DataOfID,ss,Uc,Ep*DataOfID.Amplitude);
         [ddAx,ddAy,ddAs] = StepFuncShift(Axm,Aym,Asm,Ax,Ay,As);
         dAx = dAx+ddAx; dAy = dAy+ddAy; dAs = dAs+ddAs;
    end
    if k == DataOfID.M
         dAx = 0; dAy = 0; dAs = 0;
    end
    if k == DataOfID.NumberOfPoles
         dAx = 0; dAy = 0; dAs = 0;
    end
    Ax = Ax+dAx; Ay = Ay+dAy; As = As+dAs;
    i = i+1; Sc(i) = s; Xc(i) = Uc(1); Yc(i) = Uc(3);
    t = HomogeneousTPS(By,0); [n,o,BySc(i)] = GetTPS(t);
    t = HomogeneousTPS(Ax,0); [n,o,AxSc(i)] = GetTPS(t);
    dAxSc(i) = dAx;
end
dl = SymplecticLie2DepritLie(sl);
disp('dl.R'), dl.R
disp('dl.f'), dl.f

% Calculate the effective focusing strength of SWLS field roll-off in x-direction.
% cosh(sqrt(k)*L) = dl.R(1,1) = dl.R(2,2)
% sinh(sqrt(k)*L)/sqrt(k) = dl.R(1,2); sinh(sqrt(k)*L)*sqrt(k) = dl.R(2,1)
R = dl.R;
L = DataOfID.L;
xKeff1 = (acosh(R(1,1))/L)^2
xKeff2 = (acosh(R(2,2))/L)^2
xKeff3 = -R(2,1)/R(1,2)
% xKeff = 0.0284
yKeff1 = (acos(R(3,3))/L)^2
yKeff2 = (acos(R(4,4))/L)^2
yKeff3 = -R(4,3)/R(3,4)
% yKeff = 0.5690

% <sin(k*s)*sin(k*s)> = <cos(k*s)*cos(k*s)> = 0.5
% DataOfID.Amplitude = DataOfID.PeakField/DataOfID.ks
% Effective K = 0.3529
display('Effective K value')
EffectiveK = 0.5*DataOfID.Field^2/(Br^2)*(1+2*1/4)/3

%set(gca,'FontName','Times');
%set(gca,'FontSize',14); % Default 12
%xlabel('S (Meter)');

%ylabel('Ax');
plot(Sc,AxSc,'b-x');
display('Pause > Please press Enter for continue') 
pause
plot(Sc,dAxSc,'k-x');
display('Pause > Please press Enter for continue') 
pause
%ylabel('By');
plot(Sc,BySc,'r-o');
% save data
filename = input('Pause > Please Enter file-name (SWLSatNSRRCnew.dat) for SAVEING DATA','s');
if isempty(filename)
    filename = 'SWLSatNSRRCnoOrbit.dat';
end
save filename OSIP Sc Xc Yc AxSc BySc
save SWLSatNSRRCnoOrbit.mat

