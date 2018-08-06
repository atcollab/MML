function ao = buildmmlbpmfamily(ao, SubMachine)
% New BPM
%
if nargin < 2
    SubMachine = 'StorageRing';
end

Family = 'BPM';

AFE  = [];
IP   = [];
Cell = [];
if strcmpi(SubMachine, 'SRTest')
    % Note: this is an MML naming list, eventhough the basename is cable labeling
    Family = 'BPMTest';
    DeviceList  = [
        1     2  % Test
        1     4  % Test
        1     5  % Test
        1     6  % Test 
        2     4
        2     5
        2     7
        2     9
        3     2
        3     4
        3     5
        3     7
        4     4
        4     5  % EEBI
        4     6  % EEBI
        5     4
        5     5
        5     7
        6     4
        6     5
        6     7
        
        6     10
        6     11
        6     12
        7     1
        
        7     4
        7     5
        7     7
        8     4
        8     5  % EEBI
        8     6  % EEBI
        9     4
        9     5
        9     7
       10     4
       10     5
       10     7
       11     4
       11     5
       11     7
       12     4
       12     5  % EEBI
       12     6  % EEBI
       12     9
        ];
elseif strcmpi(SubMachine, 'StorageRing')
    % Note: this is an MML naming list, eventhough the basename is cable labeling
    % Sector Dev AFE (#.Rev) IP (131.243.95.)
    d  = [  
        1     3   84.4 16   % was 1.4
       %1     6   53.4 19
        1     7   36.4 20
        1     8   10.4 21
        1     9    5.4 22
        2     3    8.4 25
        2     8   19.4 29
        3     3   22.4 32
        3     8   30.4 37
        3     9   23.4 38
        4     2   25.4 39
        4     3   26.4 40
        4     8   28.4 45
        4     9   20.4 46
        5     2   34.4 47
        5     3   37.4 48
        5     8   24.4 53
        5     9   59.4 54     % was 1.3 (Rev 3!!!)
        6     2    3.4 55
        6     3   12.4 56
        6     8   38.4 61
        6     9   40.4 62
        7     2   33.4 63
        7     3    9.4 64
        7     8   13.4 69
        7     9   39.4 70
        8     2   43.4 71
        8     3   47.4 72
        8     8   45.4 77
        8     9   48.4 78
        9     2   44.4 79
        9     3   46.4 80
        9     8   16.4 85
        9     9   32.4 86
       10     2   41.4 87
       10     3   42.4 88
       10     8    7.4 93
       10     9    6.4 94
       11     2   18.4 95
       11     3   15.4 96
       11     8   14.4 101
       11     9   11.4 102
       12     2    2.4 103
       12     3    4.4 104
       12     8   17.4 109
       %12     9   61.4 110
       ];
   DeviceList = d(:,1:2);
   AFE = d(:,3);
   Cell = d(:,1);
   for i = 1:size(d,1)
       IP{i,1}  = sprintf('131.243.95.%d', d(i,4));
       
       % Cell controller sector number doesn't match device list numbering for straight section BPMs
       if  d(i,2) >= 10
            Cell(i) = Cell(i) + 1;
       end
   end
elseif strcmpi(SubMachine, 'BTS')
    DeviceList  = [
        1     1
        1     2
        1     3
        1     4
        1     5
        1     6];
elseif any(strcmpi(SubMachine, {'BR','Booster'}))
    DeviceList  = [
        1     2
        1     3
        1     4
        1     6
        1     8
        2     2
        2     3
        2     4
        2     6
        2     8
        3     2
        3     3
        3     4
        3     6
        3     8
        4     2
        4     3
        4     4
        4     6
        4     8
        ];
elseif strcmpi(SubMachine, 'GTB')
    DeviceList  = [
        1     1
        1     2
        2     1
        2     2
        3     1
        3     2
      %  3     3  % FC?
        3     4
        3     5
        3     6
        3     7
        ];
end

ao.(Family).FamilyName  = Family;
ao.(Family).MemberOf    = {};
ao.(Family).Status      = ones(size(DeviceList,1),1);
ao.(Family).ElementList = dev2elem('BPMx', DeviceList);
ao.(Family).DeviceList  = DeviceList;
ao.(Family).Cell = Cell;
ao.(Family).FOFB = [];
ao.(Family).AFE = AFE;
ao.(Family).IP = IP;

% Just placeholders (effects the order in plotfamily, etc.)
ao.(Family).BaseName = [];
ao.(Family).X = [];
ao.(Family).Y = [];
ao.(Family).Q = [];
ao.(Family).S = [];

ao.(Family).PTA     = buildmmlsubfamily('bo');
ao.(Family).PTB     = buildmmlsubfamily('bo');
ao.(Family).PTAttn  = buildmmlsubfamily('ao');

for i = 1:size(DeviceList,1)
    if strcmpi(SubMachine, 'StorageRing') || strcmpi(SubMachine, 'SRTest')
        ao.(Family).FOFB(i,1) = 16*(DeviceList(i,1)-1) + DeviceList(i,2)-1;
        
        if DeviceList(i,2) == 10
            ao.(Family).BaseName{i,1}            = sprintf('SR%02dS:IDBPM%d',       DeviceList(i,1)+1, 1);
            ao.(Family).PTA.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptA%dOutput', DeviceList(i,1), 0);
            ao.(Family).PTB.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptB%dOutput', DeviceList(i,1), 0);
            ao.(Family).PTAttn.ChannelNames{i,1} = sprintf('SR%02d:CC:pt%dAtten',   DeviceList(i,1), 0);
        elseif DeviceList(i,2) == 11
            ao.(Family).BaseName{i,1}            = sprintf('SR%02dS:IDBPM%d',       DeviceList(i,1)+1, 3);
            ao.(Family).PTA.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptA%dOutput', DeviceList(i,1)+1, 11);
            ao.(Family).PTB.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptB%dOutput', DeviceList(i,1)+1, 11);
            ao.(Family).PTAttn.ChannelNames{i,1} = sprintf('SR%02d:CC:pt%dAtten',   DeviceList(i,1)+1, 11);
        elseif DeviceList(i,2) == 12
            ao.(Family).BaseName{i,1}            = sprintf('SR%02dS:IDBPM%d',       DeviceList(i,1)+1, 4);
            ao.(Family).PTA.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptA%dOutput', DeviceList(i,1)+1, 10);
            ao.(Family).PTB.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptB%dOutput', DeviceList(i,1)+1, 10);
            ao.(Family).PTAttn.ChannelNames{i,1} = sprintf('SR%02d:CC:pt%dAtten',   DeviceList(i,1)+1, 10);
        elseif DeviceList(i,2) == 1
            ao.(Family).BaseName{i,1}            = sprintf('SR%02dS:IDBPM%d',       DeviceList(i,1), 2);
            ao.(Family).PTA.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptA%dOutput', DeviceList(i,1), 9);
            ao.(Family).PTB.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptB%dOutput', DeviceList(i,1), 9);
            ao.(Family).PTAttn.ChannelNames{i,1} = sprintf('SR%02d:CC:pt%dAtten',   DeviceList(i,1), 9);
        else
            ao.(Family).BaseName{i,1}            = sprintf('SR%02dC:BPM%d',         DeviceList(i,1), DeviceList(i,2)-1);
            ao.(Family).PTA.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptA%dOutput', DeviceList(i,1), 10-DeviceList(i,2));
            ao.(Family).PTB.ChannelNames{i,1}    = sprintf('SR%02d:CC:ptB%dOutput', DeviceList(i,1), 10-DeviceList(i,2));
            ao.(Family).PTAttn.ChannelNames{i,1} = sprintf('SR%02d:CC:pt%dAtten',   DeviceList(i,1), 10-DeviceList(i,2));
        end
        
        % Pilot tone control
        % SR07:CC:pt0Attn		SR08S:IDBPM1:PT:Attn	7 10
        % SR07:CC:pt1Attn		SR07C:BPM8:PT:Attn	7 9
        % SR07:CC:pt2Attn		SR07C:BPM7:PT:Attn	7 8
        % SR07:CC:pt3Attn		SR07C:BPM6:PT:Attn	7 7
        % SR07:CC:pt4Attn		SR07C:BPM5:PT:Attn
        % SR07:CC:pt5Attn		SR07C:BPM4:PT:Attn
        % SR07:CC:pt6Attn		SR07C:BPM3:PT:Attn
        % SR07:CC:pt7Attn		SR07C:BPM2:PT:Attn
        % SR07:CC:pt8Attn		SR07C:BPM1:PT:Attn	 7 2
        % SR07:CC:pt9Attn		SR07S:IDBPM2:PT:Attn 7 1
        % SR07:CC:pt10Attn		SR07S:IDBPM4:PT:Attn	6 12
        % SR07:CC:pt11Attn		SR07S:IDBPM3:PT:Attn	6 11
        
        
    elseif strcmpi(SubMachine, 'Booster')
        ao.(Family).BaseName{i,1} = sprintf('BR%d:BPM%d', DeviceList(i,1), DeviceList(i,2));
    elseif strcmpi(SubMachine, 'BTS')
        ao.(Family).BaseName{i,1} = sprintf('BTS:BPM%d', DeviceList(i,2));
    elseif strcmpi(SubMachine, 'GTB')
        if DeviceList(i,1) == 1
            ao.(Family).BaseName{i,1} = sprintf('GTL:BPM%d', DeviceList(i,2));
        elseif DeviceList(i,1) == 2
            ao.(Family).BaseName{i,1} = sprintf('LN:BPM%d', DeviceList(i,2));
        else
            ao.(Family).BaseName{i,1} = sprintf('LTB:BPM%d', DeviceList(i,2));
        end
    end
end
%ao.(Family).BPM.DeviceType{i,1} = '';

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
    
    'PTHiA',    'ADC3:ptHiMag',   'ai'
    'PTHiB',    'ADC1:ptHiMag',   'ai'
    'PTHiC',    'ADC2:ptHiMag',   'ai'
    'PTHiD',    'ADC0:ptHiMag',   'ai'
    
    'PTLoA',    'ADC3:ptLoMag',    'ai'
    'PTLoB',    'ADC1:ptLoMag',    'ai'
    'PTLoC',    'ADC2:ptLoMag',    'ai'
    'PTLoD',    'ADC0:ptLoMag',    'ai'
    
    'FOFBIndex',  'FOFBindex',     'ai'
    'SampleRate', 'AFE:adcRate',   'ai'

    'Attn',    'attenuation',      'ao'
    
    'PTControl', 'autotrim:control', 'ao'
    'PTStatus',  'autotrim:status',  'bi'

    'ADC_Arm',   'wfr:ADC:arm',   'bo'
    'ADC_Armed', 'wfr:ADC:armed', 'bi'
    'ADC_A',     'wfr:ADC:A',     'waveform'
    'ADC_B',     'wfr:ADC:B',     'waveform'
    'ADC_C',     'wfr:ADC:C',     'waveform'
    'ADC_D',     'wfr:ADC:D',     'waveform'
    'ADC_TriggerMask', 'wfr:ADC:triggerMask', 'ao'
    
    'TBT_Arm',   'wfr:TBT:arm',   'bo'
    'TBT_Armed', 'wfr:TBT:armed', 'bi'
    'TBT_X',     'wfr:TBT:X',     'waveform'
    'TBT_Y',     'wfr:TBT:Y',     'waveform'
    'TBT_Q',     'wfr:TBT:Q',     'waveform'
    'TBT_S',     'wfr:TBT:S',     'waveform'
    'TBT_TriggerMask', 'wfr:TBT:triggerMask', 'ao'
    
    'FA_Arm',    'wfr:FA:arm',   'bo'
    'FA_Armed',  'wfr:FA:armed', 'bi'
    'FA_X',      'wfr:FA:X',     'waveform'
    'FA_Y',      'wfr:FA:Y',     'waveform'
    'FA_Q',      'wfr:FA:Q',     'waveform'
    'FA_S',      'wfr:FA:S',     'waveform'
    'FA_TriggerMask', 'wfr:FA:triggerMask', 'ao'
        
    'EVR_GunOn_Mask',   'EVR:event36trig',  'ao'
    'EVR_PreExt_Mask',  'EVR:event48trig',  'ao'
    'EVR_PostExt_Mask', 'EVR:event70trig',  'ao'
    'EVR_HB_Mask',      'EVR:event122trig', 'ao'
        
    'X_RMS_10k',  'SA:RMS:wide:X', 'ai'
    'Y_RMS_10k',  'SA:RMS:wide:Y', 'ai'

    'X_RMS_200',  'SA:RMS:narrow:X', 'ai'
    'Y_RMS_200',  'SA:RMS:narrow:Y', 'ai'

    % 'SetpointWF', 'waveform'
    % 'Version', 'stringin'
    };


% SR02:CC:AWGpattern  is this a large waveform?  getpvonline('SR02:CC:AWGpattern','Waveform',10)
% SR02:CC:BPMsetpoints
% SR11:CC:FOFB_KI
% SR11:CC:FOFBgains
% SR11:CC:FOFBlimits
% SR11:CC:FOFBlist


N = size(ao.(Family).DeviceList,1);

%ao = buildmmlfamily(ao.(Family).FamilyName, ao.(Family).DeviceList);
ao.(Family).MemberOf    = {'BPM';};
ao.(Family).Status      = ones(N,1);
ao.(Family).CommonNames  = {};
ao.(Family).ElementList = (1:N)';
ao.(Family).Position    = (1:N)';

Field     = SetupInfo(:,1);
Postfix   = SetupInfo(:,2);
FieldType = SetupInfo(:,3);

for i = 1:N
    ao.(Family).CommonNames{i,1} = sprintf('BPM(%d,%d)', DeviceList(i,:));
end

for i = 1:length(Field)
    ao.(Family).(Field{i}) = buildmmlsubfamily(FieldType{i});
    for j = 1:size(ao.(Family).DeviceList, 1)
        ao.(Family).(Field{i}).ChannelNames{j,1} = sprintf('%s:%s', ao.(Family).BaseName{j}, Postfix{i});
    end
end

ao.(Family).X.HWUnits      = 'mm';
ao.(Family).X.PhysicsUnits = 'Meters';

ao.(Family).Y.HWUnits      = 'mm';
ao.(Family).Y.PhysicsUnits = 'Meters';


ao.(Family).XGoldenSetpoint = buildmmlsubfamily('ao');
ao.(Family).XGoldenSetpoint.SpecialFunctionGet = @getgoldenorbit_fofb;
ao.(Family).XGoldenSetpoint.SpecialFunctionSet = @setgoldenorbit_fofb;

ao.(Family).YGoldenSetpoint = buildmmlsubfamily('ao');
ao.(Family).YGoldenSetpoint.SpecialFunctionGet = @getgoldenorbit_fofb;
ao.(Family).YGoldenSetpoint.SpecialFunctionSet = @setgoldenorbit_fofb;

%ao.(Family).Setpoint.SpecialFunctionSet = @setpv_x;
%ao.(Family).Setpoint.SpecialFunctionGet = @getpv_x;


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
