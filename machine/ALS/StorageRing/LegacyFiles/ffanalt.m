function ffanal(Sector, GeVnum, DateStr, OpenFlag)
% function ffanal(Sector, GeV, Date, OpenFlag)
%            or
% function ffanal
%
%    This function plots various information about the feed forward tables.
%
%    Sector   = the storage ring sector number for that insertion device
%    GeV      = the storage ring energy (1.0, 1.3, 1.5, 1.9)
%    Date     = the date that the table was generated (or '' for default file)
%    OpenFlag = 0 for closed data, else open data
%
%    For example, ffanal(7,1.5) analyzes the most recently generated table for sector 7
%    at 1.5 GeV, whereas ffanal(7,1.5,'6-4-96') analyze the table generated on 6-4-96.
%    
%    If no input auguments are used, a dialog box will allow one
%    to choose any feed forward table.  Table are grouped in directories
%    according and energy and the date the file was generated.  The most
%    recent table is located in w:\public\matlab\gaptrack\GeV, where GeV is the electron
%    beam energy (i.e., w:\public\matlab\gaptrack\1.5 for 1.5 GeV).
%

global IDBPMs IDBPMelem BPMs PhiX PhiY


if nargin == 0
   % Load the data tables
   CurrentDir = pwd;
   gotodata
   cd gaptrack
   [filename, pathname] = uigetfile('*.*', 'Choose the desired feed forward file or test file (.mat).');
   if filename==0
      eval(['cd ',CurrentDir]);
      disp('  Function canceled.'); disp(' ');
      return
   end
   Datafn = filename;
   eval(['cd ', pathname]);
   
   if strcmp(lower(filename(5)),'e')==1
      % User selected ff-table file
      Sector = str2num(filename(3:4));
      GeVnum = str2num(filename(6)) + .1*str2num(filename(7));
      GeVstr = sprintf('%.1f', GeVnum);
      if menu('Plot Opening or Closing Data.', 'ID Opening Data File', 'ID Closeing Data File') == 1
         Datafn1= sprintf('id%dopen.mat', Sector);
      else
         Datafn1= sprintf('id%dclos.mat', Sector);
      end
   else
      % Use open or close test file (I hope)
      if strcmp(lower(filename(4)),'c')==1 | strcmp(lower(filename(4)),'o')==1
         Sector = str2num(filename(3));
      else
         Sector = str2num(filename(3:4));
      end
      Datafn1 = filename;
      
      if ~isempty(findstr(pathname,'1.9'))
         GeVnum = 1.9;
      elseif ~isempty(findstr(pathname,'1.5'))
         GeVnum = 1.5;
      elseif ~isempty(findstr(pathname,'1.3'))
         GeVnum = 1.3;
      elseif ~isempty(findstr(pathname,'1.0'))
         GeVnum = 1.0;
      else
         disp('  Function canceled, beam energy not known.'); disp(' ');
         return
      end
      GeVstr = sprintf('%.1f', GeVnum);
      Datafn = sprintf('id%02de%c%c.mat', Sector, GeVstr(1), GeVstr(3));
   end
elseif nargin == 2 | nargin == 3  | nargin == 4
   GeVstr = sprintf('%.1f', GeVnum);
   
   CurrentDir = pwd;
   gotodata
   cd gaptrack
   
   if nargin == 3
      eval(['cd ', DirStr]);
   end
   
   Datafn = sprintf('id%02de%c%c.mat', Sector, GeVstr(1), GeVstr(3));
   
   if nargin == 4
      if OpenFlag
         Datafn1= sprintf('id%dopen.mat', Sector);
      else
         Datafn1= sprintf('id%dclos.mat', Sector);
      end
   else
      if menu('Plot openning of closing data.', 'Opening', 'Closeing') == 1
         Datafn1= sprintf('id%dopen.mat', Sector);
      else
         Datafn1= sprintf('id%dclos.mat', Sector);
      end
   end
else 
   error('ffanal requires 0, 2, 3, 4 input arguments.');
end


Datafn1 = lower(Datafn1);
if exist(Datafn1)==2
   % OK
else
   Datafn1 = upper(Datafn1);
   if exist(Datafn1)==2
      % OK
   else
      disp(['  FF test data file not found (', lower(Datafn1),').']); disp(' ');
      return
   end
end
eval(['load ', Datafn1]);


Datafn = lower(Datafn);
if exist(Datafn)==2
   % OK
else
   Datafn = upper(Datafn);
   if exist(Datafn)==2
      % OK
   else
      cd ..
      Datafn = lower(Datafn);
      if exist(Datafn)==2
         % OK
         disp(['  Feed forward file was not found in the current directory.']);
         disp(['  Using file ', Datafn, ' in directory ', pwd, '.']);
      else
         Datafn = upper(Datafn);
         if exist(Datafn)==2
            % OK
            disp(['  Feed forward file was not found in the current directory.']);
            disp(['  Using file ', Datafn, ' in directory ', pwd, '.']);
         else
            disp('  FF table file not found.'); disp(' ');
            return
         end
      end
   end
end

% End input checking


% Load data
eval(['load ', Datafn]);


% Return to current directory
eval(['cd ', CurrentDir]);



% Plot orbit data
figure; clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMx))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMx))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


figure; clf
subplot(2,1,1);
plot(Gap, 1000*mean(BPMy))
xlabel('Gap position [mm]');
ylabel('Mean(Diff. Orbit) [microns]');
title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);

subplot(2,1,2);
plot(Gap, 1000*std(BPMy))
xlabel('Gap position [mm]');
ylabel('RMS(Diff. orbit) [microns]');


ii=max(find(Gap==max(Gap)));
figure; clf
subplot(2,1,1);
plot(Gap,HCM4,tableX(:,1),tableX(:,2)+HCM4(ii));
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


subplot(2,1,2);
plot(Gap,HCM1,tableX(:,1),tableX(:,3)+HCM1(ii));
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', HCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


figure; clf
subplot(2,1,1);
plot(Gap,VCM4,tableY(:,1),tableY(:,2)+VCM4(ii));
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM8 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


subplot(2,1,2);
plot(Gap,VCM1,tableY(:,1),tableY(:,3)+VCM1(ii));
xlabel('Gap Position [mm]');
ylabel('Corrector [Amps]');
title(['ID ',num2str(Sector),', VCM1 Corrector Magnet Comparison']);
legend('Test Data   ','Actual Table ');


figure; clf
subplot(2,1,1);
plot(BPMs, 1000*BPMx);
xlabel('BPMx Position [m]');
ylabel('Diff. Orbits [microns]');
%mesh(t,BPMs,1000*BPMx);
%xlabel('Time [seconds]');
%ylabel('BPM Position [m]');
%zlabel('Diff. Orbits [microns]');
title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);
%view(95,30);

subplot(2,1,2);
plot(BPMs, 1000*BPMy)
xlabel('BPMy Position [m]');
ylabel('Diff. Orbits [microns]');
%mesh(t,BPMs,1000*BPMy);
%xlabel('Time [seconds]');
%ylabel('BPM Position [m]');
%zlabel('Diff. Orbits [microns]');
title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);
%view(95,30);
orient tall


figure; 
clf
subplot(2,2,1);
DC = ones(96,size(BPMx,2));
for i = 1:96
   DC(i,:) = DC(i,:)*BPMx(i,1);
end
plot(tout/60,BPMx-DC);grid on;
xlabel('Time [minutes]');
ylabel('BPMx [mm]');
title('Difference Orbits from Start');

DC = ones(96,size(BPMy,2));
for i = 1:96
   DC(i,:) = DC(i,:)*BPMy(i,1);
end
subplot(2,2,3);
plot(tout/60,BPMy-DC);grid on;
xlabel('Time [minutes]');
ylabel('BPMy [mm]');
title('Difference Orbits from Start');

subplot(2,2,2);
plot(BPMs,BPMx1-BPMx0)
xlabel('BPM Position [m]');
ylabel('BPMx [mm]');
title('Max-Min Gap Difference Orbit');

subplot(2,2,4);
plot(BPMs,BPMy1-BPMy0)
xlabel('BPM Position [m]');
ylabel('BPMy [mm]');
title('Max-Min Gap Difference Orbit');
orient tall


if exist('IDBPMx')==1
   figure; clf
   subplot(2,1,1);
   plot(IDBPMs(IDBPMelem), 1000*IDBPMx);
   xlabel('IDBPMx Position [m]');
   ylabel('Diff. Orbits [microns]');
   title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);
   orient tall

   %mesh(t,IDBPMs(IDBPMelem),1000*IDBPMx);
   %xlabel('Time [seconds]');
   %ylabel('IDBPMx Position [m]');
   %zlabel('Diff. Orbits [microns]');
   %title(['ID ',num2str(Sector),', Horizontal Orbit Distortion']);
   %view(95,30);
   
   
   subplot(2,1,2);
   plot(IDBPMs(IDBPMelem), 1000*IDBPMy)
   xlabel('IDBPMy Position [m]');
   ylabel('Diff. Orbits [microns]');
   title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);
   orient tall
   
   %mesh(t,IDBPMs(IDBPMelem),1000*IDBPMy);
   %xlabel('Time [seconds]');
   %ylabel('IDBPMy Position [m]');
   %zlabel('Diff. Orbits [microns]');
   %title(['ID ',num2str(Sector),', Vertical Orbit Distortion']);
   %view(95,30);
   %orient tall
   
   
   figure; 
   clf
   subplot(2,2,1);
   N = length(IDBPMelem);
   DC = ones(N,size(IDBPMx,2));
   for i = 1:N
      DC(i,:) = DC(i,:)*IDBPMx(i,1);
   end
   plot(tout/60,IDBPMx-DC);grid on;
   xlabel('Time [minutes]');
   ylabel('IDBPMx [mm]');
   title('Difference Orbits from Start');
   
   DC = ones(N,size(IDBPMy,2));
   for i = 1:N
      DC(i,:) = DC(i,:)*IDBPMy(i,1);
   end
   subplot(2,2,3);
   plot(tout/60,IDBPMy-DC);grid on;
   xlabel('Time [minutes]');
   ylabel('IDBPMy [mm]');
   title('Difference Orbits from Start');
   
   subplot(2,2,2);
   plot(IDBPMs(IDBPMelem),IDBPMx1-IDBPMx0,'-o')
   xlabel('IDBPM Position [m]');
   ylabel('IDBPMx [mm]');
   title('Max-Min Gap Difference Orbit');
   
   subplot(2,2,4);
   plot(IDBPMs(IDBPMelem),IDBPMy1-IDBPMy0,'-o')
   xlabel('IDBPM Position [m]');
   ylabel('IDBPMy [mm]');
   title('Max-Min Gap Difference Orbit');
   orient tall
end


figure; clf
subplot(2,1,1);
plot(tout/60,DCCT);grid on;
if exist('MONBPMDate') == 1
   title(['Beam Current at ',num2str(MONBPMGeV),' GeV (',MONBPMDate,' ',num2str(MONBPMClock(4)),'-',num2str(MONBPMClock(5)),'-',num2str(MONBPMClock(6)),')']);
else
   title(['Beam Current']);
end
xlabel('Time [minutes]');
ylabel('DCCT [mAmps]');
legend off;

subplot(2,1,2);
plot(tout/60,Gap);
if exist('MONBPMDate') == 1
   title(['Insertion Device Gap Locations at ',num2str(MONBPMGeV),' GeV (',MONBPMDate,' ',num2str(MONBPMClock(4)),'-',num2str(MONBPMClock(5)),'-',num2str(MONBPMClock(6)),')']);
else
   title(['Insertion Device Gap Locations']);
end
xlabel('Time [minutes]');
ylabel(['Sector ',num2str(Sector),' Gap [mm]']);
orient tall

