function ErrorFlag = setsp_rf(Family, varargin)
%  Error = setsp_rf(Family, Power, DeviceList, WaitFlag)
%  Error = setsp_rf(Family, Field, Power, DeviceList, WaitFlag)
%


ErrorFlag = 0;
Field = 'Setpoint';

% Remove the Field input
if length(varargin) >= 1
    if ischar(varargin{1})
        Field = varargin{1};
        varargin(1) = [];
    end
    if length(varargin) >= 1
        Amps = varargin{1};
        varargin(1) = [];
    else
        error('Must have at least 2 inputs (Family and Power).');
    end
    if length(varargin) >= 1
        DeviceList = varargin{1};
        varargin(1) = [];
    else
        DeviceList = [];
    end
else
    error('Must have at least 2 inputs (Family and Power).');
end

% Power is complex

%ErrorFlag  = setpv(Family, Field, Power, DeviceList, 'Hardware', varargin{:});
%Names = family2names(Family, Field, DeviceList);
%ErrorFlag  = setpv(Names, 'DTVH', 1, DeviceList, 'Hardware', varargin{:});



