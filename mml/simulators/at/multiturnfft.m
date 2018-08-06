function [X, f] = multiturnfft(x, LineType);
%MULTITURNFFT - Takes the FFT of multiple turn data (plots results if no output exists)
%
%  [X, f] = multiturnfft(x, LineType);
%
%  INPUTS
%  1. x - Multiple turn data ((#BPM x N turns) or (BPM x N turns x 6))
%  2. LineType - Line type if plotting FFT data {Default: 'b'}
%
%  OUTPUTS
%  1. X - FFT data
%  2. f - Frequency vector
%
%  NOTES
%  1. If x is (NumberOfBPMs x N x 6), then x(:,:,1) will automatically squeeze to a 2-dimensional matrix.
%     For example, x = x(1,:,1) would be a 1 x N vector.
%
%  EXAMPLES
%  1. Get 1024 turns at BPM(1,2) and compute the FFT
%     [x, ATIndex, LostBeam] = getturns([.001 0, 0.001, 0, 0, 0]', 1024, 'BPMx', [1 2;6 3]);
%     [X,  fx] = multiturnfft(x(1,:,:));  
%      X(:,1) is FFT(x)
%      X(:,2) is FFT(Px)
%      X(:,3) is FFT(y)
%      X(:,4) is FFT(Py)
%  2. To plot the FFT(x) data for the BPM(1,2):
%     multiturnfft(x(1,:,1));
%     To plot the FFT(y) data for the BPM(6,3)
%     multiturnfft(x(2,:,3));  
%  3. Multiple BPM can be used but some case should be taken to keep the phase change 
%     between BPMs roughly equal.  
%     For instace, to plot the FFT(x) data of all BPMs for the first 10 turns:
%     [x, ATIndex, LostBeam] = getturns([.001 0, 0.001, 0, 0, 0]', 10, 'BPMx', []);
%     multiturnfft(x(:,:,1));  
%
%  See also getturns, getpvmodel

%  Written by Greg Portmann


if nargin == 0
    error('1 input required.');
end
if nargin < 2
    LineType = 'b';
end


% How many BPMs in the FFT
nBPM = size(x,1);


% How many turns
N = size(x,2);


% x, Px, y, Py case
if size(x,3) ~= 1
    for i = 1:min(size(x,3),4)
        if nargout == 0
            if i == 1
                clf reset
                multiturnfft(squeeze(x(:,:,i)), N, LineType);
                subplot(2,1,1);
                if nBPM > 1
                    title(sprintf('%d BPMs  %d Turns:  x(0) = %.3g [mm]  Px(0) = %.3g [mrad]  y(0) = %.3g [mm]  Py(0) = %.3g [mrad]', nBPM, N, 1000*x(1,1,1), 1000*x(1,1,2), 1000*x(1,1,3), 1000*x(1,1,4)));
                else
                    title(sprintf('%d Turns:  x(0) = %.3g [mm]  Px(0) = %.3g [mrad]  y(0) = %.3g [mm]  Py(0) = %.3g [mrad]', N, 1000*x(1,1,1), 1000*x(1,1,2), 1000*x(1,1,3), 1000*x(1,1,4)));
                end
                ylabel('Horizontal Orbit [mm]');
            elseif i == 2
            elseif i == 3
                figure(gcf+1);
                multiturnfft(squeeze(x(:,:,i)), N, LineType);
                subplot(2,1,1);
                if nBPM > 1
                    title(sprintf('%d BPMs  %d Turns:  x(0) = %.3g [mm]  Px(0) = %.3g [mrad]  y(0) = %.3g [mm]  Py(0) = %.3g [mrad]', nBPM, N, 1000*x(1,1,1), 1000*x(1,1,2), 1000*x(1,1,3), 1000*x(1,1,4)));
                else
                    title(sprintf('%d Turns:  x(0) = %.3g [mm]  Px(0) = %.3g [mrad]  y(0) = %.3g [mm]  Py(0) = %.3g [mrad]', N, 1000*x(1,1,1), 1000*x(1,1,2), 1000*x(1,1,3), 1000*x(1,1,4)));
                end
                ylabel('Vertical Orbit [mm]');
            elseif i == 4
            end
        else
            X(:,i) = multiturnfft(squeeze(x(:,:,i)), N, LineType);
        end
    end
    return
    
    %if size(x,3) ~= 1
    %    fprintf('   x-input has too many dimensions, squeezing to 2-dim -- squeeze(x(1,:,:)).\n');
    %    x = squeeze(x(1,:,:));
    %end
end



% FFT
X = fft(x(:), nBPM*N);    % FFT
X(1) = [];                % Remove the DC term


f = (1:floor(nBPM*N/2)) / N;  % Frequency vector



if nargout == 0
    % Plot the results    
    Xmax = N; %min([100 N]);

    subplot(2,1,1);
    plot(1000*x(:));
    %plot(1:size(x,2), 1000*x);
    %plot(1000*x');
    %xaxis([0 Xmax]);
    axis tight
    if nBPM > 1
        title(sprintf('%d BPMs  %d Turns', nBPM, N));
    else
        title(sprintf('%d Turns', N));
    end
    ylabel('Data');
    if N == 1
        xlabel('First Turn');
    elseif nBPM == 1
        xlabel('Turn Number');
    else
        xlabel('');
    end
    
    %     if size(x,1) >= 4
    %         plot(1000*x, LineType);
    %         xaxis([0 Xmax]);
    %         title(sprintf('%d Total Turns:  x(0)=%.3g [mm] xp(0)=%.3g [mrad]', N, 1000*x(1,1), 1000*x(1,2)));
    %         ylabel('Horizontal [mm]');
    %     else
    %         plot(x, LineType);
    %         xaxis([0 Xmax]);
    %         title(sprintf('FFT of Single Turn Data (%d turns, Initial Conition = %.3g)', N, x(1,1)));
    %         ylabel('Data');
    %     end

    subplot(2,1,2);
    semilogy(f, abs(X(1:floor(nBPM*N/2),1)), LineType);
    xaxis([0 .5*nBPM]);
    grid on;

    if nBPM > 1
        xlabel('Tune');
    else
        xlabel('Fractional Tune');
    end

    ylabel('abs(FFT)');
end


