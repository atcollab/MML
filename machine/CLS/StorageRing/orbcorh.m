function orbcorh(Evectors, Iters, RemoveDeviceList, DisplayFlag)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/orbcorh.m 1.2 2007/03/02 09:02:48CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% orbcorh(Evectors {1e-4}, Iters {2}, RemoveDeviceList {[12 5]})

% Initialize
if nargin < 1
    Evectors = [];
end
if isempty(Evectors)
    Evectors = 1:12;
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
    RemoveDeviceList = [];  % [4 3; 11 4]
end

if nargin < 4
    DisplayFlag = [];
end
if isempty(DisplayFlag)
    DisplayFlag = 'Display';
end


% Get BPM and CM structures
CM = getsp('HCM','struct');
BPM = getx('struct');


% Remove devices
i = findrowindex(RemoveDeviceList, BPM.DeviceList); 
BPM.DeviceList(i,:) = [];
BPM.Data(i,:) = [];
BPM.Status(i,:) = [];


% Corrector orbit
setorbit('Golden', BPM, CM, Iters, Evectors, DisplayFlag);
%setorbit('Golden', BPM, CM, Iters, Evectors, 'Display', 'FitRF');



% BPMWeight = ones(size(BPM.DeviceList,1),1);
% BPMWeight(i) = [];
% setorbit('Golden', BPM, CM, Iter, Evectors, BPMWeight, 'Display');

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/orbcorh.m  $
% Revision 1.2 2007/03/02 09:02:48CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
