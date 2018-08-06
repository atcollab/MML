function orbcorv(Evectors, Iters, RemoveDeviceList, DisplayFlag)
% orbcorv(Evectors {1e-4}, Iters {2}, RemoveDeviceList {[12 5]})

% Initialize
if nargin < 1
    Evectors = [];
end
if isempty(Evectors)
    Evectors = 1e-4;
end

if nargin < 2
    Iters = [];
end
if isempty(Iters)
    Iters = 2;
end

if nargin < 3
    RemoveDeviceList = [];
end
if isempty(RemoveDeviceList)
    RemoveDeviceList = [12 5];   %  10 4
end

if nargin < 4
    DisplayFlag = [];
end
if isempty(DisplayFlag)
    DisplayFlag = 'Display';
end


% Get BPM and CM structures
CM = getsp('VCM','struct');
BPM = gety('struct');


% Remove BPMs
i = findrowindex(RemoveDeviceList, BPM.DeviceList); 
BPM.DeviceList(i,:) = [];
BPM.Data(i,:) = [];
BPM.Status(i,:) = [];


% % Remove VCMs
% if strcmpi(DisplayFlag,'Display')
%     fprintf('  Removing VCM(18,2)');
% end
% i = findrowindex([18 2], CM.DeviceList); 
% CM.DeviceList(i,:) = [];
% CM.Data(i,:) = [];
% CM.Status(i,:) = [];


% Corrector orbit
setorbit('Golden', BPM, CM, Iters, Evectors, DisplayFlag);



% BPMWeight = ones(size(BPM.DeviceList,1),1);
% BPMWeight(i) = [];
% setorbit('Golden', BPM, CM, Iter, Evectors, BPMWeight, 'Display');
