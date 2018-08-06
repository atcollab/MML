function Amps = k2amp(Family, Field, k, DeviceList, Energy, C, K2AmpScaleFactor)
%K2AMP - Converts simulator values to amperes
%  Amps = k2amp(Family, Field, k, DeviceList, Energy, Coefficients, K2AmpScaleFactor)
%       or
%  Amps = k2amp(Family, Field, k, DeviceList, Energy, MagnetCoreType, K2AmpScaleFactor)
%
%  Calculates the current [amperes] from the coefficients (or MagnetCoreType), "K-value", energy, and linear scale factor
%
%  For dipole:      k = B / Brho
%  For quadrupole:  k = B'/ Brho
%  For sextupole:   k = B"/ Brho / 2  (to be compatible with AT)
%
%  A Coefficients vector or a MagnetCoreType string (coefficient found from magnetcoefficents.m) can be used
%  k and Coefficients must have equal number of rows or one must only have one row 
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
%  Written by M. Yoon 4/8/03


% Note: skew quad family is distributed on two types of core
%       therefore might need to pass in device list
%       same could be true with quadshunt (current switched into many types of cores)

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
    temp = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
    muC = temp{1};
    mu = muC(:,1:2);
    C = muC(:,3:end);
    K2AmpScaleFactor = temp{2};
else
    temp = C;
    mu = temp(:,1:2);
    C = temp(:,3:end);
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


brho = mean(getbrho(Energy));



% Compute roots for the expansion:  0 = -BLeff + c0*I + c1*I^2 ...
% For dipole:      BLeff = B  * Leff
% For quadrupole:  BLeff = B' * Leff 
% For sextupole:   BLeff = B" * Leff

%polynom = (C(8)+C(7)*Amps+C(6)*Amps^2+C(5)*Amps^3+C(4)*Amps^4+C(3)*Amps^5+C(2)*Amps^6+C(1)*Amps^7)
%polynom = (c0+c1*Amps+c2*Amps^2+c3*Amps^3+c4*Amps^4+c5*Amps^5+c6*Amps^6+c7*Amps^7)

if isstr(C)
    temp = magnetcoefficients(C);
    muC = temp{1};
    mu = muC(:,1:2);
    C = muC(:,3:end);
    K2AmpScaleFactor = temp{2};
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

for j = 1:length(k)
    
    % Solve for roots based on polynomial coefficient (coefficients already divided by Leff)
    % p = [C(1) C(2) C(3) C(4) C(5) C(6) C(7) C(8) C(9)-k(j)*brho]; 
    
    if size(C,1) == 1
        p = [C(1:end-1) C(end)-k(j)*brho]; 
        r1inear = p(end)/p(end-1);
    else
        p = [C(j,1:end-1) C(j,end)-k(j)*brho]; 
        r1inear = p(end)/p(end-1);
    end
    
    r = roots(p);    
        
    % Choose the closest solution to the linear one
    Amps(j,1) = inf;
    for i = 1:length(r)
        if isreal(r(i))
            %if r(i)>0 & abs(r(i)) < Amps(j,1)  % Smallest, positive 
            if abs(r(i))-abs(r1inear) < abs(Amps(j,1))-abs(r1inear)  % Closest to linear solution
                Amps(j,1) = r(i);
            end
        end
    end
    
    if isinf(Amps(j,1))
        error(sprintf('Solution for k=%.3f not found (all roots are complex)', k(j)));
    end
end
% The coefficients were obtained using MATLAB's polyfit with centering and
% scaling.
if size(C,1) == 1
    Amps = Amps*mu(2) + mu(1);
else
    Amps = Amps*mu(1,2) + mu(1,1);
end

% Scale solution if required
Amps = Amps .* K2AmpScaleFactor;

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