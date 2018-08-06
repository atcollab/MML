function [OCS, OCS0, V, S, ErrorFlag] = setorbit(varargin)
%SETORBIT - Orbit correction function
%  Family/DeviceList method:
%  [CM, OCS0, V, Svalues] = setorbit(GoalOrbit, BPMFamily, BPMDevList, CMFamily, CMDevList, NIter, SVDIndex, BPMWeight);
%
%  Data structure method:
%  [CM, OCS0, V, Svalues] = setorbit(GoalOrbit, BPMstruct,             CMstruct,            NIter, SVDIndex, BPMWeight);
%
%  Use cell arrays for multiple family correction (like coupled planes):
%  [CM, OCS0, V, Svalues] = setorbit(GoalOrbitCell, BPMcell, CMcell, NIter, SVDIndex, BPMWeight);
%  Note: BPMcell and CMcell must be a data structures when using cell arrays (GoalOrbitCell can be a cell or a string)
%
%  Orbit Correction Structure (OCS) method:
%  [CM, OCS0, V, Svalues] = setorbit(OCS, NIter, SVDIndex, BPMWeight);
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
%  7. FLAGS  - 'Abs' or 'Inc' - GoalOrbit is an absolute or incremental change {Default: 'Abs'}
%                               ('Absolute' or 'Incremental' can also be used)
%              'CorrectorGain', Gain - Scale the correction by Gain {Default: 1}
%              'Display' - plot orbit information before applying the correction
%              'FigureHandles' followed by a vector of 1 or 2 elements for figure handles and
%                                                      4 or 8 elements for axes handles.
%              'FitRF' or 'SetRF' - Fit and change the RF frequency
%                   'GoldenDisp' - Use the golden dispersion {Default}
%                   'MeasDisp'   - Measure the dispersion 
%                   'ModelDisp'  - Calculate the model dispersion
%              'GetPV' or 'NoGetPV' - Get new data or use the data already in the OCS {Default: 'GetPV' (for the first iteration)}
%                                     This allows one make a correction based on data already checked and analyzed.
%                                     ('GetAM' or 'NoGetAM' does the same thing)
%              'GoldenResp' or 'ModelResp' - Golden BPM response or calculate from the model {Default: 'GoldenResp'} 
%              'SetPV' or 'NoSetPV' - Set or don't set the correctors and RF {Default: 'SetSP'}
%                                    'NoSetPV' does the calculation without making the correction.  That way one can
%                                     take a look at the expected correction results before applying them.
%                                     ('SetSP' or 'NoSetSP' does the same thing)
%              'Tolerance', Tol - Quit correction if the std(error) < Tol {Tol: 0}
%              'RampSteps', NSteps - Number of steps to ramp in the correction {NSteps: 1}
%                                    This is used to avoid a large transient between setpoint changes.
%                                    Note: NSteps is only used on the first iteration.
%              'FitRF','SetRF','RFCorrector'                       - Set the RF frequency (Eta Column)
%              'FitRFHCM0','FitRFEnergy','SetRFHCM0','SetRFEnergy' - Set the RF frequency (HCM energy constraint)
%              'FitRFDeltaHCM0','SetRFDeltaHCM0'                   - Set the RF frequency (Delta HCM energy constraint)
%              'FitRFDispersionOrbit','SetRFDispersionOrbit'       - Set the RF frequency (Dispersion orbit constraint)
%              'FitRFDispersionHCM','SetRFDispersionHCM'           - Set the RF frequency (Dispersion correction constraint)
%              The usual Units and Mode flags can also be used.
%              Flags are not case sensitive
%
%  OUTPUTS
%  1. OCS    - New orbit correction structure (OCS)
%  2. OCS0   - Starting OCS
%  3. V      - Corrector magnet singular vectors
%  4. Svalue - Singular values (vector)
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
%    OCS.BPM (Data structure or cell array of data structures)
%    OCS.CM  (Data structure or cell array of data structures)
%    OCS.GoalOrbit
%    OCS.NIter         - Number of correction iterations
%    OCS.NCorrections  - Number of corrections actually done
%    OCS.Tolerance     - Tolerance level to quit iterating
%    OCS.RampSteps     - Number of steps to ramp in the each correction
%    OCS.SVDIndex
%    OCS.FitRF         - Methods for RF correction
%                        1 Standard way with no constraints
%                        2 Sum of the energy change to zero Also remove the
%                          energy change due to the present corrector setpoints
%                        3 Sum of the energy change to zero
%                          remove energy change due to the incremental change in the correctors
%                        4 Constraint: dot(DispersionX,   Smat * dHCM) = 0
%                        5 Constraint: dot(HCM(Dispersion), dHCM) = 0
%    OCS.RF
%    OCS.DeltaRF
%    OCS.Display
%    OCS.Incremental   - GoalOrbit is an incremental change from the present (1) or absolute (0) {Default: 0}
%    OCS.CorrectorGain - Scales the correction (usually used in slow feedback)
%    OCS.BPMWeight     - Row    weights on the response matrix
%    OCS.CMWeight      - Column weights on the response matrix
%    OCS.Flags = {}
%
%  EXAMPLES
%  1. The default behavior us horizontal and vertical (coupled) orbit correction to the golden orbit
%     setorbit;
%     is equivalent to
%     x = getx('struct');
%     y = gety('struct');
%     hcm = getsp('HCM','struct');
%     vcm = getsp('VCM','struct');
%     setorbit('Golden', {x,y}, {hcm,vcm});
%
%  2. Horizontal orbit correction with the follow criterion:
%     a. Correct the horizontal plane to the golden orbit
%     b. 3 Iterations
%     c. Use the first 10 singular values
%     d. Display results
%
%     x = getx([1 1;1 2;12 1; 13 4],'struct');
%     hcm = getsp('HCM',[3 1;5 1;10 1],'struct');
%     setorbit('Golden', x, hcm, 3, 10, 'Display');
%
%  3. Horizontal and vertical (coupled) orbit correction to the golden orbit (display results)
%     x = getx([1 1;1 2;12 1; 13 4],'struct');
%     y = gety([1 1;1 2;12 1; 13 4],'struct');
%     hcm = getsp('HCM',[3 1;5 1;10 1],'struct');
%     vcm = getsp('VCM',[3 1;4 1;9 1;10 1],'struct');
%     setorbit('Golden', {x,y}, {hcm,vcm}, 'Display');
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
%  4. OCS0.CM.Data is the corrector strength before setorbit ran
%     OCS.CM.Data  is the corrector strength after  setorbit ran
%     Hence, DeltaCM = OCS.CM.Data - OCS0.CM.Data;
%     However, if the 'NoSetSP' flag was used, then no correction was done and
%     OCS.CM.Data=OCS0.CM.Data (ie, the present corrector strength).  To apply
%     the correction, use OCS.CM.Data + OCS.CM.Delta
%
%  See also orbitcorrectionmethods, setorbitbump, setorbitgui, rmdisp, plotcm

%  Written by Greg Portmann


% Initialize
ErrorFlag = 0;
ExtraDelay = 0;
DCCTLOW = .1;    % A minimum stored current into the machine

DefaultNIter = 1;
DefaultSVDIndex = 1e-4;
DefaultGoalOrbit = 'Golden';
DefaultFitRF = 0;
DefaultDisplay = 0;
DefaultCorrectorGain = 1;

RespFlag = 'GoldenResp';
DispFlag = 'GoldenDisp';
SetSPFlag = 1;
GetPVFlag = 1;
RF0 = [];
RF  = [];
FigHandles = [];
AxesHandles = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parsing and checking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IncrementalFlag = -1;
ModeFlag = '';
InputFlags = {};
OCSFlags = {};

% OCS init and defaults
OCS.BPM = [];
OCS.CM  = [];
OCS.GoalOrbit = DefaultGoalOrbit;
OCS.SVDIndex  = DefaultSVDIndex;
OCS.FitRF     = DefaultFitRF;
OCS.NIter     = DefaultNIter;
OCS.Display   = DefaultDisplay;
OCS.CorrectorGain = DefaultCorrectorGain;
OCS.Incremental = 0;
OCS.Tolerance = 0;
OCS.RampSteps = 1;

% First check if an OCS structure was input
OCSInputFlag = 0;
if length(varargin) >= 1
    if isstruct(varargin{1})
        if isfield(varargin{1},'BPM') && isfield(varargin{1},'CM')
            OCSInputFlag = 1;
                        
            OCSin = varargin{1};
            varargin(1) = [];

            % Copy the input OSC on top of the defaults 
            FieldCell = fieldnames(OCSin);
            for i = 1:length(FieldCell)
                OCS.(FieldCell{i}) = OCSin.(FieldCell{i});
            end
           
            % Attach the flags 
            if isfield(OCS, 'Flags')
                varargin = [varargin OCS.Flags];
            end
        end
    end
end


for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells

    elseif strcmpi(varargin{i},'Golden')
        % Use the golden orbit
        OCS.GoalOrbit = 'Golden';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Offset')
        % Use the offset orbit
        OCS.GoalOrbit = 'Offset';
        varargin(i) = [];

    elseif any(strcmpi(varargin{i},{'FitRF','SetRF','RFCorrector'}))
        %SetRFString = 'Set the RF frequency (Eta Column)';
        OCS.FitRF = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFHCM0','FitRFEnergy','SetRFHCM0','SetRFEnergy'}))
        %SetRFString = 'Set the RF frequency (HCM energy constraint)';
        OCS.FitRF = 2;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDeltaHCM0','SetRFDeltaHCM0'}))
        %SetRFString = 'Set the RF frequency (Delta HCM energy constraint)';
        OCS.FitRF = 3;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDispersionOrbit','SetRFDispersionOrbit'}))
        %SetRFString = 'Set the RF frequency (Dispersion orbit constraint)';
        OCS.FitRF = 4;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'FitRFDispersionHCM','SetRFDispersionHCM'}))
        %SetRFString = 'Set the RF frequency (Dispersion correction constraint)';
        OCS.FitRF = 5;
        varargin(i) = [];

    elseif strcmpi(varargin{i},'Display')
        OCS.Display = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay') || strcmpi(varargin{i},'No Display')
        OCS.Display = 0;
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

    elseif any(strcmpi(varargin{i},{'Inc','Incremental'}))
        OCS.Incremental = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'Abs','Absolute'}))
        OCS.Incremental = 0;
        varargin(i) = [];

    elseif any(strcmpi(varargin{i},{'SetPV','SetSP'}))
        SetSPFlag = 1;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i},{'NoSetPV','NoSetSP'}))
        SetSPFlag = 0;
        varargin(i) = [];

    elseif any(strcmpi(varargin{i},{'GetPV','GetAM'}))
        GetPVFlag = 1;
        varargin(i)   = [];
    elseif any(strcmpi(varargin{i},{'NoGetPV','NoGetAM'}))
        GetPVFlag = 0;
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model')
        ModeFlag = 'Simulator';
        %OCSFlags = [OCSFlags varargin(i)];    % Don't maintain the mode field, it must be on the input field 
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = 'Online';
        %OCSFlags = [OCSFlags varargin(i)];    % Don't maintain the mode field, it must be on the input field
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        ModeFlag = 'Manual';
        %OCSFlags = [OCSFlags varargin(i)];    % Don't maintain the mode field, it must be on the input field
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

    elseif strcmpi(varargin{i},'FigureHandles')
        OCS.Display = 1;
        FigHandles = varargin{i+1};
        if ~any(length(FigHandles) == [1 2  3 6])
            error('Figure handles must be of length 1 or 2 for figures or 3 or 6 for axes.');
        end
        varargin(i+1) = [];
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'CorrectorGain')
        OCS.CorrectorGain = varargin{i+1};
        varargin(i+1) = [];
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'Tolerance')
        OCS.Tolerance = varargin{i+1};
        varargin(i+1) = [];
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'RampSteps')
        OCS.RampSteps = varargin{i+1};
        varargin(i+1) = [];
        varargin(i)   = [];

    elseif strcmpi(varargin{i},'Archive')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Struct')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        % Just remove
        varargin(i) = [];
    end
end

OCSFlags = [OCSFlags {RespFlag} {DispFlag}];


if ~OCSInputFlag
    if iscell(varargin{1})
        if isstruct(varargin{1}{1})
            % BPM, CM
            if length(varargin) < 2
                error('Input parsing problem');
            end
            if ~iscell(varargin{1}) || ~iscell(varargin{2})
                error('When using cell arrays BPM and CM inputs must all be cell arrays');
            end
            OCS.BPM = varargin{1};
            OCS.CM = varargin{2};
            varargin(1:2) = [];
        else
            % GoalOrbit, BPM, CM
            if length(varargin) < 3
                error('Input parsing problem');
            end
            OCS.GoalOrbit = varargin{1};
            if ~iscell(varargin{2}) || ~iscell(varargin{3})
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
            OCS.BPM = family2datastruct(FamilyName, DeviceList);
        end
        OCS.CM = varargin{1};
        varargin(1) = [];
        if ischar(OCS.CM)
            FamilyName = OCS.CM;
            if length(varargin) < 1
                error('Corrector magnet device list must exist');
            end
            DeviceList = varargin{1};
            varargin(1) = [];
            OCS.CM = getsp(FamilyName, DeviceList, 'struct');
        end
    else
        if isnumeric(varargin{1})
            if length(varargin) < 3
                error('Input parsing problem: GoalOrbit, BPM, CM not all found');
            end
            OCS.GoalOrbit = varargin{1};
            varargin(1) = [];
        else
            if length(varargin) < 2
                error('Input parsing problem: BPM and/or CM not found');
            end
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
if length(varargin) >= 4
    OCS.NIter = varargin{4};
    varargin(1) = [];
end
if isempty(OCS.NIter)
    OCS.NIter = DefaultNIter;
end

% Get SVDIndex
if length(varargin) >= 5
    OCS.SVDIndex = varargin{5};
    varargin(1) = [];
end
if isempty(OCS.SVDIndex)
    OCS.SVDIndex = DefaultSVDIndex;
end


% Get BPMWeight
if length(varargin) >= 6
    OCS.BPMWeight = varargin{6};
    varargin(1) = [];
end


% Check BPM field
if isempty(OCS.BPM)
    OCS.BPM = {gethbpmfamily, getvbpmfamily};
end

% Check CM field
if isempty(OCS.CM)
    OCS.CM = {gethcmfamily,  getvcmfamily};
end


% Check the Display field
if isempty(OCS.Display)
    OCS.Display = DefaultDisplay;
end


% Check the corrector gain
if isempty(OCS.CorrectorGain)
    OCS.CorrectorGain = DefaultCorrectorGain;
end


% Check NIter
if OCS.Incremental
    if ~OCS.Display && OCS.NIter == 1
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
    NoCellBPMFlag = 1;
    OCS.BPM = {OCS.BPM};
else
    NoCellBPMFlag = 0;
end
if ~iscell(OCS.CM)
    NoCellCMFlag = 1;
    OCS.CM = {OCS.CM};
    if isfield(OCS, 'CMWeight') && ~iscell(OCS.CMWeight)
        OCS.CMWeight = {OCS.CMWeight};
    end
else
    NoCellCMFlag = 0;
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
if GetPVFlag
    OCS.RF = getrf('Struct', InputFlags{:});
end


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
        if GetPVFlag
            % Get new BPM data if not in calculate mode
            OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
        end
    end
end

% For increment changes, convert the goal orbit to an absolute orbit
if OCS.Incremental && OCS.NIter > 0
    for i = 1:length(OCS.GoalOrbit)
        OCS.GoalOrbit{i} = OCS.GoalOrbit{i} + OCS.BPM{i}.Data;
    end
    
    % The incremental flag changed to zero on exit because the orbits are absolute at this point
    OCS.Incremental = 0;
end



% Interactively select singular value
SVDquestion = 'Select Again';
MorePlotsFlag = 0;
while strcmp(SVDquestion,'Select Again')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Build the starting orbit %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(OCS.BPM)
        if OCS.NIter == 0
            % Don't use BPM data for zero interations
            OCS.BPM{i}.Data = zeros(size(OCS.BPM{i}.DeviceList,1),1);
        else
            if GetPVFlag
                % Get new BPM data if not in calculate mode
                OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
            end
        end
    end


    % Get the present setpoints
    if GetPVFlag
        OCS.CM = getpv(OCS.CM, 'Struct', InputFlags{:});
    end

    % Compute the correction
    [OCS, Smat, S, U, V] = orbitcorrectionmethods(OCS);

    % Save the starting OCS (with possible CM & BPM list changes)
    OCS0 = OCS;

    if OCS.Display  % || length(FigHandles>=3)
        [FigHandles, AxesHandles, OCS] = PreCorrectionDisplay(FigHandles, OCS0, OCS, Smat, S, U, V, NumberOfTrys, MorePlotsFlag, InputFlags);
    else
        SVDquestion = 'Correct Orbit';
    end

    if SetSPFlag && OCS.Display && length(FigHandles)<3
        Units = get(0,'units');
        if strcmpi(Units, 'Normalized')
            fprintf('   Setting the command window units to pixels since the menu command fails with normalized units.\n');
            set(0,'units','pixels');
        end
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
                if all(tmp<=size(V,2)) && ~isempty(tmp)
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
                    if ~isempty(OCS.BPMWeight{i}) && isvector(OCS.BPMWeight{i})
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


%%%%%%%%%%%%%%%%%%%%%%
% Exit if ~SetSPFlag %
%%%%%%%%%%%%%%%%%%%%%%
if ~SetSPFlag
    %% Put Delta into OCS.CM (don't do this since setorbit can be called multiple times before correcting)
    %for i = 1:length(OCS.CM)
    %    OCS.CM{i}.Data = OCS.CM{i}.Data + OCS.CM{i}.Delta;
    %end
    %if OCS.FitRF
    %    OCS.RF.Data = OCS.RF.Data + OCS.DeltaRF;
    %end

    % Remove the cell array if it was not input as a cell array
    if NoCellBPMFlag
        OCS.BPM = OCS.BPM{1};
        OCS0.BPM = OCS0.BPM{1};

        OCS.GoalOrbit = OCS.GoalOrbit{1};
        OCS0.GoalOrbit = OCS0.GoalOrbit{1};

        OCS.BPMWeight = OCS.BPMWeight{1};
        OCS0.BPMWeight = OCS0.BPMWeight{1};
    end
    if NoCellCMFlag
        OCS.CM = OCS.CM{1};
        OCS0.CM = OCS0.CM{1};

        if isfield(OCS, 'CMWeight')
            OCS.CMWeight = OCS.CMWeight{1};
            OCS0.CMWeight = OCS0.CMWeight{1};
        end
    end
    return;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterate on orbit correction %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isfield(OCS, 'MinimumPeriod')
    OCS.MinimumPeriod = 0;
end
if isempty(OCS.MinimumPeriod)
    OCS.MinimumPeriod = 0;
end

        
% Running flag
RingSetOrbit.RunFlag = 1;
setappdata(0, 'RingSetOrbit', RingSetOrbit);

OCS.NCorrections = 0;
for iloop = 1:NumberOfTrys
    tic;

    % The 1st iteration is already computed
    if iloop > 1
        % Build the new starting orbit
        for i = 1:length(OCS.BPM)
            OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
        end

        % Compute the correction
        OCS = orbitcorrectionmethods(OCS, Smat, S, U, V);
    end


    % Tolerance check
    for i = 1:length(OCS.BPM)
        TolFlag(i) = std(OCS.BPM{i}.Data(:) - OCS.GoalOrbit{i}(:)) < OCS.Tolerance;
    end
    if all(TolFlag)
        break;
    end

    
    % Put Delta into OCS.CM & OCS.RF
    for i = 1:length(OCS.CM)
        OCS.CM{i}.Data = OCS.CM{i}.Data + OCS.CorrectorGain * OCS.CM{i}.Delta;
    end
    if OCS.FitRF
        OCS.RF.Data = OCS.RF.Data + OCS.CorrectorGain * OCS.DeltaRF;
    end


    % Check corrector power supply limits
    for i = 1:length(OCS.CM)
        MinSP = minsp(OCS.CM{i});
        MaxSP = maxsp(OCS.CM{i});
        
        % Since the Max or Min sign is really arbitary, any(OCS.CM{i}.Data > MaxSP) will not work 
        % For instance, a max in hardware units can be a min in physics units.
        % It's better to check if it's between the max and min
        [Tmp, SortIndex] = sort([MinSP OCS.CM{i}.Data MaxSP],2);
        if any(SortIndex(:,2) ~= 2)
            icm = find(SortIndex(:,2) ~= 2);
            for j = 1:length(icm)
                fprintf('   Setting %s(%d,%d) to %f would exceed [%f %f] %s range.\n', OCS.CM{i}.FamilyName, OCS.CM{i}.DeviceList(icm(j),:), OCS.CM{i}.Data(icm(j)), MinSP(icm(j)), MaxSP(icm(j)), OCS.CM{i}.UnitsString);
            end
            fprintf('   Orbit correction stopped on iteration %d.\n   A power supply limit would have been exceeded!\n', iloop);
            RingSetOrbit.RunFlag = 0;
            setappdata(0, 'RingSetOrbit', RingSetOrbit);
            ErrorFlag = 1;
            break;
            %return;
        end
    end
    if ErrorFlag
        break;
    end


    %if OCS.Display
    %    if OCS.NIter > 1
    %        fprintf('   Iteration %d. Changing the correctors (%s)\n', iloop, datestr(clock, 0));
    %        if OCS.FitRF
    %            fprintf('   Iteration %d. Changing the RF frequency by %d %s\n', iloop, OCS.DeltaRF, OCS.RF.UnitsString);
    %        end
    %    else
    %        fprintf('   Setting the correctors (%s)\n', datestr(clock, 0));
    %        if OCS.FitRF
    %            fprintf('   Changing the RF frequency by %d %s (%s)\n', OCS.DeltaRF, OCS.RF.UnitsString, datestr(clock, 0));
    %        end
    %    end
    %end
    
    % Since power supplies get out of sync, it can be useful 
    % to set the power supplies in smaller steps.
    if OCS.RampSteps == 1 || iloop > 1
        % Apply correction in 1 step
        
        % Set the RF frequency
        if OCS.FitRF
            steprf(OCS.DeltaRF, -1, InputFlags{:});
        end

        % Set the correctors in one step
        setpv(OCS.CM, -2, InputFlags{:});

    else

        % Apply correction slowly
        CM  = OCS.CM;
        CM1 = getpv(OCS.CM,'Struct');
        CM2 = OCS.CM;

        if OCS.FitRF
            dRF = OCS.DeltaRF / OCS.RampSteps;
        end

        for j = 1:OCS.RampSteps
            if j == OCS.RampSteps
                WaitFlag = -2;
            else
                WaitFlag = -1;
            end
            
            if OCS.FitRF
                steprf(dRF, -1, InputFlags{:});
            end

            for i = 1:length(OCS.CM)
                CM{i}.Data = CM1{i}.Data + (CM2{i}.Data - CM1{i}.Data)*(j/OCS.RampSteps);
                setpv(CM{i}, WaitFlag, InputFlags{:});
            end
        end
    end
    

    OCS.NCorrections = iloop;            % Count the actual number of corrections made
    sleep(ExtraDelay);

        
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Build the final orbit %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(OCS.BPM)
        if OCS.NIter > 0
            OCS.BPM{i}.Data = getpv(OCS.BPM{i}, 'Numeric', InputFlags{:});
        end
    end


    % Get the present setpoints
    % Some accelerators might have digitizing errors that gets picked up with a reread
    OCS.CM = getpv(OCS.CM, 'Struct', InputFlags{:});

    if OCS.FitRF
        OCS.RF = getrf('Struct', InputFlags{:});
    end


    % Display final result if OCS.Display, more than 0 iterations, and a setpoint change was made
    %if (OCS.Display | length(FigHandles>=4)) & OCS.NIter & SetSPFlag
    if OCS.Display && OCS.NIter && SetSPFlag
        PostCorrectionDisplay(AxesHandles, OCS0, OCS, Smat, S, U, V, iloop, NumberOfTrys, MorePlotsFlag, InputFlags);
    end

    % Update timestamp
    if OCS.Display && isfield(OCS,'Handles') && isfield(OCS.Handles, 'TimeStamp') && ~isempty(OCS.Handles.TimeStamp)
        set(OCS.Handles.TimeStamp, 'String', datestr(clock,0));
        drawnow;
    end
    
    
    if iloop ~= NumberOfTrys
        % Check if another application is trying to change a setting
        [StopFlag, OCS, Smat, S, U, V, AxesHandles, MorePlotsFlag] = answersetorbitcall(OCS, Smat, S, U, V, AxesHandles, InputFlags);
        if StopFlag
            break;
        end


        % Check beam current (this might be machine dependent)
        if getdcct < DCCTLOW
            fprintf('   Orbit correction stopped on iteration %d.   Beam current is below .05 milliampere!\n', iloop);
            break;
        end

        
        % Set the minimum update period
        while toc < OCS.MinimumPeriod
            if (OCS.MinimumPeriod-toc) > .3
                sleep(.3);
            else
                sleep(OCS.MinimumPeriod - toc);
            end

            % Check for a stop request or change to the minimum update period
            [StopFlag, OCS, Smat, S, U, V, AxesHandles, MorePlotsFlag] = answersetorbitcall(OCS, Smat, S, U, V, AxesHandles, InputFlags);
            if StopFlag
                break;
            end
        end
    end
end


% Orbit correction finished
RingSetOrbit.RunFlag = 0;
setappdata(0, 'RingSetOrbit', RingSetOrbit);


% For multiple iterations put the total change in the .Delta & .DeltaRF fields
for i = 1:length(OCS.CM)
    OCS.CM{i}.Delta = OCS.CM{i}.Data - OCS0.CM{i}.Data;
end
if OCS.FitRF
    OCS.DeltaRF = OCS.RF.Data - OCS0.RF.Data;
end


% Remove the cell array if the input was not a cell
if NoCellBPMFlag
    OCS.BPM = OCS.BPM{1};
    OCS0.BPM = OCS0.BPM{1};

    OCS.GoalOrbit = OCS.GoalOrbit{1};
    OCS0.GoalOrbit = OCS0.GoalOrbit{1};

    OCS.BPMWeight = OCS.BPMWeight{1};
    OCS0.BPMWeight = OCS0.BPMWeight{1};
end
if NoCellCMFlag
    OCS.CM = OCS.CM{1};
    OCS0.CM = OCS0.CM{1};
    
    if isfield(OCS, 'CMWeight')
        OCS.CMWeight = OCS.CMWeight{1};
        OCS0.CMWeight = OCS0.CMWeight{1};
    end
end


% if OCS.Display
%     fprintf('   Orbit correction complete (%s)\n', datestr(clock, 0));
% end


%%%%%%%%%%%%%%%%%%%
% End of Setorbit %
%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ring/Answer Subroutine %
%%%%%%%%%%%%%%%%%%%%%%%%%%
function [StopFlag, OCS, Smat, S, U, V, FigureHandles, MorePlotsFlag] = answersetorbitcall(OCS, Smat, S, U, V, FigureHandles, InputFlags)

StopFlag = 0;
MorePlotsFlag = 0;
RingSetOrbit = getappdata(0, 'RingSetOrbit');

if ~isempty(RingSetOrbit)

    if isfield(RingSetOrbit, 'RunFlag')
        if RingSetOrbit.RunFlag == -1
            StopFlag = 1;
        end
        %RingSetOrbit = rmfield(RingSetOrbit, 'RunFlag');
        %setappdata(0, 'RingSetOrbit', RingSetOrbit);
    end

    if isfield(RingSetOrbit, 'MinimumPeriod')
        OCS.MinimumPeriod = RingSetOrbit.MinimumPeriod;
        if isempty(OCS.MinimumPeriod)
            OCS.MinimumPeriod = 0;
        end
        RingSetOrbit = rmfield(RingSetOrbit, 'MinimumPeriod');
        setappdata(0, 'RingSetOrbit', RingSetOrbit);
    end

    if isfield(RingSetOrbit, 'Display')
        OCS.Display = RingSetOrbit.Display;
        RingSetOrbit = rmfield(RingSetOrbit, 'Display');
        setappdata(0, 'RingSetOrbit', RingSetOrbit);
    end

    if isfield(RingSetOrbit, 'CorrectorGain')
        OCS.CorrectorGain = RingSetOrbit.CorrectorGain;
        RingSetOrbit = rmfield(RingSetOrbit, 'CorrectorGain');
        setappdata(0, 'RingSetOrbit', RingSetOrbit);
    end

    if isfield(RingSetOrbit, 'FigureHandles')
        FigureHandles = RingSetOrbit.FigureHandles;
        RingSetOrbit = rmfield(RingSetOrbit, 'FigureHandles');
        setappdata(0, 'RingSetOrbit', RingSetOrbit);

        if length(FigureHandles) == 6
            drawmoreplots(FigureHandles(4:6), OCS, Smat, S, U, V);
            %MorePlotsFlag = 1;
        end
    end


    if isfield(RingSetOrbit, 'FitRF')
        OCS.FitRF = RingSetOrbit.FitRF;
        RingSetOrbit = rmfield(RingSetOrbit, 'FitRF');
        setappdata(0, 'RingSetOrbit', RingSetOrbit);
        
        if OCS.FitRF == 1
            % Include the RF frequency next time
            OCS.RF = getrf('Struct', InputFlags{:});
            [OCS, Smat, S, U, V] = orbitcorrectionmethods(OCS);  % Get new S, U, V matrices
        else
            % Don't include the RF frequency next time
            OCS.FitRF = 0;
            [OCS, Smat, S, U, V] = orbitcorrectionmethods(OCS);  % Get new S, U, V matrices
        end
    end
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Pre-correction display %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [H, Haxis, OCS] = PreCorrectionDisplay(H, OCS0, OCS, Smat, S, U, V, NumberOfTrys, MorePlotsFlag, InputFlags)

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

if isempty(H)
    HCF = get(0, 'CurrentFigure');
    if isempty(HCF)
        H = [gcf; NaN];
    else
        if rem(HCF,1)==0
            H = [HCF(1); NaN];
        else
            H = [figure; NaN];
        end
    end
    %drawnow
    subfig(2,2,2, H(1));
    p = get(H(1), 'Position');
    set(H(1), 'Position', [p(1) p(2)-.8*p(4) p(3) p(4)+.8*p(4)]);
end


if length(H) < 3
    figure(H(1));
    clf reset
    Haxis(1) = subplot(3,1,1);
    Haxis(2) = subplot(3,1,2);
    Haxis(3) = subplot(3,1,3);
    yaxesposition(1.05);
    orient portrait
else
    Haxis = H;
end


ColorOrderMat = get(gca,'ColorOrder');


%%%%%%%%%%%%%%%%%%%%%%%
% Change in corrector %
%%%%%%%%%%%%%%%%%%%%%%%
axes(Haxis(1));
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
    h_legend = legend(LabelCell4);
    set(h_legend, 'FontSize', 8);
    set(h_legend, 'UserData', 'Axes1');
end

%if NumberOfTrys == 1
if OCS.FitRF
    title({sprintf('\\DeltaRF = %g %s   SV[%d out of %d]', OCS.DeltaRF, OCS.RF.UnitsString, max(OCS.SVDIndex), length(S)), 'Pre-Orbit Correction'});
else
    title({sprintf('SV[%d out of %d]', max(OCS.SVDIndex), length(S)), 'Pre-Orbit Correction'});
end

%xlabel('Position [Meters]');
xaxis([0 L]);
%set(gca,'XTickLabel','');



%%%%%%%%%%%%%%%%%%%%
% Plot Orbit Error %
%%%%%%%%%%%%%%%%%%%%
axes(Haxis(2));
for i = 1:length(OCS.BPM)
    BPMpos = getspos(OCS.BPM{i});
    [BPMpos, isort] = sort(BPMpos);
    plot(BPMpos, OCS.BPM{i}.Data(isort) - OCS.GoalOrbit{i}(isort),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    hold on;
    LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
end
hold off
if length(LabelCell2) == 1
    ylabel(sprintf('%s Starting Error [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
else
    ylabel('Starting Orbit Error');
    h_legend = legend(LabelCell2);
    set(h_legend, 'FontSize', 8);
    set(h_legend, 'UserData', 'Axes2');
end
%title(sprintf('Orbit Error Before Correction (Iteration 1 of %d)', NumberOfTrys));
%xlabel('Position [Meters]');
xaxis([0 L]);
%set(gca,'XTickLabel','');



%%%%%%%%%%%%%%%%%%%%%%
% Predicted Residual %
%%%%%%%%%%%%%%%%%%%%%%
axes(Haxis(3));

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
    h_legend = legend(LabelCell2);
    set(h_legend, 'FontSize', 8);
    set(h_legend, 'UserData', 'Axes3');
end
%title('Predicted Orbit Residual (by the Response Matrix)');
xlabel('Position [Meters]');
xaxis([0 L]);


% Add TimeStamp labels
if length(H) < 3
    OCS.Handles.TimeStamp = addlabel(1, 0, datestr(OCS.BPM{1}.TimeStamp,0));

    %if OCS.FitRF
    %    OCS.Handles.RF = addlabel(0, 0, sprintf('RF frequency will be changed by  %g %s', OCS.DeltaRF, OCS.RF.UnitsString));
    %end
end




if MorePlotsFlag || length(H)==6

    %%%%%%%%%%%%%%%%
    % 3 More Plots %
    %%%%%%%%%%%%%%%%

    if length(H) < 3
        if isnan(H(2))
            H(2) = H(1) + 1;
            subfig(2,2,1,H(2));
            p = get(H(2), 'Position');
            set(H(2), 'Position', [p(1) p(2)-.8*p(4) p(3) p(4)+.8*p(4)]);
            p = get(H(2), 'Position');
            set(H(2), 'Position', [p(1)+.2*p(3) p(2) p(3)-.1*p(3) p(4)]);

            p = get(H(1), 'Position');
            set(H(1), 'Position', [p(1)+.1*p(3) p(2) p(3)-.1*p(3) p(4)]);
        end

        figure(H(2));
        clf reset

        Haxis(4) = subplot(3,1,1);
        Haxis(5) = subplot(3,1,2);
        Haxis(6) = subplot(3,1,3);
        yaxesposition(1.05);
        orient portrait
    end

    drawmoreplots(Haxis(4:6), OCS, Smat, S, U, V);
end

drawnow;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  End pre-correction display  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function drawmoreplots(Haxis, OCS, Smat, S, U, V)


%%%%%%%%%%%%%%%%
% 3 More Plots %
%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Orbit Error & CM strength vs SVD Number %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Print wait messege
%plot([0 1],[0 1],'w');
%UnitsString = get(gca,'units');
%set(gca,'units','characters');
%p = get(gca,'Position');
%set(gca,'XTick',[]); set(gca,'YTick',[]); cla; title(' '); xlabel(' '); ylabel(' ');
%set(gca,'box','on');
%Top = floor(p(4));
%
%text(4,Top-4,sprintf('Please wait ...'),'units','characters');
%text(4,Top-6,sprintf('Computing correction performance'),'units','characters');
%text(4,Top-7,sprintf('   as a function of singular value number.'),'units','characters');
%set(gca, 'units', UnitsString);
%drawnow;


% The total kick as a function of SV
hbar = waitbar(0, 'Computing Orbit Change vs SVD#.  Please wait ...');
warning off;
LastGoodSvalue = 1;
OCStmp = OCS;
N = length(S);
for i = 1:N
    lastwarn('');
    waitbar(i/N);

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


        % S-mat prediction residual: PredictedOrbitData + Error
        BPMresidual(j,i) = std(OCStmp.BPM{j}.PredictedOrbitDelta + (OCStmp.BPM{j}.Data-OCStmp.GoalOrbit{j}));
    end

    if isempty(lastwarn)
        LastGoodSvalue = i;
        DeltaRFvec(i,1) = OCStmp.DeltaRF;
    else
        DeltaRFvec(i,1) = NaN;
        %fprintf('\n   S-value number %d warning: %s', i, lastwarn);
    end
end
try
    close(hbar);
catch
end


warning on;
if LastGoodSvalue ~= length(S)
    fprintf('   Computational warning for choosing singular values above %d. \n', LastGoodSvalue);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CM strength vs SVD number %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iSVDremove = 1:length(S);
[tmp1, tmp2, i] = intersect(OCS.SVDIndex, iSVDremove);
iSVDremove(i) = [];

for i = 1:length(OCS.CM)
    LabelCellCM{i} = sprintf('%s [%s]', OCS.CM{i}.FamilyName, OCS.CM{i}.UnitsString);
end
if OCS.FitRF
    %(Haxis(1));
    [ax, h1, h2] = plotyy(Haxis(1), 1:length(S), CMTotal, 1:length(S), DeltaRFvec, @plot, @plot);
    set(get(ax(2),'Ylabel'),'String',sprintf('\\DeltaRF Frequency [%s]', OCS.RF.UnitsString), 'Color',[.5 0 0]);
    set(h1,'LineStyle','-');
    set(h1,'Marker','.');
    set(h1,'MarkerSize',6);
    set(h2,'LineStyle','-');
    set(h2,'Color',[.5 0 0]);
    set(ax(2),'YColor',[.5 0 0]);
    set(h2,'Marker','.');
    set(h2,'MarkerSize',6);
    %set(get(ax(1),'XLabel'),'String', 'Singular Value Number');
    %set(get(ax(1),'Title'), 'String', 'Total Kick Strength');

    set(ax(1),'XLim', [0 length(S)]);
    set(ax(2),'XLim', [0 length(S)]);

    set(get(ax(1),'XLabel'),'String', '');
    set(get(ax(2),'XLabel'),'String', '');
    %set(ax(1),'XTickLabel', '');
    %set(ax(2),'XTickLabel', '');

    set(get(ax(1),'title'),'string', {'Performance vs. Number of Singular Values',sprintf('Based on %s Orbit',datestr(OCS.BPM{1}.TimeStamp,0))});

    if length(LabelCellCM) == 1
        set(get(ax(1),'YLabel'),'String',sprintf('\\Sigma \\mid%s\\mid [%s]', OCS.CM{1}.FamilyName, OCS.CM{1}.UnitsString));
    else
        set(get(ax(1),'YLabel'),'String',sprintf('\\Sigma \\midCM\\mid'));
        %h_legend = legend(Haxis(1), LabelCellCM, 'Location', 'Best');
        %set(h_legend, 'FontSize', 8);
        %set(h_legend, 'UserData', 'Axes4');
        AxePosition = get(ax(2),'Position');
        set(ax(1),'Position', AxePosition);
    end
else
    %semilogy(1:length(S), CMTotal, '.-');
    plot(Haxis(1), 1:length(S), CMTotal, '-');
    hold(Haxis(1), 'on');
    plot(Haxis(1), OCS.SVDIndex, CMTotal(:,OCS.SVDIndex), 's', 'markersize',2);
    plot(Haxis(1), iSVDremove,   CMTotal(:,iSVDremove),   'sr','markersize',2);
    hold(Haxis(1), 'off');

    if length(LabelCellCM) == 1
        ylabel(Haxis(1), sprintf('\\Sigma \\mid%s\\mid [%s]', OCS.CM{1}.FamilyName, OCS.CM{1}.UnitsString));
    else
        ylabel(Haxis(1), '\Sigma \midCM\mid');
        %h_legend = legend(Haxis(1), LabelCellCM, 'Location', 'Best');
        %set(h_legend, 'FontSize', 8);
        %set(h_legend, 'UserData', 'Axes4');
    end
    %xlabel(Haxis(1), 'Singular Value Number');
    title(Haxis(1), {'Performance vs. Number of Singular Values',sprintf('Based on %s Orbit',datestr(OCS.BPM{1}.TimeStamp,0))});
    
    axis(Haxis(1), 'tight');
    a = axis(Haxis(1));
    axis(Haxis(1), [0 length(S) a(3:4)]);
    %set(gca,'XTickLabel','');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Orbit Error vs SVD Number %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%axes(Haxis(2));
ColorOrderMat = get(Haxis(2),'ColorOrder');
for i = 1:length(OCS.BPM)
    %BPMpos = getspos(OCS.BPM{i});
    %semilogy(1:length(S), CMSTDvec{i},'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    plot(Haxis(2), 1:length(S), BPMresidual(i,:),'-', 'Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    hold(Haxis(2), 'on');
    plot(Haxis(2), OCS.SVDIndex, BPMresidual(i,OCS.SVDIndex), 's', 'markersize',2, 'Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    plot(Haxis(2), iSVDremove,   BPMresidual(i,iSVDremove),   'sr','markersize',2);
   
    LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
end
hold(Haxis(2), 'off');
if length(LabelCell2) == 1
    ylabel(Haxis(2), sprintf('STD %s [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
else
    ylabel(Haxis(2), 'std(Residual)');
    %h_legend = legend(Haxis(2), LabelCell2, 'Location', 'Best');
    %set(h_legend, 'FontSize', 8);
    %set(h_legend, 'UserData', 'Axes5');
end
%title(Haxis(2), 'Standard Deviation of the Predicted Orbit Residual');
%xlabel(Haxis(2), 'Singular Value Number');

axis(Haxis(2), 'tight');
a = axis(Haxis(2));
axis(Haxis(2), [0 length(S) a(3:4)]);
%set(gca,'XTickLabel','');


%%%%%%%%%%%%%%%%%%%%%%%%
% Plot singular values %
%%%%%%%%%%%%%%%%%%%%%%%%
axes(Haxis(3));
semilogy(Haxis(3), S, '-b');
hold(Haxis(3), 'on');
semilogy(Haxis(3), OCS.SVDIndex, S(OCS.SVDIndex), 'sb', 'markersize',2);
semilogy(Haxis(3), iSVDremove,   S(iSVDremove),   'sr', 'markersize',2);
hold(Haxis(3), 'off');
ylabel(Haxis(3), 'Magnitude');
xlabel(Haxis(3), 'Singular Value Number');
axis(Haxis(3), 'tight');
a = axis(Haxis(3));
axis(Haxis(3), [0 length(S) a(3:4)]);

drawnow;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Post-correction display  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PostCorrectionDisplay(H, OCS0, OCS, Smat, S, U, V, Iteration, NumberOfTrys, MorePlotsFlag, InputFlags)

ColorOrderMat = get(gca,'ColorOrder');

% Build the orbit vectors
StartOrbitVec = [];
Orbit0Vec = [];
GoalOrbitVec = [];
OrbitNewVec = [];
%BPMWeight = [];
for i = 1:length(OCS.BPM)
    StartOrbitVec = [StartOrbitVec; OCS.BPM{i}.Data];
    Orbit0Vec     = [Orbit0Vec;     OCS.BPM{i}.Data];
    GoalOrbitVec  = [GoalOrbitVec;  OCS.GoalOrbit{i}];

    %OCS.BPM{i} = getpv(OCS.BPM{i}, 'Struct', InputFlags{:});
    OrbitNewVec = [OrbitNewVec; OCS.BPM{i}.Data];

    %if isempty(OCS.BPMWeight{i})
    %    BPMWeight = [BPMWeight; ones(length(OCS.BPM{i}.Data),1)];
    %else
    %    BPMWeight = [BPMWeight; OCS.BPMWeight{i}(:)];
    %end
end

L = getfamilydata('Circumference');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot cumulative change in the corrector %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(H(1), 'YLimMode', 'Auto');
hline = get(H(1), 'Children');
for i = 1:length(OCS.CM)
    CMpos = getspos(OCS.CM{i});
    [CMpos, isort] = sort(CMpos);
    set(hline(end-i+1), 'YData', OCS.CM{i}.Data(isort)-OCS0.CM{i}.Data(isort));
end
if length(OCS.CM) == 1
    set(get(H(1),'YLabel'), 'String', sprintf('\\Delta %s [%s]', OCS.CM{1}.FamilyName, OCS.CM{1}.UnitsString));
else
    set(get(H(1),'YLabel'), 'String', '\Delta Corrector');
end

if NumberOfTrys == 1
    if OCS.FitRF
        DeltaRF = OCS.RF.Data - OCS0.RF.Data;
        TitleString = {sprintf('\\DeltaRF = %g %s   SV[%d out of %d]', DeltaRF, OCS.RF.UnitsString, max(OCS.SVDIndex), length(S)), 'Post-Orbit Correction'};
    else
        TitleString = {sprintf('SV[%d out of %d]', max(OCS.SVDIndex), length(S)), 'Post-Orbit Correction'};
    end
else
    if OCS.FitRF
        DeltaRF = OCS.RF.Data - OCS0.RF.Data;
        TitleString = {...
            sprintf('\\DeltaRF = %g %s    SV[%d out of %d]', DeltaRF, OCS.RF.UnitsString, max(OCS.SVDIndex), length(S)), ...
            sprintf('Iteration %d of %d', Iteration, NumberOfTrys)};
    else
        TitleString = {...
            sprintf('SV[%d out of %d]', max(OCS.SVDIndex), length(S)), ...
            sprintf('Iteration %d of %d', Iteration, NumberOfTrys)};
    end
end
set(get(H(1),'Title'), 'String', TitleString);

%set(gca,'XTickLabel','');



%%%%%%%%%%%%%%%%%%%%
% Plot Orbit Error %
%%%%%%%%%%%%%%%%%%%%
set(H(3), 'YLimMode', 'Auto');
hline = get(H(3), 'Children');
for i = 1:length(OCS.BPM)
    BPMpos = getspos(OCS.BPM{i});
    [BPMpos,isort] = sort(BPMpos);
    %plot(BPMpos, OCS.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
    set(hline(end-i+1), 'YData', OCS.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort));
end
if length(OCS.BPM) == 1
    set(get(H(3),'YLabel'), 'String', sprintf('%s Remaining Error [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
else
    set(get(H(3),'YLabel'), 'String', 'Remaining Orbit Error');
end


% if OCS.FitRF
%     set(OCS.Handles.RF, 'String', sprintf(' RF frequency was changed by  %g %s', OCS.DeltaRF, OCS.RF.UnitsString));
% end


drawnow;





% % Plot Orbit Error
%
% The problem here is the orbit gets updated but .PredictedOrbitDelta does not
%
% axes(H(3));
%
% ColorOrderMat = get(gca,'ColorOrder');
% for i = 1:length(OCS.BPM)
%     BPMpos = getspos(OCS.BPM{i});
%     [BPMpos, isort] = sort(BPMpos);
%
%     % S-mat prediction: OrbitDelta + Error
%     plot(BPMpos, OCS.BPM{i}.PredictedOrbitDelta(isort) + (OCS.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort)),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%     hold on;
%     LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
% end
% hold off
% if length(LabelCell2) == 1
%     ylabel(sprintf('%s Residual [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
% else
%     ylabel('Orbit Residual');
%     h_legend = legend(LabelCell2, 'Location', 'Best');
%     set(h_legend, 'FontSize', 8);
% end
% title('Predicted Orbit Residual (by the Response Matrix)');
% xlabel('Position [Meters]');
% xaxis([0 L]);
% set(gca,'XTickLabel','');



% %%%%%%%%%%%%%%%%%%%%%%
% % Predicted Residual %
% %%%%%%%%%%%%%%%%%%%%%%
% if length(H) < 3
%     figure(H(1));
%     subplot(3,1,3);
% else
%     axes(H(3));
% end
% for i = 1:length(OCS.BPM)
%     BPMpos = getspos(OCS.BPM{i});
%     [BPMpos, isort] = sort(BPMpos);
%
%     % S-mat prediction: OrbitDelta + Error
%     plot(BPMpos, OCS.BPM{i}.PredictedOrbitDelta(isort) + (OCS.BPM{i}.Data(isort)-OCS.GoalOrbit{i}(isort)),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%     hold on;
%     LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
% end
% hold off
% if length(LabelCell2) == 1
%     ylabel(sprintf('%s Residual [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
% else
%     ylabel('Orbit Residual');
%     h_legend = legend(LabelCell2, 'Location', 'Best');
%     set(h_legend, 'FontSize', 8);
% end
% %title('Predicted Orbit Residual (by the Response Matrix)');
% xlabel('Position [Meters]');
% xaxis([0 L]);



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
%     h_legend = legend(LabelCell2, 'Location', 'Best');
%     set(h_legend, 'FontSize', 8);
% end
% title('Predicted Orbit Residual (by the Response Matrix)');
% xlabel('Position [Meters]');
% xaxis([0 L]);












%     %%%%%%%%%%%%%%%%%%%%%
%     % Model predictions %
%     %%%%%%%%%%%%%%%%%%%%%
%     % %[Orbit0ModelX, Orbit0ModelY, Xpos, Ypos] = modeltwiss('x', 'All');
%     % for i = 1:length(OCS.BPM)
%     %     OCS0Model.BPM{i} = getpv(OCS.BPM{i},'Model');
%     % end
%     %
%     % % Step the model
%     % for i = 1:length(OCS.CM)
%     %     steppv(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, OCS.CM{i}.Delta, OCS.CM{i}.DeviceList, 'Model', InputFlags{:});
%     % end
%     % if OCS.FitRF
%     %     stepsp('RF', OCS.DeltaRF, 'Model');
%     % end
%     %
%     % %[OrbitModelX, OrbitModelY] = modeltwiss('x', 'All');
%     % for i = 1:length(OCS.BPM)
%     %     OCSModel.BPM{i} = getpv(OCS.BPM{i},'Model');
%     % end
%     %
%     % % Step the model back
%     % for i = 1:length(OCS.CM)
%     %     steppv(OCS.CM{i}.FamilyName, OCS.CM{i}.Field, -1*OCS.CM{i}.Delta, OCS.CM{i}.DeviceList, 'Model', InputFlags{:});
%     % end
%     % if OCS.FitRF
%     %     stepsp('RF', -OCS.DeltaRF, 'Model');
%     % end
%     %
%     %
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % % Plot Orbit Residue based on the AT model %
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % axes(Haxis(7));
%     % ColorOrderMat = get(gca,'ColorOrder');
%     % for i = 1:length(OCS.BPM)
%     %     BPMpos = getspos(OCS.BPM{i});
%     %     [BPMpos,isort] = sort(BPMpos);
%     %
%     %     % Model prediction Error
%     %     plot(BPMpos, (OCSModel.BPM{i}.Data(isort)-OCS0Model.BPM{i}.Data(isort)) - (OCS.GoalOrbit{i}(isort)-OCS.BPM{i}.Data(isort)),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%     %
%     %     % S-mat prediction
%     %     %    plot(BPMpos, (OCS0.BPM{i}.Data-OCS.GoalOrbit{i}) + (BPMSVDDeltaCell{i}),':','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%     %     hold on;
%     %     LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
%     % end
%     % hold off
%     % if length(LabelCell2) == 1
%     %     ylabel(sprintf('%s Residual [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
%     % else
%     %     ylabel('Orbit Residual');
%     %     h_legend = legend(LabelCell2, 'Location', 'Best');
%     %     set(h_legend, 'FontSize', 8);
%     % end
%     % title('Predicted Orbit Residual (by the Nonlinear AT Model)');
%     % xlabel('Position [Meters]');
%     % xaxis([0 L]);
%     %
%     %
%     % % Linearization Error
%     % if length(H) < 4
%     %     figure(H(2));
%     %     subplot(4,1,4);
%     % else
%     %     axes(H(8));
%     % end
%     % ColorOrderMat = get(gca,'ColorOrder');
%     % for i = 1:length(OCS.BPM)
%     %     BPMpos = getspos(OCS.BPM{i});
%     %     [BPMpos,isort] = sort(BPMpos);
%     %
%     %     % Model - S-matrix prediction
%     %     plot(BPMpos, (OCSModel.BPM{i}.Data(isort)-OCS0Model.BPM{i}.Data(isort)) - OCS.BPM{i}.PredictedOrbitDelta(isort),'.-','Color', ColorOrderMat(mod(i,size(ColorOrderMat,1)),:));
%     %     hold on;
%     %     LabelCell2{i} = sprintf('%s [%s]', OCS.BPM{i}.FamilyName, OCS.BPM{i}.UnitsString);
%     % end
%     % hold off
%     % if length(LabelCell2) == 1
%     %     %ylabel(sprintf('%s Linearization Error [%s]', OCS.BPM{1}.FamilyName, OCS.BPM{1}.UnitsString));
%     %     ylabel(sprintf('Linearization Error [%s]', OCS.BPM{1}.UnitsString));
%     % else
%     %     ylabel('Linearization Error');
%     %     h_legend = legend(LabelCell2, 'Location', 'Best');
%     %     set(h_legend, 'FontSize', 8);
%     % end
%     % title('Predicted Orbit Change Error (AT Model - Response Matrix)');
%     % xlabel('Position [Meters]');
%     % xaxis([0 L]);