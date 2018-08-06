function varargout = synchro_survey(varargin)
% SYNCHRO_SURVEY M-file for synchro_survey.fig
%      SYNCHRO_SURVEY, by itself, creates a new SYNCHRO_SURVEY or raises the existing
%      singleton*.
%
%      H = SYNCHRO_SURVEY returns the handle to a new SYNCHRO_SURVEY or the handle to
%      the existing singleton*.
%
%      SYNCHRO_SURVEY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNCHRO_SURVEY.M with the given input arguments.
%
%      SYNCHRO_SURVEY('Property','Value',...) creates a new SYNCHRO_SURVEY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before synchro_survey_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to synchro_survey_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help synchro_survey

% Last Modified by GUIDE v2.5 12-Mar-2007 04:30:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @synchro_survey_OpeningFcn, ...
                   'gui_OutputFcn',  @synchro_survey_OutputFcn, ...
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


% --- Executes just before synchro_survey is made visible.
function synchro_survey_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to synchro_survey (see VARARGIN)

% Choose default command line output for synchro_survey
handles.output = hObject;

pushbutton_get_status_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes synchro_survey wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = synchro_survey_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_LIN_lpm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LIN_lpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LIN_lpm as text
%        str2double(get(hObject,'String')) returns contents of edit_LIN_lpm as a double



% --- Executes during object creation, after setting all properties.
function edit_LIN_lpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LIN_lpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_lt1_reset_get_status.
function pushbutton_get_status_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_reset_get_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=30;

temp=tango_read_attribute('LIN/SY/LOCAL.SPM.1','Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_LIN_spm, 'String',txt);
set(handles.edit_LIN_spm,'BackgroundColor',color);

temp=tango_read_attribute('LIN/SY/LOCAL.LPM.1','Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_LIN_lpm, 'String',txt);
set(handles.edit_LIN_lpm,'BackgroundColor',color);

temp=tango_read_attribute('BOO/SY/LOCAL.Binj.1','Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_BOO_Binj, 'String',txt);
set(handles.edit_BOO_Binj,'BackgroundColor',color);

temp=tango_read_attribute('BOO/SY/LOCAL.Alim.1',  'Status');txt=temp.value; [txt, color]=state_txt(txt);
set(handles.edit_BOO_Alim, 'String',txt);
set(handles.edit_BOO_Alim,'BackgroundColor',color);

temp=tango_read_attribute('BOO/SY/LOCAL.DG.3', 'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_BOO_DG3, 'String',txt);
set(handles.edit_BOO_DG3,'BackgroundColor',color);

temp=tango_read_attribute('BOO/SY/LOCAL.Bext.1',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_BOO_Bext, 'String',txt);
set(handles.edit_BOO_Bext,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C01/SY/LOCAL.Ainj.1', 'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_Ainj1, 'String',txt);
set(handles.edit_ANS_Ainj1,'BackgroundColor',color); 

temp=tango_read_attribute('ANS-C01/SY/LOCAL.Ainj.2',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_Ainj2, 'String',txt);
set(handles.edit_ANS_Ainj2, 'BackgroundColor',color);

temp=tango_read_attribute('ANS-C01/SY/LOCAL.DG.2',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_C01, 'String',txt);
set(handles.edit_ANS_C01,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C03/SY/LOCAL.DG.1',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_C03, 'String',txt);
set(handles.edit_ANS_C03,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C05/SY/LOCAL.DG.1',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_C05, 'String',txt);
set(handles.edit_ANS_C05,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C07/SY/LOCAL.DG.1', 'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_C07, 'String',txt);
set(handles.edit_ANS_C07,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C09/SY/LOCAL.DG.1',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_C09, 'String',txt);
set(handles.edit_ANS_C09,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C11/SY/LOCAL.DG.1', 'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_C11, 'String',txt);
set(handles.edit_ANS_C11,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C13/SY/LOCAL.DG.1',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_C13, 'String',txt);
set(handles.edit_ANS_C13,'BackgroundColor',color);

temp=tango_read_attribute('ANS-C15/SY/LOCAL.DG.1',  'Status');txt=temp.value; [txt, color]=state_txt(txt);
set(handles.edit_ANS_C15, 'String',txt);
set(handles.edit_ANS_C15,'BackgroundColor',color);

temp=tango_read_attribute('ANS/SY/LOCAL.SDC.1',  'Status');txt=temp.value;[txt, color]=state_txt(txt);
set(handles.edit_ANS_SDC, 'String',txt);
set(handles.edit_ANS_SDC,'BackgroundColor',color);

function edit_BOO_Binj_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BOO_Binj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BOO_Binj as text
%        str2double(get(hObject,'String')) returns contents of edit_BOO_Binj as a double


% --- Executes during object creation, after setting all properties.
function edit_BOO_Binj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BOO_Binj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BOO_Alim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BOO_Alim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BOO_Alim as text
%        str2double(get(hObject,'String')) returns contents of edit_BOO_Alim as a double


% --- Executes during object creation, after setting all properties.
function edit_BOO_Alim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BOO_Alim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BOO_DG3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BOO_DG3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BOO_DG3 as text
%        str2double(get(hObject,'String')) returns contents of edit_BOO_DG3 as a double


% --- Executes during object creation, after setting all properties.
function edit_BOO_DG3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BOO_DG3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BOO_Bext_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BOO_Bext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BOO_Bext as text
%        str2double(get(hObject,'String')) returns contents of edit_BOO_Bext as a double


% --- Executes during object creation, after setting all properties.
function edit_BOO_Bext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BOO_Bext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_Ainj1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_Ainj1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_Ainj1 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_Ainj1 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_Ainj1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_Ainj1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_Ainj2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_Ainj2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_Ainj2 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_Ainj2 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_Ainj2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_Ainj2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C01_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C01 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C01 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C01_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C03_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C03 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C03 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C03_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C05_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C05 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C05 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C05_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C07_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C07 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C07 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C07_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C09_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C09 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C09 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C09_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C11_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C11 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C11 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C13_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C13 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C13 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_C15_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_C15 as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_C15 as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_C15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_C15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ANS_SDC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ANS_SDC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ANS_SDC as text
%        str2double(get(hObject,'String')) returns contents of edit_ANS_SDC as a double


% --- Executes during object creation, after setting all properties.
function edit_ANS_SDC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ANS_SDC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_LIN_spm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LIN_spm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LIN_spm as text
%        str2double(get(hObject,'String')) returns contents of edit_LIN_spm as a double


% --- Executes during object creation, after setting all properties.
function edit_LIN_spm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LIN_spm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_lt1_reset_Update.
function pushbutton_Update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_reset_Update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


r=tango_command_inout2('ANS/SY/LOCAL.SDC.1',  'Update');retour_update('ANS/SY/LOCAL.SDC.1',r);
r=tango_command_inout2('LIN/SY/LOCAL.LPM.1','Update');retour_update('LIN/SY/LOCAL.LPM.1',r);
r=tango_command_inout2('LIN/SY/LOCAL.SPM.1','Update');retour_update('LIN/SY/LOCAL.SPM.1',r);

r=tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Update');    retour_update('BOO/SY/LOCAL.Binj.1',r);
r=tango_command_inout2('BOO/SY/LOCAL.Alim.1',  'Update'); retour_update('BOO/SY/LOCAL.Alim.1',r);
r=tango_command_inout2('BOO/SY/LOCAL.RF.1',  'Update'); retour_update('BOO/SY/LOCAL.RF.1',r);
r=tango_command_inout2('BOO/SY/LOCAL.DG.1', 'Update');retour_update('BOO/SY/LOCAL.DG.1',r);
r=tango_command_inout2('BOO/SY/LOCAL.DG.2', 'Update');retour_update('BOO/SY/LOCAL.DG.2',r);
r=tango_command_inout2('BOO/SY/LOCAL.DG.3', 'Update');retour_update('BOO/SY/LOCAL.DG.3',r);
r=tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Update');retour_update('BOO/SY/LOCAL.Bext.1',r);

r=tango_command_inout2('LT2/SY/LOCAL.DG.1',  'Update');retour_update('LT2/SY/LOCAL.DG.1',r);
r=tango_command_inout2('LT2/SY/LOCAL.DG.2',  'Update');retour_update('LT2/SY/LOCAL.DG.2',r);

r=tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update');retour_update('ANS-C01/SY/LOCAL.Ainj.1',r);
r=tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2',  'Update');retour_update('ANS-C01/SY/LOCAL.Ainj.2',r);
r=tango_command_inout2('ANS-C01/SY/LOCAL.DG.2',  'Update');retour_update('ANS-C01/SY/LOCAL.DG.2',r);
r=tango_command_inout2('ANS-C03/SY/LOCAL.DG.1',  'Update');retour_update('ANS-C03/SY/LOCAL.DG.1',r);
r=tango_command_inout2('ANS-C05/SY/LOCAL.DG.1',  'Update');retour_update('ANS-C05/SY/LOCAL.DG.1',r);
r=tango_command_inout2('ANS-C07/SY/LOCAL.DG.1', 'Update');retour_update('ANS-C07/SY/LOCAL.DG.1',r);
r=tango_command_inout2('ANS-C09/SY/LOCAL.DG.1',  'Update');retour_update('ANS-C09/SY/LOCAL.DG.1',r);
r=tango_command_inout2('ANS-C11/SY/LOCAL.DG.1', 'Update');retour_update('ANS-C11/SY/LOCAL.DG.1',r);
r=tango_command_inout2('ANS-C13/SY/LOCAL.DG.1',  'Update');retour_update('ANS-C13/SY/LOCAL.DG.1',r);
r=tango_command_inout2('ANS-C15/SY/LOCAL.DG.1',  'Update'); retour_update('ANS-C15/SY/LOCAL.DG.1',r);
r=tango_command_inout2('ANS/SY/LOCAL.SDC.1',  'Update');retour_update('ANS/SY/LOCAL.SDC.1',r);

r=tango_command_inout2('LT1/SY/LOCAL.DG.1', 'Update');retour_update('BOO/SY/LOCAL.DG.1',r);

% --- Executes on button press in pushbutton_lt1_reset_special.
function pushbutton_special_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_reset_special (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


event=int32(1);
att ='libre.1Event';
tango_write_attribute2('ANS/SY/LOCAL.SDC.1',att,event);
tango_write_attribute2('BOO/SY/LOCAL.Binj.1',att,event);
tango_write_attribute2('BOO/SY/LOCAL.RF.1',att,event);
tango_write_attribute2('BOO/SY/LOCAL.DG.3',att,event);
tango_write_attribute2('BOO/SY/LOCAL.Bext.1',att,event);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1',att,event);
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2',att,event);
tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1',att,event);
att ='spareEvent';
tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1',att,event);
tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1',att,event);
tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1',att,event);
tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1',att,event);
tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1',att,event);
tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1',att,event);


% --- Executes on button press in pushbutton_lt1_reset_lin1_reset.
function pushbutton_lin1_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_reset_lin1_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('LIN/SY/LOCAL.SPM.1','Reset')

% --- Executes on button press in pushbutton_lt1_reset_lin1_update.
function pushbutton_lin1_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_reset_lin1_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('LIN/SY/LOCAL.SPM.1','Update')

% --- Executes on button press in pushbutton_lt1_reset_lin1_atk.
function pushbutton_lin1_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_reset_lin1_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel LIN/SY/LOCAL.SPM.1 &')


% --- Executes on button press in pushbutton_lt1_reset.
function pushbutton_lt1_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('LT1/SY/LOCAL.DG.1', 'Reset')
%tango_command_inout2('LIN/SY/LOCAL.LPM.1','Reset')

% --- Executes on button press in pushbutton_lt1_update.
function pushbutton_lt1_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('LT1/SY/LOCAL.DG.1', 'Update')
tango_command_inout2('LIN/SY/LOCAL.LPM.1','Update')

% --- Executes on button press in pushbutton_lt1_atk.
function pushbutton_lt1_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_lt1_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel LIN/SY/LOCAL.LPM.1 &')
system('atkpanel LT1/SY/LOCAL.DG.1 &')


% --- Executes on button press in pushbutton_boo_binj_reset.
function pushbutton_boo_binj_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_binj_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Reset')
%tango_command_inout2('BOO/SY/LOCAL.DG.1', 'Reset')

% --- Executes on button press in pushbutton_boo_binj_update.
function pushbutton_boo_binj_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_binj_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Update')
tango_command_inout2('BOO/SY/LOCAL.DG.1', 'Update')

% --- Executes on button press in pushbutton_boo_binj_atk.
function pushbutton_boo_binj_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_binj_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel BOO/SY/LOCAL.DG.1 &')
system('atkpanel BOO/SY/LOCAL.Binj.1 &')

% --- Executes on button press in pushbutton_boo_alim_reset.
function pushbutton_boo_alim_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_alim_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.Alim.1',  'Reset')
%tango_command_inout2('BOO/SY/LOCAL.RF.1',  'Reset')

% --- Executes on button press in pushbutton_boo_alim_update.
function pushbutton_boo_alim_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_alim_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.Alim.1',  'Update')
tango_command_inout2('BOO/SY/LOCAL.RF.1',  'Update')

% --- Executes on button press in pushbutton_boo_alim_atk.
function pushbutton_boo_alim_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_alim_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel BOO/SY/LOCAL.Alim.1 &')
system('atkpanel BOO/SY/LOCAL.RF.1 &')


% --- Executes on button press in pushbutton_boo_dg3_reset.
function pushbutton_boo_dg3_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_dg3_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.DG.3', 'Reset')

% --- Executes on button press in pushbutton_boo_dg3_update.
function pushbutton_boo_dg3_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_dg3_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.DG.3', 'Update')

% --- Executes on button press in pushbutton_boo_dg3_atk.
function pushbutton_boo_dg3_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_dg3_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel BOO/SY/LOCAL.DG.3 &')

% --- Executes on button press in pushbutton_boo_bext_reset.
function pushbutton_boo_bext_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_bext_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Reset')

% --- Executes on button press in pushbutton_boo_bext_update.
function pushbutton_boo_bext_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_bext_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Update')
tango_command_inout2('BOO/SY/LOCAL.DG.2', 'Update')

% --- Executes on button press in pushbutton_boo_bext_atk.
function pushbutton_boo_bext_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_boo_bext_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel BOO/SY/LOCAL.Bext.1 &')
system('atkpanel BOO/SY/LOCAL.DG.2 &')

% --- Executes on button press in pushbutton_ans_ainj_reset.
function pushbutton_ans_ainj_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_ainj_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Reset')

% --- Executes on button press in pushbutton_ans_ainj_update.
function pushbutton_ans_ainj_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_ainj_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Update')
tango_command_inout2('ANS-C01/SY/LOCAL.DG.1',  'Update')

% --- Executes on button press in pushbutton_ans_ainj_atk.
function pushbutton_ans_ainj_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_ainj_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel ANS-C01/SY/LOCAL.Ainj.1 &')
system('atkpanel ANS-C01/SY/LOCAL.DG.1 &')

% --- Executes on button press in pushbutton_ans_ainj2_reset.
function pushbutton_ans_ainj2_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_ainj2_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2',  'Reset')


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2',  'Update')
tango_command_inout2('ANS-C01/SY/LOCAL.DG.2',  'Update')

% --- Executes on button press in pushbutton_ans_ainj2_atk.
function pushbutton_ans_ainj2_atk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_ainj2_atk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system('atkpanel ANS-C01/SY/LOCAL.Ainj.2 &')
system('atkpanel ANS-C01/SY/LOCAL.DG.2 &')

% --- Executes on button press in pushbutton_ans_ainj2_update.
function pushbutton_ans_ainj2_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ans_ainj2_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


