function PTBOUT = ptblattice(varargin)

% P (pre-injector)  lattice definition file for AT
% Pre injector main accelarating sections, without gun and and bunching.
% Part of Elettra synchrotron light source 
% C. Scafuri

%nominal beam parameters at the entry of the accelearting sections
% Beam energy: 6.6 MeV
% nomalized emittance ( 90%) : 64.6 pi mm mmrad
% unnormalized emiitance at 6.6 MeV: 4.6 pi mm mrad
% Twiss paramters:
%    alphax,alphay: -0.56
%    betax, betay: 0.5 m
%
% standard beam energy at exit: 104 MeV
 
global THERING

P_Energy =  6.6e6;  % 104 MeV - measeured energy at the end of the linac

FAMLIST = cell(0);


% % Exact formula is mandatory for low energy like in transfer lines
% E0 = .51099906e-3;    % Electron rest mass in GeV
% %brho = (10/2.99792458) * sqrt(Energy.^2 - E0.^2);
% % WARNING AT and other tracking code give kinetic energy and not total energy
% Brho = (10/2.99792458) * sqrt((Energy+E0).^2 - E0.^2);
% 
% %Brho = getbrho(Energy);
% GLOBVAL.E0 = Energy;


% Aperture size ???
%AP =  aperture('AP',  [-10, 10, -10, 10], 'AperturePass');



% Correctors
Lcm = 0.0; %the lenght of the corrector is moved out to the surrounding drifts

%P lattice elemets in order of pass
START = marker('START', 'IdentityPass');
D1A_P1_1 = drift('D1A_P1_1',0.0705,'DriftPass');
CM_P1_1 = marker('CM_P1_1','IdentityPass');
D1B_P1_1 = drift('D1B_P1_1',0.0705,'DriftPass');
Q_P1_1 = quadrupole('QD', 0.05, -0.1092 , 'StrMPoleSymplectic4RadPass');
DTR_P1_1 = drift('DTR_P1_1',0.0330,'DriftPass');
Q_P1_2 = quadrupole('QF', 0.05, +0.2616 , 'StrMPoleSymplectic4RadPass');
DTR_P1_2 = drift('DTR_P1_2',0.0330,'DriftPass');
Q_P1_3 = quadrupole('QD', 0.05, -0.1664 , 'StrMPoleSymplectic4RadPass');
D2A_P1_1  = drift('D2A_P1_1',0.075,'DriftPass');

BPM_P1_1  = marker('BPM_P1_1', 'IdentityPass');
D2B_P1_1= drift('D2B_P1_1',0.2500,'DriftPass');

FLSC_P1_2 = marker('FLSC_P1_2', 'IdentityPass');
D2C_P1_1  = drift('D2C_P1_1',0.4395,'DriftPass');
CHAS_P1_1 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CVAS_P1_1 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
ACCT_P1_1  = drift('ACCT_P1_1',4.565,'DriftPass'); % 1st CERN type acc. section  - nel modello su DB e' spezzata in due drift con una cavita' sottile in mezzo
CHAS_P1_2 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CVAS_P1_2 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
D3_P1_1  = drift('D3_P1_1',0.3605,'DriftPass');
Q_P1_4 = quadrupole('QD', 0.05, -1.0145 , 'StrMPoleSymplectic4RadPass');
DTR_P1_3 = drift('DTR_P1_3',0.0330,'DriftPass');
Q_P1_5 = quadrupole('QF', 0.05, 2.1506  , 'StrMPoleSymplectic4RadPass');
DTR_P1_4 = drift('DTR_P1_4',0.0330,'DriftPass');
Q_P1_6 = quadrupole('QD', 0.05, -1.0121  , 'StrMPoleSymplectic4RadPass');
D4B_P1_1= drift('D4B_P1_1',0.06,'DriftPass');
CM_P1_2 = marker('CM_P1_2','IdentityPass');
D4B_P1_2= drift('D4B_P1_2',0.06,'DriftPass');
BPM_P1_2  = marker('BPM', 'IdentityPass');
D4C_P1_1= drift('D4C_P1_1',0.2550,'DriftPass');
FLSC_P1_3 = marker('FLSC_P1_3', 'IdentityPass');
D4_P1_1= drift('D4_P1_1',0.3605,'DriftPass');
CHAS_P1_3 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CVAS_P1_3 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
ACCT_P1_2  = drift('ACCT_P1_2',4.565,'DriftPass'); % 2nd CERN type acc. section  - nel modello su DB e' spezzata in due drift con una cavita' sottile in mezzo
CHAS_P1_4 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CVAS_P1_4 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
D5_P1_1= drift('D5_P1_1',0.1055,'DriftPass');
EXIT_P = marker('EXIT_P', 'IdentityPass');


% the real P lattice

P = [
START,
D1A_P1_1,
CM_P1_1,
D1B_P1_1,
Q_P1_1,
DTR_P1_1,
Q_P1_2,
DTR_P1_2,
Q_P1_3,
D2A_P1_1,
BPM_P1_1,
D2B_P1_1,
FLSC_P1_2,
D2C_P1_1,
CHAS_P1_1,
CVAS_P1_1,
ACCT_P1_1,
CHAS_P1_2,
CVAS_P1_2,
D3_P1_1,
Q_P1_4,
DTR_P1_3,
Q_P1_5,
DTR_P1_4,
Q_P1_6,
D4B_P1_1,
CM_P1_2,
D4B_P1_2,
BPM_P1_2,
D4C_P1_1,
FLSC_P1_3,
D4_P1_1,
CHAS_P1_3,
CVAS_P1_3,
ACCT_P1_2,
CHAS_P1_4,
CVAS_P1_4,
D5_P1_1,
EXIT_P
];




% PTB lattice definition file for AT
% Pre-imjnector To Booster transfer line
% part of Elettra synchrotrn light source 
% C. Scafuri

%disp('   Loading PTB (Elettra)');

PTB_Energy = 0.104e9;

% % Energy
% if nargin >=1 
%     Energy = varargin{1};
% else
%     Energy = 0.104e9;  % 104 MeV from pre-inector
% end
% 
% % Exact formula is mandatory for low energy like in transfer lines
% E0 = .51099906e-3;    % Electron rest mass in GeV
% %Brho = getbrho(Energy);
% %brho = (10/2.99792458) * sqrt(Energy.^2 - E0.^2);
% % WARNING AT and other tracking code give kinetic energy and not total energy
% Brho = (10/2.99792458) * sqrt((Energy+E0).^2 - E0.^2);

% Aperture size ???
%AP =  aperture('AP',  [-10, 10, -10, 10], 'AperturePass');



% Correctors
Lcm = 0.0; %the lenght of the corrector is moved out to the surrounding drifts



% PTB lattice elements in order of pass
START_PTB = marker('START_PTB', 'IdentityPass');
PTB_D1A = drift('PTB_D1A',0.3,'DriftPass');
CM_PTB1_1 = marker('CM_PTB1_1','IdentityPass');
PTB_D1B = drift('PTB_D1B',0.2,'DriftPass');
CH_PTB1_1 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CV_PTB1_1 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
PTB_D2A  = drift('PTB_D2B',0.24,'DriftPass');
BPM_PTB1_1  = marker('BPM', 'IdentityPass');
PTB_D2B  = drift('PTB_D2B',0.2554,'DriftPass');
Q_PTB1_1 = quadrupole('QD', 0.175, -6.5081, 'StrMPoleSymplectic4RadPass');
PTB_D3  = drift('PTB_D3',0.195,'DriftPass');
Q_PTB1_2 = quadrupole('QF', 0.175, 6.5082, 'StrMPoleSymplectic4RadPass');
PTB_D4  = drift('PTB_D3',0.3966,'DriftPass');
B_PTB1_1 = rbend('BEND', .2, 15.0*pi/180.0, 0, 0, 0, 'BndMPoleSymplectic4RadPass');
PTB_D5A  = drift('PTB_D5A',0.2979,'DriftPass');
FLSC_PTB1_2 = marker('FLSC_PTB1_2', 'IdentityPass');
PTB_D5B  = drift('PTB_D5A',0.2500,'DriftPass');
BPM_PTB1_3  = marker('BPM', 'IdentityPass');
PTB_D5C  = drift('PTB_D5C',0.35,'DriftPass');
CH_PTB1_2 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CV_PTB1_2 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
PTB_D6  = drift('PTB_D6',0.2505,'DriftPass');
Q_PTB1_3 = quadrupole('QD', 0.175, -13.5682, 'StrMPoleSymplectic4RadPass');
PTB_D7  = drift('PTB_D7',0.195,'DriftPass');
Q_PTB1_4 = quadrupole('QF', 0.175, 6.0127, 'StrMPoleSymplectic4RadPass');
PTB_D8A  = drift('PTB_D8A',0.1615,'DriftPass');
BPM_PTB1_4  = marker('BPM', 'IdentityPass');
PTB_D8B  = drift('PTB_D8B',0.2835,'DriftPass');
Q_PTB1_5 = quadrupole('QD', 0.175, -0.8036, 'StrMPoleSymplectic4RadPass');
PTB_D9  = drift('PTB_D9',0.3315,'DriftPass');
CH_PTB1_3 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CV_PTB1_3 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
PTB_D10  = drift('PTB_D10',0.6515,'DriftPass');
Q_PTB1_6 = quadrupole('QD', 0.175, -15.3733, 'StrMPoleSymplectic4RadPass');
PTB_D11  = drift('PTB_D11',0.1950,'DriftPass');
Q_PTB1_7 = quadrupole('QF', 0.175, 12.646, 'StrMPoleSymplectic4RadPass');
PTB_D12  = drift('PTB_D12',0.1365,'DriftPass');
SCRH_PTB1_1=marker('SCRH_PTB1_1','IdentityPass');
PTB_D13  = drift('PTB_D13',0.1950,'DriftPass');
SCRV_PTB1_1=marker('SCRV_PTB1_1','IdentityPass');
PTB_D14  = drift('PTB_D14',0.3650,'DriftPass');
CH_PTB1_4 = corrector('CH', Lcm, [0 0], 'CorrectorPass');
CV_PTB1_4 = corrector('CV', Lcm, [0 0], 'CorrectorPass');
PTB_D15A  = drift('PTB_D15A',0.28,'DriftPass');
FLSC_PTB1_3 = marker('FLSC_PTB1_3', 'IdentityPass');
PTB_D15B  = drift('PTB_D15B',0.1785,'DriftPass');
Q_PTB1_8 = quadrupole('QD', 0.175, -9.1185, 'StrMPoleSymplectic4RadPass');
PTB_D16A  = drift('PTB_D16A',0.1815,'DriftPass');
CM_PTB1_2=marker('CM_PTB1_2','IdentityPass');
BPM_PTB1_5  = marker('BPM', 'IdentityPass');
PTB_D16B  = drift('PTB_D16B',0.8535,'DriftPass');
SIB_PTB1_1 = rbend('BEND', .4, -15.0*pi/180.0, 0, 0, 0, 'BndMPoleSymplectic4RadPass');
PTB_D17  = drift('PTB_D16B',0.5,'DriftPass');
EXIT = marker('EXIT', 'IdentityPass');


% The PTB lattice
PTB = [
START_PTB,
PTB_D1A ,
CM_PTB1_1,
PTB_D1B ,
CH_PTB1_1,
CV_PTB1_1,
PTB_D2A,
BPM_PTB1_1,
PTB_D2B,
Q_PTB1_1,
PTB_D3,
Q_PTB1_2,
PTB_D4,
B_PTB1_1,
PTB_D5A,
FLSC_PTB1_2,
PTB_D5B,
BPM_PTB1_3,
PTB_D5C,
CH_PTB1_2,
CV_PTB1_2,
PTB_D6,
Q_PTB1_3,
PTB_D7,
Q_PTB1_4,
PTB_D8A,
BPM_PTB1_4,
PTB_D8B,
Q_PTB1_5,
PTB_D9,
CH_PTB1_3,
CV_PTB1_3,
PTB_D10,
Q_PTB1_6,
PTB_D11,
Q_PTB1_7,
PTB_D12,
SCRH_PTB1_1,
PTB_D13,
SCRV_PTB1_1,
PTB_D14,
CH_PTB1_4,
CV_PTB1_4,
PTB_D15A,
FLSC_PTB1_3,
PTB_D15B,
Q_PTB1_8,
PTB_D16A,
CM_PTB1_2,
BPM_PTB1_5,
PTB_D16B,
SIB_PTB1_1,
PTB_D17,
EXIT
];


buildlat([P; PTB]);

% Add energy to each cell
THERING(1:length(P)) = setcellstruct(THERING(1:length(P)), 'Energy', 1:length(P), P_Energy);
THERING(length(P)+(1:length(PTB))) = setcellstruct(THERING(length(P)+(1:length(PTB))), 'Energy', 1:length(PTB), PTB_Energy);

L0 = findspos(THERING, length(THERING)+1);
%fprintf('   Energy %.6f MeV  \n', PTB_Energy/1e6);
fprintf('   PTB Length = %.6f meters  \n', L0);
%evalin('caller','global THERING');
PTBOUT = THERING;


