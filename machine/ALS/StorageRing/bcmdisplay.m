function varargout = bcmdisplay(varargin)
% BCMDISPLAY MATLAB code for bcmdisplay.fig
%      BCMDISPLAY, by itself, creates a new BCMDISPLAY or raises the existing
%      singleton*.
%
%      H = BCMDISPLAY returns the handle to a new BCMDISPLAY or the handle to
%      the existing singleton*.
%
%      BCMDISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BCMDISPLAY.M with the given input arguments.
%
%      BCMDISPLAY('Property','Value',...) creates a new BCMDISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bcmdisplay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bcmdisplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bcmdisplay

% Last Modified by GUIDE v2.5 13-Apr-2017 09:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bcmdisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @bcmdisplay_OutputFcn, ...
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


% --- Executes just before bcmdisplay is made visible.
function bcmdisplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bcmdisplay (see VARARGIN)

% Choose default command line output for bcmdisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Check if the AO exists (this is required for stand-alone applications)
checkforao;

L = getcircumference;
%s = L*(0:327)/337;
s = 1:328;

% Add a sector menu
% Using a [Straight Arc] nomenclature
Sectors = 12;
if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Sector');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    Extra = 4;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['bcmdisplay(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    for i = 2:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
        set(Menu1,'Callback', ['bcmdisplay(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['bcmdisplay(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-L/Sectors-Extra L]),'],guidata(gcbo))']);

    Extra = 11;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
    set(Menu1,'Callback', ['bcmdisplay(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra]),'],guidata(gcbo))']);
    for i = 2:Sectors
        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
        set(Menu1,'Callback', ['bcmdisplay(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    
    Menu1 = uimenu(Menu0, 'Label', 'All Sectors');
    set(Menu1,'Callback', ['bcmdisplay(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',0,L),'],guidata(gcbo))']);
end


h = drawlattice(0, 1.2, handles.AxesLattice);
set(handles.AxesLattice,'Visible','Off');
set(handles.AxesLattice,'Color','None');
set(handles.AxesLattice,'XMinorTick','Off');
set(handles.AxesLattice,'XMinorGrid','Off');
set(handles.AxesLattice,'YMinorTick','Off');
set(handles.AxesLattice,'YMinorGrid','Off');
set(handles.AxesLattice,'XTickLabel',[]);
set(handles.AxesLattice,'YTickLabel',[]);
set(handles.AxesLattice,'XLim', [0 L]);
set(handles.AxesLattice,'YLim', [-1.5 1.5]);


ha = handles.BunchCurrent;
h    = plot(ha, s, NaN*s, '.-g');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, NaN*s, '.-b');
ylabel(ha, 'Bunch Current [mA]');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LineBunchCurrent = h;

ha = handles.DeltaBunchCurrent;
h    = plot(ha, s, NaN*s, '.-g');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, NaN*s, '.-b');
ylabel(ha, '\Delta Current [mA]');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LineDeltaBunchCurrent = h;

ha = handles.BunchPhase;
h    = plot(ha, s, NaN*s, '.-b');
ylabel(ha, 'Bunch Phase [Deg]');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LineBunchPhase = h;

ha = handles.DeltaBunchPhase;
h    = plot(ha, s, NaN*s, '.-b');
ylabel(ha, '\Delta Phase [Deg]');
%set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LineDeltaBunchPhase = h;

%legend(ha, 'Monitor','Control', 'Location','northeast');
linkaxes([handles.BunchCurrent handles.DeltaBunchCurrent handles.BunchPhase handles.DeltaBunchPhase], 'x');
set(handles.BunchCurrent, 'XLim', [0 328]);

try
    bcm = getbcm('Struct');
    setappdata(handles.figure1, 'BCM', bcm);
catch
    setappdata(handles.figure1, 'BCM', []);
end


% Setup Timer
UpdatePeriod = 1.4;  % Seconds
t = timer;
handles.Timer = t;  % Set here, otherwise Timer field will not be in the timer callback (TimerFcn)
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@BCMDisplay_Timer_Callback,handles});
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
%set(t, 'ErrorFcn', {@BCMDisplay_Timer_Error,handles});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'BCMDisplayTimer');


% Update handles structure
guidata(hObject, handles);

% Draw the figure
set(handles.figure1, 'Visible', 'On');
drawnow expose

Graphs3_Callback(hObject, eventdata, handles);

% Turn the timer on
start(handles.Timer);

% UIWAIT makes bcmdisplay wait for user response (see UIRESUME)
% uiwait(handles.figure1);




function BCMDisplay_Timer_Callback(hObject, eventdata, handles)
%fprintf('Timer callback  %s\n', datestr(now));

try
    bcm  = getbcm('Struct');
catch
    set(handles.AvgPhase,  'String', 'BCM Error.');
    return
end

bcm0 = getappdata(handles.figure1, 'BCM');

set(handles.LineBunchCurrent(1),      'YData', bcm.BunchCurrentPeak);
set(handles.LineBunchCurrent(2),      'YData', bcm.BunchCurrent);

if strcmpi(get(handles.Graphs3, 'Checked'), 'On')
    set(handles.LineDeltaBunchCurrent(1), 'YData', bcm.InjectionBeamCurrent*NaN);
    set(handles.LineDeltaBunchCurrent(2), 'YData', bcm.InjectionBeamCurrent);
else
    set(handles.LineDeltaBunchCurrent(1), 'YData', bcm.BunchCurrentPeak - bcm0.BunchCurrentPeak);
    set(handles.LineDeltaBunchCurrent(2), 'YData', bcm.BunchCurrent - bcm0.BunchCurrent);
end


set(handles.LineBunchPhase(1),        'YData', bcm.BunchPhase);

set(handles.LineDeltaBunchPhase(1),   'YData', bcm.BunchPhase   - bcm0.BunchPhase);

set(handles.TimeOfDay, 'String', datestr(bcm.TimeStamp,31));
%set(handles.DCCT,      'String', sprintf('%6.2f mA', bcm.DCCT));
set(handles.DCCT,      'String', sprintf('%6.2f mA', sum(bcm.BunchCurrent)));


% Set the phase info to the GUI and EPICS (if it's a good measurement)
if isnan(bcm.AvgPhase)
    set(handles.AvgPhase,  'String', 'Phase unclear');
elseif bcm.AvgPhase > 1000
    set(handles.AvgPhase,  'String', 'Bad phase calculation.');
else
    set(handles.AvgPhase,  'String', sprintf('%6.2f Deg', bcm.AvgPhase));
    
    % Create a live PV
    try
        %setpv('Physics9', bcm.AvgPhase);
        setpv('SR1:BCM:AvgPhase',     bcm.AvgPhase);
        
        % Since EPICS can't handle NaN
        bp = bcm.BunchPhase;
        bp(isnan(bcm.BunchPhase)) = -1;
        setpv('SR1:BCM:BunchPhase',   bp);
    catch
    end
end
try
    % Since EPICS can't handle NaN
    bc = bcm.BunchCurrent;
    bc(isnan(bcm.BunchCurrent)) = 0;
    setpv('SR1:BCM:BunchCurrent', bc);
    
    setpv('SR1:BCM:SROC', bcm.t_SROC);  % [nsec]
catch
end


% --- Outputs from this function are returned to the command line.
function varargout = bcmdisplay_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BCMSave.
function BCMSave_Callback(hObject, eventdata, handles)

bcm = getbcm('Struct');
setappdata(handles.figure1, 'BCM', bcm);


function BCMDisplay_CloseRequestFcn(hObject, eventdata, handles)
stop(handles.Timer);
delete(hObject);

% --------------------------------------------------------------------
function CloseMenu_Callback(hObject, eventdata, handles)
selection = questdlg(['Close BCM Display?'],...
                     ['BCM Display ...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
stop(handles.Timer);
delete(handles.figure1)


% --------------------------------------------------------------------
function HorizontalAxisSector_Callback(hObject, eventdata, handles)
a = eventdata;
if length(a) == 2
    L = getcircumference;
    set(handles.AxesLattice,  'XLim', a);
    set(handles.BunchCurrent, 'XLim', a * 328 / L);
else
    fprintf('   Horizontal axis needs to be a 2 element vector.\n');
end


% --------------------------------------------------------------------
function PrintMenu_Callback(hObject, eventdata, handles)
%printdlg(handles.figure1)
set(handles.figure1,'IntegerHandle','On');
printdlg(get(handles.figure1,'Number'));


% --------------------------------------------------------------------
function elogPrint_Callback(hObject, eventdata, handles)
set(handles.figure1,'IntegerHandle','On');
printelog(get(handles.figure1,'Number'));


% --------------------------------------------------------------------
function Graphs2_Callback(hObject, eventdata, handles)

set(handles.Graphs2, 'Checked', 'On');
set(handles.Graphs3, 'Checked', 'Off');
set(handles.Graphs4, 'Checked', 'Off');

set(handles.BunchCurrent, 'XTickLabelMode', 'Auto');
set(handles.BunchPhase,   'XTickLabelMode', 'Auto');

set(handles.BunchCurrent, 'Position', [0.11    0.52    0.8645    0.42]);
set(handles.BunchPhase,   'Position', [0.11    0.0618  0.8634    0.42]);

set(handles.BCMSave, 'Visible', 'Off');

set(handles.LineDeltaBunchCurrent(1), 'Visible', 'Off');
set(handles.LineDeltaBunchCurrent(2), 'Visible', 'Off');
set(handles.LineDeltaBunchPhase(1),   'Visible', 'Off');

set(handles.BunchCurrent,      'Visible', 'On');
set(handles.DeltaBunchCurrent, 'Visible', 'Off');
set(handles.BunchPhase,        'Visible', 'On');
set(handles.DeltaBunchPhase,   'Visible', 'Off');


% --------------------------------------------------------------------
function Graphs3_Callback(hObject, eventdata, handles)

set(handles.Graphs2, 'Checked', 'Off');
set(handles.Graphs3, 'Checked', 'On');
set(handles.Graphs4, 'Checked', 'Off');

ylabel(handles.DeltaBunchCurrent, 'Last Injection [mA]');

set(handles.BunchCurrent,      'XTickLabelMode', 'Auto');
set(handles.DeltaBunchCurrent, 'XTickLabelMode', 'Auto');
set(handles.BunchPhase,        'XTickLabelMode', 'Auto');

set(handles.BunchCurrent,      'Position', [0.11  0.60  0.8645  0.32]);
set(handles.DeltaBunchCurrent, 'Position', [0.11  0.40  0.8645  0.17]);
set(handles.BunchPhase,        'Position', [0.11  0.05  0.8634  0.32]);

set(handles.BCMSave, 'Visible', 'Off');

set(handles.LineDeltaBunchCurrent(1), 'Visible', 'Off');
set(handles.LineDeltaBunchCurrent(2), 'Visible', 'On');
set(handles.LineDeltaBunchPhase(1),   'Visible', 'Off');

set(handles.BunchCurrent,      'Visible', 'On');
set(handles.DeltaBunchCurrent, 'Visible', 'On');
set(handles.BunchPhase,        'Visible', 'On');
set(handles.DeltaBunchPhase,   'Visible', 'Off');

% get(handles.BunchCurrent,      'Position')
% get(handles.DeltaBunchCurrent, 'Position')
% get(handles.BunchPhase,        'Position')
% get(handles.DeltaBunchPhase,   'Position')


% --------------------------------------------------------------------
function Graphs4_Callback(hObject, eventdata, handles)

set(handles.Graphs2, 'Checked', 'Off');
set(handles.Graphs3, 'Checked', 'Off');
set(handles.Graphs4, 'Checked', 'On');

ylabel(handles.DeltaBunchCurrent, '\Delta Current [mA]');

set(handles.BunchCurrent, 'XTickLabel', []);
set(handles.BunchPhase,   'XTickLabel', []);

set(handles.BunchCurrent,      'Position', [0.1137    0.7282    0.8645    0.2002]);
set(handles.DeltaBunchCurrent, 'Position', [0.1137    0.5061    0.8634    0.2002]);
set(handles.BunchPhase,        'Position', [0.1137    0.2840    0.8634    0.2002]);
set(handles.DeltaBunchPhase,   'Position', [0.1137    0.0618    0.8634    0.2002]);

set(handles.BCMSave, 'Visible', 'On');

set(handles.LineDeltaBunchCurrent(1), 'Visible', 'On');
set(handles.LineDeltaBunchCurrent(2), 'Visible', 'On');
set(handles.LineDeltaBunchPhase(1),   'Visible', 'On');

set(handles.BunchCurrent,      'Visible', 'On');
set(handles.DeltaBunchCurrent, 'Visible', 'On');
set(handles.BunchPhase,        'Visible', 'On');
set(handles.DeltaBunchPhase,   'Visible', 'On');
