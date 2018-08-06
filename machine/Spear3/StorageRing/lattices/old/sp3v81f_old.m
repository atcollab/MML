function sp3v81all
% All the dipole and quadrupole lengths are effective lengths
% Compiled from spear3 deck 'sp3v81newcor'
% 06/02: include correctors and BPMs from engineering drawings
% 03/03: correct BPM positions from engineering drawings

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'sp3v81all';
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
DC1B    =    drift('DC1B'  ,0.12404125,'DriftPass');
DC3A    =    drift('DC3A'  ,0.05322065,'DriftPass');
DC3B    =    drift('DC3B'  ,0.16368247,'DriftPass');
DC4A    =    drift('DC4A'  ,0.15921467,'DriftPass');
DC4B    =    drift('DC4B'  ,0.044418,'DriftPass');
DC6A    =    drift('DC6A'  ,0.110646,'DriftPass');
DC6B    =    drift('DC6B'  ,0.06316585,'DriftPass');  %0.069354 corrected to make path length consistent

%Standard Cell Corrector Magnet Drifts
DC2A     =    drift('DC2A'   ,0.11576525,'DriftPass');
DC2B     =    drift('DC2B'   ,0.11581045,'DriftPass');
DC2C     =    drift('DC2C'   ,0.10210045,'DriftPass');
DC2D     =    drift('DC2D'   ,0.12947525,'DriftPass');
DC5A     =    drift('DC5A'   ,0.09058,'DriftPass');
DC5B     =    drift('DC5B'   ,0.36139,'DriftPass');
DC5C     =    drift('DC5C'   ,0.09584,'DriftPass');
DC5D     =    drift('DC5D'   ,0.35613,'DriftPass');

%Standard Cell Dipoles
BND	=	rbend('BND'  , 1.5048,  ...
            0.18479957, 0.18479957/2, 0.18479957/2,...
           -0.31537858,'BndMPoleSymplectic4Pass');

%Standard Cell Quadrupoles
QF		=	quadrupole('QF' , 0.3533895, 1.768672904054, 'StrMPoleSymplectic4Pass');
QD		=	quadrupole('QD' , 0.1634591,-1.542474230359, 'StrMPoleSymplectic4Pass');
QFC	    =	quadrupole('QFC', 0.5123803,  1.748640831069, 'StrMPoleSymplectic4Pass');

%Standard Cell Sextupoles
SF		=	sextupole('SF' , 0.21, 32.0477093/2,'StrMPoleSymplectic4Pass');
SD		=	sextupole('SD' , 0.25,-38.80153/2,'StrMPoleSymplectic4Pass');

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
DM4	    =	drift('DM4' ,0.21584572,'DriftPass');
DM5	    =	drift('DM5' ,0.25000000,'DriftPass');
DM6	    =	drift('DM6' ,0.49068463,'DriftPass');
DM7	    =	drift('DM7' ,0.17380985,'DriftPass');
DM8 	=	drift('DM8' ,0.50000000,'DriftPass');
DM9	    =	drift('DM9' ,0.10500000,'DriftPass');
DM10    =	drift('DM10',3.27657140,'DriftPass');

%Matching Cell A BPM Drifts
DA1A	=	drift('DA1A' ,3.6792386,'DriftPass');
DA1B	=	drift('DA1B' ,0.12406665,'DriftPass');
DA3A	=	drift('DA3A' ,0.20889925,'DriftPass');
DA3B	=	drift('DA3B' ,0.05414045,'DriftPass');
DA5A	=	drift('DA5A' ,0.11397747,'DriftPass');
DA5B	=	drift('DA5B' ,0.108563 ,'DriftPass');
DA5C	=	drift('DA5C' ,0.051845 ,'DriftPass');   
DA5D	=	drift('DA5D' ,0.17069547,'DriftPass');   
DA7A	=	drift('DA7A' ,0.1106966,'DriftPass');
DA7B	=	drift('DA7B' ,0.06311325,'DriftPass');
DA8A	=	drift('DA8A' ,0.33735947,'DriftPass');
DA8B	=	drift('DA8B' ,0.12848625,'DriftPass');
DA10A   =	drift('DA10A',0.12393965,'DriftPass');
DA10B   =	drift('DA10B',3.145937 ,'DriftPass');

%Matching Cell A Corrector Drifts
DA2A	=	drift('DA2A' ,0.1153052500000,'DriftPass');
DA2B	=	drift('DA2B' ,0.1177344500000,'DriftPass');
DA6A	=	drift('DA6A' ,0.12660000000000,'DriftPass');
%DA6B	=	drift('DA6B' ,0.90476852000000,'DriftPass');   %0.90477 corrected to make path length consistent
DA6B	=	drift('DA6B' ,0.90476828000000,'DriftPass');   %0.90477 corrected to make path length consistent with MAD (234.14401272)
DA6C	=	drift('DA6C' ,0.09600000000000,'DriftPass');
DA6D	=	drift('DA6D' ,0.93537000000000,'DriftPass');
DA9A	=	drift('DA9A' ,0.109305250000000000,'DriftPass');
DA9B	=	drift('DA9B' ,0.13730525000000000,'DriftPass');

%Matching Cell B  BPM Drifts 
DB1A	=	drift('DB1A' ,3.747082 ,'DriftPass');
DB1B	=	drift('DB1B' ,0.05622325 ,'DriftPass');
DB3A	=	drift('DB3A' ,0.13222685,'DriftPass');
DB3B	=	drift('DB3B' ,0.13081285,'DriftPass');
DB5A	=	drift('DB5A' ,0.17069547,'DriftPass');
DB5B	=	drift('DB5B' ,0.051845 ,'DriftPass');
DB5C	=	drift('DB5C' ,0.1085632,'DriftPass');
DB5D	=	drift('DB5D' ,0.11397727,'DriftPass');
DB7A	=	drift('DB7A' ,0.06311305,'DriftPass');
DB7B	=	drift('DB7B' ,0.1106968,'DriftPass');
DB8A	=	drift('DB8A' ,0.32725027,'DriftPass');
DB8B	=	drift('DB8B' ,0.13859545,'DriftPass');
DB10A	=	drift('DB10A',0.12404125 ,'DriftPass');
DB10B	=	drift('DB10B',3.1458354,'DriftPass');

%Matching Cell B Corrector Drifts
DB2A	=	drift('DB2A' ,0.1158052500,'DriftPass');
DB2B	=	drift('DB2B' ,0.1172344500,'DriftPass');
DB6A	=	drift('DB6A' ,0.937370,'DriftPass');
DB6B	=	drift('DB6B' ,0.09399852000000,'DriftPass');   %0.094 corrected to make path length consistent
DB6C	=	drift('DB6C' ,0.90437000000000,'DriftPass');
DB6D	=	drift('DB6D' ,0.12700000000000,'DriftPass');
DB9A	=	drift('DB9A' ,0.12330525000000,'DriftPass');
DB9B	=	drift('DB9B' ,0.12330525000000,'DriftPass');

%Matching Cell Dipoles
B34	=	rbend('B34'  , 1.14329,  ...
            0.138599675894, 0.138599675894/2, 0.138599675894/2,...
           -0.31537858,'BndMPoleSymplectic4Pass');

%Matching Cell Quadrupoles
QDX 	=	quadrupole('QDX' ,0.3533895,-1.386467245226 , 'StrMPoleSymplectic4Pass');
QFX 	=	quadrupole('QFX' ,0.6105311,1.573196278394, 'StrMPoleSymplectic4Pass');
QDY 	=	quadrupole('QDY' ,0.3533895,-0.460640930646 , 'StrMPoleSymplectic4Pass');
QFY 	=	quadrupole('QFY' ,0.5123803,  1.481493709831 , 'StrMPoleSymplectic4Pass');
QDZ 	=	quadrupole('QDZ' ,0.3533895,-0.878223937747 , 'StrMPoleSymplectic4Pass');
QFZ 	=	quadrupole('QFZ' ,0.3533895, 1.427902006984 , 'StrMPoleSymplectic4Pass');

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