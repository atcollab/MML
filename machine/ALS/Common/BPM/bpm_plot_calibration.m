function bpm_plot_calibration(FileName_TurnOnData)

DirStart = pwd;

if nargin < 1
    gotodirectory('/home/als/physdata/BPM/AttnCalibration/AFE2_Rev2');
    [FileName_TurnOnData, PathName] = uigetfile('TurnOnData*.mat', 'Pick a TurnOn file:');
    if ~ischar(FileName_TurnOnData)
        return;
    end
    cd (PathName);
end

load(FileName_TurnOnData);

if exist('ADC_Tone_Off', 'var')
    bpm_adc2psd(ADC_Tone_Off, ENV, 111);
end
bpm_adc2psd(ADC, ENV, 121);

% plot SA
bpm_plotsa(SA, 131);


% Test the attn table %
figure(101);
clf reset
subplot(3,1,1);
plot(attn, x);
ylabel('x [mm]');
subplot(3,1,2);
plot(attn, y);
ylabel('y [mm]');
subplot(3,1,3);
plot(attn, [a;b;c;d]);
ylabel('A B C D');
xlabel('Attenuator');


%fprintf('   Test data         saved to  %s.csv\n', FileName);
a = dir(['*', FileName(12:26),'*']);
for i = 1:length(a)
    fprintf('   %s\n', a(i).name);
end

cd(DirStart);

