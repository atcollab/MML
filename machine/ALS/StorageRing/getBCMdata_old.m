function [ output_args ] = getBCMdata( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

gotophysdata
cd MiscellaneousStudies\VariableFillPattern\

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
setpv('IGPF:LFB:SP_LOW2',5.2);
setpv('IGPF:LFB:SP_HIGH2',8);
setpv('IGPF:LFB:SP_SEARCH2',1);
setpv('IGPF:LFB:DRIVE:AMPL',1);
setpv('IGPF:LFB:DRIVE:FREQ',6);
setpv('IGPF:LFB:DRIVE:SPAN',1);
setpv('IGPF:LFB:DRIVE:PERIOD',1);
setpv('IGPF:LFB:DRIVE:WAVEFORM',0);
setpv('IGPF:LFB:DRIVE:PATTERN','285:292');

N=10;
current=0;
xrms=0;
yrms=0;
tau=0;
cPwr1=0;
cPwr2=0;
cPwr3=0;
fs=0;

pause(2);    
for i=1:N
    current = current+getdcct;
    xrms    = xrms+getpv('beamline31:XRMSAve');
    yrms    = yrms+getpv('beamline31:YRMSAve');
    tau     = tau+getpv('Topoff_lifetime_AM');
    cPwr1   = cPwr1+getpv('SR02C___C1PWR__AM00');
    cPwr2   = cPwr2+getpv('SR02C___C2PWR__AM00');
    cPwr3   = cPwr3+getpv('SR02C___C3PWR__AM00');
    fs      = fs+getpv('IGPF:LFB:PEAKFREQ2');
    pause(0.5);    
end
current=current/N
xrms=xrms/N
yrms=yrms/N
tau=tau/N
cPwr1 = cPwr1/N
cPwr2 = cPwr2/N
cPwr3 = cPwr3/N
fs = fs/N

bcm=getbcm;
phase=getpv('SR1:BCM:BunchPhase');

figure(1)
plot(bcm)
figure(2)
plot(phase)

setpv('IGPF:LFB:SP:AVG',3);
setpv('IGPF:LFB:SP_LOW2',2.5);
setpv('IGPF:LFB:SP_HIGH2',8.6);
setpv('IGPF:LFB:SP_SEARCH2',0);
setpv('IGPF:LFB:DRIVE:AMPL',0);
setpv('IGPF:LFB:DRIVE:FREQ',45);
setpv('IGPF:LFB:DRIVE:SPAN',1);
setpv('IGPF:LFB:DRIVE:PERIOD',1);
setpv('IGPF:LFB:DRIVE:WAVEFORM',0);
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

