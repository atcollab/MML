function Amps = gev2bend(varargin)
%GEV2BEND - Compute the energy based on the ramp tables
% Amps = gev2bend(Family, Field, GeV, DeviceList)
%
%  INPUTS
%  1. Bend - Bend magnet family {Optional}
%  2. Field - Field {Optional}
%  3. GeV - Electron beam energy [GeV]
%  4. DeviceList - Bend magnet device list to reference energy to {Default: BEND(1,1)}
%
%  OUTPUTS
%  1. Amps - Bend magnet current [Amps]
%
%  See also bend2gev, getenergy

%  Written by Greg Portmann

global THERING;

const = lnls_constants;

% Default
Family = '';
Field = '';
GeV = [];
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
        GeV = varargin{1};
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
    GeV = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    DeviceList = varargin{1};
    varargin(1) = [];
end

if isempty(Family)
    BendFamilies = findmemberof('BEND');
    Family = BendFamilies{1};
end
if isempty(Field)
    Field = 'Setpoint';
end
if isempty(ModeFlag)
    ModeFlag = getmode(Family);
end

if isempty(GeV)
    if strcmpi(ModeFlag,'simulator') || strcmpi(ModeFlag,'model')
        GeV = getenergymodel;
    else
        error('GeV input required');
    end
end

if isempty(DeviceList)
    DeviceList = family2dev(Family);
    if all(size(GeV)==[1 1])
        DeviceList = DeviceList(1,:);
    end
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
SumIntegratedFields = 0;

for i=1:size(BendFamilies,1)
    FamName         = BendFamilies{i};
    ElemIndex       = family2elem(FamName);
    ExcData         = getfamilydata(FamName, 'ExcitationCurves');    
    
    if strcmpi(ModeFlag,'simulator') || strcmpi(ModeFlag,'model')
        brho = getbrho(ModeFlag);
        IntegratedField = zeros(size(ElemIndex, 1),1);
        ATIndex = family2atindex(FamName);
        for j=1:length(ElemIndex)
            for k=1:size(ATIndex,2)
                DeflectionAngle = THERING{ATIndex(j,k)}.BendingAngle + THERING{ATIndex(j,k)}.PolynomB(1)*THERING{ATIndex(j,k)}.Length;
                IntegratedField(j) = IntegratedField(j) - DeflectionAngle*brho;
            end
        end
        
    else
        Current = getpv(FamName, Field, 'Hardware', ModeFlag);
        IntegratedField = zeros(size(ElemIndex, 1),1);
        for j=1:length(ElemIndex)
            idx = ElemIndex(i);
            IntegratedField(j) = interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), Current(j), 'linear', 'extrap');
        end
    end
    
    SumIntegratedFields = SumIntegratedFields + sum(IntegratedField);
    if strcmpi(FamName, Family)
        FamilyExcData = ExcData;
        FamilyIntegratedField = IntegratedField;
    end
end  

alpha = (2*pi - BCAngle)*(1/const.c)*(sqrt((GeV*1e9).^2 - (const.E0*1e6)^2))/ abs(SumIntegratedFields);

ElementsIndex = dev2elem(Family,DeviceList);
IntegratedField = alpha.*FamilyIntegratedField;
Amps = zeros(size(ElementsIndex,1),1);
for i=1:length(ElementsIndex)
    idx = ElementsIndex(i);
    Amps(i) = interp1(FamilyExcData.data{idx}(:,2), FamilyExcData.data{idx}(:,1), IntegratedField(idx), 'linear', 'extrap');
end

end



