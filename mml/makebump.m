function OCS = makebump(varargin)
%MAKEBUMP - Creates and orbit correction structure (OCS) usable by setorbit
%  OCS = makebump(BPMFamily, BPMDeviceList, GoalOrbit, CMFamily, CMIncrementList, BPMWeight {optional})
%  OCS = makebump(OCS, GoalOrbit, CMIncrementList, BPMWeight {optional})
%
%  INPUTS
%  1. BPMFamily
%  2. BPMDeviceList
%  3. GoalOrbit
%  4. CMFamily
%  5. CMIncrementList
%  6. BPMWeight - Weight applied to the BPMs inside the bump (GoalOrbit).  BPM weighting
%                 should only be required when the corrector are in a region of dispersion
%                 and the RF frequency is not used in the orbit correction.
%                {Default BPMWeight is to weight the leakage twice as much as the GoalOrbit}
%  7. 'Display' - Display bump characteristics
%  8. Optional flags used in setorbit can also be used:
%     'FitRF' flag to include the RF frequency as part of orbit correction.
%
%  NOTES
%  1. makebump creates an OCS structure.  Use setorbit to actually change the orbit.
%
%  See also setbump, setbumpgui, setorbit

%  Written by Greg Portmann


%%%%%%%%%%%%
% Defaults %
%%%%%%%%%%%%
nIter = 3;
BPMWeight = [];
GoalOrbit = [];
IncrementalFlag = 1;
DisplayFlag = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OCS.Flags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Golden')
        % Use the golden orbit
        GoalOrbit = 'Golden';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Offset')
        % Use the offset orbit
        GoalOrbit = 'Golden';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        OCS.Flags = [OCS.Flags varargin(i)];
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'ModelResp')
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FitRF')
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'ModelDisp')
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MeasDisp')
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'GoldenDisp')
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Inc') || strcmpi(varargin{i},'Incremental')
        IncrementalFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Abs') || strcmpi(varargin{i},'Absolute')
        IncrementalFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = 'SIMULATOR';
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = 'Online';
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        ModeFlag = 'Manual';
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = 'Physics';
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        OCS.Flags = [OCS.Flags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'archive')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'noarchive')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        % Just remove
        varargin(i) = [];
    end
end
i=length(OCS.Flags);
if IncrementalFlag
    OCS.Flags{i+1} = 'Incremental';
else
    OCS.Flags{i+1} = 'Absolute';
end


if isstruct(varargin{1})
    OCS = varargin{1};
    varargin(1) = [];
    if length(varargin) < 2
        error('An OCS plus at least 2 inputs are required');
    end
    GoalOrbit = varargin{1};
    varargin(1) = [];
    CMIncrementList = varargin{1};
    varargin(1) = [];
else
    if length(varargin) < 5
        error('At least 5 inputs or an orbit correction structure is required');
    end
    OCS.BPM.FamilyName = varargin{1};
    OCS.BPM.DeviceList = varargin{2};
    GoalOrbit = varargin{3};
    OCS.CM.FamilyName = varargin{4};
    CMIncrementList = varargin{5};
    varargin(1:5) = [];
end

if length(varargin) >= 1
    if isnumeric(varargin{1})
        BPMWeight = varargin{1};
        varargin(1) = [];
    end
end

% Pass the extra inputs on
if length(varargin) >= 1
    OCS.Flags = [OCS.Flags varargin];
end


% Possibly convert the GoalOrbit
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
CMIncrementList = CMIncrementList(:);
CMIncrementList = sort(CMIncrementList);
CMIncrementList(find(CMIncrementList==0)) = [];
CMIncrementList(find(diff(CMIncrementList)==0)) = [];


% Get BPM postions
BPMListTotal = family2dev(OCS.BPM.FamilyName, 1);
BPMsposTotal = getspos(OCS.BPM.FamilyName, BPMListTotal);
BPMspos      = getspos(OCS.BPM.FamilyName, OCS.BPM.DeviceList);


% Stack 3 rings so you you don't have to worry about the L to 0 transition 
CMListTotal = family2dev(OCS.CM.FamilyName, 1);
CMsposTotal = getspos(OCS.CM.FamilyName, CMListTotal);
L = getfamilydata('Circumference');
CMListTotal = [CMListTotal; CMListTotal; CMListTotal];
CMsposTotal = [CMsposTotal-L; CMsposTotal; CMsposTotal+L];


% Find the correctors
for i = 1:length(CMIncrementList)
    if CMIncrementList(i) <= 0
        j = find(CMsposTotal <= BPMspos(1));
        OCS.CM.DeviceList(i,:) = CMListTotal(j(end)+CMIncrementList(i)+1,:);
    else
        j = find(CMsposTotal >= BPMspos(end));
        OCS.CM.DeviceList(i,:) = CMListTotal(j(1)+CMIncrementList(i)-1,:);        
    end
end


% Find all BPMs outside the bump (leakage control BPMs)
CMspos = getspos(OCS.CM.FamilyName, OCS.CM.DeviceList);
j1 = find(BPMsposTotal < CMspos(1));
j2 = find(BPMsposTotal > CMspos(end));
if isempty(j1) && isempty(j2)
    error('Cound not find any leakage control BPMs');
end
OCS.BPM.DeviceList = [BPMListTotal(j1,:); OCS.BPM.DeviceList; BPMListTotal(j2,:);];

if IncrementalFlag
    OCS.GoalOrbit = [zeros(length(j1),1); GoalOrbit; zeros(length(j2),1)];
else
    OCS.GoalOrbit = [getam(OCS.BPM.FamilyName,BPMListTotal(j1,:)); GoalOrbit; getam(OCS.BPM.FamilyName,BPMListTotal(j2,:))];
end


% Add a weight
if isempty(BPMWeight)
    % Default BPMWeight is to weight the leakage twice as much as the bump goal
    BPMWeight = .5 * (length(j1) + length(j2)) / length(GoalOrbit);
    OCS.BPMWeight = [ones(length(j1),1); BPMWeight .* ones(length(GoalOrbit),1); ones(length(j2),1)];
else
    OCS.BPMWeight = [ones(length(j1),1); BPMWeight .* ones(length(GoalOrbit),1); ones(length(j2),1)];
end


% Create data structure
OCS.BPM = family2datastruct(OCS.BPM.FamilyName, OCS.BPM.DeviceList);
OCS.CM = family2datastruct(OCS.CM.FamilyName, OCS.CM.DeviceList);


% Bumps stats
if DisplayFlag
    % Corrector strength (meters/radian) and (mm/amp)
    % Warn on when to add RF frequency (generated dispersion is greater than mm per amp or % of mm/amp bump)
end
