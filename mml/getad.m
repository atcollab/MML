function  AD = getad
%GETAD - returns the Accelerator Data (AD) structure
% AD = getad


AD = getappdata(0, 'AcceleratorData');

% if isempty(AD)
%     warning('AcceleratorData not initialized');
% end

