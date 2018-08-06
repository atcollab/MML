function ErrorFlag = setrfxray(Family, Field, RF, DeviceList, WaitFlag)
% ErrorFlag = setrfxray(Family, Field, RF, DeviceList, WaitFlag)  [MHz]
% ErrorFlag = setrfxray(Family, RF, DeviceList, WaitFlag)  [MHz]
% ErrorFlag = setrfxray(RF, DeviceList, WaitFlag)  [MHz]
%
% Note: xfreqhi [kHz], xreqlo [Hz/10]

if nargin < 1
    error('RF frequency input is required.');
end

% Family or Field maybe numeric (ie, RF)
if isnumeric(Family)
    % RF, DeviceList, WaitFlag
    if nargin >= 3
        WaitFlag = RF; 
    else
        WaitFlag = 0;
    end
    
    if nargin >= 2
        DeviceList = Field;
    else
        DeviceList = [];
    end
    
    RF = Family;
elseif isnumeric(Field)
    % Family, RF, DeviceList, WaitFlag
    if nargin < 2
        error('RF frequency input is required.');
    end
    if nargin >= 4
        WaitFlag = DeviceList; 
    else
        WaitFlag = 0;
    end
    
    if nargin >= 3
        DeviceList = RF;
    else
        DeviceList = [];
    end
    
    RF = Field;
else
    % Family, Field, RF, DeviceList, WaitFlag
    if nargin < 3
        error('RF frequency input is required.');
    end
    if nargin < 4
        DeviceList = [];
    end
    if nargin < 5
        WaitFlag = 0;
    end
end


RF_hi = fix(1000*RF);           % [kHz]
RF_lo = 10000*(1000*RF-RF_hi);  % [Hz/10]
% Set hi freq first
ErrorFlag1 = setpv('xfreqhi:sp', RF_hi);

% Then set lo freq, which triggers the change 
ErrorFlag2 = setpv('xfreqlo:sp', RF_lo, WaitFlag);
ErrorFlag = ErrorFlag1 | ErrorFlag2;

