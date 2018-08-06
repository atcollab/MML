function ffgettbl(Sector, BPMFlag, QUADGenFlag)
%FFGETBL - Gets a new insertion device feedforward table
% ffgettbl(Sector, BPMFlag(1=BPM, 2=IDBPM), QUADGenFlag (0-take the old quad table, else){0})
%
% This function generates the feed forward tables necessary for insertion device compensation.
%
% See also fftest, ffanal

%
% Written by ALS people

% TODO
% Needs adaptation for SOLEIL

alsglobe

% Initialize
if nargin < 3
   QUADGenFlag = 0;  % 0 -> Do not compute a quadrupole table 
end

% Check bpm sample rate
checkbpmavg(2);
checkidbpmavg(2);
sca_sleep(.5);

% Initialization
BPMTol = .005;
BPMIter = 5;
IDBPMTol = .0003;
IDBPMIter = 5;

Navg = 1;
IDVel = 3.33;
FFDate = date;
FFClock = clock;
FFGeV = GeV;

gap=[];
hcm=[];
vcm=[];


% Check/Get inputs 
if isempty(GLOBAL_SR_GEV)
	disp('  Storage ring energy is unknown.  Run alsinit then run ffgettbl.'); disp(' ');
	return;
end


disp([' ']); disp(' '); 
disp(['       INSERTION DEVICE FEED FORWARD TABLE GENERATION APPLICATION']);
disp([' ']);
disp(['  This program will generate a feed forward table at ',num2str(GeV), ' GeV.  If this is']);
disp('  not the correct beam energy, exit (enter 0 for Sector) and run alsinit.');
disp('  Before continuing, make sure the following conditions are true.  ');
disp('                    1.  Multi-bunch mode.');
disp('                    2.  FF disabled.');
disp('                    3.  Gap Control disabled.');
disp('                    4.  Current range: typically 35-45 mAmps, but any current should be OK.');
disp('                    5.  Production corrector magnet set.');
disp('                    6.  Bumps off and BTS 3 and 4 set to zero current.');
disp('                    7.  BPMs calibrated.');
disp('                    8.  Set the insertion device Velocity Profiling off (0) (just for speed).');
disp('                    9.  Slow orbit feedback off.');

if QUADGenFlag
   disp('                   10.  Tune measure system must be on (time between updates < 5 seconds).');
end

if nargin < 1
   %Sector = input('                    Sector (0-exit, 4, 5, 7, 8, 9, 12) = ');
   SectorIn = menu(str2mat(sprintf('%.1f GeV Feed Forward Generation',GeV),'Feed forward must be off!',' ','Which insertion device?'),'4-vertical','4-longitudinal','5','7','8','9','10','12','Cancel');   
   if SectorIn == 1
      % Sector 4 vertical using new feedforward method
      Sector = 4;
      ffgettblepugap;
      return
   elseif SectorIn == 2
      % Sector 4 longitudinal using new feedforward method
      Sector = 4;
      ffgettblepushift;
      %ffgettblepu;  % old method
      return
   elseif SectorIn == 3
      Sector = 5;
   elseif SectorIn == 4
      Sector = 7;
   elseif SectorIn == 5
      Sector = 8;
   elseif SectorIn == 6
      Sector = 9;
   elseif SectorIn == 7
      Sector = 10;
   elseif SectorIn == 8
      Sector = 12;
   elseif SectorIn == 9
      disp('  ffgettbl aborted.  No changes to correctors or insertion device.');
     	return
	end
end
disp(' ');

if Sector == 0
   disp('  ffgettbl aborted.  No changes to correctors or insertion device.');
   return;
end

if Sector == 5
   QUADFlag = 1;     % 1 -> use quadrupoles   
else
   QUADFlag = 0;     % 0 -> no not use quadrupoles 
end

if size(Sector) == [1 1]
   % input ok
else
   disp('  ffgettbl aborted.  Input must to a scalar.');
   return;
end


% Minimum and maximum gap
[GAPmin, GAPmax] = gaplimit(Sector);


disp(['  The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                    Maximum Gap = ',num2str(GAPmax),' mm']);
disp(['                    Mimimum Gap = ',num2str(GAPmin),' mm']);

if nargin < 2
   BPMFlag = 2; %menu1('Which BPM family to use for table generation?','96 arc sector BPMs only.','Straight section IDBPMs only.','Exit program.');
end
if isempty(BPMFlag)
   BPMFlag = 2; 
end

if BPMFlag > 2
   disp('  ffgettbl aborted, BPMFlag > 2.  No changes to correctors or insertion device.');
   return;
end

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


if QUADGenFlag==0 & QUADFlag
   disp('  Reading the old feed forward table for quadrupole compensation.');
   [tableXold, tableYold, tableQold] = fftable(Sector, GeV);
end


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


% Corrector magnet and BPM lists
HCMlist1 = [Sector-1 8;
            Sector   1];

VCMlist1 = [Sector-1 8;
            Sector   1];

HCMlistQuad = [Sector-1 2;
               Sector   7];

VCMlistQuad = [Sector-1 2;
               Sector   7];

IDBPMlist1 = IDBPMlist;   % Remove the IDBPMs in the sector where the ID is located.
RemoveElem = find(Sector==IDBPMlist(:,1));
IDBPMlist1(RemoveElem,:) = [];


% Set gap to maximum, set velocity to maximum, velocity profile off, FF off
setff([], 0, 0); 
setid(Sector, GAPmax, IDVel, 1, 0);  
scasleep(1);


% Setbumps
setbumps(Sector, 1);  % No sextupole correctors
scasleep(1);


% Starting orbit and corrector magnet
[x210a, y210a] = getbpm(1, Navg);
[IDx210a, IDy210a] = getidbpm(1, Navg);
HCM0 = getsp('HCM', HCMlist1);
VCM0 = getsp('VCM', VCMlist1);
HCMQuad0 = getsp('HCM', HCMlistQuad);
VCMQuad0 = getsp('VCM', VCMlistQuad);
QF0 = getsp('QF', [Sector-1 1;Sector 2]);
QD0 = getsp('QD', [Sector-1 1;Sector 2]);


% Main loop
i=1;
gap(i,1) = getid(Sector);
hcm(i,:) = (getsp('HCM', HCMlist1)-HCM0)';
vcm(i,:) = (getsp('VCM', VCMlist1)-VCM0)';

if QUADFlag
   hcmquad = [];
   vcmquad = [];
   qf = [];
   qd = [];
   
   hcmquad(i,:) = (getsp('HCM', HCMlistQuad)-HCMQuad0)';
   vcmquad(i,:) = (getsp('VCM', VCMlistQuad)-VCMQuad0)';
   
   qf(i,:) = (getsp('QF', [Sector-1 1;Sector 2])-QF0)';
   qd(i,:) = (getsp('QD', [Sector-1 1;Sector 2])-QD0)';
   
   if QUADGenFlag
      scasleep(5);
      tune(i,:) = gettune';
   end
end

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


for i = 2:length(Gaps)+1
   g = Gaps(i-1);
   
   % Set gap   
   setid(Sector, g, IDVel);
   
   % Set to old table first
   %setsp('HCM', HCM0+tableXold(i,2:3)', HCMlist1);  % this does not seem to be a good idea
   %setsp('VCM', VCM0+tableYold(i,2:3)', VCMlist1);  % need to linear fit the data if you do use this???
   
   scasleep(1);
   
   % Correct orbit 
   if BPMFlag == 1
      % BPM least squares
      [STDfinal, IterOut(i)] = setbpm('HCM', x210a, HCMlist1, BPMelem, ...
                                      'VCM', y210a, VCMlist1, BPMelem, BPMIter, BPMTol);
      IDXrmsGoal(i) = STDfinal(1);
      IDYrmsGoal(i) = STDfinal(2);
   else
      % IDBPM least squares
      IDxGoal = IDx210a;
      IDxGoal(RemoveElem) = [];
      
      IDyGoal = IDy210a;
      IDyGoal(RemoveElem) = [];
      
      [STDfinal, IterOut(i)] = setidbpm('HCM', IDxGoal, HCMlist1, IDBPMlist1, ...
                                        'VCM', IDyGoal, VCMlist1, IDBPMlist1, IDBPMIter, IDBPMTol);
      IDXrmsGoal(i) = STDfinal(1);
      IDYrmsGoal(i) = STDfinal(2);
   end     
   
   
   % Record the gap AM
   gap(i,1) = getid(Sector);
   
   
   % Correct tune
   if QUADFlag
      IDxGoal = getidx;
      IDyGoal = getidy;
      
      if QUADGenFlag
         % Generate a new quadrupole table
         scasleep(5);
         settunew(Sector, tune(1,:)', 1);
         scasleep(1);
         
         % Correct orbit using IDBPM least squares
         [STDfinal, IterOut] = setidbpm('HCM', IDxGoal, HCMlistQuad, IDBPMlist, ...
                                        'VCM', IDyGoal, VCMlistQuad, IDBPMlist, IDBPMIter, IDBPMTol);
         
         scasleep(5);
         tune(i,:) = gettune';
         fprintf('  Gap=%.3f mm, TuneX=%.5f, TuneY=%.5f\n', gap(i), 14+tune(i,1), 8+tune(i,2));
         pause(0);
         
      else
         % Base quadrupole setting on the old table
         tmpgap = gap(i);
         
         % just to make table1 work
         if tmpgap >= tableQold(1,1)
            tmpgap = tableQold(1,1);
         end
         if tmpgap <= tableQold(size(tableQold,1),1)
            tmpgap = tableQold(size(tableQold,1),1);
         end
         DelQF1 = table1([tableQold(:,1) tableQold(:,2)], tmpgap);
         DelQF2 = table1([tableQold(:,1) tableQold(:,3)], tmpgap);
         DelQD1 = table1([tableQold(:,1) tableQold(:,4)], tmpgap);
         DelQD2 = table1([tableQold(:,1) tableQold(:,5)], tmpgap);
         
         setsp('QF', QF0 + [DelQF1; DelQF2], [Sector-1 1; Sector 2]);
         setsp('QD', QD0 + [DelQD1; DelQD2], [Sector-1 1; Sector 2]);
         
         if all([DelQF1 DelQF2 DelQD1 DelQD2] == [0 0 0 0])
            % Don't correct the orbit
         else
            scasleep(1);
            % Correct orbit using IDBPM least squares
            [STDfinal, IterOut] = setidbpm('HCM', IDxGoal, HCMlistQuad, IDBPMlist, ...
                                           'VCM', IDyGoal, VCMlistQuad, IDBPMlist, IDBPMIter, IDBPMTol);
         end
         
         % Since the tune measurement system is probably not on, fill with zeros
         tune(i,:) = [0 0];   %gettune';   
      end
            
      qf(i,:) = (getsp('QF', [Sector-1 1;Sector 2])-QF0)';
      qd(i,:) = (getsp('QD', [Sector-1 1;Sector 2])-QD0)';
      
      hcmquad(i,:) = (getsp('HCM', HCMlistQuad)-HCMQuad0)';
      vcmquad(i,:) = (getsp('VCM', VCMlistQuad)-VCMQuad0)';
   end
   
   
   % Record data
   hcm(i,:) = (getsp('HCM', HCMlist1)-HCM0)';
   vcm(i,:) = (getsp('VCM', VCMlist1)-VCM0)';
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
   plot(IDBPMs(IDBPMelem),(IDX(:,i)-IDx210a)*1000,'r', IDBPMs(IDBPMelem),(IDY(:,i)-IDy210a)*1000,'g');
   title(['IDBPM Orbit Error at a ', num2str(gap(i,1)),' mm Gap']);
   ylabel('X (red), Y (grn) Error [microns]');  
   xlabel('IDBPM Position [meters]');   
   
   drawnow
end


% Minimum gap orbits
[xmin, ymin] = getbpm(1, Navg);
[IDxmin, IDymin] = getidbpm(1, Navg);


% Make the FF-tables
if QUADFlag
   % Tables
   tableX = [gap hcm(:,1)-hcm(1,1) hcm(:,2)-hcm(1,2) hcmquad];
   tableY = [gap vcm(:,1)-vcm(1,1) vcm(:,2)-vcm(1,2) vcmquad];
   tableQ = [gap qf qd tune];
else
   % Tables
   tableX = [gap hcm(:,1)-hcm(1,1) hcm(:,2)-hcm(1,2)];
   tableY = [gap vcm(:,1)-vcm(1,1) vcm(:,2)-vcm(1,2)];
   tableQ = [];
end


%  Reset gap and correctors
disp('  The insertion device gap and the correctors are being reset.'); 
disp(' ');


if QUADFlag
   % Reset the quadrupole in steps (or the beam will dump)
   i = length(gap)-2;
   setid(Sector, gap(i), IDVel);
   setsp('QF', QF0+qf(i,:)', [Sector-1 1;Sector 2]);
   setsp('QD', QD0+qd(i,:)', [Sector-1 1;Sector 2]);
   setsp('HCM', HCMQuad0+hcmquad(i,:)', HCMlistQuad);
   setsp('VCM', VCMQuad0+vcmquad(i,:)', VCMlistQuad);

   i = length(gap)-6;
   setid(Sector, gap(i), IDVel);
   setsp('QF', QF0+qf(i,:)', [Sector-1 1;Sector 2]);
   setsp('QD', QD0+qd(i,:)', [Sector-1 1;Sector 2]);
   setsp('HCM', HCMQuad0+hcmquad(i,:)', HCMlistQuad);
   setsp('VCM', VCMQuad0+vcmquad(i,:)', VCMlistQuad);

   i = length(gap)-10;
   setid(Sector, gap(i), IDVel);
   setsp('QF', QF0+qf(i,:)', [Sector-1 1;Sector 2]);
   setsp('QD', QD0+qd(i,:)', [Sector-1 1;Sector 2]);
   setsp('HCM', HCMQuad0+hcmquad(i,:)', HCMlistQuad);
   setsp('VCM', VCMQuad0+vcmquad(i,:)', VCMlistQuad);
   
   % Reset to max gap values
   setsp('QF', QF0, [Sector-1 1;Sector 2]);
   setsp('QD', QD0, [Sector-1 1;Sector 2]);    
   setsp('HCM', HCMQuad0, HCMlistQuad);
   setsp('VCM', VCMQuad0, VCMlistQuad);
end


% Go to max gap
setid(Sector, GAPmax, IDVel);
setsp('HCM', HCM0, HCMlist1);
setsp('VCM', VCM0, VCMlist1);


% Ending orbits
scasleep(2);
[x210b, y210b] = getbpm(1, Navg);
[IDx210b, IDy210b] = getidbpm(1, Navg);


% Save in matlab/srdata/gaptrack
% Save in Matlab format (binary format)
CreatedGeV = GLOBAL_SR_GEV;
CreatedDateStr = date;
CreatedClock = clock;
CreatedByStr = 'ffgettbl';
ReadmeStr = sprintf('%.1f GeV feed forward table saved to %s.mat in directory %s', GLOBAL_SR_GEV, matfn1, pwd);
idbpmlist = IDBPMlist;
eval(['save ', matfn1,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr BPMFlag X Y IDX IDY x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist tableX tableY tableQ Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal IterOut FFDate FFClock FFGeV']);


% Save in text format
fid = fopen(textfn1,'wt');
if BPMFlag == 1
	fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f BPM\n', Sector, GeV, month, day, year, hour, minute, seconds);
else
	fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f IDBPM\n', Sector, GeV, month, day, year, hour, minute, seconds);
end

if QUADFlag
   fprintf(fid,'#Gap HCM(S-1,8) HCM(S,1) VCM(S-1,8) VCM(S,1) HCM(S-1,2) HCM(S,7) VCM(S-1,2) VCM(S,7) QF(S-1,1) QF(S,2)  QD(S-1,1) QD(S,2)\n');
   for i=1:size(tableX,1)
      fprintf(fid,'%.4f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3), hcmquad(i,1), hcmquad(i,2), vcmquad(i,1), vcmquad(i,2), qf(i,1), qf(i,2), qd(i,1), qd(i,2));
   end
   fclose(fid);
else
   % Normal FF
   fprintf(fid,'#Gap     HCM4   HCM1   VCM4   VCM1\n');
   for i=1:size(tableX,1)
     fprintf(fid,'%.4f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3));
   end
   fclose(fid);
end
fprintf('  Data saved to %s\n', [pwd, '/', textfn1]);


% Save in w:\public\matlab\gaptrack\archive with the date in the file name
% Save in Matlab format (binary format)
cd archive
eval(['save ', matfn2,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr BPMFlag X Y IDX IDY x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist tableX tableY tableQ Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal IterOut FFDate FFClock FFGeV']);

% Save in text format
fid = fopen(textfn2,'wt');
if BPMFlag == 1
	fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f BPM\n', Sector, GeV, month, day, year, hour, minute, seconds);
else
	fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f IDBPM\n', Sector, GeV, month, day, year, hour, minute, seconds);
end

if QUADFlag
   fprintf(fid,'#Gap HCM(S-1,8) HCM(S,1) VCM(S-1,8) VCM(S,1) HCM(S-1,2) HCM(S,7) VCM(S-1,2) VCM(S,7) QF(S-1,1) QF(S,2)  QD(S-1,1) QD(S,2)\n');
   for i=1:size(tableX,1)
      fprintf(fid,'%.4f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3), hcmquad(i,1), hcmquad(i,2), vcmquad(i,1), vcmquad(i,2), qf(i,1), qf(i,2), qd(i,1), qd(i,2));
   end
   fclose(fid);
else
   % Normal FF
   fprintf(fid,'#Gap     HCM4   HCM1   VCM4   VCM1\n');
   for i=1:size(tableX,1)
     fprintf(fid,'%.4f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3));
   end
   fclose(fid);
end
fprintf('  Data saved to %s\n', [pwd, '/', textfn2]);
cd ..

% Close figures then ffanal
close(h1); 
close(h2);
FigureHandles = ffanal(Sector, GeV);


disp(['  Measurement complete.  The gap position and correctors have been set back to their original setpoints.']);
disp(['  A new table has been generated and saved to directory /home/als/physdata/matlab/srdata/gaptrack.']);
disp(['  If the table has been successfully generated, the RMS error over the full range of gap positions will be']);
disp(['  below 10 microns (see Fig. 2), however it is probably OK to except a table with up to 25 microns of error.']);
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


fprintf('  ffgettbl function complete.\n');

