function varargout = als_loco_3sb_disp(varargin)
% Lattice definition file
% Compiled by Christoph Steier from the ALS TRACY 
% lattice file of Nishimura/Robin/Steier 04/20/2000 
%
% ALS production lattice with Superbends, quadrupole families, one bend family,
% two sextupole families, BPMs as markers, no correctors, 
% eta_x(straight sections) = 6cm.

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 1.9e9;
GLOBVAL.LatticeFile = 'als_loco_3sb_disp';
FAMLIST = cell(0);

disp('   Loading ALS lattice in alslat_loco_3sb_disp.m');

AP =  aperture('AP',  [-0.1, 0.1, -0.1, 0.1], 'AperturePass');

L0 = 196.8054150;            	% design length [m]
C0 =   299792458; 				% speed of light [m/s]

%%% RF SYSTEM 

	HarmNumber = 328;
	CAV	= rfcavity('CAV1' , 0 , 1.5e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   

%%% CORRECTORS and BPMS

	COR =  corrector('COR',0.0,[0 0],'CorrectorPass');
	CHIC = corrector('COR',0.0,[0 0],'CorrectorPass');
	BPM =  marker('BPM','IdentityPass');
	IDBPM =  marker('BPM','IdentityPass');
	BBPM = marker('BPM','IdentityPass');

%% MARKERS and APERTURES

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

% DRIFT SPACES
%    L1 = drift('L1',  2.832695, 'DriftPass');
%    L2 = drift('L2',  0.45698, 'DriftPass');
%    L3 = drift('L3',  0.08902, 'DriftPass');
%    L4 = drift('L4',  0.2155, 'DriftPass');
%    L5 = drift('L5',  0.219, 'DriftPass');
%    L6 = drift('L6',  0.107078, 'DriftPass');
%    L7 = drift('L7',  0.105716, 'DriftPass');
%    L8 = drift('L8',  0.135904, 'DriftPass');
%    L9 = drift('L9',  0.2156993, 'DriftPass');
%    L10 = drift('L10',  0.089084, 'DriftPass');
%    L11 = drift('L11',  0.235416, 'DriftPass');
%    L12 = drift('L12',  0.1245, 'DriftPass');
%    L13 = drift('L13',  0.511844, 'DriftPass');
%    L14 = drift('L14',  0.1788541, 'DriftPass');
%    L15 = drift('L15',  0.1788483, 'DriftPass');
%    L16 = drift('L16',  0.511849, 'DriftPass');
%    L17 = drift('L17',  0.1245, 'DriftPass');
%    L18 = drift('L18',  0.235405, 'DriftPass');
%    L19 = drift('L19',  0.089095, 'DriftPass');
%    L20 = drift('L20',  0.2157007, 'DriftPass');
%    L21 = drift('L21',  0.177716, 'DriftPass');
%    L22 = drift('L22',  0.170981, 'DriftPass');
%    L23 = drift('L23',  0.218997, 'DriftPass');
%    L24 = drift('L24',  0.215503, 'DriftPass');
%    L25 = drift('L25',  0.0890187, 'DriftPass');
%    L26 = drift('L26',  0.45698, 'DriftPass');
%    L27 = drift('L27',  2.832696, 'DriftPass');
%    L27a = drift('L27a',  0.8596, 'DriftPass');
%    L27b = drift('L27b',  0.1524, 'DriftPass');
%    L27c = drift('L27c',  0.04445, 'DriftPass');
%    L27d = drift('L27d',  1.776246, 'DriftPass');
%    DS = drift('DS', 0.1015, 'DriftPass');
%    LS1 = drift('LS1', 0.2300, 'DriftPass');
%    LS2 = drift('LS2', 0.094844, 'DriftPass');
%    LS3 = drift('LS3', 0.484826, 'DriftPass');

% DRIFT SPACES
   L1  = drift('L1',   2.832695,        'DriftPass'); 
%  L1e = drift('L1e',  2.6014,          'DriftPass');
%  L1f = drift('L1f',  2.832695-2.6014, 'DriftPass'); 
   L1e2 = drift('L1e2',  2.5982,          'DriftPass');
   L1f2 = drift('L1f2',  2.832695-2.5982, 'DriftPass'); 
   L1g4 = drift('L1g4',  2.15791,         'DriftPass'); %from drawing (chicane angle trig not included)
   L1h4 = drift('L1h4',  0.2, 'DriftPass');             %just a guess for now
%  L1i4 = L1 + L27 - L27e3 - L27i3 - L27j3 - L27k3 - L1g4 - L1h4
   L1i4 = drift('L1i4',  2.832695+2.832696-(2.832696-2.2127)-2.25003-0.11385-0.11385-2.15791-0.2,          'DriftPass');
   L1f4 = drift('L1f4',  2.832695-2.4257, 'DriftPass'); 
   L1e4 = drift('L1e4',  2.4257,          'DriftPass');
   L1e5 = drift('L1e5',  2.6032,          'DriftPass');
   L1f5 = drift('L1f5',  2.832695-2.6032, 'DriftPass'); 
   L1e6 = drift('L1e6',  2.5992,          'DriftPass');
   L1f6 = drift('L1f6',  2.832695-2.5992, 'DriftPass'); 
   L1e7 = drift('L1e7',  2.6012,          'DriftPass');
   L1f7 = drift('L1f7',  2.832695-2.6012, 'DriftPass'); 
   L1e8 = drift('L1e8',  2.5972,          'DriftPass');
   L1f8 = drift('L1f8',  2.832695-2.5972, 'DriftPass'); 
   L1e9 = drift('L1e9',  2.5992,          'DriftPass');
   L1f9 = drift('L1f9',  2.832695-2.5992, 'DriftPass'); 
   L1e10 = drift('L1e10',  2.5982,          'DriftPass');
   L1f10 = drift('L1f10',  2.832695-2.5982, 'DriftPass'); 
   L1e11 = drift('L1e11',  2.4232,          'DriftPass');
   L1f11 = drift('L1f11',  2.832695-2.4232, 'DriftPass'); 
   L1e12 = drift('L1e12',  2.6012,          'DriftPass');
   L1f12 = drift('L1f12',  2.832695-2.6012, 'DriftPass'); 
   
   L2 = drift('L2',  0.45698, 'DriftPass');
   L3 = drift('L3',  0.08902, 'DriftPass');
   L4 = drift('L4',  0.2155, 'DriftPass');
   L5 = drift('L5',  0.219, 'DriftPass');
   L6 = drift('L6',  0.107078, 'DriftPass');
   L7 = drift('L7',  0.105716, 'DriftPass');
   L8 = drift('L8',  0.135904, 'DriftPass');
   L9 = drift('L9',  0.2156993, 'DriftPass');
   L10 = drift('L10',  0.089084, 'DriftPass');
   L11 = drift('L11',  0.235416, 'DriftPass');
   L12 = drift('L12',  0.1245, 'DriftPass');
   L13 = drift('L13',  0.511844, 'DriftPass');
   L14 = drift('L14',  0.1788541, 'DriftPass');
   L15 = drift('L15',  0.1788483, 'DriftPass');
   L16 = drift('L16',  0.511849, 'DriftPass');
   L17 = drift('L17',  0.1245, 'DriftPass');
   L18 = drift('L18',  0.235405, 'DriftPass');
   L19 = drift('L19',  0.089095, 'DriftPass');
   L20 = drift('L20',  0.2157007, 'DriftPass');
   L21 = drift('L21',  0.177716, 'DriftPass');
   L22 = drift('L22',  0.170981, 'DriftPass');
   L23 = drift('L23',  0.218997, 'DriftPass');
   L24 = drift('L24',  0.215503, 'DriftPass');
   L25 = drift('L25',  0.0890187, 'DriftPass');
   L26 = drift('L26',  0.45698, 'DriftPass');
   L27 = drift('L27',  2.832696, 'DriftPass');
   L27a = drift('L27a',  0.8596, 'DriftPass');
   L27b = drift('L27b',  0.1524, 'DriftPass');
   L27c = drift('L27c',  0.04445, 'DriftPass');
   L27d = drift('L27d',  1.776246, 'DriftPass');
   
%  L27e = drift('L27e',  2.832696-2.3906, 'DriftPass');
%  L27f = drift('L27f',  2.3906, 'DriftPass');
   L27e1 = drift('L27e1',  2.832696-2.4142, 'DriftPass');
   L27f1 = drift('L27f1',  2.4142, 'DriftPass');
   L27e3 = drift('L27e3',  2.832696-2.2127, 'DriftPass');
	L27f3 = drift('L27f3',  2.2127, 'DriftPass');
%  L27e3 = L27g3 + CHIC +L27h3
	L27g3 = drift('L27g3',  2.832696-2.2127-0.2, 'DriftPass');
	L27h3 = drift('L27h3',  0.2, 'DriftPass');     %just a guess for now
	L27i3 = drift('L27i3',  2.25003, 'DriftPass'); %from drawing (chicane angle trig not included)
	L27j3 = drift('L27j3',  0.11385, 'DriftPass'); %from drawing (chicane angle trig not included)
	L27k3 = drift('L27k3',  0.11385, 'DriftPass'); %from drawing (chicane angle trig not included)
   L27e4 = drift('L27e4',  2.832696-2.3912, 'DriftPass');
   L27f4 = drift('L27f4',  2.3912, 'DriftPass');
   L27e5 = drift('L27e5',  2.832696-2.3887, 'DriftPass');
   L27f5 = drift('L27f5',  2.3887, 'DriftPass');
   L27e6 = drift('L27e6',  2.832696-2.3932, 'DriftPass');
   L27f6 = drift('L27f6',  2.3932, 'DriftPass');
   L27e7 = drift('L27e7',  2.832696-2.3907, 'DriftPass');
   L27f7 = drift('L27f7',  2.3907, 'DriftPass');
   L27e8 = drift('L27e8',  2.832696-2.3912, 'DriftPass');
   L27f8 = drift('L27f8',  2.3912, 'DriftPass');
   L27e9 = drift('L27e9',  2.832696-2.3902, 'DriftPass');
   L27f9 = drift('L27f9',  2.3902, 'DriftPass');
   L27e10 = drift('L27e10',  2.832696-2.2152, 'DriftPass');
   L27f10 = drift('L27f10',  2.2152, 'DriftPass');
   L27e11 = drift('L27e11',  2.832696-2.3902, 'DriftPass');
   L27f11 = drift('L27f11',  2.3902, 'DriftPass');
   
   DS = drift('DS', 0.1015, 'DriftPass');
   LS1 = drift('LS1', 0.23, 'DriftPass');
%  LS1 = drift('LS1', 0.229768, 'DriftPass');
   LS2 = drift('LS2', 0.095076, 'DriftPass');
   LS3 = drift('LS3', 0.484594, 'DriftPass');
   LS4 = drift('LS4', 0.484594, 'DriftPass');
   LS5 = drift('LS5', 0.095076, 'DriftPass');


% QUADRUPOLES 

QF		=	quadrupole('QF'  , 0.344, 2.213483 ,'StrMPoleSymplectic4RadPass');
QD		=	quadrupole('QD'  , 0.187, -2.356502 ,'StrMPoleSymplectic4RadPass');
QFA		=	quadrupole('QFA'  , 0.448, 2.954337 ,'StrMPoleSymplectic4RadPass');
QDA		=	quadrupole('QDA'  , 0.187, -1.783113 ,'StrMPoleSymplectic4RadPass');

% SEXTUPOLES for xix=0.4 and xi_y=1.4
% -52.246310 74.801936 w/o sextu in superbend
% -52.03     75.05     w/  sextu in superbend
SDD   =  sextupole('SDD', 0.2030/2, -52.0333, 'StrMPoleSymplectic4RadPass');
SFF   =  sextupole('SFF', 0.2030/2,  75.0479, 'StrMPoleSymplectic4RadPass');


% DIPOLES (COMBINED FUNCTION)
% K1= -0.7782 for 5 degrees instead of -0.81 for 3 degrees entrance/exit angle
BEND  =  rbend('BEND'  , 0.86514,  ...
            0.1745329, 0.0872665, 0.0872665, -0.7782,'BndMPoleSymplectic4RadPass');

% SUPERBEND L=255 mm for SBM1 and 254 mm for SBM3 and 4 (cf. field clamps) 
BS    =  rbend('BS', 0.255, ...
            0.1745329, 0.0872665, 0.0872665, 0,'BndMPoleSymplectic4RadPass');
         
% Begin Lattice

%%  Scraper Half-Straight  

L27s = [L27a posScrapH L27b posScrapB L27c posScrapT L27d];

%%  Superperiods  

SUP1  = [  L1 L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27e1 IDBPM L27f1];
SUP2  = [  L1e2 IDBPM L1f2 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27];
SUP3  = [  L1 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26 COR L27e3 IDBPM L27f3 IDBPM IDBPM];
%SUP3  = [  L1 COR L2 BPM L3 QF L4 COR L5 QD  ...
%           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
%           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
%           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%           BPM L22 QD L23 COR L24 QF L25  ...
%           BPM L26 COR L27g3 CHIC L27h3 IDBPM L27i3 IDBPM L27j3 CHIC L27k3 IDBPM];
%SUP4S = [  L1g4 IDBPM L1h4 CHIC L1i4 COR L2 BPM L3 QF L4 COR L5 QD  ...
%           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%           BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BBPM  ...
%           LS3 BS LS3 BBPM LS2 QDA LS1  SFF COR SFF  L17  ...
%           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%           BPM L22 QD L23 COR L24 QF L25  ...
%           BPM L26 COR L27e4 IDBPM L27f4 ];
SUP4S = [  L1e4 IDBPM L1f4 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BBPM  ...
           LS3 BS LS3 BBPM LS2 QDA LS1  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26 COR L27e4 IDBPM L27f4 ];
SUP5  = [  L1e5 IDBPM L1f5 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27e5 IDBPM L27f5];
SUP6  = [  L1e6 IDBPM L1f6 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27e6 IDBPM L27f6];
SUP7  = [  L1e7 IDBPM L1f7 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27e7 IDBPM L27f7];
SUP8S = [  L1e8 IDBPM L1f8 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BBPM  ...
           LS3 BS LS3 BBPM LS2 QDA LS1  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26 COR L27e8 IDBPM L27f8 ];
SUP9  = [  L1e9 IDBPM L1f9 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27e9 IDBPM L27f9];
SUP10 = [  L1e10 IDBPM L1f10 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27e10 IDBPM L27f10 IDBPM IDBPM];
SUP11 = [  L1e11 IDBPM L1f11 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF L13 BBPM  ...
           L14 BEND L15 BBPM L16  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26  COR L27e11 IDBPM L27f11];
SUP12S = [ L1e12 IDBPM L1f12 COR L2 BPM L3 QF L4 COR L5 QD  ...
           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
           BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BBPM  ...
           LS3 BS LS3 BBPM LS2 QDA LS1  SFF COR SFF  L17  ...
           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
           BPM L22 QD L23 COR L24 QF L25  ...
           BPM L26 L27 ];

% Individualized all 12 sectors on 6-1-04 to add IDBPM, BBPM s-positions
% 		- Previous superperiod and superbend-superperiod below
%
% SUP   = [  L1e IDBPM L1f COR L2 BPM L3 QF L4 COR L5 QD  ...
%           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%           BPM L11 QFA L12  SFF COR SFF L13 BPM  ...
%           L14 BEND L15 BPM L16  SFF COR SFF  L17  ...
%           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%           BPM L22 QD L23 COR L24 QF L25  ...
%           BPM L26  COR L27e IDBPM L27f];
% SUPS  = [  L1e IDBPM L1f COR L2 BPM L3 QF L4 COR L5 QD  ...
%           L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%           BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BPM  ...
%           LS3 BS LS3 BPM LS2 QDA LS1  SFF COR SFF  L17  ...
%           QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%           BPM L22 QD L23 COR L24 QF L25  ...
%           BPM L26 COR L27e IDBPM L27f ];
           
ELIST = [INJ SECT1 SUP1 SECT2 SUP2 SECT3 CAV SUP3 SECT4 SUP4S SECT5 SUP5 SECT6 SUP6 ...
	SECT7 SUP7 SECT8 SUP8S SECT9 SUP9 SECT10 SUP10 SECT11 SUP11 SECT12 SUP12S FIN];

% SUP  = [   L1 COR L2 BPM L3 QF L4 COR L5 QD  ...
%            L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%            BPM L11 QFA L12  SFF COR SFF L13 BPM  ...
%            L14 BEND L15 BPM L16  SFF COR SFF  L17  ...
%            QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%            BPM L22 QD L23 COR L24 QF L25  ...
%            BPM L26  COR L27 ];
% SUP1  = [   L1 L2 BPM L3 QF L4 COR L5 QD  ...
%            L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%            BPM L11 QFA L12  SFF COR SFF L13 BPM  ...
%            L14 BEND L15 BPM L16  SFF COR SFF  L17  ...
%            QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%            BPM L22 QD L23 COR L24 QF L25  ...
%            BPM L26  COR L27 ];
% SUPS  = [   L1 COR L2 BPM L3 QF L4 COR L5 QD  ...
%            L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%            BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BPM  ...
%            LS3 BS LS3 BPM LS2 QDA LS1  SFF COR SFF  L17  ...
%            QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%            BPM L22 QD L23 COR L24 QF L25  ...
%            BPM L26 COR L27 ];
% SUP12S  = [   L1 COR L2 BPM L3 QF L4 COR L5 QD  ...
%            L6 BPM L7 L8 BEND L9 SDD COR SDD L10 ... 
%            BPM L11 QFA L12  SFF COR SFF LS1 QDA LS2 BPM  ...
%            LS3 BS LS3 BPM LS2 QDA LS1  SFF COR SFF  L17  ...
%            QFA L18 BPM L19  SDD COR SDD L20 BEND L21 ... 
%            BPM L22 QD L23 COR L24 QF L25  ...
%            BPM L26 L27 ];
%            
% ELIST = [INJ SECT1 SUP1 SECT2 SUP SECT3 CAV SUP SECT4 SUPS SECT5 SUP SECT6 SUP ...
% 	SECT7 SUP SECT8 SUPS SECT9 SUP SECT10 SUP SECT11 SUP SECT12 SUP12S FIN];

% THERING=cell(size(ELIST));
% for i=1:length(THERING)
%    THERING{i} = FAMLIST{ELIST(i)}.ElemData;
%    FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
%    FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
% end

buildlat(ELIST);

QFI = findcells(THERING,'FamName','QF');
THERING = setcellstruct(THERING,'K',QFI([7:8 15:16 23:24]),2.193814);
THERING = setcellstruct(THERING,'PolynomB',QFI([7:8 15:16 23:24]),2.193814,2);
QDI = findcells(THERING,'FamName','QD');
THERING = setcellstruct(THERING,'K',QDI([7:8 15:16 23:24]),-2.316357);
THERING = setcellstruct(THERING,'PolynomB',QDI([7:8 15:16 23:24]),-2.316357,2);
QFAI = findcells(THERING,'FamName','QFA');
THERING = setcellstruct(THERING,'K',QFAI([7:8 15:16 23:24]),3.121515);
THERING = setcellstruct(THERING,'PolynomB',QFAI([7:8 15:16 23:24]),3.121515,2);

BSI = findcells(THERING,'FamName','BS');
THERING = setcellstruct(THERING,'PolynomB',BSI,-22.68,3);



%% compute total length and RF frequency

L0_tot=0;
for i=1:length(THERING)
   L0_tot=L0_tot+THERING{i}.Length;
end

fprintf('   L0_tot=%.6f m (should be 196.805415 m) \n   f_RF=%.6f MHz (should be 499.640349 Hz)\n',L0_tot,HarmNumber*C0/L0_tot/1e6)

% Compute initial tunes before loading errors
% [InitialTunes, InitialChro]= tunechrom(THERING,0,[14.25, 8.2],'chrom','coupling');
% fprintf('Tunes and chromaticities might be slightly incorrect if synchrotron radiation and cavity are on\n');
% fprintf('Tunes: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
% fprintf('Chromaticities: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));

%evalin('caller','global THERING FAMLIST GLOBVAL');
%evalin('base','global THERING FAMLIST GLOBVAL');


clear FAMLIST
clear global FAMLIST
% clear global GLOBVAL when GWig... has been changed.

