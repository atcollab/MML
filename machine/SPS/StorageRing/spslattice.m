function spslattice

% Siam Photon Source lattice.
% 1.2 GeV electron energy.

fprintf('   Loading SPS lattice in %s\n', mfilename);

global FAMLIST THERING GLOBVAL

Energy = 1.2e9;
GLOBVAL.E0 = Energy;
GLOBVAL.LatticeFile = mfilename;

FAMLIST = cell(0); 

% Begin Element Families

% Physical aperture.
% aperture('FAMILYNAME', [horiz & vert limits], 'METHOD')

AP = aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');

% Beam position monitors.
% (20 BPMs total).

BPM =  marker('BPM','IdentityPass');

% RF cavity.
% rfcavity('FAMILYNAME', length [m], voltage [V], frequency [Hz], harm number,'METHOD')

CAV	= rfcavity('CAV' , 0 , 1.2e+5 , 118.000573e+6, 32 ,'CavityPass');  

% Drift spaces.
% drift('FAMILYNAME', length [m], 'METHOD')

D01     = drift('D01', 3.09400000,'DriftPass');
D02     = drift('D02', 0.11800000,'DriftPass');
D03     = drift('D03', 0.17150000,'DriftPass');
D04     = drift('D04', 0.12700000,'DriftPass');
D05     = drift('D05', 0.14000000,'DriftPass');
D06     = drift('D06' ,0.38850000,'DriftPass');
D07     = drift('D07' ,0.46000000,'DriftPass');
D08     = drift('D08' ,0.12350000,'DriftPass');
D09     = drift('D09' ,0.10100000-0.0025,'DriftPass');
D10     = drift('D10' ,0.06950000-0.0025,'DriftPass');
D11     = drift('D11' ,1.17700000,'DriftPass');
D12     = drift('D12' ,0.07750000-0.0025,'DriftPass');
D13     = drift('D13' ,0.10100000-0.0025,'DriftPass');
D14     = drift('D14' ,0.10100000-0.0025,'DriftPass');
D15     = drift('D15' ,0.04900000-0.0025,'DriftPass');
D16     = drift('D16' ,1.10550000,'DriftPass');
D17     = drift('D17' ,0.06950000-0.0025,'DriftPass');
D18     = drift('D18' ,0.10100000-0.0025,'DriftPass');
D19     = drift('D19' ,0.12350000,'DriftPass');
D20     = drift('D20' ,0.46000000,'DriftPass');
D21     = drift('D21' ,0.38850000,'DriftPass');
D22     = drift('D22' ,0.14000000,'DriftPass');
D23     = drift('D23' ,0.12700000,'DriftPass');
D24     = drift('D24' ,0.17150000,'DriftPass');
D25     = drift('D25', 0.11800000,'DriftPass');
D26     = drift('D26', 3.09400000, 'DriftPass');
D1X     = drift('D1X',1.105500000, 'DriftPass');
D2X     = drift('D2X', 0.04900000-0.0025, 'DriftPass');
D5X     = drift('D5X', 0.07750000-0.0025, 'DriftPass');
D6X     = drift('D6X',  1.1770000, 'DriftPass');
DRFA    = drift('DRFA', 1.7300000, 'DriftPass');
DRFB    = drift('DRFB', 0.8020000, 'DriftPass');
DRFC    = drift('DRFC', 0.5620000, 'DriftPass');

D01mu    = drift('DRFC', 0.4140000, 'DriftPass'); %Distance from LSS 
D01md    = drift('DRFC', 1.6850000, 'DriftPass'); %Distance from Upstream BPM to Downstrem BPM 
D02m     = drift('DRFC', 0.995000, 'DriftPass'); %Distance from Downstream BPM to STH1 

D01s    = drift('DRFC', 0.37500000, 'DriftPass');  %Center BPM to SWLS is 375 mm
D02s    = drift('DRFC', 2.71900000, 'DriftPass');
D26s    = drift('DRFC', 2.71900000, 'DriftPass');

% Bending magnets.
% rbend('FAMILYNAME', arc length [m], bend angle [rad], entrance angle [rad],
% exit angle [rad], K [m^-2], 'METHOD')

B_ANGLE = (pi/4)/9;
RHO = 2.78;

B_ARC = B_ANGLE*RHO;

B01 = rbend('BM', B_ARC, B_ANGLE, 0, 0, 0,'BendLinearPass');
B02 = rbend('BM', B_ARC, B_ANGLE, 0, 0, 0,'BendLinearPass');

% Quadrupoles.
% quadrupole('FAMILYNAME', length [m], K [m^-2], 'METHOD')
% (8 QFs, 8 QDs, 8 QFAs & 4 QDAs).

Q_LENGTH = 0.323;

%Design parameters of 28 nm at 0.9752 GeV, 41 nm at 1.2 GeV 
%Low vertical betatron function lattice
%  QF1_K =  2.43194;
%  QD2_K = -2.60959;
%  QF3_K =  2.38843;
%  QD4_K = -1.74394;

%Design parameters of 40.6 at 0.9752 GeV, 
%Injection lattice
 QF1_K =  2.45699; 
 QD2_K = -2.62369; 
 QF3_K =  2.31755;
 QD4_K = -1.68214;

% Design parameter of 74 nm rad at 1.0 GeV, 107 nm at 1.2 GeV
%  QF1_K =  2.50144;
%  QD2_K = -2.61835;
%  QF3_K =  2.25894;
%  QD4_K = -1.78334;
 
% Design parameter of 50.3 nm rad at 1.0 GeV,  72 nm at 1.2 GeV
%  QF1_K =  2.4825;
%  QD2_K = -2.6340;
%  QF3_K =  2.2953;
%  QD4_K = -1.7024;


QF11 = quadrupole('QF', Q_LENGTH, QF1_K,  'QuadLinearPass');
QF12 = quadrupole('QF', Q_LENGTH, QF1_K,  'QuadLinearPass');
QF31 = quadrupole('QFA', Q_LENGTH, QF3_K, 'QuadLinearPass');
QF32 = quadrupole('QFA', Q_LENGTH, QF3_K, 'QuadLinearPass');

QD21 = quadrupole('QD', Q_LENGTH, QD2_K,  'QuadLinearPass');
QD22 = quadrupole('QD', Q_LENGTH, QD2_K,  'QuadLinearPass');
QD41 = quadrupole('QDA', Q_LENGTH, QD4_K, 'QuadLinearPass');

QF1_SWLS = quadrupole('QF1_SWLS', Q_LENGTH, QF1_K,  'QuadLinearPass');
QD2_SWLS = quadrupole('QD2_SWLS', Q_LENGTH, QD2_K,  'QuadLinearPass');

QF11_MPW = quadrupole('QF11_MPW', Q_LENGTH, QF1_K, 'QuadLinearPass');
QD21_MPW = quadrupole('QD21_MPW', Q_LENGTH, QD2_K, 'QuadLinearPass');
QF31_MPW = quadrupole('QF31_MPW', Q_LENGTH, QF3_K, 'QuadLinearPass');

QF18_MPW = quadrupole('QF18_MPW', Q_LENGTH, QF1_K, 'QuadLinearPass');
QD28_MPW = quadrupole('QD28_MPW', Q_LENGTH, QD2_K, 'QuadLinearPass');
QF38_MPW = quadrupole('QF38_MPW', Q_LENGTH, QF3_K, 'QuadLinearPass');


% Sextupoles
% sextupole('FAMILYNAME', length [m], S [m^-3], 'METHOD')
% (8 SFs & 8 SDs).

SF_LENGTH = 0.180;
SD_LENGTH = 0.230;

SF_S =  11.0804;   
SD_S =  -10.6179;  

SF = sextupole('SF' , SF_LENGTH, SF_S, 'StrMPoleSymplectic4Pass');
SD = sextupole('SD' , SD_LENGTH, SD_S, 'StrMPoleSymplectic4Pass');

% Steering magnets.
% corrector('FAMILYNAME', length [m], [kick angle x kick angle y], 'METHOD')
% (16 CORHs & 12 CORVs).

CORH1 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH2 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH3 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH4 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH5 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH6 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH7 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH8 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH9 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH10 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH11 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH12 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH13 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH14 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH15 =  corrector('CORH',0.1,[0 0],'CorrectorPass');
CORH16 =  corrector('CORH',0.1,[0 0],'CorrectorPass');

CORV1 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV2 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV3 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV4 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV5 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV6 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV7 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV8 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV9 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV10 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV11 =  corrector('CORV',0.1,[0 0],'CorrectorPass');
CORV12 =  corrector('CORV',0.1,[0 0],'CorrectorPass');

% Begin Lattice

SPERIOD1 =  [ D01mu BPM D01md BPM D02m CORH1 D02 BPM D03 QF11_MPW D04 CORV1 D05 QD21_MPW D06 B01 B01 B01 B01 B01 B01 B01 B01 B01... 
            D07 BPM D08 QF31_MPW D09 SF D10 CORH2 D11 BPM D12 SD D13 QD41 D14 SD...
            D15 CORV2 D16 CORH3 D17 SF D18 QF32 D19 BPM D20 B02 B02 B02 B02 B02 B02 B02 B02 B02...
            D21 QD22 D22 CORV3 D23 QF12 D24 BPM D25 CORH4 D26 ];
            
SPERIOD2 =  [ D01 CORH5 D02 BPM D03 QF11 D04 CORV4 D05 QD21 D06 B01 B01 B01 B01 B01 B01 B01 B01 B01... 
            D07 BPM D08 QF31 D09 SF D10 CORH6 D1X CORV5 D2X SD D13 QD41 D14 SD...
            D5X BPM D6X CORH7 D17 SF D18 QF32 D19 BPM D20 B02 B02 B02 B02 B02 B02 B02 B02 B02...
            D21 QD22 D22 CORV6 D23 QF12 D24 BPM D25 CORH8 DRFB CAV DRFC DRFA ];
            
SPERIOD3 =  [ D01 CORH9 D02 BPM D03 QF11 D04 CORV7 D05 QD21 D06 B01 B01 B01 B01 B01 B01 B01 B01 B01... 
            D07 BPM D08 QF31 D09 SF D10 CORH10 D11 BPM D12 SD D13 QD41 D14 SD...
            D15 CORV8 D16 CORH11 D17 SF D18 QF32 D19 BPM D20 B02 B02 B02 B02 B02 B02 B02 B02 B02...
            D21 QD2_SWLS D22 CORV9 D23 QF1_SWLS D24 BPM D25 CORH12 D26s BPM D01s ];  
            
SPERIOD4 =  [ D01s BPM D02s CORH13 D02 BPM D03 QF1_SWLS D04 CORV10 D05 QD2_SWLS D06 B01 B01 B01 B01 B01 B01 B01 B01 B01... 
            D07 BPM D08 QF31 D09 SF D10 CORH14 D1X CORV11 D2X SD D13 QD41 D14 SD...
            D5X BPM D6X CORH15 D17 SF D18 QF38_MPW D19 BPM D20 B02 B02 B02 B02 B02 B02 B02 B02 B02...
            D21 QD28_MPW D22 CORV12 D23 QF18_MPW D24 BPM D25 CORH16 D26];            
                        
ELIST  =  [SPERIOD1 SPERIOD2 SPERIOD3 SPERIOD4 AP];

% BUILDLAT places elements from FAMLIST into cell array THERING in the order 
% given by integer array ELIST to be use in AT lattice definition files

buildlat(ELIST);

% Compute total length and RF frequency
L0 = 81.299255;       % design length [m]
C0 = 299792458;       % speed of light [m/s]
HarmNumber = 32;
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
fprintf('   L0 = %.6f m   \n', L0_tot);
fprintf('   RF = %.6f MHz \n', HarmNumber*C0/L0_tot/1e6);

% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

setcavity off;
setradiation off;

clear global FAMLIST
clear global GLOBVAL   % GWig still requires GLOBVAL unfortunately

% LOSSFLAG is not global in AT1.3
%evalin('base','clear LOSSFLAG');

