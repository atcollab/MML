function [BTSConfig, FileName] = setbtsconfig(FileName)
%SETBTSCONFIG - Gets a BTS magnet configuration
%  [BTSConfig, FileName] = setbtsconfig(FileName)
%              or
%  [BTSConfig] = setbtsconfig(BTSConfig)
%
%  INPUTS
%  1. FileName - File name to get BTS data structure from (if necessary, include full path)
%                '' to browse for a directory and file
%     BTSConfig - BTS data structure
%
%  OUTPUTS
%  1. BTSConfig - Structure of setpoints
%  2. FileName - Filename where the data was retreved from (including the path)


if nargin == 0
    FileName = '';
end

if ischar(FileName)
    if isempty(FileName)
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a BTS file to load', [getfamilydata('Directory', 'DataRoot'), 'BTS', filesep]);
        if FileName == 0
            disp('   BTS magnets not changed.');
            return
        end
        FileName = [DirectoryName, FileName];
        load(FileName);
    end
else
    % Assume FileName is a BTS structure
    BTSConfig = FileName;
    FileName = '';
end


% Set the setpoint field
setpv('BTS-B7H:CurrSetpt', BTSConfig.Values.B7H);
setpv('BTS-B8V:CurrSetpt', BTSConfig.Values.B8V);
setpv('BTS-C8H:CurrSetpt', BTSConfig.Values.C8H);
setpv('BTS-B9V:CurrSetpt', BTSConfig.Values.B9V);
setpv('BTS-Q8:CurrSetpt',  BTSConfig.Values.Q8);
setpv('BTS-Q9:CurrSetpt',  BTSConfig.Values.Q9);

% Set the desired setpoint field
setpv('BTS-B7H:CurrSetptDes', BTSConfig.Values.B7H);
setpv('BTS-B8V:CurrSetptDes', BTSConfig.Values.B8V);
setpv('BTS-C8H:CurrSetptDes', BTSConfig.Values.C8H);
setpv('BTS-B9V:CurrSetptDes', BTSConfig.Values.B9V);
setpv('BTS-Q8:CurrSetptDes',  BTSConfig.Values.Q8);
setpv('BTS-Q9:CurrSetptDes',  BTSConfig.Values.Q9);



