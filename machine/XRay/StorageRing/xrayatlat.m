function xrayatlat

% X-ray ring lattice.

global FAMLIST THERING GLOBVAL

Energy = 2.80e9;
GLOBVAL.E0 = Energy;  % This might disappear in the future
GLOBVAL.LatticeFile = 'xrayatlat';
FAMLIST = cell(0);

c0       = 299792458; % speed of light in vacuum [m/s]
Harm_Num = 30;

disp('   Loading X-Ray Ring lattice in xrayatlat.m');

%quad_int_meth = 'QuadLinearPass';
quad_int_meth = 'StrMPoleSymplectic4Pass';
%quad_int_meth = 'StrMPoleSymplectic4RadPass';

%bend_int_meth = 'BendLinearPass';
bend_int_meth = 'BndMPoleSymplectic4Pass';
%bend_int_meth = 'BndMPoleSymplectic4RadPass';

AP = aperture('AP', [-0.05, 0.05, -0.05, 0.05], 'AperturePass');

CAV = rfcavity('RF', 0.0, 1e5, 0.0, Harm_Num, 'ThinCavityPass');

% 0.745 GeV (MCF = 0.006807)
% QA = quadrupole('QA', 0.4500, -1.4529, quad_int_meth);
% QB = quadrupole('QB', 0.8000,  1.3873, quad_int_meth);
% QC = quadrupole('QC', 0.4500, -1.4431, quad_int_meth);
% QD = quadrupole('QD', 0.4500,  1.2824, quad_int_meth);

% 2.8 GeV (../LOCO/11/01/04 18-18-37 (MCF = 0.003172, no sextupoles)
% QA = quadrupole('QA', 0.4500, -1.5328, quad_int_meth);
% QB = quadrupole('QB', 0.8000,  1.3669, quad_int_meth);
% QC = quadrupole('QC', 0.4500, -1.3806, quad_int_meth);
% QD = quadrupole('QD', 0.4500,  1.4280, quad_int_meth);
%         (../LOCO/03/21/05 (no LEGS sextupole)
% QA = quadrupole('QA', 0.4500, -1.4570, quad_int_meth);
% QB = quadrupole('QB', 0.8000,  1.3753, quad_int_meth);
% QC = quadrupole('QC', 0.4500, -1.4288, quad_int_meth);
% QD = quadrupole('QD', 0.4500,  1.3750, quad_int_meth);
% Nominal
% QA = quadrupole('QA', 0.4500, -1.5370, quad_int_meth);
% QB = quadrupole('QB', 0.8000,  1.3750, quad_int_meth);
% QC = quadrupole('QC', 0.4500, -1.3835, quad_int_meth);
% QD = quadrupole('QD', 0.4500,  1.3732, quad_int_meth);
% QA = quadrupole('QA', 0.4500, -1.5451, quad_int_meth);
% QB = quadrupole('QB', 0.8000,  1.3751, quad_int_meth);
% QC = quadrupole('QC', 0.4500, -1.3890, quad_int_meth);
% QD = quadrupole('QD', 0.4500,  1.4190, quad_int_meth);
% 08/31/05: No QD-Trims:
% QA = quadrupole('QA', 0.4500, -1.4721, quad_int_meth);
% QB = quadrupole('QB', 0.8000,  1.3723, quad_int_meth);
% QC = quadrupole('QC', 0.4500, -1.4213, quad_int_meth);
% QD = quadrupole('QD', 0.4500,  1.3794, quad_int_meth);
% No QD-Trims, sd(1) error
% QA = quadrupole('QA', 0.4500, -1.4685, quad_int_meth);
% QB = quadrupole('QB', 0.8000,  1.3726, quad_int_meth);
% QC = quadrupole('QC', 0.4500, -1.4233, quad_int_meth);
% QD = quadrupole('QD', 0.4500,  1.3825, quad_int_meth);

% 2.8 GeV (../LOCO/06/27/05 20-09-17 (MCF = , no sextupoles)
QA = quadrupole('QA', 0.4500, -1.5368, quad_int_meth);
QB = quadrupole('QB', 0.8000,  1.3661, quad_int_meth);
QC = quadrupole('QC', 0.4500, -1.3821, quad_int_meth);
QD = quadrupole('QD', 0.4500,  1.4304, quad_int_meth);
k_bend = 0.0037;

SF =  sextupole('SF', 0.20,  2.53838/0.20, 'StrMPoleSymplectic4Pass');
SD =  sextupole('SD', 0.20, -3.85413/0.20, 'StrMPoleSymplectic4Pass');

% k_bend = 0.0040;
phi = 22.5*pi/180.0;
BEND = rbend('BEND', 2.70, phi, phi/2.0, phi/2.0,...
             k_bend, bend_int_meth);

% Skew Quadrupoles (17)
X1SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X2SQ3  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X2SQ8  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X2SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X3SQ8  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X3SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X4SQ3  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X4SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X5SQ3  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X5SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X6SQ3  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X6SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X7SQ8  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X7SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X8SQ3  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X8SQ8  = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');
X8SQ16 = quadrupole('SQ', 0.0, 0.0, 'ThinMPolePass');

% Beam line source points

%X3S =  marker('X3S', 'IdentityPass');

% Injection hardware

XISH =  drift('XISH', 0.438, 'DriftPass');
XFB1 =  drift('XFB1', 0.208, 'DriftPass');
XFB2 =  drift('XFB2', 0.396, 'DriftPass');
XFB3 =  drift('XFB3', 0.208, 'DriftPass');

% Correctors

DT23 =  drift('DT23', 0.115, 'DriftPass');
DT11 =  drift('DT11', 0.055, 'DriftPass');
DT26 =  drift('DT26', 0.129, 'DriftPass');
DT24 =  drift('DT24', 0.121, 'DriftPass');

X1T12 = marker('X1T12', 'IdentityPass');

X1H2  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X2H3  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2H17 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X3H2  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3H3  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3H17 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X4H2  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4H3  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4H17 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X5H2  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5H3  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5H17 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X6H2  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6H3  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X7H3  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7H17 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X8H2  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8H3  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8H5  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8H8  = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8H14 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8H16 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8H17 = corrector('HCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X1V2  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X1V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X2V3  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X2V17 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X3V2  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3V3  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X3V17 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X4V2  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4V3  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X4V17 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X5V2  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5V3  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X5V17 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X6V2  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6V3  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X6V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X7V3  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X7V17 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

X8V2  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8V3  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8V5  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8V8  = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8V14 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8V16 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');
X8V17 = corrector('VCOR', 0.0, [0.0 0.0], 'CorrectorPass');

% Drift

X1D1   = drift('X1D1', 0.651, 'DriftPass');
X1D2   = drift('X1D2', 0.568, 'DriftPass');
X1D2A  = drift('X1D2A', 0.172, 'DriftPass');
X1D3   = drift('X1D3', 0.205, 'DriftPass');
X1D4   = drift('X1D4', 0.0995, 'DriftPass');
X1D5   = drift('X1D5', 0.1475, 'DriftPass');
X1D6   = drift('X1D6', 0.035, 'DriftPass');
X1D7   = drift('X1D7', 0.295, 'DriftPass');
X1D8   = drift('X1D8', 0.159, 'DriftPass');
X1D9   = drift('X1D9', 0.301, 'DriftPass');
X1D10  = drift('X1D10', 0.800, 'DriftPass');
X1D11  = drift('X1D11', 0.367, 'DriftPass');
X1D12  = drift('X1D12', 0.223, 'DriftPass');
X1D13  = drift('X1D13', 0.116, 'DriftPass');
X1D14  = drift('X1D14', 0.034, 'DriftPass');
X1D15  = drift('X1D15', 0.150, 'DriftPass');
X1D16  = drift('X1D16', 0.173, 'DriftPass');
X1D16A = drift('X1D16A', 0.319, 'DriftPass');
X1D17  = drift('X1D17', 0.044, 'DriftPass');
X1D18  = drift('X1D18', 0.756, 'DriftPass');
X1D18A = drift('X1D18A', 0.0, 'DriftPass');
X1D19  = drift('X1D19', 0.311, 'DriftPass');
X1D20  = drift('X1D20', 0.149, 'DriftPass');
X1D21  = drift('X1D21', 0.297, 'DriftPass');
X1D22  = drift('X1D22', 0.033, 'DriftPass');
X1D23  = drift('X1D23', 0.158, 'DriftPass');
X1D24  = drift('X1D24', 0.297, 'DriftPass');
X1D25  = drift('X1D25', 0.040, 'DriftPass');
X1D26  = drift('X1D26', 0.720, 'DriftPass');
X1D27  = drift('X1D27', 1.490, 'DriftPass');

X2D1   = drift('X2D1', 1.490, 'DriftPass');
X2D2   = drift('X2D2', 0.737, 'DriftPass');
X2D3   = drift('X2D3', 0.023, 'DriftPass');
X2D4   = drift('X2D4', 0.328, 'DriftPass');
X2D5   = drift('X2D5', 0.127, 'DriftPass');
X2D6   = drift('X2D6', 0.050, 'DriftPass');
X2D7   = drift('X2D7', 0.280, 'DriftPass');
X2D8   = drift('X2D8', 0.163, 'DriftPass');
X2D9   = drift('X2D9', 0.297, 'DriftPass');
X2D10  = drift('X2D10', 0.800, 'DriftPass');
X2D11  = drift('X2D11', 0.350, 'DriftPass');
X2D12  = drift('X2D12', 0.240, 'DriftPass');
X2D13  = drift('X2D13', 0.120, 'DriftPass');
X2D14  = drift('X2D14', 0.030, 'DriftPass');
X2D14A = drift('X2D14A', 0.150, 'DriftPass');
X2D15  = drift('X2D15', 0.700, 'DriftPass');
X2D16  = drift('X2D16', 0.056, 'DriftPass');
X2D17  = drift('X2D17', 0.744, 'DriftPass');
X2D18  = drift('X2D18', 0.301, 'DriftPass');
X2D19  = drift('X2D19', 0.159, 'DriftPass');
X2D20  = drift('X2D20', 0.297, 'DriftPass');
X2D21  = drift('X2D21', 0.033, 'DriftPass');
X2D22  = drift('X2D22', 0.129, 'DriftPass');
X2D23  = drift('X2D23', 0.326, 'DriftPass');
X2D24  = drift('X2D24', 0.040, 'DriftPass');
X2D25  = drift('X2D25', 0.323, 'DriftPass');
X2D26  = drift('X2D26', 1.657, 'DriftPass');

X3D1   = drift('X3D1', 1.684, 'DriftPass');
X3D2   = drift('X3D2', 0.314, 'DriftPass');
X3D3   = drift('X3D3', 0.022, 'DriftPass');
X3D4   = drift('X3D4', 0.333, 'DriftPass');
X3D5   = drift('X3D5', 0.122, 'DriftPass');
X3D6   = drift('X3D6', 0.050, 'DriftPass');
X3D7   = drift('X3D7', 0.280, 'DriftPass');
X3D8   = drift('X3D8', 0.157, 'DriftPass');
X3D9   = drift('X3D9', 0.303, 'DriftPass');
X3D10  = drift('X3D10', 0.800, 'DriftPass');
X3D11  = drift('X3D11', 0.357, 'DriftPass');
X3D12  = drift('X3D12', 0.233, 'DriftPass');
X3D13  = drift('X3D13', 0.117, 'DriftPass');
X3D14  = drift('X3D14', 0.033, 'DriftPass');
X3D14A = drift('X3D14A', 0.150, 'DriftPass');
X3D15  = drift('X3D15', 0.700, 'DriftPass');
X3D16  = drift('X3D16', 0.052, 'DriftPass');
X3D17  = drift('X3D17', 0.748, 'DriftPass');
X3D18  = drift('X3D18', 0.301, 'DriftPass');
X3D19  = drift('X3D19', 0.159, 'DriftPass');
X3D20  = drift('X3D20', 0.292, 'DriftPass');
X3D21  = drift('X3D21', 0.038, 'DriftPass');
X3D22  = drift('X3D22', 0.164, 'DriftPass');
X3D23  = drift('X3D23', 0.291, 'DriftPass');
X3D24  = drift('X3D24', 0.036, 'DriftPass');
X3D25  = drift('X3D25', 0.354, 'DriftPass');
X3D26  = drift('X3D26', 1.630, 'DriftPass');

X4D1   = drift('X4D1', 1.917, 'DriftPass');
X4D2   = drift('X4D2', 0.065, 'DriftPass');
X4D3   = drift('X4D3', 0.038, 'DriftPass');
X4D4   = drift('X4D4', 0.275, 'DriftPass');
X4D5   = drift('X4D5', 0.180, 'DriftPass');
X4D6   = drift('X4D6', 0.038, 'DriftPass');
X4D7   = drift('X4D7', 0.292, 'DriftPass');
X4D8   = drift('X4D8', 0.155, 'DriftPass');
X4D9   = drift('X4D9', 0.305, 'DriftPass');
X4D10  = drift('X4D10', 0.800, 'DriftPass');
X4D11  = drift('X4D11', 0.367, 'DriftPass');
X4D12  = drift('X4D12', 0.223, 'DriftPass');
X4D13  = drift('X4D13', 0.115, 'DriftPass');
X4D14  = drift('X4D14', 0.035, 'DriftPass');
X4D14A = drift('X4D14A', 0.150, 'DriftPass');
X4D15  = drift('X4D15', 0.700, 'DriftPass');
X4D16  = drift('X4D16', 0.045, 'DriftPass');
X4D17  = drift('X4D17', 0.755, 'DriftPass');
X4D18  = drift('X4D18', 0.308, 'DriftPass');
X4D19  = drift('X4D19', 0.152, 'DriftPass');
X4D20  = drift('X4D20', 0.296, 'DriftPass');
X4D21  = drift('X4D21', 0.034, 'DriftPass');
X4D22  = drift('X4D22', 0.145, 'DriftPass');
X4D23  = drift('X4D23', 0.310, 'DriftPass');
X4D24  = drift('X4D24', 0.041, 'DriftPass');
X4D25  = drift('X4D25', 0.516, 'DriftPass');
X4D26  = drift('X4D26', 1.463, 'DriftPass');

X5D1   = drift('X5D1', 1.464, 'DriftPass');
X5D2   = drift('X5D2', 0.527, 'DriftPass');
X5D3   = drift('X5D3', 0.029, 'DriftPass');
X5D4   = drift('X5D4', 0.249, 'DriftPass');
X5D5   = drift('X5D5', 0.206, 'DriftPass');
X5D6   = drift('X5D6', 0.044, 'DriftPass');
X5D7   = drift('X5D7', 0.286, 'DriftPass');
X5D8   = drift('X5D8', 0.163, 'DriftPass');
X5D9   = drift('X5D9', 0.297, 'DriftPass');
X5D10  = drift('X5D10', 0.800, 'DriftPass');
X5D11  = drift('X5D11', 0.363, 'DriftPass');
X5D12  = drift('X5D12', 0.227, 'DriftPass');
X5D13  = drift('X5D13', 0.113, 'DriftPass');
X5D14  = drift('X5D14', 0.037, 'DriftPass');
X5D14A = drift('X5D14A', 0.150, 'DriftPass');
X5D15  = drift('X5D15', 0.700, 'DriftPass');
X5D16  = drift('X5D16', 0.045, 'DriftPass');
X5D17  = drift('X5D17', 0.755, 'DriftPass');
X5D18  = drift('X5D18', 0.302, 'DriftPass');
X5D19  = drift('X5D19', 0.158, 'DriftPass');
X5D20  = drift('X5D20', 0.294, 'DriftPass');
X5D21  = drift('X5D21', 0.036, 'DriftPass');
X5D22  = drift('X5D22', 0.152, 'DriftPass');
X5D23  = drift('X5D23', 0.303, 'DriftPass');
X5D24  = drift('X5D24', 0.041, 'DriftPass');
X5D25  = drift('X5D25', 0.509, 'DriftPass');
X5D26  = drift('X5D26', 1.470, 'DriftPass');

X6D1   = drift('X6D1', 1.461, 'DriftPass');
X6D2   = drift('X6D2', 0.530, 'DriftPass');
X6D3   = drift('X6D3', 0.029, 'DriftPass');
X6D4   = drift('X6D4', 0.257, 'DriftPass');
X6D5   = drift('X6D5', 0.198, 'DriftPass');
X6D6   = drift('X6D6', 0.041, 'DriftPass');
X6D7   = drift('X6D7', 0.289, 'DriftPass');
X6D8   = drift('X6D8', 0.162, 'DriftPass');
X6D9   = drift('X6D9', 0.298, 'DriftPass');
X6D10  = drift('X6D10', 0.800, 'DriftPass');
X6D11  = drift('X6D11', 0.368, 'DriftPass');
X6D12  = drift('X6D12', 0.222, 'DriftPass');
X6D13  = drift('X6D13', 0.117, 'DriftPass');
X6D14  = drift('X6D14', 0.033, 'DriftPass');
X6D14A = drift('X6D14A', 0.150, 'DriftPass');
X6D15  = drift('X6D15', 0.700, 'DriftPass');
X6D16  = drift('X6D16', 0.047, 'DriftPass');
X6D17  = drift('X6D17', 0.753, 'DriftPass');
X6D18  = drift('X6D18', 0.305, 'DriftPass');
X6D19  = drift('X6D19', 0.155, 'DriftPass');
X6D20  = drift('X6D20', 0.293, 'DriftPass');
X6D21  = drift('X6D21', 0.037, 'DriftPass');
X6D22  = drift('X6D22', 0.138, 'DriftPass');
X6D23  = drift('X6D23', 0.317, 'DriftPass');
X6D24  = drift('X6D24', 0.038, 'DriftPass');
X6D25  = drift('X6D25', 0.0, 'DriftPass');
X6D26  = drift('X6D26', 2.212, 'DriftPass');

X7D1   = drift('X7D1', 2.220, 'DriftPass');
X7D2   = drift('X7D2', 0.0, 'DriftPass');
X7D3   = drift('X7D3', 0.030, 'DriftPass');
X7D4   = drift('X7D4', 0.321, 'DriftPass');
X7D5   = drift('X7D5', 0.134, 'DriftPass');
X7D6   = drift('X7D6', 0.046, 'DriftPass');
X7D7   = drift('X7D7', 0.284, 'DriftPass');
X7D8   = drift('X7D8', 0.156, 'DriftPass');
X7D9   = drift('X7D9', 0.304, 'DriftPass');
X7D10  = drift('X7D10', 0.800, 'DriftPass');
X7D11  = drift('X7D11', 0.356, 'DriftPass');
X7D12  = drift('X7D12', 0.234, 'DriftPass');
X7D13  = drift('X7D13', 0.114, 'DriftPass');
X7D14  = drift('X7D14', 0.036, 'DriftPass');
X7D14A = drift('X7D14A', 0.150, 'DriftPass');
X7D15  = drift('X7D15', 0.700, 'DriftPass');
X7D16  = drift('X7D16', 0.050, 'DriftPass');
X7D17  = drift('X7D17', 0.750, 'DriftPass');
X7D18  = drift('X7D18', 0.310, 'DriftPass');
X7D19  = drift('X7D19', 0.150, 'DriftPass');
X7D20  = drift('X7D20', 0.291, 'DriftPass');
X7D21  = drift('X7D21', 0.039, 'DriftPass');
X7D22  = drift('X7D22', 0.162, 'DriftPass');
X7D23  = drift('X7D23', 0.293, 'DriftPass');
X7D24  = drift('X7D24', 0.036, 'DriftPass');
X7D25  = drift('X7D25', 0.315, 'DriftPass');
X7D26  = drift('X7D26', 1.669, 'DriftPass');

X8D1   = drift('X8D1', 1.653, 'DriftPass');
X8D2   = drift('X8D2', 0.335, 'DriftPass');
X8D3   = drift('X8D3', 0.032, 'DriftPass');
X8D4   = drift('X8D4', 0.250, 'DriftPass');
X8D5   = drift('X8D5', 0.205, 'DriftPass');
X8D6   = drift('X8D6', 0.042, 'DriftPass');
X8D7   = drift('X8D7', 0.288, 'DriftPass');
X8D8   = drift('X8D8', 0.160, 'DriftPass');
X8D9   = drift('X8D9', 0.300, 'DriftPass');
X8D10  = drift('X8D10', 0.800, 'DriftPass');
X8D11  = drift('X8D11', 0.351, 'DriftPass');
X8D12  = drift('X8D12', 0.239, 'DriftPass');
X8D13  = drift('X8D13', 0.117, 'DriftPass');
X8D14  = drift('X8D14', 0.033, 'DriftPass');
X8D15  = drift('X8D15', 0.150, 'DriftPass');
X8D16  = drift('X8D16', 0.173, 'DriftPass');
X8D16A = drift('X8D16A', 0.319, 'DriftPass');
X8D17  = drift('X8D17', 0.056, 'DriftPass');
X8D18  = drift('X8D18', 0.744, 'DriftPass');
X8D18A = drift('X8D18A', 0.306, 'DriftPass');
X8D19  = drift('X8D19', 0.154, 'DriftPass');
X8D20  = drift('X8D20', 0.296, 'DriftPass');
X8D21  = drift('X8D21', 0.034, 'DriftPass');
X8D22  = drift('X8D22', 0.150, 'DriftPass');
X8D23  = drift('X8D23', 0.305, 'DriftPass');
X8D24  = drift('X8D24', 0.037, 'DriftPass');
X8D25  = drift('X8D25', 0.114, 'DriftPass');
X8D26  = drift('X8D26', 1.857, 'DriftPass');

% Markers and Pick-ups

CS1 = marker('CS1', 'IdentityPass');
CS2 = marker('CS2', 'IdentityPass');
CS3 = marker('CS3', 'IdentityPass');
CS4 = marker('CS4', 'IdentityPass');
CS5 = marker('CS5', 'IdentityPass');
CS6 = marker('CS6', 'IdentityPass');
CS7 = marker('CS7', 'IdentityPass');
CS8 = marker('CS8', 'IdentityPass');

BPM = marker('BPM', 'IdentityPass');


% Lattice description

% Superperiod #1:                                                                
OCT1 = [CS1, X1D1, BPM, X1D2, XFB2, X1D2A, DT26, X1H2, DT26, X1D3, ...
        QA, X1D4, XISH, X1D5, ...
        QB, X1D6, BPM, X1D7, ...                                           
        QC, X1D8, DT23, X1H5, X1V5, DT23, X1D9, ...
        BEND, X1D10, SD, X1D11, DT11, X1H8, X1V8, DT11, X1D12, ...        
        SF, X1D13, BPM, X1D14, QD, X1D15, SF, ...
        X1D16, XFB3, X1D16A, SD, ...
        X1D17, BPM, X1D18, X1T12, X1D18A, BEND, ...
        X1D19, DT23, X1H14, X1V14, DT23, X1D20, QC, ...
        X1D21, BPM, X1D22, QB, ...
        X1D23, DT23, X1H16, X1SQ16, X1V16, DT23, X1D24, QA, ...
        X1D25, BPM, X1D26, X1D27];                                        

% Superperiod #2:                                                                
OCT2 = [CS2, X2D1, X2D2, BPM, X2D3, ...                                     
        QA, X2D4, DT23, X2H3, X2SQ3, X2V3, DT23, X2D5, ...                         
        QB, X2D6, BPM, X2D7, ...                                           
        QC, X2D8, DT23, X2H5, X2V5, DT23, X2D9, ...                         
        BEND, X2D10, SD, X2D11, DT11, X2H8, X2SQ8, X2V8, DT11, X2D12, ...        
        SF, X2D13, BPM, X2D14, QD, X2D14A, SF, ...                     
        X2D15, SD, X2D16, BPM, X2D17, BEND, ...                         
        X2D18, DT23, X2H14, X2V14, DT23, X2D19, QC, ...                     
        X2D20, BPM, X2D21, QB, ...                                        
        X2D22, DT23, X2H16, X2SQ16, X2V16, DT23, X2D23, QA, ...                     
        X2D24, BPM, X2D25, DT23, X2H17, DT23, X2D26];             

% Superperiod #3:                                                                
OCT3 = [CS3, X3D1, DT23, X3H2, DT23, X3D2, BPM, X3D3, ...            
        QA, X3D4, DT23, X3H3, X3V3, DT23, X3D5, ...                         
        QB, X3D6, BPM, X3D7, ...                                          
        QC, X3D8, DT23, X3H5, X3V5, DT23, X3D9, ...                         
        BEND, X3D10, SD, X3D11, DT11, X3H8, X3SQ8, X3V8, DT11, X3D12, ...        
        SF, X3D13, BPM, X3D14, QD, X3D14A, SF, ...                    
        X3D15, SD, X3D16, BPM, X3D17, BEND, ...                         
        X3D18, DT23, X3H14, X3V14, DT23, X3D19, QC, ...                     
        X3D20, BPM, X3D21, QB, ...                                        
        X3D22, DT23, X3H16, X3SQ16, X3V16, DT23, X3D23, QA, ...                     
        X3D24, BPM, X3D25, DT23, X3H17, DT23, X3D26];             

% Superperiod #4:                                                                
OCT4 = [CS4, X4D1, DT23, X4H2, DT23, X4D2, BPM, X4D3, ...            
        QA, X4D4, DT23, X4H3, X4SQ3, X4V3, DT23, X4D5, ...                         
        QB, X4D6, BPM, X4D7, ...                                          
        QC, X4D8, DT23, X4H5, X4V5, DT23, X4D9, ...                         
        BEND, X4D10, SD, X4D11, DT11, X4H8, X4V8, DT11, X4D12, ...        
        SF, X4D13, BPM, X4D14, QD, X4D14A, SF, ...                    
        X4D15, SD, X4D16, BPM, X4D17, BEND, ...                         
        X4D18, DT23, X4H14, X4V14, DT23, X4D19, QC, ...                     
        X4D20, BPM, X4D21, QB, ...                                        
        X4D22, DT23, X4H16, X4SQ16, X4V16, DT23, X4D23, QA, ...                     
        X4D24, BPM, X4D25, DT23, X4H17, DT23, X4D26];             
          
% Superperiod #5:                                                                
OCT5 = [CS5, X5D1, DT23, X5H2, DT23, X5D2, BPM, X5D3, ...            
        QA, X5D4, DT23, X5H3, X5SQ3, X5V3, DT23, X5D5, ...                         
        QB, X5D6, BPM, X5D7, ...                                          
        QC, X5D8, DT23, X5H5, X5V5, DT23, X5D9, ...                         
        BEND, X5D10, SD, X5D11, DT11, X5H8, X5V8, DT11, X5D12, ...        
        SF, X5D13, BPM, X5D14, QD, X5D14A, SF, ...                   
        X5D15, SD, X5D16, BPM, X5D17, BEND, ...                        
        X5D18, DT23, X5H14, X5V14, DT23, X5D19, QC, ...                    
        X5D20, BPM, X5D21, QB, ...                                       
        X5D22, DT23, X5H16, X5SQ16, X5V16, DT23, X5D23, QA, ...                    
        X5D24, BPM, X5D25, DT23, X5H17, DT23, X5D26];             

% Superperiod #6:                                                                
OCT6 = [CS6, X6D1, DT23, X6H2, DT23, X6D2, BPM, X6D3, ...            
        QA, X6D4, DT23, X6H3, X6SQ3, X6V3, DT23, X6D5, ...                        
        QB, X6D6, BPM, X6D7, ...                                         
        QC, X6D8, DT23, X6H5, X6V5, DT23, X6D9, ...                        
        BEND, X6D10, SD, X6D11, DT11, X6H8, X6V8, DT11, X6D12, ...       
        SF, X6D13, BPM, X6D14, QD, X6D14A, SF, ...                  
        X6D15, SD, X6D16, BPM, X6D17, BEND, ...                        
        X6D18, DT23, X6H14, X6V14, DT23, X6D19, QC, ...                    
        X6D20, BPM, X6D21, QB, ...                                       
        X6D22, DT23, X6H16, X6SQ16, X6V16, DT23, X6D23, QA, ...                    
        X6D24, BPM, X6D25, X6D26];                                       

% Superperiod #7:                                                                
OCT7 = [CS7, X7D1, X7D2, BPM, X7D3, ...                                    
        QA, X7D4, DT23, X7H3, X7V3, DT23, X7D5, ...                        
        QB, X7D6, BPM, X7D7, ...                                         
        QC, X7D8, DT23, X7H5, X7V5, DT23, X7D9, ...                        
        BEND, X7D10, SD, X7D11, DT11, X7H8, X7SQ8, X7V8, DT11, X7D12, ...       
        SF, X7D13, BPM, X7D14, QD, X7D14A, SF, ...                  
        X7D15, SD, X7D16, BPM, X7D17, BEND, ...                        
        X7D18, DT23, X7H14, X7V14, DT23, X7D19, QC, ...                    
        X7D20, BPM, X7D21, QB, ...                                       
        X7D22, DT23, X7H16, X7SQ16, X7V16, DT23, X7D23, QA, ...                    
        X7D24, BPM, X7D25, DT23, X7H17, DT23, X7D26];             

% Superperiod #8                                                                 
OCT8 = [CS8, X8D1, DT23, X8H2, DT23, X8D2, BPM, X8D3, ...            
        QA, X8D4, DT23, X8H3, X8SQ3, X8V3, DT23, X8D5, ...                        
        QB, X8D6, BPM, X8D7, ...                                         
        QC, X8D8, DT23, X8H5, X8V5, DT23, X8D9, ...                        
        BEND, X8D10, SD, X8D11, DT11, X8H8, X8SQ8, X8V8, DT11, X8D12, ...  
        SF, X8D13, BPM, X8D14, QD, X8D15, SF, ...                   
        X8D16, XFB1, X8D16A, SD, X8D17, BPM, X8D18, BEND, ...          
        X8D18A, DT23, X8H14, X8V14, DT23, X8D19, QC, ...                   
        X8D20, BPM, X8D21, QB, ...                                       
        X8D22, DT23, X8H16, X8SQ16, X8V16, DT23, X8D23, QA, ...                    
        X8D24, BPM, X8D25, DT24, X8H17, DT24, X8D26];             


RING = [OCT1, OCT2, OCT3, OCT4, OCT5, OCT6, OCT7, OCT8, CAV];

buildlat(RING);

% compute total length and RF frequency
C = 0.0;
for i = 1:length(THERING)
   C = C + THERING{i}.Length;
end

fprintf('   C = %4.2f m, f_RF = %8.6f MHz\n', C, Harm_Num*c0/(C*1e6))

RFI = findcells(THERING, 'FamName', 'RF');
THERING = setcellstruct(THERING, 'Frequency', RFI(1:length(RFI)), Harm_Num*c0/C);

if 0
    BENDI = findcells(THERING, 'FamName', 'BEND');
    QAI = findcells(THERING, 'FamName', 'QA');
    QBI = findcells(THERING, 'FamName', 'QB');
    QCI = findcells(THERING, 'FamName', 'QC');
    QDI = findcells(THERING, 'FamName', 'QD');
    QSQI = findcells(THERING, 'FamName', 'SQ');
    
    home_dir = '/mnts/datafiles/pfiles/xraymodel/xray/';
    LOCO_dir = 'xraydata/user/LOCO/';
    file_name = '2005-06-27/prm_57_1';

    p = load([home_dir, LOCO_dir, file_name]);
    
    BENDValue = p.FitParameters(end).Values(1);
    QAValues = p.FitParameters(end).Values(2:17);
    QBValues = p.FitParameters(end).Values(18:33);
    QCValues = p.FitParameters(end).Values(34:49);
    QDValues = p.FitParameters(end).Values(50:57);
    
    THERING = setcellstruct(THERING, 'K', BENDI(1:length(QAI)), BENDValue);
    THERING = setcellstruct(THERING, 'K', QAI(1:length(QAI)), QAValues);
    THERING = setcellstruct(THERING, 'K', QBI(1:length(QBI)), QBValues);
    THERING = setcellstruct(THERING, 'K', QCI(1:length(QCI)), QCValues);
    THERING = setcellstruct(THERING, 'K', QDI(1:length(QDI)), QDValues);
    % AT b..l s..t
    THERING = setcellstruct(THERING, 'PolynomB', BENDI(1:length(BENDI)), BENDValue, 2);
    THERING = setcellstruct(THERING, 'PolynomB', QAI(1:length(QAI)), QAValues, 2);
    THERING = setcellstruct(THERING, 'PolynomB', QBI(1:length(QBI)), QBValues, 2);
    THERING = setcellstruct(THERING, 'PolynomB', QCI(1:length(QCI)), QCValues, 2);
    THERING = setcellstruct(THERING, 'PolynomB', QDI(1:length(QDI)), QDValues, 2);
end

if 0
    QuadSQValues = load([home_dir, 'a2.03.29.05.mat']);
    
    QBSQValues = QuadSQValues.a2_QB; QCSQValues = QuadSQValues.a2_QC;
    QDSQValues = QuadSQValues.a2_QD;
    
    THERING = setcellstruct(THERING, 'PolynomA', QBI(1:length(QBI)), QBSQValues, 2);
    THERING = setcellstruct(THERING, 'PolynomA', QCI(1:length(QCI)), QCSQValues, 2);
    THERING = setcellstruct(THERING, 'PolynomA', QDI(1:length(QDI)), QDSQValues, 2);
end

% THERING = setcellstruct(THERING, 'K', QDI(1),  11.4982*6.11e-3);
% THERING = setcellstruct(THERING, 'K', QDI(2),  -1.0555*6.11e-3);
% THERING = setcellstruct(THERING, 'K', QDI(3), -11.4982*6.11e-3);
% THERING = setcellstruct(THERING, 'K', QDI(4), -10.6630*6.11e-3);
% THERING = setcellstruct(THERING, 'K', QDI(5),  -7.8911*6.11e-3);
% THERING = setcellstruct(THERING, 'K', QDI(6),  -8.9107*6.11e-3);
% THERING = setcellstruct(THERING, 'K', QDI(7), -11.4982*6.11e-3);
% THERING = setcellstruct(THERING, 'K', QDI(8),  -8.8909*6.11e-3);

%THERING = setcellstruct(THERING, 'PolynomA', QSQI(5),  -8.0*4.4e-3*0.17, 2);

%evalin('caller', 'global THERING FAMLIST GLOBVAL');


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% clear LOSSFLAG ???
clear global FAMLIST
%clear global GLOBVAL when GWig... has been changed.


%disp('** Done **');
