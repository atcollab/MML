function FigureHandles = ffanalepu(Sector, GeVnum, DirStr, EPUmode)
% function FigureHandles = ffanalepu(Sector, GeV, Directory, EPUmode)
%            or
% function FigureHandles = ffanalepu
%
%    This function plots various information about the EPU longitudinal feed forward tables.
%
%    Sector    = the storage ring sector number for that EPU
%    GeV       = the storage ring energy (1.0, 1.3, 1.5, 1.9)
%    Directory = the directory location where the files are located.  To directory "tree"
%                from the root or \\Als-filer\physdata\matlab\srdata\gaptrack.
%    EPUmode   = operation mode of the EPU (0 = parallel/circular polarization;
%                                           1 = antiparallel/linear polarization)
%
%    For example, ffanalepu(4,1.5,[],0) analyzes the most recently generated
%    parallel table for sector 4 at 1.5 GeV.
%    
%    If no input auguments are used, a dialog box will allow one
%    to choose any longitudinal EPU feed forward table.  Tables are grouped in
%    directories according to energy and the date the file was generated.  The most
%    recent table is located in \\Als-filer\physdata\matlab\srdata\gaptrack.
%

% 2002-07-29 T. Scarvie
% 	Updated to draw IDBPMs at proper position along ring (IDBPM(1,1) is at 194m)


global BPMs IDBPMs IDXgolden IDYgolden

BLeffHCM = 410;  % gauss cm / amp;
BLeffVCM = 171;  % gauss cm / amp; 
Leff = 55;       % cm

[spos, svec] = sort(IDBPMs); % [2:24 1]; % used to sort data so that IDBPM(1,1) is shown at 194.4094m, where it should be (it is upstream from injection)

if nargin == 0
   % Load the data tables
   CurrentDir = pwd;
   
   if (strcmp(CurrentDir(end-7:end),'gaptrack') | strcmp(CurrentDir(end-6:end),'archive')) 
		% stay in the current directory
   else
		gotodata
		cd gaptrack
	end
	[filename, pathname] = uigetfile('epu*.mat', 'Choose the desired feed forward file.');
   if filename==0
      eval(['cd ',CurrentDir]);
      disp('  Function canceled.'); disp(' ');
      return
   end
   
   eval(['cd ', pathname]);
   Datafn = filename;
   
   Sector = str2num(filename(4:5));
elseif nargin == 2 | nargin == 3
   GeVstr = num2str(GeVnum);

	ffanal(Sector,GeVnum);
	return
elseif nargin == 4 % | nargin == 2 | nargin == 3
   GeVstr = num2str(GeVnum);
   
   CurrentDir = pwd;
   gotodata
   cd gaptrack
   
   %Datafn = sprintf('id%02de%c%c.mat', Sector, GeVstr(1), GeVstr(3))
   
   %if nargin == 3 | nargin == 4
   %   eval(['cd ', DirStr]);
   %end
   
   if nargin == 4   
       Datafn = sprintf('epu%02dm%01de%c%c.mat', Sector, EPUmode, GeVstr(1), GeVstr(3));
       if EPUmode == 0
           fprintf('  Parallel mode EPU table\n');
       elseif EPUmode == 1
           fprintf('  Anti-parallel mode EPU table\n');
       else
           fprintf(  'Unknown shift mode!\n');
       end
   end
   
   
else 
   error('ffanalepu requires 0,2,3 or 4 input arguments.');
end


Datafn = lower(Datafn);
if exist(Datafn)==2
   % OK
else
   Datafn = upper(Datafn);
   if exist(Datafn)==2
      % OK
   else
      disp('  File not found.'); 
      disp(' ');
      return
   end
end

eval(['load ', Datafn]);
eval(['cd ', CurrentDir]);
GeVnum = CreatedGeV; 

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

fprintf('  \n');
fprintf('                Golden    Starting   Error     Ending    Error\n');
fprintf('  IDBPMx(%2d,1): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n',   Sector, IDBPMgoalx(1), IDBPM210ax(1), IDBPM210ax(1)-IDBPMgoalx(1), IDBPM210bx(1), IDBPM210bx(1)-IDBPMgoalx(1));
fprintf('  IDBPMx(%2d,2): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n',   Sector, IDBPMgoalx(2), IDBPM210ax(2), IDBPM210ax(2)-IDBPMgoalx(2), IDBPM210bx(2), IDBPM210bx(2)-IDBPMgoalx(2));
fprintf('  IDBPMy(%2d,1): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n',   Sector, IDBPMgoaly(1), IDBPM210ay(1), IDBPM210ay(1)-IDBPMgoaly(1), IDBPM210by(1), IDBPM210by(1)-IDBPMgoaly(1));
fprintf('  IDBPMy(%2d,2): %6.3f     %6.3f   %6.3f     %6.3f   %6.3f  [mm]\n\n', Sector, IDBPMgoaly(2), IDBPM210ay(2), IDBPM210ay(2)-IDBPMgoaly(2), IDBPM210by(2), IDBPM210by(2)-IDBPMgoaly(2));


% Plot tables
Buffer = .01;
HeightBuffer = .05;

[Vgap, Lgap] = meshgrid(Gaps, GapsLongitudinal);

h1=figure;
subplot(2,1,1);
mesh(Vgap, Lgap, HCMtable1');
xlabel('Gap Position [mm]');
ylabel('Longitudinal Position [mm]');
zlabel('Corrector Strength [amps]');
title(['Sector ', num2str(Sector), ' Insertion Device Feedfoward Table HCM(', num2str(Sector-1),',8)']);
axis tight
view(-60,30);

subplot(2,1,2);
mesh(Vgap, Lgap, HCMtable2');
xlabel('Gap Position [mm]');
ylabel('Longitudinal Position [mm]');
zlabel('Corrector Strength [amps]');
title(['Sector ', num2str(Sector), ' Insertion Device Feedfoward Table HCM(', num2str(Sector),',1)']);
axis tight
view(-60,30);
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);
addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
orient tall



h2=figure;
subplot(2,1,1);
mesh(Vgap, Lgap, VCMtable1');
xlabel('Gap Position [mm]');
ylabel('Longitudinal Position [mm]');
zlabel('Corrector Strength [amps]');
title(['Sector ', num2str(Sector), ' Insertion Device Feedfoward Table VCM(', num2str(Sector-1),',8)']);      
axis tight
view(-60,30);

subplot(2,1,2);
mesh(Vgap, Lgap, VCMtable2');
xlabel('Gap Position [mm]');
ylabel('Longitudinal Position [mm]');
zlabel('Corrector Strength [amps]');
title(['Sector ', num2str(Sector), ' Insertion Device Feedfoward Table VCM(', num2str(Sector),',1)']);    
axis tight
view(-60,30);
addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
orient tall
set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);



h3=figure;
subplot(2,1,1);
mesh(Vgap, Lgap, 1000*IDXrms');
xlabel('Gap Position [mm]');
ylabel('Longitudinal Position [mm]');
zlabel('Horizontal RMS [Microns]');
title(['RMS Orbit Change During Table Generation for Sector ', num2str(Sector)]);
axis tight
view(-60,30);

subplot(2,1,2);
mesh(Vgap, Lgap, 1000*IDYrms');
xlabel('Gap Position [mm]');
ylabel('Longitudinal Position [mm]');
zlabel('Vertical RMS [Microns]');
title(['RMS Orbit Change During Table Generation for Sector ', num2str(Sector)]);
axis tight
view(-60,30);
addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
orient tall
set(h3,'units','normal','position',[.5+Buffer .1+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);



h4=figure;
subplot(2,1,1);
plot(BPMs,1000*(x210a-x210b),'-', BPMs,1000*(y210a-y210b),'--');
title(['Drift in the Orbit During Table Generation for Sector ', num2str(Sector)]);
xlabel('BPM Position [meters]');
ylabel('BPM Drift [microns]');
legend(['Horizontal  '],['Vertical    '],0);
axis tight

subplot(2,1,2);
idbpmelem = dev2elem('IDBPMx',idbpmlist);
plot(IDBPMs(idbpmelem(svec)),1000*(IDx210a(svec)-IDx210b(svec)),'-', IDBPMs(idbpmelem(svec)),1000*(IDy210a(svec)-IDy210b(svec)),'--');
xlabel('IDBPM Position [meters]');
ylabel('IDBPM Drift [microns]');
axis tight
addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
legend(['Horizontal  '],['Vertical    '],0);
orient tall
set(h4,'units','normal','position',[.0+Buffer .1+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


FigureHandles = [h1;h2;h3;h4];



if 0
   figure;
   subplot(2,1,1);
   mesh(Vgap, Lgap, HCMtable1'*407);
   xlabel('Gap Position [mm]');
   ylabel('Longitudinal Position [mm]');
   zlabel(['HCM(', num2str(Sector-1),',8) [Gauss CM]']);
   axis tight
   view(-60,30);
   
   subplot(2,1,2);
   mesh(Vgap, Lgap, HCMtable2'*407);
   xlabel('Gap Position [mm]');
   ylabel('Longitudinal Position [mm]');
   zlabel(['HCM(', num2str(Sector),',1) [Gauss CM]']);
   axis tight
   view(-60,30);
   addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
   orient tall
   
   
   figure;
   subplot(2,1,1);
   mesh(Vgap, Lgap, VCMtable1'*171);
   xlabel('Gap Position [mm]');
   ylabel('Longitudinal Position [mm]');
   zlabel(['VCM(', num2str(Sector-1),',8) [Gauss CM]']);
   axis tight
   view(-60,30);
   
   subplot(2,1,2);
   mesh(Vgap, Lgap, VCMtable2'*171);
   xlabel('Gap Position [mm]');
   ylabel('Longitudinal Position [mm]');
   zlabel(['VCM(', num2str(Sector),',1) [Gauss CM]']);
   axis tight
   view(-60,30);
   addlabel(1,0,[num2str(GeVnum),' GeV, ', FFDate]);
   orient tall
end
