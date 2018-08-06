function spear3resp
% Compiled from spear3 deck 'SP3V80.SHORT'
% with the addition of correctors and BPMs
% note that some drift lengths modified for corrector insertion

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'spear3resp';
FAMLIST = cell(0);

disp(' ');
disp('** Loading SPEAR-III magnet lattice');
AP  =  aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
COR =  drift('CORR',0.1,         'DriftPass');
BPM =  marker('BPM',             'IdentityPass');

% DRIFT SPACES
DC1   =    drift('DC1' ,1.53667,'DriftPass');
DC2   =    drift('DC2' ,0.1475,'DriftPass');
DC3   =    drift('DC3' ,0.25,'DriftPass');
DC4   =    drift('DC4' ,0.23,'DriftPass');
DC5   =    drift('DC5' ,0.250986,'DriftPass');
DC6   =    drift('DC6' ,0.18,'DriftPass');

DM1	=	drift('DM1' ,3.810000,'DriftPass');
DM2	=	drift('DM2' ,0.145,'DriftPass');
DM3	=	drift('DM3' ,0.28,'DriftPass');
DM4	=	drift('DM4' ,0.25,'DriftPass');
DM5	=	drift('DM5' ,0.25,'DriftPass');
DM6	=	drift('DM6' ,0.505684630,'DriftPass');
DM7	=	drift('DM7' ,0.25,'DriftPass');
DM8	=	drift('DM8' ,0.5 ,'DriftPass');
DM9	=	drift('DM9' ,0.155,'DriftPass');
DM10	=	drift('DM10' ,3.27657140,'DriftPass');


% QUADRUPOLES (standard cells)
QF		=	quadrupole('QF' , 0.34, 1.815761626091, 'QuadLinearPass');
QD		=	quadrupole('QD' , 0.15,-1.580407879319, 'QuadLinearPass');
%QFC	=	quadrupole('QFC', 0.25, 1.786614917998, 'QuadLinearPass');
QFC	=	quadrupole('QFC', 0.5,  1.786614951331, 'QuadLinearPass');

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
%**** NOTE: QFC NOT SPLIT
HCEL1 =	[DC1 BPM QF DC2 COR DC2 QD DC3 BND BPM DC4 SD...
 DC5 COR DC5 SF DC6 BPM QFC];
HCEL2 =	[DC6 SF DC5 COR DC5...
 SD DC4 BPM BND DC3 QD DC2 COR DC2 QF BPM DC1];
ACEL	=	[HCEL1 HCEL2];
SOUTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];
NORTH	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];

IR		=	[DM1 BPM QDX DM2 COR DM2 ...
       QFX DM3 QDY DM4 B34 BPM DM5 SDI DM6 COR DM6 SFI DM7 BPM QFY ...
 				DM7 SFI DM6 COR DM6 SDI DM5 BPM B34...
          DM8 QDZ DM9 COR DM9 QFZ BPM DM10];


      
      
ELIST	=	[AP IR SOUTH reverse(IR) IR NORTH reverse(IR) AP]; 


THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Done **');








