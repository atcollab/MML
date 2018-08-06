function ffgettbl(Sector, BPMFlag)
% ffgettbl(Sector, BPMFlag (0=Bergoz BPMs, else=All BPMs))
%
% This function generates the feed forward tables necessary for insertion device compensation.
%


% 2002-04-05	T.Scarvie
% 		modified to perform a tune FF correction after each move and prior to each orbit correction
%               to produce FF tables that are more accurate while running orbit FB
%
% 2003-04-25   C. Steier
%		IDBPMs in sectors 1 and 3 are not used anymore since they are noisy at low beam current
%		and therefore compromise the FF tables.
%
% 2004-07-06	T.Scarvie
% 		made tune FF correction active for 5W as well as other gaps because 5W FF table no longer
%		includes quadrupoles - all tune FF is handled by orbit feedback
%
% 2004-10-18 T. Scarvie
%      removed quad generation option from routine - tune compensation is handled by orbit
%      feedback algorithm now
%
% 2005-02-06 G. Portmann
%            Upgrate to new middlelayer format
%     To do: 1. Slow/fast correctors?
%            2. Use FF channels?
%            3. Use center chicane BPMs and correctors?


% Initialization

% Need to change this to a question dialog to allow for local tune compensation; hard-coded for now - 2004-07-06, T.Scarvie
FFTypeFlag = 'Global';

% If measuring effect of device on tunes, set to 0
% If measuring pure dipole FF in real-machine conditions, set to 1
CorrectTuneFlag = 0;    % Do not set to 1, since correction is not implemented correctly in here anymore

if nargin < 2
    BPMFlag = [];
end
if isempty(BPMFlag)
    BPMFlag = 0;  % menu1('Which BPM family to use for table generation?','96 arc sector BPMs only.','Straight section IDBPMs only.','Exit program.');
end


% BPM list
if BPMFlag
    % Use all BPMs
    BPMTol = .005;
    BPMIter = 5;
    BPMxList = getbpmlist('x');
    BPMyList = getbpmlist('y');
else
    % Only use Bergoz BPMs
    BPMTol = .0003;
    BPMIter = 5;
    BPMxList = getbpmlist('x', 'Bergoz', '1 2 3 4 5 6 7 8 9 10 11 12');
    BPMyList = getbpmlist('y', 'Bergoz', '1 2 3 4 5 6 7 8 9 10');
end


% Fast setpoints
HCMRampRate0 = getpv('HCM','RampRate');
VCMRampRate0 = getpv('VCM','RampRate');
setpv('HCM', 'RampRate', 1000, [], 0);
setpv('VCM', 'RampRate', 1000, [], 0);


IDFF.GapVelocity = 3.33;
IDFF.ShiftVelocity = 10.0;
IDFF.GeV = getenergy;


disp([' ']); disp(' ');
disp(['       INSERTION DEVICE FEED FORWARD TABLE GENERATION APPLICATION']);
disp([' ']);
disp(['  This program will generate a feed forward table at ',num2str(IDFF.GeV), ' GeV.']);
disp('  Before continuing, make sure the following conditions are true.  ');
disp('                    1.  Multi-bunch mode. No camshaft bunches necessary');
disp('                    2.  FF disabled.');
disp('                    3.  Gap Control disabled.');
disp('                    4.  Current range: typically 45-40 mA, but any current should be OK.');
disp('                    5.  Production corrector magnet set.');
disp('                    6.  Bumps off (unless measuring tunes) and BTS 3 and 4 set to nominal current.');
disp('                    7.  Set the insertion device Velocity Profiling off (0) (just for speed).');
disp('                    8.  Slow orbit feedback off.');
if BPMFlag
    disp('                    9.  BPMs calibrated.');
end

if nargin < 1
    SectorIn = menu(str2mat(sprintf('%.1f GeV Feed Forward Generation',IDFF.GeV),'Feed forward must be off!',' ','Which insertion device?'),'4-1 vertical','4-1 longitudinal','4-2 vertical','4-2 longitudinal','5','6-1','6-2 vertical','6-2 longitudinal','7-1 vertical','7-1 longitudinal','7-2 vertical','7-2 longitudinal','8','9','10','11-1 vertical','11-1 longitudinal','11-2 vertical','11-2 longitudinal','12','Cancel');
    if SectorIn == 1
        Sector = [4 1];
    elseif SectorIn == 2
        Sector = 4;
        ffgettblepushift([Sector 1]);
        return
    elseif SectorIn == 3
        Sector = [4 2];
    elseif SectorIn == 4
        Sector = 4;
        ffgettblepushift([Sector 2]);
        return
    elseif SectorIn == 5
        Sector = [5 1];
    elseif SectorIn == 6
        Sector = [6 1];
    elseif SectorIn == 7
        Sector = [6 2];
    elseif SectorIn == 8
        Sector = 6;
        ffgettblepushift([Sector 2]);
        return
    elseif SectorIn == 9
        Sector = [7 1];
    elseif SectorIn == 10
        Sector = 7;
        ffgettblepushift([Sector 1]);
        return
    elseif SectorIn == 11
        Sector = [7 2];
    elseif SectorIn == 12
        Sector = 7;
        ffgettblepushift([Sector 2]);
        return
    elseif SectorIn == 13
        Sector = [8 1];
    elseif SectorIn == 14
        Sector = [9 1];
    elseif SectorIn == 15
        Sector = [10 1];
    elseif SectorIn == 16
        Sector = [11 1];
    elseif SectorIn == 17
        Sector = 11;
        ffgettblepushift([Sector 1]);
        return
    elseif SectorIn == 18
        Sector = [11 2];
    elseif SectorIn == 19
        Sector = 11;
        ffgettblepushift([Sector 2]);
        return
    elseif SectorIn == 20
        Sector = [12 1];
    elseif SectorIn == 21
        disp('  ffgettbl aborted.  No changes to correctors or insertion device.');
        return
    end
end
disp(' ');

if Sector == 0
    disp('  ffgettbl aborted.  No changes to correctors or insertion device.');
    return;
end


% Multiple FF-tables
if size(Sector,1) ~= 1
    disp('Not checked for multiple tables yet!');
%     for iSector = 1:size(Sector,1)
%         ffgettbl_newML(Sector(iSector,:), BPMFlag);
%     end
    return;
end


% Minimum and maximum gap
[IDFF.GAPmin, IDFF.GAPmax] = gaplimit(Sector);

% handle two different minimum gaps for EPU11-1 depending on mode (EPBI heating with no mask anymore)
if (Sector(1)==11 && Sector(2)==1)
    if getpv('SR11U___ODS1M__DC00') == 0 % parallel
        IDFF.GAPmin = 16.0;
    elseif getpv('SR11U___ODS1M__DC00') == 1 % anti-parallel
        IDFF.GAPmin = 14.85;
    end
end

disp(['  The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                    Maximum Gap = ',num2str(IDFF.GAPmax),' mm']);
disp(['                    Mimimum Gap = ',num2str(IDFF.GAPmin),' mm']);


disp(['  Data collection started.  Figures 1 and 2 show the difference orbits between the maximum']);
disp(['  gap and the current gap position after the feed forward correction has been applied.']);
disp(['  Ideally, these plots should be a straight line thru zero, however, due to orbit drift, BPM']);
disp(['  noise, and feed forward imperfections one can expect 10 or 20 microns of combined errors']);
disp(['  to accumulate before minimum gap is reached (hopefully not any more than that).']);
disp(['  ']);

% Create header date/time stamp variables
tmp = clock;
year   = tmp(1);
month  = tmp(2);
day    = tmp(3);
hour   = tmp(4);
minute = tmp(5);
seconds= tmp(6);

% Setup figures
Buffer = .01;
HeightBuffer = .05;

h1 = gcf;
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


% Corrector magnet and BPM lists
if (Sector(1)==4 || Sector(1)==6 || Sector(1)==7 || Sector(1)==11) && Sector(2)==1
    HCMList = [Sector(1)-1 8; Sector(1)-1 10];
    VCMList = [Sector(1)-1 8; Sector(1)-1 10];
    %     HCMFF1PV = getname('HCM','FF1',[Sector(1)-1 8]);
    %     HCMFF2PV = getname('HCM','FF2',[Sector(1)-1 10]);
    %     VCMFF1PV = getname('VCM','FF1',[Sector(1)-1 8]);
    %     VCMFF2PV = getname('VCM','FF2',[Sector(1)-1 10]);
elseif (Sector(1)==4 || Sector(1)==6 || Sector(1)==7 || Sector(1)==11) && Sector(2)==2
    HCMList = [Sector(1)-1 10; Sector(1) 1];
    VCMList = [Sector(1)-1 10; Sector(1) 1];
    %     HCMFF1PV = getname('HCM','FF1',[Sector(1)-1 10]);
    %     HCMFF2PV = getname('HCM','FF2',[Sector(1) 1]);
    %     VCMFF1PV = getname('VCM','FF1',[Sector(1)-1 10]);
    %     VCMFF2PV = getname('VCM','FF2',[Sector(1) 1]);
else
    HCMList = [Sector(1)-1 8;
        Sector(1)   1];
    VCMList = [Sector(1)-1 8;
        Sector(1)   1];
end


% Remove the BPMs in the sector where the ID is located
iRemove = findrowindex([Sector(1)-1 10; Sector(1)-1 11; Sector(1)-1 12; Sector(1) 1], BPMxList);
BPMxList(iRemove,:) = [];

iRemove = findrowindex([Sector(1)-1 10; Sector(1)-1 11; Sector(1)-1 12; Sector(1) 1], BPMyList);
BPMyList(iRemove,:) = [];


% % Remove the BPMs in sectors 1 and 3 which are noisy at low current).
% iRemove = findrowindex([12 9; 1 2], BPMlist);
% IDBPMlist(iRemove,:) = [];


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
IDFF.Xmax = getx(BPMxList, 'Struct');
IDFF.Ymax = gety(BPMyList, 'Struct');
BPMxs = getspos(IDFF.Xmax);
BPMys = getspos(IDFF.Ymax);

HCM0 = getsp('HCM', HCMList);
VCM0 = getsp('VCM', VCMList);
QF0 = getsp('QF');
QD0 = getsp('QD');
Tunes = gettune;
TuneX0 = Tunes(1);
TuneY0 = Tunes(2);

% Main loop
i=1;
IDFF.GapMonitor(i,1) = getid(Sector);
hcm(i,:) = (getsp('HCM', HCMList)-HCM0)'; % First entry is zero
vcm(i,:) = (getsp('VCM', VCMList)-VCM0)';

X(:,i) = IDFF.Xmax.Data;
Y(:,i) = IDFF.Ymax.Data;

TuneX(i) = Tunes(1);
TuneY(i) = Tunes(2);

Xrms(i) = std(IDFF.Xmax.Data - X(:,i));
Yrms(i) = std(IDFF.Ymax.Data - Y(:,i));
IterOut(i) = 1;


if Sector(1)==6 && Sector(2)==1
    if IDFF.GAPmin < 9
        Gaps = [IDFF.GAPmax-3 30 25 20 18 16 14 12 10 8 IDFF.GAPmin];
    else
        Gaps = [IDFF.GAPmax-3 30 25 20 18 16 14 12 10 IDFF.GAPmin];
    end
elseif IDFF.GAPmin < 14
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


fprintf('\n   Generating feedforward table for %s mode\n\n', getfamilydata('OperationalMode'));


for i = 2:length(Gaps)+1
    g = Gaps(i-1);
    
    % Set gap
    setid(Sector, g, IDFF.GapVelocity);
    fprintf('   ID %s: Gap SP = %.2f mm, AM = %.3f\n', num2str(Sector), g, getid(Sector));
    
    % Change Quads via Tune FF to simulate conditions during production
    % using tune feed forward code from orbit feedback
    
    % Change in tune and [QF;QD] from maximum gap
    if strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, TopOff')
        
        if strcmp(FFTypeFlag,'Local')
            disp('Using Local tune comp!');
            
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
            QuadList = [Sector(1)-1 1;Sector(1)-1 2;Sector(1) 1;Sector(1) 2];
            QuadElem = dev2elem('QF',QuadList);
            
            if (Sector(1)==7) | (Sector(1)==10) | (Sector(1)==11)
                QFfac=(fraccorr.*([2.227520/2.237111;2.239570/2.237111;2.239570/2.237111;2.227520/2.237111]-1));
                QDfac=(fraccorr.*([2.432264/2.511045;2.543089/2.511045;2.54308/2.511045;2.432264/2.511045]-1));
            elseif (Sector(1)==5) | (Sector(1)==9)
                QFfac=(fraccorr.*([2.208418/2.219784;2.225926/2.219784;2.231777/2.237111;2.233775/2.237111]-1));
                QDfac=(fraccorr.*([2.386512/2.483259;2.545907/2.483259;2.474571/2.511045;2.491079/2.511045]-1));
            elseif (Sector(1)==4) | (Sector(1)==8) | (Sector(1)==12)
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
            QuadList = [Sector(1)-1 2;Sector(1) 1];
            QuadElem = dev2elem('QF',QuadList);
            
            DeltaAmps = inv(TUNEresp) * [(fraccorr*6.23e-4)-DeltaNuX;fraccorr*(-0.05301)];    %  DelAmps =  [QF; QD];
            addQFsp = addQFsp+DeltaAmps(1,1);
            addQDsp = addQDsp+DeltaAmps(2,1);
            
            if (Sector(1)==6) | (Sector(1)==7) | (Sector(1)==10) | (Sector(1)==11)
                QFfac=(fraccorr.*([2.243127/2.237111;2.243127/2.237111]-1));
                QDfac=(fraccorr.*([2.556392/2.511045;2.556392/2.511045]-1));
            elseif (Sector(1)==5) | (Sector(1)==9)
                QFfac=(fraccorr.*([2.225965/2.219784;2.243096/2.237111]-1));
                QDfac=(fraccorr.*([2.528950/2.483259;2.556345/2.511045]-1));
            elseif (Sector(1)==4) | (Sector(1)==8) | (Sector(1)==12)
                QFfac=(fraccorr.*([2.243096/2.237111;2.225965/2.219784]-1));
                QDfac=(fraccorr.*([2.556345/2.511045;2.528950/2.483259]-1));
            else
                QFfac=zeros(2,1);
                QDfac=zeros(2,1);
            end
            
            addQFsp(QuadElem) = addQFsp(QuadElem)+QFfac.*QFsp(QuadElem);
            addQDsp(QuadElem) = addQDsp(QuadElem)+QDfac.*QDsp(QuadElem);
            
        else
            error('Unknown type selected for tune FF');
        end
        
        AmpsQF = QFsp+addQFsp;
        AmpsQD = QDsp+addQDsp;
        
        if CorrectTuneFlag
            % Set quadrupoles
            setsp('QF', AmpsQF,[], -1);
            setsp('QD', AmpsQD,[], -1);
            write_alams_srmags_single;
        end
        
    else
        
        % Change in tune and [QF;QD] from maximum gap
        actualgap = getid(Sector);
        if actualgap < (IDFF.GAPmin-1)
            actualgap = IDFF.GAPmax;
        end
        DeltaNuY = gap2tune(Sector, actualgap);
        
        if (Sector(1)==7) | (Sector(1)==10) | (Sector(1)==11)
            DeltaAmps = inv(TUNEresp/12) * [0; -DeltaNuY];    %  DelAmps =  [QF; QD];
            DeltaAmpsQF=[DeltaAmps(1,1);DeltaAmps(1,1)];
            DeltaAmpsQD=[DeltaAmps(2,1);DeltaAmps(2,1)];
        elseif (Sector(1)==5) | (Sector(1)==9)
            DeltaAmpsQF=DeltaNuY/0.0181*0.37*[-1.0637;-0.5132];
            DeltaAmpsQD=DeltaNuY/0.0181*0.37*[-6.6328;-3.3434];
        elseif (Sector(1)==4) | (Sector(1)==8) | (Sector(1)==12)
            DeltaAmpsQF=DeltaNuY/0.0181*0.37*[-0.5132;-1.0637];
            DeltaAmpsQD=DeltaNuY/0.0181*0.37*[-3.3434;-6.6328];
        else
            DeltaAmpsQF=[0;0];
            DeltaAmpsQD=[0;0];
        end
        
        % Find which quads to change
        QuadList = [Sector(1)-1 1;Sector(1) 2];
        QuadElem = dev2elem('QF',QuadList);
        AmpsQF = QFsp(QuadElem) + DeltaAmpsQF;
        AmpsQD = QDsp(QuadElem) + DeltaAmpsQD;
        
        if CorrectTuneFlag
            % Set quadrupoles
            setsp('QF', AmpsQF, QuadList, -1);
            setsp('QD', AmpsQD, QuadList, -1);
            write_alarms_srmags_single;
        end
        
    end
    
    pause(0.5);
    
    
    % Correct orbit
    [STDfinal, IterOut(i,1)] = setbpm('HCM', IDFF.Xmax.Data, HCMList, BPMxList, ...
        'VCM', IDFF.Ymax.Data, VCMList, BPMyList, BPMIter, BPMTol);
    
    % Record the gap AM
    IDFF.GapMonitor(i,1) = getid(Sector);
    
    
    % Record data
    hcm(i,:) = (getsp('HCM', HCMList)-HCM0)';
    vcm(i,:) = (getsp('VCM', VCMList)-VCM0)';
    X(:,i) = getx(BPMxList);
    Y(:,i) = gety(BPMyList);
    
    Tunes = gettune;
    TuneX(i,:) = Tunes(1);
    TuneY(i,:) = Tunes(2);

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
IDFF.Xmin = getx(BPMxList, 'Struct');
IDFF.Ymin = gety(BPMyList, 'Struct');


% Make the FF-tables
tableX = [IDFF.GapMonitor hcm(:,1)-hcm(1,1) hcm(:,2)-hcm(1,2)];
tableY = [IDFF.GapMonitor vcm(:,1)-vcm(1,1) vcm(:,2)-vcm(1,2)];
tableQ = [];


% Try/catch resetting gap, quads, and correctors so that data is still saved if this step fails
try
    % Go to max gap
    disp('  The insertion device gap, quads, and correctors are being reset.');
    setid(Sector, IDFF.GAPmax, IDFF.GapVelocity);
    
    % Reset to maximum gap values
    setsp('HCM', HCM0, HCMList, 0);
    setsp('VCM', VCM0, VCMList, 0);
    setpv(ConfigSetpoint.QF.Setpoint, 0);
    setpv(ConfigSetpoint.QD.Setpoint, 0);
    
    % Then wait on setpoints
    setsp('HCM', HCM0, HCMList, -1);
    setsp('VCM', VCM0, VCMList, -1);
    setpv(ConfigSetpoint.QF.Setpoint, -1);
    setpv(ConfigSetpoint.QD.Setpoint, -1);
    
    
    % Ending orbits
    IDFF.XmaxEnd = getx('Struct');
    IDFF.YmaxEnd = gety('Struct');
    
    
    % Switch correctors to original ramp rate
    setpv('HCM', 'RampRate', HCMRampRate0, [], 0);
    setpv('VCM', 'RampRate', VCMRampRate0, [], 0);
catch
    disp('  Trouble restoring gap, quads, and correctors!');
end


% Structure output
IDFF.Sector = Sector;
IDFF.Gaps = Gaps;
IDFF.tableX = tableX;
IDFF.tableY = tableY;
IDFF.tableQ = tableQ;
IDFF.TuneX0 = TuneX0;
IDFF.TuneY0 = TuneY0;
IDFF.TuneX = TuneX;
IDFF.TuneY = TuneY;
IDFF.BPMFlag = BPMFlag;
IDFF.Xrms = Xrms;
IDFF.Yrms = Yrms;
IDFF.IterOut = IterOut;
IDFF.TimeStamp = clock;
IDFF.GeV = getenergy;
IDFF.DataDescriptor = 'ID Feed Forward Table';
IDFF.CreatedBy = 'ffgettbl';



% Change to DataRoot directory
DirStart = pwd;
DataRoot = getfamilydata('Directory','DataRoot');
DirectoryName = [DataRoot, 'ID', filesep, 'feedforward', filesep];
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
if (Sector(1)==4 || Sector(1)==6 || Sector(1)==7 || Sector(1)==11)
    FileName = sprintf('id%02dd%ie%.0f', Sector(1), Sector(2), 10*getenergy);
else
    FileName = sprintf('id%02de%2.0f', Sector(1), 10*getenergy);
end
FileName = appendtimestamp(FileName);
save(FileName, 'IDFF');
fprintf('   Insertion device feed forward table saved to %s.mat\n', [DirectoryName FileName]);
if ErrorFlag
    fprintf('   Warning: %s was not the desired directory\n', DirectoryName);
end
FileName = [DirectoryName FileName];



% Save in text format
if (Sector(1)==4 || Sector(1)==6 || Sector(1)==7 || Sector(1)==11)
    FileNameText = sprintf('id%02dd%ie%.0f.txt', Sector(1), Sector(2), 10*getenergy);
else
    FileNameText = sprintf('id%02de%2.0f.txt', Sector(1), 10*getenergy);
end
fid = fopen(FileNameText, 'wt'); %if we open this file in binary instead ("b" vs. "t") the linefeed issue should be fixed
fprintf(fid,'#ID(%i,%i) %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f \n', Sector(1), Sector(2), getenergy, month, day, year, hour, minute, seconds);
fprintf(fid,'#Gap     HCM4   HCM1   VCM4   VCM1\n');
for i=1:size(tableX,1)
    fprintf(fid,'%.4f %.3f %.3f %.3f %.3f\n', tableX(i,1), tableX(i,2), tableX(i,3), tableY(i,2), tableY(i,3));
end
fclose(fid);
fprintf('  Data saved to %s\n', [pwd, filesep, FileNameText]);


% Return of original directory
cd(DirStart);



% Close figures then ffanal
% close(h1);
% FigureHandles = ffanal(Sector, IDFF.GeV);

disp(['  Measurement complete.  The gap position and correctors have been set back to their original']);
fprintf('  setpoints.  A new table has been generated and archived to %s.mat\n', FileName);
disp(['  If the table has been successfully generated, the RMS error over the full range of gap positions']);
disp(['  will be below 50 microns horizontally and 25 microns vertically (see Fig. 2).']);
% disp(['           Figure ', num2str(FigureHandles(1)),'  ->  Corrector strength verses gap position.']);
% disp(['           Figure ', num2str(FigureHandles(2)),'  ->  RMS orbit distortion verses gap position.']);
% disp(['           Figure ', num2str(FigureHandles(3)),'  ->  Orbit drift during table generation verses BPM position.']);
% disp(['           Figure ', num2str(FigureHandles(4)),'  ->  Rate of Change of the Corrector Magnets.']);


% CPTableFlag = questdlg(sprintf('Copy %.1f GeV Table to the IOC?',IDFF.GeV),'Feed Forward Table Complete','Yes','No','No');
% if strcmp(CPTableFlag,'No')
%    fprintf('  Use ffcopy(%d,%.1f) to copy the table over to the feed forward program.\n', Sector, IDFF.GeV);
%    fprintf('  Use ffread(%d) (or the "Undulator Server" application) to force the IOC to read the new table.\n', Sector);
% else
%    ffcopy(textfn1);
%    fprintf('  For the IOC to read the new table use the "Undulator Server"\n');
%    fprintf('  application or run ffread(%d) from Matlab.\n', Sector);
% end

soundtada;pause(1);soundtada;pause(1);soundtada;

disp(['  Insertion device feedforward table generation for sector [',num2str(Sector),'] is complete.']);

