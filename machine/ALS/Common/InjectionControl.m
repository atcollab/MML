function varargout = InjectionControl(varargin)
% INJECTIONCONTROL MATLAB code for InjectionControl.fig
%      INJECTIONCONTROL, by itself, creates a new INJECTIONCONTROL or raises the existing
%      singleton*.
%
%      H = INJECTIONCONTROL returns the handle to a new INJECTIONCONTROL or the handle to
%      the existing singleton*.
%
%      INJECTIONCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INJECTIONCONTROL.M with the given input arguments.
%
%      INJECTIONCONTROL('Property','Value',...) creates a new INJECTIONCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InjectionControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InjectionControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InjectionControl

% Last Modified by GUIDE v2.5 11-Feb-2015 23:53:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InjectionControl_OpeningFcn, ...
                   'gui_OutputFcn',  @InjectionControl_OutputFcn, ...
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


% --- Executes just before InjectionControl is made visible.
function InjectionControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InjectionControl (see VARARGIN)

% Choose default command line output for InjectionControl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InjectionControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% Check if the AO exists (this is required for stand-alone applications)
checkforao;


% % Setup Timer
% UpdatePeriod = 0.5;
% t = timer;
% handles.Timer = t;
% set(t, 'StartDelay', 0);
% set(t, 'Period', UpdatePeriod);
% set(t, 'TimerFcn', {@InjectionTimer,handles});
% set(t, 'BusyMode', 'drop');  %'queue'
% set(t, 'TasksToExecute', Inf);
% %set(t, 'TasksToExecute', 50);
% %set(t, 'ErrorFcn', {@Timer_Error,handles});
% set(t, 'ExecutionMode', 'FixedRate');
% set(t, 'Tag', 'ImageGrabTimer');
% 
% % Update handles structure
% guidata(hObject, handles);
% 
% % Start timer
% start(handles.Timer);



% --- Outputs from this function are returned to the command line.
function varargout = InjectionControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)

if get(hObject,'Value') == 0
    return
end

TimeFormat = 'HH:MM:SS.FFF';

fprintf('Enter:  %s\n', datestr(now, TimeFormat));





% Output port name eg FP0, FPUV1, or RB00
% FP  - Front panel
% FPUV - Front panel universal, fine delay FPUV0 FPUV1
% RB  - Rear transistion board

% DlyGen -> Pulser

% Basename like S0817:EVR1-DlyGen:0:
%    Delay-SP -RB   -> Delay [ticks]
%    Width-SP -RB   -> PulseWidth [usec]
%    Ena-Sel        -> 0-Disable, 1-Enable
%    Polarity-Sel   -> Polarity:  0-Active High, 1-Active Low?
%    Evt:Trig0-SP   -> Event number


% KI Enable, delay, and trigger width 
getpv('S0817:EVR1-DlyGen:0:Evt:Trig0-SP')         %  -> set to 11 in db, but it's 30 now 
getpv('S0817:EVR1-DlyGen:0:Ena-Sel')
getpv('S0817:EVR1-DlyGen:0:Delay-SP')
getpv('S0817:EVR1-DlyGen:0:Width-SP')             % = 0.0960 usec
getpv('S0817:EVR1-DlyGen:0:Width-RB')             % = 0.0961 usec
getpv('S0817:EVR1-DlyGen:0:Polarity-Sel')         % = 0
getpv('S0817:EVR1-Out:FPUV0:Src:Pulse-SP','char') % = 0 or Pulser 0
getpv('S0817:EVR1-Out:UDC0:Delay-SP')             % Fine delay [inits???]

% KI Scope
getpv('S0817:EVR1-DlyGen:2:Evt:Trig0-SP')         % 30
getpv('S0817:EVR1-DlyGen:2:Ena-Sel')
getpv('S0817:EVR1-Out:FP0:Src:Pulse-SP', 'char')  % = 2 or Pulser 2

% GTB CCD
getpv('S0817:EVR1-DlyGen:3:Evt:Trig0-SP')         % 14
getpv('S0817:EVR1-DlyGen:3:Ena-Sel')
getpv('S0817:EVR1-Out:FP1:Src:Pulse-SP', 'char')  % = 3 or Pulser 3

% Prog 1
getpv('S0817:EVR1-Out:FPUV1:Src:Pulse-SP','char') % = 1 or Pulser 1

% Linac Modulator Scope
getpv('LI11:EVR1-DlyGen:9:Evt:Trig0-SP')         % 12
getpv('LI11:EVR1-DlyGen:9:Ena-Sel')
getpv('LI11:EVR1-Out:RB01:Src:Pulse-SP','char') % = 9 or Pulser 9


% CALC Fix
%  getpvonline('TimTargetBucketDelay.CALC','char')
%      31.25 * ((21 * A)%328)
%%setpvonline('TimTargetBucketDelay.CALC','31.25*((21*(A-1))%328)', 'char');


% Start
set(hObject, 'String', 'Push to Stop');

PV_TimSeq_Start    = 'LI11<EVR1>EvtACnt-I';
PV_TimSeq_PreInj   = 'LI11<EVR1>EvtBCnt-I';
PV_TimSeq_PreExtr  = 'LI11<EVR1>EvtCCnt-I';
PV_TimSeq_PostExtr = 'LI11<EVR1>EvtDCnt-I';
PV_TimSeq_End      = 'LI11<EVR1>EvtECnt-I';

PV_TimSeq = [
    'LI11<EVR1>EvtACnt-I';
    'LI11<EVR1>EvtBCnt-I';
    'LI11<EVR1>EvtCCnt-I';
    'LI11<EVR1>EvtDCnt-I';
    'LI11<EVR1>EvtECnt-I';];


% Start monitor
if getpv('SR01C___TIMING_AC11') == 0 && getpv('SR01C___TIMING_AC13') == 0
    % Manual mode
    TargetBucketPV = 'SR01C___TIMING_AM08';
else
    % Table mode
    TargetBucketPV = 'SR01C___TIMING_AM14';
end

lcaSetMonitor(TargetBucketPV);
lcaSetMonitor(PV_TimSeq_PostExtr);

t0 = clock;
DCCT0 = getdcct;

i = 0;
BreakFlag = 0;
[TargetBucket0, tmp, TargetBucket_TS] = getpv(TargetBucketPV);
setpvonline('TimTargetBucketNumber', TargetBucket0);
set(handles.BucketNumberTime, 'String', datestr(TargetBucket_TS, TimeFormat));
set(handles.BucketNumber,     'String', num2str(TargetBucket0));


TargetBucket = 0;

% setpvonline('LI11<EVG1-SoftSeq:1>Disable-Cmd', 1, 'double', 1);
% pause(.5);
% setpvonline('LI11<EVG1-SoftSeq:1>Enable-Cmd', 1, 'double', 1);


while 1
    
    % Line up to Post Extraction
    %lcaNewMonitorWait();  % Times out???
    while ~lcaNewMonitorValue(PV_TimSeq_PostExtr)
        if get(hObject,'Value') == 0
            BreakFlag = 1;
            break
        end
        pause(.05);
    end
    if BreakFlag
        break;
    end
    
    if 0
        % Timing sequencer 
        setpvonline('LI11<EVG1-SoftSeq:1>Disable-Cmd', 1, 'double', 1);
       % pause(.1);
        setpvonline('LI11<EVG1-SoftSeq:1>Enable-Cmd', 1, 'double', 1);
        
       % setpvonline('LI11<EVG1-SoftSeq:1>Disable-Cmd', 0);
       % setpvonline('LI11<EVG1-SoftSeq:1>Enable-Cmd', 0);

        set(handles.BucketNumberTime, 'String', datestr(now, TimeFormat));
        
    elseif 0
        % Change the target bucket
        TargetBucket = TargetBucket + 1;
        if TargetBucket > 300
            TargetBucket = 1;
        end
        setpvonline('SR01C___TIMING_AC08',   TargetBucket);
        pause(.8);
        setpvonline('TimTargetBucketNumber', TargetBucket);
        
        set(handles.BucketNumberTime, 'String', datestr(TargetBucket_TS, TimeFormat));
    else
        % Target bucket PV might change
        if getpv('SR01C___TIMING_AC11') == 0 && getpv('SR01C___TIMING_AC13') == 0
            % Manual mode
            [TargetBucket, tmp, TargetBucket_TS] = getpv('SR01C___TIMING_AM08');
        else
            % Table mode
            [TargetBucket, tmp, TargetBucket_TS] = getpv('SR01C___TIMING_AM14');
        end
        
        [TargetBucket, tmp, TargetBucket_TS] = getpv(TargetBucketPV);
        
        if TargetBucket0 ~= TargetBucket
            setpvonline('TimTargetBucketNumber', TargetBucket);
            TargetBucket0 = TargetBucket;
            set(handles.BucketNumberTime, 'String', datestr(TargetBucket_TS, TimeFormat));
        end
    end
    
    set(handles.BucketNumber, 'String', num2str(TargetBucket));
    
    [PostCounter, tmp, PostTime] = getpv(PV_TimSeq_PostExtr);
    set(handles.PostCounter, 'String', sprintf('%d',PostCounter));
    set(handles.PostTime,    'String', datestr(PostTime, TimeFormat));

    %[a, ta, Start_TS]    = getpv(PV_TimSeq_Start);
    %[b, tb, PreInj_TS]   = getpv(PV_TimSeq_PreInj);
    %[c, tb, PreExtr_TS]  = getpv(PV_TimSeq_PreExtr);
    %[d, tb, PostExtr_TS] = getpv(PV_TimSeq_PostExtr);
    %[e, tb, End_TS]      = getpv(PV_TimSeq_End);
    
    DCCT = getdcct;
        
    if get(hObject,'Value') == 0
        BreakFlag = 1;
        break
    end
    
 %   pause(.1);
    i = i + 1;
    fprintf('Running: %s\n', datestr(now, TimeFormat));

end

set(hObject, 'String', 'Push to Start');


% Clear monitor
lcaClear(TargetBucketPV);
lcaClear(PV_TimSeq_PostExtr);

fprintf('Exit:   %s\n', datestr(now, TimeFormat));
