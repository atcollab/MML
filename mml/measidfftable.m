function measidfftable(Sector, BPMFlag)
%MEASIDFFTABLE - Measures an insertion device feed forward table for the vertical gap 
%  measidfftable(Sector, BPMFlag (0=Bergoz BPMs, else=All BPMs))
%
%  This function generates the feed forward tables necessary for insertion device compensation.
%
%  This function is under development


%     To do: 1. Slow/fast correctors?
%            2. Use FF channels?
%            3. Use center chicane BPMs and correctors?


% Initialization

% Need to change this to a question dialog to allow for local tune compensation; hard-coded for now - 2004-07-06, T.Scarvie
FFTypeFlag = 'Global';

if nargin < 2
   BPMFlag = [];
end
if isempty(BPMFlag)
   BPMFlag = 0;  % menu1('Which BPM family to use for table generation?','96 arc sector BPMs only.','Straight section IDBPMs only.','Exit program.'); 
end



IDFF.GapVelocity = 3.33;
IDFF.GeV = getenergy;


disp([' ']); disp(' '); 
disp(['        INSERTION DEVICE FEED FORWARD TABLE GENERATION APPLICATION']);
disp([' ']);
disp(['   This program will generate a feed forward table at ',num2str(IDFF.GeV), ' GeV.']);
disp('   Before continuing, make sure the following conditions are true.  ');
disp('                     1.  Multi-bunch mode.');
disp('                     2.  FF disabled.');
disp('                     3.  Gap Control disabled.');
disp('                     4.  Current range: typically 35-45 mAmps, but any current should be OK.');
disp('                     5.  Production corrector magnet set.');
disp('                     6.  Bumps off and BTS 3 and 4 set to zero current.');
disp('                     7.  Set the insertion device Velocity Profiling off (0) (just for speed).');
disp('                     8.  Slow orbit feedback off.');
if BPMFlag
disp('                     9.  BPMs calibrated.');
end


if nargin < 1
   SectorIn = menu(str2mat(sprintf('%.1f GeV Feed Forward Generation',IDFF.GeV),'Feed forward must be off!',' ','Which insertion device?'),'4-vertical','4-longitudinal','5','7','8','9','10','11-vertical','11-longitudinal','12','Cancel');   
   if SectorIn == 1
      % Sector 4 vertical using new feedforward method
      Sector = 4;
      ffgettblepugap(Sector);
      return
   elseif SectorIn == 2
      % Sector 4 longitudinal using new feedforward method
      Sector = 4;
      ffgettblepushift(Sector);
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
      % Sector 11 vertical using new feedforward method
      Sector = 11;
      ffgettblepugap(Sector);
      return
   elseif SectorIn == 9
      % Sector 11 longitudinal using new feedforward method
      Sector = 11;
      ffgettblepushift(Sector);
      return
   elseif SectorIn == 10
      Sector = 12;
   elseif SectorIn == 11
      disp('   ffgettbl aborted.  No changes to correctors or insertion device.');
     	return
	end
end
disp(' ');
if Sector == 0
   disp('   ffgettbl aborted.  No changes to correctors or insertion device.');
   return;
end



%%%%%%%%%%%%%
% BPM Setup %
%%%%%%%%%%%%%
IDFF.BPMxFamily = 'BPMx';
IDFF.BPMyFamily = 'BPMy';

if BPMFlag
    % Use all BPMs
    BPMTol = .005;
    BPMIter = 5;
    IDFF.BPMxList = getbpmlist('x');
    IDFF.BPMyList = getbpmlist('y');
else
    % Only use Bergoz BPMs
    BPMTol = .0003;
    BPMIter = 5;
    IDFF.BPMxList = getbpmlist('x', 'Bergoz', '1 2 3 4 5 6 7 8 9 10');  % 11 12 ???
    IDFF.BPMyList = getbpmlist('y', 'Bergoz', '1 2 3 4 5 6 7 8 9 10');
end

% Remove the BPMs in the sector where the ID is located
iRemove = findrowindex([Sector-1 10; Sector-1 11; Sector-1 12; Sector 1], IDFF.BPMxList);
IDFF.BPMxList(iRemove,:) = [];

iRemove = findrowindex([Sector-1 10; Sector-1 11; Sector-1 12; Sector 1], IDFF.BPMyList);
IDFF.BPMyList(iRemove,:) = [];

% % Remove the BPMs in sectors 1 and 3 which are noisy at low current).
% iRemove = findrowindex([12 9; 1 2], BPMlist);
% BPMlist(iRemove,:) = [];


%%%%%%%%%%%%%%%%%%%
% Corrector Setup %
%%%%%%%%%%%%%%%%%%%
IDFF.HCMFamily = 'HCM';
IDFF.VCMFamily = 'VCM';


% Corrector magnet and BPM lists
if Sector == 6 & IDDeviceList(1,2) == 1  % ???
    IDFF.HCMList = [Sector-1  8;
                    Sector-1 10];
    IDFF.VCMList = [Sector-1  8;
                    Sector-1 10];
else
    IDFF.HCMList = [Sector-1 8;
                    Sector   1];
    IDFF.VCMList = [Sector-1 8;
                    Sector   1];
end


% Fast setpoints
HCMRampRate0 = getpv(IDFF.HCMFamily, 'RampRate', IDFF.HCMList);
VCMRampRate0 = getpv(IDFF.VCMFamily, 'RampRate', IDFF.VCMList);
setpv(IDFF.HCMFamily, 'RampRate', 1000, IDFF.HCMList, 0);
setpv(IDFF.VCMFamily, 'RampRate', 1000, IDFF.VCMList, 0);


%%%%%%%%%%%%%%%%%
% End ALS Setup %
%%%%%%%%%%%%%%%%%



% Multiple FF-tables
if size(Sector,1) ~= 1
    for iSector = 1:size(Sector,1)
        measidfftable(Sector(iSector,:), BPMFlag);
    end
    return;
end


% Minimum and maximum gap
[IDFF.GAPmin, IDFF.GAPmax] = gaplimit(Sector);


disp(['   The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                     Maximum Gap = ',num2str(IDFF.GAPmax),' mm']);
disp(['                     Mimimum Gap = ',num2str(IDFF.GAPmin),' mm']);


disp(['   Data collection started.  Figures 1 and 2 show the difference orbits between the maximum']);
disp(['   gap and the current gap position after the feed forward correction has been applied.']);
disp(['   Ideally, these plots should be a straight line thru zero, however, due to orbit drift, BPM']);
disp(['   noise, and feed forward imperfections one can expect 10 or 20 microns of combined errors']);
disp(['   to accumulate before minimum gap is reached (hopefully not any more than that).']);
disp(['  ']);


% Setup figures
Buffer = .01;
HeightBuffer = .05;

h1 = gcf;
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


% Set gap to maximum, set velocity to maximum, velocity profile off, FF off,
setff([], 0, 0);
setid(Sector, IDFF.GAPmax, IDFF.GapVelocity, 1, 0);


% Load and set QF and QD setpoints from the golden lattice
ConfigSetpoint = getproductionlattice;
setpv(ConfigSetpoint.QF.Setpoint);
setpv(ConfigSetpoint.QD.Setpoint);  
QFsp = ConfigSetpoint.QF.Setpoint.Data;
QDsp = ConfigSetpoint.QD.Setpoint.Data;


% Setbumps w/o sextupole correctors
setbumps(Sector, 1);


% Starting orbit and corrector magnet
IDFF.Xmax = getam(IDFF.BPMxFamily, IDFF.BPMxList, 'Struct');
IDFF.Ymax = getam(IDFF.BPMyFamily, IDFF.BPMyList, 'Struct');
BPMxs = getspos(IDFF.Xmax);
BPMys = getspos(IDFF.Ymax);

IDFF.HCM = getsp(IDFF.HCMFamily, IDFF.HCMList, 'Struct');
IDFF.VCM = getsp(IDFF.VCMFamily, IDFF.VCMList, 'Struct');
HCM0 = IDFF.HCM.Data;
VCM0 = IDFF.VCM.Data;
QF0 = getsp('QF');
QD0 = getsp('QD');


% Main loop
i=1;
IDFF.GapMonitor(i,1) = getid(Sector);
hcm(i,:) = (getsp(IDFF.HCMFamily, IDFF.HCMList)-HCM0)'; % First entry is zero
vcm(i,:) = (getsp(IDFF.VCMFamily, IDFF.VCMList)-VCM0)';

X(:,i) = IDFF.Xmax.Data;
Y(:,i) = IDFF.Ymax.Data;
Xrms(i) = std(IDFF.Xmax.Data - X(:,i));
Yrms(i) = std(IDFF.Ymax.Data - Y(:,i));
IterOut(i) = 1;


if IDFF.GAPmin < 14
   Gaps = [(IDFF.GAPmax-10):-10:60 56:-4:36 34.5:-1.5:19.5 19:-.5:15 14.75:-.25:IDFF.GAPmin];
elseif IDFF.GAPmin < 17
   Gaps = [(IDFF.GAPmax-10):-10:60 56:-4:36 34.5:-1.5:19.5 19:-.5:IDFF.GAPmin];
elseif IDFF.GAPmin < 34
   Gaps = [(IDFF.GAPmax-10):-10:60 56:-4:36 34.5:-1.5:IDFF.GAPmin];
elseif IDFF.GAPmin < 55
   Gaps = [(IDFF.GAPmax-10):-10:60 56:-4:IDFF.GAPmin];   
else
   Gaps = [(IDFF.GAPmax-10):-10:IDFF.GAPmin];   
end

if Gaps(length(Gaps)) > IDFF.GAPmin
    Gaps = [Gaps IDFF.GAPmin];
end

TUNEresp = gettuneresp;

for i = 2:length(Gaps)+1
   g = Gaps(i-1);
   
   % Set gap   
   setid(Sector, g, IDFF.GapVelocity);
   
   % Set to old table first
   %setsp(IDFF.HCMFamily, HCM0+Xtableold(i,2:3)', IDFF.HCMList);  % this does not seem to be a good idea
   %setsp(IDFF.VCMFamily, VCM0+Ytableold(i,2:3)', IDFF.VCMList);  % need to linear fit the data if you do use this???

   % Change Quads via Tune FF to simulate conditions during production
   % using tune feed forward code from orbit feedback
   
   % Change in tune and [QF;QD] from maximum gap
   if strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, High Tune')
      if i==2
         fprintf('   Generating feedforward table for %s mode\n', getfamilydata('OperationalMode'));
      end
      
      
      if strcmp(FFTypeFlag,'Local')
         disp('   Using local tune compensation.');
         
         addQFsp = zeros(24,1);
         addQDsp = zeros(24,1);
         
         % Change in tune and [QF;QD] from maximum gap
         actualgap = getid(Sector);
         if actualgap < (IDFF.GAPmin-1)
            actualgap = IDFF.GAPmax;
         end  
         DeltaNuY = gap2tune(Sector, actualgap);
         fraccorr = 1.15*DeltaNuY./gap2tune(5,13.23,1.9);               
         
         % Find which quads to change
         QuadList = [Sector-1 1;Sector-1 2;Sector 1;Sector 2];
         QuadElem = dev2elem('QF',QuadList);
         
         if (Sector==7) | (Sector==10) | (Sector==11)
            QFfac=(fraccorr.*([2.227520/2.237111;2.239570/2.237111;2.239570/2.237111;2.227520/2.237111]-1));               
            QDfac=(fraccorr.*([2.432264/2.511045;2.543089/2.511045;2.54308/2.511045;2.432264/2.511045]-1));
         elseif (Sector==5) | (Sector==9)
            QFfac=(fraccorr.*([2.208418/2.219784;2.225926/2.219784;2.231777/2.237111;2.233775/2.237111]-1));               
            QDfac=(fraccorr.*([2.386512/2.483259;2.545907/2.483259;2.474571/2.511045;2.491079/2.511045]-1));
         elseif (Sector==4) | (Sector==8) | (Sector==12)
            QFfac=(fraccorr.*([2.233775/2.237111;2.231777/2.237111;2.225926/2.219784;2.208418/2.219784]-1));               
            QDfac=(fraccorr.*([2.491079/2.511045;2.474571/2.511045;2.545907/2.483259;2.386512/2.483259]-1));
         else
            QFfac=zeros(4,1);               
            QDfac=zeros(4,1);
         end
         
         addQFsp(QuadElem) = addQFsp(QuadElem)+QFfac.*QFsp(QuadElem);
         addQDsp(QuadElem) = addQDsp(QuadElem)+QDfac.*QDsp(QuadElem);                              
         
      elseif strcmp(FFTypeFlag,'Global')
         
         addQFsp = zeros(24,1);
         addQDsp = zeros(24,1);
         
         % Change in tune and [QF;QD] from maximum gap
         actualgap = getid(Sector);
         if actualgap < (IDFF.GAPmin-1)
            actualgap = IDFF.GAPmax;
         end
         DeltaNuY = gap2tune(Sector, actualgap);
         DeltaNuX = 0;
         fraccorr = DeltaNuY./gap2tune(5,13.23,1.9);               
         
         % Find which quads to change
         QuadList = [Sector-1 2;Sector 1];
         QuadElem = dev2elem('QF',QuadList);
         
         DeltaAmps = inv(TUNEresp) * [(fraccorr*6.23e-4)-DeltaNuX;fraccorr*(-0.05301)];    %  DelAmps =  [QF; QD];
         addQFsp = addQFsp+DeltaAmps(1,1);
         addQDsp = addQDsp+DeltaAmps(2,1);
         
         if (Sector==7) | (Sector==10) | (Sector==11)
            QFfac=(fraccorr.*([2.243127/2.237111;2.243127/2.237111]-1));               
            QDfac=(fraccorr.*([2.556392/2.511045;2.556392/2.511045]-1));
         elseif (Sector==5) | (Sector==9)
            QFfac=(fraccorr.*([2.225965/2.219784;2.243096/2.237111]-1));               
            QDfac=(fraccorr.*([2.528950/2.483259;2.556345/2.511045]-1));
         elseif (Sector==4) | (Sector==8) | (Sector==12)
            QFfac=(fraccorr.*([2.243096/2.237111;2.225965/2.219784]-1));               
            QDfac=(fraccorr.*([2.556345/2.511045;2.528950/2.483259]-1));
         else
            QFfac=zeros(4,1);               
            QDfac=zeros(4,1);
         end
         
         addQFsp(QuadElem) = addQFsp(QuadElem)+QFfac.*QFsp(QuadElem);
         addQDsp(QuadElem) = addQDsp(QuadElem)+QDfac.*QDsp(QuadElem);                              
         
      else
         error('Unknown type selected for tune FF');
      end
      
      AmpsQF = QFsp+addQFsp;
      AmpsQD = QDsp+addQDsp;
      
      % Set quadrupoles
      setsp('QF', AmpsQF,[], 0);
      setsp('QD', AmpsQD,[], 0);
      
      
   else
      
      % Change in tune and [QF;QD] from maximum gap
      actualgap = getid(Sector);
      if actualgap < (IDFF.GAPmin-1)
         actualgap = IDFF.GAPmax;
      end  
      DeltaNuY = gap2tune(Sector, actualgap);
      
      if (Sector==7) | (Sector==10) | (Sector==11)
         DeltaAmps = inv(TUNEresp/12) * [0; -DeltaNuY];    %  DelAmps =  [QF; QD];
         DeltaAmpsQF=[DeltaAmps(1,1);DeltaAmps(1,1)];
         DeltaAmpsQD=[DeltaAmps(2,1);DeltaAmps(2,1)];
      elseif (Sector==5) | (Sector==9)
         DeltaAmpsQF=DeltaNuY/0.0181*0.37*[-1.0637;-0.5132];
         DeltaAmpsQD=DeltaNuY/0.0181*0.37*[-6.6328;-3.3434];
      elseif (Sector==4) | (Sector==8) | (Sector==12)
         DeltaAmpsQF=DeltaNuY/0.0181*0.37*[-0.5132;-1.0637];
         DeltaAmpsQD=DeltaNuY/0.0181*0.37*[-3.3434;-6.6328];
      else
         DeltaAmpsQF=[0;0];
         DeltaAmpsQD=[0;0];
      end
      
      % Find which quads to change
      QuadList = [Sector-1 1;Sector 2];
      QuadElem = dev2elem('QF',QuadList);
      AmpsQF = QFsp(QuadElem) + DeltaAmpsQF; 
      AmpsQD = QDsp(QuadElem) + DeltaAmpsQD; 
      
      % Set quadrupoles
      setsp('QF', AmpsQF, QuadList, 0);
      setsp('QD', AmpsQD, QuadList, 0);
      
   end
   
   
   pause(1);


   % Correct orbit
   [STDfinal, IterOut(i,1)] = setbpm(IDFF.HCMFamily, IDFF.Xmax.Data, IDFF.HCMList, IDFF.BPMxList, ...
                                     IDFF.VCMFamily, IDFF.Ymax.Data, IDFF.VCMList, IDFF.BPMyList, BPMIter, BPMTol);

   % Record the gap AM
   IDFF.GapMonitor(i,1) = getid(Sector);
   

   % Record data
   hcm(i,:) = (getsp(IDFF.HCMFamily, IDFF.HCMList)-HCM0)';
   vcm(i,:) = (getsp(IDFF.VCMFamily, IDFF.VCMList)-VCM0)';
   X(:,i) = getam(IDFF.BPMxFamily, IDFF.BPMxList);
   Y(:,i) = getam(IDFF.BPMyFamily, IDFF.BPMyList);


   % Statistics
   Xrms(i) = std(IDFF.Xmax.Data - X(:,i));
   Yrms(i) = std(IDFF.Ymax.Data - Y(:,i));

   
   % plot results
   figure(h1);
   plot(BPMxs,(X(:,i)-IDFF.Xmax.Data)*1000,'r', BPMys,(Y(:,i)-IDFF.Ymax.Data)*1000,'g');
   title(['BPM Orbit Error at a ', num2str(IDFF.GapMonitor(i,1)),' mm Gap']);
   ylabel('X (red), Y (grn) Error [microns]');  
   xlabel('BPM Position [meters]');
   pause(0);
end


% Minimum gap orbits
IDFF.Xmin = getam(IDFF.BPMxFamily, IDFF.BPMxList, 'Struct');
IDFF.Ymin = getam(IDFF.BPMyFamily, IDFF.BPMyList, 'Struct');


% Make the FF-tables
Xtable = [IDFF.GapMonitor hcm(:,1)-hcm(1,1) hcm(:,2)-hcm(1,2)];
Ytable = [IDFF.GapMonitor vcm(:,1)-vcm(1,1) vcm(:,2)-vcm(1,2)];
tableQ = [];


% Go to max gap
disp('   The insertion device gap, quads, and correctors are being reset.'); 
setid(Sector, IDFF.GAPmax, IDFF.GapVelocity);

% Reset to maximum gap values
setsp(IDFF.HCMFamily, HCM0, IDFF.HCMList, 0);
setsp(IDFF.VCMFamily, VCM0, IDFF.VCMList, 0);
setpv(ConfigSetpoint.QF.Setpoint, 0);
setpv(ConfigSetpoint.QD.Setpoint, 0);  

% Then wait on setpoints
setsp(IDFF.HCMFamily, HCM0, IDFF.HCMList, -1);
setsp(IDFF.VCMFamily, VCM0, IDFF.VCMList, -1);
setpv(ConfigSetpoint.QF.Setpoint, -1);
setpv(ConfigSetpoint.QD.Setpoint, -1);  


% Ending orbits
IDFF.XmaxEnd = getam(IDFF.BPMxFamily, IDFF.BPMxList, 'Struct');
IDFF.YmaxEnd = getam(IDFF.BPMyFamily, IDFF.BPMyList, 'Struct');


% Structure output
IDFF.Sector = Sector;
IDFF.Gaps = Gaps;
IDFF.Xtable = Xtable;
IDFF.Ytable = Ytable;
IDFF.tableQ = tableQ;
IDFF.BPMFlag = BPMFlag;
IDFF.Xrms = Xrms;
IDFF.Yrms = Yrms;
IDFF.IterOut = IterOut;
IDFF.TimeStamp = clock;
IDFF.GeV = getenergy;
IDFF.DataDescriptor = 'ID Feed Forward Table';
IDFF.CreatedBy = 'measidfftable';


        
% Change to DataRoot/ID/FeedForward directory
DirStart = pwd;
DataRoot = getfamilydata('Directory','DataRoot');
DirectoryName = [DataRoot, 'ID', filesep, 'FeedForward', filesep];
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
FileName = sprintf('id%02de%2.0f', Sector, 10*getenergy);
FileName = appendtimestamp(FileName);
save(FileName, 'IDFF');
fprintf('   Insertion device feed forward table saved to %s.mat\n', [DirectoryName FileName]);
if ErrorFlag
    fprintf('   Warning: %s was not the desired directory\n', DirectoryName);
end
FileName = [DirectoryName FileName];
cd(DirStart);


% Close figures
close(h1); 
FigureHandles = plotidfftable(FileName);

fprintf('   Measurement complete.  The gap position and correctors have been set back to their original setpoints.');
fprintf('   A new table has been generated and saved to directory %s\n', FileName);
fprintf('            Figure %d  ->  Corrector strength verses gap position.', FigureHandles(1));
fprintf('            Figure %d  ->  RMS orbit distortion verses gap position.', FigureHandles(2));
fprintf('                                                   ->  Orbit drift during table generation verses BPM position.');
fprintf('            Figure %d  ->  Rate of Change of the Corrector Magnets.', FigureHandles(3));
fprintf('   Insertion device feedforward table generation complete.\n');


% ALS resets

CPTableFlag = questdlg(sprintf('Copy %.1f GeV Table to the IOC?',IDFF.GeV),'Feed Forward Table Complete','Yes','No','No');
if strcmp(CPTableFlag,'No')
   fprintf('  Use ffcopy(%d,%.1f) to copy the table over to the feed forward program.\n', Sector, IDFF.GeV);
   fprintf('  Use ffread(%d) (or the "Undulator Server" application) to force the IOC to read the new table.\n', Sector);
else
   ffcopy(textfn1);
   fprintf('  For the IOC to read the new table use the "Undulator Server"\n');
   fprintf('  application or run ffread(%d) from Matlab.\n', Sector);
end

% Switch correctors to slow mode
setpv(IDFF.HCMFamily, 'RampRate', HCMRampRate0, IDFF.HCMList, 0);
setpv(IDFF.VCMFamily, 'RampRate', VCMRampRate0, IDFF.VCMList, 0);
