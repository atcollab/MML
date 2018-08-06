function ErrorFlag = settv(Family, varargin)
%SETTV - Sets the video, paddle, and lamp
%  Error = settv(Family, InOutControl, DeviceList, WaitFlag)
%  Error = settv(Family, Field, InOutControl, DeviceList, WaitFlag)

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


DeviceListTotal = family2dev('TV');
VideoNames = family2channel('TV', 'Video');

iDev = findrowindex(DeviceList, DeviceListTotal);

SPTotal = zeros(size(DeviceListTotal,1),1);
SPTotal(iDev) = InOutControl;


% Set the video to the first true
i = find(InOutControl==1);
if ~isempty(i)
    ErrorFlag1 = setpv(Family, 'Video', 1, DeviceList(i(1),:));
else
    ErrorFlag1 = 0;
end

ErrorFlag2 = setpv(Family, 'InControl',   SPTotal, DeviceListTotal, 'Hardware');
pause(.1);
ErrorFlag3 = setpv(Family, 'LampControl', SPTotal, DeviceListTotal, 'Hardware');

ErrorFlag = ErrorFlag1 || ErrorFlag2 || ErrorFlag3;


