function varargout = sp3v81respcav

disp('   Loading ALBA-03 magnet lattice');

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'cells';
FAMLIST = cell(0);

L0 =  264.03 ;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 440;
Nbends=32;
Ab=2*pi/32;

AP  =  aperture('AP', [-0.025, 0.025, -0.01, 0.01],'AperturePass');
%COR =  corrector('COR',0.2,[0.0 0.0],'CorrPass');
COR =  corrector('COR',0.2,[0 0],'CorrectorPass');
BPM =  marker('BPM','IdentityPass');
% Voltage: 3.2 e6 if only one cavity is used
CAV	= rfcavity('CAV1' , 0 , 3.5e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');

SL = 0.15 ;

FH=1;
FV=1;


%Drifts

D11 = drift ('D11',3.900000,'DriftPass');
D12 = drift ('D12',0.200000,'DriftPass');
D13 = drift ('D13',0.150000,'DriftPass');
D14 = drift ('D14',0.450000,'DriftPass');
D15 = drift ('D15',0.150000,'DriftPass');
D21 = drift ('D21',0.200000,'DriftPass');
D22 = drift ('D22',0.150000,'DriftPass');
D23 = drift ('D23',0.350000,'DriftPass');
D24 = drift ('D24',0.350000,'DriftPass');
D25 = drift ('D25',0.150000,'DriftPass');
D26 = drift ('D26',0.200000,'DriftPass');
D31 = drift ('D31',0.150000,'DriftPass');
D32 = drift ('D32',0.400000,'DriftPass');
D33 = drift ('D33',0.150000,'DriftPass');
D34 = drift ('D34',0.200000,'DriftPass');
D35 = drift ('D35',2.200000,'DriftPass');
D41 = drift ('D41',0.150000,'DriftPass');
D42 = drift ('D42',0.200000,'DriftPass');
D43 = drift ('D43',0.660000,'DriftPass');
D44 = drift ('D44',0.150000,'DriftPass');
D45 = drift ('D45',1.150000,'DriftPass');

%Standard Cell Dipoles
BE = sbend ('BE', 1.488508, Ab, Ab/2, Ab/2, -0.522689,'BndMPoleSymplectic4Pass') ;
BM = sbend ('BM', 1.488508, Ab, Ab/2, Ab/2,  -0.536727,'BndMPoleSymplectic4Pass') ;

COR =  corrector('COR',0.000001,[0 0],'CorrectorPass');


%Standard Cell Quadrupoles

QD1  =   quadrupole('QD1', 0.260000,  -1.650218, 'StrMPoleSymplectic4Pass');
QD2  =   quadrupole('QD2', 0.110000,   1.595127, 'StrMPoleSymplectic4Pass');
QD3  =   quadrupole('QD3', 0.110000,   0.508490, 'StrMPoleSymplectic4Pass');
QD4  =   quadrupole('QD4', 0.260000,  -2.498360, 'StrMPoleSymplectic4Pass');
QF1  =   quadrupole('QF1', 0.260000,   1.892468, 'StrMPoleSymplectic4Pass');
QF2  =   quadrupole('QF2', 0.260000,   2.023384, 'StrMPoleSymplectic4Pass');
QF3  =   quadrupole('QF3', 0.310000,   1.991437, 'StrMPoleSymplectic4Pass');
QF4  =   quadrupole('QF4', 0.310000,   1.560734, 'StrMPoleSymplectic4Pass');
QF5  =   quadrupole('QF5', 0.520000,   2.261012, 'StrMPoleSymplectic4Pass');
QF6  =   quadrupole('QF6', 0.310000,   1.942569, 'StrMPoleSymplectic4Pass');

%Standard Cell Sextupoles
SD1		=	sextupole('SD1' , 0.15, -14.31248,'StrMPoleSymplectic4Pass');
SF1		=	sextupole('SF1' , 0.15, 13.01046,'StrMPoleSymplectic4Pass');
SD2		=	sextupole('SD2' , 0.15, -37.17014,'StrMPoleSymplectic4Pass');
SF2		=	sextupole('SF2' , 0.15,44.6602533333333 ,'StrMPoleSymplectic4Pass');
SD3		=	sextupole('SD3' , 0.15, -26.6805133333333,'StrMPoleSymplectic4Pass');
SF3		=	sextupole('SF3' , 0.15, 45.5835266666667,'StrMPoleSymplectic4Pass');
SD4		=	sextupole('SD4' , 0.15,-48.9656 ,'StrMPoleSymplectic4Pass');
SF4		=	sextupole('SF4' , 0.15, 14.7763933333333,'StrMPoleSymplectic4Pass');
SD5		=	sextupole('SD5' , 0.15, -25.8782066666667,'StrMPoleSymplectic4Pass');




%Cells
BLOCK1 = [D11 BPM QD1 D12 COR QF1 D13 SF1 D13 QF2 BPM D14 SD1 D15];
BLOCK2 = [D21 QD2 COR BPM D22 SD2 D23 QF3 BPM D13 SF2 D13 QF4 BPM D24 SD3 D25 COR QD3 D26];
BLOCK3 = [D31 SD4 D32 BPM QF5 D33 SF3 COR D34 QD4 BPM D35];
BLOCK4 = [D41 COR SD5 D43 BPM QF6 D44 SF4 D45];
ARC =    [BLOCK1 BE BLOCK2 BM BLOCK3 reverse(BLOCK3) BM ...
          BLOCK4 BPM reverse(BLOCK4) BM BLOCK3 reverse(BLOCK3) ...
          BM BLOCK4 BPM reverse(BLOCK4) BM BLOCK3 reverse(BLOCK3)...
          BM reverse(BLOCK2) BE reverse(BLOCK1)];

ELIST	= [ARC ARC CAV ARC ARC];


buildlat(ELIST);

% Compute total length and RF frequency
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
fprintf('   Model ring circumference is %.6f meters\n', L0_tot)
fprintf('   Model RF frequency is %.6f MHz\n', HarmNumber*C0/L0_tot/1e6)


clear global FAMLIST
%clear global GLOBVAL when GWig... has been changed.

%evalin('caller','global THERING FAMLIST GLOBVAL');

