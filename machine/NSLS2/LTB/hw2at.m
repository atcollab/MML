function [k, B] = hw2at(Family, Field, Value, DeviceList, Energy, BranchFlag)
%HW2AT - Converts control system values to simulator values
%  [K, B] = hw2at(Family, Field, Value, DeviceList, Energy, BranchFlag)
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
% See also at2hw

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


if size(Value,1) == 1 && length(DeviceList) > 1
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
% HCM   BLeff  =  10-3 * I  (Tesla-meters)
% Rad = BLeff / Brho
if strcmpi(Family, 'HCM')
    Brho = getbrho(Energy);
    for i = 1:size(DeviceList,1)
        if any(DeviceList(i,2) == [3 4])
            BLeffPerI = 1e-3;  %  (Tesla-meters)
            Leff = .2;
        elseif any(DeviceList(i,2) == [1 2 5 6 7 8])
            BLeffPerI = 1e-3;  %  (Tesla-meters)
            Leff = .15;
        else
            error('Device not found in HCM family.');
        end
        
        k(i,:) = BLeffPerI .* Value(i,:) ./ Brho;

        if nargout >= 2
            B(i,:) = BLeffPerI .* Value(i,:) ./ Leff;
        end
    end
        
    % physics2hw expects real units 
    return
end

% VCM   BLeff  =  10-3 * I  (Tesla-meters)
% Rad = BLeff / Brho
if strcmpi(Family, 'VCM')
    Brho = getbrho(Energy);
    for i = 1:size(DeviceList,1)
        if any(DeviceList(i,2) == [3 4])
            BLeffPerI = 1e-3;  %  (Tesla-meters)
            Leff = .2;
        elseif any(DeviceList(i,2) == [1 2 5 6 7 8])
            BLeffPerI = 1e-3;  %  (Tesla-meters)
            Leff = .15;
        else
            error('Device not found in VCM family.');
        end
        
        k(i,:) = BLeffPerI .* Value(i,:) ./ Brho;

        if nargout >= 2
            B(i,:) = BLeffPerI .* Value(i,:) ./ Leff;
        end
    end
        
    % physics2hw expects real units 
    return
end


%%%%%%%%%%%%%%%%%%%%%%
% Quadrupole Magnets %
%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(Family, 'Q')
    Brho  = getbrho(Energy);
    Brho3 = getbrho(.3);
    for i = 1:size(DeviceList,1)
        if any(DeviceList(i,2) == [5 6])
            C = 15 / 160;
        elseif any(DeviceList(i,2) == [1 2 3 4 7 8 9 10 11 12 13 14 15])
            C = 15 / 160;
        else
            error('Device not found in Q family.');
        end
        
        k(i,:) = C .* Value(i,:) * Brho3 ./ Brho;

        if nargout >= 2
            % Field strength at the present energy
            B(i,:) = k(i,:) .* Brho;
        end
    end
        
    % physics2hw expects real units 
    return
end



%%%%%%%%%%%%%%%%
% BEND Magnets %
%%%%%%%%%%%%%%%%
% BEND  BLeff  =  ??-3 * I  (Tesla-meters)
% Rad = BLeff / Brho
%     BendingAngle: 0.2250
%    EntranceAngle: 0.1125
%        ExitAngle: 0.1125

if strcmpi(Family, 'BEND')
    % 110A -> 0.2250 rad @ 250 MeV
    Brho = getbrho(Energy);
    Leff = .35;
    
    for i = 1:size(DeviceList,1)
        if any(DeviceList(i,2) == [1 2])
            BLeffPerI = .225 * getbrho(.26) / 110;
        elseif any(DeviceList(i,2) == [3 4])
            BLeffPerI = -1 * .225 * getbrho(.26) / 110;
        end
        
        k(i,:) = BLeffPerI .* Value(i,:) ./ Brho;

        if nargout >= 2
            B(i,:) = BLeffPerI .* Value(i,:) ./ Leff;
        end
    end
    
    % physics2hw expects real units 
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if any(strcmpi(Field, {'Setpoint','Monitor'}))
%    error('sps2at conversion needs to be programmed for %s.%s\n', Family, Field);
%    return
%end


% If you made it to here, I don't know how to convert it
k = Value;
B = Value;
return

