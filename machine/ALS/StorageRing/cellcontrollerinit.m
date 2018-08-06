
function cellcontrollerinit(varargin)
%CELLCONTROLLERINIT - This function initializes the cell controller for the SR BPMs
%
% cellcontrollerinit('UserBeam')   % Default
% cellcontrollerinit('Low Current')
% cellcontrollerinit('Shutdown')
%

% NOTES
% 1. SR05C:BPM7? used for tune measurement -- no PT!!!
% 2. EEBI
% 3. Topoff interlock in sector 8 (PT combiner not connected in the ring)

% 2016-11-02 4pm -> 1,6,7 PTs on.  Look for PT orbit changes.

% 18mA -> SR01C:BPM2  pt 17 is equal with 600mA.  400mV, max  attn is about 1/10 RF


% Get inputs (sort out the flags first)
Mode = 'UserBeam';
AttnOnlyFlag = 0;
PTAttn = [];

for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor
    else
        if ischar(varargin{i})
            if any(strcmpi(varargin{i},{'Attn Only','AttnOnly','Attn'}))
                AttnOnlyFlag = 1;
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'Full Setup','FullSetup'}))
                AttnOnlyFlag = 0;
                varargin(i) = [];
            %elseif any(strcmpi(varargin{i},{'SingleBunch','Single Bunch'}))
            %    Mode = 'SingleBunch';
            %    varargin(i) = [];
            %elseif any(strcmpi(varargin{i},{'TwoBunch','Two Bunch','Two-Bunch'}))
            %    Mode = 'TwoBunch';
            %    varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'UserBeam'}))
                Mode = 'UserBeam';
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'500 mA','500mA'}))
                Mode = '500mA';
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'200 mA','200mA'}))
                Mode = '200mA';
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'Low Current','LowCurrent'}))
                Mode = 'LowCurrent';
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'Off'}))
                Mode = 'Off';
                varargin(i) = [];
            elseif any(strcmpi(varargin{i},{'Shutdown'}))
                Mode = 'Shutdown';
                varargin(i) = [];
            else
                % Ignor unknown strings
                varargin(i) = [];
            end
        end
    end
end

if length(varargin) >= 1
    PTAttn = varargin{1};
    varargin(i) = [];
end


% Main pilot tone controls per cell controller
% For user ops make sure the PT isn't on the RF     -  Should this be an MML family?
% 0 -> Off
% 1 -> -.5 Rev Harmonic from RF ("Low")
% 2 -> On RF
% 3 -> +.5 Rev Harmonic from RF ("High")
NoWaitFlag = 1;
if strcmpi(Mode, 'Shutdown')
    % RF & Hi PT
    for s = [1 2 3 4 5 6 7 8 9 10 11 12]
        % Tone PLL controls
        setpvonline(sprintf('SR%02d:CC:ptA:Frequency', s), 2, 'double', NoWaitFlag);
        setpvonline(sprintf('SR%02d:CC:ptB:Frequency', s), 3, 'double', NoWaitFlag);
    end
elseif strcmpi(Mode, 'Off')
    for s = [1 2 3 4 5 6 7 8 9 10 11 12]
        % Tone PLL controls
        setpvonline(sprintf('SR%02d:CC:ptA:Frequency', s), 0, 'double', NoWaitFlag);
        setpvonline(sprintf('SR%02d:CC:ptB:Frequency', s), 0, 'double', NoWaitFlag);
    end
else
    % Lo & Hi PT
    for s = [1 2 3 4 5 6 7 8 9 10 11 12]
        % Tone PLL controls
        setpvonline(sprintf('SR%02d:CC:ptA:Frequency', s), 1, 'double', NoWaitFlag);
        setpvonline(sprintf('SR%02d:CC:ptB:Frequency', s), 3, 'double', NoWaitFlag);
    end
end


% Drive level for PTA & PTB
% 0 -> Off
% 1 -> CMOS
% 2 -> 960 mV
% 3 -> 780 mV
% 4 -> 600 mV
% 5 -> 400 mV
if any(strcmpi(Mode, {'Off'}))
    DriveLevel = 0;
else
    DriveLevel = 4;
end


% Attn matrix: Sector rows, BPM number columns
%   0->IDBPM2    1->BPM8    2->BPM7    3->BPM6    4->BPM5    5->BPM4    6->BPM3    7->BPM2    8->BPM1    9->IDBPM2 10->IDBPM4 11->IDBPM3
AttnOff = 31.75;

if isempty(PTAttn)
    if strcmpi(Mode, 'Off')
        AttnOn = AttnOff;
    elseif strcmpi(Mode, 'Shutdown')
        AttnOn = 0;
    elseif strcmpi(Mode, 'UserBeam')
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            if DriveLevel == 1
                AttnOn  = 20.00;
            else
                AttnOn  = 14.00;
            end
        else
            % 500 mA
            if DriveLevel == 1
                % CMOS
                AttnOn  = 17.00;
            else
                AttnOn  =  0;
            end
        end
        %Attn = (500 / getdcct) * Attn;
        %Attn = round(Attn, 2);
    elseif strcmpi(Mode, '500mA')
        if DriveLevel == 1
            AttnOn  = 17;
        else
            AttnOn  = 0;
        end
    elseif strcmpi(Mode, '200mA')
        if DriveLevel == 1
            AttnOn  = 23; 
        else
            AttnOn  = 6;
        end
    elseif strcmpi(Mode, 'LowCurrent')
        if DriveLevel == 1
            AttnOn  = 27.00;
        else
            AttnOn  = 10.00;
        end
    end
end

Dev = [
    1     3   AttnOn  0
    1     7   AttnOn +3  % could be used
    1     8   AttnOn +2
    1     9   AttnOn +2
    
   %2     2   AttnOn  0
    2     3   AttnOn  0
    2     8   AttnOn +2
   %2     9   AttnOn +2
    
   %3     2   AttnOn  0
    3     3   AttnOn  0
    3     8   AttnOn +2
    3     9   AttnOn +4

    4     2   AttnOn  0
    4     3   AttnOn  0
    4     8   AttnOn +2
    4     9   AttnOn +3
    
    5     2   AttnOn  0    % Change for user beam (post mortem)?
    5     3   AttnOn  0
    5     8   AttnOn +2    % Change for user beam (tune measurement, etc.)
    5     9   AttnOn +2

    6     2   AttnOn  0
    6     3   AttnOn  0
    6     8   AttnOn +2
    6     9   AttnOn +2
    
    7     2   AttnOn  0
    7     3   AttnOn  0
    7     8   AttnOn +2
    7     9   AttnOn +2
    
    8     2   AttnOn  0
    8     3   AttnOn  0
    8     8   AttnOn +4
    8     9   AttnOn +4
    
    9     2   AttnOn  0
    9     3   AttnOn  0
    9     8   AttnOn +2
    9     9   AttnOn +2
    
    10    2   AttnOn  0
    10    3   AttnOn  0
    10    8   AttnOn +2
    10    9   AttnOn +2

    11    2   AttnOn  0
    11    3   AttnOn  0
    11    8   AttnOn +2
    11    9   AttnOn +2
    
    12    2   AttnOn  0
    12    3   AttnOn  0
    12    8   AttnOn +2
   %12    9   AttnOn +2
   ];

% Change in user ops (tune measurement, etc.)
if strcmpi(Mode, 'UserBeam')
    % TbT BPMs
    DevListTBT = [
        5 2   % Post mortem
        5 8  % Tune measurement
        ];
    i = findrowindex(DevListTBT, Dev(:,1:2));
    Dev(i,3) =  AttnOff;
    Dev(i,4) =  0;
end

% Remove the BPMs not in the BPM family
[~, iNotFound] = findrowindex(Dev(:,1:2), family2dev('BPM'));
Dev(iNotFound,:) = [];


% Test BPMs
DevTest = [
    1     2   AttnOff
    1     4   AttnOff
    1     5   AttnOn  % [1 5] drives all the Test sum signals
    1     6   AttnOff
    6     4   AttnOff
    6     5   AttnOff
    6     7   AttnOff
    6    10   AttnOff
    6    11   AttnOff
    6    12   AttnOff
%     7     4   AttnOff
%     7     5   AttnOff
%     7     6   AttnOff
%     7     7   AttnOff
%     8     4   AttnOff
%     8     5   AttnOff
%     8     6   AttnOff
%     8     7   AttnOff
%     9     4   AttnOff
%     9     5   AttnOff
%     9     6   AttnOff
%     9     7   AttnOff
%     10     4   AttnOff
%     10     5   AttnOff
%     10     6   AttnOff
%     10     7   AttnOff
%     11     4   AttnOff
%     11     5   AttnOff
%     11     6   AttnOff
%     11     7   AttnOff
%     12     4   AttnOff
%     12     5   AttnOff
%     12     6   AttnOff
%     12     7   AttnOff
    ];

% Set PT
iOn  = find(Dev(:,3)==AttnOn);
iOff = find(Dev(:,3)==AttnOff);
if ~isempty(iOn) && AttnOn~=AttnOff
    if strcmpi(Mode, 'Off')
        % First turn BPM Auto Trim off
        setpv('BPM', 'PTControl', 0, Dev(iOn,1:2));
    end
    
    setpv('BPM', 'PTA', DriveLevel, Dev(iOn, 1:2));
    setpv('BPM', 'PTB', DriveLevel, Dev(iOn, 1:2));
    
    if ~strcmpi(Mode, 'Off')
        % Turn BPM Auto Trim on
        setpv('BPM', 'PTControl', 3, Dev(iOn,1:2));
    end
end
if ~isempty(iOff)
    if strcmpi(Mode, 'Off')
        % First turn BPM Auto Trim off
        setpv('BPM', 'PTControl', 0, Dev(iOff,1:2));
    end
    
    setpv('BPM', 'PTA', 0, Dev(iOff,1:2));
    setpv('BPM', 'PTB', 0, Dev(iOff,1:2));

    if ~strcmpi(Mode, 'Off')
        % Turn BPM Auto Trim on
        setpv('BPM', 'PTControl', 3, Dev(iOff,1:2));
    end
end

% PT Attn
setpv('BPM', 'PTAttn', Dev(:,3)+Dev(:,4), Dev(:,1:2));


% PT Control - auto trim (calibration)
% 3 -> Dual PT
% 2 -> PT High
% 1 -> PT Low
% 0 -> Off
if strcmpi(Mode, 'UserBeam')
    setpv('BPM', 'PTControl', 3);
elseif strcmpi(Mode, 'Shutdown')
    setpv('BPM', 'PTControl', 2);
end


% Test BPMs
iOn  = find(DevTest(:,3)==AttnOn);
iOff = find(DevTest(:,3)==AttnOff);
if ~isempty(iOn) && AttnOn~=AttnOff
    setpv('BPMTest', 'PTA', DriveLevel, DevTest(iOn, 1:2));
    setpv('BPMTest', 'PTB', DriveLevel, DevTest(iOn, 1:2));
end
if ~isempty(iOff)
    setpv('BPMTest', 'PTA', 0, DevTest(iOff,1:2));
    setpv('BPMTest', 'PTB', 0, DevTest(iOff,1:2));
end
setpv('BPMTest', 'PTAttn', DevTest(:,3), DevTest(:,1:2));


% SR07C:BPM3 is in a unique test state at the moment
% Each input is connected to a PT output
setpv('SR07:CC:pt3Atten',  25);
setpv('SR07:CC:ptA3Output', 5);
setpv('SR07:CC:ptB3Output', 5);

setpv('SR07:CC:pt4Atten',  25);
setpv('SR07:CC:ptA4Output', 5);
setpv('SR07:CC:ptB4Output', 5);

setpv('SR07:CC:pt5Atten',  25);
setpv('SR07:CC:ptA5Output', 5);
setpv('SR07:CC:ptB5Output', 5);

setpv('SR07:CC:pt6Atten',  25);
setpv('SR07:CC:ptA6Output', 5);
setpv('SR07:CC:ptB6Output', 5);


% Set BPM to use the tone (or not)         where to do this??????
% 0-> Off
% 1-> PT correction on (double sided if 2 tones exist)
% SR01C:BPM2:autotrim:enable
%
% Auto trim control 0->Off, 1->On
%   AutoTrim = 0;
%   for i = 1:length(Prefix)
%       setpvonline(sprintf('%s:autotrim:enable', Prefix{i}), AutoTrim, 'double', NoWaitFlag);
%   end


% Golden orbit in the cell controller
% The waveform record contains 64 LONG data values in units of nanometers.  
% The first array entry is the desired x position of the BPM whose least significant 
% five bits of fast orbit feedback index are equal to 0, the second array entry the 
% desired y position of the that BPM, the third array entry the desired x position of the 
% BPM whose least significant five bits of fast orbit feedback index are equal to 1, and so on.

%getpv('SR01:CC:BPMsetpoints');
%b = dec2bin(getpv('BPM','FOFBNumber',[12 3]), 8);
%bin2dec(b(5:8))

Dev = family2dev('BPM');
setpv('BPM', 'XGoldenSetpoint', getgolden('BPMx',Dev), Dev);
setpv('BPM', 'YGoldenSetpoint', getgolden('BPMy',Dev), Dev);


% % Dev  = family2dev('BPM');
% % Cell = getfamilydata('BPM','Cell');
% % 
% % % Set the golden orbit to the cell controller
% % % The vectors are based on the FOFB index number
% % for s = 1:12
% %     % Find which BPMs are in what cell controller
% %     i = find(s == Cell(:,1));
% %     
% %     % The position in the cell controller waveform is based on the lower 4 binary digits in the FOFB index
% %     FOFBIndex = getpv('BPM','FOFBIndex', Dev(i,:));
% %     b = dec2bin(FOFBIndex, 8);
% %     CellArrayIndex = bin2dec(b(:,5:8));
% %   
% %     for j = 1:32
% %         k = find(j==CellArrayIndex+1);  % check the +1 to handle the zero case
% %         if isempty(k)
% %             x(1,j) = 0;
% %             y(1,j) = 0;
% %         else
% %             % Golden orbit
% %             x(1,j) = getgolden('BPMx',Dev(i(k),:));
% %             y(1,j) = getgolden('BPMy',Dev(i(k),:));
% %         end
% %     end
% %     
% %     GoldenSet = [x;y];
% %     GoldenSet = GoldenSet(:)';    
% %     
% %     % Save the device list per cell controller???
% % 
% %     PV = sprintf('SR%02d:CC:BPMsetpoints', s);
% %     setpvonline(PV, GoldenSet);
% % end


% Set the FOFB list
%getpv('SR01:CC:FOFBlist')




