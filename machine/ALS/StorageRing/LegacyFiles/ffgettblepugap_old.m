function ffgettblepugap(Sector)
% function ffgettblepugap(Sector)
%
% This function generates the feed forward tables necessary for insertion device compensation
% (vertical gap motion) of the EPUs in sector 4 or 11 using the channels of the fast, local feed forward
% system. 
%
% Since there are no access functions for those channels similar to the ones for all normal corrector
% channels this function is written exclusively for the EPUs in sector 4 or 11 and cannot be directly ported
% to other EPUs in the future !
%
% Christoph Steier, April 2000

% Revision History:
% 2002-06-18, Christoph Steier, Tom Scarvie
%		included EPU in sector 11 using new family names 'VCMFF' and 'HCMFF' for the fast feed forward channels
%
%  2003-04-25 C. Steier
%		IDBPMs in sectors 1 and 3 are not used anymore since they are noisy at low beam current
%		and therefore compromise the FF tables.


alsglobe

% Initialize

% Check bpm sample rate
checkbpmavg(2);
checkidbpmavg(2);
sca_sleep(.5);

% Initialization
BPMTol = .005;
BPMIter = 5;
BPMFlag = 2;
IDBPMTol = .0003;
IDBPMIter = 5;

Navg = 1;
IDVel = 4.0;
IDVelEPU = 3; %just used for setting horizontal to zero at start
FFDate = date;
FFClock = clock;
FFGeV = GeV;

gap=[];
hcm=[];
vcm=[];



% Check/Get inputs 
if exist('GeV') == 1
   if isempty(GeV)
      disp('  Storage ring energy is unknown.  Run alsinit then run ffgettblepugap.'); disp(' ');
      return;
   end
else
   disp('  Storage ring energy is unknown.  Run alsinit then run ffgettblepugap.'); disp(' ');
   return;
end


if nargin < 1
   Sector = 4;
end

if size(Sector) == [1 1]
   % input ok
else
   disp('  ffgettblepugap aborted. Input must be a scalar.');
   return;
end

[spos, svec] = sort(IDBPMs); % [2:24 1]; % used to sort data so that IDBPM(1,1) is shown at 194.4094m, where it should be (it is upstream from injection)

% Minimum and maximum gap
[GAPmin, GAPmax] = gaplimit(Sector);

%%%%%%
% Temporary to ensure that FF generation doesn't bomb for EPU4 (min gap = 14mm, but nominal min = 15mm as of 12-04)
if Sector == 4
   EPU4min = scaget('sr04u1:Vgap_target_min');
   if EPU4min > GAPmin
      scaput('sr04u1:Vgap_target_min',GAPmin);
   end
end
%%%%%%

disp(['  The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                    Maximum Gap = ',num2str(GAPmax),' mm']);
disp(['                    Mimimum Gap = ',num2str(GAPmin),' mm']);


disp(['  Data collection started.  Figures 1 and 2 show the difference orbits between the maximum']);
disp(['  gap and the current gap position after the feed forward correction has been applied. ']);
disp(['  Ideally, these plots should be a straight line thru zero, however, due to orbit drift, BPM']);
disp(['  noise, and feed forward imperfections one can expect 10 or 20 microns of combined errors']);
disp(['  to accumulate before minimum gap is reached (hopefully not any more than that).']);
disp([' ']);


% Change to physics data directory
DirStart = pwd;
gotodata
cd gaptrack




% Create output file names
tmp = clock;
year   = tmp(1);
month  = tmp(2);
day    = tmp(3);
hour   = tmp(4);
minute = tmp(5);
seconds= tmp(6);
matfn1   = sprintf('id%02de%.0f', Sector, 10*GeV);
matfn2   = sprintf('id%02de%.0f_%4d-%02d-%02d', Sector, 10*GeV, year, month, day);
textfn1 = sprintf('id%02de%.0f.txt', Sector, 10*GeV);
textfn2 = sprintf('id%02de%.0f_%4d-%02d-%02d.txt', Sector, 10*GeV, year, month, day);


% Setup figures
Buffer = .01;
HeightBuffer = .05;

h1=figure;
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);

h2=figure(h1+1);
set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);

% BPM list

IDBPMlist1 = IDBPMlist;   
% Remove the IDBPMs in the sector where the ID is located (plus sectors 1 and 3 which are noisy at low current).
RemoveElem = sort([find(Sector==IDBPMlist(:,1));find(IDBPMlist(:,1)==1);find(IDBPMlist(:,1)==3)]);
IDBPMlist1(RemoveElem,:) = [];


% Set gap to maximum, set velocity to maximum, velocity profile off, FF off, horizontal gap to 0
setff([], 0, 0); 
setepu(Sector, 0, 0, 0, IDVelEPU, 1, 0);
setid(Sector, GAPmax, IDVel, 1, 0);  
scasleep(1);

% zero additional VME channels
setsp('HCMFF',0,[Sector-1 8;Sector 1]);
setsp('VCMFF',0,[Sector-1 8;Sector 1]);

% Setbumps
setbumps(Sector, 1);  % No sextupole correctors
scasleep(1);


% Starting orbit and corrector magnet
[x210a, y210a] = getbpm(1, Navg);
[IDx210a, IDy210a] = getidbpm(1, Navg);
HCM0 = getsp('HCMFF',[Sector-1 8; Sector 1])';
VCM0 = getsp('VCMFF',[Sector-1 8; Sector 1])';

% Main loop
i=1;
gap(i,1) = getid(Sector);
hcm(i,:) = (getsp('HCMFF',[Sector-1 8; Sector 1])'-HCM0);
vcm(i,:) = (getsp('VCMFF',[Sector-1 8; Sector 1])'-VCM0);


[X(:,i), Y(:,i)] = getbpm(1, Navg);
[IDX(:,i), IDY(:,i)] = getidbpm(1, Navg);
Xrms(i) = std(x210a-X(:,i));
Yrms(i) = std(y210a-Y(:,i));
XrmsGoal(i) = std(x210a-X(:,i));
YrmsGoal(i) = std(y210a-Y(:,i));
IterOut(i) = 1;

if GAPmin < 17
   Gaps = [(GAPmax-10):-10:60 56:-4:36 34.5:-1.5:19.5 19:-.5:GAPmin];
elseif GAPmin < 34
   Gaps = [(GAPmax-10):-10:60 56:-4:36 34.5:-1.5:GAPmin];
elseif GAPmin < 55
   Gaps = [(GAPmax-10):-10:60 56:-4:GAPmin];   
else
   Gaps = [(GAPmax-10):-10:GAPmin];   
end

if min(Gaps)>GAPmin
    Gaps = [Gaps GAPmin];
end

for i = 2:length(Gaps)+1
   g = Gaps(i-1);

   [IDxGoal, IDyGoal] = getidbpm(1, Navg);
   
   % Set gap   
   setid(Sector, g, IDVel);
   
   % Set to old table first
   %setsp('HCM', HCM0+tableXold(i,2:3)', HCMlist1);  % this does not seem to be a good idea
   %setsp('VCM', VCM0+tableYold(i,2:3)', VCMlist1);  % need to linear fit the data if you do use this???
   
   scasleep(2);
   
   % Correct orbit 
   % IDBPM least squares
%      IDxGoal = IDx210a;
      IDxGoal(RemoveElem) = [];
      
%      IDyGoal = IDy210a;
      IDyGoal(RemoveElem) = [];
      
      [STDfinal, IterOut(i)] = setidbpmepuvme(Sector, IDxGoal,  ...
                                        IDyGoal, IDBPMlist1, IDBPMIter, IDBPMTol);
      IDXrmsGoal(i) = STDfinal(1);
      IDYrmsGoal(i) = STDfinal(2);
   
   
   % Record the gap AM
   gap(i,1) = getid(Sector);
   
   
   
   
   % Record data
	hcm(i,:) = (getsp('HCMFF',[Sector-1 8; Sector 1])'-HCM0);
	vcm(i,:) = (getsp('VCMFF',[Sector-1 8; Sector 1])'-VCM0);
   [X(:,i), Y(:,i)] = getbpm(1, Navg);
   [IDX(:,i), IDY(:,i)] = getidbpm(1, Navg);
   
   
   % Statistics
   Xrms(i) = std(x210a-X(:,i));
   Yrms(i) = std(y210a-Y(:,i));
   IDXrms(i) = std(IDx210a-IDX(:,i));
   IDYrms(i) = std(IDy210a-IDY(:,i));

   
   % plot results
   figure(h1); % BPMs
   plot(BPMs,(X(:,i)-x210a)*1000,'r', BPMs,(Y(:,i)-y210a)*1000,'g');
   title(['BPM Orbit Error at a ', num2str(gap(i,1)),' mm Gap']);
   ylabel('X (red), Y (grn) Error [microns]');  
   xlabel('BPM Position [meters]');
   
   figure(h2); % IDBPMs
   %plot(IDBPMs(IDBPMelem),(IDX(:,i)-IDx210a)*1000,'r', IDBPMs(IDBPMelem),(IDY(:,i)-IDy210a)*1000,'g');
   sortIDx = (IDX(:,i)-IDx210a)*1000;
   sortIDy = (IDY(:,i)-IDy210a)*1000;
   plot(IDBPMs(IDBPMelem(svec)), sortIDx(svec),'r', IDBPMs(IDBPMelem(svec)), sortIDy(svec),'g');
	title(['IDBPM Orbit Error at a ', num2str(gap(i,1)),' mm Gap']);
   ylabel('X (red), Y (grn) Error [microns]');  
   xlabel('IDBPM Position [meters]');   
   
   drawnow
end


% Minimum gap orbits
[xmin, ymin] = getbpm(1, Navg);
[IDxmin, IDymin] = getidbpm(1, Navg);


% Make the FF-tables
   % Tables
   tableX = [gap hcm(:,1)-hcm(1,1) hcm(:,2)-hcm(1,2)];
   tableY = [gap vcm(:,1)-vcm(1,1) vcm(:,2)-vcm(1,2)];
   tableQ = [];


%  Reset gap and correctors
disp('  The insertion device gap and the correctors are being reset.'); 
disp(' ');




% Go to max gap
setid(Sector, GAPmax, IDVel);
setsp('HCMFF',HCM0',[Sector-1 8; Sector 1]);
setsp('VCMFF',VCM0',[Sector-1 8; Sector 1]);

% Ending orbits
scasleep(2);
[x210b, y210b] = getbpm(1, Navg);
[IDx210b, IDy210b] = getidbpm(1, Navg);

% Save in /matlab/srdata/gaptrack
% Save in Matlab format (binary format)
CreatedGeV = GLOBAL_SR_GEV;
CreatedDateStr = date;
CreatedClock = clock;
CreatedByStr = 'ffgettblepugap';
ReadmeStr = sprintf('%.1f GeV feed forward table saved to %s.mat in directory %s', GLOBAL_SR_GEV, matfn1, pwd);
idbpmlist = IDBPMlist;
eval(['save ', matfn1,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr BPMFlag X Y IDX IDY x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist tableX tableY tableQ Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal IterOut FFDate FFClock FFGeV']);


% Save in text format
fid = fopen(textfn1,'wt');
	fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f IDBPM\n', Sector, GeV, month, day, year, hour, minute, seconds);

   % Normal FF
   fprintf(fid,'#Gap     HCM4   HCM1   VCM4   VCM1\n');
   for i=1:size(tableX,1)
     fprintf(fid,'%.4f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3));
   end
   fclose(fid);

fprintf('  Data saved to %s\n', [pwd, '/', textfn1]);


% Save in /matlab/gaptrack/archive with the date in the file name
% Save in Matlab format (binary format)
cd archive
eval(['save ', matfn2,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr BPMFlag X Y IDX IDY x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist tableX tableY tableQ Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal IterOut FFDate FFClock FFGeV']);

% Save in text format
fid = fopen(textfn2,'wt');
	fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f IDBPM\n', Sector, GeV, month, day, year, hour, minute, seconds);

   % Normal FF
   fprintf(fid,'#Gap     HCM4   HCM1   VCM4   VCM1\n');
   for i=1:size(tableX,1)
     fprintf(fid,'%.4f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3));
   end
   fclose(fid);

fprintf('  Data saved to %s\n', [pwd, '/', textfn2]);
cd ..

% Close figures then ffanal
close(h1); 
close(h2);
FigureHandles = ffanal(Sector, GeV, '.');


disp(['  Measurement complete.  The gap position and correctors have been set back to their original']);
disp(['  setpoints.  A new table has been generated and archived to w:\public\matlab\gaptrack.']);
disp(['  If the table has been successfully generated, the RMS error over the full range of gap positions']);
disp(['  will be below 50 microns horizontally and 25 microns vertically (see Fig. 2).']);
disp(['           Figure ', num2str(FigureHandles(1)),'  ->  Corrector strength verses gap position.']);
disp(['           Figure ', num2str(FigureHandles(2)),'  ->  RMS orbit distortion verses gap position.']);
disp(['           Figure ', num2str(FigureHandles(3)),'  ->  Orbit drift during table generation verses BPM position.']);
disp(['           Figure ', num2str(FigureHandles(4)),'  ->  Rate of Change of the Corrector Magnets.']);


CPTableFlag = questdlg(sprintf('Copy %.1f GeV Table to the IOC?',GeV),'Feed Forward Table Complete','Yes','No','No');
if strcmp(CPTableFlag,'No')
   fprintf('  Use ffcopy(%d,%.1f) to copy the table over to the feed forward program.\n', Sector, GeV);
   fprintf('  Use ffread(%d) (or the "Undulator Server" application) to force the IOC to read the new table.\n', Sector);
else
   ffcopy(textfn1);
   fprintf('  For the IOC to read the new table use the "Undulator Server"\n');
   fprintf('  application or run ffread(%d) from Matlab.\n', Sector);
end


% Return of original directory
eval(['cd ', DirStart]);


% Close figures
%for i = 1:length(FigureHandles)
%   close(FigureHandles(i));
%end


fprintf('  ffgettblepugap function complete.\n');

