function sp3v81fdw
% All the dipole and quadrupole lengths are effective lengths
% Compiled from spear3 deck 'sp3v81newcor'
% 06/02/02: include correctors and BPMs from engineering drawings
% 03/03/03: correct BPM positions from engineering drawings
% 03/15/03: focus strengths based on MY match of equivalent MAD deck
% 04/04/03: include long kickers and septum marker based on engineering specs
% 07/27/05: add East triplet and modified quadrupole strengths for double-waist test
%           required changing arc quads, penultimate cell quads, match cell quads, triplet quads

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'sp3v81f';
FAMLIST = cell(0);

disp(['   Loading SPEAR-III magnet lattice ', mfilename]);
AP       =  aperture('AP',  [-0.1, 0.1, -0.1, 0.1],'AperturePass');
 
L0 = 2.341440122400003e+002;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 372;
CAV	= rfcavity('RF' , 0 , 3.2e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');  

COR =  corrector('COR',0.15,[0 0],'CorrectorPass');
BPM  =  marker('BPM','IdentityPass');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           STANDARD CELLS
%           Cells 3-7, 12-16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Standard Cell Drifts
DC2     =    drift('DC2' ,0.097500,'DriftPass');
DC5     =    drift('DC5' ,0.200986,'DriftPass');

%Standard Cell Kicker Drifts
K1     =     corrector('KICKER',1.2,[0 0],'CorrectorPass');
K2     =     corrector('KICKER',0.6,[0 0],'CorrectorPass');
K3     =     corrector('KICKER',1.2,[0 0],'CorrectorPass');

DI1    =     drift('DI1'  ,0.9235741,'DriftPass');   %...see note kickers in sp3v81f.doc
DI2    =     drift('DI2'  ,0.6882939,'DriftPass');
DI3    =     drift('DI3'  ,0.6834939,'DriftPass');
DI4    =     drift('DI4'  ,0.1224401,'DriftPass');
DI5    =     drift('DI5'  ,1.2401300,'DriftPass');
DI6    =     drift('DI6'  ,0.1658040,'DriftPass');
INJ    =     marker('SEPTUM','IdentityPass');        %...end of septum

%Standard Cell BPM Drifts
DC1A    =    drift('DC1A'  ,1.40593400,'DriftPass');
DC1B    =    drift('DC1B'  ,0.12404125,'DriftPass');
DC3A    =    drift('DC3A'  ,0.05322065,'DriftPass');
DC3B    =    drift('DC3B'  ,0.16368247,'DriftPass');
DC4A    =    drift('DC4A'  ,0.15921467,'DriftPass');
DC4B    =    drift('DC4B'  ,0.04441800,'DriftPass');
DC6A    =    drift('DC6A'  ,0.11064600,'DriftPass');
DC6B    =    drift('DC6B'  ,0.06316585,'DriftPass');  %0.069354 corrected to make path length consistent

%Standard Cell Corrector Magnet Drifts
DC2A    =    drift('DC2A'  ,0.11576525,'DriftPass');
DC2B    =    drift('DC2B'  ,0.11581045,'DriftPass');
DC2C    =    drift('DC2C'  ,0.10210045,'DriftPass');
DC2D    =    drift('DC2D'  ,0.12947525,'DriftPass');
DC5A    =    drift('DC5A'  ,0.09058000,'DriftPass');
DC5B    =    drift('DC5B'  ,0.36139000,'DriftPass');
DC5C    =    drift('DC5C'  ,0.09584000,'DriftPass');
DC5D    =    drift('DC5D'  ,0.35613000,'DriftPass');

%Standard Cell Dipoles
BEND	=	rbend('BEND'  , 1.5048,  ...
            0.18479957, 0.18479957/2, 0.18479957/2,...
           -0.31537858,'BendLinearPass');


%Standard Cell Quadrupoles
QF		=	quadrupole('QF' , 0.3533895,  1.753130510678, 'QuadLinearPass');
QD		=	quadrupole('QD' , 0.1634591, -1.503519522518, 'QuadLinearPass');
QFC	    =	quadrupole('QFC', 0.5123803,  1.748641980699, 'QuadLinearPass');

%Standard Cell Sextupoles
SF		=	sextupole('SF' , 0.21, 33.555218500053/2,  'StrMPoleSymplectic4Pass');
SD		=	sextupole('SD' , 0.25,-40.646813596688/2,  'StrMPoleSymplectic4Pass');

%Standard Cell: (Note QFC not split)
HCEL1 =	[DC1A BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD DC2C COR DC2D QF DC1B BPM DC1A];
ACEL	=	[AP HCEL1 HCEL2];
%Cell 3: (K1 & K2 magnets)
K1CEL3 =	[K1 DI2 BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
K2CEL3 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD DC2C COR DC2D QF DC1B BPM DI3 K2 DI4];
CEL3	=	[AP K1CEL3 K2CEL3];

%Cell 4: (Septum & K3 magnets)
SEPCEL4 =	[DI5 INJ DI6 BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
K3CEL4 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD DC2C COR DC2D QF DC1B BPM DI2 K3];
CEL4	=	[AP SEPCEL4 K3CEL4];

%Cell 5: (K5 magnets)
K3CEL5 =	[DI1 BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
CEL5	=	[AP K3CEL5 HCEL2];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           standard cells with quad strengths adjusted for lower beta-y in match straights)
%           Cells 2,8,11,17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%  QFM1E: QUADRUPOLE, L=0.3533895, K1= 1.779734740786
%  QDM1E: QUADRUPOLE, L=0.1634591, K1=-1.929807607945
%  QDM2E: QUADRUPOLE, L=0.1634591, K1=-1.355564898126
%  QFM2E: QUADRUPOLE, L=0.3533895, K1= 1.649475379921
QF2_1		=	quadrupole('QF' , 0.3533895, 1.779734740786, 'QuadLinearPass');
QD2_1		=	quadrupole('QD' , 0.1634591,-1.929807607945, 'QuadLinearPass');
QF2_2		=	quadrupole('QF' , 0.3533895, 1.649475379921, 'QuadLinearPass');
QD2_2		=	quadrupole('QD' , 0.1634591,-1.355564898126, 'QuadLinearPass');
%Cell 2: (K1 magnet, double waist penultimate quads - west)
HCEL =	[DC1A BPM DC1B QF2_1 DC2A COR DC2B QD2_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
K1CEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD2_2 DC2C COR DC2D QF2_2 DC1B BPM DI1];
CEL2	=	[AP HCEL K1CEL2];

QF8_1		=	quadrupole('QF' , 0.3533895, 1.649475379921, 'QuadLinearPass');
QD8_1		=	quadrupole('QD' , 0.1634591,-1.355564898126, 'QuadLinearPass');
QF8_2		=	quadrupole('QF' , 0.3533895, 1.779734740786, 'QuadLinearPass');
QD8_2		=	quadrupole('QD' , 0.1634591,-1.929807607945, 'QuadLinearPass');
%Cell 8: (double waist penultimate quads - east)
HCEL1 =	[DC1A BPM DC1B QF8_1 DC2A COR DC2B QD8_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD8_2 DC2C COR DC2D QF8_2 DC1B BPM DC1A];
CEL8	=	[AP HCEL1 HCEL2];

QF11_1		=	quadrupole('QF' , 0.3533895, 1.779734740786, 'QuadLinearPass');
QD11_1		=	quadrupole('QD' , 0.1634591,-1.929807607945, 'QuadLinearPass');
QF11_2		=	quadrupole('QF' , 0.3533895, 1.649475379921, 'QuadLinearPass');
QD11_2		=	quadrupole('QD' , 0.1634591,-1.355564898126, 'QuadLinearPass');
%Cell 11: (double waist penultimate quads - east)
HCEL1 =	[DC1A BPM DC1B QF11_1 DC2A COR DC2B QD11_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD11_2 DC2C COR DC2D QF11_2 DC1B BPM DC1A];
CEL11	=	[AP HCEL1 HCEL2];

QF17_1		=	quadrupole('QF' , 0.3533895, 1.649475379921, 'QuadLinearPass');
QD17_1		=	quadrupole('QD' , 0.1634591,-1.355564898126, 'QuadLinearPass');
QF17_2		=	quadrupole('QF' , 0.3533895, 1.779734740786, 'QuadLinearPass');
QD17_2		=	quadrupole('QD' , 0.1634591,-1.929807607945, 'QuadLinearPass');
%Cell 17: (double waist penultimate quads - west)
HCEL1 =	[DC1A BPM DC1B QF17_1 DC2A COR DC2B QD17_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD17_2 DC2C COR DC2D QF17_2 DC1B BPM DC1A];
CEL17	=	[AP HCEL1 HCEL2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           MATCHING CELLS
%           Cells 1,9,10,18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Matching Cell Drifts without correctors or BPMs
% %NOTE: BPMS and correctors are not symmetric in MCA, MCB
% DM1	    =	drift('DM1' ,3.81000000,'DriftPass');
% DM2	    =	drift('DM2' ,0.09750000,'DriftPass');
% DM3	    =	drift('DM3' ,0.27500000,'DriftPass');
 DM4	    =	drift('DM4' ,0.21584572,'DriftPass');
% DM5	    =	drift('DM5' ,0.25000000,'DriftPass');
% DM6	    =	drift('DM6' ,0.49068463,'DriftPass');
 DM7	    =	drift('DM7' ,0.17380985,'DriftPass');
% DM8 	=	drift('DM8' ,0.50000000,'DriftPass');
% DM9	    =	drift('DM9' ,0.10500000,'DriftPass');
% DM10    =	drift('DM10',3.27657140,'DriftPass');

%Matching Cell A-type BPM Drifts (cells 1, 10)
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

%Matching Cell A-type Corrector Drifts (cells 1, 10)
DA2A	=	drift('DA2A' ,0.1153052500000,'DriftPass');
DA2B	=	drift('DA2B' ,0.1177344500000,'DriftPass');
DA6A	=	drift('DA6A' ,0.12660000000000,'DriftPass');
%DA6B	=	drift('DA6B' ,0.90476852000000,'DriftPass');   %0.90477 corrected to make path length consistent
DA6B	=	drift('DA6B' ,0.90476828000000,'DriftPass');   %0.90477 corrected to make path length consistent with MAD (234.14401272)
DA6C	=	drift('DA6C' ,0.09600000000000,'DriftPass');
DA6D	=	drift('DA6D' ,0.93537000000000,'DriftPass');
DA9A	=	drift('DA9A' ,0.109305250000000000,'DriftPass');
DA9B	=	drift('DA9B' ,0.13730525000000000,'DriftPass');

%Matching Cell B-type  BPM Drifts (cells 9, 18)
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

%Matching Cell B-type Corrector Drifts (cells 9, 18)
DB2A	=	drift('DB2A' ,0.1158052500,'DriftPass');
DB2B	=	drift('DB2B' ,0.1172344500,'DriftPass');
DB6A	=	drift('DB6A' ,0.937370,'DriftPass');
DB6B	=	drift('DB6B' ,0.09399852000000,'DriftPass');   %0.094 corrected to make path length consistent
DB6C	=	drift('DB6C' ,0.90437000000000,'DriftPass');
DB6D	=	drift('DB6D' ,0.12700000000000,'DriftPass');
DB9A	=	drift('DB9A' ,0.12330525000000,'DriftPass');
DB9B	=	drift('DB9B' ,0.12330525000000,'DriftPass');

%Matching Cell 9 Drifts for Triplet and Chicane magnets (replacement line for DB1A)
%QD9_1/2-D9A-QF9_1-D9B-CB2-D9C-BL121-D9D-CB1-D9E-BPM-D9F-QDX9
D9A   =	drift('D9A'     ,0.2380395  ,'DriftPass');
D9B   =	drift('D9B'     ,0.1        ,'DriftPass');
D9C   =	drift('D9C'     ,0.1        ,'DriftPass');
WIG121=	drift('WIG121'  ,1.5        ,'DriftPass');
D9D   =	drift('D9D'     ,0.1        ,'DriftPass');
D9E   =	drift('D9E'     ,0.6504     ,'DriftPass');
%D9E=DB1A-( QDEH+D9A+QF9A+D9B+CB2+D9C+BL121DRIFT+D9D+CB1+D9E)
%       = 3.747082-(0.30526555+0.2380395+0.3533895+0.1+0.2+0.1+1.5+0.1+0.2)= 0.6504 m
D9F   =	drift('D9F' ,0.05622325 ,'DriftPass');

%Matching Cell 9 Drifts for Triplet and Chicane magnets
%QD9_1/2-D10A-QF9_2-D10B-CB3-D10C-BL122-D10D-CB4-D10E-BPM-D10F-QDX10
D10A   = drift('D10A'  ,0.2380395  ,'DriftPass');
D10B   = drift('D10B'  ,0.1        ,'DriftPass');
D10C   = drift('D10C'  ,0.1        ,'DriftPass');
WIG122 = drift('WIG122',1.5        ,'DriftPass');
D10D   = drift('D10D'  ,0.1        ,'DriftPass');
D10E   = drift('D10E'  ,0.5825     ,'DriftPass');
%D10E=DA1A-( QDEH+D10A+QF10A+D10B+CB3+D10C+BL122DRIFT+D10D+CB2+D10E)
%       = 3.6792386-(0.30526555+0.2380395+0.3533895+0.1+0.2+0.1+1.5+0.1+0.2)= 0.5825 m
D10F   = drift('D10F' ,0.12406665  ,'DriftPass');

%Matching Cell Dipoles
BDM	=	rbend('BDM'  , 1.14329,  ...
            0.138599675894, 0.138599675894/2, 0.138599675894/2,...
           -0.31537858,'BendLinearPass');

%Chicane dipoles
%    straight length, bend angle, path length
% SCB1 = 0.08;  ACB1 =  0.0020;    LCB1= 0.5*SCB1*ACB1/sin(ACB1/2); 
% SCB2 = 0.15;  ACB2 =  0.0044;    LCB2= 0.5*SCB2*ACB2/sin(ACB2/2);
% SCB3 = 0.16;  ACB3 = -0.0144;    LCB3= 0.5*SCB3*ACB3/sin(ACB3/2);
% SCB4 = 0.10;  ACB4 =  0.0080;    LCB4= 0.5*SCB4*ACB4/sin(ACB4/2);
% % temporary
% ACB1 =  0.0;  LCB1=0.2;
% ACB2 =  0.0;  LCB2=0.2;
% ACB3 = -0.0;  LCB3=0.2;
% ACB4 =  0.0;  LCB4=0.2;
% %
% CB1	=	rbend('CB1'  , LCB1, ACB1, ACB1/2, ACB1/2, 0.0,'BendLinearPass');
% CB2	=	rbend('CB2'  , LCB2, ACB2, ACB2/2, ACB2/2, 0.0,'BendLinearPass');
% CB3	=	rbend('CB2'  , LCB3, ACB3, ACB3/2, ACB3/2, 0.0,'BendLinearPass');
% CB4	=	rbend('CB4'  , LCB4, ACB4, ACB4/2, ACB4/2, 0.0,'BendLinearPass');
CB1 = drift('CB1',0.2,'DriftPass');
CB2 = drift('CB2',0.2,'DriftPass');
CB3 = drift('CB3',0.2,'DriftPass');
CB4 = drift('CB4',0.2,'DriftPass');

      
%West Matching Cell Quadrupoles (cells 1, 18)
%  QDXW: QUADRUPOLE, L=0.3533895, K1=-1.196087605854
%  QFXW: QUADRUPOLE, L=0.6105311, K1= 1.746509342498
%  QDYW: QUADRUPOLE, L=0.3533895, K1=-1.253618614328
%  QFYW: QUADRUPOLE, L=0.5123803, K1= 1.481494879648
%  QDZW: QUADRUPOLE, L=0.3533895, K1=-1.366619537287
%  QFZW: QUADRUPOLE, L=0.3533895, K1= 1.698171945583
QDXW 	=	quadrupole('QDX' ,0.3533895,-1.196087605854 , 'QuadLinearPass');
QFXW 	=	quadrupole('QFX' ,0.6105311, 1.746509342498, 'QuadLinearPass');
QDYW 	=	quadrupole('QDY' ,0.3533895,-1.253618614328 , 'QuadLinearPass');
QFYW 	=	quadrupole('QFY' ,0.5123803, 1.481494879648 , 'QuadLinearPass');
QDZW 	=	quadrupole('QDZ' ,0.3533895,-1.366619537287 , 'QuadLinearPass');
QFZW 	=	quadrupole('QFZ' ,0.3533895, 1.698171945583 , 'QuadLinearPass');
%
%East Matching Cell Quadrupoles (cells 9, 10)
% QDXBE: QUADRUPOLE, L=0.3533895, K1=-0.546390688493
% QFXBE: QUADRUPOLE, L=0.6105311, K1=1.416035854808
% QDYBE: QUADRUPOLE, L=0.3533895, K1=-1.318512587529
% QFYBE: QUADRUPOLE, L=0.5123803, K1=1.481494867281
% QDZBE: QUADRUPOLE, L=0.3533895, K1=-0.964648123194
% QFZBE: QUADRUPOLE, L=0.3533895, K1=1.614715367608
QDX9 	=	quadrupole('QDX' ,0.3533895,-0.546390688493 , 'QuadLinearPass');
QFX9 	=	quadrupole('QFX' ,0.6105311, 1.416035854808 , 'QuadLinearPass');
QDY9 	=	quadrupole('QDY' ,0.3533895,-1.318512587529 , 'QuadLinearPass');
QFY9 	=	quadrupole('QFY' ,0.5123803, 1.481494867281 , 'QuadLinearPass');
QDZ9 	=	quadrupole('QDZ' ,0.3533895,-0.964648123194 , 'QuadLinearPass');
QFZ9 	=	quadrupole('QFZ' ,0.3533895, 1.614715367608 , 'QuadLinearPass');
%
QDX10 	=	quadrupole('QDX' ,0.3533895,-0.546390688493 , 'QuadLinearPass');
QFX10	=	quadrupole('QFX' ,0.6105311, 1.416035854808 , 'QuadLinearPass');
QDY10 	=	quadrupole('QDY' ,0.3533895,-1.318512587529 , 'QuadLinearPass');
QFY10 	=	quadrupole('QFY' ,0.5123803, 1.481494867281, 'QuadLinearPass');
QDZ10 	=	quadrupole('QDZ' ,0.3533895,-0.964648123194 , 'QuadLinearPass');
QFZ10 	=	quadrupole('QFZ' ,0.3533895, 1.614715367608 , 'QuadLinearPass');
%
%East Triplet Quadrupoles
% QDE: QUADRUPOLE, L=0.30526555, K1=-1.987194142639
% QFBE: QUADRUPOLE, L=0.3533895, K1=1.434738170728
% QFAE: QUADRUPOLE, L=0.3533895, K1=QFBE[K1]
QF9_1 	=	quadrupole('QDW'  ,0.3533895,1.434738170728, 'QuadLinearPass');
QD9_1 	=	quadrupole('QDW' ,0.6105311,-1.987194142639 , 'QuadLinearPass');
QF9_2 	=	quadrupole('QDW'  ,0.3533895,1.434738170728, 'QuadLinearPass');

%Matching Cell Sextupoles
SDM	=	sextupole('SDM'  , 0.21,-8.5,'StrMPoleSymplectic4Pass');
SFM	=	sextupole('SFM'  , 0.21, 7.5,'StrMPoleSymplectic4Pass');
   
%Matching Cell 1
CEL1=[DA1A BPM DA1B QDXW DA2A COR DA2B ...
QFXW DA3A BPM DA3B QDYW DM4 BDM DA5A BPM DA5B SDM DA6A COR DA6B SFM DA7A BPM DA7B QFYW ...
DM7 SFM DA6C COR DA6D SDM DA5C BPM DA5D BDM...
DA8A BPM DA8B QDZW DA9A COR DA9B QFZW DA10A BPM DA10B];

%Matching Cell 9 (reverse order)
CEL9=[BPM D9F ...
QDX9 DB2A COR DB2B ...
QFX9 DB3A BPM DB3B QDY9 DM4 BDM DB5A BPM DB5B SDM DB6A COR DB6B SFM DM7 QFY9 DB7A BPM...
DB7B SFM DB6C COR DB6D SDM DB5C BPM DB5D BDM...
DB8A BPM DB8B QDZ9 DB9A COR DB9B QFZ9 DB10A BPM DB10B];

%Straight Section 9
STR9=[D9E CB1 D9D WIG121 D9C CB2 D9B QF9_1 D9A QD9_1 D10A QF9_2 D10B CB3 D10C WIG122 D10D CB4 D10E];

%Matching Cell 10
CEL10=[BPM D10F ...
QDX10 DA2A COR DA2B ...
QFX10 DA3A BPM DA3B QDY10 DM4 BDM DA5A BPM DA5B SDM DA6A COR DA6B SFM DA7A BPM DA7B QFY10 ...
DM7 SFM DA6C COR DA6D SDM DA5C BPM DA5D BDM...
DA8A BPM DA8B QDZ10 DA9A COR DA9B QFZ10 DA10A BPM DA10B];

%Matching Cell 18 (reverse order)
CEL18=[DB1A BPM DB1B QDXW DB2A COR DB2B ...
QFXW DB3A BPM DB3B QDYW DM4 BDM DB5A BPM DB5B SDM DB6A COR DB6B SFM DM7 QFYW DB7A BPM...
DB7B SFM DB6C COR DB6D SDM DB5C BPM DB5D BDM...
DB8A BPM DB8B QDZW DB9A COR DB9B QFZW DB10A BPM DB10B];
     
% Begin Lattice
NORTH	=	[CEL2  CEL3 CEL4 CEL5 ACEL ACEL CEL8];
SOUTH	=	[CEL11 ACEL ACEL ACEL ACEL ACEL CEL17];

ELIST	=	[CAV CEL1 NORTH reverse(CEL9) STR9 CEL10 SOUTH reverse(CEL18) ]; 
buildlat(ELIST);
THERING = setcellstruct(THERING,'Energy',1:length(THERING),3e9);

evalin('caller','global THERING FAMLIST GLOBVAL');