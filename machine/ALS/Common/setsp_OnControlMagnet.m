function ErrorFlag = setsp_OnControlMagnet(Family, Field, OnControl, DeviceList, WaitFlag)
%  ErrorFlag = setsp_OnControlMagnet(Family, Field, SPnew, DeviceList, WaitFlag)


ErrorFlag = 0;

if isempty(DeviceList)
    return
end

% Makes sure DeviceList and OnControl have the same number of rows
if size(OnControl,1) == 1
    OnControl = ones(size(DeviceList,1),1) * OnControl;
end

% Turning on or off?
DeviceListOn  = DeviceList(OnControl>0,:);
DeviceListOff = DeviceList(OnControl==0,:);


if strcmpi(Family,'HCM') || strcmpi(Family,'VCM')
    TDelay = .1;
elseif strcmpi(Family,'QF') || strcmpi(Family,'QD') || strcmpi(Family,'Q')
    TDelay = .2;
else
    TDelay = .2;
end


% Turn on
if ~isempty(DeviceListOn)
    % 1. First check if the magnet is already on
    % 2. Zero the setpoint before turning on
    % 3. If the OnControl is not 0, set it to 0 only to create a transition to on
    
    % First make sure power supplies are not repeated
    ChannelName = family2channel(Family, Field,  DeviceListOn);
    [ChannelName, ii] = unique(ChannelName, 'rows');
    DeviceListOn = DeviceListOn(ii,:);

    SP = getpv(Family, 'Setpoint', DeviceListOn);
    On = getpv(Family, 'On',       DeviceListOn);
    OnControlNow = getpv(Family, Field, DeviceListOn);

    % Zero the setpoint
    for i = 1:size(DeviceListOn,1)
        % First go through and zero the setpoints and make sure the control is off
        if On(i) == 0
            % Check setpoint to be zero
            if SP(i) ~= 0
                % Zero the setpoint
                fprintf('   Zeroing the setpoint for %s(%d,%d) before turning on\n', Family, DeviceListOn(i,:));
                setpv(Family, 'Setpoint', 0, DeviceListOn(i,:));
            end
            if OnControlNow(i) ~= 0
                % Zero the OnControl
                %setpv(Family, Field, 0, DeviceListOn(i,:));
                setpv(deblank(ChannelName(i,:)), 0);
            end
        end
    end
    pause(.5);

    % Then turn on
    for i = 1:size(DeviceListOn,1)
        if On(i) == 0
            setpv(deblank(ChannelName(i,:)), OnControl(i));
            pause(TDelay);
        end
    end
    
    % If the OnControl stayed low, reset
    pause(1.1);  % Some PV only scan at 1 Hz
    On = getpv(Family, 'On', DeviceListOn);
    OnControlNow = getpv(Family, Field, DeviceListOn);
    for i = 1:size(DeviceListOn,1)
        if On(i)==0 && OnControlNow(i)==0
            setpv(Family, 'Reset', 1, DeviceListOn(i,:));
        end
    end
    
    % Then try again to turn on
    pause(.5);
    for i = 1:size(DeviceListOn,1)
        if On(i) == 0 && OnControlNow(i)==0
            setpv(deblank(ChannelName(i,:)), OnControl(i));
        end
    end
end


% Turn off
if ~isempty(DeviceListOff)
    % Only turn off a magnet if the setpoint is zero and the monitor is "near" zero
    
    % First make sure power supplies are not repeated
    ChannelName = family2channel(Family, Field,  DeviceListOff);
    [ChannelName, ii] = unique(ChannelName, 'rows');
    DeviceListOff = DeviceListOff(ii,:);

    SP = getpv(Family, 'Setpoint', DeviceListOff);
    AM = getpv(Family, 'Monitor',  DeviceListOff);
    
    % Unfortunately the SP-AM comparison does not work well at zero current
    if strcmpi(Family,'HCM') || strcmpi(Family,'VCM')
        Tol = 1;
    elseif strcmpi(Family,'QF') || strcmpi(Family,'QD') || strcmpi(Family,'QDA')
        Tol = 2;
    else
        Tol = 5;
    end
    
    % Turn off
    for i = 1:size(DeviceListOff,1)
        % Check setpoint
        if SP(i) == 0
            if abs(AM(i)) < Tol
                % Ok to turn off
                setpv(deblank(ChannelName(i,:)), OnControl(i));
                pause(.05);
            else
                fprintf('   %s(%d,%d) monitor seems large (%f) so it will not be turned off\n', Family, DeviceListOff(i,:), AM(i));
            end
        else
            fprintf('   %s(%d,%d) setpoint is not zero (%f) so it will not be turned off\n', Family, DeviceListOff(i,:), SP(i));
        end
    end
end

