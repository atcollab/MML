function alslat_symp_fam
% Lattice definition file
% Compiled by Christoph Steier from the ALS TRACY 
% lattice file of Nishimura/Robin/Steier 04/20/2000 
%
% ALS production lattice, quadrupole families, one bend family,
% two sextupole families, BPMs as markers, no correctors.

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 1.5e9;
GLOBVAL.LatticeFile = 'als_lin_fam';
FAMLIST = cell(0);
disp(' ');
disp('** Loading ALS lattice in alslat.m **');


L0 = 196.8385212;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]

% HarmNumber = 328;
% CAV	= rfcavity('CAV1' , 0 , 1.5e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   


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



% QUADRUPOLES 

QF		=	quadrupole('QF'  , 0.344, 2.2474 ,'QuadLinearPass');

QD		=	quadrupole('QD'  , 0.187, -2.3368 ,'QuadLinearPass');

QFA		=	quadrupole('QFA'  , 0.448, 2.8856 ,'QuadLinearPass');

% SEXTUPOLES
SD		=	sextupole('SD' , 0.2030,-44.33,'StrMPoleSymplectic4Pass');
SF		=	sextupole('SF'  , 0.2030, 56.21,'StrMPoleSymplectic4Pass');


% DIPOLES (COMBINED FUNCTION)
BEND	=	rbend('BEND'  , 0.86621,  ...
            0.1745329, 0.0872665, 0.0872665, -0.7787,'BendLinearPass');
B31a	=	rbend('B31a'  , 0.598655,  ...
            0.1206231, 0.0872665, 0, -0.7787,'BendLinearPass');
B31b	=  rbend('B31b'  , 0.267555,  ...
            0.0539098, 0, 0.0872665, -0.7787,'BendLinearPass');

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
SUP3s = [   L1 L2 BPM L3 QF L4  L5 QD  ...
           L6 BPM L7 L8 B31a pos31 BL31 B31b L9  SD  L10  ...
           BPM L11 QFA L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD L23  L24 QF L25  ...
           BPM L26  L27];

ELIST = [INJ SECT1 SUP SECT2 SUP SECT3 SUP SECT4 SUP SECT5 SUP SECT6 SUP ...
	SECT7 SUP SECT8 SUP SECT9 SUP SECT10 SUP SECT11 SUP SECT12 SUP FIN];

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Done **');





