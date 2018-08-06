% Add to startup.m to revert to pre-2014b color order
co = [0 0 1;
      0 0.5 0;
      1 0 0;
      0 0.75 0.75;
      0.75 0 0.75;
      0.75 0.75 0;
      0.25 0.25 0.25];
set(groot,'defaultAxesColorOrder', co);
clear co


clear
if 0
    Prefix  = 'SR01C:BPM3';
    BPMName = 'AFE 111, CTS BPM3';
elseif 0
    Prefix  = 'SR01C:BPM4';
    BPMName = 'AFE 98, CTS BPM4';
elseif 1
    Prefix  = 'SR01C:BPM5';
    BPMName = 'AFE 53, Lorch BPM5';
end

Attn = 0:31;

rfMagPV = [
    [Prefix, ':ADC0:rfMag']
    [Prefix, ':ADC1:rfMag']
    [Prefix, ':ADC2:rfMag']
    [Prefix, ':ADC3:rfMag']
    ];

ADCPeakPV = [
    [Prefix, ':ADC0:peak']
    [Prefix, ':ADC1:peak']
    [Prefix, ':ADC2:peak']
    [Prefix, ':ADC3:peak']
    ];

ptHiMagPV = [
    [Prefix,':ADC0:ptHiMag']
    [Prefix,':ADC1:ptHiMag']
    [Prefix,':ADC2:ptHiMag']
    [Prefix,':ADC3:ptHiMag']
];

ptLoMagPV = [
    [Prefix,':ADC0:ptLoMag']
    [Prefix,':ADC1:ptLoMag']
    [Prefix,':ADC2:ptLoMag']
    [Prefix,':ADC3:ptLoMag']
];

GainFactorPV = [
    [Prefix,':ADC0:gainFactor']
    [Prefix,':ADC1:gainFactor']
    [Prefix,':ADC2:gainFactor']
    [Prefix,':ADC3:gainFactor']
];

for i = 1:length(Attn)
    setpv([Prefix, ':attenuation'], Attn(i));
    pause(5);
    
    x(1,i) = getpvonline([Prefix, ':SA:X']);
    x(2,i) = getpvonline([Prefix, ':SA:Y']);
    x(3,i) = getpvonline([Prefix, ':SA:Q']);
    x(4,i) = getpvonline([Prefix, ':SA:S']);
    
    RMS10k(1,i) = getpvonline([Prefix, ':SA:RMS:wide:X']);
    RMS10k(2,i) = getpvonline([Prefix, ':SA:RMS:wide:Y']);
    
    RMS200(1,i) = getpvonline([Prefix, ':SA:RMS:narrow:X']);
    RMS200(2,i) = getpvonline([Prefix, ':SA:RMS:narrow:Y']);

    ADCPeak(:,i)    = getpv(ADCPeakPV);
    rfMag(:,i)      = getpv(rfMagPV);
    ptLoMag(:,i)    = getpv(ptLoMagPV);
    ptHiMag(:,i)    = getpv(ptHiMagPV);
    GainFactor(:,i) = getpv(GainFactorPV);
    
end

setpv([Prefix, ':attenuation'], Attn(1));

%save ATTN_Scan_CTS_BPM3_PTOn_Set3
save ATTN_Scan_Lorch_BPM5_PTOff_Set1


%% plot

figure(7);

% if 1
%     load ATTN_Scan_CTS_Set1
%     figure(1);
% elseif 1
%     %load ATTN_Scan_Lorch_Set1
%     %load ATTN_Scan_Lorch_Set2
%     load ATTN_Scan_Lorch_BPM5_PTOn_Set1
%     load ATTN_Scan_Lorch_BPM5_PTOff_Set1
%     %figure(7);
% end

GridFlag = 'On';

clf reset
h = subplot(4,1,1);
plot(Attn, x(1,:) - x(1,1), '.-b');
hold on 
plot(Attn, x(2,:) - x(2,1), '.-g');
hold off
xlabel('Attenuation');
ylabel('Orbit [mm]');
title([BPMName, ':  Attenuator Sweep']);
grid(GridFlag);
legend('x','y', 'Location','Best');

h(2) = subplot(4,1,2);
semilogy(Attn, [RMS10k; RMS200], '.-');
xlabel('Attenuation');
ylabel('RMS [\mum]');
axis tight
%yaxis([.03 1]);
grid(GridFlag);
legend('x 10kHz','y 10kHz','x 200Hz','y 200Hz', 'Location','Best');

h(3) = subplot(4,1,3);
semilogy(Attn, rfMag, '.-');
xlabel('Attenuation');
ylabel('RF Mag');
axis tight
grid(GridFlag);

h(4) = subplot(4,1,4);
semilogy(Attn, ADCPeak, '.-');
xlabel('Attenuation');
ylabel('ADC Peak [Counts]');
axis tight
grid(GridFlag);

linkaxes(h, 'x');
xaxis([0 31]);


%% 

% % Paa(f=30.466MHz) / Paa(f=26.277MHz)  % SINAD definition?
% % a.nHarmOrbit = 3201   a.f(a.nHarmOrbit) = 30.466e+06
% % a.nHarmPT    = 3121   a.f(a.nHarmPT)    = 29.704e+06
% % a.nHarmTP    = 2761   a.f(a.nHarmTP)    = 26.277e+06
% a = bpm_adc2psd(ADC99, ENV99, 11);
% a.Paa(a.nHarmOrbit)
% a.Paa(a.nHarmTP)
% s1=a.Paa(a.nHarmOrbit) / a.Paa(a.nHarmTP)
% 
% a = bpm_adc2psd(ADC99_25, ENV99, 21);
% a.Paa(a.nHarmOrbit)
% a.Paa(a.nHarmTP)
% s2=a.Paa(a.nHarmOrbit) / a.Paa(a.nHarmTP)
% 
% s1/s2


