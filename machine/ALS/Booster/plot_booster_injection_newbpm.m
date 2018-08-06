function plot_booster_injection_newbpm(varargin)
% function plot_booster_injection_newbpm(varargin)
%
% Routine to collect and plot turn by turn data of the NSLS-2 style BPMs in
% the booster.
%
% Christoph Steier, November 2016

checkforao;

% Initialization
Prefix = getfamilydata('BPM','BaseName');
NBPM = length(Prefix);

% BPMname = Prefix{1}; NBPM=1;

% Initialize BPMs for injection triggering of TBT mode
for loop=1:NBPM
    setpvonline([Prefix{loop} ':wfr:TBT:arm'],0);
    setpvonline([Prefix{loop} ':wfr:TBT:triggerMask'],bin2dec('10000000'));
    setpvonline([Prefix{loop} ':EVR:event36trig'],bin2dec('10000000'));
    %     setpvonline([Prefix{loop} ':wfr:FA:triggerMask'],bin2dec('10000000'));
    setpvonline([Prefix{loop} ':wfr:TBT:pretrigCount'],0);
    setpvonline([Prefix{loop} ':wfr:TBT:acqCount'],100000);
    %     setpvonline([Prefix{loop} ':buttonDSP'],1);
    setpvonline([Prefix{loop} ':attenuation'],3);
end

% Initialize BPMs for injection triggering of TBT mode
for loop=1:NBPM
    setpvonline([Prefix{loop} ':wfr:TBT:arm'], 0);
    setpvonline([Prefix{loop} ':wfr:TBT:acqCount'], 100000);
end


f1=figure;
f2=figure;

% Data Acquisition Loop

while 1

%     err=(-1);
%     while (err<0)
%         [count,time,err]=synctoevt(16);
%     end

% another attempt to sync to an imminent shot of the new timing system
TimInjReqStart = getpvonline('TimInjReq');
Startnum = TimInjReqStart(7);
Currentnum = Startnum;

while (Currentnum == Startnum) || (TimInjReqCurrent(3)<20)
    TimInjReqCurrent = getpvonline('TimInjReq');
    Currentnum = TimInjReqCurrent(7);
    pause(0.1);
end

%     while getpv('GTL_____TIMING_BC00')==0
%         pause(0.05);
%     end
    
    for loop=1:NBPM
        if (getpvonline([Prefix{loop} ':wfr:TBT:triggerMask'])~=bin2dec('10000000')) ...
                || (getpvonline([Prefix{loop} ':EVR:event36trig'])~=bin2dec('10000000')) ...
                || (getpvonline([Prefix{loop} ':wfr:TBT:acqCount'])~=100000)
            
            setpvonline([Prefix{loop} ':wfr:TBT:arm'],0);
            setpvonline([Prefix{loop} ':wfr:TBT:triggerMask'],bin2dec('10000000'));
            setpvonline([Prefix{loop} ':EVR:event36trig'],bin2dec('10000000'));
            setpvonline([Prefix{loop} ':wfr:TBT:pretrigCount'],0);
            setpvonline([Prefix{loop} ':wfr:TBT:acqCount'],100000);
        end
    end
    
    % Arm TBT
    for loop=1:NBPM
        setpvonline([Prefix{loop} ':wfr:TBT:arm'],1);
    end
    
    pause(0.1);
    
    % Wait for new data
    t0 = clock;
    for loop=1:NBPM
        while getpv([Prefix{loop} ':wfr:TBT:armed'])
            pause(0.2);
        end
    end
    
    pause(0.5);
    
    am = bpm_gettbt;
    
    timevec=250e-9*(1:length(am{1}.S));
    
    %ind = 4827*ones(1,NBPM);
    ind = 1040*ones(1,NBPM);
    
    if (max(am{1}.S)>1e5)
        for loop =1:NBPM
            ind(loop) = find(am{loop}.S>1e5, 1 );
        end
    end
    
    %     figure(f1);
    %     plot(timevec,am.DD_SUM_MONITOR);
    %     pause(0.1);
    
    
    if ~any(isempty(ind))
        for loop=1:NBPM
            am{loop}.X(1:(ind(loop)-1))=NaN;
            am{loop}.Y(1:(ind(loop)-1))=NaN;
        end
        
        am2 = cell2mat(am);
        S = cat(2,am2.S);
        x = cat(2,am2.X);
        y = cat(2,am2.Y);
        
        S2 = zeros(4,NBPM);
        x2 = zeros(4,NBPM);
        y2 = zeros(4,NBPM);

        S3 = zeros(1006,NBPM);
        x3 = zeros(1006,NBPM);
        y3 = zeros(1006,NBPM);

        for loop=1:NBPM            
            meanS=mean(S((ind(loop)):ind(loop)+20,loop));
            if ~isnan(meanS) && (abs(meanS)>2e5)
                S2(:,loop) = S((ind(loop)-1):ind(loop)+2,loop)./meanS;
            else
                S2(:,loop) = S((ind(loop)-1):ind(loop)+2,loop)./2e6;
            end
            meanx=mean(x((ind(loop)):ind(loop)+20,loop));
            if ~isnan(meanx) && (abs(meanx)<10)
                x2(:,loop) = x((ind(loop)-1):ind(loop)+2,loop)-meanx;
            else
                x2(:,loop) = x((ind(loop)-1):ind(loop)+2,loop);
            end
            meany=mean(y((ind(loop)):ind(loop)+20,loop));
            if ~isnan(meany) && (abs(meany)<10)
                y2(:,loop) = y((ind(loop)-1):ind(loop)+2,loop)-meany;
            else
                y2(:,loop) = y((ind(loop)-1):ind(loop)+2,loop);
            end
            S3(:,loop)=S((ind(loop)-5):(ind(loop)+1000),loop);
            x3(:,loop)=x((ind(loop)-5):(ind(loop)+1000),loop);
            y3(:,loop)=y((ind(loop)-5):(ind(loop)+1000),loop);
        end
        
        figure(f1);
        clf reset
        %if exist('textlabel','var')
        %    delete(textlabel);
        %end
        subplot(3,1,1);
        plot(timevec((ind(1)-5):(ind(1)+1000)),S3,'-');
        axis tight;
        yaxis([0 2e6]);
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('SUM (ADC counts)');
        title('Booster turn-by-turn monitor (newbpm)');
        subplot(3,1,2);
        plot(timevec((ind(1)-5):(ind(1)+1000)),x3,'-');
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('x [mm]');
        axis tight;
        yaxis([-10 10]);
        subplot(3,1,3);
        plot(timevec((ind(1)-5):(ind(1)+1000)),y3,'-');
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('y [mm]');
        axis tight;
        yaxis([-10 10]);
        textlabel=addlabel(am{1}.TsStr(1,:));
        drawnow;
        
        le = size(S2,1)*size(S2,2);
        
        figure(f2);
        clf reset
        %if exist('textlabel','var')
        %    delete(textlabel);
        %end
        subplot(3,1,1);
        plot((1:le)/NBPM-1,reshape(S2',1,le),'.-');
        axis tight;
        a = axis;
        axis([0 a(2) 0 2.2]);
        xlabel('t [turn] (after injection)');
        ylabel('SUM/<SUM> (normalized)');
        title('Booster turn-by-turn monitor (newbpm)');
        subplot(3,1,2);
        plot((1:le)/NBPM-1,reshape(x2',1,le),'.-');
        %        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('x-<x> [mm]');
        axis tight;
        a = axis;
        axis([0 a(2) -10 10]);
        %yaxis([-10 10]);
        subplot(3,1,3);
        plot((1:le)/NBPM-1,reshape(y2',1,le),'.-');
        %        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('y-<y> [mm]');
        axis tight;
        a = axis;
        axis([0 a(2) -10 10]);
        %yaxis([-10 10]);
        textlabel=addlabel(am{1}.TsStr(1,:));
        drawnow;
        
    end
    pause(0.1);
    
end


function DataTime = convertime_local(DataTime)
% Input DataTime is the time on computer taking the data (EPICS) using LabCA complex formating
% Output is referenced w.r.t. the time zone where Matlab is running in Matlab's date number format
t0 = clock;
DateNumber1970 = 719529;  %datenum('1-Jan-1970');
days = datenum(t0(1:3)) - DateNumber1970;
t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
