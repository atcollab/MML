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
    'BTSBPM1X ' 
    'BTSBPM2X ' 
    'BTSBPM3X ' 
    'BTSBPM4X ' 
    'BTSBPM5X ' 
    'BTSBPM6X ' 
    'BTSBPM7X ' 
    ];

BPM_Y = [
    'BTSBPM1Y ' 
    'BTSBPM2Y ' 
    'BTSBPM3Y ' 
    'BTSBPM4Y ' 
    'BTSBPM5Y ' 
    'BTSBPM6Y ' 
    'BTSBPM7Y ' 
    ];

HCM_PS = [
    'RCTHCPS1 '
    'RCTHCPS1A'
    'RCTHCDPS2'
    'RCTHCPS2 '
    'RCTHCPS3 '
    'RCTHCPS3A'
    'RCTHCDPS7'
    ];
    
VCM_PS = [
    'RCTVCPS1 '
    'RCTVCPS1A'
    'RCTVCPS2 '
    'RCTVCPS3 '
    'RCTVCPS4 '
    'RCTVCDPS4'
    'RCTVCDPS5'
    'RCTVCPS4A'
    'RCTVCPS5 '
    ];
   
QM_PS = [
    'RCTQPS01'
    'RCTQPS02'
    'RCTQPS03'
    'RCTQPS04'
    'RCTQPS05'
    'RCTQPS06'
    'RCTQPS07'
    'RCTQPS08'
    'RCTQPS09'
    'RCTQPS10'
    'RCTQPS11'
    'RCTQPS12'
    'RCTQPS13'
    'RCTQPS14'
    'RCTQPS15'
    'RCTQPS16'
    'RCTQPS17'
    ];

BM_PS = [
    'RCTDPS1'
    'RCTDPS1'
    'RCTDPS2'
    'RCTDPS2'
    'RCTDPS3'
    'RCTDPS3'
    'RCTDPS4'
    'RCTDPS4'
    'RCTDPS5'
    'RCTDPS5'
    'RCTDPS6'
    'RCTDPS6'
    'RCTDPS7'
    'RCTDPS7'
    'RCTDPS8'
    'RCTDPS8'
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
        
    case 'QM'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', QM_PS(i,:)));
        end
       
    case 'SQ'
        for i = 1:size(DeviceList,1)
%             ChannelName = strvcat(ChannelName,sprintf('%s(%d,%d)', Family, DeviceList(i,1), DeviceList(i,2)));
              ChannelName = strvcat(ChannelName,sprintf('%s', 'RCTSQPS'));
        end
        
    case 'BM'
        for i = 1:size(DeviceList,1)
             ChannelName = strvcat(ChannelName,sprintf('%s', BM_PS(i,:)));
        end

end

