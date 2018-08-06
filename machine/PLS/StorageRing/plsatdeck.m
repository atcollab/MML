function varargout = plsatdeck

global FAMLIST THERING GLOBVAL

Energy = 2.5e9;

GLOBVAL.E0 = Energy;
GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);

L0 = 280.56  ; % design length [m]
C0 =   299792458;     % speed of light [m/s]
HarmNumber = 468;
 
disp('   Loading PLS Ring magnet lattice');
%AP  =  aperture('AP', [-0.1,  0.1,  -0.1,  0.1],'AperturePass');
AP  =  aperture('AP', [-0.04, 0.04, -0.02, 0.02],'AperturePass');

%COR =  corrector('COR',0.2,[0.0 0.0],'CorrPass');
HCM =  corrector('HCM',0.0,[0 0],'CorrectorPass');
VCM =  corrector('VCM',0.0,[0 0],'CorrectorPass');
COR =  corrector('COR',0.0,[0 0],'CorrectorPass');

BPM =  marker('BPM','IdentityPass');
BPMx =  marker('BPMx','IdentityPass');
BPMy =  marker('BPMy','IdentityPass');

% Voltage: 1.8 e6 if four cavity is used
CAV = rfcavity('CAV1' , 0 , 1.8e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');  

%Standard Cell Drifts
LB1  = drift('LB1',  0.5197,'DriftPass');
LBE2 = drift('LBE2', 0.640, 'DriftPass');
LB3  = drift('LB3',  0.5848,'DriftPass');
LE1  = drift('LE1',  0.623, 'DriftPass');
LE3  = drift('LE3',  1.1785,'DriftPass');
L0A  = drift('L0A',  3.020, 'DriftPass');
L80  = drift('L80',  0.080, 'DriftPass');
L193 = drift('L193', 0.193, 'DriftPass');
L107 = drift('L107', 0.107, 'DriftPass');
L320 = drift('L320', 0.320, 'DriftPass');
L210 = drift('L210', 0.210, 'DriftPass');
L493 = drift('L493', 0.493, 'DriftPass');
L270 = drift('L270', 0.270, 'DriftPass');
L130 = drift('L130', 0.130, 'DriftPass');
L150 = drift('L150', 0.150, 'DriftPass');
L340 = drift('L340', 0.340, 'DriftPass'); 
L100 = drift('L100', 0.100, 'DriftPass');
L135 = drift('L135', 0.135, 'DriftPass');
L775 = drift('L775', 0.775, 'DriftPass');
L420 = drift('L420', 0.420, 'DriftPass');
L313 = drift('L313', 0.313, 'DriftPass');
L715 = drift('L715', 0.715, 'DriftPass');
L195 = drift('L195', 0.195, 'DriftPass');
L125 = drift('L125', 0.1225,'DriftPass');
L225 = drift('L225', 0.2225,'DriftPass');
L765 = drift('L765', 0.765, 'DriftPass');
L305 = drift('L305', 0.305, 'DriftPass');


%Standard Cell Dipoles
BEND = rbend('BEND', 1.1, 0.087266462*2, 0.087266462, 0.087266462, 0.0, 'BndMPoleSymplectic4Pass');
       
       
%Standard Cell Quadrupoles
Q1  = quadrupole('Q1' , 0.24,-0.641776180, 'QuadLinearPass');
Q2  = quadrupole('Q2' , 0.53, 1.51772681, 'QuadLinearPass');
Q3  = quadrupole('Q3' , 0.35,-1.69278925, 'QuadLinearPass');
Q4  = quadrupole('Q4' , 0.35,-1.45439552, 'QuadLinearPass');
Q5  = quadrupole('Q5' , 0.53, 1.81955515, 'QuadLinearPass');
Q6  = quadrupole('Q6' , 0.24,-0.794745539, 'QuadLinearPass');

%Standard Cell Sextupoles
% Set as SD = 170 mA / SF = 114 mA 
%SD  = sextupole('SD' , 0.20,-6.47662/0.2/2,'StrMPoleSymplectic4Pass');
%SF  = sextupole('SF' , 0.20, 4.49238/0.2/2,'StrMPoleSymplectic4Pass');
% Set as SD = 80 mA / SF = 56 mA 
SD  = sextupole('SD' , 0.20,-6.47662/0.2/2/2,'StrMPoleSymplectic4Pass');
SF  = sextupole('SF' , 0.20, 4.49238/0.2/2/2,'StrMPoleSymplectic4Pass');
%SD = sextupole('SD' , 0.25,-18,'DriftPass');
%SF = sextupole('SF' , 0.21, 16,'DriftPass');
%Standard Cell Kicker Drifts
K1     =     corrector('KICKER',0.6,[0 0],'CorrectorPass');
K2     =     corrector('KICKER',0.6,[0 0],'CorrectorPass');
K3     =     corrector('KICKER',0.6,[0 0],'CorrectorPass');
K4     =     corrector('KICKER',0.6,[0 0],'CorrectorPass');

INJ    =     marker('SEPTUM','IdentityPass');        %...end of septum

%Standard Cell: 
CEL0 = [ LB1 K3 LBE2 K4 LB3 BPM L107 Q1 L320 Q2 L210 ...
             COR HCM VCM L210 Q3 L107 BPM L493 ];
%CEL0 = [ L0A L80 L193 BPM  L107 Q1 L320 Q2 L210 ...
%              HCM VCM L210 Q3 L107 BPM  L493 ];
CEL1 = [ L0A HCM VCM L80 L193 BPM L107 Q1 L320 Q2 L210 ...
              HCM VCM L210 Q3 L107 BPM L493 ];
CEL2 = [ L270 BPM L130 SD L150 Q4 L340 Q5 ...
              L150 SF L125 BPM  L225 HCM VCM ...
              L80 L775 Q6 L420 ];
CEL3 = [ L313 BPM L107 Q6 L765 HCM VCM L305 ...
              BPM L130 SF L150 Q5 L340 Q4 L150 ...
              SD L130 BPM L270 ];
CEL4 = [ L493 BPM L107 Q3 L210 HCM VCM L210 Q2 L320,...
              Q1 L107 BPM L193 L80 HCM VCM L0A ];
%CEL5 = [ L493 BPM  L107 Q3 L210 HCM VCM L210 Q2 L320,...
%              Q1 L107 BPM  L193 L80 L0A ];
CEL5 = [ L493 BPM L107 Q3 L210 HCM VCM L210 Q2 L320,...
              Q1 L107 BPM LE1 K1 LBE2 K2 LE3 ];          
CELB = [ CEL0 BEND CEL2 BEND CEL3 BEND CEL4 ];
CELS = [ CEL1 BEND CEL2 BEND CEL3 BEND CEL4 ];
CELE = [ CEL1 BEND CEL2 BEND CEL3 BEND CEL5 ];
PLS  = [ INJ  CELB CELS CELS CELS CELS CELS ...
         CELS CELS CELS CELS CELS CELE CAV];
buildlat(PLS);

% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f     (design length is %.3f m)\n',  L0_tot, L0);
fprintf('   RF = %.6f MHz  \n', HarmNumber*C0/L0_tot/1e6)

% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

setcavity off;
setradiation off;

clear global FAMLIST
clear global GLOBVAL

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');

% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

