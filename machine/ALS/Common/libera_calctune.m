function [Tune, Tune_Vec] = libera_calctune(N,InfoFlag)
% | Higher Fractional Tune (X) |
% |                            | = libera_calctune(InfoFlag)
% |  Lower Fractional Tune (Y) |
%

if nargin < 1
    N = 50;
end

if nargin < 2
    if nargout == 0
        InfoFlag = 1;
    else
        InfoFlag = 0;
    end
end

% Get Orbit
liberaData = getlibera('DD3', [12 5], 0);

for i = 1:N

    fx = 1e-3*liberaData.DD_X_MONITOR(1:1024)';
    fy = 1e-3*liberaData.DD_Y_MONITOR(1:1024)';
      
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
        if (nuy(n) < 0.33) && (nuy(n) < (Tune_Vec(1,i)-0.001))
            Tune_Vec(2,i) = nuy(n);
            break;
        end
    end
    
    fprintf('   %d of %d. Time %.1f\n', i, N, toc);
end

Tune = mean(Tune_Vec,2);

if InfoFlag
    fprintf('\n  Horizontal Tune = %f\n', 14+Tune(1));
    fprintf('    Vertical Tune =  %f\n\n', 8+Tune(2));
end