function varargout = bpm_sum_signal_first_turns(varargin)
% function varargout = bpm_sum_signal_first_turns(varargin)
%
% Plot turn by turn data
% Christoph Steier, 2014-10-29

BPMnames ={
'SR01C:BPM2:SA:X'    
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

for loop=1:length(BPMnames)
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],0);
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:triggerMask'],bin2dec('01000000'));
    setpvonline([BPMnames{loop}(1:end-4) 'EVR:event12trig'],bin2dec('01000000'));
    setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:acqCount'],100000);
end
% 
%     for loop=1:length(BPMnames)
%         setpvonline([BPMnames{loop}(1:end-4) 'attenuation'],2);        
%     end

f1 = figure;
f2 = figure;

while 1
    while (getpv('GTL_____TIMING_BC00')==0) || (getpv('SR01S___BUMP1P_BC22')==0)
        pause(0.05);
    end
    
%    pause(1.0);
    
    for loop=1:length(BPMnames)
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],1);        
    end
    
    while getpv([BPMnames{1}(1:end-4) 'wfr:TBT:armed'])
        pause(0.2);
    end
    
    pause(5);
    
    for loop=1:length(BPMnames)
        sum(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c3']);
        bpmx(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c0'])/1e6;
        bpmy(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c1'])/1e6;
    end
 
    [dummy,ind] = max(bpmx(1,:));
    if isnan(ind) | isempty(ind)
        ind = min([45000 length(sum(1,:))]);
    end
    
    bpmxsub=bpmx'-ones(length(bpmx),1)*mean(bpmx');
    bpmysub=bpmy'-ones(length(bpmy),1)*mean(bpmy');
    sumsub=sum'-ones(length(sum),1)*mean(sum');

%    ind3=find(sum(1,:)>5e4);
    ind3=1:length(sum);
    
    figure(f1);
    subplot(3,1,1)
    plot(bpmxsub(ind3,:))
    xaxis([ind-100 ind+1000]);
    ylabel('x [mm]');
    subplot(3,1,2)
    plot(bpmysub(ind3,:))
    xaxis([ind-100 ind+1000]);
    ylabel('y [mm]');
    subplot(3,1,3)
    plot(sumsub(ind3,:))
    axis tight;
    xaxis([ind-100 ind+1000]);
    xlabel('Turn #');
    ylabel('Sum Signal (average removed)');
    
    
    ind2=find(abs(bpmxsub(ind+1000,:))<0.05);
    if isempty(ind2)
        ind2=size(bpmxsub,2);
    end
    
    figure(f2);
    subplot(3,1,1)
    plot(bpmxsub(:,ind2))
    xaxis([ind-1000 ind+2000]);
    ylabel('x [mm]');
    subplot(3,1,2)
    plot(bpmysub(:,ind2))
    xaxis([ind-1000 ind+2000]);
    ylabel('y [mm]');
    subplot(3,1,3)
    plot(sumsub(:,ind2))
    axis tight;
    xaxis([ind-1000 ind+2000]);
    xlabel('Turn #');
    ylabel('Sum Signal (average removed)');
    

end