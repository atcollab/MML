function ErrorFlag = setgoldenorbit_fofb(Family, varargin)
% Error = setgoldenorbit_fofb(Family, Golden, DeviceList, WaitFlag)
% Error = setgoldenorbit_fofb(Family, Field, Golden, DeviceList, WaitFlag)
%
% See also getgoldenorbit_fofb fofbinit

%  Note: special functions must have Family, Field, Setpoint, DeviceList

% I too allow 2 colm!!!
%

ErrorFlag = 0;
Golden = [];
Field = 'XGoldenSetpoint';

% Look for field input
if length(varargin) >= 1
    if ischar(varargin{1})
        Field = varargin{1};
        varargin(1) = [];
    end
end

% Look for golden input
if length(varargin) >= 1
    if ~ischar(varargin{1})
        Golden = varargin{1};
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

DevTotal = family2dev('BPM');
Cell = getfamilydata('BPM','Cell');

if isempty(Golden)
    if strcmpi(Field, 'XGoldenSetpoint')
        Golden = getgolden('BPMx', Dev);
    else
        Golden = getgolden('BPMy', Dev);
    end
end

if size(Dev,1) > 10
    % Since this function is typically called with many devices it's best to get/set all of them
    PV = [
        'SR01:CC:BPMsetpoints'
        'SR02:CC:BPMsetpoints'
        'SR03:CC:BPMsetpoints'
        'SR04:CC:BPMsetpoints'
        'SR05:CC:BPMsetpoints'
        'SR06:CC:BPMsetpoints'
        'SR07:CC:BPMsetpoints'
        'SR08:CC:BPMsetpoints'
        'SR09:CC:BPMsetpoints'
        'SR10:CC:BPMsetpoints'
        'SR11:CC:BPMsetpoints'
        'SR12:CC:BPMsetpoints'
        ];
    a = getpvonline(PV);
    
    for i = 1:size(Dev,1)
        % Find which BPMs are in what cell controller
        j = findrowindex(Dev(i,:), DevTotal);
        s = Cell(j);
        
        % The position in the cell controller waveform is based on the lower 4 binary digits in the FOFB index
        FOFBIndex = getpv('BPM', 'FOFBIndex', Dev(i,:));
        b = dec2bin(FOFBIndex, 8);
        CellArrayIndex = bin2dec(b(:,4:8));
        
        % The cell controller golden orbit is in nanometers
        if strcmpi(Field, 'XGoldenSetpoint')
            a(s,2*CellArrayIndex+1) = round(1e6 * Golden(i));
        else
            a(s,2*CellArrayIndex+2) = round(1e6 * Golden(i));
        end
    end
    
    % The cell controller golden orbit is in nanometers
    setpvonline(PV, a);
    
else
    for i = 1:size(Dev,1)
        % Find which BPMs are in what cell controller
        j = findrowindex(Dev(i,:), DevTotal);
        s = Cell(j);
        PV = sprintf('SR%02d:CC:BPMsetpoints', s);
        a = getpvonline(PV);
        
        % The position in the cell controller waveform is based on the lower 4 binary digits in the FOFB index
        FOFBIndex = getpv('BPM', 'FOFBIndex', Dev(i,:));
        b = dec2bin(FOFBIndex, 8);
        CellArrayIndex = bin2dec(b(:,5:8));
        
        % The cell controller golden orbit is in nanometers
        if strcmpi(Field, 'XGoldenSetpoint')
            a(2*CellArrayIndex+1) = round(1e6 *Golden(i));
        else
            a(2*CellArrayIndex+2) = round(1e6 *Golden(i));
        end
        
        setpvonline(PV, a);
    end
end



