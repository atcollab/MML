function [DCCT, t, BCM] = srinject
%clear

%SRINJECT - Injection with manual implementation of the bucket loading table

% PV_TimSeq = [
%     'LI11<EVR1>EvtACnt-I';
%     'LI11<EVR1>EvtBCnt-I';
%     'LI11<EVR1>EvtCCnt-I';
%     'LI11<EVR1>EvtDCnt-I';
%     'LI11<EVR1>EvtECnt-I';];
% 
% for i =1:30;[a,t,ts]=getpv(PV_TimSeq); t=datestr(ts,'SS.FFF'); fprintf('%s  %s  %s  %s  %s\n',t(1,:), t(2,:), t(3,:), t(4,:), t(5,:)); pause(.05); end
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  09.718
% 09.766  09.780  10.232  10.267  11.117
% 11.166  11.180  10.232  10.267  11.117
% 11.166  11.180  10.232  10.267  11.117
% 11.166  11.180  10.232  10.267  11.117
% 11.166  11.180  10.232  10.267  11.117
% 11.166  11.180  10.232  10.267  11.117
% 11.166  11.180  10.232  10.267  11.117
% 11.166  11.180  10.232  10.267  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  11.117
% 11.166  11.180  11.631  11.666  12.517


PV_TimSeq_Start    = 'LI11<EVR1>EvtACnt-I';
PV_TimSeq_PreInj   = 'LI11<EVR1>EvtBCnt-I';
PV_TimSeq_PreExtr  = 'LI11<EVR1>EvtCCnt-I';
PV_TimSeq_PostExtr = 'LI11<EVR1>EvtDCnt-I';
PV_TimSeq_End      = 'LI11<EVR1>EvtECnt-I';


DisplayFlag = 1;

FillMode = 'Test';
%FillMode = 'Multibunch, Single Cam';
%FillMode = 'Multibunch, Dual Cam';
%FillMode = 'Two Bunch';
%FillMode = 'Kicker Test';


DCCT_ChannelName = {'Cam1_current','Cam2_current'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the Fill Pattern %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Topoff parameters channel names
% Topoff_goal_current_SP        [17 500] Default 500 mA,  2-Bunch [17 40] Default 35
% Topoff_cam_goal_current_SP       [1 6] Default   6 mA
% Topoff_cam_inj_field_delta_SP   [5 50] Default 35 seconds between triggers


% Current levels
GoalCurrent = 100;  %getpv('Topoff_goal_current_SP');

% Cam bucket goal current [mA]
GoalCurrent_Cam = 5;  %getpv('Topoff_cam_goal_current_SP');


switch FillMode
    case 'Test'
        Cam_Buckets = [308];
        Fill_Pattern = [1:280];
        GunWidth = 12;    % 1 gun bunch

    case 'Multibunch, Single Cam'
        % Single cam bucket
        % 272 bunch, 4 gun bunches, MB fill pattern, one cam bucket
        Cam_Buckets = 318;
        
        Fill_Pattern = [ ...
            9:16:(272-12) 10:16:(272-12) 11:16:(272-12) 12:16:(272-12) ...
            1:16:(272-12) 2:16:(272-12) 3:16:(272-12) 4:16:(272-12)];
        
        %Fill_Pattern = [ ...
        %    1:16:(272-12) 2:16:(272-12) 3:16:(272-12) 4:16:(272-12) ...
        %    9:16:(272-12) 10:16:(272-12) 11:16:(272-12) 12:16:(272-12)];

        % Fill_Pattern = [1:16:(272-12) 2:16:(272-12) 3:16:(272-12) 4:16:(272-12)];

        GunWidth = 36;    % 4 gun bunches (8 ns between gun bunches)

    case 'Multibunch, Dual Cam'
        % Dual cam buckets
        Cam_Buckets = [150 318];

        Fill_Pattern = [ ...
            9:16:(128-12) 167:16:(302-12) 10:16:(128-12) 168:16:(302-12) 11:16:(128-12) 169:16:(302-12) 12:16:(128-12) 170:16:(302-12) ...
            1:16:(128-12) 159:16:(302-12) 2:16:(128-12) 160:16:(302-12) 3:16:(128-12) 161:16:(302-12) 4:16:(128-12) 162:16:(302-12) ...
            ];

        GunWidth = 36;    % 4 gun bunches (8 ns between gun bunches)

    case 'Two Bunch'
        % Two-bunch
        Cam_Buckets = [154 318];
        Fill_Pattern = [];
        GunWidth = 12;    % 1 gun bunch

    case 'Kicker Test'
        % Use this for camshaft kicker user test
        % 272 bunches, 4 gun bunches, MB fill pattern, One cam bucket
        Cam_Buckets = 318;

        % +15 is needed since the cambucket is not in the center of the gap
        Fill_Pattern = [ ...
            9:16:(272-12) 10:16:(272-12) 11:16:(272-12) 12:16:(272-12) ...
            1:16:(272-12) 2:16:(272-12) 3:16:(272-12) 4:16:(272-12)];
        Fill_Pattern = Fill_Pattern + 15;

        GunWidth = 36;    % 4 gun bunches (8 ns between gun bunches)

    otherwise
        error('Not sure what fill pattern to use.');
end


if DisplayFlag && ~isempty(Fill_Pattern)
    if GunWidth == 36
        Fill_Pattern_Plot = [Fill_Pattern Fill_Pattern+4 Fill_Pattern+8 Fill_Pattern+12];
    else
        Fill_Pattern_Plot = Fill_Pattern;
    end
    Fill_Pattern_Plot = sort(Fill_Pattern_Plot);

    FillLine = zeros(1,328);
    FillLine(Fill_Pattern_Plot) = 1;
    FillLine(Cam_Buckets) = 1;

    clf reset
    plot(Fill_Pattern_Plot, 1, '.b');
    hold on
    plot(1:328, FillLine, 'b');
    plot(Cam_Buckets, 1, '.b');
    plot(Fill_Pattern, 1, 'or', 'MarkerSize', 6);
    hold off
    axis([.6 328.4 -.05 1.05]);
end



% Check and possibly set the gun bias
% GunBias = getpv('EG______BIAS___AC01');
% GunBias = 40;
% if GunBias > 50
%     setpv('EG______BIAS___AC01', 50);
% end
% GunBias = getpv('EG______BIAS___AC01');


% This is actually not used???
% StartInjTrig = getpv('BR1_____TIMING_AM00');
% if abs(StartInjTrig-5000) > 500
%     StartInjTrig = 5000;
% end

%InjectionFieldTrigger = 5026; % 4 bunches

%getpv('GaussClockInjectionFieldTrigger');
%fprintf('%.4f\n',getpv('GaussClockInjectionFieldTrigger'))
%1846363.8015


%start_rf_gain=getpv('BR4_____XMIT___GNAC01');


% Disabling injection triggers and booster beam
%Disable_Triggers;


% Switching bucket loading from table mode to direct bucket control
setpv('SR01C___TIMING_AC11', 0);
setpv('SR01C___TIMING_AC13', 0);


% Set the gun width
% (Not sure why it gets set to GunWidth+1 first?)
setpv('GTL_____TIMING_AC02', GunWidth+1);
pause(2);
setpv('GTL_____TIMING_AC02', GunWidth);
fprintf('   Set gun width to %d ns\n', GunWidth);



%%%%%%%%%%%%%%%%%%%
% Start Fill Loop %
%%%%%%%%%%%%%%%%%%%


% Loop on the main fill pattern
if ~isempty(Fill_Pattern)
    
    % Set the first target bucket
    setpv('SR01C___TIMING_AC08', Fill_Pattern(1));
    fprintf('   Targeting bucket %d, gun width = %d\n', getpv('SR01C___TIMING_AM08'), getpv('GTL_____TIMING_AC02'));
    

    % I'm not sure what this is for, or what the default should be ???
    % Is it just be cambuckets???
    %InjTrigDelta = getpv('Topoff_cam_inj_field_delta_SP');
    %if isnan(InjTrigDelta) || (InjTrigDelta>50) || (InjTrigDelta<5)
    %    InjTrigDelta = 35;
    %end
    %setpv('BR1_____TIMING_AC00', getpv('BR1_____TIMING_AM00')+InjTrigDelta);
    
    % May want to change the scan rate of 'BTS_____ICT01__AM00' & 'BTS_____ICT02__AM01'
     
     
    %%%%%%%%%%%%%%%%%%%
    % Start Fill Loop %
    %%%%%%%%%%%%%%%%%%%
    t0 = clock;
    t_last = t0;

    for i = 1:length(Fill_Pattern)*100
        %try
            %StartCurr = getpv(DCCT_ChannelName{i});
            StartCurr = getdcct;
            
            % Sync to post extraction
            tmp = getpvonline(PV_TimSeq_PostExtr);
            while(getpvonline(PV_TimSeq_PostExtr) <= tmp)
            end
            [Extr(i,:), ~, ExtrTs(i,:)]= getpvonline(PV_TimSeq_PostExtr);
            %tmp = Extr(i)
            
            % Set the target bucket
            %LastBucket = getpv('SR01C___TIMING_AM08');
            iBucket = mod(i-1, length(Fill_Pattern))+1;
            setpvonline('SR01C___TIMING_AC08', Fill_Pattern(iBucket));
            
            if i == 1
                % Pull all paddles (if not already open)
                tic
                LTBTV_LastPosition = PullLTBPaddles;    % Often it's just TV6 that is in
                BRTV_LastPosition  = PullBoosterPaddles;
                BTSTV_LastPosition = PullBTSPaddles;
                
                
                % Enable all triggers
                Enable_Triggers;
                toc

                % Measure stuff after injection
                % about .3 sec extra
                pause(0.5-toc);  % ???  .9 seconds until the start of the next cycle
            else
                % Measure stuff after injection
                pause(0.5);  % ???  .9 seconds until the start of the next cycle
            end
            
            %fprintf('   Targeting bucket %d, gun width = %d\n', getpv('SR01C___TIMING_AM08'), getpv('GTL_____TIMING_AC02'));

            
            BTSCharge1(i,1) = getam('BTS_____ICT01__AM00');
            BTSCharge2(i,1) = getam('BTS_____ICT02__AM01');
            BTSCharge = max([BTSCharge1(i) BTSCharge2(i)]);
            DCCT(i,1) = getdcct;
            BCM(i,:)  = getbcm;

            Bucket(i,1) = Fill_Pattern(iBucket);
            BucketMonitor(i,1) = getpv('SR01C___TIMING_AM08');
           
            eff = (DCCT(i,1)-(StartCurr-0.05)) / BTSCharge * 4 / 1.5;  % BTSCharge/4=nC (ICT calibration); nC/1.5 = mA in the SR; -.05 SR lifetime loss during measurement
            %fprintf('   %s: Injection efficiency %g \n', datestr(now), eff);
            
            setpv('BTS_To_SR_Injection_Efficiency', eff);
            setpv('BTS_To_SR_Injection_Rate', (DCCT(i,1)-(StartCurr-0.05)));
            setpv('BR_To_BTS_Extracted_Charge', BTSCharge/4);
            
            fprintf('   %d.  %.1f sec (%.2f sec)  Bucket %d (AM=%d)  Extr#=%d (%s)  BTSCharge1=%.3f   BTSCharge2=%.3f  DCCT=%.3f (%.3f) eff=%g \n\n', i, etime(clock,t0), etime(clock,t_last), Fill_Pattern(iBucket), BucketMonitor(i), Extr(i), datestr(ExtrTs(i),'MM.SS.FFF'), BTSCharge1(i), BTSCharge2(i), getdcct, (DCCT(i,1)-(StartCurr-0.05)), eff);
            t_last = clock;
            
            t(i,1) = etime(clock,t0);
            
            
            % pause(0.5);
            
            % Pause between injecctions
            % minimumdt = 10;  % For topoff
            % StartPause = gettime;
            % while (gettime-StartPause) < (minimumdt-1.45)
            %     if abs(gettime-StartPause) > 1800      % This patch is necessary to deal with switching from PDST to PST
            %         StartPause = gettime;
            %     end
            %     pause(0.5);
            % end
            
            %if getpv(DCCT_ChannelName{i}) <= GoalCurrent
            if DCCT(i,1) >= GoalCurrent
                break;
            end
               
%         catch
%             fprintf('   Error occurred injecting\n');
%             setpv('LTB_____TV6____BC19', 1);   % Put a paddle in
%             break;
%         end
    end
end


% Stop injection & put a paddle in
Disable_Triggers;
setpv('LTB_____TV6____BC19', 1);
%CleanUp;


%fprintf('   Return to multibunch fill\n');
%setpv('BR1_____TIMING_AC00', StartInjTrig);
%setpv('BR1_____TIMING_AC00', getpv('BR1_____TIMING_AM00')-InjTrigDelta);
%setpv('GTL_____TIMING_AC02', 36);


%%%%%%%%%%%%%%%
% End of Main %
%%%%%%%%%%%%%%%


% 
% function [PeakFlag, T] = wait_for_booster_peak_field
% t0 = gettime;
% PeakFlag = 0;
% while (gettime-t0) < 1.5
%     BEND_AM = getam('BR1_____B_IE___AM00');
%     pause(0.1);
%     if getam('BR1_____B_IE___AM00') < (BEND_AM - 0.1)
%         fprintf('   Passed booster peak field - synchronizining timing\n');
%         PeakFlag = 1;
%         break
%     end
% end
% T = gettime-t0;
% 
% 
% function [BTSCharge, ExtractFlag, T] = wait_for_extraction
% t0 = gettime;
% ExtractFlag = 0;
% while (gettime-t0) < 1.5
%     if getam('BR1_____B_IE___AM00') > 7
%         break
%     end
%     pause(0.01);
% end
% while (gettime-t0) < 1.5
%     if getam('BR1_____B_IE___AM00') < 7
%         fprintf('   Extraction from booster detected\n');
%         ExtractFlag = 1;
%         break
%     end
%     pause(0.01);
% end
% pause(.1);
% T = gettime-t0;
% BTSCharge1 = getam('BTS_____ICT01__AM00');
% BTSCharge2 = getam('BTS_____ICT02__AM01');
% BTSCharge = max([BTSCharge1 BTSCharge2]);

% TimeOut = 1.5; % Sec
% t0 = gettime;
% ExtractFlag = 0;
% while ((gettime-t0) < TimeOut)
%     pause(0.05);
%     BTSCharge1 = getam('BTS_____ICT01__AM00');
%     BTSCharge2 = getam('BTS_____ICT02__AM01');
%     if (BTSCharge1>0.5) || (BTSCharge2>0.5)
%         fprintf('   Extraction from booster detected\n');
%         ExtractFlag = 1;
%         BTSCharge = max([BTSCharge1 BTSCharge2]);
%         break
%     else
%         BTSCharge=0;
%     end
% end
% T = gettime-t0;


function Disable_Triggers
setpv('GTL_____TIMING_BC00', 0);  % GUN trigger
setpv('BR1_____KI_P___BC17', 0);  % Booster Injection Kicker
setpv('BR2_____BUMP_P_BC21', 0);  % Booster Extraction Bump Magnets (3 magnets)
setpv('BR2_____KE_P___BC17', 0);  % Booster Extraction Kicker
setpv('BR2_____SEN_P__BC22', 0);  % Booster extraction thin septum
setpv('BR2_____SEK_P__BC23', 0);  % Booster extraction thick septum

setpv('SR01S___SEK_P__BC23', 0);  % SR injection thick septum
setpv('SR01S___SEN_P__BC22', 0);  % SR injection thin septum
setpv('SR01S___BUMP1P_BC22', 0);  % SR injection bumps (4 magnets)


function Enable_Triggers
setpv('GTL_____TIMING_BC00', 1);  % GUN trigger
setpv('BR1_____KI_P___BC17', 1);  % Booster Injection Kicker
setpv('BR2_____BUMP_P_BC21', 1);  % Booster Extraction Bump Magnets (3 magnets)
setpv('BR2_____KE_P___BC17', 1);  % Booster Extraction Kicker
setpv('BR2_____SEN_P__BC22', 1);  % Booster extraction thin septum
setpv('BR2_____SEK_P__BC23', 1);  % Booster extraction thick septum
setpv('SR01S___SEK_P__BC23', 1);  % SR injection thick septum
setpv('SR01S___SEN_P__BC22', 1);  % SR injection thin septum
setpv('SR01S___BUMP1P_BC22', 1);  % SR injection bumps (4 magnets)


function P = PullLTBPaddles
% LastPosition = PullLTBPaddles
P(1,1) = getpv('LTB_____TV1____BC16');
P(2,1) = getpv('LTB_____TV3____BC16');
P(3,1) = getpv('LTB_____TV4____BC18');
P(4,1) = getpv('LTB_____TV5____BC16');
P(5,1) = getpv('LTB_____TV6____BC19');

fprintf('   Pulling LTB paddles (if not already open)\n');
setpv('LTB_____TV1____BC16', 0);
setpv('LTB_____TV3____BC16', 0);
setpv('LTB_____TV4____BC18', 0);
setpv('LTB_____TV5____BC16', 0);
setpv('LTB_____TV6____BC19', 0);


function P = PullBTSPaddles
% LastPosition = PullBTSPaddles
P(1,1) = getpv('BTS_____TV1____BC16');
P(2,1) = getpv('BTS_____TV2____BC18');
P(3,1) = getpv('BTS_____TV3____BC18');
P(4,1) = getpv('BTS_____TV4____BC16');
P(5,1) = getpv('BTS_____TV5____BC18');
P(6,1) = getpv('BTS_____TV6____BC20');

fprintf('   Pulling BTS paddles (if not already open)\n');
setpv('BTS_____TV1____BC16',0);
setpv('BTS_____TV2____BC18',0);
setpv('BTS_____TV3____BC18',0);
setpv('BTS_____TV4____BC16',0);
setpv('BTS_____TV5____BC18',0);
setpv('BTS_____TV6____BC20',0);


function P = PullBoosterPaddles
% LastPosition = PullBoosterPaddles
P(1,1) = getpv('BR1_____TV1____BC18');
P(2,1) = getpv('BR1_____TV2____BC16');
P(3,1) = getpv('BR1_____TV3____BC18');
P(4,1) = getpv('BR3_____TV1____BC16');
P(5,1) = getpv('BR4_____TV1____BC16');

fprintf('   Pulling Booster paddles (if not already open)\n');
setpv('BR1_____TV1____BC18', 0);
setpv('BR1_____TV2____BC16', 0);
setpv('BR1_____TV3____BC18', 0);
setpv('BR3_____TV1____BC16', 0);
setpv('BR4_____TV1____BC16', 0);


function CleanUp

fprintf('   Putting LTB TV6 paddle into linac beam\n');
setpv('LTB_____TV6____BC19', 255);
pause(2);

fprintf('   Re-enabling injector - but keeping SR injection triggers OFF\n');
setpv('GTL_____TIMING_BC00', 1);  % GUN trigger
setpv('BR1_____KI_P___BC17', 1);  % Booster Injection Kicker
setpv('BR2_____BUMP_P_BC21', 1);  % Booster Extraction Bump Magnets (3 magnets)
setpv('BR2_____KE_P___BC17', 1);  % Booster Extraction Kicker
setpv('BR2_____SEN_P__BC22', 1);  % Booster extraction thin septum
setpv('BR2_____SEK_P__BC23', 1);  % Booster extraction thick septum

% Switch bucket timing control back to table
fprintf('   Bucket timing control switched back to table, i.e. SRinject\n');
setpv('SR01C___TIMING_AC11', 255);
setpv('SR01C___TIMING_AC13', 255);

% Switch gun back to multibunch
% setpv('BR1_____TIMING_AC00',StartInjTrig);
%fprintf('Setting gun width to 12 ns\n');
%setpv('GTL_____TIMING_AC02',12);
fprintf('   Setting gun width to 36 ns\n');
setpv('GTL_____TIMING_AC02',36);



%  Questions
%  1. The injection field trigger value. The average energy of the linac output is different,
%     depending on how many bunches one selects. So to optimize transmission, we have to shift
%     the injection energy into the booster around.
%     Where is BR1_____TIMING_AM00 set and what is the default?  Is it different for cam buckets
%     StartInjTrig = getpv('BR1_____TIMING_AM00');
%  2. Where are Topoff_goal_current_SP and Topoff_cam_goal_current_SP set?  hwinit?
%
%  3. Why doesn't the 255 cause trouble in EPICS for setpv('LTB_____TV6____BC19', 255), etc.? 


% GTL_____TIMING_AC00 Gun rate (1, 2, 5, 10 PPS)
% GTL_____TIMING_AC01 Linac rate (0=off, 255=on)
% GTL_____TIMING_AC02 GUN-WIDTH (1-255)
% GTL_____TIMING_AC03 Linac trg delay 
% GTL_____TIMING_AC04 Kick trig delay 
% GTL_____TIMING_AM00 Gun rate 
% GTL_____TIMING_AM01 Linac rate 
% GTL_____TIMING_AM02 GUN-WIDTH 
% GTL_____TIMING_AM03 Linac trg delay (0 - 5us in 20nsec steps)
% GTL_____TIMING_AM04 Kick trig delay  (0 - 250nsec)
% GTL_____TIMING_BC00 GUN ON 
% GTL_____TIMING_BC01 RNP 
% GTL_____TIMING_BM00 GUN ON 
% GTL_____TIMING_BM01 RNP (Request Next Pulse - enables or disables triggering)
% 
% BR1_____TIMING_AC00 inj field trg 
% BR1_____TIMING_AC01 bump mag trg 
% BR1_____TIMING_AC02 gauss interv trg 
% BR1_____TIMING_AC03 bpm halt trig 
% BR1_____TIMING_AC04 extract field tr 
% BR1_____TIMING_AC05 utility trigger 
% BR1_____TIMING_AM00 inj field trg 
% BR1_____TIMING_AM01 bump mag trg 
% BR1_____TIMING_AM02 gauss interv trg 
% BR1_____TIMING_AM03 bpm halt trig 
% BR1_____TIMING_AM04 extract field tr 
% BR1_____TIMING_AM05 utility trigger 
% 
% SR01C___TIMING_AC00 SPARE 0 
% SR01C___TIMING_AC01 SPARE 1 
% SR01C___TIMING_AC02 SR BUMP DELAY 
% SR01C___TIMING_AC03 SR THIN SEPTUM 
% SR01C___TIMING_AC04 SR THICK SEPTUM 
% SR01C___TIMING_AC05 BR THICK SEPTUM 
% SR01C___TIMING_AC06 BR THIN SEPTUM 
% SR01C___TIMING_AC07 EXTRACTION KICKE 
% SR01C___TIMING_AC09 EXTRACTION SYNC *
% 
% The Extraction Sync PV behaves like a 3-bit value with each bit controlling the following:
% bit 0 : Extraction Gate Enabled
% bit 1 : Idle Mode Enabled
% bit 2 : SRDC Trigger Disabled
% e.g. SR01C___TIMING_AC09 = 5 (1+4)  => Extraction Gate Enabled and SRDC Trigger Disabled
% 
% Bucket Loading
% SR01C___TIMING_AC08 TARGET BUCKET (1-328)
% SR01C___TIMING_AM08 TARGET BUCKET (1-328)
% SR01C___TIMING_AM10 BUCKET INDEX (1-1000)
% SR01C___TIMING_AC11 MODE (0,255)
% SR01C___TIMING_AM11 MODE (0,255)
% SR01C___TIMING_AM12 STATUS (0,64,128,255)
% SR01C___TIMING_AC13 CONTROL (0,255)
% SR01C___TIMING_AM13 CONTROL (0,255)
% SR01C___TIMING_AM14 Bucket Number (1-328)
% 
% caput SR01C___TIMING_AC11 0            /* Control = 0. Stops table execution. Whichever bucket was last being loaded will continue to be filled.*/
% caput SR01C___TIMING_AC13 0            /* Mode = 0. Switch to single bucket mode. Whatever value (1-328) that is in AC08 will be filled */
% caput SR01C___TIMING_AC08 100         /* Target bucket 100 */  
%  
% To return to table execution mode:
% caput SR01C___TIMING_AC11 255            /* Control = 255. No effect on fill state. */
% caput SR01C___TIMING_AC13 255            /* Mode = 255. Switch to table execution mode. Starts filling from last tabl
%
% see http://controls.als.lbl.gov/adp/GTLTiming
%     http://controls.als.lbl.gov/adp/BRTiming
%     http://controls.als.lbl.gov/adp/BucketLoading


