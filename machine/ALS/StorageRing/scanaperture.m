function scanaperture(BPMList, MaxChangeX, NStepsX, MaxChangeY, NStepsY, FileName)
%SCANAPERTURE - Aperture scan program
%
%  scanaperture(BPMList, MaxChangeX, NStepsX, MaxChangeY, NStepsY, FileName)
%
%  INPUTS
%  1. BPMList    - BPM list for the bump
%  2. MaxChangeX - Maximum horizontal change from the offset orbit (must be the same number of rows as BPMList)
%  3. NStepsX    - Vector of horizontal scaling steps of MaxChangeX {Default: 0} 
%  4. MaxChangeY - Maximum vertical change from the offset orbit (must be the same number of rows as BPMList) {Default: [4;4] mm} 
%  3. NStepsY    - Vector of vertical scaling steps of MaxChangeY {Default: 0:.1:1} 
%  6. FileName   - Output file name
%
%  OUTPUT
%  Output goes to a .mat file 
%  If no input filename is given, a name will be derived from the BPM devicelist, date, and time
%
%  NOTES
%  1. This function looks for a bump coefficient file corresponding to BPM list in the working directory.  
%     For instance, VerticalBumpCoef-7_8-6_1 is the vertical file for [7 8;6 1].
%     If you don't want to use this file, delete it and a new one will be created.
%  2. If MaxChangeX = 0, then vertical scan only
%     If MaxChangeY = 0, then horizontal scan only
%
%  Written by Greg Portmann


% Initialize
MinLifeTime = -inf; %.5;
MinCurrent = .05;  %5;
%LifeTimeFlag = 'Fast';
LifeTimePeriod = 4*60;



%%%%%%%%%%%%%%%%%%
% Input checking %
%%%%%%%%%%%%%%%%%%

if nargin < 1
    %cd R:\Controls\matlab\spear3data\User\aperturescan\2004-04-21

    %setmachineconfig('Golden');
    
    MaxChangeX = [0;0];
    NStepsX = 0;
    MaxChangeY = [3;3];
    %NStepsY = [0 .2 .4 .5 .6 .7 .75 .8 .85 .9 .95 1];
    NStepsY = [0 .2 .4 .6 .8  1];
    %NStepsY = [0 .1 .2 .25 .3 .35 .4 .45 .5 .55 .6 .65 .7 .75 .8 .85 .9 .95 1];

    FileName = [];
    
    Sector = menu('Choose a sector?','Injection', 'BL 5','BL 6','BL 9','14 Straight','Exit');
    Direction = menu('Choose a Direction?','Positive', 'Negative','Exit');
    if Direction == 3
        return
    end

    SkewFlag = 2;  % 1-Yesm 2-No
    
    if Sector == 1
        % Injection
        BPMList = [3 6; 4 1];
        if Direction == 1
            MaxChangeY = [4.5; 4.5];     
        else
            MaxChangeY = [-4.5; -4.5];
        end
    elseif Sector == 2
        % BL 5
        BPMList = [12 6; 13 1];
        if Direction == 1
            MaxChangeY = [4.5; 4.5];     
        else
            MaxChangeY = [-4.5; -4.5];
        end
    elseif Sector == 3
        % BL 6
        BPMList = [5 10; 6 1];
        if Direction == 1
            MaxChangeY = [3; 3];     
        else
            MaxChangeY = [-3; -3];
        end
    elseif Sector == 4
        % BL 9
        BPMList = [7 6; 8 1];
        if Direction == 1
            MaxChangeY = [4.5; 4.5];     
        else
            MaxChangeY = [-4.5; -4.5];
        end
        %SkewFlag = menu('SkeqQuad Correction?','Yes', 'No','Exit');
        %if SkewFlag == 3
        %    return
        %end
    elseif Sector == 5
        % 14 Straight
        BPMList = [14 6; 15 1];
        if Direction == 1
            MaxChangeY = [6; 6];     % 14S +  (can go to  8 before a PS limit is exceeded)
        else
            MaxChangeY = [-6; -6];   % 14S -  (can go to -9 before a PS limit is exceeded)
        end
    else
        return
    end
    
else
    
    SkewFlag = 2;  % 1-Yesm 2-No

    if nargin < 2
        MaxChangeX = [0;0];
    end
    if nargin < 3
        NStepsX = 0;
    end
    
    if nargin < 4
        MaxChangeY = [5;5];
        %MaxChangeY = [8;8];     % 14S + 
        %MaxChangeY = [-9;-9];   % 14S -
    end
    if nargin < 5
        NStepsY = [0 .2 .4 .5 .6 .7 .75 .8 .85 .9 .95 1];
        %NStepsY = 0:.1:1;
        %NStepsY = 0:-.1:-1;
    end
    
    if nargin < 6
        FileName = [];
    end
end


BPMxIndex = findrowindex(BPMList, getlist('BPMx'));
BPMyIndex = findrowindex(BPMList, getlist('BPMy'));


% Corrector starting points
HCM0 = getsp('HCM'); 
VCM0 = getsp('VCM');


% Offset
Xoffset = getoffset('BPMx', BPMList);
Yoffset = getoffset('BPMy', BPMList);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute corrector coefficients %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BPMWeight = 40;
SVDIndex = 1e-3;

FileNumberString =  sprintf('-%d_%d', BPMList');
DirectoryName = '';  % Work in the present director
%DirectoryName = [fullfile(getfamilydata('Directory','DataRoot'),'aperturescan'),filesep];  % Work off DataRoot


% Get horizontal bump coefficients
if any(NStepsX ~= 0)
    HorizontalBumpFile = sprintf('%sHorizontalBumpCoef%s', DirectoryName, FileNumberString);
    if exist([HorizontalBumpFile,'.mat'], 'file')
        fprintf('   Loading horizontal corrector magnet bump coefficients from %s\n', HorizontalBumpFile);
        load(HorizontalBumpFile);
    else
        fprintf('   Finding horizontal corrector magnet bump coefficients\n');
        
        % BPM gain (work in real coordinates)
        Xgain = getgain('BPMx', BPMList);
        DeltaXBump = MaxChangeX ./ Xgain;
        
        % Scale bump to .3 mm at it's maximum
        BumpMagnitude = .3;
        DeltaXBump = BumpMagnitude * DeltaXBump / max(abs(DeltaXBump));
        
        % Set the hysteresis
        x0 = getam('BPMx', BPMList);
        [HOCS, HOCS0] = setorbitbump('BPMx', BPMList, DeltaXBump/6, 'HCM', [-5 -4 -3 -2 -1 1 2 3 4 5], 1, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        x1 = getam('BPMx', BPMList);
        
        % Get a clean bump
        figure(1);
        clf reset
        x2 = getam('BPMx', BPMList);
        [HOCS, HOCS0] = setorbitbump('BPMx', BPMList, DeltaXBump, 'HCM', [-5 4 -3 -2 -1 1 2 3 4 5], 1, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        x3 = getam('BPMx', BPMList);
        drawnow;
        DeltaHCM = (HOCS.CM.Data - HOCS0.CM.Data) / BumpMagnitude;  % amps/mm  (real units)
        BPMDeviceList = HOCS.BPM.DeviceList;
        HCMDeviceList = HOCS.CM.DeviceList;
        save(HorizontalBumpFile, 'DeltaHCM', 'HCMDeviceList', 'BPMDeviceList', 'HOCS', 'HOCS0');
        
        tmp = questdlg(strvcat('Horizontal local bump coefficients created.','Continue with aperture scan?'),'APERTURE SCAN','Yes','No','No');
        setsp('HCM', HCM0);
        if ~strcmpi(tmp,'Yes')
            return
        end
    end
end



% Get vertical bump coefficients
if any(NStepsY ~= 0)
    VerticalBumpFile = sprintf('%sVerticalBumpCoef%s', DirectoryName, FileNumberString);
    if exist([VerticalBumpFile,'.mat'], 'file')
        fprintf('   Loading vertical corrector magnet bump coefficients from %s\n', VerticalBumpFile);
        load(VerticalBumpFile);
    else
        fprintf('   Finding vertical corrector magnet bump coefficients\n');
        
        % BPM gain (work in real coordinates)
        Ygain = getgain('BPMy', BPMList);
        DeltaYBump = MaxChangeY ./ Ygain;
        
        % Scale bump to .3 mm at it's maximum
        BumpMagnitude = .3;
        DeltaYBump = BumpMagnitude * DeltaYBump / max(abs(DeltaYBump));
                
   
        % Set the hysteresis
        y0 = getam('BPMy', BPMList);
        [VOCS, VOCS0] = setorbitbump('BPMy', BPMList, DeltaYBump/6, 'VCM', [-4 -3 -2 -1 1 2 3 4], 1, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        y1 = getam('BPMy', BPMList);
        
        % Get a clean bump
        %vcm0= getsp('VCM', VOCS.CM.DeviceList);
        %figure(1);
        %clf reset
        y2 = getam('BPMy', BPMList);
        [VOCS, VOCS0] = setorbitbump('BPMy', BPMList, DeltaYBump, 'VCM', [-4 -3 -2 -1 1 2 3 4], 5, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        y3 = getam('BPMy', BPMList);
        %drawnow;
        %vcm1= getsp('VCM', VOCS.CM.DeviceList);
        DeltaVCM = (VOCS.CM.Data - VOCS0.CM.Data) / BumpMagnitude;  % amps/mm  (real units)
        BPMDeviceList = VOCS.BPM.DeviceList;
        VCMDeviceList = VOCS.CM.DeviceList;
        save(VerticalBumpFile, 'DeltaVCM', 'VCMDeviceList', 'BPMDeviceList', 'VOCS', 'VOCS0');
        
        tmp = questdlg(strvcat('Vertical local bump coefficients created.','Continue with aperture scan?'),'APERTURE SCAN','Yes','No','No');
        setsp('VCM', VCM0);
        if ~strcmpi(tmp,'Yes')
            return
        end
    end
end



%%%%%%%%%%%%%%%%%
% Aperture scan %
%%%%%%%%%%%%%%%%%
[Nbpm, Tbpm] = getbpmaverages;


% % Correct the orbit to the offsets
% if getdcct > 10
%     setorbitdefault([],[],[],'NoDisplay');
%     pause(2.2*Tbpm);
%     setorbitdefault([],[],[],'NoDisplay');
% end


% Scan vectors
if MaxChangeX(1) ~= 0 
    DeltaX = MaxChangeX(1) * NStepsX;
else
    DeltaX = MaxChangeX(2) * NStepsX;
end
if MaxChangeY(1) ~= 0 
    DeltaY = MaxChangeY(1) * NStepsY;
else
    DeltaY = MaxChangeY(2) * NStepsY;
end


if any(NStepsX ~= 0)
    hcm0 = getsp('HCM', HCMDeviceList);
    HCM = NaN * ones(size(HCMDeviceList,1), length(DeltaX));
else
    HCM = [];
end
if any(NStepsY ~= 0)
    vcm0 = getsp('VCM', VCMDeviceList);
    VCM = NaN * ones(size(VCMDeviceList,1), length(DeltaY));
    
    % Set hysteresis in an upward direction
    setsp('VCM', vcm0 - 1 * DeltaVCM, VCMDeviceList, -1);
    setsp('VCM', vcm0, VCMDeviceList);
    
else
    VCM = [];
end


% Data filename
if isempty(FileName)
    FileNameArchive = appendtimestamp(['Aperture',FileNumberString]);
    %DirectoryName = fullfile(getfamilydata('Directory','DataRoot'),'aperturescan');
    %DirStart = pwd;
    %[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    FileName = [DirectoryName FileNameArchive];
end

%fprintf('\n   This scan will take about %f minutes\n', LifeTimePeriod * (length(NStepsY)+5) / 60);
fprintf('   Starting aperture scan at %s\n', datestr(clock));

if SkewFlag == 1
    load SkewQuadCorrectionBL9
    SkewSP = getsp('SkewQuad');
    
    % Get BPM and CM structures
    CM  = {getsp('HCM','struct'),getsp('VCM','struct')};
    BPM = {getx('struct'), gety('struct')};
end


CurrentDrop = 0;
i = 0;
for x = DeltaX
    i = i + 1;
    
    % Horizontal bump
    if any(NStepsX ~= 0)
        setsp('HCM', hcm0 + x * DeltaHCM, HCMDeviceList, -2);
        HCM(:,i) = getsp('HCM', HCMDeviceList);
    end
    
    j = 0;
    yminus1 = DeltaY(1);
    for y = DeltaY
        j = j + 1;
        
        
        % Vertical bump
        if any(NStepsY ~= 0)
            % Step in .25 mm steps
            for ystep = yminus1:sign(y-yminus1)*.25:y 
                setsp('VCM', vcm0 + ystep * DeltaVCM, VCMDeviceList, 0);
                pause(.2);
            end
            setsp('VCM', vcm0 + y * DeltaVCM, VCMDeviceList, -2);
            VCM(:,j) = getsp('VCM', VCMDeviceList);
        end
        yminus1 = y;
        
        if SkewFlag == 1
            BPMgoal = {getx, gety};
            setsp('SkewQuad', SkewSP + y * DcurrDmm);
            
            % Corrector orbit
            setorbit(BPMgoal, BPM, CM, 2, 1e-3, 'noDisplay');
        end
        
        % Lifetime measurement
        pause(1);
%         LifeTime(i,j) = measlifetime;
        LifeTime(i,j) = measlifetime(0:0.5:30);

        DCCT(i,j) = getdcct;
        BPMx(i,j,:) = raw2real('BPMx', getx);
        BPMy(i,j,:) = raw2real('BPMy', gety);
        
        IonGauge(:,j) = getam('IonGauge');
        IonPump(:,j)  = getam('IonPump');
        
        Xrms(:,j) = getspiricon('Xrms');
        Yrms(:,j) = getspiricon('Yrms');
        
        
        fprintf('  %2d %2d.  BPMx(%d,%d)=%6.3f mm,  BPMy(%d,%d)=%6.3f mm, DeltaY=%4.1f mm,  Lifetime=%5.3f hours %s\n', i, j, BPMList(1,:), BPMx(i,j,BPMxIndex(1)), BPMList(1,:), BPMy(i,j,BPMyIndex(1)), y, LifeTime(i,j), datestr(clock,0)); 
        
        figure(1)
        clf reset
        plot(squeeze(BPMy(1,:,BPMyIndex(1))), LifeTime(1,:),'.-b');

        drawnow;
        
        %if LifeTime(i,j) < MinLifeTime
        %    break;
        %end
        if getdcct < MinCurrent
            CurrentDrop = 1;
            break;
        end
        save(FileName);
    end
    
    % Bring vertical back to the starting point
    if any(NStepsY ~= 0)
        for k = linspace(1,0,6)
            setsp('VCM', vcm0 + k * y * DeltaVCM, VCMDeviceList, -1);
        end
    end

    if CurrentDrop
        % Bring horizontal back to the starting point for a refill
        if any(NStepsX ~= 0)
            for k = linspace(1,0,4)
                setsp('HCM', hcm0 + k * x * DeltaHCM, HCMDeviceList, -1);
            end
        end
        %tmp = questdlg(strvcat(sprintf('Current dropped below %.2f mAmps.  Refill and Continue or Stop', MinCurrent),'(When refilling, do not change the lattice)'),'scanaperture','Continue','Stop','Stop');
        %if strcmpi(tmp,'Continue')
        %    CurrentDrop = 0;
        %    % Put horizontal back
        %    if any(NStepsX ~= 0)
        %        for k = linspace(0,1,4)
        %            setsp('HCM', hcm0 + k * x * DeltaHCM, HCMDeviceList, -1);
        %        end
        %    end
        %else
        %    fprintf('   Measurement stopped\n');
        %    break;
        %end
        
        DeltaY = DeltaY(1:j);
        save(FileName);
        break;
    end
    
    % Other side??
    
    save(FileName);
end




% % Save data
% if ~isempty(FileName)
%     save(FileName);
%     fprintf('   Aperature scan data saved to %s.mat\n', FileName);
% else
%     FileNameArchive = appendtimestamp(['Aperture',FileNumberString]);
%     %DirectoryName = fullfile(getfamilydata('Directory','DataRoot'),'aperturescan');
%     %DirStart = pwd;
%     %[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
%     save([DirectoryName FileNameArchive]);
%     %cd(DirStart);
%     fprintf('   Aperture scan data saved to %s.mat\n', [DirectoryName FileNameArchive]);
% end

fprintf('   Aperture scan data saved to %s.mat\n', FileName);
fprintf('   Aperture scan finished at %s\n', datestr(clock));


% Reset correctors
setsp('HCM', HCM0);
setsp('VCM', VCM0);


