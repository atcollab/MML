function sp3v81cor
% Compiled from spear3 decks 'SP3V81.SHORT' and 'SP3V81.MAD'
% to include correctors and BPMs

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'sp3v81cor';
FAMLIST = cell(0);

disp(' ');
disp('** Loading SPEAR-III magnet lattice SP3V81COR **');
AP       =  aperture('AP',  [-0.05, 0.05, -0.05, 0.05],'AperturePass');
SEPTUM   =  aperture('SEP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
K1   =  aperture('K1', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
K2   =  aperture('K2', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
K3   =  aperture('K3', [-0.05, 0.05, -0.05, 0.05],'AperturePass');

L0 = 2.341440127200002e+002;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 372;
CAV	= rfcavity('CAV1' , 0 , 3.2e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');  

COR =  corrector('COR',0.2,[0 0],'CorrectorPass');
BPM  =  marker('BPM','IdentityPass');

%Standard Cell Drifts
DC1   =    drift('DC1' ,1.536670,'DriftPass');
DC1M   =    drift('DC1M' ,(1.536670+3.27657140)/2,'DriftPass');
DC2   =    drift('DC2' ,0.097500,'DriftPass');
DC3   =    drift('DC3' ,0.250000,'DriftPass');
DC4   =    drift('DC4' ,0.230000,'DriftPass');
DC5   =    drift('DC5' ,0.200986,'DriftPass');
DC6   =    drift('DC6' ,0.180000,'DriftPass');

%Standard Cell Dipoles
BNDF	=	rbend('BND'  , 1.452065/2,  ...
            0.5*pi/17, pi/34, 0.0,...
           -0.33, 'BndMPoleSymplectic4Pass'); %'BendLinearPass');
BNDR	=	rbend('BND'  , 1.452065/2,  ...
            0.5*pi/17, 0.0, pi/34,...
           -0.33, 'BndMPoleSymplectic4Pass'); %'BendLinearPass');
MBND  =  marker('MBND','IdentityPass');
BND=[BNDF,MBND,BNDR];

MID  =  marker('MID','IdentityPass');
      

%Standard Cell Quadrupoles
QFH		=	quadrupole('QF' , 0.34/2, 1.815761626091, 'QuadLinearPass');
QDH		=	quadrupole('QD' , 0.15/2,-1.580407879319, 'QuadLinearPass');
QFCH	    =	quadrupole('QFC', 0.5/2,  1.786614951331, 'QuadLinearPass');
MQF  =  marker('MQF','IdentityPass');
MQD  =  marker('MQD','IdentityPass');
MQFC  =  marker('MQFC','IdentityPass');

QF=[QFH,MQF,QFH];
QD=[QDH,MQD,QDH];
QFC=[QFCH,MQFC,QFCH];

%Standard Cell Sextupoles
SDH		=	sextupole('SD' , 0.25/2,-18,'StrMPoleSymplectic4Pass');
SFH		=	sextupole('SF' , 0.21/2, 16,'StrMPoleSymplectic4Pass');
MSF  =  marker('MSF','IdentityPass');
MSD  =  marker('MSD','IdentityPass');

SF=[SFH,MSF,SFH];
SD=[SDH,MSD,SDH];

%Standard Cell: (Note QFC not split)
HCEL1 =	[DC1 BPM QF DC2 COR DC2 QD DC3 BPM BND BPM DC4 SD...
DC5 COR DC5 SF DC6 BPM QFC];
HCEL2 =	[DC6 SF DC5 COR DC5...
SD DC4 BPM BND DC3 QD DC2 COR DC2 QF BPM DC1];
ACEL	=	[HCEL1 HCEL2];

%Standard Cell next to match cell B: (Note QFC not split)
HCEL2M =	[DC6 SF DC5 COR DC5...
SD DC4 BPM BND DC3 QD DC2 COR DC2 QF BPM DC1M];
ACELBM	=	[HCEL1 HCEL2M];
%Standard Cell next to match cell A: (Note QFC not split)
HCEL1M =	[DC1M BPM QF DC2 COR DC2 QD DC3 BPM BND BPM DC4 SD...
DC5 COR DC5 SF DC6 BPM QFC];
ACELAM	=	[HCEL1M HCEL2];

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
%DM10=	drift('DM10',3.27657140,'DriftPass');
DM10=	drift('DM10',(3.27657140+1.536670)/2,'DriftPass');

%Matching Cell Dipoles
B34F	=	rbend('B34'  , 1.088371/2 ,  ...
            0.5*0.75*pi/17, 0.75*pi/34, 0.0,...
           -0.33, 'BndMPoleSymplectic4Pass'); %'BendLinearPass');
B34R	=	rbend('B34'  , 1.088371/2 ,  ...
            0.5*0.75*pi/17, 0.0, 0.75*pi/34,...
           -0.33, 'BndMPoleSymplectic4Pass'); %'BendLinearPass');
MB34  =  marker('MB34','IdentityPass');
B34=[B34F,MB34,B34R];


%Matching Cell Quadrupoles
QDXH 	=	quadrupole('QDXH' ,0.34/2,-1.434796822848 , 'QuadLinearPass');
QFXH 	=	quadrupole('QFXH' ,0.6/2,  1.588731610032 , 'QuadLinearPass');
QDYH 	=	quadrupole('QDYH' ,0.34/2,-0.460196515928 , 'QuadLinearPass');
QFYH 	=	quadrupole('QFYH' ,0.5/2,  1.514741433485 , 'QuadLinearPass');
QDZH 	=	quadrupole('QDZH' ,0.34/2,-0.905444578906 , 'QuadLinearPass');
QFZH 	=	quadrupole('QFZH' ,0.34/2, 1.477425647494 , 'QuadLinearPass');
MQDX  =  marker('MQDX','IdentityPass');
MQFX  =  marker('MQFX','IdentityPass');
MQDY  =  marker('MQDY','IdentityPass');
MQFY  =  marker('MQFY','IdentityPass');
MQDZ  =  marker('MQDZ','IdentityPass');
MQFZ  =  marker('MQFZ','IdentityPass');

QDX=[QDXH,MQDX,QDXH];
QFX=[QFXH,MQFX,QFXH];
QDY=[QDYH,MQDY,QDYH];
QFY=[QFYH,MQFY,QFYH];
QDZ=[QDZH,MQDZ,QDZH];
QFZ=[QFZH,MQFZ,QFZH];


%Matching Cell Sextupoles
SDIH	=	sextupole('SDI'  , 0.21/2,-8.5,'StrMPoleSymplectic4Pass');
SFIH	=	sextupole('SFI'  , 0.21/2, 7.5,'StrMPoleSymplectic4Pass');
MSFI  =  marker('MSFI','IdentityPass');
MSDI  =  marker('MSDI','IdentityPass');

SFI=[SFIH,MSFI,SFIH];
SDI=[SDIH,MSDI,SDIH];

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
NORTH	=	[MID ACELAM MID ACEL SEPTUM MID ACEL MID ACEL MID ACEL MID ACEL MID ACELBM MID];
SOUTH	=	[MID ACELAM MID ACEL MID ACEL MID ACEL MID ACEL MID ACEL MID ACELBM MID];

ELIST	=	[MID AP CAV MCA NORTH reverse(MCB) MID MCA SOUTH reverse(MCB) AP ]; 
THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox **');
disp(' ');