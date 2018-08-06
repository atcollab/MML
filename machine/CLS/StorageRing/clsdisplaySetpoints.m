function clsdisplaySetpoints(srcMode)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsdisplaySetpoints.m 1.2 2007/03/02 09:02:56CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%   clsdisplaySetpoints(srcMode)
%       The purpose of this function is to get the setpoints from the
%       location specified by the 'mode' paramater and display them on the
%       screen.
%
%       INPUTS:
%           1. SRCMODE
%                   the SRCMode can be either:
%                        'Online' - this will get the current setpoints for
%                                   the ring and display them on the screen
%                        'Simulator' - this will display the current setpoints in the simulator model
%                        'Archive' - this will prompt the user to specify
%                                    a workspace configuration file 
% ----------------------------------------------------------------------------------------------

% the output is displayed on the screen as well as written to a temporary
% text file
buf=[];
if(exist('srcMode'))
    fid = fopen('machdat.txt','w');
	%determine the srcMode
	if(strcmpi(srcMode,'Archive'))
        fprintf('Retrieving setpoints from %s\n',srcMode); 
		DirectoryName = getfamilydata('Directory','ConfigData');
		[FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file', DirectoryName);
		if FileName == 0
             fprintf('Invalid FileName');
             return
		end
		load([DirectoryName FileName]);
        ad=getad;
      	fprintf('%30s\n\n',[ad.Machine ' Accelerator Settings: ' FileName]);
    	fprintf(fid,'%30s\n\n',[ad.Machine ' Accelerator Settings: ' FileName]);
        buf=sprintf('SR1Setpoints-%s.txt', FileName);
        fid = fopen('machdat.txt','w');

    else
        fprintf('Retrieving setpoints from %s\n',srcMode); 
        ConfigSetpoint = getclsconfig(srcMode);
        ad=getad;
        buf = sprintf('SR1Setpoints-%s.txt',datestr(now,0));
        
        fprintf('%30s\n\n',[ad.Machine ' Accelerator Settings: ' datestr(now,0)]);
        fprintf(fid,'%30s\n\n',[ad.Machine ' Accelerator Settings: ' datestr(now,0)]);        
        
    end      
	
    FieldNameCell = fieldnames(ConfigSetpoint);
	families=getfamilylist;
	
	for ii=1:size(families,1)
	family=deblank(families(ii,:));
	familytype=getfamilydata(family,'FamilyType');
	mode=getfamilydata(family,'Setpoint','Units');
	fprintf('Family Type: %s Family: %s\n',familytype,family);
	if strcmpi(mode,'Hardware')
	units=getfamilydata(family,'Setpoint','HWUnits');
	elseif strcmpi(mode,'Physics')
	units=getfamilydata(family,'Setpoint','PhysicsUnits');
	end
     
    %if ~strcmpi(family,'BTSQUADS') & ~strcmpi(family,'BTSSCRAPE') & ~strcmpi(family,'BTSKICK') & ~strcmpi(family,'BTSSEPT') & ...
    %            ~strcmpi(family,'BTSBEND') & ...  
    %            ~strcmpi(family,'BTSSTEER') 
    if ~strcmpi(family,'BTSSCRAPE') 
             
        
        	if strcmpi(familytype,'BEND') | strcmpi(familytype,'QUAD') | strcmpi(familytype,'SEXT') | strcmpi(familytype,'COR') | ...
                    strcmpi(familytype,'STEER') | ...  
                    strcmpi(familytype,'SEPT') | ...              
                    strcmpi(familytype,'KICK') | ...              
                    strcmpi(familytype,'SCRAPE')
            
			    DevList=family2dev(family);
			    %Setpoint=getsp(family,'Simulator');
			    Setpoint = ConfigSetpoint.(family).Data;
            Readback=[];
            if(strcmpi(srcMode,'Online'))
	
                Readback=getam(family,srcMode);
            end    
			Setpoint_PV=getfamilydata(family,'Setpoint','ChannelNames');
			Monitor_PV =getfamilydata(family,'Monitor','ChannelNames');
			
			
			if(length(Setpoint) > 0)
				
				if(length(Readback) > 0)
            		fprintf('%s\n',['   Family  DeviceList  Setpoint       Readback          SPt-RDBk    Units          Setpoint_PV          Monitor_PV']);
				    fprintf(fid,'%s\n',['   Family  DeviceList  Setpoint       Readback          SPt-RDBk    Units          Setpoint_PV          Monitor_PV']);
                else
                	fprintf('%s\n',['   Family  DeviceList  Setpoint       Units          Setpoint_PV']);
				    fprintf(fid,'%s\n',['   Family  DeviceList  Setpoint       Units          Setpoint_PV']);    
                end
                  for jj=1:size(DevList,1)
                    if(length(Readback) > 0)  
                        fprintf('%8s    [%2d,%d] %14.2f %14.2f %14.2f %10s %20s %20s\n',family,DevList(jj,1), DevList(jj,2), Setpoint(jj), Readback(jj), Setpoint(jj)-Readback(jj), units,Setpoint_PV(jj,:),Monitor_PV(jj,:));
                        fprintf(fid,'%8s    [%2d,%d] %14.2f %14.2f %14.2f %10s %20s %20s\n',family,DevList(jj,1), DevList(jj,2), Setpoint(jj), Readback(jj), Setpoint(jj)-Readback(jj), units,Setpoint_PV(jj,:),Monitor_PV(jj,:));    
                     
                    else
                        fprintf('%8s    [%2d,%d] %14.2f %10s %20s %20s\n',family,DevList(jj,1), DevList(jj,2), Setpoint(jj), units,Setpoint_PV(jj,:));
                        fprintf(fid,'%8s    [%2d,%d] %14.2f %10s %20s %20s\n',family,DevList(jj,1), DevList(jj,2), Setpoint(jj), units,Setpoint_PV(jj,:));    
                        fprintf('\n');
                        fprintf(fid,'\n'); 
                    end    
                                  
                  end
                  disp(' ');
                  fprintf(fid,'\n\n\n');
				end
            end
        end
	end
	fclose(fid);
else
    fprintf('mode not specified:> ''Online'' or ''Simulator'' or ''Archive''\n'); 
    fprintf('\t\t\tex: clsdisplaySetpoints(''Archive'')'); 
    
end %if exists('mode'))

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsdisplaySetpoints.m  $
% Revision 1.2 2007/03/02 09:02:56CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
