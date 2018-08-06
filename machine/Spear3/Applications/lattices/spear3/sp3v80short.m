function spear3
% Compiled from spear3 deck 'SP3V80.SHORT'

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'spear3';
FAMLIST = cell(0);

disp(' ');
disp('** Loading SPEAR-III magnet lattice');
AP  =  aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
K1 = marker('K1', 'IdentityPass');
K2 = marker('K2', 'IdentityPass');
K3 = marker('K3', 'IdentityPass');
AP = marker('AP', 'IdentityPass');

% DRIFT SPACES (standard cells)
DC1 =  drift('DC1' ,1.53667,     'DriftPass');
DC2 =  drift('DC2' ,0.395 ,      'DriftPass');
DC3 =  drift('DC3' ,0.25,        'DriftPass');
DC4 =  drift('DC4' ,0.23,        'DriftPass');
DC5 =  drift('DC5' ,0.601972,    'DriftPass');
DC6 =  drift('DC6' ,0.18,        'DriftPass');
% DRIFT SPACES (matching cells)
DM1	=	drift('DM1' ,3.810000,    'DriftPass');
DM2	=	drift('DM2' ,0.390,       'DriftPass');
DM3	=	drift('DM3' ,0.28,        'DriftPass');
DM4	=	drift('DM4' ,0.25,        'DriftPass');
DM5	=	drift('DM5' ,0.25,        'DriftPass');
DM6	=	drift('DM6' ,1.11136926, 'DriftPass');
DM7	=	drift('DM7' ,0.25,        'DriftPass');
DM8	=	drift('DM8' ,0.5 ,        'DriftPass');
DM9	=	drift('DM9' ,0.410,       'DriftPass');
DM10	=	drift('DM10',3.27657140,  'DriftPass');

% QUADRUPOLES (standard cells)
QF		=	quadrupole('QF' , 0.34, 1.815761626091, 'QuadLinearPass');
QD		=	quadrupole('QD' , 0.15,-1.580407879319, 'QuadLinearPass');
QFC	=	quadrupole('QFC', 0.25, 1.786614917998, 'QuadLinearPass');

% QUADRUPOLES (matching cells)
QDX 	=	quadrupole('QDX' ,0.34,-1.437770016116 , 'QuadLinearPass');
QFX 	=	quadrupole('QFX' ,0.6,  1.588310523065 , 'QuadLinearPass');
QDY 	=	quadrupole('QDY' ,0.34,-0.460196515928 , 'QuadLinearPass');
QFY 	=	quadrupole('QFY' ,0.5,  1.514741504629 , 'QuadLinearPass');
QDZ 	=	quadrupole('QDZ' ,0.34,-0.905396617422 , 'QuadLinearPass');
QFZ 	=	quadrupole('QFZ' ,0.34, 1.479267960323 , 'QuadLinearPass');

% SEXTUPOLES (standard cells)
SD		=	sextupole('SD' , 0.25,-18,'StrMPoleSymplectic4Pass');
SF		=	sextupole('SF' , 0.21, 16,'StrMPoleSymplectic4Pass');
%SD	=	sextupole('SD' , 0.25,-18,'DriftPass');
%SF	=	sextupole('SF' , 0.21, 16,'DriftPass');

% SEXTUPOLES (matching cells)
SDI	=	sextupole('SDI'  , 0.21,-8.5,'StrMPoleSymplectic4Pass');
SFI	=	sextupole('SFI'  , 0.21, 7.5,'StrMPoleSymplectic4Pass');
%SDI	=	sextupole('SDI'  , 0.21,-8.5,'DriftPass');
%SFI	=	sextupole('SFI'  , 0.21, 7.5,'DriftPass');



% DIPOLES (standard and matching cells)
BND	=	rbend('BND'  , 1.452065,  ...
            0.18479957, 0.18479957/2, 0.18479957/2,...
           -0.33,'BendLinearPass');
B34	=	rbend('B34'  , 1.088371 ,  ...
            0.138599675894, 0.138599675894/2, 0.138599675894/2,...
           -0.33,'BendLinearPass');

% Begin Lattice

HCEL	=	[DC1 QF DC2 QD DC3 BND DC4 SD DC5 SF DC6 QFC];
ACEL	=	[HCEL AP reverse(HCEL)];
SOUTH	=	[ACEL K1 ACEL K2 ACEL K3 ACEL ACEL ACEL ACEL];
NORTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];

IR		=	[AP DM1 QDX DM2 QFX DM3 QDY DM4 B34 DM5 SDI DM6 SFI DM7 QFY ...
 				DM7 SFI DM6 SDI DM5 B34 DM8 QDZ DM9 QFZ DM10];
      
ELIST	=	[IR SOUTH reverse(IR) IR NORTH reverse(IR) ]; 

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Done **');








