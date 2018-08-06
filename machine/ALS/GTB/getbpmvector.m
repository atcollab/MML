function [AM, tout, DataTime, ErrorFlag] = getbpmvector(DeviceList, varargin)
%GETBPMVECTOR - Return the orbit, button voltages, a gain for the BPMs 
%   [AM, tout, DataTime, ErrorFlag] = getbpmvector(DeviceList)
%
%   AM
%     Column 1: Horizontal Orbit 
%     Column 2: Vertical   Orbit 
%     Column 3: Button #1 Voltage 
%     Column 4: Button #2 Voltage 
%     Column 5: Button #3 Voltage 
%     Column 6: Button #4 Voltage 
%     Column 7: Gain 
%     Column 8: Heart Beat {removed}
%
%  

%   Written by Greg Portmann


if nargin < 1
    DeviceList = family2dev('BPMx');
end


[AM, tout, DataTime, ErrorFlag] = getorbitLOCAL(DeviceList);


% % Look for a heartbeat change
% while 1
%     HeartBeatStart = getpv('BPMy', 'HeartBeat', DeviceList);
%     [AM, tout, DataTime, ErrorFlag] = getorbitLOCAL(DeviceList);
%     
%     j = find(~isnan(AM(:,8)));
%     if all(HeartBeatStart(j) == AM(j,8))
%         break;
%     else
%         pause(.1);
%     end
% end


function [AM, tout, DataTime, ErrorFlag] = getorbitLOCAL(DeviceList)
[AM(:,1), tout, DataTime, ErrorFlag] = getpv('BPMx', 'Monitor', DeviceList);
AM(:,2) = getpv('BPMy', 'Monitor',   DeviceList);
AM(:,3) = getpv('BPMy', 'Button1',   DeviceList);
AM(:,4) = getpv('BPMy', 'Button2',   DeviceList);
AM(:,5) = getpv('BPMy', 'Button3',   DeviceList);
AM(:,6) = getpv('BPMy', 'Button4',   DeviceList);
AM(:,7) = getpv('BPMx', 'GainControl',      DeviceList);
%AM(:,8) = getpv('BPMx', 'HeartBeat', DeviceList);

