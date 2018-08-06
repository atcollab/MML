function [PxxAvg, fx, XAvgRMS, PxxAvg_Int, PyyAvg, fy, YAvgRMS, PyyAvg_Int] = getbpmpsd(Family, DeviceList, Navg, LineColor)
%GETCMPSD - Program to analyze CM power spectrum
%  [Pxx, fx, Xrms, PxxInt] = getbpmpsd(Family, DeviceList, Navg, LineColor) 
%
%  INPUTS
%  1. DeviceList
%  2. Navg {Default: 10}
%  3. LineColor - {Default: 'b'}
%     If input 3 exists or no output exists, then data will be plotted to the screen
%
%  OUTPUT
%  1. Pxx    - Horizontal power spectrum  [(m)^2/Hz]
%  2. fx     - Frequency vector [Hz]
%  3. Xrms   - Horizontal RMS deplacement [m]
%  4. PxxInt - Horizontal integrated RMS deplacement squared [m^2]
%  5-8. Vertical
%
%  NOTES
%  1. If not outputs exist, a file is automatically created in the current directory named according to the BPM device list
%  2. Uses the bpm_psd function to compute the PSD
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

if nargout == 0
    PlotFlag = 1;
else
    PlotFlag = 0;
end
if nargin >= 3
    PlotFlag = 1;
end


FileName =  sprintf('BPM%d_%d', DeviceList');
FileName = appendtimestamp(FileName);
NumFreqRemove = 2;
RF = getrf;


% Setup figures
if PlotFlag
    h_fig1 = subfig(2,2,1, 1);
    clf reset
    h_fig2 = subfig(2,2,3, 2);
    clf reset
    h_fig3 = subfig(2,2,2, 3);
    p = get(h_fig3, 'Position');
    set(h_fig3, 'Position', [p(1) p(2)-.3*p(4) p(3) p(4)+.3*p(4)]);
    clear p
    clf reset
    drawnow;
end

TimeStart = clock;
for i = 1:Navg
    if strcmp(getenv('computername'),'SPEARPC15')
        BPM = mcagetbpm4k(DeviceList);
    else
        BPM = getbpm4k(DeviceList);
    end
    
    for j = 1:size(DeviceList)
        
        a = squeeze(BPM(:,j,:));
        
        if PlotFlag
            figure(h_fig1);
            [Pxx(:,i), fx, Xrms(1,i), Pxx_int] = bpm_psd(a(1,:),'r');
        else
            [Pxx(:,i), fx, Xrms(1,i), Pxx_int] = bpm_psd(a(1,:));
        end
        if PlotFlag
            drawnow;
            figure(h_fig2);
            [Pyy(:,i), fy, Yrms(1,i), Pyy_int] = bpm_psd(a(2,:),'r');
            drawnow;
        else
            [Pyy(:,i), fy, Yrms(1,i), Pyy_int] = bpm_psd(a(2,:));
        end
        
        if i == 1
            PxxAvg = Pxx;
            PyyAvg = Pyy;
        else
            PxxAvg = ((i-1)*PxxAvg + Pxx(:,i)) / i;
            PyyAvg = ((i-1)*PyyAvg + Pyy(:,i)) / i;
        end
        
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
        
        PxxAvg_Int = cumsum(PxxAvg) / N / T1;
        PyyAvg_Int = cumsum(PyyAvg) / N / T1;
        
        XAvgRMS(1,i) = sqrt(max(PxxAvg_Int));
        YAvgRMS(1,i) = sqrt(max(PyyAvg_Int));
        
        DCCT(1,i) = getdcct;
        
        
        if PlotFlag
            fprintf('   %d.  Xrms = %.4f    Yrms = %.4f microns\n', i , 1e6*XAvgRMS(1,i), 1e6*YAvgRMS(1,i));
            drawnow;
        end
        
        if nargout == 0
            TimeEnd = clock;
            save(FileName);
        end
        
        % Plot the power spectrum
        if PlotFlag
            figure(h_fig3);
            subplot(2,2,1);
            if i ~= Navg
                loglog(fx(NumFreqRemove+1:N/2), 1e12*Pxx(NumFreqRemove+1:N/2,i),'r'); 
                hold on
            end
            loglog(fx(NumFreqRemove+1:N/2), 1e12*PxxAvg(NumFreqRemove+1:N/2), LineColor); 
            hold off
            title(sprintf('BPMx(%d,%d) POWER SPECTRUM (%d points)',DeviceList,N));
            xlabel('Frequency [Hz]');
            ylabel('BPMx PSD [\mum^2/Hz]');
            grid on;
            legend off;
            %aa=axis;
            %axis([1 2000 1e-3 10]);
            %axis([1 2000 aa(3) aa(4)]);
            %yaxis([1e-4 1])
            xaxis([1 2000]);
            
            % Position spectrum
            subplot(2,2,3);
            if i ~= Navg
                semilogx(fx(NumFreqRemove:N/2), 1e12*Pxx_int(NumFreqRemove:N/2), 'r'); 
                hold on
            end
            semilogx(fx(NumFreqRemove:N/2), 1e12*PxxAvg_Int(NumFreqRemove:N/2), LineColor); 
            hold off
            title(sprintf('BPMx(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList,1e6*XAvgRMS(i)));
            xlabel('Frequency [Hz]');
            ylabel('Mean Square Displacement [\mum^2]');
            grid on;
            legend off;
            %aa=axis;
            %axis([1 2000 aa(3) aa(4)]);
            xaxis([1 2000]);
            
            subplot(2,2,2);
            if i ~= Navg
                loglog(fy(NumFreqRemove+1:N/2), 1e12*Pyy(NumFreqRemove+1:N/2,i),'r'); 
                hold on
            end
            loglog(fy(NumFreqRemove+1:N/2), 1e12*PyyAvg(NumFreqRemove+1:N/2), LineColor); 
            hold off
            title(sprintf('BPMy(%d,%d) POWER SPECTRUM (%d points)',DeviceList,N));
            xlabel('Frequency [Hz]');
            ylabel('BPMy PSD [\mum^2/Hz]');
            grid on;
            legend off;
            %aa=axis;
            %axis([1 2000 aa(3) aa(4)]);
            %axis([1 2000 1e-3 10]);
            %yaxis([1e-4 1])
            xaxis([1 2000]);
            
            % Position spectrum
            subplot(2,2,4);
            if i ~= Navg
                semilogx(fy(NumFreqRemove:N/2), 1e12*Pyy_int(NumFreqRemove:N/2), 'r'); 
                hold on
            end
            semilogx(fy(NumFreqRemove:N/2), 1e12*PyyAvg_Int(NumFreqRemove:N/2), LineColor); 
            hold off
            title(sprintf('BPMy(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList,1e6*YAvgRMS(i)));
            xlabel('Frequency [Hz]');
            ylabel('Mean Square Displacement [\mum^2]');
            grid on;
            legend off;
            %aa=axis;
            %axis([1 2000 aa(3) aa(4)]);
            xaxis([1 2000]);
            
            drawnow;
        end
    end
end



%semilogx(fx(NumFreqRemove:N/2), sqrt(PxxAvg_Int(NumFreqRemove:N/2)), LineColor);
%semilogx(fy(NumFreqRemove:N/2), sqrt(PyyAvg_Int(NumFreqRemove:N/2)), LineColor);
