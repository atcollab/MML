function varargout = ICT_Scopes(varargin)
% ICT_SCOPES M-file for ICT_Scopes.fig
%      ICT_SCOPES, by itself, creates a new ICT_SCOPES or raises the existing
%      singleton*.
%
%      H = ICT_SCOPES returns the handle to a new ICT_SCOPES or the handle to
%      the existing singleton*.
%
%      ICT_SCOPES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ICT_SCOPES.M with the given input arguments.
%
%      ICT_SCOPES('Property','Value',...) creates a new ICT_SCOPES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ICT_Scopes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ICT_Scopes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ICT_Scopes

% Last Modified by GUIDE v2.5 23-Feb-2011 19:31:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ICT_Scopes_OpeningFcn, ...
                   'gui_OutputFcn',  @ICT_Scopes_OutputFcn, ...
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


% --- Executes just before ICT_Scopes is made visible.
function ICT_Scopes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ICT_Scopes (see VARARGIN)

% Choose default command line output for ICT_Scopes
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ICT_Scopes wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%%%%%%%%%%%%%%%%%%%%%%
% Location on Screen %
%%%%%%%%%%%%%%%%%%%%%%
ScreenDefault = get(0, 'Units');
AppDefault = get(hObject, 'Units');

set(0, 'Units', 'Pixels');
set(hObject, 'Units', 'Pixels');

ScreenSize = get(0, 'ScreenSize');
AppSize = get(hObject, 'Position');

% Set the application location
set(hObject, 'Position', [275 (ScreenSize(4)-AppSize(4)-600) AppSize(3) AppSize(4)]);

set(0, 'Units', ScreenDefault);
set(hObject, 'Units', AppDefault);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if already open so multiple timers don't get started %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(get(handles.TimeStamp1,'string'))
    fprintf('   BR scopes already open\n');
    return
end


%%%%%%%%%%%%%%%
% Setup Timer %
%%%%%%%%%%%%%%%
UpdatePeriod = .2;

FirstPoint.A = Inf; 
FirstPoint.B = Inf; 
FirstPoint.C = Inf; 
FirstPoint.D = Inf; 
setappdata(handles.figure1, 'FirstPoint', FirstPoint);


t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
%set(t, 'TimerFcn', 'ICT_Scopes(''OneShot_Callback'', getfield(get(timerfind(''Tag'',''PlotFamilyTimer''),''Userdata''),''figure1''), [], get(timerfind(''Tag'',''PlotFamilyTimer''),''Userdata''));');
set(t, 'TimerFcn', ['brscopes(''Timer_Callback'',', sprintf('%.30f',handles.figure1), ',',sprintf('%.30f',handles.figure1), ', [])']);
set(t, 'StartFcn', ['brscopes(''Timer_Start'',', sprintf('%.30f',handles.figure1), ',',sprintf('%.30f',handles.figure1), ', [])']);
set(t, 'UserData', handles);
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'BRScopesTimer');

handles.TimerHandle = t;

% Save handles
setappdata(handles.figure1, 'HandleStructure', handles);

set(handles.figure1, 'Name', 'Booster RF Ramp and Booster & BTS ICT Scopes');

start(t);


% try
%     % Turn off updating by deleting timer handle
%     h = get(handles.figure1, 'UserData');
%     stop(h.TimerHandle);
%     delete(h.TimerHandle);
%     h = rmfield(h, 'TimerHandle');
%     set(handles.figure1, 'UserData', h);
%     
%     % Delete all timers
%     %h = timerfind('Tag','PlotFamilyTimer');
%     %for i = 1:length(h)
%     %    stop(h(i));
%     %    delete(h(i));
%     %end
%     
%     % Change OnOff label string
%     set(handles.OnOff, 'String', 'Continuous');
% catch
%     fprintf('   Trouble stopping the timer.\n');
% end



function varargout = Timer_Start(hObject, eventdata, handles)

FontSize = 12;

handles = getappdata(hObject, 'HandleStructure');

T = 10;  % usec
N = 500;

t = linspace(0, T, N);

handles.Graph1_Axes = plot(handles.Graph1, t, [NaN*t(:) NaN*t(:)]);
ylabel(handles.Graph1, 'Booster RF', 'FontSize', FontSize);
%xlabel(handles.Graph1, 'Time [\museconds]', 'FontSize', FontSize);
set(handles.Graph1, 'XLim', [0 T]);
set(handles.Graph1, 'XTickLabel', []);

% a = axis(handles.Graph1_Axes(1));
% axis(handles.Graph1_Axes, 'tight'); 
% a = axis(handles.Graph1);
% axis(handles.Graph1, [AxisRange1X(1) AxisRange1X(2) a(3) a(4)]);

% % Set defaults
% h = plot(handles.Graph1, sx, [Data1(:) Data3(:)],'.-');
% set(h(1),'Color','b');
% set(h(2),'Color','r');
% 
% set(handles.Graph1, 'Nextplot',      'Add');
% set(handles.Graph1, 'YGrid',         'On');
% set(handles.Graph1, 'YMinorTick',    'On');
% set(handles.Graph1, 'XMinorTick',    'On');
% set(handles.Graph1, 'XAxisLocation', 'Bottom');
% set(handles.Graph1, 'XTickLabel',    '');


setappdata(handles.figure1, 'HandleStructure', handles);



function varargout = Timer_Callback(hObject, eventdata, handles)

handles = getappdata(hObject, 'HandleStructure');

FirstPoint = getappdata(handles.figure1, 'FirstPoint');

% Check the first point before getting the whole waveform
NewPoint = getpvonline('BR1_____ICT1___AT00', 'double', 1);
if FirstPoint.A ~= NewPoint
    [Data, tmp, DataTime] = getpvonline('BR1_____ICT1___AT00');
    set(handles.Graph1_Axes(1), 'YData', Data);
    
    DataTime = EPICS2MatlabTime(DataTime);
    Time = datestr(DataTime, 'dd-mmm-yyyy HH:MM:SS.FFF');
    set(handles.TimeStamp1, 'String', Time);
    
    FirstPoint.A = NewPoint;
    drawnow;
end

NewPoint = getpvonline('BTS_____ICT2___AT00', 'double', 1);
if FirstPoint.B ~= NewPoint
    [Data, tmp, DataTime] = getpvonline('BTS_____ICT2___AT00');
    set(handles.Graph1_Axes(2), 'YData', Data);
    
    DataTime = EPICS2MatlabTime(DataTime);
    Time = datestr(DataTime, 'dd-mmm-yyyy HH:MM:SS.FFF');
    set(handles.TimeStamp2, 'String', Time);
    
    FirstPoint.B = NewPoint;
    drawnow;
end

setappdata(handles.figure1, 'FirstPoint', FirstPoint);



% --- Outputs from this function are returned to the command line.
function varargout = ICT_Scopes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = []; %handles.output;




% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% If timer is on, then turn it off by deleting the timer handle
try
    h = getappdata(handles.figure1, 'HandleStructure');
    if isfield(h,'TimerHandle')
        stop(h.TimerHandle);
        delete(h.TimerHandle);
    end
catch
    fprintf('   Trouble stopping the timer on exit.\n');
end


function DataTime = EPICS2MatlabTime(DataTime)
t0 = clock;
DateNumber1970 = 719529;  %datenum('1-Jan-1970');
days = datenum(t0(1:3)) - DateNumber1970;
t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);

        
