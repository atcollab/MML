function  [ChannelName, ErrorFlag] = getname_ptb(Family, Field, DeviceList)
% ChannelName = getname_ptb(Family, Field, DeviceList)
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

% if isempty(DeviceList)
%     DeviceList = getlist(Family);
% elseif (size(DeviceList,2) == 1)
%     DeviceList = elem2dev(Family, DeviceList);
% end

ChannelName = [];

switch Family
    case 'BPMx'
        switch Field
            case 'Monitor'
            case 'Setpoint'
        end
    case 'BPMy'
        switch Field
            case 'Monitor'
            case 'Setpoint'
        end
    case 'HCM'
        switch Field
            case 'Monitor'
            case 'Setpoint'
        end
    case 'VCM'
        switch Field
            case 'Monitor'
            case 'Setpoint'
        end
    case 'QF'
        switch Field
            case 'Monitor'
            case 'Setpoint'
        end
    case 'QD'
        switch Field
            case 'Monitor'
            case 'Setpoint'
        end
    case 'BEND'
        switch Field
            case 'Monitor'
            case 'Setpoint'
        end
end

