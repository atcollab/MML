function [SA, Status] = getbpmarchive(Prefix, FigNum)
% GETBPMARCHIVE - Gets BPM data off the SSD archive on bpm01.als.lbl.gov
%
% [SA, Status] = getbpmarchive(Prefix)
%
% python /usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py -h
%
% usage: showLog.py [-h] [-b BEGIN] [-d DURATION] [-s SPARSE] [-U] [-M]
%                   [filenames [filenames ...]]
%
% Show BPM slow acquisition log as ASCII table.
%
% positional arguments:
%   filenames
%
% optional arguments:
%   -h, --help                        ->   Show this help message and exit
%   -b BEGIN, --begin BEGIN           ->   Begin date/time (YYY-MM-DD HH:MM[:SS] [TZ]),
%                                            default=beginning of time
%   -d DURATION, --duration DURATION  ->  Duration (seconds), default=1
%   -s SPARSE, --sparse SPARSE        ->  Sparsing factor, default=1
%   -U, --UTC                         ->   Show times in UTC rather than local time zone
%   -M, --MATLAB                      ->   First columns are seconds and delta seconSA. Easier toyread into MATLAB/Octave
%
%   To avoid ambiguity at the autumnal DST change the 'begin' time
%   may be followed by a time zone specifier (PST, PDT or UTC).
%
%   Columns:
%       1 - ISO-format date YYYY-MM-DD
%       2 - ISO-format time HH:MM:SS.XXx
%       3 - X position
%       4 - Y position
%       5 - Q (skew)
%       6 - Button sum
%    7-10 - ADC peak
%   11-14 - RF magnitude
%   15-18 - Low pilot tone magnitude
%   19-22 - High pilot tone magnitude
%   23-26 - Gain trim factors
%      27 - Wideband X RMS motion
%      28 - Wideband Y RMS motion
%      29 - Narrowband X RMS motion
%      30 - Narrowband Y RMS motion
%
%
% NOTES
% 1. Python script written by Eric Norum
% 2. Make sure you're using python 2.7.1 or higher
% 3. Must be run on bpm01.als.lbl.gov or a machine with the SSD mounted (like phys1, apps1, apps2)

% To-do
% 1. Add multiple BPMs and change to DeviceList input
% 2. Time inputs -> find the files and data
% 3. Separate plotting and data retrieval
% 4. To write a matlab script
%     !bunzip2 2018-03-08_00:00:00.dat.bz2
%    fid = fopen('2018-03-08_00:00:00.dat','r','b')
%    fclose(fid);

% Standard error is getting mapped into the data stream.  Eric's thoughts:
% Hmm…..the unix command must be merging stdout and stderr into a single stream.  Really antisocial behaviour.  A real rookie (or Windows) programmer thing to do.
% What happens if you add
%         2>/dev/null
% at the end of the command?  That should redirect stderr away — assuming that the unix command uses a shell to invoke the program……


% BPM Testing
% 1,3,4,5 test on one PT (EPICS channel 5)
% Raised the PT correction signal strength to 1/3 the RFMag on 11/10/2016 at 12:30am
% 2017-03-29 ->  SR01C:BPM1 Found saturated at 1:10pm, change the ATTN to 5
% 2017-03-29 ->  SR01C:BPM5 Installed CTS filters about 12pm, ATTN 5, Dual PT On
% 2017-07-07 ->  SR01C:BPM5 Installed a new CTS filter BPM with 400MHz LP on board (Friday night, 2 days of 2-bunch left)
% 2017-07-21 ->  2:40 pm removed the split to Bergoz 1,6 and connected BPM(1 )
% 2017-07-21 ->  Sector 1 back door: Openned at 2:35pm, closed at 3:35pm
 
if nargin < 2
    FigNum = 501;
end

% Noise measurement BPMs
%Prefix = 'SR01C:BPM1';  % CTS test
%Prefix = 'SR01C:BPM3';  % CTS test
%Prefix = 'SR01C:BPM4';  % CTS test
%Prefix = 'SR01C:BPM5';  % Lorch test 

%Prefix = 'SR01C:BPM2';
%Prefix = 'SR02C:BPM2';

%Prefix = 'SR10C:BPM7';
%Prefix = 'SR10C:BPM8'; 
%Prefix = 'SR11C:BPM1';  

Prefix = 'SR08C:BPM1';  

%Prefix = 'SR04C:BPM7';
%Prefix = 'SR06C:BPM2';
%Prefix = 'SR07C:BPM1';
%end

% python showLog.py /data/BPMLOG/SR01C\:BPM1/2016-09-27_00\:00\:00.dat.bz2 | tail ; date
% python showLog.py /data/BPMLOG/SR01C:BPM5/2016-09-07_15:47:04.dat.bz2 | tail

%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /data/BPMLOG/%s --begin "2016-09-29 11:00:00" --duration 10 --MATLAB', 'SR06C:BPM1');
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /data/BPMLOG/SR06C:BPM1/2016-09-29_00:00:00.dat.bz2 --begin "2016-09-29 00:00:00" --duration 360000 --MATLAB');

%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /data/BPMLOG/%s/2016-09-29_00:00:00.dat.bz2 --begin "2016-09-29 00:00:00" --duration 36000 --MATLAB', Prefix);
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /data/BPMLOG/%s/2016-09-30_00:00:00.dat.bz2 --begin "2016-09-30 00:00:00" --duration 360000 --MATLAB', Prefix);
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /data/BPMLOG/%s/2016-10-01_00:00:00.dat.bz2 --begin "2016-10-01 00:00:00" --duration 5000000 --MATLAB', Prefix);

% Owl shift 10-24-2016
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-10-23_00:00:00.dat.bz2 --begin "2016-10-23 18:30:00" --duration 100000 --MATLAB', Prefix);
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-10-24_00:00:00.dat.bz2 --begin "2016-10-24 00:00:00" --duration 234500 --MATLAB', Prefix);

%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-10-24_00:00:00.dat.bz2 --begin "2016-10-24 00:00:00" --duration 23450 --MATLAB', Prefix);

%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-10_00:00:00.dat.bz2 --begin "2016-11-10 00:00:00" --duration 2500 --MATLAB', Prefix);

% PT was 960mA
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-12_00:00:00.dat.bz2 --begin "2016-11-12 10:17:00" --duration 400 --MATLAB', Prefix);
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-12_00:00:00.dat.bz2 --begin "2016-11-12 10:17:00" --duration 1000 --MATLAB', Prefix);

% ~2:45pm ran 4 loops of PT Attn with CMOS
% 15:02pm ran 1 loops of PT Attn with CMOS
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-12_00:00:00.dat.bz2 --begin "2016-11-12 14:47:00" --duration 300 --MATLAB', Prefix);
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-12_00:00:00.dat.bz2 --begin "2016-11-12 15:01:30" --duration 300 --MATLAB', Prefix);
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-13_00:00:00.dat.bz2 --begin "2016-11-13 01:04:00" --duration 400 --MATLAB', Prefix);

% 600mA, PT attn sweep
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-15_00:00:00.dat.bz2 --begin "2016-11-15 21:57:00" --duration 400 --MATLAB', Prefix);

% 600mA to 400 transition -> 600mV is better rms (38nm to 57nm vertical)
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-15_00:00:00.dat.bz2 --begin "2016-11-15 22:17:00" --duration 500 --MATLAB', Prefix);

% 400mA to 900 transition -> 900 mA is better rms (50nm to 44.6nm vertical)
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-15_00:00:00.dat.bz2 --begin "2016-11-15 22:30:00" --duration 400 --MATLAB', Prefix);

% 900mA to 700 transition -> 900 mA is better rms (40nm to 50nm vertical)
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-15_00:00:00.dat.bz2 --begin "2016-11-15 22:36:00" --duration 600 --MATLAB', Prefix);

% 700mA to 600 transition -> 0 mA is better rms (51nm to 43.5nm vertical)
%%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-15_00:00:00.dat.bz2 --begin "2016-11-15 23:01:00" --duration 800 --MATLAB', Prefix);

% 600mA, New software
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-18_00:00:00.dat.bz2 --begin "2016-11-18 16:56:00" --duration 300 --MATLAB', Prefix);

% 5:48pm move the PT gain up/down w/ and w/o PT correction

% Something isn't right with the new firmware for changing the PT one sample earlier
%CommandStr = sprintf('/usr/local/epics/R3.14.12/modules/instrument/ALS_BPM/head/scripts/showLog.py /archive/BPMLOG/%s/2016-11-18_00:00:00.dat.bz2 --begin "2016-11-18 20:08:00" --duration 4400 --MATLAB', Prefix);

% Beam dump
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-18_00:00:00.dat.bz2 --begin "2016-11-18 21:45:00" --duration 8000 --MATLAB', Prefix);

% S0102 door open for 3 minutes (PT correction not on)
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-19_00:00:00.dat.bz2 --begin "2016-11-19 10:55:00" --duration 1800 --MATLAB', Prefix);

% S0102 door open for 20 minutes 11:30 to 11:50 (PT correction not on)
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-19_00:00:00.dat.bz2 --begin "2016-11-19 11:25:00" --duration 6000 --MATLAB', Prefix);

% On/off with new firmware.   Note: SR01C:BPM1,3,4,5 use PT SR01:CC:ptA5, SR01:CC:ptA5
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-23_00:00:00.dat.bz2 --begin "2016-11-23 20:21:00" --duration 600 --MATLAB', Prefix);
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-23_00:00:00.dat.bz2 --begin "2016-11-23 18:00:00" --duration 1800 --MATLAB', Prefix);

%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-23_00:00:00.dat.bz2 --begin "2016-11-23 20:26:00" --duration 1000 --MATLAB', Prefix);

%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-29_00:00:00.dat.bz2 --begin "2016-11-29 09:59:00" --duration 50 --MATLAB', Prefix);
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-29_00:00:00.dat.bz2 --begin "2016-11-29 10:28:00" --duration 100 --MATLAB', Prefix);
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-11-29_00:00:00.dat.bz2 --begin "2016-11-29 10:46:00" --duration 100 --MATLAB', Prefix);

%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-01_00:00:00.dat.bz2 --begin "2016-12-01 22:34:40" --duration 500 --MATLAB', Prefix);

% New code at ~1:10pm, sector 1 test BPMs
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-05_00:00:00.dat.bz2 --begin "2016-12-05 13:03:30" --duration 1000 --MATLAB', Prefix);
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-05_00:00:00.dat.bz2 --begin "2016-12-05 21:35:00" --duration 10000 --MATLAB', Prefix);

%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-09_00:00:00.dat.bz2 --begin "2016-12-09 11:35:00" --duration 800 --MATLAB', Prefix);
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-09_00:00:00.dat.bz2 --begin "2016-12-09 00:00:00" --duration 86000 --MATLAB', Prefix);

%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-16_00:00:00.dat.bz2 --begin "2016-12-16 18:00:00" --duration 16200 --MATLAB', Prefix);
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-16_00:00:00.dat.bz2 --begin "2016-12-16 22:00:00" --duration 4200 --MATLAB', Prefix);

%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/2016-12-19_00:00:00.dat.bz2 --begin "2016-12-19 00:00:00" --duration 86399 --MATLAB', Prefix);

% ymd=[
%     2016 11 30
%     2016 12  1
%     2016 12  2
%     2016 12  3
%     2016 12  4
%     2016 12  7
%     2016 12  8
%     2016 12  9
%     2016 12 10
%     2016 12 14
%     2016 12 15
%     2016 12 16
%     2016 12 17
%     2016 12 18
%     2016 12 19
%     2016 12 20
%     2016 12 21
% ];
%
% % [2016 12 14] -> PT attn increased (basically 1/10 to 1/6 the beam magnitude, PT rms dropped, added on offset)
% % [2016 12 16] -> about 6:pm I put a split signal on Bergox sector 1 BPM6
% %                 PT didn't seem to affect it????  Is it just averaged out?
% %                 Also turned PT correction back on for the other BPMs
% % [2016 12 17] -> PT 1/2 the RFmag, data looks great.
% i = 12  % 13-[2017 02 08]>17
% CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%d-%d-%d_00:00:00.dat.bz2 --begin "%d-%d-%d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:))

% About [2017 02 08] 23:40:00, PT compensation on (Low/High PTs, NSLS2 BPM at RF)
%  (2017-02-14)
%i = 1;
%ymd = [2017 02 14];
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 79200 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
%ymd = [2017 02 13];  %
%ymd = [2017 02 14];  % Good data, PT amp increased above 2M in the morning, shut the BPM door at 11:10am (4e4 seconds) -> the PT compensation doesn't do as well as expected
% ymd = [2017 02 15];  % Good data
%ymd = [2017 02 16];  % Good data for 2/3 of the day, then saturated
% ymd = [2017 02 16] to [2017 02 23] Saturated
% ymd = [2017 02 24];  % Good data (different Attn???)
%ymd = [2017 02 27];
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 28000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));

% Testing with the split BPMs
%Prefix = 'SR01C:BPM5';

% Changed the length of the cable into the splitter for SR01C: BPM1 and BPM5
%ymd = [2017 06 28];
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 15:00:00" --duration 10000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));

% 2017-06-29 3:19pm -> something odd on the high low PT on Ch A.
%ymd = [2017 06 29];
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 15:00:00" --duration 2000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));


% % 2017-02-14 at 9:27, set the following conditions
%
% % 0 -> Off
% % 3 -> Dual
% setpv('SR01C:BPM1:autotrim:control', 3);
% setpv('SR01C:BPM1:attenuation', 0);
%
% % 600 mV
% setpv('SR01:CC:ptA5Output', 4);
% setpv('SR01:CC:ptB5Output', 4);
% setpv('SR01:CC:pt5Atten', 0);
%
% % NSLS2 BPM setup (for RF tone)
% % may need to addpath_nsls2_pilot_tone first
% % setpilottone;
% tcp_write_reg(34, 127);

%ymd = [2017 03 29];
%CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 13:15:00" --duration 38000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));


% Get beam 2017:  5/24 to 5/28
% Prefix = 'SR01C:BPM1';
% ymd=[
% 2017 05 24
% 2017 05 25 % Something weird happened to the PT (saturated but still computing gains?)
%    2017 05 26
%    2017 05 27
%    2017 05 28
%
%    2017 06 01
%    2017 06 02
%    2017 06 03
%
%    2017 06 08
%    2017 06 09
%    2017 06 10

%    2017 06 13
%    2017 06 14  % PT not on
%    2017 06 15
%    2017 06 16
%    2017 06 17
%    2017 06 18
%   ];


% 2-bunch
% Prefix = 'SR01C:BPM5';
% ymd = [
%   2017 06 21
%   2017 06 22
%   2017 06 23
%   2017 06 25
%   2017 06 26
%   2017 06 27
%   2017 06 28
%   2017 06 29
%   2017 06 30 ...
%   2017 07 07
% ];

% ymd = [
%   %2017 07 18  % Owl has a physical shift and 7am cycle
%    2017 07 19
%    2017 07 20   % Something weird at 14 hours, xaxis([36.48 36.53]-24) on BPM5 (CTS)
%    2017 07 21 % 1 beam dump, openned the door at 2:35pm - 3:35pm
% ];

% ymd = [
%   %2017 11 2
%   %2017 11 3
%   %2017 11 4
%   2017 11 5
%   
%   2017 11 8
%   %2017 11 9
%   %2017 11 10
%   %2017 11 11
% ];

% ymd = [
%   2017 11 29
%   2017 11 30
%   2017 12 1
%   2017 12 2
%   2017 12 3
% ];
% ymd = [
%   2017 12  9
%   2017 12 10
%   ];
% ymd = [
%     %2017 11 29
%     %2017 11 30
%     %2017 12 1
%     %2017 12 2
%     %2017 12 3
%     
%     2017 12 13
%     2017 12 14
%     2017 12 15
% %    2017 12 16  % beam dump
% %     2017 12 17
% %     
% %     2017 12 20
% %     2017 12 21
%     ];

% EPBI trip at ~4am
% ymd = [2018 01 21];

% EPBI trip at ~00:22am
% ymd = [2018 02 10];

% Topoff trip ~2am
%ymd = [2018 01 26];


% Drift after golden orbit was set on 2/26/2018 at 50mA
%ymd = [2018 02 27];

% New firmware
% ymd = [
%     2018 03 22
%     2018 03 23
%     ];

%ymd = [2018 03 26];

% Two bunch 2018-04-04 8am to 2018-04-11 8am (but there are many issues)
% ymd = [
%    %2018 04  4
%     2018 04  5
%     2018 04  6
%     2018 04  7
%     2018 04  8
%     2018 04  9
%     2018 04 10
%    %2018 04 11
%     ];

% New firmware
%ymd = [
%     2018 04 13
%     2018 04 14
%     ];

ymd = [
     2018 05 10
     ];

SA = [];
SA.Prefix  = Prefix;
SA.X       = [];
SA.Y       = [];
SA.S       = [];
SA.Q       = [];
SA.ADCpeak = [];
SA.Gain    = [];
SA.RFmag   = [];
SA.PTLmag  = [];
SA.PTHmag  = [];
SA.Xrms10k = [];
SA.Yrms10k = [];
SA.Xrms200 = [];
SA.Yrms200 = [];
SA.Time    = [];
SA.t       = [];

% 86400 seconds in a day
for i = 1:size(ymd,1)
    tic
    fprintf('Getting /.../BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2  %02d-%02d-%02d 00:00:00\n', Prefix, ymd(i,:), ymd(i,:));
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 100 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 26400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 20000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    
    % Via mounted drive: apps2, apps3, phys1, ...
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 26400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    
    %if i == 1
    %    CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:30:00" --duration 84600 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    %else
    %    CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:30:00" --duration 25200 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    %end

    %ymd = [2018 03 26];
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 22:38:00" --duration 20000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));

%    CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
%    CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/SR01C:BPM1/2018-04-13_11:56:08.dat.bz2 --begin "2018-04-13 18:00:00" --duration 10000 --MATLAB');

    CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 40000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));

    % EPBI 1/21/2018
    % CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 04:40:10" --duration 30 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    
    % EPBI 2/10/2018
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:22:15" --duration 50 --MATLAB', Prefix, ymd(i,:), ymd(i,:));

    % Topoff
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 30000 --MATLAB', Prefix, ymd(i,:), ymd(i,:));

    % BPM local
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 26400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    
    % 460 seconds (7.7 minutes) to read 24 hours at 10 Hz, 865877 points
    % 221 seconds (3.6 minutes) to read 10 hours at 10 Hz, 360782 points
    [Status, Result] = unix(CommandStr);
     

    if Status == 1  % isempty(ds)
        fprintf('   No data (1)\n');
        ds = [];
        return;
    end
    if ~isempty(Result)
        % Only for 2016-11-18_00:00:00.dat.bz2
        %Result(1:436) = [];
        %Result(1:6869) = [];  % SR02C:BPM2/2018-03-26_00:00:00.dat.bz2
        
        d = str2num(Result);
        % d = str2double(Result);
        
        
        
        if 1
            
            % Find time errors
            i = find(diff(d(:,2)) > 1);
            if length(i) > 0
                fprintf('   %d points removed for delta time greater than 1 second.\n', length(i));
            end
            i = [i i+1 i+2];
            d(i,:) = [];

            
            % Matlab format
            SA.Time = [SA.Time; d(:,1)];
            if isempty(SA.t)
                SA.t    = d(:,2);
            else
                SA.t    = [SA.t; SA.t(end)+d(:,2)];
            end
        else
            SA.YMD = d(:,1);
            SA.HMS = d(:,2);
        end
        
        
        SA.X = [SA.X; d(:,3)];
        SA.Y = [SA.Y; d(:,4)];
        SA.Q = [SA.Q; d(:,5)];
        SA.S = [SA.S; d(:,6)];
        SA.ADCpeak = [SA.ADCpeak; d(:,7:10)];
        SA.RFmag   = [SA.RFmag;d(:,11:14)];
        SA.PTLmag  = [SA.PTLmag;d(:,15:18)];
        SA.PTHmag  = [SA.PTHmag;d(:,19:22)];
        SA.Gain    = [SA.Gain; d(:,23:26)];
        SA.Xrms10k = [SA.Xrms10k;d(:,27)];
        SA.Yrms10k = [SA.Yrms10k;d(:,28)];
        SA.Xrms200 = [SA.Xrms200;d(:,29)];
        SA.Yrms200 = [SA.Yrms200;d(:,30)];
        
    else
        ds = [];
        fprintf('   No data (2)\n');
        return
    end
    toc
end



%
if SA.Gain(1,1) >3
    SA.Gain = SA.Gain / 4;
end


% Compute the PT x/y/s and plot???
% A 3  4
% C 2  3
% B 1  2
% D 0  1
Kx = 16;
Ky = 16;

%x(1,i) = Kx * (Arms(1,i)-Brms(1,i)-Crms(1,i)+Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
%y(1,i) = Ky * (Arms(1,i)+Brms(1,i)-Crms(1,i)-Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm

A = SA.PTLmag(:,4);
B = SA.PTLmag(:,2);
C = SA.PTLmag(:,3);
D = SA.PTLmag(:,1);

SA.PTLx = Kx * (A - B - C + D) ./ (A + B + C + D ); % mm
SA.PTLy = Ky * (A + B - C - D) ./ (A + B + C + D ); % mm

A = SA.PTHmag(:,4);
B = SA.PTHmag(:,2);
C = SA.PTHmag(:,3);
D = SA.PTHmag(:,1);

SA.PTHx = Kx * (A - B - C + D) ./ (A + B + C + D ); % mm
SA.PTHy = Ky * (A + B - C - D) ./ (A + B + C + D ); % mm

% Compute without PT
% Note: RFmag appears to be scaled to the PT
A = SA.RFmag(:,4) ./ SA.Gain(:,4);
B = SA.RFmag(:,2) ./ SA.Gain(:,2);
C = SA.RFmag(:,3) ./ SA.Gain(:,3);
D = SA.RFmag(:,1) ./ SA.Gain(:,1);

SA.X_NoPT = Kx * (A - B - C + D) ./ (A + B + C + D ); % mm
SA.Y_NoPT = Ky * (A + B - C - D) ./ (A + B + C + D ); % mm

% Recompute the gain (from PT removed data)
[m,iLo] = min(SA.PTLmag(1,:));
[m,iHi] = min(SA.PTHmag(1,:));
fprintf('Lo min %d   Hi min %d\n', iLo, iHi);

if 1
    SA.Gain2(:,4) = ((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,4)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,4))) / 2;
    SA.Gain2(:,2) = ((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,2)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,2))) / 2;
    SA.Gain2(:,3) = ((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,3)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,3))) / 2;
    SA.Gain2(:,1) = ((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,1)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,1))) / 2;
else
    SA.Gain2(:,4) = round(((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,4)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,4))) / 2, 5);
    SA.Gain2(:,2) = round(((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,2)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,2))) / 2, 5);
    SA.Gain2(:,3) = round(((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,3)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,3))) / 2, 5);
    SA.Gain2(:,1) = round(((SA.PTLmag(:,iLo) ./ SA.PTLmag(:,1)) + (SA.PTHmag(:,iHi) ./ SA.PTHmag(:,1))) / 2, 5);
end
%SA.Gain2(:,4) = ((SA.PTLmag(1,4) ./ SA.PTLmag(:,4)) + (SA.PTHmag(1,4) ./ SA.PTHmag(:,4))) / 2;
%SA.Gain2(:,2) = ((SA.PTLmag(1,2) ./ SA.PTLmag(:,2)) + (SA.PTHmag(1,2) ./ SA.PTHmag(:,2))) / 2;
%SA.Gain2(:,3) = ((SA.PTLmag(1,3) ./ SA.PTLmag(:,3)) + (SA.PTHmag(1,3) ./ SA.PTHmag(:,3))) / 2;
%SA.Gain2(:,1) = ((SA.PTLmag(1,1) ./ SA.PTLmag(:,1)) + (SA.PTHmag(1,1) ./ SA.PTHmag(:,1))) / 2;

A = A .* SA.Gain2(:,4);
B = B .* SA.Gain2(:,2);
C = C .* SA.Gain2(:,3);
D = D .* SA.Gain2(:,1);

SA.XX = Kx * (A - B - C + D) ./ (A + B + C + D ); % mm
SA.YY = Ky * (A + B - C - D) ./ (A + B + C + D ); % mm


% Re-compute with PT
% A = SA.RFmag(:,4);
% B = SA.RFmag(:,2);
% C = SA.RFmag(:,3);
% D = SA.RFmag(:,1);
% SA.X_Check = Kx * (A - B - C + D) ./ (A + B + C + D ); % mm
% SA.Y_Check = Ky * (A + B - C - D) ./ (A + B + C + D ); % mm


%%
if SA.t(end) > 6*60*60
    % Hours
    SA.t = SA.t / 60 / 60;
    XLabelString = 'Time [Hours]';
elseif SA.t(end) > 20*60
    % Minutes
    SA.t = SA.t / 60;
    XLabelString = 'Time [Minutes]';
else
    XLabelString = 'Time [Seconds]';
end



%%  Plotting

if 1
    ii = find(SA.S < 5e5);
    SA.X(ii)  = NaN;
    SA.XX(ii) = NaN;
    SA.Y(ii)  = NaN;
    SA.YY(ii) = NaN;
    SA.X_NoPT(ii) = NaN;
    SA.Y_NoPT(ii) = NaN;
    %SA.X_Check(ii,:) = NaN;
    %SA.Y_Check(ii,:) = NaN;

    SA.Q(ii) = NaN;
    
    SA.Gain(ii,:) = NaN;
    SA.Gain2(ii,:) = NaN;    
    
    ii = find(SA.S < 1e7);
    SA.Xrms200(ii,:) = NaN;
    SA.Yrms200(ii,:) = NaN;
    SA.Xrms10k(ii,:) = NaN;
    SA.Yrms10k(ii,:) = NaN;
end

% Xoff = mean(SA.X_NoPT(1:1000));
% Yoff = mean(SA.Y_NoPT(1:1000));


h = [];

% X or XX???
FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(2,1,1);
%plot(SA.t, SA.X_NoPT - SA.X_NoPT(1) + SA.X(1),'g');
%hold on
plot(SA.t, SA.X , 'b');
hold off
ylabel('X [mm]');
title(sprintf('%s Orbits with the PT Compensation Off (blue) /On (red)', Prefix));
%yaxis([-.002 .002]+SA.X(1));

h(length(h)+1,1) = subplot(2,1,2);
%plot(SA.t, SA.Y_NoPT - SA.Y_NoPT(1) + SA.Y(1),'g');
%hold on
plot(SA.t, SA.Y, 'b');
hold off
ylabel('Y [mm]');
xlabel(XLabelString);
%yaxis([-.002 .002]+SA.Y(1));

% FigNum = FigNum + 1;
% figure(FigNum);
% clf reset
% h(length(h)+1,1) = subplot(2,1,1);
% plot(SA.t, SA.X_NoPT-SA.X_NoPT(1));
% ylabel('X [mm]');
% title('Orbits with the PT gain removed from RF Mag');
% h(length(h)+1,1) = subplot(2,1,2);
% plot(SA.t, SA.Y_NoPT-SA.Y_NoPT(1));
% ylabel(' Y [mm]');
% xlabel(XLabelString);

FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(4,1,1);
plot(SA.t, SA.Gain2(:,1), 'r');
hold on
plot(SA.t, SA.Gain(:,1), 'b');
hold off
title('Gain');
h(length(h)+1,1) = subplot(4,1,2);
plot(SA.t, SA.Gain2(:,2), 'r');
hold on
plot(SA.t, SA.Gain(:,2), 'b');
hold off
h(length(h)+1,1) = subplot(4,1,3);
plot(SA.t, SA.Gain2(:,3), 'r');
hold on
plot(SA.t, SA.Gain(:,3), 'b');
hold off
h(length(h)+1,1) = subplot(4,1,4);
plot(SA.t, SA.Gain2(:,4), 'r');
hold on
plot(SA.t, SA.Gain(:,4), 'b');
hold off
xlabel(XLabelString);

FigNum = FigNum + 1;
figure(FigNum);
clf reset
if 1
    h(length(h)+1,1) = subplot(1,1,1);
    plot(SA.t, SA.ADCpeak)
    title(sprintf('%s ADC Peaks', Prefix));
    xlabel(XLabelString);
else
    h(length(h)+1,1) = subplot(2,2,1);
    plot(SA.t, SA.ADCpeak(:,1));
    h(length(h)+1,1) = subplot(2,2,2);
    plot(SA.t, SA.ADCpeak(:,2));
    h(length(h)+1,1) = subplot(2,2,3);
    plot(SA.t, SA.ADCpeak(:,3));
    h(length(h)+1,1) = subplot(2,2,4);
    plot(SA.t, SA.ADCpeak(:,4));
    xlabel(XLabelString);
    addlabel(.5, 1, 'ADC Peaks');
end

%linkaxes(h, 'x');
%return


% FigNum = FigNum + 1;
% figure(FigNum);
% clf reset
% h(length(h)+1,1) = subplot(2,1,1);
% plot(SA.t, SA.X-mean(SA.X(1:1000)));
% hold on
% plot(SA.t, SA.XX-mean(SA.XX(1:1000)), 'r')
% hold off
% title(sprintf('%s Orbit', Prefix));
% ylabel('X [mm]');
% h(length(h)+1,1) = subplot(2,1,2);
% plot(SA.t, SA.Y-mean(SA.Y(1:1000)));
% hold on
% plot(SA.t, SA.YY-mean(SA.YY(1:1000)), 'r')
% hold off
% ylabel('Y [mm]');
% xlabel(XLabelString);

FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(2,1,1);
plot(SA.t, SA.PTLx);
ylabel('Lower PT X [mm]');
h(length(h)+1,1) = subplot(2,1,2);
plot(SA.t, SA.PTLy);
ylabel('Lower PT Y [mm]');
xlabel(XLabelString);

FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(2,1,1);
plot(SA.t, SA.PTHx);
ylabel('Upper PT X [mm]');
h(length(h)+1,1) = subplot(2,1,2);
plot(SA.t, SA.PTHy);
ylabel('Upper PT Y [mm]');
xlabel(XLabelString);

FigNum = FigNum + 1;
figure(FigNum);
clf reset

% Note: RFmag appears to be scaled to the PT
A = SA.RFmag(:,4) ./ SA.Gain(:,4);
B = SA.RFmag(:,2) ./ SA.Gain(:,2);
C = SA.RFmag(:,3) ./ SA.Gain(:,3);
D = SA.RFmag(:,1) ./ SA.Gain(:,1);

if 0
    h(length(h)+1,1) = subplot(1,1,1);
    %plot(SA.t, SA.RFmag)
    plot(SA.t, [A B C D]);
    title('RF Magnitude');
    xlabel(XLabelString);
else
    h(length(h)+1,1) = subplot(4,1,1);
    %plot(SA.t, SA.RFmag(:,1), 'g');
    %hold on
    plot(SA.t, A, 'b');
    title('RF Magnitude');
    h(length(h)+1,1) = subplot(4,1,2);
    %plot(SA.t, SA.RFmag(:,2), 'g');
    %hold on
    plot(SA.t, B, 'b');
    h(length(h)+1,1) = subplot(4,1,3);
    %plot(SA.t, SA.RFmag(:,3), 'g');
    %hold on
    plot(SA.t, C, 'b');
    h(length(h)+1,1) = subplot(4,1,4);
    %plot(SA.t, SA.RFmag(:,4), 'g');
    %hold on
    plot(SA.t, D, 'b');
    xlabel(XLabelString);
end

FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(2,1,1);
plot(SA.t, SA.PTHx - SA.PTHx(1), 'b');
hold on
plot(SA.t, SA.PTLx - SA.PTLx(1), 'g');
hold off
title('Pilot Tone Orbits');
h(length(h)+1,1) = subplot(2,1,2);
plot(SA.t, SA.PTHy - SA.PTHy(1), 'b');
hold on
plot(SA.t, SA.PTLy - SA.PTLy(1), 'g');
hold off
xlabel(XLabelString);


FigNum = FigNum + 1;
figure(FigNum);
clf reset
if 0
    h(length(h)+1,1) = subplot(1,1,1);
    plot(SA.t, SA.PTLmag)
    title('Pilot Tone Low');
    xlabel(XLabelString);
else
    h(length(h)+1,1) = subplot(4,1,1);
    plot(SA.t, SA.PTLmag(:,1));
    title('Pilot Tone Low');
    h(length(h)+1,1) = subplot(4,1,2);
    plot(SA.t, SA.PTLmag(:,2));
    h(length(h)+1,1) = subplot(4,1,3);
    plot(SA.t, SA.PTLmag(:,3));
    h(length(h)+1,1) = subplot(4,1,4);
    plot(SA.t, SA.PTLmag(:,4));
    xlabel(XLabelString);
end

FigNum = FigNum + 1;
figure(FigNum);
clf reset
if 0
    h(length(h)+1,1) = subplot(1,1,1);
    plot(SA.t, SA.PTHmag)
    title('Pilot Tone High');
    xlabel(XLabelString);
else
    h(length(h)+1,1) = subplot(4,1,1);
    plot(SA.t, SA.PTHmag(:,1));
    title('Pilot Tone High');
    h(length(h)+1,1) = subplot(4,1,2);
    plot(SA.t, SA.PTHmag(:,2));
    h(length(h)+1,1) = subplot(4,1,3);
    plot(SA.t, SA.PTHmag(:,3));
    h(length(h)+1,1) = subplot(4,1,4);
    plot(SA.t, SA.PTHmag(:,4));
    xlabel(XLabelString);
end


FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(4,1,1);
plot(SA.t, SA.Xrms10k);
title('RMS');
ylabel('X 10 kHz[\mum]');
h(length(h)+1,1) = subplot(4,1,2);
plot(SA.t, SA.Yrms10k);
ylabel('Y 10 kHz[\mum]');
h(length(h)+1,1) = subplot(4,1,3);
plot(SA.t, SA.Xrms200);
ylabel('X 200 Hz[\mum]');
h(length(h)+1,1) = subplot(4,1,4);
plot(SA.t, SA.Yrms200);
ylabel('Y 200 Hz[\mum]');
xlabel(XLabelString);

FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(2,1,1);
plot(SA.t, SA.S);
ylabel('Sum');
h(length(h)+1,1) = subplot(2,1,2);
plot(SA.t, SA.Q);
ylabel('Q');
xlabel(XLabelString);

% if 1
% FigNum = FigNum + 4;
% figure(FigNum);
% clf reset
% h(length(h)+1,1) = subplot(1,1,1);
% plot(SA.t, SA.PTLmag./SA.PTLmag(1,:), 'r')
% hold on
% plot(SA.t, SA.RFmag./SA.RFmag(1,:),'b')
% %axis([0 400 .9988 1.0004]);
% title('SA Data, Gain change from the first point,  RF Mag (blue), Lower PT (red)')
% xlabel(XLabelString);
% else
% FigNum = FigNum + 2;
% figure(FigNum);
% clf reset
% h(length(h)+1,1) = subplot(1,1,1);
% plot(SA.t, SA.PTHmag./SA.PTHmag(1,:), 'r')
% hold on
% plot(SA.t, SA.RFmag./SA.RFmag(1,:),'b')
% %axis([0 400 .9988 1.0004]);
% title('SA Data, Gain change from the first point,  RF Mag (blue), Upper PT (red)')
% xlabel(XLabelString);
% end

linkaxes(h, 'x');

% figure(182)
% clf reset
% plot(SA.t, SA.ADC(:,3)/ 3276.8, 'b');
% hold on
% plot(SA.t, SA.DAC(:,3)/ 3276.8, 'g');
% hold off
% title(sprintf('IRM %d  %d Seconds', IRM, T_Sec(end)));
% ylabel('[Volts]');
% xlabel(sprintf('Time from %s  [Seconds]', T_Date));
% legend('ADC3','DAC3');



% if 1
%     %T_Date = '2015-03-23 10:00:00';
%     %T_Date = '2015-03-23 11:00:00';
%     %T_Date = '2015-03-23 15:21:00';
%     %T_Date = '2015-03-23 10:55:00';
%     T_Date = '2016-04-28 22:09:00';
%     T_Sec  = 3*60;
%     CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "%s" --irm %d --duration %d --MATLAB', T_Date, IRM, T_Sec);
% else
%     % SHF issue
%     %  [a,t]=getpvonline(['irm:053:ADC0';'irm:053:ADC1'], 0:.02:60)
%     IRM = 53;
%     T_Date = '2015-05-17 00:00:00';
%     T_Sec  = 60*60;
%     CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "%s" --irm %d --duration %d --MATLAB', T_Date, IRM, T_Sec);
% end


