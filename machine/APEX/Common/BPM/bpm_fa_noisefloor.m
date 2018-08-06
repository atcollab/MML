function FA = bpm_fanoisefloor(h, Plane)
% To add noise floor to a plot


%load BPM1_4_FA_NoiseFloor.mat
load bpmTest004_FA_500mA_NoiseFloor

if isempty(h) || nargin < 1
    h = gcf;
end
if isempty(Plane) || nargin < 2
    Plane = 1;
end

if strcmpi(get(h, 'type'), 'figure')
    subplot(2,1,1);
    hold on;
    semilogy(FA.PSD.f(3:end), 1e6*FA.PSD.T1*FA.PSD.Pxx(3:end), 'k');
    hold off
    
    subplot(2,1,2);
    hold on;
    semilogy(FA.PSD.f(3:end), 1e6*FA.PSD.T1*FA.PSD.Pxx_int(3:end), 'k');
    hold off
    
elseif strcmpi(get(h, 'type'), 'axes')
    % axes
    if Plane == 1
        hold on
        semilogy(FA.PSD.f(3:end), 1e6*FA.PSD.T1*FA.PSD.Pxx(3:end), 'k');
        hold off
    else
        hold on
        semilogy(FA.PSD.f(3:end), 1e6*FA.PSD.T1*FA.PSD.Pyy_int(3:end), 'k');
        hold off
    end
end
