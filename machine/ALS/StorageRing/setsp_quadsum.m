function ErrorFlag = setsp_quadsum(Family, varargin)
%  Error = setsp_cmffsum(Family, Amps, DeviceList, WaitFlag)
%  Error = setsp_cmffsum(Family, Field, Amps, DeviceList, WaitFlag)
%
%  Sets the main setpoints to Amps and the summing junction to zero
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


ErrorFlag1 = setpv(Family, 'FF',          0, DeviceList, 0, 'Hardware');
ErrorFlag2 = setpv(Family, 'Setpoint', Amps, DeviceList, 'Hardware', varargin{:});

ErrorFlag = ErrorFlag1 | ErrorFlag2;


