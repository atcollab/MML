function nsls2_tracy_aug2007
fprintf('   Loading AT lattice (%s)\n', mfilename);

global FAMLIST THERING
FAMLIST=cell(0);
AP = aperture('AP',[-0.035, 0.035, -0.017, 0.017],'AperturePass');
Energy = 3.0;
BPM = monitor('BPM','IdentityPass');
HCM=corrector('HCM', 0, [0 0], 'CorrectorPass');
VCM=corrector('VCM', 0, [0 0], 'CorrectorPass');
BHV=[ BPM, HCM, VCM ];

D0=drift('D0', 4.278633, 'DriftPass');
D1A=drift('D1A', 0.150000, 'DriftPass');
D1BH=drift('D1BH', 0.200000, 'DriftPass');
D2A=drift('D2A', 0.150000, 'DriftPass');
D3A=drift('D3A', 0.150000, 'DriftPass');
D3B=drift('D3B', 0.150000, 'DriftPass');
D4A=drift('D4A', 0.150000, 'DriftPass');
D4B1=drift('D4B1', 0.300000, 'DriftPass');
D4B2=drift('D4B2', 0.390000, 'DriftPass');
D5B=drift('D5B', 0.300000, 'DriftPass');
D5W=drift('D5W', 0.200000, 'DriftPass');
DPW=drift('DPW', 0.200000, 'DriftPass');
D5C=drift('D5C', 0.250000, 'DriftPass');
D5A=drift('D5A', 0.150000, 'DriftPass');
D6A=drift('D6A', 0.255003, 'DriftPass');
D6B=drift('D6B', 0.150000, 'DriftPass');
D7=drift('D7', 0.255000, 'DriftPass');
DCH=drift('DCH', 0.150000, 'DriftPass');
D44A=drift('D44A', 0.200000, 'DriftPass');
DHVC=drift('DHVC', 0.150000, 'DriftPass');
D4L1=drift('D4L1', 0.135000, 'DriftPass');
D4L2=drift('D4L2', 0.135000, 'DriftPass');
D33A=drift('D33A', 0.150000, 'DriftPass');
D33B=drift('D33B', 0.150000, 'DriftPass');
D22AH=drift('D22AH', 0.200000, 'DriftPass');
D22B=drift('D22B', 0.150000, 'DriftPass');
D11A=drift('D11A', 0.000000, 'DriftPass');
D11B=drift('D11B', 0.150000, 'DriftPass');
D00=drift('D00', 3.300000, 'DriftPass');
DSX=drift('DSX', 0.100000, 'DriftPass');
DSD=drift('DSD', 0.125000, 'DriftPass');
QF1=quadrupole('QF1', 0.300000, 1.579688, 'StrMPoleSymplectic4Pass');
QD1=quadrupole('QD1', 0.300000, -1.110258, 'StrMPoleSymplectic4Pass');
QCH=quadrupole('QCH', 0.100000, -0.467815, 'StrMPoleSymplectic4Pass');
Q2=quadrupole('Q2', 0.300000, -0.722766, 'StrMPoleSymplectic4Pass');
Q3=quadrupole('Q3', 0.400000, 1.732898, 'StrMPoleSymplectic4Pass');
Q4=quadrupole('Q4', 0.300000, -1.415981, 'StrMPoleSymplectic4Pass');
Q22=quadrupole('Q22', 0.300000, -1.191968, 'StrMPoleSymplectic4Pass');
Q33=quadrupole('Q33', 0.500000, 1.840455, 'StrMPoleSymplectic4Pass');
Q44=quadrupole('Q44', 0.300000, -1.632527, 'StrMPoleSymplectic4Pass');
B1=rbend('B1', 2.620000, 6.000000*pi/180, 3.000000*pi/180, 3.000000*pi/180, 0.000000, 'BndMPoleSymplectic4Pass');
S1=sextupole('S1', 0.000000, -197255300.000000, 'StrMPoleSymplectic4Pass');
S2=sextupole('S2', 0.000000, 400000000.000000, 'StrMPoleSymplectic4Pass');
S3=sextupole('S3', 0.000000, -173534200.000000, 'StrMPoleSymplectic4Pass');
SD1=sextupole('SD1', 0.000000, -357484000.000000, 'StrMPoleSymplectic4Pass');
SF1=sextupole('SF1', 0.000000, 305429300.000000, 'StrMPoleSymplectic4Pass');
SF2H=sextupole('SF2H', 0.000000, -57360500.000000, 'StrMPoleSymplectic4Pass');
SL1=sextupole('SL1', 0.000000, -57435600.000000, 'StrMPoleSymplectic4Pass');
SL2=sextupole('SL2', 0.000000, 281086200.000000, 'StrMPoleSymplectic4Pass');
SL3=sextupole('SL3', 0.000000, -166319500.000000, 'StrMPoleSymplectic4Pass');
SL4=sextupole('SL4', 0.000000, -116814100.000000, 'StrMPoleSymplectic4Pass');
SQ = monitor('SQ','IdentityPass');
MP = monitor('MP','IdentityPass');
SS = monitor('SS','IdentityPass');
LS = monitor('LS','IdentityPass');
GS = monitor('GS','IdentityPass');
GE = monitor('GE','IdentityPass');
TPW = monitor('TPW','IdentityPass');
CAV=rfcavity('CAV', 0, 5000000.000000, 499679963.937527, 1320.000000, 'CavityPass');
LB=[ D11A,DSX,S1,DSX, D11B, BPM,Q22, D22AH,HCM,VCM,D22AH,    DSX, S2, DSX, D22B, Q33, D33A,    DSX, S3, DSX, D33B, Q44, BPM, D44A,    D4L1, DHVC, HCM, VCM];

HB=[ DSX,SL1,DSX,D1A,Q2,BPM, D2A, DSX,SL2,DSX,    D1BH, HCM, VCM, D1BH, Q3, D3A,    DSX, SL3, DSX, D3B, Q4, BPM, D4A,    DSX, SL4, DSX , D4B1, HCM, VCM];

HB_SQ=[ DSX, SL1, DSX, D1A, Q2, BPM, D2A, DSX,SL2,DSX,       D1BH, SQ, HCM, VCM, D1BH,Q3, D3A,       DSX, SL3, DSX, D3B, Q4, BPM, D4A,       DSX, SL4, DSX , D4B1, HCM, VCM];

DISP=[  D5C, VCM, HCM,  D5B, DSD, SD1, DSD,       D5A, BPM, QD1, D6A, DSD, SF1, DSD, D6B, QF1,D7,       DSX, SF2H, DSX ];

DISP_SQ=[ D5C,VCM, HCM,SQ,D5B, DSD, SD1, DSD,         D5A,BPM, QD1, D6A, DSD, SF1, DSD, D6B, QF1,D7,         DSX, SF2H, DSX ];

DBA=[ B1, D5W, DPW,     GS, DISP, DCH, QCH, MP, QCH, DCH, reverse(DISP), GE,     DPW,D5W, B1];

DBA_SQ=[ B1, D5W, DPW,        GS, DISP_SQ,DCH, QCH, MP, QCH, DCH, reverse(DISP), GE,        DPW, D5W, B1];

LINE=[ D0, GS, HB_SQ, GE, D4B2, DBA_SQ, D4L2, GS, reverse(LB), GE, D00, SS,      D00, GS, LB, GE, D4L2, DBA, D4B2, GS, reverse(HB), GE, D0, LS];

RING=[ 
    LINE, LINE, LINE, LINE, LINE, ...
    LINE, LINE, LINE, LINE, LINE, ...
    LINE, LINE, LINE, LINE, LINE, CAV];

buildlat(RING);
evalin('caller','global THERING FAMLIST GLOBVAL');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy*1e9);
clear global FAMLIST
evalin('base','clear LOSSFLAG');
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f\n', L0_tot);
