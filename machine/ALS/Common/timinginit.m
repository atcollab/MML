function timinginit(Action)
%TIMINGINIT - This function initializes the new MRF timing output for SROC generation

if nargin < 1 || isempty(Action)
    Action = 'Check';
    %Action = 'Set';
end

fprintf('This function (timinginit) is not up-to-date so it''s just returning with no action.\n');
return


% Old Potentate              New Potentate
% GTL_____TIMING_BC01 -> TimPotentate
% GTL_____TIMING_BM01 -> LI11:EVG1-SoftSeq:0:Enable-RB
% setpv('TimPotentate',0)
% setpv('LI11:EVG1-SoftSeq:0:Enable-Cmd', 1);  % Get over written by TimPotentate
% setpv('LI11:EVG1-SoftSeq:0:Disable-Cmd',1);  % Get over written by TimPotentate

%setpvonline('', );

if strcmpi(Action, 'Set')
        % Should happen on crate reboots or autosave/restore
        
%     % Set the waveforms to change the gun bias w.r.t the number of gun bunches (absolute)
%     GunBiasWF = getpvonline('GunBunchToGunBias');
%     GunBiasWF = 0*GunBiasWF + 36;  % Set the whole vector to 36
%     GunBiasWF(1) = 23.7;  % ???
%    %GunBiasWF(2) = 23.7;  % ???
%    %GunBiasWF(3) = 23.7;  % ???
%     setpvonline('GunBunchToGunBias', GunBiasWF);
%     
%     % Set the waveforms to change the injection field trigger w.r.t the number of gun bunches (delta change)
%     % Delta in 8 ns ticks
%     InjFieldTriggerWF = getpvonline('GunBunchToInjFieldTrigger');
%     InjFieldTriggerWF(1) = 44 * 125;  % Conversion from 30 Gauss clock ticks to MRF ticks is 42?
%     InjFieldTriggerWF(2) = 30 * 125;  % ???
%     InjFieldTriggerWF(3) = 15 * 125;  % ???
%     InjFieldTriggerWF(4) =  0 * 125;  % ???
%     setpvonline('GunBunchToInjFieldTrigger', InjFieldTriggerWF);
    

    % Field trigger
%     setpvonline('TimInjFieldEventDelay',   9926);
%     setpvonline('TimExtrFieldEventDelay',  8100);
%     %setpvonline('TimTargetBucketDelay',     656);  % Bucket group delay -> set by bucket loading etc.
%     setpvonline('TimInjFieldSyncDelaySP', 14769);   % was 14703 14723 14763 Injection field trigger (changes often)
%     setpvonline('TimExtrFieldSyncDelaySP', 5875);   % was 5881 Extraction field trigger

    return
    
    % Reset need when the 125MHz RF Clock input to the Timing System is interrupted,
    % resynchronization is required to restore Target Bucket alignment. One method,
    % is to reset the EVG counters. The counter reset PV is normally disabled to prevent
    % accidental resets, so it must be enabled before resetting and then disabled again.
    setpv('LI11:EVG1:ResetMxc-Cmd.DISA', 1); pause(.25);
    setpv('LI11:EVG1:ResetMxc-Cmd',      1); pause(.25);
    setpv('LI11:EVG1:ResetMxc-Cmd.DISA', 0);

    
    
    % Set the trigger width
    %  Step size = 1 microsecond step size
    
    setpv('LI11:EVR1-DlyGen:0:Width-SP', 0.0480);  % Gun On
    setpv('LI11:EVR1-DlyGen:1:Width-SP', 0.0480);  % Gun Off
    
    setpvonline('S0817:EVR1-DlyGen:3:Width-SP', 200);  % CCD GTB
    setpvonline('B0215:EVR1-DlyGen:4:Width-SP', 200);  % CCD BR
    setpvonline('B0215:EVR1-DlyGen:5:Width-SP', 200);  % CCD BTS
    
    
    %  Set the trigger delays
    %   Stepsize = Prescaler * 8nx
    
    % Tuned the gun delay for good KI timing to booster
    %  setpvonline('LI11:EVR1-DlyGen:0:Delay-SP', 37388);  % Gun on
    %  setpvonline('LI11:EVR1-DlyGen:1:Delay-SP', 37387);  % Gun off
    
    % One edge
    %setpvonline('LI11:EVR1-DlyGen:0:Delay-SP', 37408);  % Gun on
    %setpvonline('LI11:EVR1-DlyGen:1etpvonline('LI11:EVR1-DlyGen:0:Delay-SP':Delay-SP', 37407);  % Gun off
    
    % Other edge
    %setpvonline('LI11:EVR1-DlyGen:0:Delay-SP', 37397);  % Gun on
    %setpvonline('LI11:EVR1-DlyGen:1:Delay-SP', 37396);  % Gun off
    
    % Good
    %setpvonline('LI11:EVR1-DlyGen:0:Delay-SP', 37403);  % Gun on
    %setpvonline('LI11:EVR1-DlyGen:1:Delay-SP', 37402);  % Gun off
    
    % Moved one back to match the SR bucket numbering
    %setpvonline('LI11:EVR1-DlyGen:0:Delay-SP',  37319);  % Gun on
    %setpvonline('LI11:EVR1-DlyGen:1:Delay-SP',  37319);  % Gun off
    
    % Moved back one tick to hit bucket 1 in the SR (2017-08-28)
    setpvonline('LI11:EVR1-DlyGen:0:Delay-SP',  37318);  % Gun on
    setpvonline('LI11:EVR1-DlyGen:1:Delay-SP',  37318);  % Gun off
    
    % KI - Booster injection kicker
    setpvonline('S0817:EVR1-DlyGen:2:Delay-SP', 37223); % KI scope delay
    setpvonline('S0817:EVR1-DlyGen:0:Delay-SP', 37223); % KI delay
    
    % RF Master
    setpv('LI11:EVR2-DlyGen:0:Delay-SP', 35170);
    
    % BR KE
    % oddly 26010 got the beam into the BTS
    %setpvonline('B0215:EVR1-DlyGen:1:Delay-SP', 21350 - 30);  % 2016-12-11 less a delay change since then
    setpvonline('B0215:EVR1-DlyGen:1:Delay-SP',  25860);  % 2017-08-28
    setpvonline('B0215:EVR1-DlyGen:10:Delay-SP', 25860);  % 2017-08-28 -> Scope
    
    % BR Bumps???
    setpvonline('B0215:EVR1-DlyGen:0:Delay-SP', 10000);   % 2017-08-28
    setpvonline('B0215:EVR1-DlyGen:9:Delay-SP', 10000);   % 2017-08-28 -> Scope
    
    % BR SEN (thin) Septum
    setpvonline('LI11:EVR1-DlyGen:2:Delay-SP',  24107);   % 2017-08-28
    
    % BR SEK (thick) Septum
    setpvonline('LI11:EVR1-DlyGen:3:Delay-SP',   18453);   % 2017-08-28
    setpvonline('B0215:EVR1-DlyGen:11:Delay-SP', 18000);   % 2017-08-28 -> Scope for both SEN and SEK
    
    % SR Bumps
    %setpvonline(S0123:EVR1-DlyGen:0:Delay-SP', 20867);   % 2016-12-11
    setpvonline('S0123:EVR1-DlyGen:0:Delay-SP', 25387);   % 2017-08-28
    setpvonline('S0123:EVR1-DlyGen:3:Delay-SP', 25387);   % 2017-08-28 -> Scope
    
    % SR SEN (thin) Septum
    setpvonline('S0123:EVR1-DlyGen:1:Delay-SP', 24350);   % 2017-08-28
    
    % SR SEK (thick) Septum
    setpvonline('S0123:EVR1-DlyGen:2:Delay-SP', 18430-500);   % 2017-08-28
    setpvonline('S0123:EVR1-DlyGen:4:Delay-SP', 18430-500);   % 2017-08-28 -> Scope for both SEN and SEK
    
    % CCD
    setpvonline('S0817:EVR1-DlyGen:3:Delay-SP', 0);  % CCD GTB
    setpvonline('B0215:EVR1-DlyGen:4:Delay-SP', 0);  % CCD BR
    setpvonline('B0215:EVR1-DlyGen:5:Delay-SP', 0);  % CCD BTS    ->  Need to EPICS setup
    
    
    
    
    
    %fprintf('   Setting TimRFMasterDelay to 25160\n');
    %setpvonline('TimRFMasterDelay', 25160);
    
    
    fprintf('   Setting the timing system output on LI11  FP6 for SIOC\n');
    
    % LI11
    PV = 'LI11:EVR1-Out:FP6:Mode-Sel';
    setpvonline(PV, 1);
    
    PV = 'LI11:EVR1-Out:FP6:Freq:High-SP';
    setpvonline(PV, 820);
    
    PV = 'LI11:EVR1-Out:FP6:Freq:Low-SP';
    setpvonline(PV, 820);
    
    PV = 'LI11:EVR1-Out:FP6:Freq:Lvl-SP';
    setpvonline(PV, 0);
    
    PV = 'LI11:EVR1-Out:FP6:Ena-Sel';
    setpvonline(PV, 1);
    
    PV = 'LI11:EVR1-Out:FP6:Pwr-Sel';
    setpvonline(PV, 1);
    
    PV = 'LI11:EVR1-Out:FP6:Freq:Init-SP';
    setpvonline(PV, 0);
    
    PV = 'LI11:EVR1-Out:FP6:Src:DBus-SP';
    setpvonline(PV, 7);
    
    % S0123
    fprintf('   Setting the timing system output on S0123 FP6 for SIOC\n');
    
    PV = 'S0123:EVR1-Out:FP6:Mode-Sel';
    setpvonline(PV, 1);
    
    PV = 'S0123:EVR1-Out:FP6:Freq:High-SP';
    setpvonline(PV, 820);
    
    PV = 'S0123:EVR1-Out:FP6:Freq:Low-SP';
    setpvonline(PV, 820);
    
    PV = 'S0123:EVR1-Out:FP6:Freq:Lvl-SP';
    setpvonline(PV, 0);
    
    PV = 'S0123:EVR1-Out:FP6:Ena-Sel';
    setpvonline(PV, 1);
    
    PV = 'S0123:EVR1-Out:FP6:Pwr-Sel';
    setpvonline(PV, 1);
    
    PV = 'S0123:EVR1-Out:FP6:Freq:Init-SP';
    setpvonline(PV, 0);
    
    PV = 'S0123:EVR1-Out:FP6:Src:DBus-SP';
    setpvonline(PV, 7);
    
    
    % LI11 - EVR2 -: User timing
    fprintf('   Setting the timing system output on LI11 EVR2 FP6 for SIOC\n');
    
    PV = 'LI11:EVR2-Out:FP6:Mode-Sel';
    setpvonline(PV, 1);
    
    PV = 'LI11:EVR2-Out:FP6:Freq:High-SP';
    setpvonline(PV, 820);
    
    PV = 'LI11:EVR2-Out:FP6:Freq:Low-SP';
    setpvonline(PV, 820);
    
    PV = 'LI11:EVR2-Out:FP6:Freq:Lvl-SP';
    setpvonline(PV, 0);
    
    PV = 'LI11:EVR2-Out:FP6:Ena-Sel';
    setpvonline(PV, 1);
    
    PV = 'LI11:EVR2-Out:FP6:Pwr-Sel';
    setpvonline(PV, 1);
    
    PV = 'LI11:EVR2-Out:FP6:Freq:Init-SP';
    setpvonline(PV, 0);
    
    PV = 'LI11:EVR2-Out:FP6:Src:DBus-SP';
    setpvonline(PV, 7);
    
    
elseif strcmpi(Action, 'Check')
    
    % apps4.als% caget "LI11:EVR1-Out:FP6:Mode-Sel"
    % Old : LI11:EVR1-Out:FP6:Mode-Sel     4x Pattern
    % New : LI11:EVR1-Out:FP6:Mode-Sel     Frequency
    PV = 'LI11:EVR1-Out:FP6:Mode-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR1-Out:FP6:Freq:High-SP" "820"
    % Old : LI11:EVR1-Out:FP6:Freq:High-SP 40
    % New : LI11:EVR1-Out:FP6:Freq:High-SP 820
    PV = 'LI11:EVR1-Out:FP6:Freq:High-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR1-Out:FP6:Freq:Low-SP" "820"
    % Old : LI11:EVR1-Out:FP6:Freq:Low-SP  40
    % New : LI11:EVR1-Out:FP6:Freq:Low-SP  820
    PV = 'LI11:EVR1-Out:FP6:Freq:Low-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR1-Out:FP6:Freq:Lvl-SP" "0"
    % Old : LI11:EVR1-Out:FP6:Freq:Lvl-SP  Active high or 0
    % New : LI11:EVR1-Out:FP6:Freq:Lvl-SP  Active high or 0
    PV = 'LI11:EVR1-Out:FP6:Freq:Lvl-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR1-Out:FP6:Ena-Sel" "1"
    % Old : LI11:EVR1-Out:FP6:Ena-Sel      Disabled
    % New : LI11:EVR1-Out:FP6:Ena-Sel      Enabled
    PV = 'LI11:EVR1-Out:FP6:Ena-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR1-Out:FP6:Pwr-Sel" "On"
    % Old : LI11:EVR1-Out:FP6:Pwr-Sel      Off
    % New : LI11:EVR1-Out:FP6:Pwr-Sel      On
    PV = 'LI11:EVR1-Out:FP6:Pwr-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR1-Out:FP6:Freq:Init-SP" "0"
    % Old : LI11:EVR1-Out:FP6:Freq:Init-SP 0
    % New : LI11:EVR1-Out:FP6:Freq:Init-SP 0
    PV = 'LI11:EVR1-Out:FP6:Freq:Init-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR1-Out:FP6:Src:DBus-SP" "7"
    % Old : LI11:EVR1-Out:FP6:Src:DBus-SP  DBus 0
    % New : LI11:EVR1-Out:FP6:Src:DBus-SP  DBus 7
    PV = 'LI11:EVR1-Out:FP6:Src:DBus-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));

    fprintf('\n');

    % apps4.als% caget "S0123:EVR1-Out:FP6:Mode-Sel"
    % Old : S0123:EVR1-Out:FP6:Mode-Sel     4x Pattern
    % New : S0123:EVR1-Out:FP6:Mode-Sel     Frequency
    PV = 'S0123:EVR1-Out:FP6:Mode-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "S0123:EVR1-Out:FP6:Freq:High-SP" "820"
    % Old : S0123:EVR1-Out:FP6:Freq:High-SP 40
    % New : S0123:EVR1-Out:FP6:Freq:High-SP 820
    PV = 'S0123:EVR1-Out:FP6:Freq:High-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "S0123:EVR1-Out:FP6:Freq:Low-SP" "820"
    % Old : S0123:EVR1-Out:FP6:Freq:Low-SP  40
    % New : S0123:EVR1-Out:FP6:Freq:Low-SP  820
    PV = 'S0123:EVR1-Out:FP6:Freq:Low-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "S0123:EVR1-Out:FP6:Freq:Lvl-SP" "0"
    % Old : S0123:EVR1-Out:FP6:Freq:Lvl-SP  Active high
    % New : S0123:EVR1-Out:FP6:Freq:Lvl-SP  Active high
    PV = 'S0123:EVR1-Out:FP6:Freq:Lvl-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "S0123:EVR1-Out:FP6:Ena-Sel" "1"
    % Old : S0123:EVR1-Out:FP6:Ena-Sel      Disabled
    % New : S0123:EVR1-Out:FP6:Ena-Sel      Enabled
    PV = 'S0123:EVR1-Out:FP6:Ena-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "S0123:EVR1-Out:FP6:Pwr-Sel" "On"
    % Old : S0123:EVR1-Out:FP6:Pwr-Sel      Off
    % New : S0123:EVR1-Out:FP6:Pwr-Sel      On
    PV = 'S0123:EVR1-Out:FP6:Pwr-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "S0123:EVR1-Out:FP6:Freq:Init-SP" "0"
    % Old : S0123:EVR1-Out:FP6:Freq:Init-SP 0
    % New : S0123:EVR1-Out:FP6:Freq:Init-SP 0
    PV = 'S0123:EVR1-Out:FP6:Freq:Init-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "S0123:EVR1-Out:FP6:Src:DBus-SP" "7"
    % Old : S0123:EVR1-Out:FP6:Src:DBus-SP  DBus 0
    % New : S0123:EVR1-Out:FP6:Src:DBus-SP  DBus 7
    PV = 'S0123:EVR1-Out:FP6:Src:DBus-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));

    fprintf('\n');

    % apps4.als% caget "LI11:EVR2-Out:FP6:Mode-Sel"
    % Old : LI11:EVR2-Out:FP6:Mode-Sel     4x Pattern
    % New : LI11:EVR2-Out:FP6:Mode-Sel     Frequency
    PV = 'LI11:EVR2-Out:FP6:Mode-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR2-Out:FP6:Freq:High-SP" "820"
    % Old : LI11:EVR2-Out:FP6:Freq:High-SP 40
    % New : LI11:EVR2-Out:FP6:Freq:High-SP 820
    PV = 'LI11:EVR2-Out:FP6:Freq:High-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR2-Out:FP6:Freq:Low-SP" "820"
    % Old : LI11:EVR2-Out:FP6:Freq:Low-SP  40
    % New : LI11:EVR2-Out:FP6:Freq:Low-SP  820
    PV = 'LI11:EVR2-Out:FP6:Freq:Low-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR2-Out:FP6:Freq:Lvl-SP" "0"
    % Old : LI11:EVR2-Out:FP6:Freq:Lvl-SP  Active high
    % New : LI11:EVR2-Out:FP6:Freq:Lvl-SP  Active high
    PV = 'LI11:EVR2-Out:FP6:Freq:Lvl-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR2-Out:FP6:Ena-Sel" "1"
    % Old : LI11:EVR2-Out:FP6:Ena-Sel      Disabled
    % New : LI11:EVR2-Out:FP6:Ena-Sel      Enabled
    PV = 'LI11:EVR2-Out:FP6:Ena-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR2-Out:FP6:Pwr-Sel" "On"
    % Old : LI11:EVR2-Out:FP6:Pwr-Sel      Off
    % New : LI11:EVR2-Out:FP6:Pwr-Sel      On
    PV = 'LI11:EVR2-Out:FP6:Pwr-Sel';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR2-Out:FP6:Freq:Init-SP" "0"
    % Old : LI11:EVR2-Out:FP6:Freq:Init-SP 0
    % New : LI11:EVR2-Out:FP6:Freq:Init-SP 0
    PV = 'LI11:EVR2-Out:FP6:Freq:Init-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
    
    % apps4.als% caput "LI11:EVR2-Out:FP6:Src:DBus-SP" "7"
    % Old : LI11:EVR2-Out:FP6:Src:DBus-SP  DBus 0
    % New : LI11:EVR2-Out:FP6:Src:DBus-SP  DBus 7
    PV = 'LI11:EVR2-Out:FP6:Src:DBus-SP';
    fprintf('   %s  %s   %d\n', PV, getpvonline(PV, 'char'), getpvonline(PV, 'double'));
end
