function cls
% Compiled from cls deck
% includes correctors and BPMs

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 2.9e9;
GLOBVAL.LatticeFile = 'cls';
FAMLIST = cell(0);

disp(' ');
disp('** Loading CLS magnet lattice');

%marker
AP       =  aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');

%correctors
COR       =  aperture('COR', [-0.05, 0.05, -0.05, 0.05],'AperturePass'); % CX:GKICK,L=0,DXP=0

BPM  =  marker('BPM','IdentityPass');  % MV, MH:MONITOR

%drift spaces
D1  = drift('D1'  ,0.25,  'DriftPass');   % D1:DRIFT,l=.25
D1b = drift('D1b' ,0.357, 'DriftPass');   % D1b:DRIFT,l=.357
D2  = drift('D2'  ,0.267, 'DriftPass');   % D2:DRIFT,l=0.267
D3  = drift('D3'  ,0.312, 'DriftPass');   % D3:DRIFT,l=0.312
D4  = drift('D4'  ,0.407, 'DriftPass');   % D4:DRIFT,l=.407
D5  = drift('D5'  ,0.3025,'DriftPass');   % D5:DRIFT,l=.3025
D6  = drift('D6'  ,0.1795,'DriftPass');   % D6:DRIFT,l=.1795
D7  = drift('D7'  ,0.3875,'DriftPass');   % D7:DRIFT,l=.3875
D8  = drift('D8'  ,0.322, 'DriftPass');   % D8:DRIFT,l=.322
DQ  = drift('DQ'  ,0.006, 'DriftPass');   % DQ:DRIFT,L=.006


%quads
FQ1=1.80600;
FQ2=1.67571;
FQ3=2.05168;
QF		=	quadrupole('QF' , 0.18, FQ1, 'QuadLinearPass');   %Q1C:MULTIPOLE,L=.18,K1=FQ1
QD		=	quadrupole('QD' , 0.18, FQ2, 'QuadLinearPass');
QFC		=	quadrupole('QFC' , 0.26, FQ3, 'QuadLinearPass');

%sextupoles
FS1 = -27.10804;
FS2 = 41.08608;
SD		=	sextupole('SD' , 0.192,FS1,'StrMPoleSymplectic4Pass'); %S1:MULTIPOLE,L=.192,K2=FS1
SF		=	sextupole('SF' , 0.192,FS2,'StrMPoleSymplectic4Pass'); %S2:MULTIPOLE,L=.192,K2=FS2

%dipole
%HC:SBEND,L=1.87,ANGLE=0.2617994,E1=0.105,E2=.105,K1=-.3928
BEND=rbend('BEND',1.87,0.2617994, 0.105, 0.105,-.3928,'BendLinearPass');
 
%cell
CELL=[D1*ones(1,9) D1b BPM QF D2 COR D2 QD D3 BEND BPM D4 SD COR,D5 QFC D6 SF,...
      D6 QFC,D7 COR SD D8 BPM BEND D3 QD D2 COR D2 QF,BPM D1b D1*ones(1,9)];

%ring
ELIST	=	[CELL,CELL,CELL,CELL,CELL,CELL,CELL,CELL,CELL,CELL,CELL,CELL,]; 

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox **');