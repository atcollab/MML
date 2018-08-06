clear
fn = input('  Input file name (no extension): ','s');
% Time domain slow data capture, 4 channels


% Setup
Iter = 50000;             % Loop iterations
NumBlk = 10;              % Data array size
LoopDelay = 60;           % Loop delay in seconds
BandWidth = 3000;
NumAvg = 1;
ChannelVec = [1 2 3 4];
block_size = 4096;       % Time domain block (must be a power of 2) 512, 1024, 2048, 4096, 8192
Sclock= 51200;           % always use 51200 for 20-22


% Initialize DSP, siglab.out is stored in the vbin subdirectory
[drive, ppath] = pathfind('vbin');
[In, Out, BW, Ver] = siglab('IOinit',[drive,ppath,'\siglab.out']);


% Create output signal
Ochan=1;
OutLevel=1.9;
siglab('outsine',1,10);
siglab('OutLevel',Ochan,OutLevel,'Offset',0);


% Input setup
Dfac = siglab('InpSet', ChannelVec,block_size,'Sclock',Sclock,'Cfreq',0,'BW',BandWidth,'Filt','Overlap',0);
siglab('InpGain',ChannelVec,10,'Offset',0,'DC','Diff');              % set to maxrange,  Diff???????
siglab('Trigger',ChannelVec,'FreeRun','AutoArm');
%siglab('Process',ChannelVec,'Add',NumAvg,'Window',WindowType);


% Effective bandwidth = Sclock/(2.56*Dfac)
% Sampling freq = Sclock/Dfac = 2.56*bandwidth
BW_eff = Sclock/(2.56*Dfac);        % Bandwidth
Fs = Sclock/Dfac;                   % Sampling frequency
t = (0:block_size-1)/Fs;            % Time vector
T = block_size/Fs;                  % Time buffer length
f1 = 1/T;                           % First harmonic [Hz]
N_Freq = floor(block_size/2.56)+1;  % Number of PSD points
fvec = f1*(0:N_Freq-1)';


% Output info
fprintf('  Bandwidth = %f Hz (Effective BW = %f)\n', BandWidth, BW_eff);
fprintf('  Sampling Frequency = %f Hz \n', Fs);
fprintf('  Number of Data Points = %d points \n', block_size);
fprintf('  Time Record Length = %f Seconds \n', T);
fprintf('  First harmonic = %f Hz \n', f1);
fprintf('  Number of Averages = %d \n\n', NumAvg);


% Clear out any previous pending requests
MAXSLOTc = 10;
for i=0:MAXSLOTc
    if siglab('DataRdy',i) >= 0
        disp(['  Aborting request id:',num2str(i)]);
        siglab('DataAbort',i);
    end;
end;

Gain1 = 2.1137;  %1/1.2;
%Gain2 = 1/.64;

iFile = 0;
for ii = 1:Iter

    % Main loop
    t00=clock;
    for i=1:NumBlk
        c = clock;
        fprintf('  Trigger time is %d:%d:%.2f\n', c(4),c(5),c(6));

        ReqIDtime=siglab('DataReq',block_size,ChannelVec,'TimeI','First',0,'NoWait');
        t0 = clock;

        %siglab('compute',ChannelVec);
        %siglab('event',ChannelVec,'AvgStart');
        %siglab('event',ChannelVec,'AvgWait');   % hold off sending data over SCSI till averaging is complete
        %ReqIDfreq = siglab('DataReq',block_size/2.56+1,ChannelVec,'AspecA','First',0,'NoWait');

        Rdy = siglab('DataRdy',ReqIDtime);
        while  Rdy < 1
            %fprintf('  Waiting for data, T = %f.\n',etime(clock,t0));
            if etime(clock,t0) > 10*T
                fprintf('  Time-out waiting for time domain DataRdy.\n');
                siglab('DataAbort',ReqIDtime);
                return
            end
            Rdy = siglab('DataRdy',ReqIDtime);
        end;   % wait for data
        fprintf('  Time domain data ready, T = %.3f, Rdy = %d\n', etime(clock,t00), Rdy);
        [Data,ovld(i), seq, header]=siglab('DataGet',ReqIDtime);
        d1(:,i) = Data(:,1);
        d2(:,i) = Data(:,2);
        d3(:,i) = Data(:,3);
        d4(:,i) = Data(:,4);

        
        % Vertical pBPM position
        y1(:,i) = (d1(:,i) - d3(:,i)) ./ (d1(:,i) + d3(:,i));
        y1(:,i) = Gain1 * y1(:,i);

        
        scaput('Physics1', mean(d1(:,i)));  % pBPM top inside voltage
        scaput('Physics2', mean(d2(:,i)));  % BPMx(7,5) average position
        scaput('Physics3', mean(d3(:,i)));  % pBPM bottom inside voltage
        scaput('Physics4', mean(d4(:,i)));  % BPMy(7,6) average position
        scaput('Physics5', mean(y1(:,i)));  % pBPM inside average position "mm" 
        scaput('Physics6', 0);
        scaput('Physics7', 0);
        scaput('Physics8', 0);
        scaput('Physics9', 0);
        scaput('Physics10',0);
        
	     pause(.5);
    end

    TimeClock = clock;
    siglab('DataAbort',ReqIDtime);
    %siglab('DataAbort',ReqIDfreq);

    c = TimeClock;


    figure(1)
    subplot(2,2,1);
    plot(t, d1(:,1));
    title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
    ylabel('Blade 1, Top Inside [Volts]');
    xlabel('Time [Seconds]');
    axis tight

    subplot(2,2,2);
    plot(t, d2(:,1));
    ylabel('BPMy(7,5) [mm]');
    title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
    xlabel('Time [Seconds]');
    axis tight

    subplot(2,2,3);
    plot(t, d3(:,1));
    title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
    ylabel('Blade 3, Bottom Inside [Volts]');
    xlabel('Time [Seconds]');
    axis tight
    
    subplot(2,2,4);
    plot(t, d4(:,1));
    title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
    ylabel('BPMy(7,6) [mm]');
    xlabel('Time [Seconds]');
    axis tight


    N = block_size;
    DCCT = getdcct;
    if mod(ii,20) == 1 & DCCT > 1
        iFile = iFile + 1;
        fprintf('   Saving data to %s\n', [fn, num2str(iFile)]);
        eval(['save ',fn, num2str(iFile),' DCCT TimeClock Fs BandWidth BW_eff NumAvg LoopDelay N Dfac d1 d2 d3 d4']);
        %eval(['save ',fn, num2str(iFile),' DCCT TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock d1 d2 d3 d4']);
    end

    %fprintf('  POWER SPECTRUM DATA, %d Points (%d:%d:%.2f)\n',block_size, c(4),c(5),c(6));
    %fprintf('  %d. RMS = %.4f  Ch 1 (PSD computed from time series, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Paa(3:end))/N));
    %fprintf('  %d. RMS = %.4f  Ch 1 (time series data, mean removed)\n', ii, std(data-mean(data)));
    %fprintf('  %d. RMS = %.4f  Ch 1 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd1(3:end,1))*Uwindow));
    %fprintf('  %d. RMS = %.4f  Ch 2 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd2(3:end,1))*Uwindow));
    %fprintf('  %d. RMS = %.4f  Ch 3 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd3(3:end,1))*Uwindow));
    %fprintf('  %d. RMS = %.4f  Ch 4 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd4(3:end,1))*Uwindow));
    %fprintf('  Data saved to %s.mat\n  DCCT=%.1f mAmps\n\n', [fn, num2str(ii)],DCCT);
    
    
    if ii < Iter
        pause(LoopDelay);
    end

    drawnow
end