% plot_first_turns_multi_newbpms
%
% Christoph Steier

checkforao;

% Names of all new NSLS-2 style BPMS
BPMnames ={
%    'SR01C:BPM2:SA:X'
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
    setpvonline([BPMnames{loop}(1:end-4) 'buttonDSP'],1);
    if getdcct2 < 15
        setpvonline([BPMnames{loop}(1:end-4) 'attenuation'],0);
    end
end


f1=figure;
f2=figure;

while 1
    % Wait for next Injection
    while (getpv('GTL_____TIMING_BC00')==0) || (getpv('SR01S___BUMP1P_BC22')==0)
        pause(0.05);
    end
    
    tic
    % Arm BPMs for triggering
    for loop=1:length(BPMnames)
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],1);
    end
    toc
    
    % Check, whether BPM data acquisition has finished
    while getpv([BPMnames{1}(1:end-4) 'wfr:TBT:armed'])
        pause(0.2);
    end
    
    % Wait for data acquisition to definitively be complete
    pause(1);
    
    
    % Read TBT data from BPMs
    for loop=1:length(BPMnames)
        sum(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c3']);
        bpmx(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c0'])/1e6;
        bpmy(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c1'])/1e6;
    end
    
    % find injection turn
    [dummy,injind]=max(sum(1,:));
    
    
    timevec=654e-9*(1:length(sum(1,:)));
    
    figure(f1);
    subplot(3,1,1);
    plot((1:length(sum))-injind,cat(1,sum)');
    xaxis([-10 250]);
    
    ind = find(sum(1,:)<2e4);
    for loop=1:size(sum,1)
        bpmx(loop,ind)=NaN;
        bpmy(loop,ind)=NaN;
    end
    
    subplot(3,1,2);
    plot((1:length(bpmx))-injind,cat(1,bpmx)');
    axis([-10 250 -10 10]);
    
    subplot(3,1,3);
    plot((1:length(bpmy))-injind,cat(1,bpmy)');
    axis([-10 250 -10 10]);

    sum2=reshape(sum,1,size(sum,1)*size(sum,2));
    bpmx2=reshape(bpmx,1,size(bpmx,1)*size(bpmx,2));
    bpmy2=reshape(bpmy,1,size(bpmy,1)*size(bpmy,2));
    
    % find injection turn
    [dummy,injind]=max(sum2);
   
    timevec2=(1:length(sum2))./size(sum,1);
    
    figure(f2);
    subplot(3,1,1);
    plot(timevec2,sum2,'.-');
    if (injind>10) & (injind<(length(sum2)-250))
        axis([timevec2(injind)-2 timevec2(injind)+10 0 1e5]);
    else
        yaxis([0 1e5]);
    end
    
    subplot(3,1,2);
    plot(timevec2,bpmx2,'.-');
    if (injind>10) & (injind<(length(sum2)-250))
        axis([timevec2(injind)-2 timevec2(injind)+10 -10 10]);
    else
        yaxis([-10 10]);
    end

    subplot(3,1,3);
    plot(timevec2,bpmy2,'.-');
    if (injind>10) & (injind<(length(sum2)-250))
        axis([timevec2(injind)-2 timevec2(injind)+10 -10 10]);
    else
        yaxis([-10 10]);
    end

    pause(0.2);
    
end


% for loop=1:length(BPMnames)
%     setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],0);
%     setpvonline([BPMnames{loop}(1:end-4) 'buttonDSP'],0);
%     bpm_setenv(BPMnames{loop}(1:end-5));
% end

