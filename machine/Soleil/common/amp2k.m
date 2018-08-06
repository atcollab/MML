function k = amp2k(Family, Field, Amps, DeviceList, Energy, C, K2AmpScaleFactor)
%AMP2K - Converts amperes to simulator values
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, Coefficients, K2AmpScaleFactor)
%    or
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, MagnetCoreType, K2AmpScaleFactor)
%
%  Calculates the "K-value" from the coefficients (or MagnetCoreType), current [amps], energy, and linear scale factor
%
%  A Coefficients vector or a MagnetCoreType string (coefficient found from magnetcoefficents.m) can be used
%  Amps and Coefficients must have equal number of rows or one must only have one row
% INPUTS
% 1. Family - Family Name
% 2. Field  - Family Field (like 'Setpoint')
% 3. Amps   - Ampere vector to convert
% 4. DeviceList - Device list (Amps and DeviceList must have the same
% number of rows)
% 5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'. 
%              (Note: If Energy is a vector, then Amps can only have 1
%              column)Family, Field, value(:,i), DeviceList, Energy, ParamsList{:}
% 6. C - %  A Coefficients vector or a MagnetCoreType string (coefficient found from magnetcoefficents.m) can be used
%  Amps and Coefficients must have equal number of rows or one must only
%  have one row
% 7. K2AmpScaleFactor - linearly scales the input current:  Amps = Amps ./ K2AmpScaleFactor
%    This can be used to account for linear calibration errors of the power supply and magnet
%
% OUTPUT
% 1. K and B - K-value and field in AT convention
%    For dipole:      k = B / Brho
%    For quadrupole:  k = B'/ Brho
%    For sextupole:   k = B"/ Brho / 2  (to be compatible with AT)
%
%  NOTES
%  1. If energy is not an input or empty, then the energy is obtained from getenergy.
%  2. Family and Field inputs are not used but there automatically part of the hw2physics call. 
%
% See Also k2amp, magnetcoefficients

% ALGORITHM
%
% k = (c0 + c1*I + ... + cn*I^n)/Brho

%
% Written by M. Yoon 4/8/03
% Adapted by Laurent S. Nadolski

if nargin < 4
    error('At least 4 inputs required');
end

if nargin < 6
    C = [];
end
if isempty(C)
    %[C, Leff, MagnetName] = magnetcoefficients(Family);
    C = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
    C = C{1};
    %Leff = getleff(Family, DeviceList(ii,:));
end

if nargin < 5
    Energy = [];
end
if isempty(Energy)
    Energy = getenergy; % like getenergy('Production')
elseif ischar(Energy)
    Energy = getenergy(Energy);
end


% If Amps is a row vector make it a column vector
Amps = Amps(:);

% Scale solution if required
if nargin >= 7
    Amps = Amps ./ K2AmpScaleFactor;
end

brho = getbrho(Energy);

% Compute polynomial expansion:  polynom = c0 + c1*I ...
% For dipole:      polynom = B  * Leff / I
% For quadrupole:  polynom = B' * Leff / I
% For sextupole:   polynom = B" * Leff / I  (use AT unit /2 from MAD units)

% polynom = (C(8)+C(7)*Amps+C(6)*Amps^2+C(5)*Amps^3+C(4)*Amps^4+C(3)*Amps^5+C(2)*Amps^6+C(1)*Amps^7)
% polynom = (c0+c1*Amps+c2*Amps^2+c3*Amps^3+c4*Amps^4+c5*Amps^5+c6*Amps^6+c7*Amps^7)

if isstr(C)
    TableLookUpFlag = 1;
    MagnetCoreType = C;
    [C, Leff, MagnetName] = magnetcoefficients(MagnetCoreType, Amps(1));
    Amps0 = Amps(1);
else
    TableLookUpFlag = 0;
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

% B, B', or B" scaled by energy
for i = 1:length(Amps)
    % For piecewise tables, get a new polynomial
    if TableLookUpFlag
        if Amps(i) ~= Amps0;
            [C, Leff, MagnetName] = magnetcoefficients(MagnetCoreType, Amps(i));
            Amps0 = Amps(i);
        end
    end
    
    if size(C,1) == 1
        k(i,1) = polyval(C, Amps(i)) / brho;
    else
        k(i,1) = polyval(C(i,:), Amps(i)) / brho;
    end
end


% switch upper(deblank(MagnetName))
%     case 'BEND'
%         k = (Amps/brho)*polynom/Leff;   % B scaled by energy
%         %BLeff = Amps*polynom;
%         %B = BLeff/Leff;
%         
%     case 'QUAD'
%         k = (Amps/brho)*polynom/Leff;   % B' scaled by energy
%         %BPrimeLeff = Amps*polynom;
%         %Bprime = BPrimeLeff/Leff;
%         
%     case 'SEXT'
%         k = (Amps/brho)*polynom/Leff;   % B" scaled by energy
%         %BPrimePrimeLeff = Amps*polynom;
%         %BPrimePrime = BPrimePrimeLeff/Leff;        
% end
