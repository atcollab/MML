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

if nargin < 2
    FigNum = 1;
end


Prefix = 'SR10C:BPM8';  

ymd = [
    2018 01 20
    2018 01 21 % EPBI trip at ~4am
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
    
    % Build the command
    if 1
        % Via mounted drive: apps2, apps3, phys1, ...
        CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
        %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /bpm01-SSD/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 26400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
        
    else
        
        % BPM local
        CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 86400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
        %CommandStr = sprintf('/home/als/physbase/machine/ALS/Common/BPM/showLog.py /archive/BPMLOG/%s/%02d-%02d-%02d_00:00:00.dat.bz2 --begin "%02d-%02d-%02d 00:00:00" --duration 26400 --MATLAB', Prefix, ymd(i,:), ymd(i,:));
    end
    
    % Get the data
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
        
        d = str2num(Result);
        % d = str2double(Result);
        
        if 1
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


% Compute the PT x/y/s and plot
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
    ii = find(SA.S < 500000);
    SA.X(ii)  = NaN;
    SA.XX(ii) = NaN;
    SA.Y(ii)  = NaN;
    SA.YY(ii) = NaN;
    SA.X_NoPT(ii) = NaN;
    SA.Y_NoPT(ii) = NaN;
    SA.Gain(ii,:) = NaN;
    SA.Gain2(ii,:) = NaN;
    %SA.X_Check(ii,:) = NaN;
    %SA.Y_Check(ii,:) = NaN;
end

% Xoff = mean(SA.X_NoPT(1:1000));
% Yoff = mean(SA.Y_NoPT(1:1000));


h = [];

% X or XX???
FigNum = FigNum + 1;
figure(FigNum);
clf reset
h(length(h)+1,1) = subplot(2,1,1);
plot(SA.t, SA.X_NoPT - SA.X_NoPT(1) + SA.X(1));
hold on
plot(SA.t, SA.X , 'r');
hold off
ylabel('X [mm]');
title(sprintf('%s Orbits with the PT Compensation Off (blue) /On (red)', Prefix));
%yaxis([-.002 .002]+SA.X(1));

h(length(h)+1,1) = subplot(2,1,2);
plot(SA.t, SA.Y_NoPT - SA.Y_NoPT(1) + SA.Y(1));
hold on
plot(SA.t, SA.Y, 'r');
hold off
ylabel('Y [mm]');
xlabel(XLabelString);
%yaxis([-.002 .002]+SA.Y(1));

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

linkaxes(h, 'x');




