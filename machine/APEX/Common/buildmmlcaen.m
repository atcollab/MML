function OutStruct = buildmmlcaen(Family, DeviceList, Range, BaseName)
% Caen Power Supplies
%

if nargin < 3
    Range = 5;
end

% * Correct the Position field
% * Ready?


SetupInfo = {
'Monitor',        'CurrentRBV',     'ai'
'Leakage',        'LeakageCurrent', 'ai'
'Voltage',        'OutputVoltage',  'ai'
'BulkVoltage',    'BulkVoltage',    'ai'
'RegulatorTemp',  'RegulatorTemp',  'ai'
'ShuntTemp',      'ShuntTemp',      'ai'

'Setpoint',       'Setpoint',     'ao'
'Kd',             'ControllerKd', 'ao'
'Ki',             'ControllerKi', 'ao'
'Kp',             'ControllerKp', 'ao'

'Ramping',        'Ramping', 'bi'
% 'Crowbar', 'bi'
% 'DCunderV', 'bi'
% 'DSPerror', 'bi'
% 'ExternalInterlock1', 'bi'
% 'ExternalInterlock2', 'bi'
% 'ExternalInterlock3', 'bi'
% 'ExternalInterlock4', 'bi'
% 'ExternalInterlock5', 'bi'
% 'ExternalInterlock6', 'bi'
% 'ExternalInterlock7', 'bi'
% 'ExternalInterlock8', 'bi'
% 'FETovertemp', 'bi'
'Fault', 'GenericFault', 'bi'
% 'GenericWarning', 'bi'
% 'GroundCurrent', 'bi'
% 'GroundFault', 'bi'
% 'Local', 'bi'
% 'OverCurrent', 'bi'
% 'RegulatorFault', 'bi'
% 'RippleFault', 'bi'
% 'ShuntOvertemp', 'bi'
% 'ShuttingDown', 'bi'
% 'SlewControlRBV', 'bi'
'BulkOn', 'BulkStatus', 'bi'
'On', 'SupplyOn', 'bi'
% 'WaveformActive', 'bi'
'BulkControl', 'BulkEnable', 'bo'
'OnControl', 'Enable', 'bo'
'Reset', 'Reset', 'bo'
% 'SlewControl', 'bo'
% 'WaveformStop', 'bo'
% 'WaveformCount', 'longout'
% 'WaveformStart', 'longout'
% 'SetpointWF', 'waveform'
% 'Version', 'stringin'
};


N = size(DeviceList,1);

%OutStruct = buildmmlfamily(Family, DeviceList);
OutStruct.FamilyName  = Family;
OutStruct.MemberOf    = {'Power Supply'; 'Caen';};
OutStruct.Status      = ones(N,1);
OutStruct.DeviceList  = DeviceList;
OutStruct.CommonNames  = {};
OutStruct.ElementList = (0:N-1)';
OutStruct.Position    = (0:N-1)';

Field     = SetupInfo(:,1);
CaenName  = SetupInfo(:,2);
FieldType = SetupInfo(:,3);

for i = 1:N
    OutStruct.CommonNames{i,1} = sprintf('%s%d', Family, DeviceList(i,2));
end

for i = 1:length(Field)
    OutStruct.(Field{i}) = buildmmlsubfamily(FieldType{i});
    for j = 1:size(DeviceList, 1)
        if nargin >= 4
            OutStruct.(Field{i}).ChannelNames{j,1} = sprintf('%s:%s', BaseName{j}, CaenName{i});
        else
            OutStruct.(Field{i}).ChannelNames{j,1} = sprintf('%s%d:%s', Family, DeviceList(j,2), CaenName{i});
        end
    end
end

OutStruct.Monitor.HWUnits      = 'Amps';
OutStruct.Monitor.PhysicsUnits = 'Radians';
OutStruct.Setpoint.HWUnits      = 'Amps';
OutStruct.Setpoint.PhysicsUnits = 'Radians';
OutStruct.Setpoint.Range = [-ones(N,1) ones(N,1)] * Range;
OutStruct.Setpoint.Tolerance = .1 * ones(N,1);
OutStruct.Voltage.HWUnits      = 'Volts';
OutStruct.Voltage.PhysicsUnits = 'Volts';
OutStruct.BulkVoltage.HWUnits      = 'Volts';
OutStruct.BulkVoltage.PhysicsUnits = 'Volts';

if nargin >= 4
    OutStruct.BaseName = BaseName;
end

%OutStruct.Setpoint.SpecialFunctionSet = @setrf_apex;
%OutStruct.Setpoint.SpecialFunctionGet = @getrf_apex;


function Output = buildmmlsubfamily(FieldType)

if strcmpi(FieldType, 'ai')
    MemberOf = {'Caen'; 'Power Supply'; 'Magnet'; 'Monitor'; 'PlotFamily'; 'Save';};
elseif strcmpi(FieldType, 'ao')
    MemberOf = {'Caen'; 'Power Supply'; 'Magnet'; 'Setpoint'; 'PlotFamily'; 'Save/Restore';};
elseif strcmpi(FieldType, 'bi')
    MemberOf = {'Caen'; 'Power Supply'; 'Magnet'; 'Boolean Monitor'; 'PlotFamily';};
elseif strcmpi(FieldType, 'bo')
    MemberOf = {'Caen'; 'Power Supply'; 'Magnet'; 'Boolean Control'; 'PlotFamily';};
end

ChannelNames = {};
HW2PhysicsParams = 1;
Physics2HWParams = 1;
HWUnits      = '';
PhysicsUnits = '';

Output.MemberOf         = MemberOf;
Output.Mode             = 'Online';     % 'Online' 'Simulator', 'Manual' or 'Special'
Output.DataType         = 'Scalar';
%Output.Status           = ones(N,1);
%Output.DeviceList       = [ones(N,1) (1:N)'];
%Output.ElementList      = (1:N)';
Output.ChannelNames     = ChannelNames;
Output.HW2PhysicsParams = HW2PhysicsParams;
Output.Physics2HWParams = Physics2HWParams;
Output.Units            = 'Hardware';
Output.HWUnits          = HWUnits;
Output.PhysicsUnits     = PhysicsUnits;
