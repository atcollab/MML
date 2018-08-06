function viewconfigfile(FileName, varargin)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/viewconfigfile.m 1.2 2007/03/02 09:17:51CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%VIEWCONFIGFILE - opens a config file that was saved using getclsconfig and
%outputs the family setpoints to teh command window
%  viewconfigfile()
%  Written by Russ Berg
% ----------------------------------------------------------------------------------------------

% Get config structure
if nargin == 0
    % Default file
    %FileName = getfamilydata('Default','CNFArchiveFile');
    DirectoryName = getfamilydata('Directory','ConfigData');
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file', DirectoryName);
    if FileName == 0
        %fprintf('   No change to lattice (srrestore)');
        return
    end
    load([DirectoryName FileName]);
else
    if ischar(FileName)
        if strcmpi(FileName, 'Golden')
            FileName = getfamilydata('OpsData','LatticeFile');
            DirectoryName = getfamilydata('Directory','OpsData');
            load([DirectoryName FileName]);
        else
            % Input file name
            load(FileName);
        end
    else
        ConfigSetpoint = FileName;
    end
end


FieldNameCell = fieldnames(ConfigSetpoint);


for i = 1:length(FieldNameCell)
    %fprintf('outputting settings for %s\n',FieldNameCell{i});
    fprintf('\n');
    DevList=family2dev(ConfigSetpoint.(FieldNameCell{i}).FamilyName);
    Setpoint=ConfigSetpoint.(FieldNameCell{i}).Data;
    %Readback=getam(family);
    Setpoint_PV=getfamilydata(ConfigSetpoint.(FieldNameCell{i}).FamilyName,'Setpoint','ChannelNames');
    Monitor_PV =getfamilydata(ConfigSetpoint.(FieldNameCell{i}).FamilyName,'Monitor','ChannelNames');
    % Set the setpoint
    try
        
        if strcmpi(FieldNameCell{i}, 'BEND') | ...
            strcmpi(FieldNameCell{i}, 'QFA') | ...
            strcmpi(FieldNameCell{i}, 'QFB') | ...
            strcmpi(FieldNameCell{i}, 'BTSSEPT') | ...
            strcmpi(FieldNameCell{i}, 'BTSQUADS') | ...
            strcmpi(FieldNameCell{i}, 'BTSBEND') | ...
            strcmpi(FieldNameCell{i}, 'BTSSCRAPE') | ...
            strcmpi(FieldNameCell{i}, 'BTSSTEER') | ...
            strcmpi(FieldNameCell{i}, 'BTSKICK') | ...
            strcmpi(FieldNameCell{i}, 'QFC') | ...
            strcmpi(FieldNameCell{i}, 'HCM') | ...
            strcmpi(FieldNameCell{i}, 'VCM') 
            
            %ConfigSetpoint.(FieldNameCell{i}).Data + 0;
            %setpv(ConfigSetpoint.(FieldNameCell{i}), varargin{:});

            for j=1:length(ConfigSetpoint.(FieldNameCell{i}).Data)
                fprintf('%s[%d] => %f\n',FieldNameCell{i},j,ConfigSetpoint.(FieldNameCell{i}).Data(j));
                %fprintf('%8s    [%2d,%d] %14.2f %10s %20s\n',family,DevList(jj,1), DevList(jj,2), Setpoint(jj), units,Setpoint_PV(jj,:));
                %setpv(FieldNameCell{i},'Setpoint',ConfigSetpoint.(FieldNameCell{i}).Data(j), j);
            end
        end
    catch
        fprintf('\n');
    end   
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/viewconfigfile.m  $
% Revision 1.2 2007/03/02 09:17:51CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
