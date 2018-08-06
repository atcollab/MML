function ErrorFlag = setrfvuv(Family, Field, RF, DeviceList, WaitFlag)
%SETRFVUV - Sets the RF frequency in the VUV ring
%
%  ErrorFlag = setrfvuv(Family, Field, RF, DeviceList, WaitFlag)  [MHz]
%  ErrorFlag = setrfvuv(Family, RF, DeviceList, WaitFlag)  [MHz]
%  ErrorFlag = setrfvuv(RF, DeviceList, WaitFlag)  [MHz]
%
%  Program note: ufreqhi [MHz], ufreqlo [Hz]


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


RF_hi = 0.001*fix(RF*1000); % [MHz]
RF_lo = (RF-RF_hi)*1000000;  % [Hz]
% Set hi freq first
ErrorFlag1 = setpv('ufreqhi:sp', RF_hi); 
% then set lo freq, which triggers the change 
ErrorFlag2 = setpv('ufreqlo:sp', RF_lo, WaitFlag);
ErrorFlag = ErrorFlag1 | ErrorFlag2;


