function [OCS, OCS0, V, S, ErrorFlag] = setorbitbump(varargin)
%SETORBITBUMP - Local bump program (uses setorbit)
%  [OCS, OCS0, V, S] = setorbitbump(BPMFamily, BPMDeviceList, GoalOrbit, CMFamily, CMIncrementList, NIter, SVDIndex, BPMWeight)
%  [OCS, OCS0, V, S] = setorbitbump(OCS, GoalOrbit, CMIncrementList, NIter, SVDIndex, BPMWeight)
%
%  INPUTS
%  1. BPMFamily - BPM family
%  2. BPMDeviceList - BPM device list
%  3. GoalOrbit - Goal orbit position (Referenced to an absolute or incremental orbit 
%                                      depending on 'Incremental' or 'Absolute' flag)
%  4. CMFamily - Corrector magnet family
%  5. CMIncrementList - Magnet list upstream and downstream of the BPMs
%                       For instance, [-2 1 3] uses the 2nd correctors upstream and
%                       1st and 3rd corrector downstream from the BPMs in the bump.
%          or
%     CMIncrementList can be an ordinary device list used for specifying correctors.
%  6. NIter - Number of iterations  {Default: 3}
%            (set NIter to 0 if no BPMs are functioning, see setorbit)
%  7. SVDIndex - vector, maximum number, 'All', or
%                base on a threshold of min/max singular value {Default: see setorbit}
%  8. BPMWeight - Weight applied to the BPMs inside the bump (GoalOrbit).  BPM weighting
%                 should only be required when the corrector are in a region of dispersion
%                 and the RF frequency is not used in the orbit correction.
%                {Default BPMWeight is to weight the leakage twice as much as the GoalOrbit}
%  9. Optional flags (any flags used in setorbit can also be used here)
%     'Incremental' {Default} or 'Absolute' - Type of orbit change
%     'Display' - Display bump characteristics  (no display is the default)
%     'SetPV'   or 'SetSP'   - Make the setpoint change {Default}
%     'NoSetPV' or 'NoSetSP' - Don't set the magnets, just return the OCS
%     'FitRF' or 'SetRF' - Flag to include the RF frequency as part of orbit correction.
%     'LeakageCorrection' - Option to try to clean up the leakage after the bump is applied.
%                           Note: 1. NIter for leakage correction is the same for the bump
%                                 2. It's just like setting the weight to zero for a second set of iterations. 
%                                 3. For the horizontal plane, usually one should include the RF frequency
%                                    along with leakage correction.  Otherwise, the goal orbit may not be attained.
%     'Tolerance', Tol - Quit correction if the std(error) < Tol {Tol: 0}
%     'RampSteps', NSteps - Number of steps to ramp in the correction {NSteps: 1}
%                                    This is used to avoid a large transient between setpoint changes.
%
%  OUTPUTS (same as setorbit)
%  1. OCS    - Orbit correction structure (OCS) usable by setorbit
%  2. OCS0   - Starting OCS
%  3. V      - Corrector magnet singular vectors
%  4. Svalue - Singular values (vector)
%
%  NOTES
%  1. setorbitbump creates an OCS structure and uses setorbit to actually change the orbit.
%
%  EXAMPLES
%  1. 4 magnet horizontal incremental bump at BPM(6,6) and BPM(7,1) including the RF frequency
%     OCS = setorbitbump('BPMx',[6 6;7 1],[1;-1],'HCM',[-2 -1 1 2],'FitRF', 'Display');
%     On 12-16-2003, [-2 -1 1 2] corresponded to HCM(6,3), HCM(6,4), HCM(7,1), HCM(7,3)
%     Display plots information before applying the bump.
%
%  2. If the response matrix is not perfect, a clean (minimal rms orbit error) bump can be created
%     by increasing the iteration (note: in regions of dispersion, all bumps will have leakage unless
%     the RF frequency is included).  
%     [OCS, OCS0] = setorbitbump('BPMx',[6 6;7 1],[1;-1],'HCM',[-2 -1 1 2], 4, 'Display');
%     DeltaHCM = OCS.CM.Data - OCS0.CM.Data;
%     BPMxDeviceList = OCS.BPM.DeviceList;
%     HCMDeviceList  = OCS.CM.DeviceList;
%
%  See also setorbit, orbitcorrectionmethods, setorbitgui, rmdisp, plotcm

%  Written by Greg Portmann


%%%%%%%%%%%%
% Defaults %
%%%%%%%%%%%%
OCS.BPM.FamilyName = [];
OCS.BPM.DeviceList = [];
GoalOrbit = [];
OCS.CM.FamilyName = [];
OCS.CM.DeviceList = [];
CMIncrementList = [];
OCS.NIter = 3;
BPMWeight = [];
OCS.Incremental = 1;
DisplayFlag = 0;
SetSPFlag = 1;
NoLeakageFlag = 0;
UnitsFlag = '';
ModeFlag = '';

L = getfamilydata('Circumference');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Flags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Golden')
        % Use the golden orbit
        %GoalOrbit = 'Golden';
        %varargin(i) = [];
    elseif strcmpi(varargin{i},'Offset')
        % Use the offset orbit
        %GoalOrbit = 'Offset';
        %varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        Flags = [Flags varargin(i)];
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        Flags = [Flags varargin(i)];
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Inc') || strcmpi(varargin{i},'Incremental')
        OCS.Incremental = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Abs') || strcmpi(varargin{i},'Absolute')
        OCS.Incremental = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = 'SIMULATOR';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = 'Online';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        ModeFlag = 'Manual';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'SetPV','SetSP'}))
        SetSPFlag = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'NoSetPV','NoSetSP'}))
        SetSPFlag = 0;
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'LeakageCorrection')        
        NoLeakageFlag = 1;
        varargin(i) = [];
        
    elseif strcmpi(varargin{i},'archive') || strcmpi(varargin{i},'noarchive')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'struct') || strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];

    elseif strcmpi(varargin{i},'CorrectorGain')
        Flags = [Flags varargin(i) varargin(i+1)];
        varargin(i+1) = [];
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'Tolerance')
        Flags = [Flags varargin(i) varargin(i+1)];
        varargin(i+1) = [];
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'RampSteps')
        Flags = [Flags varargin(i) varargin(i+1)];
        varargin(i+1) = [];
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'ModelResp')
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'ModelDisp')
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MeasDisp')
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'GoldenDisp')
        Flags = [Flags varargin(i)];
        varargin(i) = [];
        
    elseif any(strcmpi(varargin{i},{'FitRF','SetRF','RFCorrector'}))
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFHCM0','FitRFEnergy','SetRFHCM0','SetRFEnergy'}))
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDeltaHCM0','SetRFDeltaHCM0'}))
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDispersionOrbit','SetRFDispersionOrbit'}))
        Flags = [Flags varargin(i)];
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDispersionHCM','SetRFDispersionHCM'}))
        Flags = [Flags varargin(i)];
        varargin(i) = [];

    end
end


if length(varargin) >= 1
    if isstruct(varargin{1})
        OCS = varargin{1};
        varargin(1) = [];
        if length(varargin) < 2
            error('An OCS plus at least 2 inputs are required');
        end
        if length(varargin) >= 1
            GoalOrbit = varargin{1};
            varargin(1) = [];
        end
        if length(varargin) >= 1
            CMIncrementList = varargin{1};
            varargin(1) = [];
        end
    else
        OCS.BPM.FamilyName = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            OCS.BPM.DeviceList = varargin{1};
            varargin(1) = [];
        end
        if length(varargin) >= 1
            GoalOrbit = varargin{1};
            varargin(1) = [];
        end
        if length(varargin) >= 1
            OCS.CM.FamilyName = varargin{1};
            varargin(1) = [];
        end
        if length(varargin) >= 1
            CMIncrementList = varargin{1};
            varargin(1) = [];
        end
    end
    
    % Get NIter
    if length(varargin) >= 1
        if isnumeric(varargin{1})
            OCS.NIter = varargin{1};
            varargin(1) = [];
        end
    end
    
    % Get SVDIndex (can be a fractional number, vector, or 'All')
    if length(varargin) >= 1
        %if isnumeric(varargin{1})
            OCS.SVDIndex = varargin{1};
            varargin(1) = [];
        %end
    end

    % Get BPMWeight
    if length(varargin) >= 1
        if isnumeric(varargin{1})
            BPMWeight = varargin{1};
            varargin(1) = [];
        end
    end
end


% Pass the extra inputs on
if length(varargin) >= 1
    Flags = [Flags varargin];
end


% Fill the empty fields
if isempty(OCS.BPM.FamilyName)
    i = menu('Select a plane','Horizontal','Vertical');
    if i == 1
        OCS.BPM.FamilyName = gethbpmfamily;
        OCS.CM.FamilyName  = gethcmfamily;
    elseif i == 2
        OCS.BPM.FamilyName = getvbpmfamily;
        OCS.CM.FamilyName  = getvcmfamily;
    end
end
if isempty(OCS.BPM.DeviceList)
    OCS.BPM.DeviceList = editlist(family2dev(OCS.BPM.FamilyName), OCS.BPM.FamilyName, 0);
    % Getting a list can messes up the order for bumps going from the last sector to the first
    for i = 2:length(OCS.BPM.DeviceList)
        if getspos(OCS.BPM.FamilyName,OCS.BPM.DeviceList(i,:))-getspos(OCS.BPM.FamilyName,OCS.BPM.DeviceList(i-1,:)) > L/2
            break;
        end
    end
    if i < length(OCS.BPM.DeviceList)
        OCS.BPM.DeviceList = [OCS.BPM.DeviceList(i:end,:); OCS.BPM.DeviceList(1:i-1,:)]; 
    end
end
if isempty(OCS.CM.FamilyName)
    if strcmpi(OCS.BPM.FamilyName, gethbpmfamily)
        OCS.CM.FamilyName = gethcmfamily;
    else
        OCS.CM.FamilyName = getvcmfamily;
    end
end

if isempty(UnitsFlag)
    UnitsFlag = getunits(OCS.BPM.FamilyName);
end

if isempty(ModeFlag)
    ModeFlag = getmode(OCS.BPM.FamilyName);
end

if NoLeakageFlag && OCS.NIter==0
    error('Leakage cleanup flag cannot be used with zero iterations.');
end
%%%%%%%%%%%%%%%%%%%%%%%%
% End of input parsing %
%%%%%%%%%%%%%%%%%%%%%%%%


% Possibly convert the GoalOrbit
if any(isnan(GoalOrbit))
    error('Goal orbit has a NaN');
end
if isempty(GoalOrbit)
    % Input the goal orbit
    for i = 1:size(OCS.BPM.DeviceList,1)
        labels{i} = sprintf('Input the goal orbit at %s(%d,%d)',OCS.BPM.FamilyName, OCS.BPM.DeviceList(i,1), OCS.BPM.DeviceList(i,2));
        StartingPoint{i} = '0'; 
    end
    answer = inputdlg(labels,'Local Bump',1,StartingPoint);
    if isempty(answer)
        fprintf('   Local bump cancelled');
        return
    end
    for i = 1:size(OCS.BPM.DeviceList,1)
        GoalOrbit(i,1) = str2num(answer{i});
    end
end
if ischar(GoalOrbit)
    if strcmpi(GoalOrbit, 'Golden')
        GoalOrbit = getgolden(OCS.BPM.FamilyName, OCS.BPM.DeviceList);
    elseif strcmpi(GoalOrbit, 'Offset')
        GoalOrbit = getoffset(OCS.BPM.FamilyName, OCS.BPM.DeviceList);
    else
        error('Goal unknown');
    end
end
GoalOrbit = GoalOrbit(:);

% Check the length
if length(GoalOrbit) ~= size(OCS.BPM.DeviceList,1)
    error('Length of the GoalOrbit must equal the number of devices in BPMList');
end


% CMIncrementList must be a vector, no zeros, no repeats
CheckCM = 0;
if isempty(CMIncrementList)
    CheckCM = 1;
    Ncm = size(OCS.BPM.DeviceList,1)+2;
    if rem(Ncm,2) == 0
        NcmDiv2 = Ncm / 2;
        CMIncrementList = [-(Ncm/2):-1 1:(Ncm/2)];
    else
        NcmDiv2 = Ncm / 2;
        CMIncrementList = [-floor(Ncm/2):-1 1:(floor(Ncm/2)+1)];
    end
end

% Check for a device list input
if ~(size(CMIncrementList,2) == 2 && size(CMIncrementList,1) > 1)
    CMIncrementList = CMIncrementList(:);
    CMIncrementList = sort(CMIncrementList);
    CMIncrementList(find(CMIncrementList==0)) = [];
    CMIncrementList(find(diff(CMIncrementList)==0)) = [];
end

% Get BPM positions 
BPMListTotal = family2dev(OCS.BPM.FamilyName, 1);
BPMsposTotal = getspos(OCS.BPM.FamilyName, BPMListTotal);
BPMspos      = getspos(OCS.BPM.FamilyName, OCS.BPM.DeviceList);


% Stack 3 rings so you you don't have to worry about the L to 0 transition 
CMListTotal = family2dev(OCS.CM.FamilyName, 1);
CMsposTotal = getspos(OCS.CM.FamilyName, CMListTotal);
CMListTotal = [CMListTotal; CMListTotal; CMListTotal];
CMsposTotal = [CMsposTotal-L; CMsposTotal; CMsposTotal+L];


% Find the correctors
% Check for a device list input
if size(CMIncrementList,2) == 2 && size(CMIncrementList,1) > 1
    % DeviceList
    OCS.CM.DeviceList = CMIncrementList;
else
    for i = 1:length(CMIncrementList)
        if CMIncrementList(i) <= 0
            j = find(CMsposTotal <= BPMspos(1));
            OCS.CM.DeviceList(i,:) = CMListTotal(j(end)+CMIncrementList(i)+1,:);
        else
            j = find(CMsposTotal >= BPMspos(end));
            OCS.CM.DeviceList(i,:) = CMListTotal(j(1)+CMIncrementList(i)-1,:);
        end
    end
end

if CheckCM
    DevTotal = family2dev(OCS.CM.FamilyName);
    checkvec = zeros(size(DevTotal,1),1);
    checkvec(findrowindex(OCS.CM.DeviceList, DevTotal)) = 1;
    OCS.CM.DeviceList = editlist(DevTotal, OCS.CM.FamilyName, checkvec);

    % Getting a list can messes up the order for bumps going from the last sector to the first
    for i = 2:length(OCS.CM.DeviceList)
        if getspos(OCS.CM.FamilyName,OCS.CM.DeviceList(i,:)) - getspos(OCS.CM.FamilyName,OCS.CM.DeviceList(i-1,:)) > L/2
            break;
        end
    end
    if i < length(OCS.CM.DeviceList)
        OCS.CM.DeviceList = [OCS.CM.DeviceList(i:end,:); OCS.CM.DeviceList(1:i-1,:)]; 
    end
end


% Find all BPMs outside the bump (leakage control BPMs)
CMspos = getspos(OCS.CM.FamilyName, OCS.CM.DeviceList);
if CMspos(1) > CMspos(end)
    j1 = intersect(find(BPMsposTotal < CMspos(1)), find(BPMsposTotal > CMspos(end)));
    j2 = [];
else
    j1 = find(BPMsposTotal < CMspos(1));
    j2 = find(BPMsposTotal > CMspos(end));
end
if isempty(j1) && isempty(j2)
    error('Cound not find any leakage control BPMs');
end
OCS.BPM.DeviceList   = [BPMListTotal(j1,:); OCS.BPM.DeviceList; BPMListTotal(j2,:);];
BPMDeviceListLeakage = [BPMListTotal(j1,:);                     BPMListTotal(j2,:);];


if OCS.Incremental
    % Incremental
    OCS.GoalOrbit = [zeros(length(j1),1); GoalOrbit; zeros(length(j2),1)];

    if OCS.NIter == 0
        LeakageGoalOrbit = zeros(size(BPMDeviceListLeakage,1),1);
    else
        if isempty(j1)
            LeakageOrbit1 = [];
        else
            LeakageOrbit1 = getam(OCS.BPM.FamilyName,BPMListTotal(j1,:), UnitsFlag, ModeFlag);
        end
        if isempty(j2)
            LeakageOrbit2 = [];
        else
            LeakageOrbit2 = getam(OCS.BPM.FamilyName,BPMListTotal(j2,:), UnitsFlag, ModeFlag);
        end
        LeakageGoalOrbit = [LeakageOrbit1; LeakageOrbit2];
    end
elseif ~OCS.Incremental
    % Absolute
    if isempty(j1)
        LeakageOrbit1 = [];
    else
        LeakageOrbit1 = getam(OCS.BPM.FamilyName,BPMListTotal(j1,:), UnitsFlag, ModeFlag);
    end
    if isempty(j2)
        LeakageOrbit2 = [];
    else
        LeakageOrbit2 = getam(OCS.BPM.FamilyName,BPMListTotal(j2,:), UnitsFlag, ModeFlag);
    end
    OCS.GoalOrbit    = [LeakageOrbit1; GoalOrbit; LeakageOrbit2];
    LeakageGoalOrbit = [LeakageOrbit1; LeakageOrbit2];
else
    error('Absolute or incremental input unknown.');
end


% Add a weight
if isempty(BPMWeight)
    % Default BPMWeight is to weight the leakage twice as much as the bump goal
    BPMWeight = .5 * (length(j1) + length(j2)) / length(GoalOrbit);
    OCS.BPMWeight = [ones(length(j1),1); BPMWeight .* ones(length(GoalOrbit),1); ones(length(j2),1)];
else
    OCS.BPMWeight = [ones(length(j1),1); BPMWeight .* ones(length(GoalOrbit),1); ones(length(j2),1)];
end


% Just to fill the data structure fields
OCS.BPM = family2datastruct(OCS.BPM.FamilyName, 'Monitor',  OCS.BPM.DeviceList, UnitsFlag, ModeFlag);
OCS.CM  = family2datastruct(OCS.CM.FamilyName,  'Setpoint', OCS.CM.DeviceList,  UnitsFlag, ModeFlag);


% Bumps stats
if DisplayFlag
    % Corrector strength (meters/radian) and (mm/amp)
    % Warn on when to add RF frequency (generated dispersion is greater
    % than mm per amp or % of mm/amp bump)    
end


% Set the bump
[OCS, OCS0, V, S, ErrorFlag] = setorbit(OCS, UnitsFlag, ModeFlag, Flags{:});


% Clean up the leakage
if NoLeakageFlag
    if DisplayFlag
        fprintf('   Correcting the leakage\n');
    end
    OCS1 = OCS;
    OCS1.GoalOrbit = LeakageGoalOrbit;
    OCS1.BPM = family2datastruct(OCS.BPM.FamilyName, 'Monitor', BPMDeviceListLeakage);
    OCS1.BPMWeight = [];
    OCS1.Incremental = 0;
    OCS1 = setorbit(OCS1, UnitsFlag, ModeFlag);
end

