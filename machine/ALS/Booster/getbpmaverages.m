function [N, T] = getbpmaverages(DeviceList)
%GETBPMAVERAGES - Gets the BTS BPM averages and update period
%  [N, T] = getbpmaverages(DeviceList)
%
%  INPUTS
%  1. DeviceList - BPM device list
%
%  OUTPUTS
%  1. N - Number of averages
%  2. T - Sampling period after averaging [seconds]
%
%  Written by Greg Portmann


Mode = getfamilydata(gethbpmfamily, 'Monitor', 'Mode'); 

if nargin < 0
    DeviceList = [];
end

if isempty(DeviceList)
    DeviceList = family2dev(gethbpmfamily);
end

if strcmpi(Mode,'Simulator')

    N = 1 * ones(size(DeviceList,1),1);
    T = 0 * ones(size(DeviceList,1),1);

else

    % 1 Hertz injector, no averaging
    N = 1 * ones(size(DeviceList,1),1);
    T = 1 * ones(size(DeviceList,1),1);

end

