function ErrorFlag = settv_booster(Family, varargin)
%SETTV_BTS - Sets both the paddle and lamp
%  Error = settv_booster(Family, InOutControl, DeviceList, WaitFlag)
%  Error = settv_booster(Family, Field, InOutControl, DeviceList, WaitFlag)
%
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


ErrorFlag1 = setpv(Family, 'Lamp',      InOutControl, DeviceList, 0, 'Hardware', varargin{:});
ErrorFlag  = setpv(Family, 'InControl', InOutControl, DeviceList, 'Hardware', varargin{:});
ErrorFlag1 = setpv(Family, 'Lamp',      InOutControl, DeviceList, 'Hardware', varargin{:});

ErrorFlag = ErrorFlag | ErrorFlag1;


