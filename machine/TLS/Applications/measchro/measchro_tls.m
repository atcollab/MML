function varargout = measchro_tls(varargin)
% MEASCHRO_TLS M-file for measchro_tls.fig
%      MEASCHRO_TLS, by itself, creates a new MEASCHRO_TLS or raises the existing
%      singleton*.
%
%      H = MEASCHRO_TLS returns the handle to a new MEASCHRO_TLS or the handle to
%      the existing singleton*.
%
%      MEASCHRO_TLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASCHRO_TLS.M with the given input arguments.
%
%      MEASCHRO_TLS('Property','Value',...) creates a new MEASCHRO_TLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before measchro_tls_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to measchro_tls_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help measchro_tls

% Last Modified by GUIDE v2.5 10-Sep-2010 14:08:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @measchro_tls_OpeningFcn, ...
                   'gui_OutputFcn',  @measchro_tls_OutputFcn, ...
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


% --- Executes just before measchro_tls is made visible.
function measchro_tls_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to measchro_tls (see VARARGIN)

% Choose default command line output for measchro_tls
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

chro_tls('Model',handles);

% UIWAIT makes measchro_tls wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = measchro_tls_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in measure.
function measure_Callback(hObject, eventdata, handles)
% hObject    handle to measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mode = getmode('RF');
[Chromaticity, FileName] = chro_tls(Mode,handles);
set(handles.measure,'UserData',Chromaticity);




function S1_Callback(hObject, eventdata, handles)
% hObject    handle to S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.betax);
title('');
cla;
axes(handles.betay);
title('');
cla;
chro_tls('Model',handles);

% Hints: get(hObject,'String') returns contents of S1 as text
%        str2double(get(hObject,'String')) returns contents of S1 as a double


% --- Executes during object creation, after setting all properties.
function F1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function S3_Callback(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F2 as text
%        str2double(get(hObject,'String')) returns contents of F2 as a double


% --- Executes during object creation, after setting all properties.
function S3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Q3_Callback(hObject, eventdata, handles)
% hObject    handle to Q3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Q3 as text
%        str2double(get(hObject,'String')) returns contents of Q3 as a double


% --- Executes during object creation, after setting all properties.
function Q3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Q4_Callback(hObject, eventdata, handles)
% hObject    handle to Q4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Q4 as text
%        str2double(get(hObject,'String')) returns contents of Q4 as a double


% --- Executes during object creation, after setting all properties.
function Q4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.S1, 'String', 1);
set(handles.S2, 'String', 10);
set(handles.S1, 'UserData', []);
set(handles.S2, 'UserData', []);
set(handles.IF1, 'String', []);
set(handles.IF2, 'String', []);
set(handles.IF3, 'String', []);
set(handles.IF4, 'String', []);
set(handles.IF5, 'String', []);
set(handles.IF6, 'String', []);
set(handles.R1, 'String', []);
set(handles.R2, 'String', []);
set(handles.measure,'UserData',[]);
axes(handles.betax);
title('');
cla;
axes(handles.betay);
cla;
chro_tls('Model',handles);




function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function B1_Callback(hObject, eventdata, handles)
% hObject    handle to B1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B1 as text
%        str2double(get(hObject,'String')) returns contents of B1 as a double


% --- Executes during object creation, after setting all properties.
function B1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function B2_Callback(hObject, eventdata, handles)
% hObject    handle to B2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B2 as text
%        str2double(get(hObject,'String')) returns contents of B2 as a double


% --- Executes during object creation, after setting all properties.
function B2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function B3_Callback(hObject, eventdata, handles)
% hObject    handle to B3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B3 as text
%        str2double(get(hObject,'String')) returns contents of B3 as a double


% --- Executes during object creation, after setting all properties.
function B3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function B4_Callback(hObject, eventdata, handles)
% hObject    handle to B4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of B4 as text
%        str2double(get(hObject,'String')) returns contents of B4 as a double


% --- Executes during object creation, after setting all properties.
function B4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IF1_Callback(hObject, eventdata, handles)
% hObject    handle to IF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IF1 as text
%        str2double(get(hObject,'String')) returns contents of IF1 as a double


% --- Executes during object creation, after setting all properties.
function IF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IF2_Callback(hObject, eventdata, handles)
% hObject    handle to IF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IF2 as text
%        str2double(get(hObject,'String')) returns contents of IF2 as a double


% --- Executes during object creation, after setting all properties.
function IF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IF3_Callback(hObject, eventdata, handles)
% hObject    handle to IF3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IF3 as text
%        str2double(get(hObject,'String')) returns contents of IF3 as a double


% --- Executes during object creation, after setting all properties.
function IF3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IF3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IF4_Callback(hObject, eventdata, handles)
% hObject    handle to IF4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IF4 as text
%        str2double(get(hObject,'String')) returns contents of IF4 as a double


% --- Executes during object creation, after setting all properties.
function IF4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IF4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IF5_Callback(hObject, eventdata, handles)
% hObject    handle to IF5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IF5 as text
%        str2double(get(hObject,'String')) returns contents of IF5 as a double


% --- Executes during object creation, after setting all properties.
function IF5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IF5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IF6_Callback(hObject, eventdata, handles)
% hObject    handle to IF6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IF6 as text
%        str2double(get(hObject,'String')) returns contents of IF6 as a double


% --- Executes during object creation, after setting all properties.
function IF6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IF6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T1_Callback(hObject, eventdata, handles)
% hObject    handle to T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T1 as text
%        str2double(get(hObject,'String')) returns contents of T1 as a double


% --- Executes during object creation, after setting all properties.
function T1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T2_Callback(hObject, eventdata, handles)
% hObject    handle to T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T2 as text
%        str2double(get(hObject,'String')) returns contents of T2 as a double


% --- Executes during object creation, after setting all properties.
function T2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T3_Callback(hObject, eventdata, handles)
% hObject    handle to T3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T3 as text
%        str2double(get(hObject,'String')) returns contents of T3 as a double


% --- Executes during object creation, after setting all properties.
function T3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T4_Callback(hObject, eventdata, handles)
% hObject    handle to T4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T4 as text
%        str2double(get(hObject,'String')) returns contents of T4 as a double


% --- Executes during object creation, after setting all properties.
function T4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D1_Callback(hObject, eventdata, handles)
% hObject    handle to D1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D1 as text
%        str2double(get(hObject,'String')) returns contents of D1 as a double


% --- Executes during object creation, after setting all properties.
function D1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D2_Callback(hObject, eventdata, handles)
% hObject    handle to D2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D2 as text
%        str2double(get(hObject,'String')) returns contents of D2 as a double


% --- Executes during object creation, after setting all properties.
function D2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D3_Callback(hObject, eventdata, handles)
% hObject    handle to D3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D3 as text
%        str2double(get(hObject,'String')) returns contents of D3 as a double


% --- Executes during object creation, after setting all properties.
function D3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on selection change in F2.
function F2_Callback(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns F2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from F2


% --- Executes during object creation, after setting all properties.
function F2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [Chromaticity, FileName] = chro_tls(varargin)
%chro_tls -  measures the chromaticity function emperically
%  Chrom         = chro_tls(DeltaRF, WaitFlag);
%  ChromHardware = chro_tls(DeltaRF, WaitFlag, 'Hardware'); 
%  ChromPhysics  = chro_tls(DeltaRF, WaitFlag, 'Physics');
%  ChromStruct   = chro_tls(DeltaRF, WaitFlag, 'Struct');
%
%  INPUTS
%  1. DeltaRF - Vector of master oscillator values to scan over
%               {Default:  [-.4% -.2% 0 .2% .4%] energy change}
%  2. WaitFlag >= 0, WaitFlag seconds before measuring the tune (sec)
%               = -1, wait until the magnets are done ramping
%               = -3, wait until the magnets are done ramping + a delay of 2.2*getfamilydata('TuneDelay') {default} 
%               = -4, wait until keyboard input
%               = -5, input the tune measurement manually by keyboard input
%  4. 'Hardware' - Returns chromaticity in hardware units (typically, Tune/MHz or Tune/MHz)
%     'Physics'  - Returns chromaticity in physics  units (Tune/(dp/p))  {Default}
%  5. 'Struct'  - Will return a two element dispersion data structure array {Default, unless Mode='Model'}
%     'Numeric' - Will return vector outputs
%  6. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Simulator' - Set/Get data on the simulated accelerator (ie, same commands as 'Online')
%     'Model'     - Get the model chromaticity directly from the model (uses modelchro, DeltaRF is ignored)
%     'Manual'    - Set/Get data manually
%  7. 'Archive'   - Save a chromaticity data structure to \<Directory.ChroData>\Chromaticity\
%                   with filename <ChroArchiveFile><Date><Time>.mat  {Default, unless Mode='Model'}
%                   To change the filename, included the filename after the 'Archive', '' to browse
%     'NoArchive' - No file archive {Default}
%  8. 'Display'   - Prints status information to the command window {Default, unless Mode='Model'}
%     'NoDisplay' - Nothing is printed to the command window
%
%  
%  OUTPUT
%                  | Horizontal Chromaticity |
%  ChromHardware = |                         |  [Delta Tune / Delta Frequency]
%                  | Vertical Chromaticity   |       (Hardware Units)
%
%  
%                 | Horizontal Chromaticity |
%  ChromPhysics = |                         |  [Delta Tune / Delta Energy]
%                 | Vertical Chromaticity   |       (Physics Units)
%
%  When computing physics units the momentum compaction factor is required.  The default MCF is
%  found using getmcf.  To override the default enter the new value after the 'Physics' input.
%  For example,  ChromPhysics = chro_tls(DeltaRF, WaitFlag, 'Physics', .0011);
%
%  Tune vs RF frequency or momentum are plotted to the screen
%
%  Fields for structure outputs:
%            Data: [2x1] Chromaticity vector
%      FamilyName: 'Chromaticity'
%         Monitor: Tune structure
%        Actuator: RF frequency structure
%   DeltaActuator: Vector of frequency shifts in Hz
%       TimeStamp: Timestamp
%  DataDescriptor: 'Chromacity'
%       CreatedBy: 'chro_tls'
%             MCF: Momentum compaction factor/linear
%              RF: Vector of frequency settings in Hz
%               X: Reference orbit
%               Y: Reference orbit
%           Tune0: Initial tune
%            Tune: Tune change with RF frequency, 2 row vectors
%              dp: Vector of normalized momentum shifts
%         PolyFit: Polynomial fit of chromaticity in terms of rf shift or momentum
%
%  NOTE
%  1. 'Hardware', 'Physics', 'Eta', 'Archive', 'Numeric', and 'Struct' are not case sensitive
%  2. 'Zeta' can be used instead of 'Physics'
%  3.  All inputs are optional
%  4.  One reason FamilyName is added to the output structure so that getrespmat can be 
%      used to locate archived dispersion measurements.
%  5.  Units for DeltaRF depend on the 'Physics' or 'Hardware' flags
%  6. Beware of what units you are working in.  The default units for chromaticity
%     are physics units.  This is an exception to the normal middle layer convention.
%     Hardware units for "chromaticity" is in tune change per change in RF frequency.  
%     Since this is an unusual unit to work with, the default units for chromaticity
%     is physics units.  Note that goal chromaticity is also stored in physics units.
%     plotchro can switch between 'Hardware' and 'Physics' after the measurement is taken.
%     As an example of the difference between the units, at Spear3 1 unit of chromaticity
%     in physics units corresponds to roughly -1.8 units in hardware units.  
%
%  See also plotchro, measdisp

%  Written by Greg Portmann and Jeff Corbett


NRFSteps = 1;
MCF = [];
BPMxFamily = gethbpmfamily;  % Just an extra monitor
BPMyFamily = getvbpmfamily;  % Just an extra monitor
StructOutputFlag = 0;
FileName = '';
ArchiveFlag = 1;
DisplayFlag = 1;
ModeFlag  = '';         % model, online, manual, or '' for default mode
UnitsFlag = 'Physics';  % hardware, physics, or '' for default units


% Look if 'struct' or 'numeric' in on the input line
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Numeric')
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        if length(varargin) > i
            % Look for a filename as the next input
            if ischar(varargin{i+1})
                FileName = varargin{i+1};
                varargin(i+1) = [];
            end
        end
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Zeta') || strcmpi(varargin{i},'Physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
                if any(size(MCF)>1)
                    error('Input MCF must be a scalar');
                end
            end
        end
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
                if any(size(MCF)>1)
                    error('Input MCF must be a scalar');
                end
            end
        end
    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    end
end
handles = varargin{1,length(varargin)};
varargin{1,length(varargin)} = [];
WaitFlag = str2num(get(handles.S2, 'String'));

% Default for Model is no display, no archive
if DisplayFlag == -1 || strcmpi(ModeFlag,'Model')
    DisplayFlag = 0;
end
if ArchiveFlag == -1 || strcmpi(ModeFlag,'Model')
    ArchiveFlag = 0;
end
if strcmpi(ModeFlag,'Model')
    FileName = -1;
end

% DeltaRF input
if length(varargin) >= 1
    if isnumeric(varargin{1})
        DeltaRF = varargin{1}; 
    else
        DeltaRF = [];
    end
else
    DeltaRF = [];
end

% WaitFlag input
if length(varargin) >= 2
    WaitFlag = varargin{2};
end
if isempty(WaitFlag) || WaitFlag == -3
    WaitFlag = 2.2 * getfamilydata('TuneDelay');
end
if isempty(WaitFlag)
    WaitFlag = input('   Delay for Tune Measurement (Seconds, Keyboard Pause = -4, or Manual Tune Input = -5) = ');
end


% Archive data structure
if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'ChroArchiveFile'));
        DirectoryName = getfamilydata('Directory','ChroData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Chromaticity', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select Chromaticity File', [DirectoryName FileName]);
        if FileName == 0 
            ArchiveFlag = 0;
            disp('   Chromaticity measurement canceled.');
            Chromaticity=[]; FileName='';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'ChroArchiveFile'));
        DirectoryName = getfamilydata('Directory','ChroData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Chromaticity', filesep];
        end
        FileName = [DirectoryName, FileName];
    end
end


% Get units from the RF frequency
if isempty(UnitsFlag)
    UnitsFlag = getfamilydata('RF','Setpoint','Units');
end


% if isempty(ModeFlag)
%     if strcmpi(getfamilydata('RF','Setpoint','Mode'), getfamilydata(BPMxFamily,'Monitor','Mode'))
%         ModeFlag = getfamilydata(BPMxFamily,'Monitor','Mode');
%     else
%         error('Mix Mode for RF and orbits');
%     end
% end



if strcmpi(UnitsFlag,'Hardware')
    RFUnitsString = getfamilydata('RF','Setpoint','HWUnits');
elseif strcmpi(UnitsFlag,'Physics')
    RFUnitsString = getfamilydata('RF','Setpoint','PhysicsUnits');
else
    error('RF units unknown.  Inputs DeltaRF directly.');
end

% DeltaRF default 
if isempty(DeltaRF)
    % Get the default from the AD is in Hardware units
    DeltaRF = str2num(get(handles.S1, 'String'))*[1,0.5,0,-0.5,-1];
    
    % If the default is not in the AD
    if isempty(DeltaRF)
        DeltaRF = getrf('Hardware') * getmcf * [-.004 -.002 0 .002 .004] ;  % .2% energy change per step

        %DeltaRF = [-2000 -1000 0 1000 2000];  % Hz
        %if strcmpi(RFUnitsString, 'Hz')
        %    % Default units OK
        %elseif strcmpi(RFUnitsString, 'kHz')
        %    % Change to kHz
        %    DeltaRF = DeltaRF / 1e3;
        %elseif strcmpi(RFUnitsString, 'MHz')
        %    % Change to MHz
        %    DeltaRF = DeltaRF / 1e6;
        %else
        %    error('RF units unknown.  Input DeltaRF directly or put the default in AD.DeltaRFChro.');
        %end
    else
        if strcmpi(UnitsFlag,'Physics')
            % Since the default from the AO must be in hardware units, change to physics units
            DeltaRF = hw2physics('RF', 'Setpoint', DeltaRF, [1 1], ModeFlag);
        end
    end    
end


% Check DeltaRF for resonable values
if strcmpi(RFUnitsString, 'MHz')
    if abs(max(DeltaRF)-min(DeltaRF)) > .020;  % .020 MHz
        tmp = questdlg(sprintf('%f MHz is a large RF change.  Do you want to continue?', abs(max(DeltaRF)-min(DeltaRF))),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Chromaticity=[];
            return
        end
    end
elseif strcmpi(RFUnitsString, 'kHz')
    if abs(max(DeltaRF)-min(DeltaRF)) > 20;  % kHz
        tmp = questdlg(sprintf('%f kHz is a large RF change.  Do you want to continue?', abs(max(DeltaRF)-min(DeltaRF))),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Chromaticity=[];
            return
        end
    end
elseif strcmpi(RFUnitsString, 'Hz')
    if abs(max(DeltaRF)-min(DeltaRF)) > 20000;  % Hz
        tmp = questdlg(sprintf('%f Hz is a large RF change.  Do you want to continue?', abs(max(DeltaRF)-min(DeltaRF))),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Chromaticity=[];
            return
        end
    end
else
    % Don't who how to check, hence no check made
end

% DeltaRF must be in "RFUnitsString" units at this point


RFsp = getrf('Struct', UnitsFlag, ModeFlag);

if isempty(MCF)
    MCF = getmcf(ModeFlag);
end


% Fill the chromaticity structure (response matrix structure + some fields)
c.Data = [];
c.FamilyName = 'Chromaticity';
% if isfamily('TUNE')
%     c.Monitor = family2datastruct('TUNE','Monitor',[1 1;1 2]);
% else
    c.Monitor = gettune('Struct', 'Model');  % Just to fill the structure
%     c.Monitor.Data = NaN * c.Monitor.Data;
% end
c.Actuator = RFsp;
c.ActuatorDelta = DeltaRF;
c.GeV = getenergy(ModeFlag);
c.DCCT = getam('DCCT', ModeFlag);
c.ModulationMethod = 'Unipolar';
c.WaitFlag = WaitFlag;
c.TimeStamp = clock;
c.Mode = ModeFlag;
c.Units = UnitsFlag;
c.UnitsString = [];
c.DataDescriptor = 'Chromaticity';
c.CreatedBy = 'chro_tls';
c.OperationalMode = getfamilydata('OperationalMode');

% Nonstandard response matrix fields
if strcmpi(ModeFlag,'Manual')
    c.X = NaN;
    c.Y = NaN;
else
    c.X = getx('Struct', UnitsFlag, ModeFlag);
    c.Y = gety('Struct', UnitsFlag, ModeFlag);
end
c.MCF = MCF;
RF0 = RFsp.Data(1);
c.dp = -DeltaRF / (RF0*MCF);


if strcmpi(ModeFlag,'Model')
    % No need for delays with the model
    WaitFlag = 0;
    ExtraDelay = 0; 
end



    % Start measurement
    if DisplayFlag
        fprintf('   Begin chromaticity measurement\n');
    end    
    for i = 1:length(DeltaRF)
        %setrf(RF0 + DeltaRF(i), UnitsFlag, ModeFlag);
        if (isempty(ModeFlag) && strcmpi(getfamilydata('RF','Setpoint','Mode'),'Manual')) || strcmpi(ModeFlag,'Manual')
            % One shot setting of RF
            setrf(RF0 + DeltaRF(i), UnitsFlag, ModeFlag);
        else
            % Slow setting of RF
            rf = getrf(UnitsFlag, ModeFlag);
            for k = 1:NRFSteps
                setsp('RF', rf + k/NRFSteps * (RF0+DeltaRF(i)-rf), [], -1, UnitsFlag, ModeFlag);
                pause(0.1);
            end
        end
        
        RF(:,i) = getrf(UnitsFlag, ModeFlag);
        if DisplayFlag
            fprintf('   %d. RF frequency is %.5f\n', i, RF(:,i));
        end

        % Wait for tune monitor to have fresh data
        if WaitFlag >= 0
            if DisplayFlag && ~strcmpi(ModeFlag,'Manual')
                fprintf('      Pausing %f seconds for the tune measurement\n', WaitFlag); 
                pause(0);
            end
            sleep(WaitFlag);
            if ~strcmpi(ModeFlag,'Model')
                h = msgbox(' Continue the process? ','','warn');
                hm = findall(h,'Type','Text');
                set(hm,'color','b');
                set(hm,'FontSize',10);
                set(hm,'FontWeight','bold');
                waitfor(h);
            end
            Tune(:,i) = gettune(ModeFlag);
        elseif WaitFlag == -4
            tmp = input('      Hit return when the tune measurement is ready. ');
            Tune(:,i) = gettune(ModeFlag);
        elseif WaitFlag == -5
            Tune(1,i) = input('      Input the horizontal tune = ');
            Tune(2,i) = input('      Input the  vertical  tune = ');
        else
            error('Tune delay method unknown');
        end 
        
        if ~strcmpi(ModeFlag,'Model')
            set(handles.IF1, 'String',getrf);
            set(handles.IF2, 'String',getrf-RF0/1000);
            set(handles.IF3, 'String',getdcct);
            set(handles.IF4, 'String',getenergy);
            Q = gettune;
            set(handles.IF5, 'String',Q(1)-c.Monitor.Data(1));
            set(handles.IF6, 'String',Q(2)-c.Monitor.Data(2));
        end

    end
    
    
    % Reset RF
    %setrf(RF0, UnitsFlag, ModeFlag);
    if isempty(ModeFlag) && strcmpi(getfamilydata('RF','Setpoint','Mode'),'Manual')
        % One shot setting of RF
        setrf(RF0, UnitsFlag, ModeFlag);
    else
        % Slow setting of RF
        rf = getrf(UnitsFlag, ModeFlag);
        for k = 1:NRFSteps
            setsp('RF', rf + k/NRFSteps * (RF0-rf), [], -1, UnitsFlag, ModeFlag);
            pause(0.1);
        end
    end
    sleep(WaitFlag);
    if ~strcmpi(ModeFlag,'Model')
        h = msgbox(' Continue the process? ','','warn');
        hm = findall(h,'Type','Text');
        set(hm,'color','b');
        set(hm,'FontSize',10);
        set(hm,'FontWeight','bold');
        waitfor(h);
        set(handles.IF1, 'String',getrf);
        set(handles.IF2, 'String',getrf-RF0/1000);
        set(handles.IF3, 'String',getdcct);
        set(handles.IF4, 'String',getenergy);
        Q = gettune;
        set(handles.IF5, 'String',Q(1)-c.Monitor.Data(1));
        set(handles.IF6, 'String',Q(2)-c.Monitor.Data(2));
    end
    % Load Tune measurements into the chromaticy structure
    c.Tune = Tune;
    
    if strcmpi(UnitsFlag,'Physics')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Tune Shift vs. Momentum %  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Horizontal tune vs. momentum
        p = polyfit(c.dp, Tune(1,:), 2);              %2nd order polynomial fit to data    
        c.PolyFit(1,:) = p;
        c.Data(1,1) = p(2);
        
        % Vertical  tune vs. rf frequency
        p = polyfit(c.dp, Tune(2,:), 2);
        c.PolyFit(2,:) = p;
        c.Data(2,1) = p(2);
        
        TuneUnitsString = getfamilydata('TUNE','Monitor','PhysicsUnits');
        if isempty(TuneUnitsString)
            c.UnitsString = ['Fractional Tune/(dp/p)'];
        else
            c.UnitsString = [TuneUnitsString,'/(dp/p)'];
        end
        
        %fprintf('\n   Horizontal Chromaticity (Un-normalized) = %f \n', c.Data(1));
        %fprintf('   Vertical   Chromaticity (Un-normalized) = %f \n'  , c.Data(2));
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Tune Shift vs. RF Frequency %  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Horizontal tune vs. rf frequency
        p = polyfit(DeltaRF, Tune(1,:), 2);      % 2nd order polynomial fit to data
        c.PolyFit(1,:) = p;
        c.Data(1,1) = p(2);
        
        % Vertical  tune vs. rf frequency
        p = polyfit(DeltaRF, Tune(2,:), 2);
        c.PolyFit(2,:) = p;
        c.Data(2,1) = p(2);
        
        TuneUnitsString = getfamilydata('TUNE','Monitor','HWUnits');
        if isempty(TuneUnitsString)
            c.UnitsString = ['Fractional Tune/',getfamilydata('RF','Setpoint','HWUnits')];
        else
            c.UnitsString = [TuneUnitsString,'/',getfamilydata('RF','Setpoint','HWUnits')];
        end
    end


if DisplayFlag
    fprintf('   Chromaticity = %f [%s]\n', c.Data(1), c.UnitsString);
    fprintf('   Chromaticity = %f [%s]\n', c.Data(2), c.UnitsString);
end

plotchro_tls(c,handles);



% Archive data structure
if ArchiveFlag
    % If the filename contains a directory then make sure it exists
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    Chromaticity = c;
    save(FileName, 'Chromaticity');
    if DisplayFlag
        fprintf('   Chromaticity data saved to %s.mat\n', [DirectoryName FileName]);
        if ErrorFlag
            fprintf('   Warning: %s was not the desired directory\n', DirectoryName);
        end
    end
    cd(DirStart);
    FileName = [DirectoryName, FileName, '.mat'];
end
if FileName == -1
    FileName = '';
end


% Load output data
if StructOutputFlag
    Chromaticity = c;
else
    Chromaticity = c.Data;
end


if DisplayFlag
    fprintf('   Chromaticity measurement is complete.\n');
end

function [c, FileName] = plotchro_tls(varargin)
%PLOTCHRO - Plot the chromaticity function
%  c = plotchro(c);
%  c = plotchro(c, 'Hardware');  plots in hardware units [Tune/MHz]
%  c = plotchro(c, 'Physics');   plots in physics  units [Tune/(dp/p)]
%  c = plotchro(FileName);
%  [c, FileName] = plotchro(''); prompts for a file
%
%  c is the chromacity structure returned by measchro
%
%  Note 1: 'Zeta' can be used instead of 'Physics'
%  Note 2: The default units comes from the structure c.Units
%
%  See also measchro

%  Written by Greg Portmann and Jeff Corbett


c = [];
PhysicsString = '';
FileName = '';


% Input parsing
UnitsFlag = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Zeta') || strcmpi(varargin{i},'Physics')
        UnitsFlag = [UnitsFlag varargin(i)];
        %if length(varargin) >= i+1         % Not using these inputs at the moment
        %    if isnumeric(varargin{i+1})
        %        MCF = varargin{i+1};
        %        if length(varargin) >= i+2
        %            if isnumeric(varargin{i+2})
        %                RF0 = varargin{i+2};
        %                varargin(i+2) = [];    
        %            end
        %        end
        %        varargin(i+1) = [];    
        %    end
        %end
        varargin(i) = [];    
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = [UnitsFlag varargin(i)];
        varargin(i) = [];    
    end
end


if length(varargin) >= 1
    if isstruct(varargin{1})
        c = varargin{1};
        handles = varargin{2};
    elseif ischar(varargin{1})
        FileName = varargin{1};
        handles = varargin{2};
    end
end
if isempty(c)
    [c, FileName] = getchro(FileName, 'Struct', UnitsFlag{:});
    axes(handles.betax);
    title('');
    cla;
    axes(handles.betay);
    cla;
    chro_tls([-1 -0.5 0 0.5 1]*c.ActuatorDelta,'Model',handles);
end
if ~isstruct(c)  
    error('Input must be a structure as returned by measchro');
end


Chromaticity = c.Data;
Tune =  c.Tune;
Units = c.Units;
UnitsString = c.UnitsString;
DeltaRF = c.ActuatorDelta;        


% Override the Units field
if isempty(UnitsFlag)
    PhysicsString = Units;
else
    PhysicsString = UnitsFlag{1};
end


if strcmpi(Units, 'Hardware')
    if strcmpi(PhysicsString,'Physics')
        % Change units to physics
        % MCF = c.MCF;
        % RF0 = c.Actuator.Data;
        % p = polyfit(c.dp, Tune(1,:), 2);
        % c.PolyFit(1,:) = p;
        % c.Data(1,1) = p(2);
        % p = polyfit(c.dp, Tune(2,:), 2);
        % c.PolyFit(2,:) = p;
        % c.Data(2,1) = p(2);
        % c.Units = 'Physics';
        % c.UnitsString = '1/(dp/p)';
        c = hw2physics(c);
        plotchro_tls(c);
        return
    end
    
    %================================================
    % Tune shift vs. rf frequency
    %================================================
    x2 = linspace(min(DeltaRF), max(DeltaRF), 1000);
    
    clf reset
    set(gcf,'NumberTitle','on','Name','Tune Shift vs. RF Frequency');
    subplot(2,1,1);
    if strcmpi(c.Actuator.UnitsString,'MHz')
        % Hz is easier to view
        plot(1e6*DeltaRF, Tune(1,:), 'ob','markersize',2);   % plot raw tune data 
    else
        plot(DeltaRF, Tune(1,:), 'ob','markersize',2);   % plot raw tune data 
    end
    hold on;
    p = c.PolyFit(1,:);
    y = polyval(p, x2);                  % evaluate polynomial on equispaced points x2
    if strcmpi(c.Actuator.UnitsString,'MHz')
        plot(1e6*x2, y, '-b');                   % plot polynomial fit
        xlabel('RF Frequency Change [Hz]');
    else
        plot(x2, y, '-b');                   % plot polynomial fit
        xlabel(sprintf('RF Frequency Change [%s]', c.Actuator.UnitsString));
    end
    hold off;
    title([num2str(p(1)),' x (drf/rf)^2  + ',num2str(p(2)),' x drf/rf  + ',num2str(p(3))]);
    ylabel('Horizontal Tune');
    
    subplot(2,1,2);
    if strcmpi(c.Actuator.UnitsString,'MHz')
        plot(1e6*DeltaRF, Tune(2,:), 'ob','markersize',2);   % plot raw tune data 
    else
        plot(DeltaRF, Tune(2,:), 'ob','markersize',2);       % plot raw tune data 
    end
    hold on;
    p = c.PolyFit(2,:);
    y = polyval(p, x2);
    if strcmpi(c.Actuator.UnitsString,'MHz')
        plot(1e6*x2, y, '-b');                   % plot polynomial fit
        xlabel('RF Frequency Change [Hz]');
    else
        plot(x2, y, '-b');                       % plot polynomial fit
        xlabel(sprintf('RF Frequency Change [%s]', c.Actuator.UnitsString));
    end    
    hold off;
    title([num2str(p(1)),' x (drf/rf)^2  + ',num2str(p(2)),' x drf/rf  + ',num2str(p(3))]);
    ylabel('Vertical Tune');
    if any(strcmpi(c.Monitor.Mode, {'Model','Simulator'}))
        addlabel(1,0,sprintf('%s (Model)', datestr(c.TimeStamp,0)));
    else
        addlabel(1,0,sprintf('%s', datestr(c.TimeStamp,0)));        
    end
    orient tall
    
elseif strcmpi(Units, 'Physics')
    if strcmpi(PhysicsString,'Hardware')
        % Change units to hardware
        %MCF = c.MCF;
        %RF0 = c.Actuator.Data;
        %p = polyfit(DeltaRF, Tune(1,:), 2);
        %c.PolyFit(1,:) = p;
        %c.Data(1,1) = p(2);
        %p = polyfit(DeltaRF, Tune(2,:), 2);
        %c.PolyFit(2,:) = p;
        %c.Data(2,1) = p(2);
        %c.Units = 'Hardware';
        %c.UnitsString = c.Actuator.UnitsString;
        c = physics2hw(c);
        
        plotchro_tls(c);
        return
    end

    %================================================
    % Tune shift vs. momentum    
    %================================================
    x2 = linspace(min(c.dp), max(c.dp), 1000);     %create momentum value interval
    
    axes(handles.betax);
    hold on;
    if strcmpi(c.Mode, 'Model')
        plot(100*c.dp,Tune(1,:), 'ob','markersize',6,'LineWidth',2);   %raw data
    else
        plot(100*c.dp,Tune(1,:), 'sr','markersize',10,'LineWidth',2);
    end
    grid on;
    hold on;
    p = c.PolyFit(1,:);
    y = polyval(p, x2);                          %evaluate polynomial on equispaced points x2
    if strcmpi(c.Mode, 'Model')
        plot(100*x2, y, '-b','LineWidth',2);                       %plot polynomial fit
    else
        plot(100*x2, y, '--r','LineWidth',2);              %plot polynomial fit
        C = modelchro*1000;
        set(handles.R1, 'String', sprintf('%+3.2d',p(2)-C(1)));
    end
    hold off;
    xlabel('Momentum Shift, dp/p [%]')
    ylabel('Horizontal Tune');
    if strcmpi(c.Mode, 'Model')
        set(handles.S1, 'UserData', []);
        title(['Model:  ',num2str(p(1)),' (dp/p)^2  + ',num2str(p(2)),' dp/p  + ',num2str(p(3))]);
        set(handles.S1, 'UserData', p);
        legend('Model','Model fit',0);
    else
        n = get(handles.S1, 'UserData');
        title({['Model:  ',num2str(n(1)),' (dp/p)^2  + ',num2str(n(2)),' dp/p  + ',num2str(n(3))];['Measure:  ',num2str(p(1)),' (dp/p)^2  + ',num2str(p(2)),' dp/p  + ',num2str(p(3))]});
        legend('Model','Model fit','Measure','Measure fit',0);
    end

    axes(handles.betay);
    hold on;
    if strcmpi(c.Mode, 'Model')
        plot(100*c.dp,Tune(2,:), 'ob','markersize',6,'LineWidth',2);   %raw data
    else
        plot(100*c.dp,Tune(2,:), 'sr','markersize',10,'LineWidth',2);
    end
    grid on;
    hold on;
    p = c.PolyFit(2,:);
    y = polyval(p, x2);
    if strcmpi(c.Mode, 'Model')
        plot(100*x2, y, '-b','LineWidth',2);                       %plot polynomial fit
    else
        plot(100*x2, y, '--r','LineWidth',2);                      %plot polynomial fit
        C = modelchro*1000;
        set(handles.R2, 'String', sprintf('%+3.2d',p(2)-C(2)));
    end
    hold off;
    xlabel('Momentum Shift, dp/p [%]')
    title([num2str(p(1)),' (dp/p)^2  + ',num2str(p(2)),' dp/p  + ',num2str(p(3))]);
    ylabel('Vertical Tune');
    if strcmpi(c.Mode, 'Model')
        set(handles.S2, 'UserData', []);
        title(['Model:  ',num2str(p(1)),' (dp/p)^2  + ',num2str(p(2)),' dp/p  + ',num2str(p(3))]);
        set(handles.S2, 'UserData', p);
        legend('Model','Model fit',0);
    else
        n = get(handles.S2, 'UserData');
        title({['Model:  ',num2str(n(1)),' (dp/p)^2  + ',num2str(n(2)),' dp/p  + ',num2str(n(3))];['Measure:  ',num2str(p(1)),' (dp/p)^2  + ',num2str(p(2)),' dp/p  + ',num2str(p(3))]});
        legend('Model','Model fit','Measure','Measure fit',0);
    end
%     if any(strcmpi(c.Monitor.Mode, {'Model','Simulator'}))
%         addlabel(1,0,sprintf('%s (Model)', datestr(c.TimeStamp,0)));
%     else
%         addlabel(1,0,sprintf('%s', datestr(c.TimeStamp,0)));        
%     end
    %addlabel(1,0,sprintf('%s', datestr(c.TimeStamp,0)));
    orient tall
    
else
    error('UnitsString unknown type');
end    

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Reset_Callback(hObject, eventdata, handles);
% [FileName, DirectoryName] = uigetfile;
% FileName = [DirectoryName FileName];
plotchro_tls('',handles);



function R1_Callback(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R1 as text
%        str2double(get(hObject,'String')) returns contents of R1 as a double


% --- Executes during object creation, after setting all properties.
function R1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R2_Callback(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R2 as text
%        str2double(get(hObject,'String')) returns contents of R2 as a double


% --- Executes during object creation, after setting all properties.
function R2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in F1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of F1


% --- Executes on button press in F2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to F2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of F2



function CS1_Callback(hObject, eventdata, handles)
% hObject    handle to CS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CS1 as text
%        str2double(get(hObject,'String')) returns contents of CS1 as a double


% --- Executes during object creation, after setting all properties.
function CS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CS2_Callback(hObject, eventdata, handles)
% hObject    handle to CS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CS2 as text
%        str2double(get(hObject,'String')) returns contents of CS2 as a double


% --- Executes during object creation, after setting all properties.
function CS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
step_chro(handles);
set(handles.measure,'UserData',[]);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.F1,'Value',0);
set(handles.F2,'Value',0);
set(handles.CS1,'String',[]);
set(handles.CS2,'String',[]);
set(handles.SC1,'String',[]);
set(handles.SC2,'String',[]);




function SC1_Callback(hObject, eventdata, handles)
% hObject    handle to SC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SC1 as text
%        str2double(get(hObject,'String')) returns contents of SC1 as a double


% --- Executes during object creation, after setting all properties.
function SC1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SC2_Callback(hObject, eventdata, handles)
% hObject    handle to SC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SC2 as text
%        str2double(get(hObject,'String')) returns contents of SC2 as a double


% --- Executes during object creation, after setting all properties.
function SC2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function  [DelSext, ActuatorFamily] = step_chro(varargin)
%STEPCHRO - Incremental change in the chromaticity (Delta Tune / Delta RF)
%  [DelSext, SextFamily] = stepchro(DeltaChromaticity, ChroResponseMatrix)
%
%  Step change in storage ring chromaticity using the default chromaticty correctors (findmemberof('Chromaticity Corrector'))
%
%  INPUTS
%  1.                     | Change in Horizontal Chromaticity |
%     DeltaChromaticity = |                                   | 
%                         | Change in Vertical Chromaticity   |
%  2. ChroResponseMatrix - Chromaticity response matrix {Default: getchroresp}
%  3. Optional override of the units:
%     'Physics'  - Use physics  units {Default}
%     'Hardware' - Use hardware units
%  4. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Simulator' - Set/Get data on the simulated accelerator
%     'Model'     - (same as 'Simulator')
%     'Manual'    - Set/Get data manually
%
%  OUTPUTS
%  1. DelSext
%  2. SextFamily - Families used (cell array)
%
%  ALGORITHM  
%  DelSext = inv(CHROMATICITY_RESP_MATRIX) * DeltaChromaticity
%
%  NOTES
%  1. Beware of what units you are working in.  The default units for chromaticity
%     are physics units.  This is an exception to the normal middle layer convention.
%     Hardware units for "chromaticity" is in tune change per change in RF frequency.  
%     Since this is an unusual unit to work with, the default units for chromaticity
%     is physics units.  Note that goal chromaticity is also stored in physics units.
%  2. The actuator family comes from findmemberof('Chromaticity Corrector') or 'SF','SD' if empty
%  
%  See also getchro, setchro, measchroresp

%  Written by Greg Portmann

handles = varargin{1};
varargin = [];
ActuatorFamily = findmemberof('Chromaticity Corrector')';
if get(handles.F2,'Value') == 0
    ActuatorFamily(2) = [];
end
if get(handles.F1,'Value') == 0
    ActuatorFamily(1) = [];
end
if isempty(ActuatorFamily)
    error('MemberOf ''Chromaticity Corrector'' was not found');
end

ModeFlag  = {};           % model, online, manual, or '' for default mode
UnitsFlag = {'Physics'};  % hardware, physics, or '' for default units

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'physics')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        ModeFlag = varargin(i);
        varargin(i) = [];
    end        
end


if length(varargin) >= 1
    DeltaChrom = varargin{1};
else
    DeltaChrom = [];    
end
if isempty(DeltaChrom)
%     answer = inputdlg({'Change the horizontal chromaticity by', 'Change the vertical chromaticity by'},'STEPCHRO',1,{'0','0'});
%     if isempty(answer)
%         return
%     end
    DeltaChrom(1,1) = str2num(get(handles.CS1,'String'));
    DeltaChrom(2,1) = str2num(get(handles.CS2,'String'));
end
DeltaChrom = DeltaChrom(:);
if size(DeltaChrom,1) ~= 2
    error('Input must be a 2x1 column vector.');
end
% if DeltaChrom(1)==0 && DeltaChrom(2)==0
%     return
% end
MeasuredChrom = get(handles.measure,'UserData');
if isempty(MeasuredChrom)
    h = msgbox(' Please measure the chromaticity first! ','','warn');
    hm = findall(h,'Type','Text');
    set(hm,'color','b');
    set(hm,'FontSize',8);
%     set(hm,'FontWeight','bold');
    return
end
DeltaChrom = DeltaChrom - MeasuredChrom;
if length(varargin) >= 2
    ChroResponseMatrix = varargin{2};
else
    ChroResponseMatrix = [];    
end
if isempty(ChroResponseMatrix)
    ChroResponseMatrix = getchroresp(UnitsFlag{:});
end
if isempty(ChroResponseMatrix)
    error('The chromaticity response matrix must be an input or available in one of the default response matrix files.');
end


% 1. SVD Tune Correction
% Decompose the chromaticity response matrix:
[U, S, V] = svd(ChroResponseMatrix, 'econ');
% ChroResponseMatrix = U*S*V'
%
% The V matrix columns are the singular vectors in the sextupole magnet space
% The U matrix columns are the singular vectors in the chromaticity space
% U'*U=I and V*V'=I
%
% CHROCoef is the projection onto the columns of ChroResponseMatrix*V(:,Ivec) (same space as spanned by U)
% Sometimes it's interesting to look at the size of these coefficients with singular value number.
CHROCoef = diag(diag(S).^(-1)) * U' * DeltaChrom;
%
% Convert the vector CHROCoef back to coefficents of ChroResponseMatrix
DelSext = V * CHROCoef;
for i=1:length(ActuatorFamily)
    switch ActuatorFamily{i}
        case 'SF'
            Amps = getsp('SF');
            set(handles.SC1,'UserData',Amps);
        case 'SD'
            Amps = getsp('SD');
            set(handles.SC2,'UserData',Amps);
    end
end

% 2. Square matrix solution
%DelSext = inv(ChroResponseMatrix) * DeltaChrom;


SP = getsp(ActuatorFamily, UnitsFlag{:}, ModeFlag{:});

if iscell(SP)
    for i = 1:length(SP)
        SP{i} = SP{i} + DelSext(i);
    end
else
    SP = SP + DelSext;
end


setsp(ActuatorFamily, SP, UnitsFlag{:}, ModeFlag{:});

for i=1:length(ActuatorFamily)
    switch ActuatorFamily{i}
        case 'SF'
            Amps1 = get(handles.SC1,'UserData');
            Amps2 = getsp('SF');
            Amps = Amps2 - Amps1;
            set(handles.SC1,'String',Amps(1));
        case 'SD'
            Amps1 = get(handles.SC2,'UserData');
            Amps2 = getsp('SD');
            Amps = Amps2 - Amps1;
            set(handles.SC2,'String',Amps(1));
    end
end



% --- Executes during object creation, after setting all properties.
function S1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function S2_Callback(hObject, eventdata, handles)
% hObject    handle to S2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of S2 as text
%        str2double(get(hObject,'String')) returns contents of S2 as a double


% --- Executes during object creation, after setting all properties.
function S2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in F1.
function F1_Callback(hObject, eventdata, handles)
% hObject    handle to F1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of F1
