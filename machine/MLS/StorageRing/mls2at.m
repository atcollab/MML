function k = mls2at(Family, Field, Amps, DeviceList, Energy)
%MLS2AT - Converts amperes to simulator values
%  K = mls2at(Family, Field, Amps, DeviceList, Energy)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. Amps - Ampere
%  4. DeviceList - Device list (Amps and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Amps can only have 1 column)
%
%  OUTPUTS
%  1. K - "K-value" (AT convention)
%     For dipole:      K = B / Brho
%     For quadrupole:  K = B'/ Brho
%     For sextupole:   K = B"/ Brho / 2
%
%  See also at2mls, hw2physics, physics2hw


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


if size(Amps,1) == 1 && length(DeviceList) > 1
    Amps = ones(size(DeviceList,1),1) * Amps;
elseif size(Amps,1) ~= size(DeviceList,1)
    error('Rows in Amps must equal rows in DeviceList or be a scalar');
end


if all(isnan(Amps))
    k = Amps;
    return
end


% Force Energy and Amps to have the same number of columns
if all(size(Energy) > 1)
    error('Energy can only be a scalar or vector');
end
Energy = Energy(:)';

if length(Energy) > 1
    if size(Amps,2) == size(Energy,2)
        % OK
    elseif size(Amps,2) > 1
        error('If Energy is a vector, then Amps can only have 1 column.');
    else
        % Amps has one column, expand to the size of Energy
        Amps = Amps * ones(1,size(Energy,2));
    end
else
    Energy = Energy * ones(1,size(Amps,2));
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
        k = BLeffPerI .* Amps ./ Brho;
    elseif strcmpi(Family, 'VCM')
        % VCM
        % Rad = BLeff / Brho
        Brho = getbrho(Energy);
        BLeffPerI = 0.002/7.  * getbrho(0.60);
        k = BLeffPerI .* Amps ./ Brho;
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
                k = Amps;
                return
            end

            C = reverse(C);
            Brho = getbrho(Energy);

            for iCol = 1:size(Amps,2)
                k(iDev,iCol) = polyval(C, Amps(iDev,iCol)) / Brho(iCol);
            end

            % This is a cluge!!!
            % I'm forcing zero amps to zero "k" for the moment (GJP)
            k(find(Amps==0)) = 0;
        end
    end
    return
end


% If you made it to here, I don't know how to convert it
k = Amps;
return

