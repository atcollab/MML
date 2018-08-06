clear
GapList = [4;5;7;8;9;10;12];
fn = input('  Input file name (no extension): ','s');
% Time domain slow data capture, 4 channels


% Setup
Iter = 5000;             % Loop iterations
NumBlk = 1;              % Data array size
LoopDelay = 1;  %6*60;        % Loop delay in seconds
BandWidth = 5000;        % Typically 500 or 5000
NumAvg = 10;
WindowType = 0;          % 1-hanning, 0-none
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
siglab('Process',ChannelVec,'Add',NumAvg,'Window',WindowType);
if WindowType == 0
   Uwindow = 1;
   fprintf('  No window function\n');
elseif WindowType == 1
   Uwindow = .66666666666666667;
   fprintf('  Hanning window function\n');
else
   error('WindowType unknown');
end


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

for ii = 1:inf
   
   % Main loop
   t00=clock;
   for i=1:NumBlk
      c = clock;
      fprintf('  Trigger time is %d:%d:%.2f\n', c(4),c(5),c(6));
      
      Gap1 = getid(GapList);
      [FFEnable1,tmp,GapEnable1]=getff(GapList);
      
      ReqIDtime=siglab('DataReq',block_size,ChannelVec,'TimeI','First',0,'NoWait');
      t0 = clock;
      
      siglab('compute',ChannelVec);
      siglab('event',ChannelVec,'AvgStart');
      siglab('event',ChannelVec,'AvgWait');   % hold off sending data over SCSI till averaging is complete
      ReqIDfreq=siglab('DataReq',block_size/2.56+1,ChannelVec,'AspecA','First',0,'NoWait');      
            
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
      
      Rdy = siglab('DataRdy',ReqIDfreq);
      while  Rdy < NumAvg
         %fprintf('  Waiting for data, T = %f.\n',etime(clock,t0));
         if etime(clock,t0) > 10*NumAvg*T
            fprintf('  Time-out waiting for frequency domain DataRdy.\n');
            siglab('DataAbort',ReqIDfreq);
            return
         end
         Rdy = siglab('DataRdy',ReqIDfreq);
      end;   % wait for data 
      fprintf('  Frequency domain data ready, T = %.3f, Rdy = %d\n', etime(clock,t00), Rdy);
      [Data,ovld(i), seq, header]=siglab('DataGet',ReqIDfreq);
      Fd1(:,i) = Data(:,1);
      Fd2(:,i) = Data(:,2);
      Fd3(:,i) = Data(:,3);
      Fd4(:,i) = Data(:,4);
   end;
   TimeClock = clock;
   siglab('DataAbort',ReqIDtime);
   siglab('DataAbort',ReqIDfreq);
   
   c = TimeClock;  
   
   
   figure(1)
   subplot(2,2,1);
   plot(t, d1);
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 1 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(2,2,2);
   plot(t, d2);
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 2 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(2,2,3);
   plot(t, d3);
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 3 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(2,2,4);
   plot(t, d4);
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 4 [Volts]');
   xlabel('Time [Seconds]');
   axis tight   
   
   
   figure(2)
   subplot(2,2,1);
   loglog(fvec(3:end),T*Fd1(3:N_Freq,i)*Uwindow,'r');
   ylabel('Chan 1 [(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   title(sprintf('POWER SPECTRUM  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   axis tight
   
   subplot(2,2,2);
   loglog(fvec(3:end),T*Fd2(3:N_Freq,i)*Uwindow,'r');
   ylabel('Chan 2[(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   
   subplot(2,2,3);
   loglog(fvec(3:end),T*Fd3(3:N_Freq,i)*Uwindow,'g');
   ylabel('Chan 3[(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   
   subplot(2,2,4);
   loglog(fvec(3:end),T*Fd4(3:N_Freq,i)*Uwindow,'g');
   ylabel('Chan 4 [(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   
   N = block_size;
   deltaX = 1/Fs;
   data = d1(:,1);
   %T = deltaX*N
   T1= deltaX;
   
   f0=1/(N*T1);
   f=f0*(0:N/2)';
   a=data;  %*9.8/100;    %  100 volts/g gain on the accelerometers
   %a=a-mean(a);
   %a=detrend(a);
   Arms_data = sqrt(sum((a-mean(a)).^2)/length((a-mean(a))));
   
   
   % POWER SPECTRUM
   if WindowType == 0
      w = ones(N,1);               % no window
   elseif WindowType == 1
      w = hanning(N);              % hanning window
   else
      error('WindowType unknown.');
   end
   a_w = a .* w;
   A=fft(a_w);
   Paa=A.*conj(A)/N;
   U = sum(w.^2)/N;              % approximately .375 for hanning
   %U2 = ((norm(w)/sum(w))^2);    % used to normalize plots (p. 1-68, matlab DSP toolbox)
   Paa=Paa/U;
   Paa(N/2+2:N) = [];
   Paa(2:N/2+1)=2*Paa(2:N/2+1);
   
%   subplot(2,2,1);
%   hold on  
%   loglog(f(2:N/2), T1*Paa(2:N/2),'--g');  
%   axis tight
%   hold off
   
   
   f = fvec;
   Gap2 = getid(GapList);
   DCCT = getdcct;
   [FFEnable2,tmp,GapEnable2]=getff(GapList);
   %FFEnable  = any([FFEnable1  FFEnable2]);
   %GapEnable = any([GapEnable1 GapEnable2]);
   eval(['save ',fn, num2str(ii),' DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock d1 d2 d3 d4']); 
   
   fprintf('  POWER SPECTRUM DATA, %d Points (%d:%d:%.2f)\n',block_size, c(4),c(5),c(6));
   fprintf('  %d. RMS = %.4f  Ch 1 (PSD computed from time series, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Paa(3:end))/N));
   fprintf('  %d. RMS = %.4f  Ch 1 (time series data, mean removed)\n', ii, std(data-mean(data)));
   fprintf('  %d. RMS = %.4f  Ch 1 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd1(3:end,1))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 2 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd2(3:end,1))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 3 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd3(3:end,1))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 4 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd4(3:end,1))*Uwindow));
  	fprintf('  Data saved to %s.mat\n  DCCT=%.1f mAmps\n\n', [fn, num2str(ii)],DCCT);
  
   drawnow
   if ii <Iter 
      while etime(clock,t00) < LoopDelay;
      end
   end
end