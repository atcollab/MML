function varargout = archiving_panel_mode(varargin)
% ARCHIVING_PANEL_MODE M-file for archiving_panel_mode.fig
%      ARCHIVING_PANEL_MODE, by itself, creates a new ARCHIVING_PANEL_MODE or raises the existing
%      singleton*.
%
%      H = ARCHIVING_PANEL_MODE returns the handle to a new ARCHIVING_PANEL_MODE or the handle to
%      the existing singleton*.
%
%      ARCHIVING_PANEL_MODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARCHIVING_PANEL_MODE.M with the given input arguments.
%
%      ARCHIVING_PANEL_MODE('Property','Value',...) creates a new ARCHIVING_PANEL_MODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before archiving_panel_mode_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to archiving_panel_mode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help archiving_panel_mode

% Last Modified by GUIDE v2.5 18-Nov-2004 17:18:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @archiving_panel_mode_OpeningFcn, ...
                   'gui_OutputFcn',  @archiving_panel_mode_OutputFcn, ...
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

%
% Written by Laurent S. Nadolski


% --- Executes just before archiving_panel_mode is made visible.
function archiving_panel_mode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to archiving_panel_mode (see VARARGIN)

% Choose default command line output for archiving_panel_mode
handles.output = hObject;

% keep track of whether OK was clicked, this will be used in the OutputFcn
% to determine whether to use the selected value

handles.mode.selection = {'0','0','0','0'}; 

handles.mode.periodic.period     = '30'; %seconds

handles.mode.absolute.period     = '60'; %seconds
handles.mode.absolute.upperlimit = '50'; 
handles.mode.absolute.lowerlimit = '50';

handles.mode.relative.period     = '60'; %seconds
handles.mode.relative.upperlimit = '50';
handles.mode.relative.lowerlimit = '50';

handles.mode.difference.period   = '3600'; %seconds

handles.mode.keepingwindow = '3600000'; %ms, here for 1h
handles.mode.exportwindow  = '600000';  %ms, here for 10 min 
handles.mode.grouped  = '0'; % 1: grouped, 0 ungrouped

%% Case of no DB specified => force to HDB
if isempty(varargin)
    disp('No database specified: HDB by default')
    handles.database = 'HDB';
else
    handles.database = varargin{1};
end

if strcmpi(handles.database,'TDB') % convert to milliseconds
    handles.mode.periodic.period = '100'; %ms 
    handles.mode.absolute.period = '1000'; %ms; 
    handles.mode.relative.period = '1000'; %ms; 
end

%% Load actual parameter if they exist
if size(varargin,2) == 2 && isnumeric(varargin{2})
    temp = varargin{2};
    if temp(1,1) % if periodic 
        handles.mode.selection{1} = '1';
        handles.mode.periodic.period = num2str(temp(1,1)); %seconds
    end
    if temp(1,2) % if absolute
        handles.mode.selection{2} = '1';
        handles.mode.absolute.period = num2str(temp(1,2)); %seconds
        handles.mode.absolute.upperlimit = num2str(temp(1,3));
        handles.mode.absolute.lowerlimit = num2str(temp(1,4));
    end
    if temp(1,5) % if relative
        handles.mode.selection{5} = '1';
        handles.mode.relative.period     = num2str(temp(1,5)); %seconds
        handles.mode.relative.upperlimit = num2str(temp(1,6));
        handles.mode.relative.lowerlimit = num2str(temp(1,7));
    end
end

%% Create export window menu
list_export = {'5 secondes','10 minutes'};
set(handles.popupmenu_exportwindow,'String',list_export,'Value',2);

%% Create keeping window menu
list_keeping = {'1 hour','10 hours', '1 day'};
set(handles.popupmenu_keepingwindow,'String',list_keeping,'Value',1);

%Checked already running modes
if str2double(handles.mode.selection{1})
    set(handles.checkbox_periodic,'Value',1)
end
if str2double(handles.mode.selection{2})
    set(handles.checkbox_absolute,'Value',1)
end
if str2double(handles.mode.selection{3})
    set(handles.checkbox_relative,'Value',1)
end

%% Default value for parameter group
set(handles.checkbox_grouped,'Value',str2double(handles.mode.grouped));

% Update handles structure
guidata(hObject, handles);
% Update handles structure
guidata(handles.figure1, handles);

% UIWAIT makes tango_archiving_config wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = archiving_panel_mode_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

%% Returns archiving parameters
varargout{1} = handles.mode;

% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in checkbox_periodic.
function checkbox_periodic_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_periodic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_periodic
val = get(hObject,'Value');

% Build dialogbox inputs
if strcmpi(handles.database,'TDB')
    timeformat = 'ms';
else
    timeformat = 's';
end

prompt = {['Enter period (',timeformat,')']};
name = 'Input for periodic archiving';
numlines = 1;
defaultanswer = {handles.mode.periodic.period};
answer = inputdlg(prompt, name, numlines, defaultanswer);

if ~isempty(answer)
    handles.mode.selection{1} = '1';
    handles.mode.periodic.period = answer{1};

    %% Force checkbox if mode is running
    set(handles.checkbox_periodic,'Value',1)
else
    disp('No selection');
    handles.mode.selection{1} = '0';
end

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes on button press in checkbox_absolute.
function checkbox_absolute_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_absolute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_absolute

val = get(hObject,'Value');

if strcmpi(handles.database,'TDB')
    timeformat = 'ms';
else
    timeformat = 's';
end

% Build dialogbox inputs
prompt = {...
    ['Default period (',timeformat,')'], ...
    ['Relative period (',timeformat,')'], ...
    'Upper limit', ...
    'Lower limit'};
name = 'Input for absolute archiving';
numlines = 1;
defaultanswer = {...
    handles.mode.periodic.period, ...
    handles.mode.absolute.period, ...
    handles.mode.absolute.lowerlimit, ...
    handles.mode.absolute.upperlimit};

answer = inputdlg(prompt, name, numlines, defaultanswer);

if ~isempty(answer)
    % Periodic part
    handles.mode.selection{1} = '1';
    handles.mode.periodic.period = answer{1};
    % Absolute part
    handles.mode.selection{2} = '1';
    handles.mode.absolute.period         = answer{2};
    handles.mode.absolute.lowerlimit     = answer{3};
    handles.mode.absolute.upperlimit     = answer{4};

    %% Force checkbox if mode is running
    set(handles.checkbox_absolute,'Value',1)
    set(handles.checkbox_periodic,'Value',1)
else
    disp('No selection');
    handles.mode.selection{2} = '0';
end
            

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in checkbox_relative.
function checkbox_relative_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_relative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_relative

val = get(hObject,'Value');

if strcmpi(handles.database,'TDB')
    timeformat = 'ms';
else
    timeformat = 's';
end

% Build dialogbox inputs
prompt = {...
    ['Default period (',timeformat,')'], ...
    ['Relative period (',timeformat,')'], ...
    'Upper limit (%)', ...
    'Lower limit (%)'};
name = 'Input for relative archiving';
numlines = 1;
defaultanswer = {...
    handles.mode.periodic.period, ...
    handles.mode.relative.period, ...
    handles.mode.relative.lowerlimit, ...
    handles.mode.relative.upperlimit};

answer = inputdlg(prompt, name, numlines, defaultanswer);

if ~isempty(answer)
    % Periodic part
    handles.mode.selection{1} = '1';
    handles.mode.periodic.period = answer{1};
    % Relative mode part
    handles.mode.selection{3} = '1';
    handles.mode.relative.period         = answer{2};
    handles.mode.relative.upperlimit     = answer{3};
    handles.mode.relative.lowerlimit     = answer{4};

    %% Force checkbox if mode is running
    set(handles.checkbox_relative,'Value',1)
    set(handles.checkbox_periodic,'Value',1)
else
    disp('No selection');
    handles.mode.selection{3} = '0';
end

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in checkbox_difference.
function checkbox_difference_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_difference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_difference

val = get(hObject,'Value');

switch val
    case 1
        prompt = {'Default period (s)'};
        name = 'Input for on difference archiving';
        numlines = 1;
        defaultanswer = {'3600'};
        answer = inputdlg(prompt, name, numlines, defaultanswer);
        handles.mode.selection{4} = '1';
        handles.mode.difference.defaultperiod  = answer(1);
    otherwise
        disp('No selection');
end

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);
handles.mode = -1;

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes on button press in checkbox_grouped.
function checkbox_grouped_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_grouped (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_grouped

handles.mode.grouped = num2str(get(hObject,'Value'));

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes on selection change in popupmenu_exportwindow.
function popupmenu_exportwindow_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_exportwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_exportwindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_exportwindow

contents = get(hObject,'String');

%% converts entree to milliseconds
switch contents{get(hObject,'Value')}
    case '5 seconds'
        handles.mode.exportwindow = '5000'; %ms
    case '10 minutes'
        handles.mode.exportwindow = '600000'; %ms
end

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_exportwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_exportwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_keepingwindow.
function popupmenu_keepingwindow_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_keepingwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_keepingwindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_keepingwindow

contents = get(hObject,'String');

%% converts entree to milliseconds
switch contents{get(hObject,'Value')}
    case '1 hour'
        handles.mode.keepingwindow = '3600000'; %ms
    case '10 hours'
        handles.mode.keepingwindow = '36000000'; %ms
    case '1 day'
        handles.mode.keepingwindow = '86400000'; %ms
end

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_keepingwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_keepingwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


