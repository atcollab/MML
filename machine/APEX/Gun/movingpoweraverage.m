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

% Last Modified by GUIDE v2.5 10-Nov-2011 14:39:45

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
    
    %  Stop the timer
    if isfield(handles,'TimerHandle')
        stop(handles.TimerHandle);
        delete(handles.TimerHandle);
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


% LLRF Defaults  AOs
LLRF_Defaults = {
    'ch_keep_ao', 4080
   % 'ddsa_phstep_h_ao', 149796
    'ddsa_phstep_l_ao', 2340
    'ddsa_modulo_ao', 1
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
    'pulse_boundary_bo', 1
    };
for ii = 1:length(LLRFData)
    LLRF_Prefix = LLRFData{ii}.Prefix;
    for jj = 1:size(LLRF_Defaults,1)
        ChannelName = [LLRF_Prefix, LLRF_Defaults{jj,1}];
        try
            PreSet = getpvonline(ChannelName, 'double');
            NewSP = LLRF_Defaults{jj,2};
            if iscell(NewSP)
                NewSP = NewSP{ii};
            end
            if PreSet ~= NewSP
                fprintf('   %s was %d setting to %d\n', ChannelName, PreSet, NewSP);
                setpvonline(ChannelName, NewSP);
            end
        catch
            fprintf('%s\n', lasterr);
        end
    end
end

%getpv('llrf1:permit2_mask_bo')

% Wave shift removed
%WaveShift = getpvonline('llrf1:wave_shift_ao');
%set(handles.WaveShift, 'Value', WaveShift);



% RFPLC setup
RFPLC.Prefix = 'Gun:RF:';

RFPLC.State.ChanneNames = {
    };

RFPLC.Interlock.ChanneNames = {
    'Cav_ArcDet'
    'Circ1_ArcDet'
    'Circ2_ArcDet'
    'Window1_ArcDet'
    'Window2_ArcDetDet'
    
    'SSPA_A1_FWD_Pwr'
    'SSPA_A1_REV_Pwr'
    'SSPA_A2_FWD_Pwr'
    'SSPA_A2_REV_Pwr'
    'Tetrode_A3_FWD_Pwr'
    'Tetrode_A3_REV_Pwr'
    'Tetrode_A4_FWD_Pwr'
    'Tetrode_A4_REV_Pwr'
    'Cplr2_A4_FWD_Pwr'
    'Cplr2_A4_REV_Pwr'
    
    'Cav_Probe_2_Pwr'
    
    'Circ1_Load_FWD_Pwr'
    'Circ1_Load_REV_Pwr'
    'Circ2_Load_FWD_Pwr'
    'Circ2_Load_REV_Pwr'
    
    'Circ1_TCU_Booting'
    'Circ1_TCU_OK'
    'Circ1_Error_Coil_Discon'
    'Circ1_Error_Tin_Hi'
    'Circ1_Error_Tin_Lo'
    'Circ1_Error_Tamb_Lo'
    'Circ1_Error_DeltaT_Hi'
    
    'Circ2_TCU_Booting'
    'Circ2_TCU_OK'
    
    'Circ2_Error_Coil_Discon'
    'Circ2_Error_DeltaT_Hi'
    'Circ2_Error_Tamb_Lo'
    'Circ2_Error_Tin_Hi'
    'Circ2_Error_Tin_Lo'
    
    'FastFeeder_RFPermit2'
    };


% 'Window1_ArcDetPS'
% 'Window2_ArcDetPS'
% 'Cav_ArcDetPS'
% 'Circ1_ArcDetPS'
% 'Circ2_ArcDetPS'
%
% 'ArcDet6'
% 'ArcDet7'
% 'ArcDet8'
% 'ArcDet6PS'
% 'ArcDet7PS'
% 'ArcDet8PS'
%
% 'Pwr12'

%'Channel_8_Spare'


RFPLC.Flows.ChanneNames = {
    'Cav_1_3_4_Anode_2_Flow'
    'Cav_2_5_Anode_1_Flow'
    'Cav_Nose_Cone_Flow'
    'Cav_Wall_Outlet_Flow'
    'Circ1_Flow_TX'
    'Circ1_RF_Load_Flow'
    'Circ2_Flow_TX'
    'Circ2_RF_Load_Flow'
    'Int_Solenoid_Outlet_Flow'
    'Window_Coupler_Outlet_Flow'
    };

RFPLC.Temperatures.ChanneNames = {
    'Cav_1_3_4_Anode_2_Outlet_Temp'
    'Cav_2_5_Anode_1_Outlet_Temp'
    'Cav_Nose_Cone_Outlet_Temp'
    'Cav_Wall_Outlet_Temp'
    'Circ1_Outlet_Temp'
    'Circ1_RF_Load_Outlet_Temp'
    'Circ2_Outlet_Temp'
    'Circ2_RF_Load_Outlet_Temp'
    'Int_Solenoid_Outlet_Temp'
    'Window_Coupler_Outlet_Temp'
    
    'LCW_Supply_Temp'
    'Cav_LCW_Supply_Temp'
    };

% 'Net23_AI_Spare_6
% 'Net23_AI_Spare_7'
% 'Net23_AI_Spare_8'
% 'Net24_AI_Spare_8'
% 'Net24_AI_Spare_9'
% 'Net24_AI_Spare_10'
% 'Net24_AI_Spare_11'
% 'Net24_AI_Spare_12'
% 'Net24_AI_Spare_13'
% 'Net24_AI_Spare_14'
% 'Net24_AI_Spare_15'
% 'Net24_AI_Spare_16'


RFPLC.Vacuum.ChanneNames = {
    'Cav_Vacuum'
    };


% 'Cir12_TCU_Intlk_Sum_ctrl'
% 'Cir12_TCU_St_Sum_ctrl'
% 'Cav_Cooling_Intlk_Sum_ctrl'
% 'Cav_Cooling_St_Sum_ctrl'
% 'Cav_Vac_Intlk_Sum_ctrl'
% 'Cav_Vac_St_Sum_ctrl'
% 'Feeder_Cooling_Intlk_Sum_ctrl'
% 'Feeder_Cooling_St_Sum_ctrl'
% 'RSS_Chain_A_Status_intlk_ctrl'
% 'RSS_Chain_A_ctrl'
% 'RSS_Chain_B_Status_intlk_ctrl'
% 'RSS_Chain_B_ctrl'
% 'Fast_Feeder_RF_Permit_RF_Status'
% 'Fast_Feeder_RF_Permit_RF_Status_intlk'
% 'RF_EPS_OK_Permit_RF_ctrl'
% 'RSS_OK_Permit_RF'
% 'ArcCavity'
% 'ArcCirculator1'
% 'ArcCirculator2'
% 'ArcWindow1'
% 'ArcWindow2'


Fields = {'State','Interlock','Flows','Temperatures','Vacuum'};

for jj = 1:length(Fields)
    RFPLC.(Fields{jj}).GoodData = ones(length(RFPLC.(Fields{jj}).ChanneNames),1);
end

% % RFPLC = getpv_local(RFPLC);


% % % Initialize the counters (should be a separate channel name list)
% % for ii = 1:length(RFPLC.ChanneNames)
% %     if ~isempty(strfind(RFPLC.ChanneNames{ii}, 'Intlk'))
% %         RFPLC.Counter.(RFPLC.ChanneNames{ii}) = 0;
% %         set(handles.([RFPLC.ChanneNames{ii},'Counter']), 'String', num2str(RFPLC.Counter.(RFPLC.ChanneNames{ii})));
% %     end
% % end

setappdata(handles.figure1, 'RFPLC', RFPLC);


% One shot to setup up the ylabels
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
function varargout = LLRF_Timer_Callback(hObject, eventdata, handles)

% This handles copy has the timer and line handles added
%handles = getappdata(0, 'LLRFTimer');

LLRFData = getappdata(handles.figure1, 'LLRFData');

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
    
else
    % Check if pause requested
    if ~get(handles.StartStop, 'Value')
        % Updates stopped
        pause(.25);
        return;
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
            set(handles.LLRFMessage, 'ForegroundColor', [.75 0 0]);
            set(handles.LLRFMessage, 'Visible', 'On');
            set(handles.LLRFMessage, 'String', 'Y-Scale Overflow!');
        elseif LLRFData{ii}.yscale > 32767
            set(handles.LLRFMessage, 'ForegroundColor', [.5 .5 0]);
            set(handles.LLRFMessage, 'Visible', 'On');
            set(handles.LLRFMessage, 'String', 'Y-Scale Overflow!');
        else
            set(handles.LLRFMessage, 'Visible', 'Off');
        end
    end
catch
    fprintf('Problem getting the LLRF1 error conditions.\n');
    fprintf('%s\n', lasterr);
end


% Get all the data - 20x2 waveforms!
for ii = 1:length(LLRFData)
    
    try
        % Check data time so that the real and imag are from the same data
        ReadCounter = 1;
        while ReadCounter
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w1']);
            LLRFData{ii}.Inp1.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp1.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp1.Real.Data = Wave;
            LLRFData{ii}.Inp1.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w2']);
            LLRFData{ii}.Inp1.Imag.ADC_Min = min(Wave);
            LLRFData{ii}.Inp1.Imag.ADC_Max = max(Wave);
            LLRFData{ii}.Inp1.Imag.Data = Wave;
            LLRFData{ii}.Inp1.Imag.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w3']);
            LLRFData{ii}.Inp2.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp2.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp2.Real.Data = Wave;
            LLRFData{ii}.Inp2.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w4']);
            LLRFData{ii}.Inp2.Imag.ADC_Min = min(Wave);
            LLRFData{ii}.Inp2.Imag.ADC_Max = max(Wave);
            LLRFData{ii}.Inp2.Imag.Data = Wave;
            LLRFData{ii}.Inp2.Imag.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w5']);
            LLRFData{ii}.Inp3.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp3.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp3.Real.Data = Wave;
            LLRFData{ii}.Inp3.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w6']);
            LLRFData{ii}.Inp3.Imag.ADC_Min = min(Wave);
            LLRFData{ii}.Inp3.Imag.ADC_Max = max(Wave);
            LLRFData{ii}.Inp3.Imag.Data = Wave;
            LLRFData{ii}.Inp3.Imag.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w7']);
            LLRFData{ii}.Inp4.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp4.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp4.Real.Data = Wave;
            LLRFData{ii}.Inp4.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w8']);
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
        LLRFData{ii}.t = getpvonline([LLRF_Prefix, 'xaxis']);  % ns (int)
        
        % Y-Scale is affected by,
        % 1. Averaging -wave shift (less "averaging" with greater time), changes max time
        %    28 ADC values are summed per wave_samp_per_ao (10 ns each)
        %    What's the ADC sampel rate???
        %    WaveSamplePeriod = getpvonline('llrf1:wave_samp_per_ao');
        % 2. Vertical "gain" - linear on the log scale
        %    WaveShift = getpvonline('llrf1:wave_shift_ao');
        LLRFData{ii}.yscale = getpvonline([LLRF_Prefix, 'yscale']);
        
        
        % Last fault data
        %if get(handles.LastFault, 'Value') == 1
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w1_fault']);
            LLRFData{ii}.Inp1Fault.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp1Fault.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp1Fault.Real.Data = Wave;
            LLRFData{ii}.Inp1Fault.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w2_fault']);
            LLRFData{ii}.Inp1Fault.Imag.ADC_Min = min(Wave);
            LLRFData{ii}.Inp1Fault.Imag.ADC_Max = max(Wave);
            LLRFData{ii}.Inp1Fault.Imag.Data = Wave;
            LLRFData{ii}.Inp1Fault.Imag.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w3_fault']);
            LLRFData{ii}.Inp2Fault.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp2Fault.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp2Fault.Real.Data = Wave;
            LLRFData{ii}.Inp2Fault.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w4_fault']);
            LLRFData{ii}.Inp2Fault.Imag.ADC_Min = min(Wave);
            LLRFData{ii}.Inp2Fault.Imag.ADC_Max = max(Wave);
            LLRFData{ii}.Inp2Fault.Imag.Data = Wave;
            LLRFData{ii}.Inp2Fault.Imag.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w5_fault']);
            LLRFData{ii}.Inp3Fault.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp3Fault.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp3Fault.Real.Data = Wave;
            LLRFData{ii}.Inp3Fault.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w6_fault']);
            LLRFData{ii}.Inp3Fault.Imag.ADC_Min = min(Wave);
            LLRFData{ii}.Inp3Fault.Imag.ADC_Max = max(Wave);
            LLRFData{ii}.Inp3Fault.Imag.Data = Wave;
            LLRFData{ii}.Inp3Fault.Imag.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w7_fault']);
            LLRFData{ii}.Inp4Fault.Real.ADC_Min = min(Wave);
            LLRFData{ii}.Inp4Fault.Real.ADC_Max = max(Wave);
            LLRFData{ii}.Inp4Fault.Real.Data = Wave;
            LLRFData{ii}.Inp4Fault.Real.Time = DataTime;
            
            [Wave, tout, DataTime]= getpvonline([LLRF_Prefix, 'w8_fault']);
            LLRFData{ii}.Inp4Fault.Imag.ADC_Min = min(Wave);
            LLRFData{ii}.Inp4Fault.Imag.ADC_Max = max(Wave);
            LLRFData{ii}.Inp4Fault.Imag.Data = Wave;
            LLRFData{ii}.Inp4Fault.Imag.Time = DataTime;
            
            % needs to be a fault t and yscale ???
            %LLRFData{ii}.t_fault      = getpvonline([LLRF_Prefix, 'xaxis_fault']);  % ns (int)
            %LLRFData{ii}.yscale_fault = getpvonline([LLRF_Prefix, 'yscale_fault']);
            LLRFData{ii}.t_fault      = getpvonline([LLRF_Prefix, 'xaxis']);  % ns (int)
            LLRFData{ii}.yscale_fault = getpvonline([LLRF_Prefix, 'yscale']);
        %end
    catch
        fprintf('Problem getting the LLRF%d waveforms.\n', ii);
        fprintf('%s\n', lasterr);
    end
end


% Save and plot
setappdata(handles.figure1, 'LLRFData', LLRFData);
PlotLLRFWaveforms;


% Update the LLRF1 Channels
try
    % RF Go
    %RFGo = getpvonline('llrf1:rf_go_bo');
    %set(handles.RFGo, 'Value', sprintf('%d',round(PowerReal)));
    
    
    % Power
    PowerReal = getpvonline('llrf1:source_re_ao');
    set(handles.PowerReal, 'String', sprintf('%d',round(PowerReal)));
    
    PowerImag = getpvonline('llrf1:source_im_ao');
    set(handles.PowerImag, 'String', sprintf('%d',round(PowerImag)));
    
    PowerC = PowerReal + 1i*PowerImag;
    set(handles.PowerMag,   'String', sprintf('%.1f',abs(PowerC)));
    set(handles.PowerPhase, 'String', sprintf('%.1f',180*angle(PowerC)));
    
    
    % Pulse length in EPICS is 20ns / unit  -> should be 10 ns/unit???
    PulseLength = getpvonline('llrf1:pulse_length_ao');
    set(handles.PulseLength, 'String', sprintf('%.6f',10*PulseLength/1e6));
    
    % Repetition period in EPICS is 20ns / unit  -> should be 10 ns/unit???
    RepPeriod = getpvonline('llrf1:rep_period_ao');
    set(handles.RepPeriod, 'String', sprintf('%.6f',10*RepPeriod/1e6));
    
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
    fprintf('Problem in the LLRF code section.\n');
    fprintf('%s\n', lasterr);
end


% % try
% %     % RF PLC (Horner) channels
% %     RFPLC_Last = getappdata(handles.figure1, 'RFPLC');
% %     
% %     RFPLC = getpv_local(RFPLC_Last);
% %     for ii = 1:length(RFPLC.ChanneNames)
% %         if isempty(RFPLC.Data.(RFPLC.ChanneNames{ii}))
% %             set(handles.(RFPLC.ChanneNames{ii}), 'String', 'NoData');
% %         elseif RFPLC.Data.(RFPLC.ChanneNames{ii}) == 0
% %             % Fault
% %             set(handles.(RFPLC.ChanneNames{ii}), 'String', 'Fault');
% %             set(handles.(RFPLC.ChanneNames{ii}), 'ForegroundColor', [.5 0 0]);
% %         else
% %             % Ok
% %             set(handles.(RFPLC.ChanneNames{ii}), 'String', 'Good');
% %             set(handles.(RFPLC.ChanneNames{ii}), 'ForegroundColor', [0 .5 0]);
% %         end
% %     end
% %     
% %     Arc.Cavity      = getpvonline('Gun:RF:ArcCavity',      'double');
% %     Arc.Circulator1 = getpvonline('Gun:RF:ArcCirculator1', 'double');
% %     Arc.Circulator2 = getpvonline('Gun:RF:ArcCirculator2', 'double');
% %     Arc.Window1     = getpvonline('Gun:RF:ArcWindow1',     'double');
% %     Arc.Window2     = getpvonline('Gun:RF:ArcWindow2',     'double');
% %     
% %     % Counter: Zero is a fault, New-Last==-1 -> new fault
% %     for ii = 1:length(RFPLC.ChanneNames)
% %         % For latching channels, count
% %         if ~isempty(strfind(RFPLC.ChanneNames{ii}, 'Intlk'))
% %             if (RFPLC.Data.(RFPLC.ChanneNames{ii}) - RFPLC_Last.Data.(RFPLC.ChanneNames{ii})) == -1
% %                 RFPLC.Counter.(RFPLC.ChanneNames{ii}) = RFPLC.Counter.(RFPLC.ChanneNames{ii}) + 1;
% %                 %  if isfield(handles, [RFPLC.ChanneNames{ii},'Counter'])
% %                 set(handles.([RFPLC.ChanneNames{ii},'Counter']), 'String', num2str(RFPLC.Counter.(RFPLC.ChanneNames{ii})));
% %                 %  end
% %             end
% %         end
% %     end
% %     
% %     % RFPLC Errors
% %     ArcCavityPS      = getpvonline('Gun:RF:ArcCavityPS',      'double');
% %     ArcCirculator1PS = getpvonline('Gun:RF:ArcCirculator1PS', 'double');
% %     ArcCirculator2PS = getpvonline('Gun:RF:ArcCirculator2PS', 'double');
% %     ArcWindow1PS     = getpvonline('Gun:RF:ArcWindow1PS',     'double');
% %     ArcWindow2PS     = getpvonline('Gun:RF:ArcWindow2PS',     'double');
% %     
% %     if ArcCavityPS==0 || ArcCirculator1PS==0 || ArcCirculator2PS==0 || ArcWindow1PS==0 || ArcWindow2PS==0
% %         set(handles.RFPLCMessage, 'String', 'Arc Detector Power Supply Error!');
% %         set(handles.RFPLCMessage, 'Visible', 'On');
% %         set(handles.RFPLCMessage, 'ForegroundColor', [.5 0 0]);
% %     else
% %         set(handles.RFPLCMessage, 'String', '');
% %         set(handles.RFPLCMessage, 'Visible', 'Off');
% %         set(handles.RFPLCMessage, 'ForegroundColor', [1 1 1]);
% %     end
% %     
% %     % Vacuum limit 5e-6
% %     Vacuum = getpvonline('Gun:RF:Cav_Vacuum');
% %     set(handles.Vacuum, 'String', sprintf('%.2e',Vacuum));
% %     if Vacuum > 5e-6
% %         % Fault
% %         set(handles.Vacuum, 'ForegroundColor', [.5 0 0]);
% %     else
% %         set(handles.Vacuum, 'ForegroundColor', [0 .5 0]);
% %     end
% %     
% %     % Heartbeat
% % %    RFPLCHeartbeat = getpvonline('siocrfplc:HEARTBEAT');
% % %    set(handles.RFPLCHeartbeat, 'String', sprintf('%d',RFPLCHeartbeat));
% %     
% % catch
% %     fprintf('Problem in the RFPLC code section.\n');
% %     fprintf('%s\n', lasterr);
% % end
% % 
% % drawnow;
% % pause(.1);



function PlotLLRFWaveforms

% This handles copy has the timer and line handles added
handles = getappdata(0, 'LLRFTimer');

if isempty(handles) || ~ishandle(handles.MagPhase)
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


% Time stamp
set(handles.TimeStamp, 'String', datestr(labca2datenum(LLRFData{ii}.(['Inp4',FaultFlag]).Real.Time),'mmmm dd, yyyy  HH:MM:SS.FFF'));


if strcmpi(get(handles.AutoScaleX, 'Checked'), 'On')
    set(handles.axes1, 'XLim', [0 t(end)/1e6]);
end

drawnow;


function RFPLC = getpv_local(RFPLC)

Fields = {'State','Interlock','Flows','Temperatures','Vacuum'};

for jj = 1:length(Fields)
    RFPLC.(Fields{jj}).GoodData = ones(length(RFPLC.(Fields{jj}).ChanneNames),1);
    
    for ii = 1:length(RFPLC.(Fields{jj}).ChanneNames)
        if RFPLC.(Fields{jj}).GoodData(ii)
            try
                RFPLC.(Fields{jj}).Data.(RFPLC.(Fields{jj}).ChanneNames{ii}) = getpvonline([RFPLC.Prefix, RFPLC.(Fields{jj}).ChanneNames{ii}],'double');
            catch
                RFPLC.(Fields{jj}).Data.(RFPLC.(Fields{jj}).ChanneNames{ii}) = [];
                RFPLC.(Fields{jj}).GoodData(ii) = 0;
                fprintf('%s\n', lasterr);
            end
        end
    end
end


function PulseLength_Callback(hObject, eventdata, handles)
PulseLength = str2num(get(handles.PulseLength, 'String'));
if ~isempty(PulseLength)
    PulseLengthSet = round(1e6*PulseLength/10);
    setpv('llrf1:pulse_length_ao', PulseLengthSet);
end
drawnow;


function RepPeriod_Callback(hObject, eventdata, handles)
RepPeriod = str2num(get(handles.RepPeriod, 'String'));
if ~isempty(RepPeriod)
    RepPeriodSet = round(1e6*RepPeriod/10);
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


% --- Executes on button press in RFGO.
function RFGO_Callback(hObject, eventdata, handles)
% Reset all the board?
LLRFData = getappdata(handles.figure1, 'LLRFData');
for ii = 1:length(LLRFData)
    setpvonline([LLRFData{ii}.Prefix, 'rf_go_bo'],1);
end


function PowerReal_Callback(hObject, eventdata, handles)
PowerReal = str2num(get(handles.PowerReal, 'String'));
if ~isempty(PowerReal)
    PowerReal = round(PowerReal);
    if PowerReal > 65535
        PowerReal = 65535;
    elseif PowerReal < 0
        PowerReal = 0;
    end
    setpv('llrf1:source_re_ao', PowerReal);
end
drawnow;


function PowerImag_Callback(hObject, eventdata, handles)
PowerImag = str2num(get(handles.PowerImag, 'String'));
if ~isempty(PowerImag)
    PowerImag = round(PowerImag);
    if PowerImag > 65535
        PowerImag = 65535;
    elseif PowerImag < 0
        PowerImag = 0;
    end
    setpv('llrf1:source_im_ao', PowerImag);
end
drawnow;


function PowerMagPhase_Callback(hObject, eventdata, handles)
PowerMag   = str2num(get(handles.PowerMag,   'String'));
PowerPhase = str2num(get(handles.PowerPhase, 'String'));
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
    if PowerReal > 65535
        PowerReal = 65535;
    elseif PowerReal < 0
        PowerReal = 0;
    end
    if PowerImag > 65535
        PowerImag = 65535;
    elseif PowerImag < 0
        PowerImag = 0;
    end
    setpv('llrf1:source_re_ao', PowerReal);
    setpv('llrf1:source_im_ao', PowerImag);
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
PlotLLRFWaveforms;
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
PlotLLRFWaveforms;
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
PlotLLRFWaveforms;
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
PlotLLRFWaveforms;
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
PlotLLRFWaveforms;
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


% --------------------------------------------------------------------
function PopPlot1_Callback(hObject, eventdata, handles)

a = figure;
b = copyobj(handles.axis1, a);
set(b, 'Position',[0.13 0.11 0.775 0.815]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');
Axis1 = axis;
xlabel(b, 'Time [msec]');

orient portrait


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

%                 D       E       F                               J                                    O
c = [
    18	77.8	-50.0	-3.727	-3.312	47.09	11.10	20.76	20.52	-15.80	NaN	-4.919	-77.759	-0.200	-4.900	-20.501	-25.42	-82.459	77.76	59689.8
    17	77.8	-50.0	-3.800	0.000	NaN	     NaN	24.00	24.21	-15.73	NaN	-8.935	-78.460	-0.450	-5.200	-20.475	-29.41	-83.2	78.46	70145.5
    16	80.8	-47.8	-3.700	0.000	NaN	     NaN	29.30	27.58	-16.34	NaN	-12.963	-80.800	-1.720	-5.900	-20.517	-33.48	-85.0	80.80	120226.4
    NaN	 NaN	  0	     0      0       NaN	     NaN	  NaN  -16.10	-14.85	NaN	 30.000	    NaN	-0.950	-6.300	-20.200	  9.80	  NaN	  NaN	NaN
    
    21	77.8	-50.0	-3.706	0.000	131.75	NaN	24.09	24.13	-2.18	NaN	-22.477	-78.366	-0.530	-18.800	-20.453	-42.93	-96.636	78.37	68643.6
    20	77.8	-50.0	-3.800	0.000	NaN	NaN	24.00	24.05	-1.97	18.59	-22.490	-78.260	-0.410	-18.900	-20.460	-42.95	-96.750	78.26	66988.5
    19	80.8	-50.1	-3.700	0.000	NaN	NaN	26.97	26.92	-3.19	NaN	-25.414	-77.11	-1.680	-19.100	-25.923	-46.02	-99.85	82.43	174984.7
    NaN	77.8	-50.0	-3.727	-3.308	47.09	11.20	20.77	20.57	-0.91	NaN	-20.097	-83.362	-0.440	-19.900	-15.056	-40.47	-97.505	78.05	63752.9
    
    7	77.8	-63.9	-0.561	0.000	-66.28	NaN	13.34	13.37	-2.17	NaN	-12.055	-78.681	-0.850	-19.100	-20.415	-32.47	-96.931	78.68	73807.4
    8	77.8	-64.0	-0.600	0.000	NaN	NaN	13.20	13.17	-1.45	-6.60	-12.039	-78.090	-0.320	-19.300	-20.431	-32.47	-97.070	78.09	64416.9
    9	77.8	-63.6	-0.611	0.000	134.84	NaN	13.59	13.55	-1.90	NaN	-12.110	-78.221	-0.460	-19.000	-20.440	-32.55	-96.761	78.22	66389.6
    10	77.8	-63.8	-0.600	0.000	NaN	NaN	13.40	13.36	-2.22	NaN	-12.010	-78.630	-0.870	-19.300	-20.650	-32.66	-97.060	78.63	72945.8
    
    1	77.8	-50.0	-1.400	0.000	NaN	NaN	26.40	26.43	-2.06	NaN	-25.252	-78.710	-0.880	-19.300	-20.478	-45.73	-97.130	78.71	74301.9
    2	77.8	-50.1	-1.400	0.000	NaN	NaN	26.30	26.26	-2.62	NaN	-23.780	-77.900	-0.140	-18.000	-20.480	-44.26	-95.760	77.90	61659.5
    5	77.8	-50.0	-1.400	0.000	NaN	NaN	26.40	26.36	-2.88	NaN	-23.580	-77.860	-0.100	-17.700	-20.480	-44.06	-95.460	77.86	61094.2
    4	77.8	-50.0	-1.300	0.000	NaN	NaN	26.50	26.43	-2.29	NaN	-24.456	-78.050	-0.320	-18.500	-20.474	-44.93	-96.230	78.05	63826.3
    
    15	64.8	-53.8	-0.462	0.000	-72.44	NaN	10.51	10.46	-1.97	NaN	-8.856	-65.092	-0.370	-18.900	-20.504	-29.36	-83.622	65.09	3230.0
    14	64.8	-50.0	-0.500	0.000	NaN	NaN	14.27	13.97	-1.41	-7.22	-12.700	-64.610	-0.140	-19.200	-20.470	-33.17	-83.670	64.61	2890.7
    13	64.8	-53.7	-0.524	0.000	60.35	NaN	10.55	10.25	-1.68	NaN	-8.705	-64.604	-0.130	-19.100	-20.645	-29.35	-83.574	64.60	2886.7
    12	64.8	-50.0	-0.600	0.000	NaN	NaN	14.17	13.95	-1.46	NaN	-12.650	-64.710	-0.160	-19.200	-20.500	-33.15	-83.750	64.71	2958.0
    ];
% J is 9
% O is 14
% D+E+F is 3:5
CableAttn = c(:,3)+c(:,4)+c(:,5);
dBsum = -c(:,14) + c(:,9) -30 - CableAttn;
Watts = 10.^(dBsum/10);

SqrtWatts = sqrt(Watts);

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
LLRFData{1}.Inp1.Label = 'Laser Freq';
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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
setpv('llrf1:freq_loop_close', get(handles.checkbox1,'Value'));
