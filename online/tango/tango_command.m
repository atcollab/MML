function tango_command(varargin)

%
[FamilyIndex, AO] = isfamily(varargin{1});

if FamilyIndex
    Family = varargin{1};
    if length(varargin) >= 1
        DeviceList = varargin{2};
        commandName = varargin{3};
    end
    local_command(AO, DeviceList, commandName);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Function for Getting Data using the Accelerator Object  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function [AM, tout, DataTime, ErrorFlag, DeviceIndex] = local_command(AO, Field, DeviceList, OutputDataType, t, FreshDataFlag, TimeOutPeriod)
function [AM, tout, DataTime, ErrorFlag, DeviceIndex] = local_command(AO, DeviceList, commandName)
%  INPUTS
%  1. AO - the ACCELERATOR_OBJECT structure for the called family
%  2. Field - 'Monitor' or 'Setpoint'
%  3. DeviceList - Device list 
%
%  OUTPUTS
%  1. AM - Vector a read values
%  2. TimeStamp - timestamp when data collected
%  3. ErrorFlag - 0 if OK, else 1
%  4. DeviceIndex - List of status 1 devices

%  Written by Gregory J. Portmann
%  Modified by Laurent S. Nadolski

t0 = clock;
ErrorFlag = 0;
N = 0;  % Output size

% Find the index for where the desired data is in the total device list
DeviceListTotal = AO.DeviceList;
[DeviceIndex, iNotFound] = findrowindex(DeviceList, DeviceListTotal);
if length(iNotFound) > 0
    % Device not found
    for i = 1:length(iNotFound)
        fprintf('   No devices to get for Family %s(%d,%d)\n', AO.FamilyName, DeviceList(i,1), DeviceList(i,2));
    end
    error('%d Devices not found', length(iNotFound));
end

% Check the DeviceIndex
if isempty(DeviceIndex)
    DataTime = 0 + 0*sqrt(-1);
    tout = etime(clock, t0);
    AM = [];
    %fprintf('   WARNING:  No devices to get for Family %s (getpv)\n', AO.FamilyName);
    return;
end

%% TANGO specific part

% Load Field sub-structure into AOField
if ~isfield(AO, Field);
    % Try changing the suffix of the Monitor or Setpoint field
    if isfield(AO, 'Setpoint')
        Tango = family2tango(AO, 'Setpoint', DeviceList);
    elseif isfield(AO, 'Monitor')
        Tango = family2tango(AO, 'Monitor', DeviceList);
    else
        error(sprintf('Field %s not found for Family %s', Field, AO.FamilyName));
    end
    if any(strcmpi(getfamilydata('Machine'),{'spear3','spear'}))
        % Change the last ':' Field
        i = findstr(Tango(1,:),':');
        if ~isempty(i)
            Tango(:,i:end) = [];
        end
        Tango = strcat(Tango, [':',Field]);
    else
        % Add a .Field 
        Tango = strcat(Tango, ['.',Field]);
    end

    ExtraTimeDelay = etime(clock, t0);
    if nargout < 3
        [AM, tout] = getpvonline(Tango, OutputDataType, N, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
    else
        [AM, tout, DataTime, ErrorFlag] = getpvonline(Tango, OutputDataType, N, t-ExtraTimeDelay, FreshDataFlag, TimeOutPeriod);
    end
    tout = tout + ExtraTimeDelay;
    return
end
    

AOField = AO.(Field);

% If mode does not exist, force to online mode
if isfield(AOField, 'Mode')
    Mode = AOField.Mode;
else
    Mode = 'Online';
end

%%
%=======================
%% ONLINE MACHINE
%=======================
if strcmpi(Mode,'Online')
    % Online
    if strcmpi(AOField.DataType,'Scalar')
        N = 1;  % Output size

        ExtraTimeDelay = etime(clock, t0);
        if nargout < 3
            [AM, tout] = getpvonline(AOField.TangoNames(DeviceIndex,:), Field, OutputDataType, N, t-ExtraTimeDelay);
        else
            [AM, tout, DataTime, ErrorFlag] = getpvonline(AOField.TangoNames(DeviceIndex,:), Field, OutputDataType, N, t-ExtraTimeDelay);
        end
        tout = tout + ExtraTimeDelay;

        % FreshDataFlag
        if FreshDataFlag & length(t) == 1
            % Only use FreshDataFlag for scalar t
            FreshDataCounter = FreshDataFlag;
            AM0 = AM;
            while FreshDataCounter
                if nargout < 3
                    [AM, tout] = getpvonline(AOField.TangoNames(DeviceIndex,:), Field,OutputDataType, N);
                else
                    [AM, tout, DataTime, ErrorFlag] = getpvonline(AOField.TangoNames(DeviceIndex,:), Field, OutputDataType, N);
                end

                if ~any((AM-AM0)==0)
                    FreshDataCounter = FreshDataCounter - 1;
                    AM0 = AM;
                end

                if etime(clock, t0) > TimeOutPeriod
                    k = find((AM-AM0)==0);
                    for j = 1:length(k)
                        fprintf('%s not changing.\n', deblank((AOField.TangoNames(DeviceIndex(k(j)),:))));
                    end
                    error('Timed out waiting for fresh data.');
                end
            end
            tout = etime(clock, t0);
        end
        
    elseif strcmpi(AOField.DataType, 'Vector')


        % Output(DataTypeIndex) must be equal to the number of elements in the family
        
        % There can only be one Tango or channel name for DataType='Vector'
        TangoNames = deblank(AOField.TangoNames(1,:));



        % Get data at every point in time vector, t
        AM = [];
        ExtraTimeDelay = etime(clock, t0);
        t = t - ExtraTimeDelay;
        for itime = 1:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end

            % Get data
            if nargout >= 3
                [tmp, tout, DataTime(:,itime), ErrorFlag] = getpvonline(TangoNames, 'Vector', N);
            else
                tmp = getpvonline(TangoNames, 'Vector', N);
            end
            if isfield(AOField, 'DataTypeIndex')
                tmp = tmp(AOField.DataTypeIndex);
            end
            AM = [AM tmp(DeviceIndex,:)];

            tout(itime) = etime(clock, t0);
        end

        % FreshDataFlag
        if FreshDataFlag & length(t) == 1
            % Only use FreshDataFlag for scalar t
            FreshDataCounter = FreshDataFlag;
            AM0 = AM;
            while FreshDataCounter
                if nargout >= 3
                    [AM, tout, DataTime, ErrorFlag] = getpvonline(TangoNames, 'Vector', N);
                else
                    AM = getpvonline(TangoNames, 'Vector', N);
                end
                if isfield(AOField, 'DataTypeIndex')
                    AM = AM(AOField.DataTypeIndex);
                end
                AM = AM(DeviceIndex,:);

                if ~any((AM-AM0)==0)
                    FreshDataCounter = FreshDataCounter - 1;
                    AM0 = AM;
                end

                if etime(clock, t0) > TimeOutPeriod
                    k = find((AM-AM0)==0);
                    for j = 1:length(k)
                        fprintf('%s[%d,%d] not changing.\n', AO.FamilyName, DeviceList(k(j),1), DeviceList(k(j),2));
                    end
                    error('Timed out waiting for fresh data.');
                end
            end
            tout = etime(clock, t0);
        end

    elseif strcmpi(AOField.DataType,'Matrix')

        for iDev = 1:length(DeviceIndex)
            %AM(iDev,:) = rand(1,10); DataTime(iDev,:) = now; ErrorFlag(iDev,:)=0;
            [AM(iDev,:), tout, DataTime(iDev,:), ErrorFlag(iDev,1)] = getpvonline(AOField.TangoNames(DeviceIndex(iDev),:), 'Matrix', N);
        end
        ErrorFlag = any(ErrorFlag);
        tout = etime(clock, t0);

    else
        error(sprintf('Unknown DataType for family %s.', AO.FamilyName));
    end

    % Change to physics units if Units = 'physics'
    if strcmpi(AO.(Field).Units,'physics')
        % Change to physics units
        AM = hw2physics(AO.FamilyName, Field, AM, DeviceList);
    end

elseif strcmpi(Mode,'Special')

    if isfield(AOField, 'SpecialFunctionGet')
        SpecialFunction = AOField.SpecialFunctionGet;
    elseif isfield(AOField, 'SpecialFunction')
        SpecialFunction = AOField.SpecialFunction;
    else
        error(sprintf('No special function specified for Family %s (getpv).', AO.FamilyName));
    end

    % Get data at every point in time vector, t
    ExtraTimeDelay = etime(clock, t0);
    t = t - ExtraTimeDelay;
    [AM, tout, DataTime, ErrorFlag] = feval(SpecialFunction, AO.FamilyName, Field, DeviceList, t);
    t1 = clock;
    if isempty(tout)
        tout = etime(t1, t0);
    end
    if nargout >= 3 & isempty(DataTime)
        days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
        tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
        DataTime(1:size(AM,1),1) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
    end
    if length(t) > length(tout)
        for itime = 2:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end

            % Get data
            [Tmp, toutTmp, DataTimeTmp, ErrorFlag] = feval(SpecialFunction, AO.FamilyName, Field, DeviceList, t);
            
            AM = [AM Tmp];
            DataTime = [DataTime DataTimeTmp];

            t1 = clock;
            tout(1,itime) = etime(t1, t0);
            if nargout >= 3 & isempty(DataTimeTmp)
                days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
                tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
                DataTime(1:size(AM,1),itime) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
            end
        end
    end

    % FreshDataFlag
    if FreshDataFlag & length(t) == 1
        % Only use FreshDataFlag for scalar t
        FreshDataCounter = FreshDataFlag;
        AM0 = AM;
        while FreshDataCounter
            % Get data
            [AM, tout, DataTime, ErrorFlag] = feval(SpecialFunction, AO.FamilyName, Field, DeviceList, t);

            if ~any((AM-AM0)==0)
                FreshDataCounter = FreshDataCounter - 1;
                AM0 = AM;
            end

            t1 = clock;
            if etime(t1, t0) > TimeOutPeriod
                k = find((AM-AM0)==0);
                for j = 1:length(k)
                    fprintf('%s[%d,%d] not changing.\n', AO.FamilyName, DeviceList(k(j),1), DeviceList(k(j),2));
                end
                error('Timed out waiting for fresh data.');
            end
        end
        tout = etime(t1, t0);

        if nargout >= 3 & isempty(DataTime)
            days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
            tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
            DataTime(1:size(AM,1),1) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
        end
    end    
    
    % Change to physics units if Units = 'physics'
    if strcmpi(AO.(Field).Units,'physics')
        % Change to physics units
        AM = hw2physics(AO.FamilyName, Field, AM, DeviceList);
    end
        
elseif strcmpi(Mode,'Manual')
   % Always return in hardware units (like connected to the IOC)
    % The conversion to physics in done at the end
    t = 0;
    if strcmp(AO.FamilyName, 'TUNE')
        HarmNumber = [];
        RF = [];
        if find(DeviceIndex == 1)
            AM(1,1) = input(sprintf('   Input the horizontal tune (fraction or Hz) = '));
            if AM(1,1) > 1
                HarmNumber = getharmonicnumber;
                RF = getrf('Struct');
                if strcmpi(RF.UnitsString,'MHz')
                    FundFreq = 1e6*RF.Data / HarmNumber;
                elseif strcmpi(RF.UnitsString,'Hz')
                    FundFreq = RF.Data / HarmNumber;
                else
                    error('RF units in not known.');
                end
                %AM(1,1) = (AM(1,1)- RF) / FundFreq;
                AM(1,1) = AM(1,1) / FundFreq;
                fprintf('   Horizontal fraction tune computed to be %f\n\n', AM(1,1));
            end
        end
        if find(DeviceIndex == 2)
            AM(2,1) = input(sprintf('   Input the vertical   tune (fraction or Hz) = '));
            if AM(2,1) > 1
                if isempty(HarmNumber)
                    HarmNumber = getharmonicnumber;
                end
                if isempty(RF)
                    RF = getrf('Struct');
                end
                if strcmpi(RF.UnitsString,'MHz')
                    FundFreq = 1e6*RF.Data / HarmNumber;
                elseif strcmpi(RF.UnitsString,'Hz')
                    FundFreq = RF.Data / HarmNumber;
                else
                    error('RF units in not known.');
                end
                AM(2,1) = AM(2,1)/FundFreq;
                %AM(2,1) = (AM(2,1) - HarmNumber * FundFreq)/FundFreq;
                fprintf('   Vertical   fraction tune computed to be %f\n\n', AM(2,1));
            end
        end
        if find(DeviceIndex == 3)
            AM(2,1) = input('   Input the synchrotron tune = ');
        end
    elseif strcmp(AO.FamilyName, 'RF')
        if strcmpi(AO.(Field).Units, 'Hardware')
            AM(1) = input(sprintf('   Input the RF frequency [%s] = ', AO.(Field).HWUnits));
        else
            AM(1) = input(sprintf('   Input the RF frequency [%s] = ', AO.(Field).PhysicsUnits));
            AM = physics2hw(AO.FamilyName, Field, AM, [1 1]);
        end
    else
        for i = 1:length(DeviceIndex)
            if strcmpi(AO.(Field).Units, 'Hardware')
                AM(i,:) = input(sprintf('   Manual input:  %s(%d,%d) [%s] = ', AO.FamilyName, AO.DeviceList(DeviceIndex(i),1), AO.DeviceList(DeviceIndex(i),2), AO.(Field).HWUnits));
            else
                AM(i,:) = input(sprintf('   Manual input:  %s(%d,%d) [%s] = ', AO.FamilyName, AO.DeviceList(DeviceIndex(i),1), AO.DeviceList(DeviceIndex(i),2), AO.(Field).PhysicsUnits));
                AM(i,:) = physics2hw(AO.FamilyName, Field, AM(i,:), AO.DeviceList(DeviceIndex(i),:));
            end
        end
    end
    
    t1 = clock;
    tout = etime(t1, t0);
    days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
    tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
    DataTime(1:size(AM,1),1) = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
    
    % Change to physics units if Units = 'physics'
    if strcmpi(AO.(Field).Units,'physics')
        % Change to physics units
        AM = hw2physics(AO.FamilyName, Field, AM, DeviceList);
    end
   
%====================
%% MODEL or SIMULATOR
%====================
elseif strcmpi(Mode,'Simulator') || strcmpi(Mode,'Model')    
    error('Unknown mode for family %s.', AO.FamilyName)
else
    error('Unknown mode for family %s.', AO.FamilyName);
end


% Return a column vector
%AM = AM(:);  doesn't work for strings or matrices
