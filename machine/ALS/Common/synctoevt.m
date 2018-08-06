function [Counter1, Ts, Err] = synctoevt(Evt, TimeOut)

%
Err = 0;

if nargin < 2
    TimeOut = 3;
end

% Example
% LI11:EVR1:Evt70       -> state (Active or )
% LI11:EVR1:Evt70Cnt-I  -> counter (Int)

% Evt Number, PV, CommonName
%   Generated from the GTB MML
%   for i = 1:100;fprintf('%d, ''%s'', ''%s''\n', ao.Trigger.EvtNumber(i), ao.Trigger.EvtCounter.ChannelNames(i,:), ao.Trigger.CommonNames{i});end
a = {
   %10, 'B0215:EVR1:Evt10Cnt-I', 'BR Magnet'
    10, 'LI11:EVR1:Evt10Cnt-I ', 'BR RF'
   %10, 'LI11:EVR1:Evt10Cnt-I ', 'BR RF Tuner Servo Inhibit'
   %10, 'LI11:EVR1:Evt10Cnt-I ', 'BR RF Scope'
   %10, 'LI11:EVR2:Evt10Cnt-I ', 'Peaking Strip (GC)'
    12, 'LI11:EVR1:Evt12Cnt-I ', 'LN Modulator Scope'
    14, 'S0817:EVR1:Evt14Cnt-I', 'GTB CCD'
    15, 'B0215:EVR1:Evt15Cnt-I', 'BR CCD'
    16, 'S0123:EVR1:Evt16Cnt-I', 'User Gate'
    18, 'S0817:EVR1:Evt18Cnt-I', 'BR Injection Field Monitor'
    20, 'LI11:EVR1:Evt20Cnt-I ', 'GTL Buncher Scope'
    22, 'LI11:EVR1:Evt22Cnt-I ', 'Wall Current Monitor'
    24, 'LI11:EVR2:Evt24Cnt-I ', 'Linac RF Master'
    26, 'LI11:EVR2:Evt26Cnt-I ', 'BR Injection Field (GC)'
    28, 'LI11:EVR2:Evt28Cnt-I ', 'Gun Gate Monitor'
   %30, 'S0817:EVR1:Evt30Cnt-I', 'BR Injection Kicker Scope'
    30, 'S0817:EVR1:Evt30Cnt-I', 'BR Injection Kicker'
    32, 'B0215:EVR1:Evt32Cnt-I', 'LTB ICT Scope'
    34, 'B0215:EVR1:Evt34Cnt-I', 'BR ICT Scope'
    36, 'LI11:EVR1:Evt36Cnt-I ', 'Gun On'
    37, 'LI11:EVR1:Evt37Cnt-I ', 'Gun Off'
    38, 'LI11:EVR2:Evt38Cnt-I ', 'BR Extraction Field (GC)'
    40, 'B0215:EVR1:Evt40Cnt-I', 'BR Bump'
    42, 'B0215:EVR1:Evt42Cnt-I', 'BTS CCD'
    44, 'B0215:EVR1:Evt44Cnt-I', 'BTS ICT Scope'
    46, 'B0215:EVR1:Evt46Cnt-I', 'BR Bump Scope'
    48, 'B0215:EVR1:Evt48Cnt-I', 'BR Extraction Kicker Scope'
   %48, 'B0215:EVR1:Evt48Cnt-I', 'BR Extraction Kicker'
    50, 'B0215:EVR1:Evt50Cnt-I', 'BR Extraction Field Monitor'
   %52, 'B0215:EVR1:Evt52Cnt-I', 'BR Septa Scope'
    52, 'LI11:EVR1:Evt52Cnt-I ', 'BR Thin Septum'
    54, 'LI11:EVR1:Evt54Cnt-I ', 'BR Thick Septum'
    56, 'LI11:EVR2:Evt56Cnt-I ', 'Target Bucket Monitor'
    58, 'S0123:EVR1:Evt58Cnt-I', 'SR Bump Scope'
    60, 'S0123:EVR1:Evt60Cnt-I', 'SR Bump'
    62, 'S0123:EVR1:Evt62Cnt-I', 'SR Septa Scope'
    64, 'S0123:EVR1:Evt64Cnt-I', 'SR Thin Septum'
    66, 'S0123:EVR1:Evt66Cnt-I', 'SR Thick Septum'
    68, 'LI11:EVR1:Evt68Cnt-I',  'SR Post Injection'
    70, 'LI11:EVR1:Evt70Cnt-I',  'SR Post Injection, Continuous'
   100, 'LI11:EVR2:Evt100Cnt-I', 'PS Ready'
    };

EvtAll = cell2mat(a(:,1)); 

i = findrowindex(Evt, EvtAll);

if isempty(i)
    Err = -1;
    error('Input event number not found the event list in synctoevt.m');
end

PV = a{i,2};

t0 = clock;
IncrementFlag = 0; 
[Counter0, ~, Ts] = getpvonline(PV);
while ~IncrementFlag
    pause(.05);
    [Counter1, ~, Ts] = getpvonline(PV);
    
    if Counter1 ~= Counter0
        IncrementFlag = 1; 
    elseif etime(clock,t0) > TimeOut
        IncrementFlag = 1; 
        Err = -1;
        %error('Timeout reached before sync was acheived (synctoevt).');
    end
end

if nargout >= 2
    Ts = labca2datenum(Ts);
end






