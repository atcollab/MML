function setorbitdefault(Evectors, Iters, RemoveDeviceList, DisplayFlag, varargin)
% setorbitdefault(Evectors {1e-4}, Iters {1}, RemoveDeviceList)

% Initialize
if nargin < 1
    Evectors = [];
end
if isempty(Evectors)
    Evectors = 1e-3;
end

if nargin < 2
    Iters = [];
end
if isempty(Iters)
    Iters = 1;
end

if nargin < 3
    RemoveDeviceList = [];
end
if isempty(RemoveDeviceList)
    RemoveDeviceList = [1 8; 11 9; 12 8];   %  Put default here
end

if nargin < 4
    DisplayFlag = [];
end
if isempty(DisplayFlag)
    DisplayFlag = 'Display';
end


% Get BPM and CM structures
CM  = {getsp('HCM','struct'),getsp('VCM','struct')};
BPM = {getx('struct'), gety('struct')};


% Remove devices
i = findrowindex(RemoveDeviceList, BPM{1}.DeviceList); 
BPM{1}.DeviceList(i,:) = [];
BPM{1}.Data(i,:) = [];
BPM{1}.Status(i,:) = [];

i = findrowindex(RemoveDeviceList, BPM{2}.DeviceList); 
BPM{2}.DeviceList(i,:) = [];
BPM{2}.Data(i,:) = [];
BPM{2}.Status(i,:) = [];


% Corrector orbit
setorbit('Golden', BPM, CM, Iters, Evectors, DisplayFlag, varargin{:});
