function bpm_equalization(varargin)
%BPM_EQUALIZATION - This function equalizes the pilot power
% bpm_equalization(RFMag, PTMag, DevList)

% To make this function more robust
% * Monitor for beam loss then setting attenuators
%

% * Do RFMag first, BPMs can't be saturated at the start
% * BPM[5 2] postmortum and BPM[5 8] tunes, so don't set PT during user ops


BPMFamily = 'BPM';
AttnMax = 16;     % 500 mA is about 13 
PTAttnMax = 6;   % Typically close to zero

% Drive level for PTA & PTB
% 0 -> Off
% 1 -> CMOS
% 2 -> 960 mV
% 3 -> 780 mV
% 4 -> 600 mV
% 5 -> 400 mV
DriveLevelDefault = 1;


% Get inputs (sort out the flags first)
if length(varargin) >= 1
    RFMag = varargin{1};
    varargin(1) = [];
else
    RFMag = 5.0e6;
end
if length(varargin) >= 1
    PTMag = varargin{1};
    varargin(1) = [];
else
    PTMag = 2.4e6;
end
if length(varargin) >= 1
    DevList = varargin{1};
    varargin(1) = [];
else
   %BPMFamily = 'BPM';
   %DevList = [1 5];  %family2dev('BPMTest');
    DevList = family2dev('BPM');
end

Sectors = unique(DevList(:,1));


% First turn the PT compensation off
% 3 -> Dual PT
% 2 -> PT High
% 1 -> PT Low
% 0 -> Off
setpv(BPMFamily, 'PTControl', 0, DevList);
%setpv(BPMFamily, 'PTControl', 3, DevList); % Dual sided frequnecies
pause(.5);


% Main pilot tone controls
% 0 -> Off
% 1 -> -.5 Rev Harmonic from RF ("Low")
% 2 -> On RF
% 3 -> +.5 Rev Harmonic from RF ("High")
%
% Lo & Hi PT - note this could affect other BPMs in the sector besides what is in the device list
NoWaitFlag = 1;
for s = Sectors(:)'
    % Tone PLL controls
    setpvonline(sprintf('SR%02d:CC:ptA:Frequency', s), 1, 'double', NoWaitFlag);
    setpvonline(sprintf('SR%02d:CC:ptB:Frequency', s), 3, 'double', NoWaitFlag);
end

% Zero the compensation  ???
Prefix = getfamilydata(BPMFamily, 'BaseName', DevList);
%setpvonline([Prefix,':ADC0:gainTrim'], 1); 
%setpvonline([Prefix,':ADC1:gainTrim'], 1); 
%setpvonline([Prefix,':ADC2:gainTrim'], 1); 
%setpvonline([Prefix,':ADC3:gainTrim'], 1); 
%bpm_setenv(Prefix, AttnMax, 0, 0);


% Set the drive off and max PT attn
DriveLevel = 0;
setpv(BPMFamily, 'PTA', DriveLevel, DevList);
setpv(BPMFamily, 'PTB', DriveLevel, DevList);

% PT Attn max ("off")
setpv(BPMFamily, 'PTAttn', AttnMax, DevList(:,1:2));

% Search the Attn for the right RF Mag
for i = 1:size(DevList, 1)
    Attn = AttnMax;
    Dev = DevList(i,:);
    setpv(BPMFamily, 'Attn', Attn, Dev);
    pause(.2);
    a = getrfmag(BPMFamily, Dev);
    
    while all(a < RFMag) && Attn > 1
        Attn = Attn - 1;
        setpv(BPMFamily, 'Attn', Attn, Dev);
        pause(.2);
        a = getrfmag(BPMFamily, Dev);
    end
end


% Next, turn the PT On and search on PT Attn
% Set the drive level
setpv(BPMFamily, 'PTA', DriveLevelDefault, DevList);
setpv(BPMFamily, 'PTB', DriveLevelDefault, DevList);


% Search the Attn for the right RF Mag
for i = 1:size(DevList, 1)
    Attn = PTAttnMax;
    Dev = DevList(i,:);
    setpv(BPMFamily, 'PTAttn', Attn, Dev);
    pause(.2);
    a = getptmag(BPMFamily, Dev);
    
    while all(a < PTMag) && Attn >= 1
        Attn = Attn - 1;
        setpv(BPMFamily, 'PTAttn', Attn, Dev);
        pause(.2);
        a = getptmag(BPMFamily, Dev);
    end   
end



% Turn BPM Auto Trim on
% 3 -> Dual PT
setpv(BPMFamily, 'PTControl', 3, DevList);



function a = getrfmag(BPMFamily, Dev)

a = [
    getpv(BPMFamily, 'A', Dev);
    getpv(BPMFamily, 'B', Dev);
    getpv(BPMFamily, 'C', Dev);
    getpv(BPMFamily, 'D', Dev);
];

function a = getptmag(BPMFamily, Dev)

a = [
    getpv(BPMFamily, 'PTLoA', Dev);
    getpv(BPMFamily, 'PTHiA', Dev);
    getpv(BPMFamily, 'PTLoB', Dev); 
    getpv(BPMFamily, 'PTHiB', Dev);
    getpv(BPMFamily, 'PTLoC', Dev); 
    getpv(BPMFamily, 'PTHiC', Dev);
    getpv(BPMFamily, 'PTLoD', Dev); 
    getpv(BPMFamily, 'PTHiD', Dev);
];


        
        
    
