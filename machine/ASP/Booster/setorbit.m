function [OCS, RF, OCS0, RF0, V, S] = setorbit(varargin)
%SETORBIT - Orbit correction function
%  Family/DeviceList method:
%  [CM, RF, OCS0, RF0, V, Svalues] = setorbit(GoalOrbit, BPMFamily, BPMDevList, CMFamily, CMDevList, NIter, SVDIndex, BPMWeight);
%
%  Data structure method:
%  [CM, RF, OCS0, RF0, V, Svalues] = setorbit(GoalOrbit, BPMstruct,             CMstruct,            NIter, SVDIndex, BPMWeight);
%
%  Use cell arrays for multiple family correction (like coupled planes):
%  [CM, RF, OCS0, RF0, V, Svalues] = setorbit(GoalOrbitCell, BPMcell, CMcell, NIter, SVDIndex, BPMWeight);
%  Note: BPMcell and CMcell must be a data structures when using cell arrays (GoalOrbitCell can be a cell or a string)
%
%  Orbit Correction Structure (OCS) method:
%  [CM, RF, OCS0, RF0, V, Svalues] = setorbit(OCS, NIter, SVDIndex, BPMWeight);
%
%  INPUTS
%  1. GoalOrbit - Goal orbit (vector or cell array)
%                'Golden' for the golden orbit {Default}
%                'Offset' for the offset orbit
%  2. BPM - BPM data structure (or cell array of structures)
%     or BPMFamily and BPMDevList
%  3. CM - Corrector magnet data structure (or cell array of structures)
%     or CMFamily and CMDevList
%  4. SVDIndex - vector, maximum number, 'All', or
%                base on a threshold of min/max singular value {Default: 1e-3}
%  5. NIter - Number of iterations  {Default: 1}
%            (NIter can be 0, see note 1 below)
%  6. BPMWeight - Weight applied to the BPMs (OCS.BPMWeight)
%  7. FLAGS  - 'Abs' or 'Absolute' - GoalOrbit is an absolute orbit {Default}
%              'Inc' or 'Incremental' - GoalOrbit is a incremental change
%              'GoldenResp' {Default} or 'ModelResp' - Golden BPM response or calculate from the model
%              'SetSP' - Make the setpoint change {Default}
%              'NoSetSP' - Don't set the magnets, just return the OCS
%              'Display' - plot orbit information before applying the correction
%              'FitRF' or 'SetRF' - Fit and change the RF frequency
%                   'MeasDisp' - measure the dispersion  {Default}
%                   'ModelDisp' - calculate the model dispersion
%                   'GoldenDisp' - use the golden dispersion
%              And the usual Units and Mode flags
%
%  OUTPUTS
%  1. OCS    - New orbit correction structure (OCS)
%  2. RF     - New RF frequency (if used)
%  3. OCS0   - Starting OCS
%  4. RF0    - Starting RF frequency (if used)
%  5. V      - Corrector magnet singular vectors
%  6. Svalue - Singular values (vector)
%
%  ALGORITHM
%  SVD orbit correction:
%  Decompose the response matrix, Rmat:
%    [U, S, V] = svd(Rmat);
%
%  The V matrix columns are the singular vectors in the corrector magnet space
%  The U matrix columns are the singular vectors in the BPM space
%    Rmat = U * S = Rmat * V
%
%  Modify the response matrix by removing singular vector with small singular values
%    Rmod = U(:,SVDIndex) * S(SVDIndex,SVDIndex) = Rmat * V(:,SVDIndex)
%
%  Only project (least squares) on to the modified response matrix
%    b = inv(Rmod'*Rmod)*Rmod' * (GoalOrbit - PresentOrbit);
%  Or
%    b = Rmod \ (GoalOrbit - PresentOrbit);
%
%  The b coefficients are in terms of the singular vectors.
%  The corrector strengths come from the linear combination of the singular vectors
%    DeltaCM = V(:,SVDIndex) * b;
%
%  ORBIT CORRECTION STRUCTURE (OCS)
%    OCS.BPM (data structure)
%    OCS.CM  (data structure)
%    OCS.GoalOrbit
%    OCS.NIter
%    OCS.SVDIndex
%    OCS.RF
%    OCS.DeltaRF
%    OCS.IncrementalFlag = 'Yes'/'No'
%    OCS.BPMWeight
%    OCS.Flags = { 'FitRF' , etc.  }
%
%  EXAMPLES
%  1. The default behavior us horizontal and vertical (coupled) orbit correction to the golden orbit
%     setorbit;
%     is equivalent to
%     x = getx('struct');
%     y = gety('struct');
%     hcm = getsp('struct');
%     vcm = getsp('struct');
%     setorbit('golden', {x,y}, {hcm,vcm});
%
%  2. Horizontal orbit correction with the follow criterion:
%     a. Correct to the golden orbit
%     b. Use the first 10 singular values
%     c. Display results
%
%     x = getx([1 1;1 2;12 1; 13 4],'struct');
%     hcm = getsp('HCM',[3 1;5 1;10 1],'struct');
%     setorbit('golden', x, hcm, 10, 'Display');
%
%  3. Horizontal and vertical (coupled) orbit correction to the golden orbit (display results)
%     x = getx([1 1;1 2;12 1; 13 4],'struct');
%     y = gety([1 1;1 2;12 1; 13 4],'struct');
%     hcm = getsp('HCM',[3 1;5 1;10 1],'struct');
%     vcm = getsp('VCM',[3 1;4 1;9 1;10 1],'struct');
%     setorbit('golden', {x,y}, {hcm,vcm}, 'Display');
%
%  NOTES
%  1. Incremental orbit changes with more then one iteration are treated algorithmically
%     just like absolute orbit changes.  For a 1 iteration incremental orbit change
%     BPM data is not needed and hence not used.  However, if one uses the
%     'Display' flag then BPM data is used to show results.  If BPM data is not
%     available and one wants to still display corrector and estimated orbit
%     information then use the special mode: 'Inc', 'Display', NIter=0.
%  2. The 'Display' flag only displays the first iteration and the final result.
%     Intermediate iterations (if used) are not displayed.
%  3. If horizontal and vertical corrector are used, then the
%     coupling terms in the response matrix will be used.
%     To avoid using coupling terms, use separate calls.
%  4. When not fitting the RF frequency, the portion of the orbit that
%     correlates with the dispersion can be removed using rmdisp
%  5. OCS0.CM.Data is the corrector strength before correction
%     OCS.CM.Data  is the corrector strength after correction
%     Hence, DeltaCM = OCS.CM.Data - OCS0.CM.Data;
%
%  Also see orbitcorrectionmethods, setorbitbump, rmdisp, plotcm
%
%  Written by Greg Portmann


% Initialize
ExtraDelay = 0;
DefaultBPM = {'BPMx','BPMy'};
DefaultCM  = {'HCM','VCM'};
DefaultNIter = 3;
DefaultSVDIndex = 1e-3;
DefaultGoalOrbit = 'Golden';
RespFlag = 'GoldenResp';
DispFlag = 'GoldenDisp';
FitRFFlagDefault = 0;
DisplayFlag = 0;
SetSPFlag = 1;

RF0 = [];
RF  = [];
FigHandles = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IncrementalFlag = -1;
FitRFFlag = FitRFFlagDefault;
ModeFlag = '';
InputFlags = {};
OCSFlags = {};
OCS = [];

if isstruct(varargin{1})
    % If the input is an OCS then add .Flags to the end of varargin
    if isfield(varargin{1},'Flags')
        varargin = [varargin varargin{1}.Flags];
    end
end

if length(varargin) > 0
    for i = length(varargin):-1:1
        if isstruct(varargin{i})
            % Ignor structures
        elseif iscell(varargin{i})
            % Ignor cells
        
        elseif strcmpi(varargin{i},'Golden')
            % Use the golden orbit
            OCS.GoalOrbit = 'Golden';
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Offset')
            % Use the offset orbit
            OCS.GoalOrbit = 'Offset';
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        
        elseif any(strcmpi(varargin{i},{'FitRF','SetRF','RFCorrector'}))
            %SetRFString = 'Set the RF frequency (Eta Column)';
            FitRFFlag = 1;
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        elseif any(strcmpi(varargin{i},{'FitRFHCM0','FitRFEnergy','SetRFHCM0','SetRFEnergy'}))
            %SetRFString = 'Set the RF frequency (HCM energy constraint)';
            FitRFFlag = 2;
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        elseif any(strcmpi(varargin{i},{'FitRFDeltaHCM0','SetRFDeltaHCM0'}))
            %SetRFString = 'Set the RF frequency (Delta HCM energy constraint)';
            FitRFFlag = 3;
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        elseif any(strcmpi(varargin{i},{'FitRFDispersionOrbit','SetRFDispersionOrbit'}))
            %SetRFString = 'Set the RF frequency (Dispersion orbit constraint)';
            FitRFFlag = 4;
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        elseif any(strcmpi(varargin{i},{'FitRFDispersionHCM','SetRFDispersionHCM'}))
            %SetRFString = 'Set the RF frequency (Dispersion correction constraint)';
            FitRFFlag = 5;
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];

        elseif strcmpi(varargin{i},'Display')
            DisplayFlag = 1;
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoDisplay') | strcmpi(varargin{i},'No Display')
            DisplayFlag = 0;
            OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
            
        elseif strcmpi(varargin{i},'ModelResp')
            RespFlag = varargin{i};
            varargin(i) = [];
        elseif strcmpi(varargin{i},'GoldenResp')
            RespFlag = varargin{i};
            varargin(i) = [];

        elseif strcmpi(varargin{i},'ModelDisp')
            DispFlag = varargin{i};
            varargin(i) = [];
        elseif strcmpi(varargin{i},'MeasDisp')
            DispFlag = varargin{i};
            varargin(i) = [];
        elseif strcmpi(varargin{i},'GoldenDisp')
            DispFlag = varargin{i};
            varargin(i) = [];

        elseif strcmpi(varargin{i},'Inc') | strcmpi(varargin{i},'Incremental')
            IncrementalFlag = 1;
            %OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Abs') | strcmpi(varargin{i},'Absolute')
            IncrementalFlag = 0;
            %OCSFlags = [OCSFlags varargin(i)];
            varargin(i) = [];
            
        elseif strcmpi(varargin{i},'SetSP')
            SetSPFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoSetSP')
            SetSPFlag = 0;
            varargin(i) = [];
            
        elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model')
            ModeFlag = 'SIMULATOR';
            OCSFlags = [OCSFlags varargin(i)];
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Online')
            ModeFlag = 'Online';
            OCSFlags = [OCSFlags varargin(i)];
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Manual')
            ModeFlag = 'Manual';
            OCSFlags = [OCSFlags varargin(i)];
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'physics')
            OCSFlags = [OCSFlags varargin(i)];
            InputFlags = [InputFlags varargin(i)];
            varargin(i) = [];
        elseif strcmpi(varargin{i},'hardware')
            OCSFlags = [OCSFlags varargin(i)];
            InputFlags = [InputFlags varargin(i)];
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
end

OCSFlags = [OCSFlags {RespFlag} {DispFlag}];


if length(varargin) == 0
    OCS.BPM = [];
    OCS.CM = [];
    OCS.GoalOrbit = DefaultGoalOrbit;
else
    % Check if an OCS structure was input
    OCSStructFlag = 0;
    if isstruct(varargin{1})
        if isfield(varargin{1},'BPM') & isfield(varargin{1},'CM')
            OCSStructFlag = 1;
        end
    end

    if OCSStructFlag
        OCS = varargin{1};
        varargin(1) = [];
    else
        if iscell(varargin{1})
            if isfield(OCS,'GoalOrbit')
                if length(varargin) < 2
                    error('Input parsing problem');
                end
                if ~iscell(varargin{1}) | ~iscell(varargin{2})
                    error('When using cell arrays BPM and CM inputs must all be cell arrays');
                end
                OCS.BPM = varargin{1};
                OCS.CM = varargin{2};
                varargin(1:2) = [];
            else
                if length(varargin) < 3
                    error('Input parsing problem');
                end
                OCS.GoalOrbit = varargin{1};
                if ~iscell(varargin{2}) | ~iscell(varargin{3})
                    error('When using cell arrays BPM and CM inputs must all be cell arrays');
                end
                OCS.BPM = varargin{2};
                OCS.CM = varargin{3};
                varargin(1:3) = [];
            end
        elseif isstruct(varargin{1})
            % BPM and CM are structures, Golden orbit is not
            % Golden orbit could have been a string which has already been removed
            if length(varargin) < 2
                error('Input parsing problem: BPM and/or CM not found');
            end
            OCS.BPM = varargin{1};
            varargin(1) = [];
            if ischar(OCS.BPM)
                FamilyName = OCS.BPM;
                DeviceList = varargin{1};
                if length(varargin) < 1
                    error('BPM device list must exist');
                end
                varargin(1) = [];
                %OCS.BPM = getam(FamilyName, DeviceList, 'struct');
                OCS.BPM = family2datastruct(FamilyName, DeviceList);
            end
            OCS.CM = varargin{1};
            varargin(1) = [];
            if ischar(OCS.CM)
                FamilyName = OCS.CM;
                if length(varargin) < 1
                    error('Corrector magnget device list must exist');
                end
                DeviceList = varargin{1};
                varargin(1) = [];
                OCS.CM = getsp(FamilyName, DeviceList, 'struct');
            end
        else
            if isfield(OCS,'GoalOrbit')
                if length(varargin) < 2
                    error('Input parsing problem: BPM and/or CM not found');
                end
            else
                if length(varargin) < 3
                    error('Input parsing problem: GoalOrbit, BPM, CM not all found');
                end
                OCS.GoalOrbit = varargin{1};
                varargin(1) = [];
            end

            OCS.BPM = varargin{1};
            varargin(1) = [];
            if ischar(OCS.BPM)
                FamilyName = OCS.BPM;
                if isnumeric(varargin{1})
                    DeviceList = varargin{1};
                    varargin(1) = [];
                else
                    DeviceList = [];
                end
                if length(varargin) < 1
                    error('BPM device list must exist');
                end
                %OCS.BPM = getam(FamilyName, DeviceList, 'struct');
                OCS.BPM = family2datastruct(FamilyName, DeviceList);
            end

            OCS.CM = varargin{1};
            varargin(1) = [];
            if ischar(OCS.CM)
                FamilyName = OCS.CM;
                if length(varargin) < 1
                    error('Corrector magnget device list must exist');
                end
                if isnumeric(varargin{1})
                    DeviceList = varargin{1};
                    varargin(1) = [];
                else
                    DeviceList = [];
                end
                OCS.CM = getsp(FamilyName, DeviceList, 'struct');
            end
        end
    end


    % Get NIter
    if length(varargin) >= 1
        OCS.NIter = varargin{1};
        varargin(1) = [];
    end

    % Get SVDIndex
    if length(varargin) >= 1
        OCS.SVDIndex = varargin{1};
        varargin(1) = [];
    end

    % Get BPMWeight
    if length(varargin) >= 1
        OCS.BPMWeight = varargin{1};
        varargin(1) = [];
    end
end

% RF flag
if FitRFFlag >= 0
    OCS.FitRFFlag = FitRFFlag;
else
    % No Fit RF input
    if ~isfield(OCS, 'FitRFFlag')
        OCS.FitRFFlag = FitRFFlagDefault;
    end
end
if isempty(OCS.FitRFFlag)
    OCS.FitRFFlag = FitRFFlagDefault;
end

% Check GoalOrbit
if isempty(OCS.GoalOrbit)
    OCS.GoalOrbit = DefaultGoalOrbit;
end

% Check NIter
if ~isfield(OCS, 'NIter')
    OCS.NIter = DefaultNIter;
end
if isempty(OCS.NIter)
    OCS.NIter = DefaultNIter;
end

% Get/check SVDIndex
if ~isfield(OCS, 'SVDIndex')
    OCS.SVDIndex = DefaultSVDIndex;
end
if isempty(OCS.SVDIndex)
    OCS.SVDIndex = DefaultSVDIndex;
end

% Check BPM field
if isempty(OCS.BPM)
    OCS.BPM = DefaultBPM;
end

% Check CM field
if isempty(OCS.CM)
    OCS.CM = DefaultCM;
end

if IncrementalFlag == 0
    OCS.IncrementalFlag = 'No';
elseif IncrementalFlag == 1
    OCS.IncrementalFlag = 'Yes';
elseif ~isfield(OCS, 'IncrementalFlag')
    OCS.IncrementalFlag = 'No';
end

% Check NIter
if strcmpi(OCS.IncrementalFlag,'Yes')
    if ~DisplayFlag & OCS.NIter == 1
        % Use OCS.NIter=0, since BPM data is not needed
        OCS.NIter = 0;
    end
else
    if OCS.NIter == 0
        error('Number of iterations cannot be zero for absolute orbit changes');
    end
end


% Make cell arrays if they are not already
if ~iscell(OCS.BPM)
    OCS.BPM = {OCS.BPM};
end
if ~iscell(OCS.CM)
    OCS.CM = {OCS.CM};
end

% Attach the flags
OCS.Flags = OCSFlags;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check for good status if online %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(OCS.BPM)
    if strcmpi(getmode(OCS.BPM{i}),'Online')
        [S, IndexList] = family2status(OCS.BPM{i});
        if find(S==0)
            tmp = questdlg({sprintf(...
                'BPM family %s is showing %d element(s) with bad status.', OCS.BPM{i}.FamilyName, length(find(S==0))), ...
                'Do you want to continue with orbit correction?'},...
                'SETORBIT','YES','NO','NO');
            if ~strcmpi(tmp,'YES')
                return
            end
        end
    end
end
for i = 1:length(OCS.CM)
    if strcmpi(getmode(OCS.CM{i}),'Online')
        [S, IndexList] = family2status(OCS.CM{i});
        if find(S==0)
            tmp = questdlg({sprintf(...
                'Corrector family %s is showing %d element(s) with bad status.', OCS.CM{i}.FamilyName, length(find(S==0))), ...
                'Do you want to continue with orbit correction?'},...
                'SETORBIT','YES','NO','NO');
            if ~strcmpi(tmp,'YES')
                return
            end
        end
    end
end


% Check BPMWeight
if ~isfield(OCS, 'BPMWeight')
    for i = 1:length(OCS.BPM)
        OCS.BPMWeight{i} = [];
    end
end
if ~iscell(OCS.BPMWeight)
    OCS.BPMWeight = {OCS.BPMWeight};
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the goal orbit cell %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ischar(OCS.GoalOrbit)
    GoalOrbitFlag = OCS.GoalOrbit;
    OCS.GoalOrbit = [];
    for i = 1:length(OCS.BPM)
        if strcmpi(GoalOrbitFlag,'Golden')
            tmp = getgolden(OCS.BPM{i}, 'Numeric');
        elseif strcmpi(GoalOrbitFlag,'Offset')
            tmp = getoffset(OCS.BPM{i}, 'Numeric');
        else
            error('Only golden and offset orbits are known')
        end
        OCS.GoalOrbit{i} = tmp;
    end
end
if ~iscell(OCS.GoalOrbit)
    OCS.GoalOrbit = {OCS.GoalOrbit};
end

%%%%%%%%%%%%%%%%%%%%%%
% End of Input Setup %
%%%%%%%%%%%%%%%%%%%%%%


% Save the starting RF frequency
OCS.RF = getrf('Struct', InputFlags{:});


% Number of iterations (OCS.NIter can be 0 for display reasons with increment changes)
if OCS.NIter == 0
    NumberOfTrys = 1;
else
    NumberOfTrys = OCS.NIter;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build the starting orbit %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(OCS.BPM)
    if OCS.NIter == 0
        % Don't use BPM data for zero interations
        OCS.BPM{i}.Data = zeros(size(OCS.BPM{i}.DeviceList,1),1);
    else
        OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
    end
end

% For increment changes, convert the goal orbit to an absolute orbit
if strcmpi(OCS.IncrementalFlag,'Yes')
    for i = 1:length(OCS.GoalOrbit)
        OCS.GoalOrbit{i} = OCS.GoalOrbit{i} + OCS.BPM{i}.Data;
    end
end



% Interactively select singular value
SVDquestion = 'Select Again';
MorePlotsFlag = 0;
while strcmp(SVDquestion,'Select Again')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%  remove this & put wit ????
    % Build the starting orbit %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(OCS.BPM)
        if OCS.NIter == 0
            % Don't use BPM data for zero interations
            OCS.BPM{i}.Data = zeros(size(OCS.BPM{i}.DeviceList,1),1);
        else
            OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
        end
    end


    % Get the present setpoints
    OCS.CM = getpv(OCS.CM, 'Struct', InputFlags{:});
    
    % Compute the correction
    [OCS, Smat, S, U, V] = orbitcorrectionmethods(OCS);

    % Save the starting OCS (with possible CM & BPM list changes)
    OCS0 = OCS;

    if DisplayFlag
        FigHandles = PreCorrectionDisplay(FigHandles, OCS0, OCS, Smat, S, U, V, NumberOfTrys, MorePlotsFlag, InputFlags);
    else
        SVDquestion = 'Correct Orbit';
    end

    if SetSPFlag & DisplayFlag
        if MorePlotsFlag == 0
            tmp = menu('', ...
                'Apply orbit correction', ...
                'Change the number of singular values', ...
                'Change the BPMs', ...
                'Change the correctors', ...
                'Plot more information (AT Model required)', ...
                'Exit - No orbit correction');
        else
            tmp = menu('', ...
                'Apply orbit correction', ...
                'Change the number of singular values', ...
                'Change the BPMs', ...
                'Change the correctors', ...
                'Close "more information plot"', ...
                'Exit - No orbit correction');
        end
        if tmp == 6
            fprintf('   Orbit not corrected\n');
            SVDquestion = 'Correct not corrected';
            SetSPFlag = 0;
        elseif tmp == 1
            SVDquestion = 'Correct Orbit';
        elseif tmp == 2
            % Change the singular values
            def = {sprintf('[%d:%d]',OCS.SVDIndex(1),OCS.SVDIndex(end))};
            answer=inputdlg({'Which singular values:'}, 'SETORBIT', 1, def);
            if ~isempty(answer)
                tmp = str2num(answer{1});

                % Test for out-ot-range
                if all(tmp<=size(V,2)) & ~isempty(tmp)
                    OCS.SVDIndex = tmp;
                else
                    fprintf('   Singular value selection out-of-range.  Select again and try a new range.\n');
                end
            end
        elseif tmp == 3
            % Change BPMs
            for i = 1:length(OCS.BPM)
                List0 = OCS.BPM{i}.DeviceList;
                ListTotal = family2dev(OCS.BPM{i}.FamilyName);
                j = findrowindex(OCS.BPM{i}.DeviceList, ListTotal);
                CheckedList = zeros(size(ListTotal,1),1);
                CheckedList(j) = 1;
                OCS.BPM{i}.DeviceList = editlist(ListTotal, OCS.BPM{i}.FamilyName, CheckedList);

                [j,jNotFound] = findrowindex(OCS.BPM{i}.DeviceList, List0);
                if isempty(jNotFound)
                    OCS.GoalOrbit{i} = OCS.GoalOrbit{i}(j);
                    if ~isempty(OCS.BPMWeight{i}) & isvector(OCS.BPMWeight{i})
                        OCS.BPMWeight{i} = OCS.BPMWeight{i}(j);
                    end
                else
                    % New BPMs were added
                    if any(strcmpi(OCS.Flags,'Golden'))
                        OCS.GoalOrbit{i} = getgolden(OCS.BPM{i}, 'Numeric');
                    elseif any(strcmpi(OCS.Flags,'Offset'))
                        OCS.GoalOrbit{i} = getoffset(OCS.BPM{i}, 'Numeric');
                    else
                        error('Unknown goal orbit for the new BPMs');
                    end
                    if ~isempty(OCS.BPMWeight{i})
                        if all(OCS.BPMWeight{i} == max(OCS.BPMWeight{i}))
                            % If all the weights are the same, then the new BPMs get the same weight
                            OCS.BPMWeight{i} = OCS.BPMWeight{i}(1) * ones(size(OCS.BPM{i}.DeviceList,1),1);
                        else
                            error('Unknown BPM weights for new BPMs');
                        end
                    end
                end
            end
        elseif tmp == 4
            % Change correctors
            for i = 1:length(OCS.CM)
                ListTotal = family2dev(OCS.CM{i}.FamilyName);
                j = findrowindex(OCS.CM{i}.DeviceList, ListTotal);
                CheckedList = zeros(size(ListTotal,1),1);
                CheckedList(j) = 1;
                OCS.CM{i}.DeviceList = editlist(ListTotal, OCS.CM{i}.FamilyName, CheckedList);
            end
        elseif tmp == 5
            if MorePlotsFlag == 0
                MorePlotsFlag = 1;
            else
                MorePlotsFlag = 0;
                close(FigHandles(2));
                FigHandles = [FigHandles(1); NaN];

                % Make figure 1 a little wider
                p = get(FigHandles(1), 'Position');
                set(FigHandles(1), 'Position', [p(1)-.1*p(3) p(2) p(3)+.1*p(3) p(4)]);
            end
        end
    else
        SVDquestion = 'Get out of loop';
    end
end


% Exit if ~SetSPFlag
if ~SetSPFlag
    % Put Delta into OCS.CM
    for i = 1:length(OCS.CM)
        OCS.CM{i}.Data = OCS.CM{i}.Data + OCS.CM{i}.Delta;
    end
    if FitRFFlag
        OCS.RF.Data = OCS.RF.Data + OCS.DeltaRF;
    end

    % Remove the cell array if the length is one  ??? should only do if the input was not a cell
    if length(OCS.BPM) == 1
        OCS.BPM = OCS.BPM{1};
        OCS0.BPM = OCS0.BPM{1};

        OCS.GoalOrbit = OCS.GoalOrbit{1};
        OCS0.GoalOrbit = OCS0.GoalOrbit{1};

        OCS.BPMWeight = OCS.BPMWeight{1};
        OCS0.BPMWeight = OCS0.BPMWeight{1};
    end
    if length(OCS.CM) == 1
        OCS.CM = OCS.CM{1};
        OCS0.CM = OCS0.CM{1};
    end
    return;
end


% Iterate on orbit correction
for iloop = 1:NumberOfTrys
    if iloop > 1    % Since it is already computed for the 1st iteration
        % Build the new starting orbit
        for i = 1:length(OCS.BPM)
            OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
        end

        % Compute the correction
        OCS = orbitcorrectionmethods(OCS, Smat, S, U, V);
    end
    

    % Put Delta into OCS.CM
    for i = 1:length(OCS.CM)
        OCS.CM{i}.Data = OCS.CM{i}.Data + OCS.CM{i}.Delta;
    end
    if FitRFFlag
        OCS.RF.Data = OCS.RF.Data + OCS.DeltaRF;
    end


    % Check limits
    for i = 1:length(OCS.CM)
        MinSP = minsp(OCS.CM{i});
        MaxSP = maxsp(OCS.CM{i});
        if any(OCS.CM{i}.Data > MaxSP)
            fprintf('   Orbit correction stopped.\n   A maximum power supply limit would have been exceeded!\n');
            return;
        end
        if any(OCS.CM{i}.Data < MinSP)
            fprintf('   Orbit correction stopped.\n   A minimum power supply limit would have been exceeded!\n');
            return;
        end
    end


    % Check beam current
%     if getdcct < .05
%         fprintf('   Orbit correction stopped.   Beam current is below .05 milliampere!\n');
%         return;
%     end


    if DisplayFlag
        if OCS.NIter > 1
            fprintf('   Iteration %d. Changing the correctors (%s)\n', iloop, datestr(clock, 0));
            if FitRFFlag
                fprintf('   Iteration %d. Changing the RF frequency by %d %s\n', iloop, OCS.DeltaRF, OCS.RF.UnitsString);
            end
        else
            fprintf('   Setting the correctors (%s)\n', datestr(clock, 0));
            if FitRFFlag
                fprintf('   Changing the RF frequency by %d %s (%s)\n', OCS.DeltaRF, OCS.RF.UnitsString, datestr(clock, 0));
            end
        end
    end


    % Set the RF frequency
    if FitRFFlag
        steprf(OCS.DeltaRF, InputFlags{:});
    end

    
    % Apply correction slowly  (something wrong here???)
    % CM2 = OCS.CM;
    % CM  = OCS.CM;
    % CM1 = getpv(OCS.CM,'Struct');
    % Nsteps = 3;
    % for j = 1:Nsteps
    %     for i = 1:length(OCS.CM)
    %         CM{i}.Data = CM1{i}.Data + (CM2{i}.Data - CM1{i}.Data)*(j/Nsteps);  ???
    %         setpv(CM{i}, 0, InputFlags{:});
    %     end
    %     %fprintf('  %d Corrector paused\n',j);
    %     %pause;
    % end

    % Apply correction slowly Eugene 08-05-2006
    Slowapplication = 1;
    if Slowapplication
        CM2 = OCS.CM;
        CM  = OCS.CM;
        CM1 = getpv(OCS.CM,'Struct');
        Nsteps = 10;
        j = 0
        while j <= Nsteps
            usrresp = questdlg(sprintf('Orbit correction iteration = %d / %d',j,Nsteps),...
                'Orbit Correction','Continue','Backstep','Finished','Continue');
            switch usrresp
                case 'Continue'
                    j = j + 1;
                case 'Backstep'
                    j = j - 1;
                case 'Finished'
                    break;
                case ''
            end
            for i = 1:length(OCS.CM)
                CM{i}.Data = CM1{i}.Data + (CM2{i}.Data - CM1{i}.Data)*(j/Nsteps);
                setpv(CM{i}, 0, InputFlags{:});
            end
        end
    else
        % Apply in one step
        setpv(OCS.CM, -2, InputFlags{:});
    end
    sleep(ExtraDelay);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Build the final orbit %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(OCS.BPM)
        if OCS.NIter > 0
            OCS.BPM{i}.Data = getpv(OCS.BPM{i}, 'Numeric', InputFlags{:});
        end
    end

    
    % Get the present setpoints
    % Some accelerators might have digitizing errors that get picked up with a reread
    OCS.CM = getpv(OCS.CM, 'Struct', InputFlags{:});

    %if FitRFFlag
    %    OCS.RF = getrf('Struct', InputFlags{:});
    %end
end


% For multiple iterations put the total change in the .Delta & .DeltaRF fields
for i = 1:length(OCS.CM)
    OCS.CM{i}.Delta = OCS.CM{i}.Data - OCS0.CM{i}.Data;
end
if FitRFFlag
    OCS.DeltaRF = OCS.RF.Data - OCS0.RF.Data;
end



% Display final result if DisplayFlag, more than 0 iterations, and a setpoint change was made
if DisplayFlag & OCS.NIter & SetSPFlag
    PostCorrectionDisplay(FigHandles, OCS0, OCS, Smat, S, U, V, NumberOfTrys, MorePlotsFlag, InputFlags);
end


% Setup the outputs
if FitRFFlag
    RF = getrf('Struct', InputFlags{:});
end


% Remove the cell array if the length is one ??? should only do if the input was not a cell
if length(OCS.BPM) == 1
    OCS.BPM = OCS.BPM{1};
    OCS0.BPM = OCS0.BPM{1};

    OCS.GoalOrbit = OCS.GoalOrbit{1};
    OCS0.GoalOrbit = OCS0.GoalOrbit{1};

    OCS.BPMWeight = OCS.BPMWeight{1};
    OCS0.BPMWeight = OCS0.BPMWeight{1};
end
if length(OCS.CM) == 1
    OCS.CM = OCS.CM{1};
    OCS0.CM = OCS0.CM{1};
end


if DisplayFlag
    fprintf('   Orbit correction complete (%s)\n', datestr(clock, 0));
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Pre-correction display %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H = PreCorrectionDisplay(H, OCS0, OCS, Smat, S, U, V, NumberOfTrys, MorePlotsFlag, InputFlags)

% Build the orbit vector
StartOrbitVec = [];
Orbit0Vec = [];
GoalOrbitVec = [];
BPMWeight = [];
for i = 1:length(OCS.BPM)
    StartOrbitVec = [StartOrbitVec; OCS.BPM{i}.Data];
    Orbit0Vec     = [Orbit0Vec;     OCS.BPM{i}.Data];
    GoalOrbitVec  = [GoalOrbitVec;  OCS.GoalOrbit{i}];

    if isempty(OCS.BPMWeight{i})
        BPMWeight = [BPMWeight; ones(length(OCS.BPM{i}.Data),1)];
    else
        BPMWeight = [BPMWeight; OCS.BPMWeight{i}(:)];
    end
end

% Plot some stuff
L = getfamilydata('Circumference');
if isempty(L)
    global THERING
    L = findspos(THERING, length(THERING)+1);
end


if isempty(H)
    HCF = get(0,'CurrentFigure');
    if isempty(HCF)
        H = [gcf;NaN];
    else
        if rem(HCF,1)==0
            H = [HCF(1);NaN];
        else
            H = [figure;NaN];
        end
    end
    subfig(2,2,2, H(1));
    p = get(H(1), 'Position');
    set(H(1), 'Position', [p(1) p(2)-.8*p(4) p(3) p(4)+.8*p(4)]);
end


figure(H(1));
clf reset
ColorOrderMat = get(gca,'ColorOrder');


% Plot singular values
figure(H(1));
subplot(4,1,1);
iremove = 1:length(S);
[tmp1, tmp2, i] = intersect(OCS.SVDIndex, iremove);
iremove(i) = [];
semilogy(OCS.SVDIndex,S(OCS.SVDIndex),'ob','markersize',2);
hold on;
semilogy(iremove,S(iremove),'xr','markersize',5);
hold off
ylabel('Magnitude');
xlabel('Singular Value Number');
title(sprintf('Iteration 1 of %d', NumberOfTrys));
axis tight


% Change in corrector
figure(H(1));
subplot(4,1,2);
for i4 = 1:length(OCS.CM)
    CMpos = getspos(OCS.CM{i4});
    [CMpos,isort] = sort(CMpos);

    % Percentage from max
    %CMmax = maxsp(OCS.CM{i4});
    %plot(CMpos, 100*OCS.CM{i4}.Delta./CMmax, '.-','Color', ColorOrderMat(mod(i4,size(ColorOrderMat,1)),:));
    %%plot(CMpos, 100*OCS.CM{i4}.Delta./CMmax,'-square','Color', ColorOrderMat(mod(i4,size(ColorOrderMat,1)),:), 'Markersize',3, 'MarkerFaceColor', ColorOrderMat(mod(i4,size(ColorOrderMat,1)),:));
    %LabelCell4{i4} = sprintf('%s', OCS.CM{i4}.FamilyName);

    % Absolute corrector change
    plot(CMpos, OCS.CM{i4}.Delta(isort), '.-','Color', ColorOrderMat(mod(i4,size(ColorOrderMat,1)),:));
    LabelCell4{i4} = sprintf('%s [%s]', OCS.CM{i4}.FamilyName, OCS.CM{i4}.UnitsString);

    hold on;
end
hold off;
if length(OCS.CM) == 1
    %ylabel(sprintf('{\\Delta}%s [%%Max]', OCS.CM{1}.FamilyName));
    ylabel(sprintf('\\Delta %s [%s]', OCS.CM{1}.FamilyName, OCS.CM{1}.UnitsString));
else
    %ylabel('\Delta Corrector [%Max]');
    ylabel('\Delta Corrector');
    legend(LabelCell4, 1);
end
title('Corrector Magnet Change');
xlabel('Position [Meters]');
xaxis([0 L]);


figure(H(1));
subplot(4,1,3);
for i = 1:length(OCS.BPM)
    BPMpos = getspos(OCS.BPM{i});
    [BPMpos, isort] = sort(BPMpos);

    % S-mat prediction: OrbitDelta + Error
    plot(BPMpos, OCS.BPM{i}.PredictedOrbitDelta(isort) + (OCS.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort)),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    hold on;
    LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
end
hold off
if length(LabelCell2) == 1
    ylabel(sprintf('%s Residual [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
else
    ylabel('Orbit Residual');
    h_legend1 = legend(LabelCell2, 1);
end
title('Predicted Orbit Residual (by the Response Matrix)');
xlabel('Position [Meters]');
xaxis([0 L]);


% Plot Orbit Error
figure(H(1));
subplot(4,1,4);
for i = 1:length(OCS.BPM)
    BPMpos = getspos(OCS.BPM{i});
    [BPMpos, isort] = sort(BPMpos);
    plot(BPMpos, OCS.BPM{i}.Data(isort) - OCS.GoalOrbit{i}(isort),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    hold on;
    LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
end
hold off
if length(LabelCell2) == 1
    ylabel(sprintf('%s Error [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
else
    ylabel('Orbit Error');
    h_legend1 = legend(LabelCell2, 1);
end
title('Orbit Error Before Correction');
xlabel('Position [Meters]');
xaxis([0 L]);


if OCS.FitRFFlag
    addlabel(0, 0, sprintf('RF frequency will be changed by  %g %s', OCS.DeltaRF, OCS.RF.UnitsString));
end

TimeString = datestr(clock,0);
addlabel(1, 0, TimeString);
orient portrait


if MorePlotsFlag
    persistent h_TimeLabel
    if MorePlotsFlag & isnan(H(2))
        H(2) = H(1) + 1;
        subfig(2,2,1,H(2));
        p = get(H(2), 'Position');
        set(H(2), 'Position', [p(1) p(2)-.8*p(4) p(3) p(4)+.8*p(4)]);
        p = get(H(2), 'Position');
        set(H(2), 'Position', [p(1)+.2*p(3) p(2) p(3)-.1*p(3) p(4)]);

        p = get(H(1), 'Position');
        set(H(1), 'Position', [p(1)+.1*p(3) p(2) p(3)-.1*p(3) p(4)]);

        figure(H(2));
        clf reset

        h_TimeLabel = [];

        % Print wait messege
        plot([0 1],[0 1],'w');
        set(gca,'units','characters');
        p = get(gca,'Position');
        set(gca,'XTick',[]); set(gca,'YTick',[]); cla; title(' '); xlabel(' '); ylabel(' ');
        set(gca,'box','on');
        Top = floor(p(4));

        text(4,Top-4,sprintf('Please wait ...'),'units','characters');
        text(4,Top-6,sprintf('Computing correction performance'),'units','characters');
        text(4,Top-7,sprintf('   as a function of singular value number.'),'units','characters');
        drawnow;


        % The total kick as a function of SV
        warning off;
        LastGoodSvalue = 1;
        OCStmp = OCS;
        for i = 1:length(S)
            lastwarn('');
            
            OCStmp.SVDIndex = 1:i;
            OCStmp = orbitcorrectionmethods(OCStmp, Smat, S, U, V);

            % RMS orbit change of the corrector magnets
            for j = 1:length(OCS.CM)
                if isempty(lastwarn)
                    CMSTDvec{j}(i) = std(OCStmp.CM{j}.Delta);
                    CMTotal(j,i) = sum(abs(OCStmp.CM{j}.Delta));
                else
                    CMSTDvec{j}(i) = NaN;
                    CMTotal(j,i) = NaN;
                end
            end

            if isempty(lastwarn)
                LastGoodSvalue = i;
                DeltaRFvec(i,1) = OCStmp.DeltaRF;
            else
                DeltaRFvec(i,1) = NaN;
                %fprintf('\n   S-value number %d warning: %s', i, lastwarn);
            end
        end
        
        warning on;
        if LastGoodSvalue ~= length(S)
            fprintf('   Computational warning for choosing singular values above %d. \n', LastGoodSvalue);
        end

        figure(H(2));
        clf reset
        subplot(4,1,1);
        for i = 1:length(OCS.CM)
            LabelCellCM{i} = sprintf('%s [%s]', OCS.CM{i}.FamilyName, OCS.CM{i}.UnitsString);
        end
        if OCS.FitRFFlag
            [ax, h1, h2] = plotyy(1:length(S), CMTotal, 1:length(S), DeltaRFvec);
            set(get(ax(2),'Ylabel'),'String',sprintf('\\DeltaRF Frequency [%s]', OCS.RF.UnitsString), 'Color',[.5 0 0]);
            set(h1,'LineStyle','-');
            set(h1,'Marker','.');
            set(h1,'MarkerSize',6);
            set(h2,'LineStyle','-');
            set(h2,'Color',[.5 0 0]);
            set(ax(2),'YColor',[.5 0 0]);
            set(h2,'Marker','.');
            set(h2,'MarkerSize',6);
            set(get(ax(1),'XLabel'),'String', 'Singular Value Number');
            %set(get(ax(1),'Title'), 'String', 'Pre-Orbit Correction Data');
            title(sprintf('Pre-Orbit Correction Data'));
            
            if length(LabelCellCM) == 1
                set(get(ax(1),'YLabel'),'String',sprintf('abs(sum(%s)) [%s]', OCS.CM{1}.FamilyName, OCS.CM{1}.UnitsString));
            else
                set(get(ax(1),'YLabel'),'String',sprintf('abs(sum(Kicks))'));
                h_legend1 = legend(LabelCellCM, 0);
                AxePosition = get(ax(2),'Position');
                set(ax(1),'Position', AxePosition);
            end

        else
            plot(1:length(S), CMTotal, '.-');
            if length(LabelCellCM) == 1
                ylabel(sprintf('abs(sum(%s)) [%s]', OCS.CM{1}.FamilyName, OCS.CM{1}.UnitsString));
            else
                ylabel('abs(sum(Kicks))');
                h_legend1 = legend(LabelCellCM, 0);
            end
            xlabel('Singular Value Number');
            %title(sprintf('Iteration 1 of %d', NumberOfTrys));
            title(sprintf('Pre-Orbit Correction Data'));
        end


        % Plot Orbit Error
        figure(H(2));
        subplot(4,1,2);
        ColorOrderMat = get(gca,'ColorOrder');
        for i = 1:length(OCS.BPM)
            %BPMpos = getspos(OCS.BPM{i});
            plot(1:length(S), CMSTDvec{i},'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
            hold on;
            LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
        end
        hold off
        if length(LabelCell2) == 1
            ylabel(sprintf('STD %s [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
        else
            ylabel('Orbit STD');
            h_legend1 = legend(LabelCell2, 1);
        end
        title('Standard Deviation of the Orbit Delta Due to the Correction');
        xlabel('Singular Value Number');
    end
    

    % Model prediction
    %[Orbit0ModelX, Orbit0ModelY, Xpos, Ypos] = modeltwiss('x', 'All');
    for i = 1:length(OCS.BPM)
        OCS0Model.BPM{i} = getpv(OCS.BPM{i},'Model');
    end

    % Step the model
    for i = 1:length(OCS.CM)
        steppv(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, OCS.CM{i}.Delta, OCS.CM{i}.DeviceList, 'Model', InputFlags{:});
    end
    if OCS.FitRFFlag
        stepsp('RF', OCS.DeltaRF, 'Model');
    end

    %[OrbitModelX, OrbitModelY] = modeltwiss('x', 'All');
    for i = 1:length(OCS.BPM)
        OCSModel.BPM{i} = getpv(OCS.BPM{i},'Model');
    end

    % Step the model back
    for i = 1:length(OCS.CM)
        steppv(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, -1*OCS.CM{i}.Delta, OCS.CM{i}.DeviceList, 'Model', InputFlags{:});
    end
    if OCS.FitRFFlag
        stepsp('RF', -OCS.DeltaRF, 'Model');
    end

    % Plot Orbit Error
    figure(H(2));
    subplot(4,1,3);
    ColorOrderMat = get(gca,'ColorOrder');
    for i = 1:length(OCS.BPM)
        BPMpos = getspos(OCS.BPM{i});
        [BPMpos,isort] = sort(BPMpos);

        % Model prediction Error
        plot(BPMpos, (OCSModel.BPM{i}.Data(isort)-OCS0Model.BPM{i}.Data(isort)) - (OCS.GoalOrbit{i}(isort)-OCS.BPM{i}.Data(isort)),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));

        % S-mat prediction
        %    plot(BPMpos, (OCS0.BPM{i}.Data-OCS.GoalOrbit{i}) + (BPMSVDDeltaCell{i}),':','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
        hold on;
        LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
    end
    hold off
    if length(LabelCell2) == 1
        ylabel(sprintf('%s Residual [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
    else
        ylabel('Orbit Residual');
        h_legend1 = legend(LabelCell2, 1);
    end
    title('Predicted Orbit Residual (by the Nonlinear AT Model)');
    xlabel('Position [Meters]');
    xaxis([0 L]);


    % Linearization Error
    figure(H(2));
    subplot(4,1,4);
    ColorOrderMat = get(gca,'ColorOrder');
    for i = 1:length(OCS.BPM)
        BPMpos = getspos(OCS.BPM{i});
        [BPMpos,isort] = sort(BPMpos);

        % Model - S-matrix prediction
        plot(BPMpos, (OCSModel.BPM{i}.Data(isort)-OCS0Model.BPM{i}.Data(isort)) - OCS.BPM{i}.PredictedOrbitDelta(isort),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
        hold on;
        LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
    end
    hold off
    if length(LabelCell2) == 1
        %ylabel(sprintf('%s Linearization Error [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
        ylabel(sprintf('Linearization Error [%s]', OCS.BPM{1}.UnitsString));
    else
        ylabel('Linearization Error');
        h_legend1 = legend(LabelCell2, 1);
    end
    title('Predicted Orbit Change Error (AT Model - Response Matrix)');
    xlabel('Position [Meters]');
    xaxis([0 L]);


    %     % Plot Orbit - Goal (error)
    %     for i = 1:length(OCS.BPM)
    %         [ax, h1, h2] = plotyy(Xpos, OrbitModelX-Orbit0ModelX, Ypos, OrbitModelY-Orbit0ModelY);
    %         set(get(ax(1),'Ylabel'),'String',sprintf('Horizontal [mm]'));
    %         set(get(ax(2),'Ylabel'),'String',sprintf('Vertical [mm]'));
    %         set(h1,'LineStyle','-');
    %         set(h1,'Marker','.');
    %         set(h1,'MarkerSize',6);
    %         set(h2,'LineStyle','-');
    %         set(h2,'Marker','.');
    %         set(h2,'MarkerSize',6);
    %     end
    %     xlabel('Position [Meters]');
    %     xaxis([0 L]);

    if OCS.FitRFFlag
        addlabel(0, 0, sprintf('RF frequency will be changed by  %g %s', OCS.DeltaRF, OCS.RF.UnitsString));
    end
    
    if isempty(h_TimeLabel)
        h_TimeLabel = addlabel(1, 0, TimeString);
    else
        set(h_TimeLabel,'String',TimeString);
    end
    orient portrait

    figure(H(1));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  End pre-correction display  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Post-correction display  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PostCorrectionDisplay(H, OCS0, OCS, Smat, S, U, V, NumberOfTrys, MorePlotsFlag, InputFlags)


% Build the orbit vectors
StartOrbitVec = [];
Orbit0Vec = [];
GoalOrbitVec = [];
OrbitNewVec = [];
BPMWeight = [];
for i = 1:length(OCS.BPM)
    StartOrbitVec = [StartOrbitVec; OCS.BPM{i}.Data];
    Orbit0Vec     = [Orbit0Vec;     OCS.BPM{i}.Data];
    GoalOrbitVec  = [GoalOrbitVec;  OCS.GoalOrbit{i}];

    %OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
    OrbitNewVec = [OrbitNewVec; OCS.BPM{i}.Data];
    
    if isempty(OCS.BPMWeight{i})
        BPMWeight = [BPMWeight; ones(length(OCS.BPM{i}.Data),1)];
    else
        BPMWeight = [BPMWeight; OCS.BPMWeight{i}(:)];
    end
end

L = getfamilydata('Circumference');
if isempty(L)
    global THERING
    L = findspos(THERING, length(THERING)+1);
end


% Plot some stuff
figure(H(1));
clf reset
ColorOrderMat = get(gca,'ColorOrder');


% Plot singular values
figure(H(1));
subplot(4,1,1);
iremove = 1:length(S);
[tmp1, tmp2, i] = intersect(OCS.SVDIndex, iremove);
iremove(i) = [];
semilogy(OCS.SVDIndex,S(OCS.SVDIndex),'ob','markersize',2);
hold on;
semilogy(iremove,S(iremove),'xr','markersize',5);
hold off
ylabel('Magnitude');
xlabel('Singular Value Number');
title(sprintf('Orbit Correction Results (%d Iterations)', NumberOfTrys));
axis tight


% Plot cumulative change in the corrector
figure(H(1));
subplot(4,1,2);
for i = 1:length(OCS.CM)
    CMpos = getspos(OCS.CM{i});
    [CMpos,isort] = sort(CMpos);
    plot(CMpos, OCS.CM{i}.Data(isort)-OCS0.CM{i}.Data(isort), '.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    %plot(CMpos, OCS.CM{i}.Data-OCS0.CM{i}.Data,'-square','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:), 'Markersize',3, 'MarkerFaceColor', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    hold on;
    LabelCell4{i} = sprintf('%s [%s]', OCS.CM{i}.FamilyName, OCS.CM{i}.UnitsString);
end
hold off;
if length(OCS.CM) == 1
    ylabel(sprintf('\\Delta %s [%s]', OCS.CM{1}.FamilyName, OCS.CM{1}.UnitsString));
else
    ylabel('\Delta Corrector');
    legend(LabelCell4, 1);
end
title('Corrector Magnet Change After Correction');
xlabel('Position [Meters]');
xaxis([0 L]);


% Plot Orbit Error
figure(H(1));
subplot(4,1,3);
ColorOrderMat = get(gca,'ColorOrder');
for i = 1:length(OCS.BPM)
    BPMpos = getspos(OCS.BPM{i});
    [BPMpos, isort] = sort(BPMpos);

    % S-mat prediction: OrbitDelta + Error
    plot(BPMpos, OCS.BPM{i}.PredictedOrbitDelta(isort) + (OCS.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort)),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    hold on;
    LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
end
hold off
if length(LabelCell2) == 1
    ylabel(sprintf('%s Residual [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
else
    ylabel('Orbit Residual');
    h_legend1 = legend(LabelCell2, 1);
end
title('Predicted Orbit Residual (by the Response Matrix)');
xlabel('Position [Meters]');
xaxis([0 L]);


% Plot Orbit Error
figure(H(1));
subplot(4,1,4);

% Final orbit error
for i = 1:length(OCS.BPM)
    BPMpos = getspos(OCS.BPM{i});
    [BPMpos,isort] = sort(BPMpos);
    plot(BPMpos, OCS.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    hold on;
    LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
end

% % Starting orbit error
% for i = 1:length(OCS.BPM)
%     BPMpos = getspos(OCS.BPM{i});
%     plot(BPMpos, OCS0.BPM{i}.Data-OCS.GoalOrbit{i},'.:','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%     LabelCell2{i} = sprintf('%s at start', OCS.BPM{i}.FamilyName);
% end

hold off
if length(LabelCell2) == 1
    ylabel(sprintf('%s Error [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
else
    ylabel('Orbit Error');
    h_legend1 = legend(LabelCell2, 1);
end
title('Actual Orbit Error After Correction');
xlabel('Position [Meters]');
xaxis([0 L]);


if OCS.FitRFFlag
    addlabel(0, 0, sprintf(' RF frequency was changed by  %g %s', OCS.DeltaRF, OCS.RF.UnitsString));
end

addlabel(1, 0, datestr(clock,0));
orient portrait




% for i = 1:length(OCS.BPM)
%     BPMpos = getspos(OCS.BPM{i});
%     [BPMpos,isort] = sort(BPMpos);
% 
%     % S-mat prediction
%     plot(BPMpos, (OCS0.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort)) + (OCS.BPM{i}.PredictedOrbitDelta(isort)),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%     hold on;
%     LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
% end
% hold off
% if length(LabelCell2) == 1
%     ylabel(sprintf('%s Residual [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
% else
%     ylabel('Orbit Residual');
%     h_legend1 = legend(LabelCell2, 1);
% end
% title('Predicted Orbit Residual (by the Response Matrix)');
% xlabel('Position [Meters]');
% xaxis([0 L]);


% if MorePlotsFlag
%
%     figure(H(2));
%
%     % Plot Orbit Error
%     for i = 1:length(OCS.BPM)
%         OCSFinal.BPM{i} = getpv(OCS.BPM{i});
%     end
%
%     subplot(3,1,3);
%     ColorOrderMat = get(gca,'ColorOrder');
%
%     for i = 1:length(OCS.BPM)
%         BPMpos = getspos(OCS.BPM{i});
%         plot(BPMpos, OCSFinal.BPM{i}.Data-OCS.GoalOrbit{i},'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%         hold on;
%         LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
%     end
%     hold off
%     if length(LabelCell2) == 1
%         ylabel(sprintf('%s Error [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
%     else
%         ylabel('Orbit Error');
%         h_legend1 = legend(LabelCell2, 1);
%     end
%     title('Orbit Error After Correction');
%     xlabel('Position [Meters]');
%     xaxis([0 L]);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  End post-correction display  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

