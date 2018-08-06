function sp3v81resp
% Compiled from spear3 decks 'SP3V81.SHORT' and 'SP3V81.MAD'
% to include correctors and BPMs

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'sp3v81resp';
FAMLIST = cell(0);

disp(' ');
disp('** Loading SPEAR-III magnet lattice');
AP       =  aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
SEPTUM   =  aperture('SEP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
K1   =  aperture('K1', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
K2   =  aperture('K2', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
K3   =  aperture('K3', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
COR  =	quadrupole('COR' ,0.20,0.0,'QuadLinearPass');
BPM  =  marker('BPM','IdentityPass');

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

%Standard Cell: (Note QFC not split)
HCEL1 =	[DC1 BPM QF DC2 COR DC2 QD DC3 BPM BND BPM DC4 SD...
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
   
%wjc 01/17/02 include all standard and matching cell BPMs
%NOTE: BPMS are not symmetric in MCA, MCB
%Matching Cell A (South East, North West)
MCA=[DM1 BPM QDX DM2 COR DM2 ...
QFX DM3 BPM QDY DM4 B34 BPM DM5 SDI DM6 COR DM6 SFI DM7 BPM QFY ...
DM7 SFI DM6 COR DM6 SDI DM5 BPM B34...
BPM DM8 QDZ DM9 COR DM9 QFZ BPM DM10];

%Matching Cell B (North East, South West)
MCB=[DM1 BPM QDX DM2 COR DM2 ...
QFX DM3 BPM QDY DM4 B34 BPM DM5 SDI DM6 COR DM6 SFI DM7 QFY BPM...
DM7 SFI DM6 COR DM6 SDI DM5 BPM B34...
BPM DM8 QDZ DM9 COR DM9 QFZ BPM DM10];
        
% Begin Lattice
SOUTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];
NORTH	=	[ACEL ACEL SEPTUM ACEL ACEL ACEL ACEL ACEL];

ELIST	=	[AP MCA NORTH reverse(MCB) MCA SOUTH reverse(MCB) AP]; 
ELIST	=	[AP NORTH reverse(MCB) MCA SOUTH reverse(MCB) MCA AP]; 

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox **');