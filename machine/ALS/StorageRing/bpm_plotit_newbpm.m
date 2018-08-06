function varargout = bpm_plotit_newbpm(varargin)
% function varargout = bpm_plotit_newbpm(varargin)
%
% Plot 10 kHz data from new BPMs
% Christoph Steier, 2015-01-16

BPMnames ={
'SR01C:BPM2:SA:X'    
'SR01C:BPM7:SA:X'    
'SR01C:BPM8:SA:X'    
'SR02C:BPM2:SA:X'    
'SR02C:BPM7:SA:X'    
'SR03C:BPM2:SA:X'    
'SR03C:BPM7:SA:X'    
'SR03C:BPM8:SA:X'    
% 'SR04C:BPM1:SA:X'    
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

BPMlist = [
     1     3
     1     8
     1     9
     2     3
     2     8
     3     3
     3     8
     3     9
%     4     2
     4     3
     4     8
     4     9
     5     2
     5     3
     5     8
     5     9
     6     2
     6     3
     6     8
     6     9
     7     2
     7     3
     7     8
     7     9
     8     2
     8     3
     8     8
     8     9
     9     2
     9     3
     9     8
     9     9
    10     2
    10     3
    10     8
    10     9
    11     2
    11     3
    11     8
    11     9
    12     2
    12     3
    12     8];

    
% Needed for standalone, if using MML functions that require the AO,AD setup or setting up LabCA
checkforao;

global THERING

fullBPMlist=getbpmlist('IgnoreStatus');
BPMi = findrowindex(BPMlist, fullBPMlist);
 
dt = 1/10000;

for loop=1:length(BPMnames)
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:FA:arm'],0);
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:FA:acqCount'],50000);
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:FA:triggerMask'],bin2dec('01000000'));
    setpvonline([BPMnames{loop}(1:end-4) 'EVR:event12trig'],bin2dec('01000000'));
end


while (getpv('GTL_____TIMING_BC00')==0) || (getpv('SR01S___BUMP1__BC21')==0)
    pause(0.05);
end

pause(2*1.4+0.2);

    for loop=1:length(BPMnames)
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:FA:arm'],1);        
    end

    labelstr2=sprintf('%s',datestr(now));

    while getpv([BPMnames{loop}(1:end-4) 'wfr:FA:armed'])
        pause(0.2);
    end
    
    pause(5);

    for loop=1:length(BPMnames)
        sum(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:FA:c3'], 'Waveform', 10000);
        bpmx(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:FA:c0'], 'Waveform', 10000)/1e6;
        bpmy(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:FA:c1'], 'Waveform', 10000)/1e6;
    end
    
    bpmxm=bpmx'-ones(length(bpmx),1)*mean(bpmx');
    bpmym=bpmy'-ones(length(bpmy),1)*mean(bpmy');
    
    BPMind=findcells(THERING,'FamName','BPM');
    spos=findspos(THERING,BPMind);

    figure
    subplot(2,1,1)
    plot((1:length(bpmx))*dt,bpmxm)
    title('x-orbit')
    xlabel('t [s]')
    ylabel('x [mm]');
    subplot(2,1,2)
    [dummy,sind]=sort(spos(BPMi));
    plot(spos(BPMi(sind)),bpmxm(:,sind)')
    xlabel('s [m]');
    ylabel('x [mm]');
    addlabel(0,0,labelstr2,10);

    figure
    Sx = getrespmat('BPMx',fullBPMlist(BPMi(sind),:),'HCM',getcmlist('Horizontal','1 8'),'Physics');
    for loop=1:length(bpmxm)
        corrdata(:,loop)=Sx\bpmxm(loop,sind)';
    end
    subplot(2,1,1)
    plot((1:length(bpmx))*dt,corrdata')
    title('x-corrector strength')
    xlabel('t [s]')
    ylabel('x-corr [A]');
    subplot(2,1,2)
    bar(max(corrdata')-min(corrdata'))    
    xlabel('Corrector #')
    ylabel('max-min [A]');
    
    figure
    subplot(2,1,1)
    plot((1:length(bpmy))*dt,bpmym)
    title('y-orbit')
    xlabel('t [s]')
    ylabel('y [mm]');
    subplot(2,1,2)
    [dummy,sind]=sort(spos(BPMi));
    plot(spos(BPMi(sind)),bpmym(:,sind)')
    xlabel('s [m]');
    ylabel('y [mm]');
    addlabel(0,0,labelstr2,10);

    figure
    Sy = getrespmat('BPMy',fullBPMlist(BPMi(sind),:),'VCM',getcmlist('Vertical','1 8'),'Physics');
    for loop=1:length(bpmym)
        corrdata(:,loop)=Sy\bpmym(loop,sind)';
    end
    subplot(2,1,1)
    plot((1:length(bpmy))*dt,corrdata')
    title('y-corrector strength')
    xlabel('t [s]')
    ylabel('y-corr [A]');
    subplot(2,1,2)
    bar(max(corrdata')-min(corrdata'))    
    xlabel('Corrector #')
    ylabel('max-min [A]');
