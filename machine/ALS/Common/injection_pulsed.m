

% TimInjReq Waveform
% 1. Storage ring bucket number (1 to 328)
% 
% 2. Number of gun bunches (1, 2, 3, 4, ... 16)
%     Gun bias waveform (GunBunchToGunBias) - 16 elements which has the desired gun bias setpoint for each number of bunches. 
%     Gun Bias PV:  EG______BIAS___AC01 EG______BIAS___AM01  (16-bit IRM001 DAC1)
%                   It takes about .5 seconds for the Bias to change.
% 
%     Injection field trigger waveform - 16 elements which has the desired injection field trigger setpoint for each number of bunches.
%          GunBunchToInjFieldTrigger
%
% 3. Injection Mode Number:  Setup, Injection, and Tuning Modes
%     0 ->  Default
%    10 ->  Linac and LTB
%    20 ->  Booster
%    30 ->  BTS
%    40 ->  Storage ring injection
%    41 ->  Prepare for a storage ring injection
% 
% 4. Gun Inhibit (override option on the gun trigger enable)
%     0 -> Gun trigger state determined by the mode number (3)
%     1 -> Disable the gun trigger 
% 5. Future use
% 6. Future use
% 7. Sequence NGunBunchToInjFieldTriggerumber

GunBunches  =  1;    % Number of gun bunches (1, 2, 3, 4, ... 16)
Mode        = 40;    % Injection Mode Number:10 SR->40
InhibitFlag =  0;    % Gun Inhibit 0->Gun triggered, 1->No gun trigger

% Fill pattern
if GunBunches == 1
   FillPattern = 308; %1:296;
   % FillPattern = 280:-1:1;
else
    Pass1 = 1:4:(296-12);
    FillPattern = [Pass1 Pass1+1 Pass1+2 Pass1+3];
end

TimeFormat = 'HH:MM:SS.FFF';

% Sync to the start
[Counter, Ts, Err] = synctoevt(10);
t1 = clock;
DCCT    = getpvonline('cmm:beam_current');
DCCTirm = getpvonline('irm:088:ADC3');  % Sector 8 DCCT using IRM

DCCT00 = -0.8153  % DCCT offset
DCCTLimit = 1;    % Stop at

iBucket = 1;
for i = 1:100

    % Storage ring bucket number (1 to 328)
    BucketNumber = FillPattern(iBucket);
    
    t0 = t1;
    Ts0 = Ts;
    DCCT0 = DCCT;
    DCCT0irm = DCCTirm;
    pause(.1);

    TimInjReq = srinjectoneshot(BucketNumber, GunBunches, Mode, InhibitFlag);
    
    
    % Wait for this request to start before making another request
    [Counter, Ts, Err] = synctoevt(10);   % Sync to the start

    t1 = clock;

 %   [Counter, Ts, Err] = synctoevt(68);

    DCCT    = getpvonline('cmm:beam_current');
    DCCTirm = getpvonline('irm:088:ADC3');  % Sector 8 DCCT using IRM

    fprintf('Sync to start:  %s  %s  %.2f  %.2f %d', datestr(Ts, TimeFormat), datestr(now, TimeFormat), 24*60*60*(Ts-Ts0), etime(t1,t0), getpv('LI11:EVR1:Evt10Cnt-I'));
    fprintf('  %6.2f  %6.2f  %6.2f  %6.2f (%.2f) mA\n', DCCTirm-DCCT0irm, DCCT-DCCT0, DCCTirm, DCCT, DCCT - DCCT00);

    % Get the waveforms for the active sequence, then set the next cycle
    pause(.1);
    Evt_RB(GunBunches,:) = getpvonline('LI11:EVG1-SoftSeq:0:EvtCode-RB',   'Waveform');
    Ts_RB(GunBunches,:)  = getpvonline('LI11:EVG1-SoftSeq:0:Timestamp-RB', 'Waveform');
    
    %Evt(1:28)
    %Ts(1:28)
    
    % Increment the bucket number
    iBucket = iBucket + 1;
    if iBucket > length(FillPattern)
        iBucket = 1;
    end
    
    if (DCCT - DCCT00) >= DCCTLimit
        break
    end 
end


%setpv('BPM','ADC_Arm', 1);
%pause(.1);


% To set directly: turn off the Pulse Potentate (TimPotentate)
% setpvonline('LI11:EVG1-SoftSeq:0:EvtCode-SP',  EvtCode_RB);
% setpvonline('LI11:EVG1-SoftSeq:0:Timestamp-SP',  Timestamp_RB);
% commit:  LI11:EVG1-SoftSeq:0:Commit-Cmd
% enable:  LI11:EVG1-SoftSeq:0:Enable-Cmd
% setpvonline('LI11:EVG1-SoftSeq:0:Enable-Cmd',1);


