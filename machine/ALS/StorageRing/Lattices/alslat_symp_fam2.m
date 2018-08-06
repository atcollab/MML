function alslat_symp_fam
% Lattice definition file
% Compiled by Christoph Steier from the ALS TRACY 
% lattice file of Nishimura/Robin/Steier 04/20/2000 
%
% ALS production lattice, quadrupole families, one bend family,
% two sextupole families, BPMs as markers, no correctors.

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 1.9e9;
GLOBVAL.LatticeFile = 'als_symp_fam2';
FAMLIST = cell(0);
disp(' ');
disp('** Loading ALS lattice in als_symp_fam2.m **');


L0 = 196.8385212;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]

HarmNumber = 328;
CAV	= rfcavity('CAV1' , 0 , 1.5e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   


%% Marker and apertures

   SECT1 =  aperture('SECT1', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT2 =  aperture('SECT2', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT3 =  aperture('SECT3', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT4 =  aperture('SECT4', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT5 =  aperture('SECT5', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT6 =  aperture('SECT6', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT7 =  aperture('SECT7', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT8 =  aperture('SECT8', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT9 =  aperture('SECT9', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT10 =  aperture('SECT10', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT11 =  aperture('SECT11', [-0.03 0.03 -0.004 0.004],'AperturePass');
   SECT12 =  aperture('SECT12', [-0.03 0.03 -0.004 0.004],'AperturePass');
   INJ = marker('INJ','IdentityPass');

% DRIFT SPACES
   L1 = drift('L1',  2.832695+0.45698+0.08902, 'DriftPass');
   L4 = drift('L4',  0.2155+0.219, 'DriftPass');
   L6 = drift('L6',  0.107078+0.105716+0.135904, 'DriftPass');
   L9 = drift('L9',  0.2156993, 'DriftPass');
   L10 = drift('L10',  0.089084+0.235416, 'DriftPass');
   L12 = drift('L12',  0.1245, 'DriftPass');
   L13 = drift('L13',  0.511844+0.1788541, 'DriftPass');
   L15 = drift('L15',  0.1788483+0.511849, 'DriftPass');
   L17 = drift('L17',  0.1245, 'DriftPass');
   L18 = drift('L18',  0.235405+0.089095, 'DriftPass');
   L20 = drift('L20',  0.2157007, 'DriftPass');
   L21 = drift('L21',  0.177716+0.170981, 'DriftPass');
   L23 = drift('L23',  0.218997+0.215503, 'DriftPass');
   L25 = drift('L25',  0.0890187+0.45698+2.832696, 'DriftPass');

% QUADRUPOLES 

QF		=	quadrupole('QF'  , 0.344, 2.2474 ,'StrMPoleSymplectic4RadPass');

QD		=	quadrupole('QD'  , 0.187, -2.3368 ,'StrMPoleSymplectic4RadPass');

QFA		=	quadrupole('QFA'  , 0.448, 2.8856 ,'StrMPoleSymplectic4RadPass');

% SEXTUPOLES
SD		=	sextupole('SD' , 0.2030,-44.33,'StrMPoleSymplectic4RadPass');
SF		=	sextupole('SF'  , 0.2030, 56.21,'StrMPoleSymplectic4RadPass');


% DIPOLES (COMBINED FUNCTION)
BEND	=	rbend('BEND'  , 0.86621,  ...
            0.1745329, 0.0872665, 0.0872665, -0.7787,'BndMPoleSymplectic4RadPass');

% Begin Lattice

%%  Superperiods  

SUP  = [   L1 QF L4 QD  ...
           L6 BEND L9 SD L10 ... 
           QFA L12  SF L13  ...
           BEND L15 SF  L17  ...
           QFA L18 SD L20 BEND L21 ... 
           QD L23 QF L25];

ELIST = [INJ SECT1 SUP SECT2 SUP SECT3 CAV SUP SECT4 SUP SECT5 SUP SECT6 SUP ...
	SECT7 SUP SECT8 SUP SECT9 SUP SECT10 SUP SECT11 SUP SECT12 SUP];

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Done **');





