function  [ChannelName, ErrorFlag] = getname_tls(Family, Field, DeviceList)
% ChannelName = getname_bessy2(Family, Field, DeviceList)
%
%   INPUTS
%   1. Family name
%   2. Field
%   3. DeviceList ([Sector Device #] or [element #]) (default: whole family)
%
%   OUTPUTS
%   1. ChannelName = IOC channel name corresponding to the family and DeviceList


if nargin == 0
    error('Must have at least one input (''Family'')!');
end
if nargin < 2
    Field = 'Monitor';
end
if nargin < 3
    DeviceList = [];
end

if isempty(DeviceList)
    DeviceList = getlist(Family);
elseif (size(DeviceList,2) == 1)
    DeviceList = elem2dev(Family, DeviceList);
end

ChannelName = [];

BPM_X = [
    'R1BPM0X '
    'R1BPM1X ' 
    'R2BPM0X ' 
    'R2BPM1X ' 
    'R3BPM0X ' 
    'R3BPM1X ' 
    'R4BPM0X '
    'R4BPM1X ' 
    'R5BPM0X ' 
    'R5BPM1X ' 
    'R6BPM0X ' 
    'R6BPM1X ' 
    'R7BPM0X '
    'R7BPM1X ' 
    'R8BPM0X ' 
    'R8BPM1X ' 
    'R9BPM0X ' 
    'R9BPM1X ' 
    'R10BPM0X'
    'R10BPM1X' 
    'R11BPM0X' 
    'R11BPM1X' 
    'R12BPM0X' 
    'R12BPM1X' 
    ];

BPM_Y = [
    'R1BPM0Y '
    'R1BPM1Y ' 
    'R2BPM0Y ' 
    'R2BPM1Y ' 
    'R3BPM0Y ' 
    'R3BPM1Y ' 
    'R4BPM0Y '
    'R4BPM1Y ' 
    'R5BPM0Y ' 
    'R5BPM1Y ' 
    'R6BPM0Y ' 
    'R6BPM1Y ' 
    'R7BPM0Y '
    'R7BPM1Y ' 
    'R8BPM0Y ' 
    'R8BPM1Y ' 
    'R9BPM0Y ' 
    'R9BPM1Y ' 
    'R10BPM0Y'
    'R10BPM1Y' 
    'R11BPM0Y' 
    'R11BPM1Y' 
    'R12BPM0Y' 
    'R12BPM1Y' 
    ];

HCM_PS = [
    'HCM0 '
    'HCM1 ' 
    'HCM2 ' 
    'HCM3 ' 
    'HCM4 ' 
    'HCM5 ' 
    'HCM6 ' 
    'HCM7 '
    'HCM8 ' 
    'HCM9 '
    'HCM10' 
    'HCM11'
    ];
    
VCM_PS = [
    'VCM0 '
    'VCM1 ' 
    'VCM2 ' 
    'VCM3 ' 
    'VCM4 ' 
    'VCM5 ' 
    'VCM6 '
    'VCM7 ' 
    'VCM8 ' 
    'VCM9 ' 
    'VCM10' 
    'VCM11'
    ];
   
QF_PS = [
    'R1Q10'
    'R1Q11'
    'R2Q10'
    'R2Q11'
    'R3Q10'
    'R3Q11'
    'R4Q10'
    'R4Q11'
    'R5Q10'
    'R5Q11'
    'R6Q10'
    'R6Q11'
    ];

QD_PS = [
    'R1Q20'
    'R1Q21'
    'R2Q20'
    'R2Q21'
    'R3Q20'
    'R3Q21'
    'R4Q20'
    'R4Q21'
    'R5Q20'
    'R5Q21'
    'R6Q20'
    'R6Q21'
    ];

SFQ_PS = [
    'R1QF0'
    'R1QF1'
    'R1QF2'
    'R1QF3'
    'R1QF4'
    'R1QF5'
    'R1QF6'
    'R1QF7'
    'R2QF0'
    'R2QF1'
    'R2QF2'
    'R2QF3'
    'R2QF4'
    'R2QF5'
    'R2QF6'
    'R2QF7'
    'R3QF0'
    'R3QF1'
    'R3QF2'
    'R3QF3'
    'R3QF4'
    'R3QF5'
    'R3QF6'
    'R3QF7'
    'R4QF0'
    'R4QF1'
    'R4QF2'
    'R4QF3'
    'R4QF4'
    'R4QF5'
    'R4QF6'
    'R4QF7'
    'R5QF0'
    'R5QF1'
    'R5QF2'
    'R5QF3'
    'R5QF4'
    'R5QF5'
    'R5QF6'
    'R5QF7'
    'R6QF0'
    'R6QF1'
    'R6QF2'
    'R6QF3'
    'R6QF4'
    'R6QF5'
    'R6QF6'
    'R6QF7'
    ];

SDQ_PS = [
    'R1QM0'
    'R1QM1'
    'R2QM0'
    'R2QM1'
    'R3QM0'
    'R3QM1'
    'R4QM0'
    'R4QM1'
    'R5QM0'
    'R5QM1'
    'R6QM0'
    'R6QM1'
    ];


TUNE = [
    'FX'
    'FY'
    'FS'
    ];
    
switch Family
    case 'BPMx'
        for i = 1:size(DeviceList,1)
            %ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
            ChannelName = strvcat(ChannelName,sprintf('%s', BPM_X(i,:)));
            %ChannelName{i,1} = deblank(BPM_X(i,:));
        end
    case 'BPMy'
        for i = 1:size(DeviceList,1)
            %ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
            ChannelName = strvcat(ChannelName,sprintf('%s', BPM_Y(i,:)));
            %ChannelName{i,1} = deblank(BPM_Y(i,:));
        end
    case 'HCM'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', HCM_PS(i,:)));
        end
    case 'VCM'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', VCM_PS(i,:)));
        end
    case 'QF'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', 'QF_PS'));
        end
    case 'QD'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', QF2_PS(i,:)));
              ChannelName = strvcat(ChannelName,sprintf('%s', 'QD_PS'));
        end
    case 'SFQ'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', 'SFQ_PS'));
        end
    case 'SDQ'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', 'SDQ_PS'));
        end
%     case 'S1'
%         for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'RCS1PS'));
%         end
%     case 'S2'
%         for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'RCS2PS'));
%         end
        
    case 'BD'
        for i = 1:size(DeviceList,1)
            ChannelName = strvcat(ChannelName,sprintf('%s', 'RCBDPS'));
        end
        
%     case 'BH'
%         for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'RCBHPS'));
%         end
%     case 'SWLS'
%         for i = 1:size(DeviceList,1)
% %             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'SWLSMPS'));
%         end
%     case 'IASW6'
%         for i = 1:size(DeviceList,1)
% %             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'IASWAMPS'));
%         end
%     case 'W20'
%         for i = 1:size(DeviceList,1)
% %             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'W20GAP'));
%         end
%     case 'SW6'
%         for i = 1:size(DeviceList,1)
% %             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'SMPW6MPS'));
%         end
%     case 'U9'
%         for i = 1:size(DeviceList,1)
% %             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'U9GAP'));
%         end
%     case 'U5'
%         for i = 1:size(DeviceList,1)
% %             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'U5GAP'));
%         end
%     case 'EPU56'
%         for i = 1:size(DeviceList,1)
% %             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
%             ChannelName = strvcat(ChannelName,sprintf('%s', 'EPU4GAP'));
%         end
    case 'RF'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
            ChannelName = strvcat(ChannelName,sprintf('%s', 'crrffreq'));
        end
    case 'DCCT'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
            ChannelName = strvcat(ChannelName,sprintf('%s', 'r3dccti'));
        end
    case 'TUNE'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
            ChannelName = strvcat(ChannelName,sprintf('%s', TUNE(i,:)));
        end
end

