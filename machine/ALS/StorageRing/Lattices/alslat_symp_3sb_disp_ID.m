function alslat_symp_3sb_disp_ID
% Lattice definition file
% Compiled by Christoph Steier from the ALS TRACY
% lattice file of Nishimura/Robin/Steier 04/20/2000
%
% ALS production lattice, quadrupole families, one bend family,
% two sextupole families, BPMs as markers, no correctors,
% eta_x  6cm.
%
% Modifications :
% Laurent Nadolski, August 2001
%
% correction for right path length
% correction for QDA length
% new effective SB length
% normal bend entrance/exit angle set to 5 degrees
% tunes to 14.25 8.2
% chromaticities to 0.4 1.4


global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 1.9e9;
GLOBVAL.LatticeFile = 'als_symp_3sb_disp_wig';
FAMLIST = cell(0);
disp(' ');
disp('** Loading ALS lattice in alslat_symp_3sb_disp_wig.m **');

AP =  aperture('AP',  [-0.1, 0.1, -0.1, 0.1], 'AperturePass');

L0 =  196.805415;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 328;

L_epu4 = 1.850;     % length of EPU in straight 4
L_wig  = 3.3060;    % length of wiggler
L_u6   = 1.50;      % length of undulator in straight 6
L_u7   = 4.450;     % length of undulator in straight 7

%% Cavity
%                   NAME    L     U[V]       f[Hz]            h     method
CAV	= rfcavity('CAV1' , 0 , 1.2e+6 , HarmNumber*C0/L0, HarmNumber,'ThinCavityPass');


%% Marker and apertures
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
BPM =  marker('BPM', 'IdentityPass');
INJ = aperture('INJ',[-0.03 0.03 -0.004 0.004],'AperturePass');

% DRIFT SPACES
L1 = drift('L1',  2.832695, 'DriftPass');
L1W = drift('L1',  2.832695-L_wig/2, 'DriftPass');
L1U7 = drift('L1',  2.832695-L_u7/2, 'DriftPass');


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

L27EPU = drift('L27',  2.832696/2-L_epu4/2, 'DriftPass');

L27W = drift('L27',  2.832696-L_wig/2, 'DriftPass');

L27U6 = drift('L27',  2.832696/2-L_u6/2, 'DriftPass');
L27U7 = drift('L27',  2.832696-L_u7/2, 'DriftPass');

L27a = drift('L27a',  0.8596, 'DriftPass');
L27b = drift('L27b',  0.1524, 'DriftPass');
L27c = drift('L27c',  0.04445, 'DriftPass');
L27d = drift('L27d',  1.776246, 'DriftPass');
DS = drift('DS', 0.1015, 'DriftPass');
LS1 = drift('LS1', 0.23, 'DriftPass');
%   LS1 = drift('LS1', 0.229768, 'DriftPass');
LS2 = drift('LS2', 0.095076, 'DriftPass');
LS3 = drift('LS3', 0.484594, 'DriftPass');
LS4 = drift('LS4', 0.484594, 'DriftPass');
LS5 = drift('LS5', 0.095076, 'DriftPass');


% QUADRUPOLES

% Values for low tune nuy=8.2
%QF   =  quadrupole('QF' , 0.344,  2.213482613545 ,'StrMPoleSymplectic4RadPass');
%QD   =  quadrupole('QD' , 0.187, -2.356501752011 ,'StrMPoleSymplectic4RadPass');
%QFA  =  quadrupole('QFA', 0.448,  2.954337148639 ,'StrMPoleSymplectic4RadPass');
%QDA  =  quadrupole('QDA', 0.187, -1.783113127857 ,'StrMPoleSymplectic4RadPass');

% Values for high tune nuy=9.2
QF		=	quadrupole('QF'  , 0.344, 2.237111 ,'StrMPoleSymplectic4RadPass');
QD		=	quadrupole('QD'  , 0.187, -2.511045 ,'StrMPoleSymplectic4RadPass');
QFA		=	quadrupole('QFA'  , 0.448,  2.954352,'StrMPoleSymplectic4RadPass');
QDA		=	quadrupole('QDA'  , 0.187,  -1.779475,'StrMPoleSymplectic4RadPass');

% SEXTUPOLES for xix=0.4 and xi_y=1.4
% -52.246310 74.801936 w/o sextu in superbend
% -52.03     75.05     w/  sextu in superbend
SD   =  sextupole('SD', 0.2030, -52.0333, 'StrMPoleSymplectic4RadPass');
SF   =  sextupole('SF', 0.2030,  75.0479, 'StrMPoleSymplectic4RadPass');


% DIPOLES (COMBINED FUNCTION)
% K1= -0.7782 for 5 degrees instead of -0.81 for 3 degrees entrance/exit angle
BEND  =  rbend('BEND'  , 0.86514,  ...
    0.1745329, 0.0872665, 0.0872665, -0.7782,'BndMPoleSymplectic4RadPass');

% Super bend L=255 mm for SBM1 and 254 mm for SBM3 and 4 (cf. field clamps)
BS    =  rbend('BS', 0.255, ...
    0.1745329, 0.0872665, 0.0872665, 0,'BndMPoleSymplectic4RadPass');


% Wiggler W11
%load 'wiggler_harmonics.mat'

%wiggler(fname, Ltot, Lw, Bmax, Nstep, Nmeth, By, Bx, method)

%  FamName	family name
%  Ltot		total length of the wiggle
%  Lw		total length of the wiggle
%  Bmax	 	peak wiggler field [Tesla]
%  Nstep	num of integration steps per period
%  Nmeth	symplectic integration method, 2nd or 4th order: 2 or 4
%  By		wiggler harmonics for horizontal wigglers
%  Bx		wiggler harmonics for vertical wigglers
%  method   name of the function to use for tracking

%fname  = 'W5';
%Ltot   = 3.3060;       % length of wiggler
%Lw     = 0.114;        % length of one wiggler period
%Bmax   = 1.8431;
%Nstep  = 4;
%Nmeth  = 2;
%By     = 0.114;
%Bx     = '';
%method = 'WigSymplectic4Pass';

%W5 = wiggler(fname, Ltot, Lw, Bmax, Nstep, Nmeth, By, Bx, method);
%W5 = drift('W5', 3.3060, 'DriftPass');
%W5 = wiggler('W5',3.3060,0.114,1.8431,4,2,0.114,'WigSymplectic4Pass');

%BEND('FAMILYNAME',  Length[m], BendingAngle[rad], EntranceAngle[rad],ExitAngle[rad], K, 'METHOD')


w5_switch = 0;

phiW5 = 0.007 * w5_switch;

WigB1=rbend('WigB1',0.0285, -phiW5, 0, -phiW5, 0,'BndMPoleSymplectic4RadPass');
WigB2=rbend('WigB2',0.0285, phiW5, phiW5, 0, 0,'BndMPoleSymplectic4RadPass');
WigB3=rbend('WigB3',0.0285, phiW5, 0, phiW5, 0,'BndMPoleSymplectic4RadPass');
WigB4=rbend('WigB4',0.0285, -phiW5, -phiW5, 0, 0,'BndMPoleSymplectic4RadPass');

WigPeriod = [WigB1 WigB2 WigB3 WigB4];

W5 = [ WigPeriod WigPeriod WigPeriod WigPeriod WigPeriod ...
    WigPeriod WigPeriod WigPeriod WigPeriod WigPeriod ...
    WigPeriod WigPeriod WigPeriod WigPeriod WigPeriod ...
    WigPeriod WigPeriod WigPeriod WigPeriod WigPeriod ...
    WigPeriod WigPeriod WigPeriod WigPeriod WigPeriod ...
    WigPeriod WigPeriod WigPeriod WigPeriod ];

% EPU 4/11-1/11-2

phiEPU4 = 0.07631641 * 0.0;

EPU4B1=rbend('EPU4B1',0.0125, phiEPU4, 0, 0, 0,'BndMPoleSymplectic4RadPass');
EPU4B2=rbend('EPU4B2',0.0125, phiEPU4, 0, 0, 0,'BndMPoleSymplectic4RadPass');
EPU4B3=rbend('EPU4B3',0.0125, phiEPU4, 0, 0, 0,'BndMPoleSymplectic4RadPass');
EPU4B4=rbend('EPU4B4',0.0125, phiEPU4, 0, 0, 0,'BndMPoleSymplectic4RadPass');

EPUPeriod = [EPU4B1 EPU4B2 EPU4B3 EPU4B4];

EPU4 = [ EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod ...
    EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod ...
    EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod ...
    EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod ...
    EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod ...
    EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod EPUPeriod ...
    EPUPeriod  ];


% U6

phiU6 = 0.02645469 * 0.0;

U6B1=rbend('U6B1',0.0075, phiU6, 0, 0, 0,'BndMPoleSymplectic4RadPass');
U6B2=rbend('U6B2',0.0075, phiU6, 0, 0, 0,'BndMPoleSymplectic4RadPass');
U6B3=rbend('U6B3',0.0075, phiU6, 0, 0, 0,'BndMPoleSymplectic4RadPass');
U6B4=rbend('U6B4',0.0075, phiU6, 0, 0, 0,'BndMPoleSymplectic4RadPass');

U6Period = [U6B1 U6B2 U6B3 U6B4];

U6 = [ U6Period U6Period U6Period U6Period U6Period U6Period U6Period ...
    U6Period U6Period U6Period U6Period U6Period U6Period U6Period ...
    U6Period U6Period U6Period U6Period U6Period U6Period U6Period ...
    U6Period U6Period U6Period U6Period U6Period U6Period U6Period ...
    U6Period U6Period U6Period U6Period U6Period U6Period U6Period ...
    U6Period U6Period U6Period U6Period U6Period U6Period U6Period ...
    U6Period U6Period U6Period U6Period U6Period U6Period U6Period ...
    U6Period  ];

% U7

phiU7 = 0.08450871 * 0.0;

U7B1=rbend('U7B1',0.0125, phiU7, 0, 0, 0,'BndMPoleSymplectic4RadPass');
U7B2=rbend('U7B2',0.0125, phiU7, 0, 0, 0,'BndMPoleSymplectic4RadPass');
U7B3=rbend('U7B3',0.0125, phiU7, 0, 0, 0,'BndMPoleSymplectic4RadPass');
U7B4=rbend('U7B4',0.0125, phiU7, 0, 0, 0,'BndMPoleSymplectic4RadPass');

U7Period = [U7B1 U7B2 U7B3 U7B4];

U7 = [ U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period U7Period U7Period ...
    U7Period U7Period U7Period U7Period U7Period  ];



% Begin Lattice

%%  Scraper Half-Straight

L27s = [L27a posScrapH L27b posScrapB L27c posScrapT L27d];

%%  Superperiods

SUP  = [   L1 L2 BPM L3 QF L4 L5 QD  ...
    L6 BPM L7 L8 BEND L9 SD L10 ...
    BPM L11 QFA L12  SF L13 BPM  ...
    L14 BEND L15 BPM L16  SF  L17  ...
    QFA L18 BPM L19  SD L20 BEND L21 ...
    BPM L22 QD L23  L24 QF L25  ...
    BPM L26  L27 ];

SUPEPU = [ L1 L2 BPM L3 QF L4 L5 QD  ...
    L6 BPM L7 L8 BEND L9 SD L10 ...
    BPM L11 QFA L12  SF L13 BPM  ...
    L14 BEND L15 BPM L16  SF  L17  ...
    QFA L18 BPM L19  SD L20 BEND L21 ...
    BPM L22 QD L23  L24 QF L25  ...
    BPM L26  L27EPU EPU4 L27EPU ];


SUPU7  = [ L1 L2 BPM L3 QF L4 L5 QD  ...
    L6 BPM L7 L8 BEND L9 SD L10 ...
    BPM L11 QFA L12  SF L13 BPM  ...
    L14 BEND L15 BPM L16  SF  L17  ...
    QFA L18 BPM L19  SD L20 BEND L21 ...
    BPM L22 QD L23  L24 QF L25  ...
    BPM L26  L27U7 ];

U7SUP  = [ L1U7 L2 BPM L3 QF L4 L5 QD  ...
    L6 BPM L7 L8 BEND L9 SD L10 ...
    BPM L11 QFA L12  SF L13 BPM  ...
    L14 BEND L15 BPM L16  SF  L17  ...
    QFA L18 BPM L19  SD L20 BEND L21 ...
    BPM L22 QD L23  L24 QF L25  ...
    BPM L26  L27 ];



WSUPU6  = [ L1W L2 BPM L3 QF L4 L5 QD  ...
    L6 BPM L7 L8 BEND L9 SD L10 ...
    BPM L11 QFA L12  SF L13 BPM  ...
    L14 BEND L15 BPM L16  SF  L17  ...
    QFA L18 BPM L19  SD L20 BEND L21 ...
    BPM L22 QD L23  L24 QF L25  ...
    BPM L26  L27U6 U6 L27U6 ];

SUPS  = [   L1 L2 BPM L3 QF L4 L5 QD  ...
    L6 BPM L7 L8 BEND L9 SD L10 ...
    BPM L11 QFA L12  SF LS1 QDA LS2 BPM  ...
    LS3 BS LS4 BPM LS5 QDA LS1  SF  L17  ...
    QFA L18 BPM L19  SD L20 BEND L21 ...
    BPM L22 QD L23  L24 QF L25  ...
    BPM L26  L27 ];

SUPSW  = [   L1 L2 BPM L3 QF L4 L5 QD  ...
    L6 BPM L7 L8 BEND L9 SD L10 ...
    BPM L11 QFA L12  SF LS1 QDA LS2 BPM  ...
    LS3 BS LS4 BPM LS5 QDA LS1  SF  L17  ...
    QFA L18 BPM L19  SD L20 BEND L21 ...
    BPM L22 QD L23  L24 QF L25  ...
    BPM L26  L27W ];

ELIST = [INJ SECT1 SUP SECT2 SUP SECT3 CAV SUPEPU SECT4 SUPSW SECT5 W5 WSUPU6 SECT6 SUPU7 ...
    SECT7 U7 U7SUP SECT8 SUPS SECT9 SUP SECT10 SUP SECT11 SUP SECT12 SUPS FIN];

THERING=cell(size(ELIST));
for i=1:length(THERING)
    THERING{i} = FAMLIST{ELIST(i)}.ElemData;
    FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
    FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end



QFI = findcells(THERING,'FamName','QF');

% Values for low tune nuy=8.2
%THERING = setcellstruct(THERING,'K',QFI([7:8 15:16 23:24]),2.193813983928);
%THERING = setcellstruct(THERING,'PolynomB',QFI([7:8 15:16 23:24]),2.193813983928,2);

% Values for high tune nuy=9.2
THERING = setcellstruct(THERING,'K',QFI([7:8 15:16 23:24]),2.219784);
THERING = setcellstruct(THERING,'PolynomB',QFI([7:8 15:16 23:24]),2.219784,2);

QDI = findcells(THERING,'FamName','QD');

% Values for low tune nuy=8.2
%THERING = setcellstruct(THERING,'K',QDI([7:8 15:16 23:24]),-2.316356628275);
%THERING = setcellstruct(THERING,'PolynomB',QDI([7:8 15:16 23:24]),-2.316356628275,2);

% Values for high tune nuy=9.2
THERING = setcellstruct(THERING,'K',QDI([7:8 15:16 23:24]),-2.483259);
THERING = setcellstruct(THERING,'PolynomB',QDI([7:8 15:16 23:24]),-2.483259,2);


QFAI = findcells(THERING,'FamName','QFA');

% Values for low tune nuy=8.2
%THERING = setcellstruct(THERING,'K',QFAI([7:8 15:16 23:24]),3.121514915951);
%THERING = setcellstruct(THERING,'PolynomB',QFAI([7:8 15:16 23:24]),3.121514915951,2);

% Values for high tune nuy=9.2
THERING = setcellstruct(THERING,'K',QFAI([7:8 15:16 23:24]),3.120815);
THERING = setcellstruct(THERING,'PolynomB',QFAI([7:8 15:16 23:24]),3.120815,2);



%% set the SB sextupole component strengths
BSI = findcells(THERING,'FamName','BS');
THERING = setcellstruct(THERING,'PolynomB',BSI,-22.68,3);

%% compute total length and RF frequency

L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end

setenergymodel(1.9);

fprintf('\nL0_tot=%.6f m (should be 196.805415 m) \nf_RF=%.6f MHz (should be 499.640349 Hz)\n\n',L0_tot,HarmNumber*C0/L0_tot/1e6)

%% Compute initial tunes before loading errors
%[InitialTunes, InitialChro] = tunechrom(THERING,0,[14.250, 9.20],'chrom','coupling');
%fprintf('Tunes and chromaticities are calculated slightly incorrectly since radiation and cavity are on\n');
%fprintf('Tunes before loading lattice errors: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
%fprintf('Chroma before loading lattice errors: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));

% evalin('caller','global THERING FAMLIST GLOBVAL');
% evalin('base','global THERING FAMLIST GLOBVAL');
% disp('** Done **');

