function alslat_loco_3sb_disp_nux16_122bpms(varargin)
% Lattice definition file
% Compiled by Christoph Steier from alslat_loco_3sb_disp_nuy9_122bpms
% for the sextupole upgrade lattice
%
% ALS production lattice with Superbends, quadrupole families, one bend family,
% two sextupole families, BPMs as markers,
% eta_x(straight sections) = 15cm.

global FAMLIST THERING GLOBVAL

Energy = 1.89086196873342e9;
GLOBVAL.E0 = Energy;
GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);

fprintf('   Loading ALS lattice in %s\n', mfilename);


%AP = aperture('AP',  [-0.1, 0.1, -0.1, 0.1], 'AperturePass');


L0 = 196.8054150;     % design length [m]
C0 = 299792458;       % speed of light [m/s]


% RF SYSTEM
HarmNumber = 328;
V = version;
%CAV   = rfcavity('CAV1' , 0 , 1.5e+6 , HarmNumber*C0/L0, HarmNumber ,'CavityPass');
CAV   = rfcavity('CAV1' , 0 , 1.2e+6 , HarmNumber*C0/L0, HarmNumber ,'CavityPass');


% QUADRUPOLES
% QF    =  quadrupole('QF'  , 0.344,  2.237111, 'StrMPoleSymplectic4RadPass');
% QD    =  quadrupole('QD'  , 0.187, -2.511045, 'StrMPoleSymplectic4RadPass');
% QFA   =  quadrupole('QFA' , 0.448,  2.954352, 'StrMPoleSymplectic4RadPass');
% QDA   =  quadrupole('QDA' , 0.187, -1.779475, 'StrMPoleSymplectic4RadPass');
% QF   =  quadrupole('QF' , 0.344,  2.309454 , 'StrMPoleSymplectic4RadPass');
% QD   =  quadrupole('QD' , 0.187, -2.672428 , 'StrMPoleSymplectic4RadPass');
% QFA  =  quadrupole('QFA', 0.448,  3.225664 , 'StrMPoleSymplectic4RadPass');
% QDA  =  quadrupole('QDA', 0.187, -0.5683907 , 'StrMPoleSymplectic4RadPass');
QF   =  quadrupole('QF' , 0.344, 2.310217 , 'StrMPoleSymplectic4RadPass');
QD   =  quadrupole('QD' , 0.187, -2.681751 , 'StrMPoleSymplectic4RadPass');
QFA  =  quadrupole('QFA', 0.448,  3.223830 , 'StrMPoleSymplectic4RadPass');
QDA  =  quadrupole('QDA', 0.187, -0.3656653 , 'StrMPoleSymplectic4RadPass');


% SEXTUPOLES for xix=0.4 and xi_y=1.4
% -52.246310 74.801936 w/o sextu in superbend
% -52.03     75.05     w/  sextu in superbend
%-11.4/0.203=-56.1576;
%16.8/0.203 = 82.7586;
SDD   =  sextupole('SDD', 0.2030/2, -11.4/0.203, 'StrMPoleSymplectic4RadPass');
SFF   =  sextupole('SFF', 0.2030/2,  16.8/0.203, 'StrMPoleSymplectic4RadPass');

mSHF = 11; mSHD = -12;
SHFF   =  sextupole('SHFF', 0.2030/2,  mSHF, 'StrMPoleSymplectic4RadPass');
SHDD   =  sextupole('SHDD', 0.2030/2,  mSHD, 'StrMPoleSymplectic4RadPass');


% DIPOLES (COMBINED FUNCTION)
% K1= -0.7782 for 5 degrees instead of -0.81 for 3 degrees entrance/exit angle
BEND  =  rbend('BEND', 0.86514, 0.1745329, 0.0872665, 0.0872665, -0.7782,'BndMPoleSymplectic4RadPass');

% SUPERBEND L=255 mm for SBM1 and 254 mm for SBM3 and 4 (cf. field clamps)
BS    =  rbend('BS', 0.255, 0.1745329, 0.0872665, 0.0872665, 0,'BndMPoleSymplectic4RadPass');


% CORRECTORS and BPMS
FASTKICKER =  corrector('FASTKICKER',0.0,[0 0],'CorrectorPass');
COR =  corrector('COR',0.0,[0 0],'CorrectorPass');
CHIC = corrector('CHICANE',0.0,[0 0],'CorrectorPass');
BPM =  marker('BPM','IdentityPass');
IDBPM =  marker('BPM','IdentityPass');
BBPM = marker('BPM','IdentityPass');


% MARKERS and APERTURES
SECT1 =  marker('SECT1', 'IdentityPass');
SECT2 =  marker('SECT2', 'IdentityPass');
SECT3 =  marker('SECT3', 'IdentityPass');
SECT4 =  marker('SECT4', 'IdentityPass');
SECT5 =  marker('SECT5', 'IdentityPass');
SECT6 =  marker('SECT6', 'IdentityPass');
SECT7 =  marker('SECT7', 'IdentityPass');
SECT8 =  marker('SECT8', 'IdentityPass');
SECT9 =  marker('SECT9', 'IdentityPass');
SECT10 =  marker('SECT10', 'IdentityPass');
SECT11 =  marker('SECT11', 'IdentityPass');
SECT12 =  marker('SECT12', 'IdentityPass');
BL31 =  marker('BL31', 'IdentityPass');
FIN =  marker('FIN', 'IdentityPass');
pos31 =  marker('pos31', 'IdentityPass');
posScrapH =  marker('posScrapH', 'IdentityPass');
posScrapB =  marker('posScrapB', 'IdentityPass');
posScrapT =  marker('posScrapT', 'IdentityPass');
INJ = aperture('INJ',[-0.03 0.03 -0.004 0.004],'AperturePass');



% DRIFT SPACES [meters]
CM2CL = 2.8326955;
L1  = drift('L1',   CM2CL,        'DriftPass');
L1a = drift('L1a',  CM2CL-0.2030/2, 'DriftPass');


% Straight 1
% L27 L1


% Straight 2
% COR L27e1 IDBPM L27f1 L1e2 IDBPM L1f2 COR
L27e1 = drift('L27e1', CM2CL-2.4142-0.2030/2, 'DriftPass');
L27f1 = drift('L27f1',       2.4142, 'DriftPass');        %L27f1 = drift('L27f1',  2.4142+.000451, 'DriftPass');

%L1e2  = drift('L1e2',       2.5982, 'DriftPass');        %L1e2  = drift('L1e2',   2.5982-.000451, 'DriftPass');
CLtoKicker = 1.6470955; 
L1e2u  = drift('L1e2u', CLtoKicker, 'DriftPass');         %L1e2  = drift('L1e2',   2.5982-.000451, 'DriftPass');
L1e2d  = drift('L1e2d', 2.5982-CLtoKicker, 'DriftPass');  %L1e2  = drift('L1e2',   2.5982-.000451, 'DriftPass');
L1f2  = drift('L1f2',  CM2CL-2.5982-0.2030/2, 'DriftPass');


% Straight 3
% COR L27 L1 COR L2 BPM L3 QF L4 COR L5 QD  ...

%  Scraper Half-Straight
%L27a = drift('L27a',  0.8596, 'DriftPass');
%L27b = drift('L27b',  0.1524, 'DriftPass');
%L27c = drift('L27c',  0.04445, 'DriftPass');
%L27d = drift('L27d',  1.776246, 'DriftPass');
%L27s = [L27a posScrapH L27b posScrapB L27c posScrapT L27d];


% Straight 4
% Note: base lattice is made without the chicanes on
% COR L27s4a CHIC L27s4b IDBPM L27s4c L1s4a IDBPM L1s4b CHIC COR L1s4c IDBPM L1s4d IDBPM L1s4e CHIC L1s4f COR
ID4CL2Chicane1 = 2.44006 - .13269;
ID4CL2Chicane2 = .13269;
ID4CL2Chicane3 = 2.38557 + .13269;
ID4CL2IDBPM1 = 2.34504*cos(1.25e-3) - .13269;
ID4CL2IDBPM3 = .13269 - .095*cos(1.25e-3);
ID4CL2IDBPM4 = .13269 + .095*cos(1.25e-3);
ID4CL2IDBPM2 =  2.29056*cos(1.25e-3) + .13269;

L27s4a = drift('L27s4a', CM2CL - ID4CL2Chicane1-0.2030/2,        'DriftPass');
L27s4b = drift('L27s4b', ID4CL2Chicane1 - ID4CL2IDBPM1, 'DriftPass');
L27s4c = drift('L27s4c', ID4CL2IDBPM1,                  'DriftPass');
L1s4a  = drift('L1s4a',  ID4CL2IDBPM3,                  'DriftPass');
L1s4b  = drift('L1s4b',  ID4CL2Chicane2-ID4CL2IDBPM3,   'DriftPass');
L1s4c  = drift('L1s4c',  ID4CL2IDBPM4-ID4CL2Chicane2,   'DriftPass'); 
L1s4d  = drift('L1s4d',  ID4CL2IDBPM2-ID4CL2IDBPM4,     'DriftPass');
L1s4e  = drift('L1s4e',  ID4CL2Chicane3-ID4CL2IDBPM2,   'DriftPass');
L1s4f  = drift('L1s4f',  CM2CL - ID4CL2Chicane3-0.2030/2,        'DriftPass');


% Straight 5
L27e4 = drift('L27e4', CM2CL-2.3912-0.2030/2, 'DriftPass');
L27f4 = drift('L27f4',       2.3912, 'DriftPass');
L1e5  = drift('L1e5',        2.6032, 'DriftPass');
L1f5  = drift('L1f5',  CM2CL-2.6032-0.2030/2, 'DriftPass');


% Straight 6
% Note: base lattice is made without the chicanes on
% COR L27s6a CHIC L27s6b IDBPM L27s6c L1s6a IDBPM L1s6b CHIC COR L1s6c IDBPM L1s6d IDBPM L1s6e CHIC L1s6f COR
ID6CL2Chicane1 = 2.44006 - .13268;
ID6CL2Chicane2 = .13268;
ID6CL2Chicane3 = 2.38557 + .13268;
ID6CL2IDBPM1 = 2.34504*cos(1.13e-3) - .13268;
ID6CL2IDBPM3 = .13268 - .103*cos(1.13e-3);
ID6CL2IDBPM4 = .13268 + .103*cos(1.13e-3);
ID6CL2IDBPM2 =  2.29056*cos(1.13e-3) + .13268;

L27s6a = drift('L27s6a', CM2CL - ID6CL2Chicane1-0.2030/2,        'DriftPass');
L27s6b = drift('L27s6b', ID6CL2Chicane1 - ID6CL2IDBPM1, 'DriftPass');
L27s6c = drift('L27s6c', ID6CL2IDBPM1,                  'DriftPass');
L1s6a  = drift('L1s6a',  ID6CL2IDBPM3,                  'DriftPass');
L1s6b  = drift('L1s6b',  ID6CL2Chicane2-ID6CL2IDBPM3,   'DriftPass');
L1s6c  = drift('L1s6c',  ID6CL2IDBPM4-ID6CL2Chicane2,   'DriftPass'); 
L1s6d  = drift('L1s6d',  ID6CL2IDBPM2-ID6CL2IDBPM4,     'DriftPass');
%L1s6e  = drift('L1s6e',  CM2CL-ID6CL2IDBPM2,            'DriftPass');
L1s6e  = drift('L1s6e',  ID6CL2Chicane3-ID6CL2IDBPM2,   'DriftPass');
L1s6f  = drift('L1s6f',  CM2CL - ID6CL2Chicane3-0.2030/2,        'DriftPass');

% Straight 7
% COR L27e6 IDBPM L27f6 L1e7 IDBPM L1f7 COR
L27e6 = drift('L27e6', CM2CL-2.3932-0.2030/2, 'DriftPass');
L27f6 = drift('L27f6',       2.3932, 'DriftPass');
L1e7  = drift('L1e7',        2.6012, 'DriftPass');
L1f7  = drift('L1f7',  CM2CL-2.6012-0.2030/2, 'DriftPass');


% Straight 8
L27e7 = drift('L27e7', CM2CL-2.3907-0.2030/2, 'DriftPass');
L27f7 = drift('L27f7',       2.3907, 'DriftPass');
L1e8  = drift('L1e8',        2.5972, 'DriftPass');
L1f8  = drift('L1f8',  CM2CL-2.5972-0.2030/2, 'DriftPass');


% Straight 9
L27e8 = drift('L27e8', CM2CL-2.3912-0.2030/2, 'DriftPass');
L27f8 = drift('L27f8',       2.3912, 'DriftPass');
L1e9  = drift('L1e9',        2.5992, 'DriftPass');
L1f9  = drift('L1f9',  CM2CL-2.5992-0.2030/2, 'DriftPass');


% Straight 10
% COR L27e9 IDBPM L27f9 L1e10 IDBPM L1f10 COR
L27e9 = drift('L27e9', CM2CL-2.3902-0.2030/2, 'DriftPass');
L27f9 = drift('L27f9',       2.3902, 'DriftPass');
L1e10 = drift('L1e10',       2.5982, 'DriftPass');
L1f10 = drift('L1f10', CM2CL-2.5982-0.2030/2, 'DriftPass');


% Straight 11
% Note: base lattice is made without the chicanes on
% COR L27s11a IDBPM L27s11c L1s11a IDBPM L1s11b CHIC COR L1s11c IDBPM L1s11d IDBPM L1s11e  COR
ID11CL2Chicane2 = .13268;
ID11CL2IDBPM1 = 2.34504*cos(1.13e-3) - .13268;
ID11CL2IDBPM3 = .13268 - .095*cos(1.13e-3);
ID11CL2IDBPM4 = .13268 + .095*cos(1.13e-3);
ID11CL2IDBPM2 =  2.29056*cos(1.13e-3) + .13268;

L27s11a = drift('L27s11a', CM2CL - ID11CL2IDBPM1-0.2030/2,         'DriftPass');
L27s11c = drift('L27s11c', ID11CL2IDBPM1,                 'DriftPass');
L1s11a  = drift('L1s11a',  ID11CL2IDBPM3,                 'DriftPass');
L1s11b  = drift('L1s11b',  ID11CL2Chicane2-ID11CL2IDBPM3, 'DriftPass');
L1s11c  = drift('L1s11c',  ID11CL2IDBPM4-ID11CL2Chicane2, 'DriftPass'); 
L1s11d  = drift('L1s11d',  ID11CL2IDBPM2-ID11CL2IDBPM4,   'DriftPass');
L1s11e  = drift('L1s11e',  CM2CL-ID11CL2IDBPM2-0.2030/2,           'DriftPass');


% Straight 12
L27e11 = drift('L27e11', CM2CL-2.3902-0.2030/2, 'DriftPass');
L27f11 = drift('L27f11',       2.3902, 'DriftPass');
L1e12  = drift('L1e12',        2.6012, 'DriftPass');
L1f12  = drift('L1f12',  CM2CL-2.6012-0.2030/2, 'DriftPass');


% Arc sector lengths
L2  = drift('L2',   0.45698,   'DriftPass');
L2a = drift('L2a',  0.45698-0.2030/2, 'DriftPass');
L3  = drift('L3',   0.08902,   'DriftPass');
L4  = drift('L4',   0.2155,    'DriftPass');
L4a = drift('L4a',  0.2155-0.2030/2, 'DriftPass');
L5  = drift('L5',   0.219,     'DriftPass');
L5a = drift('L5a',  0.219-0.2030/2, 'DriftPass');
L6  = drift('L6',   0.107078,  'DriftPass');
L7  = drift('L7',   0.105716,  'DriftPass');
L8  = drift('L8',   0.135904,  'DriftPass');
L9  = drift('L9',   0.2156993, 'DriftPass');
L10 = drift('L10',  0.089084,  'DriftPass');
L11 = drift('L11',  0.235416,  'DriftPass');
L12 = drift('L12',  0.1245,    'DriftPass');
L13 = drift('L13',  0.511844,  'DriftPass');
L14 = drift('L14',  0.1788541, 'DriftPass');
L15 = drift('L15',  0.1788483, 'DriftPass');
L16 = drift('L16',  0.511849,  'DriftPass');
L17 = drift('L17',  0.1245,    'DriftPass');
L18 = drift('L18',  0.235405,  'DriftPass');
L19 = drift('L19',  0.089095,  'DriftPass');
L20 = drift('L20',  0.2157007, 'DriftPass');
L21 = drift('L21',  0.177716,  'DriftPass');
L22 = drift('L22',  0.170981,  'DriftPass');
L23 = drift('L23',  0.218997,  'DriftPass');
L23a = drift('L23a',  0.218997-0.2030/2, 'DriftPass');
L24 = drift('L24',  0.215503,  'DriftPass');
L24a = drift('L24a',  0.215503-0.2030/2, 'DriftPass');
L25 = drift('L25',  0.0890187, 'DriftPass');
L26 = drift('L26',  0.45698,   'DriftPass');
L26a = drift('L26a',  0.45698-0.2030/2,   'DriftPass');
L27 = drift('L27',  CM2CL,     'DriftPass');
L27a = drift('L27a',  CM2CL-0.2030/2, 'DriftPass');


DS = drift('DS', 0.1015, 'DriftPass');
LS1 = drift('LS1', 0.23, 'DriftPass');
%  LS1 = drift('LS1', 0.229768, 'DriftPass');
LS2 = drift('LS2', 0.095076, 'DriftPass');
LS3 = drift('LS3', 0.484594, 'DriftPass');
LS4 = drift('LS4', 0.484594, 'DriftPass');
LS5 = drift('LS5', 0.095076, 'DriftPass');



% Begin Lattice

%  Superperiods
SUP1  = [  L1a SHFF SHFF L2a BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27e1 IDBPM L27f1];
SUP2  = [  L1e2u FASTKICKER L1e2d IDBPM L1f2 SHFF COR SHFF L2a ...
    BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF  COR SHFF L27a];
SUP3  = [  L1a SHFF COR SHFF L2a BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27s4a CHIC L27s4b IDBPM L27s4c ];
SUP4  = [L1s4a IDBPM L1s4b CHIC COR L1s4c IDBPM L1s4d ...
    IDBPM L1s4e CHIC L1s4f SHFF COR SHFF L2a BPM L3 QF L4a ...
    SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BBPM  ...
    LS3 BS LS3 BBPM LS2 QDA LS1  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27e4 IDBPM L27f4];
SUP5  = [  L1e5 IDBPM L1f5 SHFF COR SHFF L2a BPM L3 QF L4a ...
    SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27s6a CHIC L27s6b IDBPM L27s6c ];
SUP6  = [L1s6a IDBPM L1s6b CHIC COR L1s6c IDBPM L1s6d ...
    IDBPM L1s6e CHIC L1s6f SHFF COR SHFF L2a BPM L3 QF L4a ...
    SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF  COR SHFF L27e6 IDBPM L27f6];
SUP7  = [  L1e7 IDBPM L1f7 SHFF COR SHFF L2a ...
    BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27e7 IDBPM L27f7];
SUP8  = [  L1e8 IDBPM L1f8 SHFF COR SHFF L2a ...
    BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BBPM  ...
    LS3 BS LS3 BBPM LS2 QDA LS1  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27e8 IDBPM L27f8 ];
SUP9  = [  L1e9 IDBPM L1f9 SHFF COR SHFF L2a ...
    BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27e9 IDBPM L27f9];
SUP10 = [  L1e10 IDBPM L1f10 SHFF COR SHFF L2a ...
    BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF COR SHFF L27s11a  IDBPM L27s11c ];
SUP11 = [L1s11a IDBPM L1s11b CHIC COR L1s11c IDBPM ...
    L1s11d IDBPM L1s11e SHFF COR SHFF L2a BPM L3 ...
    QF L4a SHDD COR SHDD L5a QD  ... 
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
    L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF  COR SHFF L27e11 IDBPM L27f11];
SUP12 = [ L1e12 IDBPM L1f12 SHFF COR SHFF L2a ...
    BPM L3 QF L4a SHDD COR SHDD L5a QD  ...
    L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ...
    BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BBPM  ...
    LS3 BS LS3 BBPM LS2 QDA LS1  SFF COR SFF  L17  ...
    QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ...
    BPM L22 QD L23a SHDD COR SHDD L24a QF L25  ...
    BPM L26a SHFF SHFF L27a ];

ELIST = [INJ SECT1 SUP1 SECT2 SUP2 SECT3 CAV SUP3 SECT4 SUP4 SECT5 SUP5 SECT6 SUP6 ...
             SECT7 SUP7 SECT8 SUP8 SECT9 SUP9 SECT10 SUP10 SECT11 SUP11 SECT12 SUP12 FIN];


buildlat(ELIST);


% Superbend tweaks
QFI = findcells(THERING,'FamName','QF');
THERING = setcellstruct(THERING,'K',QFI([7:8 15:16 23:24]),2.321090);
THERING = setcellstruct(THERING,'PolynomB',QFI([7:8 15:16 23:24]),2.321090,2);
QDI = findcells(THERING,'FamName','QD');
THERING = setcellstruct(THERING,'K',QDI([7:8 15:16 23:24]),-2.561542);
THERING = setcellstruct(THERING,'PolynomB',QDI([7:8 15:16 23:24]),-2.561542,2);
QFAI = findcells(THERING,'FamName','QFA');
THERING = setcellstruct(THERING,'K',QFAI([7:8 15:16 23:24]),3.250126);
THERING = setcellstruct(THERING,'PolynomB',QFAI([7:8 15:16 23:24]),3.250126,2);
%% set the SB sextupole component strengths
BSI = findcells(THERING,'FamName','BS');
THERING = setcellstruct(THERING,'PolynomB',BSI,-22.68,3);


% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
% L0_tot=0;
% for i=1:length(THERING)
%     L0_tot=L0_tot+THERING{i}.Length;
% end
fprintf('   L0 = %.6f m   (should be 196.805415 m)\n', L0_tot)
fprintf('   RF = %.6f MHz (should be 499.640349 Hz)\n', HarmNumber*C0/L0_tot/1e6)


% Compute initial tunes before loading errors
%[InitialTunes, InitialChro]= tunechrom(THERING,0,[14.25, 8.2],'chrom','coupling');
% fprintf('Tunes and chromaticities might be slightly incorrect if synchrotron radiation and cavity are on\n');
% fprintf('Tunes: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
% fprintf('Chromaticities: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);
[td,tune]= linopt(THERING,0);
%tune
    



 % (0.14 0.25) detune 0.03, 2.062 nm
 KQDS1 =                                    -2.582593E+00;   
 KQFS1 =                                     2.309003E+00;    
 KQDAS1=                                    -5.994659E-01;   
 KQFAS1=                                     3.281174E+00;   
 KQD   =                                    -2.670210E+00;   
 KQF   =                                     2.303646E+00;    
 KQFA  =                                     3.220175E+00;   

 % % (0.14 0.25) detune 0.035, 2.062 nm
 
 KQDS1 =                                    -2.585599E+00;    
 KQFS1 =                                     2.317250E+00;   
 KQDAS1=                                    -5.646058E-01;   
 KQFAS1=                                     3.270105E+00;    
 KQD   =                                    -2.670292E+00;   
 KQF   =                                     2.303418E+00;    
 KQFA  =                                     3.218269E+00;   
 

 
QFnom=KQF*ones(24,1);
QFnom([7 8 15 16 23 24])=KQFS1;

QDnom=KQD*ones(24,1);
QDnom([7 8 15 16 23 24])=KQDS1;

QFAnom=KQFA*ones(24,1);
QFAnom([7 8 15 16 23 24])=KQFAS1;

QDAnom=KQDAS1*ones(6,1);




QFI = findcells(THERING,'FamName','QF');
THERING = setcellstruct(THERING,'K',QFI,QFnom);
THERING = setcellstruct(THERING,'PolynomB',QFI,QFnom,2);

QDI = findcells(THERING,'FamName','QD');
THERING = setcellstruct(THERING,'K',QDI,QDnom);
THERING = setcellstruct(THERING,'PolynomB',QDI,QDnom,2);

QFAI = findcells(THERING,'FamName','QFA');
THERING = setcellstruct(THERING,'K',QFAI,QFAnom);
THERING = setcellstruct(THERING,'PolynomB',QFAI,QFAnom,2);

QDAI = findcells(THERING,'FamName','QDA');
THERING = setcellstruct(THERING,'K',QDAI,QDAnom);
THERING = setcellstruct(THERING,'PolynomB',QDAI,QDAnom,2);






%setcavity off;
%setradiation off;


clear global FAMLIST
%clear global GLOBVAL when GWig... has been changed.

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');


%evalin('caller','global THERING GLOBVAL');
%evalin('base','global THERING GLOBVAL');

