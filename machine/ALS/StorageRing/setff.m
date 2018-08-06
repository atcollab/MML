function setff(DeviceList, FFEnableBC, GapEnableBC)
% function setff(DeviceList, FFEnableBC, GapEnableBC)


Mode = getmode('HCM');

if ~strcmpi(Mode,'Simulator')
    
    if nargin < 2
        error('Need atleast two inputs.');
    end

    if isempty(DeviceList)
        DeviceList = family2dev('ID');
    end
    if size(DeviceList,2) == 1
        %DeviceList = elem2dev('ID', DeviceList);
        DeviceList = [DeviceList ones(size(DeviceList))];
    end

    setpv('ID', 'FFEnableControl', FFEnableBC, DeviceList);

    if nargin >= 3
        setpv('ID', 'GapEnableControl', GapEnableBC, DeviceList);
    end

    sleep(.1);
end