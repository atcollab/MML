function plot_first_turns_multi_newbpm_oneshot(varargin)
% plot_first_turns_multi_newbpm_oneshot
%
% Christoph Steier

checkforao;

if getdcct > 1.0
    soundtada;
    error('This routine can only be used if there is no stored beam - otherwise turn by turn BPMs only see stored beam - dcct is >1.0 mA');
end
    
% Names of all new NSLS-2 style BPMS
BPMnames ={
    'SR01C:BPM2:SA:X'
    'SR01C:BPM6:SA:X'
    'SR01C:BPM7:SA:X'
    'SR01C:BPM8:SA:X'
    'SR02C:BPM2:SA:X'
    'SR02C:BPM7:SA:X'
    'SR03C:BPM2:SA:X'
    'SR03C:BPM7:SA:X'
    'SR03C:BPM8:SA:X'
    'SR04C:BPM1:SA:X'
    'SR04C:BPM2:SA:X'
    'SR04C:BPM7:SA:X'
    'SR04C:BPM8:SA:X'
    'SR05C:BPM1:SA:X'
    'SR05C:BPM2:SA:X'
    'SR05C:BPM7:SA:X'
    'SR05C:BPM8:SA:X'
    'SR06C:BPM1:SA:X'
    'SR06C:BPM2:SA:X'
    'SR06C:BPM7:SA:X'
    'SR06C:BPM8:SA:X'
    'SR07C:BPM1:SA:X'
    'SR07C:BPM2:SA:X'
    'SR07C:BPM7:SA:X'
    'SR07C:BPM8:SA:X'
    'SR08C:BPM1:SA:X'
    'SR08C:BPM2:SA:X'
    'SR08C:BPM7:SA:X'
    'SR08C:BPM8:SA:X'
    'SR09C:BPM1:SA:X'
    'SR09C:BPM2:SA:X'
    'SR09C:BPM7:SA:X'
    'SR09C:BPM8:SA:X'
    'SR10C:BPM1:SA:X'
    'SR10C:BPM2:SA:X'
    'SR10C:BPM7:SA:X'
    'SR10C:BPM8:SA:X'
    'SR11C:BPM1:SA:X'
    'SR11C:BPM2:SA:X'
    'SR11C:BPM7:SA:X'
    'SR11C:BPM8:SA:X'
    'SR12C:BPM1:SA:X'
    'SR12C:BPM2:SA:X'
    'SR12C:BPM7:SA:X'
    };


Directory = getfamilydata('Directory','DataRoot');
 if ispc
     load([Directory 'BPM\golden_injection_trajectory_20160125.mat']);
 else
     load([Directory 'BPM/golden_injection_trajectory_20160125.mat']);
 end


allname=getname('BPMx');
alllist=getlist('BPMx');

count=1;
for loop = 1:length(allname)
    if strfind(allname(loop,:),'SA')
        bpmind(count,1:2)=alllist(loop,:);
        count=count+1;
    end
end

% Initialize BPMs for injection triggering of TBT mode
for loop=1:length(BPMnames)
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],0);
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:triggerMask'],bin2dec('01000000'));
    setpvonline([BPMnames{loop}(1:end-4) 'EVR:event12trig'],bin2dec('01000000'));
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:acqCount'],100000);
    setpvonline([BPMnames{loop}(1:end-4) 'buttonDSP'],0);
%    setpvonline([BPMnames{loop}(1:end-4) 'autotrim:threshold'],100);
    if getdcct2 < 15
        setpvonline([BPMnames{loop}(1:end-4) 'attenuation'],0);
    end
end

sum=zeros(length(BPMnames),100000);
bpmx=zeros(length(BPMnames),100000);
bpmy=zeros(length(BPMnames),100000);

sum2=zeros(length(BPMnames),2510);
bpmx2=zeros(length(BPMnames),2510);
bpmy2=zeros(length(BPMnames),2510);

f1=figure;
f2=figure;
% f3=figure;
% f4=figure;

setsp('SR01C___TIMING_AC11',0);
setsp('SR01C___TIMING_AC13',0);
setsp('SR01C___TIMING_AC08',308);

pause(1);

    wait_for_booster_peak_field;
    
    setpv('GTL_____TIMING_BC00',1);

    tic
    % Arm BPMs for triggering
    for loop=1:length(BPMnames)
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],1);
    end
    toc

    pause(1);
        
    % Check, whether BPM data acquisition has finished
    while getpv([BPMnames{1}(1:end-4) 'wfr:TBT:armed'])
        pause(0.2);
    end

    setpv('GTL_____TIMING_BC00',0);

    % Wait for data acquisition to definitively be complete
    pause(1);
        
    % Read TBT data from BPMs
    for loop=1:length(BPMnames)
        sum(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c3']);
        bpmx(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c0'])/1e6;
        bpmy(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c1'])/1e6;
    end
    
    if sum(end,1) > 2e4
        soundtada;
        error('This routine can only be used if there is no stored beam - otherwise turn by turn BPMs only see stored beam - sum(BPM1,turn1)>2e4');
    end
    
    % find injection turn
    [dummy,injind]=max(diff(sum'));
    
     if any(injind<100) || any(injind>45000)
             for loop = 1:length(injind)
                 if (injind(loop)<100) || (injind(loop)>45000)
                    injind(loop) = 27480;
                 end
             end
     end
    
    for loop=1:length(BPMnames)
        sum2(loop,:)=sum(loop,(injind(loop)-9):(injind(loop)+2500));
        bpmx2(loop,:)=bpmx(loop,(injind(loop)-9):(injind(loop)+2500));
        bpmy2(loop,:)=bpmy(loop,(injind(loop)-9):(injind(loop)+2500));
    end
    
    timevec=654e-9*(1:length(sum2(1,:)));
    
    % Figure 1 - turn wise plot
    figure(f1);
    subplot(3,1,1);
    plot((1:length(sum2)),cat(1,sum2)');
    xaxis([-10 2500]);
    
    ind = find(sum2(1,:)<1e2);
    for loop=1:size(sum2,1)
        bpmx2(loop,ind)=NaN;
        bpmy2(loop,ind)=NaN;
    end
  
    subplot(3,1,2);
    plot((1:length(bpmx2)),cat(1,bpmx2)');
    axis([-10 2500 -15 15]);
    
    subplot(3,1,3);
    plot((1:length(bpmy2)),cat(1,bpmy2)');
    axis([-10 2500 -10 10]);
    
    % Figure 2 - BPM wise plot
    figure(f2);
    subplot(3,1,1);
    plot((1:size(sum2,1)*size(sum2,2))./size(sum2,1)-9,reshape(sum2,size(sum2,1)*size(sum2,2),1),'r.-')    
    hold on
    plot((1:size(sum3,1)*size(sum3,2))./size(sum3,1)-9,reshape(sum3,size(sum3,1)*size(sum3,2),1),'b.-')        
    xaxis([0 6]);
    legend('current shot')
    
    subplot(3,1,2);
    plot((1:size(bpmx2,1)*size(bpmx2,2))./size(bpmx2,1)-9,reshape(bpmx2,size(bpmx2,1)*size(bpmx2,2),1),'r.-');
    hold on
    plot((1:size(bpmx3,1)*size(bpmx3,2))./size(bpmx3,1)-9,reshape(bpmx3,size(bpmx3,1)*size(bpmx3,2),1),'b.-');
    axis([0 6 -15 15]);
    
    subplot(3,1,3);
    plot((1:size(bpmy2,1)*size(bpmy2,2))./size(bpmy2,1)-9,reshape(bpmy2,size(bpmy2,1)*size(bpmy2,2),1),'r.-');
    hold on
    plot((1:size(bpmy3,1)*size(bpmy3,2))./size(bpmy3,1)-9,reshape(bpmy3,size(bpmy3,1)*size(bpmy3,2),1),'b.-');    
    axis([0 6 -5 5]);

setsp('SR01C___TIMING_AC11',255);
setsp('SR01C___TIMING_AC13',255);


%-------------------------------------------------
function peakflag=wait_for_booster_peak_field(varargin)
t0=gettime;peakflag=0;
% New Timing system does not support booster delay adjustment, so remoevd added delay here - Christoph Steier, 2015-01-10
while ((gettime-t0)<1.5)
    % Changed to use readback from Bend magnet DPSC, instead of miniIOC
    bend_curr=getam('BR1_____B__PS__AM00');
    pause(0.1);
    % Changed to use readback from Bend magnet DPSC, instead of miniIOC
    if getam('BR1_____B__PS__AM00')<(bend_curr-1e5)
        fprintf('Passed booster peak field - synchronizing timing\n');
        peakflag=1;
        break
    end
end
return

