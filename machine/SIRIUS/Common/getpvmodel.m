function [AM, tout, DataTime, ErrorFlag] = getpvmodel(varargin)
%GETPVMODEL - Get the model value
%  [Value, tout, DataTime, ErrorFlag] = getpvmodel(Family, Field, DeviceList, t)
%  [Value, tout, DataTime, ErrorFlag] = getpvmodel(Family, DeviceList, t)
%  [Value, tout, DataTime, ErrorFlag] = getpvmodel(DataStructure, t)
%
%  INPUTS
%  1. Family - Family Name
%              Data Structure
%              Accelerator Object
%              AT family name (or 'All' for every AT element)
%              'DCCT', 'TUNE', 'Energy'
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%             AT field name
%                 or
%             'K','Quad','Quadrupole'
%             'K2','Sext','Sextupole'
%             'K3','Octupole'
%             'KS1','SkewQuad','Skew'
%             'Roll' or 'Tilt' - for a magnet rolls
%             'RollX' or 'TiltX' and 'RollY' or 'TiltY' - for corrector magnet rolls
%             'DX' or 'XShift' - for a magnet shift (see setshift)
%             'ClosedOrbit' - [x Px y Py dP dL] (dL is only calculated if the cavity is on)
%
%             'xTurns', 'PxTurns', 'yTurns', 'PyTurns', dpTurns', 'dLTurns' (single turn data) ("BPM" Number x N turns)
%             'FirstTurn' or 'LinePass' - 6-dimensional first turn (single pass)
%             'Turns' - 3 dimensional matrix (BPM Number x N turns x 6)
%             Note: Units can only be 'Physics' for these field types.  'xTurns' or 'yTurns' can
%                   be converted to 'Hardware' units by calling physics2hw as a separate call.
%             Note: getpvmodel('TwissData','ClosedOrbit') - Gets the 6-dim start condition at the first AT element 
%                   getpvmodel('TwissData', Field) - Gets the TwissData.(Field) twiss parameters at the first AT element
%
%  3. DeviceList ([Sector Device #] or [element #]) {Default: Entire family}
%  4. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)  {Default: Hardware}
%  5. 'Struct' will return a data structure {Default for data structure inputs}
%     'Numeric' will return numeric outputs {Default for non-data structure inputs}
%
%  OUTPUTS
%  1. Value - Model value
%  2. tout - Time it took to compute the output [seconds]
%  3. DataTime - Time (in seconds) since  00:00:00, Jan 1, 1970
%                 (seconds + milliseconds * i)
%  4. ErrorFlag
%
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays
%
%  See also getpv, setpvmodel

%  Written by Greg Portmann


global THERING THERINGCELL

const = lnls_constants;

ErrorFlag = 0;

% Input parsing
StructOutputFlag = 0;
NumericOutputFlag = 0;
UnitsFlag = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        NumericOutputFlag = 1;
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlag = {'Physics'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = {'Hardware'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'archive')
        % Just remove
        varargin(i) = [];
    elseif strcmpi(varargin{i},'noarchive')
        % Just remove
        varargin(i) = [];
    end
end

if isempty(varargin)
    error('Must have at least a family name input');
else
    Family = varargin{1};
    if length(varargin) >= 2
        Field = varargin{2};
    end
    if length(varargin) >= 3
        DeviceList = varargin{3};
    end
    if length(varargin) >= 4
        t = varargin{4};
    else
        t = 0;
    end
end


%%%%%%%%%%%%%%%%%%%%%
% Cell Array Inputs %
%%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if length(varargin) < 2
            [AM{i}, tout{i}, DataTime{i}, ErrorFlag{i}] = getpvmodel(Family{i}, UnitsFlag{:});
        elseif length(varargin) < 3
            if iscell(Field)
                [AM{i}, tout{i}, DataTime{i}, ErrorFlag{i}] = getpvmodel(Family{i}, Field{i}, UnitsFlag{:});
            else
                [AM{i}, tout{i}, DataTime{i}, ErrorFlag{i}] = getpvmodel(Family{i}, Field, UnitsFlag{:});
            end
        else
            if iscell(Field)
                if iscell(DeviceList)
                    [AM{i}, tout{i}, DataTime{i}, ErrorFlag{i}] = getpvmodel(Family{i}, Field{i}, DeviceList{i}, UnitsFlag{:}, t);
                else
                    [AM{i}, tout{i}, DataTime{i}, ErrorFlag{i}] = getpvmodel(Family{i}, Field{i}, DeviceList, UnitsFlag{:}, t);
                end
            else
                if iscell(DeviceList)
                    [AM{i}, tout{i}, DataTime{i}, ErrorFlag{i}] = getpvmodel(Family{i}, Field, DeviceList{i}, UnitsFlag{:}, t);
                else
                    [AM{i}, tout{i}, DataTime{i}, ErrorFlag{i}] = getpvmodel(Family{i}, Field, DeviceList, UnitsFlag{:}, t);
                end
            end
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isstruct(Family)
    % Only change StructOutputFlag if 'numeric' is not on the input line
    if ~NumericOutputFlag
        StructOutputFlag = 1;
    end

    % Data structure inputs
    Field = '';
    if length(varargin) >= 2
        % Look for t as the second input
        if isnumeric(varargin{2})
            t = varargin{2};
        else
            Field = varargin{2};
        end
    end
    if length(varargin) >= 3
        DeviceList =  varargin{3};
    else
        DeviceList = [];
    end
    if length(varargin) >= 4
        t =  varargin{4};
    end
    if isfield(Family,'FamilyName')
        Family = Family.FamilyName;
    else
        error('For data structure inputs FamilyName field must exist')
    end
    if isempty(Field)
        if isfield(Family,'Field')
            Field = Family.Field;
        end
    end
    if isempty(DeviceList)
        if isfield(Family,'DeviceList')
            DeviceList = Family.DeviceList;
        end
    end
    if isempty(UnitsFlag)
        if isfield(Family,'Units')
            UnitsFlag{1} = Family.Units;
        end
    end
else
    % Family string input
    if length(varargin) < 2
        Field = '';
    end
    if length(varargin) < 3
        DeviceList = [];
    end
    if isnumeric(Field)
        if length(varargin) >= 3
            t = DeviceList;
        end
        DeviceList = Field;
        Field = '';
    end
end

if isempty(Field)
    Field = 'Monitor';
end
if isempty(DeviceList)
    if isfamily(Family)
        DeviceList = family2dev(Family);
    end
else
    if isfamily(Family)
        if (size(DeviceList,2) == 1)
            DeviceList = elem2dev(Family, DeviceList);
        end
    end
end

if isempty(UnitsFlag)
    UnitsFlag = 'Hardware';
else
    UnitsFlag = UnitsFlag{1};
end


% Look to see it the AT model needs to be changed for this family
ATModelNumber = getfamilydata(Family, 'AT', 'ATModel');
if ~isempty(ATModelNumber)
    % Change THERING
    THERING = THERINGCELL{ATModelNumber};

    % Set AD.Circumference
    setfamilydata(findspos(THERING,length(THERING)+1), 'Circumference');
    
    if isfield(THERING{1}, 'MachineType')
        setfamilydata(THERING{1}.MachineType, 'MachineType');
    end
    if isfield(THERING{1}, 'Energy')
        setfamilydata(THERING{1}.Energy, 'Energy');
    end
    if isfield(THERING{1}, 'InjectionEnergy')
        setfamilydata(THERING{1}.InjectionEnergy, 'InjectionEnergy');
    end
    if isfield(THERING{1}, 'MCF')
        setfamilydata(THERING{1}.MCF, 'MCF');
    else
        % Recompute the MCF if it's likely if a new accelerator
        %try
        %    setfamilydata(getmcf('Model'), 'MCF');
        %catch
        %end
    end
end


% Simulator (AT)
if isempty(THERING)
    error('Simulator variable is not setup properly.');
end


t0 = gettime;

%%%%%%%%%%%%
% Get Data %
%%%%%%%%%%%%

% Families that do not require at AT field
if strcmp(Family, 'TUNE')
    AM = [modeltune; 0];
    elems = dev2elem('TUNE',DeviceList);
    AM = AM(elems);

    % Add random errors
    %AM = Tune1' + rand(2,1)*.0001;

elseif strcmp(Family, 'RF')
    
    if strcmpi(Field, 'OpMode')
        AM = 2;
    else
        iCavity = findcells(THERING,'Frequency');
        if isempty(iCavity)
            [HarmNumber, AM] = getharmonicnumber;
            AM = AM * 1e6;
        else
            AM = THERING{iCavity(1)}.Frequency;
        end
    end
    
elseif strcmpi(Family, 'DCCT')

    % 18 hour lifetime, refill at 7 am to 250 mAmps
    life_time = 18;
    
    a = clock;
    if (a(4)<=7)
        hora = a(4)+a(5)/60+a(6)/3600 + 5;
    elseif (a(4) <= 19)
        hora = a(4)+a(5)/60+a(6)/3600 - 7;
    else
        hora = a(4)+a(5)/60+a(6)/3600 - 19;
    end
   
    AM = 250 * exp(-hora/life_time);
    
elseif any(strcmpi(Family,{'Energy','GeV'}))
    
    AM = getenergymodel;
    Family = 'GeV';  % Just so hw2physics works (ALS)
    
elseif strcmp(Family, 'TwissData')
    
    if isfield(THERING{1}, 'TwissData')
        TwissData = THERING{1}.TwissData;
    else
        TwissData = getfamilydata('TwissData');
    end
    
    if any(strcmpi(Field, {'xTurns','PxTurns','yTurns','PyTurns','dPTurns','dLTurns'}))
        if ~isfield(TwissData, 'ClosedOrbit')
            error('ClosedOrbit twiss parameter not found.');
        end
        if strcmpi(Field, 'xTurns')
            AM = TwissData.ClosedOrbit(1);
        elseif strcmpi(Field, 'PxTurns')
            AM = TwissData.ClosedOrbit(2);
        elseif strcmpi(Field, 'yTurns')
            AM = TwissData.ClosedOrbit(3);
        elseif strcmpi(Field, 'PyTurns')
            AM = TwissData.ClosedOrbit(4);
        elseif strcmpi(Field, 'dPTurns')
            AM = TwissData.dP;
        elseif strcmpi(Field, 'dLTurns')
            AM = TwissData.dL;
        end
    else
        if nargin == 1
            AM = TwissData;
        else
            AM = TwissData.(Field);
        end
    end
    return;
    
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Families that require an AT field %
    %%%%%%%%%%%%%%%%%%%%%%\%%%%%%%%%%%%%%%

    % Find the index for where the desired data is in the total device list
    if isfamily(Family)
        DeviceListTotal = family2dev(Family, 0);
        [DeviceIndex, iNotFound] = findrowindex(DeviceList, DeviceListTotal);
        if ~isempty(iNotFound)
            % Device not found
            for i = 1:length(iNotFound)
                fprintf('   No devices to get for Family %s(%d,%d)\n', Family, DeviceList(i,1), DeviceList(i,2));
            end
            error(sprintf('%d Devices not found', length(iNotFound)));
        end
        
        % Find the AT structure if it exists
        AT = getfamilydata(Family, Field, 'AT');
        if isempty(AT) && any(strcmpi(Field,{'Setpoint','Monitor','Sum','Set','Read','Readback'}))
            % Try to defer the setpoint and monitor field to main family AT field
            AT = getfamilydata(Family, 'AT');
        end
        if isempty(AT)
            % Look for Family in the AT-model
            ATIndex = findcells(THERING, 'FamName', Family);
            if ~isempty(ATIndex)
                % Field becomes the sub-structure of the AT-model
                AT.ATType = Field;
            else
                % Make a new field
                if any(strcmpi(Field,{'Setpoint','Monitor','Sum','Set','Read','Readback'}))
                    Field = 'Setpoint';
                end
               
                % Look for a model field
                Model = getfamilydata(Family, Field, 'Model');
                if isempty(Model)
                     if strcmpi(Field, 'OnOffSetpoint')
                        AM = ones(size(DeviceList,1),1);
                     else
                        AM = NaN * ones(size(DeviceList,1),1);
                     end
                else
                    AM = Model.Data(DeviceIndex);  % Physics units

                    % Change to hardware units if requested
                    if strcmpi(UnitsFlag, 'Hardware')
                        AM = physics2hw(Family, Field, AM, DeviceList, getenergymodel);
                    else
                        UnitsFlag = 'Physics';
                    end
                end

                % Expand if there is a time vector input
                if length(t) > 1
                    AM(:,1:length(t)) = AM * ones(1,length(t));
                    tout(1,1:length(t)) = t + gettime - t0;
                    DataTime(1:size(AM,1),1:length(t)) = fix(t0) + rem(t0,1)*1e9*sqrt(-1);
                else
                    tout = t + gettime - t0;
                    DataTime = fix(t0) + rem(t0,1)*1e9*sqrt(-1);
                end

                %%%%%%%%%%%%%%%%%%%%%
                % Structure Outputs %
                %%%%%%%%%%%%%%%%%%%%%
                if StructOutputFlag
                    % Structure output for channel name method
                    AM.Data = AM;
                    AM.FamilyName = Family;
                    AM.Field = Field;
                    AM.DeviceList = DeviceList;
                    AM.Mode = 'Simulator';
                    AM.t = t;           % Matlab time at start of measurement
                    AM.tout = tout;     % Matlab time at  end  of measurement
                    AM.DataTime = DataTime;
                    AM.TimeStamp = clock;
                    AM.Units = UnitsFlag;
                    if strcmpi(AM.Units,'Hardware')
                        AM.UnitsString = getfamilydata(Family, Field, 'HWUnits');
                    else
                        AM.UnitsString = getfamilydata(Family, Field, 'PhysicsUnits');
                    end
                    AM.DataDescriptor = [];
                    AM.CreatedBy = 'getpvmodel';
                end
                return
            end
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Special function for simulator %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isfield(AT, 'SpecialFunctionGet')
            AM = feval(AT.SpecialFunctionGet, Family, Field, DeviceList);

            if strcmpi(UnitsFlag, 'Hardware')
                if isfamily(Family, Field)
                    AM = physics2hw(Family, Field, AM, DeviceList, getenergymodel);
                else
                    UnitsFlag = 'Physics';
                end
            else
                UnitsFlag = 'Physics';
            end

            % Expand if there is a time vector input
            if length(t) > 1
                AM(:,1:length(t)) = AM * ones(1,length(t));
                tout(1,1:length(t)) = t + gettime - t0;
                DataTime(1:size(AM,1),1:length(t)) = fix(t0) + rem(t0,1)*1e9*sqrt(-1);
            else
                tout = t + gettime - t0;
                DataTime = fix(t0) + rem(t0,1)*1e9*sqrt(-1);
            end

            if StructOutputFlag
                % Structure output for channel name method
                AM.Data = AM;
                AM.FamilyName = Family;
                AM.Field = Field;
                AM.DeviceList = DeviceList;
                AM.Mode = 'Simulator';
                AM.t = t;           % Matlab time at start of measurement
                AM.tout = tout;     % Matlab time at  end  of measurement
                AM.DataTime = DataTime;
                AM.TimeStamp = clock;
                AM.Units = UnitsFlag;
                if strcmpi(AM.Units,'Hardware')
                    AM.UnitsString = getfamilydata(Family, Field, 'HWUnits');
                else
                    AM.UnitsString = getfamilydata(Family, Field, 'PhysicsUnits');
                end
                AM.DataDescriptor = [];
                AM.CreatedBy = 'getpvmodel';
            end

            return
        end
    else
        % Look for an AT family
        if strcmpi(Family, 'All')
            AT.ATIndex = 1:length(THERING);
        else
            AT.ATIndex = findcells(THERING, 'FamName', Family);
        end
        AT.ATIndex = AT.ATIndex(:);
        DeviceIndex = 1:length(AT.ATIndex);
        if isempty(DeviceList)
            DeviceList = [ones(length(DeviceIndex),1) DeviceIndex(:)];
        end
        AT.ATType = Field;
    end
    
    
    % Get methods
    if isfield(AT, 'ATParameterGroup')
        ATIndexList = AT.ATIndex(DeviceIndex,1);  % Only use the first column
        for i = 1:size(DeviceList,1)
            if iscell(AT.ATParameterGroup)
                % If cell, get the parameter group
                % Note:  this only works if the first FieldName sets the group parameter value
                PGField = AT.ATParameterGroup{DeviceIndex(i)}(1).FieldName;
                AM(i,:) = getfield(THERING{ATIndexList(i)}, PGField, AT.ATParameterGroup{DeviceIndex(i)}(1).FieldIndex);

                % If getfield disappears use:
                %DataField = THERING{ATIndexList(i)}.(PGField);
                %Index1 = AT.ATParameterGroup{DeviceIndex(i)}(1).FieldIndex{1};
                %Index2 = AT.ATParameterGroup{DeviceIndex(i)}(1).FieldIndex{2};
                %AM(i,1) = DataField(Index1, Index2);
            elseif ischar(AT.ATParameterGroup)
                % If string, get the field
                PGField = AT.ATParameterGroup;
                AM(i,:) = THERING{ATIndexList(i)}.PGField;
            end
        end

    else
        
        % Make sure AT.Index exists
        if ~isfield(AT, 'ATIndex')
            AT.ATIndex = family2atindex(Family, DeviceListTotal);
        end

        % For split magnet reduce the get to the first magnet in the split
        % If K*Leff (not K) is being varied then use Nsplits as a multiplier
        Nsplits = 1;
        if size(AT.ATIndex,2) > 1
            Nsplits = ones(size(AT.ATIndex));
            Nsplits(find(isnan(AT.ATIndex)))=0;
            Nsplits = sum(Nsplits')';
            ATIndexList = AT.ATIndex(:,1);
        else
            ATIndexList = AT.ATIndex;
        end
        ATIndexList = ATIndexList(DeviceIndex);


        % Check the DeviceIndex
        if isempty(ATIndexList)
            AM = [];
            DataTime = 0+0*sqrt(-1);
            return;
        end


        % Switch on simulation method
        if any(strcmpi(AT.ATType, {'x','BPMx','Horizontal','y','BPMy','z','BPMz','Vertical','ClosedOrbit'}))
            % Need to consider AT 'x' at say Family='Quad' -> rolls etc?
            [ATIndexList, isort] = sort(ATIndexList);
            
            if istransport
                % Initial launch condition
                TwissData = getpvmodel('TwissData');
                x0 = [TwissData.ClosedOrbit(:); TwissData.dP; TwissData.dL];
                Orbit = linepass(THERING, x0, ATIndexList);
            else
                [CavityState, PassMethod, iCavity] = getcavity;
                if isempty(CavityState)
                    % No cavity in AT model
                    if isradiationon
                        fprintf('   Turning radiation off since there is no RF cavity.\n');
                        setradiation off;
                    end
                    Orbit = findsyncorbit(THERING, 0, ATIndexList);
                else
                    if strcmpi(deblank(CavityState(1,:)), 'On') || isradiationon
                        % findorbit6 recommended when cavity or radiation is on
                        if strcmpi(deblank(CavityState(1,:)), 'Off')
                            % Turn off cavity in AT model
                            fprintf('   Turning the RF cavity on, since radiation is on.\n');
                            setcavity('On');
                        end
                        Orbit = findorbit6(THERING, ATIndexList);
                    else
                        % Cavity is off in AT model
                        %setcavity('Off');
                        % This is a way to simulate the effect of the RF without a cavity
                        C = const.c;  % delta for non relativistic cases???
                        CavityFrequency  = THERING{iCavity(1)}.Frequency;
                        CavityHarmNumber = THERING{iCavity(1)}.HarmNumber;
                        L = findspos(THERING,length(THERING)+1);   % getfamilydata('Circumference')
                        f0 = C * CavityHarmNumber / L;
                        DeltaRF = CavityFrequency - f0;   % Hz
                        %Orbit = findsyncorbit(THERING, -C*DeltaRF*CavityHarmNumber/CavityFrequency^2, ATIndexList);

                        %%Orbit = findsyncorbit(THERING, 0, ATIndexList);
                        %Orbit = findorbit4(THERING, -C*DeltaRF*CavityHarmNumber/CavityFrequency^2, ATIndexList);
                        % Reset cavity PassMethod
                        %setcavity(PassMethod);

                        Orbit = findsyncorbit(THERING, -C*DeltaRF*CavityHarmNumber/CavityFrequency^2, 1:length(THERING)+1);
                        Orbit = Orbit(:,ATIndexList);
                    end
                end
            end
            if any(strcmpi(AT.ATType, {'x','BPMx','Horizontal'}))

                % Roll and Crunch are corrected here (BPM gain errors are corrected in real2raw/raw2real)
                if isfamily(Family, Field)
                    % Only corrector for gain/roll errors is using a ML family
                    % Roll and Crunch are corrected here (BPM gain errors are corrected in real2raw/raw2real)
                    %NDevices = length(ATIndexList);
                    %GCR = zeros(NDevices,4);
                    %GCR(:,1) = getcellstruct(THERING(ATIndexList), 'GCR', 1:NDevices, 1);
                    %GCR(:,2) = getcellstruct(THERING(ATIndexList), 'GCR', 1:NDevices, 2);
                    %GCR(:,3) = getcellstruct(THERING(ATIndexList), 'GCR', 1:NDevices, 3);
                    %GCR(:,4) = getcellstruct(THERING(ATIndexList), 'GCR', 1:NDevices, 4);
                    for i = 1:length(ATIndexList)
                        if isfield(THERING{ATIndexList(i)}, 'GCR')
                            GCR(i,:) = THERING{ATIndexList(i)}.GCR;
                        else
                            %GCR(i,:) = [1 1 0 0];  % [Gx Gy Crunch Roll]
                            Crunch = getcrunch(Family, Field, DeviceList(i,:));
                            Roll = getroll(Family, Field, DeviceList(i,:));
                            %m = gcr2loco(1, 1, Crunch, Roll);
                            GCR(i,:) = [1 1 Crunch Roll];
                        end
                    end

                    x = Orbit(1,:)';
                    y = Orbit(3,:)';

                    AM = ((x - GCR(:,3) .* y) .* cos(GCR(:,4)) + (y + GCR(:,3) .* x) .* sin(GCR(:,4))) ./ sqrt(1-GCR(:,3).^2);

                    % Same as:
                    %Crunch = GCR(:,3);
                    %Roll = GCR(:,4);
                    %a = ( Crunch .* sin(Roll) + cos(Roll)) ./ sqrt(1 - Crunch.^2);
                    %b = (-Crunch .* cos(Roll) + sin(Roll)) ./ sqrt(1 - Crunch.^2);
                    %AM = a .* x + b .* y;
                else
                    AM = Orbit(1,:)';
                end

            elseif any(strcmpi(AT.ATType, {'y','BPMy','z','BPMz','Vertical'}))

                if isfamily(Family, Field)
                    % Only corrector for gain/roll errors is using a ML family
                    % Roll and Crunch are corrected here (BPM gain errors are corrected in real2raw/raw2real)
                    for i = 1:length(ATIndexList)
                        if isfield(THERING{ATIndexList(i)}, 'GCR')
                            GCR(i,:) = THERING{ATIndexList(i)}.GCR;
                        else
                            %GCR(i,:) = [1 1 0 0];  % [Gx Gy Crunch Roll]
                            Crunch = getcrunch(Family, Field, DeviceList(i,:));
                            Roll = getroll(Family, Field, DeviceList(i,:));
                            %m = gcr2loco(1, 1, Crunch, Roll);
                            GCR(i,:) = [1 1 Crunch Roll];
                        end
                    end

                    x = Orbit(1,:)';
                    y = Orbit(3,:)';

                    AM = ((y - GCR(:,3) .* x) .* cos(GCR(:,4)) - (x + GCR(:,3) .* y) .* sin(GCR(:,4))) ./ sqrt(1-GCR(:,3).^2);

                    % Same as:
                    %Crunch = GCR(:,3);
                    %Roll = GCR(:,4);
                    %c = (-Crunch .* cos(Roll) - sin(Roll)) ./ sqrt(1 - Crunch.^2);
                    %d = (-Crunch .* sin(Roll) + cos(Roll)) ./ sqrt(1 - Crunch.^2);
                    %AM = c .* x + d .* y;
                else
                    AM = Orbit(3,:)';
                end
            elseif strcmpi(AT.ATType, 'ClosedOrbit')
                    AM = Orbit';
            end

            AM(isort,:) = AM;

            % Add noise to the BPMs
            %AM = AM + .1e-6*randn(size(AM));  % .1 microns

        elseif strcmpi(AT.ATType, 'HCM')

            if any(strcmpi(Field,{'Setpoint','Monitor','Sum','Set','Read','Readback','Kick'}))
                % Bending Angle (Radians)
                for i=1:length(ATIndexList)
                    % The CM gain errors are corrected in real2raw/raw2real
                    % Coupling: Magnet roll is part of the AT model
                    %           The gain is part of hw2physics/physics2hw
                    if isfield(THERING{ATIndexList(i)}, 'Roll')
                        Roll = THERING{ATIndexList(i)}.Roll;
                    else
                        Roll = [0 0];
                    end
                    
            
                    AM(i,1) = [cos(Roll(2)) sin(Roll(2))] * [sirius_get_kickangle(THERING,ATIndexList(i),'x'); sirius_get_kickangle(THERING,ATIndexList(i),'y')]/(cos(Roll(1)-Roll(2)));
                                      
                    %AM(i,1) = [cos(Roll(2)) sin(Roll(2))] * THERING{ATIndexList(i)}.KickAngle(:) / (cos(Roll(1)-Roll(2)));

                    if size(AT.ATIndex,2) > 1
                        AM(i,1) = Nsplits(i) * AM(i,1);
                    end
                end

                % Add noise (microradian)
                %AM = AM + 1e-6*randn(length(AM),1);
            else
                if isfield(THERING{ATIndexList(1)}, Field)
                    for i=1:length(ATIndexList)
                        AM(i,:) = THERING{ATIndexList(i)}.(Field);
                    end
                else
                    AM = zeros(length(ATIndexList),1);  % or error???
                end
            end

        elseif strcmpi(AT.ATType, 'VCM')

            if any(strcmpi(Field,{'Setpoint','Monitor','Sum','Set','Read','Readback','Kick'}))
                % Bending Angle (Radians)
                for i=1:length(ATIndexList)
                    % The CM gain errors are corrected in real2raw/raw2real
                    % Coupling: Magnet roll is part of the AT model
                    %           The gain is part of hw2physics/physics2hw
                    if isfield(THERING{ATIndexList(i)}, 'Roll')
                        Roll = THERING{ATIndexList(i)}.Roll;
                    else                      
                        Roll = [0 0];
                    end
                                      
                    AM(i,1) = [-sin(Roll(1)) cos(Roll(1))] * [sirius_get_kickangle(THERING,ATIndexList(i),'x'); sirius_get_kickangle(THERING,ATIndexList(i),'y')]/(cos(Roll(1)-Roll(2))); 
                                       
                    %AM(i,1) = [-sin(Roll(1)) cos(Roll(1))] * THERING{ATIndexList(i)}.KickAngle(:) / (cos(Roll(1)-Roll(2)));

                    if size(AT.ATIndex,2) > 1
                        AM(i,1) = Nsplits(i) * AM(i,1);
                    end
                end
                % Add noise (microradian)
                %AM = AM + 1e-6*randn(length(AM),1);
            else
                if isfield(THERING{ATIndexList(1)}, Field)
                    for i=1:length(ATIndexList)
                        AM(i,:) = THERING{ATIndexList(i)}.(Field);
                    end
                else
                    AM = zeros(length(ATIndexList),1);
                end
            end

        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'K','Quad','Quadrupole'}))
            % Quadrupole
            for i = 1:length(ATIndexList)
                AM(i,1) = THERING{ATIndexList(i)}.PolynomB(2);
            end
            % Add noise
            %AM = AM + 1e-3*randn(length(AM),1);
        
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'FamilyPS'}))           
            
            for i = 1:length(ATIndexList)
                AM(i,1) = THERING{ATIndexList(i)}.PolynomB(2);
            end
            AM = physics2hw(AT.ATMagnet, Field, AM, DeviceList, getenergymodel);    
            
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'Shunt')
                    AM(i,1) = AM(i,1) - THERING{ATIndexList(i)}.Shunt;
                end
            end
        
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'ShuntPS'}))
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'Shunt')
                    AM(i,1) = THERING{ATIndexList(i)}.Shunt;
                else
                    AM(i,1) = 0;
                end
            end
        
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'BendPS'}))
           % Booster Bend Power Supply
           AM = getpvmodel(AT.ATMagnet, Field, DeviceList, 'Hardware');
            
        % needs to implement Gap/Field/Phase changes in AT model!!!!
        
        % Ximenes 2011-03-28 / 2011-11-05
        % Added IDGaps in the simul mode
        elseif any(strcmpi(AT.ATType,{'IDGap'}))
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'IDGap')
                    AM(i,1) = THERING{ATIndexList(i)}.IDGap;
                else
                    AM(i,1) = 0;
                end
            end
            
        % Ximenes 2011-11-05
        % Added IDFase in the simul mode
        elseif any(strcmpi(AT.ATType,{'IDPhase'}))
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'IDPhase')
                    AM(i,1) = THERING{ATIndexList(i)}.IDPhase;
                else
                    AM(i,1) = 0;
                end
            end
            
        % Ximenes 2011-03-28 / 2011-11-05
        % Added IDGaps in the simul mode
        elseif any(strcmpi(AT.ATType,{'IDField'}))
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'IDField')
                    AM(i,1) = THERING{ATIndexList(i)}.IDField;
                else
                    AM(i,1) = 0;
                end
            end
            
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'K2','Sext','Sextupole'}))
            % Sextupole
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'SX')
                    AM(i,1) = THERING{ATIndexList(i)}.SX;
                else
                    AM(i,1) = THERING{ATIndexList(i)}.PolynomB(3);
                end
            end               
            % Add noise
            %AM = AM + 1e-3*randn(length(AM),1);
        
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'K3','OCTU','Octupole'}))
            % Octupole
            for i = 1:length(ATIndexList)
                AM(i,1) = THERING{ATIndexList(i)}.PolynomB(4);
            end
            % Add noise
            %AM = AM + 1e-3*randn(length(AM),1);
        
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'KS','KS1','SkewQ','SKEWQUAD', 'SKEWCORR', 'SkewCorrector'}))
            % SkewQuad
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'QS')
                    AM(i,1) = THERING{ATIndexList(i)}.QS;
                else               
                    AM(i,1) = THERING{ATIndexList(i)}.PolynomA(2);
                end
            end
            % Add noise
            %AM = AM + 1e-3*randn(length(AM),1);

        elseif strcmpi(AT.ATType, 'BEND')
            % 2015-09-29 Luana
            % BEND
            AM = sirius_modelbendget(THERING, Family, Field, DeviceList); % AM in Hardware Units
            if strcmpi(UnitsFlag, 'Physics')
                AM = hw2physics(Family, Field, AM, DeviceList, getenergymodel);               
            end
            
            % Add noise
            %AM = AM + 1e-3*randn(length(AM),1);

        elseif strcmpi(AT.ATType, 'Photon BPM')
            % Spear only
            if strcmpi(Family, 'BLOpen')
                AM = ones(length(DeviceIndex),1);
            elseif strcmpi(Family, 'BLSum')
                AM = ones(length(DeviceIndex),1);
            elseif strcmpi(Family, 'BLErr')
                % Calculate photon beam location
                % for ii=1:length(DeviceIndex)
                %    if strcmp(AO.BLType,'dipole')
                %        AM(ii)=CalcDipolePBPM(orbit(3,BPMATIndex),orbit(4,UpstreamBPMIndex),AO.BLLength);
                %    elseif strcmp(AO.BLType,'id')
                %        AM(ii)=CalcIDAngle(DeviceIndex,'simulator');
                %        AM(ii)=CalcIDError(DeviceIndex,'simulator');
                %    end
                % end
                % Add noise
                %AM = AM + 1e-3*randn(length(AM),1);
            end

        elseif strcmpi(AT.ATType, 'Kicker') || strcmpi(AT.ATType, 'kickeramp')

            ATIndexList = AT.ATIndex(DeviceIndex);
            if any(strcmpi(Field,{'Setpoint','Monitor'}))
                % KickAngle
                for i=1:length(ATIndexList)              
                    AM(i,1) = lnls_get_kickangle(THERING, ATIndexList(i), 'x');  % This only allows for a horizontal kick
                end
            else
                if isfield(THERING{ATIndexList(1)}, Field)
                    for i=1:length(ATIndexList)
                        AM(i,:) = THERING{ATIndexList(i)}.(Field);
                    end
                else
                    AM = NaN * ones(length(ATIndexList),1);
                end
            end

        elseif strcmpi(AT.ATType, 'Roll') || strcmpi(AT.ATType, 'Tilt')
            % Roll or Tilt of a magnet
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'R1') && isfield(THERING{ATIndexList(i)}, 'R2')
                    R1 = THERING{ATIndexList(i)}.R1;
                    AM(i,1) = acos(R1(1,1));
                else
                    error(sprintf('%s(%d,%d) must have a R1 & R2 field in the model to be rolled.', Family, DeviceList(i,:)));
                end
            end

        elseif strcmpi(AT.ATType, 'XShift') || strcmpi(AT.ATType, 'DX')
            % Roll or Tilt of a magnet
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'T1')
                    T1 = THERING{ATIndexList(i)}.T1;
                    AM(i,1) = T1(1);
                else
                    error(sprintf('%s(%d,%d) must have a T1 field in the model to be shifted.', Family, DeviceList(i,:)));
                end
            end

        elseif strcmpi(AT.ATType, 'YShift') || strcmpi(AT.ATType, 'DY')
            % Roll or Tilt of a magnet
            for i = 1:length(ATIndexList)
                if isfield(THERING{ATIndexList(i)}, 'T1')
                    T1 = THERING{ATIndexList(i)}.T1;
                    AM(i,1) = T1(3);
                else
                    error(sprintf('%s(%d,%d) must have a T1 field in the model to be shifted.', Family, DeviceList(i,:)));
                end
            end
            
        elseif any(strcmpi(AT.ATType,{'FirstTurn','LinePass','Turns', 'xTurns','PxTurns','yTurns','PyTurns','dPTurns','dLTurns'}))
            % Turn-by-turn data

            Nturns = round(max(abs(t)));  % getfamilydata('NTURNS');
            t = Nturns; % Just incase it changed
            if isempty(Nturns) || Nturns < 1
                Nturns = 1;
            end

            % Initial launch condition
            if isfield(THERING{1}, 'TwissData')
                TwissData = THERING{1}.TwissData;
            else
                TwissData = getfamilydata('TwissData');
            end
            if ~isfield(TwissData, 'dP')
                TwissData.dP = 0;
            end
            if ~isfield(TwissData, 'L')
                TwissData.dL = 0;
            end
            if isempty(TwissData.ClosedOrbit)
                fprintf('   6-dim initial condition set to zeros.  Use setpvmodel(''TwissData'',''ClosedOrbit'') to change it.\n');
                TwissData.ClosedOrbit = [0 0 0 0]';
                %x0 = [.001 0, 0.001, 0]';
                TwissData.dP = 0;
                TwissData.dL = 0;
            end
            x0 = [TwissData.ClosedOrbit(:); TwissData.dP; TwissData.dL];
            
            [AM, ATIndexList, LostBeam] = getturns(x0, Nturns, Family, DeviceList);
            
            if LostBeam
                error('Tracking failed due to beam loss.');
            end
            
            if any(strcmpi(AT.ATType,{'FirstTurn', 'LinePass'}))
                if size(AM,2) == 1
                    AM = squeeze(AM(:,:,1:6));
                end
            elseif any(strcmpi(AT.ATType,{'Turns'}))
                %if size(AM,2) == 1
                %    AM = squeeze(AM(:,:,1:6));
                %end
            elseif strcmpi(AT.ATType,'xTurns')
                AM = squeeze(AM(:,:,1));
                % Add noise to the BPMs
                %AM = AM + .1e-6*randn(size(AM));  % .1 microns
            elseif strcmpi(AT.ATType,'PxTurns')
                AM = squeeze(AM(:,:,2));
            elseif strcmpi(AT.ATType,'yTurns')
                AM = squeeze(AM(:,:,3));
                % Add noise to the BPMs
                %AM = AM + .1e-6*randn(size(AM));  % .1 microns
            elseif strcmpi(AT.ATType,'PyTurns')
                AM = squeeze(AM(:,:,4));
            elseif strcmpi(AT.ATType,'dPTurns')
                AM = squeeze(AM(:,:,5));
            elseif strcmpi(AT.ATType,'dLTurns')
                AM = squeeze(AM(:,:,6));
            else
                error('Input of unknown type');
            end
            
            %if size(AM, 1) ~= length(ATIndexList)
            %if size(AM, 2) ~= Nturns
            %    AM = AM';
            %end
            
            % Gain/Roll coordinate change???

            % Add noise
            %AM = AM + 1e-3*randn(length(AM),1);

        % 2015-09-17 Luana
        elseif strcmpi(AT.ATType, 'Septum')
            % Septum

            AM = zeros(size(AT.ATIndex,1),1);	
            for i = 1:size(AT.ATIndex, 1)               
                AM(i,1) = 0; 
                for j = 1:size(AT.ATIndex, 2)
                    AM(i,1) = AM(i,1) + THERING{AT.ATIndex(i,j)}.PolynomB(1)*THERING{AT.ATIndex(i,j)}.Length;
                end               
            end
            
            BendingAngle = zeros(size(AT.ATIndex, 1), 1);
            for i = 1:size(AT.ATIndex, 1)
                for j = 1:Nsplits
                    BendingAngle(i) = BendingAngle(i) + THERING{AT.ATIndex(i,j)}.BendingAngle;
                end
                AM(i) = AM(i) + BendingAngle(i);
            end

            
        elseif strcmpi(AT.ATType, 'null')
            % JR default do-nothing behaviour
            AM = NaN;

        else
            if isfield(THERING{ATIndexList(1)}, Field)
                for i = 1:length(ATIndexList)
                    AM(i,:) = THERING{ATIndexList(i)}.(Field);
                end
            else
                %error(sprintf('ATType unknown for Family %s', Family));
                AM = NaN * ones(length(ATIndexList),1);
            end
            % Add noise
            %AM = AM + 1e-3*randn(length(AM),1);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change to hardware units if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(UnitsFlag, 'Hardware') 
    if isfamily(Family, Field)
        if ~ismemberof(Family, 'BEND')
            AM = physics2hw(Family, Field, AM, DeviceList, getenergymodel);
        end       
    else
        persistent WarningFlag
        if isempty(WarningFlag)
            fprintf('\n   You are asking for hardware units from a nonstandard MML family (%s.%s).\n', Family, Field);
            fprintf('   Whenever conversion factors are not known for model data, physics units are returned.\n\n');
            WarningFlag = 1;
        end

        UnitsFlag = 'Physics';
    end
else
    UnitsFlag = 'Physics';
end


% Expand if there is a time vector input
if length(t) > 1
    AM(:,1:length(t)) = AM * ones(1,length(t));
    tout(1,1:length(t)) = t + gettime - t0;
else
    if strcmpi(Field,'Turns')
        tout = gettime - t0;
    else
        tout = t + gettime - t0;
    end
    %DataTime = fix(t0) + rem(t0,1)*1e9*sqrt(-1);
end
DataTime(1:size(AM,1),1:length(t)) = fix(t0) + rem(t0,1)*1e9*sqrt(-1);


%%%%%%%%%%%%%%%%%%%%%
% Structure Outputs %
%%%%%%%%%%%%%%%%%%%%%
if StructOutputFlag
    % Structure output for channel name method
    AM.Data = AM;
    AM.FamilyName = Family;
    AM.Field = Field;
    AM.DeviceList = DeviceList;
    AM.Mode = 'Simulator';
    AM.t = t;           % Matlab time at start of measurement
    AM.tout = tout;     % Matlab time at  end  of measurement
    AM.DataTime = DataTime;
    AM.TimeStamp = clock;
    AM.Units = UnitsFlag;
    if strcmpi(AM.Units,'Hardware')
        AM.UnitsString = getfamilydata(Family, Field, 'HWUnits');
    else
        AM.UnitsString = getfamilydata(Family, Field, 'PhysicsUnits');
    end
    AM.DataDescriptor = [];
    AM.CreatedBy = 'getpvmodel';
end

