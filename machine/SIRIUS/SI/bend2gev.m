function GeV = bend2gev(varargin)
%BEND2GEV - Compute the energy based on the ramp tables
% GeV = bend2gev(Family, Field, Amps, DeviceList, ModeFlag)
%
%  INPUTS
%  1. Family - Bend magnet family {Optional}
%  2. Field - Field {Optional}
%  3. Amps  - Bend magnet current {Optional}
%  4. DeviceList - Bend magnet device list to reference energy to {Default: BEND(1,1)}
%  5. ModeFlag - Model, Online, Manual {Optional}   
%
%  OUTPUTS
%  1. GeV - Electron beam energy [GeV]
%
%  See also gev2bend, getenergy
%
%  Written by Greg Portmann
%             Ximenes Resende
%  2012-07-06 'bo' changed to 'b1' - Afonso 

global THERING;

const = lnls_constants;

% Default
Family = '';
Field = '';
Amps = [];
DeviceList = [];
ModeFlag = '';  % model, online, manual
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        ModeFlag = varargin{i};
        varargin(i) = [];
    end        
end

if length(varargin) >= 1
    if ischar(varargin{1})
        Family = varargin{1};
        varargin(1) = [];
    else
        Amps = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            DeviceList = varargin{1};
            varargin(1) = [];
        end
    end
end
if length(varargin) >= 1 && ischar(varargin{1})
    Field = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    Amps = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    DeviceList = varargin{1};
end
AllMagnetsAmps = [];
FamMagnetsAmps = [];
if ~isempty(Family) && isempty(DeviceList)
    if ~isempty(Amps) && size(Amps,1) == 1
        FamMagnetsAmps = Amps;
    end
end
if isempty(Family)
    if ~isempty(Amps) && size(Amps,1) == 1
        AllMagnetsAmps = Amps;
    end
    BendFamilies = findmemberof('BEND');
    Family = BendFamilies{1};
end
if isempty(ModeFlag)
    ModeFlag = getmode(Family);
end
if isempty(Field)
    Field = 'Setpoint';
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
    if all(size(Amps)==[1 1]) || isempty(Amps)
        DeviceList = DeviceList(1,:);
    end
end

if isempty(Amps)
    if strcmpi(ModeFlag,'simulator') || strcmpi(ModeFlag,'model')
        % The model energy is used only if Amps is empty
        GeV = getenergymodel;
        return;
    else
        Amps = getpv(Family, Field, DeviceList, 'Hardware', ModeFlag);
    end
end

if size(Amps,1) == 1 && size(DeviceList,1) > 1
    Amps = ones(size(DeviceList,1),1) * Amps;
end

if isfamily('BC')  
    BCIndex = family2atindex('BC');
    BCAngle = 0;
    for i=1:size(BCIndex,1)
        for j=1:size(BCIndex,2)
            BCAngle = BCAngle + THERING{BCIndex(i,j)}.BendingAngle;
        end
    end
else
    fprintf('\n   WARNING: BC family not found in the model!\n');
    BCAngle = 0;
end

BendFamilies = findmemberof('BEND');
IntegField = 0;
for i=1:size(BendFamilies,1)
    FamName   = BendFamilies{i};
    AllIndex = family2elem(FamName); 
    ExcData   = getfamilydata(FamName, 'ExcitationCurves');
    
    if isempty(AllMagnetsAmps)
        if strcmpi(FamName, Family)
            if isempty(FamMagnetsAmps)
                AllDevices = family2dev(Family);
                DiffDevice = setdiff(AllDevices, DeviceList, 'rows');
                DiffAmps   = getpv(Family, Field, DiffDevice, 'Hardware', ModeFlag);
                Current    = zeros(size(AllIndex,1),1);
                for k = 1:size(AllDevices,1)
                    Device = AllDevices(k,:);
                    [tf ,idx] = ismember(Device, DeviceList, 'rows');
                    if tf
                        Current(k) = Amps(idx);
                    else
                        [~ ,idx] = ismember(Device, DiffDevice, 'rows');
                        Current(k) = DiffAmps(idx);
                    end
                end
            else
                Current = FamMagnetsAmps*ones(size(AllIndex,1),1);
            end
        else
            Current = getpv(FamName, Field, 'Hardware', ModeFlag);
        end
        
    else
        Current = AllMagnetsAmps*ones(size(AllIndex,1),1);
    end
    
    for j=1:length(AllIndex)
        idx = AllIndex(i);
        IntegField = IntegField + interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Current(j), 'linear', 'extrap');
    end

end

Energy_Gev = (1e-9)*sqrt((const.c^2)*(-IntegField/(2*pi-BCAngle))^2 + (const.E0*1e6)^2);
GeV = repmat(Energy_Gev,size(DeviceList,1),1);

end
