function [Data, t, DataTime, ErrorFlag] = getbpm_nsls2(Family, varargin)
% [Data, t, DataTime, ErrorFlag] = getbpm_nsls2(Family, Field, DeviceList, N)
if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

tout = [];
DataTime = [];
ErrorFlag = 0;

if length(varargin) >= 1 && ischar(varargin{1})
    Field = varargin{1};
    varargin(1) = [];
else
    Field = 'TBT';
end
if length(varargin) >= 1
    DeviceList = varargin{1};
else
    DeviceList = family2dev(Family);
end
if length(varargin) >= 2
    N = varargin{2};
else
    N = 0;  % Possibly limit this???  Plotfamily might be slow if you don't
end


% Add triggering here %%


ChannelName = family2channel(Family, Field, DeviceList);
[Data, t, DataTime, ErrorFlag] = getpvonline(ChannelName, 'Waveform', N);



