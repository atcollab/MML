function [ConfigSetpoint, FileName] = settfbconfig(varargin)
%SETTFBCONFIG - Sets the TFB setpoints
%  [ConfigSetpoint, FileName] = settfbconfig(FileName)
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
%      >> settfbconfig; 
%
%  2.  To set to golden configuration:
%      >> settfbconfig('Golden'); 
%
%  See also gettfbconfig, showtfb

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
            DirectoryName = getfamilydata('Directory', 'TFBData');
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a TFB file to load', DirectoryName);
            if FileName == 0
                fprintf('   No change to lattice (settfbconfig)\n');
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;
        
        elseif strcmpi(FileName,'.')
            [FileName, DirectoryName] = uigetfile('*.mat', 'Select a TFB file to load');
            if FileName == 0
                fprintf('   No change to lattice (settfbconfig)\n');
                return
            end
            load([DirectoryName FileName]);
            FileName = [DirectoryName FileName];
            AskStartQuestion = 0;

        elseif any(strcmpi(FileName, {'Golden','Production'}))
            % Get the production file name (full path)
            FileName = getfamilydata('OpsData','TFBFile');
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
        fprintf('No change made to lattice (settfbconfig)\n');
        return
    end

    % Query to begin measurement
    if ~isempty(FileName) && AskStartQuestion
        tmp = questdlg(sprintf('Change the TFB setting to values stored in %s?', FileName),'settfbconfig','Yes','No','No');
        if ~strcmpi(tmp,'Yes')
            fprintf('  No change made to lattice (settfbconfig)\n');
            return
        end
    end
end


% Make the setpoint change
try
    setpv(ConfigSetpoint);
catch
    fprintf('%s\n', lasterr)
    fprintf('Trouble with setpv(''TFB'') (settfbconfig)\n');
end


