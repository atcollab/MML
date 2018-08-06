function nsls2atlat2012Aug
fprintf('   Loading AT lattice (%s)\n', mfilename);

global FAMLIST THERING
Energy = 3.00e9;
GLOBVAL.E0 = Energy;  % This might disappear in the future
GLOBVAL.LatticeFile = 'nsls2atlat2012Aug';
FAMLIST=cell(0);
c0       = 299792458; % speed of light in vacuum [m/s]
Harm_Num = 1320;
quad_int_meth = 'StrMPoleSymplectic4Pass';
bend_int_meth = 'BndMPoleSymplectic4Pass';
CAV=rfcavity('CAV', 0, 5000000.000000, 499680594.880032, 1320.000000, 'CavityPass');

AP = aperture('AP',[-0.035, 0.035, -0.017, 0.017],'AperturePass');
DWMKM=drift('DWMKM', 3.510000, 'DriftPass');
DWSIN=drift('DWSIN', 3.510000, 'DriftPass');
IVUSIN=drift('IVUSIN', 1.500000, 'DriftPass');
IVUKM=drift('IVUKM', 1.500000, 'DriftPass');
IVUI=drift('IVUI', 1.800000, 'DriftPass');
IVU0=drift('IVU0', 1.500000, 'DriftPass');
IVUSTR=drift('IVUSTR', 3.300000, 'DriftPass');
DWI=drift('DWI', 1.140000, 'DriftPass');
DWKM=drift('DWKM', 3.510000, 'DriftPass');
DWSTR=drift('DWSTR', 4.650000, 'DriftPass');
DH0G1A=drift('DH0G1A', 4.650000, 'DriftPass');
DH1AG2A=drift('DH1AG2A', 0.087500, 'DriftPass');
DBPM=drift('DBPM', 0.087500, 'DriftPass');
DH2AG2A=drift('DH2AG2A', 0.157500, 'DriftPass');
DH2BG2A=drift('DH2BG2A', 0.157500, 'DriftPass');
DH2CG2A=drift('DH2CG2A', 0.150000, 'DriftPass');
DH3AG2A=drift('DH3AG2A', 0.190000, 'DriftPass');
DH3BG2A=drift('DH3BG2A', 0.195000, 'DriftPass');
DH4AG2A=drift('DH4AG2A', 0.087500, 'DriftPass');
DH4BG2A=drift('DH4BG2A', 0.248500, 'DriftPass');
DFCH=drift('DFCH', 0.150000, 'DriftPass');
DH4CG3A=drift('DH4CG3A', 0.031500, 'DriftPass');
DM1AG3A=drift('DM1AG3A', 0.365000, 'DriftPass');
DM1BG3A=drift('DM1BG3A', 0.310000, 'DriftPass');
DM2AG4A=drift('DM2AG4A', 0.200000, 'DriftPass');
DM2BG4A=drift('DM2BG4A', 0.582500, 'DriftPass');
DM2CG4A=drift('DM2CG4A', 0.200000, 'DriftPass');
DM2CG4B=drift('DM2CG4B', 0.200000, 'DriftPass');
DM2BG4B=drift('DM2BG4B', 0.520000, 'DriftPass');
DM2AG4B=drift('DM2AG4B', 0.262500, 'DriftPass');
DM1EG4B=drift('DM1EG4B', 0.219600, 'DriftPass');
DM1DG5B=drift('DM1DG5B', 0.055400, 'DriftPass');
DPWG5B=drift('DPWG5B', 0.200000, 'DriftPass');
DM1CG5B=drift('DM1CG5B', 0.200000, 'DriftPass');
DL4BG6B=drift('DL4BG6B', 0.187800, 'DriftPass');
DL4AG6B=drift('DL4AG6B', 0.112200, 'DriftPass');
DL3BG6B=drift('DL3BG6B', 0.087500, 'DriftPass');
DL3AG6B=drift('DL3AG6B', 0.613600, 'DriftPass');
DL2CG6B=drift('DL2CG6B', 0.250000, 'DriftPass');
DL2BG6B=drift('DL2BG6B', 0.137500, 'DriftPass');
DSCH=drift('DSCH', 0.100000, 'DriftPass');
DL2AG6B=drift('DL2AG6B', 0.137500, 'DriftPass');
DL1AG6B=drift('DL1AG6B', 0.087500, 'DriftPass');
DL0G1B=drift('DL0G1B', 3.300000, 'DriftPass');
DL1AG2B=drift('DL1AG2B', 0.087500, 'DriftPass');
DL2AG2B=drift('DL2AG2B', 0.137500, 'DriftPass');
DL2BG2B=drift('DL2BG2B', 0.137500, 'DriftPass');
DL2CG2B=drift('DL2CG2B', 0.250000, 'DriftPass');
DL3AG2B=drift('DL3AG2B', 0.613600, 'DriftPass');
DL3BG2B=drift('DL3BG2B', 0.087500, 'DriftPass');
DL4AG2B=drift('DL4AG2B', 0.281700, 'DriftPass');
DL4BG3B=drift('DL4BG3B', 0.018300, 'DriftPass');
DM1AG3B=drift('DM1AG3B', 0.365000, 'DriftPass');
DM1BG3B=drift('DM1BG3B', 0.310000, 'DriftPass');
DM2A2G4B=drift('DM2A2G4B', 0.200000, 'DriftPass');
DM2B2G4B=drift('DM2B2G4B', 0.582500, 'DriftPass');
DM2B2G4A=drift('DM2B2G4A', 0.520000, 'DriftPass');
DM2A2G4A=drift('DM2A2G4A', 0.262500, 'DriftPass');
DM1EG4A=drift('DM1EG4A', 0.219600, 'DriftPass');
DM1DG5A=drift('DM1DG5A', 0.055400, 'DriftPass');
DPWG5A=drift('DPWG5A', 0.200000, 'DriftPass');
DM1CG5A=drift('DM1CG5A', 0.200000, 'DriftPass');
DH4CG6A=drift('DH4CG6A', 0.202860, 'DriftPass');
DH4BG6A=drift('DH4BG6A', 0.077140, 'DriftPass');
DH4AG6A=drift('DH4AG6A', 0.087500, 'DriftPass');
DH3BG6A=drift('DH3BG6A', 0.195000, 'DriftPass');
DH3AG6A=drift('DH3AG6A', 0.190000, 'DriftPass');
DH2CG6A=drift('DH2CG6A', 0.150000, 'DriftPass');
DH2BG6A=drift('DH2BG6A', 0.182500, 'DriftPass');
DH2AG6A=drift('DH2AG6A', 0.132500, 'DriftPass');
DH1AG6A=drift('DH1AG6A', 0.087500, 'DriftPass');
CH1XG2C30A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C30A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C30A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C30B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C30B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C30B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C01B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C01B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C01B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C01A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C01A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C01A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C30A = monitor('MK4G1C30A','IdentityPass');
MK1G3C30A = monitor('MK1G3C30A','IdentityPass');
MK3G4C30B = monitor('MK3G4C30B','IdentityPass');
MK2G5C30B = monitor('MK2G5C30B','IdentityPass');
MK5G1C01B = monitor('MK5G1C01B','IdentityPass');
MK1G3C01B = monitor('MK1G3C01B','IdentityPass');
MK3G4C01A = monitor('MK3G4C01A','IdentityPass');
MK2G5C01A = monitor('MK2G5C01A','IdentityPass');
PH1G2C30A = monitor('BPM','IdentityPass');
PH2G2C30A = monitor('BPM','IdentityPass');
PM1G4C30A = monitor('BPM','IdentityPass');
PM1G4C30B = monitor('BPM','IdentityPass');
PL1G6C30B = monitor('BPM','IdentityPass');
PL2G6C30B = monitor('BPM','IdentityPass');
PL1G2C01B = monitor('BPM','IdentityPass');
PL2G2C01B = monitor('BPM','IdentityPass');
PM1G4C01B = monitor('BPM','IdentityPass');
PM1G4C01A = monitor('BPM','IdentityPass');
PH2G6C01A = monitor('BPM','IdentityPass');
PH1G6C01A = monitor('BPM','IdentityPass');
GEG1C30A = monitor('GE','IdentityPass');
GSG2C30A = monitor('GS','IdentityPass');
GEG2C30A = monitor('GE','IdentityPass');
GSG3C30A = monitor('GS','IdentityPass');
GEG3C30A = monitor('GE','IdentityPass');
GSG4C30A = monitor('GS','IdentityPass');
GEG4C30B = monitor('GE','IdentityPass');
GSG5C30B = monitor('GS','IdentityPass');
GEG5C30B = monitor('GE','IdentityPass');
GSG6C30B = monitor('GS','IdentityPass');
GEG6C30B = monitor('GE','IdentityPass');
GSG1C01B = monitor('GS','IdentityPass');
GEG1C01B = monitor('GE','IdentityPass');
GSG2C01B = monitor('GS','IdentityPass');
GEG2C01B = monitor('GE','IdentityPass');
GSG3C01B = monitor('GS','IdentityPass');
GEG3C01B = monitor('GE','IdentityPass');
GSG4C01B = monitor('GS','IdentityPass');
GEG4C01A = monitor('GE','IdentityPass');
GSG5C01A = monitor('GS','IdentityPass');
GEG5C01A = monitor('GE','IdentityPass');
GSG6C01A = monitor('GS','IdentityPass');
GEG6C01A = monitor('GE','IdentityPass');
GSG1C02A = monitor('GS','IdentityPass');
QH1G2C30A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C30A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C30A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C30A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C30A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C30A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C30B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C30B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C30B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C30B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C30B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C01B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C01B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C01B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C01B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C01B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C01B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C01A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C01A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C01A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C01A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C01A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C30A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C30B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C01B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C01A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C30A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C30A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C30A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C30A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C30A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C30B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C30B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C30B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C30B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C30B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C01B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C01B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C01B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C01B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C01A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C01A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C01A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C01A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C01A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C01A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C30A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C30A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C30A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C30B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C30B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C30B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C01B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C01B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C01B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C01A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C01A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C01A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C02A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C02A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C02A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C02B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C02B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C02B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C03B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C03B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C03B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C03A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C03A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C03A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C02A = monitor('MK4G1C02A','IdentityPass');
MK1G3C02A = monitor('MK1G3C02A','IdentityPass');
MK3G4C02B = monitor('MK3G4C02B','IdentityPass');
MK2G5C02B = monitor('MK2G5C02B','IdentityPass');
MK5G1C03B = monitor('MK5G1C03B','IdentityPass');
MK1G3C03B = monitor('MK1G3C03B','IdentityPass');
MK3G4C03A = monitor('MK3G4C03A','IdentityPass');
MK2G5C03A = monitor('MK2G5C03A','IdentityPass');
PH1G2C02A = monitor('BPM','IdentityPass');
PH2G2C02A = monitor('BPM','IdentityPass');
PM1G4C02A = monitor('BPM','IdentityPass');
PM1G4C02B = monitor('BPM','IdentityPass');
PL1G6C02B = monitor('BPM','IdentityPass');
PL2G6C02B = monitor('BPM','IdentityPass');
PL1G2C03B = monitor('BPM','IdentityPass');
PL2G2C03B = monitor('BPM','IdentityPass');
PM1G4C03B = monitor('BPM','IdentityPass');
PM1G4C03A = monitor('BPM','IdentityPass');
PH2G6C03A = monitor('BPM','IdentityPass');
PH1G6C03A = monitor('BPM','IdentityPass');
GEG1C02A = monitor('GE','IdentityPass');
GSG2C02A = monitor('GS','IdentityPass');
GEG2C02A = monitor('GE','IdentityPass');
GSG3C02A = monitor('GS','IdentityPass');
GEG3C02A = monitor('GE','IdentityPass');
GSG4C02A = monitor('GS','IdentityPass');
GEG4C02B = monitor('GE','IdentityPass');
GSG5C02B = monitor('GS','IdentityPass');
GEG5C02B = monitor('GE','IdentityPass');
GSG6C02B = monitor('GS','IdentityPass');
GEG6C02B = monitor('GE','IdentityPass');
GSG1C03B = monitor('GS','IdentityPass');
GEG1C03B = monitor('GE','IdentityPass');
GSG2C03B = monitor('GS','IdentityPass');
GEG2C03B = monitor('GE','IdentityPass');
GSG3C03B = monitor('GS','IdentityPass');
GEG3C03B = monitor('GE','IdentityPass');
GSG4C03B = monitor('GS','IdentityPass');
GEG4C03A = monitor('GE','IdentityPass');
GSG5C03A = monitor('GS','IdentityPass');
GEG5C03A = monitor('GE','IdentityPass');
GSG6C03A = monitor('GS','IdentityPass');
GEG6C03A = monitor('GE','IdentityPass');
GSG1C04A = monitor('GS','IdentityPass');
QH1G2C02A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C02A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C02A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C02A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C02A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C02A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C02B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C02B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C02B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C02B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C02B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C03B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C03B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C03B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C03B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C03B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C03B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C03A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C03A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C03A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C03A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C03A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C02A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C02B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C03B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C03A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C02A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C02A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C02A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C02A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C02A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C02B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C02B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C02B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C02B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C02B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C03B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C03B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C03B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C03B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C03A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C03A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C03A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C03A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C03A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C03A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C02A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C02A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C02A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C02B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C02B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C02B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C03B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C03B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C03B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C03A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C03A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C03A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C04A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C04A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C04A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C04B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C04B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C04B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C05B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C05B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C05B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C05A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C05A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C05A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C04A = monitor('MK4G1C04A','IdentityPass');
MK1G3C04A = monitor('MK1G3C04A','IdentityPass');
MK3G4C04B = monitor('MK3G4C04B','IdentityPass');
MK2G5C04B = monitor('MK2G5C04B','IdentityPass');
MK5G1C05B = monitor('MK5G1C05B','IdentityPass');
MK1G3C05B = monitor('MK1G3C05B','IdentityPass');
MK3G4C05A = monitor('MK3G4C05A','IdentityPass');
MK2G5C05A = monitor('MK2G5C05A','IdentityPass');
PH1G2C04A = monitor('BPM','IdentityPass');
PH2G2C04A = monitor('BPM','IdentityPass');
PM1G4C04A = monitor('BPM','IdentityPass');
PM1G4C04B = monitor('BPM','IdentityPass');
PL1G6C04B = monitor('BPM','IdentityPass');
PL2G6C04B = monitor('BPM','IdentityPass');
PL1G2C05B = monitor('BPM','IdentityPass');
PL2G2C05B = monitor('BPM','IdentityPass');
PM1G4C05B = monitor('BPM','IdentityPass');
PM1G4C05A = monitor('BPM','IdentityPass');
PH2G6C05A = monitor('BPM','IdentityPass');
PH1G6C05A = monitor('BPM','IdentityPass');
GEG1C04A = monitor('GE','IdentityPass');
GSG2C04A = monitor('GS','IdentityPass');
GEG2C04A = monitor('GE','IdentityPass');
GSG3C04A = monitor('GS','IdentityPass');
GEG3C04A = monitor('GE','IdentityPass');
GSG4C04A = monitor('GS','IdentityPass');
GEG4C04B = monitor('GE','IdentityPass');
GSG5C04B = monitor('GS','IdentityPass');
GEG5C04B = monitor('GE','IdentityPass');
GSG6C04B = monitor('GS','IdentityPass');
GEG6C04B = monitor('GE','IdentityPass');
GSG1C05B = monitor('GS','IdentityPass');
GEG1C05B = monitor('GE','IdentityPass');
GSG2C05B = monitor('GS','IdentityPass');
GEG2C05B = monitor('GE','IdentityPass');
GSG3C05B = monitor('GS','IdentityPass');
GEG3C05B = monitor('GE','IdentityPass');
GSG4C05B = monitor('GS','IdentityPass');
GEG4C05A = monitor('GE','IdentityPass');
GSG5C05A = monitor('GS','IdentityPass');
GEG5C05A = monitor('GE','IdentityPass');
GSG6C05A = monitor('GS','IdentityPass');
GEG6C05A = monitor('GE','IdentityPass');
GSG1C06A = monitor('GS','IdentityPass');
QH1G2C04A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C04A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C04A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C04A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C04A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C04A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C04B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C04B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C04B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C04B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C04B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C05B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C05B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C05B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C05B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C05B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C05B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C05A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C05A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C05A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C05A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C05A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C04A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C04B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C05B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C05A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C04A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C04A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C04A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C04A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C04A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C04B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C04B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C04B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C04B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C04B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C05B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C05B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C05B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C05B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C05A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C05A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C05A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C05A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C05A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C05A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C04A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C04A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C04A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C04B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C04B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C04B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C05B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C05B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C05B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C05A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C05A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C05A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C06A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C06A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C06A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C06B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C06B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C06B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C07B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C07B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C07B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C07A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C07A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C07A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C06A = monitor('MK4G1C06A','IdentityPass');
MK1G3C06A = monitor('MK1G3C06A','IdentityPass');
MK3G4C06B = monitor('MK3G4C06B','IdentityPass');
MK2G5C06B = monitor('MK2G5C06B','IdentityPass');
MK5G1C07B = monitor('MK5G1C07B','IdentityPass');
MK1G3C07B = monitor('MK1G3C07B','IdentityPass');
MK3G4C07A = monitor('MK3G4C07A','IdentityPass');
MK2G5C07A = monitor('MK2G5C07A','IdentityPass');
PH1G2C06A = monitor('BPM','IdentityPass');
PH2G2C06A = monitor('BPM','IdentityPass');
PM1G4C06A = monitor('BPM','IdentityPass');
PM1G4C06B = monitor('BPM','IdentityPass');
PL1G6C06B = monitor('BPM','IdentityPass');
PL2G6C06B = monitor('BPM','IdentityPass');
PL1G2C07B = monitor('BPM','IdentityPass');
PL2G2C07B = monitor('BPM','IdentityPass');
PM1G4C07B = monitor('BPM','IdentityPass');
PM1G4C07A = monitor('BPM','IdentityPass');
PH2G6C07A = monitor('BPM','IdentityPass');
PH1G6C07A = monitor('BPM','IdentityPass');
GEG1C06A = monitor('GE','IdentityPass');
GSG2C06A = monitor('GS','IdentityPass');
GEG2C06A = monitor('GE','IdentityPass');
GSG3C06A = monitor('GS','IdentityPass');
GEG3C06A = monitor('GE','IdentityPass');
GSG4C06A = monitor('GS','IdentityPass');
GEG4C06B = monitor('GE','IdentityPass');
GSG5C06B = monitor('GS','IdentityPass');
GEG5C06B = monitor('GE','IdentityPass');
GSG6C06B = monitor('GS','IdentityPass');
GEG6C06B = monitor('GE','IdentityPass');
GSG1C07B = monitor('GS','IdentityPass');
GEG1C07B = monitor('GE','IdentityPass');
GSG2C07B = monitor('GS','IdentityPass');
GEG2C07B = monitor('GE','IdentityPass');
GSG3C07B = monitor('GS','IdentityPass');
GEG3C07B = monitor('GE','IdentityPass');
GSG4C07B = monitor('GS','IdentityPass');
GEG4C07A = monitor('GE','IdentityPass');
GSG5C07A = monitor('GS','IdentityPass');
GEG5C07A = monitor('GE','IdentityPass');
GSG6C07A = monitor('GS','IdentityPass');
GEG6C07A = monitor('GE','IdentityPass');
GSG1C08A = monitor('GS','IdentityPass');
QH1G2C06A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C06A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C06A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C06A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C06A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C06A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C06B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C06B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C06B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C06B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C06B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C07B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C07B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C07B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C07B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C07B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C07B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C07A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C07A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C07A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C07A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C07A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C06A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C06B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C07B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C07A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C06A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C06A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C06A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C06A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C06A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C06B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C06B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C06B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C06B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C06B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C07B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C07B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C07B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C07B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C07A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C07A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C07A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C07A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C07A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C07A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C06A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C06A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C06A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C06B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C06B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C06B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C07B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C07B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C07B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C07A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C07A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C07A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C08A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C08A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C08A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C08B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C08B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C08B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C09B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C09B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C09B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C09A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C09A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C09A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C08A = monitor('MK4G1C08A','IdentityPass');
MK1G3C08A = monitor('MK1G3C08A','IdentityPass');
MK3G4C08B = monitor('MK3G4C08B','IdentityPass');
MK2G5C08B = monitor('MK2G5C08B','IdentityPass');
MK5G1C09B = monitor('MK5G1C09B','IdentityPass');
MK1G3C09B = monitor('MK1G3C09B','IdentityPass');
MK3G4C09A = monitor('MK3G4C09A','IdentityPass');
MK2G5C09A = monitor('MK2G5C09A','IdentityPass');
PH1G2C08A = monitor('BPM','IdentityPass');
PH2G2C08A = monitor('BPM','IdentityPass');
PM1G4C08A = monitor('BPM','IdentityPass');
PM1G4C08B = monitor('BPM','IdentityPass');
PL1G6C08B = monitor('BPM','IdentityPass');
PL2G6C08B = monitor('BPM','IdentityPass');
PL1G2C09B = monitor('BPM','IdentityPass');
PL2G2C09B = monitor('BPM','IdentityPass');
PM1G4C09B = monitor('BPM','IdentityPass');
PM1G4C09A = monitor('BPM','IdentityPass');
PH2G6C09A = monitor('BPM','IdentityPass');
PH1G6C09A = monitor('BPM','IdentityPass');
GEG1C08A = monitor('GE','IdentityPass');
GSG2C08A = monitor('GS','IdentityPass');
GEG2C08A = monitor('GE','IdentityPass');
GSG3C08A = monitor('GS','IdentityPass');
GEG3C08A = monitor('GE','IdentityPass');
GSG4C08A = monitor('GS','IdentityPass');
GEG4C08B = monitor('GE','IdentityPass');
GSG5C08B = monitor('GS','IdentityPass');
GEG5C08B = monitor('GE','IdentityPass');
GSG6C08B = monitor('GS','IdentityPass');
GEG6C08B = monitor('GE','IdentityPass');
GSG1C09B = monitor('GS','IdentityPass');
GEG1C09B = monitor('GE','IdentityPass');
GSG2C09B = monitor('GS','IdentityPass');
GEG2C09B = monitor('GE','IdentityPass');
GSG3C09B = monitor('GS','IdentityPass');
GEG3C09B = monitor('GE','IdentityPass');
GSG4C09B = monitor('GS','IdentityPass');
GEG4C09A = monitor('GE','IdentityPass');
GSG5C09A = monitor('GS','IdentityPass');
GEG5C09A = monitor('GE','IdentityPass');
GSG6C09A = monitor('GS','IdentityPass');
GEG6C09A = monitor('GE','IdentityPass');
GSG1C10A = monitor('GS','IdentityPass');
QH1G2C08A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C08A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C08A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C08A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C08A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C08A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C08B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C08B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C08B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C08B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C08B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C09B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C09B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C09B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C09B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C09B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C09B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C09A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C09A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C09A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C09A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C09A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C08A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C08B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C09B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C09A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C08A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C08A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C08A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C08A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C08A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C08B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C08B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C08B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C08B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C08B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C09B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C09B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C09B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C09B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C09A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C09A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C09A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C09A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C09A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C09A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C08A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C08A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C08A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C08B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C08B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C08B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C09B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C09B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C09B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C09A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C09A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C09A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C10A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C10A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C10A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C10B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C10B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C10B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C11B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C11B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C11B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C11A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C11A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C11A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C10A = monitor('MK4G1C10A','IdentityPass');
MK1G3C10A = monitor('MK1G3C10A','IdentityPass');
MK3G4C10B = monitor('MK3G4C10B','IdentityPass');
MK2G5C10B = monitor('MK2G5C10B','IdentityPass');
MK5G1C11B = monitor('MK5G1C11B','IdentityPass');
MK1G3C11B = monitor('MK1G3C11B','IdentityPass');
MK3G4C11A = monitor('MK3G4C11A','IdentityPass');
MK2G5C11A = monitor('MK2G5C11A','IdentityPass');
PH1G2C10A = monitor('BPM','IdentityPass');
PH2G2C10A = monitor('BPM','IdentityPass');
PM1G4C10A = monitor('BPM','IdentityPass');
PM1G4C10B = monitor('BPM','IdentityPass');
PL1G6C10B = monitor('BPM','IdentityPass');
PL2G6C10B = monitor('BPM','IdentityPass');
PL1G2C11B = monitor('BPM','IdentityPass');
PL2G2C11B = monitor('BPM','IdentityPass');
PM1G4C11B = monitor('BPM','IdentityPass');
PM1G4C11A = monitor('BPM','IdentityPass');
PH2G6C11A = monitor('BPM','IdentityPass');
PH1G6C11A = monitor('BPM','IdentityPass');
GEG1C10A = monitor('GE','IdentityPass');
GSG2C10A = monitor('GS','IdentityPass');
GEG2C10A = monitor('GE','IdentityPass');
GSG3C10A = monitor('GS','IdentityPass');
GEG3C10A = monitor('GE','IdentityPass');
GSG4C10A = monitor('GS','IdentityPass');
GEG4C10B = monitor('GE','IdentityPass');
GSG5C10B = monitor('GS','IdentityPass');
GEG5C10B = monitor('GE','IdentityPass');
GSG6C10B = monitor('GS','IdentityPass');
GEG6C10B = monitor('GE','IdentityPass');
GSG1C11B = monitor('GS','IdentityPass');
GEG1C11B = monitor('GE','IdentityPass');
GSG2C11B = monitor('GS','IdentityPass');
GEG2C11B = monitor('GE','IdentityPass');
GSG3C11B = monitor('GS','IdentityPass');
GEG3C11B = monitor('GE','IdentityPass');
GSG4C11B = monitor('GS','IdentityPass');
GEG4C11A = monitor('GE','IdentityPass');
GSG5C11A = monitor('GS','IdentityPass');
GEG5C11A = monitor('GE','IdentityPass');
GSG6C11A = monitor('GS','IdentityPass');
GEG6C11A = monitor('GE','IdentityPass');
GSG1C12A = monitor('GS','IdentityPass');
QH1G2C10A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C10A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C10A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C10A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C10A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C10A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C10B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C10B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C10B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C10B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C10B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C11B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C11B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C11B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C11B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C11B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C11B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C11A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C11A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C11A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C11A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C11A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C10A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C10B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C11B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C11A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C10A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C10A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C10A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C10A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C10A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C10B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C10B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C10B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C10B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C10B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C11B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C11B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C11B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C11B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C11A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C11A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C11A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C11A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C11A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C11A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C10A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C10A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C10A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C10B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C10B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C10B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C11B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C11B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C11B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C11A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C11A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C11A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C12A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C12A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C12A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C12B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C12B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C12B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C13B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C13B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C13B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C13A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C13A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C13A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C12A = monitor('MK4G1C12A','IdentityPass');
MK1G3C12A = monitor('MK1G3C12A','IdentityPass');
MK3G4C12B = monitor('MK3G4C12B','IdentityPass');
MK2G5C12B = monitor('MK2G5C12B','IdentityPass');
MK5G1C13B = monitor('MK5G1C13B','IdentityPass');
MK1G3C13B = monitor('MK1G3C13B','IdentityPass');
MK3G4C13A = monitor('MK3G4C13A','IdentityPass');
MK2G5C13A = monitor('MK2G5C13A','IdentityPass');
PH1G2C12A = monitor('BPM','IdentityPass');
PH2G2C12A = monitor('BPM','IdentityPass');
PM1G4C12A = monitor('BPM','IdentityPass');
PM1G4C12B = monitor('BPM','IdentityPass');
PL1G6C12B = monitor('BPM','IdentityPass');
PL2G6C12B = monitor('BPM','IdentityPass');
PL1G2C13B = monitor('BPM','IdentityPass');
PL2G2C13B = monitor('BPM','IdentityPass');
PM1G4C13B = monitor('BPM','IdentityPass');
PM1G4C13A = monitor('BPM','IdentityPass');
PH2G6C13A = monitor('BPM','IdentityPass');
PH1G6C13A = monitor('BPM','IdentityPass');
GEG1C12A = monitor('GE','IdentityPass');
GSG2C12A = monitor('GS','IdentityPass');
GEG2C12A = monitor('GE','IdentityPass');
GSG3C12A = monitor('GS','IdentityPass');
GEG3C12A = monitor('GE','IdentityPass');
GSG4C12A = monitor('GS','IdentityPass');
GEG4C12B = monitor('GE','IdentityPass');
GSG5C12B = monitor('GS','IdentityPass');
GEG5C12B = monitor('GE','IdentityPass');
GSG6C12B = monitor('GS','IdentityPass');
GEG6C12B = monitor('GE','IdentityPass');
GSG1C13B = monitor('GS','IdentityPass');
GEG1C13B = monitor('GE','IdentityPass');
GSG2C13B = monitor('GS','IdentityPass');
GEG2C13B = monitor('GE','IdentityPass');
GSG3C13B = monitor('GS','IdentityPass');
GEG3C13B = monitor('GE','IdentityPass');
GSG4C13B = monitor('GS','IdentityPass');
GEG4C13A = monitor('GE','IdentityPass');
GSG5C13A = monitor('GS','IdentityPass');
GEG5C13A = monitor('GE','IdentityPass');
GSG6C13A = monitor('GS','IdentityPass');
GEG6C13A = monitor('GE','IdentityPass');
GSG1C14A = monitor('GS','IdentityPass');
QH1G2C12A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C12A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C12A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C12A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C12A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C12A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C12B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C12B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C12B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C12B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C12B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C13B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C13B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C13B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C13B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C13B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C13B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C13A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C13A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C13A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C13A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C13A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C12A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C12B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C13B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C13A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C12A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C12A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C12A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C12A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C12A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C12B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C12B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C12B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C12B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C12B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C13B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C13B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C13B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C13B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C13A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C13A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C13A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C13A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C13A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C13A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C12A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C12A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C12A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C12B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C12B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C12B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C13B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C13B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C13B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C13A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C13A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C13A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C14A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C14A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C14A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C14B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C14B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C14B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C15B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C15B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C15B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C15A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C15A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C15A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C14A = monitor('MK4G1C14A','IdentityPass');
MK1G3C14A = monitor('MK1G3C14A','IdentityPass');
MK3G4C14B = monitor('MK3G4C14B','IdentityPass');
MK2G5C14B = monitor('MK2G5C14B','IdentityPass');
MK5G1C15B = monitor('MK5G1C15B','IdentityPass');
MK1G3C15B = monitor('MK1G3C15B','IdentityPass');
MK3G4C15A = monitor('MK3G4C15A','IdentityPass');
MK2G5C15A = monitor('MK2G5C15A','IdentityPass');
PH1G2C14A = monitor('BPM','IdentityPass');
PH2G2C14A = monitor('BPM','IdentityPass');
PM1G4C14A = monitor('BPM','IdentityPass');
PM1G4C14B = monitor('BPM','IdentityPass');
PL1G6C14B = monitor('BPM','IdentityPass');
PL2G6C14B = monitor('BPM','IdentityPass');
PL1G2C15B = monitor('BPM','IdentityPass');
PL2G2C15B = monitor('BPM','IdentityPass');
PM1G4C15B = monitor('BPM','IdentityPass');
PM1G4C15A = monitor('BPM','IdentityPass');
PH2G6C15A = monitor('BPM','IdentityPass');
PH1G6C15A = monitor('BPM','IdentityPass');
GEG1C14A = monitor('GE','IdentityPass');
GSG2C14A = monitor('GS','IdentityPass');
GEG2C14A = monitor('GE','IdentityPass');
GSG3C14A = monitor('GS','IdentityPass');
GEG3C14A = monitor('GE','IdentityPass');
GSG4C14A = monitor('GS','IdentityPass');
GEG4C14B = monitor('GE','IdentityPass');
GSG5C14B = monitor('GS','IdentityPass');
GEG5C14B = monitor('GE','IdentityPass');
GSG6C14B = monitor('GS','IdentityPass');
GEG6C14B = monitor('GE','IdentityPass');
GSG1C15B = monitor('GS','IdentityPass');
GEG1C15B = monitor('GE','IdentityPass');
GSG2C15B = monitor('GS','IdentityPass');
GEG2C15B = monitor('GE','IdentityPass');
GSG3C15B = monitor('GS','IdentityPass');
GEG3C15B = monitor('GE','IdentityPass');
GSG4C15B = monitor('GS','IdentityPass');
GEG4C15A = monitor('GE','IdentityPass');
GSG5C15A = monitor('GS','IdentityPass');
GEG5C15A = monitor('GE','IdentityPass');
GSG6C15A = monitor('GS','IdentityPass');
GEG6C15A = monitor('GE','IdentityPass');
GSG1C16A = monitor('GS','IdentityPass');
QH1G2C14A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C14A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C14A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C14A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C14A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C14A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C14B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C14B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C14B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C14B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C14B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C15B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C15B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C15B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C15B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C15B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C15B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C15A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C15A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C15A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C15A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C15A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C14A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C14B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C15B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C15A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C14A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C14A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C14A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C14A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C14A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C14B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C14B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C14B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C14B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C14B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C15B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C15B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C15B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C15B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C15A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C15A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C15A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C15A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C15A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C15A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C14A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C14A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C14A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C14B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C14B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C14B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C15B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C15B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C15B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C15A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C15A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C15A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C16A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C16A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C16A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C16B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C16B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C16B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C17B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C17B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C17B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C17A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C17A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C17A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C16A = monitor('MK4G1C16A','IdentityPass');
MK1G3C16A = monitor('MK1G3C16A','IdentityPass');
MK3G4C16B = monitor('MK3G4C16B','IdentityPass');
MK2G5C16B = monitor('MK2G5C16B','IdentityPass');
MK5G1C17B = monitor('MK5G1C17B','IdentityPass');
MK1G3C17B = monitor('MK1G3C17B','IdentityPass');
MK3G4C17A = monitor('MK3G4C17A','IdentityPass');
MK2G5C17A = monitor('MK2G5C17A','IdentityPass');
PH1G2C16A = monitor('BPM','IdentityPass');
PH2G2C16A = monitor('BPM','IdentityPass');
PM1G4C16A = monitor('BPM','IdentityPass');
PM1G4C16B = monitor('BPM','IdentityPass');
PL1G6C16B = monitor('BPM','IdentityPass');
PL2G6C16B = monitor('BPM','IdentityPass');
PL1G2C17B = monitor('BPM','IdentityPass');
PL2G2C17B = monitor('BPM','IdentityPass');
PM1G4C17B = monitor('BPM','IdentityPass');
PM1G4C17A = monitor('BPM','IdentityPass');
PH2G6C17A = monitor('BPM','IdentityPass');
PH1G6C17A = monitor('BPM','IdentityPass');
GEG1C16A = monitor('GE','IdentityPass');
GSG2C16A = monitor('GS','IdentityPass');
GEG2C16A = monitor('GE','IdentityPass');
GSG3C16A = monitor('GS','IdentityPass');
GEG3C16A = monitor('GE','IdentityPass');
GSG4C16A = monitor('GS','IdentityPass');
GEG4C16B = monitor('GE','IdentityPass');
GSG5C16B = monitor('GS','IdentityPass');
GEG5C16B = monitor('GE','IdentityPass');
GSG6C16B = monitor('GS','IdentityPass');
GEG6C16B = monitor('GE','IdentityPass');
GSG1C17B = monitor('GS','IdentityPass');
GEG1C17B = monitor('GE','IdentityPass');
GSG2C17B = monitor('GS','IdentityPass');
GEG2C17B = monitor('GE','IdentityPass');
GSG3C17B = monitor('GS','IdentityPass');
GEG3C17B = monitor('GE','IdentityPass');
GSG4C17B = monitor('GS','IdentityPass');
GEG4C17A = monitor('GE','IdentityPass');
GSG5C17A = monitor('GS','IdentityPass');
GEG5C17A = monitor('GE','IdentityPass');
GSG6C17A = monitor('GS','IdentityPass');
GEG6C17A = monitor('GE','IdentityPass');
GSG1C18A = monitor('GS','IdentityPass');
QH1G2C16A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C16A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C16A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C16A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C16A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C16A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C16B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C16B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C16B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C16B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C16B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C17B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C17B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C17B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C17B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C17B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C17B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C17A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C17A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C17A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C17A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C17A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C16A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C16B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C17B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C17A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C16A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C16A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C16A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C16A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C16A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C16B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C16B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C16B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C16B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C16B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C17B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C17B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C17B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C17B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C17A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C17A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C17A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C17A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C17A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C17A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C16A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C16A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C16A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C16B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C16B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C16B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C17B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C17B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C17B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C17A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C17A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C17A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C18A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C18A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C18A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C18B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C18B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C18B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C19B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C19B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C19B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C19A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C19A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C19A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C18A = monitor('MK4G1C18A','IdentityPass');
MK1G3C18A = monitor('MK1G3C18A','IdentityPass');
MK3G4C18B = monitor('MK3G4C18B','IdentityPass');
MK2G5C18B = monitor('MK2G5C18B','IdentityPass');
MK5G1C19B = monitor('MK5G1C19B','IdentityPass');
MK1G3C19B = monitor('MK1G3C19B','IdentityPass');
MK3G4C19A = monitor('MK3G4C19A','IdentityPass');
MK2G5C19A = monitor('MK2G5C19A','IdentityPass');
PH1G2C18A = monitor('BPM','IdentityPass');
PH2G2C18A = monitor('BPM','IdentityPass');
PM1G4C18A = monitor('BPM','IdentityPass');
PM1G4C18B = monitor('BPM','IdentityPass');
PL1G6C18B = monitor('BPM','IdentityPass');
PL2G6C18B = monitor('BPM','IdentityPass');
PL1G2C19B = monitor('BPM','IdentityPass');
PL2G2C19B = monitor('BPM','IdentityPass');
PM1G4C19B = monitor('BPM','IdentityPass');
PM1G4C19A = monitor('BPM','IdentityPass');
PH2G6C19A = monitor('BPM','IdentityPass');
PH1G6C19A = monitor('BPM','IdentityPass');
GEG1C18A = monitor('GE','IdentityPass');
GSG2C18A = monitor('GS','IdentityPass');
GEG2C18A = monitor('GE','IdentityPass');
GSG3C18A = monitor('GS','IdentityPass');
GEG3C18A = monitor('GE','IdentityPass');
GSG4C18A = monitor('GS','IdentityPass');
GEG4C18B = monitor('GE','IdentityPass');
GSG5C18B = monitor('GS','IdentityPass');
GEG5C18B = monitor('GE','IdentityPass');
GSG6C18B = monitor('GS','IdentityPass');
GEG6C18B = monitor('GE','IdentityPass');
GSG1C19B = monitor('GS','IdentityPass');
GEG1C19B = monitor('GE','IdentityPass');
GSG2C19B = monitor('GS','IdentityPass');
GEG2C19B = monitor('GE','IdentityPass');
GSG3C19B = monitor('GS','IdentityPass');
GEG3C19B = monitor('GE','IdentityPass');
GSG4C19B = monitor('GS','IdentityPass');
GEG4C19A = monitor('GE','IdentityPass');
GSG5C19A = monitor('GS','IdentityPass');
GEG5C19A = monitor('GE','IdentityPass');
GSG6C19A = monitor('GS','IdentityPass');
GEG6C19A = monitor('GE','IdentityPass');
GSG1C20A = monitor('GS','IdentityPass');
QH1G2C18A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C18A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C18A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C18A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C18A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C18A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C18B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C18B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C18B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C18B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C18B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C19B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C19B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C19B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C19B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C19B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C19B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C19A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C19A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C19A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C19A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C19A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C18A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C18B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C19B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C19A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C18A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C18A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C18A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C18A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C18A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C18B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C18B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C18B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C18B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C18B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C19B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C19B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C19B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C19B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C19A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C19A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C19A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C19A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C19A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C19A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C18A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C18A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C18A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C18B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C18B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C18B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C19B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C19B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C19B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C19A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C19A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C19A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C20A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C20A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C20A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C20B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C20B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C20B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C21B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C21B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C21B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C21A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C21A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C21A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C20A = monitor('MK4G1C20A','IdentityPass');
MK1G3C20A = monitor('MK1G3C20A','IdentityPass');
MK3G4C20B = monitor('MK3G4C20B','IdentityPass');
MK2G5C20B = monitor('MK2G5C20B','IdentityPass');
MK5G1C21B = monitor('MK5G1C21B','IdentityPass');
MK1G3C21B = monitor('MK1G3C21B','IdentityPass');
MK3G4C21A = monitor('MK3G4C21A','IdentityPass');
MK2G5C21A = monitor('MK2G5C21A','IdentityPass');
PH1G2C20A = monitor('BPM','IdentityPass');
PH2G2C20A = monitor('BPM','IdentityPass');
PM1G4C20A = monitor('BPM','IdentityPass');
PM1G4C20B = monitor('BPM','IdentityPass');
PL1G6C20B = monitor('BPM','IdentityPass');
PL2G6C20B = monitor('BPM','IdentityPass');
PL1G2C21B = monitor('BPM','IdentityPass');
PL2G2C21B = monitor('BPM','IdentityPass');
PM1G4C21B = monitor('BPM','IdentityPass');
PM1G4C21A = monitor('BPM','IdentityPass');
PH2G6C21A = monitor('BPM','IdentityPass');
PH1G6C21A = monitor('BPM','IdentityPass');
GEG1C20A = monitor('GE','IdentityPass');
GSG2C20A = monitor('GS','IdentityPass');
GEG2C20A = monitor('GE','IdentityPass');
GSG3C20A = monitor('GS','IdentityPass');
GEG3C20A = monitor('GE','IdentityPass');
GSG4C20A = monitor('GS','IdentityPass');
GEG4C20B = monitor('GE','IdentityPass');
GSG5C20B = monitor('GS','IdentityPass');
GEG5C20B = monitor('GE','IdentityPass');
GSG6C20B = monitor('GS','IdentityPass');
GEG6C20B = monitor('GE','IdentityPass');
GSG1C21B = monitor('GS','IdentityPass');
GEG1C21B = monitor('GE','IdentityPass');
GSG2C21B = monitor('GS','IdentityPass');
GEG2C21B = monitor('GE','IdentityPass');
GSG3C21B = monitor('GS','IdentityPass');
GEG3C21B = monitor('GE','IdentityPass');
GSG4C21B = monitor('GS','IdentityPass');
GEG4C21A = monitor('GE','IdentityPass');
GSG5C21A = monitor('GS','IdentityPass');
GEG5C21A = monitor('GE','IdentityPass');
GSG6C21A = monitor('GS','IdentityPass');
GEG6C21A = monitor('GE','IdentityPass');
GSG1C22A = monitor('GS','IdentityPass');
QH1G2C20A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C20A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C20A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C20A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C20A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C20A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C20B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C20B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C20B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C20B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C20B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C21B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C21B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C21B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C21B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C21B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C21B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C21A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C21A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C21A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C21A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C21A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C20A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C20B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C21B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C21A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C20A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C20A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C20A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C20A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C20A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C20B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C20B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C20B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C20B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C20B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C21B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C21B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C21B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C21B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C21A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C21A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C21A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C21A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C21A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C21A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C20A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C20A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C20A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C20B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C20B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C20B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C21B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C21B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C21B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C21A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C21A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C21A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C22A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C22A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C22A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C22B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C22B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C22B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C23B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C23B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C23B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C23A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C23A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C23A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C22A = monitor('MK4G1C22A','IdentityPass');
MK1G3C22A = monitor('MK1G3C22A','IdentityPass');
MK3G4C22B = monitor('MK3G4C22B','IdentityPass');
MK2G5C22B = monitor('MK2G5C22B','IdentityPass');
MK5G1C23B = monitor('MK5G1C23B','IdentityPass');
MK1G3C23B = monitor('MK1G3C23B','IdentityPass');
MK3G4C23A = monitor('MK3G4C23A','IdentityPass');
MK2G5C23A = monitor('MK2G5C23A','IdentityPass');
PH1G2C22A = monitor('BPM','IdentityPass');
PH2G2C22A = monitor('BPM','IdentityPass');
PM1G4C22A = monitor('BPM','IdentityPass');
PM1G4C22B = monitor('BPM','IdentityPass');
PL1G6C22B = monitor('BPM','IdentityPass');
PL2G6C22B = monitor('BPM','IdentityPass');
PL1G2C23B = monitor('BPM','IdentityPass');
PL2G2C23B = monitor('BPM','IdentityPass');
PM1G4C23B = monitor('BPM','IdentityPass');
PM1G4C23A = monitor('BPM','IdentityPass');
PH2G6C23A = monitor('BPM','IdentityPass');
PH1G6C23A = monitor('BPM','IdentityPass');
GEG1C22A = monitor('GE','IdentityPass');
GSG2C22A = monitor('GS','IdentityPass');
GEG2C22A = monitor('GE','IdentityPass');
GSG3C22A = monitor('GS','IdentityPass');
GEG3C22A = monitor('GE','IdentityPass');
GSG4C22A = monitor('GS','IdentityPass');
GEG4C22B = monitor('GE','IdentityPass');
GSG5C22B = monitor('GS','IdentityPass');
GEG5C22B = monitor('GE','IdentityPass');
GSG6C22B = monitor('GS','IdentityPass');
GEG6C22B = monitor('GE','IdentityPass');
GSG1C23B = monitor('GS','IdentityPass');
GEG1C23B = monitor('GE','IdentityPass');
GSG2C23B = monitor('GS','IdentityPass');
GEG2C23B = monitor('GE','IdentityPass');
GSG3C23B = monitor('GS','IdentityPass');
GEG3C23B = monitor('GE','IdentityPass');
GSG4C23B = monitor('GS','IdentityPass');
GEG4C23A = monitor('GE','IdentityPass');
GSG5C23A = monitor('GS','IdentityPass');
GEG5C23A = monitor('GE','IdentityPass');
GSG6C23A = monitor('GS','IdentityPass');
GEG6C23A = monitor('GE','IdentityPass');
GSG1C24A = monitor('GS','IdentityPass');
QH1G2C22A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C22A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C22A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C22A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C22A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C22A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C22B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C22B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C22B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C22B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C22B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C23B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C23B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C23B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C23B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C23B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C23B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C23A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C23A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C23A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C23A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C23A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C22A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C22B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C23B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C23A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C22A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C22A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C22A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C22A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C22A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C22B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C22B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C22B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C22B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C22B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C23B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C23B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C23B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C23B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C23A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C23A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C23A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C23A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C23A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C23A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C22A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C22A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C22A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C22B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C22B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C22B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C23B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C23B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C23B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C23A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C23A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C23A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C24A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C24A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C24A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C24B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C24B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C24B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C25B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C25B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C25B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C25A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C25A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C25A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C24A = monitor('MK4G1C24A','IdentityPass');
MK1G3C24A = monitor('MK1G3C24A','IdentityPass');
MK3G4C24B = monitor('MK3G4C24B','IdentityPass');
MK2G5C24B = monitor('MK2G5C24B','IdentityPass');
MK5G1C25B = monitor('MK5G1C25B','IdentityPass');
MK1G3C25B = monitor('MK1G3C25B','IdentityPass');
MK3G4C25A = monitor('MK3G4C25A','IdentityPass');
MK2G5C25A = monitor('MK2G5C25A','IdentityPass');
PH1G2C24A = monitor('BPM','IdentityPass');
PH2G2C24A = monitor('BPM','IdentityPass');
PM1G4C24A = monitor('BPM','IdentityPass');
PM1G4C24B = monitor('BPM','IdentityPass');
PL1G6C24B = monitor('BPM','IdentityPass');
PL2G6C24B = monitor('BPM','IdentityPass');
PL1G2C25B = monitor('BPM','IdentityPass');
PL2G2C25B = monitor('BPM','IdentityPass');
PM1G4C25B = monitor('BPM','IdentityPass');
PM1G4C25A = monitor('BPM','IdentityPass');
PH2G6C25A = monitor('BPM','IdentityPass');
PH1G6C25A = monitor('BPM','IdentityPass');
GEG1C24A = monitor('GE','IdentityPass');
GSG2C24A = monitor('GS','IdentityPass');
GEG2C24A = monitor('GE','IdentityPass');
GSG3C24A = monitor('GS','IdentityPass');
GEG3C24A = monitor('GE','IdentityPass');
GSG4C24A = monitor('GS','IdentityPass');
GEG4C24B = monitor('GE','IdentityPass');
GSG5C24B = monitor('GS','IdentityPass');
GEG5C24B = monitor('GE','IdentityPass');
GSG6C24B = monitor('GS','IdentityPass');
GEG6C24B = monitor('GE','IdentityPass');
GSG1C25B = monitor('GS','IdentityPass');
GEG1C25B = monitor('GE','IdentityPass');
GSG2C25B = monitor('GS','IdentityPass');
GEG2C25B = monitor('GE','IdentityPass');
GSG3C25B = monitor('GS','IdentityPass');
GEG3C25B = monitor('GE','IdentityPass');
GSG4C25B = monitor('GS','IdentityPass');
GEG4C25A = monitor('GE','IdentityPass');
GSG5C25A = monitor('GS','IdentityPass');
GEG5C25A = monitor('GE','IdentityPass');
GSG6C25A = monitor('GS','IdentityPass');
GEG6C25A = monitor('GE','IdentityPass');
GSG1C26A = monitor('GS','IdentityPass');
QH1G2C24A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C24A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C24A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C24A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C24A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C24A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C24B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C24B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C24B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C24B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C24B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C25B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C25B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C25B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C25B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C25B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C25B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C25A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C25A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C25A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C25A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C25A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C24A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C24B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C25B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C25A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C24A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C24A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C24A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C24A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C24A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C24B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C24B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C24B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C24B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C24B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C25B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C25B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C25B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C25B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C25A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C25A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C25A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C25A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C25A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C25A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C24A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C24A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C24A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C24B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C24B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C24B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C25B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C25B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C25B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C25A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C25A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C25A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C26A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C26A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C26A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C26B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C26B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C26B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C27B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C27B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C27B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C27A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C27A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C27A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C26A = monitor('MK4G1C26A','IdentityPass');
MK1G3C26A = monitor('MK1G3C26A','IdentityPass');
MK3G4C26B = monitor('MK3G4C26B','IdentityPass');
MK2G5C26B = monitor('MK2G5C26B','IdentityPass');
MK5G1C27B = monitor('MK5G1C27B','IdentityPass');
MK1G3C27B = monitor('MK1G3C27B','IdentityPass');
MK3G4C27A = monitor('MK3G4C27A','IdentityPass');
MK2G5C27A = monitor('MK2G5C27A','IdentityPass');
PH1G2C26A = monitor('BPM','IdentityPass');
PH2G2C26A = monitor('BPM','IdentityPass');
PM1G4C26A = monitor('BPM','IdentityPass');
PM1G4C26B = monitor('BPM','IdentityPass');
PL1G6C26B = monitor('BPM','IdentityPass');
PL2G6C26B = monitor('BPM','IdentityPass');
PL1G2C27B = monitor('BPM','IdentityPass');
PL2G2C27B = monitor('BPM','IdentityPass');
PM1G4C27B = monitor('BPM','IdentityPass');
PM1G4C27A = monitor('BPM','IdentityPass');
PH2G6C27A = monitor('BPM','IdentityPass');
PH1G6C27A = monitor('BPM','IdentityPass');
GEG1C26A = monitor('GE','IdentityPass');
GSG2C26A = monitor('GS','IdentityPass');
GEG2C26A = monitor('GE','IdentityPass');
GSG3C26A = monitor('GS','IdentityPass');
GEG3C26A = monitor('GE','IdentityPass');
GSG4C26A = monitor('GS','IdentityPass');
GEG4C26B = monitor('GE','IdentityPass');
GSG5C26B = monitor('GS','IdentityPass');
GEG5C26B = monitor('GE','IdentityPass');
GSG6C26B = monitor('GS','IdentityPass');
GEG6C26B = monitor('GE','IdentityPass');
GSG1C27B = monitor('GS','IdentityPass');
GEG1C27B = monitor('GE','IdentityPass');
GSG2C27B = monitor('GS','IdentityPass');
GEG2C27B = monitor('GE','IdentityPass');
GSG3C27B = monitor('GS','IdentityPass');
GEG3C27B = monitor('GE','IdentityPass');
GSG4C27B = monitor('GS','IdentityPass');
GEG4C27A = monitor('GE','IdentityPass');
GSG5C27A = monitor('GS','IdentityPass');
GEG5C27A = monitor('GE','IdentityPass');
GSG6C27A = monitor('GS','IdentityPass');
GEG6C27A = monitor('GE','IdentityPass');
GSG1C28A = monitor('GS','IdentityPass');
QH1G2C26A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C26A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C26A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C26A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C26A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C26A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C26B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C26B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C26B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C26B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C26B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C27B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C27B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C27B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C27B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C27B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C27B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C27A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C27A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C27A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C27A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C27A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C26A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C26B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C27B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C27A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C26A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C26A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C26A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C26A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C26A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C26B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C26B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C26B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C26B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C26B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C27B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C27B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C27B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C27B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C27A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C27A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C27A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C27A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C27A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C27A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C26A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C26A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C26A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C26B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C26B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C26B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C27B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C27B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C27B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C27A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C27A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C27A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1XG2C28A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C28A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C28A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C28B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C28B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C28B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C29B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C29B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG3C29B=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C29A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C29A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C29A=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C28A = monitor('MK4G1C28A','IdentityPass');
MK1G3C28A = monitor('MK1G3C28A','IdentityPass');
MK3G4C28B = monitor('MK3G4C28B','IdentityPass');
MK2G5C28B = monitor('MK2G5C28B','IdentityPass');
MK5G1C29B = monitor('MK5G1C29B','IdentityPass');
MK1G3C29B = monitor('MK1G3C29B','IdentityPass');
MK3G4C29A = monitor('MK3G4C29A','IdentityPass');
MK2G5C29A = monitor('MK2G5C29A','IdentityPass');
PH1G2C28A = monitor('BPM','IdentityPass');
PH2G2C28A = monitor('BPM','IdentityPass');
PM1G4C28A = monitor('BPM','IdentityPass');
PM1G4C28B = monitor('BPM','IdentityPass');
PL1G6C28B = monitor('BPM','IdentityPass');
PL2G6C28B = monitor('BPM','IdentityPass');
PL1G2C29B = monitor('BPM','IdentityPass');
PL2G2C29B = monitor('BPM','IdentityPass');
PM1G4C29B = monitor('BPM','IdentityPass');
PM1G4C29A = monitor('BPM','IdentityPass');
PH2G6C29A = monitor('BPM','IdentityPass');
PH1G6C29A = monitor('BPM','IdentityPass');
GEG1C28A = monitor('GE','IdentityPass');
GSG2C28A = monitor('GS','IdentityPass');
GEG2C28A = monitor('GE','IdentityPass');
GSG3C28A = monitor('GS','IdentityPass');
GEG3C28A = monitor('GE','IdentityPass');
GSG4C28A = monitor('GS','IdentityPass');
GEG4C28B = monitor('GE','IdentityPass');
GSG5C28B = monitor('GS','IdentityPass');
GEG5C28B = monitor('GE','IdentityPass');
GSG6C28B = monitor('GS','IdentityPass');
GEG6C28B = monitor('GE','IdentityPass');
GSG1C29B = monitor('GS','IdentityPass');
GEG1C29B = monitor('GE','IdentityPass');
GSG2C29B = monitor('GS','IdentityPass');
GEG2C29B = monitor('GE','IdentityPass');
GSG3C29B = monitor('GS','IdentityPass');
GEG3C29B = monitor('GE','IdentityPass');
GSG4C29B = monitor('GS','IdentityPass');
GEG4C29A = monitor('GE','IdentityPass');
GSG5C29A = monitor('GS','IdentityPass');
GEG5C29A = monitor('GE','IdentityPass');
GSG6C29A = monitor('GS','IdentityPass');
GEG6C29A = monitor('GE','IdentityPass');
GSG1C30A = monitor('GS','IdentityPass');
QH1G2C28A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
SQ1HG2C28A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C28A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3G2C28A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QM1G4C28A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C28A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C28B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C28B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QL3G6C28B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QL2G6C28B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL1G6C28B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL1G2C29B=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2G2C29B=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3G2C29B=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
SQ2HG3C29B=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C29B=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2G4C29B=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM2G4C29A=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
QM1G4C29A=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QH3G6C29A=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QH2G6C29A=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH1G6C29A=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
B1G3C28A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C28B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C29B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C29A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C28A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G2C28A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G2C28A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G2C28A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C28A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C28B=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C28B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G6C28B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G6C28B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G6C28B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL1G2C29B=sextupole('SL1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL2G2C29B=sextupole('SL2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SL3G2C29B=sextupole('SL3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C29B=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SM2HG4C29A=sextupole('SM2', 0.125000, 0.000000, 'StrMPoleSymplectic4Pass');
SM1G4C29A=sextupole('SM1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH4G6C29A=sextupole('SH4', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH3G6C29A=sextupole('SH3', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH2G6C29A=sextupole('SH2', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1G6C29A=sextupole('SH1', 0.200000, 0.000000, 'StrMPoleSymplectic4Pass');
CH1YG2C28A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C28A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C28A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C28B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C28B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C28B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C29B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C29B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG3C29B=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C29A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C29A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C29A=corrector('CV', 0, [0 0], 'CorrectorPass');
%GIRDER1C28=[ LINE=(MK4G1C28A,DH0G1A,GEG1C28A)GIRDER2C28= LINE=(GSG2C28A,SH1G2C28A,DH1AG2A,PH1G2C28A,DBPM,QH1G2C28A,DH2AG2A,& SQ1HG2C28A,CH1XG2C28A,CH1YG2C28A,SQ1HG2C28A,DH2BG2A,SH2G2C28A,DH2CG2A,& QH2G2C28A,DH3AG2A,SH3G2C28A,DH3BG2A,QH3G2C28A,DH4AG2A,PH2G2C28A,DBPM,& SH4G2C28A,DH4BG2A,DFCH,CH2XG2C28A,CH2YG2C28A,DFCH,GEG2C28A)GIRDER3C28= LINE=(DH4CG3A,GSG3C28A,MK1G3C28A,B1G3C28A,DM1AG3A,DFCH,CM1XG3C28A,& CM1YG3C28A,DFCH,DM1BG3A,GEG3C28A)GIRDER4C28= LINE=(GSG4C28A,QM1G4C28A,DM2AG4A,SM1G4C28A,DM2BG4A,PM1G4C28A,DBPM,& QM2G4C28A,DM2CG4A,SM2HG4C28B,MK3G4C28B,SM2HG4C28B,DM2CG4B,QM2G4C28B,DM2BG4B,& SM1G4C28B,DM2AG4B,PM1G4C28B,DBPM,QM1G4C28B,DM1EG4B,DFCH,CM1YG4C28B,CM1XG4C28B,& DFCH,GEG4C28B)GIRDER5C28= LINE=(GSG5C28B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C28B,MK2G5C28B,GEG5C28B)GIRDER6C28= LINE=(DL4BG6B,GSG6C28B,DFCH,CL2YG6C28B,CL2XG6C28B,DFCH,DL4AG6B,& QL3G6C28B,DBPM,PL2G6C28B,DL3BG6B,SL3G6C28B,DL3AG6B,QL2G6C28B,DL2CG6B,& SL2G6C28B,DL2BG6B,DSCH,CL1YG6C28B,CL1XG6C28B,DSCH,DL2AG6B,QL1G6C28B,DL1AG6B,& PL1G6C28B,DBPM,SL1G6C28B,GEG6C28B)GIRDER1C29= LINE=(GSG1C29B,DL0G1B,MK5G1C29B,DL0G1B,GEG1C29B)GIRDER2C29= LINE=(GSG2C29B,SL1G2C29B,DL1AG2B,PL1G2C29B,DBPM,QL1G2C29B,DL2AG2B,& DSCH,CL1XG2C29B,CL1YG2C29B,DSCH,DL2BG2B,SL2G2C29B,DL2CG2B,QL2G2C29B,DL3AG2B,& SL3G2C29B,DL3BG2B,PL2G2C29B,DBPM,QL3G2C29B,DL4AG2B,DFCH,CL2XG2C29B,CL2YG2C29B,& DFCH,GEG2C29B)GIRDER3C29= LINE=(DL4BG3B,GSG3C29B,MK1G3C29B,B1G3C29B,DM1AG3B,SQ2HG3C29B,& CM1XG3C29B,CM1YG3C29B,SQ2HG3C29B,DM1BG3B,GEG3C29B)GIRDER4C29= LINE=(GSG4C29B,QM1G4C29B,DM2A2G4B,SM1G4C29B,DM2B2G4B,PM1G4C29B,& DBPM,QM2G4C29B,DM2CG4B,SM2HG4C29A,MK3G4C29A,SM2HG4C29A,DM2CG4A,QM2G4C29A,& DM2B2G4A,SM1G4C29A,DM2A2G4A,PM1G4C29A,DBPM,QM1G4C29A,DM1EG4A,DFCH,CM1YG4C29A,& CM1XG4C29A,DFCH,GEG4C29A)GIRDER5C29= LINE=(GSG5C29A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C29A,MK2G5C29A,GEG5C29A)GIRDER6C29= LINE=(DH4CG6A,GSG6C29A,DFCH,CH2YG6C29A,CH2XG6C29A,DFCH,DH4BG6A,& SH4G6C29A,DH4AG6A,PH2G6C29A,DBPM,QH3G6C29A,DH3BG6A,SH3G6C29A,DH3AG6A,& QH2G6C29A,DH2CG6A,SH2G6C29A,DH2BG6A,DSCH,CH1YG6C29A,CH1XG6C29A,DSCH,DH2AG6A,& QH1G6C29A,DH1AG6A,PH1G6C29A,DBPM,SH1G6C29A,GEG6C29A)GIRDER1C30H= LINE=(GSG1C30A,DH0G1A)SPC28C29= LINE=(GIRDER1C28,GIRDER2C28,GIRDER3C28,GIRDER4C28,GIRDER5C28,& GIRDER6C28,GIRDER1C29,GIRDER2C29,GIRDER3C29,GIRDER4C29,GIRDER5C29,GIRDER6C29,& GIRDER1C30H)RF= RFCA,VOLT=2500000,PHASE=173.523251376,FREQ=499461995.8990133];
% Lattice description
GIRDER1C30 = [MK4G1C30A,DH0G1A,GEG1C30A];
GIRDER2C30 = [GSG2C30A,SH1G2C30A,DH1AG2A,PH1G2C30A,DBPM,QH1G2C30A,DH2AG2A, ...
 SQ1HG2C30A,CH1XG2C30A,CH1YG2C30A,SQ1HG2C30A,DH2BG2A,SH2G2C30A,DH2CG2A, ...
 QH2G2C30A,DH3AG2A,SH3G2C30A,DH3BG2A,QH3G2C30A,DH4AG2A,PH2G2C30A,DBPM, ...
 SH4G2C30A,DH4BG2A,DFCH,CH2XG2C30A,CH2YG2C30A,DFCH,GEG2C30A];
GIRDER3C30 =  [DH4CG3A,GSG3C30A,MK1G3C30A,B1G3C30A,DM1AG3A,DFCH,CM1XG3C30A, ...
 CM1YG3C30A,DFCH,DM1BG3A,GEG3C30A];
GIRDER4C30 = [GSG4C30A,QM1G4C30A,DM2AG4A,SM1G4C30A,DM2BG4A,PM1G4C30A,DBPM, ...
 QM2G4C30A,DM2CG4A,SM2HG4C30B,MK3G4C30B,SM2HG4C30B,DM2CG4B,QM2G4C30B,DM2BG4B, ...
 SM1G4C30B,DM2AG4B,PM1G4C30B,DBPM,QM1G4C30B,DM1EG4B,DFCH,CM1YG4C30B,CM1XG4C30B, ...
 DFCH,GEG4C30B];
GIRDER5C30 = [GSG5C30B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C30B,MK2G5C30B,GEG5C30B];
GIRDER6C30 = [DL4BG6B,GSG6C30B,DFCH,CL2YG6C30B,CL2XG6C30B,DFCH,DL4AG6B, ...
 QL3G6C30B,DBPM,PL2G6C30B,DL3BG6B,SL3G6C30B,DL3AG6B,QL2G6C30B,DL2CG6B, ...
 SL2G6C30B,DL2BG6B,DSCH,CL1YG6C30B,CL1XG6C30B,DSCH,DL2AG6B,QL1G6C30B,DL1AG6B, ...
 PL1G6C30B,DBPM,SL1G6C30B,GEG6C30B];
GIRDER1C01 = [GSG1C01B,DL0G1B,MK5G1C01B,DL0G1B,GEG1C01B];
GIRDER2C01 = [GSG2C01B,SL1G2C01B,DL1AG2B,PL1G2C01B,DBPM,QL1G2C01B,DL2AG2B, ...
 DSCH,CL1XG2C01B,CL1YG2C01B,DSCH,DL2BG2B,SL2G2C01B,DL2CG2B,QL2G2C01B,DL3AG2B, ...
 SL3G2C01B,DL3BG2B,PL2G2C01B,DBPM,QL3G2C01B,DL4AG2B,DFCH,CL2XG2C01B,CL2YG2C01B, ...
 DFCH,GEG2C01B];
GIRDER3C01 = [DL4BG3B,GSG3C01B,MK1G3C01B,B1G3C01B,DM1AG3B,SQ2HG3C01B, ...
 CM1XG3C01B,CM1YG3C01B,SQ2HG3C01B,DM1BG3B,GEG3C01B];
GIRDER4C01 = [GSG4C01B,QM1G4C01B,DM2A2G4B,SM1G4C01B,DM2B2G4B,PM1G4C01B, ...
 DBPM,QM2G4C01B,DM2CG4B,SM2HG4C01A,MK3G4C01A,SM2HG4C01A,DM2CG4A,QM2G4C01A, ... 
 DM2B2G4A,SM1G4C01A,DM2A2G4A,PM1G4C01A,DBPM,QM1G4C01A,DM1EG4A,DFCH,CM1YG4C01A, ...
 CM1XG4C01A,DFCH,GEG4C01A];
GIRDER5C01 = [GSG5C01A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C01A,MK2G5C01A,GEG5C01A];
GIRDER6C01 = [DH4CG6A,GSG6C01A,DFCH,CH2YG6C01A,CH2XG6C01A,DFCH,DH4BG6A, ...
 SH4G6C01A,DH4AG6A,PH2G6C01A,DBPM,QH3G6C01A,DH3BG6A,SH3G6C01A,DH3AG6A, ...
 QH2G6C01A,DH2CG6A,SH2G6C01A,DH2BG6A,DSCH,CH1YG6C01A,CH1XG6C01A,DSCH,DH2AG6A, ...
 QH1G6C01A,DH1AG6A,PH1G6C01A,DBPM,SH1G6C01A,GEG6C01A];
GIRDER1C02H = [GSG1C02A,DWSTR];
SPC30C01 = [GIRDER1C30,GIRDER2C30,GIRDER3C30,GIRDER4C30,GIRDER5C30, ...
 GIRDER6C30,GIRDER1C01,GIRDER2C01,GIRDER3C01,GIRDER4C01,GIRDER5C01,GIRDER6C01, ...
 GIRDER1C02H];


GIRDER1C02 = [MK4G1C02A,DWSTR,GEG1C02A];
GIRDER2C02 = [GSG2C02A,SH1G2C02A,DH1AG2A,PH1G2C02A,DBPM,QH1G2C02A,DH2AG2A, ...
 SQ1HG2C02A,CH1XG2C02A,CH1YG2C02A,SQ1HG2C02A,DH2BG2A,SH2G2C02A,DH2CG2A, ...
 QH2G2C02A,DH3AG2A,SH3G2C02A,DH3BG2A,QH3G2C02A,DH4AG2A,PH2G2C02A,DBPM, ...
 SH4G2C02A,DH4BG2A,DFCH,CH2XG2C02A,CH2YG2C02A,DFCH,GEG2C02A];
GIRDER3C02 = [DH4CG3A,GSG3C02A,MK1G3C02A,B1G3C02A,DM1AG3A,DFCH,CM1XG3C02A, ...
 CM1YG3C02A,DFCH,DM1BG3A,GEG3C02A];
GIRDER4C02 = [GSG4C02A,QM1G4C02A,DM2AG4A,SM1G4C02A,DM2BG4A,PM1G4C02A,DBPM, ...
 QM2G4C02A,DM2CG4A,SM2HG4C02B,MK3G4C02B,SM2HG4C02B,DM2CG4B,QM2G4C02B,DM2BG4B, ...
 SM1G4C02B,DM2AG4B,PM1G4C02B,DBPM,QM1G4C02B,DM1EG4B,DFCH,CM1YG4C02B,CM1XG4C02B, ...
 DFCH,GEG4C02B];
GIRDER5C02 = [GSG5C02B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C02B,MK2G5C02B,GEG5C02B];
GIRDER6C02 =[DL4BG6B,GSG6C02B,DFCH,CL2YG6C02B,CL2XG6C02B,DFCH,DL4AG6B, ...
 QL3G6C02B,DBPM,PL2G6C02B,DL3BG6B,SL3G6C02B,DL3AG6B,QL2G6C02B,DL2CG6B, ...
 SL2G6C02B,DL2BG6B,DSCH,CL1YG6C02B,CL1XG6C02B,DSCH,DL2AG6B,QL1G6C02B,DL1AG6B, ...
 PL1G6C02B,DBPM,SL1G6C02B,GEG6C02B];
GIRDER1C03 = [GSG1C03B,DL0G1B,MK5G1C03B,DL0G1B,GEG1C03B];
GIRDER2C03 = [GSG2C03B,SL1G2C03B,DL1AG2B,PL1G2C03B,DBPM,QL1G2C03B,DL2AG2B, ...
 DSCH,CL1XG2C03B,CL1YG2C03B,DSCH,DL2BG2B,SL2G2C03B,DL2CG2B,QL2G2C03B,DL3AG2B, ...
 SL3G2C03B,DL3BG2B,PL2G2C03B,DBPM,QL3G2C03B,DL4AG2B,DFCH,CL2XG2C03B,CL2YG2C03B, ...
 DFCH,GEG2C03B];
GIRDER3C03 = [DL4BG3B,GSG3C03B,MK1G3C03B,B1G3C03B,DM1AG3B,SQ2HG3C03B, ...
 CM1XG3C03B,CM1YG3C03B,SQ2HG3C03B,DM1BG3B,GEG3C03B];
GIRDER4C03 = [GSG4C03B,QM1G4C03B,DM2A2G4B,SM1G4C03B,DM2B2G4B,PM1G4C03B, ...
 DBPM,QM2G4C03B,DM2CG4B,SM2HG4C03A,MK3G4C03A,SM2HG4C03A,DM2CG4A,QM2G4C03A, ...
 DM2B2G4A,SM1G4C03A,DM2A2G4A,PM1G4C03A,DBPM,QM1G4C03A,DM1EG4A,DFCH,CM1YG4C03A, ...
 CM1XG4C03A,DFCH,GEG4C03A];
GIRDER5C03 = [GSG5C03A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C03A,MK2G5C03A,GEG5C03A];
GIRDER6C03 = [DH4CG6A,GSG6C03A,DFCH,CH2YG6C03A,CH2XG6C03A,DFCH,DH4BG6A, ...
 SH4G6C03A,DH4AG6A,PH2G6C03A,DBPM,QH3G6C03A,DH3BG6A,SH3G6C03A,DH3AG6A, ...
 QH2G6C03A,DH2CG6A,SH2G6C03A,DH2BG6A,DSCH,CH1YG6C03A,CH1XG6C03A,DSCH,DH2AG6A, ...
 QH1G6C03A,DH1AG6A,PH1G6C03A,DBPM,SH1G6C03A,GEG6C03A];
GIRDER1C04H = [GSG1C04A,DH0G1A];
SPC02C03 = [GIRDER1C02,GIRDER2C02,GIRDER3C02,GIRDER4C02,GIRDER5C02, ...
 GIRDER6C02,GIRDER1C03,GIRDER2C03,GIRDER3C03,GIRDER4C03,GIRDER5C03,GIRDER6C03, ...
 GIRDER1C04H];
 
 
 GIRDER1C04 = [MK4G1C04A,DH0G1A,GEG1C04A];
GIRDER2C04 = [GSG2C04A,SH1G2C04A,DH1AG2A,PH1G2C04A,DBPM,QH1G2C04A,DH2AG2A, ...
 SQ1HG2C04A,CH1XG2C04A,CH1YG2C04A,SQ1HG2C04A,DH2BG2A,SH2G2C04A,DH2CG2A, ...
 QH2G2C04A,DH3AG2A,SH3G2C04A,DH3BG2A,QH3G2C04A,DH4AG2A,PH2G2C04A,DBPM, ...
 SH4G2C04A,DH4BG2A,DFCH,CH2XG2C04A,CH2YG2C04A,DFCH,GEG2C04A];
GIRDER3C04 = [DH4CG3A,GSG3C04A,MK1G3C04A,B1G3C04A,DM1AG3A,DFCH,CM1XG3C04A, ...
 CM1YG3C04A,DFCH,DM1BG3A,GEG3C04A];
GIRDER4C04 = [GSG4C04A,QM1G4C04A,DM2AG4A,SM1G4C04A,DM2BG4A,PM1G4C04A,DBPM, ...
 QM2G4C04A,DM2CG4A,SM2HG4C04B,MK3G4C04B,SM2HG4C04B,DM2CG4B,QM2G4C04B,DM2BG4B, ...
 SM1G4C04B,DM2AG4B,PM1G4C04B,DBPM,QM1G4C04B,DM1EG4B,DFCH,CM1YG4C04B,CM1XG4C04B, ...
 DFCH,GEG4C04B];
GIRDER5C04 = [GSG5C04B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C04B,MK2G5C04B,GEG5C04B];
GIRDER6C04 =[DL4BG6B,GSG6C04B,DFCH,CL2YG6C04B,CL2XG6C04B,DFCH,DL4AG6B, ...
 QL3G6C04B,DBPM,PL2G6C04B,DL3BG6B,SL3G6C04B,DL3AG6B,QL2G6C04B,DL2CG6B, ...
 SL2G6C04B,DL2BG6B,DSCH,CL1YG6C04B,CL1XG6C04B,DSCH,DL2AG6B,QL1G6C04B,DL1AG6B, ...
 PL1G6C04B,DBPM,SL1G6C04B,GEG6C04B];
GIRDER1C05 = [GSG1C05B,DL0G1B,MK5G1C05B,DL0G1B,GEG1C05B];
GIRDER2C05 = [GSG2C05B,SL1G2C05B,DL1AG2B,PL1G2C05B,DBPM,QL1G2C05B,DL2AG2B, ...
 DSCH,CL1XG2C05B,CL1YG2C05B,DSCH,DL2BG2B,SL2G2C05B,DL2CG2B,QL2G2C05B,DL3AG2B, ...
 SL3G2C05B,DL3BG2B,PL2G2C05B,DBPM,QL3G2C05B,DL4AG2B,DFCH,CL2XG2C05B,CL2YG2C05B, ...
 DFCH,GEG2C05B];
GIRDER3C05 = [DL4BG3B,GSG3C05B,MK1G3C05B,B1G3C05B,DM1AG3B,SQ2HG3C05B, ...
 CM1XG3C05B,CM1YG3C05B,SQ2HG3C05B,DM1BG3B,GEG3C05B];
GIRDER4C05 = [GSG4C05B,QM1G4C05B,DM2A2G4B,SM1G4C05B,DM2B2G4B,PM1G4C05B, ...
 DBPM,QM2G4C05B,DM2CG4B,SM2HG4C05A,MK3G4C05A,SM2HG4C05A,DM2CG4A,QM2G4C05A ...
 DM2B2G4A,SM1G4C05A,DM2A2G4A,PM1G4C05A,DBPM,QM1G4C05A,DM1EG4A,DFCH,CM1YG4C05A, ...
 CM1XG4C05A,DFCH,GEG4C05A];
GIRDER5C05 = [GSG5C05A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C05A,MK2G5C05A,GEG5C05A];
GIRDER6C05 = [DH4CG6A,GSG6C05A,DFCH,CH2YG6C05A,CH2XG6C05A,DFCH,DH4BG6A, ...
 SH4G6C05A,DH4AG6A,PH2G6C05A,DBPM,QH3G6C05A,DH3BG6A,SH3G6C05A,DH3AG6A, ...
 QH2G6C05A,DH2CG6A,SH2G6C05A,DH2BG6A,DSCH,CH1YG6C05A,CH1XG6C05A,DSCH,DH2AG6A, ...
 QH1G6C05A,DH1AG6A,PH1G6C05A,DBPM,SH1G6C05A,GEG6C05A];
GIRDER1C06H = [GSG1C06A,DH0G1A];
SPC04C05 = [GIRDER1C04,GIRDER2C04,GIRDER3C04,GIRDER4C04,GIRDER5C04, ...
 GIRDER6C04,GIRDER1C05,GIRDER2C05,GIRDER3C05,GIRDER4C05,GIRDER5C05,GIRDER6C05, ...
 GIRDER1C06H];

 GIRDER1C06 = [MK4G1C06A,DH0G1A,GEG1C06A];
GIRDER2C06 = [GSG2C06A,SH1G2C06A,DH1AG2A,PH1G2C06A,DBPM,QH1G2C06A,DH2AG2A, ...
 SQ1HG2C06A,CH1XG2C06A,CH1YG2C06A,SQ1HG2C06A,DH2BG2A,SH2G2C06A,DH2CG2A, ...
 QH2G2C06A,DH3AG2A,SH3G2C06A,DH3BG2A,QH3G2C06A,DH4AG2A,PH2G2C06A,DBPM, ...
 SH4G2C06A,DH4BG2A,DFCH,CH2XG2C06A,CH2YG2C06A,DFCH,GEG2C06A];
GIRDER3C06 = [DH4CG3A,GSG3C06A,MK1G3C06A,B1G3C06A,DM1AG3A,DFCH,CM1XG3C06A, ...
 CM1YG3C06A,DFCH,DM1BG3A,GEG3C06A];
GIRDER4C06 = [GSG4C06A,QM1G4C06A,DM2AG4A,SM1G4C06A,DM2BG4A,PM1G4C06A,DBPM, ...
 QM2G4C06A,DM2CG4A,SM2HG4C06B,MK3G4C06B,SM2HG4C06B,DM2CG4B,QM2G4C06B,DM2BG4B, ...
 SM1G4C06B,DM2AG4B,PM1G4C06B,DBPM,QM1G4C06B,DM1EG4B,DFCH,CM1YG4C06B,CM1XG4C06B, ...
 DFCH,GEG4C06B];
GIRDER5C06 = [GSG5C06B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C06B,MK2G5C06B,GEG5C06B];
GIRDER6C06 = [DL4BG6B,GSG6C06B,DFCH,CL2YG6C06B,CL2XG6C06B,DFCH,DL4AG6B, ...
 QL3G6C06B,DBPM,PL2G6C06B,DL3BG6B,SL3G6C06B,DL3AG6B,QL2G6C06B,DL2CG6B, ...
 SL2G6C06B,DL2BG6B,DSCH,CL1YG6C06B,CL1XG6C06B,DSCH,DL2AG6B,QL1G6C06B,DL1AG6B, ...
 PL1G6C06B,DBPM,SL1G6C06B,GEG6C06B];
GIRDER1C07 = [GSG1C07B,DL0G1B,MK5G1C07B,DL0G1B,GEG1C07B];
GIRDER2C07 = [GSG2C07B,SL1G2C07B,DL1AG2B,PL1G2C07B,DBPM,QL1G2C07B,DL2AG2B, ...
 DSCH,CL1XG2C07B,CL1YG2C07B,DSCH,DL2BG2B,SL2G2C07B,DL2CG2B,QL2G2C07B,DL3AG2B, ...
 SL3G2C07B,DL3BG2B,PL2G2C07B,DBPM,QL3G2C07B,DL4AG2B,DFCH,CL2XG2C07B,CL2YG2C07B, ...
 DFCH,GEG2C07B];
GIRDER3C07 = [DL4BG3B,GSG3C07B,MK1G3C07B,B1G3C07B,DM1AG3B,SQ2HG3C07B, ...
 CM1XG3C07B,CM1YG3C07B,SQ2HG3C07B,DM1BG3B,GEG3C07B];
GIRDER4C07 = [GSG4C07B,QM1G4C07B,DM2A2G4B,SM1G4C07B,DM2B2G4B,PM1G4C07B, ...
 DBPM,QM2G4C07B,DM2CG4B,SM2HG4C07A,MK3G4C07A,SM2HG4C07A,DM2CG4A,QM2G4C07A ...
 DM2B2G4A,SM1G4C07A,DM2A2G4A,PM1G4C07A,DBPM,QM1G4C07A,DM1EG4A,DFCH,CM1YG4C07A, ...
 CM1XG4C07A,DFCH,GEG4C07A];
GIRDER5C07 = [GSG5C07A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C07A,MK2G5C07A,GEG5C07A];
GIRDER6C07  =[DH4CG6A,GSG6C07A,DFCH,CH2YG6C07A,CH2XG6C07A,DFCH,DH4BG6A, ...
 SH4G6C07A,DH4AG6A,PH2G6C07A,DBPM,QH3G6C07A,DH3BG6A,SH3G6C07A,DH3AG6A, ...
 QH2G6C07A,DH2CG6A,SH2G6C07A,DH2BG6A,DSCH,CH1YG6C07A,CH1XG6C07A,DSCH,DH2AG6A, ...
 QH1G6C07A,DH1AG6A,PH1G6C07A,DBPM,SH1G6C07A,GEG6C07A];
GIRDER1C08H = [GSG1C08A,DH0G1A];
SPC06C07 = [GIRDER1C06,GIRDER2C06,GIRDER3C06,GIRDER4C06,GIRDER5C06, ...
 GIRDER6C06,GIRDER1C07,GIRDER2C07,GIRDER3C07,GIRDER4C07,GIRDER5C07,GIRDER6C07, ...
 GIRDER1C08H];
 
 GIRDER1C08 = [MK4G1C08A,DH0G1A,GEG1C08A];
GIRDER2C08 = [GSG2C08A,SH1G2C08A,DH1AG2A,PH1G2C08A,DBPM,QH1G2C08A,DH2AG2A, ...
 SQ1HG2C08A,CH1XG2C08A,CH1YG2C08A,SQ1HG2C08A,DH2BG2A,SH2G2C08A,DH2CG2A, ...
 QH2G2C08A,DH3AG2A,SH3G2C08A,DH3BG2A,QH3G2C08A,DH4AG2A,PH2G2C08A,DBPM, ...
 SH4G2C08A,DH4BG2A,DFCH,CH2XG2C08A,CH2YG2C08A,DFCH,GEG2C08A];
GIRDER3C08 = [DH4CG3A,GSG3C08A,MK1G3C08A,B1G3C08A,DM1AG3A,DFCH,CM1XG3C08A, ...
 CM1YG3C08A,DFCH,DM1BG3A,GEG3C08A];
GIRDER4C08 = [GSG4C08A,QM1G4C08A,DM2AG4A,SM1G4C08A,DM2BG4A,PM1G4C08A,DBPM, ...
 QM2G4C08A,DM2CG4A,SM2HG4C08B,MK3G4C08B,SM2HG4C08B,DM2CG4B,QM2G4C08B,DM2BG4B, ...
 SM1G4C08B,DM2AG4B,PM1G4C08B,DBPM,QM1G4C08B,DM1EG4B,DFCH,CM1YG4C08B,CM1XG4C08B, ...
 DFCH,GEG4C08B];
GIRDER5C08 = [GSG5C08B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C08B,MK2G5C08B,GEG5C08B];
GIRDER6C08 = [DL4BG6B,GSG6C08B,DFCH,CL2YG6C08B,CL2XG6C08B,DFCH,DL4AG6B, ...
 QL3G6C08B,DBPM,PL2G6C08B,DL3BG6B,SL3G6C08B,DL3AG6B,QL2G6C08B,DL2CG6B, ...
 SL2G6C08B,DL2BG6B,DSCH,CL1YG6C08B,CL1XG6C08B,DSCH,DL2AG6B,QL1G6C08B,DL1AG6B, ...
 PL1G6C08B,DBPM,SL1G6C08B,GEG6C08B];
GIRDER1C09 = [GSG1C09B,DL0G1B,MK5G1C09B,DL0G1B,GEG1C09B];
GIRDER2C09 = [GSG2C09B,SL1G2C09B,DL1AG2B,PL1G2C09B,DBPM,QL1G2C09B,DL2AG2B, ...
 DSCH,CL1XG2C09B,CL1YG2C09B,DSCH,DL2BG2B,SL2G2C09B,DL2CG2B,QL2G2C09B,DL3AG2B, ...
 SL3G2C09B,DL3BG2B,PL2G2C09B,DBPM,QL3G2C09B,DL4AG2B,DFCH,CL2XG2C09B,CL2YG2C09B, ...
 DFCH,GEG2C09B];
GIRDER3C09 = [DL4BG3B,GSG3C09B,MK1G3C09B,B1G3C09B,DM1AG3B,SQ2HG3C09B, ...
 CM1XG3C09B,CM1YG3C09B,SQ2HG3C09B,DM1BG3B,GEG3C09B];
GIRDER4C09 = [GSG4C09B,QM1G4C09B,DM2A2G4B,SM1G4C09B,DM2B2G4B,PM1G4C09B, ...
 DBPM,QM2G4C09B,DM2CG4B,SM2HG4C09A,MK3G4C09A,SM2HG4C09A,DM2CG4A,QM2G4C09A, ...
 DM2B2G4A,SM1G4C09A,DM2A2G4A,PM1G4C09A,DBPM,QM1G4C09A,DM1EG4A,DFCH,CM1YG4C09A, ...
 CM1XG4C09A,DFCH,GEG4C09A];
GIRDER5C09 = [GSG5C09A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C09A,MK2G5C09A,GEG5C09A];
GIRDER6C09 = [DH4CG6A,GSG6C09A,DFCH,CH2YG6C09A,CH2XG6C09A,DFCH,DH4BG6A, ...
 SH4G6C09A,DH4AG6A,PH2G6C09A,DBPM,QH3G6C09A,DH3BG6A,SH3G6C09A,DH3AG6A, ...
 QH2G6C09A,DH2CG6A,SH2G6C09A,DH2BG6A,DSCH,CH1YG6C09A,CH1XG6C09A,DSCH,DH2AG6A, ...
 QH1G6C09A,DH1AG6A,PH1G6C09A,DBPM,SH1G6C09A,GEG6C09A];
GIRDER1C10H = [GSG1C10A,DH0G1A];
SPC08C09 = [GIRDER1C08,GIRDER2C08,GIRDER3C08,GIRDER4C08,GIRDER5C08, ...
 GIRDER6C08,GIRDER1C09,GIRDER2C09,GIRDER3C09,GIRDER4C09,GIRDER5C09,GIRDER6C09, ...
 GIRDER1C10H];
 
GIRDER1C10 = [MK4G1C10A,DH0G1A,GEG1C10A];
GIRDER2C10 = [GSG2C10A,SH1G2C10A,DH1AG2A,PH1G2C10A,DBPM,QH1G2C10A,DH2AG2A, ...  
 SQ1HG2C10A,CH1XG2C10A,CH1YG2C10A,SQ1HG2C10A,DH2BG2A,SH2G2C10A,DH2CG2A, ...
 QH2G2C10A,DH3AG2A,SH3G2C10A,DH3BG2A,QH3G2C10A,DH4AG2A,PH2G2C10A,DBPM, ...=&
 SH4G2C10A,DH4BG2A,DFCH,CH2XG2C10A,CH2YG2C10A,DFCH,GEG2C10A];
GIRDER3C10 = [DH4CG3A,GSG3C10A,MK1G3C10A,B1G3C10A,DM1AG3A,DFCH,CM1XG3C10A, ...
 CM1YG3C10A,DFCH,DM1BG3A,GEG3C10A];
GIRDER4C10 = [GSG4C10A,QM1G4C10A,DM2AG4A,SM1G4C10A,DM2BG4A,PM1G4C10A,DBPM, ...
 QM2G4C10A,DM2CG4A,SM2HG4C10B,MK3G4C10B,SM2HG4C10B,DM2CG4B,QM2G4C10B,DM2BG4B, ...
 SM1G4C10B,DM2AG4B,PM1G4C10B,DBPM,QM1G4C10B,DM1EG4B,DFCH,CM1YG4C10B,CM1XG4C10B, ...
 DFCH,GEG4C10B];
GIRDER5C10 = [GSG5C10B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C10B,MK2G5C10B,GEG5C10B];
GIRDER6C10 = [DL4BG6B,GSG6C10B,DFCH,CL2YG6C10B,CL2XG6C10B,DFCH,DL4AG6B, ...
 QL3G6C10B,DBPM,PL2G6C10B,DL3BG6B,SL3G6C10B,DL3AG6B,QL2G6C10B,DL2CG6B, ...
 SL2G6C10B,DL2BG6B,DSCH,CL1YG6C10B,CL1XG6C10B,DSCH,DL2AG6B,QL1G6C10B,DL1AG6B, ...
 PL1G6C10B,DBPM,SL1G6C10B,GEG6C10B];
GIRDER1C11 = [GSG1C11B,DL0G1B,MK5G1C11B,DL0G1B,GEG1C11B];
GIRDER2C11 = [GSG2C11B,SL1G2C11B,DL1AG2B,PL1G2C11B,DBPM,QL1G2C11B,DL2AG2B, ...
 DSCH,CL1XG2C11B,CL1YG2C11B,DSCH,DL2BG2B,SL2G2C11B,DL2CG2B,QL2G2C11B,DL3AG2B, ...
 SL3G2C11B,DL3BG2B,PL2G2C11B,DBPM,QL3G2C11B,DL4AG2B,DFCH,CL2XG2C11B,CL2YG2C11B, ...
 DFCH,GEG2C11B];
GIRDER3C11 = [DL4BG3B,GSG3C11B,MK1G3C11B,B1G3C11B,DM1AG3B,SQ2HG3C11B, ...
 CM1XG3C11B,CM1YG3C11B,SQ2HG3C11B,DM1BG3B,GEG3C11B];
GIRDER4C11 = [GSG4C11B,QM1G4C11B,DM2A2G4B,SM1G4C11B,DM2B2G4B,PM1G4C11B, ...
 DBPM,QM2G4C11B,DM2CG4B,SM2HG4C11A,MK3G4C11A,SM2HG4C11A,DM2CG4A,QM2G4C11A, ...
 DM2B2G4A,SM1G4C11A,DM2A2G4A,PM1G4C11A,DBPM,QM1G4C11A,DM1EG4A,DFCH,CM1YG4C11A, ...
 CM1XG4C11A,DFCH,GEG4C11A];
GIRDER5C11 = [GSG5C11A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C11A,MK2G5C11A,GEG5C11A];
GIRDER6C11 = [DH4CG6A,GSG6C11A,DFCH,CH2YG6C11A,CH2XG6C11A,DFCH,DH4BG6A, ...
 SH4G6C11A,DH4AG6A,PH2G6C11A,DBPM,QH3G6C11A,DH3BG6A,SH3G6C11A,DH3AG6A, ...
 QH2G6C11A,DH2CG6A,SH2G6C11A,DH2BG6A,DSCH,CH1YG6C11A,CH1XG6C11A,DSCH,DH2AG6A, ...
 QH1G6C11A,DH1AG6A,PH1G6C11A,DBPM,SH1G6C11A,GEG6C11A];
GIRDER1C12H = [GSG1C12A,DWSTR];
SPC10C11 = [GIRDER1C10,GIRDER2C10,GIRDER3C10,GIRDER4C10,GIRDER5C10, ...
 GIRDER6C10,GIRDER1C11,GIRDER2C11,GIRDER3C11,GIRDER4C11,GIRDER5C11,GIRDER6C11, ...
 GIRDER1C12H]; 
 

 GIRDER1C12 = [MK4G1C12A,DWSTR,GEG1C12A];
GIRDER2C12 = [GSG2C12A,SH1G2C12A,DH1AG2A,PH1G2C12A,DBPM,QH1G2C12A,DH2AG2A, ...
 SQ1HG2C12A,CH1XG2C12A,CH1YG2C12A,SQ1HG2C12A,DH2BG2A,SH2G2C12A,DH2CG2A, ...
 QH2G2C12A,DH3AG2A,SH3G2C12A,DH3BG2A,QH3G2C12A,DH4AG2A,PH2G2C12A,DBPM, ...
 SH4G2C12A,DH4BG2A,DFCH,CH2XG2C12A,CH2YG2C12A,DFCH,GEG2C12A];
GIRDER3C12 = [DH4CG3A,GSG3C12A,MK1G3C12A,B1G3C12A,DM1AG3A,DFCH,CM1XG3C12A, ...
 CM1YG3C12A,DFCH,DM1BG3A,GEG3C12A];
GIRDER4C12 = [GSG4C12A,QM1G4C12A,DM2AG4A,SM1G4C12A,DM2BG4A,PM1G4C12A,DBPM, ...
 QM2G4C12A,DM2CG4A,SM2HG4C12B,MK3G4C12B,SM2HG4C12B,DM2CG4B,QM2G4C12B,DM2BG4B, ...
 SM1G4C12B,DM2AG4B,PM1G4C12B,DBPM,QM1G4C12B,DM1EG4B,DFCH,CM1YG4C12B,CM1XG4C12B, ...
 DFCH,GEG4C12B];
GIRDER5C12 = [GSG5C12B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C12B,MK2G5C12B,GEG5C12B];
GIRDER6C12 = [DL4BG6B,GSG6C12B,DFCH,CL2YG6C12B,CL2XG6C12B,DFCH,DL4AG6B, ...
 QL3G6C12B,DBPM,PL2G6C12B,DL3BG6B,SL3G6C12B,DL3AG6B,QL2G6C12B,DL2CG6B, ...
 SL2G6C12B,DL2BG6B,DSCH,CL1YG6C12B,CL1XG6C12B,DSCH,DL2AG6B,QL1G6C12B,DL1AG6B, ...
 PL1G6C12B,DBPM,SL1G6C12B,GEG6C12B];
GIRDER1C13 = [GSG1C13B,DL0G1B,MK5G1C13B,DL0G1B,GEG1C13B];
GIRDER2C13 = [GSG2C13B,SL1G2C13B,DL1AG2B,PL1G2C13B,DBPM,QL1G2C13B,DL2AG2B, ...
 DSCH,CL1XG2C13B,CL1YG2C13B,DSCH,DL2BG2B,SL2G2C13B,DL2CG2B,QL2G2C13B,DL3AG2B, ...
 SL3G2C13B,DL3BG2B,PL2G2C13B,DBPM,QL3G2C13B,DL4AG2B,DFCH,CL2XG2C13B,CL2YG2C13B, ...
 DFCH,GEG2C13B];
GIRDER3C13 = [DL4BG3B,GSG3C13B,MK1G3C13B,B1G3C13B,DM1AG3B,SQ2HG3C13B, ...
 CM1XG3C13B,CM1YG3C13B,SQ2HG3C13B,DM1BG3B,GEG3C13B];
GIRDER4C13 = [GSG4C13B,QM1G4C13B,DM2A2G4B,SM1G4C13B,DM2B2G4B,PM1G4C13B, ...
 DBPM,QM2G4C13B,DM2CG4B,SM2HG4C13A,MK3G4C13A,SM2HG4C13A,DM2CG4A,QM2G4C13A, ...
 DM2B2G4A,SM1G4C13A,DM2A2G4A,PM1G4C13A,DBPM,QM1G4C13A,DM1EG4A,DFCH,CM1YG4C13A, ...
 CM1XG4C13A,DFCH,GEG4C13A];
GIRDER5C13 = [GSG5C13A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C13A,MK2G5C13A,GEG5C13A];
GIRDER6C13 = [DH4CG6A,GSG6C13A,DFCH,CH2YG6C13A,CH2XG6C13A,DFCH,DH4BG6A, ...
 SH4G6C13A,DH4AG6A,PH2G6C13A,DBPM,QH3G6C13A,DH3BG6A,SH3G6C13A,DH3AG6A, ...
 QH2G6C13A,DH2CG6A,SH2G6C13A,DH2BG6A,DSCH,CH1YG6C13A,CH1XG6C13A,DSCH,DH2AG6A, ...
 QH1G6C13A,DH1AG6A,PH1G6C13A,DBPM,SH1G6C13A,GEG6C13A];
GIRDER1C14H = [GSG1C14A,DH0G1A];
SPC12C13 = [GIRDER1C12,GIRDER2C12,GIRDER3C12,GIRDER4C12,GIRDER5C12, ...
 GIRDER6C12,GIRDER1C13,GIRDER2C13,GIRDER3C13,GIRDER4C13,GIRDER5C13,GIRDER6C13, ...
 GIRDER1C14H];
 
GIRDER1C14 = [MK4G1C14A,DH0G1A,GEG1C14A];
GIRDER2C14 = [GSG2C14A,SH1G2C14A,DH1AG2A,PH1G2C14A,DBPM,QH1G2C14A,DH2AG2A, ...
 SQ1HG2C14A,CH1XG2C14A,CH1YG2C14A,SQ1HG2C14A,DH2BG2A,SH2G2C14A,DH2CG2A, ...
 QH2G2C14A,DH3AG2A,SH3G2C14A,DH3BG2A,QH3G2C14A,DH4AG2A,PH2G2C14A,DBPM, ...
 SH4G2C14A,DH4BG2A,DFCH,CH2XG2C14A,CH2YG2C14A,DFCH,GEG2C14A];
GIRDER3C14 = [DH4CG3A,GSG3C14A,MK1G3C14A,B1G3C14A,DM1AG3A,DFCH,CM1XG3C14A, ...
 CM1YG3C14A,DFCH,DM1BG3A,GEG3C14A];
GIRDER4C14 = [GSG4C14A,QM1G4C14A,DM2AG4A,SM1G4C14A,DM2BG4A,PM1G4C14A,DBPM, ...
 QM2G4C14A,DM2CG4A,SM2HG4C14B,MK3G4C14B,SM2HG4C14B,DM2CG4B,QM2G4C14B,DM2BG4B, ...
 SM1G4C14B,DM2AG4B,PM1G4C14B,DBPM,QM1G4C14B,DM1EG4B,DFCH,CM1YG4C14B,CM1XG4C14B, ...
 DFCH,GEG4C14B];
GIRDER5C14 = [GSG5C14B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C14B,MK2G5C14B,GEG5C14B];
GIRDER6C14 = [DL4BG6B,GSG6C14B,DFCH,CL2YG6C14B,CL2XG6C14B,DFCH,DL4AG6B, ...
 QL3G6C14B,DBPM,PL2G6C14B,DL3BG6B,SL3G6C14B,DL3AG6B,QL2G6C14B,DL2CG6B, ...
 SL2G6C14B,DL2BG6B,DSCH,CL1YG6C14B,CL1XG6C14B,DSCH,DL2AG6B,QL1G6C14B,DL1AG6B, ...
 PL1G6C14B,DBPM,SL1G6C14B,GEG6C14B];
GIRDER1C15 = [GSG1C15B,IVUSTR,MK5G1C15B,IVUSTR,GEG1C15B];
GIRDER2C15 = [GSG2C15B,SL1G2C15B,DL1AG2B,PL1G2C15B,DBPM,QL1G2C15B,DL2AG2B, ...
 DSCH,CL1XG2C15B,CL1YG2C15B,DSCH,DL2BG2B,SL2G2C15B,DL2CG2B,QL2G2C15B,DL3AG2B, ...
 SL3G2C15B,DL3BG2B,PL2G2C15B,DBPM,QL3G2C15B,DL4AG2B,DFCH,CL2XG2C15B,CL2YG2C15B, ...
 DFCH,GEG2C15B];
GIRDER3C15 = [DL4BG3B,GSG3C15B,MK1G3C15B,B1G3C15B,DM1AG3B,SQ2HG3C15B, ...
 CM1XG3C15B,CM1YG3C15B,SQ2HG3C15B,DM1BG3B,GEG3C15B];
GIRDER4C15 = [GSG4C15B,QM1G4C15B,DM2A2G4B,SM1G4C15B,DM2B2G4B,PM1G4C15B, ...
 DBPM,QM2G4C15B,DM2CG4B,SM2HG4C15A,MK3G4C15A,SM2HG4C15A,DM2CG4A,QM2G4C15A, ...
 DM2B2G4A,SM1G4C15A,DM2A2G4A,PM1G4C15A,DBPM,QM1G4C15A,DM1EG4A,DFCH,CM1YG4C15A, ...
 CM1XG4C15A,DFCH,GEG4C15A];
GIRDER5C15 = [GSG5C15A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C15A,MK2G5C15A,GEG5C15A];
GIRDER6C15 = [DH4CG6A,GSG6C15A,DFCH,CH2YG6C15A,CH2XG6C15A,DFCH,DH4BG6A, ...
 SH4G6C15A,DH4AG6A,PH2G6C15A,DBPM,QH3G6C15A,DH3BG6A,SH3G6C15A,DH3AG6A, ...
 QH2G6C15A,DH2CG6A,SH2G6C15A,DH2BG6A,DSCH,CH1YG6C15A,CH1XG6C15A,DSCH,DH2AG6A, ...
 QH1G6C15A,DH1AG6A,PH1G6C15A,DBPM,SH1G6C15A,GEG6C15A];
GIRDER1C16H = [GSG1C16A,DH0G1A];
SPC14C15 = [GIRDER1C14,GIRDER2C14,GIRDER3C14,GIRDER4C14,GIRDER5C14, ...
 GIRDER6C14,GIRDER1C15,GIRDER2C15,GIRDER3C15,GIRDER4C15,GIRDER5C15,GIRDER6C15, ...
 GIRDER1C16H];
 
GIRDER1C16 = [MK4G1C16A,DH0G1A,GEG1C16A];
GIRDER2C16 = [GSG2C16A,SH1G2C16A,DH1AG2A,PH1G2C16A,DBPM,QH1G2C16A,DH2AG2A, ...
 SQ1HG2C16A,CH1XG2C16A,CH1YG2C16A,SQ1HG2C16A,DH2BG2A,SH2G2C16A,DH2CG2A, ...
 QH2G2C16A,DH3AG2A,SH3G2C16A,DH3BG2A,QH3G2C16A,DH4AG2A,PH2G2C16A,DBPM, ...
 SH4G2C16A,DH4BG2A,DFCH,CH2XG2C16A,CH2YG2C16A,DFCH,GEG2C16A];
GIRDER3C16 = [DH4CG3A,GSG3C16A,MK1G3C16A,B1G3C16A,DM1AG3A,DFCH,CM1XG3C16A, ...
 CM1YG3C16A,DFCH,DM1BG3A,GEG3C16A];
GIRDER4C16 = [GSG4C16A,QM1G4C16A,DM2AG4A,SM1G4C16A,DM2BG4A,PM1G4C16A,DBPM, ...
 QM2G4C16A,DM2CG4A,SM2HG4C16B,MK3G4C16B,SM2HG4C16B,DM2CG4B,QM2G4C16B,DM2BG4B, ...
 SM1G4C16B,DM2AG4B,PM1G4C16B,DBPM,QM1G4C16B,DM1EG4B,DFCH,CM1YG4C16B,CM1XG4C16B, ...
 DFCH,GEG4C16B];
GIRDER5C16 = [GSG5C16B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C16B,MK2G5C16B,GEG5C16B];
GIRDER6C16 = [DL4BG6B,GSG6C16B,DFCH,CL2YG6C16B,CL2XG6C16B,DFCH,DL4AG6B, ...
 QL3G6C16B,DBPM,PL2G6C16B,DL3BG6B,SL3G6C16B,DL3AG6B,QL2G6C16B,DL2CG6B, ...
 SL2G6C16B,DL2BG6B,DSCH,CL1YG6C16B,CL1XG6C16B,DSCH,DL2AG6B,QL1G6C16B,DL1AG6B, ...
 PL1G6C16B,DBPM,SL1G6C16B,GEG6C16B];
GIRDER1C17 = [GSG1C17B,IVUSTR,MK5G1C17B,IVUSTR,GEG1C17B];
GIRDER2C17 = [GSG2C17B,SL1G2C17B,DL1AG2B,PL1G2C17B,DBPM,QL1G2C17B,DL2AG2B, ...
 DSCH,CL1XG2C17B,CL1YG2C17B,DSCH,DL2BG2B,SL2G2C17B,DL2CG2B,QL2G2C17B,DL3AG2B, ...
 SL3G2C17B,DL3BG2B,PL2G2C17B,DBPM,QL3G2C17B,DL4AG2B,DFCH,CL2XG2C17B,CL2YG2C17B, ...
 DFCH,GEG2C17B];
GIRDER3C17 = [DL4BG3B,GSG3C17B,MK1G3C17B,B1G3C17B,DM1AG3B,SQ2HG3C17B, ...
 CM1XG3C17B,CM1YG3C17B,SQ2HG3C17B,DM1BG3B,GEG3C17B];
GIRDER4C17 = [GSG4C17B,QM1G4C17B,DM2A2G4B,SM1G4C17B,DM2B2G4B,PM1G4C17B, ...
 DBPM,QM2G4C17B,DM2CG4B,SM2HG4C17A,MK3G4C17A,SM2HG4C17A,DM2CG4A,QM2G4C17A, ...
 DM2B2G4A,SM1G4C17A,DM2A2G4A,PM1G4C17A,DBPM,QM1G4C17A,DM1EG4A,DFCH,CM1YG4C17A, ...
 CM1XG4C17A,DFCH,GEG4C17A];
GIRDER5C17 = [GSG5C17A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C17A,MK2G5C17A,GEG5C17A];
GIRDER6C17 = [DH4CG6A,GSG6C17A,DFCH,CH2YG6C17A,CH2XG6C17A,DFCH,DH4BG6A, ...
 SH4G6C17A,DH4AG6A,PH2G6C17A,DBPM,QH3G6C17A,DH3BG6A,SH3G6C17A,DH3AG6A, ...
 QH2G6C17A,DH2CG6A,SH2G6C17A,DH2BG6A,DSCH,CH1YG6C17A,CH1XG6C17A,DSCH,DH2AG6A, ...
 QH1G6C17A,DH1AG6A,PH1G6C17A,DBPM,SH1G6C17A,GEG6C17A];
GIRDER1C18H = [GSG1C18A,DH0G1A];
SPC16C17 = [GIRDER1C16,GIRDER2C16,GIRDER3C16,GIRDER4C16,GIRDER5C16, ...
 GIRDER6C16,GIRDER1C17,GIRDER2C17,GIRDER3C17,GIRDER4C17,GIRDER5C17,GIRDER6C17, ...
 GIRDER1C18H];

 GIRDER1C18 = [MK4G1C18A,DH0G1A,GEG1C18A];
GIRDER2C18 = [GSG2C18A,SH1G2C18A,DH1AG2A,PH1G2C18A,DBPM,QH1G2C18A,DH2AG2A, ...
 SQ1HG2C18A,CH1XG2C18A,CH1YG2C18A,SQ1HG2C18A,DH2BG2A,SH2G2C18A,DH2CG2A, ...
 QH2G2C18A,DH3AG2A,SH3G2C18A,DH3BG2A,QH3G2C18A,DH4AG2A,PH2G2C18A,DBPM, ...
 SH4G2C18A,DH4BG2A,DFCH,CH2XG2C18A,CH2YG2C18A,DFCH,GEG2C18A];
GIRDER3C18 = [DH4CG3A,GSG3C18A,MK1G3C18A,B1G3C18A,DM1AG3A,DFCH,CM1XG3C18A, ...
 CM1YG3C18A,DFCH,DM1BG3A,GEG3C18A];
GIRDER4C18 = [GSG4C18A,QM1G4C18A,DM2AG4A,SM1G4C18A,DM2BG4A,PM1G4C18A,DBPM, ...
 QM2G4C18A,DM2CG4A,SM2HG4C18B,MK3G4C18B,SM2HG4C18B,DM2CG4B,QM2G4C18B,DM2BG4B, ...
 SM1G4C18B,DM2AG4B,PM1G4C18B,DBPM,QM1G4C18B,DM1EG4B,DFCH,CM1YG4C18B,CM1XG4C18B, ...
 DFCH,GEG4C18B];
GIRDER5C18 = [GSG5C18B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C18B,MK2G5C18B,GEG5C18B];
GIRDER6C18 = [DL4BG6B,GSG6C18B,DFCH,CL2YG6C18B,CL2XG6C18B,DFCH,DL4AG6B, ...
 QL3G6C18B,DBPM,PL2G6C18B,DL3BG6B,SL3G6C18B,DL3AG6B,QL2G6C18B,DL2CG6B, ...
 SL2G6C18B,DL2BG6B,DSCH,CL1YG6C18B,CL1XG6C18B,DSCH,DL2AG6B,QL1G6C18B,DL1AG6B, ...
 PL1G6C18B,DBPM,SL1G6C18B,GEG6C18B];
GIRDER1C19 = [GSG1C19B,IVUSTR,MK5G1C19B,IVUSTR,GEG1C19B];
GIRDER2C19 = [GSG2C19B,SL1G2C19B,DL1AG2B,PL1G2C19B,DBPM,QL1G2C19B,DL2AG2B, ...
 DSCH,CL1XG2C19B,CL1YG2C19B,DSCH,DL2BG2B,SL2G2C19B,DL2CG2B,QL2G2C19B,DL3AG2B, ...
 SL3G2C19B,DL3BG2B,PL2G2C19B,DBPM,QL3G2C19B,DL4AG2B,DFCH,CL2XG2C19B,CL2YG2C19B, ...
 DFCH,GEG2C19B];
GIRDER3C19 = [DL4BG3B,GSG3C19B,MK1G3C19B,B1G3C19B,DM1AG3B,SQ2HG3C19B, ...
 CM1XG3C19B,CM1YG3C19B,SQ2HG3C19B,DM1BG3B,GEG3C19B];
GIRDER4C19 = [GSG4C19B,QM1G4C19B,DM2A2G4B,SM1G4C19B,DM2B2G4B,PM1G4C19B, ...
 DBPM,QM2G4C19B,DM2CG4B,SM2HG4C19A,MK3G4C19A,SM2HG4C19A,DM2CG4A,QM2G4C19A, ...
 DM2B2G4A,SM1G4C19A,DM2A2G4A,PM1G4C19A,DBPM,QM1G4C19A,DM1EG4A,DFCH,CM1YG4C19A, ...
 CM1XG4C19A,DFCH,GEG4C19A];
GIRDER5C19 = [GSG5C19A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C19A,MK2G5C19A,GEG5C19A];
GIRDER6C19 = [DH4CG6A,GSG6C19A,DFCH,CH2YG6C19A,CH2XG6C19A,DFCH,DH4BG6A, ...
 SH4G6C19A,DH4AG6A,PH2G6C19A,DBPM,QH3G6C19A,DH3BG6A,SH3G6C19A,DH3AG6A, ...
 QH2G6C19A,DH2CG6A,SH2G6C19A,DH2BG6A,DSCH,CH1YG6C19A,CH1XG6C19A,DSCH,DH2AG6A, ...
 QH1G6C19A,DH1AG6A,PH1G6C19A,DBPM,SH1G6C19A,GEG6C19A];
GIRDER1C20H = [GSG1C20A,DH0G1A];
SPC18C19 = [GIRDER1C18,GIRDER2C18,GIRDER3C18,GIRDER4C18,GIRDER5C18, ...
 GIRDER6C18,GIRDER1C19,GIRDER2C19,GIRDER3C19,GIRDER4C19,GIRDER5C19,GIRDER6C19, ...
 GIRDER1C20H];
 
GIRDER1C20 = [MK4G1C20A,DH0G1A,GEG1C20A];
GIRDER2C20 = [GSG2C20A,SH1G2C20A,DH1AG2A,PH1G2C20A,DBPM,QH1G2C20A,DH2AG2A, ...
 SQ1HG2C20A,CH1XG2C20A,CH1YG2C20A,SQ1HG2C20A,DH2BG2A,SH2G2C20A,DH2CG2A, ...
 QH2G2C20A,DH3AG2A,SH3G2C20A,DH3BG2A,QH3G2C20A,DH4AG2A,PH2G2C20A,DBPM, ...
 SH4G2C20A,DH4BG2A,DFCH,CH2XG2C20A,CH2YG2C20A,DFCH,GEG2C20A];
GIRDER3C20 = [DH4CG3A,GSG3C20A,MK1G3C20A,B1G3C20A,DM1AG3A,DFCH,CM1XG3C20A, ...
 CM1YG3C20A,DFCH,DM1BG3A,GEG3C20A];
GIRDER4C20 = [GSG4C20A,QM1G4C20A,DM2AG4A,SM1G4C20A,DM2BG4A,PM1G4C20A,DBPM, ...
 QM2G4C20A,DM2CG4A,SM2HG4C20B,MK3G4C20B,SM2HG4C20B,DM2CG4B,QM2G4C20B,DM2BG4B, ...
 SM1G4C20B,DM2AG4B,PM1G4C20B,DBPM,QM1G4C20B,DM1EG4B,DFCH,CM1YG4C20B,CM1XG4C20B, ...
 DFCH,GEG4C20B];
GIRDER5C20 = [GSG5C20B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C20B,MK2G5C20B,GEG5C20B];
GIRDER6C20 = [DL4BG6B,GSG6C20B,DFCH,CL2YG6C20B,CL2XG6C20B,DFCH,DL4AG6B, ...
 QL3G6C20B,DBPM,PL2G6C20B,DL3BG6B,SL3G6C20B,DL3AG6B,QL2G6C20B,DL2CG6B, ...
 SL2G6C20B,DL2BG6B,DSCH,CL1YG6C20B,CL1XG6C20B,DSCH,DL2AG6B,QL1G6C20B,DL1AG6B, ...
 PL1G6C20B,DBPM,SL1G6C20B,GEG6C20B];
GIRDER1C21 = [GSG1C21B,DL0G1B,MK5G1C21B,DL0G1B,GEG1C21B];
GIRDER2C21 = [GSG2C21B,SL1G2C21B,DL1AG2B,PL1G2C21B,DBPM,QL1G2C21B,DL2AG2B, ...
 DSCH,CL1XG2C21B,CL1YG2C21B,DSCH,DL2BG2B,SL2G2C21B,DL2CG2B,QL2G2C21B,DL3AG2B, ...
 SL3G2C21B,DL3BG2B,PL2G2C21B,DBPM,QL3G2C21B,DL4AG2B,DFCH,CL2XG2C21B,CL2YG2C21B, ...
 DFCH,GEG2C21B];
GIRDER3C21 = [DL4BG3B,GSG3C21B,MK1G3C21B,B1G3C21B,DM1AG3B,SQ2HG3C21B, ...
 CM1XG3C21B,CM1YG3C21B,SQ2HG3C21B,DM1BG3B,GEG3C21B];
GIRDER4C21 = [GSG4C21B,QM1G4C21B,DM2A2G4B,SM1G4C21B,DM2B2G4B,PM1G4C21B, ...
 DBPM,QM2G4C21B,DM2CG4B,SM2HG4C21A,MK3G4C21A,SM2HG4C21A,DM2CG4A,QM2G4C21A, ...
 DM2B2G4A,SM1G4C21A,DM2A2G4A,PM1G4C21A,DBPM,QM1G4C21A,DM1EG4A,DFCH,CM1YG4C21A, ...
 CM1XG4C21A,DFCH,GEG4C21A];
GIRDER5C21 = [GSG5C21A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C21A,MK2G5C21A,GEG5C21A];
GIRDER6C21 = [DH4CG6A,GSG6C21A,DFCH,CH2YG6C21A,CH2XG6C21A,DFCH,DH4BG6A, ...
 SH4G6C21A,DH4AG6A,PH2G6C21A,DBPM,QH3G6C21A,DH3BG6A,SH3G6C21A,DH3AG6A, ...
 QH2G6C21A,DH2CG6A,SH2G6C21A,DH2BG6A,DSCH,CH1YG6C21A,CH1XG6C21A,DSCH,DH2AG6A, ...
 QH1G6C21A,DH1AG6A,PH1G6C21A,DBPM,SH1G6C21A,GEG6C21A];
GIRDER1C22H = [GSG1C22A,DWSTR];
SPC20C21 = [GIRDER1C20,GIRDER2C20,GIRDER3C20,GIRDER4C20,GIRDER5C20, ...
 GIRDER6C20,GIRDER1C21,GIRDER2C21,GIRDER3C21,GIRDER4C21,GIRDER5C21,GIRDER6C21, ...
 GIRDER1C22H]; 
 
 GIRDER1C22 = [MK4G1C22A,DWSTR,GEG1C22A];
GIRDER2C22 = [GSG2C22A,SH1G2C22A,DH1AG2A,PH1G2C22A,DBPM,QH1G2C22A,DH2AG2A, ...
 SQ1HG2C22A,CH1XG2C22A,CH1YG2C22A,SQ1HG2C22A,DH2BG2A,SH2G2C22A,DH2CG2A, ...
 QH2G2C22A,DH3AG2A,SH3G2C22A,DH3BG2A,QH3G2C22A,DH4AG2A,PH2G2C22A,DBPM, ...
 SH4G2C22A,DH4BG2A,DFCH,CH2XG2C22A,CH2YG2C22A,DFCH,GEG2C22A];
GIRDER3C22 = [DH4CG3A,GSG3C22A,MK1G3C22A,B1G3C22A,DM1AG3A,DFCH,CM1XG3C22A, ...
 CM1YG3C22A,DFCH,DM1BG3A,GEG3C22A];
GIRDER4C22 = [GSG4C22A,QM1G4C22A,DM2AG4A,SM1G4C22A,DM2BG4A,PM1G4C22A,DBPM, ...
 QM2G4C22A,DM2CG4A,SM2HG4C22B,MK3G4C22B,SM2HG4C22B,DM2CG4B,QM2G4C22B,DM2BG4B, ...
 SM1G4C22B,DM2AG4B,PM1G4C22B,DBPM,QM1G4C22B,DM1EG4B,DFCH,CM1YG4C22B,CM1XG4C22B, ...
 DFCH,GEG4C22B];
GIRDER5C22 = [GSG5C22B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C22B,MK2G5C22B,GEG5C22B];
GIRDER6C22 = [DL4BG6B,GSG6C22B,DFCH,CL2YG6C22B,CL2XG6C22B,DFCH,DL4AG6B, ...
 QL3G6C22B,DBPM,PL2G6C22B,DL3BG6B,SL3G6C22B,DL3AG6B,QL2G6C22B,DL2CG6B, ...
 SL2G6C22B,DL2BG6B,DSCH,CL1YG6C22B,CL1XG6C22B,DSCH,DL2AG6B,QL1G6C22B,DL1AG6B, ...
 PL1G6C22B,DBPM,SL1G6C22B,GEG6C22B];
GIRDER1C23 = [GSG1C23B,DL0G1B,MK5G1C23B,DL0G1B,GEG1C23B];
GIRDER2C23 = [GSG2C23B,SL1G2C23B,DL1AG2B,PL1G2C23B,DBPM,QL1G2C23B,DL2AG2B, ...
 DSCH,CL1XG2C23B,CL1YG2C23B,DSCH,DL2BG2B,SL2G2C23B,DL2CG2B,QL2G2C23B,DL3AG2B, ...
 SL3G2C23B,DL3BG2B,PL2G2C23B,DBPM,QL3G2C23B,DL4AG2B,DFCH,CL2XG2C23B,CL2YG2C23B, ...
 DFCH,GEG2C23B];
GIRDER3C23 = [DL4BG3B,GSG3C23B,MK1G3C23B,B1G3C23B,DM1AG3B,SQ2HG3C23B, ...
 CM1XG3C23B,CM1YG3C23B,SQ2HG3C23B,DM1BG3B,GEG3C23B];
GIRDER4C23 = [GSG4C23B,QM1G4C23B,DM2A2G4B,SM1G4C23B,DM2B2G4B,PM1G4C23B, ...
 DBPM,QM2G4C23B,DM2CG4B,SM2HG4C23A,MK3G4C23A,SM2HG4C23A,DM2CG4A,QM2G4C23A, ...
 DM2B2G4A,SM1G4C23A,DM2A2G4A,PM1G4C23A,DBPM,QM1G4C23A,DM1EG4A,DFCH,CM1YG4C23A, ...
 CM1XG4C23A,DFCH,GEG4C23A];
GIRDER5C23 = [GSG5C23A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C23A,MK2G5C23A,GEG5C23A];
GIRDER6C23 = [DH4CG6A,GSG6C23A,DFCH,CH2YG6C23A,CH2XG6C23A,DFCH,DH4BG6A, ...
 SH4G6C23A,DH4AG6A,PH2G6C23A,DBPM,QH3G6C23A,DH3BG6A,SH3G6C23A,DH3AG6A, ...
 QH2G6C23A,DH2CG6A,SH2G6C23A,DH2BG6A,DSCH,CH1YG6C23A,CH1XG6C23A,DSCH,DH2AG6A, ...
 QH1G6C23A,DH1AG6A,PH1G6C23A,DBPM,SH1G6C23A,GEG6C23A];
GIRDER1C24H =[GSG1C24A,DH0G1A];
SPC22C23 = [GIRDER1C22,GIRDER2C22,GIRDER3C22,GIRDER4C22,GIRDER5C22, ...
 GIRDER6C22,GIRDER1C23,GIRDER2C23,GIRDER3C23,GIRDER4C23,GIRDER5C23,GIRDER6C23, ...
 GIRDER1C24H];
 
 GIRDER1C24 = [MK4G1C24A,DH0G1A,GEG1C24A];
GIRDER2C24 = [GSG2C24A,SH1G2C24A,DH1AG2A,PH1G2C24A,DBPM,QH1G2C24A,DH2AG2A, ...
 SQ1HG2C24A,CH1XG2C24A,CH1YG2C24A,SQ1HG2C24A,DH2BG2A,SH2G2C24A,DH2CG2A, ...
 QH2G2C24A,DH3AG2A,SH3G2C24A,DH3BG2A,QH3G2C24A,DH4AG2A,PH2G2C24A,DBPM, ...
 SH4G2C24A,DH4BG2A,DFCH,CH2XG2C24A,CH2YG2C24A,DFCH,GEG2C24A];
GIRDER3C24 = [DH4CG3A,GSG3C24A,MK1G3C24A,B1G3C24A,DM1AG3A,DFCH,CM1XG3C24A, ...
 CM1YG3C24A,DFCH,DM1BG3A,GEG3C24A];
GIRDER4C24 = [GSG4C24A,QM1G4C24A,DM2AG4A,SM1G4C24A,DM2BG4A,PM1G4C24A,DBPM, ...
 QM2G4C24A,DM2CG4A,SM2HG4C24B,MK3G4C24B,SM2HG4C24B,DM2CG4B,QM2G4C24B,DM2BG4B, ...
 SM1G4C24B,DM2AG4B,PM1G4C24B,DBPM,QM1G4C24B,DM1EG4B,DFCH,CM1YG4C24B,CM1XG4C24B, ...
 DFCH,GEG4C24B];
GIRDER5C24 = [GSG5C24B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C24B,MK2G5C24B,GEG5C24B];
GIRDER6C24 = [DL4BG6B,GSG6C24B,DFCH,CL2YG6C24B,CL2XG6C24B,DFCH,DL4AG6B, ...
 QL3G6C24B,DBPM,PL2G6C24B,DL3BG6B,SL3G6C24B,DL3AG6B,QL2G6C24B,DL2CG6B, ...
 SL2G6C24B,DL2BG6B,DSCH,CL1YG6C24B,CL1XG6C24B,DSCH,DL2AG6B,QL1G6C24B,DL1AG6B, ...
 PL1G6C24B,DBPM,SL1G6C24B,GEG6C24B];
GIRDER1C25 = [GSG1C25B,DL0G1B,MK5G1C25B,DL0G1B,GEG1C25B];
GIRDER2C25 = [GSG2C25B,SL1G2C25B,DL1AG2B,PL1G2C25B,DBPM,QL1G2C25B,DL2AG2B, ...
 DSCH,CL1XG2C25B,CL1YG2C25B,DSCH,DL2BG2B,SL2G2C25B,DL2CG2B,QL2G2C25B,DL3AG2B, ...
 SL3G2C25B,DL3BG2B,PL2G2C25B,DBPM,QL3G2C25B,DL4AG2B,DFCH,CL2XG2C25B,CL2YG2C25B, ...
 DFCH,GEG2C25B];
GIRDER3C25 = [DL4BG3B,GSG3C25B,MK1G3C25B,B1G3C25B,DM1AG3B,SQ2HG3C25B, ...
 CM1XG3C25B,CM1YG3C25B,SQ2HG3C25B,DM1BG3B,GEG3C25B];
GIRDER4C25 = [GSG4C25B,QM1G4C25B,DM2A2G4B,SM1G4C25B,DM2B2G4B,PM1G4C25B, ...
 DBPM,QM2G4C25B,DM2CG4B,SM2HG4C25A,MK3G4C25A,SM2HG4C25A,DM2CG4A,QM2G4C25A, ...
 DM2B2G4A,SM1G4C25A,DM2A2G4A,PM1G4C25A,DBPM,QM1G4C25A,DM1EG4A,DFCH,CM1YG4C25A, ...
 CM1XG4C25A,DFCH,GEG4C25A];
GIRDER5C25 = [GSG5C25A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C25A,MK2G5C25A,GEG5C25A];
GIRDER6C25 = [DH4CG6A,GSG6C25A,DFCH,CH2YG6C25A,CH2XG6C25A,DFCH,DH4BG6A, ...
 SH4G6C25A,DH4AG6A,PH2G6C25A,DBPM,QH3G6C25A,DH3BG6A,SH3G6C25A,DH3AG6A, ...
 QH2G6C25A,DH2CG6A,SH2G6C25A,DH2BG6A,DSCH,CH1YG6C25A,CH1XG6C25A,DSCH,DH2AG6A, ...
 QH1G6C25A,DH1AG6A,PH1G6C25A,DBPM,SH1G6C25A,GEG6C25A];
GIRDER1C26H = [GSG1C26A,DH0G1A];
SPC24C25 = [GIRDER1C24,GIRDER2C24,GIRDER3C24,GIRDER4C24,GIRDER5C24, ...
 GIRDER6C24,GIRDER1C25,GIRDER2C25,GIRDER3C25,GIRDER4C25,GIRDER5C25,GIRDER6C25, ...
 GIRDER1C26H];
 
 GIRDER1C26 = [MK4G1C26A,DH0G1A,GEG1C26A];
GIRDER2C26 = [GSG2C26A,SH1G2C26A,DH1AG2A,PH1G2C26A,DBPM,QH1G2C26A,DH2AG2A, ...
 SQ1HG2C26A,CH1XG2C26A,CH1YG2C26A,SQ1HG2C26A,DH2BG2A,SH2G2C26A,DH2CG2A, ...
 QH2G2C26A,DH3AG2A,SH3G2C26A,DH3BG2A,QH3G2C26A,DH4AG2A,PH2G2C26A,DBPM, ...
 SH4G2C26A,DH4BG2A,DFCH,CH2XG2C26A,CH2YG2C26A,DFCH,GEG2C26A];
GIRDER3C26 = [DH4CG3A,GSG3C26A,MK1G3C26A,B1G3C26A,DM1AG3A,DFCH,CM1XG3C26A, ...
 CM1YG3C26A,DFCH,DM1BG3A,GEG3C26A];
GIRDER4C26 = [GSG4C26A,QM1G4C26A,DM2AG4A,SM1G4C26A,DM2BG4A,PM1G4C26A,DBPM, ...
 QM2G4C26A,DM2CG4A,SM2HG4C26B,MK3G4C26B,SM2HG4C26B,DM2CG4B,QM2G4C26B,DM2BG4B, ...
 SM1G4C26B,DM2AG4B,PM1G4C26B,DBPM,QM1G4C26B,DM1EG4B,DFCH,CM1YG4C26B,CM1XG4C26B, ...
 DFCH,GEG4C26B];
GIRDER5C26 = [GSG5C26B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C26B,MK2G5C26B,GEG5C26B];
GIRDER6C26 = [DL4BG6B,GSG6C26B,DFCH,CL2YG6C26B,CL2XG6C26B,DFCH,DL4AG6B, ...
 QL3G6C26B,DBPM,PL2G6C26B,DL3BG6B,SL3G6C26B,DL3AG6B,QL2G6C26B,DL2CG6B, ...
 SL2G6C26B,DL2BG6B,DSCH,CL1YG6C26B,CL1XG6C26B,DSCH,DL2AG6B,QL1G6C26B,DL1AG6B, ...
 PL1G6C26B,DBPM,SL1G6C26B,GEG6C26B];
GIRDER1C27 = [GSG1C27B,DL0G1B,MK5G1C27B,DL0G1B,GEG1C27B];
GIRDER2C27 = [GSG2C27B,SL1G2C27B,DL1AG2B,PL1G2C27B,DBPM,QL1G2C27B,DL2AG2B, ...
 DSCH,CL1XG2C27B,CL1YG2C27B,DSCH,DL2BG2B,SL2G2C27B,DL2CG2B,QL2G2C27B,DL3AG2B, ...
 SL3G2C27B,DL3BG2B,PL2G2C27B,DBPM,QL3G2C27B,DL4AG2B,DFCH,CL2XG2C27B,CL2YG2C27B, ...
 DFCH,GEG2C27B];
GIRDER3C27 = [DL4BG3B,GSG3C27B,MK1G3C27B,B1G3C27B,DM1AG3B,SQ2HG3C27B, ...
 CM1XG3C27B,CM1YG3C27B,SQ2HG3C27B,DM1BG3B,GEG3C27B];
GIRDER4C27 = [GSG4C27B,QM1G4C27B,DM2A2G4B,SM1G4C27B,DM2B2G4B,PM1G4C27B, ...
 DBPM,QM2G4C27B,DM2CG4B,SM2HG4C27A,MK3G4C27A,SM2HG4C27A,DM2CG4A,QM2G4C27A, ...
 DM2B2G4A,SM1G4C27A,DM2A2G4A,PM1G4C27A,DBPM,QM1G4C27A,DM1EG4A,DFCH,CM1YG4C27A, ...
 CM1XG4C27A,DFCH,GEG4C27A];
GIRDER5C27 = [GSG5C27A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C27A,MK2G5C27A,GEG5C27A];
GIRDER6C27 = [DH4CG6A,GSG6C27A,DFCH,CH2YG6C27A,CH2XG6C27A,DFCH,DH4BG6A, ...
 SH4G6C27A,DH4AG6A,PH2G6C27A,DBPM,QH3G6C27A,DH3BG6A,SH3G6C27A,DH3AG6A, ...
 QH2G6C27A,DH2CG6A,SH2G6C27A,DH2BG6A,DSCH,CH1YG6C27A,CH1XG6C27A,DSCH,DH2AG6A, ...
 QH1G6C27A,DH1AG6A,PH1G6C27A,DBPM,SH1G6C27A,GEG6C27A];
GIRDER1C28H = [GSG1C28A,DH0G1A];
SPC26C27 = [GIRDER1C26,GIRDER2C26,GIRDER3C26,GIRDER4C26,GIRDER5C26, ...
 GIRDER6C26,GIRDER1C27,GIRDER2C27,GIRDER3C27,GIRDER4C27,GIRDER5C27,GIRDER6C27, ...
 GIRDER1C28H];

 GIRDER1C28 = [MK4G1C28A,DH0G1A,GEG1C28A];
GIRDER2C28 = [GSG2C28A,SH1G2C28A,DH1AG2A,PH1G2C28A,DBPM,QH1G2C28A,DH2AG2A, ...
 SQ1HG2C28A,CH1XG2C28A,CH1YG2C28A,SQ1HG2C28A,DH2BG2A,SH2G2C28A,DH2CG2A, ...
 QH2G2C28A,DH3AG2A,SH3G2C28A,DH3BG2A,QH3G2C28A,DH4AG2A,PH2G2C28A,DBPM, ...
 SH4G2C28A,DH4BG2A,DFCH,CH2XG2C28A,CH2YG2C28A,DFCH,GEG2C28A];
GIRDER3C28 = [DH4CG3A,GSG3C28A,MK1G3C28A,B1G3C28A,DM1AG3A,DFCH,CM1XG3C28A, ...
 CM1YG3C28A,DFCH,DM1BG3A,GEG3C28A];
GIRDER4C28 = [GSG4C28A,QM1G4C28A,DM2AG4A,SM1G4C28A,DM2BG4A,PM1G4C28A,DBPM, ...
 QM2G4C28A,DM2CG4A,SM2HG4C28B,MK3G4C28B,SM2HG4C28B,DM2CG4B,QM2G4C28B,DM2BG4B, ...
 SM1G4C28B,DM2AG4B,PM1G4C28B,DBPM,QM1G4C28B,DM1EG4B,DFCH,CM1YG4C28B,CM1XG4C28B, ...
 DFCH,GEG4C28B];
GIRDER5C28 = [GSG5C28B,DM1DG5B,DPWG5B,DM1CG5B,B1G5C28B,MK2G5C28B,GEG5C28B];
GIRDER6C28 = [DL4BG6B,GSG6C28B,DFCH,CL2YG6C28B,CL2XG6C28B,DFCH,DL4AG6B, ...
 QL3G6C28B,DBPM,PL2G6C28B,DL3BG6B,SL3G6C28B,DL3AG6B,QL2G6C28B,DL2CG6B, ...
 SL2G6C28B,DL2BG6B,DSCH,CL1YG6C28B,CL1XG6C28B,DSCH,DL2AG6B,QL1G6C28B,DL1AG6B, ...
 PL1G6C28B,DBPM,SL1G6C28B,GEG6C28B];
GIRDER1C29 = [GSG1C29B,DL0G1B,MK5G1C29B,DL0G1B,GEG1C29B];
GIRDER2C29 = [GSG2C29B,SL1G2C29B,DL1AG2B,PL1G2C29B,DBPM,QL1G2C29B,DL2AG2B, ...
 DSCH,CL1XG2C29B,CL1YG2C29B,DSCH,DL2BG2B,SL2G2C29B,DL2CG2B,QL2G2C29B,DL3AG2B, ...
 SL3G2C29B,DL3BG2B,PL2G2C29B,DBPM,QL3G2C29B,DL4AG2B,DFCH,CL2XG2C29B,CL2YG2C29B, ...
 DFCH,GEG2C29B];
GIRDER3C29 = [DL4BG3B,GSG3C29B,MK1G3C29B,B1G3C29B,DM1AG3B,SQ2HG3C29B, ...
 CM1XG3C29B,CM1YG3C29B,SQ2HG3C29B,DM1BG3B,GEG3C29B];
GIRDER4C29 = [GSG4C29B,QM1G4C29B,DM2A2G4B,SM1G4C29B,DM2B2G4B,PM1G4C29B, ...
 DBPM,QM2G4C29B,DM2CG4B,SM2HG4C29A,MK3G4C29A,SM2HG4C29A,DM2CG4A,QM2G4C29A, ...
 DM2B2G4A,SM1G4C29A,DM2A2G4A,PM1G4C29A,DBPM,QM1G4C29A,DM1EG4A,DFCH,CM1YG4C29A, ...
 CM1XG4C29A,DFCH,GEG4C29A];
GIRDER5C29 = [GSG5C29A,DM1DG5A,DPWG5A,DM1CG5A,B1G5C29A,MK2G5C29A,GEG5C29A];
GIRDER6C29 = [DH4CG6A,GSG6C29A,DFCH,CH2YG6C29A,CH2XG6C29A,DFCH,DH4BG6A, ...
 SH4G6C29A,DH4AG6A,PH2G6C29A,DBPM,QH3G6C29A,DH3BG6A,SH3G6C29A,DH3AG6A, ...
 QH2G6C29A,DH2CG6A,SH2G6C29A,DH2BG6A,DSCH,CH1YG6C29A,CH1XG6C29A,DSCH,DH2AG6A, ...
 QH1G6C29A,DH1AG6A,PH1G6C29A,DBPM,SH1G6C29A,GEG6C29A];
GIRDER1C30H = [GSG1C30A,DH0G1A];
SPC28C29 = [GIRDER1C28,GIRDER2C28,GIRDER3C28,GIRDER4C28,GIRDER5C28, ...
 GIRDER6C28,GIRDER1C29,GIRDER2C29,GIRDER3C29,GIRDER4C29,GIRDER5C29,GIRDER6C29, ...
 GIRDER1C30H];
 
RING = [SPC30C01,SPC02C03,SPC04C05,SPC06C07,SPC08C09,SPC10C11, ...
 SPC12C13,SPC14C15,SPC16C17,SPC18C19,SPC20C21,SPC22C23,SPC24C25,SPC26C27, ...
 SPC28C29 CAV];

%RING = monitor('RING','IdentityPass');
buildlat(RING);

% Set the chromaticity sextupoles (1 for now)
iAT = findcells(THERING,'FamName', 'SM1');
THERING = setcellstruct(THERING, 'PolynomB', iAT, -11.9222, 3);
iAT = findcells(THERING,'FamName', 'SM2');
THERING = setcellstruct(THERING, 'PolynomB', iAT,  13.8209, 3);

% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f (design length 791.958 m), f_RF = %8.6f MHz\n', L0_tot, Harm_Num*c0/(L0_tot*1e6));
RFI = findcells(THERING, 'FamName', 'RF');
THERING = setcellstruct(THERING, 'Frequency', RFI(1:length(RFI)), Harm_Num*c0/L0_tot);

% Add energy to each element 
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy*1e9);

clear global FAMLIST
evalin('base','clear LOSSFLAG');
%evalin('caller','global THERING');
