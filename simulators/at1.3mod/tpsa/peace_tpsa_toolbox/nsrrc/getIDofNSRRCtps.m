function DataOfID = getIDofNSRRCtps(NameOfID,Parameter)
%function DataOfID = getIDofNSRRC(NameOfID,Parameter)
% Data of NSRRC's IDs is used for TLS 1.5 GeV electron storage ring of NSRRC only.
% Mode: 0) use sin and cos in x and kx^2+ks^2 = ks^2;
%       1) use sinh and cosh in x and kx^2+ky^2 = ks^2
% Type: 'AGID','APID', 'EPID'
% Symmetry: 1(Yes, Symmetry) NumberOfPoles = odd,
%           0(No, Anti-symmetry) NumberOfPoles = even
% Name: 'SWLS', 'EPU56', 'U5', 'SW6', 'W20', 'U9'
% Parameter: double value (Gap/Phase/Current)
%-------------------------------------------------------------------------------
% Author: Chang, Ho-Ping (also known as Peace Chang)
%  National Synchrotron Radiation Research Center
%  101 Hsin-Ann Road
%  Hsinchu Science Park
%  Hsinchu 30077, Taiwan, R.O.C.
%  E-mail: peace@nsrrc.org.tw
%-------------------------------------------------------------------------------
% Created Date: 09-Jun-2003
% Updated Date: 13-May-2004
%-------------------------------------------------------------------------------
% Terminology and Category:
%  Truncated Power Series Algebra (TPSA)
%  One-Step Index Pointer (OSIP)
%  Truncated Power Series (TPS)
%------------------------------------------------------------------------------
global OSIP

% Load NSRRC/TPS Accelerator Data
AD = nsrrc_tps_ad;

if isempty(strmatch(NameOfID,AD.ID.List,'exact'))
    error('The given NameOfID (%s) is not found in nsrrc_ad.m', NameOfID);
end
DataOfID = AD.ID.(NameOfID);
DataOfID.Lambda = DataOfID.PeriodLength;
DataOfID.M = DataOfID.NumberOfEndPoles;
if DataOfID.Symmetry == 1
    DataOfID.N = (DataOfID.NumberOfPoles-1)/2-DataOfID.M;
elseif DataOfID.Symmetry == 0
    DataOfID.N = (DataOfID.NumberOfPoles)/2-DataOfID.M;
else
    error('DataOfID.Symmetry ~= 0 or 1.');
end
if (Parameter < DataOfID.Parameter(1)) | (Parameter > DataOfID.Parameter(end))
    error('Input value of argument Parameter is out of rang [minimum(%f) maximum(%f)].', DataOfID.Parameter(1), DataOfID.Parameter(end));
end
DataOfID.Field = interp1(DataOfID.Parameter,DataOfID.PeakField,Parameter,'linear');
DataOfID.L = DataOfID.NumberOfPoles*DataOfID.PoleWidth;
DataOfID.Amplitude = DataOfID.Field/DataOfID.ks;

% Vector potential Ax, Ay and As = 0
% In arbitrary 3-D Magnetic field, f0 = constant_a0*y; g0 = constant_a0*x;
DataOfID.f0 = 0;
DataOfID.g0 = 0;
DataOfID.h0 = 0;
DataOfID.G = 0;
DataOfID.F = 0;

DataOfID.Bxs = 0;
DataOfID.Bys = 0;
DataOfID.Bss = 0;
DataOfID.Axs = 0;
DataOfID.Ays = 0;
DataOfID.Ass = 0;

% DataOfID.Maximum_Harmonic_Number == n
DataOfID.Maximum_Harmonic_Number = 1;
for n=1:DataOfID.Maximum_Harmonic_Number
    % Bx = 0 case, By without roll-off in the x-direction, kx = 0
    % Bx ~= 0 case, By with roll-off in the x-direction, kx ~= 0
    DataOfID.k1x(n) = DataOfID.kx;
    DataOfID.k2x(n) = DataOfID.kx;
    if DataOfID.Mode == 0 % use sin and cos in x and kx^2+ks^2 = ks^2
       DataOfID.k1y(n) = sqrt(DataOfID.ks^2+DataOfID.k1x(n)^2);
       DataOfID.k2y(n) = sqrt(DataOfID.ks^2+DataOfID.k2x(n)^2);
    elseif DataOfID.Mode == 1 % use sinh and cosh in x and kx^2+ky^2 = ks^2
       DataOfID.k1y(n) = sqrt(DataOfID.ks^2-DataOfID.k1x(n)^2);
       DataOfID.k2y(n) = sqrt(DataOfID.ks^2-DataOfID.k2x(n)^2);
    else
       error('DataOfID.Mode ~= 0 or 1.')
    end   
    if DataOfID.Symmetry == 1 % DataOfID.NumberOfPoles = Odd Number
       % By(s-S0) = By(S0-s), g2n = 0
       DataOfID.a1(n) = 0;
       DataOfID.a2(n) = 1;
       DataOfID.d1(n) = 0;
       DataOfID.d2(n) = 1;
   elseif DataOfID.Symmetry == 0 % DataOfID.NumberOfPoles = Even Number
       % By(s-S0) = - By(S0-s), g1n = 0
       DataOfID.a1(n) = 1;
       DataOfID.a2(n) = 0;
       DataOfID.d1(n) = 1;
       DataOfID.d2(n) = 0;
   else
       error('DataOfID.Symmetry ~= 0 or 1.')
   end
    % (AGID or APID) Bx(-x) = Bx(x), By(-x) = By(x), Bs(-x) = Bs(x)
    DataOfID.b1(n) = 0;
    DataOfID.b2(n) = 0;
    % AGID By(-y) = By(y)
    DataOfID.r1(n) = 0;
    DataOfID.r2(n) = 0;

    DataOfID.nk1xx = TPS;
    DataOfID.nk2xx = TPS;
    DataOfID.nk1yy = TPS;
    DataOfID.nk2yy = TPS;
    DataOfID.s1x = TPS;
    DataOfID.s2x = TPS;
    DataOfID.c1x = TPS;
    DataOfID.c2x = TPS;
    DataOfID.s1y = TPS;
    DataOfID.s2y = TPS;
    DataOfID.c1y = TPS;
    DataOfID.c2y = TPS;
    DataOfID.f1(n) = TPS;
    DataOfID.f2(n) = TPS;
    DataOfID.g1(n) = TPS;
    DataOfID.g2(n) = TPS;
    DataOfID.h1(n) = TPS;
    DataOfID.h2(n) = TPS;
    % For Mode 0: kmnx^2 + ks^2 = kmny^2
    %DataOfID.s1x == DataOfID.sn1x;
    %DataOfID.s2x == DataOfID.sn2x;
    %DataOfID.c1x == DataOfID.cn1x;
    %DataOfID.cn2x == DataOfID.cn2x;
    % For Mode 1: kmnx^2 + kmny^2 = ks^2 
    %DataOfID.s1x == DataOfID.sh1x;
    %DataOfID.s2x == DataOfID.sh2x;
    %DataOfID.c1x == DataOfID.ch1x;
    %DataOfID.cn2x == DataOfID.ch2x;
    % For both Mode 0 and 1.
    %DataOfID.s1x = DataOfID.sh1x;
    %DataOfID.s2x = DataOfID.sh2x;
    %DataOfID.c1x = DataOfID.ch1x;
    %DataOfID.c2x = DataOfID.ch2x;
    %DataOfID.s1y = DataOfID.sh1y;
    %DataOfID.s2y = DataOfID.sh2y;
    %DataOfID.c1y = DataOfID.ch1y;
    %DataOfID.c2y = DataOfID.ch2y;
end
