function ffgettblepugap_newML(Sector, BPMFlag)
% function ffgettblepugap_newML(Sector, BPMFlag)
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
% 2003-04-25 C. Steier
%		IDBPMs in sectors 1 and 3 are not used anymore since they are noisy at low beam current
%		and therefore compromise the FF tables.
%
% 2004-07-23	T.Scarvie
%     modified to perform a tune FF correction after each move and prior to each orbit correction
%     to produce FF tables that are more accurate while running orbit FB


% Initialization

% Need to change this to a question dialog to allow for local tune compensation; hard-coded for now - 2004-07-23, T.Scarvie
FFTypeFlag = 'Global';

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


% Minimum and maximum gap
[IDFF.GAPmin, IDFF.GAPmax] = gaplimit(Sector);

disp(['  The insertion device for sector ',num2str(Sector),' has been selected.']);
disp(['                    Maximum Gap = ',num2str(IDFF.GAPmax),' mm']);
disp(['                    Mimimum Gap = ',num2str(IDFF.GAPmin),' mm']);
disp(['  Data collection started.  Figures 1 and 2 show the difference orbits between the maximum']);
disp(['  gap and the current gap position after the feed forward correction has been applied. ']);
disp(['  Ideally, these plots should be a straight line thru zero, however, due to orbit drift, BPM']);
disp(['  noise, and feed forward imperfections one can expect 10 or 20 microns of combined errors']);
disp(['  to accumulate before minimum gap is reached (hopefully not any more than that).']);
disp([' ']);


% Setup figures
Buffer = .01;
HeightBuffer = .05;

h1=figure;
set(h1,'units','normal','position',[.0+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);

h2=figure(h1+1);
set(h2,'units','normal','position',[.5+Buffer .5+Buffer .5-2*Buffer .5-2*Buffer-HeightBuffer]);


if Sector(2)==1
    HCMList = [Sector(1)-1 8; Sector(1)-1 10];
    VCMList = [Sector(1)-1 8; Sector(1)-1 10];
    HCMFF1PV = getname('HCM','FF1',[Sector(1)-1 8]);
    HCMFF2PV = getname('HCM','FF2',[Sector(1)-1 10]);
    VCMFF1PV = getname('VCM','FF1',[Sector(1)-1 8]);
    VCMFF2PV = getname('VCM','FF2',[Sector(1)-1 10]);
elseif Sector(2)==2
    HCMList = [Sector(1)-1 10; Sector(1) 1];
    VCMList = [Sector(1)-1 10; Sector(1) 1];
    HCMFF1PV = getname('HCM','FF1',[Sector(1)-1 10]);
    HCMFF2PV = getname('HCM','FF2',[Sector(1) 1]);
    VCMFF1PV = getname('VCM','FF1',[Sector(1)-1 10]);
    VCMFF2PV = getname('VCM','FF2',[Sector(1) 1]);
end

if Sector(1)~=6
    SQEPUFFPV = getname('SQEPU','FF',[Sector(1) Sector(2)]);
end

% zero feed forward magnet channels
setpv(HCMFF1PV,0);
setpv(HCMFF2PV,0);
setpv(VCMFF1PV,0);
setpv(VCMFF2PV,0);

% Set gap to maximum, set velocity to maximum, velocity profile off, FF off, horizontal gap to 0
setff([], 0, 0);
if Sector(1)~=6
    setepu(Sector, 0, 0, 0, IDFF.ShiftVelocity, 1, 0);
end
setid(Sector, IDFF.GAPmax, IDFF.GapVelocity, 1, 0);
scasleep(1);

% Load and set QF and QD setpoints from the golden lattice
ConfigSetpoint = getproductionlattice;
setpv(ConfigSetpoint.QF.Setpoint);
setpv(ConfigSetpoint.QD.Setpoint);
QFsp = ConfigSetpoint.QF.Setpoint.Data;
QDsp = ConfigSetpoint.QD.Setpoint.Data;


%%%%%%%%% need to do this for other EPUs! %%%%%%%%%%%
% load sector 11 EPU skew quadrupole table
DirStart = pwd;
DataRoot = getfamilydata('Directory','DataRoot');
DirectoryName = [DataRoot, 'ID', filesep, 'feedforward', filesep];
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
load('skew_table_epu11')
cd(DirStart);


% Setbumps
setbumps(Sector, 1);  % No sextupole correctors
scasleep(1);

% Starting orbit and corrector magnet setpoints
IDFF.Xmax = getx(BPMxList, 'Struct');
IDFF.Ymax = gety(BPMyList, 'Struct');
BPMxs = getspos(IDFF.Xmax);
BPMys = getspos(IDFF.Ymax);

HCMFF10 = getsp(HCMFF1PV);
HCMFF20 = getsp(HCMFF2PV);
HCM0 = [HCMFF10; HCMFF20];
VCMFF10 = getsp(VCMFF1PV);
VCMFF20 = getsp(VCMFF2PV);
VCM0 = [VCMFF10; VCMFF20];
if Sector(1)~=6
    SQEPUFF0 = getsp(SQEPUFFPV);
end
QF0 = getsp('QF');
QD0 = getsp('QD');


% Main loop
i=1;
IDFF.GapMonitor(i,1) = getid(Sector);
hcm(i,:) = ([getsp(HCMFF1PV) getsp(HCMFF2PV)]'-HCM0);
vcm(i,:) = ([getsp(VCMFF1PV) getsp(VCMFF2PV)]'-VCM0);

X(:,i) = IDFF.Xmax.Data;
Y(:,i) = IDFF.Ymax.Data;
Xrms(i) = std(IDFF.Xmax.Data - X(:,i));
Yrms(i) = std(IDFF.Ymax.Data - Y(:,i));
IterOut(i) = 1;

if Sector(1)==6
        Gaps = [IDFF.GAPmax-3 30 25 20 18 16 14 12 10 IDFF.GAPmin];
elseif IDFF.GAPmin < 17
%    Gaps = [(IDFF.GAPmax-10):-10:60 56:-4:36 34.5:-1.5:19.5 19:-.5:IDFF.GAPmin];
    Gaps = [(IDFF.GAPmax-10) 50 IDFF.GAPmin];
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
    
    % Change Quads via Tune FF to simulate conditions during production using tune feed forward code from orbit feedback
    % Change in tune and [QF;QD] from maximum gap
    
    if strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, TopOff')
        if i==2
            fprintf('  Generating feedforward table for %s mode\n', getfamilydata('OperationalMode'));
        end
        
        % SR11 epu skew quadrupole feed forward
        % scale= -0.06;	 % for nu_y = 8.20 lattice
        scale = -0.075;
        mid = ceil(length(epu_shift5)/2);
        
        if Sector == [11 1]
            if getsp(SQEPUFFPV)==0
                gap=getid([11 1]);
                shift=getepu([11 1]);
                if gap < (IDFF.GAPmin-1)
                    gap = IDFF.GAPmax;
                end
                corrval=sqrt(shift2tune(11,gap,25)/shift2tune(11,15.67,25))* ...
                    scale*interp1(epu_shift5,int_epu_grad5-int_epu_grad5(mid),shift,'spline');
                setsp(SQEPUFFPV,corrval);
            end
        else
            disp('This EPU does not have skew coil adjustment in code yet!');
        end
        
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
            QuadList = [Sector(1)-1 2;Sector(1) 1];
            QuadElem = dev2elem('QF',QuadList);
            
            DeltaAmps = inv(TUNEresp) * [(fraccorr*6.23e-4)-DeltaNuX;fraccorr*(-0.05301)];    %  DelAmps =  [QF; QD];
            addQFsp = addQFsp+DeltaAmps(1,1);
            addQDsp = addQDsp+DeltaAmps(2,1);
            
            if (Sector(1)==7) | (Sector(1)==10) | (Sector(1)==11)
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
        
        % Set quadrupoles
        setsp('QF', AmpsQF,[], 0);
        setsp('QD', AmpsQD,[], 0);
        
    else
        
        %%%%%%%%% need to do this for other EPUs! %%%%%%%%%%%
        % SR11 epu skew quadrupole feed forward
        scale= -0.06;
        %scale = -0.075;	 % for nu_y = 9.20 lattice
        mid = ceil(length(epu_shift5)/2);
        
        if Sector == [11 1]
            if getsp(SQEPUFFPV)==0
                gap=getid([11 1]);
                shift=getepu([11 1]);
                if gap < (IDFF.GAPmin-1)
                    gap = IDFF.GAPmax;
                end
                corrval=sqrt(shift2tune(11,gap,25)/shift2tune(11,15.67,25))* ...
                    scale*interp1(epu_shift5,int_epu_grad5-int_epu_grad5(mid),shift,'spline');
                setsp(SQEPUFFPV,corrval);
            end
        end
        
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
        
        % Set quadrupoles
        setsp('QF', AmpsQF, QuadList, 0);
        setsp('QD', AmpsQD, QuadList, 0);
        
    end % end tune correction
    
    scasleep(1);
    
    % Correct orbit
    [STDfinal, IterOut(i,1)] = setbpm('HCM', IDFF.Xmax.Data, HCMList, BPMxList, ...
        'VCM', IDFF.Ymax.Data, VCMList, BPMyList, BPMIter, BPMTol);
    
    % Record the gap AM
    IDFF.GapMonitor(i,1) = getid(Sector);
    
    % Record data
    hcm(i,:) = ([getsp(HCMFF1PV) getsp(HCMFF2PV)]'-HCM0);
    vcm(i,:) = ([getsp(VCMFF1PV) getsp(VCMFF2PV)]'-VCM0);
    
    X(:,i) = IDFF.Xmax.Data;
    Y(:,i) = IDFF.Ymax.Data;
    
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
% Tables
tableX = [IDFF.GapMonitor hcm(:,1)-hcm(1,1) hcm(:,2)-hcm(1,2)];
tableY = [IDFF.GapMonitor vcm(:,1)-vcm(1,1) vcm(:,2)-vcm(1,2)];
tableSQEPU = [];

%  Reset gap and correctors
disp('  The insertion device gap, quads, and correctors are being reset.');

setid(Sector, IDFF.GAPmax, IDFF.GapVelocity);

setpv(HCMFF1PV,HCMFF10);
setpv(HCMFF2PV,HCMFF20);
setpv(VCMFF1PV,VCMFF10);
setpv(VCMFF2PV,VCMFF20);
setpv(ConfigSetpoint.QF.Setpoint, 0);
setpv(ConfigSetpoint.QD.Setpoint, 0);

% Then wait on setpoints
setpv(HCMFF1PV,HCMFF10,-1);
setpv(HCMFF2PV,HCMFF20,-1);
setpv(VCMFF1PV,VCMFF10,-1);
setpv(VCMFF2PV,VCMFF20,-1);
setpv(ConfigSetpoint.QF.Setpoint, -1);
setpv(ConfigSetpoint.QD.Setpoint, -1);


% Ending orbits
IDFF.XmaxEnd = getx('Struct');
IDFF.YmaxEnd = gety('Struct');

% Switch correctors to slow mode
setpv('HCM','RampRate', HCMRampRate0, [], 0);
setpv('VCM','RampRate', VCMRampRate0, [], 0);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save in /matlab/srdata/gaptrack
% Save in Matlab format (binary format)
% Create output file names
tmp = clock;
year   = tmp(1);
month  = tmp(2);
day    = tmp(3);
hour   = tmp(4);
minute = tmp(5);
seconds= tmp(6);
matfn1   = sprintf('id%02de%.0f', Sector, 10*IDFF.GeV);
matfn2   = sprintf('id%02de%.0f_%4d-%02d-%02d', Sector, 10*IDFF.GeV, year, month, day);
textfn1 = sprintf('id%02de%.0f.txt', Sector, 10*IDFF.GeV);
textfn2 = sprintf('id%02de%.0f_%4d-%02d-%02d.txt', Sector, 10*IDFF.GeV, year, month, day);

CreatedDateStr = date;
CreatedClock = clock;
CreatedByStr = 'ffgettblepugap';
ReadmeStr = sprintf('%.1f GeV feed forward table saved to %s.mat in directory %s', IDFF.GeV, matfn1, pwd);
idbpmlist = IDBPMlist;
eval(['save ', matfn1,' CreatedGeV CreatedDateStr CreatedClock CreatedByStr ReadmeStr BPMFlag X Y IDX IDY x210a y210a x210b y210b IDx210a IDy210a IDx210b IDy210b xmin ymin IDxmin IDymin idbpmlist tableX tableY tableQ Xrms Yrms IDXrms IDYrms IDXrmsGoal IDYrmsGoal IterOut FFDate FFClock FFGeV']);

% Save in text format
fid = fopen(textfn1,'wt');
fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f IDBPM\n', Sector, IDFF.GeV, month, day, year, hour, minute, seconds);

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
fprintf(fid,'#SR%02d %.1f GeV %02.0f-%02.0f-%.0f %02.0f:%02.0f:%02.0f IDBPM\n', Sector, IDFF.GeV, month, day, year, hour, minute, seconds);

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
FigureHandles = ffanal(Sector, IDFF.GeV, '.');

disp(['  Measurement complete.  The gap position and correctors have been set back to their original']);
disp(['  setpoints.  A new table has been generated and archived to w:\public\matlab\gaptrack.']);
disp(['  If the table has been successfully generated, the RMS error over the full range of gap positions']);
disp(['  will be below 50 microns horizontally and 25 microns vertically (see Fig. 2).']);
disp(['           Figure ', num2str(FigureHandles(1)),'  ->  Corrector strength verses gap position.']);
disp(['           Figure ', num2str(FigureHandles(2)),'  ->  RMS orbit distortion verses gap position.']);
disp(['           Figure ', num2str(FigureHandles(3)),'  ->  Orbit drift during table generation verses BPM position.']);
disp(['           Figure ', num2str(FigureHandles(4)),'  ->  Rate of Change of the Corrector Magnets.']);

CPTableFlag = questdlg(sprintf('Copy %.1f GeV Table to the IOC?',IDFF.GeV),'Feed Forward Table Complete','Yes','No','No');
if strcmp(CPTableFlag,'No')
    fprintf('  Use ffcopy(%d,%.1f) to copy the table over to the feed forward program.\n', Sector, IDFF.GeV);
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
