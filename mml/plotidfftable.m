function FigureHandles = plotidfftable(Sector, GeV)
%PLOTIDFFTABLE - Plots various information about the feed forward tables
%  FigureHandles = plotidfftable(Sector, GeV)
%  FigureHandles = plotidfftable(Directory)
%  FigureHandles = plotidfftable
%
%  Sector    - the storage ring sector number for that insertion device
%  GeV       - the storage ring energy (1.0, 1.3, 1.5, 1.9)
%  Directory - the directory location where the files are located.
%
%  For example, plotidfftable(7,1.5) analyzes the most recently generated table for IDFF.Sector 7
%  at 1.5 IDFF.GeV.
%    
%  If no input auguments are used, a dialog box will allow one
%  to choose any feed forward table.  Table are grouped in directories
%  according and energy and the date the file was generated.

%  Written by Greg Portmann


if nargin == 0
    % Load the data tables
    [FileName, DirectoryName] = uigetfile('id*.mat', 'Choose the desired feed forward file.', [getfamilydata('Directory','DataRoot'), 'ID', filesep, 'FeedForward', filesep]);
    if FileName == 0
        FigureHandles = [];
        return
    end
    FileName = [DirectoryName, FileName];
elseif nargin == 2
    FileName = sprintf('%sid%02de%c%c.mat', [getfamilydata('Directory','DataRoot'), 'ID', filesep, 'FeedForward', filesep], IDFF.Sector, floor(IDFF.GeV(1)), rem(IDFF.GeV(1),1));
elseif nargin == 1
    FileName = Sector;
else
    error('plotidfftable input error');
end

try
    load(FileName);
catch
    FigureHandles = [];
    disp('  File not found.');
    return
end


BPMxs = getspos(IDFF.BPMxFamily, IDFF.BPMxList);
BPMys = getspos(IDFF.BPMyFamily, IDFF.BPMyList);


% Plot tables
Buffer = .01;
HeightBuffer = .05;

h1=figure;
clf reset
subplot(2,1,1);
plot(IDFF.Xtable(:,1),IDFF.Xtable(:,2),'-', IDFF.Xtable(:,1),IDFF.Xtable(:,3),'--');
%xlabel('Gap Position [mm]');
ylabel('Corrector Strength [amps]');
title(['Insertion Device Feedfoward Table for Sector ', num2str(IDFF.Sector)]);      
legend(['HCM4, Sector ',num2str(IDFF.Sector-1),'  '], ...
       ['HCM1, Sector ',num2str(IDFF.Sector),  '  '], 'Location','Best');
%[hl,hl1] = legend(['HCM4, IDFF.Sector ',num2str(IDFF.Sector-1),'  '], ...
%                  ['HCM1, IDFF.Sector ',num2str(IDFF.Sector),  '  ']);
%set(hl1(1,2),'FontUnits','points','FontSize',10);
%set(hl1(2,2),'FontUnits','points','FontSize',10);
axis tight;

subplot(2,1,2);
plot(IDFF.Ytable(:,1),IDFF.Ytable(:,2),'-', IDFF.Ytable(:,1),IDFF.Ytable(:,3),'--');
xlabel('Gap Position [mm]');
ylabel('Corrector Strength [amps]');
axis tight;
legend(['VCM4, Sector ',num2str(IDFF.Sector-1),'  '], ...
       ['VCM1, Sector ',num2str(IDFF.Sector),  '  '], 'Location','Best');
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
addlabel(1,0,[num2str(IDFF.GeV),' GeV, ', datestr(IDFF.TimeStamp)]);
orient tall


h2 = figure;
clf reset
%set(h2,'units','normal','position',[.5+Buffer .1+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
subplot(2,1,1);
plot(IDFF.Xtable(:,1),1000*IDFF.Xrms,'-', IDFF.Xtable(:,1),1000*IDFF.Yrms,'--');
title(['RMS Orbit Change During Table Generation for Sector ', num2str(IDFF.Sector)]);
xlabel('GAP Position [mm]');
ylabel('BPM Error [microns]');
legend('Horizontal', 'Vertical', 'Location','Best');
axis tight;

subplot(2,1,2);
plot(BPMxs, 1000*(IDFF.Xmax.Data - IDFF.XmaxEnd.Data),'-', BPMys, 1000*(IDFF.Ymax.Data - IDFF.YmaxEnd.Data),'--');
title(['Drift in the Orbit During Table Generation']);
xlabel('BPM Position [meters]');
ylabel('BPM Drift [microns]');
axis tight;
xaxis([0 getfamilydata('Circumference')]);
legend('Horizontal', 'Vertical', 'Location','Best');

addlabel(1,0,[num2str(IDFF.GeV),' GeV, ', datestr(IDFF.TimeStamp)]);
orient tall


% Rate of change
ExtraPlots = 1;
if ExtraPlots == 1 
   % Rate of change
   h3 = figure;
   clf reset
   set(h3,'units','normal','position',[.0+Buffer .1+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
  
   N = size(IDFF.Xtable,1);
   subplot(2,1,1);
   plot(IDFF.Xtable(2:N,1),diff(IDFF.Xtable(:,2))./diff(IDFF.Xtable(:,1)),'-', IDFF.Xtable(2:N,1),diff(IDFF.Xtable(:,3))./diff(IDFF.Xtable(:,1)),'--');
   %xlabel('Gap Position [mm]');
   ylabel('Horizontal [amps/mm]');
   title(['Corrector Magnet Rates for Sector ', num2str(IDFF.Sector)]);
   axis tight;
   legend(['HCM4, Sector ',num2str(IDFF.Sector-1),'  '], ['HCM1, Sector ',num2str(IDFF.Sector),'  '], 'Location','Best');
      
   subplot(2,1,2);
   plot(IDFF.Ytable(2:N,1),diff(IDFF.Ytable(:,2))./diff(IDFF.Ytable(:,1)),'-', IDFF.Ytable(2:N,1),diff(IDFF.Ytable(:,3))./diff(IDFF.Ytable(:,1)),'--');
   xlabel('Gap Position [mm]');
   ylabel('Vertical [amps/mm]'); 
   axis tight;
   legend(['VCM4, Sector ',num2str(IDFF.Sector-1),'  '], ['VCM1, Sector ',num2str(IDFF.Sector),'  '], 'Location','Best');

   addlabel(1,0,[num2str(IDFF.GeV),' GeV, ', datestr(IDFF.TimeStamp)]);
   orient tall
      
   FigureHandles = [h1;h2;h3];
else
   FigureHandles = [h1;h2];       
end


if 0
   figure
   clf reset
   set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);

   subplot(2,1,1);
   plot(IDFF.Xtable(:,1),IDFF.Xtable(:,2)*407,'-', IDFF.Xtable(:,1),IDFF.Xtable(:,3)*407,'--');
   %xlabel('Gap Position [mm]');
   ylabel('Corrector Strength [Gauss CM]');
   title(['Insertion Device Feedfoward Table for Sector ', num2str(IDFF.Sector)]);      
   axis tight;
   legend(['HCM4, IDFF.Sector ',num2str(IDFF.Sector-1),'  '], ...
          ['HCM1, IDFF.Sector ',num2str(IDFF.Sector),  '  '], 'Location','Best');
   
   subplot(2,1,2);
   plot(IDFF.Ytable(:,1),IDFF.Ytable(:,2)*171,'-', IDFF.Ytable(:,1),IDFF.Ytable(:,3)*171,'--');
   xlabel('Gap Position [mm]');
   ylabel('Corrector Strength [Gauss CM]');
   legend(['VCM4, Sector ',num2str(IDFF.Sector-1),'  '], ...
          ['VCM1, Sector ',num2str(IDFF.Sector),  '  '], 'Location','Best');
   axis tight;
   addlabel(1,0,[num2str(IDFF.GeV),' GeV, ', datestr(IDFF.TimeStamp)]);
   orient tall
end


