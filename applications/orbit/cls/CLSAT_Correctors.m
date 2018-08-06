function clsat
% Canadian Light Source - includes correctors and BPMs

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 2.9e9;
GLOBVAL.LatticeFile = 'clsat';
FAMLIST = cell(0);

disp(' ');
disp(['** Loading CLS magnet lattice ', mfilename]);
AP       =  aperture('AP',  [-0.1, 0.1, -0.1, 0.1],'AperturePass');


L0 = 170.8800;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 285;
CAV	= rfcavity('RF' , 0 , 2.4e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');  
%KSYN:GKICK,L=0.,DP=-.000302,V=1,T=1

COR   =  corrector('COR',0.00,[0 0],'CorrectorPass');
BPM  =  marker('BPM','IdentityPass');

%Standard Cell Drifts
D1     =     drift('D1' ,0.25,  'DriftPass');
D1b    =     drift('D1b',0.357, 'DriftPass');
D2     =     drift('D2' ,0.534, 'DriftPass');
D3     =     drift('D3' ,0.312, 'DriftPass');
D4     =     drift('D4' ,0.407, 'DriftPass');
D5     =     drift('D5' ,0.3125,'DriftPass');
D6     =     drift('D6' ,0.1695,'DriftPass');
D7     =     drift('D7' ,0.3975,'DriftPass');
D8     =     drift('D8' ,0.322, 'DriftPass');
D9     =     drift('D9' ,0.339, 'DriftPass');
D10    =     drift('D10',0.195, 'DriftPass');
D11    =     drift('D11',0.210, 'DriftPass');
D12    =     drift('D12',0.324, 'DriftPass');

%Standard Cell Dipoles
BND	=	rbend('BND', 1.87,0.2617994, 0.105, 0.105,-.3972,'BndMPoleSymplectic4Pass');
%HGAP=.025,FINT=0.5,FINTX=0.5,K2=-.2,H1=0.,H2=0.


%Standard Cell Quads
QFA		=	quadrupole('QFA' , 0.18, 1.67899, 'StrMPoleSymplectic4Pass');
QFB		=	quadrupole('QFB' , 0.18, 1.88264, 'StrMPoleSymplectic4Pass');
QFC		=	quadrupole('QFC' , 0.26, 2.03992, 'StrMPoleSymplectic4Pass');

%Standard Cell Sextupoles
SF		=	sextupole('SF'   , 0.192, -24.793,      'StrMPoleSymplectic4Pass');
SD		=	sextupole('SD'   , 0.192, 39.052*1.1,   'StrMPoleSymplectic4Pass');

%Standard Cell: (Note QFC not split)
HCELL =	[ones(1,5)*D1,ones(1,4)*D1,D1b,BPM,QFA,D9,COR,D10,QFB,D3,BND,BPM,D4,COR,SD,D5,QFC,D6,SF];
HCELR =	[D6,QFC,D7,COR,SD,D8,BPM,BND,D3,QFB,D11,COR,D12,QFA,BPM,D1b,ones(1,4)*D1,ones(1,5)*D1];
CEL    =    [HCELL,HCELR];

ELIST	=	[CEL,CEL,CEL,CEL,CEL,CEL,CEL,CEL,CEL,CEL,CEL,CEL,CAV]; 

buildlat(ELIST);

evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox **');
disp(' ');
