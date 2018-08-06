function varargout = energyscalegui(varargin)
% ENERGYSCALEGUI M-file for energyscalegui.fig
%      ENERGYSCALEGUI, by itself, creates a new ENERGYSCALEGUI or raises the existing
%      singleton*.
%
%      H = ENERGYSCALEGUI returns the handle to a new ENERGYSCALEGUI or the handle to
%      the existing singleton*.
%
%      ENERGYSCALEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENERGYSCALEGUI.M with the given input arguments.
%
%      ENERGYSCALEGUI('Property','Value',...) creates a new ENERGYSCALEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before energyscalegui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to energyscalegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help energyscalegui

% Last Modified by GUIDE v2.5 31-Jul-2006 23:52:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @energyscalegui_OpeningFcn, ...
                   'gui_OutputFcn',  @energyscalegui_OutputFcn, ...
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


% --- Executes just before energyscalegui is made visible.
function energyscalegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to energyscalegui (see VARARGIN)

% Choose default command line output for energyscalegui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes energyscalegui wait for user response (see UIRESUME)
% uiwait(handles.energyscale);

% Initialise the increments
set(handles.bend_inc,'String',sprintf('%7.5f',0.0005));
bend_inc_Callback(handles.bend_inc, eventdata, handles);

set(handles.qfa_inc,'String',sprintf('%7.5f',0.0005));
qfa_inc_Callback(handles.qfa_inc, eventdata, handles);

set(handles.qda_inc,'String',sprintf('%7.5f',0.0005));
qda_inc_Callback(handles.qda_inc, eventdata, handles);

set(handles.qfb_inc,'String',sprintf('%7.5f',0.0005));
qfb_inc_Callback(handles.qfb_inc, eventdata, handles);

initialise_Callback(handles.initialise, eventdata, handles);



% --- Outputs from this function are returned to the command line.
function varargout = energyscalegui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in initialise.
function initialise_Callback(hObject, eventdata, handles)
% hObject    handle to initialise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Read data
read_sp_Callback(handles.read_sp, eventdata, handles);

data = get(handles.energyscale,'UserData');

data.ref_setpoint = data.setpoint;

data.bend_scale = 1;
data.qfa_scale = 1;
data.qda_scale = 1;
data.qfb_scale = 1;

set(handles.bend_ref,'String',sprintf('%8.4f',data.ref_setpoint.bend_amps(1)));
set(handles.qfa_ref,'String',sprintf('%8.4f',data.ref_setpoint.qfa_amps(1)));
set(handles.qda_ref,'String',sprintf('%8.4f',data.ref_setpoint.qda_amps(1)));
set(handles.qfb_ref,'String',sprintf('%8.4f',data.ref_setpoint.qfb_amps(1)));

set(handles.bend_scale,'String',sprintf('%7.4f',data.bend_scale));
set(handles.qfa_scale,'String',sprintf('%7.4f',data.qfa_scale));
set(handles.qda_scale,'String',sprintf('%7.4f',data.qda_scale));
set(handles.qfb_scale,'String',sprintf('%7.4f',data.qfb_scale));

set(handles.energyscale,'UserData',data);


function bend_scale_Callback(hObject, eventdata, handles)
% hObject    handle to bend_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bend_scale as text
%        str2double(get(hObject,'String')) returns contents of bend_scale as a double
data = get(handles.energyscale,'UserData');
data.bend_scale = str2double(get(hObject,'String'));

setsp('BEND',data.bend_scale.*data.ref_setpoint.bend_amps,'Hardware');

set(handles.energyscale,'UserData',data);

read_sp_Callback(handles.read_sp, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function bend_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bend_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qfa_scale_Callback(hObject, eventdata, handles)
% hObject    handle to qfa_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qfa_scale as text
%        str2double(get(hObject,'String')) returns contents of qfa_scale as a double
data = get(handles.energyscale,'UserData');
data.qfa_scale = str2double(get(hObject,'String'));

setsp('QFA',data.qfa_scale.*data.ref_setpoint.qfa_amps,'Hardware');

set(handles.energyscale,'UserData',data);

read_sp_Callback(handles.read_sp, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function qfa_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qfa_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qda_scale_Callback(hObject, eventdata, handles)
% hObject    handle to qda_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qda_scale as text
%        str2double(get(hObject,'String')) returns contents of qda_scale as a double
data = get(handles.energyscale,'UserData');
data.qda_scale = str2double(get(hObject,'String'));

setsp('QDA',data.qda_scale.*data.ref_setpoint.qda_amps,'Hardware');

set(handles.energyscale,'UserData',data);

read_sp_Callback(handles.read_sp, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function qda_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qda_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qfb_scale_Callback(hObject, eventdata, handles)
% hObject    handle to qfb_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qfb_scale as text
%        str2double(get(hObject,'String')) returns contents of qfb_scale as a double
data = get(handles.energyscale,'UserData');
data.qfb_scale = str2double(get(hObject,'String'));

setsp('QFB',data.qfb_scale.*data.ref_setpoint.qfb_amps,'Hardware');

set(handles.energyscale,'UserData',data);

read_sp_Callback(handles.read_sp, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function qfb_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qfb_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bend_inc_Callback(hObject, eventdata, handles)
% hObject    handle to bend_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bend_inc as text
%        str2double(get(hObject,'String')) returns contents of bend_inc as a double
data = get(handles.energyscale,'UserData');
data.bend_inc = str2double(get(hObject,'String'));
set(handles.energyscale,'UserData',data);


% --- Executes during object creation, after setting all properties.
function bend_inc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bend_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qfa_inc_Callback(hObject, eventdata, handles)
% hObject    handle to qfa_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qfa_inc as text
%        str2double(get(hObject,'String')) returns contents of qfa_inc as a double
data = get(handles.energyscale,'UserData');
data.qfa_inc = str2double(get(hObject,'String'));
set(handles.energyscale,'UserData',data);


% --- Executes during object creation, after setting all properties.
function qfa_inc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qfa_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qda_inc_Callback(hObject, eventdata, handles)
% hObject    handle to qda_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qda_inc as text
%        str2double(get(hObject,'String')) returns contents of qda_inc as a double
data = get(handles.energyscale,'UserData');
data.qda_inc = str2double(get(hObject,'String'));
set(handles.energyscale,'UserData',data);


% --- Executes during object creation, after setting all properties.
function qda_inc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qda_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qfb_inc_Callback(hObject, eventdata, handles)
% hObject    handle to qfb_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qfb_inc as text
%        str2double(get(hObject,'String')) returns contents of qfb_inc as a double
data = get(handles.energyscale,'UserData');
data.qfb_inc = str2double(get(hObject,'String'));
set(handles.energyscale,'UserData',data);


% --- Executes during object creation, after setting all properties.
function qfb_inc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qfb_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bend_plus.
function bend_plus_Callback(hObject, eventdata, handles)
% hObject    handle to bend_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.bend_scale + data.bend_inc;
set(handles.bend_scale,'String',sprintf('%7.5f',new_scale));

bend_scale_Callback(handles.bend_scale, eventdata, handles);

% --- Executes on button press in qfa_plus.
function qfa_plus_Callback(hObject, eventdata, handles)
% hObject    handle to qfa_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.qfa_scale + data.qfa_inc;
set(handles.qfa_scale,'String',sprintf('%7.5f',new_scale));

qfa_scale_Callback(handles.qfa_scale, eventdata, handles);


% --- Executes on button press in qda_plus.
function qda_plus_Callback(hObject, eventdata, handles)
% hObject    handle to qda_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.qda_scale + data.qda_inc;
set(handles.qda_scale,'String',sprintf('%7.5f',new_scale));

qda_scale_Callback(handles.qda_scale, eventdata, handles);


% --- Executes on button press in qfb_plus.
function qfb_plus_Callback(hObject, eventdata, handles)
% hObject    handle to qfb_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.qfb_scale + data.qfb_inc;
set(handles.qfb_scale,'String',sprintf('%7.5f',new_scale));

qfb_scale_Callback(handles.qfb_scale, eventdata, handles);


% --- Executes on button press in bend_minus.
function bend_minus_Callback(hObject, eventdata, handles)
% hObject    handle to bend_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.bend_scale - data.bend_inc;
set(handles.bend_scale,'String',sprintf('%7.5f',new_scale));

bend_scale_Callback(handles.bend_scale, eventdata, handles);

% --- Executes on button press in qfa_minus.
function qfa_minus_Callback(hObject, eventdata, handles)
% hObject    handle to qfa_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.qfa_scale - data.qfa_inc;
set(handles.qfa_scale,'String',sprintf('%7.5f',new_scale));

qfa_scale_Callback(handles.qfa_scale, eventdata, handles);


% --- Executes on button press in qda_minus.
function qda_minus_Callback(hObject, eventdata, handles)
% hObject    handle to qda_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.qda_scale - data.qda_inc;
set(handles.qda_scale,'String',sprintf('%7.5f',new_scale));

qda_scale_Callback(handles.qda_scale, eventdata, handles);

% --- Executes on button press in qfb_minus.
function qfb_minus_Callback(hObject, eventdata, handles)
% hObject    handle to qfb_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.energyscale,'UserData');
new_scale = data.qfb_scale - data.qfb_inc;
set(handles.qfb_scale,'String',sprintf('%7.5f',new_scale));

qfb_scale_Callback(handles.qfb_scale, eventdata, handles);


% --- Executes on button press in read_sp.
function read_sp_Callback(hObject, eventdata, handles)
% hObject    handle to read_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.energyscale,'UserData');

data.setpoint.bend_amps = getsp('BEND','Hardware');
data.setpoint.qfa_amps = getsp('QFA','Hardware');
data.setpoint.qda_amps = getsp('QDA','Hardware');
data.setpoint.qfb_amps = getsp('QFB','Hardware');

data.setpoint.bend_gev = getsp('BEND','Physics');
data.setpoint.qfa_k = getsp('QFA','Physics');
data.setpoint.qda_k = getsp('QDA','Physics');
data.setpoint.qfb_k = getsp('QFB','Physics');

fields = fieldnames(data.setpoint);
for i=1:length(fields)
    if ~isempty(strfind(fields{i},'amps'))
        % Print amps
        set(handles.(fields{i}),'String',sprintf('%+8.4f',data.setpoint.(fields{i})(1)));
    else
        % Print k and gev
        set(handles.(fields{i}),'String',sprintf('%+8.6f',data.setpoint.(fields{i})(1)));
    end
end

set(handles.energyscale,'UserData',data);