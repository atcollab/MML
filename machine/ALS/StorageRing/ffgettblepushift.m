function ffgettblepushift(Sector, BPMFlag)
% ffgettblepushift(Sector, BPMFlag (0=Bergoz BPMs, else=All BPMs))
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
CorrectTuneFlag = 0;    % Do not set to 1 - tune FF is not implemented correctly in this routine

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
IDFF.ShiftVelocity = 5.0;
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

modechanname = sprintf('SR%02dU___ODS%iM__DC00',Sector(1),Sector(2));

ModeIn = menu(str2mat(sprintf('%.1f GeV Longitudinal Table', getenergy),sprintf('EPU, Sector %d %d            ',Sector(1), Sector(2)),' ','Start table generation?'),'parallel mode','anti-parallel mode','Cancel');
if ModeIn == 1
    EPUmode = 0;
    setpv(modechanname,EPUmode);
    if (Sector(1)==7 && Sector(2)==2) %band-aid for minimum gap getting set to 45mm when mode is switched
        try
            setpv('sr07u2:Vgap_target_min',14.5);
        catch
        end
    end
elseif ModeIn == 2
    EPUmode = 1;
    setpv(modechanname,EPUmode);
    if (Sector(1)==7 && Sector(2)==2) %band-aid for minimum gap getting set to 45mm when mode is switched
        try
            setpv('sr07u2:Vgap_target_min',14.5);
        catch
        end
    end
else
    disp('  ffgettblepushift aborted.  No changes to correctors or insertion device.');
    return
end

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
    if EPUmode == 0 % parallel
        IDFF.GAPmin = 16.0;
    elseif EPUmode == 1 % anti-parallel
        IDFF.GAPmin = 14.8; %actual min gap is 14.5 but that hits limit switches
    end
end

disp(' ');
disp(['                    EPU [',num2str(Sector),'] has been selected.']);
disp(['                    Maximum Gap = ',num2str(IDFF.GAPmax),' mm']);
disp(['                    Mimimum Gap = ',num2str(IDFF.GAPmin),' mm']);


disp(['  Data collection started.  Figures 1 and 2 show the difference orbits between the maximum']);
disp(['  gap and the current gap position after the feed forward correction has been applied.']);
disp(['  Ideally, these plots should be a straight line thru zero, however, due to orbit drift, BPM']);
disp(['  noise, and feed forward imperfections one can expect 10 or 20 microns of combined errors']);
disp(['  to accumulate before minimum gap is reached (hopefully not any more than that).']);
disp(['  ']);

% Create header date/time stamp variables and output file names
tmp = clock;
year   = tmp(1);
month  = tmp(2);
day    = tmp(3);
hour   = tmp(4);
minute = tmp(5);
seconds= tmp(6);
matfn1  = sprintf('epu%02dd%01dm%01de%.0f', Sector(1), Sector(2), EPUmode, 10*getenergy);
matfn2  = sprintf('epu%02dd%01dm%01de%.0f_%4d-%02d-%02d', Sector(1), Sector(2), EPUmode, 10*getenergy, year, month, day);
textfn1 = sprintf('epu%02dd%01dm%01de%.0f.txt',  Sector(1), Sector(2), EPUmode, 10*getenergy);
textfn2 = sprintf('epu%02dd%01dm%01de%.0f_%4d-%02d-%02d.txt',  Sector(1), Sector(2), EPUmode, 10*getenergy, year, month, day);

% Setup figures
Buffer = .01;
HeightBuffer = .05;

figure
h1 = gcf;
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);

% figure
% h2 = gcf;
% set(h2,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


% Corrector magnet and BPM lists
if (Sector(1)==4 || Sector(1)==6 || Sector(1)==7 || Sector(1) ==11) && Sector(2)==1
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
IDFF.Xmax = getx(BPMxList, 'Struct','Physics');
IDFF.Ymax = gety(BPMyList, 'Struct','Physics');
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


if Sector(1)==4 && Sector(2)==2
    GapsLongitudinal = -45:5:45;
    %IDFF.GAPmin = 15.2; %Merlin can't reach minimum gap when at maximum shift
elseif Sector(1)==6 && Sector(2)==2
    GapsLongitudinal = -17.5:2.5:17.5;
elseif Sector(1)==7 && Sector(2)==1
    GapsLongitudinal = -19:1.9:19;
elseif Sector(1)==7 && Sector(2)==2
    GapsLongitudinal = -35:3.5:35;
else
    GapsLongitudinal = -25:2.5:25;
end

if IDFF.GAPmin<17
    if (ceil(IDFF.GAPmin))==IDFF.GAPmin
        Gaps = [IDFF.GAPmax 150 100 70 50 40 35 30 27 24 21 19 17:-1:IDFF.GAPmin];
    else
        Gaps = [IDFF.GAPmax 150 100 70 50 40 35 30 27 24 21 19 17:-1:(ceil(IDFF.GAPmin)) IDFF.GAPmin];
    end
else
    error('Strange gap range for an EPU - do not know how to handle!')
end

if Gaps(length(Gaps)) > IDFF.GAPmin
    Gaps = [Gaps IDFF.GAPmin];
end

TUNEresp = gettuneresp;

fprintf('\n   Generating feedforward table for %s mode\n\n', getfamilydata('OperationalMode'));


for i = 1:length(Gaps)
    
    % Set shift back to zero so gap can go to minimum without hitting limit
    try
        setepu(Sector, 0, 0, 0, IDFF.ShiftVelocity);
    catch
        disp('EPU Horizontal Amp disabled? Try to reenable then hit the space bar...');
        pause;
        setepu(Sector, 0, 0, 0, IDFF.ShiftVelocity);
    end
    % Set gap
    try
        setid(Sector, Gaps(i), IDFF.GapVelocity);
    catch
        disp('EPU Vertical Amp disabled? Try to reenable then hit the space bar...');
        pause;
        setid(Sector, Gaps(i), IDFF.GapVelocity);
    end
    fprintf('   ID %s %s: Gap SP = %.2f mm, AM = %.3f\n', num2str(Sector(1)), num2str(Sector(2)), Gaps(i), getid(Sector));
    
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
            write_alarms_srmags_single;
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
    [STDfinal, IterOut(i,1)] = setbpm_physics('HCM', IDFF.Xmax.Data, HCMList, BPMxList, ...
        'VCM', IDFF.Ymax.Data, VCMList, BPMyList, BPMIter, BPMTol);
    
    % Corrector starting point
    HCM0 = getsp('HCM', HCMList);
    VCM0 = getsp('VCM', VCMList);
    
    % Record the gap AM
    IDFF.GapMonitor(i,1) = getid(Sector);
    IDFF.ShiftMonitor(i,1) = getepu(Sector);
    
    for j = 1:length(GapsLongitudinal)
        
        X(:,i) = getx(BPMxList,'Physics');
        Y(:,i) = gety(BPMyList,'Physics');
        
        try
            setepu(Sector, GapsLongitudinal(j), 0, 0, IDFF.ShiftVelocity);
        catch
            setepu(Sector, GapsLongitudinal(j), 0, 0, IDFF.ShiftVelocity);
        end
        
        scasleep(0.5);
        
        [offs,offsa,offsb] = getepu(Sector);
        
        %        fprintf('  Vertical Gap=%.3f, A = %.3f, B = %.3f, IDXrms=%.3f, IDYrms=%.3f \n', getid(Sector), offsa,offsb,std(IDx0-getidx), std(IDy0-getidy));
        fprintf('  Vertical Gap=%.3f, A = %.3f, B = %.3f \n', getid(Sector), offsa,offsb);
        
        if GapsLongitudinal(j) == 0
            setsp('HCM', HCM0, HCMList, -1);
            setsp('VCM', VCM0, VCMList, -1);
            pause(1);
            
            % Record data
            HCMtable1(i,j) = 0;
            HCMtable2(i,j) = 0;
            VCMtable1(i,j) = 0;
            VCMtable2(i,j) = 0;
        else
            [STDfinal, IterOut(i,1)] = setbpm_physics('HCM', IDFF.Xmax.Data, HCMList, BPMxList, ...
                'VCM', IDFF.Ymax.Data, VCMList, BPMyList, BPMIter, BPMTol);
            
            % Record data
            hcm = (getsp('HCM',HCMList)-HCM0);
            vcm = (getsp('VCM',VCMList)-VCM0);
            X(:,i) = getx(BPMxList,'Physics');
            Y(:,i) = gety(BPMyList,'Physics');
            HCMtable1(i,j) = hcm(1);
            HCMtable2(i,j) = hcm(2);
            VCMtable1(i,j) = vcm(1);
            VCMtable2(i,j) = vcm(2);
        end
        
        Tunes = gettune;
        TuneX(i,j) = Tunes(1);
        TuneY(i,j) = Tunes(2);
        
        % Statistics
        Xrms(i,j) = std(IDFF.Xmax.Data - X(:,i));
        Yrms(i,j) = std(IDFF.Ymax.Data - Y(:,i));
        
        fprintf('  LGap=%.3f, Xrms=%.3f, Yrms=%.3f \n', getepu(Sector), Xrms(i,j), Yrms(i,j));
        
        % plot results
        figure(h1);
        plot(BPMxs,(X(:,i)-IDFF.Xmax.Data)*1000,'r', BPMys,(Y(:,i)-IDFF.Ymax.Data)*1000,'g');
        title(['BPM Orbit Error at a ', num2str(IDFF.GapMonitor(i,1)),' mm Gap']);
        ylabel('X (red), Y (grn) Error [microns]');
        xlabel('BPM Position [meters]');
        %        pause(0);
        drawnow
    end
    
    try
        setepu(Sector, GapsLongitudinal(j), 0, 0, IDFF.ShiftVelocity);
    catch
        setepu(Sector, GapsLongitudinal(j), 0, 0, IDFF.ShiftVelocity);
    end
    setsp('HCM', HCM0, HCMList, -1);
    setsp('VCM', VCM0, VCMList, -1);
    pause(1);
end


% Minimum gap orbits
IDFF.Xmin = getx(BPMxList, 'Struct','Physics');
IDFF.Ymin = gety(BPMyList, 'Struct','Physics');

% Try/catch resetting gap, quads, and correctors so that data is still saved if this step fails
try
    % Go to max gap
    disp('  The insertion device gap, quads, and correctors are being reset.');
    try
        setepu(Sector, 0, 0, 0, IDFF.ShiftVelocity); % set the horizontal back to zero first to ensure no mechanical collisions possible
    catch
        sounderror;sounderror;
        disp('EPU Horizontal Amp disabled? Try to reenable then hit the space bar...');
        pause;
        setepu(Sector, 0, 0, 0, IDFF.ShiftVelocity);
    end
    try
        setid(Sector, IDFF.GAPmax, IDFF.GapVelocity);
    catch
        sounderror;sounderror;
        disp('EPU Vertical Amp disabled? Try to reenable then hit the space bar...');
        pause;
        setid(Sector, IDFF.GAPmax, IDFF.GapVelocity);
    end
    
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
    
    tableQ = [];
catch
    disp('  Trouble restoring gap, quads, and correctors!')
end

% Structure output
IDFF.Sector = Sector;
IDFF.Gaps = Gaps;
IDFF.GapsLongitudinal = GapsLongitudinal;
IDFF.HCMtable1 = HCMtable1;
IDFF.HCMtable2 = HCMtable2;
IDFF.VCMtable1 = VCMtable1;
IDFF.VCMtable2 = VCMtable2;
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
FileName = sprintf('epu%02dd%01dm%01de%.0f', Sector(1), Sector(2), EPUmode, 10*getenergy);
FileName = appendtimestamp(FileName);
save(FileName, 'IDFF');
fprintf('   Insertion device feed forward table saved to %s.mat\n', [DirectoryName FileName]);
if ErrorFlag
    fprintf('   Warning: %s was not the desired directory\n', DirectoryName);
end
FileName = [DirectoryName FileName];


% Save in text format
fid = fopen(textfn1,'wt'); %if we open this file in binary instead ("b" vs. "t") the linefeed issue should be fixed
fprintf(fid,'# EPU(%i,%i) %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f\n', Sector(1), Sector(2), getenergy, month, day, year, hour, minute, seconds);

fprintf(fid,'#\n# Sector %d, HCM4(Vertical Gap, Longitudinal Gap)  \n', Sector(1)-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, HCM1(Vertical Gap, Longitudinal Gap)  \n', Sector(1));
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM4(Vertical Gap, Longitudinal Gap)  \n', Sector(1)-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM1(Vertical Gap, Longitudinal Gap)  \n', Sector(1));
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
fprintf('  Data saved to %s\n', [pwd, '/', textfn1]);


% Save in matlab/srdata/gaptrack/archive with the date in the file name
% Save in Matlab format (binary format)
%cd archive
%eval(['save ', matfn2,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr Sector Gaps GapsLongitudinal HCMtable1 VCMtable1 HCMtable2 VCMtable2 x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal FFDate FFClock FFGeV']);


% Save in text format
fid = fopen(textfn2,'wt'); %if we open this file in binary instead ("b" vs. "t") the linefeed issue should be fixed
fprintf(fid,'# EPU(%i,%i) %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f\n', Sector(1), Sector(2), getenergy, month, day, year, hour, minute, seconds);

fprintf(fid,'#\n# Sector %d, HCM4(Vertical Gap, Longitudinal Gap)  \n', Sector(1)-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, HCM1(Vertical Gap, Longitudinal Gap)  \n', Sector(1));
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', HCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM4(Vertical Gap, Longitudinal Gap)  \n', Sector(1)-1);
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable1(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'#\n# Sector %d, VCM1(Vertical Gap, Longitudinal Gap)  \n', Sector(1));
fprintf(fid,'V\\L Gap');
for j = 1:length(GapsLongitudinal)
    fprintf(fid,'   %7.3f', GapsLongitudinal(j));
end
fprintf(fid,'\n');
for i=1:length(Gaps)
    fprintf(fid,'%7.3f', Gaps(i));
    for j = 1:length(GapsLongitudinal)
        fprintf(fid,'   %7.3f', VCMtable2(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
fprintf('  Data saved to %s\n', [pwd, '/', textfn2]);
cd ..


% Close figures then ffanal
% close(h1);
% close(h2);
% FigureHandles = ffanalepu(Sector, IDFF.GeV, '.', EPUmode);

soundtada;pause(1);soundtada;

disp(['  Measurement complete.  The gap position and correctors have been set back to their original']);
fprintf('  setpoints.  A new table has been generated and archived to %s.mat\n', FileName);
disp(['  If the table has been successfully generated, the RMS error over the full range of gap positions']);
disp(['  will be below 50 microns horizontally and 25 microns vertically (see Fig. 2).']);
%disp(['           Figure ', num2str(FigureHandles(1)),'  ->  Corrector strength verses gap position.']);
%disp(['           Figure ', num2str(FigureHandles(2)),'  ->  RMS orbit distortion verses gap position.']);
%disp(['           Figure ', num2str(FigureHandles(3)),'  ->  Orbit drift during table generation verses BPM position.']);
%disp(['           Figure ', num2str(FigureHandles(4)),'  ->  Rate of Change of the Corrector Magnets.']);1


% Return of original directory
cd(DirStart);


% CPTableFlag = questdlg(sprintf('Copy %.1f GeV Table to the IOC?',IDFF.GeV),'Feed Forward Table Complete','Yes','No','No');
% if strcmp(CPTableFlag,'No')
%    fprintf('  Use ffcopy(%d,%.1f) to copy the table over to the feed forward program.\n', Sector, IDFF.GeV);
%    fprintf('  Use ffread(%d) (or the "Undulator Server" application) to force the IOC to read the new table.\n', Sector);
% else
%    ffcopy(textfn1);
%    fprintf('  For the IOC to read the new table use the "Undulator Server"\n');
%    fprintf('  application or run ffread(%d) from Matlab.\n', Sector);
% end


disp(['  EPU feedforward table generation for EPU[',num2str(Sector),'] is complete.']);

