function alslat
% Lattice definition file
% Compiled by Christoph Steier from the ALS TRACY 
% lattice file of Nishimura/Robin/Steier 04/20/2000 
%
% ALS production lattice, individual quadrupoles, one bend family,
% two sextupole families, BPMs included as markers, no correctors.

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 1.5e9;
GLOBVAL.LatticeFile = 'als_short';
FAMLIST = cell(0);
disp(' ');
disp('** Loading ALS lattice in alslat.m **');


L0 = 196.8000096;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]

HarmNumber = 328;
CAV	= rfcavity('CAV1' , 0 , 1.5e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   


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

QF1		=	quadrupole('QF1'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF2		=	quadrupole('QF2'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF3		=	quadrupole('QF3'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF4		=	quadrupole('QF4'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF5		=	quadrupole('QF5'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF6		=	quadrupole('QF6'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF7		=	quadrupole('QF7'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF8		=	quadrupole('QF8'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF9		=	quadrupole('QF9'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF10		=	quadrupole('QF10'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF11		=	quadrupole('QF11'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF12		=	quadrupole('QF12'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF13		=	quadrupole('QF13'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF14		=	quadrupole('QF14'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF15		=	quadrupole('QF15'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF16		=	quadrupole('QF16'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF17		=	quadrupole('QF17'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF18		=	quadrupole('QF18'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF19		=	quadrupole('QF19'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF20		=	quadrupole('QF20'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF21		=	quadrupole('QF21'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF22		=	quadrupole('QF22'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF23		=	quadrupole('QF23'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');
QF24		=	quadrupole('QF24'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');

QD1		=	quadrupole('QD1'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD2		=	quadrupole('QD2'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD3		=	quadrupole('QD3'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD4		=	quadrupole('QD4'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD5		=	quadrupole('QD5'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD6		=	quadrupole('QD6'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD7		=	quadrupole('QD7'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD8		=	quadrupole('QD8'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD9		=	quadrupole('QD9'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD10		=	quadrupole('QD10'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD11		=	quadrupole('QD11'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD12		=	quadrupole('QD12'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD13		=	quadrupole('QD13'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD14		=	quadrupole('QD14'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD15		=	quadrupole('QD15'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD16		=	quadrupole('QD16'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD17		=	quadrupole('QD17'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD18		=	quadrupole('QD18'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD19		=	quadrupole('QD19'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD20		=	quadrupole('QD20'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD21		=	quadrupole('QD21'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD22		=	quadrupole('QD22'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD23		=	quadrupole('QD23'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');
QD24		=	quadrupole('QD24'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');

QFA1		=	quadrupole('QFA1'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA2		=	quadrupole('QFA2'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA3		=	quadrupole('QFA3'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA4		=	quadrupole('QFA4'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA5		=	quadrupole('QFA5'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA6		=	quadrupole('QFA6'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA7		=	quadrupole('QFA7'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA8		=	quadrupole('QFA8'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA9		=	quadrupole('QFA9'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA10		=	quadrupole('QFA10'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA11		=	quadrupole('QFA11'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA12		=	quadrupole('QFA12'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA13		=	quadrupole('QFA13'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA14		=	quadrupole('QFA14'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA15		=	quadrupole('QFA15'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA16		=	quadrupole('QFA16'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA17		=	quadrupole('QFA17'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA18		=	quadrupole('QFA18'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA19		=	quadrupole('QFA19'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA20		=	quadrupole('QFA20'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA21		=	quadrupole('QFA21'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA22		=	quadrupole('QFA22'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA23		=	quadrupole('QFA23'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');
QFA24		=	quadrupole('QFA24'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');



% SEXTUPOLES
SD		=	sextupole('SD' , 0.2030,-44.33,'StrMPoleSymplectic4RadPass');
SF		=	sextupole('SF'  , 0.2030, 56.21,'StrMPoleSymplectic4RadPass');



% DIPOLES (COMBINED FUNCTION)
BEND	=	rbend('BEND'  , 0.86621,  ...
            0.1745329, 0.0872665, 0.0872665, -0.7787,'BndMPoleSymplectic4RadPass');
B31a	=	rbend('B31a'  , 0.598655,  ...
            0.1206231, 0.0872665, 0, -0.7787,'BndMPoleSymplectic4RadPass');
B31b	=  rbend('B31b'  , 0.267555,  ...
            0.0539098, 0, 0.0872665, -0.7787,'BndMPoleSymplectic4RadPass');




% Begin Lattice

%%  Scraper Half-Straight  

L27s = [L27a posScrapH L27b posScrapB L27c posScrapT L27d];

%%  Superperiods  

SUP1 = [   L1 L2 BPM L3 QF1 L4 L5 QD1  ...
           L6 BPM L7 L8 BEND L9 SD L10 ... 
           BPM L11 QFA1 L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA2 L18 BPM L19  SD L20 BEND L21 ... 
           BPM L22 QD2 L23  L24 QF2 L25  ...
           BPM L26  L27 ];
SUP2 = [    L1  L2 BPM L3 QF3 L4  L5 QD3  ...
           L6 BPM L7 L8 BEND L9  SD L10  ...
           BPM L11 QFA3 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA4 L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD4 L23  L24 QF4 L25  ...
           BPM L26 CAV L27];
SUP3 = [   L1 CAV L2 BPM L3 QF5 L4  L5 QD5  ...
           L6 BPM L7 L8 B31a B31b L9  SD  L10  ...
           BPM L11 QFA5 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA6 L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD6 L23  L24 QF6 L25  ...
           BPM L26  L27];
SUP3s = [   L1 L2 BPM L3 QF5 L4  L5 QD5  ...
           L6 BPM L7 L8 B31a pos31 BL31 B31b L9  SD  L10  ...
           BPM L11 QFA5 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA6 L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD6 L23  L24 QF6 L25  ...
           BPM L26  L27];
SUP4 = [   L1  L2 BPM L3 QF7 L4  L5 QD7  ...
           L6 BPM L7 L8 BEND L9  SD  L10  ...
           BPM L11 QFA7 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA8 L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD8 L23  L24 QF8 L25  ...
           BPM L26  L27];
SUP5 = [   L1  L2 BPM L3 QF9 L4  L5 QD9  ...
           L6 BPM L7 L8 BEND L9  SD  L10  ...
           BPM L11 QFA9 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA10 L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD10 L23  L24 QF10 L25  ...
           BPM L26  L27];
SUP6 = [   L1  L2 BPM L3 QF11 L4  L5 QD11  ...
           L6 BPM L7 L8 BEND L9  SD  L10  ...
           BPM L11 QFA11 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA12 L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD12 L23  L24 QF12 L25  ...
           BPM L26 L27];
SUP7 = [   L1 L2 BPM L3 QF13 L4 L5 QD13  ...
           L6 BPM L7 L8 BEND L9  SD  L10  ...
           BPM L11 QFA13 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA14 L18 BPM L19  SD  L20 BEND L21  ...
           BPM L22 QD14 L23  L24 QF14 L25  ...
           BPM L26  L27];
SUP8 = [   L1 L2 BPM L3 QF15 L4 L5 QD15  ...
           L6 BPM L7 L8 BEND L9  SD  L10  ...
           BPM L11 QFA15 L12  SF  L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA16 L18 BPM L19  SD L20 BEND L21  ...
           BPM L22 QD16 L23  L24 QF16 L25  ...
           BPM L26  L27];
SUP9 = [   L1  L2 BPM L3 QF17 L4  L5 QD17  ...
           L6 BPM L7 L8 BEND L9  SD  L10  ...
           BPM L11 QFA17 L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF  L17  ...
           QFA18 L18 BPM L19  SD L20 BEND L21  ...
           BPM L22 QD18 L23  L24 QF18 L25  ...
           BPM L26 L27];
SUP10 = [  L1 L2 BPM L3 QF19 L4 L5 QD19  ...
           L6 BPM L7 L8 BEND L9  SD L10  ...
           BPM L11 QFA19 L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF L17  ...
           QFA20 L18 BPM L19  SD L20 BEND L21  ...
           BPM L22 QD20 L23 L24 QF20 L25  ...
           BPM L26 L27s];
SUP11 = [  L1 L2 BPM L3 QF21 L4 L5 QD21  ...
           L6 BPM L7 L8 BEND L9  SD L10  ...
           BPM L11 QFA21 L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF L17  ...
           QFA22 L18 BPM L19  SD L20 BEND L21  ...
           BPM L22 QD22 L23 L24 QF22 L25  ...
           BPM L26 L27];
SUP12 = [  L1 L2 BPM L3 QF23 L4 L5 QD23  ...
           L6 BPM L7 L8 BEND L9  SD L10  ...
           BPM L11 QFA23 L12  SF L13 BPM  ...
           L14 BEND L15 BPM L16  SF L17  ...
           QFA24 L18 BPM L19  SD L20 BEND L21  ...
           BPM L22 QD24 L23 L24 QF24 L25  ...
           BPM L26 L27];

ELIST = [ SECT1 SUP1 SECT2 SUP2 SECT3 SUP3s SECT4 SUP4 SECT5 SUP5 SECT6 SUP6 ...
	SECT7 SUP7 SECT8 SUP8 SECT9 SUP9 SECT10 SUP10 SECT11 SUP11 SECT12 SUP12];

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Done **');





