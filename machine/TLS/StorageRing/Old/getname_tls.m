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
    'R1BPM2X ' 
    'R1BPM3X ' 
    'R1BPM4X ' 
    'R1BPM5X ' 
    'R1BPM6X ' 
    'R1BPM7X '
    'R1BPM8X '
    'R1BPM9X ' 
    'R2BPM0X ' 
    'R2BPM1X ' 
    'R2BPM2X ' 
    'R2BPM3X '
    'R2BPM4X '
    'R2BPM5X ' 
    'R2BPM6X '
    'R2BPM7X ' 
    'R2BPM8X ' 
    'R2BPM9X '
    'R3BPM0X ' 
    'R3BPM1X ' 
    'R3BPM2X ' 
    'R3BPM3X ' 
    'R3BPM4X ' 
    'R3BPM4AX'
    'R3BPM5AX' 
    'R3BPM5X ' 
    'R3BPM6X ' 
    'R3BPM7X ' 
    'R3BPM8X ' 
    'R4BPM0X '  
    'R4BPM1X ' 
    'R4BPM2X ' 
    'R4BPM3X ' 
    'R4BPM4X ' 
    'R4BPM5X ' 
    'R4BPM6X ' 
    'R4BPM7X ' 
    'R4BPM8X '
    'R4BPM9X ' 
    'R5BPM0X ' 
    'R5BPM1X ' 
    'R5BPM2X ' 
    'R5BPM3X ' 
    'R5BPM4X '
    'R5BPM5X ' 
    'R5BPM6X ' 
    'R5BPM7X '
    'R5BPM8X ' 
    'R5BPM9X ' 
    'R6BPM0X ' 
    'R6BPM1X ' 
    'R6BPM2X '
    'R6BPM3X ' 
    'R6BPM4X ' 
    'R6BPM5X ' 
    'R6BPM6X ' 
    'R6BPM7X '
    ];

BPM_Y = [
    'R1BPM0Y '
    'R1BPM1Y ' 
    'R1BPM2Y ' 
    'R1BPM3Y ' 
    'R1BPM4Y ' 
    'R1BPM5Y ' 
    'R1BPM6Y ' 
    'R1BPM7Y '
    'R1BPM8Y '
    'R1BPM9Y ' 
    'R2BPM0Y ' 
    'R2BPM1Y ' 
    'R2BPM2Y ' 
    'R2BPM3Y '
    'R2BPM4Y '
    'R2BPM5Y ' 
    'R2BPM6Y '
    'R2BPM7Y ' 
    'R2BPM8Y ' 
    'R2BPM9Y '
    'R3BPM0Y ' 
    'R3BPM1Y ' 
    'R3BPM2Y ' 
    'R3BPM3Y ' 
    'R3BPM4Y ' 
    'R3BPM4AY'
    'R3BPM5AY' 
    'R3BPM5Y ' 
    'R3BPM6Y ' 
    'R3BPM7Y ' 
    'R3BPM8Y ' 
    'R4BPM0Y '  
    'R4BPM1Y ' 
    'R4BPM2Y ' 
    'R4BPM3Y ' 
    'R4BPM4Y ' 
    'R4BPM5Y ' 
    'R4BPM6Y ' 
    'R4BPM7Y ' 
    'R4BPM8Y '
    'R4BPM9Y ' 
    'R5BPM0Y ' 
    'R5BPM1Y ' 
    'R5BPM2Y ' 
    'R5BPM3Y ' 
    'R5BPM4Y '
    'R5BPM5Y ' 
    'R5BPM6Y ' 
    'R5BPM7Y '
    'R5BPM8Y ' 
    'R5BPM9Y ' 
    'R6BPM0Y ' 
    'R6BPM1Y ' 
    'R6BPM2Y '
    'R6BPM3Y ' 
    'R6BPM4Y ' 
    'R6BPM5Y ' 
    'R6BPM6Y ' 
    'R6BPM7Y '
    ];

HCM_PS = [
    'RCHCPS10 '
    'RCHCPS10A'
    'RCHCPS11 '
    'RCHCPS11A'
    'RCHCSPS11'
    'RCHCSPS12'
    'RCHCPS12A'
    'RCHCPS12 '
    'RCHCPS13 '
    'RCHCPS20 '
    'RCHCPS21 '
    'RCHCPS21A'
    'RCHCSPS21'
    'RCHCSPS22'
    'RCHCPS22A'
    'RCHCPS22 '
    'RCHCPS23 '
    'RCHCPS30 '
    'RCHCPS31 '
    'RCHCPS31A'
    'RCHCSPS31'
    'RCHCSPS32'
    'RCHCPS32 '
    'RCHCPS33 '
    'RCHCPS40 '
    'RCHCPS40A'
    'RCHCPS41A'
    'RCHCSPS41'
    'RCHCSPS42'
    'RCHCPS42A'
    'RCHCPS42 '
    'RCHCPS43 '
    'RCHCPS50 '
    'RCHCPS51 '
    'RCHCPS51A'
    'RCHCSPS51'
    'RCHCSPS52'
    'RCHCPS52A'
    'RCHCPS52 '
    'RCHCPS53 '
    'RCHCPS60 '
    'RCHCPS61 '
    'RCHCPS61A'
    'RCHCSPS61'
    'RCHCSPS62'
    'RCHCPS62 '
    'RCHCPS64 '
    ];
    
VCM_PS = [
    'RCVCPS10 '
    'RCVCPS10A'
    'RCVCPS11 '
    'RCVCSPS11'
    'RCVCPS12 '
    'RCVCSPS12'
    'RCVCPS13A'
    'RCVCPS13 '
    'RCVCPS21 '
    'RCVCPS21A'
    'RCVCPS22 '
    'RCVCSPS22'
    'RCVCPS23A'
    'RCVCPS23 '
    'RCVCPS24 '
    'RCVCPS30 '
    'RCVCPS31 '
    'RCVCPS31A'
    'RCVCSPS31'
    'RCVCPS32 '
    'RCVCSPS32'
    'RCVCPS33 '
    'RCVCPS40 '
    'RCVCPS41 '
    'RCVCSPS41'
    'RCVCPS42 '
    'RCVCSPS42'
    'RCVCPS43A'
    'RCVCPS43 '
    'RCVCPS44 '
    'RCVCPS50 '
    'RCVCPS51 '
    'RCVCPS51A'
    'RCVCSPS51'
    'RCVCPS52 '
    'RCVCSPS52'
    'RCVCPS53A'
    'RCVCPS53 '
    'RCVCPS54 '
    'RCVCPS60 '
    'RCVCPS61 '
    'RCVCPS61A'
    'RCVCSPS61'
    'RCVCPS62 '
    'RCVCSPS62'
    'RCVCPS63 '
    'RCVCPS65 '
    ];
   
QD1_PS = [
    'R61QPS1'
    'R12QPS1'
    'R12QPS1'
    'R23QPS1'
    'R23QPS1'
    'R34QPS1'
    'R34QPS1'
    'R45QPS1'
    'R45QPS1'
    'R56QPS1'
    'R56QPS1'
    'R61QPS1'
    ];

QD2_PS = [
    'R61QPS3'
    'R12QPS3'
    'R12QPS3'
    'R23QPS3'
    'R23QPS3'
    'R34QPS3'
    'R34QPS3'
    'R45QPS3'
    'R45QPS3'
    'R56QPS3'
    'R56QPS3'
    'R61QPS3'
    ];

QF1_PS = [
    'R61QPS2'
    'R12QPS2'
    'R12QPS2'
    'R23QPS2'
    'R23QPS2'
    'R34QPS2'
    'R34QPS2'
    'R45QPS2'
    'R45QPS2'
    'R56QPS2'
    'R56QPS2'
    'R61QPS2'
    ];

QF2_PS = [
    'R61QPS4'
    'R12QPS4'
    'R12QPS4'
    'R23QPS4'
    'R23QPS4'
    'R34QPS4'
    'R34QPS4'
    'R45QPS4'
    'R45QPS4'
    'R56QPS4'
    'R56QPS4'
    'R61QPS4'
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
    case 'QF1'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', QF1_PS(i,:)));
        end
    case 'QF2'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', QF2_PS(i,:)));
        end
    case 'QD1'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', QD1_PS(i,:)));
        end
    case 'QD2'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', QD2_PS(i,:)));
        end
    case 'SF'
        for i = 1:size(DeviceList,1)
            ChannelName = strvcat(ChannelName,sprintf('%s', 'RCSFPS'));
        end
    case 'SD'
        for i = 1:size(DeviceList,1)
            ChannelName = strvcat(ChannelName,sprintf('%s', 'RCSDPS'));
        end
    case 'BEND'
        for i = 1:size(DeviceList,1)
            ChannelName = strvcat(ChannelName,sprintf('%s', 'RCDPS'));
        end
    case 'RF'
        for i = 1:size(DeviceList,1)
            ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
        end
    case 'DCCT'
        for i = 1:size(DeviceList,1)
            ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
        end
    case 'TUNE'
        for i = 1:size(DeviceList,1)
            ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
        end
end

