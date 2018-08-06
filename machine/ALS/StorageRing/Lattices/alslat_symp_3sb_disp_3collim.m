function alslat_symp_3sb_disp_3collim
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
GLOBVAL.LatticeFile = 'als_symp_3sb_disp_3collim';
FAMLIST = cell(0);
disp(' ');
disp('** Loading ALS lattice in alslat_symp_3sb_disp_3collim.m **');


L0 =  196.805415;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 328;

%% Cavity
%                   NAME    L     U[V]       f[Hz]            h            method       
CAV	= rfcavity('CAV1' , 0 , 1.2e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   


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
   COL0 = aperture('COL0',[-0.011 0.011 -0.01 0.01],'IdentityPass');
   COL1 = aperture('COL1',[-0.011 0.011 -0.0025 0.0025],'IdentityPass');
   COL2 = aperture('COL2',[-0.03 0.03 -0.0025 0.0025],'IdentityPass');
   U281 = aperture('U281',[-0.03 0.03 -0.0025 0.0025],'AperturePass');
   U282 = aperture('U282',[-0.03 0.03 -0.0025 0.0025],'AperturePass');
   U283 = aperture('U283',[-0.03 0.03 -0.0025 0.0025],'AperturePass');
   
% DRIFT SPACES
   L1 = drift('L1',  2.832695, 'DriftPass');
   L1U = drift('L1U',  2.832695-0.75, 'DriftPass');
   L1U2 = drift('L1U2',  0.75, 'DriftPass');
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
   L27U = drift('L27U',  2.832696-0.75, 'DriftPass');
   L27U2 = drift('L27U2',  0.75, 'DriftPass');
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
QF   =  quadrupole('QF' , 0.344,  2.213482613545 , 'StrMPoleSymplectic4RadPass');
QD   =  quadrupole('QD' , 0.187, -2.356501752011 , 'StrMPoleSymplectic4RadPass');
QFA  =  quadrupole('QFA', 0.448,  2.954337148639 , 'StrMPoleSymplectic4RadPass');
QDA  =  quadrupole('QDA', 0.187, -1.783113127857 , 'StrMPoleSymplectic4RadPass');


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
SUP1  = [   L1 COL0 L2 BPM L3 QF L4 L5 QD  ...
           L6 BPM L7 L8 BEND L9 SD L10 ... 
           BPM L11 QFA L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA L18 BPM L19  SD L20 BEND L21 ... 
           BPM L22 QD L23  L24 QF L25  ...
           BPM L26 L27 ];
SUP2  = [   L1 COL1 L2 BPM L3 QF L4 L5 QD  ...
           L6 BPM L7 L8 BEND L9 SD L10 ... 
           BPM L11 QFA L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA L18 BPM L19  SD L20 BEND L21 ... 
           BPM L22 QD L23  L24 QF L25  ...
           BPM L26 L27 ];
SUP3  = [   L1 COL2 L2 BPM L3 QF L4 L5 QD  ...
           L6 BPM L7 L8 BEND L9 SD L10 ... 
           BPM L11 QFA L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA L18 BPM L19  SD L20 BEND L21 ... 
           BPM L22 QD L23  L24 QF L25  ...
           BPM L26  L27 ];           
SUP5  = [   L1 L2 BPM L3 QF L4 L5 QD  ...
           L6 BPM L7 L8 BEND L9 SD L10 ... 
           BPM L11 QFA L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA L18 BPM L19  SD L20 BEND L21 ... 
           BPM L22 QD L23  L24 QF L25  ...
           BPM L26  L27U U281 L27U2 U282 ];           
SUP6  = [   L1U2 U283 L1U L2 BPM L3 QF L4 L5 QD  ...
           L6 BPM L7 L8 BEND L9 SD L10 ... 
           BPM L11 QFA L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA L18 BPM L19  SD L20 BEND L21 ... 
           BPM L22 QD L23  L24 QF L25  ...
           BPM L26  L27 ];           
SUPS  = [   L1 L2 BPM L3 QF L4 L5 QD  ...
           L6 BPM L7 L8 BEND L9 SD L10 ... 
           BPM L11 QFA L12  SF LS1 QDA LS2 BPM  ...
           LS3 BS LS4 BPM LS5 QDA LS1  SF  L17  ...
           QFA L18 BPM L19  SD L20 BEND L21 ... 
           BPM L22 QD L23  L24 QF L25  ...
           BPM L26  L27 ];
           
ELIST = [INJ SECT1 SUP1 SECT2 SUP2 SECT3 CAV SUP3 SECT4 SUPS SECT5 SUP5 SECT6 SUP6 ...
	SECT7 SUP SECT8 SUPS SECT9 SUP SECT10 SUP SECT11 SUP SECT12 SUPS FIN];

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end

QFI = findcells(THERING,'FamName','QF');
THERING = setcellstruct(THERING,'K',QFI([7:8 15:16 23:24]),2.193813983928);
THERING = setcellstruct(THERING,'PolynomB',QFI([7:8 15:16 23:24]),2.193813983928,2);
QDI = findcells(THERING,'FamName','QD');
THERING = setcellstruct(THERING,'K',QDI([7:8 15:16 23:24]),-2.316356628275);
THERING = setcellstruct(THERING,'PolynomB',QDI([7:8 15:16 23:24]),-2.316356628275,2);
QFAI = findcells(THERING,'FamName','QFA');
THERING = setcellstruct(THERING,'K',QFAI([7:8 15:16 23:24]),3.121514915951);
THERING = setcellstruct(THERING,'PolynomB',QFAI([7:8 15:16 23:24]),3.121514915951,2);

%% set the SB sextupole component strengths
BSI = findcells(THERING,'FamName','BS');
THERING = setcellstruct(THERING,'PolynomB',BSI,-22.68,3);

%% compute total length and RF frequency

L0_tot=0;
for i=1:length(THERING)
   L0_tot=L0_tot+THERING{i}.Length;
end

fprintf('\nL0_tot=%.6f m (should be 196.805415 m) \nf_RF=%.6f MHz (should be 499.640349 Hz)\n\n',L0_tot,HarmNumber*C0/L0_tot/1e6)

%% Compute initial tunes before loading errors
[InitialTunes, InitialChro]= tunechrom(THERING,0,[14.25, 8.2],'chrom','coupling');

fprintf('Tunes and chromaticities are calculated slightly incorrectly since radiation and cavity are on\n');
fprintf('Tunes before loading lattice errors: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
fprintf('Chroma before loading lattice errors: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));

evalin('caller','global THERING FAMLIST GLOBVAL');
evalin('base','global THERING FAMLIST GLOBVAL');
disp('** Done **');
