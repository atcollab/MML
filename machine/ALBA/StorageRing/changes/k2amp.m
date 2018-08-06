function [Amps, B] = k2amp(Family, Field, k, DeviceList, Energy, BranchFlag)
%K2AMP - Converts simulator values to amperes
%  [Amps, B] = k2amp(Family, Field, K, DeviceList, Energy, BranchFlag)
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
%  6. BranchFlag - 1 -> Lower branch
%                  2 -> Upper branch {Default}
%
%  OUTPUTS
%  1. Amps - Ampere
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

if nargin < 6
    BranchFlag = [];
end
if isempty(BranchFlag)
    % Default is upper branch
    BranchFlag = 2;
end


if size(k,1) == 1 & length(DeviceList) > 1
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
if size(Energy,1) > 1 & size(Energy,2) > 1
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



%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%
% if strcmpi(Family, 'HCM')
%     Brho = getbrho(Energy);
%     for i = 1:size(DeviceList,1)
%         if any(DeviceList(i,2) == [1 4])
%             BLeffPerI =  4.070e-4;  %  (Tesla-meters)
%             Leff = .5;
%         elseif any(DeviceList(i,2) == [2 3])
%             BLeffPerI =  4.070e-4;  %  (Tesla-meters)
%             Leff = .5;
%         else
%             error('Device not found in HCM family.');
%         end
% 
%         Amps(i,:) = k(i,:) .* Brho / BLeffPerI;
% 
%         if nargout >= 2
%             B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
%         end
%     end
%     return
% end
% 
% if strcmpi(Family, 'VCM')
%     Brho = getbrho(Energy);
%     for i = 1:size(DeviceList,1)
%         if any(DeviceList(i,2) == [1 4])
%             BLeffPerI =  1.711e-4;  %  (Tesla-meters)
%             Leff = .5;
%         elseif any(DeviceList(i,2) == [2 3])
%             BLeffPerI =  1.711e-4;  %  (Tesla-meters)
%             Leff = .5;
%         else
%             error('Device not found in VCM family.');
%         end
% 
%         Amps(i,:) = k(i,:) .* Brho / BLeffPerI;
% 
%         if nargout >= 2
%             B(i,:) = BLeffPerI .* Amps(i,:) ./ Leff;
%         end
%     end
%     return
% end



%%%%%%%%%%%%%%
% Skew Quads %
%%%%%%%%%%%%%%
if any(strcmpi(Family, {'SQSF','SQSD'}))
    error('Family not found.');
    return
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if any(strcmpi(Field, {'Setpoint','Monitor'}))
%     return
% end



% If you made it to here, I don't know how to convert it
Amps = k;
B = k;
return
