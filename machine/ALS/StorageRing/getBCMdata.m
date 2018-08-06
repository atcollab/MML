% Measures and returns fill pattern, current, beam sizes, lifetime, f_s, and HHC powers
% 
% Simon Leemann, Fernando Sannibale, October 2017
%
% 2017-12-18: modifed to use getsynchtune script to measure f_s
% 2018-2-11: added recording 3HC temperatures

gotophysdata
cd MiscellaneousStudies\VariableFillPattern\

% prevAvg=getpv('IGPF:LFB:SP:AVG'); % averaging mode
% prevLO=getpv('IGPF:LFB:SP_LOW2'); % lower limit for peak search
% prevHI=getpv('IGPF:LFB:SP_HIGH2'); % upper limit for peak search
% prevMode=getpv('IGPF:LFB:SP_SEARCH2'); % peak search mode: 1 is max, 0 is min
% prevDrvAmpl=getpv('IGPF:LFB:DRIVE:AMPL'); % drive amplitude [kHz]
% prevDrvFreq=getpv('IGPF:LFB:DRIVE:FREQ'); % drive frequency
% prevDrvSpan=getpv('IGPF:LFB:DRIVE:SPAN'); % drive span [kHz]
% prevDrvPeriod=getpv('IGPF:LFB:DRIVE:PERIOD'); % period [uS]
% prevDrvWaveform=getpv('IGPF:LFB:DRIVE:WAVEFORM'); % waveform [0=sin]
% prevDrvPattern=getpv('IGPF:LFB:DRIVE:PATTERN'); % pattern
% setpv('IGPF:LFB:SP:AVG',1);
% setpv('IGPF:LFB:SP_LOW2',5.2);
% setpv('IGPF:LFB:SP_HIGH2',8);
% setpv('IGPF:LFB:SP_SEARCH2',1);
% setpv('IGPF:LFB:DRIVE:AMPL',1);
% setpv('IGPF:LFB:DRIVE:FREQ',6);
% setpv('IGPF:LFB:DRIVE:SPAN',1);
% setpv('IGPF:LFB:DRIVE:PERIOD',1);
% setpv('IGPF:LFB:DRIVE:WAVEFORM',0);
% setpv('IGPF:LFB:DRIVE:PATTERN','285:292');

N=40;
current=0;
xrms=0;
yrms=0;
tau=0;
cPwr1=0;
cPwr2=0;
cPwr3=0;
cTmp1=0;
cTmp2=0;
cTmp3=0;
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
    cTmp1   = cTmp1+getpv('SR02C___C1BRTP_AM00');
    cTmp2   = cTmp2+getpv('SR02C___C2BRTP_AM00');
    cTmp3   = cTmp3+getpv('SR02C___C3BRTP_AM00');
    %fs      = fs+getpv('IGPF:LFB:PEAKFREQ2');
    pause(0.5);    
end
current=current/N
xrms=xrms/N
yrms=yrms/N
tau=tau/N
cPwr1 = cPwr1/N
cPwr2 = cPwr2/N
cPwr3 = cPwr3/N
cTmp1 = cTmp1/N
cTmp2 = cTmp2/N
cTmp3 = cTmp3/N
%fs = fs/N
fs = getsynchtune(N);

bcm=getbcm;
phase=getpv('SR1:BCM:BunchPhase');

 

figure(1)
plot(bcm)
figure(2)
plot(phase)



% setpv('IGPF:LFB:SP:AVG',prevAvg);
% setpv('IGPF:LFB:SP_LOW2',prevLO);
% setpv('IGPF:LFB:SP_HIGH2',prevHI);
% setpv('IGPF:LFB:SP_SEARCH2',prevMode);
% setpv('IGPF:LFB:DRIVE:AMPL',prevDrvAmpl);
% setpv('IGPF:LFB:DRIVE:FREQ',prevDrvFreq);
% setpv('IGPF:LFB:DRIVE:SPAN',prevDrvSpan);
% setpv('IGPF:LFB:DRIVE:PERIOD',prevDrvPeriod);
% setpv('IGPF:LFB:DRIVE:WAVEFORM',prevDrvWaveform);
% setpv('IGPF:LFB:DRIVE:PATTERN','290:292');
% 
% finalAvg=getpv('IGPF:LFB:SP:AVG');
% finalLO=getpv('IGPF:LFB:SP_LOW2');
% finalHI=getpv('IGPF:LFB:SP_HIGH2');
% finalMode=getpv('IGPF:LFB:SP_SEARCH2');
% finalDrvAmpl=getpv('IGPF:LFB:DRIVE:AMPL');
% finalDrvFreq=getpv('IGPF:LFB:DRIVE:FREQ');
% finalDrvSpan=getpv('IGPF:LFB:DRIVE:SPAN');
% finalDrvPeriod=getpv('IGPF:LFB:DRIVE:PERIOD');
% finalDrvWaveform=getpv('IGPF:LFB:DRIVE:WAVEFORM');
% finalDrvPattern=getpv('IGPF:LFB:DRIVE:PATTERN');

date_time=fix(clock);
name=['getBCMresults_',datestr(date_time, 'yyyy_mm_dd_HH_MM_SS')]
save(name)