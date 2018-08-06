function varargout = LT1cycling(varargin)
% LT1CYCLING M-file for LT1cycling.fig
%      LT1CYCLING, by itself, creates a new LT1CYCLING or raises the existing
%      singleton*.
%
%      H = LT1CYCLING returns the handle to a new LT1CYCLING or the handle to
%      the existing singleton*.
%
%      LT1CYCLING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LT1CYCLING.M with the given input arguments.
%
%      LT1CYCLING('Property','Value',...) creates a new LT1CYCLING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LT1cycling_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LT1cycling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LT1cycling

% Last Modified by GUIDE v2.5 04-Apr-2005 17:56:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LT1cycling_OpeningFcn, ...
                   'gui_OutputFcn',  @LT1cycling_OutputFcn, ...
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


% --- Executes just before LT1cycling is made visible.
function LT1cycling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LT1cycling (see VARARGIN)

% Choose default command line output for LT1cycling
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LT1cycling wait for user response (see UIRESUME)
% uiwait(handles.figure1);
list = {'Present', 'Golden', 'UserSelect'};
set(handles.popupmenu_file,'String',list);

list = {'Simple', 'Full', 'startup'};
set(handles.popupmenu_type,'String',list);

list = {'Load cycling curve','Start', 'Stop', 'Pause', 'Resume', 'Init'};
set(handles.popupmenu_command,'String',list);

Machine = getfamilydata('SubMachine');

if isempty(Machine)
    error('Exiting .. first load a machine!');
    return;
else
    switch Machine
        case {'LT1','LT2'}            
            set(handles.figure1,'Name', [Machine 'cycling']);
        otherwise
            error('Exiting .. first load LT1 or LT2!');
            return;
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = LT1cycling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_none.
function checkbox_none_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_none
val = get(hObject,'Value');

if val
    set(handles.checkbox_BEND,'Value',0);
    set(handles.checkbox_QP,'Value',0);
    set(handles.checkbox_CH,'Value',0);
    set(handles.checkbox_CV,'Value',0);
    set(handles.checkbox_all,'Value',0);
end

% --- Executes on button press in checkbox_all.
function checkbox_all_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_all
val = get(hObject,'Value');

if val
    set(handles.checkbox_BEND,'Value',1);
    set(handles.checkbox_QP,'Value',1);
    set(handles.checkbox_CH,'Value',1);
    set(handles.checkbox_CV,'Value',1);
    set(handles.checkbox_none,'Value',0);
end


% --- Executes on button press in checkbox_BEND.
function checkbox_BEND_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BEND (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BEND

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_QP.
function checkbox_QP_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_QP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_QP

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_CH.
function checkbox_CH_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_CH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_CH

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_CV.
function checkbox_CV_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_CV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_CV

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in pushbutton_apply.
function pushbutton_apply_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = get(handles.popupmenu_command,'String');
command  = contents{get(handles.popupmenu_command,'Value')};

switch command
    case {'Start','Stop','Init','Pause','Resume', 'Load cycling curve'}
        cyclemagnet_local(command,handles);
    otherwise
        error('Unknown ommand name: %s ', command);
end

function cyclemagnet_local(command,handles)

%     [CycleIndex, CycleAO] = isfamily(CycleFamily);
% 
%     rep = tango_group_command_inout2(CycleAO.GroupId,'State',1,0);

Family = {'BEND','QP','CH','CV'};    
    
Families = {};
for k = 1:length(Family),
    if get(handles.(['checkbox_',Family{k}]),'Value')
        Families = {Families{:}, Family{k}};
    end
end

switch command
    case {'Start'}
        % get cycling file
        contents = get(handles.popupmenu_file,'String');
        file = contents{get(handles.popupmenu_file,'Value')};

        % get cycling file
        contents = get(handles.popupmenu_type,'String');
        type = contents{get(handles.popupmenu_type,'Value')};

        magnetcycle(type,file,Families,'NoDisplay','NoConfig');
        
    case {'Load cycling curve'}
        % get cycling file
        contents = get(handles.popupmenu_file,'String');
        file = contents{get(handles.popupmenu_file,'Value')};

        % get cycling file
        contents = get(handles.popupmenu_type,'String');
        type = contents{get(handles.popupmenu_type,'Value')};

        magnetcycle(type,file,Families,'NoDisplay','NoConfig', 'NoApply');
        
    case {'Stop','Init','Pause','Resume'}
        for k =1:length(Families)
            CycleFamily = ['Cycle' Families{k}];
            cyclingcommand(CycleFamily,command);
        end
end

% --- Executes on selection change in popupmenu_command.
function popupmenu_command_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_command contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_command

% --- Executes during object creation, after setting all properties.
function popupmenu_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_type.
function popupmenu_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_type


% --- Executes during object creation, after setting all properties.
function popupmenu_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_file.
function popupmenu_file_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_file contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_file


% --- Executes during object creation, after setting all properties.
function popupmenu_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


