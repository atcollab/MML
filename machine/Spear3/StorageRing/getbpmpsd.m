function [Pxx, fx, Xrms, Pxx_Int, Pyy, fy, Yrms, Pyy_Int, TimeStart] = getbpmpsd(DeviceList, Navg, FileName, LineColor)
%GETBPMPSD - Program to analyze BPM power spectrum
%  [Pxx, fx, Xrms, PxxInt, Pyy, fy, Yrms, PyyInt, TimeStart] = getbpmpsd(DeviceList, Navg, FileName, LineColor) 
%
%  INPUTS
%  1. DeviceList
%  2. Navg {Default: 10}
%  3. FileName - Filename (automatic creates a file if there is no output variables)
%  4. LineColor - {Default: 'b'}
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
%  1. If no output exist, a file is automatically created in the current directory named according to the BPM device list
%  2. Uses function bpm_psd to compute the PSD
%  2. Uses function getbpm4k to get the 4 KHz BPM data in millimeters 
%
%  Written by Greg Portmann


if nargin < 1
    DeviceList = family2dev('BPMx');
end
if nargin < 2
    Navg = 10;
end

if nargin < 3
    if size(DeviceList,1)
        FileName =  sprintf('PSD_BPM%d_%d', DeviceList(1,:));
    else
        FileName =  sprintf('PSD_BPM%d_%d_thru_%d_%d', DeviceList(1,:), DeviceList(end,:));
    end
    FileName = appendtimestamp(FileName);
end

if nargin < 4
    LineColor = 'b';
end

if nargout == 0
    PlotFlag = 1;
else
    PlotFlag = 0;
end
if nargin >= 4
    PlotFlag = 1;
end

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
%     if strcmp(getenv('computername'),'SPEARPC15')
%         BPM = mcagetbpm4k(DeviceList);
%     else
%         BPM = getbpm4k(DeviceList);
%     end
%     
    BPM = getbpm4k(DeviceList);
    for j = 1:size(DeviceList,1)
        
        a = squeeze(BPM(:,j,:));
        
        if PlotFlag
            figure(h_fig1);
            [Pxx1, fx, x1rms, Pxx1_Int] = bpm_psd(a(1,:),'r');
            Pxx1 = Pxx1(:)';
        else
            [Pxx1, fx, x1rms, Pxx1_Int] = bpm_psd(a(1,:));
            Pxx1 = Pxx1(:)';
        end
        if PlotFlag
            drawnow;
            figure(h_fig2);
            [Pyy1, fy, y1rms, Pyy1_Int] = bpm_psd(a(2,:),'r');
            Pyy1 = Pyy1(:)';
            drawnow;
        else
            [Pyy1, fy, y1rms, Pyy1_Int] = bpm_psd(a(2,:));
            Pyy1 = Pyy1(:)';
        end
        
        if i == 1
            Pxx(j,:) = Pxx1;
            Pyy(j,:) = Pyy1;
        else
            Pxx(j,:) = ((i-1)*Pxx(j,:) + Pxx1) / i;
            Pyy(j,:) = ((i-1)*Pyy(j,:) + Pyy1) / i;
        end
        
        %BPMx(:,i) = a(1,:)';
        %BPMy(:,i) = a(2,:)';
        %BPMs(:,i) = a(3,:)';
        %BPMq(:,i) = a(4,:)';
        
        N = length(a(1,:));
        T1 = 1/4000; % Sample period
        
        for k = 1:NumFreqRemove
            Pxx1(k) = 0;
            Pyy1(k) = 0;
            Pxx(j,k) = 0;
            Pyy(j,k) = 0;
        end
        
        Pxx_Int(j,:) = cumsum(Pxx(j,:)) / N / T1;
        Pyy_Int(j,:) = cumsum(Pyy(j,:)) / N / T1;
        
        Xrms(j,1) = sqrt(max(Pxx_Int(j,:)));
        Yrms(j,1) = sqrt(max(Pyy_Int(j,:)));
        
        DCCT(1,i) = getdcct;
        
        
        if PlotFlag
            fprintf('   %d.  Xrms(%d,%d) = %.4f    Yrms(%d,%d) = %.4f microns\n', i , DeviceList(j,:), 1e6*Xrms(j,1), DeviceList(j,:), 1e6*Yrms(j,1));
            drawnow;
        end
        
        if nargout == 0
            TimeEnd = clock;
            save(FileName, 'Pxx', 'fx', 'Xrms', 'Pxx_Int', 'Pyy', 'fy', 'Yrms', 'Pyy_Int', 'DCCT', 'DeviceList', 'TimeStart');
        end
        
        % Plot the power spectrum
        if PlotFlag
            figure(h_fig3);
            subplot(2,2,1);
            if i ~= Navg
                loglog(fx(NumFreqRemove+1:N/2), 1e12*Pxx1(NumFreqRemove+1:N/2),'r'); 
                hold on
            end
            loglog(fx(NumFreqRemove+1:N/2), 1e12*Pxx(j,NumFreqRemove+1:N/2), LineColor); 
            hold off
            title(sprintf('BPMx(%d,%d) POWER SPECTRUM (%d points)',DeviceList(j,:),N));
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
                semilogx(fx(NumFreqRemove:N/2), 1e12*Pxx1_Int(NumFreqRemove:N/2), 'r'); 
                hold on
            end
            semilogx(fx(NumFreqRemove:N/2), 1e12*Pxx_Int(j,NumFreqRemove:N/2), LineColor); 
            hold off
            title(sprintf('BPMx(%d,%d) Integrated PSD (RMS=%.1f \\mum)', DeviceList(j,:), 1e6*Xrms(j)));
            xlabel('Frequency [Hz]');
            ylabel('Mean Square Displacement [\mum^2]');
            grid on;
            legend off;
            %aa=axis;
            %axis([1 2000 aa(3) aa(4)]);
            xaxis([1 2000]);
            
            subplot(2,2,2);
            if i ~= Navg
                loglog(fy(NumFreqRemove+1:N/2), 1e12*Pyy1(NumFreqRemove+1:N/2),'r'); 
                hold on
            end
            loglog(fy(NumFreqRemove+1:N/2), 1e12*Pyy(j,NumFreqRemove+1:N/2), LineColor); 
            hold off
            title(sprintf('BPMy(%d,%d) POWER SPECTRUM (%d points)',DeviceList(j,:),N));
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
                semilogx(fy(NumFreqRemove:N/2), 1e12*Pyy1_Int(NumFreqRemove:N/2), 'r'); 
                hold on
            end
            semilogx(fy(NumFreqRemove:N/2), 1e12*Pyy_Int(j,NumFreqRemove:N/2), LineColor); 
            hold off
            title(sprintf('BPMy(%d,%d) Integrated PSD (RMS=%.1f \\mum)',DeviceList(j,:),1e6*Yrms(j)));
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



%semilogx(fx(NumFreqRemove:N/2), sqrt(Pxx_Int(NumFreqRemove:N/2)), LineColor);
%semilogx(fy(NumFreqRemove:N/2), sqrt(Pyy_Int(NumFreqRemove:N/2)), LineColor);
