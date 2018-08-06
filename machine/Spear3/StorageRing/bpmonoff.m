function bpmonoff(BPMDeviceList,NewStatus);
%BPMONOFF sets the BPM status in the AO
% BPMONOFF(BPMDeviceList, NewStatus)
% NewStatus can be numeric 1 / 0, or sting 'on' / 'off'


if isnumeric(NewStatus)
    if NewStatus==0 | NewStatus == 1
        S = NewStatus;
    else
        error('Allowed values for NewStatus are 0,1,''on'', and ''off''');
    end
elseif ischar(NewStatus)
    if strcmpi(NewStatus,'on')
        S = 1;
    elseif strcmpi(NewStatus,'off')
        S = 0;
    else
        error('Allowed values for NewStatus are 0,1,''on'', and ''off''');
    end
else
    error('Allowed values for NewStatus are 0,1,''on'', and ''off''');
end
    
setfamilydata(S,'BPMx','Status',BPMDeviceList);
setfamilydata(S,'BPMy','Status',BPMDeviceList);