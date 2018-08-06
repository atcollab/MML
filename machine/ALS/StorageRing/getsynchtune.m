function [ fs_kHz ] = getsynchtune(N)
% function [ fs_kHz ] = getsynchtune(varargin)
% Measures and returns synchrotron tune frequency in kHz
% 
% Simon C. Leemann, Fernando Sannibale, October 2017
%
% 2017-11-27: minor modifications to output -SCL

N; % number of averages (input argument)
fs0=6; % initial synchr. freq in kHz
span_kHz=1; % drive span [kHz]

pattern0='285:292'; % excitation pattern
LFBmarkerMinFreq_kHz=5.2; %lower freq. limit for LFB marker 2
%LFBmarkerMinFreq_kHz=7.2; %lower freq. limit for LFB marker 2
LFBmarkerMaxFreq_kHz=7; %higher freq. limit for LFB marker 2
%pattern0='308'; % excitation pattern
%LFBmarkerMinFreq_kHz=5.5; %lower freq. limit for LFB marker 2
%LFBmarkerMaxFreq_kHz=6.3; %higher freq. limit for LFB marker 2

ExcAmp=1; % Excitation amplitude. Max value is 1
ExcPeriod_us=.1; %excitation scan duration in us
waittime=.5; %waiting time in s

['Be patient please, it takes ~',num2str(waittime*N+2),' seconds to provide the result']


prevAvg=getpv('IGPF:LFB:SP:AVG'); % averaging mode
prevLO=getpv('IGPF:LFB:SP_LOW2'); % lower limit for peak search
prevHI=getpv('IGPF:LFB:SP_HIGH2'); % upper limit for peak search
prevMode=getpv('IGPF:LFB:SP_SEARCH2'); % peak search mode: 1 is max, 0 is min
prevDrvAmpl=getpv('IGPF:LFB:DRIVE:AMPL'); % drive amplitude [kHz]
prevDrvFreq=getpv('IGPF:LFB:DRIVE:FREQ'); % drive frequency
prevDrvSpan=getpv('IGPF:LFB:DRIVE:SPAN'); % drive span [kHz]
prevDrvPeriod=getpv('IGPF:LFB:DRIVE:PERIOD'); % period [uS]
prevDrvWaveform=getpv('IGPF:LFB:DRIVE:WAVEFORM'); % waveform [0=sin]
prevDrvPattern=getpv('IGPF:LFB:DRIVE:PATTERN'); % pattern

setpv('IGPF:LFB:SP:AVG',1);
setpv('IGPF:LFB:SP_LOW2',LFBmarkerMinFreq_kHz);
setpv('IGPF:LFB:SP_HIGH2',LFBmarkerMaxFreq_kHz);
setpv('IGPF:LFB:SP_SEARCH2',1);
setpv('IGPF:LFB:DRIVE:AMPL',ExcAmp);
setpv('IGPF:LFB:DRIVE:FREQ',fs0);
setpv('IGPF:LFB:DRIVE:SPAN',span_kHz);
setpv('IGPF:LFB:DRIVE:PERIOD',ExcPeriod_us);
setpv('IGPF:LFB:DRIVE:WAVEFORM',0);
setpv('IGPF:LFB:DRIVE:PATTERN',pattern0);

fs=0;

pause(2);    

for i=1:N
    %%% expanded statement so can print individual measurements
    fsn     = 0;
    fsn     = getpv('IGPF:LFB:PEAKFREQ2');
    fs      = fs+fsn;
    pause(waittime);    
end
% format long
fs_kHz = fs/N;
fprintf('synchrotron frequency = %.5f kHz\n',fs_kHz);

setpv('IGPF:LFB:SP:AVG',prevAvg);
setpv('IGPF:LFB:SP_LOW2',prevLO);
setpv('IGPF:LFB:SP_HIGH2',prevHI);
setpv('IGPF:LFB:SP_SEARCH2',prevMode);
setpv('IGPF:LFB:DRIVE:AMPL',prevDrvAmpl);
setpv('IGPF:LFB:DRIVE:FREQ',prevDrvFreq);
setpv('IGPF:LFB:DRIVE:SPAN',prevDrvSpan);
setpv('IGPF:LFB:DRIVE:PERIOD',prevDrvPeriod);
setpv('IGPF:LFB:DRIVE:WAVEFORM',prevDrvWaveform);
setpv('IGPF:LFB:DRIVE:PATTERN','290:292');

finalAvg=getpv('IGPF:LFB:SP:AVG');
finalLO=getpv('IGPF:LFB:SP_LOW2');
finalHI=getpv('IGPF:LFB:SP_HIGH2');
finalMode=getpv('IGPF:LFB:SP_SEARCH2');
finalDrvAmpl=getpv('IGPF:LFB:DRIVE:AMPL');
finalDrvFreq=getpv('IGPF:LFB:DRIVE:FREQ');
finalDrvSpan=getpv('IGPF:LFB:DRIVE:SPAN');
finalDrvPeriod=getpv('IGPF:LFB:DRIVE:PERIOD');
finalDrvWaveform=getpv('IGPF:LFB:DRIVE:WAVEFORM');
finalDrvPattern=getpv('IGPF:LFB:DRIVE:PATTERN');

end

