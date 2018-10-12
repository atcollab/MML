function varargout = meastune(varargin)
% MEASTUNE measures the tune using various possible sources. The default is
% from Turn-by-Turn (TBT) data from the Liberas. The probram does not turn
% on or off any magnets.
%
% >> tunes = meastune;
%
% Eugene

t0 = clock;

% Source of tunes
% 1:  From general PVs
% 2:  From TBT data
% 3:  From automated tune measurement system
% 4:  From BbB
choice = 4;

switch choice

    case 1 % From General PVs

    tune(1) = getpv('CR01:GENERAL_ANALOG_02_MONITOR');
    tune(2) = getpv('CR01:GENERAL_ANALOG_03_MONITOR');

    case 2 % Using TBT data
    % Method
    % 1:  SVD component method with zero padding for frequency interpolation.
    % 2:  FFT with background subtraction
    method = 2;
    % Test
    % 0:  No test
    % 1:  Sample dataset
    % 2:  Pure function
    testsource = 0;
    
    %Check excitation
    if sum(getpv('KICK','OFF_ON_STATUS')) == 4
       warning('You can get better tune measurements with just a single kicker.\n');
    elseif sum(getpv('KICK','OFF_ON_STATUS')) == 0
       warning('No kickers turned ON! Data may not be valid.');
    end
    % Check septum
    if getpv('PS-SEI-3:STATUS1') == 1
        warning('Septum (SEI-3) is turned on. This broadens the tunelines making it harder to measure the vertical tune');
    end
    % Check timing. Dependent on the function 'meastunearm'
    %   Events
    if getpv('TS01EVR01:TTL01_EVENT_CODE_STATUS') ~= 13
        warning('Timing: BPM trigger event not set to ''Storage Ring BPM''');
    end
    if getpv('TS01EVR06:TTL01_EVENT_CODE_STATUS') ~= 13
        warning('Timing: Kicker 2''s trigger event not set to ''Storage Ring BPM''');
    end
    % BPMs must be triggered 85.4 turns (61.528 us) before the kickers. I
    % presume these are delays in the BPM fanout and/or internal delays in the
    % Liberas. Calculate time difference in turns relative to +85.4.
    timedifference = (getpv('TS01EVR06:TTL01_TIME_DELAY_MONITOR') - getpv('TS01EVR01:TTL01_TIME_DELAY_MONITOR'))/720.5e-9 - 85.4;
    if  timedifference < -250 || timedifference > 250
        warning(sprintf('Timing: BPM delay not set properly. Nominal TS01EVR01:TTL01_TIME_DELAY_SP: %11.9f seconds.',...
            getpv('TS01EVR06:TTL01_TIME_DELAY_MONITOR') - 85.4*720.5e-9));
    end
    
    if method == 1
        if any(getliberaswitches)
            warning('Method 1 (SVD) best used with libera switches turned off');
        end
        if getpv('SR00SOF01:STATUS') == 2
            warning('Turn off SOFB before turning switches off');
        end
        % Check to see if SOFB it turned on. Ask user to turn off before
        % continuing. or Cancel
%         while getpv('SR00SOF01:STATUS') == 2 && method == 1 && testsource == 0
%             switch questdlg('Please turn off SOFB before running MEASTUNE.','Slow Orbit Feedback Running','Continue','Exit','Continue')
%                 case 'Continue'
%                     measure = 1;
%                 otherwise
%                     measure = 0;
%             end
%         end
%         turnswitches off &;
%         pause(1);

        N = 16384;
        % turns to evaluate at each BPM to get an accurate measure of the tunes.
        % Generally 1000 turns is sufficient as the damping of the ring means the
        % useful data is only if the first 1000 turns (for low amplitude kicks).
        % For larger amplitude kicks you should select turns at the end as we
        % probably do not want to include amplitude tuneshifts in our measurement.
        % The improvement in the accuracy is linear with number of turns.
        xturns = 30:1000;
        yturns = 30:1000;
        %xturns = 1:5000; % DJP
        %yturns = 1:5000;
        % Which BPMs to select from. By default based on some trial studies it
        % seems around 40 BPMs gives a very accurate measurement of the tunes
        % (horizontally). Adding more BPMs does not seem to help. Strangely
        % vertical seems not to have this effect and would require all BPMs.
        nbpm = [1:15];[2 4 5 6 8 9 10 11 12 15 20 25 30 40 50 60 70];
%         nbpm = [2 4];
        % Component number. Try changing these numbers between 1 and 5 and see
        % if you can get a better measure for the tune. 
        inum(1) = 1; %2
        inum(2) = 1; %2

        if testsource == 0
            dev = elem2dev('BPMx',nbpm(:));
            tt = getliberatbt('DD3',dev);
        elseif testsource == 1
            warning('Running in test mode 1');
            filestr = '/asp/usr/measurements/bpm/2011_02_28_tbtdataproblem/offsettune_125_tbtdata.mat';
            load(filestr);
            tt = data;
            clear data;
        elseif testsource == 2
            warning('Running in test mode 2');
            fxstr = '500e-6*sin(2*pi*0.290*[1:10000]).*exp(-[1:10000]/1500)+0.5e-6*randn(1,10000)';
            fystr = '100e-6*sin(2*pi*0.216*[1:10000]).*exp(-[1:10000]/1500)+0.5e-6*randn(1,10000)';
            tt.tbtx = repmat(eval(fxstr),10,1);
            tt.tbty = repmat(eval(fystr),10,1);
        end
        
%         turnswitches on &;

        for plane=1:2
            if plane==1
                data = tt.tbtx(:,xturns);
            else
                data = tt.tbty(:,yturns);
            end
            ndata = size(data,2);
            % subtract DC
            data = data - repmat(mean(data,2),1,ndata);
            % Singular value decomposition. Probably the most time consuming part.
            [u s v] = svd(data);
            % Calculate the spectra.
            vdata(:,plane) = v(:,inum(plane));
            [powerspectra amplitude f] = getfftspectrum([v(:,inum(plane)); zeros(N-ndata,1)],1,N,0);
            figure(100+plane);
            subplot(2,2,1);
            plot(data(1,:));
            title('Input data first sample');
            subplot(2,2,2);
            semilogy(diag(s),'.-');
            title('Singular Values');
            subplot(2,1,2);
            plot(f(2:end),10*log10(powerspectra(2:end)));
            title(sprintf('Power spectra in dB for component %d',inum))
            % Find the frequency peak x
            % ET: getfftspectrum returns only half the FFT power spectra. So no
            % need to find the peak in just the lower half. 06/04/2009
            if plane==1
                [maxval maxindx] = max(amplitude);
                diffind = maxindx-2:maxindx+2;
                diffb = gradient(amplitude(diffind));
                tune(plane) = interp1(diffb,f(diffind),0);
            end
            % Find the frequency peak y using x peak as limiting range -50
            % points            
            if plane ==2 
                offset_start = 100;
                [maxval maxindy] = max(amplitude(1+offset_start:maxindx-50));
                maxindy = maxindy + offset_start;
                diffind = maxindy-2:maxindy+2;
                diffb = gradient(amplitude(diffind));
                tune(plane) = interp1(diffb,f(diffind),0);
            end
        end
    elseif method == 2

        if testsource == 0
            % use only every 5
            tt = getliberatbt('DD3',elem2dev('BPMx',sort([2:7:98 6:7:98])));
            datax = tt.tbtx-repmat(mean(tt.tbtx,2),1,size(tt.tbtx,2)); % remove DC
            datay = tt.tbty-repmat(mean(tt.tbty,2),1,size(tt.tbty,2));
            clear tt;
        elseif testsource == 1
            warning('Running in test mode 1');
            filestr = '/asp/usr/measurements/bpm/2011_02_28_tbtdataproblem/offsettune_125_tbtdata.mat';
            load(filestr);
            datax = data.tbtx-repmat(mean(data.tbtx,2),1,size(data.tbtx,2));
            datay = data.tbty-repmat(mean(data.tbty,2),1,size(data.tbty,2));
            clear data;
        elseif testsource == 2
            warning('Running in test mode 2');
            fxstr = '500e-6*sin(2*pi*0.290*[1:10000]).*exp(-[1:10000]/1500)+0.5e-6*randn(1,10000)';
            fystr = '100e-6*sin(2*pi*0.216*[1:10000]).*exp(-[1:10000]/1500)+0.5e-6*randn(1,10000)';
            datax = repmat(eval(fxstr),10,1);
            datay = repmat(eval(fystr),10,1);
        end

        % Range where the main betatron oscillations will be. With 5000
        % samples the resolution is 2e-4;
        % 06/2011Eugene currently starts at 131 turns as the Liberas seem
        % to have some issues in the first 100 turns where the data is
        % corrupted. 
        range = 131:5130;
        N = length(range);
        f = (0:N/2) / N;

        t = [1:length(range)];
        p = 1;
        kai = ( 2^p*(factorial(p))^2*(1+cos(pi*(2*(t-max(t)/2)/max(t)))).^p/factorial(2*p) );
        kai = 1;repmat(kai/max(kai),size(datax,1),1)';
        
        fftdatax1 = fft(kai.*datax(:,range)');
        fftdatay1 = fft(kai.*datay(:,range)');
        
        range = 1:430;
        
        t = [1:length(range)];
        p = 1;
        kai = ( 2^p*(factorial(p))^2*(1+cos(pi*(2*(t-max(t)/2)/max(t)))).^p/factorial(2*p) );
        kai = 1;repmat(kai/max(kai),size(datax,1),1)';
        
        fftdataysmall = fft(kai.*datay(:,range)');
        Nsmall = length(range);
        fsmall = (0:Nsmall/2) / Nsmall;
       
        % The back end where some damping have occured and use this as a
        % baseline
        range = 5001:10000;
        
        t = [1:length(range)];
        p = 1;
        kai = ( 2^p*(factorial(p))^2*(1+cos(pi*(2*(t-max(t)/2)/max(t)))).^p/factorial(2*p) );
        kai = 1;repmat(kai/max(kai),size(datax,1),1)';
        
        
        fftdatax2 = fft(kai.*datax(:,range)');
        fftdatay2 = fft(kai.*datay(:,range)');

        % Calculate the relative amplitude of the signal. Subtract the
        % baseline spectrum.
        range = 1:fix(N/2)+1;
        ampxraw = abs(fftdatax1(range,:))/(N/2);
        ampxbase = abs(fftdatax2(range,:))/(N/2);
        ampyraw = abs(fftdatay1(range,:))/(N/2);
        ampybase = abs(fftdatay2(range,:))/(N/2);
        ampx = ampxraw - ampxbase;
        ampy = ampyraw - ampybase;
                
        % Horizontal Tune
        [val(1) ind] = max(mean(ampx(500:end,:),2));
        ind = ind + 500-1;
        tune(1) = f(ind);
        
        % Try and remove the horizontal component from the measurement. In
        % this way relative amplitudes between horizontal and vertical
        % should not be used as betatron coupling...
        ampyxcomp = max(mean(ampy'))/max(mean(ampx'))*mean(ampx');
%         ampyxcomp = sum(mean(ampx')/sum(mean(ampx')).*mean(ampy')/sum(mean(ampy')))*mean(ampx');

%         Possibly use the smaller FFT to find the peak then search around
%         it however this encounters poblems with the synchrotron tune
%         being stronger and also the horizontal tune. So for now this idea
%         is abandoned. The smaller FFT also has an issue with frequency
%         resolution where if the the resonant peak at the FFT data point
%         will be larger in amplitude than if the resonant peak is between
%         data points. Therefore as the tune drifts its amplitude will go
%         up and down and can swap in maximum amplitude with its sidebands.
%         This may be overcome with max resolution FTT coupled with binning
%         before peak searching.
        range = 1:fix(Nsmall/2)+1;
        ampysmall = abs(fftdataysmall(range,:))/(N/2);
%         [tempval tempind] = max(mean(ampysmall'));
%         peaksearchrange = find(f > fsmall(tempind)-0.009 & f < fsmall(tempind)+0.009);
        
        
        ampy = mean(ampy') - ampyxcomp;
        ampy = filter([1 1 1 1]/4,1,ampy);
        [val(2) ind] = max(ampy(:));
        tune(2) = f(ind);
        
        figure(104); clf; 
%         set(gcf,'Position',[588   431   744   606]);
        subplot(2,1,1);
        semilogy(f,abs(mean(ampx,2)));
        ylabel('X Amplitude (nm) [bg subtraction]');
        xlabel('Fractional Tune');
        if testsource == 1;
            hold on;
            semilogy(f,mean(ampxraw,2),'r');
            semilogy(f,mean(ampxbase,2),'k');
            hold off;
            title(sprintf('From data saved in: %s (Tune: %7.5f, Amp: %5.1f um)',filestr,tune(1),val(1)*1e-3),'Interpreter','none');
        elseif testsource == 2
            hold on;
            semilogy(f,mean(ampxraw,2),'r');
            semilogy(f,mean(ampxbase,2),'k');
            hold off;
            title(sprintf('Test function: %s (Tune: %7.5f, Amp: %5.1f um)',fxstr,tune(1),val(1)*1e6));
        end
        
        subplot(2,1,2);
        semilogy(f,abs(ampy));
%         plot(f,abs(ampy))
        ylabel('Y Amplitude (nm) [bg subtraction & H comp. removal]');
        xlabel('Fractional Tune');
        
        if testsource == 0
            hold on; 
            semilogy(fsmall, abs(mean(ampysmall,2)),'r'); 
            hold off;
            %legend('High resolution averaged spectrum','Low resolution averaged spectrum');
        elseif testsource == 1;
            hold on;
            semilogy(f,mean(ampyraw,2),'r');
            semilogy(f,mean(ampybase,2),'k');
            semilogy(f,ampyxcomp,'g');
            hold off;nargout
            title(sprintf('From data saved in: %s (Tune: %7.5f, Amp: %5.1f um)',filestr,tune(2),val(2)*1e-3),'Interpreter','none');
            legend('Treated spectrum','Raw Spectrum','Base line spectrum subtraced from raw spectrum','Horizontal compoennt');
        elseif testsource == 2
            hold on;
            semilogy(f,mean(ampyraw,2),'r');
            semilogy(f,mean(ampybase,2),'k');
            semilogy(f,ampyxcomp,'g');
            hold off;
            title(sprintf('Test function: %s (Tune: %7.5f, Amp: %5.1f um)',fystr,tune(2),val(2)*1e6));
            legend('Treated spectrum','Raw Spectrum','Base line spectrum subtraced from raw spectrum','Horizontal compoennt');
        end
    else
        tune = [NaN NaN];
    end

    case 3 % FRom R&S SPA

%TUNES FROM THE SPA
% mo = getsp('RF');
% tune = sr11spa01_matlab(mo(1),29.1474444e6,0.29,0.04,0.22,0.04);
% disp('Tunes from the SPA (returned by program):')
% disp(tune')

    pause(5);
    tune(1) = getpv('SR00TUM01:X_TUNE_MONITOR');
    tune(2) = getpv('SR00TUM01:Y_TUNE_MONITOR');
    
    case 4
        pause(2);
        tune(1) = getpv('IGPF:X:SRAM:PEAKTUNE2');
        tune(2) = getpv('IGPF:Y:SRAM:PEAKTUNE2');
    
end
   
varargout{1} = tune(:);
if nargout > 1
    % tout
    varargout{2} = clock;
end
if nargout > 2
    % Data time
    varargout{3} = t0;
end
if nargout > 3
    % Error flag
    varargout{4} = 0;
end
if nargout > 4
    % tune amplitude
    varargout{5} = 0;
end