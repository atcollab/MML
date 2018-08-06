function [FA_Noise, ENV_Noise] = bpm_fa_noisefloor(h, Plane)
% To add noise floor to a plot


%load BPM1_4_FA_NoiseFloor.mat
load bpmTest004_FA_500mA_NoiseFloor

if nargin < 1 || isempty(h)
    h = gcf;
end
if nargin < 2 || isempty(Plane)
    Plane = 1;
end

if strcmpi(get(h, 'type'), 'figure')
    subplot(2,1,1);
    hold on;
    loglog(FA_Noise.PSD.f(3:end), 1e6*FA_Noise.PSD.T1*FA_Noise.PSD.Pxx(3:end), 'k');
    hold off
    
    subplot(2,1,2);
    hold on;
    loglog(FA_Noise.PSD.f(3:end), 1e6*FA_Noise.PSD.Pxx_int(3:end), 'k');
    hold off
    
    RMSx = sqrt(1e6*FA_Noise.PSD.Pxx_int(end));
    
elseif strcmpi(get(h, 'type'), 'axes')
    % axes
    if Plane == 1
        hold on
        loglog(FA_Noise.PSD.f(3:end), 1e6*FA_Noise.PSD.T1*FA_Noise.PSD.Pyy(3:end), 'k');
        hold off
    else
        hold on
        loglog(FA_Noise.PSD.f(3:end), 1e6*FA_Noise.PSD.Pyy_int(3:end), 'k');
        hold off
    end
end
