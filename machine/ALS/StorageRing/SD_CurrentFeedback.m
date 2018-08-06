function varargout = SD_CurrentFeedback(varargin)
% SD_CURRENTFEEDBACK MATLAB code for SD_CurrentFeedback.fig
%      SD_CURRENTFEEDBACK, by itself, creates a new SD_CURRENTFEEDBACK or raises the existing
%      singleton*.
%
%      H = SD_CURRENTFEEDBACK returns the handle to a new SD_CURRENTFEEDBACK or the handle to
%      the existing singleton*.
%
%      SD_CURRENTFEEDBACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SD_CURRENTFEEDBACK.M with the given input arguments.
%
%      SD_CURRENTFEEDBACK('Property','Value',...) creates a new SD_CURRENTFEEDBACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SD_CurrentFeedback_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SD_CurrentFeedback_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SD_CurrentFeedback

% Last Modified by GUIDE v2.5 10-Apr-2012 12:39:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SD_CurrentFeedback_OpeningFcn, ...
                   'gui_OutputFcn',  @SD_CurrentFeedback_OutputFcn, ...
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


% --- Executes just before SD_CurrentFeedback is made visible.
function SD_CurrentFeedback_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SD_CurrentFeedback (see VARARGIN)

% Choose default command line output for SD_CurrentFeedback
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SD_CurrentFeedback wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% Check if the AO exists (this is required for stand-alone applications)
checkforao;

% Setup graph
hplot = plot(handles.axes1, NaN, NaN, '.-');
set(handles.LoopOff, 'UserData', hplot);
set(handles.axes1, 'XLim', [0 4]);
set(handles.axes1, 'YLimMode', 'Auto');
xlabel('SD [Amps]');
ylabel('Time [Seconds]');


% Fix the setpoint goal
[SPGoal, t, DataTime] = getsp('SD', [1 1]);
set(handles.LoopOn, 'UserData', SPGoal);


set(handles.OutlierText, 'String', '');


% Setup Timer
UpdatePeriod = 2.1;

t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@SD_Feedback_Callback, handles});
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'SD_Feedback_Timer');

%thehandles.TimerHandle = t;
%guidata(hMainFigure,thehandles);

drawnow;
set(handles.figure1, 'Visible', 'On');
start(t);


function varargout = SD_Feedback_Callback(hObject, eventdata, handles)

if isempty(handles)
    return
end

LoopGain = .3;

LoopControl = get(handles.LoopOn, 'Value');

% Plot all the time
hplot = get(handles.LoopOff, 'UserData');
[sp, t, DataTime] = getsp('SD', [1 1]);
[am,t] = getam('SD', [1 1], 0:.1:4);
set(hplot, 'XData', t, 'YData', am);
set(handles.TimeStamp, 'String', datestr(DataTime(1),31));

% NaN
if any(isnan(am))
    set(handles.OutlierText, 'String', 'Monitor data had a NaN in it!');
    return;
end

% Outlier removal
RMSam = std(am);
i = find(abs(am-mean(am)) > 2*RMSam);
if isempty(i)
    set(handles.OutlierText, 'String', '');
else
    am(i) = [];
    set(handles.OutlierText, 'String', sprintf('%d outliers removed',length(i)));
    
    if isempty(am)
        set(handles.OutlierText, 'String', 'All outliers!!!');
        return;
    end
end


if mean(am) < 30
    % Turn off loop
    set(handles.LoopOn,  'Value', 0);
    set(handles.LoopOff, 'Value', 1);
    LoopControl = 0;
    set(handles.OutlierText, 'String', 'SD current too low for feedback!');
end


if LoopControl    
    SPGoal = get(handles.LoopOn, 'UserData');
    SP_AM_Offset = .0755;
    
    AMGoal = SPGoal - SP_AM_Offset;
    Err = AMGoal - mean(am);
    
    setsp('SD', sp + LoopGain*Err, [1 1]);
else
    % Reread the setpoint goal incase it changed
    [SPGoal, t, DataTime] = getsp('SD', [1 1]);
    set(handles.LoopOn, 'UserData', SPGoal);
end



% --- Outputs from this function are returned to the command line.
function varargout = SD_CurrentFeedback_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles)
    varargout{1} = handles.output;
end
