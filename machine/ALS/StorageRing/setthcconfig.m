function [ConfigSetpoint, FileName] = setthcconfig(varargin)
%SETTHCCONFIG - Sets the THC setpoints
%  [ConfigSetpoint, FileName] = setthcconfig(FileName)
%  
%  INPUTS
%  1. FileName - File name to get setpoint data (if necessary, include full path)
%                'Production' or 'Golden' will get the lattice from the "golden lattice" which stored in <OpsData.LatticeFile>
%                'Injection' will get the injection lattice stored in <OpsData.InjectionFile>
%                {Default: browse for the desired file}
%
%  OUTPUTS
%  1. FileName - filename where the data came from
%
%  EXAMPLES  
%  1.  To browse for a configuration to set:
%      >> setthcconfig; 
%
%  2.  To set to golden configuration:
%      >> setthcconfig('Golden'); 
%
%  See also getthcconfig, showthc

%  Written by Greg Portmann


FileName = '';
ConfigSetpoint = [];

if length(varargin) >= 1
    FileName = varargin{1};
    varargin(1) = [];
end


% Get config structure
if isempty(ConfigSetpoint)
    AskStartQuestion = 1;
    try
        if isempty(FileName)
            % Default file
            DirectoryName = getfamilydata('Directory', 'THCData');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a THC file to load', DirectoryName);
            if FileName == 0
                fprintf('   No change to lattice (setthcconfig)\n');
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;
        
        elseif strcmpi(FileName,'.')
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a THC file to load');
            if FileName == 0
                fprintf('   No change to lattice (setthcconfig)\n');
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;

        elseif any(strcmpi(FileName, {'Golden','Production'}))
            % Get the production file name (full path)
            FileName = getfamilydata('OpsData','THCFile');
            [DirectoryName, FileName, Ext] = fileparts(FileName);
            if isempty(DirectoryName)
                DirectoryName = getfamilydata('Directory', 'OpsData');
            end
            FileName = fullfile(DirectoryName,[FileName, '.mat']);
            load(FileName);

        else
            % Input file name
            load(FileName);
        end
    catch
        fprintf('%s\n', lasterr)
        fprintf('No change made to lattice (setthcconfig)\n');
        return
    end

    % Query to begin measurement
    if ~isempty(FileName) && AskStartQuestion
        tmp = questdlg(sprintf('Change the THC setting to values stored in %s?', FileName),'setthcconfig','Yes','No','No');
        if ~strcmpi(tmp,'Yes')
            fprintf('  No change made to lattice (setthcconfig)\n');
            return
        end
    end
end


% Make the setpoint change
try
    setpv(ConfigSetpoint.Setpoint);
    setpv(ConfigSetpoint.Error);
catch
    fprintf('%s\n', lasterr)
    fprintf('Trouble with setpv(''THC'') (setthcconfig)\n');
end


