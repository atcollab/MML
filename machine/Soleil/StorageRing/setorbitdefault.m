function setorbitdefault(varargin)
% setorbitdefault(Evectors, Iters {1}, RemoveBPMDeviceList, RemoveHCMDeviceList, RemoveVCMDeviceList)


% Defaults
PlaneFlag = 0;
Iters = 1;
Evectors = [];
RemoveBPMDeviceList = [];   
RemoveHCMDeviceList = [];   
RemoveVCMDeviceList = [];   
DisplayFlag = 'NoDisplay';

HCMFamily = gethcmfamily;
VCMFamily = getvcmfamily;


% Input parsing
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Just remove
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 'Display';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 'NoDisplay';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'x','Horizontal'}))
        PlaneFlag = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'y','Vertical'}))
        PlaneFlag = 2;
        varargin(i) = [];
    end
end


if length(varargin) >= 1
    if isnumeric(varargin{1})
        Evectors = varargin{1};
        varargin(i) = [];
    end
end
if isempty(Evectors)
    nxcor = 56;
    nycor = 56;
    if PlaneFlag == 0
        % Both planes
        Evectors = 1:(nxcor + nycor);
    elseif PlaneFlag == 1
        % Horizontal
        Evectors = 1:nxcor;
    elseif PlaneFlag == 2
        Evectors = 1:nycor;
    end
end

if length(varargin) >= 1
    if isnumeric(varargin{1})
        Iters = varargin{1};
        varargin(i) = [];
    end
end

if length(varargin) >= 1
    if isnumeric(varargin{1})
        RemoveBPMDeviceList = varargin{1};
        varargin(i) = [];
    end
end

if PlaneFlag == 0
    % Get BPM and CM structures
    CM  = {getsp(HCMFamily,'struct'),getsp(VCMFamily,'struct')};
    BPM = {getx('struct'), gety('struct')};
    
    
    % Remove devices
    
    % HCM
    i = findrowindex(RemoveHCMDeviceList, CM{1}.DeviceList); 
    CM{1}.DeviceList(i,:) = [];
    CM{1}.Data(i,:) = [];
    CM{1}.Status(i,:) = [];

    % VCM
    i = findrowindex(RemoveVCMDeviceList, CM{2}.DeviceList); 
    CM{2}.DeviceList(i,:) = [];
    CM{2}.Data(i,:) = [];
    CM{2}.Status(i,:) = [];

    % BPMx and BPMy
    i = findrowindex(RemoveBPMDeviceList, BPM{1}.DeviceList); 
    BPM{1}.DeviceList(i,:) = [];
    BPM{1}.Data(i,:) = [];
    BPM{1}.Status(i,:) = [];
    
    i = findrowindex(RemoveBPMDeviceList, BPM{2}.DeviceList); 
    BPM{2}.DeviceList(i,:) = [];
    BPM{2}.Data(i,:) = [];
    BPM{2}.Status(i,:) = [];
    
elseif PlaneFlag == 1

    % Get BPM and CM structures
    CM  = getsp(HCMFamily,'struct');
    BPM = getx('struct');
    
    
    % Remove devices
    
    % HCM
    i = findrowindex(RemoveHCMDeviceList, CM.DeviceList); 
    CM.DeviceList(i,:) = [];
    CM.Data(i,:) = [];
    CM.Status(i,:) = [];

    % BPMx
    i = findrowindex(RemoveBPMDeviceList, BPM.DeviceList); 
    BPM.DeviceList(i,:) = [];
    BPM.Data(i,:) = [];
    BPM.Status(i,:) = [];    

elseif PlaneFlag == 2
    
    % Get BPM and CM structures
    CM  = getsp(VCMFamily,'struct');
    BPM = gety('struct');
    
    
    % Remove devices
    
    % VCM
    i = findrowindex(RemoveVCMDeviceList, CM.DeviceList); 
    CM.DeviceList(i,:) = [];
    CM.Data(i,:) = [];
    CM.Status(i,:) = [];
    
    % BPMy
    i = findrowindex(RemoveBPMDeviceList, BPM.DeviceList);
    BPM.DeviceList(i,:) = [];
    BPM.Data(i,:) = [];
    BPM.Status(i,:) = [];
end


% Corrector orbit
setorbit('Golden', BPM, CM, Iters, Evectors, DisplayFlag, varargin{:});
