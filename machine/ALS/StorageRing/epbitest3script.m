%function epbitest3script

% 

%% Cell 1:  Setup the EPBI Test #3

% Comments
% 1. run from Linux. The time resolution on the PC isn't good (etime issue in getpvonline)
% 2. This script is meant to be used with "cell evaluation"
% 3. Edit the below lines for each sector
clear


% Make sure the scapers are open
% open_jh_scrapers

% User lattice
% Correct orbit
% IDFF & SOFB on while ID closes
% Stop SOFB & IDFF
% Add local bump 
%    BPMy(Sector-1,10) BPMy(Sector, 1)
%    [-3 -1 1 3]
%    Iterations 3
%    RampSteps 25
% Runtest (note: don't initialize the EPBI test3 until after the SOFB is off)



% ************  Inputs that will need to be changed for each test *****************

IDDevice = [6 1];   % Sector number
UpperFlag = 0
;       % 1 for upper, 0 for lower TCs
T = 2;               % Time of the corrector bump [seconds]


% Corrector magnet setup
% Note: Only sector 11 is correct where the correct choice was [Sector+1 2]
%       A most effective corrector from the response matrix or model might be better
% Sector VCMDeviceList UpperDelta LowerDelta
EPBI_Input = [
    [ 1 1] [ 2 2] -8 9
    [ 2 1] [ 3 2] -8 9
    [ 3 1] [ 4 2] -8 9
    [ 4 1] [ 5 2] -8 8
    [ 5 1] [ 6 2] -8 5
    [ 6 1] [ 7 2] -7.5 6
    [ 6 2] [ 7 2] -7 6
    [ 7 1] [ 8 2] -7 7
    [ 8 1] [ 9 2] -8 8     % Note: this power supply is ringing badly!!!
    [ 9 1] [10 2] -8 8
    [10 1] [11 2] -7 8
    [11 1] [12 2] -7 7
    [11 2] [12 2] -6 7
    [12 1] [ 1 2] -7 7
    ];

% ************  End of inputs that will need to be changed for each test *************



i = findrowindex(IDDevice, EPBI_Input(:,1:2));
Sector = EPBI_Input(i,1);


%EPBIData = getepbichannelnames(Sector);


if UpperFlag
    VCMdelta = EPBI_Input(i,5);  % Ex. -8 for sector 11 upper
else
    VCMdelta = EPBI_Input(i,6);  % Ex.  9 for sector 11 lower
end
%VCMdelta = 0  % for testing 
VCMDev = EPBI_Input(i, [3 4]);


% Pack the channels in one matrix for fast gets
if Sector==5
    TC_Names = [
        sprintf('SR%02dW___TCUP0__AM', Sector)
        sprintf('SR%02dW___TCUP1__AM', Sector)
        sprintf('SR%02dW___TCUP2__AM', Sector)
        sprintf('SR%02dW___TCUP3__AM', Sector)
        sprintf('SR%02dW___TCUP4__AM', Sector)
        sprintf('SR%02dW___TCUP5__AM', Sector)
        sprintf('SR%02dW___TCUP6__AM', Sector)
        sprintf('SR%02dW___TCUP7__AM', Sector)
        sprintf('SR%02dW___TCUP8__AM', Sector)
       %sprintf('SR%02dW___TCUP9__AM', Sector)
        sprintf('SR%02dW___TCDN0__AM', Sector)
        sprintf('SR%02dW___TCDN1__AM', Sector)
        sprintf('SR%02dW___TCDN2__AM', Sector)
        sprintf('SR%02dW___TCDN3__AM', Sector)
        sprintf('SR%02dW___TCDN4__AM', Sector)
        sprintf('SR%02dW___TCDN5__AM', Sector)
        sprintf('SR%02dW___TCDN6__AM', Sector)
        sprintf('SR%02dW___TCDN7__AM', Sector)
        sprintf('SR%02dW___TCDN8__AM', Sector)
        %sprintf('SR%02dW___TCDN9__AM', Sector)
        
        % sprintf('SR%02dW___TCUP0__BM', Sector)
        % sprintf('SR%02dW___TCUP1__BM', Sector)
        % sprintf('SR%02dW___TCUP2__BM', Sector)
        % sprintf('SR%02dW___TCUP3__BM', Sector)
        % sprintf('SR%02dW___TCUP4__BM', Sector)
        % sprintf('SR%02dW___TCUP5__BM', Sector)
        % sprintf('SR%02dW___TCUP6__BM', Sector)
        % sprintf('SR%02dW___TCUP7__BM', Sector)
        % sprintf('SR%02dW___TCUP8__BM', Sector)
        % sprintf('SR%02dW___TCUP9__BM', Sector)
        % sprintf('SR%02dW___TCDN0__BM', Sector)
        % sprintf('SR%02dW___TCDN1__BM', Sector)
        % sprintf('SR%02dW___TCDN2__BM', Sector)
        % sprintf('SR%02dW___TCDN3__BM', Sector)
        % sprintf('SR%02dW___TCDN4__BM', Sector)
        % sprintf('SR%02dW___TCDN5__BM', Sector)
        % sprintf('SR%02dW___TCDN6__BM', Sector)
        % sprintf('SR%02dW___TCDN7__BM', Sector)
        % sprintf('SR%02dW___TCDN8__BM', Sector)
        % sprintf('SR%02dW___TCDN9__BM', Sector)
        ];
    
    TC_Names = [
        TC_Names
        sprintf('SR%02dW___UP_OUT_BM', Sector)
        sprintf('SR%02dW___DN_OUT_BM', Sector)
        ];
else
    
    TC_Names = [
        sprintf('SR%02dS___TCUP0__AM', Sector)
        sprintf('SR%02dS___TCUP1__AM', Sector)
        sprintf('SR%02dS___TCUP2__AM', Sector)
        sprintf('SR%02dS___TCUP3__AM', Sector)
        sprintf('SR%02dS___TCUP4__AM', Sector)
        sprintf('SR%02dS___TCUP5__AM', Sector)
        sprintf('SR%02dS___TCUP6__AM', Sector)
        sprintf('SR%02dS___TCUP7__AM', Sector)
        sprintf('SR%02dS___TCUP8__AM', Sector)
        %sprintf('SR%02dS___TCUP9__AM', Sector)
        sprintf('SR%02dS___TCDN0__AM', Sector)
        sprintf('SR%02dS___TCDN1__AM', Sector)
        sprintf('SR%02dS___TCDN2__AM', Sector)
        sprintf('SR%02dS___TCDN3__AM', Sector)
        sprintf('SR%02dS___TCDN4__AM', Sector)
        sprintf('SR%02dS___TCDN5__AM', Sector)
        sprintf('SR%02dS___TCDN6__AM', Sector)
        sprintf('SR%02dS___TCDN7__AM', Sector)
        sprintf('SR%02dS___TCDN8__AM', Sector)
        %sprintf('SR%02dS___TCDN9__AM', Sector)
        
        % sprintf('SR%02dS___TCUP0__BM', Sector)
        % sprintf('SR%02dS___TCUP1__BM', Sector)
        % sprintf('SR%02dS___TCUP2__BM', Sector)
        % sprintf('SR%02dS___TCUP3__BM', Sector)
        % sprintf('SR%02dS___TCUP4__BM', Sector)
        % sprintf('SR%02dS___TCUP5__BM', Sector)
        % sprintf('SR%02dS___TCUP6__BM', Sector)
        % sprintf('SR%02dS___TCUP7__BM', Sector)
        % sprintf('SR%02dS___TCUP8__BM', Sector)
        % sprintf('SR%02dS___TCUP9__BM', Sector)
        % sprintf('SR%02dS___TCDN0__BM', Sector)
        % sprintf('SR%02dS___TCDN1__BM', Sector)
        % sprintf('SR%02dS___TCDN2__BM', Sector)
        % sprintf('SR%02dS___TCDN3__BM', Sector)
        % sprintf('SR%02dS___TCDN4__BM', Sector)
        % sprintf('SR%02dS___TCDN5__BM', Sector)
        % sprintf('SR%02dS___TCDN6__BM', Sector)
        % sprintf('SR%02dS___TCDN7__BM', Sector)
        % sprintf('SR%02dS___TCDN8__BM', Sector)
        % sprintf('SR%02dS___TCDN9__BM', Sector)
        ];
    
    TC_Names = [
        TC_Names
        sprintf('SR%02dS___UP_OUT_BM', Sector)
        sprintf('SR%02dS___DN_OUT_BM', Sector)
        ];
end
NTC = 18;

% More TC resolution for EDM etc.
setpv(TC_Names(1:NTC,:), 'MDEL', 0);
pause(.1);


% Add 2 BPMs and the corrector AM 
% In the future: add a BPM sum signal
% Note: cmm:beam_current is too slow
if Sector == 12
    ChannelNameX   = family2channel('BPMx','Monitor', [Sector 1;Sector 9]);
    ChannelNameY   = family2channel('BPMy','Monitor', [Sector 1;Sector 9]);
else
    ChannelNameX   = family2channel('BPMx','Monitor', [Sector 1;Sector+1 1]);
    ChannelNameY   = family2channel('BPMy','Monitor', [Sector 1;Sector+1 1]);
end
ChannelNameVCM = family2channel('VCM', 'Monitor', VCMDev);
ChannelName = [
    ChannelNameX
    ChannelNameY
    ChannelNameVCM
    ];
ChannelName = strvcat(TC_Names, ChannelName);

   
% Speed up the EPBI PVs
% The EPBI PV update rate is 20 msec / throttle (ie, 50 Hz max)
%setpv('SR11S___UP_throttle');
if Sector==5
    setpv(sprintf('SR%02dW___UP_throttle', Sector), 1);
    setpv(sprintf('SR%02dW___DN_throttle', Sector), 1);
else
    setpv(sprintf('SR%02dS___UP_throttle', Sector), 1);
    setpv(sprintf('SR%02dS___DN_throttle', Sector), 1);
end

% Higher the bandwidth of the BPMs
%setpv('BPMx', 'TimeConstant', .001);
%setpv('BPMy', 'TimeConstant', .001);

% Setup the corrector
VCMchan = family2channel('VCM', 'Setpoint', VCMDev);   % Could use 'Trim'?
RampRateStart = getpv('VCM', 'RampRate', VCMDev);
setpv('VCM', 'RampRate', 1000, VCMDev);
VCMsp = getpv(VCMchan);

% Enable the EPBI recorder
setpv('EPBI_TR_ARM_BC', 1);

% Make sure all the monitor channels are connected
[Data0, t, TimeStamp] = getpv(ChannelName);

% Test channel timing
% [Data, t, TimeStamp] = getpv(ChannelName, 0:.004:2.5);
% plot(t,Data(1:18,:),'.-');


% Filename - time gets added later
if ispc
    DirectoryPath = 'M:\EPBI\Test3_Data\';
else
    DirectoryPath = '/home/als/physdata/EPBI/Test3_Data/';
end

if UpperFlag
    FileName = sprintf('EPBI_Test3_Sector%d_Upper', Sector);
else
    FileName = sprintf('EPBI_Test3_Sector%d_Lower', Sector);
end
FileName = [DirectoryPath, FileName];

pause(.5);



%%  Apply kick and get data ("The real test")
%   1. Warren will put a local bump in the orbit before starting this cell!
%   2. If it doesn't kill the beam, adjust the kick or local bump
%   3. It helpful to have the EDM page up so you can see if the TC are getting heated from the local bunch

t0 = gettime;
setpv(VCMchan, VCMsp+VCMdelta, 0);
t1 = gettime;
[Data, t, TimeStamp] = getpv(ChannelName, 0:.002:2);
t2 = gettime;

% Reset the corrector setpoint
setpv(VCMchan, VCMsp);


% Waveform data recorder (assuming a trip occured)
% Note: DataTime is last point in the waveform
try
    for i = 1:9
        if Sector==5
            [TCUP(i,:), tmp, DataTime(i,1)] = getpv(sprintf('SR%02dW___TCUP%d_WF_AM', Sector, i));
        else
            [TCUP(i,:), tmp, DataTime(i,1)] = getpv(sprintf('SR%02dS___TCUP%d_WF_AM', Sector, i));
            %[tmp1, tmp2, LcaTime(i,1)]      = getpvonline(sprintf('SR%02dS___TCUP%d_WF_AM', Sector, i));
            %TCDN(i,:) = getpv(sprintf('SR%02dS___TCDN%d_WF_AM', Sector, i));
        end
    end
    clear tmp
catch
end

% Save data
FileName = appendtimestamp(FileName, clock);
save(FileName);
fprintf('   Test #3 complete.  Data saved to %s', FileName);





%% Plot EPBI Test #3

plotepbitest3(FileName);




%% Publish - work in progress buy it should work

publish_epbi(FileName)




%% Clean up after sector is complete

% Throttle the EPBI PVs to 10 Hz
%setpv('SR11S___UP_throttle');
for i = [4 5 6 7 8 9 10 11 12]
    if i==5
        setpv(sprintf('SR%02dW___UP_throttle', i), 5);
        setpv(sprintf('SR%02dW___DN_throttle', i), 5);
    else
        setpv(sprintf('SR%02dS___UP_throttle', i), 5);
        setpv(sprintf('SR%02dS___DN_throttle', i), 5);
    end
end

% Reset the ramprate
%setpv('VCM', 'RampRate', RampRateStart, VCMDev);

% Make sure the BPM TimeConstant is setup back
% Make sure the corrector ramprate is setup back
hwinit;   % overkill




% %% Re-publish
% 
% if ispc
%     DirectoryPath = 'M:\EPBI\Test2_Data\';
% else
%     DirectoryPath = '/home/als/physdata/EPBI/Test3_Data/';
% end
% 
% a = {
%     'EPBI_Test3_Sector10_Lower_2012-02-09_00-15-41.mat'
%     'EPBI_Test3_Sector10_Upper_2012-02-08_20-14-13.mat'
%     'EPBI_Test3_Sector11_Lower_2012-02-09_02-09-32.mat'
%     'EPBI_Test3_Sector11_Lower_2012-02-09_02-10-33.mat'
%     'EPBI_Test3_Sector11_Lower_2012-02-09_02-12-13.mat'
%     'EPBI_Test3_Sector11_Upper_2012-02-09_01-49-37.mat'
%     'EPBI_Test3_Sector11_Upper_2012-02-09_01-50-44.mat'
%     'EPBI_Test3_Sector11_Upper_2012-02-09_01-51-17.mat'
%     'EPBI_Test3_Sector12_Lower_2012-02-09_00-49-51.mat'
%     'EPBI_Test3_Sector12_Upper_2012-02-09_00-38-54.mat'
%     'EPBI_Test3_Sector5_Lower_2012-02-08_19-21-25.mat'
%     'EPBI_Test3_Sector5_Lower_2012-02-08_19-22-04.mat'
%     'EPBI_Test3_Sector5_Lower_2012-04-25_09-58-11.mat'
%     'EPBI_Test3_Sector5_Upper_2012-02-08_18-47-29.mat'
%     'EPBI_Test3_Sector5_Upper_2012-02-08_18-53-44.mat'
%     'EPBI_Test3_Sector5_Upper_2012-04-25_09-33-10.mat'
%     'EPBI_Test3_Sector5_Upper_2012-04-25_09-33-38.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-12-49.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-13-19.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-17-59.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-36-40.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-37-05.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-37-20.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-37-34.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-37-48.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-38-05.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-38-27.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-38-42.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-53-39.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-53-58.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-54-24.mat'
%     'EPBI_Test3_Sector6_Lower_2012-04-25_11-54-41.mat'
%     'EPBI_Test3_Sector6_Lower_2012-08-15_11-59-12.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-21-25.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-21-53.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-22-14.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-22-35.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-22-53.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-26-28.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-27-04.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-37-14.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-42-04.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-42-26.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-43-23.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-44-58.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-54-54.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-55-18.mat'
%     'EPBI_Test3_Sector6_Upper_2012-04-25_10-55-43.mat'
%     'EPBI_Test3_Sector6_Upper_2012-08-15_11-41-24.mat'
%     'EPBI_Test3_Sector7_Lower_2012-02-08_19-53-00.mat'
%     'EPBI_Test3_Sector7_Upper_2012-02-08_19-37-26.mat'
%     'EPBI_Test3_Sector8_Lower_2012-02-14_22-55-02.mat'
%     'EPBI_Test3_Sector8_Lower_2012-02-14_22-59-46.mat'
%     'EPBI_Test3_Sector8_Upper_2012-02-14_22-36-52.mat'
%     'EPBI_Test3_Sector9_Lower_2012-02-09_01-25-11.mat'
%     'EPBI_Test3_Sector9_Upper_2012-02-09_01-06-53.mat'
%     'EPBI_Test3_Sector9_Upper_2012-02-09_01-07-41.mat'
%     };
% 
% for i = 1:length(a)
%     publish_epbi([DirectoryPath, a{i}]);
% end


