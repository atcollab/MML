function OutStruct = buildmmliaimotor(Family, DeviceList, Range)
% IAI Motors
%

if nargin < 3
    Range = 50;
end

%      EPICS Channels
% PCMD	ao	Position Request [ao]
% PNOW	ai	Position [mm]
% praw_	ai	Position (raw units)
% STP	bo	Stop Request
% ALMH	bi	Major Alarm
% ALML	bi	Minor Alarm
% EMGS	bi	Emergency Stop
% HEND	bi	Homed
% PEND	bi	Moving
% PWR	bi	Controller Ready
% SFTY	bi	Safety Speed
% SV	bi	Servo Ready
% HOME	bo	Home Request
% Version stringin

SetupInfo = {
    'Monitor',         'PNOW',    'ai'
    'Setpoint',        'PCMD',    'ao'
    'Moving',          'PEND',    'bi'
    'Homed',           'HEND',    'bi'
    'HomeControl',     'HOME',    'bo'
    'EmergencyStop',   'EMGS',    'bi'
    'MajorAlarm',      'ALMH',    'bi'
    'MinorAlarm',      'ALML',    'bi'
    'ControllerReady', 'PWR',     'bi'
    'ServoReady',      'SV',      'bi'
    'SafetySpeed',     'SFTY',    'bi'
    };


N = size(DeviceList,1);

%OutStruct = buildmmlfamily(Family, DeviceList);
OutStruct.FamilyName  = Family;
OutStruct.MemberOf    = {'Solenoid'; 'Motor';};
OutStruct.Status      = ones(N,1);
OutStruct.DeviceList  = DeviceList;
OutStruct.CommonNames  = {};
OutStruct.ElementList = (1:N)';
OutStruct.Position    = (1:N)';

Field     = SetupInfo(:,1);
PVName    = SetupInfo(:,2);
FieldType = SetupInfo(:,3);

for i = 1:N
    OutStruct.CommonNames{i,1} = sprintf('%s:M%d', Family, i);
end

for i = 1:length(Field)
    OutStruct.(Field{i}) = buildmmlsubfamily(FieldType{i});
    for j = 1:size(DeviceList, 1)
        OutStruct.(Field{i}).ChannelNames{j,1} = sprintf('%s:M%d:%s', Family, j, PVName{i});
    end
end

OutStruct.Monitor.HWUnits      = 'mm';
OutStruct.Monitor.PhysicsUnits = 'mm';
OutStruct.Setpoint.HWUnits      = 'mm';
OutStruct.Setpoint.PhysicsUnits = 'mm';
OutStruct.Setpoint.Range = [zeros(N,1) ones(N,1)] * Range;
OutStruct.Setpoint.Tolerance = .1 * ones(N,1);



function Output = buildmmlsubfamily(FieldType)

if strcmpi(FieldType, 'ai')
    MemberOf = {'Solenoid'; 'Motor'; 'Magnet'; 'Monitor'; 'Save';};
elseif strcmpi(FieldType, 'ao')
    MemberOf = {'Solenoid'; 'Motor'; 'Magnet'; 'Setpoint'; 'Save/Restore';};
elseif strcmpi(FieldType, 'bi')
    MemberOf = {'Solenoid'; 'Motor'; 'Magnet'; 'Boolean Monitor';};
elseif strcmpi(FieldType, 'bo')
    MemberOf = {'Solenoid'; 'Motor'; 'Magnet'; 'Boolean Control';};
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
