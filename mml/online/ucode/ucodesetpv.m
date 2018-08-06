function status =  ucodesetpv(pvs, values)
% UICODESETPV
% PV names must end with ':am' or ':sp'
% for readbacks and setpoints


if ischar (pvs) 
    pvs = cellstr(pvs);
end
if length(pvs) ~= length(values)
    error('values and pvs must be the same length')
end

commandstr = '/home/bengtsson/matlab1.0/acceleratorcontrol/ucode/uputsp';


devicestring = '';

for i=1:length(pvs)
    devicestring = [devicestring, '  ', pvs{i}(1:end-3)];
    
    
    if strcmpi(pvs{i}(end-1:end),'sp') == 0
        error('pv name must end with '':sp''');
    end
    
    devicestring = [devicestring, '  ', num2str(values(i))];
    
end


%disp(devicestring)
[status, longstring] = system([commandstr, '   ', devicestring]);
crs = findstr(longstring, sprintf('\n'));
longstring = longstring(crs(end)-1:end);
status = str2num(longstring);

