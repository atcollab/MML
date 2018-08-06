function [N, T] = getbpmaverages(varargin)
%GETBPMAVERAGES - Gets the BTS BPM averages and update period
%  [N, T] = getbpmaverages(DeviceList)
%
%  INPUTS
%  1. DeviceList - BPM device list {Default: [1 3]}
%
%  OUTPUTS
%  1. N - Number of averages
%  2. T - Sampling period after averaging [seconds]
%
%  Written by Greg Portmann


Mode = getfamilydata('BPMx','Monitor','Mode');
DeviceList = [];

if nargin == 0
    DeviceList = family2dev(gethbpmfamily);
else
    DeviceList = varargin{1};
end

if strcmpi(Mode,'Simulator')

        if length(varargin) >= 1
            if ischar(varargin{1})
                varargin(1) = [];
            end
        end
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                DeviceList = varargin{1};
            else
                error('DeviceList not found');
            end
        end
        if isempty(DeviceList)
            DeviceList = family2dev('BPMx');
        end

        N = 1 * ones(size(DeviceList,1),1);
        T = 0 * ones(size(DeviceList,1),1);

else

	% 1.45 Hertz injector, no averaging
	N = 1 * ones(size(DeviceList,1),1);
	T = 2 * ones(size(DeviceList,1),1);

end

