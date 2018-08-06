function varargout = boosterlattice(varargin)
%BOOSTERLATTICE - Booster lattice definition function


global THERING 


% Energy
if nargin >=1 
    Energy = varargin{1};
else
    Energy = 1.9e9;
end


% Markers
START = marker('START', 'IdentityPass');
BPM   = marker('BPM',   'IdentityPass');
TV    = marker('TV',    'IdentityPass');


% Aperture
AP = aperture('AP',  [-0.1, 0.1, -0.1, 0.1], 'AperturePass');


% RF SYSTEM
L0 = 75;              % Design length [m]
C0 = 299792458;       % Speed of light [m/s]
HarmNumber = 125;     % Base  RF on storage ring
CAV = rfcavity('CAV' , 0 , 1.2e+6 , HarmNumber*C0/L0, HarmNumber ,'CavityPass');


% Drifts
L1  = drift('L1', 0.546875, 'DriftPass');
L2  = drift('L2', 0.496875, 'DriftPass');
L3  = drift('L3', 2.093750, 'DriftPass');


% Correctors
Lcm = 0;
HCM = corrector('HCM', Lcm, [0 0], 'CorrectorPass');
VCM = corrector('VCM', Lcm, [0 0], 'CorrectorPass');


% Quadrupoles (split)
%QF = quadrupole('QF', .15,  0.96*2.7682214, 'StrMPoleSymplectic4RadPass'); 
%QD = quadrupole('QD', .10, -2.5401249*0.99, 'StrMPoleSymplectic4RadPass'); 

QF = quadrupole('QF', .15,  0.96*2.7682214, 'StrMPoleSymplectic4RadPass'); 
QD = quadrupole('QD', .10, -2.5401249*1.107, 'StrMPoleSymplectic4RadPass'); 


% Sextupoles
Lsext = 0;
SD = sextupole('SD', Lsext, 0.0, 'StrMPoleSymplectic4RadPass');
SF = sextupole('SF', Lsext, 0.0, 'StrMPoleSymplectic4RadPass');


% Bend (split)
%B = rbend('BEND', 1.05  , 15.0*pi/180, 15.0*pi/180, 15.0*pi/180, 0, 'BndMPoleSymplectic4RadPass');
BU = rbend('BEND', 1.05/2,  7.5*pi/180,  7.5*pi/180,           0, 0, 'BndMPoleSymplectic4RadPass');
BD = rbend('BEND', 1.05/2,  7.5*pi/180,           0,  7.5*pi/180, 0, 'BndMPoleSymplectic4RadPass');


% Build lattice
%CELL1 = [L3 QF QF BPM HCM TV L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM TV L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 HCM BPM QF QF VCM L3 BPM QD QD  ];
%CELL2 = [L3 QF QF BPM HCM    L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM    L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 HCM BPM QF QF VCM L3     QD QD BPM];
%CELL3 = [L3 QF QF BPM HCM    L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM    L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 HCM BPM QF QF VCM L3     QD QD BPM];
%CELL4 = [L3 QF QF BPM HCM    L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM TV L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 HCM BPM QF QF VCM L3     QD QD BPM];

CELL1 = [HCM BPM QF QF VCM L3     QD QD BPM L3 QF QF BPM HCM TV L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM TV L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2];
CELL2 = [HCM BPM QF QF VCM L3 BPM QD QD     L3 QF QF BPM HCM    L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM    L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2];
CELL3 = [HCM BPM QF QF VCM L3     QD QD BPM L3 QF QF BPM HCM    L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM    L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2];
CELL4 = [HCM BPM QF QF VCM L3     QD QD BPM L3 QF QF BPM HCM    L2 BU BD L1 VCM QD QD BPM SD L1 BU BD L2 HCM QF QF BPM SF L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 SF BPM QF QF HCM TV L2 BU BD L1 SD QD QD BPM VCM L1 BU BD L2 ];

BOOSTER = [ START AP CAV CELL1 CELL2 CELL3 CELL4 ];


buildlat(BOOSTER);

% Add energy field everywhere
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% Compute length
L0 = findspos(THERING, length(THERING)+1);
fprintf('   Booster Length = %.6f meters  \n', L0)


