function [Golden, t, DataTime, ErrorFlag] = getgoldenorbit_fofb(Family, varargin)
% [Golden, tout, DataTime, ErrorFlag] = getgoldenorbit_fofb(Family, DeviceList)
% [Golden, tout, DataTime, ErrorFlag] = getgoldenorbit_fofb(Family, Field, DeviceList)
%
% See also setgoldenorbit_fofb fofbinit

% Note: the Field input is ignored but special functions must have Family, Field, DeviceList

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

t = [];
DataTime = [];
ErrorFlag = 0;

Field = 'XGoldenSetpoint';

% Look for field input
if length(varargin) >= 1
    if ischar(varargin{1})
        Field = varargin{1};
        varargin(1) = [];
    end
end

% Look for device list input
if length(varargin) >= 1
    if ~ischar(varargin{1})
        Dev = varargin{1};
        varargin(1) = [];
    end
end

DevTotal  = family2dev('BPM');
Cell = getfamilydata('BPM','Cell');

for i = 1:size(Dev,1)
    % Find which BPMs are in what cell controller
    j = findrowindex(Dev(i,:), DevTotal);
    s = Cell(j);
    PV = sprintf('SR%02d:CC:BPMsetpoints', s);
    [a, t, DataTime(i,1), ErrorFlag] = getpvonline(PV);
    

    % The position in the cell controller waveform is based on the lower 4 binary digits in the FOFB index
    FOFBIndex = getpv('BPM', 'FOFBIndex', Dev(i,:));
    b = dec2bin(FOFBIndex, 8);
    CellArrayIndex = bin2dec(b(:,4:8));
 
    if strcmpi(Field, 'XGoldenSetpoint')
        Golden(i,1) = a(2*CellArrayIndex+1) / 1e6;
    else
        Golden(i,1) = a(2*CellArrayIndex+2) / 1e6;
    end  
end



