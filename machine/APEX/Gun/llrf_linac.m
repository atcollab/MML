function varargout = llrf_linac(varargin)
% LLRF_LINAC MATLAB code for llrf_linac.fig
%      LLRF_LINAC, by itself, creates a new LLRF_LINAC or raises the existing
%      singleton*.
%
%      H = LLRF_LINAC returns the handle to a new LLRF_LINAC or the handle to
%      the existing singleton*.
%
%      LLRF_LINAC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LLRF_LINAC.M with the given input arguments.
%
%      LLRF_LINAC('Property','Value',...) creates a new LLRF_LINAC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before llrf_linac_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to llrf_linac_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help llrf_linac

% Last Modified by GUIDE v2.5 21-Sep-2015 16:57:05
% Feb. 7, 2012. Modified by Fernando. Added FPGA frequency alignment in function setllrf1power
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @llrf_linac_OpeningFcn, ...
    'gui_OutputFcn',  @llrf_linac_OutputFcn, ...
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
function varargout = llrf_linac_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes just before llrf_linac is made visible.
function llrf_linac_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to llrf_linac (see VARARGIN)

% Choose default command line output for llrf_linac
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% Check if the AO exists (this is required for stand-alone applications)
checkforao;

% UIWAIT makes llrf_linac wait for user response (see UIRESUME)
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


LLRFData = [];

if 1
    LLRFData = LLRFCalibration_Linac(LLRFData, handles);
    set(handles.figure1, 'color', [.729 .831 .957]);
elseif 1
    LLRFData = LLRFCalibration_Buncher(LLRFData, handles);
    set(handles.figure1, 'color', [.757 .867 .776]);
elseif 0 
    % Old DCav
    LLRFData = LLRFCalibration_DeflectingCavity(LLRFData, handles);
end
setappdata(handles.figure1, 'LLRFData', LLRFData);


% Graph max starting point
GraphMax = getpvonline([LLRFData{1}.Prefix, 'wave_samp_per_ao'], 'double');
if GraphMax > 51
    GraphMax = 51;
elseif GraphMax < 1
    GraphMax = 1;
end
set(handles.GraphMax, 'Value', GraphMax);


% Move to HWINIT???

% pulse_boundary has 4 States
% 00 always trigger (compatible)
% 01 trigger when rf_on or lost rf_master (compatible)
% 10 trigger on rising rf edge only (new)
% 11 trigger on falling rf edge only (new)
pulse_boundary = 0; % ???

% LLRF_LINAC Defaults  AOs
LLRF_Defaults = {
    'ch_keep_ao', 4080
    %'ddsa_phstep_h_ao', 193534
    'ddsa_phstep_l_ao', 1116   % 2340 for llrf:  ???
    'ddsa_modulo_ao', 4      % 1 for llrf:  ???
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

%getpv('L1llrf:permit2_mask')

% Wave shift removed
%WaveShift = getpvonline('L1llrf:wave_shift_ao', 'double');
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
%set(t, 'StartFcn', ['llrf_linac(''Timer_Start'',',    sprintf('%.30f',handles.hMainFigure), ',',sprintf('%.30f',handles.hMainFigure), ', [])']);
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
    % Which LLRF_LINAC board
    ii = LLRFNumber(handles);
    LLRF_Prefix = LLRFData{ii}.Prefix;
    
    if ~isempty(eventdata) && ischar(eventdata) && strcmpi(eventdata,'OneShot')
        % One shot
        
        % Update graph max
        %GraphMaxSet = 73.042200*getpvonline([LLRF_Prefix, 'wave_samp_per_ao'], 'double')/255;
        %set(handles.GraphMax, 'String', sprintf('%.6f',t(end)/1e6));  % If editbox
        pause(.1);
        GraphMax = getpvonline([LLRF_Prefix, 'wave_samp_per_ao'], 'double');
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


% Get LLRF_LINAC error/warning conditions
try
    % Reset warning
    RF_Permit = getpvonline([LLRFData{1}.Prefix, 'rf_permit'], 'double');
    RF_Master = getpvonline([LLRFData{1}.Prefix, 'rf_master'], 'double');
    
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
            set(handles.LLRFMessage, 'String', 'Y-Scale Overflow!');
        else
            set(handles.LLRFMessage, 'String', 'Permit & Y-Scale ok');
            set(handles.LLRFMessage, 'ForegroundColor', [0 .5 0]);
            set(handles.LLRFMessage, 'Visible', 'On');
        end
    end
    
    % Check the interlock state on each LLRF_LINAC board
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
    %llrfreset = getpvonline([LLRFData{1}.Prefix, 'rf_go_bo'], 'double');
    %set(handles.llrfreset, 'Value', sprintf('%d',round(PowerReal)));
    
    % Power
    PowerReal = getpvonline([LLRFData{1}.Prefix, 'source_re_ao'], 'double');
    set(handles.PowerReal, 'String', sprintf('%d',round(PowerReal)));
    
    PowerImag = getpvonline([LLRFData{1}.Prefix, 'source_im_ao'], 'double');
    set(handles.PowerImag, 'String', sprintf('%d',round(PowerImag)));
    
    PowerC = PowerReal + 1i*PowerImag;
    set(handles.PowerMag,   'String', sprintf('%.1f',abs(PowerC)));
    set(handles.PowerPhase, 'String', sprintf('%.1f',180*angle(PowerC)/pi));
    
    TimeScaleCalFactor = 1;
    
    % Pulse length in EPICS is 20ns / unit  -> should be 10 ns/unit???
    PulseLength = getpvonline([LLRFData{1}.Prefix, 'pulse_length_ao'], 'double');
    set(handles.PulseLength, 'String', sprintf('%.6f',10*PulseLength/(TimeScaleCalFactor*1e6)));
    
    % Repetition period in EPICS is 20ns / unit  -> should be 10 ns/unit???
    RepPeriod = getpvonline([LLRFData{1}.Prefix, 'rep_period_ao'], 'double');
    set(handles.RepPeriod, 'String', sprintf('%.6f',10*RepPeriod/(TimeScaleCalFactor*1e6)));

    % Graph max
    %GraphMaxSet = 73.042200*getpvonline('L1llrf:wave_samp_per_ao')/255;
    %set(handles.GraphMax, 'String', sprintf('%.6f',t(end)/1e6));  % If editbox
    %GraphMax = getpvonline('L1llrf:wave_samp_per_ao');
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
    %WaveShift = getpvonline('L1llrf:wave_shift_ao');
    %set(handles.WaveShift, 'Value', WaveShift);
    
    %TriggerMode = getpvonline('L1llrf:pulse_boundary_bo','double');
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
    
    % LLRF_LINAC Channels
    LLRFData{ii}.t = getpvonline([Board, 'xaxis']);  % ns (int)
    
    % Y-Scale is affected by,
    % 1. Averaging -wave shift (less "averaging" with greater time), changes max time
    %    28 ADC values are summed per wave_samp_per_ao (10 ns each)
    %    What's the ADC sampel rate???
    %    WaveSamplePeriod = getpvonline('L1llrf:wave_samp_per_ao');
    % 2. Vertical "gain" - linear on the log scale
    %    WaveShift = getpvonline('L1llrf:wave_shift_ao');
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

% LLRF_LINAC Data
LLRFData = getappdata(handles.figure1, 'LLRFData');

% Which LLRF_LINAC board
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


% Time stamp
set(handles.TimeStamp, 'String', datestr(labca2datenum(LLRFData{ii}.(['Inp4',FaultFlag]).Real.Time),'mmmm dd, yyyy  HH:MM:SS.FFF'));


if strcmpi(get(handles.AutoScaleX, 'Checked'), 'On') && ~isnan(t(end)) && t(end)~=0
    set(handles.axes1, 'XLim', [0 t(end)/1e6]);
end

drawnow;



function PulseLength_Callback(hObject, eventdata, handles)
LLRFData = getappdata(handles.figure1, 'LLRFData');
PulseLength = str2num(get(handles.PulseLength, 'String'));

TimeScaleCalFactor = 1;
    
if ~isempty(PulseLength)
    PulseLengthSet = round(TimeScaleCalFactor*1e6*PulseLength/10);
    setpvonline([LLRFData{1}.Prefix, 'pulse_length_ao'], PulseLengthSet);
end
drawnow;


function RepPeriod_Callback(hObject, eventdata, handles)
LLRFData = getappdata(handles.figure1, 'LLRFData');
RepPeriod = str2num(get(handles.RepPeriod, 'String'));

TimeScaleCalFactor = 1; 
    
if ~isempty(RepPeriod)
    RepPeriodSet = round(TimeScaleCalFactor*1e6*RepPeriod/10);
    setpvonline([LLRFData{1}.Prefix, 'rep_period_ao'], RepPeriodSet);
end
drawnow;


% --- Executes on slider movement.
function WaveShift_Callback(hObject, eventdata, handles)
LLRFData = getappdata(handles.figure1, 'LLRFData');
WaveShift = get(handles.WaveShift, 'Value');
if ~isempty(WaveShift)
    %WaveShift = round(WaveShift);
    if WaveShift > 7
        WaveShift = 7;
    elseif WaveShift < 1
        WaveShift = 1;
    end
    setpvonline([LLRFData{1}.Prefix, 'wave_shift_ao'], WaveShift);
    pause(.1);
end
%set(handles.WaveShift, 'Value', );
drawnow;


function GraphMax_Callback(hObject, eventdata, handles)
% L1llrf:wave_samp_per_ao vs graph max [msec]
%         255 73.042200
%         201 57.5744
%          99 28.357560
%          10  2.864400

% Which LLRF_LINAC board
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
        % Set all the LLRF_LINAC board to the same scaling
        for ii = 1:length(LLRFData)
            LLRF_Prefix = LLRFData{ii}.Prefix;
            setpvonline([LLRF_Prefix, 'wave_samp_per_ao'], GraphMax);
        end
    else
        %setpvonline('L1llrf:wave_samp_per_ao', GraphMax);
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
    %setpvonline('L1llrf:wave_samp_per_ao', GraphMaxSet);
end

drawnow;


% --- Executes on button press in TimeScaleAll.
function TimeScaleAll_Callback(hObject, eventdata, handles)



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
    %setpv('L1llrf:source_re_ao', PowerReal);
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
    %setpv('L1llrf:source_im_ao', PowerImag);
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
    
    %setpv('L1llrf:source_re_ao', PowerReal);
    %setpv('L1llrf:source_im_ao', PowerImag);
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

% Which LLRF_LINAC board
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

% LLRF_LINAC Data
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

% Save LLRF_LINAC Data to global and plot
if exist('LLRFData','var')
    setappdata(handles.figure1, 'LLRFData', LLRFData);
    PlotLLRFWaveforms;
else
    fprintf('   LLRF data structure not found in %s\n', FileName);
end



function ii = LLRFNumber(handles)
% LLRF_LINAC Data
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



function LLRFData = LLRFCalibration_Linac(LLRFData, handles)
 
% lmon21
% Klystron FWD
% Klystron REV
% Circulator OUT FWD
% Circulator OUT REV
% 
% lmon22
% Linac 1 CPL 1-1 Fwd
% Linac 1 CPL 1-2 Rev
% Linac 1 CPL 2-1 Fwd
% Linac 2 CPL 1-1 Fwd
% 
% lmon31
% Linac 2 CPL 1-2 Rev
% Linac 2 CPL 2-1 Fwd
% Linac 2 CPL 2-2 Rev
% Linac 3 CPL 1-1 Fwd
% 
% lmon32
% Linac 3 CPL 1-2 Rev
% Linac 3 CPL 2-1 Fwd
% Linac 3 CPL 2-2 Rev
% Deflecting Probe

% l2llrf
% Linac 1 CPL 2-2 Rev
% Linac 1 Probe
% Linac 2 Probe
% Linac 3 Probe

for ii = 1:5
    LLRFData{ii}.Inp1.ScaleFactor = 1;  %SqrtWatts(4);
    LLRFData{ii}.Inp2.ScaleFactor = 1;  %SqrtWatts(1);
    LLRFData{ii}.Inp3.ScaleFactor = 1;  %SqrtWatts(2);
    LLRFData{ii}.Inp4.ScaleFactor = 1;  %SqrtWatts(3);
end

LLRFData{1}.Prefix = 'L2llrf:';
LLRFData{1}.Inp1.Label = 'Linac 1 CPL 2-2 Rev';
LLRFData{1}.Inp2.Label = 'Linac 1 Probe';
LLRFData{1}.Inp3.Label = 'Linac 2 Probe';
LLRFData{1}.Inp4.Label = 'Linac 3 Probe';
set(handles.LLRF1, 'String', 'L2llrf');

LLRFData{2}.Prefix = 'Lmon21:';
LLRFData{2}.Inp1.Label = 'Klystron FWD';
LLRFData{2}.Inp2.Label = 'Klystron REV';
LLRFData{2}.Inp3.Label = 'Circulator OUT FWD';
LLRFData{2}.Inp4.Label = 'Circulator OUT REV';
set(handles.LLRF2, 'String', 'Lmon11');

LLRFData{3}.Prefix = 'Lmon22:';
LLRFData{3}.Inp1.Label = 'Linac 1 CPL 1-1 Fwd';
LLRFData{3}.Inp2.Label = 'Linac 1 CPL 1-2 Rev';
LLRFData{3}.Inp3.Label = 'Linac 1 CPL 2-1 Fwd';
LLRFData{3}.Inp4.Label = 'Linac 2 CPL 1-1 Fwd';
set(handles.LLRF3, 'String', 'Lmon22');

LLRFData{4}.Prefix = 'Lmon31:';
LLRFData{4}.Inp1.Label = 'Linac 2 CPL 1-2 Rev';
LLRFData{4}.Inp2.Label = 'Linac 2 CPL 2-1 Fwd';
LLRFData{4}.Inp3.Label = 'Linac 2 CPL 2-2 Rev';
LLRFData{4}.Inp4.Label = 'Linac 3 CPL 1-1 Fwd';
set(handles.LLRF4, 'String', 'Lmon31');

LLRFData{5}.Prefix = 'Lmon32:';
LLRFData{5}.Inp1.Label = 'Linac 3 CPL 1-2 Rev';
LLRFData{5}.Inp2.Label = 'Linac 3 CPL 2-1 Fwd';
LLRFData{5}.Inp3.Label = 'Linac 3 CPL 2-2 Rev';
LLRFData{5}.Inp4.Label = 'Deflecting Probe';
set(handles.LLRF5, 'String', 'Lmon32');

% LLRFData{4}.Prefix = 'Lmon11:';
% LLRFData{4}.Inp1.Label = 'Buncher';
% LLRFData{4}.Inp2.Label = 'Buncher';
% LLRFData{4}.Inp3.Label = 'Buncher';
% LLRFData{4}.Inp4.Label = 'Buncher';
% set(handles.LLRF4, 'String', 'Buncher');


function LLRFData = LLRFCalibration_Buncher(LLRFData, handles)
% lmon11
% Buncher 1 CPL 1-1 Fwd
% Buncher 1 CPL 1-2 Rev
% Buncher 1 CPL 2-1 Fwd
% Buncher 2 CPL 3-1 Fwd
% 
% lmon12
% Buncher 2 CPL 4-1 Fwd
% Buncher 2 CPL 3-2 Rev
% Deflecting CPL 1-1
% Deflecting CPL 1-2
%
% l1llrf
% Buncher 1 CPL 2-2 Rev
% Buncher 1 Probe
% Buncher 2 CPL 4-2 Rev
% Buncher 2 Probe


for ii = 1:3
    LLRFData{ii}.Inp1.ScaleFactor = 1;  %SqrtWatts(4);
    LLRFData{ii}.Inp2.ScaleFactor = 1;  %SqrtWatts(1);
    LLRFData{ii}.Inp3.ScaleFactor = 1;  %SqrtWatts(2);
    LLRFData{ii}.Inp4.ScaleFactor = 1;  %SqrtWatts(3);
end

LLRFData{1}.Prefix = 'L1llrf:';
LLRFData{1}.Inp1.Label = 'Buncher 1 CPL 2-2 Rev';
LLRFData{1}.Inp2.Label = 'Buncher 1 Probe';
LLRFData{1}.Inp3.Label = 'Buncher 2 CPL 4-2 Rev';
LLRFData{1}.Inp4.Label = 'Buncher 2 Probe';
set(handles.LLRF1, 'String', 'L1llrf');

LLRFData{2}.Prefix = 'Lmon11:';
LLRFData{2}.Inp1.Label = 'Buncher 1 CPL 1-1 Fwd';
LLRFData{2}.Inp2.Label = 'Buncher 1 CPL 1-2 Rev';
LLRFData{2}.Inp3.Label = 'Buncher 1 CPL 2-1 Fwd';
LLRFData{2}.Inp4.Label = 'Buncher 2 CPL 3-1 Fwd';
set(handles.LLRF2, 'String', 'Lmon11');

LLRFData{3}.Prefix = 'Lmon12:';
LLRFData{3}.Inp1.Label = 'Buncher 2 CPL 4-1 Fwd';
LLRFData{3}.Inp2.Label = 'Buncher 2 CPL 3-2 Rev';
LLRFData{3}.Inp3.Label = 'Deflecting CPL 1-1';
LLRFData{3}.Inp4.Label = 'Deflecting CPL 1-2';
set(handles.LLRF3, 'String', 'Lmon12');

set(handles.LLRF4, 'String', '');
set(handles.LLRF4, 'Enable', 'Off');

set(handles.LLRF5, 'String', '');
set(handles.LLRF5, 'Enable', 'Off');



function LLRFData = LLRFCalibration_DeflectingCavity(LLRFData, handles)

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
LLRFData{ii}.Inp1.ScaleFactor = 1;  %SqrtWatts(4);
LLRFData{ii}.Inp2.ScaleFactor = 1;  %SqrtWatts(1);
LLRFData{ii}.Inp3.ScaleFactor = 1;  %SqrtWatts(2);
LLRFData{ii}.Inp4.ScaleFactor = 1;  %SqrtWatts(3);

% ii = 4;
% LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(5);
% LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(6);
% LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(7);
% LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(8);
% 
% ii = 3;
% LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(9);
% LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(10);
% LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(11);
% LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(12);
% 
% ii = 5;
% LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(13);
% LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(14);
% LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(15);
% LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(16);
% 
% ii = 2;
% LLRFData{ii}.Inp1.ScaleFactor = SqrtWatts(17);
% LLRFData{ii}.Inp2.ScaleFactor = SqrtWatts(18);
% LLRFData{ii}.Inp3.ScaleFactor = SqrtWatts(19);
% LLRFData{ii}.Inp4.ScaleFactor = SqrtWatts(20);


LLRFData{1}.Prefix = 'L1llrf:';
LLRFData{1}.Inp1.Label = 'Input 1';
LLRFData{1}.Inp2.Label = 'Input 2';
LLRFData{1}.Inp3.Label = 'Input 3';
LLRFData{1}.Inp4.Label = 'Input 4';
set(handles.LLRF1, 'String', 'DCav');

% LLRFData{4}.Prefix = 'llrf2molk1:';
% LLRFData{4}.Inp1.Label = 'Cav A4 FWD';
% LLRFData{4}.Inp2.Label = 'Cav A4 REV';
% LLRFData{4}.Inp3.Label = 'Cav Cell Probe 2';
% LLRFData{4}.Inp4.Label = 'Cav A3 FWD (split)';
set(handles.LLRF2, 'String', '');
set(handles.LLRF2, 'Enable', 'Off');

% LLRFData{3}.Prefix = 'llrf1molk2:';
% LLRFData{3}.Inp1.Label = 'Tetrode A3 FWD';
% LLRFData{3}.Inp2.Label = 'Tetrode A3 REV';
% LLRFData{3}.Inp3.Label = 'Tetrode A4 FWD';
% LLRFData{3}.Inp4.Label = 'Tetrode A4 REV';
set(handles.LLRF3, 'String', '');
set(handles.LLRF3, 'Enable', 'Off');

% LLRFData{5}.Prefix = 'llrf2molk2:';
% LLRFData{5}.Inp1.Label = 'Circ 1 Load FWD';
% LLRFData{5}.Inp2.Label = 'Circ 1 Load REV';
% LLRFData{5}.Inp3.Label = 'Circ 2 Load FWD';
% LLRFData{5}.Inp4.Label = 'Circ 2 Load REV';
set(handles.LLRF4, 'String', '');
set(handles.LLRF4, 'Enable', 'Off');

% LLRFData{2}.Prefix = 'llrf1molk1:';
% LLRFData{2}.Inp1.Label = 'SSPA A1 FWD';
% LLRFData{2}.Inp2.Label = 'SSPA A1 REV';
% LLRFData{2}.Inp3.Label = 'SSPA A2 FWD';
% LLRFData{2}.Inp4.Label = 'SSPA A2 REV';
set(handles.LLRF5, 'String', '');
set(handles.LLRF5, 'Enable', 'Off');


% save after a calibration change (I'll do every standalone launch for now)
%if isdeployed
%    save('/remote/apex/hlc/matlab/machine/APEX/Gun/LLRFDataStructure','LLRFData');
%end



% Deflecting Cavity
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

PowerReal = getpvonline([LLRFData{1}.Prefix, 'source_re_ao']);
PowerImag = getpvonline([LLRFData{1}.Prefix, 'source_im_ao']);

 % Pulse length in EPICS is 10ns / unit
 
TimeScaleCalFactor = 1;
    
PulseLength = getpvonline([LLRFData{1}.Prefix, 'pulse_length_ao'])*10/(TimeScaleCalFactor*1e6);

% Repetition period in EPICS is 20ns / unit  -> should be 10 ns/unit???
RepPeriod = getpvonline([LLRFData{1}.Prefix, 'rep_period_ao'])*10/(TimeScaleCalFactor*1e6);
PulsedModeFlag=0;
if PulseLength < RepPeriod
    PulsedModeFlag = 1;
end

%PulseLength = str2num(get(handles.PulseLength, 'String'));
%RepPeriod   = str2num(get(handles.RepPeriod, 'String'));

% Check the requested power
if 0  % ProblemDetected
    ShutOffDrivePower(handles);
else
    % Goto requested power
    PowerReal = get(handles.PowerReal, 'UserData');
    PowerImag = get(handles.PowerImag, 'UserData');
    
    if ~isempty(PowerReal) && isnumeric(PowerReal)
        setpvonline([LLRFData{1}.Prefix, 'source_re_ao'], PowerReal);
        set(handles.PowerReal, 'UserData', []);
    end
    if ~isempty(PowerImag) && isnumeric(PowerImag)
        setpvonline([LLRFData{1}.Prefix, 'source_im_ao'], PowerImag);
        set(handles.PowerImag, 'UserData', []);
    end

end


function ShutOffDrivePower(handles)
LLRFData = getappdata(handles.figure1, 'LLRFData');

fprintf('IT GOES!\n');

PowerReal = getpvonline([LLRFData{1}.Prefix, 'source_re_ao']);
PowerImag = getpvonline([LLRFData{1}.Prefix, 'source_im_ao']);

setpvonline([LLRFData{1}.Prefix, 'source_im_ao'], 0);
set(handles.PowerImag,  'String', '0');
set(handles.PowerPhase, 'String', '0');

if PowerReal==0
    % Set it again just to make sure the PV had processed
    setpvonline([LLRFData{1}.Prefix, 'source_re_ao'], 0);
else
    pwr0 = abs(getpvonline([LLRFData{1}.Prefix, 'source_re_ao']));
    pwr  = pwr0:-1000:0;
    
    if ~round(pwr(end))
        fprintf('   Ramping down power\n');
    end
    
    for i = 2:length(pwr)
        setpvonline([LLRFData{1}.Prefix, 'source_re_ao'], round(pwr(i)));
        set(handles.PowerReal, 'String', num2str(round(pwr(i))));
        set(handles.PowerMag,  'String', num2str(round(pwr(i))));
        fprintf('   Driver set to %5d ADC [counts]\n', round(pwr(i)));
        pause(.2);
    end
    setpvonline([LLRFData{1}.Prefix, 'source_re_ao'], 0);
    if round(pwr(end))
        fprintf('   Driver set to 0 ADC [counts]\n');
    end
end

set(handles.PowerReal, 'String', '0');
set(handles.PowerMag,  'String', '0');
set(handles.PowerReal, 'UserData', []);
set(handles.PowerImag, 'UserData', []);


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
