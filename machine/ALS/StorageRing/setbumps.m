function setbumps(IDDeviceList, CMGroup, BPMxGoal, BPMyGoal, BPMIter, BPMTol, DisplayFlag)
%SETBUMPS - Make a straight section bump
%  setbumps(Sector, CMGroup, X, Y, BPMIter, BPMTol, DisplayFlag)
%
%  INPUTS
%  1. Sector - Sector numbers or device list  {Default: all insertion device sectors}
%              For bumps in straight 1 & 3 (no Bergoz BPMs):
%                  [s 1]    - BPM(s-1, 9) & BPM(s, 2)
%              If using a device list in a straight with a chicane, the options are:
%                  [s 0]    - BPM(s-1, 10), BPM(s-1, 11), BPM(s-1, 12) & BPM(s, 1)  (both IDs at the same time)
%                  [s 1]    - BPM(s-1, 10) & BPM(s-1, 11)   (Upstream ID)
%                  [s 2]    - BPM(s-1, 12) & BPM(s, 1)    (Downstream ID)
%                  [s else] - BPM(s-1, 10) & BPM(s, 1)    (Long bump around both IDs)
%              For bumps in normal straights:
%                  [s 1]    - BPM(s-1, 10) & BPM(s, 1)
%
%  2. CMGroup - Corrector magnet group: 0 - sextupole correctors, else - no sextupole correctors
%  3. X and Y - This function is normally used to place the beam in the BPM "center" as defined
%               by golden orbit.  However, the X and Y inputs can be used to override
%               the golden orbit values.  X and Y are in absolute values.
%  4. BPMIter, BPMTol - (see setbpm) 
%  5. DisplayFlag - 'Display' or 'NoDisplay'
%


% Revision History:
% 2002-07-22 Christoph Steier
% added sector 1 and 3 as allowed sectors
%
% 2004-03-08 Christoph Steier
% Modified code to read FB.BPMlist structure of srcontrol (if it exists), in order
% to recognize BPMs excluded from orbit correction.
%
% 2005-05-14 Greg Portmann
% Changed SectorList to IDDeviceList
% Removed the BPM list coming from SRCTRLButtonOrbitCorrectionSetup->UserData
%
% 2007-02-21 Greg Portmann
% Fixed [s 3] case to remove BPM [s-1 11] & [s-1 12]



if nargin < 7
    DisplayFlag = 'Display';
end

BPMxList = getbpmlist('x', 'Bergoz', '1 2 3 4 5 6 7 8 9 10');
BPMyList = getbpmlist('y', 'Bergoz', '1 2 3 4 5 6 7 8 9 10');

SR_Mode = getfamilydata('OperationalMode');

if nargin < 1
    IDDeviceList = [];
end
if isempty(IDDeviceList)
    %IDDeviceList = [4;5;6;7;8;9;10;11;12];
    IDDeviceList = [4 0;5 1;6 0;7 1;8 1;9 1;10 1;11 0;12 1];
end

% Add a devicelist
if size(IDDeviceList,2) == 1
    % For chicane straights do both bumps at once
    IDDeviceList = [IDDeviceList ones(length(IDDeviceList),1)];
%    i = findrowindex([4 1;6 1;11 1],IDDeviceList); %switch back to this when BPM(3,12) is fixed
    i = findrowindex([6 1;11 1],IDDeviceList);
    IDDeviceList(i,2) = 0;
end


if getdcct < 5     % Don't feedback if the current is too small
    fprintf('   Orbit not corrected due to small SR current ( < 5 mAmps).\n');
    return
end


if nargin < 2
    CMGroup = [];
end
if isempty(CMGroup)
    a = menu('Use Sextupole Correctors?','Yes','No','Exit Program');
    if a == 1
        CMGroup = 0;
    elseif a==2
        CMGroup = 1;
    else
        disp('   Program stopped, no correctors changed.');
        return
    end
end


% Changed 2000-02-01 (C. Steier) since
% original settings (Iter=10, Tol=.001) consumed too much time in two bunch mode ...
% set tolerance back to 1 um for multibunch mode (2000-03-27)
% BPMs are slightly noisier now ... raised tolerance to 1.5 um (C. Steier, 2001-10-3)
if strcmp(SR_Mode, '1.9 GeV, Two Bunch')
    BPMIter = 1;
    BPMTol = .005;
else
    BPMIter = 2;
    BPMTol = .0015;
end


% Added: 2004-03-08 (C. Steier)
%
% So far all BPMs were used, even if they were marked excluded in the orbit correction setup ...
% Added some code here to disable BPMs which are exluded from list.
BPMxList = getbpmlist('BPMx','Bergoz');
BPMyList = getbpmlist('BPMy','Bergoz');
% FB = get(findobj(gcbf,'Tag','SRCTRLButtonOrbitCorrectionSetup'),'Userdata');
% if ~isempty(FB)
%    BPMxList = FB.BPMlist1;
%    BPMyList = FB.BPMlist1;
% end
% excludeindex = find(BPMxList(:,2)==11);
% BPMxList(excludeindex,:)=[];
% excludeindex = find(BPMxList(:,2)==12);
% BPMxList(excludeindex,:)=[];
% excludeindex = find(BPMyList(:,2)==11);
% BPMyList(excludeindex,:)=[];
% excludeindex = find(BPMyList(:,2)==12);
% BPMyList(excludeindex,:)=[];


% Turn feedforward off
setff([],0);


% Main
for i = 1:size(IDDeviceList,1)
    Sector = IDDeviceList(i,1);    
    if Sector == 1
        Sector_1 = 12;
    else
        Sector_1 = Sector -1;
    end


    % BPM list
    if Sector == 1
        % Injection
        BPMxListBump = [12 9; 1 2];
        BPMyListBump = [12 9; 1 2];
        
    elseif Sector == 3
        % RF
        BPMxListBump = [2 9; 3 2];
        BPMyListBump = [2 9; 3 2];
        
    elseif any(Sector == [4 6 11]) & IDDeviceList(i,2) == 0
        % Chicane bumps (2 at once)
        BPMxListBump = [Sector-1 10; Sector-1 11; Sector-1 12; Sector 1];
        BPMyListBump = [Sector-1 10; Sector-1 11; Sector-1 12; Sector 1];

    elseif any(Sector == [4 6 11]) & IDDeviceList(i,2) == 1
        % Chicane bumps
        BPMxListBump = [Sector-1 10; Sector-1 11];
        BPMyListBump = [Sector-1 10; Sector-1 11];

        iRemove = findrowindex([Sector-1 12; Sector 1], BPMxList);
        BPMxList(iRemove,:) = [];
        iRemove = findrowindex([Sector-1 12; Sector 1], BPMyList);
        BPMyList(iRemove,:) = [];

    elseif any(Sector == [4 6 11]) & IDDeviceList(i,2) == 2
        % Chicane bumps
        BPMxListBump = [Sector-1 12; Sector 1];
        BPMyListBump = [Sector-1 12; Sector 1];

        iRemove = findrowindex([Sector-1 11; Sector-1 10], BPMxList);
        BPMxList(iRemove,:) = [];
        iRemove = findrowindex([Sector-1 11; Sector-1 10], BPMyList);
        BPMyList(iRemove,:) = [];
        
    else       
        % Generic ID straight section
        BPMxListBump = [Sector_1 10; Sector 1];
        BPMyListBump = [Sector_1 10; Sector 1];
        
        iRemove = findrowindex([Sector-1 11; Sector-1 12], BPMxList);
        BPMxList(iRemove,:) = [];
        iRemove = findrowindex([Sector-1 11; Sector-1 12], BPMyList);
        BPMyList(iRemove,:) = [];
    end

    
    % Check for bad BPMs
    [iGood, iRemove] = findrowindex(BPMxListBump, BPMxList);
    if ~isempty(iRemove)
        for j = 1:length(iRemove)
            fprintf('   BPMx(%d,%d) is not a good BPM\n', BPMxListBump(iRemove(j,:)));
        end
        error('BPMx problem.');
    end
    

    % CM Bump magnets
    if CMGroup
        % No Sextupole correctors
        if any(Sector == [4 6 11]) & IDDeviceList(i,2) == 0
            % Chicane bumps
            HCMList = [Sector_1 7; Sector_1 8; Sector_1 10; Sector 1; Sector 2];
            VCMList = [Sector_1 7; Sector_1 8; Sector_1 10; Sector 1; Sector 2];
        elseif any(Sector == [4 6 11]) & IDDeviceList(i,2) == 1
            % Chicane bumps
            HCMList = [Sector_1 7; Sector_1 8; Sector_1 10; Sector 1];
            VCMList = [Sector_1 7; Sector_1 8; Sector_1 10; Sector 1];
        elseif any(Sector == [4 6 11]) & IDDeviceList(i,2) == 2
            % Chicane bumps
            HCMList = [Sector_1 8; Sector_1 10; Sector 1; Sector 2];
            VCMList = [Sector_1 8; Sector_1 10; Sector 1; Sector 2];
        else
            HCMList = [Sector_1 7; Sector_1 8; Sector 1; Sector 2];
            VCMList = [Sector_1 7; Sector_1 8; Sector 1; Sector 2];
        end
        %OCS = makebump('BPMx', BPMxListBump, NaN*[1;1], 'HCM', [-2 -1 1 2], 'Incremental');
        %OCS.CM.DeviceList
    else
        % Sextupole correctors
        if any(Sector == [4 6 11]) & IDDeviceList(i,2) == 0
            % Chicane bumps
            HCMList = [Sector_1 6; Sector_1 8; Sector_1 10; Sector 1; Sector 3];
            VCMList = [Sector_1 5; Sector_1 8; Sector_1 10; Sector 1; Sector 4];
        elseif any(Sector == [4 6 11]) & IDDeviceList(i,2) == 1
            % Chicane bumps
            HCMList = [Sector_1 6; Sector_1 8; Sector_1 10; Sector 1; Sector 3];
            VCMList = [Sector_1 5; Sector_1 8; Sector_1 10; Sector 1; Sector 4];
        elseif any(Sector == [4 6 11]) & IDDeviceList(i,2) == 2
            % Chicane bumps
            HCMList = [Sector_1 6; Sector_1 8; Sector_1 10; Sector 1; Sector 3];
            VCMList = [Sector_1 5; Sector_1 8; Sector_1 10; Sector 1; Sector 4];
        else
            HCMList = [Sector_1 6; Sector_1 8; Sector 1; Sector 3];
            VCMList = [Sector_1 5; Sector_1 8; Sector 1; Sector 4];
        end
        %OCS = makebump('BPMx', BPMxListBump, NaN*[1;1], 'HCM', [-3 -1 1 3], 'Incremental');
        %OCS.CM.DeviceList
    end
    

    if nargin < 3
        BPMxGoal = getgolden('BPMx', BPMxListBump);
    end
    if nargin < 4
        BPMyGoal = getgolden('BPMy', BPMyListBump);
    end


    if getdcct < 3
        % Don't feedback if the current is too small
        fprintf('  Orbit not corrected due to small SR current ( < 5 mAmps).\n');
        return
    end

%     % Find the BPMs in the sector where the ID is located.
     ix = findrowindex(BPMxListBump, BPMxList);
%     if length(ix) ~= 2
%         error('BPMx list error');
%     end
     iy = findrowindex(BPMyListBump, BPMyList);
%     if length(iy) ~= 2
%         error('BPMy list error');
%     end

    % BPM least squares
    IDxGoal = getx(BPMxList);
    IDxGoal(ix) = BPMxGoal;

    IDyGoal = gety(BPMyList);
    IDyGoal(iy) = BPMyGoal;

    if getdcct < 5     
        fprintf('   Orbit not corrected due to small SR current ( < 5 mAmps).\n');
        return
    end

    x = getx(BPMxList, 'Struct');
    y = gety(BPMyList, 'Struct');
    HCM = getsp('HCM', HCMList, 'Struct');
    VCM = getsp('VCM', VCMList, 'Struct');

    
    % New MML
    OCS = setorbit({IDxGoal,IDyGoal}, {x,y}, {HCM, VCM}, BPMIter, 'NoDisplay', 'Tolerance', BPMTol);
    for j = 1:length(OCS.BPM)
        OrbitSTD(j) = std(OCS.BPM{j}.Data(:) - OCS.GoalOrbit{j}(:));
    end
    IterOut = OCS.NCorrections;
    
    
    % Old MML
    %[OrbitSTD, IterOut] = setbpm('HCM', IDxGoal, HCMList, BPMxList, 'VCM', IDyGoal, VCMList, BPMyList, BPMIter, BPMTol);


    BPMxFinal = getx(BPMxListBump);
    BPMyFinal = gety(BPMyListBump);
    

    if strcmpi(DisplayFlag, 'Display')
        % analorb(Sector);
        fprintf('\n                 Final Value   Goal       Error\n');
        fprintf('   BPMx(%2d,%2d) :  %6.3f      %6.3f      %6.3f  [mm]  \n', BPMxListBump(1,1), BPMxListBump(1,2), BPMxFinal(1), BPMxGoal(1), BPMxFinal(1)-BPMxGoal(1));
        fprintf('   BPMx(%2d,%2d) :  %6.3f      %6.3f      %6.3f  [mm]  \n', BPMxListBump(2,1), BPMxListBump(2,2), BPMxFinal(2), BPMxGoal(2), BPMxFinal(2)-BPMxGoal(2));
        fprintf('   BPMy(%2d,%2d) :  %6.3f      %6.3f      %6.3f  [mm]  \n', BPMyListBump(1,1), BPMyListBump(1,2), BPMyFinal(1), BPMyGoal(1), BPMyFinal(1)-BPMyGoal(1));
        fprintf('   BPMy(%2d,%2d) :  %6.3f      %6.3f      %6.3f  [mm]  \n', BPMyListBump(2,1), BPMyListBump(2,2), BPMyFinal(2), BPMyGoal(2), BPMyFinal(2)-BPMyGoal(2));
        fprintf('   STDx = %f mm, STDy = %f mm, Iterations = %d (Max=%d), Tolerance = %f mm.\n', OrbitSTD(1), OrbitSTD(2), IterOut, BPMIter, BPMTol);
        fprintf('   Sector %d straight section bump complete\n', Sector);
        pause(0);
    end
    
end






