function sp3v82
% All the dipole and quadrupole lengths are effective lengths
% Compiled from spear3 deck 'sp3v81newcor'
% 06/02/02: include correctors and BPMs from engineering drawings
% 03/03/03: correct BPM positions from engineering drawings
% 03/15/03: focus strengths based on MY match of equivalent MAD deck
% 04/04/03: include long kickers and septum marker based on engineering specs
% 07/27/05: add East triplet and modified quadrupole strengths for double-waist test
%           required changing arc quads, penultimate cell quads, match cell quads, triplet quads
% 07/08/06: change 'CB' to 'CD' for chicane dipoles
% 07/08/06: put CD and BPMs in proper locations according to engineering dwgs
% 07/16/06: split CD and Q9S magnets for correctors
% 07/16/06: reduce length of CD magnets in model from 20cm to 11cm as per engineering specs
% 07/18/06: re-defined CD magnets as correctors instead of Bends to avoid
%           warning about changing bends
% 08/01/06: enter quadrupole strengths from Yuri match sp3v81f_dwc_14.13-6.22_symm_eng.txt
%   'symm' indicates North/South symmetric optics
%   'dwc' indicates double-waist chicane
%   'eng' indicates CD magnets and dwc BPMs are in correct positions as per engineering drawings

disp(['   Loading SPEAR-III magnet lattice ', mfilename]);

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'sp3v81f';
FAMLIST = cell(0);

AP       =  aperture('AP',  [-0.1, 0.1, -0.1, 0.1],'AperturePass');
 
L0 = 2.341440122400003e+002;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 372;
CAV	= rfcavity('RF' , 0 , 3.2e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');  

THINCOR =  corrector('COR',0.00,[0 0],'CorrectorPass');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     STANDARD CELLS 3-7, 12-16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BPM  =  marker('BPM','IdentityPass');
COR =  corrector('COR',0.15,[0 0],'CorrectorPass');

%Standard Cell Drifts
DC2     =    drift('DC2' ,0.097500,'DriftPass');
DC5     =    drift('DC5' ,0.200986,'DriftPass');

%Standard Cell BPM Drifts
DC1A    =    drift('DC1A'  ,1.40593400,'DriftPass');
DC1B    =    drift('DC1B'  ,0.12404125,'DriftPass');
DC3A    =    drift('DC3A'  ,0.05322065,'DriftPass');
DC3B    =    drift('DC3B'  ,0.16368247,'DriftPass');
DC4A    =    drift('DC4A'  ,0.15921467,'DriftPass');
DC4B    =    drift('DC4B'  ,0.04441800,'DriftPass');
DC6A    =    drift('DC6A'  ,0.11064600,'DriftPass');
DC6B    =    drift('DC6B'  ,0.06316585,'DriftPass');  %0.069354 corrected to make path length consistent

%Standard Cell Corrector Drifts
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

%Injection Kickers and Septum
K1     =     corrector('KICKER',1.2,[0 0],'CorrectorPass');
K2     =     corrector('KICKER',0.6,[0 0],'CorrectorPass');
K3     =     corrector('KICKER',1.2,[0 0],'CorrectorPass');
INJ    =     marker('SEPTUM','IdentityPass');        %...exit of septum

%Injection Kicker Drifts
DI1    =     drift('DI1'  ,0.9235741,'DriftPass');   %...see note kickers in sp3v81f.doc
DI2    =     drift('DI2'  ,0.6882939,'DriftPass');
DI3    =     drift('DI3'  ,0.6834939,'DriftPass');
DI4    =     drift('DI4'  ,0.1224401,'DriftPass');
DI5    =     drift('DI5'  ,1.2401300,'DriftPass');
DI6    =     drift('DI6'  ,0.1658040,'DriftPass');

%================= BEGIN STANDARD CELL  (QFC not split) ===========================
HCEL1 =	[DC1A BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];

HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD DC2C COR DC2D QF DC1B BPM DC1A];

ACEL	=	[AP HCEL1 HCEL2];
%================= END STANDARD CELL  =============================================

%================= BEGIN CELL 2 (K1, quads for low-betay in match straights)=======
QFM1= 1.796107206934;   %QF magnet toward pits
QFM2= 1.668556235871;   %QF magnet toward arcs
QDM1=-1.942744871911;   %QD magnet toward pits
QDM2=-1.374597393400;   %QD magnet toward arcs
QF2_1		=	quadrupole('QF' , 0.3533895, QFM1, 'QuadLinearPass');
QD2_1		=	quadrupole('QD' , 0.1634591, QDM1, 'QuadLinearPass');
QF2_2		=	quadrupole('QF' , 0.3533895, QFM2, 'QuadLinearPass');
QD2_2		=	quadrupole('QD' , 0.1634591, QDM2, 'QuadLinearPass');

HCEL =	[DC1A BPM DC1B QF2_1 DC2A COR DC2B QD2_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
K1CEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD2_2 DC2C COR DC2D QF2_2 DC1B BPM DI1];

CEL2	=	[AP HCEL K1CEL2];
%================= END CELL 2 =====================================================
  
%================= BEGIN CELL 3: (K1, K2 Kickers) =================================
K1CEL3 =	[K1 DI2 BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];

K2CEL3 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD DC2C COR DC2D QF DC1B BPM DI3 K2 DI4];

CEL3	=	[AP K1CEL3 K2CEL3];
%================ END CELL 3 ======================================================

%=================BEGIN CELL 4: (Septum & K3 Kicker)===============================
SEPCEL4 =	[DI5 INJ DI6 BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
K3CEL4 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD DC2C COR DC2D QF DC1B BPM DI2 K3];
CEL4	=	[AP SEPCEL4 K3CEL4];
%================ END CELL 4 ======================================================

%==================BEGIN CELL 5: (K5 magnet?)======================================
K3CEL5 =	[DI1 BPM DC1B QF DC2A COR DC2B QD DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
CEL5	=	[AP K3CEL5 HCEL2];
%================ END CELL 5 ======================================================

%================ CELL 6,7 ARE STANDARD CELLS (Defined above)======================

%==================BEGIN CELL 8: (quads for low-betay in match straights)==========
QF8_1		=	quadrupole('QF' , 0.3533895, QFM2, 'QuadLinearPass');
QD8_1		=	quadrupole('QD' , 0.1634591, QDM2, 'QuadLinearPass');
QF8_2		=	quadrupole('QF' , 0.3533895, QFM1, 'QuadLinearPass');
QD8_2		=	quadrupole('QD' , 0.1634591, QDM1, 'QuadLinearPass');

HCEL1 =	[DC1A BPM DC1B QF8_1 DC2A COR DC2B QD8_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD8_2 DC2C COR DC2D QF8_2 DC1B BPM DC1A];
CEL8	=	[AP HCEL1 HCEL2];
%================ END CELL 8 ======================================================

%================ CELL 9,10 ARE MATCHING CELLS (Defined below) ====================

%=================BEGIN CELL 11: (quads for low-betay in match straights)==========
QF11_1		=	quadrupole('QF' , 0.3533895, QFM1, 'QuadLinearPass');
QD11_1		=	quadrupole('QD' , 0.1634591, QDM1, 'QuadLinearPass');
QF11_2		=	quadrupole('QF' , 0.3533895, QFM2, 'QuadLinearPass');
QD11_2		=	quadrupole('QD' , 0.1634591, QDM2, 'QuadLinearPass');

HCEL1 =	[DC1A BPM DC1B QF11_1 DC2A COR DC2B QD11_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND DC3B DC3A QD11_2 DC2C COR DC2D QF11_2 DC1B BPM DC1A];
CEL11	=	[AP HCEL1 HCEL2];
%================ END CELL 11 =====================================================

%================ CELL 12-16 ARE STANDARD CELLS (Defined above) ===================

%=================BEGIN CELL 17: (quads for low-betay in match straights)==========
QF17_1		=	quadrupole('QF' , 0.3533895, QFM2, 'QuadLinearPass');
QD17_1		=	quadrupole('QD' , 0.1634591, QDM2, 'QuadLinearPass');
QF17_2		=	quadrupole('QF' , 0.3533895, QFM1, 'QuadLinearPass');
QD17_2		=	quadrupole('QD' , 0.1634591, QDM1, 'QuadLinearPass');
%Cell 17: (double waist penultimate quads - west)
MIKE  =  marker('MIKE','IdentityPass');

HCEL1 =	[DC1A BPM DC1B QF17_1 DC2A COR DC2B QD17_1 DC3A BPM DC3B BEND DC4A BPM DC4B SD...
DC5A COR DC5B SF DC6A BPM DC6B QFC];
HCEL2 =	[DC6B DC6A SF DC5C COR DC5D...
SD DC4B BPM DC4A BEND MIKE DC3B DC3A QD17_2 DC2C COR DC2D QF17_2 DC1B BPM DC1A];
CEL17	=	[AP HCEL1 HCEL2];
%================ END CELL 17 =====================================================

%================ MATCHING CELL ELEMENT DEFINITIONS ===============================
%           MCA-TYPE CELLS: 1 and 10         MCB-TYPE CELLS: 9 and  18
%==================================================================================
%MCA, MCB drifts with no corrector or BPM
DA4	    =	drift('DA4' ,0.21584572,'DriftPass');
DA8	    =	drift('DA8' ,0.17380985,'DriftPass');
DB4	    =	drift('DB4' ,0.21584572,'DriftPass');
DB7	    =	drift('DB7' ,0.17380985,'DriftPass');

%MCA BPM Drifts (7 ea)
DA1A	=	drift('DA1A' ,3.6792386,'DriftPass');
DA1B	=	drift('DA1B' ,0.12406665,'DriftPass');
DA3A	=	drift('DA3A' ,0.20889925,'DriftPass');
DA3B	=	drift('DA3B' ,0.05414045,'DriftPass');
DA5A	=	drift('DA5A' ,0.11397747,'DriftPass');
DA5B	=	drift('DA5B' ,0.108563 ,'DriftPass');
DA7A	=	drift('DA7A' ,0.1106966,'DriftPass');
DA7B	=	drift('DA7B' ,0.06311325,'DriftPass');
DA10A	=	drift('DA10A',0.051845 ,'DriftPass');   
DA10B	=	drift('DA10B',0.17069547,'DriftPass');   
DA11A	=	drift('DA11A',0.33735947,'DriftPass');
DA11B	=	drift('DA11B',0.12848625,'DriftPass');
DA13A   =	drift('DA13A',0.12393965,'DriftPass');
DA13B   =	drift('DA13B',3.145937 ,'DriftPass');

%MCA Corrector Drifts (4 ea)
DA2A	=	drift('DA2A' ,0.1153052500000,'DriftPass');
DA2B	=	drift('DA2B' ,0.1177344500000,'DriftPass');
DA6A	=	drift('DA6A' ,0.12660000000000,'DriftPass');
DA6B	=	drift('DA6B' ,0.90476828000000,'DriftPass');   %0.90477 corrected to make path length consistent with MAD (234.14401272)
DA9A	=	drift('DA9A' ,0.09600000000000,'DriftPass');
DA9B	=	drift('DA9B' ,0.93537000000000,'DriftPass');
DA12A	=	drift('DA12A',0.1093052500000,'DriftPass');
DA12B	=	drift('DA12B',0.1373052500000,'DriftPass');

%MCB BPM Drifts (7 ea)
DB1A	=	drift('DB1A' ,3.747082 ,'DriftPass');
DB1B	=	drift('DB1B' ,0.05622325 ,'DriftPass');
DB3A	=	drift('DB3A' ,0.13222685,'DriftPass');
DB3B	=	drift('DB3B' ,0.13081285,'DriftPass');
DB5A	=	drift('DB5A' ,0.17069547,'DriftPass');
DB5B	=	drift('DB5B' ,0.051845 ,'DriftPass');
DB8A	=	drift('DB8A' ,0.06311305,'DriftPass');
DB8B	=	drift('DB8B' ,0.1106968,'DriftPass');
DB10A	=	drift('DB10A' ,0.1085632,'DriftPass');
DB10B	=	drift('DB10B' ,0.11397727,'DriftPass');
DB11A	=	drift('DB11A' ,0.32725027,'DriftPass');
DB11B	=	drift('DB11B' ,0.13859545,'DriftPass');
DB13A	=	drift('DB13A',0.12404125 ,'DriftPass');
DB13B	=	drift('DB13B',3.1458354,'DriftPass');

%MCB Corrector Drifts (4 ea)
DB2A	=	drift('DB2A' ,0.1158052500,'DriftPass');
DB2B	=	drift('DB2B' ,0.1172344500,'DriftPass');
DB6A	=	drift('DB6A' ,0.937370,'DriftPass');
DB6B	=	drift('DB6B' ,0.09399852000000,'DriftPass');   %0.094 corrected to make path length consistent
DB9A	=	drift('DB9A' ,0.90437000000000,'DriftPass');
DB9B	=	drift('DB9B' ,0.12700000000000,'DriftPass');
DB12A	=	drift('DB12A' ,0.12330525000000,'DriftPass');
DB12B	=	drift('DB12B' ,0.12330525000000,'DriftPass');

%S9 Drifts
D9S1    =	drift('D9S1'      ,0.138100     ,'DriftPass');
D9S2A   =	drift('D9S2A'     ,0.124000     ,'DriftPass');
D9S2B   =	drift('D9S2B'     ,2.21980      ,'DriftPass');
D9S2C   =	drift('D9S2C'     ,0.043        ,'DriftPass');
D9S3    =	drift('D9S3'      ,0.1055000    ,'DriftPass');
D9S4    =	drift('D9S4'      ,0.2380398    ,'DriftPass');
D9S5A   =   drift('D9S5A'     ,0.11973445   ,'DriftPass');
D9S5B   =   drift('D9S5B'     ,0.11830505   ,'DriftPass');
D9S6    =   drift('D9S6'      ,0.12560545   ,'DriftPass');
D9S7A   =   drift('D9S7A'     ,0.045        ,'DriftPass');
D9S7B   =   drift('D9S7B'     ,2.24820      ,'DriftPass');
D9S7C   =   drift('D9S7C'     ,0.044        ,'DriftPass');
D9S8    =   drift('D9S8'      ,0.099700     ,'DriftPass');


%Matching Cell Dipoles
BDM	=	rbend('BDM'  , 1.14329,  ...
            0.138599675894, 0.138599675894/2, 0.138599675894/2,...
           -0.31537858,'BendLinearPass');

       %West Matching Cell Quadrupoles (cells 1, 18)
QDXW 	=	quadrupole('QDX' ,0.3533895,-1.352137583368 , 'QuadLinearPass');
QFXW 	=	quadrupole('QFX' ,0.6105311, 1.788901294265, 'QuadLinearPass');
QDYW 	=	quadrupole('QDY' ,0.3533895,-1.228187092157 , 'QuadLinearPass');
QFYW 	=	quadrupole('QFY' ,0.5123803, 1.481494890153 , 'QuadLinearPass');
QDZW 	=	quadrupole('QDZ' ,0.3533895,-1.292554906327 , 'QuadLinearPass');
QFZW 	=	quadrupole('QFZ' ,0.3533895, 1.652137149352 , 'QuadLinearPass');
%
%East Matching Cell Quads
QDX9 	=	quadrupole('QDX' ,0.3533895,-0.506202543201 , 'QuadLinearPass');
QFX9 	=	quadrupole('QFX' ,0.6105311, 1.393717225884 , 'QuadLinearPass');
QDY9 	=	quadrupole('QDY' ,0.3533895,-1.316363066520 , 'QuadLinearPass');
QFY9 	=	quadrupole('QFY' ,0.5123803, 1.487667447513 , 'QuadLinearPass');
QDZ9 	=	quadrupole('QDZ' ,0.3533895,-0.971446090856 , 'QuadLinearPass');
QFZ9 	=	quadrupole('QFZ' ,0.3533895, 1.623915643638 , 'QuadLinearPass');
%
QDX10 	=	quadrupole('QDX' ,0.3533895,-0.498609505069 , 'QuadLinearPass');
QFX10	=	quadrupole('QFX' ,0.6105311, 1.375216955766 , 'QuadLinearPass');
QDY10 	=	quadrupole('QDY' ,0.3533895,-1.304485550061 , 'QuadLinearPass');
QFY10 	=	quadrupole('QFY' ,0.5123803, 1.479326419997, 'QuadLinearPass');
QDZ10 	=	quadrupole('QDZ' ,0.3533895,-0.957755695355 , 'QuadLinearPass');
QFZ10 	=	quadrupole('QFZ' ,0.3533895, 1.596309077780 , 'QuadLinearPass');
%
%East Triplet Quads
QF9_1H 	=	quadrupole('Q9S'  ,0.3533895/2,1.404889990368, 'QuadLinearPass');
QD9_1 	=	quadrupole('Q9S' ,0.6105311,-1.970309412395 , 'QuadLinearPass');
QF9_2H 	=	quadrupole('Q9S'  ,0.3533895/2,1.420293718455, 'QuadLinearPass');

%Matching Cell Sextupoles
SDM	=	sextupole('SDM'  , 0.21,-8.5,'StrMPoleSymplectic4Pass');
SFM	=	sextupole('SFM'  , 0.21, 7.5,'StrMPoleSymplectic4Pass');

%Chicane dipoles
LCD=0.11;
ACD1 =  +0.002000;  % bend angles from Ringwall
ACD2 =  +0.0048325;
ACD3 =  -0.0148325;
ACD4 =  +0.008000;

%8/16/2006  split CD magnets to add correctors inside. NOTE: avoid split-bend disease
CD1UP	=	rbend('CD'  , LCD/2, ACD1/2,   ACD1/2, 0*ACD1/2, 0.0,'BendLinearPass');  %0.0=no gradient
CD1DN	=	rbend('CD'  , LCD/2, ACD1/2, 0*ACD1/2, ACD1/2,   0.0,'BendLinearPass');  
CD2UP	=	rbend('CD'  , LCD/2, ACD2/2,   ACD2/2, 0*ACD2/2, 0.0,'BendLinearPass');
CD2DN	=	rbend('CD'  , LCD/2, ACD2/2, 0*ACD2/2, ACD2/2,   0.0,'BendLinearPass');
CD3UP	=	rbend('CD'  , LCD/2, ACD3/2,   ACD3/2, 0*ACD3/2, 0.0,'BendLinearPass');
CD3DN	=	rbend('CD'  , LCD/2, ACD3/2, 0*ACD3/2, ACD3/2,   0.0,'BendLinearPass');
CD4UP	=	rbend('CD'  , LCD/2, ACD4/2,   ACD4/2, 0*ACD4/2, 0.0,'BendLinearPass');
CD4DN	=	rbend('CD'  , LCD/2, ACD4/2, 0*ACD4/2, ACD4/2,   0.0,'BendLinearPass');


%================= BEGIN CELL 1 (MCA) =============================================
CEL1=[DA1A BPM DA1B QDXW DA2A COR DA2B ...
QFXW DA3A BPM DA3B QDYW DA4 BDM DA5A BPM DA5B SDM DA6A COR DA6B SFM DA7A BPM DA7B QFYW ...
DA8 SFM DA9A COR DA9B SDM DA10A BPM DA10B BDM...
DA11A BPM DA11B QDZW DA12A COR DA12B QFZW DA13A BPM DA13B];
%================= END CELL 1 ======================================================

%================= BEGIN CELL 9 (MCB, reverse order)================================
CEL9=[BPM DB1B QDX9 DB2A COR DB2B ...
QFX9 DB3A BPM DB3B QDY9 DB4 BDM DB5A BPM DB5B SDM DB6A COR DB6B SFM DB7 QFY9 DB8A BPM...
DB8B SFM DB9A COR DB9B SDM DB10A BPM DB10B BDM...
DB11A BPM DB11B QDZ9 DB12A COR DB12B QFZ9 DB13A BPM DB13B];

%CELL 9 Straight Section (replaces DB1A/DA1A drifts in previous lattices)
S9=[D9S1 CD1UP THINCOR CD1DN D9S2A BPM D9S2B BPM D9S2C CD2UP THINCOR CD2DN D9S3 QF9_1H THINCOR QF9_1H...
      D9S4 QD9_1 D9S5A BPM D9S5B QF9_2H THINCOR QF9_2H D9S6 CD3UP THINCOR CD3DN D9S7A BPM D9S7B BPM D9S7C CD4UP THINCOR CD4DN D9S8];
%================= END CELL 9 ======================================================

%================= BEGIN CELL 10 (MCA) =============================================
CEL10=[BPM DA1B QDX10 DA2A COR DA2B ...
QFX10 DA3A BPM DA3B QDY10 DA4 BDM DA5A BPM DA5B SDM DA6A COR DA6B SFM DA7A BPM DA7B QFY10 ...
DA8 SFM DA9A COR DA9B SDM DA10A BPM DA10B BDM...
DA11A BPM DA11B QDZ10 DA12A COR DA12B QFZ10 DA13A BPM DA13B];
%================= END CELL 10 =====================================================

%================= BEGIN CELL 18 (MCB, reverse order)===============================
CEL18=[DB1A BPM DB1B QDXW DB2A COR DB2B ...
QFXW DB3A BPM DB3B QDYW DB4 BDM DB5A BPM DB5B SDM DB6A COR DB6B SFM DB7 QFYW DB8A BPM...
DB8B SFM DB9A COR DB9B SDM DB10A BPM DB10B BDM MIKE...
DB11A BPM DB11B QDZW DB12A COR DB12B QFZW DB13A BPM DB13B];
%================= END CELL 18 ======================================================
     
% Begin Lattice
NORTH	=	[CEL2  CEL3 CEL4 CEL5 ACEL ACEL CEL8];
SOUTH	=	[CEL11 ACEL ACEL ACEL ACEL ACEL CEL17];

ELIST	=	[CAV CEL1 NORTH reverse(CEL9) S9 CEL10 SOUTH reverse(CEL18) ]; 
buildlat(ELIST);
THERING = setcellstruct(THERING,'Energy',1:length(THERING),3e9);

evalin('caller','global THERING FAMLIST GLOBVAL');