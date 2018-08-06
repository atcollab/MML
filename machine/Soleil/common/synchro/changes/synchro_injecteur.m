function varargout = synchro_injecteur(varargin)
% SYNCHRO_INJECTEUR M-file for synchro_injecteur.fig
%      SYNCHRO_INJECTEUR, by itself, creates a new SYNCHRO_INJECTEUR or raises the existing
%      singleton*.
%
%      H = SYNCHRO_INJECTEUR returns the handle to a new SYNCHRO_INJECTEUR or the handle to
%      the existing singleton*.
%
%      SYNCHRO_INJECTEUR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNCHRO_INJECTEUR.M with the given input arguments.
%
%      SYNCHRO_INJECTEUR('Property','Value',...) creates a new SYNCHRO_INJECTEUR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before synchro_injecteur_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to synchro_injecteur_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help synchro_injecteur

% Last Modified by GUIDE v2.5 20-Apr-2006 21:51:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @synchro_injecteur_OpeningFcn, ...
                   'gui_OutputFcn',  @synchro_injecteur_OutputFcn, ...
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


% --- Executes just before synchro_injecteur is made visible.
function synchro_injecteur_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to synchro_injecteur (see VARARGIN)

% Choose default command line output for synchro_injecteur
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes synchro_injecteur wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = synchro_injecteur_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dipole_Callback(hObject, eventdata, handles)
% hObject    handle to dipole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dipole as text
%        str2double(get(hObject,'String')) returns contents of dipole as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function dipole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dipole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function qf_Callback(hObject, eventdata, handles)
% hObject    handle to qf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qf as text
%        str2double(get(hObject,'String')) returns contents of qf as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function qf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qd_Callback(hObject, eventdata, handles)
% hObject    handle to qd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qd as text
%        str2double(get(hObject,'String')) returns contents of qd as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function qd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf_Callback(hObject, eventdata, handles)
% hObject    handle to sf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf as text
%        str2double(get(hObject,'String')) returns contents of sf as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function sf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd_Callback(hObject, eventdata, handles)
% hObject    handle to sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd as text
%        str2double(get(hObject,'String')) returns contents of sd as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function sd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rf_Callback(hObject, eventdata, handles)
% hObject    handle to rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rf as text
%        str2double(get(hObject,'String')) returns contents of rf as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('BOO/SY/LOCAL.RF.1', 'rfTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function rf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function canon_Callback(hObject, eventdata, handles)
% hObject    handle to canon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of canon as text
%        str2double(get(hObject,'String')) returns contents of canon as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function canon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to canon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function emittance_Callback(hObject, eventdata, handles)
% hObject    handle to emittance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emittance as text
%        str2double(get(hObject,'String')) returns contents of emittance as a double
delay=str2double(get(hObject,'String'));
tango_write_attribute('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function emittance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emittance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MC1_Callback(hObject, eventdata, handles)
% hObject    handle to MC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MC1 as text
%        str2double(get(hObject,'String')) returns contents of MC1 as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function MC1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MC2_Callback(hObject, eventdata, handles)
% hObject    handle to MC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MC2 as text
%        str2double(get(hObject,'String')) returns contents of MC2 as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function MC2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function osc_Callback(hObject, eventdata, handles)
% hObject    handle to osc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of osc as text
%        str2double(get(hObject,'String')) returns contents of osc as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function osc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sdc_Callback(hObject, eventdata, handles)
% hObject    handle to sdc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdc as text
%        str2double(get(hObject,'String')) returns contents of sdc as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function sdc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function septum_Callback(hObject, eventdata, handles)
% hObject    handle to septum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of septum as text
%        str2double(get(hObject,'String')) returns contents of septum as a double

%delay=str2double(get(hObject,'String'));
%tango_write_attribute('BOO/SY/LOCAL.Binj.1', 'sep-p.inj.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function septum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kicker_Callback(hObject, eventdata, handles)
% hObject    handle to kicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kicker as text
%        str2double(get(hObject,'String')) returns contents of kicker as a double

%delay=str2double(get(hObject,'String'));
%tango_write_attribute('BOO/SY/LOCAL.Binj.1', 'k.inj.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function kicker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bpm_Callback(hObject, eventdata, handles)
% hObject    handle to bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bpm as text
%        str2double(get(hObject,'String')) returns contents of bpm as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('LT1/SY/LOCAL.DG.1', 'bpm-booTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function bpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nod_Callback(hObject, eventdata, handles)
% hObject    handle to nod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nod as text
%        str2double(get(hObject,'String')) returns contents of nod as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('LT1/SY/LOCAL.DG.1', 'NODTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function nod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dcct_Callback(hObject, eventdata, handles)
% hObject    handle to dcct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dcct as text
%        str2double(get(hObject,'String')) returns contents of dcct as a double
delay=str2double(get(hObject,'String'));
tango_write_attribute('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',delay);
% --- Executes during object creation, after setting all properties.
function dcct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dcct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hall_Callback(hObject, eventdata, handles)
% hObject    handle to hall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hall as text
%        str2double(get(hObject,'String')) returns contents of hall as a double


% --- Executes during object creation, after setting all properties.
function hall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pc_address_Callback(hObject, eventdata, handles)
% hObject    handle to pc_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pc_address as text
%        str2double(get(hObject,'String')) returns contents of pc_address as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('ANS/SY/CENTRAL', 'TPcTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function pc_address_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pc_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inj_address_Callback(hObject, eventdata, handles)
% hObject    handle to inj_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inj_address as text
%        str2double(get(hObject,'String')) returns contents of inj_address as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('ANS/SY/CENTRAL', 'TInjTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function inj_address_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inj_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to pc_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pc_address as text
%        str2double(get(hObject,'String')) returns contents of pc_address as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pc_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function soft_address_Callback(hObject, eventdata, handles)
% hObject    handle to soft_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of soft_address as text
%        str2double(get(hObject,'String')) returns contents of soft_address as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute('ANS/SY/CENTRAL', 'TSoftTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function soft_address_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soft_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in acquisition1.
function acquisition1_Callback(hObject, eventdata, handles)
% hObject    handle to acquisition1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




n=2;

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');
set(handles.pc_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(n)));



temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay');
set(handles.sdc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay');
set(handles.canon,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'bpm-booTimeDelay');
set(handles.bpm,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay');
set(handles.emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay');
set(handles.MC1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay');
set(handles.MC2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay');
set(handles.osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay');
set(handles.dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'NODTimeDelay');
set(handles.nod,'String',num2str(temp.value(n)));

% temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.inj.trigTimeDelay');
% set(handles.septum,'String',num2str(temp.value(n)));

% temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.inj.trigTimeDelay');
% set(handles.kicker,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
set(handles.dipole,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
set(handles.qf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
set(handles.qd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay');
set(handles.sf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay');
set(handles.sd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay');
set(handles.rf,'String',num2str(temp.value(n)));


% --- Executes on button press in acquisition2.
function acquisition2_Callback(hObject, eventdata, handles)
% hObject    handle to acquisition2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n=1;

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');
set(handles.pc_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(n)));



temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay');
set(handles.sdc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay');
set(handles.canon,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'bpm-booTimeDelay');
set(handles.bpm,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay');
set(handles.emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay');
set(handles.MC1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay');
set(handles.MC2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay');
set(handles.osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay');
set(handles.dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'NODTimeDelay');
set(handles.nod,'String',num2str(temp.value(n)));

% temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.injread.trigTimeDelay');
% set(handles.septum,'String',num2str(temp.value(n)));

% temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.inj.trigTimeDelay');
% set(handles.kicker,'String',num2str(temp.value(n)));


temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
set(handles.dipole,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
set(handles.qf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
set(handles.qd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay');
set(handles.sf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay');
set(handles.sd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay');
set(handles.rf,'String',num2str(temp.value(n)));




% --- Executes on button press in soft_button.
function soft_button_Callback(hObject, eventdata, handles)
% hObject    handle to soft_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of soft_button

etat=get(hObject,'Value');
if (etat==0)
    event=int32(2) ;% adresse de l'injection
    tango_write_attribute('ANS/SY/LOCAL.SDC.1', 'oscEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'bpm-booEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'mc.1Event',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'mc.2Event',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'oscEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'NODEvent',event);
 %  temp=tango_write_attribute('BOO/SY/LOCAL.Binj.1', 'sep-p.inj.trigEvent',event);
%   temp=tango_write_attribute('BOO/SY/LOCAL.Binj.1', 'k.inj.trigEvent',event);   
elseif (etat==1)
    event=int32(5) ;% adresse de l'injection
    tango_write_attribute('ANS/SY/LOCAL.SDC.1', 'oscEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'bpm-booEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'mc.1Event',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'mc.2Event',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'oscEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',event);
    tango_write_attribute('LT1/SY/LOCAL.DG.1', 'NODEvent',event);
%   temp=tango_write_attribute('BOO/SY/LOCAL.Binj.1', 'sep-p.inj.trigEvent',event);
%   temp=tango_write_attribute('BOO/SY/LOCAL.Binj.1', 'k.inj.trigEvent',event);
end


% --- Executes on button press in push_soft.
function push_soft_Callback(hObject, eventdata, handles)
% hObject    handle to push_soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
