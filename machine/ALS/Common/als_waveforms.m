function varargout = als_waveforms(ScopeType, varargin)
%ALS_WAVEFORM - GUI to display data from the ZTEC scopes and other waveforms
%
%  See also als_waveforms_setup


% Various error channels
% getpvonline([ScopeName,':UtilErrReport'])
% getpvonline([ScopeName,':UtilErr'])
% getpvonline([ScopeName,':UtilErrNext'])
% getpvonline([ScopeName,':UtilErrCount'])

% Reset
% setpvonline([ScopeName,':UtilReset'], 0);
% setpvonline([ScopeName,':UtilReset'], 1);

% Need a force capture button
% setpvonline([ScopeName,':OpForceCap'], 1);
% setpvonline([ScopeName,':OpArm'], 1);  % For software arm???
% Reset button - setpvonline([ScopeName,':UtilReset'],0);setpvonline([ScopeName,':UtilReset'],1)
% Abort - setpvonline([ScopeName,':OpAbort'], 0)


if nargin < 1
    ScopeType = '';
end


% Check if the AO exists (this is required for stand-alone applications)
checkforao;


% Get the scope and graph setup definition
[ztec, ScopeTypeCell] = als_waveforms_setup(ScopeType);
if isempty(ztec)
    return
end
ScopeName = ztec.Device.Name;



hMainFigure = figure( ...
    'Color', [0.8 0.8 0.8], ...
    'DeleteFcn', @hMainFigure_DeleteFcn, ...
    'NumberTitle', 'Off', ...
    'Name', 'ZTEC Scope', ...
    'Renderer','painters',...
    'Toolbar', 'Figure', ...
    'MenuBar','none',...
    'IntegerHandle', 'Off', ...
    'Visible', 'Off');
%'Units', 'Normalized', ...
%'Position',fposition,...

% set(hMainFigure, 'Position',fposition);

% create the MATLAB handles structure for the gui/widgets
thehandles = guihandles(hMainFigure);
% add the mainfigure to the handle structure
thehandles.hMainFigure = hMainFigure;

% update handles structure
guidata(thehandles.hMainFigure, thehandles);


%%%%%%%%%%%%%%%%
% Figure Setup %
%%%%%%%%%%%%%%%%

% Add the command line inputs to the figure properties
for i = 1:2:length(varargin)
    ztec.Figure.(varargin{i}) = varargin{i+1};
end

% handles = graphit_setup(ztec, hMainFigure);
graphit_setup(ztec, hMainFigure, ScopeTypeCell);


% refresh the reference to the handles
thehandles = guidata(hMainFigure);

% for i = length(thehandles.axes):-1:1
%     if strcmpi(ztec.GraphIt{i}.Axes.XLimMode, 'Auto')
%         get(thehandles.axes(i), 'XLimMode')
%         set(thehandles.axes(i), 'XLimMode', 'Auto');
%         get(thehandles.axes(i), 'XLimMode')
%     end
% end

FigColor = get(hMainFigure, 'Color');

thehandles.TimeStamp = uicontrol( ...
    'BackgroundColor', FigColor, ...
    'HorizontalAlignment', 'Right', ...
    'Style', 'Text', ...
    'Units', 'Normalized', ...
    'Position', [1-.32-.1 .001 .3 .03], ...
    'String', '');

thehandles.TimeSinceLastTrigger = uicontrol( ...
    'BackgroundColor', FigColor, ...
    'HorizontalAlignment', 'Right', ...
    'Style', 'Text', ...
    'Units', 'Normalized', ...
    'Position', [1-.11 .001 .08 .03], ...
    'String', '');

thehandles.StartStop = uicontrol( ...
    'Style', 'ToggleButton', ...
    'Units', 'Normalized', ...
    'Callback', @StartStopCallback, ...
    'Position', [.001 .001 .08 .05], ...
    'Interruptible', 'On', ...
    'String', 'Stop', ...
    'Value', 1);

guidata(hMainFigure,thehandles);

% if isunix && strcmpi(ztec.Device.Type, 'ztec')
%     thehandles.EDM = uicontrol( ...
%         'Style', 'PushButton', ...
%         'Units', 'Normalized', ...
%         'Callback', @EDMCallback, ...
%         'Position', [.1 .001 .08 .05], ...
%         'Interruptible', 'On', ...
%         'String', 'EDM', ...
%         'Value', 1);
%     guidata(hMainFigure,thehandles);
% end


% handles.Continuous = uicontrol( ...
%     'Style', 'ToggleButton', ...
%     'Units', 'Normalized', ...
%     'Callback', @ContinuousCallback, ...
%     'Position', [.001+.16 .001 .15 .05], ...
%     'String', 'Continuous', ...
%     'Value', 0);


%%%%%%%%%
% Setup %
%%%%%%%%%

if strcmpi(ztec.Device.Type, 'ztec')
    % Only for ztec scopes
    ztec = ztec_setup(ztec);
    
    % Check if operational and add the UtilID to the title
    UtilID = getpvonline([ScopeName, ':UtilID']);         % checks to make sure you are talking to the instrument
    %fprintf('  %s:UtilID = %s\n', ztec.Device.Name, UtilID);
    %set(handles.hMainFigure, 'Name', sprintf('%s  (%s)  -  %s  -  %s', ztec.Figure.Name, ztec.Device.Name, ztec.Device.ScopeType, UtilID));
    set(hMainFigure, 'Name', sprintf('%s  (%s)  -  %s', UtilID, ztec.Device.Name, ztec.Device.ScopeType));
    
    
    % Create the time vector once (may want to get all the time??? or on the first capture???)
    ztec.Device.Setup.setHorzPoints = getpvonline([ScopeName,':getHorzPoints']);
    ztec.Device.Setup.setHorzTime   = getpvonline([ScopeName,':getHorzTime']);   % HorzTime can differ be small amounts
    ztec.Device.Setup.setHorzOffset = getpvonline([ScopeName,':getHorzOffset']);
    
    N          = ztec.Device.Setup.setHorzPoints;   % getpvonline([ScopeName,':getHorzPoints']);
    HorzTime   = ztec.Device.Setup.setHorzTime;     % getpvonline([ScopeName,':getHorzTime']);
    HorzOffset = ztec.Device.Setup.setHorzOffset;   % getpvonline([ScopeName,':getHorzOffset']);
    t = HorzTime*(0:N-1)/N - HorzOffset;
    %fs = 1/(t(2)-t(1));
    %fs = getpvonline([ScopeName,':HorzRate'])
    
    
    % Save setup data in the figure
    %set(handles.StartStop, 'UserData', handles);
    %setappdata(hMainFigure, 'HandleStructure', handles);
    setappdata(hMainFigure, 'TimeVector', t);  % Need to get after the first capture???
    
    
    % Save the wave counters
    if ztec.Device.Setup.setInp1Enable
        setappdata(hMainFigure, 'WaveCounter', getpvonline([ScopeName,':Inp1WaveCount'])-1);  % -1 forces an update on launch
    elseif ztec.Device.Setup.setInp2Enable
        setappdata(hMainFigure, 'WaveCounter', getpvonline([ScopeName,':Inp2WaveCount'])-1);  % -1 forces an update on launch
    elseif ztec.Device.Setup.setInp3Enable
        setappdata(hMainFigure, 'WaveCounter', getpvonline([ScopeName,':Inp3WaveCount'])-1);  % -1 forces an update on launch
    elseif ztec.Device.Setup.setInp4Enable
        setappdata(hMainFigure, 'WaveCounter', getpvonline([ScopeName,':Inp4WaveCount'])-1);  % -1 forces an update on launch
    else
        error('No channels are enabled.');
    end
else
    set(hMainFigure, 'Name', sprintf('%s  -  %s', ztec.Device.Name, ztec.Device.ScopeType));
end

% Save starting time
t_trigger = clock;
setappdata(hMainFigure, 't_trigger', t_trigger);
setappdata(hMainFigure, 'ZTECSetup', ztec);

set(hMainFigure, 'HandleVisibility', 'Off');
set(hMainFigure, 'Visible', 'On');
drawnow;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if already open so multiple timers don't get started %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% h = getappdata(hMainFigure, 'HandleStructure');
% if isfield(thehandles,'TimerHandle') && isobject(thehandles.TimerHandle)
%     % Just restart it
%     start(thehandles.TimerHandle);
%     %fprintf('   BR scopes already open\n');
%     %return
% else
%     % Setup Timer
%     UpdatePeriod = .2;
%
%     t = timer;
%     set(t, 'StartDelay', 0);
%     set(t, 'Period', UpdatePeriod);
%     set(t, 'TimerFcn', @ZTEC_Timer_Callback);
%     %set(t, 'StartFcn', ['als_waveforms(''Timer_Start'',',    sprintf('%.30f',handles.hMainFigure), ',',sprintf('%.30f',handles.hMainFigure), ', [])']);
%     set(t, 'UserData', thehandles);
%     set(t, 'BusyMode', 'drop');  %'queue'
%     set(t, 'TasksToExecute', Inf);
%     %set(t, 'TasksToExecute', 50);
%     set(t, 'ExecutionMode', 'FixedRate');
%     set(t, 'UserData', hMainFigure);
%     set(t, 'Tag', 'ZTECScopeTimer');
%
%     thehandles.TimerHandle = t;
%
%     % Save handles
%     setappdata(hMainFigure, 'HandleStructure', handles);
%     guidata(hMainFigure,thehandles);
%
%     start(t);
% end
% h = getappdata(hMainFigure, 'HandleStructure');
thehandles = guidata(hMainFigure);
if isfield(thehandles,'TimerHandle') && isobject(thehandles.TimerHandle)
    % Just restart it
    start(thehandles.TimerHandle);
    %fprintf('   BR scopes already open\n');
    %return
else
    % Setup Timer
    UpdatePeriod = .2;
    
    t = timer;
    set(t, 'StartDelay', 0);
    set(t, 'Period', UpdatePeriod);
    set(t, 'TimerFcn', {@ZTEC_Timer_Callback,thehandles});
    %set(t, 'StartFcn', ['als_waveforms(''Timer_Start'',',    sprintf('%.30f',handles.hMainFigure), ',',sprintf('%.30f',handles.hMainFigure), ', [])']);
    %     set(t, 'UserData', thehandles);
    set(t, 'BusyMode', 'drop');  %'queue'
    set(t, 'TasksToExecute', Inf);
    %set(t, 'TasksToExecute', 50);
    set(t, 'ExecutionMode', 'FixedRate');
    set(t, 'Tag', 'ZTECScopeTimer');
    
    thehandles.TimerHandle = t;
    
    % Save handles
    guidata(hMainFigure,thehandles);
    
    start(t);
end


%%%%%%%%%%%%%%%%%
% Main Callback %
%%%%%%%%%%%%%%%%%
function varargout = ZTEC_Timer_Callback(hObject, eventdata, handles)

handles = guidata(handles.hMainFigure);

ztec = getappdata(handles.hMainFigure, 'ZTECSetup');


% Wait on a trigger
GR.Device.Type = 'ztec';
if strcmpi(ztec.Device.Type, 'ztec')
    % Only for ztec scopes
    t                = getappdata(handles.hMainFigure, 'TimeVector');
    t_trigger_last   = getappdata(handles.hMainFigure, 't_trigger');
    WaveCounterLast = getappdata(handles.hMainFigure,  'WaveCounter');
    %ztec             = getappdata(handles.hMainFigure, 'ZTECSetup');
    
    ScopeName  = ztec.Device.Name;
    N          = ztec.Device.Setup.setHorzPoints;
    HorzOffset = ztec.Device.Setup.setHorzOffset;
    HorzTime   = ztec.Device.Setup.setHorzTime;      % getpvonline([ScopeName,':getHorzTime']);

    % Look for scope conflicts
    if strcmpi(ztec.Device.ScopeType, 'Wall Current Monitor') || strcmpi(ztec.Device.ScopeType, 'Traveling Wave Electrode (TWE)')
        Inp1Enable = getpvonline([ScopeName,':setInp1Enable'], 'double');
        if ztec.Device.Setup.setInp1Enable ~= Inp1Enable
            try
                stop(handles.TimerHandle);
                set(handles.StartStop, 'Visible', 'Off');
                if isunix
                    set(handles.EDM, 'Visible', 'Off');
                end
                set(handles.hOptionsMenu, 'Enable','Off');
                if strcmpi(ztec.Device.ScopeType, 'Wall Current Monitor')
                    textString = 'Updating stopped!  Someone switch to the TWE.';
                else
                    textString = 'Updating stopped!  Someone switch to the Wall Current Monitor.';
                end
                % Draw a red line across the graph
                annotation(handles.hMainFigure, 'textbox', [.1 .96 .8 .04], 'String', textString, 'FontSize',12, 'Color','Red', 'HorizontalAlignment','Center');
                return;
            catch ME
                fprintf('Cannot stop the timer %s',ME.message);
            end
        end
%     elseif strcmpi(ztec.Device.ScopeType, 'LTB ICT') || strcmpi(ztec.Device.ScopeType, 'BTS ICTs')
%         Inp1Enable = getpvonline([ScopeName,':setInp1Enable'], 'double');
%         if ztec.Device.Setup.setInp1Enable ~= Inp1Enable
%             try
%                 stop(handles.TimerHandle);
%                 set(handles.StartStop, 'Visible', 'Off');
%                 if isunix
%                     set(handles.EDM, 'Visible', 'Off');
%                 end
%                 set(handles.hOptionsMenu, 'Enable','Off');
%                 if strcmpi(ztec.Device.ScopeType, 'LTB ICT')
%                     textString = 'Updating stopped!  Someone switch to the BTS ICTs.';
%                 else
%                     textString = 'Updating stopped!  Someone switch to the LTB ICT.';
%                 end
%                 % Draw a red line across the graph
%                 annotation(handles.hMainFigure, 'textbox', [.1 .96 .8 .04], 'String', textString, 'FontSize',12, 'Color','Red', 'HorizontalAlignment','Center');
%                 return;
%             catch ME
%                 fprintf('Cannot stop the timer %s',ME.message);
%             end
%         end
    elseif isfield(ztec.Device, 'MUX') && ~isempty(ztec.Device.MUX)
        % if MUX, need to check, if THIS MUX settings are any different from the Device(MUX) live settings:
        % e.g. somebody modified the MUX, then THIS istance is not that MUX anymore, stop the timer, disable timer button warn user and return.
        
        % Get the mux pv values
        Value1    = getpvonline(ztec.Device.MUX.Ch1.Name,  'Double');
        Value2    = getpvonline(ztec.Device.MUX.Ch2.Name,  'Double');
        TrigValue = getpvonline(ztec.Device.MUX.Trig.Name, 'Double');
        
        if (Value1 ~= ztec.Device.MUX.Ch1.Value || Value2 ~= ztec.Device.MUX.Ch2.Value || TrigValue ~= ztec.Device.MUX.Trig.Value)
            try
                stop(handles.TimerHandle);
                set(handles.StartStop, 'Visible', 'Off');
                if isunix
                    set(handles.EDM, 'Visible', 'Off');
                end
                set(handles.hOptionsMenu, 'Enable','Off');
                textString = 'Updating stopped!  Someone changed one of the MUX settings.';
                % Draw a red line across the graph
                %annotation(handles.hMainFigure, 'line', [0 1], [0 1], 'Color', 'Red');
                annotation(handles.hMainFigure, 'textbox', [.1 .96 .8 .04], 'String', textString, 'FontSize',12, 'Color','Red', 'HorizontalAlignment','Center');
                return;
            catch ME
                fprintf('Cannot stop the timer %s',ME.message);
            end
        end
        
    elseif strcmpi(ztec.Device.ScopeType, 'Caen Power Supply Tesing')
        if strcmpi(getpvonline([ScopeName,':setTrigSource']), 'MAN') && get(handles.StartStop, 'Value')
            % Manual trigger
            setpvonline([ScopeName,':OpForceCap'], 1);
            %fprintf('Force a trigger \n');
            pause(.6);
        end
    end
    
    
    if get(handles.StartStop, 'Value') == 0
        return;
    end
        
    
    % Check if the waveform updated
    %OpComplete = getpvonline([ScopeName,':getOpComplete'], 'char');
    
    if ztec.Device.Setup.setInp1Enable == 1
        WaveCounter = getpvonline([ScopeName,':Inp1WaveCount']);
    elseif ztec.Device.Setup.setInp2Enable
        WaveCounter = getpvonline([ScopeName,':Inp2WaveCount']);
    elseif ztec.Device.Setup.setInp3Enable
        WaveCounter = getpvonline([ScopeName,':Inp3WaveCount']);
    elseif ztec.Device.Setup.setInp4Enable
        WaveCounter = getpvonline([ScopeName,':Inp4WaveCount']);
    else
        error('No channels are enabled.');
    end
    
    if WaveCounter==0 || WaveCounter == WaveCounterLast
        %fprintf('  %10.5f seconds waiting on trigger and waveform  --  WaveCounter=%d  --  OpComplete = %s\n', etime(clock, t_trigger_last), WaveCounter, OpComplete);
        set(handles.TimeSinceLastTrigger, 'String', sprintf('%.2f',etime(clock, t_trigger_last)));
        
        pause(.1);
        return
    end
    
    % Save the wave count number
    setappdata(handles.hMainFigure, 'WaveCounter', WaveCounter);
    
    % Record trigger complete
    set(handles.TimeSinceLastTrigger, 'String', sprintf('%.2f',etime(clock, t_trigger_last)));
    t_trigger = clock;
    setappdata(handles.hMainFigure, 't_trigger', t_trigger);
    %fprintf('  %10.5f seconds between measurement completes    --  WaveCounter=%d  --  OpComplete = %s\n', etime(t_trigger, t_trigger_last), WaveCounter, OpComplete);

elseif strcmpi(ztec.Device.Type,  'Libera')
    % Libera 
    if get(handles.StartStop, 'Value') == 0
        return;
    end
    
    % TriggerFlag will sync injection (BR) or extraction (SR)
    t_trigger_last   = getappdata(handles.hMainFigure, 't_trigger');
end


%%%%%%%%%%%%%%%%%%%%%%%%%
% Get and plot waveform %
%%%%%%%%%%%%%%%%%%%%%%%%%


% Check X/Y LimMode for zoom state and reset the toggle button accordingly
modeX =' ';
modeY =' ';
for i=1:length(handles.axes)
    if strcmpi(get(handles.axes(i), 'YLimMode'), 'manual')
        modeY = 'manual';
    end
    if strcmpi(get(handles.axes(i), 'XLimMode'), 'manual')
        modeX = 'manual';
    end
end
if(strcmp(modeX, 'manual'))
    if strcmpi(get(handles.hAutoScaleXToggle, 'State'), 'On')
        set(handles.hAutoScaleXToggle, 'State','Off');
    end
    
end
if(strcmp(modeY, 'manual'))
    if strcmpi(get(handles.hAutoScaleYToggle, 'State'), 'On')
        set(handles.hAutoScaleYToggle, 'State','Off');
    end
    
end


% Special cases
if strcmpi(ztec.Device.Type, 'Libera')
    TriggerFlag = 1;
    
    [AM, SP] = libera('DD3', ztec.Device.Name, TriggerFlag);
    
    % Record trigger complete
    t_trigger = clock;
    setappdata(handles.hMainFigure, 't_trigger', t_trigger);

    DataTimeStr = AM.DD_FINISHED_MONITOR_TIMESTAMP;
    
    NTurns = 100000;
    
    set(handles.Line{1}, 'XData', 1:NTurns, 'YData', AM.DD_X_MONITOR(1:NTurns)/1e6);
    set(handles.Line{2}, 'XData', 1:NTurns, 'YData', AM.DD_Y_MONITOR(1:NTurns)/1e6);
    set(handles.Line{3}, 'XData', 1:NTurns, 'YData', AM.DD_SUM_MONITOR(1:NTurns));

elseif strcmpi(ztec.Device.ScopeType, 'SR Bunch Current Monitor')
    tic;
    [Data, tmp, DataTime] = getpvonline(ztec.GraphIt{1}.ChannelNames{1}, 'double', ztec.Device.Setup.setHorzPoints);
    t = getpvonline([ScopeName,':InpScaledTime'], 'double', ztec.Device.Setup.setHorzPoints);
    fprintf('  %10.5f seconds to get %s\n', toc, ztec.GraphIt{1}.ChannelNames{1});
    
    %DCCT = getdcct;
    DCCT = getpv('cmm:beam_current');
    
    
    RF = getpv('SR01C___FREQBHPAM00') + 499.642;
    %RF = getrf;    % 'SR01C___FREQB__AM00'
    RF = RF * 1e6;  % [Hz]
    
    Data = detrend(Data);
    tt = t - t(1);
    
    % Length of a ztec turn
    TimeScaling = 5.5e-12;  % was 7.5 [ps]  - Should be an input???
    T = 328/RF + TimeScaling;
    
    % Number of full turns in the data buffer
    N_Turns = floor(tt(end)/T);
    
    
    for i = 1:N_Turns
        j = find([(i-1)*T<=tt & tt<i*T]);
        tt(j) = tt(j) - (i-1)*T;
    end
    
    % Remove the data past N-turns
    try
        tt(max(j):end) = [];
        Data(max(j):end) = [];
        [tt, i] = sort(tt);
        Data = Data(i);
    catch
        fprintf('Error with time vector: %s', lasterr);
        return
    end
    
    % Filter without phase delay
    [b, a] = fir1(30, .005);
    FData = filtfilt(b, a, Data);
    
    Offset = .7e-9;
    dOff = .15e-9;
    T_1ns = T/328/2;
    T_2ns = T/328;
    for i = 1:328
        j = find([((i-1)*T_2ns+Offset+dOff)<=tt & tt<((i-1)*T_2ns+T_1ns+Offset+dOff)]);
        [BunchCurrentMin(i),m] = min(FData(j));
        %tmin(i) = tt(j(m));
        tmin(i) = ((i-1)*T_2ns+Offset)+T_1ns/2+dOff;
        
        j = find([((i-1)*T_2ns+T_1ns+Offset-dOff)<=tt & tt<((i-1)*T_2ns+T_2ns+Offset-dOff)]);
        [BunchCurrentMax(i),n] = max(FData(j));
        %tmax(i) = tt(j(n));
        tmax(i) = ((i-1)*T_2ns+T_1ns+Offset)+T_1ns/2-dOff;
    end
    
    
    % Compute 2 bunch currents (relative to bunch length)
    DeltaBunch = 1;
    BunchCurrentMin = [BunchCurrentMin(DeltaBunch:end) BunchCurrentMin(1:DeltaBunch-1)];
    BunchCurrentMax = [BunchCurrentMax(DeltaBunch:end) BunchCurrentMax(1:DeltaBunch-1)];
    
    BunchCurrentMax = -1*BunchCurrentMax;
    BunchCurrentMin1 = DCCT * BunchCurrentMin / sum(BunchCurrentMin);
    BunchCurrentMax1 = DCCT * BunchCurrentMax / sum(BunchCurrentMax);
    
    
    if DCCT < .15
        ScaleFactorMin = -56;
        ScaleFactorMax = -72;
    else
        iPos = find(BunchCurrentMin1 > 0);
        if isempty(iPos)
            % Problem
            ScaleFactorMin = DCCT / sum(BunchCurrentMin);
        else
            ScaleFactorMin = DCCT / sum(BunchCurrentMin(iPos));
        end
        
        iPos = find(BunchCurrentMax1 > 0);
        if isempty(iPos)
            % Problem
            ScaleFactorMax = DCCT / sum(BunchCurrentMax);
        else
            ScaleFactorMax = DCCT / sum(BunchCurrentMax(iPos));
        end
    end
    
    fprintf('     ScaleFactorMin=%.5f ScaleFactorMax=%.5f\n', ScaleFactorMin, ScaleFactorMax);
    BunchCurrentMin = ScaleFactorMin * BunchCurrentMin;
    BunchCurrentMax = ScaleFactorMax * BunchCurrentMax;
    
    tt = tt*1e9;
    T  =  T*1e9;
    
    set(handles.Line{1}(1), 'XData', tt,    'YData', Data);
    set(handles.Line{1}(2), 'XData', tt,    'YData', FData);
    
    % Add markers to set the timing (menu???)
    if 0
        set(handles.Line{1}(3), 'XData', tmin*1e9, 'YData', BunchCurrentMin);
        set(handles.Line{1}(4), 'XData', tmin*1e9, 'YData', BunchCurrentMax);
    else
        set(handles.Line{1}(3), 'XData', tmin*1e9, 'YData', NaN*BunchCurrentMin);
        set(handles.Line{1}(4), 'XData', tmin*1e9, 'YData', NaN*BunchCurrentMax);
    end
    
    
    % Fix X-axis limit
    % We may not want to do this since it removes auto!
    if strcmpi(get(handles.axes(1), 'XLimMode'), 'Auto')
        set(handles.axes(1), 'XLim', [0 T]);
    end
    
    % Plot the bunch current (graph 2)
    set(handles.Line{2}(1), 'XData', 1:328, 'YData', BunchCurrentMax);
    set(handles.Line{2}(2), 'XData', 1:328, 'YData', BunchCurrentMin);
    
    DataTime = EPICS2MatlabTime(DataTime);
    DataTimeStr = datestr(DataTime, 'dd-mmm-yyyy HH:MM:SS.FFF');
    %DataTimeStr = datestr(now, 'dd-mmm-yyyy HH:MM:SS.FFF');
    
elseif strcmpi(ztec.Device.ScopeType, 'LTB ICT')
    
    [Data1, tmp, DataTime] = getpvonline(ztec.GraphIt{1}.ChannelNames{1}, 'double', ztec.Device.Setup.setHorzPoints);
   %[Data2, tmp, DataTime] = getpvonline(ztec.GraphIt{2}.ChannelNames{1}, 'double', ztec.Device.Setup.setHorzPoints);
    t = getpvonline([ScopeName,':InpScaledTime'], 'double', ztec.Device.Setup.setHorzPoints);
    
    Gain   = ztec.GraphIt{1}.Data.Gain{1};
    Offset = ztec.GraphIt{1}.Data.Offset{1};
    XGain  = ztec.GraphIt{1}.Data.XGain{1};
    
    Data1 = Gain * Data1 - Offset;
    set(handles.Line{1}(1), 'XData', t*XGain, 'YData', Data1);

    % Integration window
    if 1
        % Base on time
        Tneg =  75e-9;   % Seconds before the peak
        Tpos = 100e-9;   % Seconds after  the peak
        
        [tmp, imin] = min(Data1);
        iNeg = min(find(t>(t(imin)-Tneg)));
        iPos = min(find(t>(t(imin)+Tpos)));
        if isempty(iNeg)
            iNeg = 1;
        end
        if isempty(iPos)
            iPos = length(t);
        end
        i = iNeg:iPos;
        
    else
        % Base on points (not robust!)
        TrigLev = getpvonline([ScopeName,':setTrigLevInp1'], 'double');
        TrigLev = Gain * TrigLev;
        i = find(Data1 < -1*abs(TrigLev));
        NN = ceil(.4*length(i));
        if NN < 10
            iNeg = -10:-1;
        else
            iNeg = -NN:-1;
        end
        NN = ceil(.6*length(i));
        if NN < 20
            iPos = 1:20;
        else
            iPos = 1:NN;
        end
        i = [i(1)+iNeg i i(end)+iPos];
    end
    
    ZeroLevel = mean(Data1(1:i(1)));
    Data1 = Data1 - ZeroLevel;
    
    IntData1 = sum(Data1(i)) * (t(i(2))-t(i(1)));
    
    set(handles.Line{1}(2), 'XData', t(i)*XGain, 'YData', Data1(i));
    
    %set(handles.Line{2}(1), 'XData', t*XGain, 'YData', Data2);

    h = get(handles.Line{1}(2), 'Parent');
    h = get(h, 'title');
    
    LTB1nC =  abs(IntData1*1e9/1.25/15);
    set(h, 'String', sprintf('\\fontsize{14}LTB ICT:  Integral %.3g nC  (%.3g V*sec, DC Offset=%.3g)', LTB1nC,  IntData1, ZeroLevel));
    
    DataTime = EPICS2MatlabTime(DataTime);
    DataTimeStr = datestr(DataTime, 'dd-mmm-yyyy HH:MM:SS.FFF');
    
    % Set back to the database
    if isnan(LTB1nC)
        LTB1nC = 0;
    end
    setpv('LTB:ICT1', LTB1nC);

        
elseif strcmpi(ztec.Device.ScopeType, 'BTS ICTs')
    
    [Data1, tmp, DataTime] = getpvonline(ztec.GraphIt{1}.ChannelNames{1}, 'double', ztec.Device.Setup.setHorzPoints);
    [Data2, tmp, DataTime] = getpvonline(ztec.GraphIt{2}.ChannelNames{1}, 'double', ztec.Device.Setup.setHorzPoints);
    t = getpvonline([ScopeName,':InpScaledTime'], 'double', ztec.Device.Setup.setHorzPoints);    
    XGain  = ztec.GraphIt{1}.Data.XGain{1};
    
    
    set(handles.Line{1}(1), 'XData', t*XGain, 'YData', Data1);
    set(handles.Line{2}(1), 'XData', t*XGain, 'YData', Data2);
    
    % Integration window (base on time)
    Tneg = 70e-9;   % Seconds before the peak
    Tpos = 90e-9;   % Seconds after  the peak
    
    % BTS1
    [tmp, imin] = min(Data1);
    iNeg = min(find(t>(t(imin)-Tneg)));
    iPos = min(find(t>(t(imin)+Tpos)));
    if isempty(iNeg)
        iNeg = 1;
    end
    if isempty(iPos)
        iPos = length(t);
    end
    i = iNeg:iPos;
    
    if ~isempty(i)
        ZeroLevel1 = mean(Data1(1:i(1)));
        Data1 = Data1 - ZeroLevel1;
        IntData1 = sum(Data1(i)) * (t(i(2))-t(i(1)));
        BTS1nC = abs(IntData1*1e9/1.25/15);
        
        set(handles.Line{1}(2), 'XData', t(i)*XGain, 'YData', Data1(i));
        h = get(handles.Line{1}(2), 'Parent');
        h = get(h, 'title');
        set(h, 'String', sprintf('\\fontsize{14}BTS ICT #1:  Integral %.3g nC  (%.3g V*sec, DC Offset=%.3g)', BTS1nC,  IntData1, ZeroLevel1));
        setpv('BTS:ICT1', BTS1nC);
    else
        % Shouldn't get here
        BTS1nC = -1*eps;
        set(handles.Line{1}(2), 'XData', t, 'YData', NaN*Data1);
    end
    
    if isnan(BTS1nC)
        BTS1nC = 0;
    end
    
    % BTS2
    [tmp, imin] = min(Data2);
    iNeg = min(find(t>(t(imin)-Tneg)));
    iPos = min(find(t>(t(imin)+Tpos)));
    i = iNeg:iPos;
    
    if ~isempty(i)
        ZeroLevel2 = mean(Data2(2:i(1)));
        Data2 = Data2 - ZeroLevel2;
        IntData2 = sum(Data2(i)) * (t(i(2))-t(i(1)));
        BTS2nC = abs(IntData2*1e9/1.25/15/4);   % Not sure why I need the extra scale factor after the ICT repair
        
        set(handles.Line{2}(2), 'XData', t(i)*XGain, 'YData', Data2(i));
        h = get(handles.Line{2}(2), 'Parent');
        h = get(h, 'title');
        set(h, 'String', sprintf('\\fontsize{14}BTS ICT #2:  Integral %.3g nC  (%.3g V*sec, DC Offset=%.3g)', BTS2nC,  IntData2, ZeroLevel2));
        
        % Set back to the database
        if isnan(BTS2nC)
            BTS2nC = 0;
        end
        setpv('BTS:ICT2', BTS2nC);
    else
        % Beam lost in BTS
        BTS1nC = -1*eps;
        h = get(handles.Line{2}(2), 'Parent');
        h = get(h, 'title');
        set(h, 'String', '\fontsize{14}BTS ICT #2: No good signal (lost in BTS line?)');
        set(handles.Line{2}(2), 'XData', t, 'YData', NaN*Data1);
    end

    % Poor-mans arcihver (this can have issue with file access, best to not run in production with file achivering)
    %getict('Archive');
    
    
    DataTime = EPICS2MatlabTime(DataTime);
    DataTimeStr = datestr(DataTime, 'dd-mmm-yyyy HH:MM:SS.FFF');

else
    for i = 1:length(handles.Line)
        for j = 1:length(handles.Line{i})
            
            tic;
            [Data, tmp, DataTime] = getpvonline(ztec.GraphIt{i}.ChannelNames{j}, 'double', ztec.Device.Setup.setHorzPoints);
            t = getpvonline([ScopeName,':InpScaledTime'], 'double', ztec.Device.Setup.setHorzPoints);
            %fprintf('  %10.5f seconds to get %s\n', toc, ztec.GraphIt{i}.ChannelNames{j});
            
            DownSampleNumber = ztec.Device.Special.DownSampleNumber;
            if DownSampleNumber ~= 1
                NN = floor(N / DownSampleNumber);
                %tt = reshape(t(1:DownSampleNumber*NN),DownSampleNumber,NN);
                [Data, n] = min(reshape(Data(1:DownSampleNumber*NN),DownSampleNumber,NN));
                
                % Find the time index of all the min
                iMax = sub2ind([DownSampleNumber,NN],n,[1:NN]);
                t = t(iMax);
            end
            
            Gain   = ztec.GraphIt{i}.Data.Gain{j};
            Offset = ztec.GraphIt{i}.Data.Offset{j};
            XOffset = ztec.GraphIt{i}.Data.XOffset{j};
            
            XGain = ztec.GraphIt{i}.Data.XGain{j};
            
%             if strcmpi(ztec.Device.ScopeType, 'Booster ICT')
%                 % If there are no electrons, then don't update the plot
%                 ICTmax = max(abs(Data));
%                 if ICTmax < .025
%                     return;
%                 end
%             %else
%             %    ICTmax = max(abs(Data));                
%             end
            
            set(handles.Line{i}(j), 'XData', XGain * t - XOffset, 'YData', Gain * Data - Offset);
        end
    end
    
    % Fix X-axis limit
    % We may not want to do this since it removes auto!
    %for i = 1:length(ztec.GraphIt);
    %    if strcmpi(get(handles.axes(i), 'XLimMode'), 'Auto')
    %        set(handles.axes(i), 'XLim', [t(1) t(end)]);
    %    end
    %end
    
    DataTime = EPICS2MatlabTime(DataTime);
    DataTimeStr = datestr(DataTime, 'dd-mmm-yyyy HH:MM:SS.FFF');
    %DataTimeStr = datestr(now, 'dd-mmm-yyyy HH:MM:SS.FFF');
    
    
    if strcmpi(ztec.Device.ScopeType, 'Gauss Clock Triggers')
        % Injection
        %Data = getpvonline('ztec16:Inp1ScaledWave', 'double', ztec.Device.Setup.setHorzPoints);
        
        GaussClockData = getappdata(handles.hMainFigure, 'GaussClockData');
        
        if isempty(GaussClockData)
            GaussClockData.UpdateInjTrigger  = 1;
            %GaussClockData.UpdateBumpTrigger = 1;
            GaussClockData.UpdateExtTrigger  = 1;
            
            GaussClockData.BR_Inj = 0;  % ???
            GaussClockData.BR_Ext = 0;  % ???
            GaussClockData.Bend.Gain    = getpv('BR1_____B__PSGNAM00');
            GaussClockData.Bend.Offset  = getpv('BR1_____B__PSOFAM00');
        end
        
        GaussClockData.InjTrigger  = -1;  %NaN;
        GaussClockData.ExtTrigger  = -1;  %NaN;
        GaussClockData.BumpTrigger = -1;  %NaN;
        
        % Injection
        Data = getpvonline('ztec16:Inp1ScaledWave', 'double', ztec.Device.Setup.setHorzPoints);
        [Tmp,iTrigger] = find(Data > 1);
        if ~isempty(iTrigger)
            InjDelay = .4667;  % DG654 delay [Seconds]  (.4645)
            GaussClockData.InjTrigger = t(min(iTrigger)) - InjDelay;
            
            %fprintf('  Injection Trigger  = %13.9f milliseconds from the waveform trigger (%s)\n', 1000*GaussClockData.InjTrigger, datestr(clock,31));
        end
        
        Data = getpvonline('ztec16:Inp2ScaledWave', 'double', ztec.Device.Setup.setHorzPoints);
        [Tmp,iTrigger] = find(Data > 1);
        if ~isempty(iTrigger)
            InjDelay = .4667;  % DG654 delay [Seconds]  (.4645)
            GaussClockData.InjTriggerMRF = t(min(iTrigger)) - InjDelay;
        end
        
        % Extraction
        Data = getpvonline('ztec16:Inp3ScaledWave', 'double', ztec.Device.Setup.setHorzPoints);
        [Tmp,iTrigger] = find(Data > 1);
        if ~isempty(iTrigger)
            GaussClockData.ExtTrigger = t(min(iTrigger));
            
            %fprintf('  Extraction Trigger = %13.9f milliseconds from the waveform trigger (%s)\n\n', 1000*GaussClockData.ExtTrigger, datestr(clock,31));
        end
        
        Data = getpvonline('ztec16:Inp4ScaledWave', 'double', ztec.Device.Setup.setHorzPoints);
        [Tmp,iTrigger] = find(Data > 1);
        if ~isempty(iTrigger)
            GaussClockData.ExtTriggerMRF = t(min(iTrigger));
        end
            
        % Bump
        if 1
            GaussClockData.BumpTrigger = GaussClockData.ExtTrigger - .004955;
        else
            Data = getpvonline('ztec16:Inp2ScaledWave', 'double', ztec.Device.Setup.setHorzPoints);
            [Tmp,iTrigger] = find(Data > 1);
            if ~isempty(iTrigger)
                BumpDelay = .0054;  % DG654 delay [Seconds]
                GaussClockData.BumpTrigger = t(min(iTrigger)) - BumpDelay;
                
               % fprintf('  Bump Trigger       = %13.9f milliseconds from the waveform trigger (%s)\n', 1000*GaussClockData.BumpTrigger, datestr(clock,31));
            end
        end
        
        
        GaussClockDataOld = GaussClockData;
        
        GaussClockData.BucketNumber = getpv('SR01C___TIMING_AC08');
        GaussClockData.BR_Inj       = getpv('BR1_____TIMING_AM00');
        GaussClockData.BR_Bump      = getpv('BR1_____TIMING_AM01');
        GaussClockData.BR_Ext       = getpv('BR1_____TIMING_AM04');
        GaussClockData.Bend.Gain    = getpv('BR1_____B__PSGNAM00');
        GaussClockData.Bend.Offset  = getpv('BR1_____B__PSOFAM00');
        GaussClockData.DCCT         = 1000*getpv('SR05W___DCCT2__AM01');

        
        
        % Write data to PVs
        if (GaussClockData.Bend.Gain ~= GaussClockDataOld.Bend.Gain) || (GaussClockData.Bend.Offset ~= GaussClockDataOld.Bend.Offset)
            GaussClockData.UpdateInjTrigger = 2;
            GaussClockData.UpdateExtTrigger = 2;
        end
        
        
        if GaussClockData.BR_Inj ~= GaussClockDataOld.BR_Inj
            GaussClockData.UpdateInjTrigger = 2;
        end
        if GaussClockData.UpdateInjTrigger && GaussClockData.InjTrigger > 0
            setpvonline('GaussClockInjectionFieldTrigger',   GaussClockData.InjTrigger);
            GaussClockData.UpdateInjTrigger = GaussClockData.UpdateInjTrigger - 1;
            %fprintf('  Injection Trigger  = %13.9f milliseconds from the waveform trigger (%s)\n', 1000*GaussClockData.InjTrigger, datestr(clock,31));
        end
        
        
        %if (GaussClockData.UpdateBumpTrigger || GaussClockData.BR_Bump ~= GaussClockDataOld.BR_Bump) && GaussClockData.BumpTrigger > 0
        %    setpvonline('GaussClockExtractionFieldTrigger',  GaussClockData.BumpTrigger);
        %end
        if GaussClockData.BR_Ext ~= GaussClockDataOld.BR_Ext
            GaussClockData.UpdateExtTrigger = 2;
        end
        if GaussClockData.UpdateExtTrigger && GaussClockData.ExtTrigger > 0
            setpvonline('GaussClockBoosterBumpFieldTrigger', GaussClockData.BumpTrigger);
            setpvonline('GaussClockExtractionFieldTrigger',  GaussClockData.ExtTrigger);
            GaussClockData.UpdateExtTrigger = GaussClockData.UpdateExtTrigger - 1;
            %fprintf('  Extraction Trigger = %13.9f milliseconds from the waveform trigger (%s)\n', 1000*GaussClockData.ExtTrigger, datestr(clock,31));
        end
        

        % Set to PVs
        setpvonline('GaussClockInjectionFieldTriggerRBV',   GaussClockData.InjTrigger);
        setpvonline('GaussClockBoosterBumpFieldTriggerRBV', GaussClockData.BumpTrigger);
        setpvonline('GaussClockExtractionFieldTriggerRBV',  GaussClockData.ExtTrigger);      
        %setpvonline('GaussClockInjectionFieldTriggerMFRRBV',   GaussClockData.InjTriggerMRF);
        %setpvonline('GaussClockExtractionFieldTriggerMRFRBV',  GaussClockData.ExtTriggerMRF);

        
        if GaussClockData.UpdateInjTrigger < 0
            GaussClockData.UpdateInjTrigger  = 0;
        end
        if GaussClockData.UpdateExtTrigger < 0
            GaussClockData.UpdateExtTrigger  = 0;
        end
        
        setappdata(handles.hMainFigure, 'GaussClockData', GaussClockData);
        

        % Print all the time
        %fprintf('  Injection Trigger  = %13.9f %13.9f (MRF) milliseconds from the waveform trigger (%s)\n', 1000*GaussClockData.InjTrigger, 1000*GaussClockData.InjTriggerMRF, datestr(clock,31));
        %fprintf('  Extraction Trigger = %13.9f %13.9f (MRF) milliseconds from the waveform trigger (%s)\n\n', 1000*GaussClockData.ExtTrigger, 1000*GaussClockData.ExtTriggerMRF, datestr(clock,31)
        fprintf('  Gauss Clock: Injection Trigger = %13.9f     Extraction Trigger = %13.9f  milliseconds from the waveform trigger\n', 1000*GaussClockData.InjTrigger,    1000*GaussClockData.ExtTrigger);
        fprintf('  MRF:         Injection Trigger = %13.9f     Extraction Trigger = %13.9f  milliseconds from the waveform trigger\n', 1000*GaussClockData.InjTriggerMRF, 1000*GaussClockData.ExtTriggerMRF);
        fprintf('               ========================================================================\n');
        fprintf('  Diff:                            %13.9f                          %13.9f                     %s\n\n', 1000*(GaussClockData.InjTrigger-GaussClockData.InjTriggerMRF), 1000*(GaussClockData.ExtTrigger-GaussClockData.ExtTriggerMRF), datestr(clock,31));     
        drawnow;
        
        
        %FileNameDefault = 'BoosterTriggerData.mat';
        %FileName = which(FileNameDefault);
        %if isempty(FileName)
        %    FileName = FileNameDefault;
        %    TriggerData = [];
        %else
        %    load(FileName);
        %end
        %                               Time                     InjTrigger                BumpTrigger                ExtTrigger           DCCT                              BucketNumber                 BR_Inj                       BR_Bump                      BR_Ext                     Bend Gain                 Bend Offset
        %TriggerData = [TriggerData; datenum(now) GaussClockData.InjTrigger GaussClockData.BumpTrigger GaussClockData.ExtTrigger 1000*getpv('SR05W___DCCT2__AM01') getpv('SR01C___TIMING_AC08') getpv('BR1_____TIMING_AM00') getpv('BR1_____TIMING_AM01') getpv('BR1_____TIMING_AM04') getpv('BR1_____B__PSGNAC00') getpv('BR1_____B__PSOFAC00')];
        %save(FileName, 'TriggerData');
    end
end

if strcmpi(ztec.Device.ScopeType, 'Caen Power Supply Tesing')
    t = get(handles.Line{1}(1), 'XData');
    y = get(handles.Line{1}(1), 'YData');
    n = 100;
    tt = t(1:100000-25);
    yy = zeros(1,100000-25);
    Rate = zeros(1,100000-n);
    for i = 1:length(yy)
        yy(i) = mean(y(i:i+24));
    end
    for i = 1:length(Rate)
        %tt(i) = t(i);
        Rate(i) = .25*(y(i+n)-y(i))/(t(i+n)-t(i));
    end
   %set(handles.Line{2}(1), 'XData', t(1:length(Rate)), 'YData', Rate);
    set(handles.Line{2}(1), 'XData', tt(1:length(Rate)), 'YData', Rate);
    
    t = get(handles.Line{1}(2), 'XData');
    y = get(handles.Line{1}(2), 'YData');
    n = 100;
    tt = t(1:100000-25);
    yy = zeros(1,100000-25);
    Rate = zeros(1,100000-n);
    for i = 1:length(yy)
        yy(i) = mean(y(i:i+24));
    end
    for i = 1:length(Rate)
        %tt(i) = t(i);
        Rate(i) = .25*(y(i+n)-y(i))/(t(i+n)-t(i));
    end
   %set(handles.Line{2}(1), 'XData', t(1:length(Rate)), 'YData', Rate);
    set(handles.Line{2}(2), 'XData', tt(1:length(Rate)), 'YData', Rate);    
end

% If not using scaled data
%Inp1 = (Inp1Range * Inp1 / 2^31) + Inp1Offset;
%Inp2 = (Inp2Range * Inp2 / 2^31) + Inp2Offset;


if ~isempty(DataTimeStr)
    set(handles.TimeStamp, 'String', DataTimeStr);
end

%if strcmpi(ztec.Device.ScopeType, 'Booster ICT')
%    % Removed since it requires a delay to wait for the PVs to update
%    Info = sprintf('%.2f mA to SR (%.1f%% eff)    %s', getpv('BTS_To_SR_Injection_Rate'), 100*getpv('BTS_To_SR_Injection_Efficiency'), DataTimeStr);
%    set(handles.TimeStamp, 'String', Info);
%end


% Info window
%set(handles.OpComplete, 'String', sprintf('   %.2f seconds since the last trigger', etime(t_trigger, t_trigger_last)));

%fprintf('  %10.5f seconds to analyze and plot\n', toc);
%fprintf('  %10.5f seconds from measurement complete to ploting complete\n\n', etime(clock, t_trigger));

drawnow;


if strcmpi(ztec.Device.Type, 'ztec')
    % If in Continuous mode, start a new capture when in single shot mode
    %if get(handles.Continuous,'Value')==1 && getpvonline([ScopeName,':OpInitiate'],'double') == 0
    if getpvonline([ScopeName,':OpInitiate'],'double') == 0
        setpvonline([ScopeName,':OpInitiate'], 0);
    end
end





%%%%%%%%%%%%%%%
% GUI Widgets %
%%%%%%%%%%%%%%%

% Start/Stop Button Callback: start/stop the timer
function StartStopCallback(hObject,evendata,handles)

handles = guidata(hObject);

if get(handles.StartStop, 'Value') == 0
    
    set(handles.StartStop, 'Value', 0);
    set(handles.StartStop, 'String', 'Start');
    %     if isfield(handles, 'TimerHandle')
    %         stop(handles.TimerHandle);
    %     end
    
else
    
    %     if isfield(handles, 'TimerHandle')
    %         start(handles.TimerHandle);
    %     end
    set(handles.StartStop, 'Value', 1);
    set(handles.StartStop, 'String', 'Stop');
    
end
drawnow;


function EDMCallback(hObject,evendata,handles)

handles = guidata(hObject);

ztec       = getappdata(handles.hMainFigure, 'ZTECSetup');
ScopeName  = ztec.Device.Name;

if isfield(ztec.Device.Setup, 'setInp4Imped')
    fprintf('   %s\n',['/home/als/physbase/hlc/General/Ztec/runZtec4.sh ', ScopeName]);
    unix(['/home/als/physbase/hlc/General/Ztec/runZtec4.sh ', ScopeName, ' &']);
else
    fprintf('   %s\n',['/home/als/physbase/hlc/General/Ztec/runZtec2.sh ', ScopeName]);
    unix(['/home/als/physbase/hlc/General/Ztec/runZtec2.sh ', ScopeName, ' &']);
end



% function ContinuousCallback(varargin)
% h = get(varargin{1}, 'Parent');
% handles = getappdata(h, 'HandleStructure');
% ztec    = getappdata(handles.hMainFigure, 'ZTECSetup');
% ScopeName = ztec.Device.Name;
%
% if get(handles.Continuous, 'Value') == 1
%     set(handles.Continuous, 'Value', 0);
%     setpvonline([ScopeName,':OpInitiate'], 0);
% else
%     set(handles.Continuous, 'Value', 1);
%     setpvonline([ScopeName,':OpInitiate'], ztec.Device.Setup.OpInitiate);
% end




% function handles = graphit_setup(ztec, mainfigure)
function graphit_setup(ztec, mainfigure, ScopeTypeCell)

GR  = ztec.GraphIt;
Fig = ztec.Figure;


ghandles = guidata(mainfigure);

% Set the figure properties
FigureFields = fieldnames(Fig);
for i = 1:length(FigureFields)
    set(mainfigure, FigureFields{i}, Fig.(FigureFields{i}));
end


% add a toolbar
hT =findall(mainfigure,'Type','uitoolbar');

ghandles.hToolbar = hT;

% Save the structure
guidata(mainfigure,ghandles);

%  2.2 Remove tools not needed in default matlab toolbar
% make them visible first
set(0,'Showhidden','on');

hCh = get(ghandles.hToolbar,'Children');

for i =1:length(hCh)
    
    %     'FigureToolBar'
    %     'Plottools.PlottoolsOn'
    %     'Plottools.PlottoolsOff'
    %     'Annotation.InsertLegend'
    %     'Annotation.InsertColorbar'
    %     'DataManager.Linking'
    %     'Exploration.Brushing'
    %     'Exploration.DataCursor'
    %     'Exploration.Rotate'
    %     'Exploration.Pan'
    %     'Exploration.ZoomOut'
    %     'Exploration.ZoomIn'
    %     'Standard.EditPlot'
    %     'Standard.PrintFigure'
    %     'Standard.SaveFigure'
    %     'Standard.FileOpen'
    %     'Standard.NewFigure'
    
    %     keep zoom in and zoom out
    if(~(strcmpi(get(hCh(i), 'Tag'),'Exploration.ZoomOut') ...
            || (strcmpi(get(hCh(i), 'Tag'),'Exploration.ZoomIn') )))
        delete(hCh(i));
    end
    
end


try
    
    xIcon = fullfile(matlabroot,'/toolbox/matlab/icons/zoomx.mat');
    cdatax = importdata(xIcon);
    
catch ME
    fprintf('Error loading button icon %s %s.....',xIcon, ME.message);
end

try
    
    yIcon = fullfile(matlabroot,'/toolbox/matlab/icons/zoomy.mat');
    cdatay = importdata(yIcon);
    
catch ME
    fprintf('Error loading button icon %s %s.....',yIcon, ME.message);
end


ghandles.hAutoScaleXToggle = uitoggletool(ghandles.hToolbar,'CData',cdatax,...
    'TooltipString','AutoScale X','Separator','On',...
    'Tag','AutoscaleX',...
    'OnCallback',@AutoscaleXOnCallback,...
    'OffCallback',@AutoscaleXOffCallback);

ghandles.hAutoScaleYToggle = uitoggletool(ghandles.hToolbar,'CData',cdatay,...
    'TooltipString','AutoScale Y',...
    'Separator','Off',...
    'Tag','AutoscaleY',...
    'OnCallback',@AutoscaleYOnCallback,...
    'OffCallback',@AutoscaleYOffCallback);


guidata(mainfigure,ghandles);



% 3. Create and populate menu

% now create custon menu

% File Menu
ghandles.hFileMenu      =   uimenu(...       % File menu
    'Tag', 'FileMenu',...
    'Parent',mainfigure,...
    'HandleVisibility','callback', ...
    'Label','File');


% Add menu items to File Menu
ghandles.hOpenMenuitem  =  uimenu(...       % Open menu item
    'Parent',ghandles.hFileMenu,...
    'Tag', 'OpenMenu',...
    'Label','Open new graph',...
    'HandleVisibility','callback', ...
    'Callback', @hOpenMenuitemCallback);


% Add menu items to File Menu
ghandles.hPrintMenuitem  =  uimenu(...       % Print menu item
    'Parent',ghandles.hFileMenu,...
    'Tag', 'PrintMenu',...
    'Label','Print',...
    'HandleVisibility','callback', ...
    'Callback', @hPrintMenuitemCallback);



% Add menu items to File Menu
ghandles.hSaveAsMenuitem  =  uimenu(...       % SaveAs menu item
    'Parent',ghandles.hFileMenu,...
    'Tag', 'SaveAsMenu',...
    'Label','Save as...',...
    'HandleVisibility','callback', ...
    'Callback', @hSaveAsMenuitemCallback);


ghandles.hCloseMenuitem  =  uimenu(...       % Close menu item
    'Parent',ghandles.hFileMenu,...
    'Tag', 'CloseMenu',...
    'Label','Close',...
    'Separator','on',...
    'HandleVisibility','callback', ...
    'Callback', @hCloseMenuitemCallback);


guidata(mainfigure,ghandles);


% 3.2.2 Device Menu
ghandles.hDeviceMenu = uimenu(...       % Device menu
    'Parent',mainfigure,...
    'Tag', 'DeviceMenu',...
    'HandleVisibility','callback', ...
    'Label','Device');

% Add menu items to multiple menu:
for item =1: length(ScopeTypeCell)
    % Here set on callback for all items
    if iscell(ScopeTypeCell{item})
        Label = ScopeTypeCell{item}{1};
        ScopeCell = ScopeTypeCell{item}{2};
        
        Menuitem = uimenu(...
            'Parent',ghandles.hDeviceMenu,...
            'Label',Label,...
            'Separator','off',...
            'Checked','off');
        
        for item = 1: length(ScopeCell)
            ghandles.hDeviceMenuitem(item) = uimenu(...
                'Parent',Menuitem,...
                'Label', ScopeCell{item},...
                'Tag',   ScopeCell{item},...
                'Separator','off',...
                'Checked','off',...
                'HandleVisibility','callback', ...
                'Callback', @hDeviceMenuitemCallback);
        end
        
    else
        ghandles.hDeviceMenuitem(item) = uimenu(...
            'Parent',ghandles.hDeviceMenu,...
            'Label',ScopeTypeCell{item},...
            'Tag',ScopeTypeCell{item},...
            'Separator','off',...
            'Checked','off',...
            'HandleVisibility','callback', ...
            'Callback', @hDeviceMenuitemCallback);
    end
end

guidata(mainfigure,ghandles);

% 3.2.3 Options Menu (for ztec scopes only)
if strcmpi(ztec.Device.Type, 'ztec')
    ScopeName = ztec.Device.Name;

    ghandles.hOptionsMenu = uimenu(...       % Device menu
        'Parent',mainfigure,...
        'Tag', 'OptionsMenu',...
        'HandleVisibility','callback', ...
        'Label','Options');
    
    
    ghandles.hHorizTimeMenuitem  =  uimenu(...       % HorizTime menu item
        'Parent',ghandles.hOptionsMenu,...
        'Tag', 'HorizTimeMenu',...
        'Label','Horiz Time',...
        'HandleVisibility','callback');
    
    ghandles.hHorizTimeMenuitem1  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizTimeMenuitem,...
        'Tag', 'HorizTimeMenuItem1',...
        'Label','Horiz Time',...
        'Enable','Off',...
        'HandleVisibility','callback', ...
        'Callback', @hHorizTimeMenuitem1Callback);
    
    
    ghandles.hHorizOffsetMenuitem  =  uimenu(...       % HorizOffset menu item
        'Parent',ghandles.hOptionsMenu,...
        'Tag', 'HorizOffsetMenu',...
        'Label','Horiz Offset',...
        'HandleVisibility','callback');
    
    ghandles.hHorizOffsetMenuitemPre100  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Pre-Trigger 100% of Horz Time',...
        'Tag','PreTrigger100',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    ghandles.hHorizOffsetMenuitemPre75  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Pre-Trigger  75% of Horz Time',...
        'Tag','PreTrigger75',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    ghandles.hHorizOffsetMenuitemPre50  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Pre-Trigger  50% of Horz Time',...
        'Tag','PreTrigger50',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    ghandles.hHorizOffsetMenuitemPre25  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Pre-Trigger  25% of Horz Time',...
        'Tag','PreTrigger25',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    ghandles.hHorizOffsetMenuitemZero  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','0 Offset',...
        'Tag','HorizOffsetZero',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    ghandles.hHorizOffsetMenuitemPost25  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Post-Trigger  25% of Horz Time',...
        'Tag','PostTrigger25',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    ghandles.hHorizOffsetMenuitemPost50  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Post-Trigger  50% of Horz Time',...
        'Tag','PostTrigger50',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    
    ghandles.hHorizOffsetMenuitemPost75  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Post-Trigger  75% of Horz Time',...
        'Tag','PostTrigger75',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    
    ghandles.hHorizOffsetMenuitemPost100  =  uimenu(...       % HorizTime1 menu item
        'Parent',ghandles.hHorizOffsetMenuitem,...
        'Label','Post-Trigger 100% of Horz Time',...
        'Tag','PostTrigger100',...
        'HandleVisibility','callback', ...
        'Callback', @hSetHorizOffsetMenuitemCallback);
    
    
    
    guidata(mainfigure,ghandles);
    
    % Trigger Item
    
    ghandles.hTriggerMenuitem  =  uimenu(...
        'Parent',ghandles.hOptionsMenu,...
        'Tag', 'TriggerMenuItem',...
        'HandleVisibility','callback', ...
        'Label','Trigger');
    
    ghandles.hForceTriggerMenuitem  =  uimenu(...
        'Parent',ghandles.hTriggerMenuitem,...
        'Label','Force a Trigger',...
        'Tag','ForceTrigger',...
        'HandleVisibility','callback', ...
        'Callback', @hForceTriggerMenuitemCallback);
    
    ghandles.hTriggerOnChannelMenuitem  = uimenu(...
        'Parent',ghandles.hTriggerMenuitem,...
        'Tag', 'TriggerOnChannelMenuItem',...
        'Label','Trigger On Channel',...
        'Separator','on',...
        'HandleVisibility','callback');
    
    
    guidata(mainfigure,ghandles);
    
    % Number of channel for this scope
    % Ex. ZTEC,ZT4211LXI,22141,5.60
    UtilID = getpvonline([ScopeName,':UtilID']);
    if length(UtilID)>=14 && strcmpi(UtilID(1:14),'ZTEC,ZT4628LXI')
        % ZT4628 demo scope
        numberOfChannels = 2;
    elseif UtilID(11) == '1'
        numberOfChannels = 2;
    else
        numberOfChannels = 4;
    end

    % scopes; count number of channels for THIS scope
    % this is needed to dynamically create the options menu for the scope
    %numberOfChannels = 0;
    %for i=1:length(GR)
    %    n =length(GR{i}.ChannelNames);
    %    numberOfChannels =  numberOfChannels + n;
    %end
    
    % create the Trigger On Channel menu items
    % and set the checked default value from
    % the set up value
    for nCh =1: numberOfChannels
        
        % here set on callback for all items
        ghandles.hTriggerOnChannel(nCh)=uimenu(...
            'Parent',ghandles.hTriggerOnChannelMenuitem,...
            'Label',['Ch',num2str(nCh)],...
            'Tag',['TriggerOnChannel',num2str(nCh)],...
            'HandleVisibility','callback', ...
            'Callback', @hTriggerOnChannelMenuitemCallback);
        
        switch(num2str(nCh))
            
            case '1'
                if(strcmpi(ztec.Device.Setup.setTrigSource,'INP1'))
                    set(ghandles.hTriggerOnChannel(nCh), 'Checked','On');
                end
                
            case '2'
                if(strcmpi(ztec.Device.Setup.setTrigSource,'INP2'))
                    set(ghandles.hTriggerOnChannel(nCh), 'Checked','On');
                end
                
            case '3'
                if(strcmpi(ztec.Device.Setup.setTrigSource,'INP3'))
                    set(ghandles.hTriggerOnChannel(nCh), 'Checked','On');
                end
                
            case '4'
                if(strcmpi(ztec.Device.Setup.setTrigSource,'INP4'))
                    set(ghandles.hTriggerOnChannel(nCh), 'Checked','On');
                end
                
        end
        
        
        % ztec.Setup.setTrigSource
        if(nCh == numberOfChannels)
            ghandles.hTriggerOnChannelEXT = uimenu(... % Close menu item
                'Parent',ghandles.hTriggerOnChannelMenuitem,...
                'Label','EXT',...
                'Tag',['TriggerOnChannel','EXT'],...
                'HandleVisibility','callback', ...
                'Callback', @hTriggerOnChannelMenuitemCallback);
            if(strcmpi(ztec.Device.Setup.setTrigSource,'EXT'))
                set(ghandles.hTriggerOnChannelEXT, 'Checked','On');
            end
        end
    end
    
    guidata(mainfigure,ghandles);
    
    ghandles.hImpedanceMenuitem  =  uimenu(...
        'Parent',ghandles.hOptionsMenu,...
        'HandleVisibility','callback', ...
        'Label','Impedance');
    
    
    for nCh =1: numberOfChannels
        
        % here set on callback for all items
        ghandles.hChImpedance(nCh) = uimenu(...
            'Parent',ghandles.hImpedanceMenuitem,...
            'Label',['Ch',num2str(nCh)],...
            'Tag',num2str(nCh),...
            'HandleVisibility','callback');
        
        ghandles.h50ChImpedance(nCh)=uimenu(...
            'Parent',ghandles.hChImpedance(nCh),...
            'Label','50 Ohm',...
            'Tag','50Ohm',...
            'HandleVisibility','callback',...
            'Callback', @hSetChImpedanceMenuitemCallback);
        
        ghandles.h1MChImpedance(nCh)=uimenu(...
            'Parent',ghandles.hChImpedance(nCh),...
            'Label','1M Ohm',...
            'Tag','1MOhm',...
            'HandleVisibility','callback',...
            'Callback', @hSetChImpedanceMenuitemCallback);
        
        
        % initialize menu: set checked impedance based on set up file
        switch(num2str(nCh))
            
            case '1'
                if(ztec.Device.Setup.setInp1Imped == 50)
                    set(ghandles.h50ChImpedance(nCh), 'Checked','On');
                elseif(ztec.Device.Setup.setInp1Imped == 1e6)
                    set(ghandles.h1MChImpedance(nCh), 'Checked','On');
                end
                
            case '2'
                if(ztec.Device.Setup.setInp2Imped == 50)
                    set(ghandles.h50ChImpedance(nCh), 'Checked','On');
                elseif(ztec.Device.Setup.setInp2Imped == 1e6)
                    set(ghandles.h1MChImpedance(nCh), 'Checked','On');
                end
                
            case '3'
                if(ztec.Device.Setup.setInp3Imped == 50)
                    set(ghandles.h50ChImpedance(nCh), 'Checked','On');
                elseif(ztec.Device.Setup.setInp3Imped == 1e6)
                    set(ghandles.h1MChImpedance(nCh), 'Checked','On');
                end
                
            case '4'
                if(ztec.Device.Setup.setInp4Imped == 50)
                    set(ghandles.h50ChImpedance(nCh), 'Checked','On');
                elseif(ztec.Device.Setup.setInp4Imped == 1e6)
                    set(ghandles.h1MChImpedance(nCh), 'Checked','On');
                end
                
                
        end
        
        
        if(nCh == numberOfChannels)
            
            ghandles.hEXTImpedance  = uimenu(...
                'Parent',ghandles.hImpedanceMenuitem,...
                'Label','EXT',...
                'Tag','EXT',...
                'HandleVisibility','callback');
            
            ghandles.h50EXTImpedance = uimenu(...
                'Parent',ghandles.hEXTImpedance,...
                'Label','50 Ohm',...
                'Tag','50Ohm',...
                'Checked','Off',...
                'HandleVisibility','callback',...
                'Callback', @hSetChImpedanceMenuitemCallback);
            
            ghandles.h1MEXTImpedance = uimenu(...
                'Parent',ghandles.hEXTImpedance,...
                'Label','1M Ohm',...
                'Tag','1MOhm',...
                'Checked','On',...
                'HandleVisibility','callback',...
                'Callback', @hSetChImpedanceMenuitemCallback);
            % initialize menu: set checked impedance based on set up file
            if(ztec.Device.Setup.setTrigImpedExt == 50)
                set(ghandles.h50EXTImpedance, 'Checked','On');
            elseif(ztec.Device.Setup.setTrigImpedExt == 1e6)
                set(ghandles.h1MEXTImpedance, 'Checked','On');
            end
            
        end
    end
end


guidata(mainfigure,ghandles);

% Set the axis properties
iAxes = 0;
for i = 1:length(GR);
    iAxes = iAxes + 1;
    ghandles.axes(iAxes) = axes;
    Fields = fieldnames(GR{i}.Axes);
    for k = 1:length(Fields);
        if strcmpi(Fields{k}, 'YLabel')
            YLabel = GR{i}.Axes.(Fields{k});
            h = get(ghandles.axes(iAxes), 'YLabel');
            YLabelFields = fieldnames(YLabel);
            for m = 1:length(YLabelFields)
                set(h, YLabelFields{m}, YLabel.(YLabelFields{m}));
            end
            
            % set contex menu a label
            % right click: displays line name and color
            hcontext(i)=uicontextmenu;
            set(h,'uicontextmenu',hcontext(i));
            
            for it =1:size(GR{i}.Data.DisplayString,2)
                item(it) = uimenu(hcontext(i), 'Label', GR{i}.Data.DisplayString{it});
                set(item(it),'ForegroundColor', GR{i}.Line.Color{it});
            end
            
        elseif strcmpi(Fields{k}, 'XLabel')
            XLabel = GR{i}.Axes.(Fields{k});
            h = get(ghandles.axes(iAxes), 'XLabel');
            XLabelFields = fieldnames(XLabel);
            for m = 1:length(XLabelFields)
                set(h, XLabelFields{m}, XLabel.(XLabelFields{m}));
            end
        elseif strcmpi(Fields{k}, 'Title')
            TitleStruct = GR{i}.Axes.(Fields{k});
            h = get(ghandles.axes(iAxes), 'Title');
            TitleFields = fieldnames(TitleStruct);
            for m = 1:length(TitleFields)
                set(h, TitleFields{m}, TitleStruct.(TitleFields{m}));
            end
        else
            %Fields{k}
            set(ghandles.axes(iAxes), Fields{k}, GR{i}.Axes.(Fields{k}));
        end
    end
    %set(ghandles.axes(iAxes), 'HandleVisibility', 'Off');
end

guidata(mainfigure,ghandles);


% Set the line properties
for i = 1:length(GR)
    LineFields = fieldnames(GR{i}.Line);
    for j = 1:length(GR{i}.ChannelNames)
        axes(ghandles.axes(i));
        ghandles.Line{i}(j) = line(NaN*[1 2 3], NaN*[0 .5 6]);
        set(ghandles.axes(i), 'NextPlot', 'Add');
        for k = 1:length(LineFields)
            set(ghandles.Line{i}(j), LineFields{k}, GR{i}.Line.(LineFields{k}){j});
        end
    end
    set(ghandles.axes(i), 'NextPlot', 'Replace');
    
end
guidata(mainfigure,ghandles);


% Link the x axes
if length(ghandles.axes) > 1
    % All the XLimMode are auto, then use linkaxes
    %XLimAllAuto = 1;
    %for i = 1:length(ghandles.axes)
    %    if strcmpi(GR{i}.Axes.XLimMode, 'Manual')
    %        XLimAllAuto = 0;
    %    end
    %end
    %if XLimAllAuto
    %    linkaxes(ghandles.axes, 'x');
    %end
    
    linkaxes(ghandles.axes, 'x');
    
    % Note: linkaxes sets the XLimMode to manual.  Try setting it back to Auto.
    %       This gave inconsistent
    for i = 1:length(ghandles.axes)
        if strcmpi(GR{i}.Axes.XLimMode, 'Auto')
            %get(ghandles.axes(i), 'XLimMode')
            set(ghandles.axes(i), 'XLimMode', 'Auto');
            %get(ghandles.axes(i), 'XLimMode')
        end
    end
end




% 3.3 define callbacks for menu items...

% File Menu callbacks

% Open a new graph als_waveform
function hOpenMenuitemCallback(hObject, eventdata, handles)

als_waveforms;
% fprintf('Open new  graph \n');



function hPrintMenuitemCallback(hObject, eventdata, handles)

handles = guidata(hObject);
printdlg('-setup',handles.hMainFigure);
fprintf('Print graph \n');


function hSaveAsMenuitemCallback(hObject, eventdata, handles)
h= guidata(hObject);
[filename,pathname] = uiputfile;
if isequal(filename,0) || isequal(pathname,0)
    %  disp('User selected Cancel')
    return;
else
    % disp(['User selected',fullfile(pathname,filename)])
    saveas(h.hMainFigure,fullfile(pathname,filename))
end

% fprintf('Save as graph \n');



function hCloseMenuitemCallback(hObject, eventdata, handles)

handles = guidata(hObject);
% call delete callback and stops the timer
delete(handles.hMainFigure);





%Device Menu Callbacks
% user selects one device under device menu:
% close current gui application and open new one
% chosen
function hDeviceMenuitemCallback(hObject, eventdata, handles)


handles = guidata(hObject);

WhichDevice = get(hObject, 'Tag');
pos  = get(handles.hMainFigure, 'Position');
% calls delete callback and stops the timer
delete(handles.hMainFigure);
%TODO: check this...all handles OK?
als_waveforms(WhichDevice,'Position', pos);
% als_waveforms(WhichDevice);
% h = guidata(gcf);
% set(h.hMainFigure, 'Position', pos);
drawnow;








% Options Menu callback
function hHorizTimeMenuitem1Callback(hObject, eventdata, handles)

fprintf('Set Horiz Time \n');



% just set a ztec value
% TODO check this
% value: -pre-trigger time to
% 100
% def:
% Time offset in seconds for trigger from
% selected trigger location offset reference:
% Pre-trigger: 0 to 100% of acquisition time,
% Post-trigger: 0 to 100 seconds

% Pre-trigger: the HorzOffset is relative to the setHorzTime value
function hSetHorizOffsetMenuitemCallback(hObject, eventdata, handles)

% determine which value the user selected
WhichHorizOffset = get(hObject, 'Tag');


% set a value anyhow
HorizOffset =0;

switch(WhichHorizOffset)
    
    
    case 'PreTrigger100'
        
        HorizOffset = 1.0;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
    case 'PreTrigger75'
        
        HorizOffset = 0.75;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
    case 'PreTrigger50'
        
        HorizOffset = 0.50;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
    case 'PreTrigger25'
        
        HorizOffset = 0.25;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
        
    case 'HorizOffsetZero'
        
        HorizOffset = 0;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
        
    case 'PostTrigger25'
        
        HorizOffset = -0.25;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
    case 'PostTrigger50'
        
        HorizOffset = -0.50;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
    case 'PostTrigger75'
        
        HorizOffset = -0.75;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
    case 'PostTrigger100'
        
        HorizOffset = -1.0;
        fprintf('Set Horiz Offset %f \n',HorizOffset);
        
end

% now try to set the channel value
% now, set the value on the scope
handles = guidata(hObject);
ztec  = getappdata(handles.hMainFigure, 'ZTECSetup');
ScopeName = ztec.Device.Name;

% Pre-trigger
%if(HorizOffset > 0)
% TODO check error handling for ca: try catch
% retrieve the acquisition time first
horztime = getpvonline([ScopeName,':setHorzTime']);
%
HorizOffset = horztime*HorizOffset;
%end

setpvonline([ScopeName, ':setHorzOffset'],HorizOffset);
ztec.Device.Setup.setHorzOffset = getpvonline([ScopeName,':getHorzOffset']);

% now Autoscale X
handles = guidata(hObject);

% for i=1:length(handles.axes)
set(handles.axes, 'XLimMode', 'auto');
% end



% call cmd to force a trigger
function hForceTriggerMenuitemCallback(hObject, eventdata, handles)
handles = guidata(hObject);
ztec  = getappdata(handles.hMainFigure, 'ZTECSetup');
ScopeName = ztec.Device.Name;

setpvonline([ScopeName,':OpForceCap'], 1);

fprintf('Force a trigger \n');




% call cmd on Ch (setTrigSource) and check the chosen one
function hTriggerOnChannelMenuitemCallback(hObject, eventdata, handles)

% get selected channel
WhichChannel = get(hObject, 'Tag');

% TODO: this is only the happy path
% move after switch statement
% reset all channels/items to not selected
MenuItems = get(get(hObject, 'Parent'), 'Children');
for k=1:length(MenuItems)
    set(MenuItems(k), 'Checked','Off');
end
% now check the selected channel/item
set(hObject, 'Checked','On');


% now, set the value on the scope
handles = guidata(hObject);
ztec  = getappdata(handles.hMainFigure, 'ZTECSetup');
ScopeName = ztec.Device.Name;

switch(WhichChannel)
    
    % TODO: error handling?
    case 'TriggerOnChannel1'
        setpvonline([ScopeName, ':setTrigSource'],'INP1');
        ztec.Device.Setup.setTrigSource = 'INP1';
        fprintf('Trigger on Channel %s \n',WhichChannel);
        
    case 'TriggerOnChannel2'
        setpvonline([ScopeName, ':setTrigSource'],'INP2');
        ztec.Device.Setup.setTrigSource = 'INP2';
        fprintf('Trigger on Channel %s \n',WhichChannel);
        
    case 'TriggerOnChannel3'
        setpvonline([ScopeName, ':setTrigSource'],'INP3');
        ztec.Device.Setup.setTrigSource = 'INP3';
        fprintf('Trigger on Channel %s \n',WhichChannel);
        
    case 'TriggerOnChannel4'
        setpvonline([ScopeName, ':setTrigSource'],'INP4');
        ztec.Device.Setup.setTrigSource = 'INP4';
        fprintf('Trigger on Channel %s \n',WhichChannel);
        
    case 'TriggerOnChannelEXT'
        setpvonline([ScopeName, ':setTrigSource'],'EXT');
        ztec.Device.Setup.setTrigSource = 'EXT';
        fprintf('Trigger on Channel %s \n',WhichChannel);
        
end


% this is to select Impedance Value on a Ch.
% Default value checked on the menu is set at menu creation
%
function hSetChImpedanceMenuitemCallback(hObject, eventdata, handles)

WhichChannel = get(get(hObject, 'Parent'), 'Tag');

Impedance = get(hObject,'Tag');

fprintf('Channel Impedance \n');

% now set the value on the scope
handles = guidata(hObject);
ztec  = getappdata(handles.hMainFigure, 'ZTECSetup');
ScopeName = ztec.Device.Name;

% set a value anyhow
ImpedanceValue = 1e6;

if(strcmpi(Impedance,'50Ohm'))
    
    ImpedanceValue = 50;
    
elseif(strcmpi(Impedance,'1MOhm'))
    
    ImpedanceValue = 1e6;
end


switch(WhichChannel)
    
    case '1'
        
        setpvonline([ScopeName, ':setInp1Imped'], ImpedanceValue);
        ztec.Device.Setup.setInp1Imped = ImpedanceValue;
        fprintf('Set impedance value %s %f\n',WhichChannel, ImpedanceValue);
        
    case '2'
        
        setpvonline([ScopeName, ':setInp2Imped'], ImpedanceValue);
        ztec.Device.Setup.setInp2Imped = ImpedanceValue;
        fprintf('Set impedance value %s %f\n',WhichChannel, ImpedanceValue);
        
    case '3'
        
        setpvonline([ScopeName, ':setInp3Imped'], ImpedanceValue);
        ztec.Device.Setup.setInp3Imped = ImpedanceValue;
        fprintf('Set impedance value %s %f\n',WhichChannel, ImpedanceValue);
        
    case '4'
        
        setpvonline([ScopeName, ':setInp4Imped'], ImpedanceValue);
        ztec.Device.Setup.setInp4Imped = ImpedanceValue;
        fprintf('Set impedance value %s %f\n',WhichChannel, ImpedanceValue);
        
    case 'EXT'
        % if ImpedanceValue is 50, ask user to confirm
        if(ImpedanceValue == 50)
            
            choice = questdlg('50 Ohm on EXT Trigger is unusual: are you sure you want to set the value?','Warning: Impedance value on EXT Trigger',...
                'Yes','No','No');
            if(~strcmpi(choice, 'Yes'))
                return;
            end
            
        end
        
        setpvonline([ScopeName, ':setTrigImpedExt'], ImpedanceValue);
        ztec.Device.Setup.setTrigImpedExt = ImpedanceValue;
        fprintf('Set impedance value %s %f\n',WhichChannel, ImpedanceValue);
        
end

%THIS is the happy path
%TODO: add some error handling

% First reset all items to Not Checked
MenuItems = get(get(hObject, 'Parent'),'Children');
for k=1:length(MenuItems)
    set(MenuItems(k), 'Checked','Off');
end
% now check the selected item
set(hObject, 'Checked','On');



function errorOnChannel = setZtecChValue(scopename, ch, chvalue)

ScopeName = scopename;
ChannelName = ch;
ChannelValue = chvalue;

errorOnChannel = 0;
try
    
    setpvonline([ScopeName, ':', ChannelName], ChannelValue);
    
    % Just to be safe, I'm adding some delay after certain sets
    if any(strcmpi(ChanName, {'setOutCoerce','setHorzPoints','setHorzTime'}))
        pause(.05);
    end
    if any(strcmpi(ChanName, {'setRestoreState'}))
        pause(.5);  % test this???
    end
    
    
catch ME
    
    fprintf('Error setting channel %s %s %f %s\n',ScopeName, ChannelName, ChannelValue, ME.message);
    errorOnChannel =1;
end




% callback for AutoscaleX ON toggle button
function AutoscaleXOnCallback(hObject, eventdata, handles)

handles = guidata(hObject);
set(handles.axes, 'XLimMode', 'auto');


% callback for AutoscaleX OFF toggle button
function AutoscaleXOffCallback(hObject, eventdata, handles)

handles = guidata(hObject);
set(handles.axes, 'XLimMode', 'manual');

% callback for AutoscaleY ON toggle button
function AutoscaleYOnCallback(hObject, eventdata, handles)

handles = guidata(hObject);
set(handles.axes, 'YLimMode', 'auto');

% callback for AutoscaleY OFF toggle button
function AutoscaleYOffCallback(hObject, eventdata, handles)

handles = guidata(hObject);
set(handles.axes, 'YLimMode', 'manual');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End Menu & Toolbar callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% --- Executes during object deletion, before destroying properties.
function hMainFigure_DeleteFcn(hObject, eventdata, handles)
% If timer is on, then turn it off by deleting the timer handle

try
    handles = guidata(hObject);
    if isfield(handles, 'TimerHandle')
        stop(handles.TimerHandle);
        delete(handles.TimerHandle);
    end
catch ME
    fprintf('Trouble stopping the scope timer on exit: %s.\n',ME.message);
end



function DataTime = EPICS2MatlabTime(DataTime)
t0 = clock;
DateNumber1970 = 719529;  %datenum('1-Jan-1970');
days = datenum(t0(1:3)) - DateNumber1970;
t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
if ~(TimeZoneDiff==-7 || TimeZoneDiff==-8)
    % Typically -7 (daylight savings) or -8 hours
    fprintf('   TimeZoneDiff=%f hours, reset to zero (UTC)!\n', TimeZoneDiff);
    TimeZoneDiff = 0;
end
DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);


