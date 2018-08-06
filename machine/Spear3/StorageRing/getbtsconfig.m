function [BTSConfig, FileName] = getbtsconfig(FileName)
%GETBTSCONFIG - Gets a BTS magnet configuration
%  [BTSConfig, FileName] = getbtsconfig
%
%  INPUTS
%  1. FileName - File name to storage data (if necessary, include full path)
%                '' to browse for a directory and file
%                If FileName is not input, then the configuration will not be saved to file.
%
%  OUTPUTS
%  1. BTSConfig - Structure of setpoints
%  2. FileName - If data was archived, filename where the data was saved (including the path)


if nargin == 0
    if nargout == 0
        ArchiveFlag = 1;
        FileName = '';
    else
        ArchiveFlag = 0;
    end
end

if isempty(FileName)
    [FileName, DirectoryName] = uiputfile('*.mat', 'Save BTS Magnets to ...', [getfamilydata('Directory', 'DataRoot'), 'BTS', filesep]);
    if FileName == 0
        disp('   BTS configuration not saved.');
        return
    end
    FileName = [DirectoryName, FileName];
    ArchiveFlag = 1;
end


% Present BTSsetpoints
BTSConfig.Values.B7H = getpv('BTS-B7H:CurrSetpt');
BTSConfig.Values.B8V = getpv('BTS-B8V:CurrSetpt');
BTSConfig.Values.C8H = getpv('BTS-C8H:CurrSetpt');  BTSConfig.Values.C8H = BTSConfig.Values.C8H(1);
BTSConfig.Values.B9V = getpv('BTS-B9V:CurrSetpt');
BTSConfig.Values.Q8  = getpv('BTS-Q8:CurrSetpt');
BTSConfig.Values.Q9  = getpv('BTS-Q9:CurrSetpt');

BTSConfig.TimeStamp = clock;
BTSConfig.Time = datestr(BTSConfig.TimeStamp);
BTSConfig.Desc = 'BTS Setpoint';


if ArchiveFlag
    save(FileName, 'BTSConfig');
end



