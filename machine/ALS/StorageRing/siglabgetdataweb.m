function siglabgetdataweb

alsvars(4)

%addpath('c:\siglab\vcom')
%addpath('c:\siglab\v5\vbin') attempts for running siglabgetdataweb from Q; drive

global IDXgolden IDYgolden IDBPMlist IDBPMelem

% Record start directory
DirStart = pwd;

% Create directory by date to store data 
tmp = clock;
year   = tmp(1);
month  = tmp(2);
day    = tmp(3);
hour   = tmp(4);
minute = tmp(5);
seconds= tmp(6);

% Change to .../srdata and create directory by date
gotophysdata
cd idbpm
DirByDate = sprintf('%d-%02d-%02d', year, month, day);
[status, msg] = feval('mkdir', DirByDate);
%if status == 2  % The directory already exists
%   Answer = questdlg(sprintf('Directory %s already exists. Are you sure you want to write to this directory?',DirByDate),'SiglabGetDataWeb','Yes','No','No');
%   if strcmp(Answer,'No')
%      feval('cd', DirStart);
%      return
%   end
%end
pause(1);    % Should not be needed but windows in stupid
feval('cd', DirByDate);
fprintf('\n  Data will be written to %s \n\n', pwd);

i = find(IDBPMlist(:,1) == 10);
xoffset = IDXgolden(IDBPMelem(i(2)));
yoffset = IDYgolden(IDBPMelem(i(2)));


%Program Setup
Iter = 100000;         % Loop iterations
LoopDelay = 10*60;     % Loop delay in seconds
NumBlk = 1;            % Data array size
%GapList = getlist('IDpos');
GapList = [5 1;7 1;8 1;9 1;10 1;12 1];
fn = 'data';
% fn = input('  Input file name (no extension): ','s');


% Initialize DSP, siglab.out is stored in the vbin subdirectory     
[drive, ppath] = pathfind('vbin');
%pathfind seems to no longer exist in matlab so do it manually
%drive='c:\';
%ppath='siglab\vbin';
[In, Out, BW, Ver] = siglab('IOinit',[drive,ppath,'\siglab.out']);

% Create output signal (for testing)
Ochan=1;
OutLevel=1.9;
siglab('outsine',1,10);
siglab('OutLevel',Ochan,OutLevel,'Offset',0);


% Main loop
for ii = 1:Iter
   t000=gettime;


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Data Block Setup #1
   BandWidth = 50;
   NumAvg = 10; %1 is faster for testing, 10 is for production
   WindowType = 1;          % 1-hanning, 0-none
   ChannelVec = [1 2 3 4];
   block_size = 4096;       % Time domain block (must be a power of 2) 512, 1024, 2048, 4096, 8192
   Sclock= 51200;           % always use 51200 for 20-22 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
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
   if ii == 1
      fprintf('  Bandwidth = %f Hz (Effective BW = %f)\n', BandWidth, BW_eff);
      fprintf('  Sampling Frequency = %f Hz \n', Fs);
      fprintf('  Number of Data Points = %d points \n', block_size);
      fprintf('  Time Record Length = %f Seconds \n', T);
      fprintf('  First harmonic = %f Hz \n', f1);
      fprintf('  Number of Averages = %d \n\n', NumAvg);
   end

   
   % Clear out any previous pending requests
   MAXSLOTc = 10;
   for i=0:MAXSLOTc
      if siglab('DataRdy',i) >= 0 
         disp(['  Aborting request id:',num2str(i)]);
         siglab('DataAbort',i);
      end;
   end;
   
   
   t00=clock;
   Gap1 = getid(GapList);
   [FFEnable1, tmp, GapEnable1] = getff(GapList);
   
   c = clock;
   fprintf('  Trigger time is %d:%d:%.2f\n', c(4),c(5),c(6));
   ReqIDtime=siglab('DataReq',block_size,ChannelVec,'TimeI','First',0,'NoWait');
   t0 = clock;
   
   siglab('compute',ChannelVec);
   siglab('event',ChannelVec,'AvgStart');
   siglab('event',ChannelVec,'AvgWait');   % hold off sending data over SCSI till averaging is complete
   ReqIDfreq=siglab('DataReq',block_size/2.56+1,ChannelVec,'AspecA','First',0,'NoWait');      
   
   Rdy = siglab('DataRdy',ReqIDtime);
   while  Rdy < 1
      %fprintf('  Waiting for data, T = %f.\n',etime(clock,t0));
      if etime(clock,t0) > 4*T
         fprintf('  Time-out waiting for time domain DataRdy.\n');
         siglab('DataAbort',ReqIDtime);
         return
      end
      Rdy = siglab('DataRdy',ReqIDtime);
   end;   % wait for data 
   fprintf('  Time domain data ready, T = %.3f, Rdy = %d\n', etime(clock,t00), Rdy);
   [Data,ovld(1), seq, header]=siglab('DataGet',ReqIDtime);
   d1(:,1) = Data(:,1)-xoffset;
   d2(:,1) = Data(:,2)-yoffset;
   d3(:,1) = Data(:,3);
   d4(:,1) = Data(:,4);
   
   Rdy = siglab('DataRdy',ReqIDfreq);
   while  Rdy < NumAvg
      %fprintf('  Waiting for data, T = %f.\n',etime(clock,t0));
      if etime(clock,t0) > 4*NumAvg*T
         fprintf('  Time-out waiting for frequency domain DataRdy.\n');
         siglab('DataAbort',ReqIDfreq);
         return
      end
      Rdy = siglab('DataRdy',ReqIDfreq);
   end;   % wait for data 
   fprintf('  Frequency domain data ready, T = %.3f, Rdy = %d\n', etime(clock,t00), Rdy);
   [Data,ovld(i), seq, header]=siglab('DataGet',ReqIDfreq);
   Fd1(:,1) = Data(:,1);
   Fd2(:,1) = Data(:,2);
   Fd3(:,1) = Data(:,3);
   Fd4(:,1) = Data(:,4);
   
   TimeClock = clock;
   siglab('DataAbort',ReqIDtime);
   siglab('DataAbort',ReqIDfreq);
   
   c = TimeClock;  
   
   
   % Setup figures
   Buffer = .01;
   HeightBuffer = .05;
   
   h1=figure(1);
   clf;
   set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   
   subplot(4,2,1);
   plot(t, d1, 'b');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 1 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(4,2,2);
   plot(t, d2, 'b');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 2 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(4,2,3);
   plot(t, d3, 'b');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 3 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(4,2,4);
   plot(t, d4, 'b');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 4 [Volts]');
   xlabel('Time [Seconds]');
   axis tight   
   
   
   h2=figure(h1+1);
   clf;
   set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   
   subplot(2,2,1);
   loglog(fvec(3:end),T*Fd1(3:N_Freq)*Uwindow,'b');
   ylabel('Chan 1 [(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   title(sprintf('POWER SPECTRUM  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   axis tight
   
   subplot(2,2,2);
   loglog(fvec(3:end),T*Fd2(3:N_Freq)*Uwindow,'b');
   ylabel('Chan 2[(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   
   subplot(2,2,3);
   loglog(fvec(3:end),T*Fd3(3:N_Freq)*Uwindow,'b');
   ylabel('Chan 3[(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   
   subplot(2,2,4);
   loglog(fvec(3:end),T*Fd4(3:N_Freq)*Uwindow,'b');
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
   U = sum(w.^2)/N;               % approximately .375 for hanning
   %U2 = ((norm(w)/sum(w))^2);    % used to normalize plots (p. 1-68, matlab DSP toolbox)
   Paa=Paa/U;
   Paa(N/2+2:N) = [];
   Paa(2:N/2+1)=2*Paa(2:N/2+1);
   
   
   f = fvec;
   Gap2 = getid(GapList);
   DCCT = getdcct;
   [FFEnable2,tmp,GapEnable2]=getff(GapList);
   
   % Archive save
   %eval(['save ',fn, 'A', num2str(ii),' DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 d1 d2 d3 d4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock']);  
   
   %save m:\matlab\srdata\idbpm\RealTimeData\tmp1 DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 d1 d2 d3 d4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock
   %siglabplot('m:\matlab\srdata\idbpm\RealTimeData\tmp1',1,'m:\matlab\srdata\idbpm\RealTimeData\tmpf1');
      
   % Web page save
   %if all(GapEnable1(3:end)) & all(GapEnable2(3:end)) & DCCT>1
   if any(GapEnable1) & any(GapEnable2) & DCCT>1
      save \\Cgsrv\alswebdata\portmann\psd1 DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 d1 d2 d3 d4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock
      [rms1,  rms2, rms3, rms4] = siglabplot('\\Cgsrv\alswebdata\portmann\psd1',1,'\\Cgsrv\alswebdata\portmann\f1');
      
      % Save to the database for archiving
      %scaput('SR09S_IBPM2X_RMS',rms1);
      %scaput('SR09S_IBPM2Y_RMS',rms2);
      %scaput('SR09S_IBPM1X_RMS',rms3);
      %scaput('SR09S_IBPM1Y_RMS',rms4);
      
      eval(['save slowdata', num2str(ii),' DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4  d1 d2 d3 d4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock']);
   end
   
   fprintf('  POWER SPECTRUM DATA, %d Points (%d:%d:%.2f)\n',block_size, c(4),c(5),c(6));
   fprintf('  %d. RMS = %.4f  Ch 1 (PSD computed from time series, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Paa(3:end))/N));
   fprintf('  %d. RMS = %.4f  Ch 1 (time series data, mean removed)\n', ii, std(data-mean(data)));
   fprintf('  %d. RMS = %.4f  Ch 1 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd1(3:end))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 2 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd2(3:end))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 3 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd3(3:end))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 4 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd4(3:end))*Uwindow));
   fprintf('  Data saved to %s.mat\n  DCCT=%.1f mAmps\n\n', [fn, num2str(ii)],DCCT);
   
   drawnow
  
  
  
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Data Block Setup #2
   BandWidth = 300;
   NumAvg = 25;
   WindowType = 1;          % 1-hanning, 0-none
   ChannelVec = [1 2 3 4];
   block_size = 4096;       % Time domain block (must be a power of 2) 512, 1024, 2048, 4096, 8192
   Sclock= 51200;           % always use 51200 for 20-22 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
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
   if ii == 1
      fprintf('  Bandwidth = %f Hz (Effective BW = %f)\n', BandWidth, BW_eff);
      fprintf('  Sampling Frequency = %f Hz \n', Fs);
      fprintf('  Number of Data Points = %d points \n', block_size);
      fprintf('  Time Record Length = %f Seconds \n', T);
      fprintf('  First harmonic = %f Hz \n', f1);
      fprintf('  Number of Averages = %d \n\n', NumAvg);
   end
   
   % Clear out any previous pending requests
   MAXSLOTc = 10;
   for i=0:MAXSLOTc
      if siglab('DataRdy',i) >= 0 
         disp(['  Aborting request id:',num2str(i)]);
         siglab('DataAbort',i);
      end;
   end;
   
   
   t00=clock;
   Gap1 = getid(GapList);
   [FFEnable1, tmp, GapEnable1] = getff(GapList);
   
   c = clock;
   fprintf('  Trigger time is %d:%d:%.2f\n', c(4),c(5),c(6));
   ReqIDtime=siglab('DataReq',block_size,ChannelVec,'TimeI','First',0,'NoWait');
   t0 = clock;
   
   siglab('compute',ChannelVec);
   siglab('event',ChannelVec,'AvgStart');
   siglab('event',ChannelVec,'AvgWait');   % hold off sending data over SCSI till averaging is complete
   ReqIDfreq=siglab('DataReq',block_size/2.56+1,ChannelVec,'AspecA','First',0,'NoWait');      
   
   Rdy = siglab('DataRdy',ReqIDtime);
   while  Rdy < 1
      %fprintf('  Waiting for data, T = %f.\n',etime(clock,t0));
      if etime(clock,t0) > 4*T
         fprintf('  Time-out waiting for time domain DataRdy.\n');
         siglab('DataAbort',ReqIDtime);
         return
      end
      Rdy = siglab('DataRdy',ReqIDtime);
   end;   % wait for data 
   fprintf('  Time domain data ready, T = %.3f, Rdy = %d\n', etime(clock,t00), Rdy);
   [Data,ovld(1), seq, header]=siglab('DataGet',ReqIDtime);
   d1(:,1) = Data(:,1)-xoffset;
   d2(:,1) = Data(:,2)-yoffset;
   d3(:,1) = Data(:,3);
   d4(:,1) = Data(:,4);
   
   Rdy = siglab('DataRdy',ReqIDfreq);
   while  Rdy < NumAvg
      if etime(clock,t0) > 4*NumAvg*T
         fprintf('  Time-out waiting for frequency domain DataRdy.\n');
         siglab('DataAbort',ReqIDfreq);
         return
      end
      Rdy = siglab('DataRdy',ReqIDfreq);
   end;   % wait for data 
   fprintf('  Frequency domain data ready, T = %.3f, Rdy = %d\n', etime(clock,t00), Rdy);
   [Data,ovld(i), seq, header]=siglab('DataGet',ReqIDfreq);
   Fd1(:,1) = Data(:,1);
   Fd2(:,1) = Data(:,2);
   Fd3(:,1) = Data(:,3);
   Fd4(:,1) = Data(:,4);
   
   TimeClock = clock;
   siglab('DataAbort',ReqIDtime);
   siglab('DataAbort',ReqIDfreq);
   
   c = TimeClock;  
   
  
   figure(h1);
   
   subplot(4,2,5);
   plot(t, d1, 'r');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 1 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(4,2,6);
   plot(t, d2, 'r');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 2 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(4,2,7);
   plot(t, d3, 'r');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 3 [Volts]');
   xlabel('Time [Seconds]');
   axis tight
   
   subplot(4,2,8);
   plot(t, d4, 'r');
   title(sprintf('Time Series  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   ylabel('Chan 4 [Volts]');
   xlabel('Time [Seconds]');
   axis tight   
   
   
   figure(h2);   
   subplot(2,2,1);
   hold on;
   loglog(fvec(3:end),T*Fd1(3:N_Freq)*Uwindow,'r');
   ylabel('Chan 1 [(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   title(sprintf('POWER SPECTRUM  %d Points (%d:%d:%.2f)',block_size, c(4),c(5),c(6)));
   axis tight
   hold off;
   
   subplot(2,2,2);
   hold on;
   loglog(fvec(3:end),T*Fd2(3:N_Freq)*Uwindow,'r');
   ylabel('Chan 2[(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   hold off;
   
   subplot(2,2,3);
   hold on;
   loglog(fvec(3:end),T*Fd3(3:N_Freq)*Uwindow,'r');
   ylabel('Chan 3[(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   hold off;
   
   subplot(2,2,4);
   hold on;
   loglog(fvec(3:end),T*Fd4(3:N_Freq)*Uwindow,'r');
   ylabel('Chan 4 [(Volts){^2}/Hz]');
   xlabel('Frequency [Hz]');
   axis tight
   hold off;

   
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
   U = sum(w.^2)/N;               % approximately .375 for hanning
   %U2 = ((norm(w)/sum(w))^2);    % used to normalize plots (p. 1-68, matlab DSP toolbox)
   Paa=Paa/U;
   Paa(N/2+2:N) = [];
   Paa(2:N/2+1)=2*Paa(2:N/2+1);
   
   f = fvec;
   Gap2 = getid(GapList);
   DCCT = getdcct;
   [FFEnable2,tmp,GapEnable2]=getff(GapList);
   %eval(['save ',fn, 'B', num2str(ii),' DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 d1 d2 d3 d4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock']); 
   
   % Web page save
   if any(GapEnable1) & any(GapEnable2) & DCCT>1
      save \\Cgsrv\alswebdata\portmann\psd2 DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 d1 d2 d3 d4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock
      siglabplot('\\Cgsrv\alswebdata\portmann\psd2',1,'\\Cgsrv\alswebdata\portmann\f2');
      
      eval(['save fastdata', num2str(ii),' DCCT Gap1 Gap2 FFEnable1 GapEnable1 FFEnable2 GapEnable2 TimeClock f1 Fs Fd1 Fd2 Fd3 Fd4 d1 d2 d3 d4 BandWidth BW_eff NumAvg LoopDelay WindowType block_size Uwindow Dfac Sclock']);  
   end
   
   
   fprintf('  POWER SPECTRUM DATA, %d Points (%d:%d:%.2f)\n',block_size, c(4),c(5),c(6));
   fprintf('  %d. RMS = %.4f  Ch 1 (PSD computed from time series, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Paa(3:end))/N));
   fprintf('  %d. RMS = %.4f  Ch 1 (time series data, mean removed)\n', ii, std(data-mean(data)));
   fprintf('  %d. RMS = %.4f  Ch 1 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd1(3:end))*Uwindow));
   
   fprintf('  %d. RMS = %.4f  Ch 2 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd2(3:end))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 3 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd3(3:end))*Uwindow));
   fprintf('  %d. RMS = %.4f  Ch 4 (Siglab PSD data, mean, f(1) & f(2) removed)\n', ii, sqrt(sum(Fd4(3:end))*Uwindow));
   fprintf('  Data saved to %s.mat\n  DCCT=%.1f mAmps\n\n', [fn, num2str(ii)],DCCT);
  
   drawnow

  
   if ii < Iter 
      while gettime-t000 < LoopDelay;
      end
   end
   close all
end

feval('cd', DirStart);
