function [Position, Velocity, RunFlag, UserGap] = getid(DeviceList, ChanType)
%GETID - Get the insertion device position, velocity, run flag, and user requested gap
%  [Position, Velocity, RunFlag, UserGap] = getid(DeviceList, ChanType)
%  DeviceList - DeviceList Number
%  Position  - Insertion device position [mm]
%  Velocity  - Insertion device velocity [mm/sec]
%  RunFlag   - Run count number -> .5 if running
%                               -> negative if error occurred
%  UserGap   - Insertion device user requested position [mm]  
%
%  ChanType  - 0 -> monitor for position and velocity {Default}
%                -> setpoint for position and velocity
%
%  See also getff, getusergap, gap2tune, shift2tune

if nargin == 0
	DeviceList = [];
end
if isempty(DeviceList)
	DeviceList = family2dev('ID');
end
if size(DeviceList,2) == 1
    %DeviceList = elem2dev('ID', DeviceList);
    DeviceList = [DeviceList ones(size(DeviceList))];
end

if nargin < 2
	ChanType = [];
end
if isempty(ChanType)
	ChanType= 0;
end

if ChanType
    Position = getsp('ID', DeviceList);
    if nargout >= 2
        Velocity = getpv('ID', 'VelocityControl', DeviceList);
    end
else
    Position = getam('ID', DeviceList);
    if nargout >= 2
        Velocity = getpv('ID', 'Velocity', DeviceList);    
    end
end
if nargout >= 3
    RunFlag = getpv('ID', 'RunFlag', DeviceList);
end
if nargout >= 4
    UserGap = getpv('ID', 'UserGap', DeviceList);  
end