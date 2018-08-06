function bpm_writefile_attn(varargin)
%BPM_WRITEFILE_ATTN
% bpm_writefile_attn(DeviceList)
% bpm_writefile_attn(DeviceList, FileName)  -> Optional FileName if one device
%
% bpm_writefile_attn(AFE, Rev, FileName)
%
% See also bpm_afeinfo bpm_meas_staticgain

%bpm_writefile_attn(40,4,'Attenuation_AFE2_Rev4_SN040.csv');
%bpm_writefile_attn(getfamilydata('BPM', 'AFE'), 4);

 DevList = [];
 Rev = 4;
 FileNameInput = '';  %'Unity';
 
if nargin == 0
   error('AFE number and Rev are required inputs.  See bpm_afeinfo for a list.');
   bpm_writefile_attn(getfamilydata('BPM', 'AFE'), 4);
   
   % Sector 1 & 7 production BPMs
   %AFE = [1 36 10 5 33 9 65 13 39]';
   %AFE = [25 26 28 20]';  % Sector 4
   %AFE = [3 12 38 40]';   % Sector 6
   %AFE = [33 9 13 39]';   % Sector 7
   %AFE = [18 15 14 11]';  % Sector 11
   %AFE = [2 4 17]';       % Sector 12
end
if nargin >= 1
    if size(varargin{1},2) == 2
        % DeviceList
        DevList = varargin{1};
        if nargin >= 2
            FileNameInput = varargin{2};
        end
        if size(DevList, 1) > 1
            for i = 1:length(DevList)
                bpm_writefile_attn(DevList(i));
            end
            return
        end
        AFE = getfamilydata('BPM', 'AFE' , DevList);
        if isstoragering
            Rev = 4;
        else
            Rev = 2;
        end
    else
        AFE = varargin{1};
        if nargin >= 2
            Rev = varargin{2};
        end
        if nargin >= 3
            FileNameInput = varargin{3};
        end
        if length(AFE) > 1
            FileNameInput = '';
            %FileNameInput = 'Unity';
            for i = 1:length(AFE)
                bpm_writefile_attn(AFE(i), Rev, FileNameInput);
            end
            return
        end
    end
end


DirStart = pwd;
if Rev == 2
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev2_DualTone');
   %gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev2');
elseif Rev == 4
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev4_DualTone');
   %gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev4');
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





