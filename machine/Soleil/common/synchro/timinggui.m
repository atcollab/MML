function varargout = timinggui(varargin)
% TIMINGGUI M-file for timinggui.fig
%      TIMINGGUI, by itself, creates a new TIMINGGUI or raises the existing
%      singleton*.
%
%      H = TIMINGGUI returns the handle to a new TIMINGGUI or the handle to
%      the existing singleton*.
%
%      TIMINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMINGGUI.M with the given input arguments.
%
%      TIMINGGUI('Property','Value',...) creates a new TIMINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before timinggui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to timinggui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help timinggui

% Last Modified by GUIDE v2.5 07-Oct-2005 14:24:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @timinggui_OpeningFcn, ...
                   'gui_OutputFcn',  @timinggui_OutputFcn, ...
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


% --- Executes just before timinggui is made visible.
function timinggui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to timinggui (see VARARGIN)

% Choose default command line output for timinggui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes timinggui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.device_carte1 ='BOO/SY/CPT.1';
handles.device_carte2 ='LT1/SY/CPT.1';
handles.device_carte3 ='BOO/SY/CPT.2';

str1 = {'delayCounter0', 'delayCounter1', 'delayCounter2', ...
    'delayCounter3', 'delayCounter4', 'delayCounter5', 'delayCounter6', 'delayCounter7'};

str2 = {'counter0Enable', 'counter1Enable', 'counter2Enable', ...
    'counter3Enable', 'counter4Enable', 'counter5Enable', 'counter6Enable', ...
    'counter7Enable'};

nb = length(str1);
handles.delayname1 = [repmat(handles.device_carte1,nb,1) repmat('/',nb,1) cell2mat(str1')];
handles.delayname2 = [repmat(handles.device_carte2,nb,1) repmat('/',nb,1) cell2mat(str1')];
handles.delayname3 = [repmat(handles.device_carte3,nb,1) repmat('/',nb,1) cell2mat(str1')];
handles.enablename1 = [repmat(handles.device_carte1,nb,1) repmat('/',nb,1) cell2mat(str2')];
handles.enablename2 = [repmat(handles.device_carte2,nb,1) repmat('/',nb,1) cell2mat(str2')];
handles.enablename3 = [repmat(handles.device_carte3,nb,1) repmat('/',nb,1) cell2mat(str2')];

% Reads all delays for card #1, 2
handles.delayvalue1 = readattribute(handles.delayname1);
handles.delayvalue2 = readattribute(handles.delayname2);
handles.delayvalue3 = readattribute(handles.delayname3);

% Update handles structure
guidata(hObject, handles);

%pushbutton_acquisition_Callback(handles.pushbutton_acquisition,eventdata,handles);


% --- Outputs from this function are returned to the command line.
function varargout = timinggui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_carte1_5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_5 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_5 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte1_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte1_4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_4 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_4 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte1_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte1_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_3 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte1_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte1_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_2 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte1_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte1_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_1 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte1_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_carte1_0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_0 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_0 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte1_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte2_5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_5 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_5 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte2_4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_4 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_4 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte2_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_3 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte2_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_2 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte2_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_1 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte2_0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_0 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_0 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_carte2_7_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_7 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_7 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte2_6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte2_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte2_6 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte2_6 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte2_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte2_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte3_5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_5 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_5 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte3_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte3_4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_4 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_4 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte3_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte3_3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_3 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_3 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte3_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte3_2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_2 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_2 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte3_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte3_1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_1 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_1 as a double
setdelay(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_carte3_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_carte3_0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_0 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_0 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte3_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte3_7_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_7 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_7 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte3_7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte3_6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte3_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte3_6 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte3_6 as a double


% --- Executes during object creation, after setting all properties.
function edit_carte3_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte3_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_acquisition.
function pushbutton_acquisition_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_acquisition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reads all delays for card #1, 2
handles.delayvalue1 = readattribute(handles.delayname1);
handles.delayvalue2 = readattribute(handles.delayname2);
handles.delayvalue3 = readattribute(handles.delayname3);
handles.enablevalue1 = readattribute(handles.enablename1);
handles.enablevalue2 = readattribute(handles.enablename2);
handles.enablevalue3 = readattribute(handles.enablename3);

% Update handles structure
guidata(hObject, handles);

nb = length(handles.delayvalue1);

% update display for Card1
for k = 1:nb,
    set(handles.(['edit_carte1_' num2str(k-1)]),'String',num2str(handles.delayvalue1(k),7));
    set(handles.(['checkbox_carte1_' num2str(k-1)]),'Value',handles.enablevalue1(k));
end

% update display for Card2
for k = 1:nb,
    set(handles.(['edit_carte2_' num2str(k-1)]),'String',num2str(handles.delayvalue2(k),7));
    set(handles.(['checkbox_carte2_' num2str(k-1)]),'Value',handles.enablevalue2(k));
end

% update display for Card3
for k = 1:nb,
    set(handles.(['edit_carte3_' num2str(k-1)]),'String',num2str(handles.delayvalue3(k),7));
    set(handles.(['checkbox_carte3_' num2str(k-1)]),'Value',handles.enablevalue3(k));
end

% get state of the 3 counter cards
set(handles.checkbox_status1,'String',tango_command_inout2(handles.device_carte1,'State'))
set(handles.checkbox_status2,'String',tango_command_inout2(handles.device_carte2,'State'))
set(handles.checkbox_status3,'String',tango_command_inout2(handles.device_carte3,'State'))


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_carte1_6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_6 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_6 as a double


% --- Executes during object creation, after setting all properties.
function edit_carte1_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_carte1_7_Callback(hObject, eventdata, handles)
% hObject    handle to edit_carte1_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_carte1_7 as text
%        str2double(get(hObject,'String')) returns contents of edit_carte1_7 as a double

setdelay(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_carte1_7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_carte1_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_carte1_0.
function checkbox_carte1_0_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_0

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte1_2.
function checkbox_carte1_2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_2

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte1_3.
function checkbox_carte1_3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_3

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte1_4.
function checkbox_carte1_4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_4

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte1_5.
function checkbox_carte1_5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_5

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte1_6.
function checkbox_carte1_6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_6

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte1_7.
function checkbox_carte1_7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_7

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte1_1.
function checkbox_carte1_1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte1_1

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_0.
function checkbox_carte2_0_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_0

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_2.
function checkbox_carte2_2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_2

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_3.
function checkbox_carte2_3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_3

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_4.
function checkbox_carte2_4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_4

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_5.
function checkbox_carte2_5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_5

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_6.
function checkbox_carte2_6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_6

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_7.
function checkbox_carte2_7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_7

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte2_1.
function checkbox_carte2_1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte2_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte2_1

setoutput(hObject, handles)


% --- Executes on button press in checkbox_carte3_0.
function checkbox_carte3_0_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_0

setoutput(hObject, handles)


% --- Executes on button press in checkbox_carte3_2.
function checkbox_carte3_2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_2

setoutput(hObject, handles)


% --- Executes on button press in checkbox_carte3_3.
function checkbox_carte3_3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_3

setoutput(hObject, handles)


% --- Executes on button press in checkbox_carte3_4.
function checkbox_carte3_4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_4

setoutput(hObject, handles)


% --- Executes on button press in checkbox_carte3_5.
function checkbox_carte3_5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_5

setoutput(hObject, handles)


% --- Executes on button press in checkbox_carte3_6.
function checkbox_carte3_6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_6

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte3_7.
function checkbox_carte3_7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_7

setoutput(hObject, handles)

% --- Executes on button press in checkbox_carte3_1.
function checkbox_carte3_1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_carte3_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_carte3_1

setoutput(hObject, handles)

% Generic function to set delays
function setdelay(hObject, handles)

val = str2double(get(hObject,'String'));
tag = get(hObject,'Tag');
id = regexpi(tag,'carte');

cardnum = tag(id+5);
outputnum = str2double(tag(id+7));

writeattribute(handles.(['delayname' cardnum])(outputnum+1,:),val);    

% Generic function to enable/disable output
function setoutput(hObject, handles)

val = get(hObject,'Value');
tag = get(hObject,'Tag');
id = regexpi(tag,'carte');

cardnum = tag(id+5);
outputnum = str2double(tag(id+7));

writeattribute(handles.(['enablename' cardnum])(outputnum+1,:),uint8(val));    

% --------------------------------------------------------------------
function menu_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delayvalue1 = readattribute(handles.delayname1);
delayvalue2 = readattribute(handles.delayname2);
delayvalue3 = readattribute(handles.delayname3);
enablevalue1 = readattribute(handles.enablename1);
enablevalue2 = readattribute(handles.enablename2);
enablevalue3 = readattribute(handles.enablename3);

FileName = 'synchro';
DirectoryName = getfamilydata('Directory','Timing');
FileName = appendtimestamp(FileName, clock);
[FileName, DirectoryName] = uiputfile('*.mat','Save Lattice to ...', [DirectoryName FileName]);
if FileName == 0
    fprintf('   File not saved \n');
    return;
end

% Save all data in structure to file
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
try
    save(FileName, 'delayvalue1', 'delayvalue2', 'delayvalue3',...
                   'enablevalue1', 'enablevalue2', 'enablevalue3');
catch
    cd(DirStart);
    return
end
cd(DirStart);

% --------------------------------------------------------------------
function menu_load_Callback(hObject, eventdata, handles)
% hObject    handle to menu_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DirSpec   =  getfamilydata('Directory','Timing');           %default to Configuration data directory
FileName  =  [];                                %no default file
[FileName, DirSpec,FilterIndex]=uigetfile('*.mat','Select Configuration File',[DirSpec FileName]);
FileSpec=[DirSpec FileName];

try
    cnf=load([DirSpec FileName]);          %load configuration from archive
catch
    return
end

writeattribute(handles.delayname1, cnf.delayvalue1);
writeattribute(handles.delayname2, cnf.delayvalue2);
writeattribute(handles.delayname3, cnf.delayvalue3);
writeattribute(handles.enablename1, cnf.enablevalue1, 'uint8');
writeattribute(handles.enablename2, cnf.enablevalue2, 'uint8');
writeattribute(handles.enablename3, cnf.enablevalue3, 'uint8');

%refresh data in GUI
pushbutton_acquisition_Callback(handles.pushbutton_acquisition,eventdata,handles);


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.checkbox_status1,'Value') == 1
    tango_command_inout2(handles.device_carte1,'Start');
end

if get(handles.checkbox_status2,'Value') == 1
    tango_command_inout2(handles.device_carte2,'Start');
end

if get(handles.checkbox_status3,'Value') == 1
    tango_command_inout2(handles.device_carte3,'Start');
end

pushbutton_acquisition_Callback(handles.pushbutton_acquisition, eventdata, handles)

% --- Executes on button press in pushbutton_stop.
function pushbutton_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.checkbox_status1,'Value') == 1
    tango_command_inout2(handles.device_carte1,'Stop');
end

if get(handles.checkbox_status2,'Value') == 1
    tango_command_inout2(handles.device_carte2,'Stop');
end

if get(handles.checkbox_status3,'Value') == 1
    tango_command_inout2(handles.device_carte3,'Stop');
end

pushbutton_acquisition_Callback(handles.pushbutton_acquisition, eventdata, handles)

% --- Executes on button press in checkbox_status1.
function checkbox_status1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_status1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_status1


% --- Executes on button press in checkbox_status2.
function checkbox_status2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_status2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_status2


% --- Executes on button press in checkbox_status3.
function checkbox_status3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_status3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_status3


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cmd = 'Init';

if get(handles.checkbox_status1,'Value') == 1
    tango_command_inout2(handles.device_carte1,cmd);
end

if get(handles.checkbox_status2,'Value') == 1
    tango_command_inout2(handles.device_carte2,cmd);
end

if get(handles.checkbox_status3,'Value') == 1
    tango_command_inout2(handles.device_carte3,cmd);
end

pushbutton_acquisition_Callback(handles.pushbutton_acquisition, eventdata, handles)

