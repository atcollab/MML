function [Pyy, fy, Pyy_Int, FileName] = plotbpmpsd(FileName, LineColorInput, HoldFlag1)
%PLOTBPMPSD - Plots data taken will getbpmpsd
%  [Pxx, f, PxxInt, FileName] = plotbpmpsd(FileName, LineType, HoldFlag)
%
%  INPUTS
%  1. FileName - Filename or '' to browse
%  2. LineType - Line type, like '-r' 
%  3. HoldFlag - 0   -> new plot
%               else -> hold last plot 
%
%  OUTPUTS
%  1. Pxx - Power spectrum
%  2. f - Frequency vector 
%  3. PxxInt - Cumulated integrated power spectrum
%  4. FileName - Filename used
%
%   Written by Greg Portmann


if nargin < 1
    FileName = [];
end
if nargin < 2
    LineColorInput = 'b';
end
if nargin < 3
    HoldFlag1 = 0;
end

if isempty(FileName)
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load');
    if FileName == 0
        return
    else
        load([DirectoryName FileName]);
    end
else
    load(FileName);
end

if exist('PxxAvg', 'var')
    Pxx = PxxAvg;
    Pyy = PyyAvg;
    Xrms = XAvgRMS;
    Yrms = YAvgRMS;
end

newList = editlist(DeviceList, 'BPM', zeros(size(DeviceList,1),1));
if isempty(newList)
    return
end
j = findrowindex(newList(1,:), DeviceList);

if ~HoldFlag1
    clf reset
end

subplot(2,2,1);
if HoldFlag1
    hold on;
end
NumFreqRemove = length(find(Pxx(j,:)==0));
loglog(fx(NumFreqRemove+1:end), 1e12*Pxx(j,NumFreqRemove+1:end), LineColorInput); 
if HoldFlag1
    title(sprintf('BPMx POWER SPECTRUM (%d points)',length(fx)));
else
    title(sprintf('BPMx(%d,%d) POWER SPECTRUM (%d points)',DeviceList(j,:),length(fx)));
end
xlabel('Frequency [Hz]');
ylabel('BPMx PSD [\mum^2/Hz]');
grid on;
legend off;
%aa=axis;
%axis([1 2000 aa(3) aa(4)]);
axis([1 2000 1e-3 10]);

% Position spectrum
subplot(2,2,3);
if HoldFlag1
    hold on;
end
semilogx(fx(NumFreqRemove:end), 1e12*Pxx_Int(j,NumFreqRemove:end), LineColorInput); 
if HoldFlag1
    title(sprintf('BPMx Integrated PSD'));
else
    title(sprintf('BPMx(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList(j,:),1e6*Xrms(end)));
end
xlabel('Frequency [Hz]');
ylabel('Mean Square Displacement [\mum^2]');
grid on;
legend off;
aa=axis;
axis([1 2000 aa(3) aa(4)]);

subplot(2,2,2);
if HoldFlag1
    hold on;
end
loglog(fy(NumFreqRemove+1:end), 1e12*Pyy(j,NumFreqRemove+1:end), LineColorInput); 
if HoldFlag1
    title(sprintf('BPMy POWER SPECTRUM (%d points)',length(fy)));
else
    title(sprintf('BPMy(%d,%d) POWER SPECTRUM (%d points)',DeviceList(j,:),length(fy)));
end
xlabel('Frequency [Hz]');
ylabel('BPMy PSD [\mum^2/Hz]');
grid on;
legend off;
%aa=axis;
%axis([1 2000 aa(3) aa(4)]);
axis([1 2000 1e-3 10]);

% Position spectrum
subplot(2,2,4);
if HoldFlag1
    hold on;
end
semilogx(fy(NumFreqRemove:end), 1e12*Pyy_Int(j,NumFreqRemove:end), LineColorInput); 
if HoldFlag1
    title(sprintf('BPMy Integrated PSD'));
else
    title(sprintf('BPMy(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList(j,:),1e6*Yrms(end)));
    addlabel(1,0,datestr(TimeStart));
end
xlabel('Frequency [Hz]');
ylabel('Mean Square Displacement [\mum^2]');
grid on;
legend off;
aa=axis;
axis([1 2000 aa(3) aa(4)]);

