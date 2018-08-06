function save_first_turns_multi_newbpm(varargin)
% save_first_turns_multi_newbpm
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

% bpmgaing = 1.0e+005 * [ ...
%     0.6639    0.5962    0.5225    1.7245    1.9049    1.9989    1.9298    1.3526    1.7708    1.8554    1.8984    1.7618    1.9304    2.0595    1.9623    0.5255    1.6539    1.7652    1.6165 ...
%     1.7752    1.9011    2.0261    1.8401    1.7472    1.7986    1.9448    1.7968    1.7952    1.7996    2.0253    1.8657    1.6195    1.6589    0.5617    1.7485    1.4802    1.5697    1.7279 ...
%     1.5134    0.5561    0.5410    1.8685];

bpmgain = 1.0e+004 * [...
    7.7861    7.1925    6.1306    6.6496    7.3101    7.4611    7.6333    5.1163    6.5982    7.2116    7.3617 ...
    7.0210    7.0664    7.7447    7.4300    6.3058    6.3590    6.7832    6.3458    6.7084    6.8540    7.6674 ...
    7.4435    6.7842    5.7141    7.2930    6.7006    6.9350    6.9068    7.6943    7.4031    5.4184    6.4742 ...
    6.5895    6.5367    5.1115    5.6462    5.8880    5.5082    6.7017    6.3741    6.9078];

bpmgaing=bpmgain;

Directory = getfamilydata('Directory','DataRoot');
% if ispc
%     load([Directory 'BPM\golden_injection_trajectory_20150908.mat']);
% else
%     load([Directory 'BPM/golden_injection_trajectory_20150908.mat']);
% end
if ispc
    load([Directory 'BPM\golden_injection_trajectory_20160125.mat']);
else
    load([Directory 'BPM/golden_injection_trajectory_20160125.mat']);
end


allname=getname('BPMx');
alllist=getlist('BPMx');

sum=zeros(length(BPMnames),100000);
bpmx=zeros(length(BPMnames),100000);
bpmy=zeros(length(BPMnames),100000);

sum2=zeros(length(BPMnames),260);
bpmx2=zeros(length(BPMnames),260);
bpmy2=zeros(length(BPMnames),260);

count=1;
for loop = 1:length(allname)
    if strfind(allname(loop,:),'SA')
        bpmind(count,1:2)=alllist(loop,:);
        count=count+1;
    end
end

bpmind(1,:)= [];

f1=figure;
f2=figure;
f3=figure;
f4=figure;

        
    % Read TBT data from BPMs
    for loop=1:length(BPMnames)
        sum(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c3']);
        bpmx(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c0'])/1e6;
        bpmy(loop,:)=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c1'])/1e6;
    end
    
    if sum(1,1) > 2e4
        soundtada;
        error('This routine can only be used if there is no stored beam - otherwise turn by turn BPMs only see stored beam - sum(BPM1,turn1)>2e4');
    end
    
    % find injection turn
    [dummy,injind]=max(diff(sum'));
    
    if any(injind<100) || any(injind>45000)
            injind = ones(length(BPMnames),1)*27480;
    end
    
    for loop=1:length(BPMnames)
        sum2(loop,:)=sum(loop,(injind(loop)-9):(injind(loop)+250));
        bpmx2(loop,:)=bpmx(loop,(injind(loop)-9):(injind(loop)+250));
        bpmy2(loop,:)=bpmy(loop,(injind(loop)-9):(injind(loop)+250));
    end
    
    timevec=654e-9*(1:length(sum2(1,:)));
    
    % Figure 1 - turn wise plot
    figure(f1);
    subplot(3,1,1);
    plot((1:length(sum2)),cat(1,sum2)');
    xaxis([-10 250]);
    
    ind = find(sum2(1,:)<2e3);
    for loop=1:size(sum2,1)
        bpmx2(loop,ind)=NaN;
        bpmy2(loop,ind)=NaN;
    end

    ratio = sum2./sum3;
    
    ind = find(sum3(1,:)<2e3);
    for loop=1:size(sum2,1)
        ratio(loop,ind)=0;
        bpmx3(loop,ind)=NaN;
        bpmy3(loop,ind)=NaN;
    end
    
    subplot(3,1,2);
    plot((1:length(bpmx2)),cat(1,bpmx2)');
    axis([-10 250 -15 15]);
    
    subplot(3,1,3);
    plot((1:length(bpmy2)),cat(1,bpmy2)');
    axis([-10 250 -10 10]);
    
    % Figure 2 - BPM wise plot
    figure(f2);
    subplot(3,1,1);
    plot((1:size(sum2,1)*size(sum2,2))./size(sum2,1)-9,reshape(sum2./(ones(1,size(sum2,2))'*bpmgain)',size(sum2,1)*size(sum2,2),1),'r.-', ...
        (1:size(sum3,1)*size(sum3,2))./size(sum3,1)-9,reshape(sum3./(ones(1,size(sum3,2))'*bpmgaing)',size(sum3,1)*size(sum3,2),1),'b')    
    xaxis([0 6]);
    legend('current shot','golden')
    
    subplot(3,1,2);
    plot((1:size(bpmx2,1)*size(bpmx2,2))./size(bpmx2,1)-9,reshape(bpmx2,size(bpmx2,1)*size(bpmx2,2),1),'r.-', ...
        (1:size(bpmx3,1)*size(bpmx3,2))./size(bpmx3,1)-9,reshape(bpmx3,size(bpmx3,1)*size(bpmx3,2),1),'b');
    axis([0 6 -15 15]);
    
    subplot(3,1,3);
    plot((1:size(bpmy2,1)*size(bpmy2,2))./size(bpmy2,1)-9,reshape(bpmy2,size(bpmy2,1)*size(bpmy2,2),1),'r.-', ...
        (1:size(bpmy3,1)*size(bpmy3,2))./size(bpmy3,1)-9,reshape(bpmy3,size(bpmy3,1)*size(bpmy3,2),1),'b');
    axis([0 6 -5 5]);

    % Figure 3 - BPM wise plot - difference from golden orbit
    figure(f3);
    subplot(3,1,1);
    plot((1:size(sum2,1)*size(sum2,2))./size(sum2,1)-9,reshape(ratio,size(sum2,1)*size(sum2,2),1),'b.-')    
    xaxis([0 6]);
    legend('current shot/golden')
    
    subplot(3,1,2);
    plot((1:size(bpmx2,1)*size(bpmx2,2))./size(bpmx2,1)-9,reshape(bpmx2,size(bpmx2,1)*size(bpmx2,2),1)-reshape(bpmx3,size(bpmx3,1)*size(bpmx3,2),1),'b');
    axis([0 6 -15 15]);
    legend('current shot-golden')
    
    subplot(3,1,3);
    plot((1:size(bpmy2,1)*size(bpmy2,2))./size(bpmy2,1)-9,reshape(bpmy2,size(bpmy2,1)*size(bpmy2,2),1)-reshape(bpmy3,size(bpmy3,1)*size(bpmy3,2),1),'b');
    axis([0 6 -5 5]);
    legend('current shot-golden')

    % Figure 4 - BPM wise plot - difference from golden orbit - turn 1 only
    bpms = getspos('BPMx',bpmind);
    
    figure(f4);
    subplot(3,1,1);
    plot(bpms,ratio(:,11).*bpmgaing'./bpmgain','b.-')    
    legend('current shot/golden')
    
    subplot(3,1,2);
    plot(bpms,bpmx2(:,11)-bpmx3(:,11),'b.-');
    yaxis([-15 15]);
    hold on;
    drawlattice(11.5,3);
    legend('current shot-golden')
    
    subplot(3,1,3);
    plot(bpms,bpmy2(:,11)-bpmy3(:,11),'b.-');
    yaxis([-5 5]);
    legend('current shot-golden')

    save([Directory 'BPM\bpmdata_' datestr(now,30) '.mat'])