function Amps = at2mls(Family, Field, k, DeviceList, Energy)
%AT2MLS - Converts simulator values to amperes
%  Amps = at2mls(Family, Field, K, DeviceList, Energy)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. K - "K-value" (AT convention)
%          For dipole:      K = B / Brho
%          For quadrupole:  K = B'/ Brho
%          For sextupole:   K = B"/ Brho / 2
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Amps can only have 1 column)
%
%  OUTPUTS
%  1. Amps - Ampere (or real hardware units)
%
%  See also mls2at, hw2physics, physics2hw


if nargin < 3
    error('At least 3 input required');
end

if isempty(Field)
    Field = 'Setpoint';
end

if nargin < 4
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if nargin < 5
    Energy = [];
end
if isempty(Energy)
    Energy = getenergy;
elseif ischar(Energy)
    Energy = getenergy(Energy);
end


if size(k,1) == 1 && length(DeviceList) > 1
    k = ones(size(DeviceList,1),1) * k;
elseif size(k,1) ~= size(DeviceList,1)
    error('Rows in K must equal rows in DeviceList or be a scalar');
end


if all(isnan(k))
    Amps = k;
    B = k;
    return
end


% Force Energy and K to have the same number of columns
if all(size(Energy) > 1)
    error('Energy can only be a scalar or vector');
end
Energy = Energy(:)';

if length(Energy) > 1
    if size(k,2) == size(Energy,2)
        % OK
    elseif size(k,2) > 1
        error('If Energy is a vector, then K can only have 1 column.');
    else
        % K has one column, expand to the size of Energy
        k = k * ones(1,size(Energy,2));
    end
else
    Energy = Energy * ones(1,size(k,2));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor Fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Field, {'Setpoint','Monitor'}))
    if strcmpi(Family, 'HCM')
        % HCM
        % Rad = BLeff / Brho
        Brho = getbrho(Energy);
        BLeffPerI = 0.002/3.5 * getbrho(0.60);
        Amps = k .* Brho / BLeffPerI;
    elseif strcmpi(Family, 'VCM')
        % VCM
        % Rad = BLeff / Brho
        Brho = getbrho(Energy);
        BLeffPerI = 0.002/7.  * getbrho(0.60);
        Amps = k .* Brho / BLeffPerI;
    else
        for iDev = 1:size(DeviceList,1)
            if strcmpi(Family, 'BEND')
                % conversion     X0               X1          X2           X3          X4           X5
                %C = [-4.96974e-4    +00.00762    -3.73956e-7 +1.1569e-9   -1.24377e-12   +0.00       0.0 0.0 0.0];
                C = [ 0.0  2.110080000000010e-03 0.0 ];
            
            elseif any(strcmpi(Family, {'OCTU'}))
                %C = [ 64.45819      +1356.30247  +34.11868   -10.91875    +0.90058       +0.00       0.0 0.0 0.0];
                C = [ 30.5004064310073 458.582398764302 1.80872126601211 -1.15913610241367 0.116895117664849 ];
            
            elseif any(strcmpi(Family, {'SF', 'SD', 'HSD'}))
                %C = [0.000         +10.71254    +0.1549      -0.00523  +8.16067e-5    -4.70938e-7 0.0 0.0 0.0];
                C = [1.50482883122982 3.99722720879143 0.0211025152303994 -0.000574792229059250 3.84470492536723e-06];
                if any(strcmpi(Family, {'SD', 'HSD'}))
                    C = -C;
                end

            elseif strcmpi(Family, 'QF')
                % Q3
                if DeviceList(iDev,1) == 1 || DeviceList(iDev,1) == 3
                    % conv_Q3k
                    C = [-3.018659654166098e-01     1.494364860337816e-01 ];
                end
                if DeviceList(iDev,1) == 2
                    % conv_Q3l2
                    C = [-4.284693858303152e-01     1.537127476853837e-01 ];
                end
                if DeviceList(iDev,1) == 4
                    % conv_Q3l4
                    C = [-4.404998445185297e-01     1.535992563527457e-01 ];
                end
                C = [0.0450000000000001 0.139867122421569 -0.000459031215332247 8.88123013208069e-06 -5.26898671780445e-08];

            elseif strcmpi(Family, 'QD')
                % Q2
                if DeviceList(iDev,1) == 1 || DeviceList(iDev,1) == 3
                    % conv_Q2k
                    C  = [ 3.327381121771293e-01    -1.529412863450864e-01 ];
                end
                if DeviceList(iDev,1) == 2
                    % conv_Q2l2
                    C = [ 3.946722647092257e-01    -1.562921772516132e-01 ];
                end
                if DeviceList(iDev,1) == 4
                    % conv_Q2l4
                    C = [ 3.999366139023597e-01    -1.566782818613120e-01 ];
                end
                C = -1*[0.0450000000000001 0.139867122421569 -0.000459031215332247 8.88123013208069e-06 -5.26898671780445e-08];

            elseif strcmpi(Family, 'QFA')
                % Q1
                %C = [ 3.246282471027307e-02     1.347880617573123e-01];
                C = -1*[0.0450000000000001 0.139867122421569 -0.000459031215332247 8.88123013208069e-06 -5.26898671780445e-08];
                
            elseif any(strcmpi(Family, {'CSQ'}))
                C  = [ 0 1. 0];   %Baustelle
            else
                % If you made it to here, I don't know how to convert it
                Amps = k;
                return
            end
            
            C = reverse(C);
            Brho = getbrho(Energy);

            for iCol = 1:size(k,2)
                % Solve for roots based on polynomial coefficient
                % p = [C(1) C(2) C(3) C(4) C(5) C(6) C(7) C(8) C(9)-k(j)*Brho];
                p = [C(1:end-1) C(end)-k(iDev,iCol)*Brho(iCol)];
                r1inear = k(iDev,iCol)*Brho(iCol)/C(end-1);
                r = roots(p);

                % Choose the closest solution to the linear one
                Amps(iDev,iCol) = inf;
                for i = 1:length(r)
                    if isreal(r(i))
                        %if r(i)>0 & abs(r(i)) < Amps(j,1)  % Smallest, positive
                        if abs(r(i)-r1inear) < abs(Amps(iDev,iCol)-r1inear)  % Closest to linear solution
                            Amps(iDev,iCol) = r(i);
                        end
                    end
                end
                if isinf(Amps(iDev,iCol))
                    error(sprintf('Solution for k=%.3f not found (all roots are complex)', k(iDev,iCol)));
                end
            end
        end
        % This is a cluge!!!
        % I'm forcing zero amps to zero "k" for the moment (GJP)
        Amps(find(k==0)) = 0;
    end
    return
end


% If you made it to here, I don't know how to convert it
Amps = k;
return
