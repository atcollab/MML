function bareLT1lattice
% Lattice definition file
% Lattice for LT1
%
% Laurent S. Nadolski, SOLEIL, 03/04
% 17/01/06 Pass method for bend is obsolete in new AT

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 100e6;
GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);
disp(['** Loading lattice in ' mfilename])

%% markers           
%% Ecrans
ECR0 =  marker('BPM', 'IdentityPass');
ECR1 =  marker('BPM', 'IdentityPass');
ECR2 =  marker('BPM', 'IdentityPass');
ECR3 =  marker('BPM', 'IdentityPass');
ECR4 =  marker('BPM', 'IdentityPass');
%% Collimateur (fente d'analyse)
COLL =  marker('COLL', 'IdentityPass');
%% perturbateurs
KICKQD =  marker('KICKQD', 'IdentityPass');
PERTM =  marker('PERTM', 'IdentityPass');
%% divers
FIN =  marker('FIN', 'IdentityPass');
DEBUT =  marker('DEBUT', 'IdentityPass');

%% DRIFT SPACES
SDL1  = drift('SDL1', 1.2892000, 'DriftPass');
SDL1A = drift('SDL1A',  0.379800, 'DriftPass');
SDL2  = drift('SDL2',  0.180000, 'DriftPass');
SDL2B = drift('SDL2B',  0.674150, 'DriftPass');
SDL3  = drift('SDL3',  0.180000, 'DriftPass');
SDL3B = drift('SDL3B',  2.220000, 'DriftPass');
SDL4  = drift('SDL4',  0.180000, 'DriftPass');
SDL4B = drift('SDL4B', 0.770000, 'DriftPass');
SDL5H1= drift('SDL5H1',  0.180000, 'DriftPass');
SDL5H2= drift('SDL5H2',  0.505260, 'DriftPass');
SDL5C = drift('SDL5C',  0.364740, 'DriftPass');
SDL6  = drift('SDL6', 2.49248, 'DriftPass');
SDL6T = drift('SDL6T',  0.221200, 'DriftPass');
SDL7  = drift('SDL7',  0.130000, 'DriftPass');
SDL7B = drift('SDL7B',  0.971910, 'DriftPass');
SDL8  = drift('SDL8',  0.180000, 'DriftPass');
SDL8B = drift('SDL8B', 0.300000, 'DriftPass');
SDL9  = drift('SDL9',  0.344540, 'DriftPass');
SDL9B = drift('SDL9B',  0.180000, 'DriftPass');
SDL0  = drift('SDL0',  0.198800, 'DriftPass');
SDL0B = drift('SDL0B',  0.583820, 'DriftPass');
SDL0B1= drift('SDL0B1', 0.500000, 'DriftPass');
SDL0C = drift('SDL0C',  2.309270, 'DriftPass');
SBOO1 = drift('SBOO1',  1.294100, 'DriftPass');
SBOO2 = drift('SBOO2',  0.764434, 'DriftPass');
SBOO3 = drift('SBOO3', 0.150000, 'DriftPass');
SBOO4 = drift('SBOO4',  2.000000, 'DriftPass');
PERTEBR = drift('PERTEBR',  0.130000, 'DriftPass');
PERTELM = drift('PERTELM',  0.30000, 'DriftPass');
PERTSLM = drift('PERTSLM',  0.30000, 'DriftPass');
PERTSBR = drift('PERTSBR',  0.130000, 'DriftPass');

%% QUADRUPOLES 
L= 0.15/2;
QP1  =  quadrupole('QP', L,  4.17582 , 'QuadLinearPass');
QP2  =  quadrupole('QP', L, -2.78267 , 'QuadLinearPass');
QP3  =  quadrupole('QP', L, -2.61001 , 'QuadLinearPass');
QP4  =  quadrupole('QP', L,  4.29826   , 'QuadLinearPass');
QP5  =  quadrupole('QP', L,  4.94250   , 'QuadLinearPass');
QP6  =  quadrupole('QP', L, -4.94777  , 'QuadLinearPass');
QP7  =  quadrupole('QP', L,  4.92238  , 'QuadLinearPass');
QDBOO=  quadrupole('QDBOO', 0.2,  -0.891375 , 'QuadLinearPass');

% Q1 = [QP1 QP1];
% Q2 = [QP2 QP2];
% Q3 = [QP3 QP3];
% Q4 = [QP4 QP4];
% Q5 = [QP5 QP5];
% Q6 = [QP6 QP6];
% Q7 = [QP7 QP7];
% EN attente d'elements coupes en deux
L= 0.15; 
Q1  =  quadrupole('QP', L,  4.17582, 'QuadLinearPass');
Q2  =  quadrupole('QP', L, -2.78267, 'QuadLinearPass');
Q3  =  quadrupole('QP', L, -2.61001, 'QuadLinearPass');
Q4  =  quadrupole('QP', L,  4.29826, 'QuadLinearPass');
Q5  =  quadrupole('QP', L,  4.94250, 'QuadLinearPass');
Q6  =  quadrupole('QP', L, -4.94777, 'QuadLinearPass');
Q7  =  quadrupole('QP', L,  4.92238, 'QuadLinearPass');


%% Vertical Correctors 
CV  =  corrector('CV',0.0,[0 0],'CorrectorPass');

%% Horizontal Correctors 
CH  =  corrector('CH',0.0,[0 0],'CorrectorPass');

%% DIPOLES
% {** 1.3815 factor to fit with BETA ??? strange **}
theta = -15*pi/180;
fullgap = 0.105*0.724*2/6*1.3815;
% BEND  =  rbend2('BEND', 0.30, theta, theta/2, theta/2, 0.0, ...
%                 fullgap,'BendLinearFringeTiltPass');

BEND  =  rbend2('BEND', 0.30, theta, theta/2, theta/2, 0.0, ...
                fullgap,'BendLinearPass');

%% {** septa booster **}
% beta_gap=0.03/6;
% tracy_gap=beta_gap*0.724*2;
theta = -7.5*pi/180;
fullgap= 0.03/6*0.724*2; %*1.3815;
L = 0.30;
SEP     = rbend2('SEP', L,  theta, theta/2, theta/2, 0.0, fullgap, 'BendLinearPass');
SEPup   = rbend2('SEPup', L/2, theta/2, theta/2, 0.0, 0.0,  fullgap, 'BendLinearPass');
SEPdown = rbend2('SEPdown', L/2, theta/2, 0.0, theta/2, 0.0,  fullgap, 'BendLinearPass');

% SEP     = rbend2('SEP', L,  theta, theta/2, theta/2, 0.0, fullgap, 'BendLinearFringeTiltPass');
% SEPup   = rbend2('SEPup', L/2, theta/2, theta/2, 0.0, 0.0,  fullgap, 'BendLinearFringeTiltPass');
% SEPdown = rbend2('SEPdown', L/2, theta/2, 0.0, theta/2, 0.0,  fullgap, 'BendLinearFringeTiltPass');

% Begin Lattice
%%  Superperiods  
LINE2 = [ ... 
    SDL1       ECR0      SDL1A     QP1       QP1       SDL2       CH    ...
    SDL2B     ...
    QP2        QP2       SDL3      CV       SDL3B      QP3        QP3    ...
    SDL4       SDL4B     QP4       QP4       SDL5H1     CH        SDL5H2     ...
    ECR1       SDL5C     BEND      SDL6      COLL      ...
    SDL6T      QP5       QP5       SDL7      CH        SDL7B      CV        ...
    SDL8       QP6       QP6       SDL8B     BEND       SDL9       ECR2    ...
    SDL0       QP7       QP7       SDL9B     SDL0C      CV        SDL0B1     ...
    ECR3       SDL0B     SEPup     SEPdown    SBOO1      QDBOO      ...
    KICKQD     QDBOO  ...    
    SBOO2      SBOO3     PERTEBR   PERTELM   PERTM      PERTSLM    PERTSBR    ...
    SBOO3      ECR4      SBOO4
];

LINE = [ ... 
    SDL1       ECR0     SDL1A     Q1       SDL2       CH        SDL2B     ...
    Q2         SDL3      CV       SDL3B      Q3        ...
    SDL4       SDL4B     Q4       SDL5H1     CH        SDL5H2     ...
    ECR1       SDL5C     BEND      SDL6     COLL      ...
    SDL6T      Q5       SDL7      CH        SDL7B      CV        ...
    SDL8       Q6       SDL8B     BEND       SDL9       ECR2    ...
    SDL0       Q7       SDL9B     SDL0C      CV        SDL0B1     ...
    ECR3       SDL0B     SEPup     CH       SEPdown    SBOO1      QDBOO      ...
    KICKQD     QDBOO  ...    
    SBOO2      SBOO3     PERTEBR   PERTELM   PERTM      PERTSLM    PERTSBR    ...
    SBOO3      ECR4      SBOO4
];

ELIST = [DEBUT, LINE2, FIN];

buildlat(ELIST);

% Set all magnets to same energy
THERING = setcellstruct(THERING,'Energy',1:length(THERING),GLOBVAL.E0);

disp('** Done **');
