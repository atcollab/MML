function k = sirius_hw2ph(Family, Field, Amps, DeviceList, Energy)
%SIRIUS_HW2PH - Converts hardware (amperes) to simulator values
%
%  K = lnls1_hw2ph(Family, Field, Amps, DeviceList, Energy)
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
%     For sextupole:   K = B"/ Brho
%
%  See also lnls1_ph2hw, hw2physics, physics2hw
%
%Hist�ria
%
%2010-09-13: c�digo fonte com coment�rios iniciais.

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


ElementsIndex = dev2elem(Family,DeviceList);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setpoint and Monitor Fields %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmpi(Field, {'Setpoint','Readback','ReferenceMonitor','Monitor'}))
    Brho = getbrho(Energy);
    if any(strcmpi(Family, findmemberof('HCM'))) || any(strcmpi(Family, findmemberof('KICKER')))
        ExcData = getfamilydata(Family, 'ExcitationCurves');
        k=zeros(size(Amps,1),1);
        for i=1:length(ElementsIndex)
            idx = ElementsIndex(i);
            k(i) = - interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Amps(i), 'linear', 'extrap') / (Brho);
        end
   
    elseif any(strcmpi(Family, findmemberof('VCM'))) 
        ExcData = getfamilydata(Family, 'ExcitationCurves');
        k=zeros(size(Amps,1),1);
        for i=1:length(ElementsIndex)
            idx = ElementsIndex(i);
            k(i) = interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Amps(i), 'linear', 'extrap') / (Brho);
        end
        
    elseif any(strcmpi(Family, findmemberof('QUAD'))) || any(strcmpi(Family, findmemberof('SKEWQUAD')))
        EffLength = getleff(Family, DeviceList); 
        ExcData = getfamilydata(Family, 'ExcitationCurves');
        k=zeros(size(Amps,1),1);
        for i=1:length(ElementsIndex)
            idx = ElementsIndex(i);
            k(i) = -interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Amps(i), 'linear', 'extrap') / (Brho * EffLength(i));
        end
        
    elseif any(strcmpi(Family, findmemberof('SEXT')))
        EffLength = getleff(Family, DeviceList); 
        ExcData = getfamilydata(Family, 'ExcitationCurves');
        k=zeros(size(Amps,1),1);
        for i=1:length(ElementsIndex)
            idx = ElementsIndex(i);
            k(i) = -interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Amps(i), 'linear', 'extrap') / (Brho * EffLength(i));
        end
               
    elseif any(strcmpi(Family, findmemberof('SKEWCORR')))
        EffLength = getleff(Family, DeviceList); 
        ExcData = getfamilydata(Family, 'ExcitationCurves');
        k=zeros(size(Amps,1),1);
        for i=1:length(ElementsIndex)
            idx = ElementsIndex(i);
            k(i) = -interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Amps(i), 'linear', 'extrap') / (Brho * EffLength(i));
        end

    elseif any(strcmpi(Family, findmemberof('SEPTUM')))
        ExcData = getfamilydata(Family, 'ExcitationCurves');
        k=zeros(size(Amps,1),1);
        for i=1:length(ElementsIndex)
            idx = ElementsIndex(i);
            k(i) = -interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Amps(i), 'linear', 'extrap') / (Brho) ;
        end
              
    else
        k = Amps;
    end
    
    return
end


% If you made it to here, I don't know how to convert it
k = Amps;
return

