function Amps = k2amp(Family, Field, k, DeviceList, Energy, C, K2AmpScaleFactor, varargin)
%K2AMP - Converts simulator values to amperes
%  Amps = k2amp(Family, Field, k, DeviceList, Energy, Coefficients, K2AmpScaleFactor)
%       or
%  Amps = k2amp(Family, Field, k, DeviceList, Energy, MagnetCoreType, K2AmpScaleFactor)
%
%  Calculates the current [amperes] from the coefficients (or
%  MagnetCoreType), "K-value", energy, and linear scale factor
%
%  For dipole:      k = B / Brho
%  For quadrupole:  k = B'/ Brho
%  For sextupole:   k = B"/ Brho / 2  (to be compatible with AT)
%
%  A curve vector or a MagnetCoreType string (current curves found from
%  magnetcoefficents.m) can be used. Amps and Coefficients must have equal
%  number of rows or one must only have one row.
%
%  Energy can be anything getenergy accepts, like 'Model' or 'Online'. 
%
%  The K2AmpScaleFactor linearly scales the output current:  Amps = K2AmpScaleFactor .* Amps
%
%  If energy is not an input or empty, then the energy is read from the accelerator data object (AD)
%  This can be used to account for linear calibration errors of the power supply and magnet
%
%  NOTES
%  1. If energy is not an input or empty, then the energy is obtained from getenergy.
%  2. Family and Field inputs are not used but there automatically part of the physics2hw call. 
%
% Original structure set up using polynomials by M. Yoon 4/8/03
% Modified for ASP by E. Tan 31/05/2006

if nargin < 4
    error('At least 4 inputs required');
end

if nargin < 6
    C = [];
end
if isempty(C)
    %[CC, Leff, MagnetName] = magnetcoefficients(Family);
    temp = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
    C = temp{1};
end

if nargin < 5
    Energy = [];
end
if isempty(Energy)
    Energy = getenergy;
elseif ischar(Energy)
    Energy = getenergy(Energy);
end

% If k is a row vector make it a column vector
k = k(:);

brho = getbrho(Energy);

if isstr(C)
    [C, Leff, MagnetName] = magnetcoefficients(C);
end

if any(size(C,1) ~= length(k))
    if length(k) == 1
        k = ones(size(C,1),1) * k;
    elseif size(C,1) == 1
        % Ok as is
        %C = ones(size(k,1),1) * C;
    else
        error('k and Coefficients must have equal number of rows or one must only have one row');
    end
end

% Simple interpolation function therefore assuming monotonic function
% for the magnets (which is reasonable) the it is a simple matter of
% reversing from B vs I to I vs B.
splitind = size(C,2)/2;
for i = 1:length(k)
    if size(C,1) == 1
        Amps(i,1) = interp1(C(1,splitind+1:end),C(1,1:splitind),k(i)*brho,'linear','extrap');
    else
        Amps(i,1) = interp1(C(i,splitind+1:end),C(i,1:splitind),k(i)*brho,'linear','extrap');
    end
end

% Scale solution if required
if nargin >= 7
    Amps = Amps ./ K2AmpScaleFactor;
end