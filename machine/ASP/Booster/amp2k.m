function k = amp2k(Family, Field, Amps, DeviceList, Energy, C, K2AmpScaleFactor)
%AMP2K - Converts amperes to simulator values
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, Coefficients, K2AmpScaleFactor)
%    or
%  k = amp2k(Family, Field, Amps, DeviceList, Energy, MagnetCoreType, K2AmpScaleFactor)

if nargin < 4
    error('At least 4 inputs required');
end

if nargin < 7
    K2AmpScaleFactor = 1;
end

if nargin < 6
    C = [];
end

if isempty(C)
%     temp = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
%     muC = temp{1};
%     scaling = temp{2};
    
    temp = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
    muC = temp{1};
    mu = muC(:,1:2);
    C = muC(:,3:end);
    K2AmpScaleFactor = temp{2};
else
%     temp = C;
%     muC = temp{1};
%     scaling = temp{2};
    
    muC = C;
    
    mu = muC(:,1:2);
    C = muC(:,3:end);
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

% Scale solution if required
Amps = Amps ./ K2AmpScaleFactor;


brho = mean(getbrho(Energy));


% Compute polynomial expansion:  polynom = c0 + c1*I ...
% For dipole:      polynom = B  * Leff / I
% For quadrupole:  polynom = B' * Leff / I
% For sextupole:   polynom = B" * Leff / I  (use AT unit /2 from MAD units)

% polynom = (C(8)+C(7)*Amps+C(6)*Amps^2+C(5)*Amps^3+C(4)*Amps^4+C(3)*Amps^5+C(2)*Amps^6+C(1)*Amps^7)
% polynom = (c0+c1*Amps+c2*Amps^2+c3*Amps^3+c4*Amps^4+c5*Amps^5+c6*Amps^6+c7*Amps^7)

if isstr(C)
    muC = magnetcoefficients(C);
    mu = muC(:,1:2);
    C = muC(:,3:end);
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

% Modifiers due to power supply variations. Variation from Setpoint to
% Readback.
switch Family
    case 'QD'
        Amps = Amps*1;
    case 'QF'
        Amps = Amps*1;
    case 'SD'
        Amps = Amps*1;
    case 'SF'
        Amps = Amps*1;
end

% B, B', or B" scaled by energy
for i = 1:length(Amps)
    if size(C,1) == 1
        k(i,:) = polyval(C, Amps(i),[],mu) / brho;
    else
        k(i,:) = polyval(C(i,:), Amps(i),[],mu(i,:)) / brho;
    end
end
