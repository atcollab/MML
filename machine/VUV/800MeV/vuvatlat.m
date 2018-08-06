function vuvatlat
%VUVATLAT - VUV storage ring AT lattice

global FAMLIST GLOBVAL

GLOBVAL.E0 = 0.808e9;
GLOBVAL.LatticeFile = 'vuvatlat';
FAMLIST = cell(0);


disp('   Loading VUV Ring lattice in vuvatlat.m');


% AP = aperture('AP', [-0.04, 0.04, -0.02, 0.02], 'AperturePass');

C       = 51.024;    % circumference [m]
c0      = 299792458; % speed of light in vacuum [m/s]
Har_Num = 9;
CAV = rfcavity('RF', 0.0, 5e4, Har_Num*c0/C, Har_Num, 'ThinCavityPass');

% Main magnets

% Dipoles

%bend_int_meth = 'BendLinearPass';
bend_int_meth = 'BndMPoleSymplectic4Pass';
%bend_int_meth = 'BndMPoleSymplectic4RadPass';

BD = rbend('BEND', 1.50, pi/4.0, pi/8.0, pi/8.0, -0.026784, bend_int_meth);

% Quadrupoles

quad_int_meth = 'QuadLinearPass';
%quad_int_meth = 'StrMPoleSymplectic4Pass';
%quad_int_meth = 'StrMPoleSymplectic4RadPass';

Q1 = quadrupole('Q1', 0.300,  1.8681, quad_int_meth);
Q2 = quadrupole('Q2', 0.300, -1.1964, quad_int_meth);
Q3 = quadrupole('Q3', 0.300,  1.8696, quad_int_meth);
Q4 = quadrupole('Q4', 0.300, -1.3031, quad_int_meth);
Q5 = quadrupole('Q5', 0.300,  1.9396, quad_int_meth);
Q6 = quadrupole('Q6', 0.300, -1.1645, quad_int_meth);
Q7 = quadrupole('Q7', 0.300,  1.8917, quad_int_meth);

% Skew Quadrupoles

SQ1 = quadrupole('SQ1', 0.00,  0.0, 'ThinMPolePass');
%SQ2 = quadrupole('SQ2', 0.00,  0.0, 'ThinMPolePass');

% Sextupoles

SF =  sextupole('SF', 0.20,  28.03, 'StrMPoleSymplectic4Pass');
SD =  sextupole('SD', 0.20, -15.66, 'StrMPoleSymplectic4Pass');


% Injection hardware

BUISH  =  drift('BUISH',  0.75, 'DriftPass');
BUIFB1 =  drift('BUIFB1', 0.10, 'DriftPass');
BUIFB2 =  drift('BUIFB2', 0.10, 'DriftPass');
BUIFB3 =  drift('BUIFB3', 0.10, 'DriftPass');

% Correctors

U1HS1   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U1HS2   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U1HS3   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U1HS4   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U2HS5   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U2HS6   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U2HS7   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U2HS8   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U3HS9   = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U3HS10  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U3HS11  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U3HS12  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U4HS13  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U4HS14  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U4HS15  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Backleg
U4HS16  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

U1VS1   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U1VS2   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U1VS3   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U1VS4   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U2VS5   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U2VS6   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U2VS7   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U2VS8   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U3VS9   = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U3VS10  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U3VS11  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U3VS12  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U4VS13  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
U4VS14  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U4VS15  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass'); % Air core
U4VS16  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

% Drifts

INJD1   = drift('INJD1', 0.97, 'DriftPass');
INJD2   = drift('INJD2', 0.78, 'DriftPass');
INJD3   = drift('INJD3', 0.35, 'DriftPass');

U1D1   = drift('U1D1',  0.102, 'DriftPass');
U1D2   = drift('U1D2',  0.051, 'DriftPass');
U1D3   = drift('U1D3',  0.175, 'DriftPass');
U1D4   = drift('U1D4',  0.175, 'DriftPass');
U1D5   = drift('U1D5',  0.025, 'DriftPass');
U1D6   = drift('U1D6',  0.625, 'DriftPass');
U1D7   = drift('U1D7',  0.155, 'DriftPass');
U1D8   = drift('U1D8',  0.155, 'DriftPass');
U1D9   = drift('U1D9',  0.037, 'DriftPass');
U1D10  = drift('U1D10', 0.173, 'DriftPass');
U1D11  = drift('U1D11', 0.180, 'DriftPass');
U1D12  = drift('U1D12', 0.250, 'DriftPass');
U1D13  = drift('U1D13', 0.250, 'DriftPass');
U1D14  = drift('U1D14', 0.035, 'DriftPass');
U1D15  = drift('U1D15', 0.455, 'DriftPass');
U1D16  = drift('U1D16', 0.155, 'DriftPass');
U1D17  = drift('U1D17', 0.155, 'DriftPass');
U1D18  = drift('U1D18', 0.625, 'DriftPass');
U1D19  = drift('U1D19', 0.025, 'DriftPass');
U1D20  = drift('U1D20', 0.175, 'DriftPass');
U1D21  = drift('U1D21', 0.175, 'DriftPass');
U1D22  = drift('U1D22', 0.048, 'DriftPass');
U1D23  = drift('U1D23', 0.105, 'DriftPass');

U5D    = drift('U5D',   2.950, 'DriftPass');

U2D1   = drift('U2D1',  0.102, 'DriftPass');
U2D2   = drift('U2D2',  0.051, 'DriftPass');
U2D3   = drift('U2D3',  0.175, 'DriftPass');
U2D4   = drift('U2D4',  0.175, 'DriftPass');
U2D5   = drift('U2D5',  0.025, 'DriftPass');
U2D6   = drift('U2D6',  0.625, 'DriftPass');
U2D7   = drift('U2D7',  0.155, 'DriftPass');
U2D8   = drift('U2D8',  0.155, 'DriftPass');
U2D9   = drift('U2D9',  0.454, 'DriftPass');
U2D10  = drift('U2D10', 0.036, 'DriftPass');
U2D11  = drift('U2D11', 0.250, 'DriftPass');
U2D12  = drift('U2D12', 0.250, 'DriftPass');
U2D13  = drift('U2D13', 0.040, 'DriftPass');
U2D14  = drift('U2D14', 0.450, 'DriftPass');
U2D15  = drift('U2D15', 0.155, 'DriftPass');
U2D16  = drift('U2D16', 0.155, 'DriftPass');
U2D17  = drift('U2D17', 0.612, 'DriftPass');
U2D18  = drift('U2D18', 0.038, 'DriftPass');
U2D19  = drift('U2D19', 0.175, 'DriftPass');
U2D20  = drift('U2D20', 0.175, 'DriftPass');
U2D21  = drift('U2D21', 0.038, 'DriftPass');
U2D22  = drift('U2D22', 0.115, 'DriftPass');

RFD1   = drift('RFD1',  1.445, 'DriftPass');
RFD2   = drift('RFD2',  1.505, 'DriftPass');

U3D1   = drift('U3D1',  0.115, 'DriftPass');
U3D2   = drift('U3D2',  0.038, 'DriftPass');
U3D3   = drift('U3D3',  0.175, 'DriftPass');
U3D4   = drift('U3D4',  0.175, 'DriftPass');
U3D5   = drift('U3D5',  0.038, 'DriftPass');
U3D6   = drift('U3D6',  0.612, 'DriftPass');
U3D7   = drift('U3D7',  0.155, 'DriftPass');
U3D8   = drift('U3D8',  0.155, 'DriftPass');
U3D9   = drift('U3D9',  0.450, 'DriftPass');
U3D10  = drift('U3D10', 0.040, 'DriftPass');
U3D11  = drift('U3D11', 0.250, 'DriftPass');
U3D12  = drift('U3D12', 0.250, 'DriftPass');
U3D13  = drift('U3D13', 0.038, 'DriftPass');
U3D14  = drift('U3D14', 0.452, 'DriftPass');
U3D15  = drift('U3D15', 0.155, 'DriftPass');
U3D16  = drift('U3D16', 0.155, 'DriftPass');
U3D17  = drift('U3D17', 0.629, 'DriftPass');
U3D18  = drift('U3D18', 0.021, 'DriftPass');
U3D19  = drift('U3D19', 0.175, 'DriftPass');
U3D20  = drift('U3D20', 0.175, 'DriftPass');
U3D21  = drift('U3D21', 0.053, 'DriftPass');
U3D22  = drift('U3D22', 0.100, 'DriftPass');

U13D   = drift('U13D',  2.950, 'DriftPass');

U4D1   = drift('U4D1',  0.102, 'DriftPass');
U4D2   = drift('U4D2',  0.051, 'DriftPass');
U4D3   = drift('U4D3',  0.175, 'DriftPass');
U4D4   = drift('U4D4',  0.175, 'DriftPass');
U4D5   = drift('U4D5',  0.021, 'DriftPass');
U4D6   = drift('U4D6',  0.629, 'DriftPass');
U4D7   = drift('U4D7',  0.155, 'DriftPass');
U4D8   = drift('U4D8',  0.155, 'DriftPass');
U4D9   = drift('U4D9',  0.455, 'DriftPass');
U4D10  = drift('U4D10', 0.035, 'DriftPass');
U4D11  = drift('U4D11', 0.250, 'DriftPass');
U4D12  = drift('U4D12', 0.250, 'DriftPass');
U4D13  = drift('U4D13', 0.180, 'DriftPass');
U4D14  = drift('U4D14', 0.177, 'DriftPass');
U4D15  = drift('U4D15', 0.033, 'DriftPass');
U4D16  = drift('U4D16', 0.155, 'DriftPass');
U4D17  = drift('U4D17', 0.155, 'DriftPass');
U4D18  = drift('U4D18', 0.612, 'DriftPass');
U4D19  = drift('U4D19', 0.038, 'DriftPass');
U4D20  = drift('U4D20', 0.175, 'DriftPass');
U4D21  = drift('U4D21', 0.175, 'DriftPass');
U4D22  = drift('U4D22', 0.038, 'DriftPass');
U4D23  = drift('U4D23', 0.115, 'DriftPass');

% Pick-ups

BPM   = marker('BPM',  'IdentityPass');


% Lattice description

% Injection Straight Section

INJSTRT = [INJD1,BUIFB2,INJD2,BUISH,INJD3];

% Quadrant #1

SEC1 = [U1D1, BPM, U1D2, Q1, U1D3, U1HS1, U1VS1, SQ1, U1D4, ...
        Q2, U1D5, BPM, U1D6, U1HS2, BD, U1D7, U1VS2, U1D8, SD, U1D9, ...
        BPM, U1D10, BUIFB3, U1D11, Q3, U1D12, SF, U1D13, Q3, ...
        U1D14, BPM, U1D15, SD, U1D16, U1VS3, U1D17, BD, U1HS3, U1D18, ...
        BPM, U1D19, Q4, U1D20, U1VS4, U1HS4, U1D21, Q5, ...
        U1D22, BPM, U1D23];
                                                                
% U5 Undulator Straight Section                                    

U5STRT = U5D;


% Quadrant #2

SEC2 = [U2D1, BPM, U2D2, Q5, U2D3, U2HS5, U2VS5, SQ1, U2D4, ...
        Q4, U2D5, BPM, U2D6, U2HS6, BD, U2D7, U2VS6, U2D8, SD, U2D9, ...
        BPM, U2D10, Q3, U2D11, SF, U2D12, Q3, U2D13, BPM, ...
        U2D14, SD, U2D15, U2VS7, U2D16, BD, U2HS7, U2D17, BPM, ...
        U2D18, Q2, U2D19, U2VS8, U2HS8, U2D20, Q1, ...
        U2D21, BPM, U2D22];

% RF Straight Section

RFSTRT = [RFD1,CAV,RFD2];


% Quadrant #3

SEC3 = [U3D1, BPM, U3D2, Q1, U3D3, U3HS9, U3VS9, SQ1, U3D4, ...
        Q2, U3D5, BPM, U3D6, U3HS10, BD, U3D7, U3VS10, U3D8, SD, ...
        U3D9, BPM, U3D10, Q3, U3D11, SF, U3D12, Q3, U3D13, ...
        BPM, U3D14, SD, U3D15, U3VS11, U3D16, BD, U3HS11, U3D17, ...
        BPM, U3D18, Q6, U3D19, U3VS12, U3HS12, U3D20, Q7, ...
        U3D21, BPM, U3D22];

% Undulator U13 Straight Section

U13STRT = U13D;

% Quadrant #4

SEC4 = [U4D1, BPM, U4D2, Q7, U4D3, U4HS13, U4VS13, SQ1, U4D4, ...
        Q6, U4D5, BPM, U4D6, U4HS14, BD, U4D7, U4VS14, U4D8, SD, ...
        U4D9,BPM,U4D10,Q3,U4D11,SF, U4D12, Q3, U4D13, BUIFB1, ...
        U4D14, BPM, U4D15, SD, U4D16, U4VS15, U4D17, BD, U4HS15, U4D18, ...
        BPM, U4D19, Q2, U4D20, U4VS16, U4HS16, U4D21, Q1, ...
        U4D22, BPM, U4D23];


RING = [INJSTRT, SEC1, U5STRT, SEC2, RFSTRT, SEC3, U13STRT, SEC4];

buildlat(RING);


%evalin('caller', 'global THERING FAMLIST GLOBVAL');
