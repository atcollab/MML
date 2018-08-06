% SPEAR 3 lattice with
% betay=1.5m at west IP and 
%5cm dispersion in 3.8m straights.
%"West IP nominal [SPEAR3 v.79].                                               "
%
% DATE AND TIME:    10/04/:1  17.07.50 (Y.Nosochkov)
% Compiled from spear3 deck 'SP3V79'

%function lowbeta
global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'lowbeta';
FAMLIST = cell(0);

disp(' ');
disp('** Loading SPEAR-III magnet lattice with low betay in IP and finite dispersion');

%====== cell drifts ========
D0 =  drift('D0' ,  0.0,     'DriftPass');
DC1 = drift('DC1',  1.53667, 'DriftPass');
%DC2 = drift('DC2',  0.0975,  'DriftPass');
DC2 = drift('DC2',  0.395,   'DriftPass');
DC3 = drift('DC3',  0.25,    'DriftPass');
DC4 = drift('DC4',  0.23,    'DriftPass');
DC5 = drift('DC5',  0.601972,'DriftPass');
DC6 = drift('DC6',  0.18,    'DriftPass');
%====== cell quads =========
QF = quadrupole('QF',  0.34, 1.825299822195, 'QuadLinearPass');
QD = quadrupole('QD',  0.15,-1.534549201494, 'QuadLinearPass');
QFC= quadrupole('QFC', 0.25, 1.754517417509, 'QuadLinearPass');
%====== cell sexts =========
SF=sextupole('SF' , 0.21, 31.551173099975/2,'StrMPoleSymplectic4Pass');
SD=sextupole('SD' , 0.25,-38.065110752207/2,'StrMPoleSymplectic4Pass');
%====== cell dipoles =========
BND	=	rbend('BND'  , 1.452065,  ...
                0.18479957, 0.18479957/2, 0.18479957/2,...
               -0.33,'BendLinearPass');

%==== Match Cell Drifts
DM1W = drift('DM1W',1.45,        'DriftPass');
DQW  = drift('DQW', 0.3,         'DriftPass');
DMW  = drift('DMW', 1.13897548,  'DriftPass');
DM2W = drift('DM2W',0.0,         'DriftPass');
DM1  = drift('DM1', 3.56897548,  'DriftPass');
DM2  = drift('DM2', 0.39,       'DriftPass');
DM3  = drift('DM3', 0.28,        'DriftPass');
DM4  = drift('DM4', 0.25,        'DriftPass');
DM5  = drift('DM5', 0.25,        'DriftPass');
DM6  = drift('DM6', 1.09060618 , 'DriftPass');
DM7  = drift('DM7', 0.25,        'DriftPass');
DM8  = drift('DM8', 0.5,         'DriftPass');
DM9  = drift('DM9', 0.41,        'DriftPass');
DM10 = drift('DM10',3.31,        'DriftPass');

%==== West Pit Quads =====
QFW  = quadrupole('QFW' , .34,  0.0,            'QuadLinearPass');
QDW  = quadrupole('QDW' , .34,  0.0,            'QuadLinearPass');
QDXW = quadrupole('QDXW', .34, -1.613573574062, 'QuadLinearPass');
QFXW = quadrupole('QFXW', .6,   1.784652840016, 'QuadLinearPass');
QDYW = quadrupole('QDYW', .34, -0.972816621089, 'QuadLinearPass');
QFYW = quadrupole('QFYW', .5,   1.490880520107, 'QuadLinearPass');
QDZW = quadrupole('QDZW', .34, -0.683511154525, 'QuadLinearPass');
QFZW = quadrupole('QFZW', .34,  1.390107676984, 'QuadLinearPass');

%==== East Pit Quads =====
QDXE = quadrupole('QDXE', .34, -1.478173156638, 'QuadLinearPass');
QFXE = quadrupole('QFXE', .6,   1.684739797027, 'QuadLinearPass');
QDYE = quadrupole('QDYE', .34, -0.739808319328, 'QuadLinearPass');
QFYE = quadrupole('QFYE', .5,   1.492191222410, 'QuadLinearPass');
QDZE = quadrupole('QDZE', .34, -0.891827325308, 'QuadLinearPass');
QFZE = quadrupole('QFZE', .34,  1.484496975077, 'QuadLinearPass');

%==== Match Cell Dipoles
B34	=	rbend('B34'  , 1.088371 ,  ...
            0.138599675894, 0.138599675894/2, 0.138599675894/2,...
           -0.33,'BendLinearPass');

%====== Match Cell Sexts =========
SFI=sextupole('SFI' , 0.21, 15/2,'StrMPoleSymplectic4Pass');
SDI=sextupole('SDI' , 0.21,-17/2,'StrMPoleSymplectic4Pass');

% Begin Lattice:Arcs
AP  =  aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
HCEL	=	[DC1 QF DC2 QD DC3 BND DC4 SD DC5 SF DC6 QFC];
ACEL	=	[HCEL AP reverse(HCEL)];
SOUTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];
NORTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];

%Insertion Regions
CAVITY = drift('CAVITY', 0.25, 'DriftPass');
DMRF = drift('DMRF', 3.06, 'DriftPass');
DSQ = drift('DSQ', .25, 'DriftPass');


IRW= [QDXW,DM2W,DM2,QFXW,DM3,QDYW,DM4,B34,DM5,SDI,...
DM6,SFI,DM7,QFYW,DM7,SFI,DM6,SDI,DM5,B34,DM8,QDZW,DM9,QFZW];

IRE= [QDXE,DM2,QFXE,DM3,QDYE,DM4,B34,DM5,SDI,DM6,...
SFI,DM7,QFYE,DM7,SFI,DM6,SDI,DM5,B34,DM8,QDZE,DM9,QFZE];

IRSW= [DM1W,DSQ,QFW,DQW,QDW,DMW,IRW,DM10];
MIR= [-IRSW];

IRSE= [DM1,IRE,DMRF,CAVITY];

IRNE= [DM1,QDXE,DM2,QFXE,DM3,QDYE,DM4,B34,...
DM5,SDI,DM6,SFI,DM7,QFYE,DM7,SFI,DM6,SDI,DM5,...
B34,DM8,QDZE,DM9,QFZE,DMRF,CAVITY];

IRNW= [DM1W,QFW,DQW,QDW,DMW,QDXW,DM2W,DM2,QFXW,...
DM3,QDYW,DM4,B34,DM5,SDI,DM6,SFI,DM7,QFYW,DM7,SFI,DM6,...
SDI,DM5,B34,DM8,QDZW,DM9,QFZW,DM10];

RING= [IRSW,SOUTH,reverse(IRSE),IRNE,NORTH,reverse(IRNW)];
ELIST = RING;
      
%ELIST=ACEL;

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Done Loading Lattice **');
disp(' ');
disp('** NOTE: THIS LATTICE IS SLIGHTLY INACCURATE **');
disp(' ');



