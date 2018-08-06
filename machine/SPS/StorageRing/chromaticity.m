function varargout = chromaticity(varargin)
% CHROMATICITY M-file for chromaticity.fig
%      CHROMATICITY, by itself, creates a new CHROMATICITY or raises the existing
%      singleton*.
%
%      H = CHROMATICITY returns the handle to a new CHROMATICITY or the handle to
%      the existing singleton*.
%
%      CHROMATICITY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHROMATICITY.M with the given input arguments.
%
%      CHROMATICITY('Property','Value',...) creates a new CHROMATICITY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chromaticity_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chromaticity_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chromaticity

% Last Modified by GUIDE v2.5 17-Apr-2007 17:50:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chromaticity_OpeningFcn, ...
                   'gui_OutputFcn',  @chromaticity_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before chromaticity is made visible.
function chromaticity_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chromaticity (see VARARGIN)

% Choose default command line output for chromaticity
handles.output = hObject;
set(gcf, 'MenuBar', 'figure');
datenow = date;
set(handles.date_statictext,'String',datenow);
timenow = fix(clock);
%timeonly = num2str(timenow(1,4:6));
hour = timenow(4);
min = timenow(5);
time = num2str(hour+(0.01*min), '%6.2f');

set(handles.time_statictext,'String', time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Keep the handles of the table %%%%%%%%%%%%%%%%%%%%%

handles.fRF = [handles.f1_edittext handles.f2_edittext handles.f3_edittext ...
    handles.f4_edittext handles.f5_edittext];

handles.fx = [handles.f1x_edittext handles.f2x_edittext handles.f3x_edittext...
    handles.f4x_edittext handles.f5x_edittext];

handles.fy = [handles.f1y_edittext handles.f2y_edittext handles.f3y_edittext...
    handles.f4y_edittext handles.f5y_edittext];

handles.vx = [handles.v1x_edittext handles.v2x_edittext handles.v3x_edittext...
    handles.v4x_edittext handles.v5x_edittext];

handles.vy = [handles.v1y_edittext handles.v2y_edittext handles.v3y_edittext...
    handles.v4y_edittext handles.v5y_edittext];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes chromaticity wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%close BeamMeas

% --- Outputs from this function are returned to the command line.
function varargout = chromaticity_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function f1_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f1_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f1_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f1_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f1_edittext as text
%        str2double(get(hObject,'String')) returns contents of f1_edittext as a double


% --- Executes during object creation, after setting all properties.
function f1x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f1x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f1x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f1x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f1x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f1x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f1y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f1y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f1y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f1y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f1y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f1y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v1x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v1x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v1x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v1x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v1x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v1x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v1y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v1y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v1y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v1y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v1y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v1y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f2_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f2_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f2_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f2_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f2_edittext as text
%        str2double(get(hObject,'String')) returns contents of f2_edittext as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function f2y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f2y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f2y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f2y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f2y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f2y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v2x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v2x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v2x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v2x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v2x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v2x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v2y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v2y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v2y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v2y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v2y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v2y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f3_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f3_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f3_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f3_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f3_edittext as text
%        str2double(get(hObject,'String')) returns contents of f3_edittext as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function f3y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f3y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f3y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f3y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f3y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f3y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v3x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v3x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v3x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v3x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v3x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v3x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v3y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v3y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v3y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v3y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v3y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v3y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f4_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f4_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f4_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f4_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f4_edittext as text
%        str2double(get(hObject,'String')) returns contents of f4_edittext as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function f4y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f4y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f4y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f4y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f4y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f4y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v4x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v4x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v4x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v4x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v4x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v4x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v4y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v4y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v4y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v4y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v4y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v4y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f5_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f5_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f5_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f5_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f5_edittext as text
%        str2double(get(hObject,'String')) returns contents of f5_edittext as a double


% --- Executes during object creation, after setting all properties.
function f5x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f5x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f5x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f5x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f5x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f5x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f5y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f5y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f5y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f5y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f5y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f5y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v5x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v5x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v5x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v5x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v5x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v5x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v5y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v5y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v5y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v5y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v5y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v5y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f6_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f6_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f6_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f6_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f6_edittext as text
%        str2double(get(hObject,'String')) returns contents of f6_edittext as a double


% --- Executes during object creation, after setting all properties.
function f6x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f6x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f6x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f6x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f6x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f6x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f6y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f6y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f6y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f6y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f6y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f6y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v6x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v6x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v6x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v6x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v6x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v6x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v6y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v6y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v6y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v6y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v6y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v6y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f7_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f7_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f7_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f7_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f7_edittext as text
%        str2double(get(hObject,'String')) returns contents of f7_edittext as a double


% --- Executes during object creation, after setting all properties.
function f7x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f7x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f7x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f7x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f7x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f7x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f7y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f7y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f7y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f7y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f7y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f7y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v7x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v7x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v7x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v7x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v7x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v7x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v7y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v7y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v7y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v7y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v7y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v7y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f8_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f8_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f8_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f8_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f8_edittext as text
%        str2double(get(hObject,'String')) returns contents of f8_edittext as a double


% --- Executes during object creation, after setting all properties.
function f8x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f8x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f8x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f8x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f8x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f8x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f8y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f8y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f8y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f8y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f8y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f8y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v8x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v8x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v8x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v8x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v8x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v8x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v8y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v8y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v8y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v8y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v8y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v8y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f9_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f9_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f9_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f9_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f9_edittext as text
%        str2double(get(hObject,'String')) returns contents of f9_edittext as a double


% --- Executes during object creation, after setting all properties.
function f9x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f9x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f9x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f9x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f9x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f9x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f9y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f9y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f9y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f9y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f9y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f9y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v9x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v9x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v9x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v9x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v9x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v9x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v9y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v9y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v9y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v9y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v9y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v9y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f10_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f10_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f10_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f10_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f10_edittext as text
%        str2double(get(hObject,'String')) returns contents of f10_edittext as a double


% --- Executes during object creation, after setting all properties.
function f10x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f10x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f10x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f10x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f10x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f10x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f10y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f10y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f10y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f10y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f10y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f10y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v10x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v10x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v10x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v10x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v10x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v10x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v10y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v10y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v10y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v10y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v10y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v10y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f11_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f11_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f11_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f11_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f11_edittext as text
%        str2double(get(hObject,'String')) returns contents of f11_edittext as a double


% --- Executes during object creation, after setting all properties.
function f11x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f11x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f11x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f11x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f11x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f11x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f11y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f11y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f11y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f11y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f11y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f11y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v11x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v11x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v11x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v11x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v11x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v11x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v11y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v11y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v11y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v11y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v11y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v11y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f12_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f12_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f12_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f12_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f12_edittext as text
%        str2double(get(hObject,'String')) returns contents of f12_edittext as a double


% --- Executes during object creation, after setting all properties.
function f12x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f12x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f12x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f12x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f12x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f12x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f12y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f12y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f12y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f12y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f12y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f12y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v12x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v12x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v12x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v12x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v12x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v12x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v12y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v12y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v12y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v12y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v12y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v12y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f13_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f13_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f13_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f13_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f13_edittext as text
%        str2double(get(hObject,'String')) returns contents of f13_edittext as a double


% --- Executes during object creation, after setting all properties.
function f13x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f13x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f13x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f13x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f13x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f13x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f13y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f13y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f13y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f13y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f13y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f13y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v13x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v13x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v13x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v13x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v13x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v13x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v13y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v13y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v13y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v13y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v13y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v13y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f14_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f14_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f14_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f14_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f14_edittext as text
%        str2double(get(hObject,'String')) returns contents of f14_edittext as a double


% --- Executes during object creation, after setting all properties.
function f14x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f14x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f14x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f14x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f14x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f14x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f14y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f14y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f14y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f14y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f14y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f14y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v14x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v14x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v14x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v14x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v14x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v14x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v14y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v14y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v14y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v14y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v14y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v14y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f15_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f15_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f15_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f15_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f15_edittext as text
%        str2double(get(hObject,'String')) returns contents of f15_edittext as a double


% --- Executes during object creation, after setting all properties.
function f15x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f15x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f15x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f15x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f15x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f15x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f15y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f15y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f15y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f15y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f15y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f15y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v15x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v15x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v15x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v15x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v15x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v15x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v15y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v15y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v15y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v15y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v15y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v15y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f16_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f16_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f16_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f16_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f16_edittext as text
%        str2double(get(hObject,'String')) returns contents of f16_edittext as a double


% --- Executes during object creation, after setting all properties.
function f16x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f16x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f16x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f16x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f16x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f16x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f16y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f16y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f16y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f16y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f16y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f16y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v16x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v16x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v16x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v16x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v16x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v16x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v16y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v16y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v16y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v16y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v16y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v16y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f17_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f17_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f17_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f17_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f17_edittext as text
%        str2double(get(hObject,'String')) returns contents of f17_edittext as a double


% --- Executes during object creation, after setting all properties.
function f17x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f17x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f17x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f17x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f17x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f17x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f17y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f17y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f17y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f17y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f17y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f17y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v17x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v17x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v17x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v17x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v17x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v17x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v17y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v17y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v17y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v17y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v17y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v17y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f18_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f18_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f18_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f18_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f18_edittext as text
%        str2double(get(hObject,'String')) returns contents of f18_edittext as a double


% --- Executes during object creation, after setting all properties.
function f18x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f18x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f18x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f18x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f18x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f18x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f18y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f18y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f18y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f18y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f18y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f18y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v18x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v18x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v18x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v18x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v18x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v18x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v18y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v18y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v18y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v18y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v18y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v18y_edittext as a double









% --- Executes during object creation, after setting all properties.
function f2x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f2x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f2x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f2x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f2x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f2x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f3x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f3x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f3x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f3x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f3x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f3x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f4x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f4x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f4x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f4x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f4x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f4x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f19_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f19_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f19_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f19_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f19_edittext as text
%        str2double(get(hObject,'String')) returns contents of f19_edittext as a double


% --- Executes during object creation, after setting all properties.
function f19x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f19x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f19x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f19x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f19x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f19x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f19y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f19y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f19y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f19y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f19y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f19y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v19x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v19x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v19x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v19x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v19x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v19x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v19y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v19y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v19y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v19y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v19y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v19y_edittext as a double


% --- Executes during object creation, after setting all properties.
function f20_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f20_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f20_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f20_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f20_edittext as text
%        str2double(get(hObject,'String')) returns contents of f20_edittext as a double


% --- Executes during object creation, after setting all properties.
function f20x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f20x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f20x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f20x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f20x_edittext as text
%        str2double(get(hObject,'String')) returns contents of f20x_edittext as a double


% --- Executes during object creation, after setting all properties.
function f20y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f20y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f20y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to f20y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f20y_edittext as text
%        str2double(get(hObject,'String')) returns contents of f20y_edittext as a double


% --- Executes during object creation, after setting all properties.
function v20x_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v20x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v20x_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v20x_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v20x_edittext as text
%        str2double(get(hObject,'String')) returns contents of v20x_edittext as a double


% --- Executes during object creation, after setting all properties.
function v20y_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v20y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function v20y_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to v20y_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v20y_edittext as text
%        str2double(get(hObject,'String')) returns contents of v20y_edittext as a double


% --- Executes on button press in GetData_pushbutton.
function GetData_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to GetData_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function chromox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chromox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate chromox




% --- Executes on button press in getconfig_pushbutton.
function getconfig_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to getconfig_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.status_statictext,'string', 'Getting Configuration');

da = opcda('localhost','RSLinx Remote OPC Server');
connect(da);
grp = addgroup(da);
item1 = additem(grp,'[STR-DCS]S_QF_M1.SetUpValue');
item2 = additem(grp,'[STR-DCS]S_QD_M2.SetUpValue');
item3 = additem(grp,'[STR-DCS]S_QF_M3.SetUpValue');
item4 = additem(grp,'[STR-DCS]S_QD_M4.SetUpValue');
item5 = additem(grp,'[STR-DCS]S_BM_M.SetUpValue');
item6 = additem(grp,'[STR-DCS]S_SXF_M.SetUpValue');
item7 = additem(grp,'[STR-DCS]S_SXD_M.SetUpValue'); 
item8 = additem(grp,'[CNT-DCS]Beam_Current');

iqfm1 = get(item1);
iqf1 = iqfm1.Value;

iqdm2 = get(item2);
iqd2 = iqdm2.Value;

iqfm3 = get(item3);
iqf3 = iqfm3.Value;

iqdm4 = get(item4);
iqd4 = iqdm4.Value;

ibmm = get(item5);
ibm = ibmm.Value;

pause (5);

isxfm = get(item6);
isxf = isxfm.Value;

isxdm = get(item7);
isxd = isxdm.Value;

ibeam = get(item8);
ibeam = ibeam.Value;


if ibm==1290
    set(handles.beamenergy_statictext, 'string', '0.98');
elseif ibm ==1787 
    set(handles.beamenergy_statictext, 'string', '1.20');
end

set(handles.ibm_statictext,'string', num2str(ibm));
set(handles.iqf1_statictext,'string',num2str(iqf1));
set(handles.iqd2_statictext,'string',num2str(iqd2));
set(handles.iqf3_statictext,'string',num2str(iqf3));
set(handles.iqd4_statictext,'string',num2str(iqd4));
set(handles.isxf_statictext,'string',num2str(isxf));
set(handles.isxd_statictext,'string',num2str(isxd));
set(handles.beamcurrent_statictext,'string',num2str(ibeam));

Read_f0;
set(handles.center_freq_statictext, 'string', num2str(f0));
Read_fxfy;
frev = f0/32;


if fys(1,2)>-100 %--Check if Level < -100 dBm it isn't the point we expected --%
    fy=fys(1,1);
%    set(handles.fy_statictext,'string',num2str(fy));
    nuy = 2+(1-(fy-f0)/frev);
    set(handles.tuney0_statictext,'string',num2str(nuy));
else
    fy='Can not find fy';
 
    Tuney='Can not find Tuney';
    set(handles.tuney0_statictext,'string',Tuney);
end

if fxs(1,2)>-100 %--Check if Level < -100 dBm it isn't the point we expected --%
    fx=fxs(1,1);
    nux = 4+(1-(fx-f0)/frev);
    set(handles.tunex0_statictext,'string',num2str(nux));
else
    fx='Can not find fx';
    Tunex='Can not find Tunex';
    set(handles.tunex0_statictext,'string',Tunex);
end


disconnect(da);
set(handles.status_statictext,'string', 'Complete Getting Configuration');

% --- Executes on button press in startmeas_pushbutton.
function startmeas_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startmeas_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.status_statictext,'string', 'Getting Measurement Data');
global fRF_10digit RF_step_10digit f0 

for k = 1:5
    da = opcda('localhost', 'RSLinx Remote OPC Server');
    connect(da);
    grp=addgroup(da);
    item1 = additem(grp, '[GIS-DCS]RFOSC.Remote');
    item2 = additem(grp, '[GIS-DCS]RFOSC.SetupValue');
    item3 = additem(grp, '[GIS-DCS]RFOSC.Step');
    
    read(item1);
    if item1 == 0
       write (item1, 1);
    end
    write(item2, (fRF_10digit + (k-1)*RF_step_10digit));
    disconnect(da);

    Read_f0
    Read_fxfy
    
    pause(1);
    frev=f0/32;
    
set(handles.fRF(k), 'string',num2str(f0, '%6.4f'));


if fys(1,2)>-100 %--Check if Level < -100 dBm it isn't the point we expected --%
    fy=fys(1,1);
    set(handles.fy(k),'string',num2str(fy,'%6.4f'));
    nuy = 2+(1-(fy-f0)/frev);
    set(handles.vy(k),'string',num2str(nuy,'%6.4f'));
else
    fy='Can not find fy';
    set(handles.fy(i),'string',fy);
    Tuney='Can not find Tuney';
    set(handles.vy(k),'string',Tuney);
end

if fxs(1,2)>-100 %--Check if Level < -100 dBm it isn't the point we expected --%
    fx=fxs(1,1);
    set(handles.fx(k),'string',num2str(fx,'%6.4f'));
    nux = 4+(1-(fx-f0)/frev);
    set(handles.vx(k),'string',num2str(nux,'%6.4f'));
else
    fx='Can not find fx';
    set(handles.fx(k),'string',fx);
    Tunex='Can not find Tunex';
    set(handles.vx(k),'string',Tunex);
end
end



%%%%%%%%%%%%%%%%Set the RF frequency back to original values %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fcenter = str2num(get(handles.center_freq_statictext, 'string'))
    da = opcda('localhost', 'RSLinx Remote OPC Server');
    connect(da);
    grp=addgroup(da);
    item1 = additem(grp, '[GIS-DCS]RFOSC.Remote');
    item2 = additem(grp, '[GIS-DCS]RFOSC.SetupValue');
       read(item1);
    if item1 == 0
       write (item1, 1);
    end
    write(item2, (fcenter*10^7));
    disconnect(da);
    
   
%%%%%%%%%%%%%%%%%%%%% Calculate the Chromaticity %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%from measuring data %%%%%%%%%%%%%%%%%%%%%%%%%%%%

global fRF dff nux nuy

for k=1:5
fRF(k)=str2num(get(handles.fRF(k), 'string'));
nux(k)=str2num(get(handles.vx(k), 'string'));
nuy(k)=str2num(get(handles.vy(k), 'string'));
dff(k)=(fRF(k)-fRF(1))/fRF(1);
dnux(k)=nux(k)-nux(1);
dnuy(k)=nuy(k)-nuy(1);
end

alpha_c = getmcf
%%%%%%%%%%%%%%%%%%%%%%%%%Linear Data Fitting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Px = polyfit(dff,dnux,1);
chrom_x =(-1*alpha_c)*Px(1);
fitx = polyval(Px,dff);

Py = polyfit(dff,dnuy,1);
chrom_y =(-1*alpha_c)*Py(1);
fity = polyval(Py,dff);
axes(handles.chromox);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%Specify the coordinates for equations %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_max = max(dff);
x_min = min(dff);
x_width = x_max-x_min;
x_text = x_min+(x_width/5);

dnux_max = max(dnux);
dnux_min = min(dnux);
dnux_width = dnux_max-dnux_min;
dnux_text1 = dnux_max-(dnux_width/5);
dnux_text2 = dnux_max-2*(dnux_width/5);

dnuy_max = max(dnuy);
dnuy_min = min(dnuy);
dnuy_width = dnuy_max-dnuy_min;
dnuy_text1 = dnuy_max-(dnuy_width/5);
dnuy_text2 = dnuy_max-2*(dnuy_width/5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%% Plotting the results %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(handles.chromox);
plot(dff,dnux,'.b',dff,fitx,'-b');
if Px(2) > 0
text(x_text,dnux_text1, ['y  = ', num2str(Px(1), '%6.5g'), ...
    'x + ', num2str(Px(2))], 'color','b') 
else 
text(x_text,dnux_text1, ['y  = ', num2str(Px(1), '%6.5g'),...
    'x ', num2str(Px(2))], 'color','b') 
end

text(x_text,dnux_text2, ['\xi_x = ', num2str(-1*(Px(1))*alpha_c,...
    '%6.5g')], 'color','b') 
        
title('Horizontal Chromaticity', 'color', 'b');
hold on
xlabel('\Deltaf/f');
ylabel('\Delta\nu_x');
grid;

axes(handles.chromoy);
plot(dff,dnuy,'.r',dff,fity,'-r');
if Py(2) > 0
text(x_text,dnuy_text1, ['y   = ', num2str(Py(1), '%6.5g'),...
    'x + ', num2str(Py(2))], 'color','r') 
else 
text(x_text,dnuy_text1, ['y   = ', num2str(Py(1), '%6.5g'),...
    'x ', num2str(Py(2))], 'color','r') 
end

text(x_text,dnuy_text2, ['\xi_y  = ', num2str(-1*(Py(1))*alpha_c,...
    '%6.5g')], 'color','r') 

title('Vertical Chromaticity','color', 'r');
hold on

xlabel('\Deltaf/f');
ylabel('\Delta\nu_y');
grid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.status_statictext,'string', 'Complete Measuremnt');

%%%%%%%%%%%%%%%%%%%% Print Bitmap file of the page %%%%%%%%%%%%5%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pathname = 'D:\MATLAB for measurement\beam measurement\output\Chromaticity\';
filenamebmp = [pathname 'Chromo-' date '.bmp'];
fpfig = fopen(filenamebmp,'w');
disp('done')
print(chromaticity,'-dbitmap',filenamebmp);
fclose(fpfig);
clear(pathname)

    
% --- Executes on button press in setrf_pushbutton.
function setrf_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to setrf_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in set_pushbutton.
function set_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to set_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fRF RF_step fRF_10digit RF_step_10digit

fRF = str2num(get(handles.statrfreq_edittext, 'string'));
RF_step = str2num(get(handles.stepfreq_edittext, 'string'));
fRF_10digit = fRF*10^7;
RF_step_10digit = RF_step*10^7;

% --- Executes on button press in plotchromo_pushbutton.
function plotchromo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotchromo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function statrfreq_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to statrfreq_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of statrfreq_edittext as text
%        str2double(get(hObject,'String')) returns contents of statrfreq_edittext as a double


% --- Executes during object creation, after setting all properties.
function statrfreq_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statrfreq_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepfreq_edittext_Callback(hObject, eventdata, handles)
% hObject    handle to stepfreq_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepfreq_edittext as text
%        str2double(get(hObject,'String')) returns contents of stepfreq_edittext as a double


% --- Executes during object creation, after setting all properties.
function stepfreq_edittext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepfreq_edittext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

