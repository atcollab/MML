function tls_bts
% TLS BTS transfer line
% Created by F.H. Tseng 2010/09/30

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 1.5e9; % Energy = 0.15e9;
FAMLIST = cell(0);

TB1L = rbend('BM', 0.5655, -0.078539816, 0, 0, 0.0, 'BendLinearPass');
TB1R = rbend('BM', 0.5655, -0.078539816, 0, 0, 0.0, 'BendLinearPass');
TB2L = rbend('BM', 0.4000, -0.087266462, -0.087266462, 0, 0.0, 'BendLinearPass');
TB2R = rbend('BM', 0.4000, -0.087266462, 0, -0.087266462, 0.0, 'BendLinearPass');
TB3L = rbend('BM', 0.4000, -0.102084307, -0.102084307, 0, 0.0, 'BendLinearPass');
TB3R = rbend('BM', 0.4000, -0.102084307, 0, -0.102084307, 0.0, 'BendLinearPass');
TB4L = rbend('BM', 0.6000, -0.130899693, -0.130899693, 0, 0.0, 'BendLinearPass');
TB4R = rbend('BM', 0.6000, -0.130899693, 0, -0.130899693, 0.0, 'BendLinearPass');
TB5L = rbend('BM', 0.6000, 0.130899693, 0.130899693, 0, 0.0, 'BendLinearPass');
TB5R = rbend('BM', 0.6000, 0.130899693, 0, 0.130899693, 0.0, 'BendLinearPass');
TB6L = rbend('BM', 0.4000, 0.087266462, 0.087266462, 0, 0.0, 'BendLinearPass');
TB6R = rbend('BM', 0.4000, 0.087266462, 0, 0.087266462, 0.0, 'BendLinearPass');
TB7L = rbend('BM', 0.4000, 0.087266462, 0.087266462, 0, 0.0, 'BendLinearPass');
TB7R = rbend('BM', 0.4000, 0.087266462, 0, 0.087266462, 0.0, 'BendLinearPass');
TB8L = rbend('BM', 0.4500, 0.08726645, 0, 0, 0.0, 'BendLinearPass');
TB8R = rbend('BM', 0.4500, 0.08726645, 0, 0, 0.0, 'BendLinearPass');

BPM = marker('BPM','IdentityPass');
TBPM1 = BPM;
TBPM2 = BPM;
TBPM3 = BPM;
TBPM4 = BPM;
TBPM5 = BPM;
TBPM6 = BPM;
TBPM7 = BPM;

HCOR =  corrector('HCOR',0.0,[0 0],'CorrectorPass');
THC1 = HCOR;
THC1A = HCOR;
THC2 = HCOR;
THC3 = HCOR;
THC3A = HCOR;
TTHC1 = marker('TTHC1','IdentityPass');
TTHC2 = HCOR;
TTHC3 = marker('TTHC3','IdentityPass');
TTHC6 = marker('TTHC6','IdentityPass');
TTHC7 = HCOR;
TTHC8 = marker('TTHC8','IdentityPass');

VCOR =  corrector('VCOR',0.0,[0 0],'CorrectorPass');
TVC1 = VCOR;
TVC1A = VCOR;
TVC2 = VCOR;
TVC3 = VCOR;
TVC4 = VCOR;
TVC4A = VCOR;
TVC5 = VCOR;
TTVC4 = VCOR;
TTVC5 = VCOR;


%{*** quadrupole ***}
TSQ = quadrupole('SQ',0.10, 0, 'QuadLinearPass');
TQ1 = quadrupole('QM',0.21, -2.10415569278, 'QuadLinearPass');
TQ2 = quadrupole('QM',0.21, 2.43049435911, 'QuadLinearPass');
TQ3 = quadrupole('QM',0.21, -1.66490933, 'QuadLinearPass');
TQ4 = quadrupole('QM',0.21, 2.30583372275, 'QuadLinearPass');
TQ5 = quadrupole('QM',0.21, -0.989293713261, 'QuadLinearPass');
TQ6 = quadrupole('QM',0.21, 1.93137182401, 'QuadLinearPass');
TQ7 = quadrupole('QM',0.21, -1.00379525602, 'QuadLinearPass');
TQ8 = quadrupole('QM',0.21, 1.91707655097, 'QuadLinearPass');
TQ9 = quadrupole('QM',0.21, -2.60643687759, 'QuadLinearPass');
TQ10 = quadrupole('QM',0.21, 1.07646912147, 'QuadLinearPass');
TQ11 = quadrupole('QM',0.21, -2.63254474369, 'QuadLinearPass');
TQ12 = quadrupole('QM',0.21, 2.09175179361, 'QuadLinearPass');
TQ13 = quadrupole('QM',0.21, -3.94928199110, 'QuadLinearPass');
TQ14 = quadrupole('QM',0.21, 4.14232161659, 'QuadLinearPass');
TQ15 = quadrupole('QM',0.21, -4.24002498747, 'QuadLinearPass');
TQ16 = quadrupole('QM',0.21, 4.24402771397, 'QuadLinearPass');
TQ17 = quadrupole('QM',0.21, 0.801388570894, 'QuadLinearPass');

%%{*** Marker ***}
TCT1 = marker('TCT1','IdentityPass');
TCT2 = marker('TCT2','IdentityPass');
TCT3 = marker('TCT3','IdentityPass');
TCT4 = marker('TCT4','IdentityPass');
TSLIT = marker('TSLIT','IdentityPass');
TSCRH2 = marker('TSCRH2','IdentityPass');
TSCRV2 = marker('TSCRV2','IdentityPass');
TWCM1 = marker('TWCM1','IdentityPass');
TWCM2 = marker('TWCM2','IdentityPass');

THARP = marker('THARP','IdentityPass');
TSCN1 = marker('TSCN1','IdentityPass');
TSCN2 = marker('TSCN2','IdentityPass');
TSCN3 = marker('TSCN3','IdentityPass');
TSCN3A = marker('TSCN3A','IdentityPass');
TSCN4 = marker('TSCN4','IdentityPass');
TSCN4A = marker('TSCN4A','IdentityPass');
TSCN5 = marker('TSCN5','IdentityPass');
TSCN6 = marker('TSCN6','IdentityPass');
TSCN7 = marker('TSCN7','IdentityPass');
TSCN8 = marker('TSCN8','IdentityPass');

%%{*** drift sections along BTS ***}
TB1D = drift('TB1D',0.134,'DriftPass');
TBD2 = drift('TBD2',0.686,'DriftPass'); 
TBD3 = drift('TBD3',0.2,'DriftPass'); 
TDQDS = drift('TDQDS',0.23,'DriftPass');
TDQSS = drift('TDQSS',0.15,'DriftPass');
TDS = drift('TDS',0.1,'DriftPass');
TD1 = drift('TD1',1.53912,'DriftPass');
TD2 = drift('TD2',0.84788,'DriftPass');
TD2L = drift('TD2L',0.4,'DriftPass');
TD3A = drift('TD3A',0.479,'DriftPass');
TD3B = drift('TD3B',0.4,'DriftPass');
TD3C = drift('TD3C',0.35,'DriftPass');
TD3D = drift('TD3D',3.68998,'DriftPass');
TD4 = drift('TD4',0.88598,'DriftPass');
TD5 = drift('TD5',1.63712,'DriftPass');
TD6L = drift('TD6L',2.0346,'DriftPass');
TD6 = drift('TD6',0.422,'DriftPass');
TD7 = drift('TD7',0.3706,'DriftPass');
TD7R = drift('TD7R',3.082,'DriftPass');
TD8L = drift('TD8L',0.419,'DriftPass');
TD8R = drift('TD8R',3.431,'DriftPass');
TD9 = drift('TD9',2.745,'DriftPass');
TD10A = drift('TD10A',0.3489,'DriftPass');
TD10B = drift('TD10B',2.907,'DriftPass');
TD10C = drift('TD10C',2.6051,'DriftPass');
TD10D = drift('TD10D',0.304,'DriftPass');
TD11 = drift('TD11',1.74,'DriftPass');
TD12 = drift('TD12',1.04,'DriftPass');
TD13L = drift('TD13L',1.409,'DriftPass');
TD13LR = drift('TD13LR',0.105,'DriftPass');
TD13R = drift('TD13R',0.42115,'DriftPass');
TD14A = drift('TD14A',2.23407,'DriftPass');
TD14B = drift('TD14B',0.28429,'DriftPass');
TD15 = drift('TD15',1.755,'DriftPass');
TD16 = drift('TD16',7.277,'DriftPass');
TD17A = drift('TD17A',0.33751,'DriftPass');
TD17B = drift('TD17B',0.6804,'DriftPass');
TD18 = drift('TD18',0.422,'DriftPass');
TD19 = drift('TD19',0.05752,'DriftPass');
TD20 = drift('TD20',0.40298,'DriftPass');
TD21 = drift('TD21',0.4,'DriftPass');
TD22 = drift('TD22',0.37698,'DriftPass');
TD23A = drift('TD23A',0.2087265,'DriftPass');
TD23B = drift('TD23B',0.2087265,'DriftPass');
TD24 = drift('TD24',0.256227,'DriftPass');
TDBDUM = drift('TDBDUM',3.72,'DriftPass');
TDBDUM1 = drift('TDBDUM1',3.309,'DriftPass');
TDSCN = drift('TDSCN',0.1045,'DriftPass');
TDK = drift('TDK',0.08,'DriftPass');
TDWCM = drift('TDWCM',0.075,'DriftPass');
TDCT = drift('TDCT',0.075,'DriftPass');
TDSPL = drift('TDSPL',0.12,'DriftPass');
TDHAR = drift('TDHAR',0.12,'DriftPass');
TDSLI = drift('TDSLI',0.1045,'DriftPass');
TD209 = drift('TD209',0.209,'DriftPass');
TD142 = drift('TD142',0.142,'DriftPass');
TD120 = drift('TD120',0.12,'DriftPass');
TD197 = drift('TD197',0.197,'DriftPass');
TD365 = drift('TD365',0.365,'DriftPass');
TD95 = drift('TD95',0.095,'DriftPass');
TD94 = drift('TD94',0.09455,'DriftPass');
TD150 = drift('TD150',0.15,'DriftPass');
TD291 = drift('TD291',0.291,'DriftPass');
TD455 = drift('TD455',0.455,'DriftPass');
TD240 = drift('TD240',0.24,'DriftPass');
TD215 = drift('TD215',0.215,'DriftPass');
TD392 = drift('TD392',0.392,'DriftPass');
TD734 = drift('TD734',0.7346,'DriftPass');
TD44 = drift('TD44',0.044,'DriftPass');
TD323 = drift('TD323',0.323,'DriftPass');
TD245 = drift('TD245',0.245,'DriftPass');
TD246 = drift('TD246',0.24545,'DriftPass');
TD353 = drift('TD353',0.353,'DriftPass');

%%---------------------------------------
%% Define beamline
BTS1 = [TB1L,TTHC1,TB1R,TD1,TDWCM,TWCM1,TDWCM,...
TD209,TDCT,TCT1,TDCT,TD142,TDSCN,TSCN1,TDSCN,TD120,...
TDK,TVC1,TDK,TD365,TQ1,TD2L,...
TDK,THC1,TDK,TD2,...
TQ2,TD95,TDHAR,THARP,TDHAR,TD150,TDSPL,TBPM1,TDSPL,...
TD3A, TVC1A, TD3B, THC1A, TD3C, TSQ, TD3D,...
TDSCN,TSCN2,TDSCN,TD291,TB2L,TTHC2,TB2R,...
TD4,TDK,TVC2,TDK,...
TD455,TQ3,TD5,TQ4,TD95,TDSLI,TSLIT,TDSLI,TD6L,...
TDSPL,TBPM2,TDSPL,TD6,TB3L,TTHC3,TB3R];
MID = [TD7,TDK,TVC3,TDK,TD7R,TQ5,TD8L,...
TSCN3 TD8R,TQ6,TD245,...
TDSPL,TBPM3,TDSPL,TD9,TQ7,TD10A, TSCRH2, TD10B,...
TSCRV2, TD10C, TSCN3A, TD10D ,TDK,TVC4,TDK,TD240,...
TDK,THC2,TDK,TD215,TQ8,TD11,TQ9,TD12,TQ10,TD13L,...
TSCN4, TD13LR,...
TDSPL,TBPM4,TDSPL,TD13R];
% DUMP = [TD7,TDK,TVC3,TDK,TD7R,TQ5,TD8,TQ6,TD245,...
% TDSPL,TBPM3,TDSPL,TD9,TQ7,TD10,TDK,TVC4,TDK,TD240,...
% TDK,THC2,TDK,TD215,TQ8,TD11,TQ9,TD12,TQ10,TD13,...
% TDSPL,TBPM4,TDSPL,TDBDUM,TDCT,TCT4,TDCT,TDSCN,TSCN9,...
% TDSCN,TDBDUM1];
VBEN = [TB4L,TTVC4,TB4R,TD392,TDK,THC3,TDK,TD14A,...
 TSCN4A TD14B ,TQ11,TD95,...
TDCT,TCT2,TDCT,TD15,TQ12,TD95,TDSCN,TSCN5,TDSCN,...
TD16,TDSPL,TBPM5,TDSPL,TD95,TQ13,TD17A, THC3A,...
TD17B,TB5L,TTVC5,TB5R];
STB1  =[TD18,TDSCN,TSCN6,TDSCN,TD94,TQ14,TD246,...
TDSPL,TBPM6,TDSPL,TDWCM,TWCM2,TDWCM,TD19,TQ15,TD20,...
TB6L,TTHC6,TB6R,TD21,TB7L,TTHC7,TB7R,TD22,TQ16,TD23A,...
TVC4A, TD23B,...
TQ17,TD734,TDK,TVC5,TDK,TD323,TDSPL,TBPM7,TDSPL,...
TDCT,TCT3,TDCT,TDSCN,TSCN7,TDSCN,TD24,TB8L,TTHC8,TB8R,...
TSCN8];
BTS =[BTS1,MID,VBEN,STB1];

buildlat(BTS);

% Newer AT versions requires 'Energy' to be an AT field
%THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), GLOBVAL.E0);

% Compute total length
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
fprintf('   Model BTS Length is %.6f meters\n', L0_tot)

findspos(THERING,1:length(THERING)+1);

settilt(41,pi/4);
settilt(113,1.57079632679);
settilt(115,1.57079632679);
settilt(143,1.57079632679);
settilt(145,1.57079632679);

%atsummary;

if nargout
    varargout{1} = THERING;
end

disp('** Finished loading lattice in Accelerator Toolbox');

clear global FAMLIST 

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');   % Unfortunately it will come back