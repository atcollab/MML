
% Sync to the booster cycle
[Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, Timeout after 2 seconds

[startcurr,tout,t2,errnum] = getdcct;
curr_meas_time = gettime;
startcurr2 = 1000*getpvonline('SR05W___DCCT2__AM01');  % Old DCCT (GJP 2017-09-01)
%  startcurr2 = getpv('SR09S___DCCT___AM03');              % IRM channel for sector 9 DCCT  (GJP 2017-09-01)???
startcam1=getcamcurrent_local('Cam1_current');
startcam2=getcamcurrent_local('Cam2_current');


% Sync to the booster cycle
[Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, Timeout after 2 seconds

[Counter, Ts, Err] = synctoevt(48, 2);   % Sync to KE???, Timeout after 2 seconds
% Check timing of ztec to Evt 48???

[btscharge, t] = getam(['BTS_____ICT01__AM00';'BTS_____ICT02__AM01'], 0:.05:.3);  % These always update, really difficult to used???
btscharge1 = max(btscharge(1,:));
btscharge2 = max(btscharge(2,:));

BTS_ICT1 = getpv(['BTS:ICT1';'BTS:ICT2']);  % From the ztec13 scope
trigcnt1=getpv('ztec13:Inp1WaveCount');


trigcnt1=getpv('ztec13:Inp1WaveCount');

if (trigcnt1>trigcnt0)  % (btscharge1>1.0)  || (btscharge2>1.0) % || (trigcnt1>trigcnt0)
    fprintf('Extraction from booster detected\n');
    extractflag=1;
    pause(0.1);
    %        btscharge1=getam('BTS_____ICT01__AM00');
    %        btscharge2=(-1)*getam('BTS_____ICT02__AM01');
    %        btscharge=max([btscharge1 btscharge2]);
    %        if btscharge1>2.0
    %            btscharge=btscharge1;
    %         else
    ictdata=lcaGet('ztec13:Inp1ScaledWave',1000);
    % btscharge=(-1.5*5)*min(ictdata);
    [~,ictind]=min(ictdata);
    btscharge=sum(ictdata(ictind-22:ictind+35))/(-2.92);
else
    btscharge=0;
end



stopcurr=getdcct;
time_diff = (gettime-curr_meas_time);
lifetime=getpv('Topoff_lifetime_AM');
stopcurr2=1000*getpvonline('SR05W___DCCT2__AM01');
%startcurr2 = getpv('SR09S___DCCT___AM03');              % IRM channel for sector 9 DCCT  (GJP 2017-09-01)???


eff=((stopcurr-(startcurr-time_diff*startcurr/3600/lifetime))/1.5)/(btscharge/5);
eff2=((stopcurr2-(startcurr2-time_diff*startcurr2/3600/lifetime))/1.5)/(btscharge/5);
eff3=((stopcurr2-(startcurr2-2.0*startcurr2/3600/lifetime))/1.5)/(btscharge/5);
inj_rate = (stopcurr2-(startcurr2-time_diff*startcurr2/3600/lifetime));
fprintf('%s: Injection efficiency %g (%g, %g)\n',datestr(now),eff2,eff,eff3);

