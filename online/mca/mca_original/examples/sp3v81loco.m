function varargout = sp3v81respcav

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'sp3v81resp';
FAMLIST = cell(0);

L0 = 2.341440127200002e+002;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 372;
 


disp(' ');
disp('** Loading SPEAR-III magnet lattice');
AP  =  aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
%COR =  corrector('COR',0.2,[0.0 0.0],'CorrPass');
COR =  corrector('COR',0.2,[0 0],'CorrectorPass');
BPM =  marker('BPM','IdentityPass');
% Voltage: 3.2 e6 if only one cavity is used
CAV	= rfcavity('CAV1' , 0 , 3.2e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');  

%Standard Cell Drifts
DC1   =    drift('DC1' ,1.536670,'DriftPass');
DC2   =    drift('DC2' ,0.097500,'DriftPass');
DC3   =    drift('DC3' ,0.250000,'DriftPass');
DC4   =    drift('DC4' ,0.230000,'DriftPass');
DC5   =    drift('DC5' ,0.200986,'DriftPass');
DC6   =    drift('DC6' ,0.180000,'DriftPass');

%Standard Cell Dipoles
BND	=	rbend('BND'  , 1.452065,  ...
            0.18479957, 0.18479957/2, 0.18479957/2,...
           -0.33,'BendLinearPass');

%Standard Cell Quadrupoles
QF		=	quadrupole('QF' , 0.34, 1.815761626091, 'QuadLinearPass');
QD		=	quadrupole('QD' , 0.15,-1.580407879319, 'QuadLinearPass');
QFC	    =	quadrupole('QFC', 0.5,  1.786614951331, 'QuadLinearPass');

%Standard Cell Sextupoles
SD		=	sextupole('SD' , 0.25,-18,'StrMPoleSymplectic4Pass');
SF		=	sextupole('SF' , 0.21, 16,'StrMPoleSymplectic4Pass');
%SD	=	sextupole('SD' , 0.25,-18,'DriftPass');
%SF	=	sextupole('SF' , 0.21, 16,'DriftPass');

%Standard Cell: (Note QFC not split)
HCEL1 =	[DC1 BPM QF DC2 COR DC2 QD DC3 BND BPM DC4 SD...
DC5 COR DC5 SF DC6 BPM QFC];
HCEL2 =	[DC6 SF DC5 COR DC5...
SD DC4 BPM BND DC3 QD DC2 COR DC2 QF BPM DC1];
ACEL	=	[HCEL1 HCEL2];

%Matching Cell Drifts
DM1	=	drift('DM1' ,3.81000000,'DriftPass');
DM2	=	drift('DM2' ,0.09750000,'DriftPass');
DM3	=	drift('DM3' ,0.27500000,'DriftPass');
DM4	=	drift('DM4' ,0.25000000,'DriftPass');
DM5	=	drift('DM5' ,0.25000000,'DriftPass');
DM6	=	drift('DM6' ,0.49068463,'DriftPass');
DM7	=	drift('DM7' ,0.18000000,'DriftPass');
DM8	=	drift('DM8' ,0.50000000,'DriftPass');
DM9	=	drift('DM9' ,0.10500000,'DriftPass');
DM10=	drift('DM10',3.27657140,'DriftPass');

%Matching Cell Dipoles
B34	=	rbend('B34'  , 1.088371 ,  ...
            0.138599675894, 0.138599675894/2, 0.138599675894/2,...
           -0.33,'BendLinearPass');

%Matching Cell Quadrupoles
QDX 	=	quadrupole('QDX' ,0.34,-1.434796822848 , 'QuadLinearPass');
QFX 	=	quadrupole('QFX' ,0.6,  1.588731610032 , 'QuadLinearPass');
QDY 	=	quadrupole('QDY' ,0.34,-0.460196515928 , 'QuadLinearPass');
QFY 	=	quadrupole('QFY' ,0.5,  1.514741433485 , 'QuadLinearPass');
QDZ 	=	quadrupole('QDZ' ,0.34,-0.905444578906 , 'QuadLinearPass');
QFZ 	=	quadrupole('QFZ' ,0.34, 1.477425647494 , 'QuadLinearPass');

%Matching Cell Sextupoles
SDI	=	sextupole('SDI'  , 0.21,-8.5,'StrMPoleSymplectic4Pass');
SFI	=	sextupole('SFI'  , 0.21, 7.5,'StrMPoleSymplectic4Pass');
%SDI	=	sextupole('SDI'  , 0.21,-8.5,'DriftPass');
%SFI	=	sextupole('SFI'  , 0.21, 7.5,'DriftPass');
       
%Matching Cell
IR=[DM1 BPM QDX DM2 COR DM2 ...
QFX DM3 QDY DM4 B34 BPM DM5 SDI DM6 COR DM6 SFI DM7 BPM QFY ...
DM7 SFI DM6 COR DM6 SDI DM5 BPM B34...
DM8 QDZ DM9 COR DM9 QFZ BPM DM10];
         
% Begin Lattice
SOUTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];
NORTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];

ELIST	=	[CAV IR SOUTH reverse(IR) IR NORTH reverse(IR) AP]; 


buildlat(ELIST);

evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox **');









