function showmachinedata(families)
%SHOWMACHINEDATA - Display setpoints and readbacks for families in AcceleratorObjects
%  showmachinedata(Family)
%
%  INPUTS
%  1. Family - Can be char or cell array, showmachinedata{'Q1'; 'Q2';}

% Written by Jeff Corbett
% Modified by Laurent S. Nadolski


if nargin == 0 
    families = '';
end

ad = getad; % gets Accelerator Data

% Prints out current time
fprintf('%30s\n\n',[ad.Machine ' Accelerator Settings: ' datestr(now,0)]);

if isempty(families)
    families=getfamilylist;
elseif ischar(families)
    families=char(families);   %make sure same length
elseif iscell(families)
    families=char(families{:});
end

for ii = 1:size(families,1)
    family = deblank(families(ii,:));

    if ~isfamily(family)
        disp(['   Warning: family not available... ', family]);
    else
        if ismemberof(family, 'Magnet')

            DevList     = family2dev(family);
            %SetpointPV  = char(getfamilydata(family,'Setpoint','TangoNames'));
            Setpoint    = getsp(family,'hardware');
            PSetpoint   = hw2physics(family,'Setpoint',Setpoint);

            %MonitorPV   = char(getfamilydata(family,'Monitor','TangoNames'));
            Monitor     = getam(family,'hardware');
            PMonitor    = hw2physics(family,'Monitor', Monitor);


            %display hardware values
            fprintf('%s\n',['   Family  DeviceList  HWSetpoint PhysicsSetpoint     HWReadback    PhysicsReadback   SP-MON (HW)   SP-MON (Physics)']);
            %fprintf('%s\n',['   Family  DeviceList  HWSetpoint PhysicsSetpoint     HWReadback    PhysicsReadback   SP-MON (HW)   SP-MON (Physics)  Setpoint_PV             Monitor_PV']);

            for jj=1:size(DevList,1)
                fprintf('%8s    [%2d,%d] %14.5f %14.5f %14.5f %14.5f %14.5f %14.5f\n',family,DevList(jj,1),DevList(jj,2),Setpoint(jj),PSetpoint(jj),Monitor(jj),PMonitor(jj),Setpoint(jj)-Monitor(jj),PSetpoint(jj)-PMonitor(jj));
                %fprintf('%8s    [%2d,%d] %14.5f %14.5f %14.5f %14.5f %14.5f %14.5f %28s %20s\n',family,DevList(jj,1),DevList(jj,2),Setpoint(jj),PSetpoint(jj),Monitor(jj),PMonitor(jj),Setpoint(jj)-Monitor(jj),PSetpoint(jj)-PMonitor(jj),SetpointPV(jj,:),MonitorPV(jj,:));
            end
            disp(' ');
        end
    end
end
