function nsls2_tracy_june2008
fprintf('   Loading AT lattice (%s)\n', mfilename);

global FAMLIST THERING
FAMLIST=cell(0);
AP = aperture('AP',[-0.035, 0.035, -0.017, 0.017],'AperturePass');
Energy = 3.0;
CAV=rfcavity('CAV', 0, 5000000.000000, 499680594.880032, 1320.000000, 'CavityPass');
CH=corrector('CH', 0, [0 0], 'CorrectorPass');
CV=corrector('CV', 0, [0 0], 'CorrectorPass');
BPM = monitor('BPM','IdentityPass');
GE = monitor('GE','IdentityPass');
GS = monitor('GS','IdentityPass');
SS = monitor('SS','IdentityPass');
LS = monitor('LS','IdentityPass');
DBPM=drift('DBPM', 0.087500, 'DriftPass');
DFCH=drift('DFCH', 0.150000, 'DriftPass');
DH0G1A=drift('DH0G1A', 4.650000, 'DriftPass');
DH1AG2A=drift('DH1AG2A', 0.087500, 'DriftPass');
DH1AG6B=drift('DH1AG6B', 0.087500, 'DriftPass');
DH2AG2A=drift('DH2AG2A', 0.157500, 'DriftPass');
DH2AG6B=drift('DH2AG6B', 0.132500, 'DriftPass');
DH2BG2A=drift('DH2BG2A', 0.157500, 'DriftPass');
DH2BG6B=drift('DH2BG6B', 0.182500, 'DriftPass');
DH2CG2A=drift('DH2CG2A', 0.150000, 'DriftPass');
DH2CG6B=drift('DH2CG6B', 0.150000, 'DriftPass');
DH3AG2A=drift('DH3AG2A', 0.190000, 'DriftPass');
DH3AG6B=drift('DH3AG6B', 0.190000, 'DriftPass');
DH3BG2A=drift('DH3BG2A', 0.195000, 'DriftPass');
DH3BG6B=drift('DH3BG6B', 0.195000, 'DriftPass');
DH4AG2A=drift('DH4AG2A', 0.087500, 'DriftPass');
DH4AG6B=drift('DH4AG6B', 0.087500, 'DriftPass');
DH4BG2A=drift('DH4BG2A', 0.248500, 'DriftPass');
DH4BG6B=drift('DH4BG6B', 0.077140, 'DriftPass');
DH4CG3A=drift('DH4CG3A', 0.031500, 'DriftPass');
DH4CG6B=drift('DH4CG6B', 0.202860, 'DriftPass');
DL0G1A=drift('DL0G1A', 3.300000, 'DriftPass');
DL1AG2A=drift('DL1AG2A', 0.087500, 'DriftPass');
DL1AG6B=drift('DL1AG6B', 0.087500, 'DriftPass');
DL2AG2A=drift('DL2AG2A', 0.137500, 'DriftPass');
DL2AG6B=drift('DL2AG6B', 0.137500, 'DriftPass');
DL2BG2A=drift('DL2BG2A', 0.137500, 'DriftPass');
DL2BG6B=drift('DL2BG6B', 0.137500, 'DriftPass');
DL2CG2A=drift('DL2CG2A', 0.250000, 'DriftPass');
DL2CG6B=drift('DL2CG6B', 0.250000, 'DriftPass');
DL3AG2A=drift('DL3AG2A', 0.613600, 'DriftPass');
DL3AG6B=drift('DL3AG6B', 0.613600, 'DriftPass');
DL3BG2A=drift('DL3BG2A', 0.087500, 'DriftPass');
DL3BG6B=drift('DL3BG6B', 0.087500, 'DriftPass');
DL4AG2A=drift('DL4AG2A', 0.281700, 'DriftPass');
DL4AG6B=drift('DL4AG6B', 0.082200, 'DriftPass');
DL4BG3A=drift('DL4BG3A', 0.018300, 'DriftPass');
DL4BG6B=drift('DL4BG6B', 0.217800, 'DriftPass');
DM1AG3A=drift('DM1AG3A', 0.365000, 'DriftPass');
DM1BG3A=drift('DM1BG3A', 0.310000, 'DriftPass');
DM1CG5B=drift('DM1CG5B', 0.200000, 'DriftPass');
DM1DG5B=drift('DM1DG5B', 0.055400, 'DriftPass');
DM1EG4B=drift('DM1EG4B', 0.219600, 'DriftPass');
DM2A2G4A=drift('DM2A2G4A', 0.200000, 'DriftPass');
DM2AG4B=drift('DM2AG4B', 0.112500, 'DriftPass');
DM2B2G4B=drift('DM2B2G4B', 0.670000, 'DriftPass');
DM2BG4A=drift('DM2BG4A', 0.582500, 'DriftPass');
DM2CG4A=drift('DM2CG4A', 0.200000, 'DriftPass');
DM2CG4B=drift('DM2CG4B', 0.200000, 'DriftPass');
DPWG5B=drift('DPWG5B', 0.200000, 'DriftPass');
DSCH=drift('DSCH', 0.100000, 'DriftPass');
B1G3C01A=rbend('BEND', 2.620000, 6.000000*pi/180, 3.000000*pi/180, 3.000000*pi/180, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C30A=rbend('BEND', 2.620000, 6.000000*pi/180, 3.000000*pi/180, 3.000000*pi/180, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C01B=rbend('BEND', 2.620000, 6.000000*pi/180, 3.000000*pi/180, 3.000000*pi/180, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C30B=rbend('BEND', 2.620000, 6.000000*pi/180, 3.000000*pi/180, 3.000000*pi/180, 0.000000, 'BndMPoleSymplectic4Pass');
QH1=quadrupole('QH1', 0.250000, -0.688256, 'StrMPoleSymplectic4Pass');
QH2=quadrupole('QH2', 0.400000, 1.655220, 'StrMPoleSymplectic4Pass');
QH3=quadrupole('QH3', 0.250000, -1.873900, 'StrMPoleSymplectic4Pass');
QL1=quadrupole('QL1', 0.250000, -1.782990, 'StrMPoleSymplectic4Pass');
QL2=quadrupole('QL2', 0.400000, 2.011750, 'StrMPoleSymplectic4Pass');
QL3=quadrupole('QL3', 0.250000, -1.557680, 'StrMPoleSymplectic4Pass');
QM1=quadrupole('QM1', 0.250000, -0.824645, 'StrMPoleSymplectic4Pass');
QM2=quadrupole('QM2', 0.250000, 1.387710, 'StrMPoleSymplectic4Pass');
SQ1H=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
SQ2H=quadrupole('SQ', 0.150000, 0.000000, 'StrMPoleSymplectic4Pass');
SH1=sextupole('SH1', 0.200000, 9.995400, 'StrMPoleSymplectic4Pass');
SH2=sextupole('SH2', 0.200000, 4.533030, 'StrMPoleSymplectic4Pass');
SH3=sextupole('SH3', 0.200000, -8.869700, 'StrMPoleSymplectic4Pass');
SH4=sextupole('SH4', 0.200000, -5.637850, 'StrMPoleSymplectic4Pass');
SL1=sextupole('SL1', 0.200000, 3.055080, 'StrMPoleSymplectic4Pass');
SL2=sextupole('SL2', 0.200000, 8.661350, 'StrMPoleSymplectic4Pass');
SL3=sextupole('SL3', 0.200000, -9.999950, 'StrMPoleSymplectic4Pass');
SM1=sextupole('SM1', 0.200000, -11.301650, 'StrMPoleSymplectic4Pass');
SM2H=sextupole('SM2', 0.125000, 12.779700, 'StrMPoleSymplectic4Pass');
Girder1C30=[ DH0G1A,GE];

Girder2C30=[ GS,SH1,DH1AG2A,BPM,DBPM,QH1,DH2AG2A,SQ1H,CH,CV,SQ1H,    DH2BG2A,SH2,DH2CG2A,QH2,DH3AG2A,SH3,DH3BG2A,QH3,DH4AG2A,BPM,    DBPM,SH4,DH4BG2A,DFCH,CH,CV,DFCH,GE,DH4CG3A];

Girder3C30=[ GS,B1G3C30A,DM1AG3A,DFCH,CH,CV,DFCH,DM1BG3A,GE];

Girder4C30=[ GS,QM1,DM2A2G4A,SM1,DM2BG4A,BPM,DBPM,QM2,DM2CG4A,    SM2H,SM2H,DM2CG4B,QM2,DM2B2G4B,SM1,DM2AG4B,BPM,DBPM,QM1,    DM1EG4B,DFCH,CV,CH,DFCH,GE];

Girder5C30=[ GS,DM1DG5B,DPWG5B,DM1CG5B,B1G5C30B,GE,DL4BG6B];

Girder6C30=[ GS,DFCH,CV,CH,DFCH,DL4AG6B,QL3,DBPM,BPM,DL3BG6B,SL3,    DL3AG6B,QL2,DL2CG6B,SL2,DL2BG6B,DSCH,CV,CH,DSCH,DL2AG6B,QL1,    DL1AG6B,BPM,DBPM,SL1,GE];

Girder1C01=[ GS,DL0G1A,DL0G1A,GE];

Girder2C01=[ GS,SL1,DL1AG2A,BPM,DBPM,QL1,DL2AG2A,DSCH,CH,CV,DSCH,    DL2BG2A,SL2,DL2CG2A,QL2,DL3AG2A,SL3,DL3BG2A,BPM,DBPM,QL3,    DL4AG2A,DFCH,CH,CV,DFCH,GE,DL4BG3A];

Girder3C01=[ GS,B1G3C01A,DM1AG3A,SQ2H,CH,CV,SQ2H,DM1BG3A,GE];

Girder4C01=[ GS,QM1,DM2A2G4A,SM1,DM2BG4A,BPM,DBPM,QM2,DM2CG4A,SM2H,    SM2H,DM2CG4B,QM2,DM2B2G4B,SM1,DM2AG4B,BPM,DBPM,QM1,DM1EG4B,    DFCH,CV,CH,DFCH,GE];

Girder5C01=[ GS,DM1DG5B,DPWG5B,DM1CG5B,B1G5C01B,GE,DH4CG6B];

Girder6C01=[ GS,DFCH,CV,CH,DFCH,DH4BG6B,SH4,DH4AG6B,BPM,DBPM,QH3,    DH3BG6B,SH3,DH3AG6B,QH2,DH2CG6B,SH2,DH2BG6B,DSCH,CV,CH,DSCH,    DH2AG6B,QH1,DH1AG6B,BPM,DBPM,SH1,GE];

Girder1C02H=[ GS,DH0G1A];

SPC30C01=[ Girder1C30,Girder2C30,Girder3C30,Girder4C30,Girder5C30,    Girder6C30,SS,Girder1C01,Girder2C01,Girder3C01,Girder4C01,    Girder5C01,Girder6C01,Girder1C02H,LS];

RING=[ 
    SPC30C01, SPC30C01, SPC30C01, SPC30C01, SPC30C01, ...
    SPC30C01, SPC30C01, SPC30C01, SPC30C01, SPC30C01, ...
    SPC30C01, SPC30C01, SPC30C01, SPC30C01, SPC30C01, CAV];

buildlat(RING);
evalin('caller','global THERING FAMLIST GLOBVAL');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy*1e9);
clear global FAMLIST
evalin('base','clear LOSSFLAG');
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f\n', L0_tot);
