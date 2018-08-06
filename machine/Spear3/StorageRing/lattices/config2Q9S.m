%load configuration file via browser
%configgui('LBoxWait');

DirSpec   =  getfamilydata('Directory','ConfigData');           %default to Configuration data directory
FileName  =  [];                                %no default file
[FileName, DirSpec,FilterIndex]=uigetfile('*.mat','Select Configuration File',[DirSpec FileName]);
FileSpec=[DirSpec FileName];

try
cnf=load([DirSpec FileName]);          %load configuration from archive
ConfigSetpoint=cnf.ConfigSetpoint;
ConfigMonitor=cnf.ConfigMonitor;
catch
disp(['  Sorry, file ' [DirSpec FileName] 'could not be loaded. Try again'])
return
end

%modify structures SetpointData and MonitorData

if isfield(ConfigSetpoint,'QDW')
    ConfigSetpoint.Q9S=ConfigSetpoint.QDW;
    rmfield(ConfigSetpoint,'QDW')
    ConfigSetpoint.Q9S.Setpoint.FamilyName='Q9S';
    ConfigSetpoint.Q9S.Setpoint.CreatedBy=['File: ' [DirSpec FileName]];
    ConfigSetpoint
end

if isfield(ConfigMonitor,'QDW')
    ConfigMonitor.Q9S=ConfigMonitor.QDW;
    rmfield(ConfigMonitor,'QDW')
    ConfigMonitor.Q9S.Monitor.FamilyName='Q9S';
    ConfigMonitor.Q9S.Monitor.CreatedBy=['File: ' [DirSpec FileName]];
    ConfigMonitor
end


%Write configuration to file via browswer
        DirStart = pwd;
        FileName = getfamilydata('Default','CNFArchiveFile');
        DirectoryName = getfamilydata('Directory','ConfigData');
        [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);  
        FileName = appendtimestamp(FileName, clock);
        [FileName, DirectoryName] = uiputfile('*.mat','Save Lattice to ...', [DirectoryName FileName]);
        if FileName == 0 
            fprintf('   File not saved\n');
            return;
        end
    
    % Save all data in structure to file
    try
    save(FileName, 'ConfigSetpoint', 'ConfigMonitor');
    catch
    cd(DirStart);
    return
    end
    cd(DirStart);




