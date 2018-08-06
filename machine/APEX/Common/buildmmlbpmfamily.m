function ao = buildmmlbpmfamily(ao, SubMachine)
% New BPM
%
if nargin < 2
    SubMachine = 'Gun';
end

Family = 'BPM';

if strcmpi(SubMachine, 'Gun')
    DeviceList  = [
      % 1  1
        1  2
        1  3
        1  4
        1  5
        ];
end

ao.FamilyName  = Family;
ao.MemberOf    = {'BPM'};
ao.Status      = ones(size(DeviceList,1),1);
ao.DeviceList  = DeviceList;
ao.ElementList = DeviceList(:,2);

for i = 1:size(DeviceList,1)
    if strcmpi(SubMachine, 'Gun')
        ao.BaseName{i,1} = sprintf('Gun:BPM%d', DeviceList(i,2));
    end
end
%ao.BPM.DeviceType{i,1} = '';

% A=c3  B=c1  C=c2  D=c0
SetupInfo = {
    'X',        'SA:X',     'ai'
    'Y',        'SA:Y',     'ai'
    'Q',        'SA:Q',     'ai'
    'S',        'SA:S',     'ai'
    
    'Apeak',    'ADC3:peak',     'ai'
    'Bpeak',    'ADC1:peak',     'ai'
    'Cpeak',    'ADC2:peak',     'ai'
    'Dpeak',    'ADC0:peak',     'ai'
    
    'A',        'ADC3:rfMag',     'ai'
    'B',        'ADC1:rfMag',     'ai'
    'C',        'ADC2:rfMag',     'ai'
    'D',        'ADC0:rfMag',     'ai'
    
    'ptHiA',    'ADC3:ptHiMag',   'ai'
    'ptHiB',    'ADC1:ptHiMag',   'ai'
    'ptHiC',    'ADC2:ptHiMag',   'ai'
    'ptHiD',    'ADC0:ptHiMag',   'ai'
    
    'ptLoA',    'ADC3:ptLoMag',    'ai'
    'ptLoB',    'ADC1:ptLoMag',    'ai'
    'ptLoC',    'ADC2:ptLoMag',    'ai'
    'ptLoD',    'ADC0:ptLoMag',    'ai'
    
    'Attn',    'attenuation',    'ao'

    'ADC_Arm',   'wfr:ADC:arm',   'bo'
    'ADC_Armed', 'wfr:ADC:armed', 'bi'
    'ADC_X',     'wfr:ADC:A',     'waveform'
    'ADC_Y',     'wfr:ADC:B',     'waveform'
    'ADC_Q',     'wfr:ADC:C',     'waveform'
    'ADC_S',     'wfr:ADC:D',     'waveform'
    
    'TBT_Arm',   'wfr:TBT:arm',   'bo'
    'TBT_Armed', 'wfr:TBT:armed', 'bi'
    'TBT_X',     'wfr:TBT:X',     'waveform'
    'TBT_Y',     'wfr:TBT:Y',     'waveform'
    'TBT_Q',     'wfr:TBT:Q',     'waveform'
    'TBT_S',     'wfr:TBT:S',     'waveform'
    
    'FA_Arm',    'wfr:FA:arm',   'bo'
    'FA_Armed',  'wfr:FA:armed', 'bi'
    'FA_X',      'wfr:FA:X',     'waveform'
    'FA_Y',      'wfr:FA:Y',     'waveform'
    'FA_Q',      'wfr:FA:Q',     'waveform'
    'FA_S',      'wfr:FA:S',     'waveform'
    
    % 'SetpointWF', 'waveform'
    % 'Version', 'stringin'
    };


N = size(ao.DeviceList,1);

%ao = buildmmlfamily(ao.FamilyName, ao.DeviceList);
ao.MemberOf    = {'BPM';};
ao.Status      = ones(N,1);
ao.CommonNames  = {};
ao.ElementList = (1:N)';
ao.Position    = (1:N)';

Field     = SetupInfo(:,1);
Postfix   = SetupInfo(:,2);
FieldType = SetupInfo(:,3);

for i = 1:N
    ao.CommonNames{i,1} = sprintf('BPM(%d,%d)', DeviceList(i,:));
end

for i = 1:length(Field)
    ao.(Field{i}) = buildmmlsubfamily(FieldType{i});
    for j = 1:size(ao.DeviceList, 1)
        ao.(Field{i}).ChannelNames{j,1} = sprintf('%s:%s', ao.BaseName{j}, Postfix{i});
    end
end

ao.X.HWUnits      = 'mm';
ao.X.PhysicsUnits = 'Meters';

ao.Y.HWUnits      = 'mm';
ao.Y.PhysicsUnits = 'Meters';

%ao.Setpoint.SpecialFunctionSet = @setpv_x;
%ao.Setpoint.SpecialFunctionGet = @getpv_x;


function ao = buildmmlsubfamily(FieldType)

if strcmpi(FieldType, 'ai')
    MemberOf = {'BPM'; 'Monitor'; 'PlotFamily'; };  % 'Save';
elseif strcmpi(FieldType, 'ao')
    MemberOf = {'BPM'; 'Setpoint'; 'PlotFamily';};
elseif strcmpi(FieldType, 'bi')
    MemberOf = {'BPM'; 'Boolean Monitor'; 'PlotFamily';};
elseif strcmpi(FieldType, 'bo')
    MemberOf = {'BPM'; 'Boolean Control'; 'PlotFamily';};
elseif strcmpi(FieldType, 'waveform')
    MemberOf = {'BPM'; 'Waveform';};
else
    MemberOf = {'BPM';};
end

ChannelNames = {};
HW2PhysicsParams = 1;
Physics2HWParams = 1;
HWUnits      = '';
PhysicsUnits = '';

ao.MemberOf         = MemberOf;
ao.Mode             = 'Online';     % 'Online' 'Simulator', 'Manual' or 'Special'
ao.DataType         = 'Scalar';
%ao.Status           = ones(N,1);
%ao.DeviceList       = [ones(N,1) (1:N)'];
%ao.ElementList      = (1:N)';
ao.ChannelNames     = ChannelNames;
ao.HW2PhysicsParams = HW2PhysicsParams;
ao.Physics2HWParams = Physics2HWParams;
ao.Units            = 'Hardware';
ao.HWUnits          = HWUnits;
ao.PhysicsUnits     = PhysicsUnits;




%     'SR01C:BPM1'
%     'SR01C:BPM2'
%     'SR01C:BPM4'
%     'SR01C:BPM6'
%     'SR01C:BPM7'
%     'SR01C:BPM8'
%     'SR02C:BPM2'
%     'SR02C:BPM7'
%     'SR03C:BPM2'
%     'SR03C:BPM7'
%     'SR03C:BPM8'
%     'SR04C:BPM1'
%     'SR04C:BPM2'
%     'SR04C:BPM7'
%     'SR04C:BPM8'
%     'SR05C:BPM1'
%     'SR05C:BPM2'
%     'SR05C:BPM7'
%     'SR05C:BPM8'
%     'SR06C:BPM1'
%     'SR06C:BPM2'
%     'SR06C:BPM7'
%     'SR06C:BPM8'
%     'SR07C:BPM1'
%     'SR07C:BPM2'
%     'SR07C:BPM7'
%     'SR07C:BPM8'
%     'SR08C:BPM1'
%     'SR08C:BPM2'
%     'SR08C:BPM7'
%     'SR08C:BPM8'
%     'SR09C:BPM1'
%     'SR09C:BPM2'
%     'SR09C:BPM7'
%     'SR09C:BPM8'
%     'SR10C:BPM1'
%     'SR10C:BPM2'
%     'SR10C:BPM7'
%     'SR10C:BPM8'
%     'SR11C:BPM1'
%     'SR11C:BPM2'
%     'SR11C:BPM7'
%     'SR11C:BPM8'
%     'SR12C:BPM1'
%     'SR12C:BPM2'
%     'SR12C:BPM7'
