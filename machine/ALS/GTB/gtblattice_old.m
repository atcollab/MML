function varargout = gtblattice(varargin)
% GTB lattice definition file


global THERING 

% Energy
if nargin >=1 
    Energy = varargin{1};
else
    Energy = 0.05e9;  % 50 MeV
end

Brho = getbrho(Energy/1e9);

% Aperture size ???
%AP =  aperture('AP',  [-0.2, 0.2, -0.1, 0.1], 'AperturePass');
AP =  aperture('AP',  [-10, 10, -10, 10], 'AperturePass');

START = marker('START', 'IdentityPass');
BPM   = marker('BPM',   'IdentityPass');
BPM_MISSING= marker('MISSING', 'IdentityPass');
TV    = marker('TV',    'IdentityPass');
END   = marker('END',   'IdentityPass');



%%%%%%%%%%%%%%%%
% Gun to Linac %
%%%%%%%%%%%%%%%%

% Correctors
GUN_HCM_L = 6*.0254;  % 6 inches is the physical length of the iron core
GUN_VCM_L = 6*.0254;  % 6 inches is the physical length of the iron core
HCM = corrector('HCM', GUN_HCM_L, [0 0], 'CorrectorPass');
VCM = corrector('VCM', GUN_VCM_L, [0 0], 'CorrectorPass');

% Gun + Linac is 8.19026 meters
GLT_START_HCM1 = drift('L', .333, 'DriftPass');
GLT_HCM1_VCM1  = drift('L', .066, 'DriftPass');
GLT_VCM1_HCM2  = drift('L', .333, 'DriftPass');
GLT_HCM2_VCM2  = drift('L', .066, 'DriftPass');
GLT_VCM2_BPM1  = drift('L', .333, 'DriftPass');
GLT_BPM1_TV1   = drift('L', .333, 'DriftPass');
GLT_TV1_BPM2   = drift('L', .333, 'DriftPass');
GLT_BPM2_HCM3  = drift('L', .333, 'DriftPass');
GLT_HCM3_VCM3  = drift('L', .066, 'DriftPass');
GLT_VCM3_BPM3  = drift('L', .333, 'DriftPass');
GLT_BPM3_HCM4  = drift('L', .333, 'DriftPass');
GLT_HCM4_VCM4  = drift('L', .066, 'DriftPass');
GLT_VCM4_TV2   = drift('L', .333, 'DriftPass');
GLT_TV2_END    = drift('L', .333, 'DriftPass');

GUN = [
    START
    GLT_START_HCM1
    HCM
    GLT_HCM1_VCM1
    VCM
    GLT_VCM1_HCM2
    HCM
    GLT_HCM2_VCM2
    VCM
    GLT_VCM2_BPM1
    BPM
    GLT_BPM1_TV1
    TV
    GLT_TV1_BPM2
    BPM
    GLT_BPM2_HCM3
    HCM
    GLT_HCM3_VCM3
    VCM
    GLT_VCM3_BPM3
    BPM_MISSING
    GLT_BPM3_HCM4
    HCM
    GLT_HCM4_VCM4
    VCM
    GLT_VCM4_TV2
    TV
    GLT_TV2_END
    END
    ]';


%%%%%%%%%
% Linac %
%%%%%%%%%

% Correctors
LN_HCM_L = 6*.0254;  % 6 inches is the physical length of the iron core
LN_VCM_L = 6*.0254;  % 6 inches is the physical length of the iron core
HCM = corrector('HCM', LN_HCM_L, [0 0], 'CorrectorPass');
VCM = corrector('VCM', LN_VCM_L, [0 0], 'CorrectorPass');

% Quadrupoles ???
L_Q = .15;    % Quadrupole length
LNQ11 = quadrupole('Q', L_Q, -0.781050/Brho, 'StrMPoleSymplectic4RadPass');
LNQ12 = quadrupole('Q', L_Q,  1.2635/Brho,   'StrMPoleSymplectic4RadPass');
LNQ13 = quadrupole('Q', L_Q, -0.781050/Brho, 'StrMPoleSymplectic4RadPass');


LN_START_BPM1 = drift('L', .333, 'DriftPass');
LN_BPM1_HCM1  = drift('L', .333, 'DriftPass');
LN_HCM1_VCM1  = drift('L', .066, 'DriftPass');
LN_VCM1_TV1   = drift('L', .333, 'DriftPass');
LN_TV1_Q11    = drift('L', .333, 'DriftPass');
LN_Q11_Q12    = drift('L', .333, 'DriftPass');
LN_Q12_Q13    = drift('L', .333, 'DriftPass');
LN_Q13_HCM2   = drift('L', .333, 'DriftPass');
LN_HCM2_VCM2  = drift('L', .066, 'DriftPass');
LN_VCM2_BPM2  = drift('L', .333, 'DriftPass');
LN_BPM2_TV2   = drift('L', .333, 'DriftPass');
LN_TV2_END    = drift('L', .333, 'DriftPass');

LINAC = [
    START
    LN_START_BPM1
    BPM_MISSING
    LN_BPM1_HCM1
    HCM
    LN_HCM1_VCM1
    VCM
    LN_VCM1_TV1
    TV
    LN_TV1_Q11
    LNQ11
    LN_Q11_Q12
    LNQ12
    LN_Q12_Q13
    LNQ13
    LN_Q13_HCM2
    HCM
    LN_HCM2_VCM2
    VCM
    LN_VCM2_BPM2
    BPM
    LN_BPM2_TV2
    TV
    LN_TV2_END
    END
    ]';


%%%%%%%%%
% LTB 1 %
%%%%%%%%%

% Correctors
LTB_HCM_L = 6*.0254;  % 6 inches is the physical length of the iron core
LTB_VCM_L = 6*.0254;  % 6 inches is the physical length of the iron core
HCM = corrector('HCM', LTB_HCM_L, [0 0], 'CorrectorPass');
VCM = corrector('VCM', LTB_VCM_L, [0 0], 'CorrectorPass');

% Quadrupoles
L_Q = .15;    % Quadrupole length
Q11 = quadrupole('Q', L_Q, -0.781050/Brho, 'StrMPoleSymplectic4RadPass');
Q12 = quadrupole('Q', L_Q,  1.2635/Brho,   'StrMPoleSymplectic4RadPass');
Q13 = quadrupole('Q', L_Q, -0.781050/Brho, 'StrMPoleSymplectic4RadPass');

% BENDs
BX = rbend('BX', .5, 0, 0, 0, 0, 'BndMPoleSymplectic4RadPass');
BS = rbend('BEND', .5, 10*pi/180, 0, 0, 0, 'BndMPoleSymplectic4RadPass'); % ???

%L1  = 3.075;  % Start of LTB to Q1.1
LTB_START_HCM1 = drift('L', .333, 'DriftPass');
LTB_HCM1_VCM1  = drift('L', .05, 'DriftPass');
LTB_VCM1_BX    = drift('L', .333, 'DriftPass');
LTB_BX_VCM2    = drift('L', .333, 'DriftPass');
LTB_VCM2_HCM2  = drift('L', .05, 'DriftPass');
LTB_HCM2_Q11   = drift('L', .333, 'DriftPass');
LTB_Q11_Q12    = drift('L', .45-L_Q/2, 'DriftPass');
LTB_Q12_Q13    = drift('L', .45-L_Q/2, 'DriftPass');
LTB_Q13_BPM1   = drift('L', 1-L_Q/2, 'DriftPass');
LTB_BPM1_TV1   = drift('L', .333, 'DriftPass');
LTB_TV1_BPM2   = drift('L', .333, 'DriftPass');
LTB_BPM2_BS    = drift('L', .333, 'DriftPass');

LTB1 = [
    START
    LTB_START_HCM1
    HCM
    LTB_HCM1_VCM1
    VCM
    LTB_VCM1_BX
    BX
    LTB_BX_VCM2
    VCM
    LTB_VCM2_HCM2
    HCM
    LTB_HCM2_Q11
    Q11
    LTB_Q11_Q12
    Q12
    LTB_Q12_Q13
    Q13
    LTB_Q13_BPM1
    BPM
    LTB_BPM1_TV1
    TV
    LTB_TV1_BPM2
    BPM
    LTB_BPM2_BS
    BS
    ]';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTB2:  Branch to Booster %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Quadrupoles
L_Q = .15;    % Quadrupole length
Q2  = quadrupole('Q', L_Q, 1.7752/Brho, 'StrMPoleSymplectic4RadPass');
Q31 = quadrupole('Q', L_Q, 1.524537/Brho, 'StrMPoleSymplectic4RadPass');
Q32 = quadrupole('Q', L_Q, -1.251297/Brho, 'StrMPoleSymplectic4RadPass');
Q41 = quadrupole('Q', L_Q, 1.976818/Brho, 'StrMPoleSymplectic4RadPass');
Q42 = quadrupole('Q', L_Q, -1.552307/Brho, 'StrMPoleSymplectic4RadPass');
Q5  = quadrupole('Q', L_Q, 1.23613/Brho, 'StrMPoleSymplectic4RadPass');
Q6  = quadrupole('Q', L_Q, -1.069303/Brho, 'StrMPoleSymplectic4RadPass');

% Last booster quad
BR1QD1 = quadrupole('BR1QD1', .3, 0.462/Brho, 'StrMPoleSymplectic4RadPass');
BR1QF2 = quadrupole('BR1QF2', .15, 0.462/Brho, 'StrMPoleSymplectic4RadPass');

% BENDs
B1 = rbend('BEND', .5,  40*pi/180, 0, 0, 0, 'BndMPoleSymplectic4RadPass');  % B1: bending, L=0.50, T=40.0, T1=18.0, T2=18.0; ???
B2 = rbend('BEND', .5, -20*pi/180, 0, 0, 0, 'BndMPoleSymplectic4RadPass');  % B2: bending, L=0.50, T=-20.0; ???
B3 = rbend('BEND', .5, -10*pi/180, 0, 0, 0, 'BndMPoleSymplectic4RadPass');  % B3: bending, L=0.35, T=-10.0, T1=-5.0, T2=-5.0;???
BRSI = rbend('BEND', .35, -3.5*pi/180, 0, 0, 0, 'BndMPoleSymplectic4RadPass');  % BRSI: bending, L=0.35, T=-10.0, T1=-5.0, T2=-5.0;???
BRKI = rbend('BEND', .5,  -3.5*pi/180, 0, 0, 0, 'BndMPoleSymplectic4RadPass');  % BRKI: bending, L=0.5, T=-3.5, T1=3.5, T2=0.0;

LTB_BS_VCM3    = drift('L', .333, 'DriftPass');
LTB_VCM3_Q2    = drift('L', .333, 'DriftPass');
LTB_Q2_TV2     = drift('L', .333, 'DriftPass');
LTB_TV2_BPM4   = drift('L', .333, 'DriftPass');
LTB_BPM4_B1    = drift('L', .333, 'DriftPass');
LTB_B1_Q31     = drift('L', .333, 'DriftPass');
LTB_Q31_Q32    = drift('L', .333, 'DriftPass');
LTB_Q32_VCM4   = drift('L', .333, 'DriftPass');
LTB_VCM4_BPM5  = drift('L', .333, 'DriftPass');
LTB_BPM5_B2    = drift('L', .333, 'DriftPass');
LTB_B2_Q41     = drift('L', .333, 'DriftPass');
LTB_Q41_TV4    = drift('L', .333, 'DriftPass');
LTB_TV4_Q42    = drift('L', .333, 'DriftPass');
LTB_Q42_VCM5   = drift('L', .333, 'DriftPass');
LTB_VCM5_VCM6  = drift('L', .333, 'DriftPass');
LTB_VCM6_BPM6  = drift('L', .333, 'DriftPass');
LTB_BPM6_Q5    = drift('L', .333, 'DriftPass');
LTB_Q5_BPM7    = drift('L', .333, 'DriftPass');
LTB_BPM7_Q6    = drift('L', .333, 'DriftPass');
LTB_Q6_VCM7    = drift('L', .333, 'DriftPass');
LTB_VCM7_B3  = drift('L', .333, 'DriftPass');
LTB_B3_HCM7  = drift('L', .333, 'DriftPass');
LTB_HCM7_TV5   = drift('L', .333, 'DriftPass');
LTB_TV5_BR1QD1 = drift('L', .333, 'DriftPass');
LTB_BR1QD1_TV6 = drift('L', .333, 'DriftPass');
LTB_TV6_BRSI   = drift('L', .333, 'DriftPass');
LTB_BRSI_BRKI  = drift('L', .333, 'DriftPass');
LTB_BRKI_BR1QF2= drift('L', .333, 'DriftPass');
LTB_BR1QF2_END = drift('L', .333, 'DriftPass');

LTB2 = [
    LTB_BS_VCM3
    VCM
    LTB_VCM3_Q2
    Q2
    LTB_Q2_TV2
    TV
    LTB_TV2_BPM4
    BPM
    LTB_BPM4_B1
    B1
    LTB_B1_Q31
    Q31
    LTB_Q31_Q32
    Q32
    LTB_Q32_VCM4
    VCM
    LTB_VCM4_BPM5
    BPM
    LTB_BPM5_B2
    B2
    LTB_B2_Q41
    Q41
    LTB_Q41_TV4
    TV
    LTB_TV4_Q42
    Q42
    LTB_Q42_VCM5
    VCM
    LTB_VCM5_VCM6
    VCM
    LTB_VCM6_BPM6
    BPM
    LTB_BPM6_Q5
    Q5
    LTB_Q5_BPM7
    BPM
    LTB_BPM7_Q6
    Q6
    LTB_Q6_VCM7
    VCM
    LTB_VCM7_B3
    B3
    LTB_B3_HCM7
    HCM
    LTB_HCM7_TV5
    TV
    LTB_TV5_BR1QD1
    BR1QD1
    LTB_BR1QD1_TV6
    TV
    LTB_TV6_BRSI
    BRSI
    LTB_BRSI_BRKI
    BRKI
    LTB_BRKI_BR1QF2
    BR1QF2
    LTB_BR1QF2_END
    END
    ]';

% Need BPMs, Correctors, TVs
LTB = [GUN LINAC LTB1 LTB2];

buildlat(LTB);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

L0 = findspos(THERING, length(THERING)+1);
fprintf('   GTB Length = %.6f meters  \n', L0)




%  define lattice;
%  Energy  = 0.05; { GeV }
%  dP      = 1.0E-6;
%  dK      = 0.01;
%  CODdxdy = 1.0E-5;
%  CODeps  = 1.0E-15;
%  Brho    = 0.1685;
% 
%  L4      : drift, L= 3.83;
%  Q11     : quadrupole, L=0.15, K=-0.781050/Brho;
%  L5      : drift, L= 0.30;
%  Q12     : quadrupole, L=0.15, K=1.2635/Brho;
%  Q13     : quadrupole, L=0.15, K=-0.781050/Brho;
%  L6      : drift, L= 1.4;
%  LTBBS   : bending, L=0.50, T=40.0;
%  L7      : drift, L= 0.992;
%  L8      : drift, L= 0.075;
%  Q2      : quadrupole, L=0.15, K=1.7752/Brho;
%  L9      : drift, L= 0.9331;
%  B1      : bending, L=0.50, T=40.0, T1=18.0, T2=18.0;
%  L10     : drift, L= 0.5;
% 
%  Q31     : quadrupole, L=0.15, K=1.524537/Brho;
%  Q32     : quadrupole, L=0.15, K=-1.251297/Brho;
%  L11     : drift, L= 2.3894;
%  B2      : bending, L=0.50, T=-20.0;
%  L3      : drift, L=0.5;
%  Q41     : quadrupole, L=0.15, K=1.976818/Brho;
%  Q42     : quadrupole, L=0.15, K=-1.552307/Brho;
%  L12     : drift, L= 2.5079;
%  Q5      : quadrupole, L=0.15, K=1.23613/Brho;
%  L13     : drift, L= 0.5;
%  Q6      : quadrupole, L=0.15, K=-1.069303/Brho;
%  BRSI    : bending, L=0.35, T=-10.0, T1=-5.0, T2=-5.0;
%  L14     : drift, L= 0.8682;
%  BRLQD1  : drift, L= 0.3;
%  L15     : drift, L= 1.2936;
%  BRKI    : bending, L=0.5, T=-3.5, T1=3.5, T2=0.0;
%  L16     : drift, L= 0.25;
%  BRLQF2  : quadrupole, L=0.15, K=0.462/Brho;
% 
%  LTB     : L4,Q11,L5,Q12,L5,Q11,L6,LTBBS,L7,L8,Q2,L9,B1,L10,
%            Q31, L5, Q32, L11, B2, L3, Q41, L5, Q42, L12, Q5, L13,
%            Q6, L10, BRSI, L14, BRLQD1, L15, BRKI, L16, BRLQF2;

% LTB = [
%     START AP L4 Q11 L5 Q12 L5 Q13 L6 LTBBS L7 L8 Q2 L9 B1 L10 ...
%     Q31  L5  Q32  L11  B2  L3  Q41  L5  Q42  L12  Q5  L13 Q6  ...
%     L10  BRSI  L14  BRLQD1  L15  BRKI  L16  BRLQF2 END];
