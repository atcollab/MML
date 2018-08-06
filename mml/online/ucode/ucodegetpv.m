function data =  ucodegetpv(pvs)
% UICODEGETPV
% PV names must end with ':am' or ':sp'
% for readbacks and setpoints
% 

NHEADER = 1;

if ischar (pvs) 
    pvs = cellstr(pvs);
end

commandstr = '/home/moper/acceleratorcontrol/mml/links/ucode/uget';
devicestring = '';

for i=1:length(pvs)
    devicestring = [devicestring, '  ', pvs{i}(1:end-3)];
 
    if strcmpi(pvs{i}(end-1:end),'am')
        amspswitch = 2;
    elseif strcmpi(pvs{i}(end-1:end),'sp')
        amspswitch = 1;
    else
        error('pv name must end with '':am'' or '':sp''');
    end

end

% status system call return status
[status, longstring] = system([commandstr,'   ', devicestring]);

if status
    data = NaN;
    disp(['** system call failed: ', longstring]);
else
    crs = findstr(longstring, sprintf('\n'));
    longstring = longstring(crs(NHEADER)+1:end);
    data = str2double(longstring);
    data =  data(:, amspswitch);
end
