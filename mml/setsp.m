function ErrorFlag = setsp(Family, varargin)
%SETSP - Makes an absolute setpoint change to the 'Setpoint' field
%  If using family name, device list method,
%  ErrorFlag = setsp(Family, newSP, DeviceList, WaitFlag)
%  ErrorFlag = setsp(DataStructure, WaitFlag)
%
%  If using common name method,
%  ErrorFlag = setsp(Family, newSP, CommonNames, WaitFlag)
%
%  If using channel name method,
%  ErrorFlag = setsp('ChannelName', newSP)
%
%
%  INPUTS & OUTPUTS
%  See setpv.  Setsp is an alias to setpv with the Field='Setpoint'.
%  
%
%  EXAMPLES
%  setsp('HCM',1.23) sets the entire HCM family to 1.23
%  setsp({'HCM','VCM'},{10.4,5.3}) sets the entire HCM family to 10.4 and VCM family to 5.3
%  setsp(AccData, 1.5, [1 2]) if AccData is a properly formated Accelerator Data Structure
%                             then the 1st sector, 2nd element is set to 1.5
%
%  See also stepsp, getam, getsp, getpv, setpv, steppv

%  Written by Greg Portmann


%ErrorFlag = setpv(varargin{:});


if nargin == 0
    error('Must have at least one input (Family, Data Structure or Channel Name).');
end


if iscell(Family)
    ErrorFlag = setpv(Family, 'Setpoint', varargin{:});
else
    FamilyIndex = isfamily(Family);

    if FamilyIndex
        % Family name method
        % Cannot send the AO because the AO method needs the setpoint on the input line
        ErrorFlag = setpv(Family, 'Setpoint', varargin{:});
    else
        % ChannelName method
        ErrorFlag = setpv(Family, '', varargin{:});
    end
end

