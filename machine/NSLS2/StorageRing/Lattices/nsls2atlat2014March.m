function nsls2atlat2014March
%lattice converted from Weiming's commission elegant lattice to AT by Xi Yang
fprintf('   Loading AT lattice (%s)\n', mfilename);

global FAMLIST THERING
Energy = 3.00;
GLOBVAL.E0 = Energy;  % This might disappear in the future
GLOBVAL.LatticeFile = 'nsls2atlat2014March';
FAMLIST=cell(0);
c0       = 299792458; % speed of light in vacuum [m/s]
Harm_Num = 1320;
L0 = 791.958000;
AP = aperture('AP',[-0.035, 0.035, -0.017, 0.017],'AperturePass');
DFT=drift('DFT', 0.022000, 'DriftPass');
DFT1=drift('DFT1', 0.233200, 'DriftPass');
DFT2=drift('DFT2', 0.051000, 'DriftPass');
FH2G1C30A = monitor('FH2G1C30A','IdentityPass');
FM1G4C30A = monitor('FM1G4C30A','IdentityPass');
FL1G1C01A = monitor('FL1G1C01A','IdentityPass');
FL2G1C01A = monitor('FL2G1C01A','IdentityPass');
FM1G4C01A = monitor('FM1G4C01A','IdentityPass');
FH1G1C02A = monitor('FH1G1C02A','IdentityPass');
DH01G1A=drift('DH01G1A', 4.165100, 'DriftPass');
DH02G1A=drift('DH02G1A', 4.293790, 'DriftPass');
DH1G1A=drift('DH1G1A', 0.312210, 'DriftPass');
DH2G1A=drift('DH2G1A', 0.440900, 'DriftPass');
DH1AG2A=drift('DH1AG2A', 0.085000, 'DriftPass');
DH4AG2A=drift('DH4AG2A', 0.076020, 'DriftPass');
DM2BG4A=drift('DM2BG4A', 0.292400, 'DriftPass');
DM2AG4B=drift('DM2AG4B', 0.262260, 'DriftPass');
DL3CG6B=drift('DL3CG6B', 0.087780, 'DriftPass');
DL1AG6B=drift('DL1AG6B', 0.078300, 'DriftPass');
DL1AG2A=drift('DL1AG2A', 0.090000, 'DriftPass');
DL3CG2A=drift('DL3CG2A', 0.090080, 'DriftPass');
DM2B2G4A=drift('DM2B2G4A', 0.292400, 'DriftPass');
DM2A2G4B=drift('DM2A2G4B', 0.262260, 'DriftPass');
DH4AG6B=drift('DH4AG6B', 0.089600, 'DriftPass');
DH1AG6B=drift('DH1AG6B', 0.080590, 'DriftPass');
DBPM01=drift('DBPM01', 0.081000, 'DriftPass');
DBPM02=drift('DBPM02', 0.089980, 'DriftPass');
DBPM03=drift('DBPM03', 0.084400, 'DriftPass');
DBPM04=drift('DBPM04', 0.089240, 'DriftPass');
DBPM05=drift('DBPM05', 0.078220, 'DriftPass');
DBPM06=drift('DBPM06', 0.087700, 'DriftPass');
DBPM07=drift('DBPM07', 0.076000, 'DriftPass');
DBPM08=drift('DBPM08', 0.075920, 'DriftPass');
DBPM09=drift('DBPM09', 0.084400, 'DriftPass');
DBPM10=drift('DBPM10', 0.089240, 'DriftPass');
DBPM11=drift('DBPM11', 0.076400, 'DriftPass');
DBPM12=drift('DBPM12', 0.085410, 'DriftPass');
DH2AG2A=drift('DH2AG2A', 0.148500, 'DriftPass');
DH2BG2A=drift('DH2BG2A', 0.453500, 'DriftPass');
DH3AG2A=drift('DH3AG2A', 0.184000, 'DriftPass');
DH3BG2A=drift('DH3BG2A', 0.186000, 'DriftPass');
DH4BG2A=drift('DH4BG2A', 0.248500, 'DriftPass');
DFCH=drift('DFCH', 0.150000, 'DriftPass');
DH4CG3A=drift('DH4CG3A', 0.031500, 'DriftPass');
DM1AG4A=drift('DM1AG4A', 0.501000, 'DriftPass');
DM1BG4A=drift('DM1BG4A', 0.275500, 'DriftPass');
DM2AG4A=drift('DM2AG4A', 0.201500, 'DriftPass');
DM2BG4B=drift('DM2BG4B', 0.504000, 'DriftPass');
DM2CG4A=drift('DM2CG4A', 0.184000, 'DriftPass');
DM2CG4B=drift('DM2CG4B', 0.184000, 'DriftPass');
DM2A2G4A=drift('DM2A2G4A', 0.201500, 'DriftPass');
DM2B2G4B=drift('DM2B2G4B', 0.504000, 'DriftPass');
DM1EG4B=drift('DM1EG4B', 0.110500, 'DriftPass');
DM1DG5B1=drift('DM1DG5B1', 0.100000, 'DriftPass');
DM1DG5B2=drift('DM1DG5B2', 0.100000, 'DriftPass');
DPWG5B=drift('DPWG5B', 0.200000, 'DriftPass');
DM1CG5B1=drift('DM1CG5B1', 0.266000, 'DriftPass');
DM1CG5B2=drift('DM1CG5B2', 0.266000, 'DriftPass');
DL4BG6B=drift('DL4BG6B', 0.217800, 'DriftPass');
DL4AG6B=drift('DL4AG6B', 0.373200, 'DriftPass');
DL3BG6B=drift('DL3BG6B', 0.157500, 'DriftPass');
DL3AG6B=drift('DL3AG6B', 0.202100, 'DriftPass');
DL2CG6B=drift('DL2CG6B', 0.244000, 'DriftPass');
DL2BG6B=drift('DL2BG6B', 0.131250, 'DriftPass');
DSCH=drift('DSCH', 0.100000, 'DriftPass');
DL2AG6B=drift('DL2AG6B', 0.134750, 'DriftPass');
DL0BG1A=drift('DL0BG1A', 0.446520, 'DriftPass');
DL0AG1A=drift('DL0AG1A', 0.312320, 'DriftPass');
DLDK=drift('DLDK', 0.095000, 'DriftPass');
DL01G1A=drift('DL01G1A', 2.663480, 'DriftPass');
DL02G1A=drift('DL02G1A', 2.797680, 'DriftPass');
DL2AG2A=drift('DL2AG2A', 0.134750, 'DriftPass');
DL2BG2A=drift('DL2BG2A', 0.131250, 'DriftPass');
DL2CG2A=drift('DL2CG2A', 0.244000, 'DriftPass');
DL3AG2A=drift('DL3AG2A', 0.202100, 'DriftPass');
DL3BG2A=drift('DL3BG2A', 0.157500, 'DriftPass');
DL4AG2A=drift('DL4AG2A', 0.572700, 'DriftPass');
DL4BG3A=drift('DL4BG3A', 0.018300, 'DriftPass');
DH4CG6B=drift('DH4CG6B', 0.216340, 'DriftPass');
DH4BG6B=drift('DH4BG6B', 0.063660, 'DriftPass');
DH3BG6B=drift('DH3BG6B', 0.186000, 'DriftPass');
DH3AG6B=drift('DH3AG6B', 0.184000, 'DriftPass');
DH2BG6B=drift('DH2BG6B', 0.478500, 'DriftPass');
DH2AG6B=drift('DH2AG6B', 0.123500, 'DriftPass');
CH1XG2C30A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C30A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C30A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C30B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C30B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C30B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C01A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C01A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C01A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C01B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C01B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C01B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C30A = monitor('MK4G1C30A','IdentityPass');
MK1G3C30A = monitor('MK1G3C30A','IdentityPass');
MK3G4C30B = monitor('MK3G4C30B','IdentityPass');
MK2G5C30B = monitor('MK2G5C30B','IdentityPass');
MK5G1C01A = monitor('MK5G1C01A','IdentityPass');
MK1G3C01A = monitor('MK1G3C01A','IdentityPass');
MK3G4C01B = monitor('MK3G4C01B','IdentityPass');
MK2G5C01B = monitor('MK2G5C01B','IdentityPass');
PH1G2C30A = monitor('BPM','IdentityPass');
PH2G2C30A = monitor('BPM','IdentityPass');
PM1G4C30A = monitor('BPM','IdentityPass');
PM1G4C30B = monitor('BPM','IdentityPass');
PL2G6C30B = monitor('BPM','IdentityPass');
PL1G6C30B = monitor('BPM','IdentityPass');
PL1G2C01A = monitor('BPM','IdentityPass');
PL2G2C01A = monitor('BPM','IdentityPass');
PM1G4C01A = monitor('BPM','IdentityPass');
PM1G4C01B = monitor('BPM','IdentityPass');
PH2G6C01B = monitor('BPM','IdentityPass');
PH1G6C01B = monitor('BPM','IdentityPass');
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
GSG1C01A = monitor('GS','IdentityPass');
GEG1C01A = monitor('GE','IdentityPass');
GSG2C01A = monitor('GS','IdentityPass');
GEG2C01A = monitor('GE','IdentityPass');
GSG3C01A = monitor('GS','IdentityPass');
GEG3C01A = monitor('GE','IdentityPass');
GSG4C01A = monitor('GS','IdentityPass');
GEG4C01B = monitor('GE','IdentityPass');
GSG5C01B = monitor('GS','IdentityPass');
GEG5C01B = monitor('GE','IdentityPass');
GSG6C01B = monitor('GS','IdentityPass');
GEG6C01B = monitor('GE','IdentityPass');
GSG1C02A = monitor('GS','IdentityPass');
QH1G2C30A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C30A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C30A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C30A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C30A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C30A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C30B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C30B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C30B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C30B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C30B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C01A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C01A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C01A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C01A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C01A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C01A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C01B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C01B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C01B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C01B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C01B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C30A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C30B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C01A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C01B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C30A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C30A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C30A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C30A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C30B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C30B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C30B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C30B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C30B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C01A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C01A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C01A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C01A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C01B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C01B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C01B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C01B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C01B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C30A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C30A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C30A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C30B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C30B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C30B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C01A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C01A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C01A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C01B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C01B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C01B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C30=[MK4G1C30A,DH02G1A,DFT,FH2G1C30A,DFT,DH1G1A,GEG1C30A];

GIRDER2C30=[GSG2C30A,SH1G2C30A,DH1AG2A,PH1G2C30A,DBPM01,QH1G2C30A,...
 DH2AG2A,SQHHG2C30A,CH1XG2C30A,CH1YG2C30A,SQHHG2C30A,DH2BG2A,QH2G2C30A,DH3AG2A, ...
 SH3G2C30A,DH3BG2A,QH3G2C30A,DH4AG2A,PH2G2C30A,DBPM02,SH4G2C30A,DH4BG2A,DFCH, ...
 CH2XG2C30A,CH2YG2C30A,DFCH,GEG2C30A];
GIRDER3C30=[DH4CG3A,GSG3C30A,MK1G3C30A,B1G3C30A,GEG3C30A];

GIRDER4C30=[GSG4C30A,DM1AG4A,DSCH,CM1XG4C30A,CM1YG4C30A,DSCH,DM1BG4A,...
 QM1G4C30A,DM2AG4A,SM1G4C30A,DFT1,DFT,FM1G4C30A,DFT,DM2BG4A,PM1G4C30A,DBPM03, ...
 QM2G4C30A,DM2CG4A,SM2HG4C30B,DM2CG4B,QM2G4C30B,DM2BG4B, ...
 SM1G4C30B,DM2AG4B,PM1G4C30B,DBPM04,QM1G4C30B,DM1EG4B,DFCH,CM1YG4C30B, ...
 CM1XG4C30B,DFCH,GEG4C30B];
GIRDER5C30=[GSG5C30B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C30B,MK2G5C30B,...
 GEG5C30B];
GIRDER6C30=[DL4BG6B,GSG6C30B,DL4AG6B,QL3G6C30B,DBPM05,PL2G6C30B,DL3CG6B,...
 SL3G6C30B,DL3BG6B,DSCH,CL2YG6C30B,CL2XG6C30B,DSCH,DL3AG6B,QL2G6C30B,DL2CG6B, ...
 SL2G6C30B,DL2BG6B,DSCH,CL1YG6C30B,CL1XG6C30B,DSCH,DL2AG6B,QL1G6C30B,DL1AG6B, ...
 PL1G6C30B,DBPM06,SL1G6C30B,GEG6C30B];
GIRDER1C01=[GSG1C01A,DL0BG1A,DFT,FL1G1C01A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C01A,DL02G1A,DLDK,DFT2,DFT,FL2G1C01A,DFT,DL0AG1A,GEG1C01A];
GIRDER2C01=[GSG2C01A,SL1G2C01A,DL1AG2A,PL1G2C01A,DBPM07,QL1G2C01A,...
 DL2AG2A,DSCH,CL1XG2C01A,CL1YG2C01A,DSCH,DL2BG2A,SL2G2C01A,DL2CG2A,QL2G2C01A, ...
 DL3AG2A,DSCH,CL2XG2C01A,CL2YG2C01A,DSCH,DL3BG2A,SL3G2C01A,DL3CG2A,PL2G2C01A, ...
 DBPM08,QL3G2C01A,DL4AG2A,GEG2C01A];
GIRDER3C01=[DL4BG3A,GSG3C01A,MK1G3C01A,B1G3C01A,GEG3C01A];
GIRDER4C01=[GSG4C01A,DM1AG4A,SQMHG4C01A,CM1XG4C01A,CM1YG4C01A,...
 SQMHG4C01A,DM1BG4A,QM1G4C01A,DM2A2G4A,SM1G4C01A,DFT1,DFT,FM1G4C01A,DFT, ...
 DM2B2G4A,PM1G4C01A,DBPM09,QM2G4C01A,DM2CG4A,SM2HG4C01B,...
 DM2CG4B,QM2G4C01B,DM2B2G4B,SM1G4C01B,DM2A2G4B,PM1G4C01B,DBPM10,QM1G4C01B, ...
 DM1EG4B,DFCH,CM1YG4C01B,CM1XG4C01B,DFCH,GEG4C01B];
GIRDER5C01=[GSG5C01B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C01B,MK2G5C01B,...
 GEG5C01B];
GIRDER6C01=[DH4CG6B,GSG6C01B,DFCH,CH2YG6C01B,CH2XG6C01B,DFCH,DH4BG6B,...
 SH4G6C01B,DH4AG6B,PH2G6C01B,DBPM11,QH3G6C01B,DH3BG6B,SH3G6C01B,DH3AG6B, ...
 QH2G6C01B,DH2BG6B,DSCH,CH1YG6C01B,CH1XG6C01B,DSCH,DH2AG6B,QH1G6C01B,DH1AG6B, ...
 PH1G6C01B,DBPM12,SH1G6C01B,GEG6C01B];
GIRDER1C02H=[GSG1C02A,DH2G1A,DFT,FH1G1C02A,DFT,DH01G1A];
SPC30C01=[GIRDER1C30,GIRDER2C30,GIRDER3C30,GIRDER4C30,GIRDER5C30,...
 GIRDER6C30,GIRDER1C01,GIRDER2C01,GIRDER3C01,GIRDER4C01,GIRDER5C01,GIRDER6C01, ...
 GIRDER1C02H];
FH2G1C02A = monitor('FH2G1C02A','IdentityPass');
FM1G4C02A = monitor('FM1G4C02A','IdentityPass');
FL1G1C03A = monitor('FL1G1C03A','IdentityPass');
FL2G1C03A = monitor('FL2G1C03A','IdentityPass');
FM1G4C03A = monitor('FM1G4C03A','IdentityPass');
FH1G1C04A = monitor('FH1G1C04A','IdentityPass');
CH1XG2C02A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C02A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C02A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C02B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C02B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C02B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C03A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C03A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C03A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C03B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C03B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C03B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C02A = monitor('MK4G1C02A','IdentityPass');
MK1G3C02A = monitor('MK1G3C02A','IdentityPass');
MK3G4C02B = monitor('MK3G4C02B','IdentityPass');
MK2G5C02B = monitor('MK2G5C02B','IdentityPass');
MK5G1C03A = monitor('MK5G1C03A','IdentityPass');
MK1G3C03A = monitor('MK1G3C03A','IdentityPass');
MK3G4C03B = monitor('MK3G4C03B','IdentityPass');
MK2G5C03B = monitor('MK2G5C03B','IdentityPass');
PH1G2C02A = monitor('BPM','IdentityPass');
PH2G2C02A = monitor('BPM','IdentityPass');
PM1G4C02A = monitor('BPM','IdentityPass');
PM1G4C02B = monitor('BPM','IdentityPass');
PL2G6C02B = monitor('BPM','IdentityPass');
PL1G6C02B = monitor('BPM','IdentityPass');
PL1G2C03A = monitor('BPM','IdentityPass');
PL2G2C03A = monitor('BPM','IdentityPass');
PM1G4C03A = monitor('BPM','IdentityPass');
PM1G4C03B = monitor('BPM','IdentityPass');
PH2G6C03B = monitor('BPM','IdentityPass');
PH1G6C03B = monitor('BPM','IdentityPass');
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
GSG1C03A = monitor('GS','IdentityPass');
GEG1C03A = monitor('GE','IdentityPass');
GSG2C03A = monitor('GS','IdentityPass');
GEG2C03A = monitor('GE','IdentityPass');
GSG3C03A = monitor('GS','IdentityPass');
GEG3C03A = monitor('GE','IdentityPass');
GSG4C03A = monitor('GS','IdentityPass');
GEG4C03B = monitor('GE','IdentityPass');
GSG5C03B = monitor('GS','IdentityPass');
GEG5C03B = monitor('GE','IdentityPass');
GSG6C03B = monitor('GS','IdentityPass');
GEG6C03B = monitor('GE','IdentityPass');
GSG1C04A = monitor('GS','IdentityPass');
QH1G2C02A =quadrupole('QH1', 0.268, -0.641957314648408, 'StrMPoleSymplectic4Pass');
SQHHG2C02A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C02A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C02A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C02A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C02A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C02B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C02B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C02B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C02B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C02B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C03A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C03A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C03A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C03A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C03A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C03A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C03B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C03B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C03B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C03B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C03B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C02A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C02B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C03A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C03B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C02A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C02A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C02A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C02A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C02B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C02B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C02B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C02B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C02B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C03A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C03A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C03A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C03A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C03B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C03B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C03B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C03B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C03B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C02A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C02A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C02A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C02B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C02B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C02B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C03A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C03A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C03A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C03B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C03B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C03B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C02=[MK4G1C02A,DH02G1A,DFT,FH2G1C02A,DFT,DH1G1A,GEG1C02A];
GIRDER2C02=[GSG2C02A,SH1G2C02A,DH1AG2A,PH1G2C02A,DBPM01,QH1G2C02A,...
 DH2AG2A,SQHHG2C02A,CH1XG2C02A,CH1YG2C02A,SQHHG2C02A,DH2BG2A,QH2G2C02A,DH3AG2A, ...
 SH3G2C02A,DH3BG2A,QH3G2C02A,DH4AG2A,PH2G2C02A,DBPM02,SH4G2C02A,DH4BG2A,DFCH, ...
 CH2XG2C02A,CH2YG2C02A,DFCH,GEG2C02A];
GIRDER3C02=[DH4CG3A,GSG3C02A,MK1G3C02A,B1G3C02A,GEG3C02A];
GIRDER4C02=[GSG4C02A,DM1AG4A,DSCH,CM1XG4C02A,CM1YG4C02A,DSCH,DM1BG4A,...
 QM1G4C02A,DM2AG4A,SM1G4C02A,DFT1,DFT,FM1G4C02A,DFT,DM2BG4A,PM1G4C02A,DBPM03, ...
 QM2G4C02A,DM2CG4A,SM2HG4C02B,DM2CG4B,QM2G4C02B,DM2BG4B, ...
 SM1G4C02B,DM2AG4B,PM1G4C02B,DBPM04,QM1G4C02B,DM1EG4B,DFCH,CM1YG4C02B, ...
 CM1XG4C02B,DFCH,GEG4C02B];
GIRDER5C02=[GSG5C02B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C02B,MK2G5C02B,...
 GEG5C02B];
GIRDER6C02=[DL4BG6B,GSG6C02B,DL4AG6B,QL3G6C02B,DBPM05,PL2G6C02B,DL3CG6B,...
 SL3G6C02B,DL3BG6B,DSCH,CL2YG6C02B,CL2XG6C02B,DSCH,DL3AG6B,QL2G6C02B,DL2CG6B, ...
 SL2G6C02B,DL2BG6B,DSCH,CL1YG6C02B,CL1XG6C02B,DSCH,DL2AG6B,QL1G6C02B,DL1AG6B, ...
 PL1G6C02B,DBPM06,SL1G6C02B,GEG6C02B];
GIRDER1C03=[GSG1C03A,DL0BG1A,DFT,FL1G1C03A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C03A,DL02G1A,DLDK,DFT2,DFT,FL2G1C03A,DFT,DL0AG1A,GEG1C03A];
GIRDER2C03=[GSG2C03A,SL1G2C03A,DL1AG2A,PL1G2C03A,DBPM07,QL1G2C03A,...
 DL2AG2A,DSCH,CL1XG2C03A,CL1YG2C03A,DSCH,DL2BG2A,SL2G2C03A,DL2CG2A,QL2G2C03A, ...
 DL3AG2A,DSCH,CL2XG2C03A,CL2YG2C03A,DSCH,DL3BG2A,SL3G2C03A,DL3CG2A,PL2G2C03A, ...
 DBPM08,QL3G2C03A,DL4AG2A,GEG2C03A];
GIRDER3C03=[DL4BG3A,GSG3C03A,MK1G3C03A,B1G3C03A,GEG3C03A];
GIRDER4C03=[GSG4C03A,DM1AG4A,SQMHG4C03A,CM1XG4C03A,CM1YG4C03A,...
 SQMHG4C03A,DM1BG4A,QM1G4C03A,DM2A2G4A,SM1G4C03A,DFT1,DFT,FM1G4C03A,DFT, ...
 DM2B2G4A,PM1G4C03A,DBPM09,QM2G4C03A,DM2CG4A,SM2HG4C03B,...
 DM2CG4B,QM2G4C03B,DM2B2G4B,SM1G4C03B,DM2A2G4B,PM1G4C03B,DBPM10,QM1G4C03B, ...
 DM1EG4B,DFCH,CM1YG4C03B,CM1XG4C03B,DFCH,GEG4C03B];
GIRDER5C03=[GSG5C03B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C03B,MK2G5C03B,...
 GEG5C03B];
GIRDER6C03=[DH4CG6B,GSG6C03B,DFCH,CH2YG6C03B,CH2XG6C03B,DFCH,DH4BG6B,...
 SH4G6C03B,DH4AG6B,PH2G6C03B,DBPM11,QH3G6C03B,DH3BG6B,SH3G6C03B,DH3AG6B, ...
 QH2G6C03B,DH2BG6B,DSCH,CH1YG6C03B,CH1XG6C03B,DSCH,DH2AG6B,QH1G6C03B,DH1AG6B, ...
 PH1G6C03B,DBPM12,SH1G6C03B,GEG6C03B];
GIRDER1C04H=[GSG1C04A,DH2G1A,DFT,FH1G1C04A,DFT,DH01G1A];
SPC02C03=[GIRDER1C02,GIRDER2C02,GIRDER3C02,GIRDER4C02,GIRDER5C02,...
 GIRDER6C02,GIRDER1C03,GIRDER2C03,GIRDER3C03,GIRDER4C03,GIRDER5C03,GIRDER6C03, ...
 GIRDER1C04H];
FH2G1C04A = monitor('FH2G1C04A','IdentityPass');
FM1G4C04A = monitor('FM1G4C04A','IdentityPass');
FL1G1C05A = monitor('FL1G1C05A','IdentityPass');
FL2G1C05A = monitor('FL2G1C05A','IdentityPass');
FM1G4C05A = monitor('FM1G4C05A','IdentityPass');
FH1G1C06A = monitor('FH1G1C06A','IdentityPass');
CH1XG2C04A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C04A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C04A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C04B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C04B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C04B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C05A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C05A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C05A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C05B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C05B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C05B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C04A = monitor('MK4G1C04A','IdentityPass');
MK1G3C04A = monitor('MK1G3C04A','IdentityPass');
MK3G4C04B = monitor('MK3G4C04B','IdentityPass');
MK2G5C04B = monitor('MK2G5C04B','IdentityPass');
MK5G1C05A = monitor('MK5G1C05A','IdentityPass');
MK1G3C05A = monitor('MK1G3C05A','IdentityPass');
MK3G4C05B = monitor('MK3G4C05B','IdentityPass');
MK2G5C05B = monitor('MK2G5C05B','IdentityPass');
PH1G2C04A = monitor('BPM','IdentityPass');
PH2G2C04A = monitor('BPM','IdentityPass');
PM1G4C04A = monitor('BPM','IdentityPass');
PM1G4C04B = monitor('BPM','IdentityPass');
PL2G6C04B = monitor('BPM','IdentityPass');
PL1G6C04B = monitor('BPM','IdentityPass');
PL1G2C05A = monitor('BPM','IdentityPass');
PL2G2C05A = monitor('BPM','IdentityPass');
PM1G4C05A = monitor('BPM','IdentityPass');
PM1G4C05B = monitor('BPM','IdentityPass');
PH2G6C05B = monitor('BPM','IdentityPass');
PH1G6C05B = monitor('BPM','IdentityPass');
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
GSG1C05A = monitor('GS','IdentityPass');
GEG1C05A = monitor('GE','IdentityPass');
GSG2C05A = monitor('GS','IdentityPass');
GEG2C05A = monitor('GE','IdentityPass');
GSG3C05A = monitor('GS','IdentityPass');
GEG3C05A = monitor('GE','IdentityPass');
GSG4C05A = monitor('GS','IdentityPass');
GEG4C05B = monitor('GE','IdentityPass');
GSG5C05B = monitor('GS','IdentityPass');
GEG5C05B = monitor('GE','IdentityPass');
GSG6C05B = monitor('GS','IdentityPass');
GEG6C05B = monitor('GE','IdentityPass');
GSG1C06A = monitor('GS','IdentityPass');
QH1G2C04A=quadrupole('QH1', 0.268, -0.641957314648408, 'StrMPoleSymplectic4Pass');
SQHHG2C04A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C04A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C04A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C04A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C04A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C04B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C04B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C04B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C04B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C04B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C05A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C05A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C05A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C05A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C05A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C05A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C05B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C05B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C05B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C05B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C05B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C04A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C04B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C05A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C05B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C04A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C04A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C04A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C04A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C04B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C04B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C04B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C04B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C04B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C05A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C05A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C05A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C05A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C05B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C05B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C05B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C05B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C05B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C04A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C04A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C04A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C04B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C04B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C04B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C05A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C05A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C05A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C05B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C05B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C05B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C04=[MK4G1C04A,DH02G1A,DFT,FH2G1C04A,DFT,DH1G1A,GEG1C04A];
GIRDER2C04=[GSG2C04A,SH1G2C04A,DH1AG2A,PH1G2C04A,DBPM01,QH1G2C04A,...
 DH2AG2A,SQHHG2C04A,CH1XG2C04A,CH1YG2C04A,SQHHG2C04A,DH2BG2A,QH2G2C04A,DH3AG2A, ...
 SH3G2C04A,DH3BG2A,QH3G2C04A,DH4AG2A,PH2G2C04A,DBPM02,SH4G2C04A,DH4BG2A,DFCH, ...
 CH2XG2C04A,CH2YG2C04A,DFCH,GEG2C04A];
GIRDER3C04=[DH4CG3A,GSG3C04A,MK1G3C04A,B1G3C04A,GEG3C04A];
GIRDER4C04=[GSG4C04A,DM1AG4A,DSCH,CM1XG4C04A,CM1YG4C04A,DSCH,DM1BG4A,...
 QM1G4C04A,DM2AG4A,SM1G4C04A,DFT1,DFT,FM1G4C04A,DFT,DM2BG4A,PM1G4C04A,DBPM03, ...
 QM2G4C04A,DM2CG4A,SM2HG4C04B,DM2CG4B,QM2G4C04B,DM2BG4B, ...
 SM1G4C04B,DM2AG4B,PM1G4C04B,DBPM04,QM1G4C04B,DM1EG4B,DFCH,CM1YG4C04B, ...
 CM1XG4C04B,DFCH,GEG4C04B];
GIRDER5C04=[GSG5C04B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C04B,MK2G5C04B,...
 GEG5C04B];
GIRDER6C04=[DL4BG6B,GSG6C04B,DL4AG6B,QL3G6C04B,DBPM05,PL2G6C04B,DL3CG6B,...
 SL3G6C04B,DL3BG6B,DSCH,CL2YG6C04B,CL2XG6C04B,DSCH,DL3AG6B,QL2G6C04B,DL2CG6B, ...
 SL2G6C04B,DL2BG6B,DSCH,CL1YG6C04B,CL1XG6C04B,DSCH,DL2AG6B,QL1G6C04B,DL1AG6B, ...
 PL1G6C04B,DBPM06,SL1G6C04B,GEG6C04B];
GIRDER1C05=[GSG1C05A,DL0BG1A,DFT,FL1G1C05A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C05A,DL02G1A,DLDK,DFT2,DFT,FL2G1C05A,DFT,DL0AG1A,GEG1C05A];
GIRDER2C05=[GSG2C05A,SL1G2C05A,DL1AG2A,PL1G2C05A,DBPM07,QL1G2C05A,...
 DL2AG2A,DSCH,CL1XG2C05A,CL1YG2C05A,DSCH,DL2BG2A,SL2G2C05A,DL2CG2A,QL2G2C05A, ...
 DL3AG2A,DSCH,CL2XG2C05A,CL2YG2C05A,DSCH,DL3BG2A,SL3G2C05A,DL3CG2A,PL2G2C05A, ...
 DBPM08,QL3G2C05A,DL4AG2A,GEG2C05A];
GIRDER3C05=[DL4BG3A,GSG3C05A,MK1G3C05A,B1G3C05A,GEG3C05A];
GIRDER4C05=[GSG4C05A,DM1AG4A,SQMHG4C05A,CM1XG4C05A,CM1YG4C05A,...
 SQMHG4C05A,DM1BG4A,QM1G4C05A,DM2A2G4A,SM1G4C05A,DFT1,DFT,FM1G4C05A,DFT, ...
 DM2B2G4A,PM1G4C05A,DBPM09,QM2G4C05A,DM2CG4A,SM2HG4C05B, ...
 DM2CG4B,QM2G4C05B,DM2B2G4B,SM1G4C05B,DM2A2G4B,PM1G4C05B,DBPM10,QM1G4C05B, ...
 DM1EG4B,DFCH,CM1YG4C05B,CM1XG4C05B,DFCH,GEG4C05B];
GIRDER5C05=[GSG5C05B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C05B,MK2G5C05B,...
 GEG5C05B];
GIRDER6C05=[DH4CG6B,GSG6C05B,DFCH,CH2YG6C05B,CH2XG6C05B,DFCH,DH4BG6B,...
 SH4G6C05B,DH4AG6B,PH2G6C05B,DBPM11,QH3G6C05B,DH3BG6B,SH3G6C05B,DH3AG6B, ...
 QH2G6C05B,DH2BG6B,DSCH,CH1YG6C05B,CH1XG6C05B,DSCH,DH2AG6B,QH1G6C05B,DH1AG6B, ...
 PH1G6C05B,DBPM12,SH1G6C05B,GEG6C05B];
GIRDER1C06H=[GSG1C06A,DH2G1A,DFT,FH1G1C06A,DFT,DH01G1A];
SPC04C05=[GIRDER1C04,GIRDER2C04,GIRDER3C04,GIRDER4C04,GIRDER5C04,...
 GIRDER6C04,GIRDER1C05,GIRDER2C05,GIRDER3C05,GIRDER4C05,GIRDER5C05,GIRDER6C05, ...
 GIRDER1C06H];
FH2G1C06A = monitor('FH2G1C06A','IdentityPass');
FM1G4C06A = monitor('FM1G4C06A','IdentityPass');
FL1G1C07A = monitor('FL1G1C07A','IdentityPass');
FL2G1C07A = monitor('FL2G1C07A','IdentityPass');
FM1G4C07A = monitor('FM1G4C07A','IdentityPass');
FH1G1C08A = monitor('FH1G1C08A','IdentityPass');
CH1XG2C06A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C06A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C06A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C06B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C06B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C06B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C07A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C07A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C07A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C07B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C07B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C07B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C06A = monitor('MK4G1C06A','IdentityPass');
MK1G3C06A = monitor('MK1G3C06A','IdentityPass');
MK3G4C06B = monitor('MK3G4C06B','IdentityPass');
MK2G5C06B = monitor('MK2G5C06B','IdentityPass');
MK5G1C07A = monitor('MK5G1C07A','IdentityPass');
MK1G3C07A = monitor('MK1G3C07A','IdentityPass');
MK3G4C07B = monitor('MK3G4C07B','IdentityPass');
MK2G5C07B = monitor('MK2G5C07B','IdentityPass');
PH1G2C06A = monitor('BPM','IdentityPass');
PH2G2C06A = monitor('BPM','IdentityPass');
PM1G4C06A = monitor('BPM','IdentityPass');
PM1G4C06B = monitor('BPM','IdentityPass');
PL2G6C06B = monitor('BPM','IdentityPass');
PL1G6C06B = monitor('BPM','IdentityPass');
PL1G2C07A = monitor('BPM','IdentityPass');
PL2G2C07A = monitor('BPM','IdentityPass');
PM1G4C07A = monitor('BPM','IdentityPass');
PM1G4C07B = monitor('BPM','IdentityPass');
PH2G6C07B = monitor('BPM','IdentityPass');
PH1G6C07B = monitor('BPM','IdentityPass');
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
GSG1C07A = monitor('GS','IdentityPass');
GEG1C07A = monitor('GE','IdentityPass');
GSG2C07A = monitor('GS','IdentityPass');
GEG2C07A = monitor('GE','IdentityPass');
GSG3C07A = monitor('GS','IdentityPass');
GEG3C07A = monitor('GE','IdentityPass');
GSG4C07A = monitor('GS','IdentityPass');
GEG4C07B = monitor('GE','IdentityPass');
GSG5C07B = monitor('GS','IdentityPass');
GEG5C07B = monitor('GE','IdentityPass');
GSG6C07B = monitor('GS','IdentityPass');
GEG6C07B = monitor('GE','IdentityPass');
GSG1C08A = monitor('GS','IdentityPass');
QH1G2C06A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C06A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C06A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C06A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C06A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C06A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C06B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C06B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C06B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C06B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C06B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C07A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C07A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C07A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C07A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C07A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C07A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C07B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C07B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C07B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C07B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C07B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C06A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C06B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C07A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C07B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C06A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C06A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C06A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C06A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C06B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C06B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C06B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C06B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C06B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C07A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C07A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C07A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C07A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C07B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C07B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C07B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C07B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C07B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C06A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C06A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C06A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C06B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C06B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C06B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C07A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C07A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C07A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C07B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C07B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C07B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C06=[MK4G1C06A,DH02G1A,DFT,FH2G1C06A,DFT,DH1G1A,GEG1C06A];
GIRDER2C06=[GSG2C06A,SH1G2C06A,DH1AG2A,PH1G2C06A,DBPM01,QH1G2C06A,...
 DH2AG2A,SQHHG2C06A,CH1XG2C06A,CH1YG2C06A,SQHHG2C06A,DH2BG2A,QH2G2C06A,DH3AG2A, ...
 SH3G2C06A,DH3BG2A,QH3G2C06A,DH4AG2A,PH2G2C06A,DBPM02,SH4G2C06A,DH4BG2A,DFCH, ...
 CH2XG2C06A,CH2YG2C06A,DFCH,GEG2C06A];
GIRDER3C06=[DH4CG3A,GSG3C06A,MK1G3C06A,B1G3C06A,GEG3C06A];
GIRDER4C06=[GSG4C06A,DM1AG4A,DSCH,CM1XG4C06A,CM1YG4C06A,DSCH,DM1BG4A,...
 QM1G4C06A,DM2AG4A,SM1G4C06A,DFT1,DFT,FM1G4C06A,DFT,DM2BG4A,PM1G4C06A,DBPM03, ...
 QM2G4C06A,DM2CG4A,SM2HG4C06B,DM2CG4B,QM2G4C06B,DM2BG4B, ...
 SM1G4C06B,DM2AG4B,PM1G4C06B,DBPM04,QM1G4C06B,DM1EG4B,DFCH,CM1YG4C06B, ...
 CM1XG4C06B,DFCH,GEG4C06B];
GIRDER5C06=[GSG5C06B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C06B,MK2G5C06B,...
 GEG5C06B];
GIRDER6C06=[DL4BG6B,GSG6C06B,DL4AG6B,QL3G6C06B,DBPM05,PL2G6C06B,DL3CG6B,...
 SL3G6C06B,DL3BG6B,DSCH,CL2YG6C06B,CL2XG6C06B,DSCH,DL3AG6B,QL2G6C06B,DL2CG6B, ...
 SL2G6C06B,DL2BG6B,DSCH,CL1YG6C06B,CL1XG6C06B,DSCH,DL2AG6B,QL1G6C06B,DL1AG6B, ...
 PL1G6C06B,DBPM06,SL1G6C06B,GEG6C06B];
GIRDER1C07=[GSG1C07A,DL0BG1A,DFT,FL1G1C07A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C07A,DL02G1A,DLDK,DFT2,DFT,FL2G1C07A,DFT,DL0AG1A,GEG1C07A];
GIRDER2C07=[GSG2C07A,SL1G2C07A,DL1AG2A,PL1G2C07A,DBPM07,QL1G2C07A,...
 DL2AG2A,DSCH,CL1XG2C07A,CL1YG2C07A,DSCH,DL2BG2A,SL2G2C07A,DL2CG2A,QL2G2C07A, ...
 DL3AG2A,DSCH,CL2XG2C07A,CL2YG2C07A,DSCH,DL3BG2A,SL3G2C07A,DL3CG2A,PL2G2C07A, ...
 DBPM08,QL3G2C07A,DL4AG2A,GEG2C07A];
GIRDER3C07=[DL4BG3A,GSG3C07A,MK1G3C07A,B1G3C07A,GEG3C07A];
GIRDER4C07=[GSG4C07A,DM1AG4A,SQMHG4C07A,CM1XG4C07A,CM1YG4C07A,...
 SQMHG4C07A,DM1BG4A,QM1G4C07A,DM2A2G4A,SM1G4C07A,DFT1,DFT,FM1G4C07A,DFT, ...
 DM2B2G4A,PM1G4C07A,DBPM09,QM2G4C07A,DM2CG4A,SM2HG4C07B, ...
 DM2CG4B,QM2G4C07B,DM2B2G4B,SM1G4C07B,DM2A2G4B,PM1G4C07B,DBPM10,QM1G4C07B, ...
 DM1EG4B,DFCH,CM1YG4C07B,CM1XG4C07B,DFCH,GEG4C07B];
GIRDER5C07=[GSG5C07B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C07B,MK2G5C07B,...
 GEG5C07B];
GIRDER6C07=[DH4CG6B,GSG6C07B,DFCH,CH2YG6C07B,CH2XG6C07B,DFCH,DH4BG6B,...
 SH4G6C07B,DH4AG6B,PH2G6C07B,DBPM11,QH3G6C07B,DH3BG6B,SH3G6C07B,DH3AG6B, ...
 QH2G6C07B,DH2BG6B,DSCH,CH1YG6C07B,CH1XG6C07B,DSCH,DH2AG6B,QH1G6C07B,DH1AG6B, ...
 PH1G6C07B,DBPM12,SH1G6C07B,GEG6C07B];
GIRDER1C08H=[GSG1C08A,DH2G1A,DFT,FH1G1C08A,DFT,DH01G1A];
SPC06C07=[GIRDER1C06,GIRDER2C06,GIRDER3C06,GIRDER4C06,GIRDER5C06,...
 GIRDER6C06,GIRDER1C07,GIRDER2C07,GIRDER3C07,GIRDER4C07,GIRDER5C07,GIRDER6C07, ...
 GIRDER1C08H];
FH2G1C08A = monitor('FH2G1C08A','IdentityPass');
FM1G4C08A = monitor('FM1G4C08A','IdentityPass');
FL1G1C09A = monitor('FL1G1C09A','IdentityPass');
FL2G1C09A = monitor('FL2G1C09A','IdentityPass');
FM1G4C09A = monitor('FM1G4C09A','IdentityPass');
FH1G1C10A = monitor('FH1G1C10A','IdentityPass');
CH1XG2C08A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C08A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C08A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C08B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C08B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C08B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C09A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C09A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C09A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C09B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C09B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C09B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C08A = monitor('MK4G1C08A','IdentityPass');
MK1G3C08A = monitor('MK1G3C08A','IdentityPass');
MK3G4C08B = monitor('MK3G4C08B','IdentityPass');
MK2G5C08B = monitor('MK2G5C08B','IdentityPass');
MK5G1C09A = monitor('MK5G1C09A','IdentityPass');
MK1G3C09A = monitor('MK1G3C09A','IdentityPass');
MK3G4C09B = monitor('MK3G4C09B','IdentityPass');
MK2G5C09B = monitor('MK2G5C09B','IdentityPass');
PH1G2C08A = monitor('BPM','IdentityPass');
PH2G2C08A = monitor('BPM','IdentityPass');
PM1G4C08A = monitor('BPM','IdentityPass');
PM1G4C08B = monitor('BPM','IdentityPass');
PL2G6C08B = monitor('BPM','IdentityPass');
PL1G6C08B = monitor('BPM','IdentityPass');
PL1G2C09A = monitor('BPM','IdentityPass');
PL2G2C09A = monitor('BPM','IdentityPass');
PM1G4C09A = monitor('BPM','IdentityPass');
PM1G4C09B = monitor('BPM','IdentityPass');
PH2G6C09B = monitor('BPM','IdentityPass');
PH1G6C09B = monitor('BPM','IdentityPass');
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
GSG1C09A = monitor('GS','IdentityPass');
GEG1C09A = monitor('GE','IdentityPass');
GSG2C09A = monitor('GS','IdentityPass');
GEG2C09A = monitor('GE','IdentityPass');
GSG3C09A = monitor('GS','IdentityPass');
GEG3C09A = monitor('GE','IdentityPass');
GSG4C09A = monitor('GS','IdentityPass');
GEG4C09B = monitor('GE','IdentityPass');
GSG5C09B = monitor('GS','IdentityPass');
GEG5C09B = monitor('GE','IdentityPass');
GSG6C09B = monitor('GS','IdentityPass');
GEG6C09B = monitor('GE','IdentityPass');
GSG1C10A = monitor('GS','IdentityPass');
QH1G2C08A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C08A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C08A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C08A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C08A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C08A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C08B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C08B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C08B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C08B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C08B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C09A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C09A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C09A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C09A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C09A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C09A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C09B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C09B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C09B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C09B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C09B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C08A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C08B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C09A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C09B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C08A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C08A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C08A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C08A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C08B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C08B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C08B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C08B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C08B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C09A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C09A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C09A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C09A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C09B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C09B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C09B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C09B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C09B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C08A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C08A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C08A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C08B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C08B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C08B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C09A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C09A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C09A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C09B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C09B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C09B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C08=[MK4G1C08A,DH02G1A,DFT,FH2G1C08A,DFT,DH1G1A,GEG1C08A];
GIRDER2C08=[GSG2C08A,SH1G2C08A,DH1AG2A,PH1G2C08A,DBPM01,QH1G2C08A,...
 DH2AG2A,SQHHG2C08A,CH1XG2C08A,CH1YG2C08A,SQHHG2C08A,DH2BG2A,QH2G2C08A,DH3AG2A, ...
 SH3G2C08A,DH3BG2A,QH3G2C08A,DH4AG2A,PH2G2C08A,DBPM02,SH4G2C08A,DH4BG2A,DFCH, ...
 CH2XG2C08A,CH2YG2C08A,DFCH,GEG2C08A];
GIRDER3C08=[DH4CG3A,GSG3C08A,MK1G3C08A,B1G3C08A,GEG3C08A];
GIRDER4C08=[GSG4C08A,DM1AG4A,DSCH,CM1XG4C08A,CM1YG4C08A,DSCH,DM1BG4A,...
 QM1G4C08A,DM2AG4A,SM1G4C08A,DFT1,DFT,FM1G4C08A,DFT,DM2BG4A,PM1G4C08A,DBPM03, ...
 QM2G4C08A,DM2CG4A,SM2HG4C08B,DM2CG4B,QM2G4C08B,DM2BG4B, ...
 SM1G4C08B,DM2AG4B,PM1G4C08B,DBPM04,QM1G4C08B,DM1EG4B,DFCH,CM1YG4C08B, ...
 CM1XG4C08B,DFCH,GEG4C08B];
GIRDER5C08=[GSG5C08B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C08B,MK2G5C08B,...
 GEG5C08B];
GIRDER6C08=[DL4BG6B,GSG6C08B,DL4AG6B,QL3G6C08B,DBPM05,PL2G6C08B,DL3CG6B,...
 SL3G6C08B,DL3BG6B,DSCH,CL2YG6C08B,CL2XG6C08B,DSCH,DL3AG6B,QL2G6C08B,DL2CG6B, ...
 SL2G6C08B,DL2BG6B,DSCH,CL1YG6C08B,CL1XG6C08B,DSCH,DL2AG6B,QL1G6C08B,DL1AG6B, ...
 PL1G6C08B,DBPM06,SL1G6C08B,GEG6C08B];
GIRDER1C09=[GSG1C09A,DL0BG1A,DFT,FL1G1C09A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C09A,DL02G1A,DLDK,DFT2,DFT,FL2G1C09A,DFT,DL0AG1A,GEG1C09A];
GIRDER2C09=[GSG2C09A,SL1G2C09A,DL1AG2A,PL1G2C09A,DBPM07,QL1G2C09A,...
 DL2AG2A,DSCH,CL1XG2C09A,CL1YG2C09A,DSCH,DL2BG2A,SL2G2C09A,DL2CG2A,QL2G2C09A, ...
 DL3AG2A,DSCH,CL2XG2C09A,CL2YG2C09A,DSCH,DL3BG2A,SL3G2C09A,DL3CG2A,PL2G2C09A, ...
 DBPM08,QL3G2C09A,DL4AG2A,GEG2C09A];
GIRDER3C09=[DL4BG3A,GSG3C09A,MK1G3C09A,B1G3C09A,GEG3C09A];
GIRDER4C09=[GSG4C09A,DM1AG4A,SQMHG4C09A,CM1XG4C09A,CM1YG4C09A,...
 SQMHG4C09A,DM1BG4A,QM1G4C09A,DM2A2G4A,SM1G4C09A,DFT1,DFT,FM1G4C09A,DFT, ...
 DM2B2G4A,PM1G4C09A,DBPM09,QM2G4C09A,DM2CG4A,SM2HG4C09B, ...
 DM2CG4B,QM2G4C09B,DM2B2G4B,SM1G4C09B,DM2A2G4B,PM1G4C09B,DBPM10,QM1G4C09B, ...
 DM1EG4B,DFCH,CM1YG4C09B,CM1XG4C09B,DFCH,GEG4C09B];
GIRDER5C09=[GSG5C09B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C09B,MK2G5C09B,...
 GEG5C09B];
GIRDER6C09=[DH4CG6B,GSG6C09B,DFCH,CH2YG6C09B,CH2XG6C09B,DFCH,DH4BG6B,...
 SH4G6C09B,DH4AG6B,PH2G6C09B,DBPM11,QH3G6C09B,DH3BG6B,SH3G6C09B,DH3AG6B, ...
 QH2G6C09B,DH2BG6B,DSCH,CH1YG6C09B,CH1XG6C09B,DSCH,DH2AG6B,QH1G6C09B,DH1AG6B, ...
 PH1G6C09B,DBPM12,SH1G6C09B,GEG6C09B];
GIRDER1C10H=[GSG1C10A,DH2G1A,DFT,FH1G1C10A,DFT,DH01G1A];
SPC08C09=[GIRDER1C08,GIRDER2C08,GIRDER3C08,GIRDER4C08,GIRDER5C08,...
 GIRDER6C08,GIRDER1C09,GIRDER2C09,GIRDER3C09,GIRDER4C09,GIRDER5C09,GIRDER6C09, ...
 GIRDER1C10H];
FH2G1C10A = monitor('FH2G1C10A','IdentityPass');
FM1G4C10A = monitor('FM1G4C10A','IdentityPass');
FL1G1C11A = monitor('FL1G1C11A','IdentityPass');
FL2G1C11A = monitor('FL2G1C11A','IdentityPass');
FM1G4C11A = monitor('FM1G4C11A','IdentityPass');
FH1G1C12A = monitor('FH1G1C12A','IdentityPass');
CH1XG2C10A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C10A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C10A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C10B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C10B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C10B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C11A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C11A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C11A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C11B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C11B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C11B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C10A = monitor('MK4G1C10A','IdentityPass');
MK1G3C10A = monitor('MK1G3C10A','IdentityPass');
MK3G4C10B = monitor('MK3G4C10B','IdentityPass');
MK2G5C10B = monitor('MK2G5C10B','IdentityPass');
MK5G1C11A = monitor('MK5G1C11A','IdentityPass');
MK1G3C11A = monitor('MK1G3C11A','IdentityPass');
MK3G4C11B = monitor('MK3G4C11B','IdentityPass');
MK2G5C11B = monitor('MK2G5C11B','IdentityPass');
PH1G2C10A = monitor('BPM','IdentityPass');
PH2G2C10A = monitor('BPM','IdentityPass');
PM1G4C10A = monitor('BPM','IdentityPass');
PM1G4C10B = monitor('BPM','IdentityPass');
PL2G6C10B = monitor('BPM','IdentityPass');
PL1G6C10B = monitor('BPM','IdentityPass');
PL1G2C11A = monitor('BPM','IdentityPass');
PL2G2C11A = monitor('BPM','IdentityPass');
PM1G4C11A = monitor('BPM','IdentityPass');
PM1G4C11B = monitor('BPM','IdentityPass');
PH2G6C11B = monitor('BPM','IdentityPass');
PH1G6C11B = monitor('BPM','IdentityPass');
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
GSG1C11A = monitor('GS','IdentityPass');
GEG1C11A = monitor('GE','IdentityPass');
GSG2C11A = monitor('GS','IdentityPass');
GEG2C11A = monitor('GE','IdentityPass');
GSG3C11A = monitor('GS','IdentityPass');
GEG3C11A = monitor('GE','IdentityPass');
GSG4C11A = monitor('GS','IdentityPass');
GEG4C11B = monitor('GE','IdentityPass');
GSG5C11B = monitor('GS','IdentityPass');
GEG5C11B = monitor('GE','IdentityPass');
GSG6C11B = monitor('GS','IdentityPass');
GEG6C11B = monitor('GE','IdentityPass');
GSG1C12A = monitor('GS','IdentityPass');
QH1G2C10A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C10A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C10A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C10A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C10A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C10A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C10B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C10B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C10B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C10B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C10B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C11A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C11A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C11A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C11A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C11A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C11A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C11B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C11B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C11B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C11B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C11B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C10A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C10B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C11A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C11B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C10A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C10A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C10A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C10A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C10B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C10B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C10B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C10B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C10B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C11A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C11A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C11A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C11A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C11B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C11B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C11B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C11B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C11B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C10A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C10A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C10A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C10B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C10B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C10B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C11A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C11A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C11A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C11B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C11B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C11B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C10=[MK4G1C10A,DH02G1A,DFT,FH2G1C10A,DFT,DH1G1A,GEG1C10A];
GIRDER2C10=[GSG2C10A,SH1G2C10A,DH1AG2A,PH1G2C10A,DBPM01,QH1G2C10A,...
 DH2AG2A,SQHHG2C10A,CH1XG2C10A,CH1YG2C10A,SQHHG2C10A,DH2BG2A,QH2G2C10A,DH3AG2A, ...
 SH3G2C10A,DH3BG2A,QH3G2C10A,DH4AG2A,PH2G2C10A,DBPM02,SH4G2C10A,DH4BG2A,DFCH, ...
 CH2XG2C10A,CH2YG2C10A,DFCH,GEG2C10A];
GIRDER3C10=[DH4CG3A,GSG3C10A,MK1G3C10A,B1G3C10A,GEG3C10A];
GIRDER4C10=[GSG4C10A,DM1AG4A,DSCH,CM1XG4C10A,CM1YG4C10A,DSCH,DM1BG4A,...
 QM1G4C10A,DM2AG4A,SM1G4C10A,DFT1,DFT,FM1G4C10A,DFT,DM2BG4A,PM1G4C10A,DBPM03, ...
 QM2G4C10A,DM2CG4A,SM2HG4C10B,DM2CG4B,QM2G4C10B,DM2BG4B, ...
 SM1G4C10B,DM2AG4B,PM1G4C10B,DBPM04,QM1G4C10B,DM1EG4B,DFCH,CM1YG4C10B, ...
 CM1XG4C10B,DFCH,GEG4C10B];
GIRDER5C10=[GSG5C10B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C10B,MK2G5C10B,...
 GEG5C10B];
GIRDER6C10=[DL4BG6B,GSG6C10B,DL4AG6B,QL3G6C10B,DBPM05,PL2G6C10B,DL3CG6B,...
 SL3G6C10B,DL3BG6B,DSCH,CL2YG6C10B,CL2XG6C10B,DSCH,DL3AG6B,QL2G6C10B,DL2CG6B, ...
 SL2G6C10B,DL2BG6B,DSCH,CL1YG6C10B,CL1XG6C10B,DSCH,DL2AG6B,QL1G6C10B,DL1AG6B, ...
 PL1G6C10B,DBPM06,SL1G6C10B,GEG6C10B];
GIRDER1C11=[GSG1C11A,DL0BG1A,DFT,FL1G1C11A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C11A,DL02G1A,DLDK,DFT2,DFT,FL2G1C11A,DFT,DL0AG1A,GEG1C11A];
GIRDER2C11=[GSG2C11A,SL1G2C11A,DL1AG2A,PL1G2C11A,DBPM07,QL1G2C11A,...
 DL2AG2A,DSCH,CL1XG2C11A,CL1YG2C11A,DSCH,DL2BG2A,SL2G2C11A,DL2CG2A,QL2G2C11A, ...
 DL3AG2A,DSCH,CL2XG2C11A,CL2YG2C11A,DSCH,DL3BG2A,SL3G2C11A,DL3CG2A,PL2G2C11A, ...
 DBPM08,QL3G2C11A,DL4AG2A,GEG2C11A];
GIRDER3C11=[DL4BG3A,GSG3C11A,MK1G3C11A,B1G3C11A,GEG3C11A];
GIRDER4C11=[GSG4C11A,DM1AG4A,SQMHG4C11A,CM1XG4C11A,CM1YG4C11A,...
 SQMHG4C11A,DM1BG4A,QM1G4C11A,DM2A2G4A,SM1G4C11A,DFT1,DFT,FM1G4C11A,DFT, ...
 DM2B2G4A,PM1G4C11A,DBPM09,QM2G4C11A,DM2CG4A,SM2HG4C11B, ...
 DM2CG4B,QM2G4C11B,DM2B2G4B,SM1G4C11B,DM2A2G4B,PM1G4C11B,DBPM10,QM1G4C11B, ...
 DM1EG4B,DFCH,CM1YG4C11B,CM1XG4C11B,DFCH,GEG4C11B];
GIRDER5C11=[GSG5C11B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C11B,MK2G5C11B,...
 GEG5C11B];
GIRDER6C11=[DH4CG6B,GSG6C11B,DFCH,CH2YG6C11B,CH2XG6C11B,DFCH,DH4BG6B,...
 SH4G6C11B,DH4AG6B,PH2G6C11B,DBPM11,QH3G6C11B,DH3BG6B,SH3G6C11B,DH3AG6B, ...
 QH2G6C11B,DH2BG6B,DSCH,CH1YG6C11B,CH1XG6C11B,DSCH,DH2AG6B,QH1G6C11B,DH1AG6B, ...
 PH1G6C11B,DBPM12,SH1G6C11B,GEG6C11B];
GIRDER1C12H=[GSG1C12A,DH2G1A,DFT,FH1G1C12A,DFT,DH01G1A];
SPC10C11=[GIRDER1C10,GIRDER2C10,GIRDER3C10,GIRDER4C10,GIRDER5C10,...
 GIRDER6C10,GIRDER1C11,GIRDER2C11,GIRDER3C11,GIRDER4C11,GIRDER5C11,GIRDER6C11, ...
 GIRDER1C12H];
FH2G1C12A = monitor('FH2G1C12A','IdentityPass');
FM1G4C12A = monitor('FM1G4C12A','IdentityPass');
FL1G1C13A = monitor('FL1G1C13A','IdentityPass');
FL2G1C13A = monitor('FL2G1C13A','IdentityPass');
FM1G4C13A = monitor('FM1G4C13A','IdentityPass');
FH1G1C14A = monitor('FH1G1C14A','IdentityPass');
CH1XG2C12A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C12A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C12A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C12B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C12B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C12B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C13A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C13A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C13A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C13B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C13B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C13B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C12A = monitor('MK4G1C12A','IdentityPass');
MK1G3C12A = monitor('MK1G3C12A','IdentityPass');
MK3G4C12B = monitor('MK3G4C12B','IdentityPass');
MK2G5C12B = monitor('MK2G5C12B','IdentityPass');
MK5G1C13A = monitor('MK5G1C13A','IdentityPass');
MK1G3C13A = monitor('MK1G3C13A','IdentityPass');
MK3G4C13B = monitor('MK3G4C13B','IdentityPass');
MK2G5C13B = monitor('MK2G5C13B','IdentityPass');
PH1G2C12A = monitor('BPM','IdentityPass');
PH2G2C12A = monitor('BPM','IdentityPass');
PM1G4C12A = monitor('BPM','IdentityPass');
PM1G4C12B = monitor('BPM','IdentityPass');
PL2G6C12B = monitor('BPM','IdentityPass');
PL1G6C12B = monitor('BPM','IdentityPass');
PL1G2C13A = monitor('BPM','IdentityPass');
PL2G2C13A = monitor('BPM','IdentityPass');
PM1G4C13A = monitor('BPM','IdentityPass');
PM1G4C13B = monitor('BPM','IdentityPass');
PH2G6C13B = monitor('BPM','IdentityPass');
PH1G6C13B = monitor('BPM','IdentityPass');
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
GSG1C13A = monitor('GS','IdentityPass');
GEG1C13A = monitor('GE','IdentityPass');
GSG2C13A = monitor('GS','IdentityPass');
GEG2C13A = monitor('GE','IdentityPass');
GSG3C13A = monitor('GS','IdentityPass');
GEG3C13A = monitor('GE','IdentityPass');
GSG4C13A = monitor('GS','IdentityPass');
GEG4C13B = monitor('GE','IdentityPass');
GSG5C13B = monitor('GS','IdentityPass');
GEG5C13B = monitor('GE','IdentityPass');
GSG6C13B = monitor('GS','IdentityPass');
GEG6C13B = monitor('GE','IdentityPass');
GSG1C14A = monitor('GS','IdentityPass');
QH1G2C12A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C12A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C12A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C12A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C12A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C12A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C12B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C12B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C12B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C12B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C12B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C13A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C13A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C13A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C13A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C13A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C13A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C13B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C13B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C13B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C13B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C13B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C12A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C12B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C13A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C13B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C12A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C12A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C12A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C12A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C12B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C12B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C12B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C12B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C12B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C13A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C13A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C13A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C13A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C13B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C13B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C13B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C13B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C13B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C12A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C12A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C12A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C12B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C12B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C12B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C13A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C13A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C13A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C13B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C13B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C13B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C12=[MK4G1C12A,DH02G1A,DFT,FH2G1C12A,DFT,DH1G1A,GEG1C12A];
GIRDER2C12=[GSG2C12A,SH1G2C12A,DH1AG2A,PH1G2C12A,DBPM01,QH1G2C12A,...
 DH2AG2A,SQHHG2C12A,CH1XG2C12A,CH1YG2C12A,SQHHG2C12A,DH2BG2A,QH2G2C12A,DH3AG2A, ...
 SH3G2C12A,DH3BG2A,QH3G2C12A,DH4AG2A,PH2G2C12A,DBPM02,SH4G2C12A,DH4BG2A,DFCH, ...
 CH2XG2C12A,CH2YG2C12A,DFCH,GEG2C12A];
GIRDER3C12=[DH4CG3A,GSG3C12A,MK1G3C12A,B1G3C12A,GEG3C12A];
GIRDER4C12=[GSG4C12A,DM1AG4A,DSCH,CM1XG4C12A,CM1YG4C12A,DSCH,DM1BG4A,...
 QM1G4C12A,DM2AG4A,SM1G4C12A,DFT1,DFT,FM1G4C12A,DFT,DM2BG4A,PM1G4C12A,DBPM03, ...
 QM2G4C12A,DM2CG4A,SM2HG4C12B,DM2CG4B,QM2G4C12B,DM2BG4B, ...
 SM1G4C12B,DM2AG4B,PM1G4C12B,DBPM04,QM1G4C12B,DM1EG4B,DFCH,CM1YG4C12B, ...
 CM1XG4C12B,DFCH,GEG4C12B];
GIRDER5C12=[GSG5C12B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C12B,MK2G5C12B,...
 GEG5C12B];
GIRDER6C12=[DL4BG6B,GSG6C12B,DL4AG6B,QL3G6C12B,DBPM05,PL2G6C12B,DL3CG6B,...
 SL3G6C12B,DL3BG6B,DSCH,CL2YG6C12B,CL2XG6C12B,DSCH,DL3AG6B,QL2G6C12B,DL2CG6B, ...
 SL2G6C12B,DL2BG6B,DSCH,CL1YG6C12B,CL1XG6C12B,DSCH,DL2AG6B,QL1G6C12B,DL1AG6B, ...
 PL1G6C12B,DBPM06,SL1G6C12B,GEG6C12B];
GIRDER1C13=[GSG1C13A,DL0BG1A,DFT,FL1G1C13A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C13A,DL02G1A,DLDK,DFT2,DFT,FL2G1C13A,DFT,DL0AG1A,GEG1C13A];
GIRDER2C13=[GSG2C13A,SL1G2C13A,DL1AG2A,PL1G2C13A,DBPM07,QL1G2C13A,...
 DL2AG2A,DSCH,CL1XG2C13A,CL1YG2C13A,DSCH,DL2BG2A,SL2G2C13A,DL2CG2A,QL2G2C13A, ...
 DL3AG2A,DSCH,CL2XG2C13A,CL2YG2C13A,DSCH,DL3BG2A,SL3G2C13A,DL3CG2A,PL2G2C13A, ...
 DBPM08,QL3G2C13A,DL4AG2A,GEG2C13A];
GIRDER3C13=[DL4BG3A,GSG3C13A,MK1G3C13A,B1G3C13A,GEG3C13A];
GIRDER4C13=[GSG4C13A,DM1AG4A,SQMHG4C13A,CM1XG4C13A,CM1YG4C13A,...
 SQMHG4C13A,DM1BG4A,QM1G4C13A,DM2A2G4A,SM1G4C13A,DFT1,DFT,FM1G4C13A,DFT, ...
 DM2B2G4A,PM1G4C13A,DBPM09,QM2G4C13A,DM2CG4A,SM2HG4C13B, ...
 DM2CG4B,QM2G4C13B,DM2B2G4B,SM1G4C13B,DM2A2G4B,PM1G4C13B,DBPM10,QM1G4C13B, ...
 DM1EG4B,DFCH,CM1YG4C13B,CM1XG4C13B,DFCH,GEG4C13B];
GIRDER5C13=[GSG5C13B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C13B,MK2G5C13B,...
 GEG5C13B];
GIRDER6C13=[DH4CG6B,GSG6C13B,DFCH,CH2YG6C13B,CH2XG6C13B,DFCH,DH4BG6B,...
 SH4G6C13B,DH4AG6B,PH2G6C13B,DBPM11,QH3G6C13B,DH3BG6B,SH3G6C13B,DH3AG6B, ...
 QH2G6C13B,DH2BG6B,DSCH,CH1YG6C13B,CH1XG6C13B,DSCH,DH2AG6B,QH1G6C13B,DH1AG6B, ...
 PH1G6C13B,DBPM12,SH1G6C13B,GEG6C13B];
GIRDER1C14H=[GSG1C14A,DH2G1A,DFT,FH1G1C14A,DFT,DH01G1A];
SPC12C13=[GIRDER1C12,GIRDER2C12,GIRDER3C12,GIRDER4C12,GIRDER5C12,...
 GIRDER6C12,GIRDER1C13,GIRDER2C13,GIRDER3C13,GIRDER4C13,GIRDER5C13,GIRDER6C13, ...
 GIRDER1C14H];
FH2G1C14A = monitor('FH2G1C14A','IdentityPass');
FM1G4C14A = monitor('FM1G4C14A','IdentityPass');
FL1G1C15A = monitor('FL1G1C15A','IdentityPass');
FL2G1C15A = monitor('FL2G1C15A','IdentityPass');
FM1G4C15A = monitor('FM1G4C15A','IdentityPass');
FH1G1C16A = monitor('FH1G1C16A','IdentityPass');
CH1XG2C14A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C14A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C14A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C14B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C14B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C14B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C15A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C15A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C15A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C15B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C15B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C15B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C14A = monitor('MK4G1C14A','IdentityPass');
MK1G3C14A = monitor('MK1G3C14A','IdentityPass');
MK3G4C14B = monitor('MK3G4C14B','IdentityPass');
MK2G5C14B = monitor('MK2G5C14B','IdentityPass');
MK5G1C15A = monitor('MK5G1C15A','IdentityPass');
MK1G3C15A = monitor('MK1G3C15A','IdentityPass');
MK3G4C15B = monitor('MK3G4C15B','IdentityPass');
MK2G5C15B = monitor('MK2G5C15B','IdentityPass');
PH1G2C14A = monitor('BPM','IdentityPass');
PH2G2C14A = monitor('BPM','IdentityPass');
PM1G4C14A = monitor('BPM','IdentityPass');
PM1G4C14B = monitor('BPM','IdentityPass');
PL2G6C14B = monitor('BPM','IdentityPass');
PL1G6C14B = monitor('BPM','IdentityPass');
PL1G2C15A = monitor('BPM','IdentityPass');
PL2G2C15A = monitor('BPM','IdentityPass');
PM1G4C15A = monitor('BPM','IdentityPass');
PM1G4C15B = monitor('BPM','IdentityPass');
PH2G6C15B = monitor('BPM','IdentityPass');
PH1G6C15B = monitor('BPM','IdentityPass');
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
GSG1C15A = monitor('GS','IdentityPass');
GEG1C15A = monitor('GE','IdentityPass');
GSG2C15A = monitor('GS','IdentityPass');
GEG2C15A = monitor('GE','IdentityPass');
GSG3C15A = monitor('GS','IdentityPass');
GEG3C15A = monitor('GE','IdentityPass');
GSG4C15A = monitor('GS','IdentityPass');
GEG4C15B = monitor('GE','IdentityPass');
GSG5C15B = monitor('GS','IdentityPass');
GEG5C15B = monitor('GE','IdentityPass');
GSG6C15B = monitor('GS','IdentityPass');
GEG6C15B = monitor('GE','IdentityPass');
GSG1C16A = monitor('GS','IdentityPass');
QH1G2C14A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C14A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C14A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C14A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C14A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C14A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C14B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C14B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C14B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C14B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C14B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C15A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C15A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C15A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C15A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C15A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C15A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C15B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C15B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C15B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C15B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C15B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C14A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C14B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C15A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C15B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C14A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C14A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C14A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C14A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C14B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C14B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C14B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C14B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C14B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C15A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C15A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C15A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C15A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C15B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C15B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C15B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C15B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C15B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C14A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C14A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C14A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C14B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C14B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C14B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C15A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C15A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C15A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C15B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C15B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C15B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C14=[MK4G1C14A,DH02G1A,DFT,FH2G1C14A,DFT,DH1G1A,GEG1C14A];
GIRDER2C14=[GSG2C14A,SH1G2C14A,DH1AG2A,PH1G2C14A,DBPM01,QH1G2C14A,...
 DH2AG2A,SQHHG2C14A,CH1XG2C14A,CH1YG2C14A,SQHHG2C14A,DH2BG2A,QH2G2C14A,DH3AG2A, ...
 SH3G2C14A,DH3BG2A,QH3G2C14A,DH4AG2A,PH2G2C14A,DBPM02,SH4G2C14A,DH4BG2A,DFCH, ...
 CH2XG2C14A,CH2YG2C14A,DFCH,GEG2C14A];
GIRDER3C14=[DH4CG3A,GSG3C14A,MK1G3C14A,B1G3C14A,GEG3C14A];
GIRDER4C14=[GSG4C14A,DM1AG4A,DSCH,CM1XG4C14A,CM1YG4C14A,DSCH,DM1BG4A,...
 QM1G4C14A,DM2AG4A,SM1G4C14A,DFT1,DFT,FM1G4C14A,DFT,DM2BG4A,PM1G4C14A,DBPM03, ...
 QM2G4C14A,DM2CG4A,SM2HG4C14B,DM2CG4B,QM2G4C14B,DM2BG4B, ...
 SM1G4C14B,DM2AG4B,PM1G4C14B,DBPM04,QM1G4C14B,DM1EG4B,DFCH,CM1YG4C14B, ...
 CM1XG4C14B,DFCH,GEG4C14B];
GIRDER5C14=[GSG5C14B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C14B,MK2G5C14B,...
 GEG5C14B];
GIRDER6C14=[DL4BG6B,GSG6C14B,DL4AG6B,QL3G6C14B,DBPM05,PL2G6C14B,DL3CG6B,...
 SL3G6C14B,DL3BG6B,DSCH,CL2YG6C14B,CL2XG6C14B,DSCH,DL3AG6B,QL2G6C14B,DL2CG6B, ...
 SL2G6C14B,DL2BG6B,DSCH,CL1YG6C14B,CL1XG6C14B,DSCH,DL2AG6B,QL1G6C14B,DL1AG6B, ...
 PL1G6C14B,DBPM06,SL1G6C14B,GEG6C14B];
GIRDER1C15=[GSG1C15A,DL0BG1A,DFT,FL1G1C15A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C15A,DL02G1A,DLDK,DFT2,DFT,FL2G1C15A,DFT,DL0AG1A,GEG1C15A];
GIRDER2C15=[GSG2C15A,SL1G2C15A,DL1AG2A,PL1G2C15A,DBPM07,QL1G2C15A,...
 DL2AG2A,DSCH,CL1XG2C15A,CL1YG2C15A,DSCH,DL2BG2A,SL2G2C15A,DL2CG2A,QL2G2C15A, ...
 DL3AG2A,DSCH,CL2XG2C15A,CL2YG2C15A,DSCH,DL3BG2A,SL3G2C15A,DL3CG2A,PL2G2C15A, ...
 DBPM08,QL3G2C15A,DL4AG2A,GEG2C15A];
GIRDER3C15=[DL4BG3A,GSG3C15A,MK1G3C15A,B1G3C15A,GEG3C15A];
GIRDER4C15=[GSG4C15A,DM1AG4A,SQMHG4C15A,CM1XG4C15A,CM1YG4C15A,...
 SQMHG4C15A,DM1BG4A,QM1G4C15A,DM2A2G4A,SM1G4C15A,DFT1,DFT,FM1G4C15A,DFT, ...
 DM2B2G4A,PM1G4C15A,DBPM09,QM2G4C15A,DM2CG4A,SM2HG4C15B, ...
 DM2CG4B,QM2G4C15B,DM2B2G4B,SM1G4C15B,DM2A2G4B,PM1G4C15B,DBPM10,QM1G4C15B, ...
 DM1EG4B,DFCH,CM1YG4C15B,CM1XG4C15B,DFCH,GEG4C15B];
GIRDER5C15=[GSG5C15B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C15B,MK2G5C15B,...
 GEG5C15B];
GIRDER6C15=[DH4CG6B,GSG6C15B,DFCH,CH2YG6C15B,CH2XG6C15B,DFCH,DH4BG6B,...
 SH4G6C15B,DH4AG6B,PH2G6C15B,DBPM11,QH3G6C15B,DH3BG6B,SH3G6C15B,DH3AG6B, ...
 QH2G6C15B,DH2BG6B,DSCH,CH1YG6C15B,CH1XG6C15B,DSCH,DH2AG6B,QH1G6C15B,DH1AG6B, ...
 PH1G6C15B,DBPM12,SH1G6C15B,GEG6C15B];
GIRDER1C16H=[GSG1C16A,DH2G1A,DFT,FH1G1C16A,DFT,DH01G1A];
SPC14C15=[GIRDER1C14,GIRDER2C14,GIRDER3C14,GIRDER4C14,GIRDER5C14,...
 GIRDER6C14,GIRDER1C15,GIRDER2C15,GIRDER3C15,GIRDER4C15,GIRDER5C15,GIRDER6C15, ...
 GIRDER1C16H];
FH2G1C16A = monitor('FH2G1C16A','IdentityPass');
FM1G4C16A = monitor('FM1G4C16A','IdentityPass');
FL1G1C17A = monitor('FL1G1C17A','IdentityPass');
FL2G1C17A = monitor('FL2G1C17A','IdentityPass');
FM1G4C17A = monitor('FM1G4C17A','IdentityPass');
FH1G1C18A = monitor('FH1G1C18A','IdentityPass');
CH1XG2C16A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C16A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C16A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C16B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C16B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C16B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C17A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C17A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C17A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C17B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C17B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C17B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C16A = monitor('MK4G1C16A','IdentityPass');
MK1G3C16A = monitor('MK1G3C16A','IdentityPass');
MK3G4C16B = monitor('MK3G4C16B','IdentityPass');
MK2G5C16B = monitor('MK2G5C16B','IdentityPass');
MK5G1C17A = monitor('MK5G1C17A','IdentityPass');
MK1G3C17A = monitor('MK1G3C17A','IdentityPass');
MK3G4C17B = monitor('MK3G4C17B','IdentityPass');
MK2G5C17B = monitor('MK2G5C17B','IdentityPass');
PH1G2C16A = monitor('BPM','IdentityPass');
PH2G2C16A = monitor('BPM','IdentityPass');
PM1G4C16A = monitor('BPM','IdentityPass');
PM1G4C16B = monitor('BPM','IdentityPass');
PL2G6C16B = monitor('BPM','IdentityPass');
PL1G6C16B = monitor('BPM','IdentityPass');
PL1G2C17A = monitor('BPM','IdentityPass');
PL2G2C17A = monitor('BPM','IdentityPass');
PM1G4C17A = monitor('BPM','IdentityPass');
PM1G4C17B = monitor('BPM','IdentityPass');
PH2G6C17B = monitor('BPM','IdentityPass');
PH1G6C17B = monitor('BPM','IdentityPass');
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
GSG1C17A = monitor('GS','IdentityPass');
GEG1C17A = monitor('GE','IdentityPass');
GSG2C17A = monitor('GS','IdentityPass');
GEG2C17A = monitor('GE','IdentityPass');
GSG3C17A = monitor('GS','IdentityPass');
GEG3C17A = monitor('GE','IdentityPass');
GSG4C17A = monitor('GS','IdentityPass');
GEG4C17B = monitor('GE','IdentityPass');
GSG5C17B = monitor('GS','IdentityPass');
GEG5C17B = monitor('GE','IdentityPass');
GSG6C17B = monitor('GS','IdentityPass');
GEG6C17B = monitor('GE','IdentityPass');
GSG1C18A = monitor('GS','IdentityPass');
QH1G2C16A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C16A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C16A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C16A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C16A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C16A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C16B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C16B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C16B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C16B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C16B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C17A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C17A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C17A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C17A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C17A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C17A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C17B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C17B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C17B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C17B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C17B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C16A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C16B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C17A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C17B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C16A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C16A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C16A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C16A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C16B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C16B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C16B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C16B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C16B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C17A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C17A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C17A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C17A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C17B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C17B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C17B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C17B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C17B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C16A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C16A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C16A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C16B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C16B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C16B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C17A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C17A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C17A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C17B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C17B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C17B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C16=[MK4G1C16A,DH02G1A,DFT,FH2G1C16A,DFT,DH1G1A,GEG1C16A];
GIRDER2C16=[GSG2C16A,SH1G2C16A,DH1AG2A,PH1G2C16A,DBPM01,QH1G2C16A,...
 DH2AG2A,SQHHG2C16A,CH1XG2C16A,CH1YG2C16A,SQHHG2C16A,DH2BG2A,QH2G2C16A,DH3AG2A, ...
 SH3G2C16A,DH3BG2A,QH3G2C16A,DH4AG2A,PH2G2C16A,DBPM02,SH4G2C16A,DH4BG2A,DFCH, ...
 CH2XG2C16A,CH2YG2C16A,DFCH,GEG2C16A];
GIRDER3C16=[DH4CG3A,GSG3C16A,MK1G3C16A,B1G3C16A,GEG3C16A];
GIRDER4C16=[GSG4C16A,DM1AG4A,DSCH,CM1XG4C16A,CM1YG4C16A,DSCH,DM1BG4A,...
 QM1G4C16A,DM2AG4A,SM1G4C16A,DFT1,DFT,FM1G4C16A,DFT,DM2BG4A,PM1G4C16A,DBPM03, ...
 QM2G4C16A,DM2CG4A,SM2HG4C16B,DM2CG4B,QM2G4C16B,DM2BG4B, ...
 SM1G4C16B,DM2AG4B,PM1G4C16B,DBPM04,QM1G4C16B,DM1EG4B,DFCH,CM1YG4C16B, ...
 CM1XG4C16B,DFCH,GEG4C16B];
GIRDER5C16=[GSG5C16B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C16B,MK2G5C16B,...
 GEG5C16B];
GIRDER6C16=[DL4BG6B,GSG6C16B,DL4AG6B,QL3G6C16B,DBPM05,PL2G6C16B,DL3CG6B,...
 SL3G6C16B,DL3BG6B,DSCH,CL2YG6C16B,CL2XG6C16B,DSCH,DL3AG6B,QL2G6C16B,DL2CG6B, ...
 SL2G6C16B,DL2BG6B,DSCH,CL1YG6C16B,CL1XG6C16B,DSCH,DL2AG6B,QL1G6C16B,DL1AG6B, ...
 PL1G6C16B,DBPM06,SL1G6C16B,GEG6C16B];
GIRDER1C17=[GSG1C17A,DL0BG1A,DFT,FL1G1C17A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C17A,DL02G1A,DLDK,DFT2,DFT,FL2G1C17A,DFT,DL0AG1A,GEG1C17A];
GIRDER2C17=[GSG2C17A,SL1G2C17A,DL1AG2A,PL1G2C17A,DBPM07,QL1G2C17A,...
 DL2AG2A,DSCH,CL1XG2C17A,CL1YG2C17A,DSCH,DL2BG2A,SL2G2C17A,DL2CG2A,QL2G2C17A, ...
 DL3AG2A,DSCH,CL2XG2C17A,CL2YG2C17A,DSCH,DL3BG2A,SL3G2C17A,DL3CG2A,PL2G2C17A, ...
 DBPM08,QL3G2C17A,DL4AG2A,GEG2C17A];
GIRDER3C17=[DL4BG3A,GSG3C17A,MK1G3C17A,B1G3C17A,GEG3C17A];
GIRDER4C17=[GSG4C17A,DM1AG4A,SQMHG4C17A,CM1XG4C17A,CM1YG4C17A,...
 SQMHG4C17A,DM1BG4A,QM1G4C17A,DM2A2G4A,SM1G4C17A,DFT1,DFT,FM1G4C17A,DFT, ...
 DM2B2G4A,PM1G4C17A,DBPM09,QM2G4C17A,DM2CG4A,SM2HG4C17B, ...
 DM2CG4B,QM2G4C17B,DM2B2G4B,SM1G4C17B,DM2A2G4B,PM1G4C17B,DBPM10,QM1G4C17B, ...
 DM1EG4B,DFCH,CM1YG4C17B,CM1XG4C17B,DFCH,GEG4C17B];
GIRDER5C17=[GSG5C17B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C17B,MK2G5C17B,...
 GEG5C17B];
GIRDER6C17=[DH4CG6B,GSG6C17B,DFCH,CH2YG6C17B,CH2XG6C17B,DFCH,DH4BG6B,...
 SH4G6C17B,DH4AG6B,PH2G6C17B,DBPM11,QH3G6C17B,DH3BG6B,SH3G6C17B,DH3AG6B, ...
 QH2G6C17B,DH2BG6B,DSCH,CH1YG6C17B,CH1XG6C17B,DSCH,DH2AG6B,QH1G6C17B,DH1AG6B, ...
 PH1G6C17B,DBPM12,SH1G6C17B,GEG6C17B];
GIRDER1C18H=[GSG1C18A,DH2G1A,DFT,FH1G1C18A,DFT,DH01G1A];
SPC16C17=[GIRDER1C16,GIRDER2C16,GIRDER3C16,GIRDER4C16,GIRDER5C16,...
 GIRDER6C16,GIRDER1C17,GIRDER2C17,GIRDER3C17,GIRDER4C17,GIRDER5C17,GIRDER6C17, ...
 GIRDER1C18H];
FH2G1C18A = monitor('FH2G1C18A','IdentityPass');
FM1G4C18A = monitor('FM1G4C18A','IdentityPass');
FL1G1C19A = monitor('FL1G1C19A','IdentityPass');
FL2G1C19A = monitor('FL2G1C19A','IdentityPass');
FM1G4C19A = monitor('FM1G4C19A','IdentityPass');
FH1G1C20A = monitor('FH1G1C20A','IdentityPass');
CH1XG2C18A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C18A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C18A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C18B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C18B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C18B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C19A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C19A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C19A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C19B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C19B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C19B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C18A = monitor('MK4G1C18A','IdentityPass');
MK1G3C18A = monitor('MK1G3C18A','IdentityPass');
MK3G4C18B = monitor('MK3G4C18B','IdentityPass');
MK2G5C18B = monitor('MK2G5C18B','IdentityPass');
MK5G1C19A = monitor('MK5G1C19A','IdentityPass');
MK1G3C19A = monitor('MK1G3C19A','IdentityPass');
MK3G4C19B = monitor('MK3G4C19B','IdentityPass');
MK2G5C19B = monitor('MK2G5C19B','IdentityPass');
PH1G2C18A = monitor('BPM','IdentityPass');
PH2G2C18A = monitor('BPM','IdentityPass');
PM1G4C18A = monitor('BPM','IdentityPass');
PM1G4C18B = monitor('BPM','IdentityPass');
PL2G6C18B = monitor('BPM','IdentityPass');
PL1G6C18B = monitor('BPM','IdentityPass');
PL1G2C19A = monitor('BPM','IdentityPass');
PL2G2C19A = monitor('BPM','IdentityPass');
PM1G4C19A = monitor('BPM','IdentityPass');
PM1G4C19B = monitor('BPM','IdentityPass');
PH2G6C19B = monitor('BPM','IdentityPass');
PH1G6C19B = monitor('BPM','IdentityPass');
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
GSG1C19A = monitor('GS','IdentityPass');
GEG1C19A = monitor('GE','IdentityPass');
GSG2C19A = monitor('GS','IdentityPass');
GEG2C19A = monitor('GE','IdentityPass');
GSG3C19A = monitor('GS','IdentityPass');
GEG3C19A = monitor('GE','IdentityPass');
GSG4C19A = monitor('GS','IdentityPass');
GEG4C19B = monitor('GE','IdentityPass');
GSG5C19B = monitor('GS','IdentityPass');
GEG5C19B = monitor('GE','IdentityPass');
GSG6C19B = monitor('GS','IdentityPass');
GEG6C19B = monitor('GE','IdentityPass');
GSG1C20A = monitor('GS','IdentityPass');
QH1G2C18A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C18A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C18A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C18A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C18A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C18A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C18B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C18B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C18B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C18B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C18B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C19A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C19A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C19A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C19A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C19A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C19A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C19B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C19B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C19B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C19B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C19B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C18A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C18B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C19A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C19B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C18A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C18A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C18A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C18A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C18B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C18B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C18B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C18B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C18B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C19A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C19A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C19A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C19A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C19B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C19B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C19B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C19B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C19B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C18A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C18A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C18A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C18B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C18B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C18B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C19A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C19A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C19A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C19B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C19B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C19B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C18=[MK4G1C18A,DH02G1A,DFT,FH2G1C18A,DFT,DH1G1A,GEG1C18A];
GIRDER2C18=[GSG2C18A,SH1G2C18A,DH1AG2A,PH1G2C18A,DBPM01,QH1G2C18A,...
 DH2AG2A,SQHHG2C18A,CH1XG2C18A,CH1YG2C18A,SQHHG2C18A,DH2BG2A,QH2G2C18A,DH3AG2A, ...
 SH3G2C18A,DH3BG2A,QH3G2C18A,DH4AG2A,PH2G2C18A,DBPM02,SH4G2C18A,DH4BG2A,DFCH, ...
 CH2XG2C18A,CH2YG2C18A,DFCH,GEG2C18A];
GIRDER3C18=[DH4CG3A,GSG3C18A,MK1G3C18A,B1G3C18A,GEG3C18A];
GIRDER4C18=[GSG4C18A,DM1AG4A,DSCH,CM1XG4C18A,CM1YG4C18A,DSCH,DM1BG4A,...
 QM1G4C18A,DM2AG4A,SM1G4C18A,DFT1,DFT,FM1G4C18A,DFT,DM2BG4A,PM1G4C18A,DBPM03, ...
 QM2G4C18A,DM2CG4A,SM2HG4C18B,DM2CG4B,QM2G4C18B,DM2BG4B, ...
 SM1G4C18B,DM2AG4B,PM1G4C18B,DBPM04,QM1G4C18B,DM1EG4B,DFCH,CM1YG4C18B, ...
 CM1XG4C18B,DFCH,GEG4C18B];
GIRDER5C18=[GSG5C18B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C18B,MK2G5C18B,...
 GEG5C18B];
GIRDER6C18=[DL4BG6B,GSG6C18B,DL4AG6B,QL3G6C18B,DBPM05,PL2G6C18B,DL3CG6B,...
 SL3G6C18B,DL3BG6B,DSCH,CL2YG6C18B,CL2XG6C18B,DSCH,DL3AG6B,QL2G6C18B,DL2CG6B, ...
 SL2G6C18B,DL2BG6B,DSCH,CL1YG6C18B,CL1XG6C18B,DSCH,DL2AG6B,QL1G6C18B,DL1AG6B, ...
 PL1G6C18B,DBPM06,SL1G6C18B,GEG6C18B];
GIRDER1C19=[GSG1C19A,DL0BG1A,DFT,FL1G1C19A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C19A,DL02G1A,DLDK,DFT2,DFT,FL2G1C19A,DFT,DL0AG1A,GEG1C19A];
GIRDER2C19=[GSG2C19A,SL1G2C19A,DL1AG2A,PL1G2C19A,DBPM07,QL1G2C19A,...
 DL2AG2A,DSCH,CL1XG2C19A,CL1YG2C19A,DSCH,DL2BG2A,SL2G2C19A,DL2CG2A,QL2G2C19A, ...
 DL3AG2A,DSCH,CL2XG2C19A,CL2YG2C19A,DSCH,DL3BG2A,SL3G2C19A,DL3CG2A,PL2G2C19A, ...
 DBPM08,QL3G2C19A,DL4AG2A,GEG2C19A];
GIRDER3C19=[DL4BG3A,GSG3C19A,MK1G3C19A,B1G3C19A,GEG3C19A];
GIRDER4C19=[GSG4C19A,DM1AG4A,SQMHG4C19A,CM1XG4C19A,CM1YG4C19A,...
 SQMHG4C19A,DM1BG4A,QM1G4C19A,DM2A2G4A,SM1G4C19A,DFT1,DFT,FM1G4C19A,DFT, ...
 DM2B2G4A,PM1G4C19A,DBPM09,QM2G4C19A,DM2CG4A,SM2HG4C19B, ...
 DM2CG4B,QM2G4C19B,DM2B2G4B,SM1G4C19B,DM2A2G4B,PM1G4C19B,DBPM10,QM1G4C19B, ...
 DM1EG4B,DFCH,CM1YG4C19B,CM1XG4C19B,DFCH,GEG4C19B];
GIRDER5C19=[GSG5C19B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C19B,MK2G5C19B,...
 GEG5C19B];
GIRDER6C19=[DH4CG6B,GSG6C19B,DFCH,CH2YG6C19B,CH2XG6C19B,DFCH,DH4BG6B,...
 SH4G6C19B,DH4AG6B,PH2G6C19B,DBPM11,QH3G6C19B,DH3BG6B,SH3G6C19B,DH3AG6B, ...
 QH2G6C19B,DH2BG6B,DSCH,CH1YG6C19B,CH1XG6C19B,DSCH,DH2AG6B,QH1G6C19B,DH1AG6B, ...
 PH1G6C19B,DBPM12,SH1G6C19B,GEG6C19B];
GIRDER1C20H=[GSG1C20A,DH2G1A,DFT,FH1G1C20A,DFT,DH01G1A];
SPC18C19=[GIRDER1C18,GIRDER2C18,GIRDER3C18,GIRDER4C18,GIRDER5C18,...
 GIRDER6C18,GIRDER1C19,GIRDER2C19,GIRDER3C19,GIRDER4C19,GIRDER5C19,GIRDER6C19, ...
 GIRDER1C20H];
FH2G1C20A = monitor('FH2G1C20A','IdentityPass');
FM1G4C20A = monitor('FM1G4C20A','IdentityPass');
FL1G1C21A = monitor('FL1G1C21A','IdentityPass');
FL2G1C21A = monitor('FL2G1C21A','IdentityPass');
FM1G4C21A = monitor('FM1G4C21A','IdentityPass');
FH1G1C22A = monitor('FH1G1C22A','IdentityPass');
CH1XG2C20A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C20A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C20A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C20B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C20B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C20B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C21A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C21A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C21A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C21B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C21B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C21B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C20A = monitor('MK4G1C20A','IdentityPass');
MK1G3C20A = monitor('MK1G3C20A','IdentityPass');
MK3G4C20B = monitor('MK3G4C20B','IdentityPass');
MK2G5C20B = monitor('MK2G5C20B','IdentityPass');
MK5G1C21A = monitor('MK5G1C21A','IdentityPass');
MK1G3C21A = monitor('MK1G3C21A','IdentityPass');
MK3G4C21B = monitor('MK3G4C21B','IdentityPass');
MK2G5C21B = monitor('MK2G5C21B','IdentityPass');
PH1G2C20A = monitor('BPM','IdentityPass');
PH2G2C20A = monitor('BPM','IdentityPass');
PM1G4C20A = monitor('BPM','IdentityPass');
PM1G4C20B = monitor('BPM','IdentityPass');
PL2G6C20B = monitor('BPM','IdentityPass');
PL1G6C20B = monitor('BPM','IdentityPass');
PL1G2C21A = monitor('BPM','IdentityPass');
PL2G2C21A = monitor('BPM','IdentityPass');
PM1G4C21A = monitor('BPM','IdentityPass');
PM1G4C21B = monitor('BPM','IdentityPass');
PH2G6C21B = monitor('BPM','IdentityPass');
PH1G6C21B = monitor('BPM','IdentityPass');
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
GSG1C21A = monitor('GS','IdentityPass');
GEG1C21A = monitor('GE','IdentityPass');
GSG2C21A = monitor('GS','IdentityPass');
GEG2C21A = monitor('GE','IdentityPass');
GSG3C21A = monitor('GS','IdentityPass');
GEG3C21A = monitor('GE','IdentityPass');
GSG4C21A = monitor('GS','IdentityPass');
GEG4C21B = monitor('GE','IdentityPass');
GSG5C21B = monitor('GS','IdentityPass');
GEG5C21B = monitor('GE','IdentityPass');
GSG6C21B = monitor('GS','IdentityPass');
GEG6C21B = monitor('GE','IdentityPass');
GSG1C22A = monitor('GS','IdentityPass');
QH1G2C20A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C20A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C20A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C20A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C20A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C20A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C20B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C20B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C20B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C20B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C20B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C21A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C21A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C21A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C21A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C21A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C21A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C21B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C21B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C21B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C21B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C21B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C20A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C20B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C21A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C21B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C20A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C20A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C20A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C20A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C20B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C20B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C20B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C20B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C20B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C21A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C21A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C21A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C21A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C21B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C21B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C21B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C21B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C21B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C20A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C20A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C20A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C20B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C20B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C20B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C21A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C21A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C21A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C21B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C21B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C21B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C20=[MK4G1C20A,DH02G1A,DFT,FH2G1C20A,DFT,DH1G1A,GEG1C20A];
GIRDER2C20=[GSG2C20A,SH1G2C20A,DH1AG2A,PH1G2C20A,DBPM01,QH1G2C20A,...
 DH2AG2A,SQHHG2C20A,CH1XG2C20A,CH1YG2C20A,SQHHG2C20A,DH2BG2A,QH2G2C20A,DH3AG2A, ...
 SH3G2C20A,DH3BG2A,QH3G2C20A,DH4AG2A,PH2G2C20A,DBPM02,SH4G2C20A,DH4BG2A,DFCH, ...
 CH2XG2C20A,CH2YG2C20A,DFCH,GEG2C20A];
GIRDER3C20=[DH4CG3A,GSG3C20A,MK1G3C20A,B1G3C20A,GEG3C20A];
GIRDER4C20=[GSG4C20A,DM1AG4A,DSCH,CM1XG4C20A,CM1YG4C20A,DSCH,DM1BG4A,...
 QM1G4C20A,DM2AG4A,SM1G4C20A,DFT1,DFT,FM1G4C20A,DFT,DM2BG4A,PM1G4C20A,DBPM03, ...
 QM2G4C20A,DM2CG4A,SM2HG4C20B,DM2CG4B,QM2G4C20B,DM2BG4B, ...
 SM1G4C20B,DM2AG4B,PM1G4C20B,DBPM04,QM1G4C20B,DM1EG4B,DFCH,CM1YG4C20B, ...
 CM1XG4C20B,DFCH,GEG4C20B];
GIRDER5C20=[GSG5C20B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C20B,MK2G5C20B,...
 GEG5C20B];
GIRDER6C20=[DL4BG6B,GSG6C20B,DL4AG6B,QL3G6C20B,DBPM05,PL2G6C20B,DL3CG6B,...
 SL3G6C20B,DL3BG6B,DSCH,CL2YG6C20B,CL2XG6C20B,DSCH,DL3AG6B,QL2G6C20B,DL2CG6B, ...
 SL2G6C20B,DL2BG6B,DSCH,CL1YG6C20B,CL1XG6C20B,DSCH,DL2AG6B,QL1G6C20B,DL1AG6B, ...
 PL1G6C20B,DBPM06,SL1G6C20B,GEG6C20B];
GIRDER1C21=[GSG1C21A,DL0BG1A,DFT,FL1G1C21A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C21A,DL02G1A,DLDK,DFT2,DFT,FL2G1C21A,DFT,DL0AG1A,GEG1C21A];
GIRDER2C21=[GSG2C21A,SL1G2C21A,DL1AG2A,PL1G2C21A,DBPM07,QL1G2C21A,...
 DL2AG2A,DSCH,CL1XG2C21A,CL1YG2C21A,DSCH,DL2BG2A,SL2G2C21A,DL2CG2A,QL2G2C21A, ...
 DL3AG2A,DSCH,CL2XG2C21A,CL2YG2C21A,DSCH,DL3BG2A,SL3G2C21A,DL3CG2A,PL2G2C21A, ...
 DBPM08,QL3G2C21A,DL4AG2A,GEG2C21A];
GIRDER3C21=[DL4BG3A,GSG3C21A,MK1G3C21A,B1G3C21A,GEG3C21A];
GIRDER4C21=[GSG4C21A,DM1AG4A,SQMHG4C21A,CM1XG4C21A,CM1YG4C21A,...
 SQMHG4C21A,DM1BG4A,QM1G4C21A,DM2A2G4A,SM1G4C21A,DFT1,DFT,FM1G4C21A,DFT, ...
 DM2B2G4A,PM1G4C21A,DBPM09,QM2G4C21A,DM2CG4A,SM2HG4C21B, ...
 DM2CG4B,QM2G4C21B,DM2B2G4B,SM1G4C21B,DM2A2G4B,PM1G4C21B,DBPM10,QM1G4C21B, ...
 DM1EG4B,DFCH,CM1YG4C21B,CM1XG4C21B,DFCH,GEG4C21B];
GIRDER5C21=[GSG5C21B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C21B,MK2G5C21B,...
 GEG5C21B];
GIRDER6C21=[DH4CG6B,GSG6C21B,DFCH,CH2YG6C21B,CH2XG6C21B,DFCH,DH4BG6B,...
 SH4G6C21B,DH4AG6B,PH2G6C21B,DBPM11,QH3G6C21B,DH3BG6B,SH3G6C21B,DH3AG6B, ...
 QH2G6C21B,DH2BG6B,DSCH,CH1YG6C21B,CH1XG6C21B,DSCH,DH2AG6B,QH1G6C21B,DH1AG6B, ...
 PH1G6C21B,DBPM12,SH1G6C21B,GEG6C21B];
GIRDER1C22H=[GSG1C22A,DH2G1A,DFT,FH1G1C22A,DFT,DH01G1A];
SPC20C21=[GIRDER1C20,GIRDER2C20,GIRDER3C20,GIRDER4C20,GIRDER5C20,...
 GIRDER6C20,GIRDER1C21,GIRDER2C21,GIRDER3C21,GIRDER4C21,GIRDER5C21,GIRDER6C21, ...
 GIRDER1C22H];
FH2G1C22A = monitor('FH2G1C22A','IdentityPass');
FM1G4C22A = monitor('FM1G4C22A','IdentityPass');
FL1G1C23A = monitor('FL1G1C23A','IdentityPass');
FL2G1C23A = monitor('FL2G1C23A','IdentityPass');
FM1G4C23A = monitor('FM1G4C23A','IdentityPass');
FH1G1C24A = monitor('FH1G1C24A','IdentityPass');
CH1XG2C22A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C22A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C22A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C22B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C22B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C22B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C23A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C23A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C23A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C23B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C23B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C23B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C22A = monitor('MK4G1C22A','IdentityPass');
MK1G3C22A = monitor('MK1G3C22A','IdentityPass');
MK3G4C22B = monitor('MK3G4C22B','IdentityPass');
MK2G5C22B = monitor('MK2G5C22B','IdentityPass');
MK5G1C23A = monitor('MK5G1C23A','IdentityPass');
MK1G3C23A = monitor('MK1G3C23A','IdentityPass');
MK3G4C23B = monitor('MK3G4C23B','IdentityPass');
MK2G5C23B = monitor('MK2G5C23B','IdentityPass');
PH1G2C22A = monitor('BPM','IdentityPass');
PH2G2C22A = monitor('BPM','IdentityPass');
PM1G4C22A = monitor('BPM','IdentityPass');
PM1G4C22B = monitor('BPM','IdentityPass');
PL2G6C22B = monitor('BPM','IdentityPass');
PL1G6C22B = monitor('BPM','IdentityPass');
PL1G2C23A = monitor('BPM','IdentityPass');
PL2G2C23A = monitor('BPM','IdentityPass');
PM1G4C23A = monitor('BPM','IdentityPass');
PM1G4C23B = monitor('BPM','IdentityPass');
PH2G6C23B = monitor('BPM','IdentityPass');
PH1G6C23B = monitor('BPM','IdentityPass');
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
GSG1C23A = monitor('GS','IdentityPass');
GEG1C23A = monitor('GE','IdentityPass');
GSG2C23A = monitor('GS','IdentityPass');
GEG2C23A = monitor('GE','IdentityPass');
GSG3C23A = monitor('GS','IdentityPass');
GEG3C23A = monitor('GE','IdentityPass');
GSG4C23A = monitor('GS','IdentityPass');
GEG4C23B = monitor('GE','IdentityPass');
GSG5C23B = monitor('GS','IdentityPass');
GEG5C23B = monitor('GE','IdentityPass');
GSG6C23B = monitor('GS','IdentityPass');
GEG6C23B = monitor('GE','IdentityPass');
GSG1C24A = monitor('GS','IdentityPass');
QH1G2C22A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C22A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C22A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C22A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C22A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C22A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C22B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C22B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C22B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C22B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C22B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C23A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C23A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C23A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C23A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C23A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C23A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C23B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C23B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C23B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C23B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C23B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C22A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C22B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C23A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C23B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C22A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C22A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C22A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C22A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C22B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C22B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C22B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C22B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C22B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C23A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C23A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C23A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C23A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C23B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C23B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C23B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C23B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C23B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C22A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C22A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C22A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C22B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C22B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C22B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C23A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C23A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C23A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C23B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C23B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C23B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C22=[MK4G1C22A,DH02G1A,DFT,FH2G1C22A,DFT,DH1G1A,GEG1C22A];
GIRDER2C22=[GSG2C22A,SH1G2C22A,DH1AG2A,PH1G2C22A,DBPM01,QH1G2C22A,...
 DH2AG2A,SQHHG2C22A,CH1XG2C22A,CH1YG2C22A,SQHHG2C22A,DH2BG2A,QH2G2C22A,DH3AG2A, ...
 SH3G2C22A,DH3BG2A,QH3G2C22A,DH4AG2A,PH2G2C22A,DBPM02,SH4G2C22A,DH4BG2A,DFCH, ...
 CH2XG2C22A,CH2YG2C22A,DFCH,GEG2C22A];
GIRDER3C22=[DH4CG3A,GSG3C22A,MK1G3C22A,B1G3C22A,GEG3C22A];
GIRDER4C22=[GSG4C22A,DM1AG4A,DSCH,CM1XG4C22A,CM1YG4C22A,DSCH,DM1BG4A,...
 QM1G4C22A,DM2AG4A,SM1G4C22A,DFT1,DFT,FM1G4C22A,DFT,DM2BG4A,PM1G4C22A,DBPM03, ...
 QM2G4C22A,DM2CG4A,SM2HG4C22B,DM2CG4B,QM2G4C22B,DM2BG4B, ...
 SM1G4C22B,DM2AG4B,PM1G4C22B,DBPM04,QM1G4C22B,DM1EG4B,DFCH,CM1YG4C22B, ...
 CM1XG4C22B,DFCH,GEG4C22B];
GIRDER5C22=[GSG5C22B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C22B,MK2G5C22B,...
 GEG5C22B];
GIRDER6C22=[DL4BG6B,GSG6C22B,DL4AG6B,QL3G6C22B,DBPM05,PL2G6C22B,DL3CG6B,...
 SL3G6C22B,DL3BG6B,DSCH,CL2YG6C22B,CL2XG6C22B,DSCH,DL3AG6B,QL2G6C22B,DL2CG6B, ...
 SL2G6C22B,DL2BG6B,DSCH,CL1YG6C22B,CL1XG6C22B,DSCH,DL2AG6B,QL1G6C22B,DL1AG6B, ...
 PL1G6C22B,DBPM06,SL1G6C22B,GEG6C22B];
GIRDER1C23=[GSG1C23A,DL0BG1A,DFT,FL1G1C23A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C23A,DL02G1A,DLDK,DFT2,DFT,FL2G1C23A,DFT,DL0AG1A,GEG1C23A];
GIRDER2C23=[GSG2C23A,SL1G2C23A,DL1AG2A,PL1G2C23A,DBPM07,QL1G2C23A,...
 DL2AG2A,DSCH,CL1XG2C23A,CL1YG2C23A,DSCH,DL2BG2A,SL2G2C23A,DL2CG2A,QL2G2C23A, ...
 DL3AG2A,DSCH,CL2XG2C23A,CL2YG2C23A,DSCH,DL3BG2A,SL3G2C23A,DL3CG2A,PL2G2C23A, ...
 DBPM08,QL3G2C23A,DL4AG2A,GEG2C23A];
GIRDER3C23=[DL4BG3A,GSG3C23A,MK1G3C23A,B1G3C23A,GEG3C23A];
GIRDER4C23=[GSG4C23A,DM1AG4A,SQMHG4C23A,CM1XG4C23A,CM1YG4C23A,...
 SQMHG4C23A,DM1BG4A,QM1G4C23A,DM2A2G4A,SM1G4C23A,DFT1,DFT,FM1G4C23A,DFT, ...
 DM2B2G4A,PM1G4C23A,DBPM09,QM2G4C23A,DM2CG4A,SM2HG4C23B, ...
 DM2CG4B,QM2G4C23B,DM2B2G4B,SM1G4C23B,DM2A2G4B,PM1G4C23B,DBPM10,QM1G4C23B, ...
 DM1EG4B,DFCH,CM1YG4C23B,CM1XG4C23B,DFCH,GEG4C23B];
GIRDER5C23=[GSG5C23B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C23B,MK2G5C23B,...
 GEG5C23B];
GIRDER6C23=[DH4CG6B,GSG6C23B,DFCH,CH2YG6C23B,CH2XG6C23B,DFCH,DH4BG6B,...
 SH4G6C23B,DH4AG6B,PH2G6C23B,DBPM11,QH3G6C23B,DH3BG6B,SH3G6C23B,DH3AG6B, ...
 QH2G6C23B,DH2BG6B,DSCH,CH1YG6C23B,CH1XG6C23B,DSCH,DH2AG6B,QH1G6C23B,DH1AG6B, ...
 PH1G6C23B,DBPM12,SH1G6C23B,GEG6C23B];
GIRDER1C24H=[GSG1C24A,DH2G1A,DFT,FH1G1C24A,DFT,DH01G1A];
SPC22C23=[GIRDER1C22,GIRDER2C22,GIRDER3C22,GIRDER4C22,GIRDER5C22,...
 GIRDER6C22,GIRDER1C23,GIRDER2C23,GIRDER3C23,GIRDER4C23,GIRDER5C23,GIRDER6C23, ...
 GIRDER1C24H];
FH2G1C24A = monitor('FH2G1C24A','IdentityPass');
FM1G4C24A = monitor('FM1G4C24A','IdentityPass');
FL1G1C25A = monitor('FL1G1C25A','IdentityPass');
FL2G1C25A = monitor('FL2G1C25A','IdentityPass');
FM1G4C25A = monitor('FM1G4C25A','IdentityPass');
FH1G1C26A = monitor('FH1G1C26A','IdentityPass');
CH1XG2C24A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C24A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C24A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C24B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C24B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C24B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C25A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C25A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C25A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C25B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C25B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C25B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C24A = monitor('MK4G1C24A','IdentityPass');
MK1G3C24A = monitor('MK1G3C24A','IdentityPass');
MK3G4C24B = monitor('MK3G4C24B','IdentityPass');
MK2G5C24B = monitor('MK2G5C24B','IdentityPass');
MK5G1C25A = monitor('MK5G1C25A','IdentityPass');
MK1G3C25A = monitor('MK1G3C25A','IdentityPass');
MK3G4C25B = monitor('MK3G4C25B','IdentityPass');
MK2G5C25B = monitor('MK2G5C25B','IdentityPass');
PH1G2C24A = monitor('BPM','IdentityPass');
PH2G2C24A = monitor('BPM','IdentityPass');
PM1G4C24A = monitor('BPM','IdentityPass');
PM1G4C24B = monitor('BPM','IdentityPass');
PL2G6C24B = monitor('BPM','IdentityPass');
PL1G6C24B = monitor('BPM','IdentityPass');
PL1G2C25A = monitor('BPM','IdentityPass');
PL2G2C25A = monitor('BPM','IdentityPass');
PM1G4C25A = monitor('BPM','IdentityPass');
PM1G4C25B = monitor('BPM','IdentityPass');
PH2G6C25B = monitor('BPM','IdentityPass');
PH1G6C25B = monitor('BPM','IdentityPass');
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
GSG1C25A = monitor('GS','IdentityPass');
GEG1C25A = monitor('GE','IdentityPass');
GSG2C25A = monitor('GS','IdentityPass');
GEG2C25A = monitor('GE','IdentityPass');
GSG3C25A = monitor('GS','IdentityPass');
GEG3C25A = monitor('GE','IdentityPass');
GSG4C25A = monitor('GS','IdentityPass');
GEG4C25B = monitor('GE','IdentityPass');
GSG5C25B = monitor('GS','IdentityPass');
GEG5C25B = monitor('GE','IdentityPass');
GSG6C25B = monitor('GS','IdentityPass');
GEG6C25B = monitor('GE','IdentityPass');
GSG1C26A = monitor('GS','IdentityPass');
QH1G2C24A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C24A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C24A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C24A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C24A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C24A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C24B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C24B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C24B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C24B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C24B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C25A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C25A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C25A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C25A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C25A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C25A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C25B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C25B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C25B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C25B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C25B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C24A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C24B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C25A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C25B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C24A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C24A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C24A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C24A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C24B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C24B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C24B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C24B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C24B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C25A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C25A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C25A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C25A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C25B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C25B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C25B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C25B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C25B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C24A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C24A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C24A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C24B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C24B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C24B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C25A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C25A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C25A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C25B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C25B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C25B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C24=[MK4G1C24A,DH02G1A,DFT,FH2G1C24A,DFT,DH1G1A,GEG1C24A];
GIRDER2C24=[GSG2C24A,SH1G2C24A,DH1AG2A,PH1G2C24A,DBPM01,QH1G2C24A,...
 DH2AG2A,SQHHG2C24A,CH1XG2C24A,CH1YG2C24A,SQHHG2C24A,DH2BG2A,QH2G2C24A,DH3AG2A, ...
 SH3G2C24A,DH3BG2A,QH3G2C24A,DH4AG2A,PH2G2C24A,DBPM02,SH4G2C24A,DH4BG2A,DFCH, ...
 CH2XG2C24A,CH2YG2C24A,DFCH,GEG2C24A];
GIRDER3C24=[DH4CG3A,GSG3C24A,MK1G3C24A,B1G3C24A,GEG3C24A];
GIRDER4C24=[GSG4C24A,DM1AG4A,DSCH,CM1XG4C24A,CM1YG4C24A,DSCH,DM1BG4A,...
 QM1G4C24A,DM2AG4A,SM1G4C24A,DFT1,DFT,FM1G4C24A,DFT,DM2BG4A,PM1G4C24A,DBPM03, ...
 QM2G4C24A,DM2CG4A,SM2HG4C24B,DM2CG4B,QM2G4C24B,DM2BG4B, ...
 SM1G4C24B,DM2AG4B,PM1G4C24B,DBPM04,QM1G4C24B,DM1EG4B,DFCH,CM1YG4C24B, ...
 CM1XG4C24B,DFCH,GEG4C24B];
GIRDER5C24=[GSG5C24B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C24B,MK2G5C24B,...
 GEG5C24B];
GIRDER6C24=[DL4BG6B,GSG6C24B,DL4AG6B,QL3G6C24B,DBPM05,PL2G6C24B,DL3CG6B,...
 SL3G6C24B,DL3BG6B,DSCH,CL2YG6C24B,CL2XG6C24B,DSCH,DL3AG6B,QL2G6C24B,DL2CG6B, ...
 SL2G6C24B,DL2BG6B,DSCH,CL1YG6C24B,CL1XG6C24B,DSCH,DL2AG6B,QL1G6C24B,DL1AG6B, ...
 PL1G6C24B,DBPM06,SL1G6C24B,GEG6C24B];
GIRDER1C25=[GSG1C25A,DL0BG1A,DFT,FL1G1C25A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C25A,DL02G1A,DLDK,DFT2,DFT,FL2G1C25A,DFT,DL0AG1A,GEG1C25A];
GIRDER2C25=[GSG2C25A,SL1G2C25A,DL1AG2A,PL1G2C25A,DBPM07,QL1G2C25A,...
 DL2AG2A,DSCH,CL1XG2C25A,CL1YG2C25A,DSCH,DL2BG2A,SL2G2C25A,DL2CG2A,QL2G2C25A, ...
 DL3AG2A,DSCH,CL2XG2C25A,CL2YG2C25A,DSCH,DL3BG2A,SL3G2C25A,DL3CG2A,PL2G2C25A, ...
 DBPM08,QL3G2C25A,DL4AG2A,GEG2C25A];
GIRDER3C25=[DL4BG3A,GSG3C25A,MK1G3C25A,B1G3C25A,GEG3C25A];
GIRDER4C25=[GSG4C25A,DM1AG4A,SQMHG4C25A,CM1XG4C25A,CM1YG4C25A,...
 SQMHG4C25A,DM1BG4A,QM1G4C25A,DM2A2G4A,SM1G4C25A,DFT1,DFT,FM1G4C25A,DFT, ...
 DM2B2G4A,PM1G4C25A,DBPM09,QM2G4C25A,DM2CG4A,SM2HG4C25B, ...
 DM2CG4B,QM2G4C25B,DM2B2G4B,SM1G4C25B,DM2A2G4B,PM1G4C25B,DBPM10,QM1G4C25B, ...
 DM1EG4B,DFCH,CM1YG4C25B,CM1XG4C25B,DFCH,GEG4C25B];
GIRDER5C25=[GSG5C25B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C25B,MK2G5C25B,...
 GEG5C25B];
GIRDER6C25=[DH4CG6B,GSG6C25B,DFCH,CH2YG6C25B,CH2XG6C25B,DFCH,DH4BG6B,...
 SH4G6C25B,DH4AG6B,PH2G6C25B,DBPM11,QH3G6C25B,DH3BG6B,SH3G6C25B,DH3AG6B, ...
 QH2G6C25B,DH2BG6B,DSCH,CH1YG6C25B,CH1XG6C25B,DSCH,DH2AG6B,QH1G6C25B,DH1AG6B, ...
 PH1G6C25B,DBPM12,SH1G6C25B,GEG6C25B];
GIRDER1C26H=[GSG1C26A,DH2G1A,DFT,FH1G1C26A,DFT,DH01G1A];
SPC24C25=[GIRDER1C24,GIRDER2C24,GIRDER3C24,GIRDER4C24,GIRDER5C24,...
 GIRDER6C24,GIRDER1C25,GIRDER2C25,GIRDER3C25,GIRDER4C25,GIRDER5C25,GIRDER6C25, ...
 GIRDER1C26H];
FH2G1C26A = monitor('FH2G1C26A','IdentityPass');
FM1G4C26A = monitor('FM1G4C26A','IdentityPass');
FL1G1C27A = monitor('FL1G1C27A','IdentityPass');
FL2G1C27A = monitor('FL2G1C27A','IdentityPass');
FM1G4C27A = monitor('FM1G4C27A','IdentityPass');
FH1G1C28A = monitor('FH1G1C28A','IdentityPass');
CH1XG2C26A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C26A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C26A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C26B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C26B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C26B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C27A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C27A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C27A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C27B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C27B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C27B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C26A = monitor('MK4G1C26A','IdentityPass');
MK1G3C26A = monitor('MK1G3C26A','IdentityPass');
MK3G4C26B = monitor('MK3G4C26B','IdentityPass');
MK2G5C26B = monitor('MK2G5C26B','IdentityPass');
MK5G1C27A = monitor('MK5G1C27A','IdentityPass');
MK1G3C27A = monitor('MK1G3C27A','IdentityPass');
MK3G4C27B = monitor('MK3G4C27B','IdentityPass');
MK2G5C27B = monitor('MK2G5C27B','IdentityPass');
PH1G2C26A = monitor('BPM','IdentityPass');
PH2G2C26A = monitor('BPM','IdentityPass');
PM1G4C26A = monitor('BPM','IdentityPass');
PM1G4C26B = monitor('BPM','IdentityPass');
PL2G6C26B = monitor('BPM','IdentityPass');
PL1G6C26B = monitor('BPM','IdentityPass');
PL1G2C27A = monitor('BPM','IdentityPass');
PL2G2C27A = monitor('BPM','IdentityPass');
PM1G4C27A = monitor('BPM','IdentityPass');
PM1G4C27B = monitor('BPM','IdentityPass');
PH2G6C27B = monitor('BPM','IdentityPass');
PH1G6C27B = monitor('BPM','IdentityPass');
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
GSG1C27A = monitor('GS','IdentityPass');
GEG1C27A = monitor('GE','IdentityPass');
GSG2C27A = monitor('GS','IdentityPass');
GEG2C27A = monitor('GE','IdentityPass');
GSG3C27A = monitor('GS','IdentityPass');
GEG3C27A = monitor('GE','IdentityPass');
GSG4C27A = monitor('GS','IdentityPass');
GEG4C27B = monitor('GE','IdentityPass');
GSG5C27B = monitor('GS','IdentityPass');
GEG5C27B = monitor('GE','IdentityPass');
GSG6C27B = monitor('GS','IdentityPass');
GEG6C27B = monitor('GE','IdentityPass');
GSG1C28A = monitor('GS','IdentityPass');
QH1G2C26A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C26A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C26A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C26A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C26A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C26A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C26B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C26B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C26B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C26B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C26B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C27A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C27A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C27A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C27A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C27A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C27A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C27B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C27B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C27B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C27B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C27B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C26A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C26B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C27A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C27B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C26A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C26A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C26A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C26A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C26B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C26B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C26B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C26B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C26B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C27A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C27A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C27A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C27A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C27B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C27B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C27B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C27B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C27B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C26A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C26A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C26A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C26B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C26B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C26B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C27A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C27A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C27A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C27B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C27B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C27B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C26=[MK4G1C26A,DH02G1A,DFT,FH2G1C26A,DFT,DH1G1A,GEG1C26A];
GIRDER2C26=[GSG2C26A,SH1G2C26A,DH1AG2A,PH1G2C26A,DBPM01,QH1G2C26A,...
 DH2AG2A,SQHHG2C26A,CH1XG2C26A,CH1YG2C26A,SQHHG2C26A,DH2BG2A,QH2G2C26A,DH3AG2A, ...
 SH3G2C26A,DH3BG2A,QH3G2C26A,DH4AG2A,PH2G2C26A,DBPM02,SH4G2C26A,DH4BG2A,DFCH, ...
 CH2XG2C26A,CH2YG2C26A,DFCH,GEG2C26A];
GIRDER3C26=[DH4CG3A,GSG3C26A,MK1G3C26A,B1G3C26A,GEG3C26A];
GIRDER4C26=[GSG4C26A,DM1AG4A,DSCH,CM1XG4C26A,CM1YG4C26A,DSCH,DM1BG4A,...
 QM1G4C26A,DM2AG4A,SM1G4C26A,DFT1,DFT,FM1G4C26A,DFT,DM2BG4A,PM1G4C26A,DBPM03, ...
 QM2G4C26A,DM2CG4A,SM2HG4C26B,DM2CG4B,QM2G4C26B,DM2BG4B, ...
 SM1G4C26B,DM2AG4B,PM1G4C26B,DBPM04,QM1G4C26B,DM1EG4B,DFCH,CM1YG4C26B, ...
 CM1XG4C26B,DFCH,GEG4C26B];
GIRDER5C26=[GSG5C26B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C26B,MK2G5C26B,...
 GEG5C26B];
GIRDER6C26=[DL4BG6B,GSG6C26B,DL4AG6B,QL3G6C26B,DBPM05,PL2G6C26B,DL3CG6B,...
 SL3G6C26B,DL3BG6B,DSCH,CL2YG6C26B,CL2XG6C26B,DSCH,DL3AG6B,QL2G6C26B,DL2CG6B, ...
 SL2G6C26B,DL2BG6B,DSCH,CL1YG6C26B,CL1XG6C26B,DSCH,DL2AG6B,QL1G6C26B,DL1AG6B, ...
 PL1G6C26B,DBPM06,SL1G6C26B,GEG6C26B];
GIRDER1C27=[GSG1C27A,DL0BG1A,DFT,FL1G1C27A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C27A,DL02G1A,DLDK,DFT2,DFT,FL2G1C27A,DFT,DL0AG1A,GEG1C27A];
GIRDER2C27=[GSG2C27A,SL1G2C27A,DL1AG2A,PL1G2C27A,DBPM07,QL1G2C27A,...
 DL2AG2A,DSCH,CL1XG2C27A,CL1YG2C27A,DSCH,DL2BG2A,SL2G2C27A,DL2CG2A,QL2G2C27A, ...
 DL3AG2A,DSCH,CL2XG2C27A,CL2YG2C27A,DSCH,DL3BG2A,SL3G2C27A,DL3CG2A,PL2G2C27A, ...
 DBPM08,QL3G2C27A,DL4AG2A,GEG2C27A];
GIRDER3C27=[DL4BG3A,GSG3C27A,MK1G3C27A,B1G3C27A,GEG3C27A];
GIRDER4C27=[GSG4C27A,DM1AG4A,SQMHG4C27A,CM1XG4C27A,CM1YG4C27A,...
 SQMHG4C27A,DM1BG4A,QM1G4C27A,DM2A2G4A,SM1G4C27A,DFT1,DFT,FM1G4C27A,DFT, ...
 DM2B2G4A,PM1G4C27A,DBPM09,QM2G4C27A,DM2CG4A,SM2HG4C27B, ...
 DM2CG4B,QM2G4C27B,DM2B2G4B,SM1G4C27B,DM2A2G4B,PM1G4C27B,DBPM10,QM1G4C27B, ...
 DM1EG4B,DFCH,CM1YG4C27B,CM1XG4C27B,DFCH,GEG4C27B];
GIRDER5C27=[GSG5C27B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C27B,MK2G5C27B,...
 GEG5C27B];
GIRDER6C27=[DH4CG6B,GSG6C27B,DFCH,CH2YG6C27B,CH2XG6C27B,DFCH,DH4BG6B,...
 SH4G6C27B,DH4AG6B,PH2G6C27B,DBPM11,QH3G6C27B,DH3BG6B,SH3G6C27B,DH3AG6B, ...
 QH2G6C27B,DH2BG6B,DSCH,CH1YG6C27B,CH1XG6C27B,DSCH,DH2AG6B,QH1G6C27B,DH1AG6B, ...
 PH1G6C27B,DBPM12,SH1G6C27B,GEG6C27B];
GIRDER1C28H=[GSG1C28A,DH2G1A,DFT,FH1G1C28A,DFT,DH01G1A];
SPC26C27=[GIRDER1C26,GIRDER2C26,GIRDER3C26,GIRDER4C26,GIRDER5C26,...
 GIRDER6C26,GIRDER1C27,GIRDER2C27,GIRDER3C27,GIRDER4C27,GIRDER5C27,GIRDER6C27, ...
 GIRDER1C28H];
FH2G1C28A = monitor('FH2G1C28A','IdentityPass');
FM1G4C28A = monitor('FM1G4C28A','IdentityPass');
FL1G1C29A = monitor('FL1G1C29A','IdentityPass');
FL2G1C29A = monitor('FL2G1C29A','IdentityPass');
FM1G4C29A = monitor('FM1G4C29A','IdentityPass');
FH1G1C30A = monitor('FH1G1C30A','IdentityPass');
CH1XG2C28A=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG2C28A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C28A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C28B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG6C28B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG6C28B=corrector('CH', 0, [0 0], 'CorrectorPass');
CL1XG2C29A=corrector('CH', 0, [0 0], 'CorrectorPass');
CL2XG2C29A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C29A=corrector('CH', 0, [0 0], 'CorrectorPass');
CM1XG4C29B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH2XG6C29B=corrector('CH', 0, [0 0], 'CorrectorPass');
CH1XG6C29B=corrector('CH', 0, [0 0], 'CorrectorPass');
MK4G1C28A = monitor('MK4G1C28A','IdentityPass');
MK1G3C28A = monitor('MK1G3C28A','IdentityPass');
MK3G4C28B = monitor('MK3G4C28B','IdentityPass');
MK2G5C28B = monitor('MK2G5C28B','IdentityPass');
MK5G1C29A = monitor('MK5G1C29A','IdentityPass');
MK1G3C29A = monitor('MK1G3C29A','IdentityPass');
MK3G4C29B = monitor('MK3G4C29B','IdentityPass');
MK2G5C29B = monitor('MK2G5C29B','IdentityPass');
PH1G2C28A = monitor('BPM','IdentityPass');
PH2G2C28A = monitor('BPM','IdentityPass');
PM1G4C28A = monitor('BPM','IdentityPass');
PM1G4C28B = monitor('BPM','IdentityPass');
PL2G6C28B = monitor('BPM','IdentityPass');
PL1G6C28B = monitor('BPM','IdentityPass');
PL1G2C29A = monitor('BPM','IdentityPass');
PL2G2C29A = monitor('BPM','IdentityPass');
PM1G4C29A = monitor('BPM','IdentityPass');
PM1G4C29B = monitor('BPM','IdentityPass');
PH2G6C29B = monitor('BPM','IdentityPass');
PH1G6C29B = monitor('BPM','IdentityPass');
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
GSG1C29A = monitor('GS','IdentityPass');
GEG1C29A = monitor('GE','IdentityPass');
GSG2C29A = monitor('GS','IdentityPass');
GEG2C29A = monitor('GE','IdentityPass');
GSG3C29A = monitor('GS','IdentityPass');
GEG3C29A = monitor('GE','IdentityPass');
GSG4C29A = monitor('GS','IdentityPass');
GEG4C29B = monitor('GE','IdentityPass');
GSG5C29B = monitor('GS','IdentityPass');
GEG5C29B = monitor('GE','IdentityPass');
GSG6C29B = monitor('GS','IdentityPass');
GEG6C29B = monitor('GE','IdentityPass');
GSG1C30A = monitor('GS','IdentityPass');
QH1G2C28A=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
SQHHG2C28A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QH2G2C28A=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH3G2C28A=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QM1G4C28A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C28A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C28B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C28B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QL3G6C28B=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
QL2G6C28B=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL1G6C28B=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL1G2C29A=quadrupole('QL1', 0.268000, -1.617855, 'StrMPoleSymplectic4Pass');
QL2G2C29A=quadrupole('QL2', 0.460000, 1.764774, 'StrMPoleSymplectic4Pass');
QL3G2C29A=quadrupole('QL3', 0.268000, -1.518683, 'StrMPoleSymplectic4Pass');
SQMHG4C29A=quadrupole('SQ', 0.100000, 0.000000, 'StrMPoleSymplectic4Pass');
QM1G4C29A=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QM2G4C29A=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM2G4C29B=quadrupole('QM2', 0.282000, 1.226155, 'StrMPoleSymplectic4Pass');
QM1G4C29B=quadrupole('QM1', 0.247000, -0.812235, 'StrMPoleSymplectic4Pass');
QH3G6C29B=quadrupole('QH3', 0.268000, -1.753550, 'StrMPoleSymplectic4Pass');
QH2G6C29B=quadrupole('QH2', 0.460000, 1.436731, 'StrMPoleSymplectic4Pass');
QH1G6C29B=quadrupole('QH1', 0.268000, -0.641957, 'StrMPoleSymplectic4Pass');
B1G3C28A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C28B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G3C29A=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
B1G5C29B=rbend('BEND', 2.620000, 0.104720, 0.052360, 0.052360, 0.000000, 'BndMPoleSymplectic4Pass');
SH1G2C28A=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
SH3G2C28A=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH4G2C28A=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SM1G4C28A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C28B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C28B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SL3G6C28B=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SL2G6C28B=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL1G6C28B=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL1G2C29A=sextupole('SL1', 0.200000, -13.271606054728/2, 'StrMPoleSymplectic4Pass');
SL2G2C29A=sextupole('SL2', 0.200000,  35.677921453110/2, 'StrMPoleSymplectic4Pass');
SL3G2C29A=sextupole('SL3', 0.200000, -29.460860606140/2, 'StrMPoleSymplectic4Pass');
SM1G4C29A=sextupole('SM1', 0.200000, -23.680634239277/2, 'StrMPoleSymplectic4Pass');
SM2HG4C29B=sextupole('SM2', 0.250000,  28.643154691514/2, 'StrMPoleSymplectic4Pass');
SM1G4C29B=sextupole('SM1', 0.200000, -25.946035461812/2, 'StrMPoleSymplectic4Pass');
SH4G6C29B=sextupole('SH4', 0.200000, -15.820900706680/2, 'StrMPoleSymplectic4Pass');
SH3G6C29B=sextupole('SH3', 0.200000,  -5.855108411471/2, 'StrMPoleSymplectic4Pass');
SH1G6C29B=sextupole('SH1', 0.200000,  19.832912099742/2, 'StrMPoleSymplectic4Pass');
CH1YG2C28A=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG2C28A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C28A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C28B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG6C28B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG6C28B=corrector('CV', 0, [0 0], 'CorrectorPass');
CL1YG2C29A=corrector('CV', 0, [0 0], 'CorrectorPass');
CL2YG2C29A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C29A=corrector('CV', 0, [0 0], 'CorrectorPass');
CM1YG4C29B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH2YG6C29B=corrector('CV', 0, [0 0], 'CorrectorPass');
CH1YG6C29B=corrector('CV', 0, [0 0], 'CorrectorPass');
GIRDER1C28=[MK4G1C28A,DH02G1A,DFT,FH2G1C28A,DFT,DH1G1A,GEG1C28A];
GIRDER2C28=[GSG2C28A,SH1G2C28A,DH1AG2A,PH1G2C28A,DBPM01,QH1G2C28A,...
 DH2AG2A,SQHHG2C28A,CH1XG2C28A,CH1YG2C28A,SQHHG2C28A,DH2BG2A,QH2G2C28A,DH3AG2A, ...
 SH3G2C28A,DH3BG2A,QH3G2C28A,DH4AG2A,PH2G2C28A,DBPM02,SH4G2C28A,DH4BG2A,DFCH, ...
 CH2XG2C28A,CH2YG2C28A,DFCH,GEG2C28A];
GIRDER3C28=[DH4CG3A,GSG3C28A,MK1G3C28A,B1G3C28A,GEG3C28A];
GIRDER4C28=[GSG4C28A,DM1AG4A,DSCH,CM1XG4C28A,CM1YG4C28A,DSCH,DM1BG4A,...
 QM1G4C28A,DM2AG4A,SM1G4C28A,DFT1,DFT,FM1G4C28A,DFT,DM2BG4A,PM1G4C28A,DBPM03, ...
 QM2G4C28A,DM2CG4A,SM2HG4C28B,DM2CG4B,QM2G4C28B,DM2BG4B, ...
 SM1G4C28B,DM2AG4B,PM1G4C28B,DBPM04,QM1G4C28B,DM1EG4B,DFCH,CM1YG4C28B, ...
 CM1XG4C28B,DFCH,GEG4C28B];
GIRDER5C28=[GSG5C28B,DM1DG5B1,DPWG5B,DM1CG5B1,B1G5C28B,MK2G5C28B,...
 GEG5C28B];
GIRDER6C28=[DL4BG6B,GSG6C28B,DL4AG6B,QL3G6C28B,DBPM05,PL2G6C28B,DL3CG6B,...
 SL3G6C28B,DL3BG6B,DSCH,CL2YG6C28B,CL2XG6C28B,DSCH,DL3AG6B,QL2G6C28B,DL2CG6B, ...
 SL2G6C28B,DL2BG6B,DSCH,CL1YG6C28B,CL1XG6C28B,DSCH,DL2AG6B,QL1G6C28B,DL1AG6B, ...
 PL1G6C28B,DBPM06,SL1G6C28B,GEG6C28B];
GIRDER1C29=[GSG1C29A,DL0BG1A,DFT,FL1G1C29A,DFT,DFT2,DLDK,DL01G1A,...
 MK5G1C29A,DL02G1A,DLDK,DFT2,DFT,FL2G1C29A,DFT,DL0AG1A,GEG1C29A];
GIRDER2C29=[GSG2C29A,SL1G2C29A,DL1AG2A,PL1G2C29A,DBPM07,QL1G2C29A,...
 DL2AG2A,DSCH,CL1XG2C29A,CL1YG2C29A,DSCH,DL2BG2A,SL2G2C29A,DL2CG2A,QL2G2C29A, ...
 DL3AG2A,DSCH,CL2XG2C29A,CL2YG2C29A,DSCH,DL3BG2A,SL3G2C29A,DL3CG2A,PL2G2C29A, ...
 DBPM08,QL3G2C29A,DL4AG2A,GEG2C29A];
GIRDER3C29=[DL4BG3A,GSG3C29A,MK1G3C29A,B1G3C29A,GEG3C29A];
GIRDER4C29=[GSG4C29A,DM1AG4A,SQMHG4C29A,CM1XG4C29A,CM1YG4C29A,...
 SQMHG4C29A,DM1BG4A,QM1G4C29A,DM2A2G4A,SM1G4C29A,DFT1,DFT,FM1G4C29A,DFT, ...
 DM2B2G4A,PM1G4C29A,DBPM09,QM2G4C29A,DM2CG4A,SM2HG4C29B, ...
 DM2CG4B,QM2G4C29B,DM2B2G4B,SM1G4C29B,DM2A2G4B,PM1G4C29B,DBPM10,QM1G4C29B, ...
 DM1EG4B,DFCH,CM1YG4C29B,CM1XG4C29B,DFCH,GEG4C29B];
GIRDER5C29=[GSG5C29B,DM1DG5B2,DPWG5B,DM1CG5B2,B1G5C29B,MK2G5C29B,...
 GEG5C29B];
GIRDER6C29=[DH4CG6B,GSG6C29B,DFCH,CH2YG6C29B,CH2XG6C29B,DFCH,DH4BG6B,...
 SH4G6C29B,DH4AG6B,PH2G6C29B,DBPM11,QH3G6C29B,DH3BG6B,SH3G6C29B,DH3AG6B, ...
 QH2G6C29B,DH2BG6B,DSCH,CH1YG6C29B,CH1XG6C29B,DSCH,DH2AG6B,QH1G6C29B,DH1AG6B, ...
 PH1G6C29B,DBPM12,SH1G6C29B,GEG6C29B];
GIRDER1C30H=[GSG1C30A,DH2G1A,DFT,FH1G1C30A,DFT,DH01G1A];
SPC28C29=[GIRDER1C28,GIRDER2C28,GIRDER3C28,GIRDER4C28,GIRDER5C28,...
 GIRDER6C28,GIRDER1C29,GIRDER2C29,GIRDER3C29,GIRDER4C29,GIRDER5C29,GIRDER6C29, ...
 GIRDER1C30H];
%RF: RFCA,VOLT=2500000,PHASE=173.523251376,FREQ=499461995.899013 ...
RF=rfcavity('RF', 0, 2500000, Harm_Num*c0/L0, Harm_Num, 'CavityPass');
% MA1: MALIGN,ON_PASS= ...
% W1: WATCH,FILENAME="%s.w1",MODE="coordinate ...
RING=[SPC30C01,SPC02C03,SPC04C05,SPC06C07,SPC08C09,SPC10C11,...
 SPC12C13,SPC14C15,SPC16C17,SPC18C19,SPC20C21,SPC22C23,SPC24C25,SPC26C27, ...
 SPC28C29];
% LMALIGN=drift('LMALIGN', 5.000000, 'DriftPass');
% BPMMALIGN = monitor('BPM','IdentityPass');
% RING0=[RING,LMALIGN,BPMMALIGN,LMALIGN,BPMMALIGN]

% USE,RIN ...
% RETUR ...
buildlat(RING);
% compute total length and RF frequency
C = 0.0;
for i = 1:length(THERING)
   C = C + THERING{i}.Length;
end
fprintf('   C = %4.2f m, f_RF = %8.6f MHz\n', C, Harm_Num*c0/(C*1e6))
RFI = findcells(THERING, 'FamName', 'RF');
THERING = setcellstruct(THERING, 'Frequency', RFI(1:length(RFI)), Harm_Num*c0/C);

evalin('caller','global THERING FAMLIST GLOBVAL');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy*1e9);
clear global FAMLIST
evalin('base','clear LOSSFLAG');
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f\n', L0_tot);
