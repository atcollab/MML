function sps_synlattice

% Siam Photon Source lattice.
% 1.2 GeV electron energy.
% 39 nm-rad emittance.
% 28 July 2005.

%%%%%% Just Comment 1/2
%%%%%% fprintf('   Loading SPS lattice in %s\n', mfilename);
%%%%%%
global FAMLIST THERING GLOBVAL

Energy = 1.00e9;
%Energy = 1.0e9;
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

% was 118.0076e+6
CAV	= rfcavity('CAV' , 0 , 0.60e+5 , 118.00000e+6, 17 ,'CavityPass');  

% Drift spaces.
% drift('FAMILYNAME', length [m], 'METHOD')

D01     = drift('D01', 1.01115,'DriftPass');
D02     = drift('D02', 0.27365,'DriftPass');
D03     = drift('D03', 0.27365,'DriftPass');
D04     = drift('D04', 0.27365,'DriftPass');
D05     = drift('D05', 0.27365,'DriftPass');
D06     = drift('D06', 1.01115,'DriftPass');


% Bending magnets.
% rbend('FAMILYNAME', arc length [m], bend angle [rad], entrance angle [rad],
% exit angle [rad], K [m^-2], 'METHOD')

% Electron rest mass energy [GeV/c^2].

E0 = 0.0005109990615;

%gamma = (GLOBVAL.E0/1e9)/E0;
%beta = sqrt(1 - gamma^(-2));

B_ANGLE = (pi/6);

%B_FIELD = 1.440576;
%RHO = (beta*(GLOBVAL.E0/1e9))/(0.299792458*B_FIELD)

RHO = 3.03;

B_ARC = B_ANGLE*RHO;

B01 = rbend('BM', B_ARC, B_ANGLE, B_ANGLE/2, B_ANGLE/2, 0,'BendLinearPass');
B02 = rbend('BM', B_ARC, B_ANGLE, B_ANGLE/2, B_ANGLE/2, 0,'BendLinearPass');

% Quadrupoles.
% quadrupole('FAMILYNAME', length [m], K [m^-2], 'METHOD')
% QF and QD valus set to have the tune at (4.7513,2.8250)

Q_LENGTH = 0.30270;


 %Quadrupole strength by using g/I curve from SORTEC
 %QF1_K =  1.16184;
 %QD1_K =  -1.04821;

%Quadrupole strength by using calibrated g/I
 %QF1_K = 1.17042;
 %QD1_K = -0.97268;
 
 %Quadrupole strength for new operating point
 QF1_K = 1.1516% 1.17269;
 QF2_K = 1.1516%1.17269;
 QD3_K = -0.8366%-0.81718;


QF1 = quadrupole('QF', Q_LENGTH, QF1_K,  'QuadLinearPass');
QF2 = quadrupole('QF', Q_LENGTH, QF2_K,  'QuadLinearPass');
QD3 = quadrupole('QD', Q_LENGTH, QD3_K,  'QuadLinearPass');



% Steering magnets.
% corrector('FAMILYNAME', length [m], [kick angle x kick angle y], 'METHOD')
% (16 CORHs & 12 CORVs).

% CORH1 =  corrector('CORH',0.1,[0 0],'CorrectorPass');


% CORV1 =  corrector('CORV',0.1,[0 0],'CorrectorPass');


% Begin Lattice

SPERIOD1 =  [ D01 QF1 D02 B01 D03 QD3 D04 B02 D05 QF2 D06 ];
SPERIOD2 =  [ D01 QF1 D02 B01 D03 QD3 D04 B02 D05 QF2 D06 ];
SPERIOD3 =  [ D01 QF1 D02 B01 D03 QD3 D04 B02 D05 QF2 D06 ];
SPERIOD4 =  [ D01 QF1 D02 B01 D03 QD3 D04 B02 D05 QF2 D06 ];
SPERIOD5 =  [ D01 QF1 D02 B01 D03 QD3 D04 B02 D05 QF2 D06 ];
SPERIOD6 =  [ D01 QF1 D02 B01 D03 QD3 D04 B02 D05 QF2 D06 ];
            

ELIST  =  [SPERIOD1 SPERIOD2 SPERIOD3 SPERIOD4 SPERIOD5 SPERIOD6 AP];

% BUILDLAT places elements from FAMLIST into cell array THERING in the order 
% given by integer array ELIST to be use in AT lattice definition files

buildlat(ELIST);



% Compute total length and RF frequency
L0 = 43.188;       % design length [m]
C0 = 299792458;       % speed of light [m/s]
HarmNumber = 17;
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
%%%%%%% Just comment 2/2
%%%%%%% fprintf('   L0 = %.6f m   \n', L0_tot);
%%%%%%% fprintf('   RF = %.6f MHz \n', HarmNumber*C0/L0_tot/1e6);
%%%%%%%

%fprintf('   L0 = %.6f m  (should be %f m)\n', L0_tot, L0);
%fprintf('   RF = %.6f MHz (should be  Hz)\n', HarmNumber*C0/L0_tot/1e6);


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

%setcavity off;
%setradiation off;


clear global FAMLIST
clear global GLOBVAL   % GWig still requires GLOBVAL unfortunately

% LOSSFLAG is not global in AT1.3
%evalin('base','clear LOSSFLAG');

