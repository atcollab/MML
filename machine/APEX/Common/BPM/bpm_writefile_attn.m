function bpm_writefile_attn(AFE, Rev, FileNameInput)

if nargin < 2
   error('AFE number and Rev are required inputs.');
end
if nargin < 3 || isempty(FileNameInput)
    FileNameInput = '';  %'Unity';
end


DirStart = pwd;
if Rev == 2
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev2');
elseif Rev == 4
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev4');
else
    error('Unknown rev number.');
end

[DFE, IP, Prefix, File] = bpm_afeinfo(AFE, Rev);

% Input override of the attenuation file
if isempty(FileNameInput)
    % Go with what's in bpm_afeinfo
elseif strcmpi(FileNameInput, 'Unity')
    File = 'Attenuation_Unity.csv';
else
    File = FileNameInput;
end

fprintf('   AFE #%d (%s) %s\n', AFE, IP, File);
cmd = sprintf('tftp %s -v -m binary -c put %s Attenuation.csv', IP, File);
unix(cmd);

cd(DirStart);





