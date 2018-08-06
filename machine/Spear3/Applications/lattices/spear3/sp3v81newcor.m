function sp3v81newcor
% Compiled from spear3 deck 'sp3v81newcor'
% 06/02: include correctors and BPMs from engineering drawings

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'sp3v81newcor';
FAMLIST = cell(0);

disp(' ');
disp(['** Loading SPEAR-III magnet lattice ', mfilename]);
AP       =  aperture('AP',  [-0.1, 0.1, -0.1, 0.1],'AperturePass');


L0 = 2.341440127200002e+002;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 372;
CAV	= rfcavity('RF' , 0 , 3.2e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');  

COR =  corrector('COR',0.15,[0 0],'CorrectorPass');
BPM  =  marker('BPM','IdentityPass');

%Standard Cell Drifts
DC2     =    drift('DC2' ,0.097500,'DriftPass');
DC5     =    drift('DC5' ,0.200986,'DriftPass');

%Standard Cell BPM Drifts
DC1A    =    drift('DC1A'  ,1.405934,'DriftPass');
DC1B    =    drift('DC1B'  ,0.130736,'DriftPass');
DC3A    =    drift('DC3A'  ,0.0599502,'DriftPass');
DC3B    =    drift('DC3B'  ,0.1900498,'DriftPass');
DC4A    =    drift('DC4A'  ,0.044418,'DriftPass');
DC4B    =    drift('DC4B'  ,0.185582,'DriftPass');
DC6A    =    drift('DC6A'  ,0.110646,'DriftPass');
DC6B    =    drift('DC6B'  ,0.069356,'DriftPass');  %0.069354 corrected to make path length consistent

%Standard Cell Corrector Magnet Drifts
DC2A     =    drift('DC2A'   ,0.12246,'DriftPass');
DC2B     =    drift('DC2B'   ,0.12254,'DriftPass');
DC2C     =    drift('DC2C'   ,0.10883,'DriftPass');
DC2D     =    drift('DC2D'   ,0.13617,'DriftPass');
DC5A     =    drift('DC5A'   ,0.09058,'DriftPass');
DC5B     =    drift('DC5B'   ,0.36139,'DriftPass');
DC5C     =    drift('DC5C'   ,0.09584,'DriftPass');
DC5D     =    drift('DC5D'   ,0.35613,'DriftPass');

%Standard Cell Dipoles
BND	=	rbend('BND'  , 1.452065,  ...
            0.18479957, 0.18479957/2, 0.18479957/2,...
           -0.33,'BndMPoleSymplectic4Pass');

%Standard Cell Quadrupoles
QF		=	quadrupole('QF' , 0.34, 1.815761626091, 'StrMPoleSymplectic4Pass');
QD		=	quadrupole('QD' , 0.15,-1.580407879319, 'StrMPoleSymplectic4Pass');
QFC	    =	quadrupole('QFC', 0.5,  1.786614951331, 'StrMPoleSymplectic4Pass');

%Standard Cell Sextupoles
SD		=	sextupole('SD' , 0.25,-18,'StrMPoleSymplectic4Pass');
SF		=	sextupole('SF' , 0.21, 16,'StrMPoleSymplectic4Pass');

%Standard Cell: (Note QFC not split)
HCEL1 =	[DC1A BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BND DC3B DC3A QD DC2C COR DC2D QF DC1B BPM DC1A];
ACEL	=	[AP HCEL1 HCEL2];

%Matching Cell Drifts without correctors or BPMs
%NOTE: BPMS and correctors are not symmetric in MCA, MCB
DM1	    =	drift('DM1' ,3.81000000,'DriftPass');
DM2	    =	drift('DM2' ,0.09750000,'DriftPass');
DM3	    =	drift('DM3' ,0.27500000,'DriftPass');
DM4	    =	drift('DM4' ,0.25000000,'DriftPass');
DM5	    =	drift('DM5' ,0.25000000,'DriftPass');
DM6	    =	drift('DM6' ,0.49068463,'DriftPass');
DM7	    =	drift('DM7' ,0.18000000,'DriftPass');
DM8 	=	drift('DM8'  ,0.50000000,'DriftPass');
DM9	    =	drift('DM9' ,0.10500000,'DriftPass');
DM10    =	drift('DM10',3.27657140,'DriftPass');

%Matching Cell A BPM Drifts
DA1A	=	drift('DM1A' ,0.1307614,'DriftPass');
DA1B	=	drift('DM1B' ,3.6792386,'DriftPass');
DA3A	=	drift('DM3A' ,0.0608352,'DriftPass');
DA3B	=	drift('DM3B' ,0.2141648,'DriftPass');
DA5A	=	drift('DA5A' ,0.0035632,'DriftPass');
DA5B	=	drift('DA5B' ,0.2464368,'DriftPass');
DA5C	=	drift('DA5C' ,0.051845,'DriftPass');   
DA5D	=	drift('DA5D' ,0.198155,'DriftPass');   
DA7A	=	drift('DM7A' ,0.0693034,'DriftPass');
DA7B	=	drift('DM7B' ,0.1106966,'DriftPass');
DA8A	=	drift('DA8A' ,0.364819,'DriftPass');
DA8B	=	drift('DA8B' ,0.1351810,'DriftPass');
DA10A   =	drift('DA10A',0.1306344,'DriftPass');
DA10B   =	drift('DA10B',3.145937,'DriftPass');

%Matching Cell A Corrector Drifts
DA2A	=	drift('DA2A' ,0.12200000000000,'DriftPass');
DA2B	=	drift('DA2B' ,0.12300000000000,'DriftPass');
DA6A	=	drift('DA6A' ,0.12660000000000,'DriftPass');
DA6B	=	drift('DA6B' ,0.90476852000000,'DriftPass');   %0.90477 corrected to make path length consistent
DA6C	=	drift('DA6C' ,0.09600000000000,'DriftPass');
DA6D	=	drift('DA6D' ,0.93537000000000,'DriftPass');
DA9A	=	drift('DA9A' ,0.11600000000000,'DriftPass');
DA9B	=	drift('DA9B' ,0.14400000000000,'DriftPass');

%Matching Cell B  BPM Drifts 
DB1A	=	drift('DB1A' ,0.062918,'DriftPass');
DB1B	=	drift('DB1B' ,3.747082,'DriftPass');
DB3A	=	drift('DB3A' ,0.1374924,'DriftPass');
DB3B	=	drift('DB3B' ,0.1375076,'DriftPass');
DB5A	=	drift('DB5A' ,0.051845,'DriftPass');
DB5B	=	drift('DB5B' ,0.198155,'DriftPass');
DB5C	=	drift('DB5A' ,0.1106968,'DriftPass');
DB5D	=	drift('DB5B' ,0.1393032,'DriftPass');
DB7A	=	drift('DB7A' ,0.1106968,'DriftPass');
DB7B	=	drift('DB7B' ,0.0693032,'DriftPass');
DB8A	=	drift('DB8A' ,0.1452902,'DriftPass');
DB8B	=	drift('DB8B' ,0.3547098,'DriftPass');
DB10A	=	drift('DB10A' ,0.130736,'DriftPass');
DB10B	=	drift('DA10B' ,3.1458354,'DriftPass');

%Matching Cell B Corrector Drifts
DB2A	=	drift('DB2A' ,0.122500,'DriftPass');
DB2B	=	drift('DB2B' ,0.122500,'DriftPass');
DB6A	=	drift('DB2A' ,0.937370,'DriftPass');
DB6B	=	drift('DB2B' ,0.09399852000000,'DriftPass');   %0.094 corrected to make path length consistent
DB6C	=	drift('DB2C' ,0.90437000000000,'DriftPass');
DB6D	=	drift('DB2D' ,0.12700000000000,'DriftPass');
DB9A	=	drift('DB2A' ,0.13000000000000,'DriftPass');
DB9B	=	drift('DB2B' ,0.13000000000000,'DriftPass');

%Matching Cell Dipoles
B34	=	rbend('B34'  , 1.088371 ,  ...
            0.138599675894, 0.138599675894/2, 0.138599675894/2,...
           -0.33,'BndMPoleSymplectic4Pass');

%Matching Cell Quadrupoles
QDX 	=	quadrupole('QDX' ,0.34,-1.434796822848 , 'StrMPoleSymplectic4Pass');
QFX 	=	quadrupole('QFX' ,0.6,  1.588731610032 , 'StrMPoleSymplectic4Pass');
QDY 	=	quadrupole('QDY' ,0.34,-0.460196515928 , 'StrMPoleSymplectic4Pass');
QFY 	=	quadrupole('QFY' ,0.5,  1.514741433485 , 'StrMPoleSymplectic4Pass');
QDZ 	=	quadrupole('QDZ' ,0.34,-0.905444578906 , 'StrMPoleSymplectic4Pass');
QFZ 	=	quadrupole('QFZ' ,0.34, 1.477425647494 , 'StrMPoleSymplectic4Pass');

%Matching Cell Sextupoles
SDI	=	sextupole('SDI'  , 0.21,-8.5,'StrMPoleSymplectic4Pass');
SFI	=	sextupole('SFI'  , 0.21, 7.5,'StrMPoleSymplectic4Pass');
%SDI	=	sextupole('SDI'  , 0.21,-8.5,'DriftPass');
%SFI	=	sextupole('SFI'  , 0.21, 7.5,'DriftPass');
   
%Matching Cell A (South East, North West)
MCA=[DA1A BPM DA1B QDX DA2A COR DA2B ...
QFX DA3A BPM DA3B QDY DM4 B34 DA5A BPM DA5B SDI DA6A COR DA6B SFI DA7A BPM DA7B QFY ...
DM7 SFI DA6C COR DA6D SDI DA5C BPM DA5D B34...
DA8A BPM DA8B QDZ DA9A COR DA9B QFZ DA10A BPM DA10B];

%Matching Cell B (North East, South West)
MCB=[DB1A BPM DB1B QDX DB2A COR DB2B ...
QFX DB3A BPM DB3B QDY DM4 B34 DB5A BPM DB5B SDI DB6A COR DB6B SFI DM7 QFY DB7A BPM...
DB7B SFI DB6C COR DB6D SDI DB5C BPM DB5D B34...
DB8A BPM DB8B QDZ DB9A COR DB9B QFZ DB10A BPM DB10B];
        
% Begin Lattice
SOUTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];
NORTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];

ELIST	=	[CAV MCA NORTH reverse(MCB) MCA SOUTH reverse(MCB) ]; 

buildlat(ELIST);

evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox **');
disp(' ');