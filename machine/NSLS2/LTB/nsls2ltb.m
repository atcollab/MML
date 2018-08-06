function varargout = ltblattice(varargin)

global THERING 

if nargin >=1
   Energy = varargin{1};
else
  Energy = 200e6;
end

M1 = marker('MARK', 'IdentityPass');
M2 = marker('MARK', 'IdentityPass');
M3 = marker('MARK', 'IdentityPass');
LIN_P1 = drift('DRIF', 0.09804400000000001, 'DriftPass');
P1_VF1 = drift('DRIF', 0.104795, 'DriftPass');
VF1_C1 = drift('DRIF', 0.129253, 'DriftPass');
C1_Q1 = drift('DRIF', 0.04727, 'DriftPass');
Q1_IT1 = drift('DRIF', 0.100157, 'DriftPass');
IT1_Q2 = drift('DRIF', 0.09995999999999999, 'DriftPass');
Q2_Q3 = drift('DRIF', 0.199842, 'DriftPass');
Q3_C2 = drift('DRIF', 0.041102, 'DriftPass');
C2_B1 = drift('DRIF', 0.286154, 'DriftPass');
B1_Q4 = drift('DRIF', 0.729842, 'DriftPass');
Q4_C3 = drift('DRIF', 1.326519, 'DriftPass');
C3_Q5 = drift('DRIF', 0.293181, 'DriftPass');
Q5_SL1 = drift('DRIF', 0.25969, 'DriftPass');
SL1_P2 = drift('DRIF', 0.10974, 'DriftPass');
P2_VF2 = drift('DRIF', 0.134939, 'DriftPass');
VF2_FT1 = drift('DRIF', 0.253756, 'DriftPass');
FT1_Q6 = drift('DRIF', 0.801714, 'DriftPass');
Q6_C4 = drift('DRIF', 0.287279, 'DriftPass');
C4_B2 = drift('DRIF', 0.242721, 'DriftPass');
B2_Q7 = drift('DRIF', 0.852268, 'DriftPass');
Q7_Q8 = drift('DRIF', 0.429352, 'DriftPass');
Q8_SS1 = drift('DRIF', 0.063855, 'DriftPass');
SS1 = drift('DRIF', 0.71354, 'DriftPass');
SS1_Q9 = drift('DRIF', 0.06336600000000001, 'DriftPass');
Q9_C5 = drift('DRIF', 0.03831, 'DriftPass');
C5_P3 = drift('DRIF', 0.058188, 'DriftPass');
P3_WALL = drift('DRIF', 0.163333, 'DriftPass');
WALL = drift('DRIF', 0.9917240000000001, 'DriftPass');
WALL_VF3 = drift('DRIF', 0.403402, 'DriftPass');
VF3_B3 = drift('DRIF', 0.347013, 'DriftPass');
B3_P4 = drift('DRIF', 0.144200532, 'DriftPass');
P4_VF4 = drift('DRIF', 0.104648, 'DriftPass');
VF4_Q10 = drift('DRIF', 0.412084, 'DriftPass');
Q10_B4 = drift('DRIF', 0.82128, 'DriftPass');
B4_P5 = drift('DRIF', 0.144259, 'DriftPass');
P5_C6 = drift('DRIF', 0.111851573, 'DriftPass');
C6_Q11 = drift('DRIF', 0.201283, 'DriftPass');
Q11_Q12 = drift('DRIF', 0.767, 'DriftPass');
Q12_C7 = drift('DRIF', 0.297903, 'DriftPass');
C7_Q13 = drift('DRIF', 0.319197, 'DriftPass');
Q13_FT2 = drift('DRIF', 0.261709209, 'DriftPass');
FT2_VF5 = drift('DRIF', 0.12477529, 'DriftPass');
VF5_IT2 = drift('DRIF', 0.144587274, 'DriftPass');
IT2_Q14 = drift('DRIF', 0.235928672, 'DriftPass');
Q14_Q15 = drift('DRIF', 0.767, 'DriftPass');
Q15_C8 = drift('DRIF', 0.104688, 'DriftPass');
C8_P6 = drift('DRIF', 0.705745, 'DriftPass');
P6_SP1SI = drift('DRIF', 0.712824, 'DriftPass');
DAIN2 = drift('DRIF', 0.944, 'DriftPass');
DAIN3 = drift('DRIF', 1.525127, 'DriftPass');
DAIN4 = drift('DRIF', 0.555017, 'DriftPass');
DAIN5 = drift('DRIF', 0.181486, 'DriftPass');
DAIN6 = drift('DRIF', 0.043543, 'DriftPass');
B1_C1BD1 = drift('DRIF', 1.428144, 'DriftPass');
C1BD1_Q1BD1 = drift('DRIF', 0.871902, 'DriftPass');
Q1BD1_Q2BD1 = drift('DRIF', 0.314027, 'DriftPass');
Q2BD1_C2BD1 = drift('DRIF', 0.11578, 'DriftPass');
C2BD1_VF1BD1 = drift('DRIF', 0.231107, 'DriftPass');
VF1BD1_VF2BD1 = drift('DRIF', 1.080014, 'DriftPass');
VF2BD1_VF3BD1 = drift('DRIF', 1.010651, 'DriftPass');
VF3BD1_DU1 = drift('DRIF', 0.594803, 'DriftPass');
B2_VF1BD2 = drift('DRIF', 2.142409, 'DriftPass');
VF1BD2_DU2 = drift('DRIF', 0.593532, 'DriftPass');
B1 = rbend('BEND', 0.35, 0.225, 0.1125, 0.1125, 0,  'BndMPoleSymplectic4Pass');
B2 = rbend('BEND', 0.35, 0.225, 0.1125, 0.1125, 0,  'BndMPoleSymplectic4Pass');
B3 = rbend('BEND', 0.35, -0.1625, -0.08125, -0.08125, 0,  'BndMPoleSymplectic4Pass');
B4 = rbend('BEND', 0.35, -0.1625, -0.08125, -0.08125, 0,  'BndMPoleSymplectic4Pass');
%SP1SI = rbend('BEND', 0.75, -0.125, -0.0625, -0.0625, 0,  'BndMPoleSymplectic4Pass');
%BU3SI = corrector('KICKER', 0.2, [0.01291 0],  'CorrectorPass'); -->**
%BU4SI = 'CSBEND', 0.2, 0.01291, 0.006, 0.006, 0,  'BndMPoleSymplectic4Pass');  --> Corrector (Sep,, )

SP1SI = rbend('Septum', 0.75, -0.125, -0.0625, -0.0625, 0,  'BndMPoleSymplectic4Pass');
%BU3SI = rbend('KICKER', 0.2,  0.01291,  0.01291/2,  0.01291/2, 0, 'BndMPoleSymplectic4Pass');
%BU4SI = rbend('KICKER', 0.2, -0.01291, -0.01291/2, -0.01291/2, 0, 'BndMPoleSymplectic4Pass');
BU3SI = sbend('KICKER', 0.2 ,  0.01291, 0, 0, 0, 'BndMPoleSymplectic4Pass');
BU4SI = sbend('KICKER', 0.2 , -0.01291, 0, 0, 0, 'BndMPoleSymplectic4Pass');
%BU3SI = corrector('KICKER',  0.2, [0.01291 0],  'CorrectorPass');
%BU4SI = corrector('KICKER',  0.2, [-0.01291 0],  'CorrectorPass');


Q1 = quadrupole('QUAD', 0.15, -12.38103029065561,  'StrMPoleSymplectic4Pass');
Q2 = quadrupole('QUAD', 0.15, 13.05625044521254,  'StrMPoleSymplectic4Pass');
Q3 = quadrupole('QUAD', 0.15, -4.291155182,  'StrMPoleSymplectic4Pass');
Q4 = quadrupole('QUAD', 0.15, -6.921706304831361,  'StrMPoleSymplectic4Pass');
Q5 = quadrupole('QUAD', 0.25, 3.337595064691999,  'StrMPoleSymplectic4Pass');
Q6 = quadrupole('QUAD', 0.25, -4.00264266214753,  'StrMPoleSymplectic4Pass');
Q7 = quadrupole('QUAD', 0.15, 6.163087783701275,  'StrMPoleSymplectic4Pass');
Q8 = quadrupole('QUAD', 0.15, 0,  'StrMPoleSymplectic4Pass');
Q9 = quadrupole('QUAD', 0.15, -4.921477207393242,  'StrMPoleSymplectic4Pass');
Q10 = quadrupole('QUAD', 0.15, 7.260753465,  'StrMPoleSymplectic4Pass');
Q11 = quadrupole('QUAD', 0.15, -4.927380968,  'StrMPoleSymplectic4Pass');
Q12 = quadrupole('QUAD', 0.15, 6.213876419731516,  'StrMPoleSymplectic4Pass');
Q13 = quadrupole('QUAD', 0.15, 0,  'StrMPoleSymplectic4Pass');
Q14 = quadrupole('QUAD', 0.15, -3.391126950253495,  'StrMPoleSymplectic4Pass');
Q15 = quadrupole('QUAD', 0.15, 1.712181096,  'StrMPoleSymplectic4Pass');

Q1BD1 = quadrupole('QUAD', 0.15, -8.984411885820821, 'StrMPoleSymplectic4Pass');
Q2BD1 = quadrupole('QUAD', 0.15,  7.98520609273425,  'StrMPoleSymplectic4Pass');

%C1 = corrector('KICKER', 0.15, [0 0],  'CorrectorPass');
%C2 = drift('DRIF', 0.15, 'DriftPass');
%C3 = drift('DRIF', 0.2, 'DriftPass');
%C4 = corrector('KICKER', 0.2, [0 0],  'CorrectorPass'); 
%C5 = drift('DRIF', 0.15, 'DriftPass');
%C6 = corrector('VKICK', 0.15, [0 0],  'CorrectorPass');
%C7 = corrector('HKICK', 0.15, [0 0],  'CorrectorPass');
%C8 = corrector('KICKER', 0.15, [0 0],  'CorrectorPass');
%C1BD1 = corrector('KICKER', 0.15, [0 0],  'CorrectorPass');
%C2BD1 = corrector('KICKER', 0.15, [0 0],  'CorrectorPass');
%C2SI = drift('DRIF', 0.15, 'DriftPass');
C1 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');
C2 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');
C3 = corrector('HVCM', 0.2, [0 0],  'CorrectorPass');
C4 = corrector('HVCM', 0.2, [0 0],  'CorrectorPass');
C5 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');
C6 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');
C7 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');
C8 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');

%C1BD1 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');
%C2BD1 = corrector('HVCM', 0.15, [0 0],  'CorrectorPass');
C2SI  = corrector('BR_HVCM', 0.15, [0 0],  'CorrectorPass');

% LTB CCD
VF1 = marker('SCREEN', 'IdentityPass');
VF2 = marker('SCREEN', 'IdentityPass');
VF3 = marker('SCREEN', 'IdentityPass');
VF4 = marker('SCREEN', 'IdentityPass');
VF5 = marker('SCREEN', 'IdentityPass');

VF1BD1 = marker('SCREEN', 'IdentityPass');
VF2BD1 = marker('SCREEN', 'IdentityPass');
VF3BD1 = marker('SCREEN', 'IdentityPass');
VF1BD2 = marker('SCREEN', 'IdentityPass');
VF2SI  = marker('SCREEN', 'IdentityPass');

%P1 = drift('MONI', 0.16, 'DriftPass');
P1_half = drift('DRIF', 0.08, 'DriftPass');
P1 = marker('BPM', 'IdentityPass');
P2_half = drift('DRIF', 0.08, 'DriftPass');
P2 = marker('BPM', 'IdentityPass');
P3_half = drift('DRIF', 0.08, 'DriftPass');
P3 = marker('BPM', 'IdentityPass');
P4_half = drift('DRIF', 0.08, 'DriftPass');
P4 = marker('BPM', 'IdentityPass');
P5_half = drift('DRIF', 0.08, 'DriftPass');
P5 = marker('BPM', 'IdentityPass');
P6_half = drift('DRIF', 0.08, 'DriftPass');
P6 = marker('BPM', 'IdentityPass');
P2SI_half = drift('DRIF', 0.08, 'DriftPass');
P2SI = marker('BPM', 'IdentityPass');
%P2 = drift('MONI', 0.16, 'DriftPass');
%P3 = drift('MONI', 0.16, 'DriftPass');
%P4 = drift('MONI', 0.16, 'DriftPass');
%P5 = drift('MONI', 0.16, 'DriftPass');
%P6 = drift('MONI', 0.16, 'DriftPass');
%P2SI = drift('MONI', 0.09000800000000001, 'DriftPass');
DU1 = marker('MARK', 'IdentityPass');
DU2 = marker('MARK', 'IdentityPass');
IT1 = marker('MARK', 'IdentityPass');
IT2 = marker('MARK', 'IdentityPass');
FT1 = marker('MARK', 'IdentityPass');
FT2 = marker('MARK', 'IdentityPass');
INJ = marker('MARK', 'IdentityPass');
SL1 = drift('RCOL', 0, 'DriftPass');

START = marker('START', 'IdentityPass');
END   = marker('END',   'IdentityPass');

OUT      = [ LIN_P1  P1_half P1  P1_half P1_VF1  VF1  VF1_C1  C1  C1_Q1  Q1  Q1_IT1  IT1  IT1_Q2  Q2  Q2_Q3  Q3  Q3_C2  C2  C2_B1  M1];
DISP     = [ B1  B1_Q4  Q4  Q4_C3  C3  C3_Q5  Q5  Q5_SL1  SL1  SL1_P2  P2_half P2  P2_half  P2_VF2  VF2  VF2_FT1  FT1  FT1_Q6  Q6  Q6_C4  C4  C4_B2];
ACHROMAT = [ DISP  B2  M2];

B2_B3    = [ B2_Q7  Q7  Q7_Q8  Q8  Q8_SS1  SS1  SS1_Q9  Q9  Q9_C5  C5  C5_P3  P3_half P3  P3_half  P3_WALL  WALL  WALL_VF3  VF3  VF3_B3];
B3_B4    = [ B3_P4  P4_half P4  P4_half  P4_VF4  VF4  VF4_Q10  Q10  Q10_B4];
B4_SP1SI = [ B4_P5  P5_half P5  P5_half  P5_C6  C6  C6_Q11  Q11  Q11_Q12  Q12  Q12_C7  C7  C7_Q13  Q13  Q13_FT2  FT2  FT2_VF5  VF5  VF5_IT2  IT2  IT2_Q14  Q14  Q14_Q15  Q15  Q15_C8  C8  C8_P6  P6_half P6  P6_half  P6_SP1SI];

MATCH    = [ B2_B3  M3  B3  B3_B4  B4  B4_SP1SI  SP1SI  INJ  DAIN2  BU3SI  DAIN3  P2SI_half P2SI  P2SI_half  DAIN4  BU4SI  DAIN5  C2SI  DAIN6];
L2B      = [START OUT ACHROMAT MATCH END];



%FULLACHRO= [ OUT  ACHROMAT];
%DUMP1= [ OUT  B1_C1BD1  C1BD1  C1BD1_Q1BD1  Q1BD1  Q1BD1_Q2BD1  Q2BD1  Q2BD1_C2BD1  C2BD1  C2BD1_VF1BD1  VF1BD1  VF1BD1_VF2BD1  M2  VF2BD1  VF2BD1_VF3BD1  VF3BD1  VF3BD1_DU1  DU1];
%DUMP2= [ OUT  DISP  B2_VF1BD2  VF1BD2  VF1BD2_DU2  DU2];
%L2B_BACK= reverse(L2B);

buildlat(L2B);

%evalin('caller','global THERING FAMLIST GLOBVAL');
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);
L0 = findspos(THERING, length(THERING)+1);
fprintf('   Total Length = %.6f meters  \n', L0)


