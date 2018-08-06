function [DCCT, tout, DataTime, ErrorFlag] = getdcct(varargin)
%GETDCCT - returns the beam current
%  [DCCT, tout, DataTime, ErrorFlag] = getdcct(t, InputFlags)
%
%  OUTPUTS
%  1. DCCT = storage ring electron beam current
%  
%  INPUTS
%  1. 'Struct' will return a data structure
%     'Numeric' will return numeric outputs {Defaul}
%  2. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%  3. 'Online' - Get data online (optional override of the mode)
%     'Model'  - Get data from the model (optional override of the mode)
%     'Manual' - Get data manually (optional override of the mode)
%
%  NOTE
%  1. Simulation mode: lifetime is 6 hour, refill at midnight to 1000 mamps
%  2. This function is just an alias for getam('DCCT', ...)

%  Written by Greg Portmann

if isfamily('DCCT')
    if nargout > 2
        [DCCT, tout, DataTime, ErrorFlag] = getpv('DCCT', 'Monitor', [], varargin{:});
    else
        [DCCT, tout] = getpv('DCCT', 'Monitor', [], varargin{:});
    end
else
    DCCT = NaN;
    tout = 0;

    t1 = clock;
    days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
    tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
    DataTime = fix(tt) + rem(tt,1)*1e9*sqrt(-1);

    ErrorFlag = -1;
end

