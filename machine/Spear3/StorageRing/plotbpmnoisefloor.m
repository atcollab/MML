function [f, P] = plotbpmnoisefloor(PlaneString, LineType, HoldFlag)
%PLOTBPMNOISEFLOOR - Plots the BPM 
%  [f, P] = plotbpmnoisefloor(PlotType, LineType, HoldFlag)
%
%  INPUTS
%  1. PlotType - 'x', 'h', or 'Horizontal' - Horizontal power spectrum [microns^2/Hz]  {Default}
%                'y', 'v', or 'Vertical'   - Vertical   power spectrum [microns^2/Hz]
%                'xint', 'hint', or 'HorizontalInt' - Horizontal integrated power spectrum [microns^2]
%                'yint', 'vint', or 'VerticalInt'   - Vertical   integrated power spectrum [microns^2]
%  2. LineType - Line type {Default: '-k'}
%  3. HoldFlag - 0 off, else on
%
%  OUTPUTS
%  1. f - Frequency vector
%  2. P - Power spectrum vector
%
%  NOTE
%  1. The noise floor data is based on measurement data on BPM(8,5) 
%     during a user run at 90 mAmps (20 PSD averages, no window).
%
%  Written by Greg Portmann


% Based on BPM(8,5)
load('BPMNoiseFloor');

if nargin < 1
    PlaneString = 'x';
end
if nargin < 2
    LineType = 'k';
end
if nargin < 3
    HoldFlag = 0;
end


if HoldFlag
    hold on;
end

if any(strcmpi(PlaneString, {'x','h','Horizontal'}))
    % Power spectrum
    f = fx(NumFreqRemove+1:N/2);
    P = 1e12*PxxAvg(NumFreqRemove+1:N/2);
    loglog(f, P, LineType); 
elseif any(strcmpi(PlaneString, {'y','v','Vertical'}))
    % Power spectrum
    f = fy(NumFreqRemove+1:N/2);
    P = 1e12*PyyAvg(NumFreqRemove+1:N/2);
    loglog(f, P, LineType); 
elseif any(strcmpi(PlaneString, {'xint','hint','HorizontalInt'}))
    % Integrated position spectrum
    f = fx(NumFreqRemove:N/2);
    P = 1e12*PxxAvg_Int(NumFreqRemove:N/2);
    semilogx(f, P, LineType); 
elseif any(strcmpi(PlaneString, {'yint','vint','VerticalInt'}))
    % Integrated position spectrum
    f = fy(NumFreqRemove:N/2);
    P = 1e12*PyyAvg_Int(NumFreqRemove:N/2);
    semilogx(f, P, LineType); 
end

if HoldFlag
    hold off;
end


% if HoldFlag
%     title(sprintf('BPMx Integrated PSD'));
% else
%     title(sprintf('BPMx(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList,1e6*XAvgRMS(end)));
% end
% xlabel('Frequency [Hz]');
% ylabel('Mean Square Displacement [\mum^2]');
% grid on;
% legend off;
% aa=axis;
% axis([1 2000 aa(3) aa(4)]);
% 
% subplot(2,2,2);
% if HoldFlag
%     hold on;
% end
% loglog(fy(NumFreqRemove+1:N/2), 1e12*PyyAvg(NumFreqRemove+1:N/2), LineType); 
% if HoldFlag
%     title(sprintf('BPMy POWER SPECTRUM (%d points)',N));
% else
%     title(sprintf('BPMy(%d,%d) POWER SPECTRUM (%d points)',DeviceList,N));
% end
% xlabel('Frequency [Hz]');
% ylabel('BPMy PSD [\mum^2/Hz]');
% grid on;
% legend off;
% %aa=axis;
% %axis([1 2000 aa(3) aa(4)]);
% axis([1 2000 1e-3 10]);
% 
% % Position spectrum
% subplot(2,2,4);
% if HoldFlag
%     hold on;
% end
% semilogx(fy(NumFreqRemove:N/2), 1e12*PyyAvg_Int(NumFreqRemove:N/2), LineType); 
% if HoldFlag
%     title(sprintf('BPMy Integrated PSD'));
% else
%     title(sprintf('BPMy(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList,1e6*YAvgRMS(end)));
% end
% xlabel('Frequency [Hz]');
% ylabel('Mean Square Displacement [\mum^2]');
% grid on;
% legend off;
% aa=axis;
% axis([1 2000 aa(3) aa(4)]);

