function LT2lattice
% Lattice definition file
% Lattice for LT2
%
% Laurent S. Nadolski, SOLEIL, 03/04
% 17/01/06 Pass method for bend is obsolete in new AT

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 2.75e9; % Ring energy
GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);
disp(['** Loading lattice in ' mfilename])

%% markers           
%% Ecrans
ECR1 =  marker('BPM', 'IdentityPass');
ECR_EMIT =  marker('BPM', 'IdentityPass');
ECR2 =  marker('BPM', 'IdentityPass');
ECR3 =  marker('BPM', 'IdentityPass');
BPM1 =  marker('BPM', 'IdentityPass');
BPM2 =  marker('BPM', 'IdentityPass');
BPM3 =  marker('BPM', 'IdentityPass');
% %% perturbateurs
% KICKQD =  marker('KICKQD', 'IdentityPass');
% PERTM =  marker('PERTM', 'IdentityPass');
% emittance
EMIT  = marker('EMITTANCE', 'IdentityPass');
%% divers
FIN =  marker('FIN', 'IdentityPass');
DEBUT =  marker('DEBUT', 'IdentityPass');

%% DRIFT SPACES
 SD1  = drift('SD1', 0.100000E+00,'DriftPass');
 SD2    = drift('SD2', 0.493000E+01,'DriftPass');
 SD20    = drift('SD20', 0.116250E+01,'DriftPass');
 %SD20A    = drift('SD20A', 2.125,'DriftPass');
 SD20A    = drift('SD20A', 1.975,'DriftPass');
 SD22A    = drift('SD20A', 0.30,'DriftPass');
 SD21     = drift('SD21', 0.354250E+01,'DriftPass');
 %SD21A    = drift('SD21A', 1.3201,'DriftPass');
 SD21A    = drift('SD21A', 1.1701,'DriftPass');
 SD21AB    = drift('SD21AB',0.554,'DriftPass');
 SD21ABBP  = drift('SD21ABBP', 0.350,'DriftPass');
 SD22      = drift('SD22', 0.255500E+01,'DriftPass');
 SD22B     = drift('SD22B', 0.355900E+00,'DriftPass');
 SD31      = drift('SD31', 0.100000E+01,'DriftPass');
 SD32      = drift('SD32', 0.176000E+01,'DriftPass');
 SD32A     = drift('SD32A',0.210,'DriftPass');
 SD33      = drift('SD33', 0.130000E+01,'DriftPass');
 SD33A     = drift('SD33A', 0.120000E+01,'DriftPass');
 SD34      = drift('SD34', 0.310000E+01,'DriftPass');
 SD4       = drift('SD4', 0.500000E+00,'DriftPass');
 SD5        = drift('SD5', 0.100000E+01,'DriftPass');
 SD5G       = drift('SD5G', 0.775000E+00,'DriftPass');
 SD5G1     = drift('SD5G1', 0.387500E+00,'DriftPass');
 SD51      = drift('SD5G1', 0.500000E+00,'DriftPass');
 SD6       = drift('SD6', 0.691715E+01,'DriftPass');
 SD6A      = drift('SD6A', 0.502831E+01,'DriftPass');
 SD6AGBP   = drift('SD6AGBP',0.450,'DriftPass');
 SD6AG     = drift('SD6AG', 0.435331E+01,'DriftPass');
 SD6AB     = drift('SD6AB', 0.300000E+00,'DriftPass');
 SD6B      = drift('SD6B', 0.151524E+01,'DriftPass');
 SD61      = drift('SD61', 0.700000E+00,'DriftPass');
 SD62      = drift('SD62', 0.700000E+00,'DriftPass');
 SD62B     = drift('SD62B', 0.600000E+00,'DriftPass');
 SD63      = drift('SD63', 0.126260E+01,'DriftPass');
 SD7       = drift('SD7', 0.147000E+01,'DriftPass');
 SD7G      = drift('SD7G', 0.124500E+01,'DriftPass');
 SDG       = drift('SDG', 0.225000E+00,'DriftPass');
 SD8       = drift('SD8',  0.100000E+01,'DriftPass');
 SD8G      = drift('SD8G', 0.775000E+00,'DriftPass');
 SD81      = drift('SD81', 0.500000E+00,'DriftPass');
 SD9       = drift('SD9',0.100000E+01,'DriftPass');
 SD10      = drift('SD10', 0.620000E+01,'DriftPass');
 SD101     = drift('SD101', 0.291500E+01,'DriftPass');
 SD102      = drift('SD102', 0.133530E+01,'DriftPass');
 SD101E    = drift('SD101E', 0.200000E+01,'DriftPass');
 SD102E    = drift('SD102E', 0.684700E+00,'DriftPass');
 SD103     = drift('SD103', 0.181000E+01,'DriftPass');
 SD11      = drift('SD11', 0.799977E+00,'DriftPass');
 DRIFT      = drift('DRIFT', 0.200000E+02,'DriftPass');

%% QUADRUPOLES 
L= 0.4;
% focalisation sans les champs de fuite dans les dipoles
% QP1  =  quadrupole('QP', L, 0.1004788E+01  , 'QuadLinearPass');
% QP2  =  quadrupole('QP', L, -.6306412E+00 , 'QuadLinearPass');
% QP3  =  quadrupole('QP', L, -.7193035E+00  , 'QuadLinearPass');
% QP4  =  quadrupole('QP', L, 0.1047543E+01  , 'QuadLinearPass');
% QP5  =  quadrupole('QP', L,  0.9431380E+00   , 'QuadLinearPass');
% QP6  =  quadrupole('QP', L, -.1152734E+01  , 'QuadLinearPass');
% QP7  =  quadrupole('QP', L,  0.6238244E+00  , 'QuadLinearPass');

% % focalisation avec champ de fuite dans les dipoles - betax = 10.8 m entrée ANNEAU
% QP1  =  quadrupole('QP', L, 0.40371/L  , 'QuadLinearPass');
% QP2  =  quadrupole('QP', L, -.25738/L , 'QuadLinearPass');
% QP3  =  quadrupole('QP', L, -.29429/L  , 'QuadLinearPass');
% QP4  =  quadrupole('QP', L, 0.42088/L  , 'QuadLinearPass');
% QP5  =  quadrupole('QP', L,  0.37640/L   , 'QuadLinearPass');
% QP6  =  quadrupole('QP', L, -.46712/L  , 'QuadLinearPass');
% QP7  =  quadrupole('QP', L,  0.25389/L  , 'QuadLinearPass');

% focalisation avec champ de fuite dans les dipoles - betax = 3 m entrée ANNEAU
QP1  =  quadrupole('QP', L, 0.31134/L  , 'QuadLinearPass');
QP2  =  quadrupole('QP', L, -.18935/L , 'QuadLinearPass');
QP3  =  quadrupole('QP', L, -.29986/L  , 'QuadLinearPass');
QP4  =  quadrupole('QP', L, 0.40561/L  , 'QuadLinearPass');
QP5  =  quadrupole('QP', L,  0.35898/L   , 'QuadLinearPass');
QP6  =  quadrupole('QP', L, -.43423/L  , 'QuadLinearPass');
QP7  =  quadrupole('QP', L,  0.21242/L  , 'QuadLinearPass');


% Q1 = [QP1 QP1];
% Q2 = [QP2 QP2];
% Q3 = [QP3 QP3];
% Q4 = [QP4 QP4];
% Q5 = [QP5 QP5];
% Q6 = [QP6 QP6];
% Q7 = [QP7 QP7];
% EN attente d'elements coupes en deux


%% Vertical Correctors 
CV  =  corrector('CV',0.0,[0 0],'CorrectorPass');

%% Horizontal Correctors 
CH  =  corrector('CH',0.0,[0 0],'CorrectorPass');

%% DIPOLES
% {** 1.3815 factor to fit with BETA ??? strange **}
theta = 0.193789E+00;  % radian
%fullgap = 0.105*0.724*2/6*1.3815;
BEND  =  rbend('BEND', 1.052435,  ...
    theta, theta/2, theta/2, 0.0, ...
                'BendLinearPass');

%% {** septa booster **}
% beta_gap=0.03/6;
% tracy_gap=beta_gap*0.724*2;
% theta = -7.5*pi/180;
% fullgap= 0.03/6*0.724*2; %*1.3815;

% SEP     = rbend2('SEP', L,  theta, theta/2, theta/2, 0.0, fullgap, 'BendLinearPass');
% SEPup   = rbend2('SEPup', L/2, theta/2, theta/2, 0.0, 0.0,  fullgap, 'BendLinearPass');
% SEPdown = rbend2('SEPdown', L/2, theta/2, 0.0, theta/2, 0.0,  fullgap, 'BendLinearPass');

L_sep_A = 0.50; theta_sep_A = 0.550000E-01; % radian
L_sep_P = 0.60; theta_sep_P = 0.2374000E-01; % radian
SEP_A_1    = rbend('SEP_A_1', L_sep_A,  theta_sep_A, 0, theta_sep_A, 0.0,  'BendLinearPass');
SEP_A_2    = rbend('SEP_A_2', L_sep_A,  theta_sep_A,  theta_sep_A,0,  0.0,  'BendLinearPass');
SEP_P    = rbend('SEP_A_2', L_sep_P,  theta_sep_P,  theta_sep_P,0,  0.0,  'BendLinearPass');


% Begin Lattice
%%  Superperiods  

LINE1 = [...
 SD20A    CV       SD22A...
 CV      SD21A     SD21AB    SD21ABBP       ECR1 ...
 SD22B     CH      SDG       QP1            SD31 ...
 QP2      SD32A    SD32      BEND           SD33 ...
 SD33A   ECR_EMIT  SD34      BEND           SD4  ...    
 QP3       SDG       CV      SD5G1          SD5G1 ...
 QP4       SDG       CH      SD6AGBP        SD6AG ...
 SD6AB     BPM1      SD6B    BEND           SD63 ...
 BEND      SD7G      CH      SDG            QP5   ...
 SD81     BPM2       SD81    QP6            SDG  ...
 CV       SD8G      QP7      SD101E          CV  ...
 SD102E   SD102     BPM3     ECR2          SD103 ...
 SEP_A_1  SD1       SEP_A_2  SD11          SEP_P ...
 ECR3...
       ];



ELIST = [DEBUT, LINE1, FIN];

buildlat(ELIST);

% Set all magnets to same energy
THERING = setcellstruct(THERING,'Energy',1:length(THERING),GLOBVAL.E0);

disp('** Done **');
