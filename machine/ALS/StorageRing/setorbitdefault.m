function [OCS, RF, OCS0, RF0] = setorbitdefault(varargin)
% [OCS, RF, OCS0, RF0] = setorbitdefault(EVectors {1e-2}, Iters {1}, RemoveBPMDeviceList, RemoveHCMDeviceList, RemoveVCMDeviceList)
%
% Keywords:  'Golden' or 'Offset'
%            'Display' or 'NoDisplay'
%            'x', 'Horizontal', 'y', 'Vertical'  {Default: both planes}
%            'zerocm' (only when correcting 1 plane)
%            or any keyword used by setorbit (eg. 'FitRF')


% Defaults
DisplayFlag = 'Display';
ItersDefault = 3;
EVectorsDefault = 1e-2;

RemoveBPMDeviceList = [];  %[3 12; 5 4; 8 7; 9 7; 11 4;];  % used to remove [4 4; 7 9; 9 2;]
RemoveHCMDeviceList = [];
RemoveVCMDeviceList = []; 

%RemoveBPMDeviceList = [3 11; 3 12; 5 11; 5 12; 8 7; 9 7;10 11; 10 12; 2 4; 5 4; 11 4];
%RemoveHCMDeviceList = [3 10; 5 10; 10 10];
%RemoveVCMDeviceList = [3 10; 5 10; 10 10]; 

%RemoveHCMDeviceList = [10 8;11 1]  % to remove chicane for RF tests


% Defaults ([]-ask with a dialog menu)
GoalOrbit = '';
PlaneFlag = [];
BPMFlag = [];
CMFlag = [];
ZeroCorrectorsFlag = [];  % 0-Don't zero first, 1-start from zero

OCSFlags = {};
SetRFString = 'RF frequency NOT included in the correction';

%OCSFlags = {'FitRFHCM0'};
%SetRFString = 'Set the RF frequency (HCM energy constraint)';


% Input parsing
EVectors = [];
Iters = [];
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Just remove
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Golden')
        GoalOrbit = 'Golden';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Offset')
        GoalOrbit = 'Offset';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'x','h','Horizontal', 'HCM'}))
        PlaneFlag = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'y','v','Vertical','VCM'}))
        PlaneFlag = 2;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'zerocm','zero correctors'}))
        ZeroCorrectorsFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 'Display';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay') | strcmpi(varargin{i},'No Display')
        DisplayFlag = 'NoDisplay';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'ModelResp')
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];

    elseif any(strcmpi(varargin{i},{'FitRF','SetRF','RFCorrector'}))
        SetRFString = 'Set the RF frequency (Eta Column)';
        %FitRFFlag = 1;
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFHCM0','FitRFEnergy','SetRFHCM0','SetRFEnergy'}))
        SetRFString = 'Set the RF frequency (HCM energy constraint)';
        %FitRFFlag = 2;
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDeltaHCM0','SetRFDeltaHCM0'}))
        SetRFString = 'Set the RF frequency (Delta HCM energy constraint)';
        %FitRFFlag = 3;
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDispersionOrbit','SetRFDispersionOrbit'}))
        SetRFString = 'Set the RF frequency (Dispersion orbit constraint)';
        %FitRFFlag = 4;
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDispersionHCM','SetRFDispersionHCM'}))
        SetRFString = 'Set the RF frequency (Dispersion correction constraint)';
        %FitRFFlag = 5;
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];

    elseif strcmpi(varargin{i},'ModelDisp')
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MeasDisp')
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'GoldenDisp')
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];

    elseif strcmpi(varargin{i},'physics')
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        OCSFlags = [OCSFlags varargin(i)];
        varargin(i) = [];
    end
end


if length(varargin) >= 1
    if isnumeric(varargin{1})
        EVectors = varargin{1};
        varargin(i) = [];
    end
end
if isempty(EVectors)
    if PlaneFlag == 0
        EVectors = EVectorsDefault;
    elseif PlaneFlag == 1
        EVectors = EVectorsDefault;
    elseif PlaneFlag == 2
        EVectors = EVectorsDefault;
    end
end

if length(varargin) >= 1
    if isnumeric(varargin{1})
        Iters = varargin{1};
        varargin(i) = [];
    end
end
if isempty(Iters)
    Iters = ItersDefault;
end

if length(varargin) >= 1
    if isnumeric(varargin{1})
        RemoveBPMDeviceList = varargin{1};
        varargin(i) = [];
    end
end


% Customize or not?
if isempty(GoalOrbit)
    GoalString = 'golden';
else
    GoalString = GoalOrbit;
end
if isempty(PlaneFlag)
    PlaneString = 'Both horizontal and vertical planes';
elseif PlaneFlag == 1
    PlaneString = 'Horizontal plane only';
elseif PlaneFlag == 2
    PlaneString = 'Vertical plane only';
end
if isempty(ZeroCorrectorsFlag) | ZeroCorrectorsFlag == 0
    ZeroCorrectorsString = 'Start from present corrector set';
else
    ZeroCorrectorsString = 'Zero the correctors before correcting the orbit';
end


if strcmpi(DisplayFlag, 'Display')
    FastCorrection = questdlg( ...
        strvcat('Choose this correction method or customize it:', ...
        strvcat(sprintf('1. %s', PlaneString), ...
        strvcat(sprintf('2. Correction to the %s orbit', GoalString), ...
        strvcat('3. 96 BPMs (less bad BPMs)', ...
        strvcat('4. Corrector magnets [1 2 3 4 5 6 7 8]', ...
        strvcat(sprintf('5. %d iterations', Iters), ...
        strvcat(sprintf('6. %s', ZeroCorrectorsString), sprintf('7. %s', SetRFString) ))))))), ...
        'SETORBIT', ...
        'Correct Orbit', ...
        'Customize Orbit Correction', ...
        'Cancel', ...
        'Cancel');

    switch FastCorrection
        case 'Correct Orbit'
            BPMFlag = 2;
            CMFlag = 2;
            if isempty(PlaneFlag)
                PlaneFlag = 0;
            end
            if isempty(ZeroCorrectorsFlag)
                ZeroCorrectorsFlag = 0;  % 0-Don't zero first, 1-start from zero
            end
            if isempty(GoalOrbit)
                GoalOrbit = 'Golden';
            end
        case 'Customize Orbit Correction'
        otherwise
            OCS=[]; RF=[]; OCS0=[]; RF0=[];
            fprintf('   Orbit correction canceled.\n');
            return;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the BPM DeviceList %
%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(BPMFlag)
    BPMFlag = menu('Which BPM set?',...
        sprintf('All BPMs  (%d total)', size(getbpmlist('All'),1)), ...
        sprintf('[1  3  4  5  6  7  8  10] with [1 2],[2 9],[3 2],[12 9] (%d total)', size(getbpmlist('1 3 4 5 6 7 8 10'),1)+4), ...
        sprintf('[2  3  4  5  6  7  8  9]  (%d total)', size(getbpmlist('2 3 4 5 6 7 8 9'),1)), ...
        sprintf('All Bergoz BPMs  (%d total)', size(getbpmlist('Bergoz'),1)), ...
        sprintf('[1  2  3  4  5  6  7  8  9 10]  (%d total)', size(getbpmlist('1 2 3 4 5 6 7 8 9 10'),1)), ...
        sprintf('[2  3  4  5  6  7  8  9] QF QD QFA BEND (%d total)', size(getbpmlist('2 3 4 5 6 7 8 9'),1)), ...
        sprintf('[2  3  4y  5BSC  6BSC  7y  8  9]  QF QD QFAy SBEND'), ...
        sprintf('[2  3  8  9] QF and QD correction  (%d total)', size(getbpmlist('2 3 8 9'),1)), ...
        '                   Exit                   ');
    drawnow;
end
if BPMFlag == 1
    BPMxList = getbpmlist('All');
    BPMyList = BPMxList;
elseif BPMFlag == 2
    BPMxList = getbpmlist('1 3 4 5 6 7 8 10');
    BPMxList = [BPMxList; 1 2;2 9;3 2;12 9];

    DeviceListAll = family2dev('BPMx',0);
    IndexDeviceList = findrowindex(BPMxList, DeviceListAll);
    IndexDeviceList = sort(IndexDeviceList);
    BPMxList = DeviceListAll(IndexDeviceList, 1:2);

    BPMyList = BPMxList;
elseif BPMFlag == 3
    BPMxList = getbpmlist('2 3 4 5 6 7 8 9');
    BPMyList = BPMxList;
elseif BPMFlag == 4
    BPMxList = getbpmlist('Bergoz');
    BPMyList = BPMxList;
elseif BPMFlag == 5
    BPMxList = getbpmlist('1 2 3 4 5 6 7 8 9 10');
    BPMyList = BPMxList;
elseif BPMFlag == 6
    BPMxList = getbpmlist('2 3 4 5 6 7 8 9');
    BPMyList = BPMxList;
elseif BPMFlag == 7
    BPMxList = getbpmlist('2 3 5BSC 6BSC 8 9');
    BPMyList = getbpmlist('2 3 4 5BSC 6BSC 7 8 9');
elseif BPMFlag == 8
    BPMxList = getbpmlist('2 3 8 9');
    BPMyList = BPMxList;
else
    fprintf('  Orbit correction canceled.\n');
    return
end


if isempty(GoalOrbit)
    GoalOrbit = questdlg('What is goal orbit?','SETORBIT','Golden','Offset','Golden');
end
if isempty(GoalOrbit)
    fprintf('  Orbit correction canceled.  Unknown goal orbit.\n');
    return
end


if isempty(PlaneFlag)
    PlaneString = questdlg('Which plane?','SETORBIT','Horizontal','Vertical','Both','Both');
    drawnow;
    if strcmpi(PlaneString, 'Horizontal')
        PlaneFlag = 1;
    elseif strcmpi(PlaneString, 'Vertical')
        PlaneFlag = 2;
    else
        PlaneFlag = 0;
    end
end

if PlaneFlag == 0
    %%%%%%%%%%%%%%%
    % Both Planes %
    %%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Get the CM DeviceList %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(CMFlag)
        CMFlag = menu('Which corrector set?',...
            sprintf('All Corrector Magnets  (%d horizontal, %d vertical)', size(getcmlist('Horizontal'),1), size(getcmlist('Vertical'),1)), ...
            sprintf('[1 2 3 4 5 6 7 8]  (%d horizontal, %d vertical)', size(getcmlist('Horizontal', '1 2 3 4 5 6 7 8'),1), size(getcmlist('Vertical', '1 2 4 5 7 8'),1)), ...
            sprintf('[1  2  7  8]  (%d horizontal, %d vertical)', size(getcmlist('Horizontal', '1 2 7 8'),1), size(getcmlist('Vertical', '1 2 7 8'),1)), ...
            sprintf('[3x 4 5 6x]  (%d horizontal, %d vertical)', size(getcmlist('Horizontal', '3 4 5 6'),1), size(getcmlist('Vertical', '4 5'),1)), ...
            '                   Exit                   ');
        drawnow;
    end
    if CMFlag == 1
        HCMList = getcmlist('Horizontal');
        VCMList = getcmlist('Vertical');
        EVectors = [1:72];
    elseif CMFlag == 2
        HCMList = getcmlist('Horizontal', '1 2 3 4 5 6 7 8');
        VCMList = getcmlist('Vertical', '1 2 4 5 7 8');
        EVectors = [1:72];
    elseif CMFlag == 3
        HCMList = getcmlist('Horizontal', '1 2 7 8');
        VCMList = getcmlist('Vertical', '1 2 7 8');
    elseif CMFlag == 4
        HCMList = getcmlist('Horizontal', '3 4 5 6');
        VCMList = getcmlist('Vertical', '4 5');
    else
        disp('  Orbit correction canceled.');
        return
    end

    % Get BPM and CM structures
    CM  = {family2datastruct('HCM', 'Setpoint', HCMList),  family2datastruct('VCM', 'Setpoint', VCMList)};
    BPM = {family2datastruct('BPMx', 'Monitor', BPMxList), family2datastruct('BPMy', 'Monitor', BPMyList)};
      
    % Remove devices
    % HCM
    i = findrowindex(RemoveHCMDeviceList, CM{1}.DeviceList); 
    CM{1}.DeviceList(i,:) = [];
    CM{1}.Data(i,:) = [];
    CM{1}.Status(i,:) = [];

    % VCM
    i = findrowindex(RemoveVCMDeviceList, CM{2}.DeviceList); 
    CM{2}.DeviceList(i,:) = [];
    CM{2}.Data(i,:) = [];
    CM{2}.Status(i,:) = [];

    % BPMx and BPMy
    i = findrowindex(RemoveBPMDeviceList, BPM{1}.DeviceList); 
    BPM{1}.DeviceList(i,:) = [];
    BPM{1}.Data(i,:) = [];
    BPM{1}.Status(i,:) = [];
    
    i = findrowindex(RemoveBPMDeviceList, BPM{2}.DeviceList); 
    BPM{2}.DeviceList(i,:) = [];
    BPM{2}.Data(i,:) = [];
    BPM{2}.Status(i,:) = [];
    
    
elseif PlaneFlag == 1
    %%%%%%%%%%%%%%%%%%%
    % Horizontal Only %
    %%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Get the CM DeviceList %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(CMFlag)
        CMFlag = menu('Which corrector set?',...
            sprintf('All Corrector Magnets  (%d horizontal)', size(getcmlist('Horizontal'),1)), ...
            sprintf('[1 2 3 4 5 6 7 8]  (%d horizontal)', size(getcmlist('Horizontal', '1 2 3 4 5 6 7 8'),1)), ...
            sprintf('[1  2  7  8]  (%d horizontal)', size(getcmlist('Horizontal', '1 2 7 8'),1)), ...
            sprintf('[3 4 5 6]  (%d horizontal)', size(getcmlist('Horizontal', '3 4 5 6'),1)), ...
            sprintf('[3 6]  (%d horizontal)', size(getcmlist('Horizontal', '3 6'),1)), ...
            sprintf('[4 5]  (%d horizontal)', size(getcmlist('Horizontal', '4 5'),1)), ...
            '                   Exit                   ');
        drawnow;
    end
    if CMFlag == 1
        HCMList = getcmlist('Horizontal');
        EVectors = [1:47];
    elseif CMFlag == 2
        HCMList = getcmlist('Horizontal', '1 2 3 4 5 6 7 8');
        EVectors = [1:48];
    elseif CMFlag == 3
        HCMList = getcmlist('Horizontal', '1 2 7 8');
        EVectors = [1:24];
    elseif CMFlag == 4
        HCMList = getcmlist('Horizontal', '3 4 5 6');
        EVectors = [1:24];
    elseif CMFlag == 5
        HCMList = getcmlist('Horizontal', '3 6');
        EVectors = [1:12];
    elseif CMFlag == 6
        HCMList = getcmlist('Horizontal', '4 5');
        EVectors = [1:12];
    else
        disp('  Orbit correction canceled.');
        return
    end
    
    % Get BPM and CM structures
    CM  = family2datastruct('HCM', 'Setpoint', HCMList);
    BPM = family2datastruct('BPMx', 'Monitor', BPMxList);

    % Remove devices
    % HCM
    i = findrowindex(RemoveHCMDeviceList, CM.DeviceList);
    CM.DeviceList(i,:) = [];
    CM.Data(i,:) = [];
    CM.Status(i,:) = [];

    % BPMx
    i = findrowindex(RemoveBPMDeviceList, BPM.DeviceList);
    BPM.DeviceList(i,:) = [];
    BPM.Data(i,:) = [];
    BPM.Status(i,:) = [];
    
elseif PlaneFlag == 2
    %%%%%%%%%%%%%%%%%
    % Vertical Only %
    %%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Get the CM DeviceList %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(CMFlag)
        CMFlag = menu('Which corrector set?',...
            sprintf('All Corrector Magnets  (%d vertical)', size(getcmlist('Vertical'),1)), ...
            sprintf('[1 2 4 5 7 8]  (%d vertical)', size(getcmlist('Vertical', '1 2 4 5 7 8'),1)), ...
            sprintf('[1  2  7  8]  (%d vertical)', size(getcmlist('Vertical', '1 2 7 8'),1)), ...
            sprintf('[4  5]  (%d vertical)', size(getcmlist('Vertical', '4 5'),1)), ...
            '                   Exit                   ');
        drawnow;
    end
    if CMFlag == 1
        VCMList = getcmlist('Vertical');
        EVectors = [1:24];
    elseif CMFlag == 2
        VCMList = getcmlist('Vertical', '1 2 4 5 7 8');
        EVectors = [1:48];
    elseif CMFlag == 3
        VCMList = getcmlist('Vertical', '1 2 7 8');
        EVectors = [1:24];
    elseif CMFlag == 4
        VCMList = getcmlist('Vertical', '4 5');
        EVectors = [1:12];
    else
        disp('  Orbit correction canceled.');
        return
    end

    % Get BPM and CM structures
    CM  = family2datastruct('VCM', 'Setpoint', VCMList);
    BPM = family2datastruct('BPMy', 'Monitor', BPMyList);
        
    % Remove devices
    % VCM
    i = findrowindex(RemoveVCMDeviceList, CM.DeviceList); 
    CM.DeviceList(i,:) = [];
    CM.Data(i,:) = [];
    CM.Status(i,:) = [];
    
    % BPMy
    i = findrowindex(RemoveBPMDeviceList, BPM.DeviceList); 
    BPM.DeviceList(i,:) = [];
    BPM.Data(i,:) = [];
    BPM.Status(i,:) = [];    
    
end


% Turn off question
if isempty(ZeroCorrectorsFlag) & (PlaneFlag == 1 || PlaneFlag == 2)
    ZeroCorrectorsFlag = questdlg('Start from zero corrector strength?','SETORBITDEFAULT','Yes','No','No');
    drawnow;
    switch ZeroCorrectorsFlag
        case 'Yes'
            ZeroCorrectorsFlag = 1;
        case 'No'
            ZeroCorrectorsFlag = 0;
        otherwise
            ZeroCorrectorsFlag = 0;
    end
end

% Turn off corrector and make the first orbit correction
if ZeroCorrectorsFlag == 1 && (PlaneFlag == 1 || PlaneFlag == 2)
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Turning off corrector family %s\n', CM.FamilyName);
    end
    
    if strcmp(CM.FamilyName,'VCM')
        FractionOff = 0.30;
        fprintf('  Vertical correctors set to %.1f%% of nominal\n', 100*FractionOff);
    else
        FractionOff = 0;
    end

    turnoff(CM.FamilyName, CM.DeviceList, FractionOff);
    
    [N, BPMDelay] = getbpmaverages;
    BPMDelay = 1.5*2.2*BPMDelay;
    if ~isempty(BPMDelay)
        sleep(BPMDelay);
    end
    
    if strcmpi(DisplayFlag, 'Display')
        fprintf('   Applying 50%% of the correction before doing a full correction.\n');
    end
    [OCS, RF, OCS0, RF0] = setorbit('Golden', 'NoSetSP', BPM, CM, 1, EVectors, DisplayFlag, OCSFlags{:});
    drawnow;
    DeltaCM = OCS.CM.Data - OCS0.CM.Data;
    stepsp(OCS.CM.FamilyName, .25*DeltaCM, OCS.CM.DeviceList, -1);
    stepsp(OCS.CM.FamilyName, .50*DeltaCM, OCS.CM.DeviceList, -2);
else
    if ZeroCorrectorsFlag == 1
        fprintf('   Correctors can start from zero only for single plane correction.\n');
    end
end



% Corrector orbit
[OCS, RF, OCS0, RF0] = setorbit(GoalOrbit, BPM, CM, Iters, EVectors, DisplayFlag, OCSFlags{:});



% HCM Chicane correction
%setorbit('Golden', 'BPMx', getbpmlist('2 3 4 5 6 7 8 9'), 'HCM', [10 8;11 1], 1, [1 2], 'Display');
%setorbit('Golden', 'BPMx', getbpmlist('2 3 4 5 6 7 8 9'), 'HCM', [6 1], 1, [1 ], 'Display');


