function varargout = btslattice(varargin)
% BTS lattice definition file


global THERING 


% Energy
if nargin >=1 
    Energy = varargin{1};
else
    Energy = 1.9e9;
end


% Aperture size ???
%AP =  aperture('AP',  [-0.2, 0.2, -0.1, 0.1], 'AperturePass');
AP =  aperture('AP',  [-10, 10, -10, 10], 'AperturePass');

START = marker('START', 'IdentityPass');
BPM   = marker('BPM', 'IdentityPass');


% Correctors
Lcm = 6*.0254;  % 6 inches is the physical length of the iron core
HCM = corrector('HCM', Lcm, [0 0], 'CorrectorPass');
VCM = corrector('VCM', Lcm, [0 0], 'CorrectorPass');


% Last booster quad
QD  = quadrupole('QD', 1.0E-001,-2.3256700, 'StrMPoleSymplectic4RadPass');


% Lattice in order without BPMs and correctors
L1  = drift('L1', 2.0048900E-001, 'DriftPass');
SEN = rbend('SEN', .6, -2.0*pi/180, -1.0*pi/180, -1.0*pi/180, 0, 'BndMPoleSymplectic4RadPass');
%SEN = rbend('SEN', .6, .0, 0.0, 0, 0, 'BndMPoleSymplectic4RadPass');
L2  = drift('L2', 2.0E-001, 'DriftPass');
SEK = rbend('SEK', .9, -10.0*pi/180, -5.0*pi/180, -5.0*pi/180, 0, 'BndMPoleSymplectic4RadPass');
%SEK = rbend('SEK', .9, 0, 0, 0, 0.0, 'BndMPoleSymplectic4RadPass');
L3  = drift('L3', .798989-Lcm/2, 'DriftPass');
% HCM
L4  = drift('L4', .648535-Lcm/2, 'DriftPass');
% BPM
L5  = drift('L5', .382917-Lcm/2, 'DriftPass');
% VCM
L6  = drift('L6', .300000-Lcm/2, 'DriftPass');
TV1 = marker('TV', 'IdentityPass');
L7  = drift('L7', .2, 'DriftPass');
Q1  = quadrupole('Q', .3, 1.3921, 'StrMPoleSymplectic4RadPass');
L8  = drift('L8', .20-Lcm/2, 'DriftPass');
% HCM
L9  = drift('L9', .25-Lcm, 'DriftPass');
% VCM
L10 = drift('L10', 3.4095580-Lcm/2, 'DriftPass');
TV2 = marker('TV', 'IdentityPass');
L11 = drift('L11', 2.0E-001, 'DriftPass');
Q21 = quadrupole('Q', 3.0E-001,-6.1290000E-001, 'StrMPoleSymplectic4RadPass');
L12 = drift('L12', 3.0E-001, 'DriftPass');
Q22 = quadrupole('Q', 3.0E-001,-2.9980000E-001, 'StrMPoleSymplectic4RadPass');
L13 = drift('L13', .16-Lcm/2, 'DriftPass');
% HCM
L14 = drift('L14', .175-Lcm, 'DriftPass');
% VCM
L15 = drift('L15', .452-Lcm/2, 'DriftPass');
B1  = rbend('BEND', 1.4, 20*pi/180, 10*pi/180, 10*pi/180, 0, 'BndMPoleSymplectic4RadPass');
L16 = drift('L16', 1.6685430, 'DriftPass');
% BPM
L17 = drift('L17', 3.5642900E-001, 'DriftPass');
Q31 = quadrupole('Q', 3.0E-001,-3.9970000E-001, 'StrMPoleSymplectic4RadPass');
L18 = drift('L18', 3.0E-001, 'DriftPass');
Q32 = quadrupole('Q', 3.0E-001, 1.6189000, 'StrMPoleSymplectic4RadPass');
L19 = drift('L19', .15-Lcm/2, 'DriftPass');
% HCM
L20 = drift('L20', .175-Lcm, 'DriftPass');
% VCM
L21 = drift('L21', .20-Lcm/2, 'DriftPass');
TV3 = marker('TV', 'IdentityPass');
L22 = drift('L22', 1.1710280, 'DriftPass');
B2  = rbend('BEND', 1.4, 20*pi/180, 10*pi/180, 10*pi/180, 0.0, 'BndMPoleSymplectic4RadPass');
L23 = drift('L23', 6.0719400E-001, 'DriftPass');
Q4  = quadrupole('Q', 3.0E-001, 2.2984000, 'StrMPoleSymplectic4RadPass');
L24 = drift('L24', 3.0359400E-001, 'DriftPass');
TV4 = marker('TV', 'IdentityPass');
L25 = drift('L25', 1.1918470-Lcm/2, 'DriftPass');
% HCM
L26 = drift('L26', .175-Lcm, 'DriftPass');
% VCM
L27 = drift('L27', .15-Lcm/2, 'DriftPass');
Q51 = quadrupole('Q', 3.0E-001,-2.9246000, 'StrMPoleSymplectic4RadPass');
L28 = drift('L28', 3.0E-001, 'DriftPass');
Q52 = quadrupole('Q', 3.0E-001, 2.7048000, 'StrMPoleSymplectic4RadPass');
L29 = drift('L29', 2.0426500E-001, 'DriftPass');
% BPM
L30 = drift('L30', 9.1510000E-001, 'DriftPass');
B3  = rbend('BEND', 1.4, 20*pi/180, 10*pi/180, 10*pi/180, 0, 'BndMPoleSymplectic4RadPass');
L31 = drift('L31', .579682-Lcm/2, 'DriftPass');
% HCM
L32 = drift('L32', .175-Lcm, 'DriftPass');
% VCM
L33 = drift('L33', 2.3067730-Lcm/2, 'DriftPass');
% BPM
L34 = drift('L34', 3.5634900E-001, 'DriftPass');
Q61 = quadrupole('Q', 3.0E-001, 2.1585000, 'StrMPoleSymplectic4RadPass');
L35 = drift('L35', 3.0E-001, 'DriftPass');
Q62 = quadrupole('Q', 3.0E-001,-2.0719000, 'StrMPoleSymplectic4RadPass');
L36 = drift('L36', .149446-Lcm/2, 'DriftPass');
% HCM
L37 = drift('L37', .175-Lcm, 'DriftPass');
% VCM
L38 = drift('L38', .87103-Lcm/2, 'DriftPass');
B4  = rbend('BEND', 1.3989, 18.4*pi/180, 9.2*pi/180, 9.2*pi/180, 0.0, 'BndMPoleSymplectic4RadPass');
L39 = drift('L39', 6.8926600E-001, 'DriftPass');
TV5 = marker('TV', 'IdentityPass');
L40 = drift('L40', 1.3422340, 'DriftPass');
% BPM
L41 = drift('L41', 3.5634900E-001, 'DriftPass');
Q7  = quadrupole('Q', 3.0E-001, 1.7455000, 'StrMPoleSymplectic4RadPass');
L42 = drift('L42', .20-Lcm/2, 'DriftPass');
% HCM
L43 = drift('L43', .25-Lcm, 'DriftPass');
% VCM
L44 = drift('L44', 1.3856790-Lcm/2, 'DriftPass');
% BPM
L45 = drift('L45', .955427-Lcm/2, 'DriftPass');
% HCM
L46 = drift('L46', .24727900-Lcm, 'DriftPass');
% VCM
L47 = drift('L47', .392873-Lcm/2, 'DriftPass');
TV6 = marker('TV', 'IdentityPass');
L48 = drift('L48', 8.0712800E-001, 'DriftPass');
SIK = rbend('SIK', 9.0E-1, 10.07*pi/180, 10.07*pi/180, 0.0*pi/180, 0.0, 'BndMPoleSymplectic4RadPass');
L49 = drift('L49', 2.7700000E-001, 'DriftPass');
SIN = rbend('SIN', .6, 2.0*pi/180, 2.0*pi/180, 0.0*pi/180, 0.0, 'BndMPoleSymplectic4RadPass');
L50 = drift('L50', 2.2743000E-001, 'DriftPass');
SRBMP3 = rbend('SRBMP3', .7, 0, 0, 0, 0, 'BndMPoleSymplectic4RadPass');
SRBMP4 = rbend('SRBMP4', .7, 0, 0, 0, 0, 'BndMPoleSymplectic4RadPass');
L51 = drift('L51', 3.0E-001, 'DriftPass');
CTR_SRQF = marker('CTR_SRQF', 'IdentityPass');

% Location?
SRTV1 = marker('TV', 'IdentityPass');

% QF?
BTS = [START AP L1 SEN L2 SEK L3 HCM L4 BPM L5 VCM L6 TV1 L7 Q1 L8 HCM L9 VCM ...
L10 TV2 L11 Q21 L12 Q22 L13 HCM L14 VCM L15 B1 L16 BPM L17 Q31 L18 Q32 ...
L19 HCM L20 VCM L21 TV3 L22 B2 L23 Q4 L24 TV4 L25 HCM L26 VCM L27 Q51 L28 Q52 ...
L29 BPM L30 B3 L31 HCM L32 VCM L33 BPM L34 Q61 L35 Q62 L36 HCM L37 VCM L38 B4 ...
L39 TV5 L40 BPM L41 Q7 L42 HCM L43 VCM L44 BPM L45 HCM L46 VCM L47 TV6 L48 SIK L49 SIN ... 
L50 SRBMP3 L50 SRBMP4 L51 CTR_SRQF SRTV1];


buildlat(BTS);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

L0 = findspos(THERING, length(THERING)+1);
fprintf('   BTS Length = %.6f meters  \n', L0)


% Add the magnet measurements data for the quadrupoles to THERING
% Cell array: {Ampere Vector, Tesla*Meter Vector, Quadrupole Number}
iQ = findcells(THERING, 'FamName', 'Q');


% Quadrupole Magnet Measurements
% Field at .030 meter, Unbucked Current

% TOYL 09
TOYL09 = [
     0.00  0.000000  % zero is artificial but nice to have
     9.95  0.015406
    20.69  0.031357
    31.53  0.047627 
    42.05  0.063726
    52.95  0.080198
    63.78  0.096559
    85.39  0.128990
    96.29  0.145190
   106.81  0.160930
    ];

 % TOYL 06
 TOYL06 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.07  0.015705
     20.72  0.031689
     31.62  0.048198
     42.15  0.064416
     53.04  0.081059
     63.97  0.097655
     74.65  0.113940
     85.51  0.130310
     96.41  0.146670
    106.94  0.162550
     ];

% TOYL 05
 TOYL05 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.01  0.015605
     20.72  0.031581
     31.59  0.048005
     42.15  0.064229
     53.04  0.080733
     63.91  0.097324
     74.62  0.11344
     85.48  0.12983
     96.35  0.14609
    106.88  0.16195
     ];

% TOYL 01
 TOYL01 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.01  0.015681
     20.72  0.03173
     31.59  0.048266
     42.15  0.064555
     53.04  0.081163
     63.94  0.097829
     74.62  0.11407
     85.51  0.13057
     96.38  0.14697
    106.94  0.16295
     ];

% TOYL 02
 TOYL02 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.07  0.015668
     20.75  0.031589
     31.65  0.048046
     42.21  0.064278
     53.1   0.080835
     63.97  0.097205
     74.68  0.11358
     85.54  0.12994
     96.41  0.14626
    106.94  0.16253
     ];

% TOYL 10
 TOYL10 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.07  0.015765
     20.72  0.031748
     31.62  0.048304
     42.15  0.064599
     53.04  0.08123
     63.94  0.097861
     74.62  0.11416
     85.51  0.13066
     96.38  0.14707
    106.91  0.16305
     ];

% TOYL 03
 TOYL03 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.01  0.01565
     20.63  0.031609
     31.53  0.048165
     42.12  0.064474
     52.98  0.081
     63.88  0.097641
     74.56  0.11392
     85.42  0.13044
     96.32  0.14682
    106.88  0.16275
     ];

% TOYL 08
 TOYL08 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.01  0.015689
     20.69  0.031705
     31.59  0.048258
     42.12  0.064551
     53.01  0.081196
     63.94  0.097813
     74.59  0.11411
     85.48  0.13063
     96.35  0.14702
    106.91  0.16296
     ];

% TOYL 11
 TOYL11 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.0   0.015743
     20.75  0.031679
     31.62  0.048156
     42.18  0.064385
     53.07  0.080952
     63.94  0.097482
     74.65  0.11371
     85.54  0.13018
     96.41  0.14649
    106.94  0.16238
     ];

% TOYL 04
 TOYL04 = [
      0.00  0.000000  % zero is artificial but nice to have
      9.98  0.015526
     20.66  0.031473
     31.56  0.047933
     42.09  0.064138
     52.98  0.080695
     63.88  0.097216
     85.45  0.12984
     96.32  0.14603
    106.85  0.16199
     ];

% TOYL 12
 TOYL12 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.07  0.015746
     20.69  0.031663
     31.62  0.048134
     42.15  0.064352
     53.04  0.080941
     63.94  0.097483
     74.65  0.11367
     85.51  0.13011
     96.38  0.14638
    106.94  0.16228
     ];

% TOYL 07  (the spare?)
 TOYL07 = [
      0.00  0.000000  % zero is artificial but nice to have
     10.04  0.014337
     20.69  0.028957
     31.59  0.044028
     42.15  0.058853
     53.04  0.074068
     63.91  0.089417
     74.59  0.10417
     85.48  0.11924
     96.38  0.13432
    106.91  0.14899
     ];

THERING{iQ(1)}.MagnetMeasurements  = TOYL09;
THERING{iQ(2)}.MagnetMeasurements  = TOYL06;
THERING{iQ(3)}.MagnetMeasurements  = TOYL05;
THERING{iQ(4)}.MagnetMeasurements  = TOYL01;
THERING{iQ(5)}.MagnetMeasurements  = TOYL02;
THERING{iQ(6)}.MagnetMeasurements  = TOYL10;
THERING{iQ(7)}.MagnetMeasurements  = TOYL03;
THERING{iQ(8)}.MagnetMeasurements  = TOYL08;
THERING{iQ(9)}.MagnetMeasurements  = TOYL11;
THERING{iQ(10)}.MagnetMeasurements = TOYL04;
THERING{iQ(11)}.MagnetMeasurements = TOYL12;


% % Plotting
% figure(1);
% clf reset
% for i = iQ
%     h = subplot(2,1,1);
%     plot(THERING{i}.MagnetMeasurements(:,1), THERING{i}.MagnetMeasurements(:,2),'.-');
%     hold on;
%     grid on;
%     h(2) = subplot(2,1,2);
%     plot(THERING{i}.MagnetMeasurements(:,1), THERING{i}.MagnetMeasurements(:,2)./THERING{i}.MagnetMeasurements(:,1),'.-');
%     hold on;
%     grid on
% end
% linkaxes(h, 'x');



