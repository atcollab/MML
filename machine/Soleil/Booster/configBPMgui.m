function varargout = configBPMgui(varargin)
% CONFIGBPMGUI M-file for configBPMgui.fig
%      CONFIGBPMGUI, by itself, creates a new CONFIGBPMGUI or raises the existing
%      singleton*.
%
%      H = CONFIGBPMGUI returns the handle to a new CONFIGBPMGUI or the handle to
%      the existing singleton*.
%
%      CONFIGBPMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGBPMGUI.M with the given input arguments.
%
%      CONFIGBPMGUI('Property','Value',...) creates a new CONFIGBPMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before configBPMgui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to configBPMgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help configBPMgui

% Last Modified by GUIDE v2.5 09-Sep-2005 17:57:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @configBPMgui_OpeningFcn, ...
                   'gui_OutputFcn',  @configBPMgui_OutputFcn, ...
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


% --- Executes just before configBPMgui is made visible.
function configBPMgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to configBPMgui (see VARARGIN)

% Choose default command line output for configBPMgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes configBPMgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = configBPMgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_BPM1.
function checkbox_BPM1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM1


% --- Executes on button press in checkbox_BPM2.
function checkbox_BPM2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM2


% --- Executes on button press in checkbox_BPM3.
function checkbox_BPM3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM3


% --- Executes on button press in checkbox_BPM4.
function checkbox_BPM4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM4


% --- Executes on button press in checkbox_BPM5.
function checkbox_BPM5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM5


% --- Executes on button press in checkbox_BPM6.
function checkbox_BPM6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM6


% --- Executes on button press in BPM7_checkbox.
function BPM7_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM7_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM7_checkbox


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


% --- Executes on button press in pushbutton_command.
function pushbutton_command_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_selectall.
function checkbox_selectall_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_selectall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_selectall


% --- Executes on button press in checkbox_selectnone.
function checkbox_selectnone_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_selectnone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_selectnone



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_mode.
function popupmenu_mode_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_mode


% --- Executes during object creation, after setting all properties.
function popupmenu_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_refresh.
function pushbutton_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_BPM12.
function checkbox_BPM12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM12


% --- Executes on button press in checkbox_BPM13.
function checkbox_BPM13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM13


% --- Executes on button press in checkbox_BPM14.
function checkbox_BPM14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM14


% --- Executes on button press in checkbox_BPM15.
function checkbox_BPM15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM15


% --- Executes on button press in checkbox_BPM16.
function checkbox_BPM16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM16


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on button press in checkbox_BPM7.
function checkbox_BPM7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM7


% --- Executes on button press in checkbox_BPM8.
function checkbox_BPM8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM8


% --- Executes on button press in checkbox_BPM9.
function checkbox_BPM9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM9


% --- Executes on button press in checkbox_BPM20.
function checkbox_BPM20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM20


% --- Executes on button press in checkbox_BPM11.
function checkbox_BPM11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM11


% --- Executes on button press in checkbox_BPM18.
function checkbox_BPM18_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM18


% --- Executes on button press in checkbox_BPM19.
function checkbox_BPM19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM19


% --- Executes on button press in checkbox_BPM20.
function checkbox25_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM20


% --- Executes on button press in checkbox_BPM21.
function checkbox_BPM21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM21


% --- Executes on button press in checkbox_BPM22.
function checkbox_BPM22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BPM22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BPM22


