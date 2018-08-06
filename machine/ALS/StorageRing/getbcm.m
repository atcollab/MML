function bcm = getbcm(varargin)
%GETBCM - Bunch current monitor
%  BCM_328Point_Waveform = getictwave(Field)
%  StructureOfWaveforms  = getictwave('All')
%
%  BCM = getbcm('BunchCharge')  {Default}
%
%  NOTE
%  1. There is roughly 62.54 ps between ADC samples (also the Trigger Delay step size)  
%  2. There is 32 samples per RF bucket
%  3. The following PV are used to report one element in the current waveform 
%        Cam1_current
%        Cam2_current
%        Cam1_scale_factor
%        Cam2_scale_factor
%        Cam1_bucket_number
%        Cam2_bucket_number
% 
%  See also checkbcm, setbcm, bcmdisplay

% Written by Greg Portmann


% To do:  1. Add input string for each field
%            BCM = getbcm('BunchCharge')  {Default}
%         3. Add channel names to Struct?
%         4. Should BunchPhase change with SROC???
%         5. The delay setup should put the first bunch zero crossing at 16?
%            May want to adjust the peak search range to something like 3:18 and 14:34?


% The trigger delay change the ADC stream, but the SIOC WF can correct it. 
% Does changing the RF frequency change the bunch phase?
%
% 2017-03-13
% SR1:BCM:triggerDelay = 4149
% bpm.AvgPhase -> 78 (was 154) degrees
% 2017-09-07
% SR1:BCM:triggerDelay = 6854

DCCT0 = 0;  % Zero beam DCCT offset???

% Phase measurement is relate to SROC.  SROC can change with certain BCM changes (firmware, cabling, etc.)
%PhaseOffset =  105;    % Before 2017-04-03
PhaseOffset = -120.5;   % 2017-04-03 using only single bunch 308 (set after firmware change)


% Flags
Add3PointFit = 0;


if nargin >= 1 && any(strcmpi(varargin{1}, {'All','Struct'}))
    % Structure output
    [bcm.BunchCurrent, ~, DataTime] = getpvonline('SR1:BCM:BunchQ_WF');  % [mA]
    bcm.ADC                         = getpvonline('SR1:BCM:ADC_WF');
    bcm.SROC                        = getpvonline('SR1:BCM:SROC_WF');    
    bcm.SquelchLevel                = getpvonline('SR1:BCM:squelchLevel');    % Percent
    bcm.BeamCurrent                 = getpvonline('SR1:BCM:beamCurrent');     % DCCT [mA]
    bcm.InjectionBeamCurrent        = getpvonline('SR1:BCM:BunchQinj_WF');    % Delta DCCT from the last injection [mA]
    bcm.DeltaBeamCurrent            = getpvonline('SR1:BCM:BunchQdelta_WF');  % Delta DCCT from the last acquisition [mA]
    bcm.PeaksWF                     = getpvonline('SR1:BCM:Peaks_WF');
    bcm.TriggerDelay                = getpvonline('SR1:BCM:triggerDelay');

    bcm.ADCTemperatureAB            = getpvonline('SR1:BCM:fmcABtemp');
    bcm.ADCTemperatureCD            = getpvonline('SR1:BCM:fmcCDtemp');
    bcm.ADCTemperatureEF            = getpvonline('SR1:BCM:fmcEFtemp');
    bcm.ADCTemperatureGH            = getpvonline('SR1:BCM:fmcGHtemp');

    % bcm.BeamI_ABS = getpvonline('SR1:BCM:BeamI_ABS');
    % bcm.BeamI_POS = getpvonline('SR1:BCM:BeamI_POS');
    % bcm.BeamI_RMS = getpvonline('SR1:BCM:BeamI_RMS');
    
    bcm.Peaks           = find(bcm.PeaksWF==5000);
    bcm.IntegrationArea = find(bcm.PeaksWF==bcm.SquelchLevel);  % ???

    bcm.RF = getrf;
    bcm.ADCClock = getpv('SR1:BCM:ADCclockSpeed');
    
    bcm.T = 1/1e6/bcm.RF/32;  % 32 samples per RF bucket
    bcm.t = (0:length(bcm.ADC)-1) * bcm.T;
    bcm.TimeStamp = labca2datenum(DataTime);  % Matlab time
    
    [bcm.DCCT, tmp, bcm.DCCT_TimeStamp] = getpv('SR1:BCM:beamCurrent');
   %[bcm.DCCT, tmp, bcm.DCCT_TimeStamp] = getdcct;
    bcm.DCCT = bcm.DCCT - DCCT0;
    
    % 2 * 2% SquelchLevel was not enough to Squelch bucket after the cam
    % Or, at least a few ADC counts (since the percent isn't well defined for no beam)
    ADC_SquelchLevel = 3.0 * bcm.SquelchLevel * max(bcm.ADC) / 100;  % 6.25% if input Squelch is 2.5%
    if ADC_SquelchLevel < 22
        ADC_SquelchLevel = 22;
    end
    bcm.SquelchLevelADC = ADC_SquelchLevel;
    
    % Find the positive peaks
    for ii = 1:328
        %if ii == 309
        %   ii;
        %end

        %adc = bcm_ADC(32*(ii-1)+(1:32),i);
        iBunch = 32*(ii-1)+(2:20); 
        adc = bcm.ADC(iBunch);
        
        % Positive max
        adc(adc<0) = 0;
        [maxadc, imax] = max(adc);
        
        if maxadc <= ADC_SquelchLevel || imax==1 || imax==length(adc)
            % Squelch measurement
            if Add3PointFit
                bcm.BunchTime3(ii) = NaN;
                bcm.ADCMax3(ii) = 0;
            end
            
            bcm.BunchTime1(ii) = NaN;
            bcm.ADCMax1(ii) = 0;
        else
            if Add3PointFit
                % 3 point fit
                x1 = bcm.t(iBunch(imax)-1);
                x2 = bcm.t(iBunch(imax));
                x3 = bcm.t(iBunch(imax)+1);
                
                y1 = bcm.ADC(iBunch(imax)-1);
                y2 = bcm.ADC(iBunch(imax));
                y3 = bcm.ADC(iBunch(imax)+1);
                
                a = ((y2-y1)*(x1-x3) + (y3-y1)*(x2-x1)) / ((x1-x3)*(x2^2-x1^2) + (x2-x1)*(x3^2-x1^2));
                b = ((y2 - y1) - a*(x2^2 - x1^2)) / (x2-x1);
                c = y1 - a*x1^2 - b*x1;
                
                bcm.BunchTime3(ii) = -b / 2 / a;
                bcm.ADCMax3(ii) = a*bcm.BunchTime3(ii)^2 + b*bcm.BunchTime3(ii) + c;
                
                %b3 = [a; b; c];
            end
            
            % Add a 5-point fit
            % Change the offset and scaling to avoid singularity issues with big and small numbers
            x(1,1) = (bcm.t(iBunch(imax)-2)-bcm.t(iBunch(imax))) * 1e9;
            x(2,1) = (bcm.t(iBunch(imax)-1)-bcm.t(iBunch(imax))) * 1e9;
            x(3,1) = (bcm.t(iBunch(imax)-0)-bcm.t(iBunch(imax))) * 1e9;
            x(4,1) = (bcm.t(iBunch(imax)+1)-bcm.t(iBunch(imax))) * 1e9;
            x(5,1) = (bcm.t(iBunch(imax)+2)-bcm.t(iBunch(imax))) * 1e9;
            
            y(1,1) = bcm.ADC(iBunch(imax)-2);
            y(2,1) = bcm.ADC(iBunch(imax)-1);
            y(3,1) = bcm.ADC(iBunch(imax)-0);
            y(4,1) = bcm.ADC(iBunch(imax)+1);
            y(5,1) = bcm.ADC(iBunch(imax)+2);

            X = [x.^2 x ones(5,1)];
            b = inv(X'*X)*X' * y;
            yhat = X * b; 
            
            bcm.BunchTime1(ii) = (-b(2) / 2 / b(1));
            bcm.ADCMax1(ii) = b(1)*bcm.BunchTime1(ii)^2 + b(2)*bcm.BunchTime1(ii) + b(3);
            bcm.BunchTime1(ii) = bcm.BunchTime1(ii) + 1e9*bcm.t(iBunch(imax));
        end
    end
    
    if Add3PointFit
        bcm.BunchCurrent3 = bcm.DCCT * bcm.ADCMax3 / sum(bcm.ADCMax3);
    end
    
    if any(isnan(bcm.ADCMax1))
        % NaN in one element will make all BunchCurrent NaN
         bcm.ADCMax1(isnan(bcm.ADCMax1)) = 0;
    end
    if  sum(bcm.ADCMax1) == 0
        %bcm.BunchCurrent1 = bcm.DCCT * ones(1,328) / 328;
        bcm.BunchCurrent1 = zeros(1,328);
    else
        bcm.BunchCurrent1 = bcm.DCCT * bcm.ADCMax1 / sum(bcm.ADCMax1);
    end
           
        
    % Bunch Phase (convert from delay)
    %BunchPhase(:,i) = (360/TwoNanoSeconds)*(1e9*BunchTime1(:,i) - TwoNanoSeconds*(0:327)');  % Degrees
    TwoNanoSeconds = 1/(1e6*bcm.RF);  % 1e9/(1e6*RF(i))
    
    % Relate the phase to SROC
    iSROC_h = min(find(bcm.SROC > 1023));    % High point
    iSROC_l = min(find(bcm.SROC > 0))-1;     % Low point
    ivec = iSROC_l-1:iSROC_h+1;
    [tmp, i] = min(abs(bcm.SROC(ivec)-512));
    iSROC_m = ivec(i);                       % Middle point
    
    if ~isempty(iSROC_m)
        bcm.t_SROC = bcm.t(iSROC_m);  % nsec
        
        % Fit for SROC time
        % Might need to smooth the fit???
        m = 10;
        s = [zeros(1,m) 512 1024*ones(1,m)];
        nvec = (-m:m) + iSROC_m;
        ii = 0;
        clear y tt
        for i = nvec
            ii = ii + 1;
            y(ii) = sum(bcm.SROC(i+(-m:m)) - s);
            tt(ii) = bcm.t(i);
        end
        X = [1e9*tt(:) ones(2*m+1,1)];
        b = inv(X'*X)*X' * y(:);
        yhat = X * b;
        t_intercept = 1e-9 * (-b(2) / b(1));
        bcm.t_SROC = t_intercept;
        %  fprintf('SROC = %10.4f   %.4f  %.2f\n', 1e9*t_intercept, 360*(t_intercept/TwoNanoSeconds), getrf*1e6);
        
        
        % Since the BCM is always setup so that first bunch is the start of the waveform move SROC to the first bunch
        % Typically SROCBunchNumber is 198
        t_SROC = bcm.t_SROC;
        SROCBunchNumber = 1;
        while t_SROC > TwoNanoSeconds
            t_SROC = t_SROC - TwoNanoSeconds;
            SROCBunchNumber = SROCBunchNumber + 1;
        end
        bcm.SROCBunchNumber = SROCBunchNumber;
    else
        % No SROC data
        bcm.t_SROC = NaN;
        t_SROC = bcm.t_SROC;
        bcm.SROCBunchNumber = [];
    end
    
   %bcm.BunchTime1  = 1e-9 * bcm.BunchTime1;
    bcm.BunchTime1  = 1e-9 * (bcm.BunchTime1 + .396) - t_SROC;
    bcm.BunchPhase1 =  360 * (bcm.BunchTime1/TwoNanoSeconds - (0:327)) - PhaseOffset;  % Degrees
    bcm.AvgPhase1 = mean(bcm.BunchPhase1(~isnan(bcm.BunchPhase1)));

    %if isnan(bcm.AvgPhase)
    %elseif bcm.AvgPhase > 1000
    %    % ???
    %    bcm.AvgPhase;
    %else
    %    %set(handles.AvgPhase,  'String', sprintf('%6.2f Deg', bcm.AvgPhase));
    %end

    if Add3PointFit
        bcm.BunchPhase3 = (360)*(bcm.BunchTime3/TwoNanoSeconds - (0:327));  % Degrees
    end

 
    
    % Find the negative peaks
    for ii = 1:328
        if ii == 309
           ii;
        end
        
        if ii == 328
            iBunch = 32*(ii-1)+(16:32); 
        else
            iBunch = 32*(ii-1)+(16:33); 
        end
        adc = -1 * bcm.ADC(iBunch);
        
        % Positive max
        adc(adc<0) = 0;
        [maxadc, imax] = max(adc);
        
        if maxadc <= ADC_SquelchLevel || imax==1 || imax==length(adc)
            % Squelch measurement
            bcm.BunchTime2(ii) = NaN;
            bcm.ADCMax2(ii) = 0;
        else
            % Add a 5-point fit
            % Change the offset and scaling to avoid singularity issues with big and small numbers
            x(1,1) = (bcm.t(iBunch(imax)-2)-bcm.t(iBunch(imax))) * 1e9;
            x(2,1) = (bcm.t(iBunch(imax)-1)-bcm.t(iBunch(imax))) * 1e9;
            x(3,1) = (bcm.t(iBunch(imax)-0)-bcm.t(iBunch(imax))) * 1e9;
            x(4,1) = (bcm.t(iBunch(imax)+1)-bcm.t(iBunch(imax))) * 1e9;
            x(5,1) = (bcm.t(iBunch(imax)+2)-bcm.t(iBunch(imax))) * 1e9;
            
            y(1,1) = bcm.ADC(iBunch(imax)-2);
            y(2,1) = bcm.ADC(iBunch(imax)-1);
            y(3,1) = bcm.ADC(iBunch(imax)-0);
            y(4,1) = bcm.ADC(iBunch(imax)+1);
            y(5,1) = bcm.ADC(iBunch(imax)+2);

            X = [x.^2 x ones(5,1)];
            b = inv(X'*X)*X' * y;
            yhat = X * b; 
            
            bcm.BunchTime2(ii) = (-b(2) / 2 / b(1));
            bcm.ADCMax2(ii) = b(1)*bcm.BunchTime2(ii)^2 + b(2)*bcm.BunchTime2(ii) + b(3);
            bcm.BunchTime2(ii) = bcm.BunchTime2(ii) + 1e9*bcm.t(iBunch(imax));
        end
    end
        
    if any(isnan(bcm.ADCMax2))
        % NaN in one element will make all BunchCurrent NaN
         bcm.ADCMax2(isnan(bcm.ADCMax2)) = 0;
    end
    if  sum(bcm.ADCMax2) == 0
        bcm.BunchCurrent2 = zeros(1,328);
    else
        bcm.BunchCurrent2 = bcm.DCCT * bcm.ADCMax2 / sum(bcm.ADCMax2);
    end
                
    bcm.BunchTime2  = 1e-9 * (bcm.BunchTime2 - .396) - t_SROC;
    bcm.BunchPhase2 = (360)*(bcm.BunchTime2/TwoNanoSeconds - (0:327)) - PhaseOffset;  % Degrees
    bcm.AvgPhase2 = mean(bcm.BunchPhase2(~isnan(bcm.BunchPhase2)));
    
    
    % The FPGA compute bunch current based on the peak ADC of the upper pulse
    bcm.BunchCurrentPeak = bcm.BunchCurrent;
      
    % Return the averages ???
   %bcm.BunchCurrent = bcm.BunchCurrent1;
    bcm.BunchCurrent = (bcm.BunchCurrent1 + bcm.BunchCurrent2)/2;
    
    % Normalize to total current again incase both 1 & 2 have different squelch cases
    if sum(bcm.BunchCurrent) == 0 
        bcm.BunchCurrent2 = zeros(1,328);
    else
        bcm.BunchCurrent = bcm.DCCT * bcm.BunchCurrent / sum(bcm.BunchCurrent);
    end
    
   %bcm.AvgPhase = bcm.AvgPhase1;
    bcm.AvgPhase = (bcm.AvgPhase1 + bcm.AvgPhase2)/2;
    
   %bcm.BunchPhase = bcm.BunchPhase1;
    bcm.BunchPhase = (bcm.BunchPhase1+bcm.BunchPhase2)/2;
    
    
%     figure(2);
%     clf reset
%     plot(bcm.BunchPhase1,'.-b');
%     hold on
%     plot(bcm.BunchPhase2,'.-g');
%     hold off

else
    bcm = getpvonline('SR1:BCM:BunchQ_WF');
end




