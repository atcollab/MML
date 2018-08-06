function showmachinedata(families)
%display setpoint and readbacks for families in AcceleratorObjects
%showmachinedata(families) where families can be char or cell array showmachinedata{'QF'; 'QD';}
ad=getad;
fprintf('%30s\n\n',[ad.Machine ' Accelerator Settings: ' datestr(now,0)]);

if nargin<1
    families=getfamilylist;
elseif ischar(families)
    families=char(families);   %make sure same length
elseif iscell(families)
    families=char(families{:}); 
end

for ii=1:size(families,1)
family=deblank(families(ii,:));
if ~isfamily(family)   disp(['   Warning: family not available... ', family]);  end
familytype=getfamilydata(family,'FamilyType');  %returns [] for family not available
 
if strcmpi(familytype,'BEND') | strcmpi(familytype,'QUAD') | strcmpi(familytype,'SEXT') | strcmpi(familytype,'COR')
    
DevList=family2dev(family);
SetpointPV  =getfamilydata(family,'Setpoint','ChannelNames');
Setpoint    =getsp(family,'hardware');
PSetpoint    =hw2physics(family,'Setpoint',Setpoint);

MonitorPV   =getfamilydata(family,'Monitor','ChannelNames');
Monitor     =getam(family,'hardware');
PMonitor     =hw2physics(family,'Monitor', Monitor);


%display hardware values
fprintf('%s\n',['   Family  DeviceList  HWSetpoint PhysicsSetpoint     HWReadback    PhysicsReadback   SP-MON (HW)   SP-MON (Physics)  Setpoint_PV             Monitor_PV']);

  for jj=1:size(DevList,1)
    fprintf('%8s    [%2d,%d] %14.5f %14.5f %14.5f %14.5f %14.5f %14.5f %28s %20s\n',family,DevList(jj,1),DevList(jj,2),Setpoint(jj),PSetpoint(jj),Monitor(jj),PMonitor(jj),Setpoint(jj)-Monitor(jj),PSetpoint(jj)-PMonitor(jj),SetpointPV(jj,:),MonitorPV(jj,:));
  end
  disp(' ');
  
  
end

end
