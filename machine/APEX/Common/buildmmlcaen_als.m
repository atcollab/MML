function ao = buildmmlcaen(ao, Range)
% Caen Power Supplies
%

if nargin < 2
    Range = 5;
end

% * Correct the Position field
% * Ready?


SetupInfo = {
'Monitor',         'CurrentRBV',     'ai'
'Leakage',         'LeakageCurrent', 'ai'
'Voltage',         'OutputVoltage',  'ai'
'BulkVoltage',     'BulkVoltage',    'ai'
%'RegulatorTemp',  'ai'
%'ShuntTemp',      'ai'

'Setpoint',        'Setpoint', 'ao'
%'Kd',              'ControllerKd', 'ao'
%'Ki',              'ControllerKi', 'ao'
%'Kp',              'ControllerKp', 'ao'
'RampRate',        'SlewRate', 'ao'

'Ramping',         'Ramping', 'bi'
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
% 'GenericFault', 'bi'
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


N = size(ao.DeviceList,1);

%ao = buildmmlfamily(ao.FamilyName, ao.DeviceList);
ao.MemberOf    = {'Power Supply'; 'Caen';};
ao.Status      = ones(N,1);
ao.CommonNames  = {};
ao.ElementList = (1:N)';
ao.Position    = (1:N)';

Field     = SetupInfo(:,1);
CaenName  = SetupInfo(:,2);
FieldType = SetupInfo(:,3);

for i = 1:N
    ao.CommonNames{i,1} = sprintf('%s', ao.BaseName{i});
end

for i = 1:length(Field)
    ao.(Field{i}) = buildmmlsubfamily(FieldType{i});
    for j = 1:size(ao.DeviceList, 1)
        ao.(Field{i}).ChannelNames{j,1} = sprintf('%s:%s', ao.BaseName{j}, CaenName{i});
    end
end

ao.Monitor.HWUnits      = 'Amps';
ao.Monitor.PhysicsUnits = 'Radians';
ao.Setpoint.HWUnits      = 'Amps';
ao.Setpoint.PhysicsUnits = 'Radians';
if all(size(Range) == [1 1])
    ao.Setpoint.Range = [-ones(N,1) ones(N,1)] * Range;
else
    ao.Setpoint.Range = Range;
end
ao.Setpoint.Tolerance = .1 * ones(N,1);
ao.Voltage.HWUnits      = 'Volts';
ao.Voltage.PhysicsUnits = 'Volts';
ao.BulkVoltage.HWUnits      = 'Volts';
ao.BulkVoltage.PhysicsUnits = 'Volts';


%ao.Setpoint.SpecialFunctionSet = @setrf_apex;
%ao.Setpoint.SpecialFunctionGet = @getrf_apex;


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
