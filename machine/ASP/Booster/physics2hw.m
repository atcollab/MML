function S = physics2hw(Family, Field, value, DeviceList, Energy)
%PHYSICS2HW - Converts from 'Physics' units to 'Hardware' units
%  ValHW = hw2physics(Family, Field, ValPhysics, DeviceList, Energy)
%
%  For data structure inputs: 
%  ValHW = hw2physics(DataStructure)
%
%  PHYSICS2HW converts the values from 'Physics' units to 'Hardware'
%  units for writting to PV's using the conversion function and 
%  conversion paramaters stored in the AO
%
%  Energy can be anything getenergy accepts, like 'Model' or 'Online' 
%
%  NOTES
%  1. Field is typically 'Monitor' or 'Setpoint'
%  2. For structure inputs, if the data is already in hardware units
%     then no conversion will be done!
%  3. Energy may not be dealt with directly in this function, it
%     depends on how Physics2HWFcn deals with energy change.
%
%  Written by A. Terebilo and G. Portmann

S = [];

if nargin < 1
    error('1 (data structure), 3, or 4 inputs required');
end

if ischar(Family)
    if nargin < 3
        error('At least 3 inputs required.');
    end
    if nargin < 4
        DeviceList = [];
    end
    if isempty(DeviceList)
        DeviceList = family2dev(Family);
    end
    if nargin < 5
        if strcmpi(getmode(Family),'Online')
            Energy = 'Online';
        else
            Energy = 'Production';
        end
    end
    
    if size(DeviceList,1) ~= size(value,1)
        if size(value,1) == 1
            value = value * ones(size(DeviceList,1),1);
        else
            error('The length of ValPhysics must match the number of devices');
        end
    end
    
    
    FunctionStr = getfamilydata(Family, Field, 'Physics2HWFcn');
    Params      = getfamilydata(Family, Field, 'Physics2HWParams', DeviceList);
    

    for i = 1:size(value,2)
        if isempty(FunctionStr)
            if isempty(Params)
                % No info on how to convert, so use a gain of 1
                S(:,i) = value(:,i);
            else
                % If no function, use a constant scaling
                S(:,i) = value(:,i) .* Params(:,1);
                
                % Energy scaling this way works for magnets but not BPMs or maybe other stuff!
                % So if you want energy scaling do it as a function like k2amp
                % if ~ismemberof(Family,'BPM')
                %    if isempty(Energy)
                %        Energy = getenergy;
                %    elseif ischar(Energy)
                %        Energy = getenergy(Energy);
                %    end
                %    S(:,i) = S(:,i) * getbrho(Energy) / getbrho(getenergy('Production'));
                % end
            end
            
            
        else
            % Use inline or user specified function
            if isempty(Energy)
                Energy = getenergy;
            elseif ischar(Energy)
                Energy = getenergy(Energy);
            end
            if iscell(Params)
                S(:,i) = feval(FunctionStr, Family, Field, value(:,i), DeviceList, Energy, Params{:});
            elseif isempty(Params)
                S(:,i) = feval(FunctionStr, Family, Field, value(:,i), DeviceList, Energy);
            elseif isstr(Params)
                S(:,i) = feval(FunctionStr, Family, Field, value(:,i), DeviceList, Energy, Params);
            else
                % This will make all elements in the row vector a separate input
%                 ParamsList = num2cell(Params,1);
%                 S(:,i) = feval(FunctionStr, Family, Field, value(:,i),
%                 DeviceList, Energy, ParamsList{:});
                % This version edited for ASP by Eugene.
                S(:,i) = feval(FunctionStr, Family, Field, value(:,i), DeviceList, Energy, Params);
            end
        end
    end

    
    % Lastly convert to raw hardware units (usually based on LOCO gains)
    S = real2raw(Family, Field, S, DeviceList);
    
    
elseif isstruct(Family)
    S = Family;

    for j = 1:size(S,1)
        for k = 1:size(S,2)

            if isfield(S(j,k),'Monitor') & isfield(S(j,k),'Actuator')
                % Response matrix structure

                if nargin < 2
                    %Energy = 'Production';
                    Energy = S(j,k).GeV;
                else
                    Energy = Field;
                end

                % Note: Chromaticity and Dispersion are special cases
                if strcmpi(S(j,k).Monitor.FamilyName, 'Chromaticity')
                    % Chromaticity response matrix
                    if ~strcmpi(S(j,k).Units, 'Hardware')
                        RF = S(j,k).Monitor.Actuator.Data;
                        MCF = S(j,k).Monitor.MCF;
                        S(j,k).Data = - S(j,k).Data / RF(1) / MCF;
                        S(j,k).Monitor = physics2hw(S(j,k).Monitor);   % Chromaticity structure (also a response structure)
                        
                        ActuatorDeltaPhysics = S(j,k).ActuatorDelta;
                        S(j,k).ActuatorDelta = physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                                               physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);
                        ActuatorScaleFactor = S(j,k).ActuatorDelta ./ ActuatorDeltaPhysics;
                        ActuatorScaleFactor = ActuatorScaleFactor(:)';
                        S(j,k).Actuator = physics2hw(S(j,k).Actuator, S(j,k).GeV);  % Sextupole
                        
                        % Scalar row by the actuator scaling
                        for i = 1:size(S(j,k).Data,1)
                            S(j,k).Data(i,:) = S(j,k).Data(i,:) ./ ActuatorScaleFactor;
                        end

%                         if abs(S(j,k).GeV-Energy)>1e-2 & (S(j,k).GeV~=NaN)  & (Energy~=NaN)
%                             fprintf('   Response matrix scaled to %.3f GeV using R(%.3f) = %.3f * R(%.3f) / %.3f (physics2hw)\n', Energy, Energy, S(j,k).GeV, S(j,k).GeV, Energy);
%                         end
%                         S(j,k).GeV = Energy;

                        % Change units and UnitsString fields
                        if isfield(S(j,k),'Units')
                            S(j,k).Units = 'Hardware';
                        end
                        if isfield(S(j,k),'UnitsString')
                            if isfield(S(j,k).Monitor,'UnitsString') & isfield(S(j,k).Actuator,'UnitsString')
                                S(j,k).UnitsString = [S(j,k).Monitor.UnitsString , '/', S(j,k).Actuator.UnitsString];
                            else
                                S(j,k).UnitsString = '';
                            end
                        end
                    end
                    
                elseif strcmpi(S(j,k).Monitor.FamilyName, 'TUNE') & strcmpi(S(j,k).Actuator.FamilyName, 'RF')
                    % Chromaticity measurement
                    if ~strcmpi(S(j,k).Units, 'Hardware')
                        % Convert the Monitor and Actuator fields
                        %S(j,k).Monitor  = physics2hw(S(j,k).Monitor);   % Tune structure (same in Hardware and Physics) 
                        S(j,k).ActuatorDelta = physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                                               physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);
                        S(j,k).Actuator = physics2hw(S(j,k).Actuator, S(j,k).GeV);  % RF
                         
                        RF = S(j,k).Actuator.Data;
                        MCF = S(j,k).MCF;
                        DeltaRF = S(j,k).ActuatorDelta;        
                        
                        S(j,k).Data = - S(j,k).Data / RF(1) / MCF;
                        p = polyfit(DeltaRF, S(j,k).Tune(1,:), 2);
                        S(j,k).PolyFit(1,:) = p;
                        %S(j,k).Data(1,1) = p(2);
                        p = polyfit(DeltaRF, S(j,k).Tune(2,:), 2);
                        S(j,k).PolyFit(2,:) = p;
                        %S(j,k).Data(2,1) = p(2);
                        S(j,k).Units = 'Hardware';
                        S(j,k).UnitsString = [S(j,k).Monitor.UnitsString,'/',S(j,k).Actuator.UnitsString];
                    end
                    
                elseif ismemberof(S(j,k).Monitor.FamilyName, 'BPM') & strcmpi(S(j,k).Actuator.FamilyName, 'RF')
                    % Dispersion measurement
                    if ~strcmpi(S(j,k).Units, 'Hardware')
                        % Change to Hardware units
                        
                        % Change the numerator as if it was a BPM (but remove the offset)
                        d = S(j,k).Monitor;
                        d.Data = S(j,k).Data;
                        d = physics2hw(d, S(j,k).GeV);
                        d.Data = d.Data - getoffset(S(j,k).Monitor.FamilyName, 'Monitor', S(j,k).Monitor.DeviceList);
                        S(j,k).Data = d.Data;
                        
                        % Change the Monitor and Actuator fields
                        S(j,k).Monitor  = physics2hw(S(j,k).Monitor);
                        S(j,k).ActuatorDelta = physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                                               physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);
                        S(j,k).Actuator = physics2hw(S(j,k).Actuator, S(j,k).GeV);
                        
                        % Change to denominator to energy shift (dp/p)
                        RF = S(j,k).Actuator.Data;
                        MCF = S(j,k).MCF;
                        S(j,k).Data = -S(j,k).Data / RF(1) / MCF;
                        S(j,k).Units = 'Hardware';
                        S(j,k).UnitsString = [S(j,k).Monitor.UnitsString,'/',S(j,k).Actuator.UnitsString];
                    end
                    
                else
                    % Typical response matrix (usually orbit/corrector) 
                    % Need to determine the hw2physics scaling for delta monitor / delta actuator
                    
%                     % For BPM response matrices the coupling needs to be taken into account
%                     if ismemberof(S(j,k).Monitor.FamilyName,'BPM') & ismemberof(S(j,k).Actuator.FamilyName,'COR')
%                         % The loco corrected orbit is,
%                         % X = (1./Gx) .* X  +  Cx .* Y 
%                         % Y = (1./Gy) .* Y  +  Cy .* X 
%                         % 
%                         % Since real2raw (in physics2hw) will divide by Gy, multiple the above 
%                         % equation by Gy so that the hardware units output is correct
%                         BPMxGain = getgain(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, );
%                         BPMyGain = getgain(BPMyFamily, BPMyList);
%                         BPMxCoupling = getcoupling(BPMxFamily, BPMxList);
%                         BPMyCoupling = getcoupling(BPMyFamily, BPMyList);
%                         
%                         C = [diag(ones(size(BPMxList,1),1))  diag(BPMxGain .* BPMxCoupling)
%                              diag(BPMyGain .* BPMyCoupling)  diag(ones(size(BPMyList,1),1))];
%                         
%                         % Rotate Mmodel
%                         R0 = C * R0;
%                     end
                    
                    
                    % Only change units if in 'Physics' units
                    if strcmpi(S(j,k).Actuator.Units, 'Physics')                        
                        % Convert .ActuatorDelta
                        ActuatorDeltaPhysics = S(j,k).ActuatorDelta;
                        
                        % Scale Factor w/o energy scaling
                        %ActuatorDeltaNoEnergyScaling = physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV) - ...
                        %                               physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, S(j,k).GeV);
                        %ActuatorScaleFactorNoEnergyScaling = ActuatorDeltaNoEnergyScaling ./ ActuatorDeltaPhysics;
                        %ActuatorScaleFactorNoEnergyScaling = ActuatorScaleFactorNoEnergyScaling(:)';
                        
                        % Scale Factor with energy scaling
                        S(j,k).ActuatorDelta = physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, S(j,k).ActuatorDelta + S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, Energy) - ...
                                               physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field,                        S(j,k).Actuator.Data, S(j,k).Actuator.DeviceList, Energy);
                        
                        % HW units (@ Energy) / Physics units (@ S(j,k).GeV)
                        ActuatorScaleFactor = S(j,k).ActuatorDelta ./ ActuatorDeltaPhysics;
                        ActuatorScaleFactor = ActuatorScaleFactor(:)';
                                              
                        % Convert .Actuator field
                        S(j,k).Actuator = physics2hw(S(j,k).Actuator, Energy);
                        
                        
                        %ActuatorData = S(j,k).Actuator.Data;
                        %S(j,k).Actuator = physics2hw(S(j,k).Actuator);
                        %if any(ActuatorData == 0)
                        %    ActuatorScaleFactor = physics2hw(S(j,k).Actuator.FamilyName, S(j,k).Actuator.Field, 1, S(j,k).Actuator.DeviceList, Energy); 
                        %else
                        %    ActuatorScaleFactor = S(j,k).Actuator.Data ./ ActuatorData;
                        %end

                    else
                        % Include energy scaling of actuator
                        ActuatorScaleFactor = Energy / S(j,k).GeV;
                        ActuatorDeltaPhysics = S(j,k).ActuatorDelta;
                    end

                    if abs(S(j,k).GeV-Energy)>1e-2 & (S(j,k).GeV~=NaN)  & (Energy~=NaN)
                        fprintf('   Response matrix scaled to %.3f GeV using R(%.3f) = %.3f * R(%.3f) / %.3f (physics2hw)\n', Energy, Energy, S(j,k).GeV, S(j,k).GeV, Energy);
                    end

                    
                    % Only change units if in 'Physics' units
                    if strcmpi(S(j,k).Monitor.Units, 'Physics')                        
                        % Just to get an approximate scaling for the monitor size
                        %MonitorDeltaPhysics = max(abs(S(j,k).Data(:,1) * ActuatorDeltaPhysics(1)));
                        %MonitorDelta = physics2hw(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, MonitorDeltaPhysics + S(j,k).Monitor.Data, S(j,k).Monitor.DeviceList, S(j,k).GeV) - ...
                        %               physics2hw(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field,                  S(j,k).Monitor.Data, S(j,k).Monitor.DeviceList, S(j,k).GeV);
                        %%MonitorDelta = physics2hw(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, MonitorDeltaPhysics, S(j,k).Monitor.DeviceList, S(j,k).GeV) - getoffset(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field);
                        %
                        %MonitorScaleFactor = MonitorDelta ./ MonitorDeltaPhysics;
                        %MonitorScaleFactor = MonitorScaleFactor(:);
                        
                        % physics2hw must be linear for this to work, but the other methods have issues with small numbers
                        MonitorScaleFactor = physics2hw(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 1, S(j,k).Monitor.DeviceList, Energy) - ...
                                             physics2hw(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 0, S(j,k).Monitor.DeviceList, Energy);

                        % Convert .Monitor field
                        S(j,k).Monitor = physics2hw(S(j,k).Monitor, Energy);
                        
                        %MonitorData = S(j,k).Monitor.Data;
                        %S(j,k).Monitor = physics2hw(S(j,k).Monitor);
                        %if any(MonitorData == 0)
                        %    % This might introduce an error if physics2hw is nonlinear
                        %    MonitorScaleFactor = physics2hw(S(j,k).Monitor.FamilyName, S(j,k).Monitor.Field, 1, S(j,k).Monitor.DeviceList, S(j,k).GeV); 
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

                    % Change units and UnitsString fields
                    if isfield(S(j,k),'Units')
                        S(j,k).Units = 'Hardware';
                    end
                    if isfield(S(j,k),'UnitsString')
                        if isfield(S(j,k).Monitor,'UnitsString') & isfield(S(j,k).Actuator,'UnitsString')
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
                
            elseif isfield(S(j,k),'FamilyName') & isfield(S(j,k),'Field')
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

                % Only change units if in 'Physics' units
                if ~strcmpi(S(j,k).Units, 'Hardware')
                    S(j,k).Data = physics2hw(S(j,k).FamilyName, S(j,k).Field, S(j,k).Data, S(j,k).DeviceList, Energy);
                    S(j,k).Units = 'Hardware';
                    S(j,k).UnitsString = getfamilydata(S(j,k).FamilyName, S(j,k).Field, 'HWUnits');
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
