function [k, B] = ler2at(Family, Field, Value, DeviceList, Energy, BranchFlag)
%LER2AT - Converts control system values to simulator values
%  [K, B] = ler2at(Family, Field, Value, DeviceList, Energy, BranchFlag)
%
%  INPUTS
%  1. Family - Family name
%  2. Field - Sub-field (like 'Setpoint')
%  3. Value - Controls system values
%  4. DeviceList - Device list (Value and DeviceList must have the same number of rows)
%  5. Energy - Energy in GeV {Default: getenergy}
%              If Energy is a vector, each output column will correspond to that energy.
%              Energy can be anything getenergy accepts, like 'Model' or 'Online'.
%              (Note: If Energy is a vector, then Value can only have 1 column)
%  6. BranchFlag - 1 -> Lower branch
%                  2 -> Upper branch
%
%  OUTPUTS
%  1. K and B - K-value and field in AT convention
%     For dipole:      K = B / Brho
%     For quadrupole:  K = B'/ Brho
%     For sextupole:   K = B"/ Brho / 2
%
%  See also at2ler
%
%  Written by Greg Portmann


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
    if char(BranchFlag)
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


if size(Value,1) == 1 & length(DeviceList) > 1
    Value = ones(size(DeviceList,1),1) * Value;
elseif size(Value,1) ~= size(DeviceList,1)
    error('Rows in Value must equal rows in DeviceList or be a scalar');
end


if all(isnan(Value))
    k = Value;
    B = Value;
    return
end


% Force Energy and Value to have the same number of columns
if all(size(Energy) > 1)
    error('Energy can only be a scalar or vector');
end
Energy = Energy(:)';

if length(Energy) > 1
    if size(Value,2) == size(Energy,2)
        % OK
    elseif size(Value,2) > 1
        error('If Energy is a vector, then Value can only have 1 column.');
    else
        % Value has one column, expand to the size of Energy
        Value = Value * ones(1,size(Energy,2));
    end
else
    Energy = Energy * ones(1,size(Value,2));
end



%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%
% Conversions factors
% HCM:   BLeff  = K_hcm * I  (Tesla-meters)
% VCM:   BLeff  = K_vcm * I  (Tesla-meters)
% Radian = BLeff / Brho
if strcmpi(Family, 'HCM')
    C = 8.5/1000;  % Radian/kGaussMeter
    k = C * Value;
    if nargout >= 2
        B = NaN;
    end
    return
end

if strcmpi(Family, 'VCM')
    C = 8.5/1000;  % Radian/kGaussMeter
    k = C * Value;
    if nargout >= 2
        B = NaN;
    end
    return
end


%%%%%%%%%%%%%%
% Skew Quads %
%%%%%%%%%%%%%%
%if any(strcmpi(Family, {'SQSF','SQSD'}))
%    error('ler2at conversion needs to be programmed for %s.%s\n', Family, Field);
%     % Scaling factors [A/m^-2] (based on magnetic measurements of skew quadrupoles)
%     for i = 1:size(Value,1)
%         for j = 1:size(Value,2)
%             ScaleFactor = ??? * Energy(j);
%             k(i,j) = Value(i,j) / ScaleFactor;
%             if nargout >=2
%                 B(i,j) = k(i,j) * getbrho(Energy(j));
%             end
%         end
%     end
%     return
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if any(strcmpi(Field, {'Setpoint','Monitor'}))
%    error('ler2at conversion needs to be programmed for %s.%s\n', Family, Field);
%    return
%end


% If you made it to here, I don't know how to convert it
k = Value;
B = Value;
return

