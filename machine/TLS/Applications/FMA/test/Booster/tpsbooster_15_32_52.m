function tpsbooster
% TPS booster lattice
% Created by Peace Aug/19/2009
% Modified and Tested by Peace Aug/25/2009

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3.00e9; % Energy = 3.0e9;
GLOBVAL.LatticeFile = 'B6P4D'; % mfilename
FAMLIST = cell(0);

disp(['>> Loading TPS booster lattice ', mfilename]);
AP       =  aperture('AP',  [-0.0175, 0.0175, -0.01, 0.01],'AperturePass');
 
L0 = 496.80000000000089;		% design length [m]
C0 =   299792458; 	% speed of light [m/s]
HarmNumber = 828;
CAV = rfcavity('RF', 0, 0.9e+6, HarmNumber*C0/L0, HarmNumber,'ThinCavityPass'); 

% BPM #60
BPM  =  marker('BPM','IdentityPass');
B1BPM0  = BPM;
B1BPM1  = BPM;
B1BPM2  = BPM;
B1BPM3  = BPM;
B1BPM4  = BPM;
B1BPM5  = BPM;
B1BPM6  = BPM;
B1BPM7  = BPM;
B1BPM8  = BPM;
B1BPM9  = BPM;
B1BPM10 = BPM;

B2BPM0  = BPM;
B2BPM1  = BPM;
B2BPM2  = BPM;
B2BPM3  = BPM;
B2BPM4  = BPM;
B2BPM5  = BPM;
B2BPM6  = BPM;
B2BPM7  = BPM;
B2BPM8  = BPM;
B2BPM9  = BPM;
B2BPM10 = BPM;

B3BPM0  = BPM;
B3BPM1  = BPM;
B3BPM2  = BPM;
B3BPM3  = BPM;
B3BPM4  = BPM;
B3BPM5  = BPM;
B3BPM6  = BPM;
B3BPM7  = BPM;
B3BPM8  = BPM;
B3BPM9  = BPM;
B3BPM10 = BPM;

B4BPM0  = BPM;
B4BPM1  = BPM;
B4BPM2  = BPM;
B4BPM3  = BPM;
B4BPM4  = BPM;
B4BPM5  = BPM;
B4BPM6  = BPM;
B4BPM7  = BPM;
B4BPM8  = BPM;
B4BPM9  = BPM;
B4BPM10 = BPM;

B5BPM0  = BPM;
B5BPM1  = BPM;
B5BPM2  = BPM;
B5BPM3  = BPM;
B5BPM4  = BPM;
B5BPM5  = BPM;
B5BPM6  = BPM;
B5BPM7  = BPM;
B5BPM8  = BPM;
B5BPM9  = BPM;
B5BPM10 = BPM;

B6BPM0  = BPM;
B6BPM1  = BPM;
B6BPM2  = BPM;
B6BPM3  = BPM;
B6BPM4  = BPM;
B6BPM5  = BPM;
B6BPM6  = BPM;
B6BPM7  = BPM;
B6BPM8  = BPM;
B6BPM9  = BPM;
B6BPM10 = BPM;

% Horizontal Corrector #60
HCOR =  corrector('HCOR',0.0,[0 0],'CorrectorPass');
B1CH1  = HCOR;
B1CH2  = HCOR;
B1CH3  = HCOR;
B1CH4  = HCOR;
B1CH5  = HCOR;
B1CH6  = HCOR;
B1CH7  = HCOR;
B1CH8  = HCOR;
B1CH9  = HCOR;
B1CH10 = HCOR;

B2CH1  = HCOR;
B2CH2  = HCOR;
B2CH3  = HCOR;
B2CH4  = HCOR;
B2CH5  = HCOR;
B2CH6  = HCOR;
B2CH7  = HCOR;
B2CH8  = HCOR;
B2CH9  = HCOR;
B2CH10 = HCOR;

B3CH1  = HCOR;
B3CH2  = HCOR;
B3CH3  = HCOR;
B3CH4  = HCOR;
B3CH5  = HCOR;
B3CH6  = HCOR;
B3CH7  = HCOR;
B3CH8  = HCOR;
B3CH9  = HCOR;
B3CH10 = HCOR;

B4CH1  = HCOR;
B4CH2  = HCOR;
B4CH3  = HCOR;
B4CH4  = HCOR;
B4CH5  = HCOR;
B4CH6  = HCOR;
B4CH7  = HCOR;
B4CH8  = HCOR;
B4CH9  = HCOR;
B4CH10 = HCOR;

B5CH1  = HCOR;
B5CH2  = HCOR;
B5CH3  = HCOR;
B5CH4  = HCOR;
B5CH5  = HCOR;
B5CH6  = HCOR;
B5CH7  = HCOR;
B5CH8  = HCOR;
B5CH9  = HCOR;
B5CH10 = HCOR;

B6CH1  = HCOR;
B6CH2  = HCOR;
B6CH3  = HCOR;
B6CH4  = HCOR;
B6CH5  = HCOR;
B6CH6  = HCOR;
B6CH7  = HCOR;
B6CH8  = HCOR;
B6CH9  = HCOR;
B6CH10 = HCOR;

% Vertical Corrector #36
VCOR =  corrector('VCOR',0.0,[0 0],'CorrectorPass');
B1CV1 = VCOR;
B1CV2 = VCOR;
B1CV3 = VCOR;
B1CV4 = VCOR;
B1CV5 = VCOR;
B1CV6 = VCOR;

B2CV1 = VCOR;
B2CV2 = VCOR;
B2CV3 = VCOR;
B2CV4 = VCOR;
B2CV5 = VCOR;
B2CV6 = VCOR;

B3CV1 = VCOR;
B3CV2 = VCOR;
B3CV3 = VCOR;
B3CV4 = VCOR;
B3CV5 = VCOR;
B3CV6 = VCOR;

B4CV1 = VCOR;
B4CV2 = VCOR;
B4CV3 = VCOR;
B4CV4 = VCOR;
B4CV5 = VCOR;
B4CV6 = VCOR;

B5CV1 = VCOR;
B5CV2 = VCOR;
B5CV3 = VCOR;
B5CV4 = VCOR;
B5CV5 = VCOR;
B5CV6 = VCOR;

B6CV1 = VCOR;
B6CV2 = VCOR;
B6CV3 = VCOR;
B6CV4 = VCOR;
B6CV5 = VCOR;
B6CV6 = VCOR;

% Drifts
D0      =    drift('D0' ,3.290000,'DriftPass');
D0A     =    drift('D0A' ,2.690000,'DriftPass');
D0A0     =    drift('D0A0' ,2.510000,'DriftPass');

D0B     =    drift('D0B' ,2.990000,'DriftPass');

DM1      =    drift('DM1'  ,2.970000,'DriftPass');
DM1A     =    drift('DM1A' ,2.770000,'DriftPass');
DM1B     =    drift('DM1B' ,2.420000,'DriftPass');
DM1B0     =    drift('DM1B0' ,2.270000,'DriftPass');
DM2      =    drift('DM2'  ,3.290000,'DriftPass');
DM2A     =    drift('DM2A' ,2.290000,'DriftPass');

D1      =    drift('D1'  ,3.010000,'DriftPass');
D1A     =    drift('D1A' ,2.710000,'DriftPass');

D2      =    drift('D2' ,0.3,'DriftPass');
D3      =    drift('D3' ,0.3,'DriftPass');

D15     =    drift('D15' ,0.15,'DriftPass');
D20     =    drift('D20' ,0.20,'DriftPass');
D30     =    drift('D30' ,0.30,'DriftPass');
D35     =    drift('D35' ,0.35,'DriftPass');
D48     =    drift('D48' ,0.48,'DriftPass');

% Dipoles
ANG  = 0.1308996939;
BDK1 = -0.172159776849;
BDK2 = -1.232600386674;
BD  = rbend('BD', 1.6, ANG, ANG/2, ANG/2, BDK1, 'BendLinearPass');
BD1 = rbend('BD', 0.8, ANG/2, ANG/2, 0.0, BDK1, 'BendLinearPass');
BD2 = rbend('BD', 0.8, ANG/2, 0.0, ANG/2, BDK1, 'BendLinearPass');

BH  = rbend('BH', 0.8, ANG/2, ANG/4, ANG/4, BDK1, 'BendLinearPass');

% Quadrupoles
QFK1 = 1.126212342112;
QFK2 = 2.579093907853;
QF  = quadrupole('QF',0.3, QFK1, 'QuadLinearPass');
QF1 = quadrupole('QF1',0.15, QFK1, 'QuadLinearPass');
 
QM  = quadrupole('QM',0.3, -0.420771792226, 'QuadLinearPass');
Q1  = quadrupole('Q1',0.3, 1.432844249109, 'QuadLinearPass');
Q2  = quadrupole('Q2',0.3, -0.905810827199, 'QuadLinearPass');

% Sextupoles
S1 = sextupole('S1', 0.2, 0.0, 'StrMPoleSymplectic4Pass');   
S2 = sextupole('S2', 0.2, 0.0, 'StrMPoleSymplectic4Pass');   

PERIOD1 = [D1A,B1CH1,D15,B1BPM1,D15,Q1,D2,Q2,D3, ...
           BH,DM1A,B1CV1,D20,QM,D30,S1,DM2A,S2,D30,QF, ...
           D15,B1BPM2,D15,B1CH2,D0A0,B1CV2,D48,BD,D0B,B1CH3, ...
           D15,B1BPM3,D15,QF,       D0,BD,D0,QF, ...
           D15,B1BPM4,D15,B1CH4,D0A0,B1CV3,D48,BD,D0,QF, ...
           D15,B1BPM5,D15,B1CH5,       D0B,BD,D0,QF, ...
           D15,B1BPM6,D15,B1CH6,D0A0,B1CV4,D48,BD,D0,QF, ...
           D15,B1BPM7,D15,B1CH7,       D0B,BD,D0,QF, ...
           D15,B1BPM8,D15,B1CH8,D0A0,B1CV5,D48,BD,D0B, ...
	   B1CH9,D15,B1BPM9,D15,QF,D30,S2,DM2A,S1,D30,QM,D20,B1CV6, ...
	   DM1B0,B1CH10,D15,B1BPM10,D35,BH,D3,Q2,D2,Q1,D1];
PERIOD2 = [D1A,B2CH1,D15,B2BPM1,D15,Q1,D2,Q2,D3, ...
           BH,DM1A,B2CV1,D20,QM,D30,S1,DM2A,S2,D30,QF, ...
           D15,B2BPM2,D15,B2CH2,D0A0,B2CV2,D48,BD,D0B,B2CH3, ...
           D15,B2BPM3,D15,QF,       D0,BD,D0,QF, ...
           D15,B2BPM4,D15,B2CH4,D0A0,B2CV3,D48,BD,D0,QF, ...
           D15,B2BPM5,D15,B2CH5,       D0B,BD,D0,QF, ...
           D15,B2BPM6,D15,B2CH6,D0A0,B2CV4,D48,BD,D0,QF, ...
           D15,B2BPM7,D15,B2CH7,       D0B,BD,D0,QF, ...
           D15,B2BPM8,D15,B2CH8,D0A0,B2CV5,D48,BD,D0B, ...
	   B2CH9,D15,B2BPM9,D15,QF,D30,S2,DM2A,S1,D30,QM,D20,B2CV6, ...
	   DM1B0,B2CH10,D15,B2BPM10,D35,BH,D3,Q2,D2,Q1,D1];
PERIOD3 = [D1A,B3CH1,D15,B3BPM1,D15,Q1,D2,Q2,D3, ...
           BH,DM1A,B3CV1,D20,QM,D30,S1,DM2A,S2,D30,QF, ...
           D15,B3BPM2,D15,B3CH2,D0A0,B3CV2,D48,BD,D0B,B3CH3, ...
           D15,B3BPM3,D15,QF,       D0,BD,D0,QF, ...
           D15,B3BPM4,D15,B3CH4,D0A0,B3CV3,D48,BD,D0,QF, ...
           D15,B3BPM5,D15,B3CH5,       D0B,BD,D0,QF, ...
           D15,B3BPM6,D15,B3CH6,D0A0,B3CV4,D48,BD,D0,QF, ...
           D15,B3BPM7,D15,B3CH7,       D0B,BD,D0,QF, ...
           D15,B3BPM8,D15,B3CH8,D0A0,B3CV5,D48,BD,D0B, ...
	   B3CH9,D15,B3BPM9,D15,QF,D30,S2,DM2A,S1,D30,QM,D20,B3CV6, ...
	   DM1B0,B3CH10,D15,B3BPM10,D35,BH,D3,Q2,D2,Q1,D1];
PERIOD4 = [D1A,B4CH1,D15,B4BPM1,D15,Q1,D2,Q2,D3, ...
           BH,DM1A,B4CV1,D20,QM,D30,S1,DM2A,S2,D30,QF, ...
           D15,B4BPM2,D15,B4CH2,D0A0,B4CV2,D48,BD,D0B,B4CH3, ...
           D15,B4BPM3,D15,QF,       D0,BD,D0,QF, ...
           D15,B4BPM4,D15,B4CH4,D0A0,B4CV3,D48,BD,D0,QF, ...
           D15,B4BPM5,D15,B4CH5,       D0B,BD,D0,QF, ...
           D15,B4BPM6,D15,B4CH6,D0A0,B4CV4,D48,BD,D0,QF, ...
           D15,B4BPM7,D15,B4CH7,       D0B,BD,D0,QF, ...
           D15,B4BPM8,D15,B4CH8,D0A0,B4CV5,D48,BD,D0B, ...
	   B4CH9,D15,B4BPM9,D15,QF,D30,S2,DM2A,S1,D30,QM,D20,B4CV6, ...
	   DM1B0,B4CH10,D15,B4BPM10,D35,BH,D3,Q2,D2,Q1,D1];
PERIOD5 = [D1A,B5CH1,D15,B5BPM1,D15,Q1,D2,Q2,D3, ...
           BH,DM1A,B5CV1,D20,QM,D30,S1,DM2A,S2,D30,QF, ...
           D15,B5BPM2,D15,B5CH2,D0A0,B5CV2,D48,BD,D0B,B5CH3, ...
           D15,B5BPM3,D15,QF,       D0,BD,D0,QF, ...
           D15,B5BPM4,D15,B5CH4,D0A0,B5CV3,D48,BD,D0,QF, ...
           D15,B5BPM5,D15,B5CH5,       D0B,BD,D0,QF, ...
           D15,B5BPM6,D15,B5CH6,D0A0,B5CV4,D48,BD,D0,QF, ...
           D15,B5BPM7,D15,B5CH7,       D0B,BD,D0,QF, ...
           D15,B5BPM8,D15,B5CH8,D0A0,B5CV5,D48,BD,D0B, ...
	   B5CH9,D15,B5BPM9,D15,QF,D30,S2,DM2A,S1,D30,QM,D20,B5CV6, ...
	   DM1B0,B5CH10,D15,B5BPM10,D35,BH,D3,Q2,D2,Q1,D1];
PERIOD6 = [D1A,B6CH1,D15,B6BPM1,D15,Q1,D2,Q2,D3, ...
           BH,DM1A,B6CV1,D20,QM,D30,S1,DM2A,S2,D30,QF, ...
           D15,B6BPM2,D15,B6CH2,D0A0,B6CV2,D48,BD,D0B,B6CH3, ...
           D15,B6BPM3,D15,QF,       D0,BD,D0,QF, ...
           D15,B6BPM4,D15,B6CH4,D0A0,B6CV3,D48,BD,D0,QF, ...
           D15,B6BPM5,D15,B6CH5,       D0B,BD,D0,QF, ...
           D15,B6BPM6,D15,B6CH6,D0A0,B6CV4,D48,BD,D0B, ...
           B6CH7,D15,B6BPM7,D15,QF,D0,BD,D0,QF, ...
           D15,B6BPM8,D15,B6CH8,D0A0,B6CV5,D48,BD,D0B, ...
	   B6CH9,D15,B6BPM9,D15,QF,D30,S2,DM2A,S1,D30,QM,D20,B6CV6, ...
	   DM1B0,B6CH10,D15,B6BPM10,D35,BH,D3,Q2,D2,Q1,D1];

BOOSTER=[PERIOD1,PERIOD2,PERIOD3,CAV,PERIOD4,PERIOD5,PERIOD6];

buildlat(BOOSTER);

% Newer AT versions requires 'Energy' to be an AT field
%THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), GLOBVAL.E0);

% Compute total length and RF frequency
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
fprintf('   Model booster circumference is %.6f meters\n', L0_tot)
fprintf('   Model RF frequency is %.6f MHz\n', HarmNumber*C0/L0_tot/1e6)

findspos(THERING,1:length(THERING)+1);

ati=atindex(THERING);
 Bp = 10;
 k  = size((ati.QF),2);
 l  = size((ati.BD),2);
 m  = size((ati.BH),2);

for i = 1 : k
    THERING{ati.QF(i)}.MaxOrder   = 2;
    THERING{ati.QF(i)}.PassMethod = 'StrMPoleSymplectic4Pass';
    THERING{ati.QF(i)}.PolynomB   = [0   THERING{ati.QF(i)}.K   QFK2 ];
    THERING{ati.QF(i)}.PolynomA   = [0   0   0 ];			   
end

%  Changing the MaxOrder & PassMethod of Dipole
for i = 1 : m
    THERING{ati.BH(i)}.MaxOrder   = 2;
    THERING{ati.BH(i)}.PassMethod = 'BndMPoleSymplectic4Pass';
    b2 =(BDK2)*(THERING{ati.BH(i)}.BendingAngle)/(THERING{ati.BH(i)}.Length);
    THERING{ati.BH(i)}.PolynomB   = [0  BDK1  BDK2 ];
    THERING{ati.BH(i)}.PolynomA   = [0  0  0  ];
end

for i = 1 : l
    THERING{ati.BD(i)}.MaxOrder   = 2;
    THERING{ati.BD(i)}.PassMethod = 'BndMPoleSymplectic4Pass';
    b2 =(BDK2)*(THERING{ati.BD(i)}.BendingAngle)/(THERING{ati.BD(i)}.Length);
    THERING{ati.BD(i)}.PolynomB   = [0  BDK1  BDK2 ];
    THERING{ati.BD(i)}.PolynomA   = [0  0  0  ];
end

evalin('caller','global THERING FAMLIST GLOBVAL');

temp_string = sprintf('# of vertical corrector           : %d',size((ati.VCOR),2));
disp(temp_string);
temp_string = sprintf('# of horizontal corrector         : %d',size((ati.HCOR),2));
disp(temp_string);
temp_string = sprintf('# of BPM                          : %d',size((ati.BPM),2));
disp(temp_string);
temp_string = sprintf('# of combined func. bending BD    : %d',size((ati.BD),2));
disp(temp_string);
temp_string = sprintf('# of combined func. bending BH    : %d',size((ati.BH),2));
disp(temp_string);
temp_string = sprintf('# of combined function quadrupole : %d',size((ati.QF),2));
disp(temp_string);
temp_string = sprintf('# of pure quadrupole QM           : %d',size((ati.QM),2));
disp(temp_string);
temp_string = sprintf('# of pure quadrupole Q1           : %d',size((ati.Q1),2));
disp(temp_string);
temp_string = sprintf('# of pure quadrupole Q2           : %d',size((ati.Q2),2));
disp(temp_string);
temp_string = sprintf('# of pure sextupole S1            : %d',size((ati.S1),2));
disp(temp_string);
temp_string = sprintf('# of pure sextupole S2            : %d',size((ati.S2),2));
disp(temp_string);

%atsummary;

if nargout
    varargout{1} = THERING;
end

disp('** Finished loading lattice in Accelerator Toolbox');

clear global FAMLIST 

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');   % Unfortunately it will come back
