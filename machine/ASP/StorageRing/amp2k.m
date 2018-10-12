function k = amp2k(Family, Field, Amps, DeviceList, Energy, C, K2AmpScaleFactor)
%AMP2K - Converts amperes to simulator values
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, Coefficients, K2AmpScaleFactor)
%    or
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, MagnetCoreType, K2AmpScaleFactor)
%
%  Calculates the "K-value" from the coefficients (or MagnetCoreType),
%  current [amps], energy, and linear scale factor
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
%  The K2AmpScaleFactor linearly scales the input current:  Amps = Amps ./ K2AmpScaleFactor
%  This can be used to account for linear calibration errors of the power supply and magnet
%
%  NOTES
%  1. If energy is not an input or empty, then the energy is obtained from getenergy.
%  2. Family and Field inputs are not used but there automatically part of the hw2physics call. 
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
    %[C, Leff, MagnetName] = magnetcoefficients(Family);
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


% If Amps is a row vector make it a column vector
Amps = Amps(:);

brho = getbrho(Energy);

% Scale solution if required
if nargin >= 7
    Amps = Amps ./ K2AmpScaleFactor;
end



if isstr(C)
    [C, Leff, MagnetName] = magnetcoefficients(C);
end

if any(size(C,1) ~= length(Amps))
    if length(Amps) == 1
        Amps = ones(size(C,1),1) * Amps;
    elseif size(C,1) == 1
        %C = ones(size(Amps,1),1) * C;
    else
        error('Amps and Coefficients must have equal number of rows or one must only have one row');
    end
end

% B, B', or B" scaled by energy. Applies to all other magnets other than
% the dipoles. The curve C is arranged such that the first half of the row
% vector contains the current data and the second half contains the B, B'
% and/or B" as a function of the current data.
splitind = size(C,2)/2;
for i = 1:length(Amps)
    if size(C,1) == 1
        k(i,1) = interp1(C(1,1:splitind),C(1,splitind+1:end),Amps(i),'linear','extrap') / brho;
    else
        k(i,1) = interp1(C(i,1:splitind),C(i,splitind+1:end),Amps(i),'linear','extrap') / brho;
    end
end
