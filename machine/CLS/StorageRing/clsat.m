function clsat
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsat.m 1.1.1.2 2007/07/10 12:47:46CST Tasha Summers (summert) Exp  $
% ----------------------------------------------------------------------------------------------
% Canadian Light Source
% ----------------------------------------------------------------------------------------------

disp(['   Loading CLS magnet lattice ', mfilename]);

global FAMLIST THERING
Energy = 2.9e9;
FAMLIST = cell(0);

AP    = aperture('AP',  [-0.1, 0.1, -0.1, 0.1], 'AperturePass');

L0    = 170.88;
C0    = 299792458; 
HarmNumber = 285;
CAV	  = rfcavity('RF', 0, 2.4e+6, HarmNumber*C0/L0, HarmNumber, 'CavityPass');  

COR   = corrector('COR',0.15,[0 0],'CorrectorPass');  
CORSD = corrector('COR',0.00,[0 0],'CorrectorPass');  

BPM   = marker('BPM', 'IdentityPass');

% Drifts should match the DIMAD model
D1  = drift('D1' , 0.2500, 'DriftPass');   % D1L   = drift('D1L', 2.25, 'DriftPass');
D1A = drift('D1A', 0.2910, 'DriftPass');
D1B = drift('D1B', 0.0660, 'DriftPass');

D2A = drift('D2A', 0.3390-.15/2, 'DriftPass');  % Was 0.264
D2B = drift('D2B', 0.1950-.15/2, 'DriftPass');  % Was 0.120

D3  = drift('D3',  0.3120, 'DriftPass');  % Was 0.534

D4A = drift('D4A', 0.3095, 'DriftPass'); 
D4B = drift('D4B', 0.0975, 'DriftPass');  % Was 0.0375

D5  = drift('D5',  0.3125, 'DriftPass');  % Was 0.3335
D6  = drift('D6',  0.1695, 'DriftPass');
D7  = drift('D7',  0.3975, 'DriftPass');  % Was 0.4185
D8A = drift('D8A', 0.0920, 'DriftPass');  % Was 0.1130
D8B = drift('D8B', 0.2300, 'DriftPass');

D9A = drift('D9A', 0.2100-.15/2, 'DriftPass');  % Was 0.135
D9B = drift('D9B', 0.3240-.15/2, 'DriftPass');  % Was 0.249

D10A = drift('D10A', 0.0700, 'DriftPass');
D10B = drift('D10B', 0.2870, 'DriftPass');

%BEND  = rbend('BEND', 1.87, 0.2617994, 0.105, 0.105, -0.3972, 'BndMPoleSymplectic4Pass');
BEND1  = rbend('BEND', 1.87/4, 0.2617994/4, 0.105, 0.000, -0.3972, 'BndMPoleSymplectic4Pass');
BEND2  = rbend('BEND', 1.87/4, 0.2617994/4, 0.000, 0.000, -0.3972, 'BndMPoleSymplectic4Pass');
BEND3  = rbend('BEND', 1.87/4, 0.2617994/4, 0.000, 0.000, -0.3972, 'BndMPoleSymplectic4Pass');
BEND4  = rbend('BEND', 1.87/4, 0.2617994/4, 0.000, 0.105, -0.3972, 'BndMPoleSymplectic4Pass');

% nux=10.22, nuy=4.31
%QFA = quadrupole('QFA', 0.18, 1.9682, 'StrMPoleSymplectic4Pass');
%QFB = quadrupole('QFB', 0.18, 1.4111, 'StrMPoleSymplectic4Pass');
QFA = quadrupole('QFA', 0.18, 1.9770, 'StrMPoleSymplectic4Pass');
QFB = quadrupole('QFB', 0.18, 1.4741, 'StrMPoleSymplectic4Pass');
QFC = quadrupole('QFC', 0.26, 2.0068, 'StrMPoleSymplectic4Pass');

% nux=10.2207, nuy=3.29554
%QFA   = quadrupole('QFA', 0.18, 1.67900, 'StrMPoleSymplectic4Pass');
%QFB   = quadrupole('QFB', 0.18, 1.88264, 'StrMPoleSymplectic4Pass');
%QFC   = quadrupole('QFC', 0.26, 2.04000, 'StrMPoleSymplectic4Pass');

% Chromaticity (near 1)
SF = sextupole('SF', 0.192  , +25.0871, 'StrMPoleSymplectic4Pass');
SD = sextupole('SD', 0.192/2, -16.2293, 'StrMPoleSymplectic4Pass');

% Build the lattice
HCELL =	[ones(1,9)*D1 D1A BPM D1B QFA D2A COR D2B QFB D3 BEND1 BEND2 BEND3 BEND4 D4A BPM D4B SD CORSD SD D5 QFC D6 SF];
HCELR =	[D6 QFC D7 SD CORSD SD D8A BPM D8B BEND1 BEND2 BEND3 BEND4 D3 QFB D9A COR D9B QFA D10A BPM D10B ones(1,9)*D1];
CEL   = [HCELL HCELR];
ELIST = [CEL CEL CEL CEL CEL CEL CEL CEL CEL CEL CEL CAV CEL]; 
buildlat(ELIST);


% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   L0 = %.6f     (design length is 170.8800 m)\n', L0_tot)
fprintf('   RF = %.6f MHz  \n', HarmNumber*C0/L0_tot/1e6)

% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

setcavity off;
setradiation off;

clear global FAMLIST

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');

