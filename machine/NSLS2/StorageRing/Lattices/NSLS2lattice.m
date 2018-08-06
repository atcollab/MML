function NSLS2lattice
fprintf('   Loading NSLS-II lattice (%s)\n', mfilename);

global FAMLIST THERING
FAMLIST=cell(0);
Energy = 3.0; % In GeV

% AP = aperture('AP',[-1, 1, -1, 1],'AperturePass');

TPW = monitor('TPW','IdentityPass'); % Three-pole wiggler


%{***** RF cavity *****}
L0=791.958; % design circumference [m]
C0=299792458; % speed of light [m/s]
HarmNumber=1320;
Frf = C0/L0*HarmNumber; %499.68 MHz
CAV = rfcavity('CAV', 0, 2.5e6, Frf, HarmNumber, 'CavityPass');


%{***** Beam position monitors *****}
BPM = monitor('BPM','IdentityPass');


%{***** Correctors *****}
HCM=corrector('HCM', 0, [0 0], 'CorrectorPass');
VCM=corrector('VCM', 0, [0 0], 'CorrectorPass');

%{***** Skew quadrupoles *****}
SQ = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');


%{***** Drifts *****}
DHS1A=drift('DHS1A', 4.000, 'DriftPass');
DHS1B=drift('DHS1B', 0.650, 'DriftPass');
DLS1A=drift('DLS1A', 3.000, 'DriftPass');
DLS1B=drift('DLS1B', 0.300, 'DriftPass');

DH1A =drift('DH1A',  0.100, 'DriftPass');
DH1B =drift('DH1B',  0.050, 'DriftPass');
DH2A =drift('DH2A',  0.245, 'DriftPass');
DH2B =drift('DH2B',  0.245, 'DriftPass');
DH3  =drift('DH3',   0.150, 'DriftPass');
DH4  =drift('DH4',   0.190, 'DriftPass');
DH5  =drift('DH5',   0.200, 'DriftPass');
DH6A =drift('DH6A',  0.050, 'DriftPass');
DH6B =drift('DH6B',  0.100, 'DriftPass');
DH7A =drift('DH7A',  0.250, 'DriftPass');
DH7B =drift('DH7B',  0.300, 'DriftPass');

DL1A =drift('DL1A',  0.100, 'DriftPass');
DL1B =drift('DL1B',  0.050, 'DriftPass');
DL2A =drift('DL2A',  0.250, 'DriftPass');
DL2B =drift('DL2B',  0.250, 'DriftPass');
DL3  =drift('DL3',   0.250, 'DriftPass');
DL4  =drift('DL4',   0.3886, 'DriftPass');
DL5  =drift('DL5',   0.150, 'DriftPass');
DL6A =drift('DL6A',  0.050, 'DriftPass');
DL6B =drift('DL6B',  0.225, 'DriftPass');
DL6C =drift('DL6C',  0.275, 'DriftPass');

DM1A =drift('DM1A', 0.650, 'DriftPass');
DM1B =drift('DM1B', 0.250, 'DriftPass');
DM1C =drift('DM1C', 0.050, 'DriftPass');
DM2  =drift('DM2',  0.150, 'DriftPass');
DM3  =drift('DM3',  0.620, 'DriftPass');
DM4  =drift('DM4',  0.250, 'DriftPass');
DM5A =drift('DM5A', 0.050, 'DriftPass');
DM5B =drift('DM5B', 0.200, 'DriftPass');
DM6  =drift('DM6',  0.620, 'DriftPass');
DM7  =drift('DM7',  0.150, 'DriftPass');
DM8A =drift('DM8A', 0.050, 'DriftPass');
DM8B =drift('DM8B', 0.325, 'DriftPass');
DM8C =drift('DM8C', 0.275, 'DriftPass');
DM8D =drift('DM8D', 0.300, 'DriftPass');


%{***** Quadrupoles *****}
QH1=quadrupole('QH1', 0.300, -0.621453, 'StrMPoleSymplectic4Pass');
QH2=quadrupole('QH2', 0.400,  1.668877, 'StrMPoleSymplectic4Pass');
QH3=quadrupole('QH3', 0.300, -1.551548, 'StrMPoleSymplectic4Pass');
QM1=quadrupole('QM1', 0.300, -0.685803, 'StrMPoleSymplectic4Pass');
QM2=quadrupole('QM2', 0.300,  1.159750, 'StrMPoleSymplectic4Pass');
QL1=quadrupole('QL1', 0.300, -1.316453, 'StrMPoleSymplectic4Pass');
QL2=quadrupole('QL2', 0.400,  2.117711, 'StrMPoleSymplectic4Pass');
QL3=quadrupole('QL3', 0.300, -1.538644, 'StrMPoleSymplectic4Pass');


%{***** Dipole ******}
BEND=rbend('BEND',2.62,pi/30,pi/60,pi/60, 0.0,'BndMPoleSymplectic4Pass');


%{***** Sextupoles *****}
SH1=sextupole('SH1', 0.20,  0.975485/0.20, 'StrMPoleSymplectic4Pass');
SH2=sextupole('SH2', 0.20,  1.576651/0.20, 'StrMPoleSymplectic4Pass');
SH3=sextupole('SH3', 0.20, -1.884663/0.20, 'StrMPoleSymplectic4Pass');
SH4=sextupole('SH4', 0.20, -0.968570/0.20, 'StrMPoleSymplectic4Pass');

SL1=sextupole('SL1', 0.20,  1.996040/0.20, 'StrMPoleSymplectic4Pass');
SL2=sextupole('SL2', 0.20,  1.999802/0.20, 'StrMPoleSymplectic4Pass');
SL3=sextupole('SL3', 0.20, -1.997541/0.20, 'StrMPoleSymplectic4Pass');

SM1=sextupole('SM1', 0.25, -2.219245/0.25, 'StrMPoleSymplectic4Pass');
SM2=sextupole('SM2', 0.30,  3.100800/0.30, 'StrMPoleSymplectic4Pass');


%{***** Lattice *****}
HB   =[SH1,DH1A,BPM,DH1B,QH1,DH2A,HCM,VCM,   DH2B,SH2,DH3,QH2,DH4,SH3,...
    DH5,QH3,DH6A,BPM,DH6B,SH4,DH7A,HCM,VCM,DH7B];
HBSQ =[SH1,DH1A,BPM,DH1B,QH1,DH2A,HCM,VCM,SQ,DH2B,SH2,DH3,QH2,DH4,SH3,...
    DH5,QH3,DH6A,BPM,DH6B,SH4,DH7A,HCM,VCM,DH7B];

LB   =[SL1,DL1A,BPM,DL1B,QL1,DL2A,HCM,VCM,   DL2B,SL2,DL3,QL2,DL4,SL3,...
    DL5,QL3,DL6A,BPM,DL6B,HCM,VCM,DL6C];


DBA   =[BEND,DM1A,HCM,VCM,   DM1B,BPM,DM1C,QM1,DM2,SM1,DM3,QM2,DM4,SM2,...
    DM5A,BPM,DM5B,QM2,DM6,SM1,DM7,QM1,DM8A,BPM,DM8B,HCM,VCM,DM8C,TPW,DM8D,BEND];

DBASQ =[BEND,DM1A,HCM,VCM,SQ,DM1B,BPM,DM1C,QM1,DM2,SM1,DM3,QM2,DM4,SM2,...
    DM5A,BPM,DM5B,QM2,DM6,SM1,DM7,QM1,DM8A,BPM,DM8B,HCM,VCM,DM8C,TPW,DM8D,BEND];



HS=[DHS1B,BPM,DHS1A,DHS1A,BPM,DHS1B];
CAVS=[DHS1B,BPM,DHS1A,CAV,DHS1A,BPM,DHS1B];
LS=[DLS1B,BPM,DLS1A,DLS1A,BPM,DLS1B];

CELL=[HBSQ,DBASQ,reverse(LB),LS,LB,DBA,reverse(HB),HS];
CAVCELL=[HBSQ,DBASQ,reverse(LB),LS,LB,DBA,reverse(HB),CAVS];

RING=[CELL CELL CELL CELL CELL ...
      CELL CELL CELL CELL CELL ...
      CELL CELL CELL CELL CAVCELL ];


buildlat(RING);
evalin('caller','global THERING FAMLIST');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy*1e9);

clear global FAMLIST
evalin('base','clear LOSSFLAG');

% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f     (design length is %.6f m)\n', L0_tot, L0);

% Match the RF to the model length
i = findcells(THERING,'FamName','CAV');
THERING{i}.Frequency = HarmNumber*C0/L0_tot;

