function [Data, t, DataTime, ErrorFlag] = getam_nsls2(Family, varargin)


if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

tout = [];
DataTime = [];
ErrorFlag = 0;


% Remove the Field input
if length(varargin) >= 1
    if ischar(varargin{1})
        % Remove and ignor the Field string
        varargin(1) = [];
    end
end

DeviceList = family2dev('BPMx');
i = findrowindex([1  5;], DeviceList); 
DeviceList(i,:) = [];

ChannelName = family2channel(Family, 'Monitor', DeviceList);
[Data,   t, DataTime, ErrorFlag] = getpv(ChannelName);


if strcmpi(Family, 'BPMx')
    
    tcp_write_reg(0,1);
    pause(1);
    [cha, chb, chc, chd] = tcp_read_adcdata_v3(2^16);
    %plot(cha);
    low = 21;
    high = 21;
    FigNum = [];
    Shift = 0;
    NTurns = 10;  % ???
    [x,y] = nsls_xy({cha, chb, chc, chd}, low, high, FigNum, Shift, NTurns);
    
    AM = mean(x);
    
    save temp y
    
else
    load temp
    AM = mean(y);
end


Data = [Data(1:i-1); AM; Data(i:end)];
DataTime = [DataTime(1:i-1); DataTime(i-1); DataTime(i:end)];  % Just fake the NSLS2 time


