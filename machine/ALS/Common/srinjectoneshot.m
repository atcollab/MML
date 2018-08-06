function Req = srinjectoneshot(BucketNumber, GunBunches, Mode, InhibitFlag)
% TimInjReq = srinjectoneshot(BucketNumber, GunBunches, Mode, InhibitFlag)
% TimInjReq = srinjectoneshot(InjectionWaveform)
%
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
% 7. Sequence Number (this function will automatically increment)
%
% NOTES
% 1. This function is used for the topoff application
%

% Get the last shot and increment the sequence number
Req = getpv('TimInjReq');
Req(7) = Req(7) + 1;
if Req(7)>20000
    Req(7) = 1;
end


% Inputs
if length(BucketNumber) > 1
    if length(BucketNumber) < 4
        error('For an injection waveform input at least 4 elements are needed.');
    end
    Req(1) = BucketNumber(1);
    Req(2) = BucketNumber(2);
    Req(3) = BucketNumber(3);
    Req(4) = BucketNumber(4);
else  
    Req(1) = BucketNumber;   % Storage ring bucket number (1 to 328)
    Req(2) = GunBunches;     % Number of gun bunches (1, 2, 3, 4, ... 16)
    Req(3) = Mode;           % Injection Mode Number:10 SR->40
    Req(4) = InhibitFlag;    % Gun Inhibit 0->Gun triggered, 1->No gun trigger
end

setpvonline('TimInjReq', Req(:)');





