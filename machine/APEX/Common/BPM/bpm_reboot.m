function bpm_reboot(PrefixIn)

if nargin < 1 || isempty(PrefixIn)
    PrefixIn = getfamilydata('BPM','BaseName');
end

if ischar(PrefixIn)
    for i = 1:size(PrefixIn, 1)
        Prefix{i} = deblank(PrefixIn(i,:));
    end
elseif iscell(PrefixIn)
    Prefix = PrefixIn;
elseif isnumeric(PrefixIn)
    % DeviceList input
    DeviceList = PrefixIn;
    Prefix = getfamilydata('BPM', 'BaseName', DeviceList);
end


% Step 1
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':FPGA:reboot'], 0);
end
pause(.5);

% Step 2
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':FPGA:reboot'], 100);
end
pause(.5);

% Step 3
for i = 1:length(Prefix)
    setpvonline([Prefix{i},':FPGA:reboot'], 10000, 'double', 1);
end

% Note:  SR03C:BPM8 & SR04C:BPM8 never seem to work in a group





