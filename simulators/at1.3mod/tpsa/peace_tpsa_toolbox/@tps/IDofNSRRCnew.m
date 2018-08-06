function DataOfID = IDofNSRRCnew(template,Name,Parameter)
%function DataOfID = IDofNSRRCnew(TPS,Name,Parameter)
% Data of NSRRC's IDs used for TLS 1.5 GeV electron storage ring of NSRRC only.
% Transerve field approach, vector potential Ax = Ay = 0 and As is used only.
% Mode: 0 or 1
% Type: 'AGID','APID', 'EPID'
% Symmetry: 1(Yes, Symmetry) NumberOfPoles = odd, 0(No, Anti-symmetry) NumberOfPoles = even
% Name: 'W20','U5','U9','EPU56','SWLS','SMPW'
% Parameter: double value (Gap/Phase/Current)
%-------------------------------------------------------------------------------
% Author:
%  Chang, Ho-Ping (also written as Ho-Ping Chang or Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road, Hsinchu Science-Based Industrial Park
%  Hsinchu 30077, Taiwan
%  E-mail: peace@nsrrc.org.tw
% Created Date: 09-Jun-2003
% Updated Date:
%  10-Jun-2003
%  12-Jun-2003
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
global OSIP
DataOfID.Name = Name;
DataOfID.Parameter = Parameter;

ID.List = strvcat('W20', 'U5', 'U9', 'EPU56', 'SWLS', 'SMPW');
DataOfID.Index = strmatch(DataOfID.Name,ID.List,'exact');
if (DataOfID.Index < 1) | (DataOfID.Index > length(ID.List))
   error('Input argument Name does not appear in the ID.List!');
end

% Wiggler W20
% Ideal W20: 1st-end-pole : 2nd-end-pole : full-pole = 1/4 : 3/4 : 1
% Real W20: [P1 P2 PX PC] = [1/6 -3/5 1 -1]
ID.Data(1).NumberOfPoles = 27;
ID.Data(1).NumberOfEndPoles = 2;
%ID.Data(1).Mode = 1; % sinh/cosh
ID.Data(1).Mode = 0; % sin/cos
ID.Data(1).Type = 'AGID';
ID.Data(1).Symmetry = 1;
ID.Data(1).PoleWidth = 0.1; % Unit: meter, 0.1 meter = 10 cm
ID.Data(1).PeriodLength = 2*ID.Data(1).PoleWidth;
ID.Data(1).ks = pi/ID.Data(1).PoleWidth;
ID.Data(1).kx = 0;
ID.Data(1).Parameter = [22 22.3 26 30 35 40 45 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230]; % Gap
ID.Data(1).PeakField = [1.85800442 1.83999121 1.63038117 1.42944175 1.22988308 1.07126800 0.94573509 0.84357756 0.68074448 0.56165399 0.46678419 0.39248674 0.33061181 ...
        0.28011830 0.23751561 0.20211365 0.17175343 0.14642083 0.12460224 0.10633915 0.09061517 0.07733557 0.06599265 0.05631031 0.04809014 0.04107413];

% Undulator U5
%[PE N1 P2 NN PN N2 P1 NE] = [56/916 -32/61 58/61 -1 1 -58/61 32/61 -56/918]
ID.Data(2).NumberOfPoles = 156;
ID.Data(2).NumberOfEndPoles = 2;
ID.Data(2).Mode = 1;
ID.Data(2).Type = 'AGID';
ID.Data(2).Symmetry = 0;
ID.Data(2).PoleWidth = 0.025;
ID.Data(2).PeriodLength = 2*ID.Data(2).PoleWidth;
ID.Data(2).kx = 0;
ID.Data(2).Parameter = [14 18 19 20 22 25 27 30 35 40 45 50 60 70 120 230 250]; % Gap
ID.Data(2).PeakField = [0.91533720 0.67329090 0.63140240 0.58600030 0.51216510 0.41593170 0.36989030 0.30280650 0.22158930 0.15936110 0.11580370 0.08483674 0.04426467 ...
        0.02305669 0.00103300 0.00000000 0.00000000];

% Undulator U9
% [NE P1 N2 PN NN P2 N1 PE] = [-2147/12802 8855/12802 -125/128 1 -1 125/128 -8855/12802]
ID.Data(3).NumberOfPoles = 100;
ID.Data(3).NumberOfEndPoles = 2;
ID.Data(3).Mode = 1;
ID.Data(3).Type = 'AGID';
ID.Data(3).Symmetry = 0;
ID.Data(3).PoleWidth = 0.045;
ID.Data(3).PeriodLength = 2*ID.Data(3).PoleWidth;
ID.Data(3).kx = 0;
ID.Data(3).Parameter = [18 19 20 21 22 24 26 28 30 32 34 36 38 42 46 50 54 60 70 80 100 220 230]; % Gap
ID.Data(3).PeakField = [1.28021150 1.28021150 1.21708700 1.15863990 1.10385940 1.00499390 0.91819627 0.84152641 0.77290514 0.71158841 0.65633119 0.60639290 0.56080759 ...
        0.48108067 0.41400438 0.35693640 0.30817691 0.24765390 0.17248560 0.12025689 0.05841128 0.00077322 0.00000000];

% Undulator EPU56
% [PE NE P1 N1 P2 N P] = [1/4 -3/4 1 -1 1 -1 1]
ID.Data(4).NumberOfPoles = 133;
ID.Data(4).NumberOfEndPoles = 2;
ID.Data(4).Mode = 1;
ID.Data(4).Type = 'EPU';
ID.Data(4).Symmetry = 0; % Phase ?
ID.Data(4).PoleWidth = 0.028;
ID.Data(4).PeriodLength = 2*ID.Data(4).PoleWidth;
ID.Data(4).kx = 0;
ID.Data(4).Parameter = [17 18 20 23 28 35 50 70 110 160 230]; % Gap (or Phase)
ID.Data(4).PeakField = [0.69915008 0.69915008 0.62564473 0.52931217 0.39986535 0.26945240 0.11531039 0.03683968 0.00373228 0.00000000 0.00000000];

% Super-Conducting Wave-Length Shifter (SWLS)
% [N P N] = [-1/2 1 -1/2]
ID.Data(5).NumberOfPoles = 3;
ID.Data(5).NumberOfEndPoles = 1;
%ID.Data(5).Mode = 1; % Use sinh/cosh in x-direction and k_x^2+k_y^2 = k_s^2
ID.Data(5).Mode = 0; % Use sin/cos in x-direction and kappa_x^2+k_s^2 = k_y^2
ID.Data(5).Type = 'AGID';
ID.Data(5).Symmetry = 1;
ID.Data(5).PoleWidth = 0.2;
%ID.Data(5).PoleWidth = 0.1396263; % kx = 3.6, ky = 22.8, ks = 22.5, pole-width = 0.1396263 
ID.Data(5).PeriodLength = 2*ID.Data(5).PoleWidth;
ID.Data(5).ks = pi/ID.Data(5).PoleWidth; % ks = 2*pi/Lambda = pi/PoleWidth;
ID.Data(5).kx = 0;
%ID.Data(5).kx = 3.6;
ID.Data(5).ky = 22.8;
ID.Data(5).Parameter = [0 25 50 75 100 125 150 175 200 225 250 260 261]; % Current
ID.Data(5).PeakField = [0.000000 1.245164 1.856044 2.414862 2.916582 3.415849 3.906895 4.365579 4.825984 5.290268 5.758334 5.944600 6.0];

% Super-Conducting Multi-Pole Wiggler SMPW
% [] = []
ID.Data(6).NumberOfPoles = 33;
ID.Data(6).NumberOfEndPoles = 1;
ID.Data(6).Mode = 0;
ID.Data(6).Type = 'AGID';
ID.Data(6).Symmetry = 1;
ID.Data(6).PoleWidth = 0.03;
ID.Data(6).PeriodLength = 2*ID.Data(5).PoleWidth;
ID.Data(6).kx = 0;
ID.Data(6).Parameter = []; % Current
ID.Data(6).PeakField = [];

DataOfID.PoleWidth = ID.Data(DataOfID.Index).PoleWidth;
DataOfID.Lambda = DataOfID.PoleWidth*2;
DataOfID.NumberOfPoles = ID.Data(DataOfID.Index).NumberOfPoles;
DataOfID.NumberOfEndPoles = ID.Data(DataOfID.Index).NumberOfEndPoles;
DataOfID.M = DataOfID.NumberOfEndPoles;
DataOfID.Mode = ID.Data(DataOfID.Index).Mode;
DataOfID.Type = ID.Data(DataOfID.Index).Type;
DataOfID.Symmetry = ID.Data(DataOfID.Index).Symmetry;
if DataOfID.Symmetry == 1
    DataOfID.N = (DataOfID.NumberOfPoles-1)/2-DataOfID.M;
elseif DataOfID.Symmetry == 0
    DataOfID.N = (DataOfID.NumberOfPoles)/2-DataOfID.M;
else
    error('DataOfID.Symmetry ~= 0 or 1.');
end
DataOfID.ks = pi/DataOfID.PoleWidth;

DataOfID.kx = ID.Data(DataOfID.Index).kx;
DataOfID.ky = ID.Data(DataOfID.Index).ky;

len = length(ID.Data(DataOfID.Index).Parameter);
if (Parameter < ID.Data(DataOfID.Index).Parameter(1)) | (Parameter > ID.Data(DataOfID.Index).Parameter(len))
    error('Input value of argument Parameter is out of rang [minimum maximum].');
end
for up=2:len
    if Parameter < ID.Data(DataOfID.Index).Parameter(up), break, end
end
dn = up-1;

Factor = (ID.Data(DataOfID.Index).PeakField(up)-ID.Data(DataOfID.Index).PeakField(dn));
Factor = Factor/( ID.Data(DataOfID.Index).Parameter(up)-ID.Data(DataOfID.Index).Parameter(dn));
DataOfID.PeakField = ID.Data(DataOfID.Index).PeakField(dn);
DataOfID.PeakField = DataOfID.PeakField+(Parameter-ID.Data(DataOfID.Index).Parameter(dn))*Factor;
DataOfID.L = DataOfID.NumberOfPoles*DataOfID.PoleWidth;
%DataOfID.Amplitude = DataOfID.PeakField/DataOfID.ks;
DataOfID.Amplitude = DataOfID.PeakField*0.5;

clear up dn len Factor