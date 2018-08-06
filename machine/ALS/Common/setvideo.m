function ErrorFlag = setvideo(Family, varargin)
%SETVIDEO - Sets the video

%  Written by Greg Portmann


ErrorFlag = 0;


% Remove the Field input
if length(varargin) >= 1
    if ischar(varargin{1})
        % Remove and ignor the Field string
        varargin(1) = [];
    end
    if length(varargin) >= 1
        InOutControl = varargin{1};
        varargin(1) = [];
    else
        error('Must have at least 2 inputs (Family and InOutControl).');
    end
    if length(varargin) >= 1
        DeviceList = varargin{1};
        varargin(1) = [];
    else
        DeviceList = [];
    end
else
    error('Must have at least 2 inputs (Family and InOutControl).');
end


% Can only set one video device
% Set the video to the first true
i = find(InOutControl==1);
if ~isempty(i)
    DeviceList = DeviceList(i(1),:);
else
    return;
end

DeviceListTotal = family2dev('TV');
VideoNames = family2channel('TV', 'Video');

iDev = findrowindex(DeviceList, DeviceListTotal);

DevName = VideoNames(iDev,:);

% There might be a couple blanks at the end
DevName = deblank(DevName);

SubMachine = getfamilydata('SubMachine');
if strcmpi(SubMachine, 'GTB')
    MUX_Name = 'ltb_video_mux';
elseif strcmpi(SubMachine, 'Booster')
    MUX_Name = 'br_video_mux';
elseif strcmpi(SubMachine, 'BTS')
    MUX_Name = 'br_video_mux';
elseif strcmpi(SubMachine, 'StorageRing')
    MUX_Name = 'br_video_mux';
else
    error('SubMachine type unknown');
end

ErrorFlag = setpvonline(MUX_Name, DevName, 'char');

