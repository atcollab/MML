function [PxxAvg, fx, XAvgrms, PxxAvg_int, PyyAvg, fy, YAvgrms, PyyAvg_int] = getbpmpsd(DeviceList, Navg, LineColor)
%  [PxxAvg, fx, XAvgrms, PxxAvg_int, PyyAvg, fy, YAvgrms, PyyAvg_int] = getbpmpsd(DeviceList, Navg, LineColor)
%
%  Program to analyze BPM power spectrum 
%
%  INPUTS
%  1. DeviceList
%  2. Navg {10}
%  3. LineColor = 'b'
%
%  OUTPUT
%  1. PxxAvg     = displacement power spectrum  [(m)^2/Hz]
%  2. fx         = frequency vector [Hz]
%  3. XAvgrms    = RMS deplacement [m]
%  4. PxxAvg_int = Integrated RMS deplacement squared [m^2]
%  5-8. Vertical
%
%  If not outputs exist, a file is automatically created in the current directory named according to the BPM device list
%
%  Written by Greg Portmann


if nargin < 1
    DeviceList = [1 1];
end
if nargin < 2
    Navg = 10;
end
if nargin < 3
    LineColor = 'b';
end

FileName =  sprintf('BPM%d_%d', DeviceList');

NumFreqRemove = 2;

RF = getrf;

a = getbpm4k(DeviceList)
%a = mcagetbpm4k(DeviceList);
a = squeeze(a(:,1,:));

i = 1;
figure(1);
[Pxx, fx, Xrms, Pxx_int] = bpm_psd(a(1,:));
figure(2);
[Pyy, fy, Yrms, Pyy_int] = bpm_psd(a(2,:));
PxxAvg = Pxx;
PyyAvg = Pyy;

% BPMx(:,i) = a(1,:)';
% BPMy(:,i) = a(2,:)';
% BPMs(:,i) = a(3,:)';
% BPMq(:,i) = a(4,:)';

N = length(a(1,:));
T1 = 1/4000; % Sample period

for j=1:NumFreqRemove
    Pxx(j,i) = 0;
    Pyy(j,i) = 0;
    PxxAvg(j) = 0;
    PyyAvg(j) = 0;
end

PxxAvg_int = cumsum(PxxAvg) / N / T1;
PyyAvg_int = cumsum(PyyAvg) / N / T1;

XAvgrms(1,i) = sqrt(max(PxxAvg_int));
YAvgrms(1,i) = sqrt(max(PyyAvg_int));

DCCT(1,i) = getdcct;

if nargout == 0
    save(FileName);
end

fprintf('   %d.  Xrms = %.4f    Yrms = %.4f microns\n', i , 1e6*XAvgrms(1,i), 1e6*YAvgrms(1,i));
drawnow;


for i = 2:Navg
    a = getbpm4k(DeviceList);
    %a = mcagetbpm4k(DeviceList);
    
    a = squeeze(a(:,1,:));

    figure(1);
    [Pxx(:,i), fx, Xrms(1,i), Pxx_int] = bpm_psd(a(1,:));
    figure(2);
    [Pyy(:,i), fy, Yrms(1,i), Pyy_int] = bpm_psd(a(2,:));
    PxxAvg = ((i-1)*PxxAvg + Pxx(:,i)) / i;
    PyyAvg = ((i-1)*PyyAvg + Pyy(:,i)) / i;

    %BPMx(:,i) = a(1,:)';
    %BPMy(:,i) = a(2,:)';
    %BPMs(:,i) = a(3,:)';
    %BPMq(:,i) = a(4,:)';

    N = length(a(1,:));
    T1 = 1/4000; % Sample period

    for j=1:NumFreqRemove
        Pxx(j,i) = 0;
        Pyy(j,i) = 0;
        PxxAvg(j) = 0;
        PyyAvg(j) = 0;
    end
   
    PxxAvg_int = cumsum(PxxAvg) / N / T1;
    PyyAvg_int = cumsum(PyyAvg) / N / T1;

    XAvgrms(1,i) = sqrt(max(PxxAvg_int));
    YAvgrms(1,i) = sqrt(max(PyyAvg_int));
    
    DCCT(1,i) = getdcct;

    fprintf('   %d.  Xrms = %.4f    Yrms = %.4f microns\n', i , 1e6*XAvgrms(1,i), 1e6*YAvgrms(1,i));
    drawnow;

    if nargout == 0
        save(FileName);
    end

    % Plot the power spectrum
    figure(3);
    subplot(2,2,1);
    loglog(fx(NumFreqRemove+1:N/2), 1e12*Pxx(NumFreqRemove+1:N/2),'r'); 
    hold on
    loglog(fx(NumFreqRemove+1:N/2), 1e12*PxxAvg(NumFreqRemove+1:N/2), LineColor); 
    hold off
    title(sprintf('BPMx(%d,%d) POWER SPECTRUM (%d points)',DeviceList,N));
    xlabel('Frequency [Hz]');
    ylabel('BPMx PSD [\mum^2/Hz]');
    grid on;
    legend off;
    aa=axis;
    axis([1 2000 1e-3 10]);
    %axis([1 2000 aa(3) aa(4)]);
    yaxis([1e-4 1])

    % Position spectrum
    subplot(2,2,3);
    semilogx(fx(NumFreqRemove:N/2), 1e12*PxxAvg_int(NumFreqRemove:N/2), LineColor); 
    hold on
    semilogx(fx(NumFreqRemove:N/2), 1e12*Pxx_int(NumFreqRemove:N/2), 'r'); 
    hold off
    title(sprintf('BPMx(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList,1e6*XAvgrms(i)));
    xlabel('Frequency [Hz]');
    ylabel('Mean Square Displacement [\mum^2]');
    grid on;
    legend off;
    aa=axis;
    axis([1 2000 aa(3) aa(4)]);

    subplot(2,2,2);
    loglog(fy(NumFreqRemove+1:N/2), 1e12*Pyy(NumFreqRemove+1:N/2),'r'); 
    hold on
    loglog(fy(NumFreqRemove+1:N/2), 1e12*PyyAvg(NumFreqRemove+1:N/2), LineColor); 
    hold off
    title(sprintf('BPMy(%d,%d) POWER SPECTRUM (%d points)',DeviceList,N));
    xlabel('Frequency [Hz]');
    ylabel('BPMy PSD [\mum^2/Hz]');
    grid on;
    legend off;
    aa=axis;
    %axis([1 2000 aa(3) aa(4)]);
    axis([1 2000 1e-3 10]);
    yaxis([1e-4 1])

    % Position spectrum
    subplot(2,2,4);
    semilogx(fy(NumFreqRemove:N/2), 1e12*PyyAvg_int(NumFreqRemove:N/2), LineColor); 
    hold on
    semilogx(fy(NumFreqRemove:N/2), 1e12*Pyy_int(NumFreqRemove:N/2), 'r'); 
    hold off
    title(sprintf('BPMy(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList,1e6*YAvgrms(i)));
    xlabel('Frequency [Hz]');
    ylabel('Mean Square Displacement [\mum^2]');
    grid on;
    legend off;
    aa=axis;
    axis([1 2000 aa(3) aa(4)]);
    
    drawnow;

end



%semilogx(fx(NumFreqRemove:N/2), sqrt(PxxAvg_int(NumFreqRemove:N/2)), LineColor);
%semilogx(fy(NumFreqRemove:N/2), sqrt(PyyAvg_int(NumFreqRemove:N/2)), LineColor);
