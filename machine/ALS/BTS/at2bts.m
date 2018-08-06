function [Value, B] = at2bts(Family, Field, k, DeviceList, Energy, BranchFlag)
%AT2BTS - Converts simulator values to control system values
%  [Value, B] = at2bts(Family, Field, K, DeviceList, Energy, BranchFlag)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. K - "K-value" in AT convention
%          For dipole:      K = B / Brho
%          For quadrupole:  K = B'/ Brho
%          For sextupole:   K = B"/ Brho / 2
%  4. DeviceList - Device list (Value and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Value can only have 1 column)
%  6. BranchFlag - 1 -> Lower branch
%                  2 -> Upper branch
%
%  OUTPUTS
%  1. Value - Controls system values
%
%  See also bts2at, physics2hw, hw2physics

%  Written by Greg Portmann


global THERING

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


% Hysteresis branch
if nargin < 6
    BranchFlag = [];
else
    if ischar(BranchFlag)
        if strcmpi(BranchFlag, 'Lower')
            % Lower branch
            BranchFlag = 1;
        elseif strcmpi(BranchFlag, 'Upper')
            % Upper branch
            BranchFlag = 2;
        end
    end
end
if isempty(BranchFlag)
    if strcmpi(getfamilydata('HysteresisBranch'),'Lower')
        % Lower branch
        BranchFlag = 1;
    else
        % Upper branch (default)
        BranchFlag = 2;
    end
end


if size(k,1) == 1 && length(DeviceList) > 1
    k = ones(size(DeviceList,1),1) * k;
elseif size(k,1) ~= size(DeviceList,1)
    error('Rows in K must equal rows in DeviceList or be a scalar');
end


if all(isnan(k))
    Value = k;
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
% Setpoint and Monitor fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Field, {'Setpoint','Monitor'}))

    %%%%%%%%%%%%%%%%%%%%%
    % Corrector Magnets %
    %%%%%%%%%%%%%%%%%%%%%
    % Conversions factors
    % HCM:   BLeff  = K_hcm * I  (Tesla-meters)
    % VCM:   BLeff  = K_vcm * I  (Tesla-meters)
    % Radian = BLeff / Brho
    if strcmpi(Family, 'HCM')
        C = 4.58e-4;  % Radian/kGaussMeter
        Value = k / C;
        if nargout >= 2
            B = NaN;
        end
        return
    end

    if strcmpi(Family, 'VCM')
        C = 4.58e-4;  % Radian/kGaussMeter
        Value = k / C;
        if nargout >= 2
            B = NaN;
        end
        return
    end


    %%%%%%%%%%%%%%%
    % Quadrupoles %
    %%%%%%%%%%%%%%%
    if strcmpi(Family, 'Q')
        iAT = family2atindex(Family, DeviceList);

        % L  = .300;
        Leff = .315;
        brho = getbrho(Energy);
        
        % Sign(k) for a positive power supply strength (QF or QD)
        iMML = findrowindex(DeviceList, family2dev('Q',0));
        Qsign = [
             1
            -1
            -1
            -1
             1
             1
            -1
             1
             1
            -1
            1];

        % Magnet measurements were done at .030 meters from the magnet center
        ktable = k .* brho *.03 * Leff;
        for i = 1:length(iAT)
            ktable(i,:) = Qsign(iMML(i)) * ktable(i,:);  % Absolute value should do the same thing
            Value(i,:) = interp1(THERING{iAT(i)}.MagnetMeasurements(:,2), THERING{iAT(i)}.MagnetMeasurements(:,1), ktable(i,:), 'linear', 'extrap');
        end
                    
        % Average slope
        %BprimeLeffoverI = .16 / .03 / 115;  % (T m) / (m amp)
        %Value = k /(BprimeLeffoverI / Leff);

        if nargout >= 2
            B = NaN;
        end
        return
    end
end


% If you made it to here, I don't know how to convert it
Value = k;
B = k;
return
