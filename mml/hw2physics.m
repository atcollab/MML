function S = hw2physics(Family, Field, value, DeviceList, Energy)
%HW2PHYSICS - Converts from 'Hardware' units to 'Physics' units
%  ValPhysics = hw2physics(Family, Field, ValHW, DeviceList, Energy)
%
%  For data structure inputs: 
%  ValPhysics = hw2physics(DataStructure, Energy)
%
%  HW2PHYSICS converts the values in 'Hardware' units read from PV's
%  to 'Physics' units using the conversion function and conversion paramaters
%  stored in the AO fields HW2PhysicsFcn and HW2PhysicsParams
%
%  Energy can be anything getenergy accepts, like 'Model' or 'Online' {Default: 'Production'}
%
%  INPUTS
%  1.  Family - Family name
%  2.  Field - Typically 'Monitor' or 'Setpoint'
%  3.  Value - Data for conversion
%  4.  DeviceList - List of devices
%  5.  Energy - Extra parameter for energy. Default is 'Production'
%
%  OUTPUTS
%  1. S - Result of conversion from hardware to physics units
%
%  NOTES
%  1. For structure inputs, if the data is already in physics units
%     then no conversion will be done!
%  2. Energy may not be dealt with directly in this function, it
%     depends on how HW2PhysicsFcn deals with energy change.
%  3. The gain/offset conversions are done in raw2real & real2raw.
%
%  See also hw2physic, raw2real, real2raw
 
%  Written by Andrei Terebilo and Greg Portmann

S = [];

if nargin < 1
    error('1 (data structure), 3, or 4 inputs required');
end

if ischar(Family)
    if nargin < 3
        error('3-4 inputs required');
    end
    if nargin < 4
        DeviceList = [];
    end
    if isempty(DeviceList)
        DeviceList = family2dev(Family);
    end
    if nargin < 5
        Energy = 'Production';
    end
    
    if size(DeviceList,1) ~= size(value,1)
        if size(value,1) == 1
            value = ones(size(DeviceList,1),1) * value;
        else
            error('The length of ValHW must match the number of devices');
        end
    end
    
    FunctionStr = getfamilydata(Family, Field, 'HW2PhysicsFcn');
    Params      = getfamilydata(Family, Field, 'HW2PhysicsParams', DeviceList);
    
    
    % First convert to "corrected" hardware units (usually based on LOCO gains)
    value = raw2real(Family, Field, value, DeviceList);

    if isempty(FunctionStr)
        if isempty(Params)
            % No info on how to convert, so use a gain of 1
            S = value;
        else
            % If no function, use a constant scaling
            for i = 1:size(value,2)
                S(:,i) = value(:,i) .* Params(:,1);
            end
        end

        % Energy scaling this way works for magnets but not BPMs, RF, or maybe other stuff!
        % So if you want energy scaling do it with a function like amp2k
        % if ~ismemberof(Family,'BPM')
        %    if isempty(Energy)
        %        Energy = getenergy;
        %    elseif ischar(Energy)
        %        Energy = getenergy(Energy);
        %    end
        %    S(:,i) = S(:,i) * getbrho(getenergy('Production')) / getbrho(Energy);
        % end
        if ~ischar(Energy)
            % Expand to the length of Energy input
            if size(S,1) == 1
                S = S * ones(1,size(Energy,2));
            end
        end

    else
        % Use inline or user specified function
        if isempty(Energy)
            Energy = getenergy;
        elseif ischar(Energy)
            Energy = getenergy(Energy);
        end
        if iscell(Params)
            S = feval(FunctionStr, Family, Field, value, DeviceList, Energy, Params{:});
        elseif isempty(Params)
            S = feval(FunctionStr, Family, Field, value, DeviceList, Energy);
        elseif ischar(Params)
            S = feval(FunctionStr, Family, Field, value, DeviceList, Energy, Params);
        else
            % This will make all elements in the row vector a separate input
            ParamsList = num2cell(Params,1);
            S = feval(FunctionStr, Family, Field, value, DeviceList, Energy, ParamsList{:});
        end
    end

elseif isstruct(Family)   
    % Convert entire data structure e.g. response matrix
    % Note: S(j,k).GeV is used instead of the energy input because the response does not change with energy in physics units 
    S = Family;
   
    for j = 1:size(S,1)
        for k = 1:size(S,2)

            if isfield(S(j,k),'Monitor') && isfield(S(j,k),'Actuator')
                % Response matrix structure

                if nargin < 2
                    %Energy = 'Production';
                    Energy = S(j,k).GeV;
                else
                    if ~isempty(Field)
                        Energy = Field;
                    else
                        Energy = S(j,k).GeV;
                    end
                end

                % Note: Chromaticity and Dispersion are special cases
                if strcmpi(S(j,k).Monitor.FamilyName, 'Chromaticity')
                    % Chromaticity response matrix
                    if ~strcmpi(S(j,k).Units, 'Physics')
                        RF = S(j,k).Monitor.Actuator.Data;
                        MCF = S(j,k).Monitor.MCF;
                        S(j,k).Data = - S(j,k).Data * RF(1) * MCF;
                        S(j,k).Monitor  = hw2physics(S(j,k).Monitor);    % Chromaticity structure (also a response structure)
                        
                        ActuatorDeltaHardware = S(j,k).ActuatorDelta;
                        S(j,k).ActuatorDelta = hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                                               hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);
                        ActuatorScaleFactor = S(j,k).ActuatorDelta ./ ActuatorDeltaHardware;
                        ActuatorScaleFactor = ActuatorScaleFactor(:)';
                        S(j,k).Actuator = hw2physics(S(j,k).Actuator, S(j,k).GeV);  % Sextupole
                        
                        % Scalar row by the actuator scaling
                        for i = 1:size(S(j,k).Data,1)
                            S(j,k).Data(i,:) = S(j,k).Data(i,:) ./ ActuatorScaleFactor;
                        end
                        
                        % Change units and UnitsString fields
                        if isfield(S(j,k),'Units')
                            S(j,k).Units = 'Physics';
                        end
                        if isfield(S(j,k),'UnitsString')
                            if isfield(S(j,k).Monitor,'UnitsString') && isfield(S(j,k).Actuator,'UnitsString')
                                %S(j,k).UnitsString = '(Fractional Tune/(dp/p))/meter^-3';
                                S(j,k).UnitsString = [S(j,k).Monitor.UnitsString , '/', S(j,k).Actuator.UnitsString];
                            else
                                S(j,k).UnitsString = '';
                            end
                        end
                    end
                elseif strcmpi(S(j,k).Monitor.FamilyName, 'TUNE') && strcmpi(S(j,k).Actuator.FamilyName, 'RF')
                    % Chromaticity measurement
                    if ~strcmpi(S(j,k).Units, 'Physics')
                        RF = S(j,k).Actuator.Data;
                        MCF = S(j,k).MCF;
                        S(j,k).Data = - S(j,k).Data * RF(1) * MCF;
                        
                        if isfield(S(j,k),'Tune') && isfield(S(j,k),'PolyFit')
                            p = polyfit(S(j,k).dp, S(j,k).Tune(1,:), 2);
                            S(j,k).PolyFit(1,:) = p;
                            % S(j,k).Data(1,1) = p(2);
                            p = polyfit(S(j,k).dp, S(j,k).Tune(2,:), 2);
                            S(j,k).PolyFit(2,:) = p;
                            % S(j,k).Data(2,1) = p(2);
                        end
                        
                        % Convert the Monitor and Actuator fields
                        %S(j,k).Monitor  = hw2physics(S(j,k).Monitor);   % Tune structure (same in Hardware and Physics) 
                        S(j,k).ActuatorDelta = hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                                               hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);
                        S(j,k).Actuator = hw2physics(S(j,k).Actuator, S(j,k).GeV);  % RF

                        S(j,k).Units = 'Physics';
                        %S(j,k).UnitsString = '1/(dp/p)';
                        S(j,k).UnitsString = [S(j,k).Monitor.UnitsString,'/(dp/p)'];
                    end
                elseif ismemberof(S(j,k).Monitor.FamilyName, 'BPM') && strcmpi(S(j,k).Actuator.FamilyName, 'RF')
                    % Dispersion measurement
                    if ~strcmpi(S(j,k).Units, 'Physics')
                        % Change to physics units
                        
                        % Change the numerator as if it was a BPM (but remove the offset)
                        d = S(j,k).Monitor;
                        d.Data = S(j,k).Data + getoffset(S(j,k).Monitor.FamilyName, 'Monitor', S(j,k).Monitor.DeviceList, 'Hardware');
                        d = hw2physics(d, S(j,k).GeV);
                        S(j,k).Data = d.Data;
                        
                        % Change to denominator to energy shift (dp/p)
                        RF = S(j,k).Actuator.Data;
                        MCF = S(j,k).MCF;
                        S(j,k).Data = -RF(1) * MCF * S(j,k).Data;
                        
                        % Change the Monitor and Actuator fields
                        S(j,k).Monitor  = hw2physics(S(j,k).Monitor, S(j,k).GeV);
                        S(j,k).ActuatorDelta = hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                                               hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);
                        S(j,k).Actuator = hw2physics(S(j,k).Actuator, S(j,k).GeV);

                        S(j,k).Units = 'Physics';
                        S(j,k).UnitsString = [S(j,k).Monitor.UnitsString,'/(dp/p)'];
                    end
                    
                else
                    % Typical response matrix  (usually orbit/corrector) 
                    % Need to determine the hw2physics scaling for delta monitor / delta actuator
                    
                    % Only change units if in 'Hardware' units
                    if strcmpi(S(j,k).Actuator.Units, 'Hardware')                        
                        % Convert .ActuatorDelta
                        ActuatorDeltaHW = S(j,k).ActuatorDelta;
                        
                        % Scale Factor without energy scaling (since physics units are the same at all energies)
                        S(j,k).ActuatorDelta = hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                                               hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);

                        % Physics units / HW units
                        ActuatorScaleFactor = S(j,k).ActuatorDelta ./ ActuatorDeltaHW;
                        ActuatorScaleFactor = ActuatorScaleFactor(:)';
            
                        % Convert .Actuator field
                        S(j,k).Actuator = hw2physics(S(j,k).Actuator, S(j,k).GeV);
                        
                        %ActuatorData = S(j,k).Actuator.Data;
                        %S(j,k).Actuator = physics2hw(S(j,k).Actuator);
                        %if any(ActuatorData == 0)
                        %    ActuatorScaleFactor = hw2physics(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, 1, S(j,k).Actuator.DeviceList, S(j,k).GeV); 
                        %else
                        %    ActuatorScaleFactor = S(j,k).Actuator.Data ./ ActuatorData;
                        %end
                    else
                        % Don't include energy scaling of actuator if already in physics units
                        ActuatorScaleFactor = 1; %Energy/S(j,k).GeV;
                        ActuatorDeltaHW = S(j,k).ActuatorDelta;
                    end
                    

                    % Only change units if in 'Hardware' units
                    if strcmpi(S(j,k).Monitor.Units, 'Hardware')                        
                        % Just to get an approximate scaling for the monitor size
                        %MonitorDeltaHW = max(abs(S(j,k).Data(:,1) * ActuatorDeltaHW(1)));
                        %MonitorDelta = hw2physics(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, MonitorDeltaHW + S(j,k).Monitor.Data, S(j,k).Monitor.DeviceList, S(j,k).GeV) - ...
                        %               hw2physics(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field,                  S(j,k).Monitor.Data, S(j,k).Monitor.DeviceList, S(j,k).GeV);
                        %%MonitorDelta = hw2physics(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, MonitorDeltaHW, S(j,k).Monitor.DeviceList, Energy) - getoffset(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 'Hardware');
                        %
                        %MonitorScaleFactor = MonitorDelta ./ MonitorDeltaHW;
                        %MonitorScaleFactor = MonitorScaleFactor(:);
                        
                        % hw2physics must be linear for this to work, but the other methods have issues with small numbers
                        %MonitorScaleFactor = hw2physics(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 1+getoffset(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field), S(j,k).Monitor.DeviceList, S(j,k).GeV, 'Hardware');                     
                        MonitorScaleFactor = hw2physics(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 1, S(j,k).Monitor.DeviceList, S(j,k).GeV) - ...
                                             hw2physics(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 0, S(j,k).Monitor.DeviceList, S(j,k).GeV);

                        % Convert .Monitor field
                        S(j,k).Monitor = hw2physics(S(j,k).Monitor, S(j,k).GeV);

                        % Convert .Monitor1 and .Monitor2 field ???

                        %MonitorData = S(j,k).Monitor.Data;
                        %S(j,k).Monitor = physics2hw(S(j,k).Monitor);
                        %if any(MonitorData == 0)
                        %    % This might introduce an error if physics2hw is nonlinear
                        %    MonitorScaleFactor = hw2physics(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 1, S(j,k).Monitor.DeviceList, S(j,k).GeV); 
                        %else
                        %    MonitorScaleFactor = S(j,k).Monitor.Data ./ MonitorData;
                        %end
                    else
                        MonitorScaleFactor = 1;
                    end

                    
                    % Scalar column by the monitor scaling
                    for i = 1:size(S(j,k).Data,2)
                        S(j,k).Data(:,i) = MonitorScaleFactor .* S(j,k).Data(:,i);
                    end
                    %S(j,k).MonitorScaleFactor = MonitorScaleFactor;
                    
                    % Scalar row by the actuator scaling
                    for i = 1:size(S(j,k).Data,1)
                        S(j,k).Data(i,:) = S(j,k).Data(i,:) ./ ActuatorScaleFactor;
                    end
                    %S(j,k).ActuatorScaleFactor = ActuatorScaleFactor;
                    
                    S(j,k).GeV = Energy;

                    % Change units and unitsstring fields
                    if isfield(S(j,k),'Units')
                        S(j,k).Units = 'Physics';
                    end
                    if isfield(S(j,k),'UnitsString')
                        if isfield(S(j,k).Monitor,'UnitsString') && isfield(S(j,k).Actuator,'UnitsString')
                            S(j,k).UnitsString = [ ...
                                    S(j,k).Monitor.UnitsString , '/', ...
                                    S(j,k).Actuator.UnitsString];
                            %S(j,k).UnitsString = [ ...
                            %        getfamilydata(S(j,k).Monitor.FamilyName,  S(j,k).Monitor.Field,  'PhysicsUnits') , '/', ...
                            %        getfamilydata(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, 'PhysicsUnits')];
                        else
                            S(j,k).UnitsString = '';
                        end
                    end
                end

            elseif isfield(S(j,k),'FamilyName') && isfield(S(j,k),'Field')
                % Data structure

                if nargin < 2
                    if isfield(S(j,k), 'GeV')
                        Energy = S(j,k).GeV;
                    else
                        Energy = 'NoEnergyScaling';
                        %Energy = 'Production';
                    end
                else
                    Energy = Field;
                end

                % Only change units if in 'Hardware' units
                if ~strcmpi(S(j,k).Units, 'Physics')
                    % First convert to "corrected" hardware units
                    %S(j,k) = raw2real(S(j,k));  Done in hw2physics for FamilyName inputs
                    
                    S(j,k).Data = hw2physics(S(j,k).FamilyName, S(j,k).Field, S(j,k).Data, S(j,k).DeviceList, Energy);
                    S(j,k).Units = 'Physics';
                    S(j,k).UnitsString = getfamilydata(S(j,k).FamilyName, S(j,k).Field, 'PhysicsUnits');
                                        
                    % Special fields
                    %if any(strcmpi(S(j,k).CreatedBy, {'monbpm','measbpmsigma','getsigma'})) && isfield(S(j,k), 'Sigma')
                    if isfield(S(j,k),'Sigma') && size(S(j,k).Data,1)==length(S(j,k).Sigma)
                        % monbpm data (add the offset first for difference orbits, since hw2physics will remove it)
                        S(j,k).Sigma = S(j,k).Sigma + getoffset(S(j,k).FamilyName, S(j,k).Field, S(j,k).DeviceList, 'Hardware');
                        S(j,k).Sigma = hw2physics(S(j,k).FamilyName, S(j,k).Field, S(j,k).Sigma, S(j,k).DeviceList, Energy);
                    end
                end
                
            else
                error('Unknown data structure type');
            end
        end
    end
    
elseif iscell(Family)
    error('Cell array inputs not programmed yet');
    
else 
    error('Input #1 type unknown');
end


