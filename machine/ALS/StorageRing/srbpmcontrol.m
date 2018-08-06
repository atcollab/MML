function varargout = srbpmcontrol(varargin)
% SRBPMCONTROL MATLAB code for srbpmcontrol.fig
%      SRBPMCONTROL, by itself, creates a new SRBPMCONTROL or raises the existing
%      singleton*.
%
%      H = SRBPMCONTROL returns the handle to a new SRBPMCONTROL or the handle to
%      the existing singleton*.
%
%      SRBPMCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SRBPMCONTROL.M with the given input arguments.
%
%      SRBPMCONTROL('Property','Value',...) creates a new SRBPMCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before srbpmcontrol_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to srbpmcontrol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help srbpmcontrol

% Last Modified by GUIDE v2.5 03-Mar-2017 23:53:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @srbpmcontrol_OpeningFcn, ...
                   'gui_OutputFcn',  @srbpmcontrol_OutputFcn, ...
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


% --- Executes just before srbpmcontrol is made visible.
function srbpmcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to srbpmcontrol (see VARARGIN)


 
% Choose default command line output for srbpmcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Check if the AO exists (this is required for stand-alone applications)
checkforao;

L = getcircumference;
s = getspos('BPM');


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
    set(Menu1,'Callback', ['srbpmcontrol(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    for i = 2:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
        set(Menu1,'Callback', ['srbpmcontrol(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
    set(Menu1,'Callback', ['srbpmcontrol(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-L/Sectors-Extra L]),'],guidata(gcbo))']);

    Extra = 11;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
    set(Menu1,'Callback', ['srbpmcontrol(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra]),'],guidata(gcbo))']);
    for i = 2:Sectors
        Menu1 = uimenu(Menu0, 'Label',sprintf('Straight Section %d',i));
        set(Menu1,'Callback', ['srbpmcontrol(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    
    Menu1 = uimenu(Menu0, 'Label', 'All Sectors');
    set(Menu1,'Callback', ['srbpmcontrol(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',0,L),'],guidata(gcbo))']);
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


%x = [getpv('BPM', 'Apeak') getpv('BPM', 'Bpeak') getpv('BPM', 'Cpeak') getpv('BPM', 'Dpeak')];
%h = plot(handles.AxesADC, s, x);
ha = handles.AxesADC;
h    = plot(ha, s, getpv('BPM', 'Apeak'), '.-b');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, getpv('BPM', 'Bpeak'), '.-g');
h(3) = plot(ha, s, getpv('BPM', 'Cpeak'), '.-r');
h(4) = plot(ha, s, getpv('BPM', 'Dpeak'), '.-c');
ylabel(ha, 'ADC Peak');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LineADC = h;

ha = handles.AxesRF;
h    = plot(ha, s, getpv('BPM', 'A'), '.-b');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, getpv('BPM', 'B'), '.-g');
h(3) = plot(ha, s, getpv('BPM', 'C'), '.-r');
h(4) = plot(ha, s, getpv('BPM', 'D'), '.-c');
ylabel(ha, 'RF Mag');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LineRF = h;

ha = handles.AxesPTLo;
h    = plot(ha, s, getpv('BPM', 'PTLoA'), '.-b');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, getpv('BPM', 'PTLoB'), '.-g');
h(3) = plot(ha, s, getpv('BPM', 'PTLoC'), '.-r');
h(4) = plot(ha, s, getpv('BPM', 'PTLoD'), '.-c');
ylabel(ha, 'PT Low');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LinePTLo = h;

ha = handles.AxesPTHi;
h    = plot(ha, s, getpv('BPM', 'PTHiA'), '.-b');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, getpv('BPM', 'PTHiB'), '.-g');
h(3) = plot(ha, s, getpv('BPM', 'PTHiC'), '.-r');
h(4) = plot(ha, s, getpv('BPM', 'PTHiD'), '.-c');
ylabel(ha, 'PT High');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LinePTHi = h;

ha = handles.AxesAttn;
h    = plot(ha, s, getpv('BPM', 'Attn'),   '.-b');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, getpv('BPM', 'PTAttn'), '.-g');
ylabel(ha, 'Attn');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LineAttn = h;
legend(ha, 'BPM','Pilot Tone', 'Location','northeast');

ha = handles.AxesPTState;
h    = plot(ha, s, getpv('BPM', 'PTStatus'), '.-g');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, getpv('BPM', 'PTControl'), '.b');
ylabel(ha, 'PT State');
set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LinePTState = h;
legend(ha, 'Monitor','Control', 'Location','northeast');

ha = handles.AxesPTOutput;
h    = plot(ha, s, getpv('BPM', 'PTA'), '.-g');
set(ha, 'NextPlot', 'Add');
h(2) = plot(ha, s, getpv('BPM', 'PTB'), '.b');
ylabel(ha, 'PT Output');
% set(ha, 'XTickLabel', []);
set(ha, 'XMinorTick', 'On');
handles.LinePTOutput = h;
legend(ha, 'PT-A','PT-B', 'Location','northeast');

linkaxes([handles.AxesLattice handles.AxesADC handles.AxesRF handles.AxesPTLo handles.AxesPTHi handles.AxesAttn handles.AxesPTState handles.AxesPTOutput], 'x');
set(handles.AxesADC, 'XLim', [0 L]);


% Setup Timer
UpdatePeriod = 1.0;  % Seconds
t = timer;
handles.Timer = t;  % Set here, otherwise Timer field will not be in the timer callback (TimerFcn)
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@SRBPM_Timer_Callback,handles});
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
%set(t, 'ErrorFcn', {@SRBPM_Timer_Error,handles});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'SRBPMTimer');


% Update handles structure
guidata(hObject, handles);


% Draw the figure
set(handles.figure1, 'Visible', 'On');
drawnow expose

% Turn the timer on
start(handles.Timer);

% UIWAIT makes srbpmcontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = srbpmcontrol_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

fprintf('Hello\n');


function SRBPM_Timer_Callback(hObject, eventdata, handles)
%fprintf('Timer callback  %s\n', datestr(now));

set(handles.LineADC(1), 'YData', getpv('BPM', 'Apeak'));
set(handles.LineADC(2), 'YData', getpv('BPM', 'Bpeak'));
set(handles.LineADC(3), 'YData', getpv('BPM', 'Cpeak'));
set(handles.LineADC(4), 'YData', getpv('BPM', 'Dpeak'));

set(handles.LineRF(1), 'YData', getpv('BPM', 'A'));
set(handles.LineRF(2), 'YData', getpv('BPM', 'B'));
set(handles.LineRF(3), 'YData', getpv('BPM', 'C'));
set(handles.LineRF(4), 'YData', getpv('BPM', 'D'));

set(handles.LinePTLo(1), 'YData', getpv('BPM', 'PTLoA'));
set(handles.LinePTLo(2), 'YData', getpv('BPM', 'PTLoB'));
set(handles.LinePTLo(3), 'YData', getpv('BPM', 'PTLoC'));
set(handles.LinePTLo(4), 'YData', getpv('BPM', 'PTLoD'));

set(handles.LinePTHi(1), 'YData', getpv('BPM', 'PTHiA'));
set(handles.LinePTHi(2), 'YData', getpv('BPM', 'PTHiB'));
set(handles.LinePTHi(3), 'YData', getpv('BPM', 'PTHiC'));
set(handles.LinePTHi(4), 'YData', getpv('BPM', 'PTHiD'));

set(handles.LineAttn(1), 'YData', getpv('BPM', 'Attn'));
set(handles.LineAttn(2), 'YData', getpv('BPM', 'PTAttn'));

set(handles.LinePTState(1), 'YData', getpv('BPM', 'PTStatus'));
set(handles.LinePTState(2), 'YData', getpv('BPM', 'PTControl'));

set(handles.LinePTOutput(1), 'YData', getpv('BPM', 'PTA'));
set(handles.LinePTOutput(2), 'YData', getpv('BPM', 'PTB'));

[DCCT, t, Ts] = getdcct;
%set(handles.TimeOfData, 'String', datestr(Ts);
set(handles.TimeOfDay, 'String', datestr(now,31));
set(handles.DCCT,      'String', sprintf('%6.1f mA',DCCT));


% --- Executes on selection change in SRMode.
function SRMode_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns SRMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SRMode
%contents = cellstr(get(hObject,'String'));
%contents{get(hObject,'Value')}

if get(hObject,'Value') == 1
    % Ignor
elseif get(hObject,'Value') == 2
    bpminit('UserBeam');
elseif get(hObject,'Value') == 3
    bpminit('500 mA');
elseif get(hObject,'Value') == 4
    bpminit('200 mA');
elseif get(hObject,'Value') == 5
    bpminit('Low Current');
elseif get(hObject,'Value') == 6
    bpminit('Low Current', 'RMS');
else
    fprintf('Option not programmed yet (SRBPMCONTROL)!!!\n');
end


% --- Executes on selection change in PilotToneMode.
function PilotToneMode_Callback(hObject, eventdata, handles)

if get(hObject,'Value') == 1
    % Ignor
elseif get(hObject,'Value') == 2
    CommandStr = 'UserBeam';
elseif get(hObject,'Value') == 3
    CommandStr = '500 mA';
elseif get(hObject,'Value') == 4
    CommandStr = '200 mA';
elseif get(hObject,'Value') == 5
    CommandStr = 'Low Current';
elseif get(hObject,'Value') == 6
    CommandStr = 'Off';
else
    fprintf('Option not programmed yet (SRBPMCONTROL)!!!\n');
    return
end

cellcontrollerinit(CommandStr);
fprintf('   cellcontrollerinit(''%s'') complete.\n', CommandStr);


% --- Executes during object creation, after setting all properties.
function PilotToneMode_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function SRMode_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function PrintMenu_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)


function SRBPM_CloseRequestFcn(hObject, eventdata, handles)
stop(handles.Timer);
delete(hObject);

% --------------------------------------------------------------------
function CloseMenu_Callback(hObject, eventdata, handles)
selection = questdlg(['Close SRBPM Control?'],...
                     ['SRBPM Control ...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
stop(handles.Timer);
delete(handles.figure1)


% --------------------------------------------------------------------
function BPMInitMenu_Callback(hObject, eventdata, handles)
bpminit;


% --------------------------------------------------------------------
function CellControllerInit_Callback(hObject, eventdata, handles)
cellcontrollerinit;


% --------------------------------------------------------------------
function HorizontalAxisSector_Callback(hObject, eventdata, handles)
a = eventdata;
if length(a) == 2
    set(handles.AxesLattice, 'XLim', a);

else
    fprintf('   Horizontal axis needs to be a 2 element vector.\n');
end
