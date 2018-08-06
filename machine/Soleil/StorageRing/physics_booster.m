function physics_booster
%
%

%
%  Written by Laurent S. Nadolski

%%
RfAcceptanceFlag = 1;
EnergyLossFlag = 0;

alpha = 3.19e-2;
Einj = 0.100; % GeV
Eext = 2.75; % GeV
rho = 12.376; % m
E = (Einj:0.1:Eext)% GeV
h = 184;
%%
if EnergyLossFlag == 1
    figure
    plot(E, physics_energyloss(E,rho));
    grid on
    xlabel('Energy (GeV)')
    ylabel('U0 (keV)');
    title('Energy loss per turn for the Booster ring')
    U0inj = physics_energyloss(Einj,rho);
    U0ext = physics_energyloss(Eext,rho);
    fprintf('U0 = %f keV @ %f GeV\n',U0inj, Einj);
    fprintf('U0 = %f keV @ %f GeV\n',U0ext, Eext);    
end

if RfAcceptanceFlag == 1
    figure
    VRF = (0:10:1000); % keV
    epsilon_RF = physics_RFacceptance(VRF,alpha,rho,Eext,h)
    plot(VRF,epsilon_RF*100);
    grid on
    xlabel('RF voltage (kV)')
    ylabel('RF acceptance (%)');
    title('RF acceptance for the Booster ring')
    e_RFinj = physics_RFacceptance(208,alpha,rho,Einj,h)
    fprintf('RF acceptance = %f %% @ %f GeV\n',e_RFinj*100, Einj);
end

%%
VRF = [230 844]; % kV
E   = [0.11 2.75]; % GeV 
Trev = 157/3e8; % s
U0 = physics_energyloss(E,rho)

phis = asin(U0./VRF); 
nus = sqrt(alpha*h*cos(phis).*VRF*1e-6/2/pi./E);
sigmaEoE = 6.6e-4*[1/25 1];
epsilon_RF = physics_RFacceptance(VRF,alpha,rho,E,h)
tau_epsilon = 3.4e-3;
tau_q = physics_quantumlifetime(epsilon_RF,sigmaEoE,tau_epsilon)

fprintf('               Injection    |  Extraction\n');
fprintf('----------------------------------------------\n');
fprintf('Energy (GeV) |  %4.3f       |     %4.3f \n',E);
fprintf('U0 (keV)     |  %4.3f       |     %4.1f \n',U0);
fprintf('Phis (°)     |  %4.3f       |     %2.2f \n',phis*180/pi);
fprintf('VRF (kV)     |  %4.1f       |     %4.1f \n',VRF);
fprintf('Energy spread|  %6.2e    |     %6.2e \n',sigmaEoE);
fprintf('e_RF (%%)     |  %4.3f       |     %4.3f \n',epsilon_RF*100);
fprintf('tau_q(s)     |  %4.3f        |     %4.1f \n',tau_q);
fprintf('nus          |  %4.3f       |     %4.3f \n',nus);
fprintf('nus (turn)   |  %4.2f       |     %4.2f \n',1./nus);
fprintf('nus (kHz)    |  %4.2f       |     %4.2f \n',nus/Trev/1e3);
fprintf('10 kHz <==> 1e-3 energy shift   \n');

%%
fRF = 353.202; % MHz
dfRF = fRF*alpha*0.01