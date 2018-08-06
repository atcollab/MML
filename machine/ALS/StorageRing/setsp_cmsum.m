function ErrorFlag = setsp_cmsum(Family, varargin)
%  Error = setsp_cmffsum(Family, Amps, DeviceList, WaitFlag)
%  Error = setsp_cmffsum(Family, Field, Amps, DeviceList, WaitFlag)
%
%  Sets the main setpoints to Amps and all the summing junctions to zero
%
%  Note: the Field input is ignored but special functions must have Family, Field, Setpoint, DeviceList


ErrorFlag = 0;


% Remove the Field input
if length(varargin) >= 1
    if ischar(varargin{1})
        % Remove and ignor the Field string
        varargin(1) = [];
    end
    if length(varargin) >= 1
        Amps = varargin{1};
        varargin(1) = [];
    else
        error('Must have at least 2 inputs (Family and Amps).');
    end
    if length(varargin) >= 1
        DeviceList = varargin{1};
        varargin(1) = [];
    else
        DeviceList = [];
    end
else
    error('Must have at least 2 inputs (Family and Amps).');
end


ErrorFlag1 = setpv(Family, 'Trim',        0, DeviceList, 0, 'Hardware');
ErrorFlag2 = setpv(Family, 'FF1',         0, DeviceList, 0, 'Hardware');
ErrorFlag3 = setpv(Family, 'FF2',         0, DeviceList, 0, 'Hardware');
ErrorFlag  = setpv(Family, 'Setpoint', Amps, DeviceList, 'Hardware', varargin{:});

ErrorFlag = ErrorFlag | ErrorFlag1 | ErrorFlag2 | ErrorFlag3;


