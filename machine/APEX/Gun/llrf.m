function varargout = llrf(varargin)
% LLRF MATLAB code for llrf.fig
%      LLRF, by itself, creates a new LLRF or raises the existing
%      singleton*.
%
%      H = LLRF returns the handle to a new LLRF or the handle to
%      the existing singleton*.
%
%      LLRF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LLRF.M with the given input arguments.
%
%      LLRF('Property','Value',...) creates a new LLRF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before llrf_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to llrf_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help llrf

% Last Modified by GUIDE v2.5 29-Sep-2015 16:23:21
% Feb. 7, 2012. Modified by Fernando. Added FPGA frequency alignment in function setllrf1power
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @llrf_OpeningFcn, ...
    'gui_OutputFcn',  @llrf_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)

% If timer is on, then turn it off by deleting the timer handle
% try
%     %h = get(gcbf, 'UserData');
%     h = get(handles.figure1, 'UserData');
%     if isfield(h,'TimerHandle')
%         stop(h.TimerHandle);
%         delete(h.TimerHandle);
%     end
% catch
%     fprintf('   Trouble stopping the timer on exit.\n');
% end

try
    handles = getappdata(0, 'LLRFTimer');
    
    %  Stop and delete the timer
    if isfield(handles,'TimerHandle')
        stop(handles.TimerHandle);
        delete(handles.TimerHandle);
        rmappdata(0, 'LLRFTimer');
    end
catch
    fprintf('   Trouble stopping the timer on exit.\n');
end

% Check if the figure got closed
% try
%     if ishandle(handles.figure1)
%         close(handles.figure1)
%     end
% catch
%     fprintf('   Trouble closing the figure on exit.\n');
% end


% --- Outputs from this function are returned to the command line.
function varargout = llrf_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes just before llrf is made visible.
function llrf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to llrf (see VARARGIN)

% Choose default command line output for llrf
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% Check if the AO exists (this is required for stand-alone applications)
checkforao;

% UIWAIT makes llrf wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.Line1a = plot(handles.axes1, NaN, NaN);
handles.Line1b = plot(handles.axes2, NaN, NaN);
handles.Line2a = plot(handles.axes3, NaN, NaN);
handles.Line2b = plot(handles.axes4, NaN, NaN);
handles.Line3a = plot(handles.axes5, NaN, NaN);
handles.Line3b = plot(handles.axes6, NaN, NaN);
handles.Line4a = plot(handles.axes7, NaN, NaN);
handles.Line4b = plot(handles.axes8, NaN, NaN);

linkaxes([handles.axes1;handles.axes2;handles.axes3;handles.axes4;handles.axes5;handles.axes6;handles.axes7;handles.axes8],'x');

set(handles.axes1, 'XLimMode', 'auto');
set(handles.axes2, 'YLim', [-180 180]);
set(handles.axes4, 'YLim', [-180 180]);
set(handles.axes6, 'YLim', [-180 180]);
set(handles.axes8, 'YLim', [-180 180]);
set(handles.axes2, 'YTick', [-180 -90 0 90 180]);
set(handles.axes4, 'YTick', [-180 -90 0 90 180]);
set(handles.axes6, 'YTick', [-180 -90 0 90 180]);
set(handles.axes8, 'YTick', [-180 -90 0 90 180]);


% Graph max starting point
GraphMax = getpvonline('llrf1:wave_samp_per_ao');
if GraphMax > 51
    GraphMax = 51;
elseif GraphMax < 1
    GraphMax = 1;
end
set(handles.GraphMax, 'Value', GraphMax);


LLRFData = [];
LLRFData = LLRFCalibration(LLRFData);
setappdata(handles.figure1, 'LLRFData', LLRFData);


% Move to HWINIT???

% pulse_boundary has 4 States
% 00 always trigger (compatible)
% 01 trigger when rf_on or lost rf_master (compatible)
% 10 trigger on rising rf edge only (new)
% 11 trigger on falling rf edge only (new)
pulse_boundary = 0; % ???

% LLRF Defaults  AOs
LLRF_Defaults = {
    'ch_keep_ao', 4080
    %'ddsa_phstep_h_ao', 193534
    'ddsa_phstep_l_ao', 744
    'ddsa_modulo_ao', 4
    'show_test_cnt_bo', 0
    'en_adc0_bo', 1
    'en_adc1_bo', 1
    'en_adc2_bo', 1
    'en_adc3_bo', 1
    'en_dac_bo', 1
    'en_dallas_bo', 1
    'en_slowadc_bo', 1
    'mcp3208_divset_ao', 42
    'mcp3208_trigset_ao', 1920
    'mcp3208_lochan_ao', 1
    'mcp3208_lothresh_ao', {1100 300 300 300 300}  % Threshold for the "Local Oscillator OK" front panel light
    %'pulse_boundary', pulse_boundary  ???
    };
for ii = 1:length(LLRFData)
    LLRF_Prefix = LLRFData{ii}.Prefix;
    try
        for jj = 1:size(LLRF_Defaults,1)
            ChannelName = [LLRF_Prefix, LLRF_Defaults{jj,1}];
            %fprintf('%s\n', ChannelName);

            PreSet = getpvonline(ChannelName, 'double');
            NewSP = LLRF_Defaults{jj,2};
            if iscell(NewSP)
                NewSP = NewSP{ii};
            end
            if PreSet ~= NewSP
                fprintf('   %s was %d setting to %d\n', ChannelName, PreSet, NewSP);
                setpvonline(ChannelName, NewSP);
            end
        end
    catch
        fprintf('%s\n', lasterr);
        fprintf('   Skipping the rest of %s setup.\n', LLRF_Prefix(1:end-1));
    end
end

%getpv('llrf1:permit2_mask')

% Wave shift removed
%WaveShift = getpvonline('llrf1:wave_shift_ao');
%set(handles.WaveShift, 'Value', WaveShift);


% One shot and setup the ylabels
setappdata(0, 'LLRFTimer', handles);
LLRF_Timer_Callback(hObject, eventdata, handles)
LLRF1_Callback(hObject, eventdata, handles);

% Set the Time scaling
GraphMax_Callback(hObject, eventdata, handles);

xlabel(handles.axes7, 'Time [msec]');
xlabel(handles.axes8, 'Time [msec]');


% Setup Timer
UpdatePeriod = .2;

t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@LLRF_Timer_Callback,handles});
%set(t, 'StartFcn', ['llrf(''Timer_Start'',',    sprintf('%.30f',handles.hMainFigure), ',',sprintf('%.30f',handles.hMainFigure), ', [])']);
%set(t, 'UserData', thehandles);
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
set(t, 'ErrorFcn', {@LLRF_Timer_Error,handles});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'LLRFTimer');

handles.TimerHandle = t;

% Save handles
setappdata(0, 'LLRFTimer', handles);

% Draw the figure
set(handles.figure1,'Visible','On');
drawnow expose

start(t);



%%%%%%%%%%%%%%%%%%%%%%%
% Main Timer Callback %
%%%%%%%%%%%%%%%%%%%%%%%
function varargout = LLRF_Timer_Error(hObject, eventdata, handles)
% Unknown fault
set(handles.RFPLCMessage, 'String', 'Unknown Error - Not Updating!!!');
set(handles.RFPLCMessage, 'ForegroundColor', [.5 0 0]);
set(handles.RFFaults, 'String', {'Restart the LLRF application.'});

try
    handles = getappdata(0, 'LLRFTimer');
    
    %  Stop and delete the timer
    if isfield(handles,'TimerHandle')
        stop(handles.TimerHandle);
        delete(handles.TimerHandle);
        rmappdata(0, 'LLRFTimer');
    end
catch
    fprintf('   Trouble stopping the timer.\n');
end



function varargout = LLRF_Timer_Callback(hObject, eventdata, handles)

% This handles copy has the timer and line handles added
%handles = getappdata(0, 'LLRFTimer');

if isempty(handles) || ~ishandle(handles.MagPhase) || ~ishandle(handles.figure1)
    fprintf('Figure handle disappeared.\n');
    return
end

LLRFData = getappdata(handles.figure1, 'LLRFData');


% Check if the power needs to be changed
% Even if the updates are off, allow power changes and check the soft interlocks
try
    LLRFData = setllrf1power(LLRFData, handles);
    setappdata(handles.figure1, 'LLRFData', LLRFData);
catch
    if isempty(strfind(lasterr,'Invalid handle object')) && isempty(strfind(lasterr,'Invalid or deleted object'))
        fprintf('Problem in the RF power subroutine.\n');
        fprintf('%s\n', lasterr);
    else
        fprintf('RF power subroutine interrupted (figure probably got closed.)\n');
        return
    end
end


% This try is to catch if the figure disappears
try
    % Which LLRF board
    ii = LLRFNumber(handles);
    LLRF_Prefix = LLRFData{ii}.Prefix;
    
    if ~isempty(eventdata) && ischar(eventdata) && strcmpi(eventdata,'OneShot')
        % One shot
        
        % Update graph max
        %GraphMaxSet = 73.042200*getpvonline([LLRF_Prefix, 'wave_samp_per_ao'])/255;
        %set(handles.GraphMax, 'String', sprintf('%.6f',t(end)/1e6));  % If editbox
        pause(.1);
        GraphMax = getpvonline([LLRF_Prefix, 'wave_samp_per_ao']);
        if GraphMax > 51
            GraphMax = 51;
        elseif GraphMax < 1
            GraphMax = 1;
        end
        %GraphMaxTimer = get(handles.GraphMax, 'Value');
        %if GraphMax ~= GraphMaxTimer
        %   GraphMaxTimer
        %   GraphMax
        %end
        set(handles.GraphMax, 'Value', GraphMax);
    end
catch
    if isempty(strfind(lasterr,'Invalid handle object')) && isempty(strfind(lasterr,'Invalid or deleted object'))
        fprintf('%s\n', lasterr);
    else
        fprintf('Figure probably got closed.\n');
        return
    end
end


% Get LLRF error/warning conditions
try
    % Reset warning
    RF_Permit = getpvonline('llrf1:rf_permit', 'double');
    RF_Master = getpvonline('llrf1:rf_master', 'double');
    
    if RF_Permit==0 || RF_Master==0
        % Reset error
        if RF_Permit==0
            set(handles.LLRFMessage, 'String', 'RF Permit Error!');
        else
            set(handles.LLRFMessage, 'String', 'RF Master Error!');
        end
        set(handles.LLRFMessage, 'Visible', 'On');
        set(handles.LLRFMessage, 'ForegroundColor', [.5 0 0]);
    else
        % Overflow warnings
        LLRFData{ii}.yscale = getpvonline([LLRF_Prefix, 'yscale']);
        if LLRFData{ii}.yscale > 65535
            set(handles.LLRFMessage, 'ForegroundColor', [.5 0 0]);
            set(handles.LLRFMessage, 'Visible', 'On');
            set(handles.LLRFMessage, 'String', 'Y-Scale Overflow!');
        elseif LLRFData{ii}.yscale > 32767
            set(handles.LLRFMessage, 'ForegroundColor', [.5 .5 0]);
            set(handles.LLRFMessage, 'Visible', 'On');
            set(handles.LLRFMessage, 'String', 'Y-Scale Overflow Approaching?!');
        else
            set(handles.LLRFMessage, 'String', 'Permit & Y-Scale ok');
            set(handles.LLRFMessage, 'ForegroundColor', [0 .5 0]);
            set(handles.LLRFMessage, 'Visible', 'On');
        end
    end
    
    % Check the interlock state on each LLRF board
    InterlockFlag = 0;
    for ii = 1:length(LLRFData)
        InterlockSum = getpvonline([LLRFData{ii}.Prefix, 'interlock']);
        if InterlockSum ~= 15
            InterlockFlag = 1;
            set(handles.LLRFIntlkMessage, 'String', sprintf('%s Intlk Error (%d)!\n', LLRFData{ii}.Prefix, InterlockSum));
            set(handles.LLRFIntlkMessage, 'ForegroundColor', [.5 0 0]);
            set(handles.LLRFIntlkMessage, 'Visible', 'On');
            break
        end
    end
    if InterlockFlag == 0
        set(handles.LLRFIntlkMessage, 'String', 'Interlock Sum ok');
        set(handles.LLRFIntlkMessage, 'ForegroundColor', [0 .5 0]);
        set(handles.LLRFIntlkMessage, 'Visible', 'On');
    end
    
catch
    if isempty(strfind(lasterr,'Invalid handle object')) && isempty(strfind(lasterr,'Invalid or deleted object'))
        fprintf('Problem getting the LLRF1 error conditions.\n');
        fprintf('%s\n', lasterr);
    else
        fprintf('Update skipped (figure probably got closed.)\n');
        return
    end
end


% This try is to catch if the figure disappears
try
    % Check if graphing pause requested
    if get(handles.StartStop, 'Value')
        % Get new waveforms
        LLRFData = getllrfdata(LLRFData);
        setappdata(handles.figure1, 'LLRFData', LLRFData);
        
        % Local save and plot
        PlotLLRFWaveforms;
    else
        % Updates stopped
        pause(.25);
        %return;
    end
catch
    if isempty(strfind(lasterr,'Invalid handle object')) && isempty(strfind(lasterr,'Invalid or deleted object'))
        fprintf('Problem while getting the LLRF data.\n');
        fprintf('%s\n', lasterr);
    else
        fprintf('Update skipped (figure probably got closed during plot subroutine)\n');
        return
    end
end


% Update the LLRF1 Channels
try
    % RF Go
    %llrfreset = getpvonline('llrf1:rf_go_bo');
    %set(handles.llrfreset, 'Value', sprintf('%d',round(PowerReal)));
    
    % Power
    PowerReal = getpvonline('llrf1:source_re_ao');
    set(handles.PowerReal, 'String', sprintf('%d',round(PowerReal)));
    
    PowerImag = getpvonline('llrf1:source_im_ao');
    set(handles.PowerImag, 'String', sprintf('%d',round(PowerImag)));
    
    PowerC = PowerReal + 1i*PowerImag;
    set(handles.PowerMag,   'String', sprintf('%.1f',abs(PowerC)));
    set(handles.PowerPhase, 'String', sprintf('%.1f',180*angle(PowerC)/pi));
    
    TimeScaleCalFactor=1.0177;%1.02143; %Time Calibration Factor required after March 2014 LLRF upgrade. There 4 of such lines.
    
    % Pulse length in EPICS is 20ns / unit  -> should be 10 ns/unit???
    PulseLength = getpvonline('llrf1:pulse_length_ao');
    set(handles.PulseLength, 'String', sprintf('%.6f',10*PulseLength/(TimeScaleCalFactor*1e6)));
    
    % Repetition period in EPICS is 20ns / unit  -> should be 10 ns/unit???
    RepPeriod = getpvonline('llrf1:rep_period_ao');
    set(handles.RepPeriod, 'String', sprintf('%.6f',10*RepPeriod/(TimeScaleCalFactor*1e6)));

    %set(handles.MatlabFreqLoop, 'Value', getpvonline('llrf1:freq_loop_close','double'));

    % Graph max
    %GraphMaxSet = 73.042200*getpvonline('llrf1:wave_samp_per_ao')/255;
    %set(handles.GraphMax, 'String', sprintf('%.6f',t(end)/1e6));  % If editbox
    %GraphMax = getpvonline('llrf1:wave_samp_per_ao');
    %if GraphMax > 51
    %    GraphMax = 51;
    %elseif GraphMax < 1
    %    GraphMax = 1;
    %end
    %GraphMaxTimer = get(handles.GraphMax, 'Value');
    %if GraphMax ~= GraphMaxTimer
    %    GraphMaxTimer
    %    GraphMax
    %end
    %set(handles.GraphMax, 'Value', GraphMax);
    
    % Wave shift removed
    %WaveShift = getpvonline('llrf1:wave_shift_ao');
    %set(handles.WaveShift, 'Value', WaveShift);
    
    %TriggerMode = getpvonline('llrf1:pulse_boundary_bo','double');
    %if TriggerMode == 1
    %    set(handles.StartStop, 'Value', 1);
    %    set(handles.StartStop, 'BackgroundColor', [.757 .867 .776]);
    %    set(handles.StartStop, 'String', 'Trigger: On');
    %else
    %    set(handles.StartStop, 'Value', 0);
    %    set(handles.StartStop, 'BackgroundColor', [.702 .702 .702]-.1);
    %    set(handles.StartStop, 'String', 'Trigger: Free Run');
    %end
    
catch
    if isempty(strfind(lasterr,'Invalid handle object')) && isempty(strfind(lasterr,'Invalid or deleted object'))
        fprintf('Problem in the LLRF code section.\n');
        fprintf('%s\n', lasterr);
        pause(.25);
        return
    else
        fprintf('Update skipped (figure probably got closed.)\n');
        pause(.25);
        return
    end
end


% This try is to catch if the figure disappears
try
    drawnow;
    pause(.25);
catch
    if isempty(strfind(lasterr,'Invalid handle object')) && isempty(strfind(lasterr,'Invalid or deleted object'))
        fprintf('%s\n', lasterr);
    else
        fprintf('Figure probably got closed.\n');
        return
    end
end



function LLRFData = getllrfdata(LLRFData)

% Get all the data - 20x2 waveforms!
for ii = 1:length(LLRFData)
    Board = LLRFData{ii}.Prefix;
    
    % Check data time so that the real and imag are from the same data
    ReadCounter = 1;
    while ReadCounter
        [Wave, tout, DataTime]= getpvonline([Board, 'w1']);
        LLRFData{ii}.Inp1.Real.ADC_Min = min(Wave);
        LLRFData{ii}.Inp1.Real.ADC_Max = max(Wave);
        LLRFData{ii}.Inp1.Real.Data = Wave;
        LLRFData{ii}.Inp1.Real.Time = DataTime;
        
        [Wave, tout, DataTime]= getpvonline([Board, 'w2']);
        LLRFData{ii}.Inp1.Imag.ADC_Min = min(Wave);
        LLRFData{ii}.Inp1.Imag.ADC_Max = max(Wave);
        LLRFData{ii}.Inp1.Imag.Data = Wave;
        LLRFData{ii}.Inp1.Imag.Time = DataTime;
        
        [Wave, tout, DataTime]= getpvonline([Board, 'w3']);
        LLRFData{ii}.Inp2.Real.ADC_Min = min(Wave);
        LLRFData{ii}.Inp2.Real.ADC_Max = max(Wave);
        LLRFData{ii}.Inp2.Real.Data = Wave;
        LLRFData{ii}.Inp2.Real.Time = DataTime;
        
        [Wave, tout, DataTime]= getpvonline([Board, 'w4']);
        LLRFData{ii}.Inp2.Imag.ADC_Min = min(Wave);
        LLRFData{ii}.Inp2.Imag.ADC_Max = max(Wave);
        LLRFData{ii}.Inp2.Imag.Data = Wave;
        LLRFData{ii}.Inp2.Imag.Time = DataTime;
        
        [Wave, tout, DataTime]= getpvonline([Board, 'w5']);
        LLRFData{ii}.Inp3.Real.ADC_Min = min(Wave);
        LLRFData{ii}.Inp3.Real.ADC_Max = max(Wave);
        LLRFData{ii}.Inp3.Real.Data = Wave;
        LLRFData{ii}.Inp3.Real.Time = DataTime;
        
        [Wave, tout, DataTime]= getpvonline([Board, 'w6']);
        LLRFData{ii}.Inp3.Imag.ADC_Min = min(Wave);
        LLRFData{ii}.Inp3.Imag.ADC_Max = max(Wave);
        LLRFData{ii}.Inp3.Imag.Data = Wave;
        LLRFData{ii}.Inp3.Imag.Time = DataTime;
        
        [Wave, tout, DataTime]= getpvonline([Board, 'w7']);
        LLRFData{ii}.Inp4.Real.ADC_Min = min(Wave);
        LLRFData{ii}.Inp4.Real.ADC_Max = max(Wave);
        LLRFData{ii}.Inp4.Real.Data = Wave;
        LLRFData{ii}.Inp4.Real.Time = DataTime;
        
        [Wave, tout, DataTime]= getpvonline([Board, 'w8']);
        LLRFData{ii}.Inp4.Imag.ADC_Min = min(Wave);
        LLRFData{ii}.Inp4.Imag.ADC_Max = max(Wave);
        LLRFData{ii}.Inp4.Imag.Data = Wave;
        LLRFData{ii}.Inp4.Imag.Time = DataTime;
        
        dt2 = LLRFData{ii}.Inp1.Imag.Time - LLRFData{ii}.Inp1.Real.Time;
        dt3 = LLRFData{ii}.Inp2.Real.Time - LLRFData{ii}.Inp1.Real.Time;
        dt4 = LLRFData{ii}.Inp2.Imag.Time - LLRFData{ii}.Inp1.Real.Time;
        dt5 = LLRFData{ii}.Inp3.Real.Time - LLRFData{ii}.Inp1.Real.Time;
        dt6 = LLRFData{ii}.Inp3.Imag.Time - LLRFData{ii}.Inp1.Real.Time;
        dt7 = LLRFData{ii}.Inp4.Real.Time - LLRFData{ii}.Inp1.Real.Time;
        dt8 = LLRFData{ii}.Inp4.Imag.Time - LLRFData{ii}.Inp1.Real.Time;
        
        % Delta time in milliseconds
        dt = [real(dt2)+imag(dt2)/1e6 real(dt3)+imag(dt3)/1e6 real(dt4)+imag(dt4)/1e6 real(dt5)+imag(dt5)/1e6 real(dt6)+imag(dt6)/1e6 real(dt7)+imag(dt7)/1e6 real(dt8)+imag(dt8)/1e6];
        dtmax = max(dt);
        if dtmax > 1
            %fprintf('   %s  Delta from w1  %10.6f  %10.6f  %10.6f  %10.6f  %10.6f  %10.6f %10.6f msec (%d bad attempt)\n', datestr(labca2datenum(LLRFData{ii}.Inp4.Imag.Time)), dt, ReadCounter);
            ReadCounter = ReadCounter + 1;
        else
            %fprintf('   %s  Delta from w1  %10.6f  %10.6f  %10.6f  %10.6f  %10.6f  %10.6f %10.6f msec (ok)\n', datestr(labca2datenum(LLRFData{ii}.Inp4.Imag.Time)), dt);
            ReadCounter = 0;
        end
    end
    
    % LLRF Channels
    LLRFData{ii}.t = getpvonline([Board, 'xaxis']);  % ns (int)
    
    % Y-Scale is affected by,
    % 1. Averaging -wave shift (less "averaging" with greater time), changes max time
    %    28 ADC values are summed per wave_samp_per_ao (10 ns each)
    %    What's the ADC sampel rate???
    %    WaveSamplePeriod = getpvonline('llrf1:wave_samp_per_ao');
    % 2. Vertical "gain" - linear on the log scale
    %    WaveShift = getpvonline('llrf1:wave_shift_ao');
    LLRFData{ii}.yscale = getpvonline([Board, 'yscale']);
    
    
    % Last fault data
    %if get(handles.LastFault, 'Value') == 1
    [Wave, tout, DataTime]= getpvonline([Board, 'w1_fault']);
    LLRFData{ii}.Inp1Fault.Real.ADC_Min = min(Wave);
    LLRFData{ii}.Inp1Fault.Real.ADC_Max = max(Wave);
    LLRFData{ii}.Inp1Fault.Real.Data = Wave;
    LLRFData{ii}.Inp1Fault.Real.Time = DataTime;
    
    [Wave, tout, DataTime]= getpvonline([Board, 'w2_fault']);
    LLRFData{ii}.Inp1Fault.Imag.ADC_Min = min(Wave);
    LLRFData{ii}.Inp1Fault.Imag.ADC_Max = max(Wave);
    LLRFData{ii}.Inp1Fault.Imag.Data = Wave;
    LLRFData{ii}.Inp1Fault.Imag.Time = DataTime;
    
    [Wave, tout, DataTime]= getpvonline([Board, 'w3_fault']);
    LLRFData{ii}.Inp2Fault.Real.ADC_Min = min(Wave);
    LLRFData{ii}.Inp2Fault.Real.ADC_Max = max(Wave);
    LLRFData{ii}.Inp2Fault.Real.Data = Wave;
    LLRFData{ii}.Inp2Fault.Real.Time = DataTime;
    
    [Wave, tout, DataTime]= getpvonline([Board, 'w4_fault']);
    LLRFData{ii}.Inp2Fault.Imag.ADC_Min = min(Wave);
    LLRFData{ii}.Inp2Fault.Imag.ADC_Max = max(Wave);
    LLRFData{ii}.Inp2Fault.Imag.Data = Wave;
    LLRFData{ii}.Inp2Fault.Imag.Time = DataTime;
    
    [Wave, tout, DataTime]= getpvonline([Board, 'w5_fault']);
    LLRFData{ii}.Inp3Fault.Real.ADC_Min = min(Wave);
    LLRFData{ii}.Inp3Fault.Real.ADC_Max = max(Wave);
    LLRFData{ii}.Inp3Fault.Real.Data = Wave;
    LLRFData{ii}.Inp3Fault.Real.Time = DataTime;
    
    [Wave, tout, DataTime]= getpvonline([Board, 'w6_fault']);
    LLRFData{ii}.Inp3Fault.Imag.ADC_Min = min(Wave);
    LLRFData{ii}.Inp3Fault.Imag.ADC_Max = max(Wave);
    LLRFData{ii}.Inp3Fault.Imag.Data = Wave;
    LLRFData{ii}.Inp3Fault.Imag.Time = DataTime;
    
    [Wave, tout, DataTime]= getpvonline([Board, 'w7_fault']);
    LLRFData{ii}.Inp4Fault.Real.ADC_Min = min(Wave);
    LLRFData{ii}.Inp4Fault.Real.ADC_Max = max(Wave);
    LLRFData{ii}.Inp4Fault.Real.Data = Wave;
    LLRFData{ii}.Inp4Fault.Real.Time = DataTime;
    
    [Wave, tout, DataTime]= getpvonline([Board, 'w8_fault']);
    LLRFData{ii}.Inp4Fault.Imag.ADC_Min = min(Wave);
    LLRFData{ii}.Inp4Fault.Imag.ADC_Max = max(Wave);
    LLRFData{ii}.Inp4Fault.Imag.Data = Wave;
    LLRFData{ii}.Inp4Fault.Imag.Time = DataTime;
    
    % needs to be a fault t and yscale ???
    %LLRFData{ii}.t_fault      = getpvonline([Board, 'xaxis_fault']);  % ns (int)
    %LLRFData{ii}.yscale_fault = getpvonline([Board, 'yscale_fault']);
    LLRFData{ii}.t_fault      = getpvonline([Board, 'xaxis']);  % ns (int)
    LLRFData{ii}.yscale_fault = getpvonline([Board, 'yscale']);
    %end
end



function PlotLLRFWaveforms


% This handles copy has the timer and line handles added
handles = getappdata(0, 'LLRFTimer');

if isempty(handles) || ~ishandle(handles.MagPhase) || ~ishandle(handles.figure1)
    fprintf('MagPhase or Figure handle disappeared.\n');
    return;
end

% LLRF Data
LLRFData = getappdata(handles.figure1, 'LLRFData');

% Which LLRF board
ii = LLRFNumber(handles);

if get(handles.LastFault, 'Value') == 1
    FaultFlag = 'Fault';
    YScale = 'yscale_fault';
    t = LLRFData{ii}.t_fault;
else
    FaultFlag = '';
    YScale = 'yscale';
    t = LLRFData{ii}.t;
end

if strcmpi(get(handles.MagPhase, 'Checked'), 'On')
    set(handles.MagString,   'String', 'Magnitude');
    set(handles.PhaseString, 'String', 'Phase');
    
    % sqrt(Watts)
    y1 = LLRFData{ii}.Inp1.ScaleFactor * (LLRFData{ii}.(['Inp1',FaultFlag]).Real.Data/LLRFData{ii}.(YScale) + LLRFData{ii}.(['Inp1',FaultFlag]).Imag.Data/LLRFData{ii}.(YScale) * 1i);
    %y1 = LLRFData{ii}.Inp1.ScaleFactor * (LLRFData{ii}.Inp.Real.Data/LLRFData{ii}.yscale + LLRFData{ii}.Inp1.Imag.Data/LLRFData{ii}.yscale * 1i);
    
    % Watts for magnitude
    y1mag = abs(y1).^2;
    
    set(handles.Line1a, 'XData', t/1e6, 'YData', y1mag);
    set(handles.Line1b, 'XData', t/1e6, 'YData', 180*angle(y1)/pi);
    
    y2 = LLRFData{ii}.Inp2.ScaleFactor * (LLRFData{ii}.(['Inp2',FaultFlag]).Real.Data/LLRFData{ii}.(YScale) + LLRFData{ii}.(['Inp2',FaultFlag]).Imag.Data/LLRFData{ii}.(YScale) * 1i);
    y2mag = abs(y2).^2;
    set(handles.Line2a, 'XData', t/1e6, 'YData', y2mag);
    set(handles.Line2b, 'XData', t/1e6, 'YData', 180*angle(y2)/pi);
    
    y3 = LLRFData{ii}.Inp3.ScaleFactor * (LLRFData{ii}.(['Inp3',FaultFlag]).Real.Data/LLRFData{ii}.(YScale) + LLRFData{ii}.(['Inp3',FaultFlag]).Imag.Data/LLRFData{ii}.(YScale) * 1i);
    y3mag = abs(y3).^2;
    set(handles.Line3a, 'XData', t/1e6, 'YData', y3mag);
    set(handles.Line3b, 'XData', t/1e6, 'YData', 180*angle(y3)/pi);
    
    y4 = LLRFData{ii}.Inp4.ScaleFactor * (LLRFData{ii}.(['Inp4',FaultFlag]).Real.Data/LLRFData{ii}.(YScale) + LLRFData{ii}.(['Inp4',FaultFlag]).Imag.Data/LLRFData{ii}.(YScale) * 1i);
    y4mag = abs(y4).^2;
    set(handles.Line4a, 'XData', t/1e6, 'YData', y4mag);
    set(handles.Line4b, 'XData', t/1e6, 'YData', 180*angle(y4)/pi);
    
elseif strcmpi(get(handles.RealImag, 'Checked'), 'On')
    set(handles.MagString,   'String', 'Real');
    set(handles.PhaseString, 'String', 'Imaginary');
    
    % sqrt(Watts)
    set(handles.Line1a, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp1.ScaleFactor * LLRFData{ii}.(['Inp1',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line1b, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp1.ScaleFactor * LLRFData{ii}.(['Inp1',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
    set(handles.Line2a, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp2.ScaleFactor * LLRFData{ii}.(['Inp2',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line2b, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp2.ScaleFactor * LLRFData{ii}.(['Inp2',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
    set(handles.Line3a, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp3.ScaleFactor * LLRFData{ii}.(['Inp3',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line3b, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp3.ScaleFactor * LLRFData{ii}.(['Inp3',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
    set(handles.Line4a, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp4.ScaleFactor * LLRFData{ii}.(['Inp4',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line4b, 'XData', t/1e6, 'YData', LLRFData{ii}.Inp4.ScaleFactor * LLRFData{ii}.(['Inp4',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
elseif strcmpi(get(handles.NormalizedUnits, 'Checked'), 'On')
    set(handles.MagString,   'String', 'Real');
    set(handles.PhaseString, 'String', 'Imaginary');
    
    % Normalized to +/-1
    set(handles.Line1a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp1',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line1b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp1',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
    set(handles.Line2a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp2',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line2b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp2',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
    set(handles.Line3a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp3',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line3b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp3',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
    set(handles.Line4a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp4',FaultFlag]).Real.Data / LLRFData{ii}.(YScale));
    set(handles.Line4b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp4',FaultFlag]).Imag.Data / LLRFData{ii}.(YScale));
    
elseif strcmpi(get(handles.ADCCounts, 'Checked'), 'On')
    set(handles.MagString,   'String', 'Real');
    set(handles.PhaseString, 'String', 'Imaginary');
    
    % ADC counts
    set(handles.Line1a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp1',FaultFlag]).Real.Data);
    set(handles.Line1b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp1',FaultFlag]).Imag.Data);
    
    set(handles.Line2a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp2',FaultFlag]).Real.Data);
    set(handles.Line2b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp2',FaultFlag]).Imag.Data);
    
    set(handles.Line3a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp3',FaultFlag]).Real.Data);
    set(handles.Line3b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp3',FaultFlag]).Imag.Data);
    
    set(handles.Line4a, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp4',FaultFlag]).Real.Data);
    set(handles.Line4b, 'XData', t/1e6, 'YData', LLRFData{ii}.(['Inp4',FaultFlag]).Imag.Data);
end


% Power test
A3Fwd = LLRFData{1}.Inp2.ScaleFactor * (LLRFData{1}.Inp2.Real.Data + 1i*LLRFData{1}.Inp2.Imag.Data) / LLRFData{1}.(YScale);
A3Fwd = abs(A3Fwd).^2;
set(handles.A3FwdPowerAvg, 'String', sprintf('%.2f',mean(A3Fwd)));

A4Fwd = LLRFData{4}.Inp1.ScaleFactor * (LLRFData{4}.Inp1.Real.Data + 1i*LLRFData{4}.Inp1.Imag.Data) / LLRFData{4}.(YScale);
A4Fwd = abs(A4Fwd).^2;
set(handles.A4FwdPowerAvg, 'String', sprintf('%.2f',mean(A4Fwd)));

A3Rev = LLRFData{1}.Inp3.ScaleFactor * (LLRFData{1}.Inp3.Real.Data + 1i*LLRFData{1}.Inp3.Imag.Data) / LLRFData{1}.(YScale);
A3Rev = abs(A3Rev).^2;
set(handles.A3RevPowerAvg, 'String', sprintf('%.2f',mean(A3Rev)));

A4Rev = LLRFData{4}.Inp2.ScaleFactor * (LLRFData{4}.Inp2.Real.Data + 1i*LLRFData{4}.Inp2.Imag.Data) / LLRFData{4}.(YScale);
A4Rev = abs(A4Rev).^2;
set(handles.A4RevPowerAvg, 'String', sprintf('%.2f',mean(A4Rev)));


% Time stamp
set(handles.TimeStamp, 'String', datestr(labca2datenum(LLRFData{ii}.(['Inp4',FaultFlag]).Real.Time),'mmmm dd, yyyy  HH:MM:SS.FFF'));


if strcmpi(get(handles.AutoScaleX, 'Checked'), 'On') && ~isnan(t(end)) && t(end)~=0
    set(handles.axes1, 'XLim', [0 t(end)/1e6]);
end

drawnow;



% function [RFPLC, ErrorMessage] = get_RFPLC(handles)
% 
% RFPLC = getappdata(handles.figure1, 'RFPLC');
% ErrorMessage = {};
% ErrorCount = 0;
% 
% if isempty(RFPLC)
%     % Initialize
%     InitFlag = 1;
%     RFPLC = getfamilydata('RF');
%     RFPLC = rmfield(RFPLC,{'FamilyName','MemberOf','DeviceList','ElementList','Status','Setpoint','Monitor','Position'});
% else
%     RFPLC_Old = RFPLC;
%     InitFlag = 0;
% end
% 
% 
% % Get data
% %[sp,am,tmp1,tmp2]=getmachineconfig('RF','NoArchive');
% Fields = fieldnames(RFPLC);
% for jj = 1:length(Fields)
%     try
%         [RFPLC.(Fields{jj}).Data, tmp, RFPLC.(Fields{jj}).TimeStamp] = getpv('RF', Fields{jj}, 'double');
%         
%         %fprintf('RF.%s\n', Fields{jj});
%         %datestr(RFPLC.(Fields{jj}).TimeStamp)
%     catch
%         % Turn off status on error
%         setfamilydata(0, 'RF', Fields{jj}, 'Status');
%         RFPLC.(Fields{jj}).Data = NaN * RFPLC.(Fields{jj}).Status;
%         fprintf('Changing the status on %s due to error message:\n%s\n', Fields{jj}, lasterr);
%     end
% end
% 
% 
% Fields_Counters = {
%     'PowerIntlk'
%     'VacuumIntlk'
%     'ArcDetect'
%     'PermitIntlk'
%     'Circ1Intlk'
%     'Circ2Intlk'
%     'WaterFlowIntlk'
%     'TemperatureIntlk'
%     'ArcDetectPowerSupply'
%     };
% 
% if ~InitFlag
%     % Check and count interlock states
%     % Counter: Zero is a fault, New-Last==-1 -> new fault
%     Fields = Fields_Counters;
%     for jj = 1:length(Fields)
%         for ii = 1:size(RFPLC.(Fields{jj}).Data,1)
%             if RFPLC.(Fields{jj}).Data(ii) == 0
%                 % Timestamp if it a new error
%                 RFPLC.(Fields{jj}).FaultTime{ii} = [RFPLC.(Fields{jj}).FaultTime{ii} RFPLC.(Fields{jj}).TimeStamp(ii)];
%                 RFPLC.(Fields{jj}).FaultTime{ii} = unique(RFPLC.(Fields{jj}).FaultTime{ii});
%                 RFPLC.(Fields{jj}).Counter(ii) = length(RFPLC.(Fields{jj}).FaultTime{ii});
%                 %Test = RFPLC.(Fields{jj}).Data(ii) - RFPLC_Old.(Fields{jj}).Data(ii);
%                 %if Test == -1
%                 %    RFPLC.(Fields{jj}).Counter(ii) = RFPLC.(Fields{jj}).Count(ii) + 1;
%                 %end
%                 
%                 % Error message cell array
%                 ErrorCount = ErrorCount + 1;
%                 ErrorMessage{ErrorCount,1} = sprintf('Fault: %s', RFPLC.(Fields{jj}).ChannelNames{ii}(8:end));
%             end
%         end
%     end
%     
%     
%     % State field
%     Fields = {
%         'Power'
%         'Vacuum'
%         'Permit'
%         'SSPA'
%         'Tetrode'
%         };
%     for jj = 1:length(Fields)
%         for ii = 1:size(RFPLC.(Fields{jj}).Data,1)
%             if RFPLC.(Fields{jj}).Data(ii) == 0
%                 % Error message cell array
%                 ErrorCount = ErrorCount + 1;
%                 ErrorMessage{ErrorCount,1} = sprintf('Fault: %s', RFPLC.(Fields{jj}).ChannelNames{ii}(8:end));
%             end
%         end
%     end
% else
%     % Setup counters
%     Fields = Fields_Counters;
%     for jj = 1:length(Fields)
%         N = size(RFPLC.(Fields{jj}).Data,1);
%         RFPLC.(Fields{jj}).Counter = zeros(N,1);
%         RFPLC.(Fields{jj}).FaultTime = cell(N,1);
%     end
% end
% 
% setappdata(handles.figure1, 'RFPLC', RFPLC);



% --------------------------------------------------------------------
function ShowFaults_Callback(hObject, eventdata, handles)

RFPLC = getappdata(handles.figure1, 'RFPLC');

Fields_Counters = {
    'PowerIntlk'
    'VacuumIntlk'
    'ArcDetect'
    'PermitIntlk'
    'Circ1Intlk'
    'Circ2Intlk'
    'WaterFlowIntlk'
    'TemperatureIntlk'
    'ArcDetectPowerSupply'
    };

FaultCounter = 0;
Fields = Fields_Counters;
for jj = 1:length(Fields)
    for ii = 1:size(RFPLC.(Fields{jj}).Data,1)
        if RFPLC.(Fields{jj}).Data(ii) == 0
            if ~isempty(RFPLC.(Fields{jj}).FaultTime{ii})
                ChanName = family2channel('RF',Fields{jj},[1 ii]);
                fprintf('%30s: ', ChanName{1}(8:end));
                for k = 1:length(RFPLC.(Fields{jj}).FaultTime{ii})
                    fprintf(' %s', datestr(RFPLC.(Fields{jj}).FaultTime{ii}(k)));
                    FaultCounter = FaultCounter + 1;
                end
                fprintf('\n');
            end
        end
    end
end

if FaultCounter
    fprintf('\n');
end



% --- Executes on selection change in RFFaults.
function RFFaults_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns RFFaults contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RFFaults


% --- Executes during object creation, after setting all properties.
function RFFaults_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PulseLength_Callback(hObject, eventdata, handles)
PulseLength = str2num(get(handles.PulseLength, 'String'));

TimeScaleCalFactor=1.0177;%1.02143; %Time Calibration Factor required after March 2014 LLRF upgrade. There 4 of such lines.
    
if ~isempty(PulseLength)
    PulseLengthSet = round(TimeScaleCalFactor*1e6*PulseLength/10);
    setpv('llrf1:pulse_length_ao', PulseLengthSet);
end
drawnow;


function RepPeriod_Callback(hObject, eventdata, handles)
RepPeriod = str2num(get(handles.RepPeriod, 'String'));

TimeScaleCalFactor=1.0177;%1.02143; %Time Calibration Factor required after March 2014 LLRF upgrade. There 4 of such lines.
    
if ~isempty(RepPeriod)
    RepPeriodSet = round(TimeScaleCalFactor*1e6*RepPeriod/10);
    setpv('llrf1:rep_period_ao', RepPeriodSet);
end
drawnow;


% --- Executes on slider movement.
function WaveShift_Callback(hObject, eventdata, handles)
WaveShift = get(handles.WaveShift, 'Value');
if ~isempty(WaveShift)
    %WaveShift = round(WaveShift);
    if WaveShift > 7
        WaveShift = 7;
    elseif WaveShift < 1
        WaveShift = 1;
    end
    setpvonline('llrf1:wave_shift_ao', WaveShift);
    pause(.1);
end
%set(handles.WaveShift, 'Value', );
drawnow;


function GraphMax_Callback(hObject, eventdata, handles)
% llrf1:wave_samp_per_ao vs graph max [msec]
%         255 73.042200
%         201 57.5744
%          99 28.357560
%          10  2.864400

% Which LLRF board
LLRFData = getappdata(handles.figure1, 'LLRFData');
ii = LLRFNumber(handles);
LLRF_Prefix = LLRFData{ii}.Prefix;


%GraphMax = str2num(get(handles.GraphMax, 'String'));  % If editbox
GraphMax = get(handles.GraphMax, 'Value');
if ~isempty(GraphMax)
    GraphMax = round(GraphMax);
    if GraphMax > 51
        GraphMax = 51;
    elseif GraphMax < 1
        GraphMax = 1;
    end
    
    if get(handles.TimeScaleAll,'Value')
        % Set all the LLRF board to the same scaling
        for ii = 1:length(LLRFData)
            LLRF_Prefix = LLRFData{ii}.Prefix;
            setpvonline([LLRF_Prefix, 'wave_samp_per_ao'], GraphMax);
        end
    else
        %setpvonline('llrf1:wave_samp_per_ao', GraphMax);
        setpvonline([LLRF_Prefix, 'wave_samp_per_ao'], GraphMax);
        pause(.1);
    end
    
    % If editbox
    %GraphMaxSet = round(255*GraphMax/73.042200);
    %if GraphMaxSet > 255
    %    GraphMaxSet = 255;
    %elseif GraphMaxSet < 1
    %    GraphMaxSet = 1;
    %end
    %setpvonline('llrf1:wave_samp_per_ao', GraphMaxSet);
end

drawnow;


% --- Executes on button press in TimeScaleAll.
function TimeScaleAll_Callback(hObject, eventdata, handles)


% --- Executes on button press in RFReset.
function RFReset_Callback(hObject, eventdata, handles)
% .25 sec needed for total reset (done in EPICS?)
setpvonline('Gun:RF:InterlockReset',1);


% --- Executes on button press in LLRFReset.
function LLRFReset_Callback(hObject, eventdata, handles)
% Reset all the boards?
LLRFData = getappdata(handles.figure1, 'LLRFData');
for ii = 1:length(LLRFData)
    setpvonline([LLRFData{ii}.Prefix, 'rf_go_bo'],1);
end



% --- Executes on button press in LLRFResetIntlk.
function LLRFResetIntlk_Callback(hObject, eventdata, handles)
% Reset all the boards
LLRFData = getappdata(handles.figure1, 'LLRFData');

% First make sure it is out
for ii = 1:length(LLRFData)
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_1_bo'], 0);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_2_bo'], 0);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_3_bo'], 0);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_4_bo'], 0);
end
pause(.5);

% Do the reset
for ii = 1:length(LLRFData)
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_1_bo'], 1);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_2_bo'], 1);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_3_bo'], 1);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_4_bo'], 1);
end
pause(.5);

% Leave it out
for ii = 1:length(LLRFData)
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_1_bo'], 0);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_2_bo'], 0);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_3_bo'], 0);
    setpvonline([LLRFData{ii}.Prefix, 'reset_inlk_4_bo'], 0);
end

% Leave it out
for ii = 1:length(LLRFData)
    InterlockSum = getpvonline([LLRFData{ii}.Prefix, 'interlock']);
    if InterlockSum == 15
        fprintf('   Interlock sum %d -> Good!\n', InterlockSum);
    else
        fprintf('   Interlock sum %d -> Bad!\n', InterlockSum);
    end
end


function PowerReal_Callback(hObject, eventdata, handles)
PowerReal = str2num(get(handles.PowerReal, 'String'));
if ~isempty(PowerReal)
    PowerReal = round(PowerReal);
    if PowerReal > 32767
        PowerReal = 32767;
    elseif PowerReal < -32767
        PowerReal = -32767;
    end
    %setpv('llrf1:source_re_ao', PowerReal);
    set(handles.PowerReal, 'UserData', PowerReal);
end
drawnow;


function PowerImag_Callback(hObject, eventdata, handles)
PowerImag = str2num(get(handles.PowerImag, 'String'));
if ~isempty(PowerImag)
    PowerImag = round(PowerImag);
    if PowerImag > 32767
        PowerImag = 32767;
    elseif PowerImag < -32767
        PowerImag = -32767;
    end
    %setpv('llrf1:source_im_ao', PowerImag);
    set(handles.PowerImag, 'UserData', PowerImag);
end
drawnow;


function PowerMagPhase_Callback(hObject, eventdata, handles)
%
% PowerPhase comes in a degrees

PowerMag   =    str2num(get(handles.PowerMag,   'String'));
PowerPhase = pi*str2num(get(handles.PowerPhase, 'String'))/180;
if ~isempty(PowerMag) && ~isempty(PowerPhase)
    if PowerMag > 32767
        PowerMag = 32767;
    end
    
    Z = PowerMag.*exp(1i*PowerPhase);
    PowerReal = real(Z);
    PowerImag = imag(Z);
    
    PowerReal = round(PowerReal);
    PowerImag = round(PowerImag);
    
    % Power limits
    % PowerReal 0-32767 Positive
    % PowerReal 32768-65535 Negative (hence just phase to change
    
    if PowerReal > 32767
        PowerReal = 32767;
    elseif PowerReal < -32767
        PowerReal = -32767;
    end
    if PowerImag > 32767
        PowerImag = 32767;
    elseif PowerImag < -32767
        PowerImag = -32767;
    end
    
    %setpv('llrf1:source_re_ao', PowerReal);
    %setpv('llrf1:source_im_ao', PowerImag);
    set(handles.PowerReal, 'UserData', PowerReal);
    set(handles.PowerImag, 'UserData', PowerImag);
end
drawnow;



% --- Executes on button press in LLRF1.
function LLRF1_Callback(hObject, eventdata, handles)
set(handles.LLRF1, 'Value', 1);
set(handles.LLRF2, 'Value', 0);
set(handles.LLRF3, 'Value', 0);
set(handles.LLRF4, 'Value', 0);
set(handles.LLRF5, 'Value', 0);

set(handles.LLRF1, 'BackgroundColor', [.757 .867 .776]);
set(handles.LLRF2, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF3, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF4, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF5, 'BackgroundColor', [.702 .702 .702]-.1);

label_local(hObject, eventdata, handles);

% Autoscale once when board in changed
if strcmpi(get(handles.AutoScaleY1, 'Checked'), 'Off')
    set(handles.AutoScaleY1, 'Checked', 'Off');
    AutoScaleY1_Callback(hObject, eventdata, handles);
    PlotLLRFWaveforms;
    set(handles.AutoScaleY1, 'Checked', 'On');
    AutoScaleY1_Callback(hObject, eventdata, handles);
else
    PlotLLRFWaveforms;
end
%LLRF_Timer_Callback(hObject, 'OneShot', handles);

% --- Executes on button press in LLRF2.
function LLRF2_Callback(hObject, eventdata, handles)
set(handles.LLRF1, 'Value', 0);
set(handles.LLRF2, 'Value', 1);
set(handles.LLRF3, 'Value', 0);
set(handles.LLRF4, 'Value', 0);
set(handles.LLRF5, 'Value', 0);

set(handles.LLRF1, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF2, 'BackgroundColor', [.757 .867 .776]);
set(handles.LLRF3, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF4, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF5, 'BackgroundColor', [.702 .702 .702]-.1);

label_local(hObject, eventdata, handles);

% Autoscale once when board in changed
if strcmpi(get(handles.AutoScaleY1, 'Checked'), 'Off')
    set(handles.AutoScaleY1, 'Checked', 'Off');
    AutoScaleY1_Callback(hObject, eventdata, handles);
    PlotLLRFWaveforms;
    set(handles.AutoScaleY1, 'Checked', 'On');
    AutoScaleY1_Callback(hObject, eventdata, handles);
else
    PlotLLRFWaveforms;
end
%LLRF_Timer_Callback(hObject, 'OneShot', handles);

% --- Executes on button press in LLRF3.
function LLRF3_Callback(hObject, eventdata, handles)
set(handles.LLRF1, 'Value', 0);
set(handles.LLRF2, 'Value', 0);
set(handles.LLRF3, 'Value', 1);
set(handles.LLRF4, 'Value', 0);
set(handles.LLRF5, 'Value', 0);

set(handles.LLRF1, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF2, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF3, 'BackgroundColor', [.757 .867 .776]);
set(handles.LLRF4, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF5, 'BackgroundColor', [.702 .702 .702]-.1);

label_local(hObject, eventdata, handles);

% Autoscale once when board in changed
if strcmpi(get(handles.AutoScaleY1, 'Checked'), 'Off')
    set(handles.AutoScaleY1, 'Checked', 'Off');
    AutoScaleY1_Callback(hObject, eventdata, handles);
    PlotLLRFWaveforms;
    set(handles.AutoScaleY1, 'Checked', 'On');
    AutoScaleY1_Callback(hObject, eventdata, handles);
else
    PlotLLRFWaveforms;
end
%LLRF_Timer_Callback(hObject, 'OneShot', handles);

% --- Executes on button press in LLRF4.
function LLRF4_Callback(hObject, eventdata, handles)
set(handles.LLRF1, 'Value', 0);
set(handles.LLRF2, 'Value', 0);
set(handles.LLRF3, 'Value', 0);
set(handles.LLRF4, 'Value', 1);
set(handles.LLRF5, 'Value', 0);

set(handles.LLRF1, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF2, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF3, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF4, 'BackgroundColor', [.757 .867 .776]);
set(handles.LLRF5, 'BackgroundColor', [.702 .702 .702]-.1);

label_local(hObject, eventdata, handles);

% Autoscale once when board in changed
if strcmpi(get(handles.AutoScaleY1, 'Checked'), 'Off')
    set(handles.AutoScaleY1, 'Checked', 'Off');
    AutoScaleY1_Callback(hObject, eventdata, handles);
    PlotLLRFWaveforms;
    set(handles.AutoScaleY1, 'Checked', 'On');
    AutoScaleY1_Callback(hObject, eventdata, handles);
else
    PlotLLRFWaveforms;
end
%LLRF_Timer_Callback(hObject, 'OneShot', handles);

% --- Executes on button press in LLRF5.
function LLRF5_Callback(hObject, eventdata, handles)
set(handles.LLRF1, 'Value', 0);
set(handles.LLRF2, 'Value', 0);
set(handles.LLRF3, 'Value', 0);
set(handles.LLRF4, 'Value', 0);
set(handles.LLRF5, 'Value', 1);

set(handles.LLRF1, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF2, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF3, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF4, 'BackgroundColor', [.702 .702 .702]-.1);
set(handles.LLRF5, 'BackgroundColor', [.757 .867 .776]);

label_local(hObject, eventdata, handles);

% Autoscale once when board in changed
if strcmpi(get(handles.AutoScaleY1, 'Checked'), 'Off')
    set(handles.AutoScaleY1, 'Checked', 'Off');
    AutoScaleY1_Callback(hObject, eventdata, handles);
    PlotLLRFWaveforms;
    set(handles.AutoScaleY1, 'Checked', 'On');
    AutoScaleY1_Callback(hObject, eventdata, handles);
else
    PlotLLRFWaveforms;
end
%LLRF_Timer_Callback(hObject, 'OneShot', handles);



% --- Executes on button press in ActiveWaveform.
function ActiveWaveform_Callback(hObject, eventdata, handles)
set(handles.ActiveWaveform, 'Value', 1);
set(handles.LastFault,      'Value', 0);
set(handles.ActiveWaveform, 'BackgroundColor', [.757 .867 .776]);
set(handles.LastFault,      'BackgroundColor', [.702 .702 .702]-.1);
PlotLLRFWaveforms;

% --- Executes on button press in LastFault.
function LastFault_Callback(hObject, eventdata, handles)
set(handles.ActiveWaveform, 'Value', 0);
set(handles.LastFault,      'Value', 1);
set(handles.LastFault,      'BackgroundColor', [.757 .867 .776]);
set(handles.ActiveWaveform, 'BackgroundColor', [.702 .702 .702]-.1);
PlotLLRFWaveforms;


% --------------------------------------------------------------------
function MagPhase_Callback(hObject, eventdata, handles)
set(handles.MagPhase, 'Checked', 'On');
set(handles.RealImag, 'Checked', 'Off');
set(handles.ADCCounts, 'Checked', 'Off');
set(handles.NormalizedUnits, 'Checked', 'Off');
label_local(hObject, eventdata, handles);
PlotLLRFWaveforms;
AutoScaleY(handles);

% --------------------------------------------------------------------
function RealImag_Callback(hObject, eventdata, handles)
set(handles.MagPhase, 'Checked', 'Off');
set(handles.RealImag, 'Checked', 'On');
set(handles.ADCCounts, 'Checked', 'Off');
set(handles.NormalizedUnits, 'Checked', 'Off');
label_local(hObject, eventdata, handles);
PlotLLRFWaveforms;
AutoScaleY(handles);

% --------------------------------------------------------------------
function ADCCounts_Callback(hObject, eventdata, handles)
set(handles.MagPhase, 'Checked', 'Off');
set(handles.RealImag, 'Checked', 'Off');
set(handles.ADCCounts, 'Checked', 'On');
set(handles.NormalizedUnits, 'Checked', 'Off');
label_local(hObject, eventdata, handles);
PlotLLRFWaveforms;
AutoScaleY(handles);

% --------------------------------------------------------------------
function NormalizedUnits_Callback(hObject, eventdata, handles)
set(handles.MagPhase, 'Checked', 'Off');
set(handles.RealImag, 'Checked', 'Off');
set(handles.ADCCounts, 'Checked', 'Off');
set(handles.NormalizedUnits, 'Checked', 'On');
label_local(hObject, eventdata, handles);
PlotLLRFWaveforms;
AutoScaleY(handles);


function label_local(hObject, eventdata, handles)

LLRFData = getappdata(handles.figure1, 'LLRFData');

% Which LLRF board
ii = LLRFNumber(handles);

if strcmpi(get(handles.MagPhase, 'Checked'), 'On')
    UnitsString = ' [Watt]';
elseif strcmpi(get(handles.RealImag, 'Checked'), 'On')
    UnitsString = ' [\surdWatt]';
elseif strcmpi(get(handles.NormalizedUnits, 'Checked'), 'On')
    UnitsString = '';
elseif strcmpi(get(handles.ADCCounts, 'Checked'), 'On')
    UnitsString = ' [Counts]';
end

if ii == 1
    % Special case: Laser frequency doesn't have units
    ylabel(handles.axes1, LLRFData{ii}.Inp1.Label);
else
    ylabel(handles.axes1, [LLRFData{ii}.Inp1.Label, UnitsString]);
end
ylabel(handles.axes3, [LLRFData{ii}.Inp2.Label, UnitsString]);
ylabel(handles.axes5, [LLRFData{ii}.Inp3.Label, UnitsString]);
ylabel(handles.axes7, [LLRFData{ii}.Inp4.Label, UnitsString]);


function AutoScaleY(handles)
% Autoscale Y
if strcmpi(get(handles.AutoScaleY1, 'Checked'), 'Off')
    set(handles.axes1, 'YLimMode', 'manual');
    set(handles.axes2, 'YLimMode', 'manual');
    set(handles.axes3, 'YLimMode', 'manual');
    set(handles.axes4, 'YLimMode', 'manual');
    set(handles.axes5, 'YLimMode', 'manual');
    set(handles.axes6, 'YLimMode', 'manual');
    set(handles.axes7, 'YLimMode', 'manual');
    set(handles.axes8, 'YLimMode', 'manual');
    
    % Force ymin to zero for autoscale off
    if strcmpi(get(handles.MagPhase, 'Checked'), 'On')
        YLim = get(handles.axes1,'YLim');
        set(handles.axes1,'YLim', [0 YLim(2)*1.25]);
        YLim = get(handles.axes3,'YLim');
        set(handles.axes3,'YLim', [0 YLim(2)*1.25]);
        YLim = get(handles.axes5,'YLim');
        set(handles.axes5,'YLim', [0 YLim(2)*1.25]);
        YLim = get(handles.axes7,'YLim');
        set(handles.axes7,'YLim', [0 YLim(2)*1.25]);
    end
    
else
    % Force off zoom
    set(handles.ZoomXY, 'Checked', 'Off');
    set(handles.ZoomY,  'Checked', 'Off');
    zoom(handles.figure1, 'off');
    
    set(handles.axes1, 'YLimMode', 'auto');
    set(handles.axes3, 'YLimMode', 'auto');
    set(handles.axes5, 'YLimMode', 'auto');
    set(handles.axes7, 'YLimMode', 'auto');
    
    if strcmpi(get(handles.MagPhase, 'Checked'), 'On')
        % +/-180 if phase
        set(handles.axes2, 'YLimMode', 'manual');
        set(handles.axes4, 'YLimMode', 'manual');
        set(handles.axes6, 'YLimMode', 'manual');
        set(handles.axes8, 'YLimMode', 'manual');
        set(handles.axes2, 'YLim', [-180 180]);
        set(handles.axes4, 'YLim', [-180 180]);
        set(handles.axes6, 'YLim', [-180 180]);
        set(handles.axes8, 'YLim', [-180 180]);
        
        set(handles.axes2, 'YTick', [-180 -90 0 90 180]);
        set(handles.axes4, 'YTick', [-180 -90 0 90 180]);
        set(handles.axes6, 'YTick', [-180 -90 0 90 180]);
        set(handles.axes8, 'YTick', [-180 -90 0 90 180]);
    else
        set(handles.axes2, 'YLimMode', 'auto');
        set(handles.axes4, 'YLimMode', 'auto');
        set(handles.axes6, 'YLimMode', 'auto');
        set(handles.axes8, 'YLimMode', 'auto');
        
        set(handles.axes2, 'YTickMode', 'auto');
        set(handles.axes4, 'YTickMode', 'auto');
        set(handles.axes6, 'YTickMode', 'auto');
        set(handles.axes8, 'YTickMode', 'auto');
    end
end

%Del = max(y2mag);
%set(handles.axes1, 'YLim', [-.05*Del Del*1.1]);


% --- Executes on button press in AutoScaleY1.
function AutoScaleY1_Callback(hObject, eventdata, handles)

if strcmpi(get(handles.AutoScaleY1, 'Checked'), 'On')
    set(handles.AutoScaleY1, 'Checked', 'Off')
    set(handles.AutoScaleY2, 'Value', 0);
    set(handles.AutoScaleY2, 'BackgroundColor', [.702 .702 .702]-.1);
    set(handles.AutoScaleY2, 'String', 'Vertical Auto Scale Off');
else
    set(handles.AutoScaleY1, 'Checked', 'On')
    set(handles.AutoScaleY2, 'Value', 1);
    set(handles.AutoScaleY2, 'BackgroundColor', [.757 .867 .776]);
    set(handles.AutoScaleY2, 'String', 'Vertical Auto Scale On');
end
AutoScaleY(handles);


% --- Executes on button press in AutoScaleY2.
function AutoScaleY2_Callback(hObject, eventdata, handles)

if get(handles.AutoScaleY2, 'Value')
    set(handles.AutoScaleY1, 'Checked', 'On')
    set(handles.AutoScaleY2, 'BackgroundColor', [.757 .867 .776]);
    set(handles.AutoScaleY2, 'String', 'Vertical Auto Scale On');
else
    set(handles.AutoScaleY1, 'Checked', 'Off')
    set(handles.AutoScaleY2, 'BackgroundColor', [.702 .702 .702]-.1);
    set(handles.AutoScaleY2, 'String', 'Vertical Auto Scale Off');
end

AutoScaleY(handles);


% --- Executes on button press in AutoScaleX.
function AutoScaleX_Callback(hObject, eventdata, handles)
% Autoscale X
ii = 1;
if strcmpi(get(handles.AutoScaleX, 'Checked'), 'On')
    set(handles.AutoScaleX, 'Checked', 'Off')
else
    set(handles.AutoScaleX, 'Checked', 'On')
    %t = get(handles.Line1a, 'XData');
    %set(handles.axes1, 'XLim', [0 t(end)]);
    if strcmpi(get(handles.ZoomXY, 'Checked'), 'On')
        set(handles.ZoomXY,   'Checked', 'Off');
        zoom(handles.figure1, 'off');
    end
    LLRFData = getappdata(handles.figure1, 'LLRFData');
    set(handles.axes1, 'XLim', [0 LLRFData{ii}.t(end)/1e6]);
end


% --------------------------------------------------------------------
function ZoomXY_Callback(hObject, eventdata, handles)
if strcmpi(get(handles.ZoomXY, 'Checked'), 'On')
    set(handles.ZoomXY, 'Checked', 'Off');
    zoom(handles.figure1, 'off');
else
    set(handles.ZoomXY,      'Checked', 'On');
    set(handles.ZoomY,       'Checked', 'Off');
    set(handles.AutoScaleX,  'Checked', 'Off');
    set(handles.AutoScaleY1, 'Checked', 'Off');
    set(handles.AutoScaleY2, 'Value', 0);
    set(handles.AutoScaleY2, 'BackgroundColor', [.702 .702 .702]-.1);
    set(handles.AutoScaleY2, 'String', 'Vertical Auto Scale Off');
    zoom(handles.figure1, 'on');
end


% --------------------------------------------------------------------
function ZoomY_Callback(hObject, eventdata, handles)
if strcmpi(get(handles.ZoomY, 'Checked'), 'On')
    set(handles.ZoomY, 'Checked', 'Off');
    zoom(handles.figure1, 'off');
else
    set(handles.ZoomY,       'Checked', 'On');
    set(handles.ZoomXY,      'Checked', 'Off');
    set(handles.AutoScaleY1, 'Checked', 'Off');
    set(handles.AutoScaleY2, 'Value', 0);
    set(handles.AutoScaleY2, 'BackgroundColor', [.702 .702 .702]-.1);
    set(handles.AutoScaleY2, 'String', 'Vertical Auto Scale Off');
    zoom(handles.figure1, 'yon');
end



% --- Executes on selection change in StartStop.
function StartStop_Callback(hObject, eventdata, handles)

if get(handles.StartStop, 'Value') == 1
    set(handles.StartStop, 'BackgroundColor', [.757 .867 .776]);
    set(handles.StartStop, 'String', 'Continuous Acquire');
else
    set(handles.StartStop, 'BackgroundColor', [.702 .702 .702]-.1);
    set(handles.StartStop, 'String', 'Updates Paused');
end
drawnow;



% --------------------------------------------------------------------
function PrinteLog_Callback(hObject, eventdata, handles)

%'Logbook','testbench',
printelog(handles.figure1, 'Subject','LLRF', 'Text','LLRF printout', 'NoScaling', 'NoFig');



% --------------------------------------------------------------------
function SaveLLRF_Callback(hObject, eventdata, handles)
DisplayFlag = 1;

% LLRF Data
LLRFData = getappdata(handles.figure1, 'LLRFData');
RFPLC    = getappdata(handles.figure1, 'RFPLC');

% Get filename
DirectoryName = [getfamilydata('Directory','DataRoot'), 'LLRF', filesep];
FileName = appendtimestamp('LLRF');

[FileName, DirectoryName] = uiputfile('*.mat', 'Save LLRF data to ...', [DirectoryName FileName]);
if FileName == 0
    disp('   LLRF data not saved.');
    return
end

% Save
DirStart = pwd;
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
save(FileName, 'LLRFData','RFPLC');
cd(DirStart);

% Display
if DisplayFlag
    FileName = [DirectoryName FileName];
    fprintf('   LLRF data saved to %s.mat\n', FileName);
    if ErrorFlag
        fprintf('   Warning:  The lattice file was saved, but it did not go the desired directory');
        fprintf('   Check %s for your data\n', DirectoryName);
    end
end

% --------------------------------------------------------------------
function LoadLLRF_Callback(hObject, eventdata, handles)


% Stop updating
set(handles.StartStop, 'Value', 0);
drawnow;
StartStop_Callback(hObject, eventdata, handles);

% Get file
DirectoryName = [getfamilydata('Directory','DataRoot'), 'LLRF', filesep];
[FileName, DirectoryName] = uigetfile('*.mat', 'Select a LLRF file to load', DirectoryName);
if FileName == 0
    return
end
load([DirectoryName FileName]);
FileName = [DirectoryName FileName];

% Save LLRF Data to global and plot
if exist('LLRFData','var')
    setappdata(handles.figure1, 'LLRFData', LLRFData);
    PlotLLRFWaveforms;
else
    fprintf('   LLRF data structure not found in %s\n', FileName);
end



function ii = LLRFNumber(handles)
% LLRF Data
LLRFData = getappdata(handles.figure1, 'LLRFData');

if get(handles.LLRF1, 'Value')
    ii = 1;
elseif get(handles.LLRF2, 'Value')
    ii = 2;
elseif get(handles.LLRF3, 'Value')
    ii = 3;
elseif get(handles.LLRF4, 'Value')
    ii = 4;
elseif get(handles.LLRF5, 'Value')
    ii = 5;
end



function LLRFData = LLRFCalibration(LLRFData)

% To get numbers between -1 and 1:
% Waveform = Waveform / yscale
%
% Note: mWatt = 10^(dBm/10)
%
% The results get multiplied by a scale factor.  Options are:
%
% 1. For board-level work, relevant to ADC behavior panel_scale
%    sqrt(Watts) at the chassis rear panel
%    panel_scale*pickup_scale
%
% 1 mWatt = 1mWatt
% a. sqrt(Watts) at the point of interest (e.g., waveguide)
%    panel_scale = 10.^(panel_scale_dBm/20-3);
%    where Ken and Larry calibrated the chassis, including ADCs, to get
%    panel_scale_dBm = [ 0; +18.6; +18.9; +31.1 ]     (we didn't calibrate the first ADC).
%
% b. pickup_scale is something Ken will give you.  Presumably he will
%    provide a set of three attenuations (positive) expressed in dB, and
%
%    pickup_scale = 10.^(pickup_scale_dB/20);
%
% X and Y are in units of sqrt(Watts)
% To convert to magnitude/phase then square the magnitude to get Watts.
% (or dimensionless 0 to 1, if they have chosen a scale factor of 1.0).


% LLRF1 Board Calibration (Oct 2011)
% Assuming 1.1 dBm input, wave_samp_per=4 wave_shift=4 digital full scale 25088
% ADC2 mean 3344.9 implies +18.6 dBm full scale
% ADC3 mean 3231.0 implies +18.9 dBm full scale
% ADC4 mean  793.5 implies +31.1 dBm full scale
%
% PanelScale_dBm = [ 0 18.6 18.9 31.1 ]'/20 - 3;
% PanelScale = 10.^PanelScale_dBm;
% PickupScale = [1 1 1 1]';
% ScaleFactor = PanelScale .* PickupScale;   % sqrt(Watts)

%                 D       E       F                               J                                       O
% c = [
%     18	77.8	-50.0	-3.727	-3.312	47.09	11.10	20.76	16.58	4.73	NaN	    -4.919	-57.229	-0.190	0.000	4.919	0.00	-57.039
%     17	77.8	-50.0	-3.800	0.000	NaN	     NaN	24.00	20.30	8.63	NaN	    -8.935	-54.110	-0.310	0.000	8.935	0.00	-53.8
%     16	80.8	-47.8	-3.700	0.000	NaN	     NaN	29.30	26.00	12.65	NaN	    -12.963	-51.810	-0.310	0.000	12.963	0.00	-51.5
%     NaN	NaN       NaN	NaN	     NaN	NaN	     NaN	 NaN	-16.10	-14.85	NaN      30.000	 NaN	-0.950	-6.300	-20.200	9.80	NaN
%     21	77.8	-50.0	-3.706	0.000	131.75	 NaN	24.09	24.13	-2.18	NaN	    -22.477	-78.366	-0.530	-18.800	-20.453	-42.93	-96.636
%     20	77.8	-50.0	-3.800	0.000	NaN	     NaN	24.00	24.05	-1.97	0.00	-22.490	-78.260	-0.410	-18.900	-20.460	-42.95	-96.750
%     19	80.8	-50.1	-3.700	0.000	NaN	     NaN	26.97	26.92	-3.19	NaN	    -25.414	-75.15	-1.680	-19.100	-27.889	-46.02	-99.85
%     NaN	77.8	-50.0	-3.727	-3.308	47.09	11.20	20.77	19.33	-1.70	NaN	    -18.131	-84.148	-0.500	-19.200	-13.116	-38.53	-95.565
%     7	77.8	-63.9	-0.561	0.000	-66.28	 NaN	13.34	13.37	-2.17	NaN	    -12.055	-78.681	-0.850	-19.100	-20.415	-32.47	-96.931
%     8	77.8	-64.0	-0.600	0.000	NaN	     NaN	13.20	13.17	-1.45	-6.60	-12.039	-78.090	-0.320	-19.300	-20.431	-32.47	-97.070
%     9	77.8	-63.6	-0.611	0.000	134.84	 NaN	13.59	13.55	-1.90	NaN	    -12.110	-78.221	-0.460	-19.000	-20.440	-32.55	-96.761
%     10	77.8	-63.8	-0.600	0.000	NaN	     NaN	13.40	13.36	-2.22	NaN	    -12.010	-78.630	-0.870	-19.300	-20.650	-32.66	-97.060
%     1	77.8	-50.0	-1.400	0.000	NaN	     NaN	26.40	26.43	-2.06	NaN	    -25.252	-78.710	-0.880	-19.300	-20.478	-45.73	-97.130
%     2	77.8	-50.1	-1.400	0.000	NaN	     NaN	26.30	26.26	-2.62	NaN	    -23.780	-77.900	-0.140	-18.000	-20.480	-44.26	-95.760
%     5	77.8	-50.0	-1.400	0.000	NaN	     NaN	26.40	26.36	-2.88	NaN	    -23.580	-77.860	-0.100	-17.700	-20.480	-44.06	-95.460
%     4	77.8	-50.0	-1.300	0.000	NaN	     NaN	26.50	26.43	-2.29	NaN	    -24.456	-78.050	-0.320	-18.500	-20.474	-44.93	-96.230
%     15	64.8	-53.8	-0.462	0.000	-72.44	 NaN	10.51	10.46	-1.97	NaN	     -8.856	-65.092	-0.370	-18.900	-20.504	-29.36	-83.622
%     14	64.8	-50.0	-0.500	0.000	NaN	     NaN	14.27	13.97	-1.41	-7.22	-12.700	-64.610	-0.140	-19.200	-20.470	-33.17	-83.670
%     13	64.8	-53.7	-0.524	0.000	60.35	 NaN	10.55	10.25	-1.68	NaN	     -8.705	-64.604	-0.130	-19.100	-20.645	-29.35	-83.574
%     12	64.8	-50.0	-0.600	0.000	NaN	     NaN	14.17	13.95	-1.46	NaN	    -12.650	-64.710	-0.160	-19.200	-20.500	-33.15	-83.750
%     ];


% J is 9        Actual Signal Level @ Chassis R.P. connector (dBm)
% O is 14       Measured Signal Level at ADC (dBFS)
% D+E+F is 3:5  Signal Source Coupling Factor, Cable Atten, Splitter Atten (dB)

% Cal 2011-11-03
%                 D       E       F                               J                                    O
% c = [
%     18	77.8	-50.0	-3.727	-3.312	47.09	11.10	20.76	20.52	-15.80	NaN	-4.919	-77.759	-0.200	-4.900	-20.501	-25.42	-82.459	77.76	59689.8
%     17	77.8	-50.0	-3.800	0.000	NaN	     NaN	24.00	24.21	-15.73	NaN	-8.935	-78.460	-0.450	-5.200	-20.475	-29.41	-83.2	78.46	70145.5
%     16	80.8	-47.8	-3.700	0.000	NaN	     NaN	29.30	27.58	-16.34	NaN	-12.963	-80.800	-1.720	-5.900	-20.517	-33.48	-85.0	80.80	120226.4
%     NaN	 NaN	  0	     0      0       NaN	     NaN	  NaN  -16.10	-14.85	NaN	 30.000	    NaN	-0.950	-6.300	-20.200	  9.80	  NaN	  NaN	NaN
%     
%     21	77.8	-50.0	-3.706	0.000	131.75	NaN	24.09	24.13	-2.18	NaN	-22.477	-78.366	-0.530	-18.800	-20.453	-42.93	-96.636	78.37	68643.6
%     20	77.8	-50.0	-3.800	0.000	NaN	NaN	24.00	24.05	-1.97	18.59	-22.490	-78.260	-0.410	-18.900	-20.460	-42.95	-96.750	78.26	66988.5
%     19	80.8	-50.1	-3.700	0.000	NaN	NaN	26.97	26.92	-3.19	NaN	-25.414	-77.11	-1.680	-19.100	-25.923	-46.02	-99.85	82.43	174984.7
%     NaN	77.8	-50.0	-3.727	-3.308	47.09	11.20	20.77	20.57	-0.91	NaN	-20.097	-83.362	-0.440	-19.900	-15.056	-40.47	-97.505	78.05	63752.9
%     
%     7	77.8	-63.9	-0.561	0.000	-66.28	NaN	13.34	13.37	-2.17	NaN	-12.055	-78.681	-0.850	-19.100	-20.415	-32.47	-96.931	78.68	73807.4
%     8	77.8	-64.0	-0.600	0.000	NaN	NaN	13.20	13.17	-1.45	-6.60	-12.039	-78.090	-0.320	-19.300	-20.431	-32.47	-97.070	78.09	64416.9
%     9	77.8	-63.6	-0.611	0.000	134.84	NaN	13.59	13.55	-1.90	NaN	-12.110	-78.221	-0.460	-19.000	-20.440	-32.55	-96.761	78.22	66389.6
%     10	77.8	-63.8	-0.600	0.000	NaN	NaN	13.40	13.36	-2.22	NaN	-12.010	-78.630	-0.870	-19.300	-20.650	-32.66	-97.060	78.63	72945.8
%     
%     1	77.8	-50.0	-1.400	0.000	NaN	NaN	26.40	26.43	-2.06	NaN	-25.252	-78.710	-0.880	-19.300	-20.478	-45.73	-97.130	78.71	74301.9
%     2	77.8	-50.1	-1.400	0.000	NaN	NaN	26.30	26.26	-2.62	NaN	-23.780	-77.900	-0.140	-18.000	-20.480	-44.26	-95.760	77.90	61659.5
%     5	77.8	-50.0	-1.400	0.000	NaN	NaN	26.40	26.36	-2.88	NaN	-23.580	-77.860	-0.100	-17.700	-20.480	-44.06	-95.460	77.86	61094.2
%     4	77.8	-50.0	-1.300	0.000	NaN	NaN	26.50	26.43	-2.29	NaN	-24.456	-78.050	-0.320	-18.500	-20.474	-44.93	-96.230	78.05	63826.3
%     
%     15	64.8	-53.8	-0.462	0.000	-72.44	NaN	10.51	10.46	-1.97	NaN	-8.856	-65.092	-0.370	-18.900	-20.504	-29.36	-83.622	65.09	3230.0
%     14	64.8	-50.0	-0.500	0.000	NaN	NaN	14.27	13.97	-1.41	-7.22	-12.700	-64.610	-0.140	-19.200	-20.470	-33.17	-83.670	64.61	2890.7
%     13	64.8	-53.7	-0.524	0.000	60.35	NaN	10.55	10.25	-1.68	NaN	-8.705	-64.604	-0.130	-19.100	-20.645	-29.35	-83.574	64.60	2886.7
%     12	64.8	-50.0	-0.600	0.000	NaN	NaN	14.17	13.95	-1.46	NaN	-12.650	-64.710	-0.160	-19.200	-20.500	-33.15	-83.750	64.71	2958.0
%     ];
% 
% CableAttn = c(:,3)+c(:,4)+c(:,5);
% dBsum = -c(:,14) + c(:,9) -30 - CableAttn;
% Watts = 10.^(dBsum1/10);


% % Cal 2011-11-16
% %                             F       G       H                              L                                        Q
% c = [
%     18	77.782	60006.74	-50.0	-3.727	-3.312	47.09	11.10	20.74	20.59	-15.46	 NaN	-6.050	-78.549	-0.920	-5.900	-20.440	-26.49	-83.529	71597.9
%     17	77.782	60006.74	-50.0	-3.800	0.000	 NaN	 NaN	23.98	24.21	-15.73	 NaN	-8.935	-78.460	-0.450	-5.200	-20.475	-29.41	-83.2	70145.5
%     16	80.792	120005.18	-47.8	-3.700	0.000	 NaN	 NaN	29.29	27.57	-16.35	 NaN	-12.963	-80.810	-1.740	-5.900	-20.507	-33.47	-85.0	120503.6
%     NaN	 NaN	 NaN	     NaN	 NaN	 NaN	 NaN	 NaN	 NaN	-16.10	-14.85	 NaN	 30.000	  NaN	-0.950	-6.300	-20.200	9.80	 NaN	NaN
%     
%     21	77.782	60006.74	-50.0	-3.706	0.000	131.75	 NaN	24.08	24.13	-2.18	 NaN	-22.477	-78.366	-0.530	-18.800	-20.453	-42.93	-96.636	68643.6
%     20	77.782	60006.74	-50.0	-3.800	0.000	 NaN	 NaN	23.98	24.05	-1.97	18.59	-22.490	-78.260	-0.410	-18.900	-20.460	-42.95	-96.750	66988.5
%     19	80.792	120005.18	-50.1	-3.700	0	     NaN	 NaN	26.96	26.93	-2.56	 NaN	-25.414	-81.80	-1.040	-19.000	-20.516	-45.93	-99.76	151356.1
%     NaN	77.782	60006.74	-50.0	-3.727	-3.308	47.09	11.20	20.75	20.78	-1.70	 NaN	-20.097	-78.835	-1.020	-19.700	-20.383	-40.48	-97.515	76471.6
%     
%     7	77.782	60006.74	-63.9	-0.561	0.000	-66.28	 NaN	13.32	13.37	-2.17	 NaN	-12.055	-78.681	-0.850	-19.100	-20.415	-32.47	-96.931	73807.4
%     8	77.782	60006.74	-64.0	-0.600	0.000	 NaN	 NaN	13.18	13.17	-1.45	-6.60	-12.039	-78.090	-0.320	-19.300	-20.431	-32.47	-97.070	64416.9
%     9	77.782	60006.74	-63.6	-0.611	0.000	134.84	 NaN	13.57	13.55	-1.90	 NaN	-12.110	-78.221	-0.460	-19.000	-20.440	-32.55	-96.761	66389.6
%     10	77.782	60006.74	-63.8	-0.600	0.000	 NaN	 NaN	13.38	13.36	-2.22	 NaN	-12.010	-78.630	-0.870	-19.300	-20.650	-32.66	-97.060	72945.8
%     
%     1	77.782	60006.74	-50.0	-1.400	0.000	 NaN	 NaN	26.38	26.43	-2.06	 NaN	-25.252	-78.710	-0.880	-19.300	-20.478	-45.73	-97.130	74301.9
%     2	77.782	60006.74	-50.1	-1.400	0.000	 NaN	 NaN	26.28	26.26	-2.62	 NaN	-23.780	-77.900	-0.140	-18.000	-20.480	-44.26	-95.760	61659.5
%     5	77.782	60006.74	-50.0	-1.400	0.000	 NaN	 NaN	26.38	26.36	-2.88	 NaN	-23.580	-77.860	-0.100	-17.700	-20.480	-44.06	-95.460	61094.2
%     4	77.782	60006.74	-50.0	-1.300	0.000	 NaN	 NaN	26.48	26.43	-2.29	 NaN	-24.456	-78.050	-0.320	-18.500	-20.474	-44.93	-96.230	63826.3
%     
%     15	64.772	3000.54	    -53.8	-0.462	0.000	-72.44	  NaN	10.51	10.46	-1.97	 NaN	-8.856	-65.092	-0.370	-18.900	-20.504	-29.36	-83.622	3230.0
%     14	64.772	3000.54	    -50.0	-0.500	0.000	 NaN	  NaN	14.27	13.94	-1.38	-7.22	-12.700	-64.580	-0.140	-19.100	-20.340	-33.04	-83.540	2870.8
%     13	64.772	3000.54	    -53.7	-0.524	0.000	60.35	  NaN	10.55	10.25	-1.68	 NaN	-8.705	-64.604	-0.130	-19.100	-20.645	-29.35	-83.574	2886.7
%     12	64.772	3000.54	    -50.0	-0.600	0.000	 NaN	  NaN	14.17	13.95	-1.46	 NaN	-12.650	-64.710	-0.160	-19.200	-20.500	-33.15	-83.750	2958.0
%     ];
% % L is 10       Test Signal Level @ Chassis R.P. connector (dBm)
% % O is 15       Measured Signal Level at ADC (dBFS)
% % F+G+H is 4:6  Signal Source Coupling Factor, Cable Atten, Splitter Atten (dB)
% CableAttn = c(:,4)+c(:,5)+c(:,6);
% dBsum = -c(:,15) + c(:,10) -30 - CableAttn;
% Watts = 10.^(dBsum/10);

% Cal 2011-11-16 + LLRF1 changes on 2014-03-24
%                   Goal    Actual   Front-panel atten
%             FWD   20.79   21.74    27.7 dB
%             REV   24.02   24.71    30.6 dB
%             Cell  29.17   29.75    36.9 dB
%    B    D        E           F       G       H                              L                                        Q
%c_old = [
%    18	77.782	60006.74	-50.0	-3.727	-3.312	47.09	11.10	20.79   21.74 	-15.46	 NaN	-6.050	-78.549	-0.920	-5.900	-20.440	-27.70	-83.529	71597.9
%    17	77.782	60006.74	-50.0	-3.800	0.000	 NaN	 NaN	24.02   24.71	-15.73	 NaN	-8.935	-78.460	-0.450	-5.200	-20.475	-30.60	-83.2	70145.5
%    16	80.792	120005.18	-47.8	-3.700	0.000	 NaN	 NaN	29.17   29.75	-16.35	 NaN	-12.963	-80.810	-1.740	-5.900	-20.507	-36.90	-85.0	120503.6
%    NaN	 NaN	 NaN	     NaN	 NaN	 NaN	 NaN	 NaN	 NaN	-16.10	-14.85	 NaN	 30.000	  NaN	-0.950	-6.300	-20.200	  9.80	 NaN	NaN
%    
%    21	77.782	60006.74	-50.0	-3.706	0.000	131.75	 NaN	24.08	24.13	-2.18	 NaN	-22.477	-78.366	-0.530	-18.800	-20.453	-42.93	-96.636	68643.6
%    20	77.782	60006.74	-50.0	-3.800	0.000	 NaN	 NaN	23.98	24.05	-1.97	18.59	-22.490	-78.260	-0.410	-18.900	-20.460	-42.95	-96.750	66988.5
%    19	80.792	120005.18	-50.1	-3.700	0	     NaN	 NaN	26.96	26.93	-2.56	 NaN	-25.414	-81.80	-1.040	-19.000	-20.516	-45.93	-99.76	151356.1
%    NaN	77.782	60006.74	-50.0	-3.727	-3.308	47.09	11.20	20.75	20.78	-1.70	 NaN	-20.097	-78.835	-1.020	-19.700	-20.383	-40.48	-97.515	76471.6
%    
%    7	77.782	60006.74	-63.9	-0.561	0.000	-66.28	 NaN	13.32	13.37	-2.17	 NaN	-12.055	-78.681	-0.850	-19.100	-20.415	-32.47	-96.931	73807.4
%    8	77.782	60006.74	-64.0	-0.600	0.000	 NaN	 NaN	13.18	13.17	-1.45	-6.60	-12.039	-78.090	-0.320	-19.300	-20.431	-32.47	-97.070	64416.9
%    9	77.782	60006.74	-63.6	-0.611	0.000	134.84	 NaN	13.57	13.55	-1.90	 NaN	-12.110	-78.221	-0.460	-19.000	-20.440	-32.55	-96.761	66389.6
%    10	77.782	60006.74	-63.8	-0.600	0.000	 NaN	 NaN	13.38	13.36	-2.22	 NaN	-12.010	-78.630	-0.870	-19.300	-20.650	-32.66	-97.060	72945.8
%    
%    1	77.782	60006.74	-50.0	-1.400	0.000	 NaN	 NaN	26.38	26.43	-2.06	 NaN	-25.252	-78.710	-0.880	-19.300	-20.478	-45.73	-97.130	74301.9
%    2	77.782	60006.74	-50.1	-1.400	0.000	 NaN	 NaN	26.28	26.26	-2.62	 NaN	-23.780	-77.900	-0.140	-18.000	-20.480	-44.26	-95.760	61659.5
%    5	77.782	60006.74	-50.0	-1.400	0.000	 NaN	 NaN	26.38	26.36	-2.88	 NaN	-23.580	-77.860	-0.100	-17.700	-20.480	-44.06	-95.460	61094.2
%    4	77.782	60006.74	-50.0	-1.300	0.000	 NaN	 NaN	26.48	26.43	-2.29	 NaN	-24.456	-78.050	-0.320	-18.500	-20.474	-44.93	-96.230	63826.3
%    
%    15	64.772	3000.54	    -53.8	-0.462	0.000	-72.44	  NaN	10.51	10.46	-1.97	 NaN	-8.856	-65.092	-0.370	-18.900	-20.504	-29.36	-83.622	3230.0
%    14	64.772	3000.54	    -50.0	-0.500	0.000	 NaN	  NaN	14.27	13.94	-1.38	-7.22	-12.700	-64.580	-0.140	-19.100	-20.340	-33.04	-83.540	2870.8
%    13	64.772	3000.54	    -53.7	-0.524	0.000	60.35	  NaN	10.55	10.25	-1.68	 NaN	-8.705	-64.604	-0.130	-19.100	-20.645	-29.35	-83.574	2886.7
%    12	64.772	3000.54	    -50.0	-0.600	0.000	 NaN	  NaN	14.17	13.95	-1.46	 NaN	-12.650	-64.710	-0.160	-19.200	-20.500	-33.15	-83.750	2958.0
%    ];
% L is 10       Test Signal Level @ Chassis R.P. connector (dBm)
% O is 15       Measured Signal Level at ADC (dBFS)
% F+G+H is 4:6  Signal Source Coupling Factor, Cable Atten, Splitter Atten (dB)
% CableAttn = c(:,4)+c(:,5)+c(:,6);
% dBsum = -c(:,15) + c(:,10) -30 - CableAttn;
% Watts = 10.^(dBsum/10);

% Cal 2015-01-05
% https://docs.google.com/a/lbl.gov/spreadsheets/d/1BBZZhRteE_n90_15nkfpKJOdwe4uRvV3WU6CVlQ4eTM/edit#gid=322172472
%        D            E       F       G       H                               L                                  Q                                                   W (new col)
% c_old = [
%     18	77.78151   60000.00 -50.20	-3.712	-3.300	36.77	-0.62	20.57	20.61  -14.56	NaN	 -6.050	-77.822	0.000	 -5.900	-20.460	-26.51	-83.722	 60562.0	0.040
%     17	77.78	   60000.00 -49.96	-3.725	0.000	23.10	 NaN	24.10	23.49  -14.56	NaN	 -9.820	-78.065	0.000	 -5.200	-18.870	-28.69	-82.4	 64047.2	0.283
%     16	80.79	  120000.00 -46.80	-3.787	0.000	42.15	 NaN	30.20	28.67  -15.71	NaN	-14.480	-80.777	0.000	 -5.900	-20.090	-34.57	-85.2	119591.4   -0.015
%     NaN	  NaN	      NaN	 NaN	 NaN	  NaN	  NaN	 NaN   -16.10  -13.90	 NaN  30.00	 NaN	 0.000 -6.300	-20.200	  9.80	 NaN	 NaN	   NaN       NaN
%     
%     21	77.78	   60000.00	-49.70	-3.691	0.000	121.07	NaN	    24.39	24.40	-1.92	NaN	-22.477	-77.791	0.000	-18.800	-20.723	-43.20	-96.591	 60131.2 	0.009
%     20	77.78	   60000.00	-49.90	-3.730	0.000	92.33	NaN	    24.15	24.18	-1.69 18.59	-22.490	-77.810	0.000	-18.900	-20.590	-43.08	-96.710	 60394.9	0.028
%     19	80.79	  120000.00	-56.40	-3.596	0.000	39.61	NaN	    20.80	25.71	-0.30	NaN	-20.120	-80.42	0.000	-19.000	-24.590	-44.71	-104.71	110052.5   -0.376
%     NaN	77.78	   60000.00	-50.20	-3.712	-3.288	36.77	9.34	20.58	21.58	-1.48	NaN	-20.097	-78.780	0.000	-19.700	-21.183	-41.28	-98.480	 75509.2	0.998
%     
%     7	77.78	   60000.00	-63.90	-0.564	0.000	-65.33	NaN	    13.32	14.28	-2.23	NaN	-12.055	-78.744	0.000	-19.100	-21.325	-33.38	-97.844	 74885.9 	0.962
%     8	77.78	   60000.00	-64.00	-0.567	0.000	-72.23	NaN	    13.21	13.62	-1.58 -6.60	-12.039	-78.187	0.000	-19.300	-20.881	-32.92	-97.487	 65871.9	0.405
%     9	77.78	   60000.00	-63.60	-0.615	0.000	135.78	NaN	    13.57	14.03	-1.92	NaN	-12.110	-78.245	0.000	-19.000	-20.920	-33.03	-97.245	 66757.5	0.463
%     10	77.78	   60000.00	-63.80	-0.617	0.000	135.38	NaN	    13.36	14.10	-2.09	NaN	-12.010	-78.517	0.000	-19.300	-21.390	-33.40	-97.817	 71072.2	0.735
%     
%     1	77.78	   60000.00	-50.00	-1.330	0.000	-158.34	NaN	    26.45	27.53	-2.28	NaN	-24.470	-78.080	0.000	-19.300	-22.360	-46.83	-98.160	 64268.8	0.298
%     2	77.78	   60000.00	-50.10	-1.325	0.000	-100.98	NaN	    26.36	26.52	-2.74	NaN	-23.780	-77.945	0.000	-18.000	-20.740	-44.52	-95.945	 62301.7	0.163
%     5	77.78	   60000.00	-50.00	-1.310	0.000	-10.82	NaN	    26.47	26.88	-3.30	NaN	-23.580	-78.190	0.000	-17.700	-21.000	-44.58	-95.890	 65917.4	0.408
%     4	77.78	   60000.00	-50.00	-1.312	0.000	7.93	NaN	    26.47	27.06	-2.60	NaN	-24.456	-78.372	0.000	-18.500	-21.104	-45.56	-96.872	 68738.5	0.590
%     
%     15	64.77121	3000.00	-53.80	-0.466	0.000	-71.48	NaN	    10.51	11.40	-2.54	NaN	-8.856	-65.666	0.000	-18.900	-21.444	-30.30	-84.566	  3686.4	0.895
%     14	64.77121	3000.00	-50.00	-0.467	0.000	-74.20	NaN	    14.30	15.06	-2.36 -7.22	-12.700	-65.527	0.000	-19.100	-21.460	-34.16	-84.627	  3570.3	0.756
%     13	64.77121	3000.00	-53.70	-0.530	0.000	61.16	NaN	    10.54	11.22	-2.52	NaN	-8.705	-65.450	0.000	-19.100	-21.615	-30.32	-84.550	  3507.5	0.679
%     12	64.77121	3000.00	-50.00	-0.533	0.000	59.55	NaN	    14.24	14.77	-2.12	NaN	-12.650	-65.303	0.000	-19.200	-21.320	-33.97	-84.503	  3390.8	0.532
%     ];
% L is 10       Test Signal Level @ Chassis R.P. connector (dBm)
% Q is 15       Measured Signal Level at ADC (dBFullScale)
% Note: in this table L and Q are added together and reported in L (Q is zero)
% F+G+H is 4:6  Signal Source Coupling Factor, Cable Atten, Splitter Atten (dB)
%CableAttn = c(:,4)+c(:,5)+c(:,6);
%dBsum = -c(:,15) + c(:,10) -30 - CableAttn;
%Watts = 10.^(dBsum/10);% Full Scale in Watts

% Cal 2015-01-05
% https://docs.google.com/a/lbl.gov/spreadsheets/d/1BBZZhRteE_n90_15nkfpKJOdwe4uRvV3WU6CVlQ4eTM/edit#gid=322172472
%                                  F       G       H                              L                                        Q                                               W (new col)
% c = [
%    18	77.78151	60000.00	-50.20	-3.712	-3.300	36.77	-0.62	20.57	20.61	-14.56	NaN	  -6.050	-77.822	 0.000	-5.900	-20.460	-26.51	-83.722	 60562.0	0.040
%    17	77.78	    60000.00	-49.96	-3.725		0   23.10	 NaN	24.10	24.81	-15.26	NaN	  -9.820	-78.765	-0.270	-5.200	-20.190	-30.01	-83.7	 75248.9	0.983
%    16	80.79	   120000.00	-46.80	-3.787		0   42.15	 NaN	30.20	29.12	-15.38	NaN	 -14.890	-80.857	-1.150	-5.900	-20.130	-35.02	-85.6	121814.8	0.065
%    NaN	NaN				NaN		   NaN	   NaN    NaN    NaN     NaN   -16.10  -13.90	 NaN	30.		NaN      0.000	-6.300	-20.200	  9.80	 NaN      NaN  	  NaN        NaN
% 																					
%    21	77.78	    60000.00	-49.70	-3.691		0  121.07	 NaN	24.39	24.40	-1.92	NaN	  -22.477	-77.791	 0.000	-18.800	-20.723	 -43.20	-96.591	 60131.2	0.009
%    20	77.78	    60000.00	-49.90	-3.730		0   92.33	 NaN	24.15	24.18	-1.69	18.59 -22.490	-77.810	 0.000	-18.900	-20.590	 -43.08	-96.710	 60394.9	0.028
%    19	80.79	   120000.00	-56.40	-3.596		0   39.61	 NaN	20.80	22.87	-2.410	NaN	  -20.590	-83.00	-0.130	-19.000	-21.280	 -41.87	-101.87	199342.5	2.204
%   NaN   77.78	    60000.00	-50.20	-3.712	-3.288	36.77	9.34	20.58	21.58	-1.48	NaN	  -20.097	-78.780	 0.000	-19.700	-21.183	 -41.28	-98.480	 75509.2	0.998
% 																					
%     7	77.78	    60000.00	-63.90	-0.564		0  -65.33	 NaN	13.32	14.28	-2.23	NaN	  -12.055	-78.744	 0.000	-19.100	-21.325	 -33.38	-97.844	 74885.9	0.962
%     8	77.78	    60000.00	-64.00	-0.567		0  -72.23	 NaN	13.21	13.62	-1.58  -6.60  -12.039	-78.187	 0.000	-19.300	-20.881	 -32.92	-97.487	 65871.9	0.405
%     9	77.78	    60000.00	-63.60	-0.615		0  135.78	 NaN	13.57	14.03	-1.92	NaN	  -12.110	-78.245	 0.000	-19.000	-20.920	 -33.03	-97.245	 66757.5	0.463
%    10	77.78	    60000.00	-63.80	-0.617		0  135.38	 NaN	13.36	14.10	-2.090	NaN	  -12.010	-78.517	 0.000	-19.300	-21.390	 -33.40	-97.817	 71072.2	0.735
% 																					
%     1	77.78	    60000.00	-50.00	-1.330		0 -158.34	 NaN	26.45	26.27	-2.01	NaN	  -24.420	-77.760	-0.160	-19.300	-21.150	 -45.57	-96.900	 59703.5   -0.022
%     2	77.78	    60000.00	-50.10	-1.325		0 -100.98	 NaN	26.36	26.52	-2.74	NaN	  -23.780	-77.945	 0.000	-18.000	-20.740	 -44.52	-95.945	 62301.7	0.163
%     5	77.78	    60000.00	-50.00	-1.310		0  -10.82	 NaN	26.47	26.88	-3.30	NaN	  -23.580	-78.190	 0.000	-17.700	-21.000	 -44.58	-95.890	 65917.4	0.408
%     4	77.78	    60000.00	-50.00	-1.312		0    7.93	 NaN	26.47	27.06	-2.60	NaN	  -24.456	-78.372	 0.000	-18.500	-21.104	 -45.56	-96.872	 68738.5	0.590
% 																					
%     15	64.77121	 3000.00	-53.80	-0.466		0  -71.48	 NaN	10.51	11.40	-2.54	NaN	   -8.856	-65.666	 0.000	-18.900	-21.444	 -30.30	-84.566	  3686.4	0.895
%     14	64.77121	 3000.00	-50.00	-0.467		0  -74.20	 NaN	14.30	15.06	-2.36  -7.22  -12.700	-65.527	 0.000	-19.100	-21.460	 -34.16	-84.627	  3570.3	0.756
%     13	64.77121	 3000.00	-53.70	-0.530		0   61.16	 NaN	10.54	11.22	-2.52	NaN	   -8.705	-65.450	 0.000	-19.100	-21.615	 -30.32	-84.550	  3507.5	0.679
%     12	64.77121	 3000.00	-50.00	-0.533		0   59.55	 NaN	14.24	14.77	-2.12	NaN	  -12.650	-65.303	 0.000	-19.200	-21.320	 -33.97	-84.503	  3390.8	0.532
%     ];

% Cal 2015-01-05 rev2
% https://docs.google.com/a/lbl.gov/spreadsheets/d/17PK9gBRx3CTseTf4vNcL4tWgB3zTgPFNd48HhHGGZDs/edit#gid=1510861559
%                              F       G       H                           L                                  Q                                               W (new col)
c = [
    18 77.78151	 60000.00	-50.20	-3.712 -3.300	36.77 -0.62	20.57	20.61	-14.56	NaN  -6.050 -77.822	 0.000	-5.900	-20.460	-26.51	-83.722	60562.0	0.040
    17	77.78	 60000.00	-49.96	-3.725	0.000	23.10	NaN	24.10	24.81	-15.26	NaN	 -9.820	-78.765	-0.270	-5.200	-20.190	-30.01	-83.7	75248.9	0.983
    16	80.79	120000.00	-46.80	-3.787	0.000	42.15	NaN	30.20	29.12	-15.38	NaN	-14.890	-80.857	-1.150	-5.900	-20.130	-35.02	-85.6  121814.8	0.065
    NaN	NaN	       NaN  	 NaN	 NaN	NaN	     NaN	NaN	 NaN   -16.10	-13.90	NaN	 30.000	  NaN	 0.000	-6.300	-20.2	  9.80	 NaN	   NaN	NaN
    
    21	77.78	60000.00	-49.70	-3.691	0.000	121.07	NaN	24.39	24.40	-1.92	NaN	-22.477	-77.791	 0.000	-18.800	-20.723	-43.20	-96.591	60131.2	0.009
    20	77.78	60000.00	-49.90	-3.730	0.000	92.33	NaN	24.15	24.18	-1.69 18.59	-22.490	-77.810	 0.000	-18.900	-20.590	-43.08	-96.710	60394.9	0.028
    19	80.79  120000.00	-56.40	-3.596	0.000	39.61	NaN	20.80	22.87	-2.41	NaN	-20.590	-83.00  -0.130	-19.000	-21.280	-41.87	-101.87	199342.5	2.204
    NaN	77.78	60000.00	-50.20	-3.712	-3.288	36.77  9.34	20.58	21.58	-1.48	NaN	-20.097	-78.780	 0.000	-19.700	-21.183	-41.28	-98.480	75509.2	0.998
    
    7	77.78	60000.00	-63.90	-0.564	0.000	-65.33	NaN	13.32	14.28	-2.23	NaN	-12.055	-78.744	 0.000	-19.100	-21.325	-33.38	-97.844	74885.9	0.962
    8	77.78	60000.00	-64.00	-0.567	0.000	-72.23	NaN	13.21	13.62	-1.58 -6.60	-12.039	-78.187	 0.000	-19.300	-20.881	-32.92	-97.487	65871.9	0.405
    9	77.78	60000.00	-63.60	-0.615	0.000	135.78	NaN	13.57	14.03	-1.92	NaN	-12.110	-78.245	 0.000	-19.000	-20.920	-33.03	-97.245	66757.5	0.463
    10	77.78	60000.00	-63.80	-0.617	0.000	135.38	NaN	13.36	14.10	-2.090	NaN	-12.010	-78.517	 0.000	-19.300	-21.390	-33.40	-97.817	71072.2	0.735
    
    1	77.78	60000.00	-50.00	-1.330	0.000	-158.34	NaN	26.45	26.27	-2.01	NaN	-24.420	-77.760	-0.160	-19.300	-21.150	-45.57	-96.900	59703.5	-0.022
    2	77.78	60000.00	-50.10	-1.325	0.000	-100.98	NaN	26.36	26.52	-2.74	NaN	-23.780	-77.945  0.000	-18.000	-20.740	-44.52	-95.945	62301.7	0.163
    5	77.78	60000.00	-50.00	-1.310	0.000	-10.82	NaN	26.47	26.88	-3.30	NaN	-23.580	-78.190	 0.000	-17.700	-21.000	-44.58	-95.890	65917.4	0.408
    4	77.78	60000.00	-50.00	-1.312	0.000	7.93	NaN	26.47	27.06	-2.60	NaN	-24.456	-78.372	 0.000	-18.500	-21.104	-45.56	-96.872	68738.5	0.590
    
    15	64.77121	3000.00	-53.80	-0.466	0.000	-71.48	NaN	10.51	11.40	-2.54	NaN	 -8.856	-65.666	 0.000	-18.900	-21.444	-30.30	-84.566	3686.4	0.895
    14	64.77121	3000.00	-50.00	-0.467	0.000	-74.20	NaN	14.30	15.06	-2.36 -7.22	-12.700	-65.527	 0.000	-19.100	-21.460	-34.16	-84.627	3570.3	0.756
    13	64.77121	3000.00	-53.70	-0.530	0.000	61.16	NaN	10.54	11.22	-2.52	NaN	 -8.705	-65.450	 0.000	-19.100	-21.615	-30.32	-84.550	3507.5	0.679
    12	64.77121	3000.00	-50.00	-0.533	0.000	59.55	NaN	14.24	14.77	-2.12	NaN	-12.650	-65.303	 0.000	-19.200	-21.320	-33.97	-84.503	3390.8	0.532
    ];

% REMARK: Only columns F, G, H, L and Q are used
% L is 10       Test Signal Level @ Chassis R.P. connector (dBm)
% Q is 15       Measured Signal Level at ADC (dBFullScale)
% Note: in this table L and Q are added together and reported in L (Q is zero in most cases)
% F+G+H is 4:6  Signal Source Coupling Factor, Cable Atten, Splitter Atten (dB)
CableAttn = c(:,4)+c(:,5)+c(:,6);
dBsum     = c(:,10) -c(:,15) - 30 - CableAttn;   % L - Q - 30 - (F + G + H)
Watts     = 10.^(dBsum/10);                      % Full Scale in Watts

SqrtWatts = sqrt(Watts);
SqrtWatts(isnan(SqrtWatts)) = 1;

% Compare new table
%[Watts1 Watts Watts1-Watts]


ii = 1;
LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(4);
LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(1);
LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(2);
LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(3);

ii = 4;
LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(5);
LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(6);
LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(7);
LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(8);

ii = 3;
LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(9);
LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(10);
LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(11);
LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(12);

ii = 5;
LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(13);
LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(14);
LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(15);
LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(16);

ii = 2;
LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(17);
LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(18);
LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(19);
LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(20);


LLRFData{1}.Prefix = 'llrf1:';
LLRFData{1}.Inp1.Label = 'Laser Amp';
LLRFData{1}.Inp2.Label = 'Cav A3 FWD (split)';
LLRFData{1}.Inp3.Label = 'Cav A3 REV';
LLRFData{1}.Inp4.Label = 'Cav Cell Probe 1';

LLRFData{4}.Prefix = 'llrf2molk1:';
LLRFData{4}.Inp1.Label = 'Cav A4 FWD';
LLRFData{4}.Inp2.Label = 'Cav A4 REV';
LLRFData{4}.Inp3.Label = 'Cav Cell Probe 2';
LLRFData{4}.Inp4.Label = 'Cav A3 FWD (split)';

LLRFData{3}.Prefix = 'llrf1molk2:';
LLRFData{3}.Inp1.Label = 'Tetrode A3 FWD';
LLRFData{3}.Inp2.Label = 'Tetrode A3 REV';
LLRFData{3}.Inp3.Label = 'Tetrode A4 FWD';
LLRFData{3}.Inp4.Label = 'Tetrode A4 REV';

LLRFData{5}.Prefix = 'llrf2molk2:';
LLRFData{5}.Inp1.Label = 'Circ 1 Load FWD';
LLRFData{5}.Inp2.Label = 'Circ 1 Load REV';
LLRFData{5}.Inp3.Label = 'Circ 2 Load FWD';
LLRFData{5}.Inp4.Label = 'Circ 2 Load REV';

LLRFData{2}.Prefix = 'llrf1molk1:';
LLRFData{2}.Inp1.Label = 'SSPA A1 FWD';
LLRFData{2}.Inp2.Label = 'SSPA A1 REV';
LLRFData{2}.Inp3.Label = 'SSPA A2 FWD';
LLRFData{2}.Inp4.Label = 'SSPA A2 REV';


% save after a calibration change (I'll do every standalone launch for now)
if isdeployed
    save('/remote/apex/hlc/matlab/machine/APEX/Gun/LLRFDataStructure','LLRFData');
end



% Info not used at the moment
% Source Rear_panel_output (dBm)
%     0 -132.2
%     1  -82.7
%   625  -35.2
%  1250  -29.1
%  2500  -23.1
%  5000  -17.1
% 10000  -11.08
% 15000   -7.7
% 20000   -5.2
% 25000   -3.3
% 30000   -1.74
% 46339   -0.46
% 
% Clock change:    100 MHz to 102.143 MHz for the clock
%               14.285 MHz to 18.571 MHz for the IF
% 
% Du has a long story about frequencies.  Here's the short story:
%  1300/7      = 185.714
%  1300*11/140 = 102.143
%  1300/70     =  18.571
% 
%  18.571/102.143 = 2/11
  


% --------------------------------------------------------------------
function ReadSetLLRFInterlocks_Callback(hObject, eventdata, handles)

LLRFData = getappdata(handles.figure1, 'LLRFData');
setllrfinterlocks(LLRFData);



function [LLRFData, ProblemDetected] = setllrf1power(LLRFData, handles)

%%%%%%%%%%%%%%%%%%%%%
% Look for Problems %
%%%%%%%%%%%%%%%%%%%%%

ProblemDetected = 0;

% Shutdown thresholds
CurrThreshold_caenA3620_22 = 0;   % Solenoid PS1 current [A]
CurrThreshold_caenA3620_23 = 0;   % Solenoid PS3 current [A]

TempThreshold1  = 98;  % Treshold for the gun wall and couplers temperatures for operation[C]
TempThreshold2  = 85;  % Treshold for the coaxial lines temperatures and cavity and coupler water cooling for operation[C]

%TempThreshold1  = 220;  % Treshold for the gun wall and couplers temperatures for RF baking[C]
%TempThreshold2  = 220;  % Treshold for the coaxial lines temperatures and cavity and coupler water cooling for RF baking[C]

PowerReal = getpv('llrf1:source_re_ao');
PowerImag = getpv('llrf1:source_im_ao');

 % Pulse length in EPICS is 10ns / unit
 
TimeScaleCalFactor=1; % ??? %1.0177;%1.02143; %Time Calibration Factor required after March 2014 LLRF upgrade. There 4 of such lines.
    
PulseLength = getpvonline('llrf1:pulse_length_ao')*10/(TimeScaleCalFactor*1e6);
 % Repetition period in EPICS is 20ns / unit  -> should be 10 ns/unit???
RepPeriod = getpvonline('llrf1:rep_period_ao')*10/(TimeScaleCalFactor*1e6);
PulsedModeFlag=0;
if PulseLength < RepPeriod
    PulsedModeFlag = 1;
end

%PulseLength=str2num(get(handles.PulseLength, 'String'));
%RepPeriod=str2num(get(handles.RepPeriod, 'String'));

% Solenoid #1
%PS22Curr   = abs(getpv('MPSol1:CurrentRBV'));
%PS22Status = getpv('MPSol1:SupplyOn');
%if (PowerReal || PowerImag) && PS22Curr < CurrThreshold_caenA3620_22
%    fprintf('   WARNING: caenA3620:22 current < %.1f A\n', CurrThreshold_caenA3620_22);
%    ShutOffDrivePower(handles);
%    ProblemDetected = 1;
%    return;
%elseif (PowerReal || PowerImag) && PS22Status==0
%    fprintf(   'WARNING: caenA3620:22 Off!!!\n');
%    ShutOffDrivePower(handles);
%    ProblemDetected = 1;
%    return;
%end


% Solenoid #2
%PS23Curr   = abs(getpv('MPSol2:CurrentRBV'));
%PS23Status = getpv('MPSol2:SupplyOn');
%if (PowerReal || PowerImag) && PS23Curr < CurrThreshold_caenA3620_23
%    fprintf('WARNING: caenA3620:23 current < %.1f A\n', CurrThreshold_caenA3620_23);
%    ShutOffDrivePower(handles);
%    ProblemDetected = 1;
%    return;
%elseif (PowerReal || PowerImag) && PS23Status==0
%    fprintf('WARNING: caenA3620:23 Off!!!\n');
% %    ShutOffDrivePower(handles);
%    ProblemDetected = 1;
%    return;
%end

% Phase l3o3 control
%y3 = LLRFData{1}.Inp3.ScaleFactor * (LLRFData{1}.Inp3.Real.Data + 1i*LLRFData{1}.Inp3.Imag.Data) / LLRFData{1}.('yscale');
%y3meanmag = mean(abs(y3).^2);
if get(handles.MatlabFreqLoop,'Value') && PulsedModeFlag % only run this loop in pulsed mode
    PhaseDiff=getpv('llrf1:phase_diff');
    if abs(PhaseDiff) > 3 
        setpvonline('llrf1:bt_do_freq_correction',1,'float',1); % use this version for quick refresh
        setpvonline('llrf1:bt_do_freq_correction',0,'float',1);
    end
end

% RF PLC Issue
% % Temperature control
 Chan1 = {
     'Gun:RF:Loop_Coupler_Outlet_Temp'
     'Gun:RF:Temp9'  
     'Gun:RF:Temp10'
     'Gun:RF:Temp11'
     'Gun:RF:Temp12'
     'Gun:RF:Temp13'
     'Gun:RF:Temp14'
     'Gun:RF:Temp15'
     };
% 
 Chan2 = {
     'Gun:RF:Cav_LCW_Supply_Temp'
     'Gun:RF:Cav_Nose_Cone_Outlet_Temp'
     'Gun:RF:Cav_2_5_Anode_1_Outlet_Temp'
     'Gun:RF:Cav_1_3_4_Anode_2_Outlet_Temp'
     'Gun:RF:Cav_Wall_Outlet_Temp'
     'Gun:RF:Cavity_OuterRing_Outlet_Temp'
     'Gun:Waveguide:Temp1'
     'Gun:Waveguide:Temp2'
     'Gun:Waveguide:Temp3'
     'Gun:Waveguide:Temp4'
     'Gun:Waveguide:Temp5'
     'Gun:Waveguide:Temp6'
     'Gun:Waveguide:Temp7'
     'Gun:Waveguide:Temp8'
     };
% 
 for i = 1:length(Chan1)
     T = getpvonline(Chan1{i});
     if T > TempThreshold1
         fprintf('   WARNING: %13s is %.1f C (beyond %.1f C threshold)\n', Chan1{i}, T, TempThreshold1);
         ProblemDetected = 1;
     end
 end
% 
 for i = 1:length(Chan2)
     T = getpvonline(Chan2{i});
     if T > TempThreshold2
         fprintf('   WARNING: %13s is %.1f C (beyond %.1f C threshold)\n', Chan2{i}, T, TempThreshold2);
         ProblemDetected = 1;
    end
 end

% Align central frequency of FPGA diagnostic boards to the LLRF one
llrfFreq=getpv('llrf1:ddsa_phstep_h_ao'); % read LLRF central frequency
setpvonline('llrf1molk1:ddsa_phstep_h_ao',llrfFreq,'float',1); % set llrf1molk1 central frequency
setpvonline('llrf1molk2:ddsa_phstep_h_ao',llrfFreq,'float',1); % set llrf1molk2 central frequency
setpvonline('llrf2molk1:ddsa_phstep_h_ao',llrfFreq,'float',1); % set llrf2molk1 central frequency
setpvonline('llrf2molk2:ddsa_phstep_h_ao',llrfFreq,'float',1); % set llrf2molk2 central frequency

% Check the requested power
if ProblemDetected
    ShutOffDrivePower(handles);
else
    % Goto requested power
    PowerReal = get(handles.PowerReal, 'UserData');
    PowerImag = get(handles.PowerImag, 'UserData');
    
    if ~isempty(PowerReal) && isnumeric(PowerReal)
        setpv('llrf1:source_re_ao', PowerReal);
        set(handles.PowerReal, 'UserData', []);
    end
    if ~isempty(PowerImag) && isnumeric(PowerImag)
        setpv('llrf1:source_im_ao', PowerImag);
        set(handles.PowerImag, 'UserData', []);
    end

end


function ShutOffDrivePower(handles)
fprintf('IT GOES!\n');

PowerReal = getpv('llrf1:source_re_ao');
PowerImag = getpv('llrf1:source_im_ao');

setpv('llrf1:source_im_ao', 0);
set(handles.PowerImag,  'String', '0');
set(handles.PowerPhase, 'String', '0');

if PowerReal==0
    % Set it again just to make sure the PV had processed
    setpv('llrf1:source_re_ao', 0);
else
    pwr0 = abs(getpv('llrf1:source_re_ao'));
    pwr  = pwr0:-1000:0;
    
    if ~round(pwr(end))
        fprintf('   Ramping down gun RF power\n');
    end
    
    for i = 2:length(pwr)
        setpv('llrf1:source_re_ao', round(pwr(i)));
        set(handles.PowerReal, 'String', num2str(round(pwr(i))));
        set(handles.PowerMag,  'String', num2str(round(pwr(i))));
        fprintf('   Gun RF driver set to %5d ADC [counts]\n', round(pwr(i)));
        pause(.2);
    end
    setpv('llrf1:source_re_ao', 0);
    if round(pwr(end))
        fprintf('   Gun RF driver set to 0 ADC [counts]\n');
    end
end

set(handles.PowerReal, 'String', '0');
set(handles.PowerMag,  'String', '0');
set(handles.PowerReal, 'UserData', []);
set(handles.PowerImag, 'UserData', []);


% --- Executes on button press in MatlabFreqLoop.
function MatlabFreqLoop_Callback(hObject, eventdata, handles)
% hObject    handle to MatlabFreqLoop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MatlabFreqLoop

% %setpv('llrf1:freq_loop_close', get(handles.MatlabFreqLoop,'Value'));



% --------------------------------------------------------------------
function PopPlot_Callback(hObject, eventdata, handles)

a = figure;

p = get(a, 'Position');
set(a, 'Position', [p(1) p(2) p(3)+.2*p(3) p(4)+.15*p(4)]);

b = copyobj(handles.axes1, a);
set(b, 'Position',[  0.1300    0.5838    0.7750    0.3412]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');
title(b, get(get(b,'ylabel'),'string'));
ylabel(b, 'Magnitude');

b = copyobj(handles.axes2, a);
set(b, 'Position',[ 0.1300    0.1100    0.7750    0.3412]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');
ylabel(b, 'Phase');
xlabel(b, 'Time [msec]');

orient portrait


% --------------------------------------------------------------------
function PopPlotAll_Callback(hObject, eventdata, handles)

a = figure;

p = get(a, 'Position');
set(a, 'Position', [p(1) p(2) p(3)+.5*p(3) p(4)+.7*p(4)]);

b = copyobj(handles.axes1, a);
set(b, 'Position',[ 0.1300    0.7731    0.3347    0.1519]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

b = copyobj(handles.axes2, a);
set(b, 'Position',[ 0.5703    0.7673    0.3347    0.1577]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

b = copyobj(handles.axes3, a);
set(b, 'Position',[ 0.1300    0.5482    0.3347    0.1577]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

b = copyobj(handles.axes4, a);
set(b, 'Position',[ 0.5703    0.5482    0.3347    0.1577]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

b = copyobj(handles.axes5, a);
set(b, 'Position',[ 0.1300    0.3291    0.3347    0.1577]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

b = copyobj(handles.axes6, a);
set(b, 'Position',[ 0.5703    0.3291    0.3347    0.1577]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

b = copyobj(handles.axes7, a);
set(b, 'Position',[ 0.1300    0.1100    0.3347    0.1577]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

xlabel(b, 'Time [msec]');

b = copyobj(handles.axes8, a);
set(b, 'Position',[ 0.5703    0.1100    0.3347    0.1577]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

xlabel(b, 'Time [msec]');

orient portrait
