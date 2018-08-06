function [ds, Status] = getirmarchive(IRM)
% GETIRMARCHIVE
% 
% python /vxboot/siocirm/boot/scripts/showLog.py -h
%
% usage: showLog.py [-h] [-b BEGIN] [-d DURATION] [-s SPARSE] [-i IRM]
%                   [-l LOGDIR] [-U] [-M]
%                   [filename [filename ...]]
% 
% Show log file as ASCII table.
% 
% positional arguments:
%   filename
% 
% optional arguments:
%   -h, --help            show this help message and exit
%   -b BEGIN, --begin BEGIN
%                         Begin date/time (YYY-MM-DD HH:MM[:SS] [TZ]),
%                         default=beginning of time
%   -d DURATION, --duration DURATION
%                         duration (seconds), default=10
%   -s SPARSE, --sparse SPARSE
%                         sparsing factor, default=1
%   -i IRM, --irm IRM     IRM number
%   -l LOGDIR, --logdir LOGDIR
%                         log directoryCommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 09:30:00" --irm %d --duration 60 --MATLAB', IRM);

%   -U, --UTC             Show times in UTC rather than local time zone
%   -M, --MATLAB          First columns are seconds and delta seconds. Easier to
%                         read into MATLAB/Octave
% 
% The --irm and --logdir options are ignored if one
% or or more filename arguments are present.
% 
% To avoid ambiguity at the autumnal DST change the 'begin' time
% may be followed by a time zone specifier (PST, PDT or UTC).
% 
% Columns:
%    1 - ISO-format date YYYY-MM-DD
%    2 - ISO-format time HH-MM-SS.xxx
%    3 - Time source (0-IRM, 1-IOC)
%    4 - +5V current (mA)
%    5 - Module temperature (degrees C)
%    6 - IRM #
%    7 - Status bits [1]-Calibrated, [0]-Power good
%    8 - DAC 0
%    9 - DAC 1
%   10 - DAC 2
%   11 - DAC 3
%   12 - ADC 0
%   13 - ADC 1
%   14 - ADC 2
%   15 - ADC 3
%   16 - Booleans
%
%
% NOTES
% 1. Python script written by Eric Norum
% 2. Make sure you're using python 2.7.1 or higher
% 3. Volts = ADC / 3276.8

%    Val = ESLO * Volts + EOFF
%

if nargin < 1
    IRM = 1;   % Gun Bias
    %IRM = 14;   % Mod I, HV
    %IRM = 37;    % 37-BR KE
    %IRM = 73;    % 73-DCCT (old)
    %IRM = 88;    % 88-DCCT (new)
    %IRM = 84;    % 84-BBPM  %51;
end

%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 09:30:00" --irm %d --duration 60 --MATLAB', IRM);

% python /vxboot/siocirm/boot/scripts/showLog.py -b "2013-04-02 15:00:00" -i 51 -d 0.1 -M
% python /vxboot/siocirm/boot/scripts/showLog.py --begin "2013-04-02 15:00:00" --irm 51 --duration 0.1 --MATLAB

%CommandStr = sprintf('python /vxboot/siocirm/boot/scripts/showLog.py --begin "2013-04-02 15:00:00" --irm %d --duration 0.1 --MATLAB', IRM);

% Beam bump
%CommandStr = sprintf('python /vxboot/siocirm/boot/scripts/showLog.py --begin "2013-04-12 12:35:00" --irm %d --duration 300.0 --MATLAB', IRM);
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2013-05-13 13:33:00" --irm %d --duration 1.0 --MATLAB', IRM);

%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2013-07-18 23:46:34" --irm %d --duration 30.0 --MATLAB', IRM);

% BPM FOFB on/off
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2013-11-27 10:30:00" --irm %d --duration 60.0 --MATLAB', IRM);

%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2013-12-05 10:00:00" --irm %d --duration 60.0 --MATLAB', IRM);

% 
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-02-10 11:28:00" --irm %d --duration 600 --MATLAB', IRM);

%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-25 16:15:00" --irm %d --duration 60 --MATLAB', IRM);
%fan on 100mA
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 09:30:00" --irm %d --duration 60 --MATLAB', IRM);
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 09:40:00" --irm %d --duration 60 --MATLAB', IRM);

% fan off, 100mA
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 10:30:00" --irm %d --duration 60 --MATLAB', IRM);
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 10:40:00" --irm %d --duration 60 --MATLAB', IRM);

% fan on 100 mA
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 11:05:00" --irm %d --duration 60 --MATLAB', IRM);
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 11:10:00" --irm %d --duration 60 --MATLAB', IRM);
% two downstream fans off  100 mA
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 12:05:00" --irm %d --duration 60 --MATLAB', IRM);
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-07-27 12:10:00" --irm %d --duration 60 --MATLAB', IRM);

% Big 60 Hz
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2014-02-07 10:00:00" --irm %d --duration 60.0 --MATLAB', IRM);

% Vacuum leak
%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2013-11-25 1:00:00" --irm %d --duration 30.0 --MATLAB', IRM);


%CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "2015-03-23 11:00:00" --irm %d --duration 180 --MATLAB', IRM);

if 1
    %T_Date = '2015-03-23 10:00:00';
    %T_Date = '2015-03-23 11:00:00';
    %T_Date = '2015-03-23 15:21:00';
    %T_Date = '2015-03-23 10:55:00';
    T_Date = '2016-04-28 22:09:00';
    T_Sec  = 3*60;
    CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "%s" --irm %d --duration %d --MATLAB', T_Date, IRM, T_Sec);
else
    % SHF issue
    %  [a,t]=getpvonline(['irm:053:ADC0';'irm:053:ADC1'], 0:.02:60)
    IRM = 53;
    T_Date = '2015-05-17 00:00:00';
    T_Sec  = 60*60;
    CommandStr = sprintf('python /vxboot/siocirm/head/scripts/showLog.py --begin "%s" --irm %d --duration %d --MATLAB', T_Date, IRM, T_Sec);
end




[Status, Result] = unix(CommandStr);

if ~isempty(Result)
    
    d = str2num(Result);
    
    if 1
        % Matlab format
        ds.Time = d(:,1);
        ds.t = d(:,2);
    else
        ds.YMD = d(:,1);
        ds.HMS = d(:,2);
    end
    ds.TimeSource = d(:,3);
    ds.WallCurrent = d(:,4);  % mA
    ds.Temperature = d(:,5);
    ds.IRM = d(:,6);
    ds.Status = d(:,7);
    ds.DAC = d(:,8:11);
    ds.ADC = d(:,12:15);
    ds.Booleans = d(:,16);
    ds.Binary = dec2bin(ds.Booleans, 24);

    for i = 0:size(ds.Binary,2)-1
        ds.(sprintf('B%d',i)) = ds.Binary(:,size(ds.Binary,2)-i)*1 - 48;
    end
else
    ds = [];
end


% Calibrate counts to volts or engineering units?


% Note: 
% ASLO = 1.907348632812500e-05
% 1 / (3276.8 * 1.907348632812500e-05) = 16


%  Plotting

% Volts
figure;
clf reset
subplot(2,2,1)
plot(ds.t, ds.ADC(:,1)/ 3276.8);
subplot(2,2,2)
plot(ds.t, ds.ADC(:,2)/ 3276.8);
subplot(2,2,3)
plot(ds.t, ds.ADC(:,3)/ 3276.8);
subplot(2,2,4)
plot(ds.t, ds.ADC(:,4)/ 3276.8);

figure(103)
clf reset
plot(ds.t, ds.ADC(:,3)/ 3276.8, 'b');
hold on
plot(ds.t, ds.DAC(:,3)/ 3276.8, 'g');
hold off
title(sprintf('IRM %d  %d Seconds', IRM, T_Sec(end)));
ylabel('[Volts]');
xlabel(sprintf('Time from %s  [Seconds]', T_Date));
legend('ADC3','DAC3');


% % Bias voltage plot, IRM001
% figure(101);
% clf reset
% plot(a.t-26.2-.0705, 6*a.ADC(:,2)/3276.8+20);
% axis([-.2 1.2 34.5 41]);
% grid on
% xlabel('Time [Seconds]');
% ylabel('EG______BIAS___AM01');




