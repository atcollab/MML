function ErrorFlag = setpvmodel(varargin)
%SETPVMODEL - Sets the model
%  ErrorFlag = setpvmodel(Family, Field, NewSP, DeviceList)
%  ErrorFlag = setpvmodel(Family, NewSP, DeviceList)
%  ErrorFlag = setpvmodel(Family, NewSP)
%  ErrorFlag = setpvmodel(Family)
%
%  INPUTS
%  1. Family - Family Name
%              Data Structure
%              Accelerator Object
%  2. Field - Middle layer field name ('Monitor', 'Setpoint', etc) {'Monitor'}
%             AT field name
%             or
%             'K','Quad','Quadrupole'
%             'K2','Sext','Sextupole'
%             'K3','Octupole'
%             'KS1','SkewQuad','Skew'
%             'Roll' or 'Tilt'  [radian] (for a magnet, uses mksrollmat)
%             'RollX' or 'TiltX' and 'RollY' or 'TiltY'  (for a corrector magnet)
%             Note: setpvmodel('TwissData', 'ClosedOrbit') - Sets the start condition at the first AT element
%                   setpvmodel('TwissData', Field) - Sets the TwissData.(Field) twiss parameters at the first AT element
%                                                    See twissline for the definition of TwissData.
%                                                   'dP' and 'dL' are also stored in TwissData for 6-Dim tracking.
%
%  3. NewSP - Desired values {Default: getgolden}
%  4. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  5. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%
%  OUTPUTS
%  1. NewSP - The actual values set
%  2. ErrorFlag
%
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays
%
%  See also setpv, getpv, getpvmodel

%  Written by Greg Portmann


global THERING THERINGCELL


ErrorFlag = 0;

%%%%%%%%%%%%%%%%%
% Input parsing %
%%%%%%%%%%%%%%%%%
UnitsFlag = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct') || strcmpi(varargin{i},'numeric')
        % Remove and ignor
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
        NewSP = varargin{3};
    end
    if length(varargin) >= 4
        DeviceList = varargin{4};
    end
end


%%%%%%%%%%%%%%
% Cell input %
%%%%%%%%%%%%%%
if iscell(Family)
    for i = 1:length(Family)
        if length(varargin) < 2
            ErrorFlag{i} = setpvmodel(Family{i}, UnitsFlag{:});
        elseif length(varargin) < 3
            if iscell(Field)
                ErrorFlag{i} = setpvmodel(Family{i}, Field{i}, UnitsFlag{:});
            else
                ErrorFlag{i} = setpvmodel(Family{i}, Field, UnitsFlag{:});
            end
        elseif length(varargin) < 4
            if iscell(Field)
                if iscell(NewSP)
                    ErrorFlag{i} = setpvmodel(Family{i}, Field{i}, NewSP{i}, UnitsFlag{:});
                else
                    ErrorFlag{i} = setpvmodel(Family{i}, Field{i}, NewSP, UnitsFlag{:});
                end
            else
                if iscell(NewSP)
                    ErrorFlag{i} = setpvmodel(Family{i}, Field, NewSP{i}, UnitsFlag{:});
                else
                    ErrorFlag{i} = setpvmodel(Family{i}, Field, NewSP, UnitsFlag{:});
                end
            end
        else
            if iscell(Field)
                if iscell(NewSP)
                    if iscell(DeviceList)
                        ErrorFlag{i} = setpvmodel(Family{i}, Field{i}, NewSP{i}, DeviceList{i}, UnitsFlag{:});
                    else
                        ErrorFlag{i} = setpvmodel(Family{i}, Field{i}, NewSP{i}, DeviceList, UnitsFlag{:});
                    end
                else
                    if iscell(DeviceList)
                        ErrorFlag{i} = setpvmodel(Family{i}, Field{i}, NewSP, DeviceList{i}, UnitsFlag{:});
                    else
                        ErrorFlag{i} = setpvmodel(Family{i}, Field{i}, NewSP, DeviceList, UnitsFlag{:});
                    end
                end
            else
                if iscell(NewSP)
                    if iscell(DeviceList)
                        ErrorFlag{i} = setpvmodel(Family{i}, Field, NewSP{i}, DeviceList{i}, UnitsFlag{:});
                    else
                        ErrorFlag{i} = setpvmodel(Family{i}, Field, NewSP{i}, DeviceList, UnitsFlag{:});
                    end
                else
                    if iscell(DeviceList)
                        ErrorFlag{i} = setpvmodel(Family{i}, Field, NewSP, DeviceList{i}, UnitsFlag{:});
                    else
                        ErrorFlag{i} = setpvmodel(Family{i}, Field, NewSP, DeviceList, UnitsFlag{:});
                    end
                end
            end
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Family or data structure inputs beyond this point %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only change StructOutputFlag if 'numeric' is not on the input line
if isstruct(Family)
    % Data structure inputs
    if length(varargin) < 2
        if isfield(Family,'Field')
            Field = Family.Field;
        else
            Field = '';
        end
    end
    if length(varargin) < 3
        if isfield(Family,'Data')
            NewSP = Family.Data;
        else
            error('NewSP input required (or a .Data field must exist for data structure inputs)');
        end
    end
    if length(varargin) < 4
        if isfield(Family,'DeviceList')
            DeviceList = Family.DeviceList;
        else
            DeviceList = [];
        end
    end
    if isempty(UnitsFlag)
        if isfield(Family,'Units')
            UnitsFlag{1} = Family.Units;
        end
    end
    if isfield(Family,'FamilyName')
        Family = Family.FamilyName;
    else
        error('For data structure inputs FamilyName field must exist')
    end
else
    % Family string input
    if length(varargin) < 2
        Field = '';
    end
    if length(varargin) < 3
        NewSP = [];
    end
    if length(varargin) < 4
        DeviceList = [];
    end
end

if isnumeric(Field)
    DeviceList = NewSP;
    NewSP = Field;
    Field = '';
end
if isempty(Field)
    Field = 'Setpoint';
end

if isempty(NewSP)
    NewSP = getgolden(Family, Field, DeviceList, 'numeric', UnitsFlag{:});
end

if isempty(DeviceList)
    if isfamily(Family)
        DeviceList = family2dev(Family);
    end
end
if isfamily(Family)
    if (size(DeviceList,2) == 1)
        DeviceList = elem2dev(Family, DeviceList);
    end
end

if isempty(UnitsFlag)
    UnitsFlag = 'Hardware';
else
    UnitsFlag = UnitsFlag{1};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change to physics units if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NewSP_HW = [];
if strcmpi(UnitsFlag,'Hardware') && isfamily(Family, Field)
    NewSP_HW = NewSP;
    NewSP = hw2physics(Family, Field, NewSP, DeviceList, getenergymodel);
end

if ~isstruct(NewSP) && ~iscell(NewSP) && size(NewSP,1)~=size(DeviceList,1)
    if size(NewSP,1) == 1
        NewSP = ones(size(DeviceList,1),1) * NewSP;
    else
        error('Setpoint size must equal the device list or be a scalar.');
    end
end

% Look to see it the AT model needs to be changed for this family
ATModelNumber = getfamilydata(Family, 'AT', 'ATModel');
if ~isempty(ATModelNumber)
    % Change THERING
    THERING = THERINGCELL{ATModelNumber};
    
    % Set AD.Circumference
    setfamilydata(findspos(THERING, length(THERING)+1), 'Circumference');
    
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


%%%%%%%%%%%%
% Set Data %
%%%%%%%%%%%%

% Do families that do not require at AT field first
if strcmp(Family, 'RF') && strcmpi(Field, 'OpMode')
    % do nothing;
elseif strcmp(Family, 'RF')
    % RF
    iCavity = findcells(THERING,'Frequency');
    for i = 1:length(iCavity)
        THERING{iCavity(i)}.Frequency = NewSP(1);
    end
    
elseif any(strcmpi(Family,{'Energy','GeV'}))
    
    % Set energy in AT
    % Noter: Changing the energy of the model is only a variable change
    setenergymodel(NewSP(1));
    
elseif strcmp(Family, 'TwissData')
    
    if isfield(THERING{1}, 'TwissData')
        InATFlag = 1;
        TwissData = THERING{1}.TwissData;
    else
        InATFlag = 0;
        TwissData = getfamilydata('TwissData');
        if isempty(TwissData)
            % Store in AT
            InATFlag = 1;
        end
    end
    
    if any(strcmpi(Field, {'ClosedOrbit','dP','dL'}))
        if ~isfield(TwissData, 'ClosedOrbit')
            TwissData.ClosedOrbit = [0 0 0 0]';
        end
        if ~isfield(TwissData, 'dP')
            TwissData.dP = 0;
        end
        if ~isfield(TwissData, 'dL')
            TwissData.dL = 0;
        end
        if strcmpi(Field, 'ClosedOrbit')
            if length(NewSP) < 4 || length(NewSP) == 5 || length(NewSP) > 6
                error('Closed orbit input must be length 4 or 6');
            elseif length(NewSP) == 4
                TwissData.ClosedOrbit = NewSP(1:4);
            else
                TwissData.ClosedOrbit = NewSP(1:4);
                TwissData.dP = NewSP(5);
                TwissData.dL = NewSP(6);
            end
        elseif strcmpi(Field, 'dP')
            TwissData.dP = NewSP(1);
        elseif strcmpi(Field, 'dL')
            TwissData.dL = NewSP(1);
        end
    else
        if any(strcmpi(Field, {'Setpoint','Monitor'}))
            TwissData = NewSP;
        else
            TwissData.(Field) = NewSP;
        end
    end
    
    % Store TwissData where it was found
    if InATFlag
        THERING{1}.TwissData = TwissData;
    else
        setfamilydata(TwissData, 'TwissData');
    end
else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Families that require an AT field %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Find the index for where the desired data is in the total device list
    if isfamily(Family)
        DeviceListTotal = family2dev(Family, 0);
        [DeviceIndex, iNotFound] = findrowindex(DeviceList, DeviceListTotal);
        if ~isempty(iNotFound)
            % Device not found
            for i = 1:length(iNotFound)
                fprintf('   No devices to set for Family %s(%d,%d)\n', Family, DeviceList(i,1), DeviceList(i,2));
            end
            error(sprintf('%d Devices not found', length(iNotFound)));
        end
        
        % Find the AT structure if it exists
        AT = getfamilydata(Family, Field, 'AT');
        if isempty(AT)
            if any(strcmpi(Field,{'Setpoint','Monitor','Sum','Set','Read','Readback'}))
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
                        Model.Data = NaN * ones(size(DeviceListTotal,1),1);
                    end
                    Model.Data(DeviceIndex) = NewSP;  % Physics units
                    setfamilydata(Model, Family, Field, 'Model');  % Store the data in .Model field
                    
                    % AT.ATType must be defined
                    %warning('Simulator not setup for %s.%s family\n', Family, Field);
                    %fprintf('WARNING: Simulator not setup for %s.%s family\n', Family, Field);
                    %ErrorFlag = 1;
                    %DataTime = 0+0*sqrt(-1);
                    ErrorFlag = 0;
                    DataTime = 0+0*sqrt(-1);
                    return
                end
            end
        else
            % Set methods
            if isfield(AT, 'SpecialFunctionSet')
                ErrorFlag = feval(AT.SpecialFunctionSet, Family, Field, NewSP, DeviceList);
                return
            end
        end
        
        % Make sure AT.Index exists
        if ~isfield(AT,'ATIndex')
            AT.ATIndex = family2atindex(Family, DeviceListTotal);
        end
    else
        % Look for an AT family
        if strcmpi(Family, 'All')
            AT.ATIndex = (1:length(THERING))';
        else
            AT.ATIndex = findcells(THERING, 'FamName', Family);
        end
        DeviceIndex = 1:length(AT.ATIndex);
        if isempty(DeviceList)
            DeviceList = [ones(length(DeviceIndex),1) DeviceIndex(:)];
        end
        AT.ATType = Field;
    end
    
    % 2015-09-17 Luana
    NewPhysicsValue = NewSP;
    SetMultipolesErrors = getfamilydata('SetMultipolesErrors');
    
    % Check for a split magnet
    Nsplit = size(AT.ATIndex,2);
    if Nsplit > 1
        % Make a large column out of the split magnets
        NewSP = NewSP*ones(1,Nsplit);
        NewSP = NewSP';
        NewSP = NewSP(:);
               
        ATIndexList = AT.ATIndex(DeviceIndex,:)';
        ATIndexList = ATIndexList(:);
        
        iNaN = find(isnan(ATIndexList));
        ATIndexList(iNaN) = [];
        NewSP(iNaN) = [];    
    else
        ATIndexList = AT.ATIndex(DeviceIndex);
    end
    
    
    % Make the setpoint changes
    if isfield(AT, 'ATParameterGroup')
        for i = 1:size(NewSP,1)
            if iscell(AT.ATParameterGroup)
                % If cell, set the parameter group
                ParameterGroup = AT.ATParameterGroup{DeviceIndex(i)};
                THERING = setparamgroup(THERING, ParameterGroup, NewSP(i));
            elseif ischar(AT.ATParameterGroup)
                % Set the field
                ATField = AT.ATParameterGroup;
                THERING{ATIndexList(i)}.(ATField) = NewSP(i);
            end
        end
    else
        if any(strcmpi(AT.ATType, {'HCM','Kicker'}))
            % HCM
            % 2015-09-18 Luana 
            if SetMultipolesErrors
                NewHardwareValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
                THERING = sirius_add_multipoles_errors(THERING, Family, Field, NewHardwareValue, DeviceList);     
            end
         
            for i = 1:size(NewSP,1)
                % Coupling: Magnet roll is part of the AT model
                %           The gain is part of hw2physics/physics2hw
                if isfield(THERING{ATIndexList(i)}, 'Roll')
                    Roll = THERING{ATIndexList(i)}.Roll;
                else
                    Roll = [0 0];          
                end
                
                % New X-Kick, but the Y-Kick needs to be maintained (middle layer coordinates)
                XKick = NewSP(i);           
                YKick = [-sin(Roll(1)) cos(Roll(1))] * [sirius_get_kickangle(THERING,ATIndexList(i),'x'); sirius_get_kickangle(THERING,ATIndexList(i),'y')] / (cos(Roll(1)-Roll(2)));
                
                %YKick = [-sin(Roll(1)) cos(Roll(1))] * [lnls_get_kickangle(THERING, ATIndexList(i), 'x'); lnls_get_kickangle(THERING, ATIndexList(i), 'y')] / (cos(Roll(1)-Roll(2)));
                %YKick = [-sin(Roll(1)) cos(Roll(1))] * THERING{ATIndexList(i)}.KickAngle(:) / (cos(Roll(1)-Roll(2)));
                
                % Superimpose the X and Y kicks
                
                % 2015-09-17 Luana
                THERING = sirius_set_kickangle(THERING, XKick * cos(Roll(1)) - YKick * sin(Roll(2)), ATIndexList(i), 'x');
                THERING = sirius_set_kickangle(THERING, XKick * sin(Roll(1)) + YKick * cos(Roll(2)), ATIndexList(i), 'y');      
                
                %THERING{ATIndexList(i)}.KickAngle(1) = XKick * cos(Roll(1)) - YKick * sin(Roll(2));
                %THERING{ATIndexList(i)}.KickAngle(2) = XKick * sin(Roll(1)) + YKick * cos(Roll(2));
                %fprintf('kick(%d,%d)=%g %g  AT=%g %g  Roll=%g  %g\n',DeviceList(i,:), XKick, YKick, THERING{ATIndexList(i)}.KickAngle, Roll);
                
                %% X only kick
                %THERING{ATIndexList(i)}.KickAngle(1) = NewSP(i) * cos(Roll(1));
                %THERING{ATIndexList(i)}.KickAngle(2) = NewSP(i) * sin(Roll(1));
            end
                    
            
        elseif strcmpi(AT.ATType, 'VCM')
            % VCM            
            % 2015-09-18 Luana     
            if SetMultipolesErrors
                NewHardwareValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
                THERING = sirius_add_multipoles_errors(THERING, Family, Field, NewHardwareValue, DeviceList); 
            end

            for i = 1:size(NewSP,1)
                % Coupling: Magnet roll is part of the model
                %           The gain is part of hw2physics/physics2hw
                
                if isfield(THERING{ATIndexList(i)}, 'Roll')
                    Roll = THERING{ATIndexList(i)}.Roll;
                else
                    Roll = [0 0];           
                end
                % New Y-Kick, but the X-Kick needs to be maintained (middle layer coordinates)
                
                % 2015-09-17 Luana
                XKick = [cos(Roll(2)) sin(Roll(2))] * [sirius_get_kickangle(THERING,ATIndexList(i),'x'); sirius_get_kickangle(THERING,ATIndexList(i),'y')] / (cos(Roll(1)-Roll(2)));
                YKick = NewSP(i);
                
                %XKick = [cos(Roll(2)) sin(Roll(2))] * THERING{ATIndexList(i)}.KickAngle(:) / (cos(Roll(1)-Roll(2)));
                
                % Superimpose the X and Y kicks
                
                % 2015-09-17 Luana
                THERING = sirius_set_kickangle(THERING, XKick * cos(Roll(1)) - YKick * sin(Roll(2)), ATIndexList(i), 'x');
                THERING = sirius_set_kickangle(THERING, XKick * sin(Roll(1)) + YKick * cos(Roll(2)), ATIndexList(i), 'y');
                               
                %THERING{ATIndexList(i)}.KickAngle(1) = XKick * cos(Roll(1)) - YKick * sin(Roll(2));
                %THERING{ATIndexList(i)}.KickAngle(2) = XKick * sin(Roll(1)) + YKick * cos(Roll(2));
                %fprintf('kick(%d,%d)=%g %g  AT=%g %g  Roll=%g  %g\n',DeviceList(i,:), XKick, YKick, THERING{ATIndexList(i)}.KickAngle, Roll);
                
                %% Y only kick
                %THERING{ATIndexList(i)}.KickAngle(1) = -1 * NewSP(i) * sin(Roll(2));
                %THERING{ATIndexList(i)}.KickAngle(2) =      NewSP(i) * cos(Roll(2));
                
            end
                        
        elseif any(strcmpi(AT.ATType,{'K','Quad','Quadrupole'}))
            % K - Quadrupole
            
            % 2015-09-17 Luana           
            PrevHardwareValue = getpvmodel(Family, Field, DeviceList, 'Hardware');
            NewHardwareValue  = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
            
            if SetMultipolesErrors
                THERING = sirius_add_multipoles_errors(THERING, Family, Field, NewHardwareValue, DeviceList);
            end
            
            for i = 1:size(NewSP,1)
                if isfield(THERING{ATIndexList(i)}, 'K')
                    THERING{ATIndexList(i)}.K = NewSP(i);
                end
                THERING{ATIndexList(i)}.PolynomB(2) = NewSP(i);
            end
                                  
            AllDevices = family2dev(Family);
            if size(DeviceList, 1) ~= size(AllDevices, 1)              
                for i = 1:size(NewHardwareValue,1)
                    for j = 1:Nsplit
                        if isfield(THERING{AT.ATIndex(i,j)}, 'Shunt')
                            THERING{AT.ATIndex(i,j)}.Shunt = THERING{AT.ATIndex(i,j)}.Shunt + NewHardwareValue(i) - PrevHardwareValue(i);
                        else
                            THERING{AT.ATIndex(i,j)}.Shunt = NewHardwareValue(i) - PrevHardwareValue(i);
                        end      
                    end
                end
            else 
                FamilyValue = mean(NewHardwareValue);
                for i = 1:size(NewHardwareValue,1)
                    for j = 1:Nsplit
                        THERING{AT.ATIndex(i,j)}.Shunt = NewHardwareValue(i) - FamilyValue;
                    end
                end
            end
            
        % 2015-09-17 Luana    
        elseif any(strcmpi(AT.ATType, {'FamilyPS'}))

            AllDevices = family2dev(Family);
            AllIndices = family2atindex(Family);
            PrevFamilyValue  = getpvmodel(Family, Field, AllDevices, 'Hardware');
            PrevTotalValue   = getpvmodel(AT.ATMagnet, Field, AllDevices, 'Hardware');
            
            NewFamilyValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
            if size(DeviceList, 1) ~= size(AllDevices, 1) 
                NewFamilyValue = ones(size(AllDevices, 1),1)*NewFamilyValue(1);
            end
            NewTotalValue = PrevTotalValue - PrevFamilyValue + NewFamilyValue;
            
            if SetMultipolesErrors
                THERING = sirius_add_multipoles_errors(THERING, AT.ATMagnet, Field,  NewTotalValue, AllDevices);
            end
            
            NewTotalValue = hw2physics(AT.ATMagnet, Field, NewTotalValue, AllDevices); 
            for i = 1:size(NewTotalValue, 1)
                for j =1:Nsplit
                    if isfield(THERING{AllIndices(i,j)}, 'K')
                        THERING{AllIndices(i,j)}.K = NewTotalValue(i);
                    end
                    THERING{AllIndices(i,j)}.PolynomB(2) = NewTotalValue(i);
                end
            end
            
        % 2015-90-17 Luana 
        elseif any(strcmpi(AT.ATType, {'ShuntPS'}))
                       
            PrevShuntValue   = getpvmodel(Family, Field, DeviceList, 'Hardware');
            PrevTotalValue   = getpvmodel(AT.ATMagnet, Field, DeviceList, 'Hardware');
            
            NewShuntValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);    
            NewTotalValue = PrevTotalValue - PrevShuntValue + NewShuntValue;
            
            if SetMultipolesErrors
                THERING = sirius_add_multipoles_errors(THERING, AT.ATMagnet, Field, NewTotalValue, DeviceList);
            end
            
            NewTotalvalue = hw2physics(AT.ATMagnet, Field, NewTotalValue, DeviceList);
            for i = 1:size(NewTotalValue, 1)
                for j =1:Nsplit
                    if isfield(THERING{AT.ATIndex(i,j)}, 'K')
                        THERING{AT.ATIndex(i,j)}.K = NewTotalvalue(i);
                    end
                    THERING{AT.ATIndex(i,j)}.PolynomB(2) = NewTotalvalue(i); % Physics Units
                    THERING{AT.ATIndex(i,j)}.Shunt       = NewShuntValue(i); % Hardware Units
                end                
            end  
            
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'K2','Sext','Sextupole'}))
            % K2 - Sextupole
            if SetMultipolesErrors
                NewHardwareValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
                THERING = sirius_add_multipoles_errors(THERING, Family, Field, NewHardwareValue, DeviceList); 
            end           
            
            for i = 1:size(NewSP,1)
                if isfield(THERING{ATIndexList(i)}, 'SX')
                    THERING{ATIndexList(i)}.SX = NewSP(i);
                end
                THERING{ATIndexList(i)}.PolynomB(3) = NewSP(i);
            end           
        
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'K3','OCTU','Octupole'}))
            % K3 - Octupole
            
            if SetMultipolesErrors
                NewHardwareValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
                THERING = sirius_add_multipoles_errors(THERING, Family, Field, NewHardwareValue, DeviceList); 
            end
            
            for i = 1:size(NewSP,1)
                THERING{ATIndexList(i)}.PolynomB(4) = NewSP(i);
            end

        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType,{'KS','KS1','SkewQ','SkewQuad', 'SKEWCORR', 'SkewCorrector'}))
            % KS1 - Skew Quadrupole
            if SetMultipolesErrors
                NewHardwareValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
                THERING = sirius_add_multipoles_errors(THERING, Family, Field, NewHardwareValue, DeviceList); 
            end
          	
            for i = 1:size(NewSP,1)
                if isfield(THERING{ATIndexList(i)}, 'QS')
                    THERING{ATIndexList(i)}.QS = NewSP(i);
                end
                THERING{ATIndexList(i)}.PolynomA(2) = NewSP(i);
            end
                    
        % 2015-09-17 Luana
        elseif any(strcmpi(AT.ATType, {'BendPS'}))
            % Booster Bend Power Supply
            NewHardwareValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
            ErrorFlag = setpvmodel(AT.ATMagnet, Field, NewHardwareValue, DeviceList, 'Hardware');
            
        % needs to implement Gap/Field/Phase changes in AT model!
             
        % 2011-11-05 : Added IDPhase AT Type in simul
        elseif any(strcmpi(AT.ATType, {'IDPhase'}))
            for i = 1:size(NewSP,1)
                THERING{ATIndexList(i)}.IDPhase = NewSP(i);
            end
            
        % 2011-11-05 : Added IDGap AT Type in simul
        elseif any(strcmpi(AT.ATType, {'IDGap'}))
            for i = 1:size(NewSP,1)
                THERING{ATIndexList(i)}.IDGap = NewSP(i);
            end
        
        % 2011-11-05 : Added IDGap AT Type in simul
        elseif any(strcmpi(AT.ATType, {'IDField'}))
            for i = 1:size(NewSP,1)
                THERING{ATIndexList(i)}.IDField = NewSP(i);
            end
        
        elseif strcmpi(AT.ATType, 'BEND')
            % BEND       
            if isempty(NewSP_HW)
                fprintf('\n   WARNING: Must set the BEND magnet in the model in hardware units.\n');
                fprintf('   No change made to the BEND family in the model!\n');
                return
            end
            
            if strcmpi(getfamilydata('MachineType'), 'Booster')              
                % The BEND simulates very differently:
                % 1. The BEND radians does not change
                % 2. The energy comes from the hw2physics (bend2gev)
                % 3. All the other magnets have a "K" change
                % 4. The underlying assumption is that the RF cavity provides the necessary energy

                % Since this takes a relatively long time, only do it once.  Setting each BEND to
                % different setpoints will not work anyways.

                % Get the energy of the model
                GeVPresent = getenergy('Simulator');

                % Get the desired energy of the model
                GeVDesired = bend2gev(Family, Field, NewSP_HW(1), DeviceList(1,:));

                if abs(GeVPresent - GeVDesired) < 1e-9  % GeV
                    % No change needed
                    return;
                end

                % Get the present machine config in hardware units
                SP = getmachineconfig('Hardware', 'Simulator');

                % Set energy in the model
                setenergymodel(GeVDesired);            % Sets the model energy which is stored in AT
                setfamilydata(GeVDesired, 'Energy');   % Set design energy in the middle layer

                % Set the new "K" values (physics values)
                % The amperes does not change, but the "K" values do
                % because the energy was change between hw2physics/physics2hw calls

                % 2015-10-01 Luana
                Families = fieldnames(SP);
                Bends = findmemberof('BEND');
                PowerSupplies = findmemberof('PowerSupply');
                for i=1:size(Families,1)
                    if any(strcmpi(Families(i,:), Bends))
                        SP = rmfield(SP, Families(i,:));
                    end
                    if any(strcmpi(Families(i,:), PowerSupplies))
                        SP = rmfield(SP, Families(i,:));
                    end
                end

                setmachineconfig(SP, 'Hardware', 'Simulator');
            
            else
                
                Dipoles = findmemberof('BEND');
                NewSP_HW = NewSP_HW(1);
                for k = 1:size(Dipoles,1)
                    FamName = Dipoles{k};
                    fprintf('   Setting all magnets of family %s to %.4f Amperes\n', FamName, NewSP_HW);
                    if SetMultipolesErrors
                        THERING = sirius_add_multipoles_errors(THERING, FamName, Field, NewSP_HW);
                    end
                    THERING = sirius_modelbendset(THERING, FamName, Field, NewSP_HW);
                end
                
            end
            
        elseif strcmpi(AT.ATType, 'Roll')
            % Roll or Tilt
            for i = 1:size(NewSP,1)
                % Roll the magnet
                if isfield(THERING{ATIndexList(i)}, 'R1') && isfield(THERING{ATIndexList(i)}, 'R2')
                    R1 = mksrollmat( NewSP(i));
                    R2 = mksrollmat(-NewSP(i));
                    THERING{ATIndexList(i)}.R1 = R1;
                    THERING{ATIndexList(i)}.R2 = R2;
                else
                    error(sprintf('%s(%d,%d) must have a R1 & R2 field in the model to be rolled.', Family, DeviceList(i,:)));
                end
            end
        
        % 2015-09-17 Luana
        elseif strcmpi(AT.ATType, 'Septum')
            % Septum
            
            if SetMultipolesErrors
                NewHardwareValue = physics2hw(Family, Field, NewPhysicsValue, DeviceList);
                THERING = sirius_add_multipoles_errors(THERING, Family, Field, NewHardwareValue, DeviceList);
            end
            
            SeptumLength = zeros(size(AT.ATIndex, 1), 1);
            BendingAngle = zeros(size(AT.ATIndex, 1), 1);
            DeltaPB      = zeros(size(AT.ATIndex, 1), 1);
            for i = 1:size(AT.ATIndex, 1)
                for j = 1:Nsplit
                    SeptumLength(i) = SeptumLength(i) + THERING{AT.ATIndex(i,j)}.Length;
                    BendingAngle(i) = BendingAngle(i) + THERING{AT.ATIndex(i,j)}.BendingAngle;
                end
                DeltaPB(i) = (NewPhysicsValue(i) - BendingAngle(i))/SeptumLength(i);
            end
            
            for i=1:size(DeltaPB,1)
                for j = 1:Nsplit
                    THERING{AT.ATIndex(i,j)}.PolynomB(1) = DeltaPB(i); 
                end
            end
            
        elseif strcmpi(AT.ATType, 'null')
            % JR - do nothing behaviour
            
        else
            %error(sprintf('ATType unknown for Family %s', Family));
            for i = 1:size(NewSP,1)
                THERING{ATIndexList(i)}.(Field) = NewSP(i);
            end
        end
    end
end



% Look to see if the THERINGCELL needs to be updated
if ~isempty(ATModelNumber)
    THERINGCELL{ATModelNumber} = THERING;
end

