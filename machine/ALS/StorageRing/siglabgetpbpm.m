function [d1, d2, d3, d4, y1, y2, yy1, yy2, Gain, GainAvg] = siglabgetpbpm(Iter, NumBlk, FileNamePrefix)
% [d1, d2, d3, d4, y1, y2, yy1, yy2, Gain, GainAvg] = siglabgetpbpm(Iterations {Forever}, NumberOfAverages (10), FileName)

%
% for i = 1:10; pbpm_plotpsd('pBPMdata');eval(sprintf('!cp pBPMdata.mat ./2007-11-07/pBPM_FB_On/pBPMdata%d.mat',i));pause(60);end
%


% Setup up EPICS records by preventing the PVs from processing so this app can write to them
% setpvonline('SR07C___PBPM2Y1AM00.SCAN', 'Passive', 'String');



%%%%%%%%%%%%%%%%%%%%%%%%%  Setup: Time domain slow data capture, 4 channels, pBPM  %%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    Iter = 50000;        % Loop iterations
end
if nargin < 2
    NumBlk = 10;         % Data array size
end
if nargout == 0 & nargin < 3
    FileNamePrefix = input('  Input file name (no extension): ','s');
end
LoopDelay = 1;           % Loop delay in seconds
BandWidth = 500;         % Typically 500 or 5000
NumAvg = 10;             % PSD averages in the siglab box
ChannelVec = [1 2 3 4];
block_size = 4096;       % Time domain block (must be a power of 2) 512, 1024, 2048, 4096, 8192
Sclock= 51200;           % always use 51200 for 20-22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DirectoryStart = pwd;

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

        [Data, OverVoltage, seq, header]=siglab('DataGet',ReqIDtime);

        if OverVoltage(1) == 0
            ovld(i) = OverVoltage;
        else
            fprintf('\n');
            fprintf('   Over voltage in %d channel\n', OverVoltage);
            fprintf('\n');
            %Data = NaN * ones(size(d1,1),4);
            ovld(i) = OverVoltage(1);
        end

        d1(:,i) = Data(:,1);
        d2(:,i) = Data(:,2);
        d3(:,i) = Data(:,3);
        d4(:,i) = Data(:,4);

        % Vertical position
        y1(:,i) = (d1(:,i) - d3(:,i)) ./ (d1(:,i) + d3(:,i));
        y2(:,i) = (d2(:,i) - d4(:,i)) ./ (d2(:,i) + d4(:,i));


        % y1-y2 should equal .978 mm (6/2006 distance between the blades)
        Gain    = .978 ./ (y2(:,i) - y1(:,i));
        GainAvg = .978 ./ (mean(y2(:,i)) - mean(y1(:,i)));


        % Base a calibration data (should add a final calibration here)
        y(:,i) = Gain .* y1(:,i);
        %y(:,i) = Gain .* y2(:,i);

              
        % Or base on an average gain over the sample time
        %yy1(:,i) = GainAvg * y1(:,i) ./ Gain;
        %yy2(:,i) = GainAvg * y2(:,i) ./ Gain;
        
        
        if 1
            scaput('SR07C___PBPM2A_AM00', mean(d1(:,i)));
            scaput('SR07C___PBPM2B_AM00', mean(d2(:,i)));
            scaput('SR07C___PBPM2C_AM00', mean(d3(:,i)));
            scaput('SR07C___PBPM2D_AM00', mean(d4(:,i)));
            scaput('SR07C___PBPM2Y1AM00', mean(y1(:,i)));
            scaput('SR07C___PBPM2Y2AM00', mean(y2(:,i)));
            scaput('SR07C___PBPM2Y_AM00', mean(y(:,i)));
            scaput('Physics7', mean(Gain));
            if NumBlk == 1
                %scaput('PhysicsWave1', y1(:,i));
            end
        elseif 0
            scaput('Physics1', mean(d1(:,i)));
            scaput('Physics2', mean(d2(:,i)));
            scaput('Physics3', mean(d3(:,i)));
            scaput('Physics4', mean(d4(:,i)));
            scaput('Physics5', mean(y1(:,i)));
            scaput('Physics6', mean(y2(:,i)));
            scaput('Physics7', mean(Gain));
            %scaput('Physics8', mean(yy1(:,i)));
            %scaput('Physics9', mean(yy2(:,i)));
            scaput('Physics10',mean(GainAvg));
        else
            Data = [
                mean(d1(:,i));
                mean(d2(:,i));
                mean(d3(:,i));
                mean(d4(:,i));
                mean(y1(:,i));
                mean(y2(:,i));
                mean(Gain);
                %mean(yy1(:,i));
                %mean(yy2(:,i));
                mean(GainAvg)];
            save siglabdata Data
        end

        TimeClock = clock;
        c = TimeClock;

        figure(1)
        subplot(2,2,1);
        plot(t, d1(:,i));
        title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
        ylabel('Chan 1 [Volts]');
        xlabel('Time [Seconds]');
        axis tight

        subplot(2,2,2);
        plot(t, d2(:,i));
        title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
        ylabel('Chan 2 [Volts]');
        xlabel('Time [Seconds]');
        axis tight

        subplot(2,2,3);
        plot(t, d3(:,i));
        title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
        ylabel('Chan 3 [Volts]');
        xlabel('Time [Seconds]');
        axis tight

        subplot(2,2,4);
        plot(t, d4(:,i));
        title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
        ylabel('Chan 4 [Volts]');
        xlabel('Time [Seconds]');
        axis tight

        figure(2)
        subplot(2,1,1);
        plot(t, y1(:,i));
        title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
        ylabel('y1 [mm]');
        xlabel('Time [Seconds]');
        axis tight
        a = axis;
        axis([0 .083 a(3:4)]);

        subplot(2,1,2);
        plot(t, y2(:,i));
        title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
        ylabel('y2 [mm]');
        xlabel('Time [Seconds]');
        axis tight
        a = axis;
        axis([0 .083 a(3:4)]);

        drawnow;

        if ii < Iter
            pause(LoopDelay);
        end
    end


    siglab('DataAbort',ReqIDtime);
    %siglab('DataAbort',ReqIDfreq);


    if nargout == 0 | nargin >= 3
        N = block_size;
        DCCT = getdcct;
        %if mod(ii,2) == 1 & DCCT > 1
        %if DCCT > 1
        if mod(ii,100) == 0 & DCCT > .25
            iFile = iFile + 1;
            if Iter == 1
                FileName = FileNamePrefix;
            else
                FileName = [FileNamePrefix, num2str(iFile)];
            end

            %fprintf('   Saving data to %s\n', FileName);
            %eval(['save ', FileName, ' DCCT TimeClock Fs BandWidth BW_eff NumAvg LoopDelay N Dfac d1 d2 d3 d4']);
            %%eval(['save ', FileName, ' DCCT TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock d1 d2 d3 d4']);
        end
    end
    
    cd M:\matlab\StorageRingData\TopOff\pBPM
    fprintf('   Saving data to pBPMdata at %s\n\n\n', datestr(now));
    save pBPMdata DCCT TimeClock Fs BandWidth BW_eff NumAvg LoopDelay N Dfac d1 d2 d3 d4
    cd(DirectoryStart);
    
    %fprintf('  POWER SPECTRUM DATA, %d Points (%d:%d:%.2f)\n',block_size, c(4),c(5),c(6));
    %fprintf('  %d. RMS = %.4f  Ch 1 (PSD computed from time series, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Paa(3:end))/N));
    %fprintf('  %d. RMS = %.4f  Ch 1 (time series data, mean removed)\n', ii, std(data-mean(data)));
    %fprintf('  %d. RMS = %.4f  Ch 1 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd1(3:end,1))*Uwindow));
    %fprintf('  %d. RMS = %.4f  Ch 2 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd2(3:end,1))*Uwindow));
    %fprintf('  %d. RMS = %.4f  Ch 3 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd3(3:end,1))*Uwindow));
    %fprintf('  %d. RMS = %.4f  Ch 4 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd4(3:end,1))*Uwindow));
    %fprintf('  Data saved to %s.mat\n  DCCT=%.1f mAmps\n\n', [FileNamePrefix, num2str(ii)],DCCT);
end



