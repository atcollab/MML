function FigureHandles = ffanal(Sector, GeVnum, DirStr)
%FFANAL - Analyses an existing feedforward table
% function FigureHandles = ffanal(Sector, GeV, Directory)
%            or
% function FigureHandles = ffanal
%
%    This function plots various information about the feed forward tables.
%
%    Sector    = the storage ring sector number for that insertion device
%    GeV       = the storage ring energy (1.0, 1.3, 1.5, 1.9)
%    Directory = the directory location where the files are located.  To directory "tree"
%                from the root or w:\public\matlab\gaptrack.
%
%    For example, ffanal(7,1.5) analyzes the most recently generated table for sector 7
%    at 1.5 GeV.
%    
%    If no input auguments are used, a dialog box will allow one
%    to choose any feed forward table.  Table are grouped in directories
%    according and energy and the date the file was generated.  The most
%    recent table is located in w:\public\matlab\gaptrack.
%

%
% Written By ALS people

% TODO
% Adpation for SOLEIL

global BPMs IDBPMs IDXgolden IDYgolden

BLeffHCM = 410;  % gauss cm / amp;
BLeffVCM = 171;  % gauss cm / amp; 
Leff = 55;       % cm

%disp(' ');

if nargin == 0
   % Load the data tables
   CurrentDir = pwd;
   
   gotodata
   cd gaptrack
   [filename, pathname] = uigetfile('id*.mat', 'Choose the desired feed forward file.');
   if filename==0
      eval(['cd ',CurrentDir]);
      disp('  Function canceled.'); disp(' ');
      return
   end
   
   eval(['cd ', pathname]);
   Datafn = filename;
   
   Sector = str2num(filename(3:4));
   GeVnum = str2num(filename(6)) + .1*str2num(filename(7));
elseif nargin == 2 | nargin == 3 
   GeVstr = num2str(GeVnum);
   
   CurrentDir = pwd;
   gotodata
   cd gaptrack
   
   if nargin == 3
      eval(['cd ', DirStr]);
   end
   
   Datafn = sprintf('id%02de%c%c.mat', Sector, GeVstr(1), GeVstr(3));
else 
   error('ffanal requires 0, 2, or 3 input arguments.');
end


Datafn = lower(Datafn);
if exist(Datafn)==2
   % OK
else
   Datafn = upper(Datafn);
   if exist(Datafn)==2
      % OK
   else
      disp('  File not found.'); disp(' ');
      return
   end
end

eval(['load ', Datafn]);
eval(['cd ', CurrentDir]);

% IDBPM starting point
% Find the IDBPMs in the sector where the ID is located.
ii = dev2elem('IDBPMx',getlist('IDBPMx',Sector));
IDBPMgoalx = IDXgolden(ii);
IDBPMgoaly = IDYgolden(ii);

ii=find(idbpmlist(:,1)==Sector);
IDBPM210ax = IDx210a(ii);
IDBPM210ay = IDy210a(ii);
IDBPM210bx = IDx210b(ii);
IDBPM210by = IDy210b(ii);

if exist('BPMFlag')==1
   if BPMFlag == 1
      disp('  Arc sector BPMs were used to generation the feed forward tables.');
   elseif BPMFlag == 2
      disp('  IDBPMs were used to generation the feed forward tables.');;
   end
end

fprintf('                Golden    Starting   Error     Ending    Error\n');
fprintf('  IDBPMx(%2d,1): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n',   Sector, IDBPMgoalx(1), IDBPM210ax(1), IDBPM210ax(1)-IDBPMgoalx(1), IDBPM210bx(1), IDBPM210bx(1)-IDBPMgoalx(1));
fprintf('  IDBPMx(%2d,2): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n',   Sector, IDBPMgoalx(2), IDBPM210ax(2), IDBPM210ax(2)-IDBPMgoalx(2), IDBPM210bx(2), IDBPM210bx(2)-IDBPMgoalx(2));
fprintf('  IDBPMz(%2d,1): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n',   Sector, IDBPMgoaly(1), IDBPM210ay(1), IDBPM210ay(1)-IDBPMgoaly(1), IDBPM210by(1), IDBPM210by(1)-IDBPMgoaly(1));
fprintf('  IDBPMz(%2d,2): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n\n', Sector, IDBPMgoaly(2), IDBPM210ay(2), IDBPM210ay(2)-IDBPMgoaly(2), IDBPM210by(2), IDBPM210by(2)-IDBPMgoaly(2));
pause(0);

% Plot tables
Buffer = .01;
HeightBuffer = .05;

h1=figure;
subplot(2,1,1);
plot(tableX(:,1),tableX(:,2),'-', tableX(:,1),tableX(:,3),'--');
%xlabel('Gap Position [mm]');
ylabel('Corrector Strength [amps]');
title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector)]);      
legend(['HCM4, Sector ',num2str(Sector-1),'  '], ...
       ['HCM1, Sector ',num2str(Sector),  '  '],0);
%[hl,hl1] = legend(['HCM4, Sector ',num2str(Sector-1),'  '], ...
%                  ['HCM1, Sector ',num2str(Sector),  '  ']);
%set(hl1(1,2),'FontUnits','points','FontSize',10);
%set(hl1(2,2),'FontUnits','points','FontSize',10);
axis tight;

subplot(2,1,2);
plot(tableY(:,1),tableY(:,2),'-', tableY(:,1),tableY(:,3),'--');
xlabel('Gap Position [mm]');
ylabel('Corrector Strength [amps]');
axis tight;
legend(['VCM4, Sector ',num2str(Sector-1),'  '], ...
       ['VCM1, Sector ',num2str(Sector),  '  '],0);
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
orient tall


h2=figure;
if exist('IDXrms') == 1     
   subplot(2,1,1);
end
plot(tableX(:,1),1000*Xrms,'-', tableX(:,1),1000*Yrms,'--');
title(['RMS Orbit Change During Table Generation for Sector ', num2str(Sector)]);
ylabel('BPM Error [microns]');
axis tight;
legend(['Horizontal  '],['Vertical    '],0);

if exist('IDXrms') == 1     
   subplot(2,1,2);
   plot(tableX(:,1),1000*IDXrms,'-', tableX(:,1),1000*IDYrms,'--');
   ylabel('IDBPM Error [microns]');
   legend(['Horizontal  '],['Vertical    '],0);
end 
xlabel('GAP Position [mm]');
axis tight;
set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
orient tall


h3=figure;
if exist('IDx210a') == 1     
   subplot(2,1,1);
end
plot(BPMs,1000*(x210a-x210b),'-', BPMs,1000*(y210a-y210b),'--');
title(['Drift in the Orbit During Table Generation for Sector ', num2str(Sector)]);
xlabel('BPM Position [meters]');
ylabel('BPM Drift [microns]');
axis tight;
xaxis([0 200]);
legend(['Horizontal  '],['Vertical    '],0);

if exist('IDx210a') == 1     
   subplot(2,1,2);
   idbpmelem = dev2elem('IDBPMx',idbpmlist);
   plot(IDBPMs(idbpmelem),1000*(IDx210a-IDx210b),'-', IDBPMs(idbpmelem),1000*(IDy210a-IDy210b),'--');
   xlabel('IDBPM Position [meters]');
   ylabel('IDBPM Drift [microns]');
   legend(['Horizontal  '],['Vertical    '],0);
   axis tight;
   xaxis([0 200]);
end

set(h3,'units','normal','position',[.5+Buffer .1+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
orient tall


% Rate of change
ExtraPlots = 1;
if ExtraPlots == 1 
   % Rate of change
   N = size(tableX,1);
   h4=figure;
   subplot(2,1,1);
   plot(tableX(2:N,1),diff(tableX(:,2))./diff(tableX(:,1)),'-', tableX(2:N,1),diff(tableX(:,3))./diff(tableX(:,1)),'--');
   %xlabel('Gap Position [mm]');
   ylabel('Horizontal [amps/mm]');
   title(['Corrector Magnet Rates for Sector ', num2str(Sector)]);
   axis tight;
   legend(['HCM4, Sector ',num2str(Sector-1),'  '], ['HCM1, Sector ',num2str(Sector),'  '],0);
      
   subplot(2,1,2); hold off
   plot(tableY(2:N,1),diff(tableY(:,2))./diff(tableY(:,1)),'-', tableY(2:N,1),diff(tableY(:,3))./diff(tableY(:,1)),'--');
   xlabel('Gap Position [mm]');
   ylabel('Vertical [amps/mm]'); 
   axis tight;
   legend(['VCM4, Sector ',num2str(Sector-1),'  '], ['VCM1, Sector ',num2str(Sector),'  '],0);
   set(h4,'units','normal','position',[.0+Buffer .1+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
   orient tall
      
   FigureHandles = [h1;h2;h3;h4];
else
   FigureHandles = [h1;h2;h3];       
end


if 0
   figure
   subplot(2,1,1);
   plot(tableX(:,1),tableX(:,2)*407,'-', tableX(:,1),tableX(:,3)*407,'--');
   %xlabel('Gap Position [mm]');
   ylabel('Corrector Strength [Gauss CM]');
   title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector)]);      
   axis tight;
   legend(['HCM4, Sector ',num2str(Sector-1),'  '], ...
          ['HCM1, Sector ',num2str(Sector),  '  '],0);
   
   subplot(2,1,2);
   plot(tableY(:,1),tableY(:,2)*171,'-', tableY(:,1),tableY(:,3)*171,'--');
   xlabel('Gap Position [mm]');
   ylabel('Corrector Strength [Gauss CM]');
   legend(['VCM4, Sector ',num2str(Sector-1),'  '], ...
          ['VCM1, Sector ',num2str(Sector),  '  '],0);
   axis tight;
   set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
   addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
   orient tall
end


%  figure(2); clf;
%  subplot(2,1,1); hold off
%  plot(h1(:,1),h1(:,2)*BLeffHCM,'-r', h1(:,1),h1(:,3)*BLeffHCM,'--r');
%  xlabel('Gap Position [mm]');
%  ylabel('Horizontal Corrector Strength [G cm]');
%
%  if GeVnum == 1.9
%    title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector),' at 1.9 GeV']);
%  elseif GeVnum == 1.5
%    title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector),' at 1.5 GeV']);
%  elseif GeVnum == 1.0
%    title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector),' at 1.0 GeV']);
%  end
%
%  legend('-r',  ['HCM4, Sector ',num2str(Sector-1),'  '], ...
%         '--r', ['HCM1, Sector ',num2str(Sector),'  ']);
%
%  subplot(2,1,2); hold off
%  plot(v1(:,1),v1(:,2)*BLeffVCM,'-r', v1(:,1),v1(:,3)*BLeffVCM,'--r');
%  xlabel('Gap Position [mm]');
%  ylabel('Vertical Corrector Strength [G cm]');
%
%  legend('-r',  ['VCM4, Sector ',num2str(Sector-1),'  '], ...
%         '--r', ['VCM1, Sector ',num2str(Sector),'  ']);


%%  Plot integrated kick stuff
%  figure(7); clf;
%  subplot(2,1,1); 
%  plot(h1(:,1),h1(:,2)*BLeffHCM+h1(:,3)*BLeffHCM,'-r'); hold on;
%  plot(v1(:,1),v1(:,2)*BLeffVCM+v1(:,3)*BLeffVCM,'--g'); hold off;
%  xlabel('Gap Position [mm]');
%  ylabel('Integrated B dl [G cm]');
%
%  if GeVnum == 1.9
%    title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector),' at 1.9 GeV']);
%  elseif GeVnum == 1.5
%    title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector),' at 1.5 GeV']);
%  elseif GeVnum == 1.0
%    title(['Insertion Device Feedfoward Table for Sector ', num2str(Sector),' at 1.0 GeV']);
%  end
%
%  legend('Horizontal','Vertical');
%
%  subplot(2,1,2);
%  plot(h1(:,1),Leff*(h1(:,2)*BLeffHCM/Leff).^2+Leff*(h1(:,3)*BLeffHCM/Leff).^2,'-r'); hold on;
%  plot(v1(:,1),Leff*(v1(:,2)*BLeffVCM/Leff).^2+Leff*(v1(:,3)*BLeffVCM/Leff).^2,'--g'); hold off;
%  xlabel('Gap Position [mm]');
%  ylabel('Integrated (B^2 dl) [G^2 cm]');
%
%  legend('Horizontal','Vertical');


