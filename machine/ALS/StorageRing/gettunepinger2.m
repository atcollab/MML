%function [Tune, Tune_Vec] = gettunepinger(N,InfoFlag)
% | Higher Fractional Tune (X) |
% |                            | = gettuneping(InfoFlag)
% |  Lower Fractional Tune (Y) |
%
% InfoFlag = 0    -> do not print status information,
%            else -> print status information
%
% NOTES
% 1. TFB should be off
% 2. If NaN is returned, than something is wrong with the tune measurement system (pinger, libera).

N = 1;
HPingerVolts = 0;
VPingerVolts = 1.1e3;

% % Pinger high voltage
% HPingerVolts = 3000;
% VPingerVolts = 6000;
% 
% 
% if nargin < 1
%     N = 50;
% end
% 
% if nargin < 2
%     if nargout == 0
%         InfoFlag = 1;
%     else
%         InfoFlag = 0;
%     end
% end
% % Stops table execution
% setsp('SR01C___TIMING_AC11', 0);
% 
% % Switch to single bucket mode
% setsp('SR01C___TIMING_AC13', 0);
% 
% 
% % Target bucket 160 (as determined by Christoph's pingertiming_libera)
% setsp('SR01C___TIMING_AC08', 160);
% 
% 
% 
% 
% % Set pinger high voltage
% setsp('SR02S___PINGH__AC02', HPingerVolts);
% 
% setsp('SR02S___PINGV__AC00', VPingerVolts);
% pause(5);

BPMDevice = [12 5];

% HPingerVolts_AM = getam('SR02S___PINGH__AM02');
% VPingerVolts_AM = getam('SR02S___PINGV__AM00');

clear t

tic;
t0 = clock;

for i =1:N

    % Get Orbit
    liberaData = getlibera('DD3', BPMDevice, 1);
    fx = 1e-3*liberaData.DD_X_MONITOR(1:1024)';
    fy = 1e-3*liberaData.DD_Y_MONITOR(1:1024)';
    t(i) = etime(clock,t0);
      
    %mfx = fx(21:400,1)-mean(fx(21:400,1));
    %mfy = fy(21:400,1)-mean(fy(21:400,1));
    
    mfx = fx(21:400,1)-mean(fx(21:1021,1));
    mfy = fy(21:400,1)-mean(fy(21:1021,1));

    fftx = abs(fft(mfx));
    ffty = abs(fft(mfy));
    
    figure(999);
    subplot(2,2,1);
    plot(fx(:,1));
    xlabel('turn #');
    ylabel('x [\mum]');
    xaxis([0 1024]);
    grid on;
    
    subplot(2,2,2);
    plot(fy(:,1));
    xlabel('turn #');
    ylabel('y [\mum]');
    xaxis([0 1024]);
    grid on;
    
    subplot(2,2,3);
    plot([1:length(fftx)]/length(fftx), fftx);
    xlabel('\nu_x');
    ylabel('fft(x)');
    xaxis([0 0.5]);
    grid on;
    
    subplot(2,2,4);
    plot([1:length(ffty)]/length(ffty), ffty);
    xlabel('\nu_y');
    ylabel('fft(y)');
    xaxis([0 0.5]);
    grid on;
    
    [nux] = calcnaff(mfx,zeros(length(mfx),1),1);
    [nuy] = calcnaff(mfy,zeros(length(mfy),1),1);
    
    nux = abs(nux)/(2*pi);
    nuy = abs(nuy)/(2*pi);
    
    Tune = [NaN;NaN];
    
    for n=1:length(nux)
        if nux(n) < 0.33
            Tune_Vec(1,i) = nux(n);
            break;
        end
    end
    
    for n=1:length(nuy)
        if (nuy(n) < 0.33)  % && (nuy(n) < (Tune_Vec(1,i)-0.001))
            Tune_Vec(2,i) = nuy(n);
            break;
        end
    end
    
    fprintf('   %d of %d.  TuneX = %.5f    TuneY = %.5f   Time %.1f\n', i, N, Tune_Vec(1,i), Tune_Vec(2,i), toc);
    tic;
end

Tune = mean(Tune_Vec,2)

nuy

%save PingerTuneYMeasurement2 t Tune_Vec Tune HPingerVolts VPingerVolts


% % Zero pinger high voltage
% setsp('SR02S___PINGH__AC02',0);
% setsp('SR02S___PINGV__AC00',0);
% 
% 
% % Start table execution
% setsp('SR01C___TIMING_AC11', 1);
% 
% % Switch to table execution mode. Starts filling from last table position
% setsp('SR01C___TIMING_AC13', 1);


% if InfoFlag
%     fprintf('\n  Horizontal Tune = %f\n', 14+Tune(1));
%     fprintf('    Vertical Tune =  %f\n\n', 8+Tune(2));
% end