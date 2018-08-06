function bpm_writefile_attn(varargin)
%BPM_WRITEFILE_ATTN
% bpm_writefile_attn(DeviceList)
% bpm_writefile_attn(DeviceList, FileName)  -> Optional FileName if one device
%
% bpm_writefile_attn(AFE, FileName)
%
% See also bpm_meas_staticgain

%bpm_writefile_attn(40, 'Attenuation_AFE2_Rev4_SN040.csv');
%bpm_writefile_attn(getfamilydata('BPM', 'AFE'),);

DevList = [];
FileNameInput = '';  %'Unity';

if nargin == 0
    % Do them all
    DevList = family2dev('BPM');
    
    %error('Devicelist or AFE number inputs required.');
    
    % Sector 1 & 7 production BPMs
    %AFE = [1 36 10 5 33 9 65 13 39]';
    %AFE = [25 26 28 20]';  % Sector 4
    %AFE = [3 12 38 40]';   % Sector 6
    %AFE = [33 9 13 39]';   % Sector 7
    %AFE = [18 15 14 11]';  % Sector 11
    %AFE = [2 4 17]';       % Sector 12
end

if nargin >= 1
    DevList = varargin{1};
end
if nargin >= 2 && ischar(varargin{2})
    FileNameInput = varargin{2};
end

% Check for AFE number input
if size(DevList, 2) == 1
    % Convert to DevList
    AFE = DevList;
    AFEListFull = getfamilydata('BPM', 'AFE');
    DevListFull = getfamilydata('BPM', 'DeviceList');
    i = findrowindex(AFE, AFEListFull);
    DevList = DevListFull(i,:);
end

if size(DevList, 1) > 1
    for i = 1:length(DevList)
        bpm_writefile_attn(DevList(i,:), FileNameInput);
    end
    return
end

DirStart = pwd;
if isstoragering
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/SR');
else
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/Injector');
end

        
IP = getfamilydata('BPM', 'IP', DevList);
IP = IP{1};
BaseName = getfamilydata('BPM', 'BaseName', DevList);
BaseName = BaseName{1};
AFE = getfamilydata('BPM', 'AFE', DevList);
Rev = round(10*rem(AFE,1));
AFE = floor(AFE);

File = sprintf('Attenuation_AFE2_Rev%d_SN%03d.csv', Rev, AFE);

% Input override of the attenuation file
if isempty(FileNameInput)
    % Use the AFE number in the MML
elseif strcmpi(FileNameInput, 'Unity')
    File = 'Attenuation_Unity.csv';
else
    File = FileNameInput;
end

fprintf('   AFE #%d (%s) %s\n', AFE, IP, File);
cmd = sprintf('tftp %s -v -m binary -c put %s Attenuation.csv', IP, File);
unix(cmd);

cd(DirStart);





