function Amps = k2amp(Family, Field, k, DeviceList, Energy, C, K2AmpScaleFactor)
%K2AMP - Converts simulator values to amperes
%  Amps = k2amp(Family, Field, k, DeviceList, Energy, Coefficients, K2AmpScaleFactor)
%       or
%  Amps = k2amp(Family, Field, k, DeviceList, Energy, MagnetCoreType, K2AmpScaleFactor)
%
%  Calculates the current [amperes] from the coefficients (or MagnetCoreType), "K-value", energy, and linear scale factor
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. K - "K-value" in AT convention
%          For dipole:      K = B / Brho
%          For quadrupole:  K = B'/ Brho
%          For sextupole:   K = B"/ Brho / 2
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'. 
%              (Note: If Energy is a vector, then Amps can only have 1 column) 
%  6. Coefficients - A Coefficients vector or a MagnetCoreType string (coefficient found from magnetcoefficents.m) can be used
%  k and Coefficients must have equal number of rows or one must only have
%  one row 
%  7. K2AmpScaleFactor - linearly scales the output current:  Amps =
%  K2AmpScaleFactor .* Amps
%
%  NOTES
%  1. If energy is not an input or empty, then the energy is obtained from getenergy.
%  2. Family and Field inputs are not used but there automatically part of the physics2hw call. 
%
% See Also amp2k, magnetcoefficients

% ALGORITHM
%
% p = root(-k*Brho  + (c0 + c1*I + ... + cn*I^n))
% I = root(p) closest to linear solution rlin
% Linear solution is
% rlin = (k*Brho - c0)/c1

%
% M. Yoon 4/8/03
% Adapted by Laurent S. Nadolski
% Closest solution to linear takes into account the offset term


if nargin < 4
    error('At least 4 inputs required');
end

if nargin < 6
    C = [];
end
if isempty(C)
    %[CC, Leff, MagnetName] = magnetcoefficients(Family);
    C = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
    C = C{1};
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


% Compute roots for the expansion:  0 = -BLeff + c0*I + c1*I^2 ...
% For dipole:      BLeff = B  * Leff
% For quadrupole:  BLeff = B' * Leff 
% For sextupole:   BLeff = B" * Leff

%polynom = (C(8)+C(7)*Amps+C(6)*Amps^2+C(5)*Amps^3+C(4)*Amps^4+C(3)*Amps^5+C(2)*Amps^6+C(1)*Amps^7)
%polynom = (c0+c1*Amps+c2*Amps^2+c3*Amps^3+c4*Amps^4+c5*Amps^5+c6*Amps^6+c7*Amps^7)


if isstr(C)
    TableLookUpFlag = 1;
    MagnetCoreType = C;
    [C, Leff, MagnetName] = magnetcoefficients(MagnetCoreType, k(1), 'k');
    k0 = k(1);
else
    TableLookUpFlag = 0;
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
    % For piecewise tables, get a new polynomial
    if TableLookUpFlag
        if k(j) ~= k0;
            [C, Leff, MagnetName] = magnetcoefficients(MagnetCoreType, k(j), 'k');
            k0 = k(j);
        end
    end

    
    
    % Solve for roots based on polynomial coefficient (coefficients already divided by Leff)
    % p = [C(1) C(2) C(3) C(4) C(5) C(6) C(7) C(8) C(9)-k(j)*brho]; 
    
    if size(C,1) == 1
        p = [C(1:end-1) C(end)-k(j)*brho]; 
        r1inear = (k(j)*brho-C(end))/C(end-1);
    else
        p = [C(j,1:end-1) C(j,end)-k(j)*brho]; 
        r1inear = (k(j)*brho-C(end))/C(j,end-1);
    end
    
    r = roots(p);    
        
    % Choose the closest solution to the linear one
    Amps(j,1) = Inf;
    FitError = Inf;
    for i = 1:length(r)
        if isreal(r(i))
            %if r(i)>0 & abs(r(i)) < Amps(j,1)  % Smallest, positive 
                        
            % Closest to linear method
            if abs(r(i)-r1inear) < abs(Amps(j,1)-r1inear)
                Amps(j,1) = r(i);
            end
        end
    end
    
    if isinf(Amps(j,1))
        error(sprintf('Solution for k=%.3f not found (all roots are complex)', k(j)));
    end
end

% Scale solution if required
if nargin >= 7
    Amps = Amps .* K2AmpScaleFactor;
end
