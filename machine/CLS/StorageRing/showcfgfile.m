function showcfgfile
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/showcfgfile.m 1.2 2007/03/02 09:17:24CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

DirectoryName = getfamilydata('Directory','ConfigData');
[FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file', DirectoryName);
if FileName == 0
     fprintf('   No change to lattice (srrestore)');
     return
end

load([DirectoryName FileName]);
FieldNameCell = fieldnames(ConfigSetpoint);


fid = fopen('machdat.txt','w');
ad=getad;
fprintf('%30s\n\n',[ad.Machine ' Accelerator Settings: ' datestr(now,0)]);
fprintf(fid,'%30s\n\n',[ad.Machine ' Accelerator Settings: ' datestr(now,0)]);

families=getfamilylist;

for ii=1:size(families,1)
family=deblank(families(ii,:));
familytype=getfamilydata(family,'FamilyType');
mode=getfamilydata(family,'Setpoint','Units');

if strcmpi(mode,'Hardware')
units=getfamilydata(family,'Setpoint','HWUnits');
elseif strcmpi(mode,'Physics')
units=getfamilydata(family,'Setpoint','PhysicsUnits');
end
 
if strcmpi(familytype,'BEND') | strcmpi(familytype,'QUAD') | strcmpi(familytype,'SEXT') | strcmpi(familytype,'COR') | ...
            strcmpi(familytype,'STEER') | ...  
            strcmpi(familytype,'SEPT') | ...              
            strcmpi(familytype,'KICK') | ...              
            strcmpi(familytype,'SCRAPE')
    
	DevList=family2dev(family);
	Setpoint=getsp(family,'Simulator');
	Readback=getam(family,'Simulator');
	Setpoint_PV=getfamilydata(family,'Setpoint','ChannelNames');
	Monitor_PV =getfamilydata(family,'Monitor','ChannelNames');
	
	
	
	
	
	fprintf('%s\n',['   Family  DeviceList  Setpoint       Readback          SPt-RDBk    Units          Setpoint_PV          Monitor_PV']);
	fprintf(fid,'%s\n',['   Family  DeviceList  Setpoint       Readback          SPt-RDBk    Units          Setpoint_PV          Monitor_PV']);
	
      for jj=1:size(DevList,1)
        fprintf('%8s    [%2d,%d] %14.2f %14.2f %14.2f %10s %20s %20s\n',family,DevList(jj,1), DevList(jj,2), Setpoint(jj), Readback(jj), Setpoint(jj)-Readback(jj), units,Setpoint_PV(jj,:),Monitor_PV(jj,:));
        fprintf(fid,'%8s    [%2d,%d] %14.2f %14.2f %14.2f %10s %20s %20s\n',family,DevList(jj,1), DevList(jj,2), Setpoint(jj), Readback(jj), Setpoint(jj)-Readback(jj), units,Setpoint_PV(jj,:),Monitor_PV(jj,:));    
      end
      disp(' ');
      fprintf(fid,'\n\n\n');
	end

end
fclose(fid);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/showcfgfile.m  $
% Revision 1.2 2007/03/02 09:17:24CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
