function varargout = qart_inject(varargin)
% QART_INJECT M-file for qart_inject.fig
%      QART_INJECT, by itself, creates a new QART_INJECT or raises the existing
%      singleton*.
%
%      H = QART_INJECT returns the handle to a new QART_INJECT or the handle to
%      the existing singleton*.
%
%      QART_INJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QART_INJECT.M with the given input arguments.
%
%      QART_INJECT('Property','Value',...) creates a new QART_INJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before qart_inject_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to qart_inject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help qart_inject

% Last Modified by GUIDE v2.5 16-Jun-2006 16:20:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @qart_inject_OpeningFcn, ...
                   'gui_OutputFcn',  @qart_inject_OutputFcn, ...
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


% --- Executes just before qart_inject is made visible.
function qart_inject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qart_inject (see VARARGIN)

% Choose default command line output for qart_inject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes qart_inject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = qart_inject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_quart1.
function button_quart1_Callback(hObject, eventdata, handles)
% hObject    handle to button_quart1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit1,'String',' Running, wait !');
injection_quart(1);
set(handles.edit1,'String','Injection sur quart 1 OK');

% --- Executes on button press in button_quart2.
function button_quart2_Callback(hObject, eventdata, handles)
% hObject    handle to button_quart2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'String',' Running, wait !');
injection_quart(2);
set(handles.edit1,'String','Injection sur quart 2 OK');

% --- Executes on button press in button_quart3.
function button_quart3_Callback(hObject, eventdata, handles)
% hObject    handle to button_quart3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'String',' Running, wait !');
injection_quart(3);
set(handles.edit1,'String','Injection sur quart 3 OK');

% --- Executes on button press in button_quart4.
function button_quart4_Callback(hObject, eventdata, handles)
% hObject    handle to button_quart4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'String',' Running, wait !');
injection_quart(4);
set(handles.edit1,'String','Injection sur quart 4 OK');

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


