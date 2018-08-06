function varargout = synchro_injecteur5(varargin)
% SYNCHRO_INJECTEUR5 M-file for synchro_injecteur5.fig
%      SYNCHRO_INJECTEUR5, by itself, creates a new SYNCHRO_INJECTEUR5 or raises the existing
%      singleton*.
%
%      H = SYNCHRO_INJECTEUR5 returns the handle to a new SYNCHRO_INJECTEUR5 or the handle to
%      the existing singleton*.
%
%      SYNCHRO_INJECTEUR5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNCHRO_INJECTEUR5.M with the given input arguments.
%
%      SYNCHRO_INJECTEUR5('Property','Value',...) creates a new SYNCHRO_INJECTEUR5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before synchro_injecteur5_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to synchro_injecteur5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help synchro_injecteur5

% Last Modified by GUIDE v2.5 14-Oct-2006 21:06:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @synchro_injecteur5_OpeningFcn, ...
                   'gui_OutputFcn',  @synchro_injecteur5_OutputFcn, ...
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


% --- Executes just before synchro_injecteur5 is made visible.
function synchro_injecteur5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to synchro_injecteur5 (see VARARGIN)

% Choose default command line output for synchro_injecteur5
handles.output = hObject;
load('synchro_offset', 'inj_offset' , 'ext_offset');
set(handles.inj_offset,'String',num2str(inj_offset));
set(handles.ext_offset,'String',num2str(ext_offset));

% periode du trigger par defaut = 4/3
handles.periode = 10;
set(handles.periode_edit,'String',num2str(handles.periode));
set(handles.edit_Nshot_soft,'String',num2str(1));
set(handles.edit_laps,'String',1.0);

%Mode
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay');
clk1=temp.value(1);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');
clk2=temp.value(1);
jump=int32([0 39 26 13]);
handles.clk_pc  =jump +  int32(clk1);
handles.clk_soft=jump  + int32(clk2);
handles.quart=1;

handles.mode = 'Mode=???';
set(handles.edit_filling_relecture_tables,'Enable','off');
set(handles.edit_filling_relecture_bunch,'Enable','off');

set(handles.panel_bpm,'Visible','off');

% Creates timer Infinite loop
timer1=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',handles.periode,'TasksToExecute',Inf);
timer1.TimerFcn = {@fonction_alex, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer',timer1);

% button group sur on/off timer du trigger
h = uibuttongroup('visible','off','Position',[0.1485 0.29 0.10 0.12],...
    'Title','','TitlePosition','centertop',...
    'BackgroundColor',[1 0.3 0 ]);
u1 = uicontrol('Style','Radio','String','OFF','Tag','radiobutton1',...
    'pos',[45 20 40 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[1 0.3 0  ]);
u2 = uicontrol('Style','Radio','String','ON','Tag','radiobutton2',...
    'pos',[45 50 40 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[1 0.3 0 ]);
set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});

handles.off = u1;
handles.on = u2;

set(h,'SelectedObject',u1); 
set(h,'Visible','on');

%% Set closing gui function
set(handles.figure1,'CloseRequestFcn',{@Closinggui,timer1,handles.figure1});



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes synchro_injecteur5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = synchro_injecteur5_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function alim_dipole_Callback(hObject, eventdata, handles)
% hObject    handle to alim_dipole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alim_dipole as text
%        str2double(get(hObject,'String')) returns contents of alim_dipole as a double
h=gcf
delay=str2double(get(hObject,'String'));
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function alim_dipole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alim_dipole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function alim_qf_Callback(hObject, eventdata, handles)
% hObject    handle to alim_qf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alim_qf as text
%        str2double(get(hObject,'String')) returns contents of alim_qf as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function alim_qf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alim_qf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alim_qd_Callback(hObject, eventdata, handles)
% hObject    handle to alim_qd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alim_qd as text
%        str2double(get(hObject,'String')) returns contents of alim_qd as a double
get(hObject,'Tag')
delay=str2double(get(hObject,'String'));
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function alim_qd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alim_qd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alim_sf_Callback(hObject, eventdata, handles)
% hObject    handle to alim_sf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alim_sf as text
%        str2double(get(hObject,'String')) returns contents of alim_sf as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function alim_sf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alim_sf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alim_sd_Callback(hObject, eventdata, handles)
% hObject    handle to alim_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alim_sd as text
%        str2double(get(hObject,'String')) returns contents of alim_sd as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function alim_sd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alim_sd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_rf_Callback(hObject, eventdata, handles)
% hObject    handle to boo_rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_rf as text
%        str2double(get(hObject,'String')) returns contents of boo_rf as a double

delay=str2double(get(hObject,'String'));
tango_write_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_rf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lin_canon_Callback(hObject, eventdata, handles)
% hObject    handle to lin_canon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lin_canon as text
%        str2double(get(hObject,'String')) returns contents of lin_canon as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function lin_canon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lin_canon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lt1_emittance_Callback(hObject, eventdata, handles)
% hObject    handle to lt1_emittance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lt1_emittance as text
%        str2double(get(hObject,'String')) returns contents of lt1_emittance as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function lt1_emittance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lt1_emittance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lt1_MC1_Callback(hObject, eventdata, handles)
% hObject    handle to lt1_MC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lt1_MC1 as text
%        str2double(get(hObject,'String')) returns contents of lt1_MC1 as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function lt1_MC1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lt1_MC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lt1_MC2_Callback(hObject, eventdata, handles)
% hObject    handle to lt1_MC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lt1_MC2 as text
%        str2double(get(hObject,'String')) returns contents of lt1_MC2 as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function lt1_MC2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lt1_MC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lt1_osc_Callback(hObject, eventdata, handles)
% hObject    handle to lt1_osc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lt1_osc as text
%        str2double(get(hObject,'String')) returns contents of lt1_osc as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function lt1_osc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lt1_osc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sdc1_Callback(hObject, eventdata, handles)
% hObject    handle to sdc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdc1 as text
%        str2double(get(hObject,'String')) returns contents of sdc1 as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function sdc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_inj_septum_Callback(hObject, eventdata, handles)
% hObject    handle to boo_inj_septum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_inj_septum as text
%        str2double(get(hObject,'String')) returns contents of boo_inj_septum as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_inj_septum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_inj_septum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_inj_kicker_Callback(hObject, eventdata, handles)
% hObject    handle to boo_inj_kicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_inj_kicker as text
%        str2double(get(hObject,'String')) returns contents of boo_inj_kicker as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_inj_kicker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_inj_kicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_bpm_Callback(hObject, eventdata, handles)
% hObject    handle to boo_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_bpm as text
%        str2double(get(hObject,'String')) returns contents of boo_bpm as a double

inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay',delay);
tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigTimeDelay',delay);
tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigTimeDelay',delay);
tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function boo_bpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_nod_Callback(hObject, eventdata, handles)
% hObject    handle to boo_nod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_nod as text
%        str2double(get(hObject,'String')) returns contents of boo_nod as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_nod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_nod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_dcct_Callback(hObject, eventdata, handles)
% hObject    handle to boo_dcct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_dcct as text
%        str2double(get(hObject,'String')) returns contents of boo_dcct as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_dcct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_dcct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_hall_Callback(hObject, eventdata, handles)
% hObject    handle to boo_hall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_hall as text
%        str2double(get(hObject,'String')) returns contents of boo_hall as a double


% --- Executes during object creation, after setting all properties.
function boo_hall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_hall (see GCBO)
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
tango_write_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay',delay);

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
tango_write_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay',delay);

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
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay',delay);

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');
clkinj=int32(temp.value(1)+5*52);
clkext=int32(temp.value(1)/52+10);
tango_write_attribute2('ANS/SY/CENTRAL', 'TInjStepDelay',clkinj);
tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue',clkext);

%status soft checked on linac
temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent');
if (temp.value(1)==2)
   %
elseif (temp.value(1)==5)
    dt=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
    inj_offset=str2double(get(handles.inj_offset,'String'));
    delay=dt.value(1)+inj_offset;
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay',delay);
    temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay');
    set(handles.lin_modulateur,'String',num2str(temp.value(1)-inj_offset));
end

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

set(handles.inj_offset,'Enable','off');
set(handles.sdc1,'Enable','off');
set(handles.lin_canon,'Enable','off');
set(handles.boo_bpm,'Enable','off');
set(handles.lt1_emittance,'Enable','off');
set(handles.lt1_MC1,'Enable','off');
set(handles.lt1_MC2,'Enable','off');
set(handles.lt1_osc,'Enable','off');
set(handles.boo_dcct,'Enable','off');
set(handles.boo_nod,'Enable','off');
set(handles.boo_inj_septum,'Enable','off');
set(handles.boo_inj_kicker,'Enable','off');
set(handles.alim_dipole,'Enable','off');
set(handles.alim_qf,'Enable','off');
set(handles.alim_qd,'Enable','off');
set(handles.alim_sf,'Enable','off');
set(handles.alim_sd,'Enable','off');
set(handles.boo_rf,'Enable','off');
set(handles.lin_modulateur,'Enable','off');
set(handles.ext_offset,'Enable','off');
set(handles.boo_ext_dof,'Enable','off');
set(handles.boo_ext_sept_p,'Enable','off');
set(handles.boo_ext_sept_a,'Enable','off');
set(handles.boo_ext_kicker,'Enable','off');
set(handles.sdc2,'Enable','off');
set(handles.lt2_emittance,'Enable','off');
set(handles.lt2_osc,'Enable','off');
set(handles.lt2_bpm,'Enable','off');
set(handles.ans_inj_k1,'Enable','off');
set(handles.ans_inj_k2,'Enable','off');
set(handles.ans_inj_k3,'Enable','off');
set(handles.ans_inj_k4,'Enable','off');
set(handles.ans_inj_sept_p,'Enable','off');
set(handles.ans_inj_sept_a,'Enable','off');
set(handles.ans_bpm,'Enable','off');
set(handles.ans_dcct,'Enable','off');
set(handles.ans_bpm_c01,'Enable','off');
set(handles.ans_bpm_c02,'Enable','off');
set(handles.ans_bpm_c03,'Enable','off');
set(handles.ans_bpm_c04,'Enable','off');
set(handles.ans_bpm_c05,'Enable','off');
set(handles.ans_bpm_c06,'Enable','off');
set(handles.ans_bpm_c07,'Enable','off');
set(handles.ans_bpm_c08,'Enable','off');
set(handles.ans_bpm_c09,'Enable','off');
set(handles.ans_bpm_c10,'Enable','off');
set(handles.ans_bpm_c11,'Enable','off');
set(handles.ans_bpm_c12,'Enable','off');
set(handles.ans_bpm_c13,'Enable','off');
set(handles.ans_bpm_c14,'Enable','off');
set(handles.ans_bpm_c15,'Enable','off');
set(handles.ans_bpm_c16,'Enable','off');


n=1;

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');
set(handles.pc_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue');
set(handles.ext_address,'String',num2str(temp.value(n)));


temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay');
set(handles.sdc1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay');
set(handles.lin_canon,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay');
set(handles.boo_bpm,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay');
set(handles.lt1_emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay');
set(handles.lt1_MC1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay');
set(handles.lt1_MC2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay');
set(handles.lt1_osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay');
set(handles.boo_dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay');
set(handles.boo_nod,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay');
set(handles.boo_inj_septum,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay');
set(handles.boo_inj_kicker,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
set(handles.alim_dipole,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
set(handles.alim_qf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
set(handles.alim_qd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay');
set(handles.alim_sf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay');
set(handles.alim_sd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay');
set(handles.boo_rf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay');
set(handles.lin_modulateur,'String',num2str(temp.value(n)));





temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay');
set(handles.boo_ext_dof,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay');
set(handles.boo_ext_sept_p,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay');
set(handles.boo_ext_sept_a,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay');
set(handles.boo_ext_kicker,'String',num2str(temp.value(n)));


temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay');
set(handles.sdc2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay');
set(handles.lt2_emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay');
set(handles.lt2_osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay');
set(handles.lt2_bpm,'String',num2str(temp.value(n)));



temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay');
set(handles.ans_inj_k1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay');
set(handles.ans_inj_k2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay');
set(handles.ans_inj_k3,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay');
set(handles.ans_inj_k4,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay');
set(handles.ans_inj_sept_p,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay');
set(handles.ans_inj_sept_a,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay');
set(handles.ans_dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay');
set(handles.ans_bpm,'String',num2str(temp.value(n)));
set(handles.ans_bpm_c01,'String',num2str(temp.value(n)));


temp=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c02,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c03,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c04,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c05,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c06,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c07,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c08,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c09,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c10,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c11,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c12,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c13,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c14,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c15,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c16,'String',num2str(temp.value(n)));



%status soft checked on linac
temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent');
if (temp.value(n)==2)
    set(handles.soft_button,'Value',0);
elseif (temp.value(n)==5)
    set(handles.soft_button,'Value',1);
end

%status tables
temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue');
offset=temp.value(1)*52;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TablesCurrentDepth');
n=temp.value;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionDelayTable');
table=temp.value(1:n)-offset;
set(handles.edit_filling_relecture_tables,'String',['T=' , num2str(table)]);  



% --- Executes on button press in acquisition2.
function acquisition2_Callback(hObject, eventdata, handles)
% hObject    handle to acquisition2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.inj_offset,'Enable','on');
set(handles.sdc1,'Enable','on');
set(handles.lin_canon,'Enable','on');
set(handles.boo_bpm,'Enable','on');
set(handles.lt1_emittance,'Enable','on');
set(handles.lt1_MC1,'Enable','on');
set(handles.lt1_MC2,'Enable','on');
set(handles.lt1_osc,'Enable','on');
set(handles.boo_dcct,'Enable','on');
set(handles.boo_nod,'Enable','on');
set(handles.boo_inj_septum,'Enable','on');
set(handles.boo_inj_kicker,'Enable','on');
set(handles.alim_dipole,'Enable','on');
set(handles.alim_qf,'Enable','on');
set(handles.alim_qd,'Enable','on');
set(handles.alim_sf,'Enable','on');
set(handles.alim_sd,'Enable','on');
set(handles.boo_rf,'Enable','on');
set(handles.lin_modulateur,'Enable','on');
set(handles.ext_offset,'Enable','on');
set(handles.boo_ext_dof,'Enable','on');
set(handles.boo_ext_sept_p,'Enable','on');
set(handles.boo_ext_sept_a,'Enable','on');
set(handles.boo_ext_kicker,'Enable','on');
set(handles.sdc2,'Enable','on');
set(handles.lt2_emittance,'Enable','on');
set(handles.lt2_osc,'Enable','on');
set(handles.lt2_bpm,'Enable','on');
set(handles.ans_inj_k1,'Enable','on');
set(handles.ans_inj_k2,'Enable','on');
set(handles.ans_inj_k3,'Enable','on');
set(handles.ans_inj_k4,'Enable','on');
set(handles.ans_inj_sept_p,'Enable','on');
set(handles.ans_inj_sept_a,'Enable','on');
set(handles.ans_bpm,'Enable','on');
set(handles.ans_dcct,'Enable','on');
set(handles.ans_bpm_c01,'Enable','on');
set(handles.ans_bpm_c02,'Enable','on');
set(handles.ans_bpm_c03,'Enable','on');
set(handles.ans_bpm_c04,'Enable','on');
set(handles.ans_bpm_c05,'Enable','on');
set(handles.ans_bpm_c06,'Enable','on');
set(handles.ans_bpm_c07,'Enable','on');
set(handles.ans_bpm_c08,'Enable','on');
set(handles.ans_bpm_c09,'Enable','on');
set(handles.ans_bpm_c10,'Enable','on');
set(handles.ans_bpm_c11,'Enable','on');
set(handles.ans_bpm_c12,'Enable','on');
set(handles.ans_bpm_c13,'Enable','on');
set(handles.ans_bpm_c14,'Enable','on');
set(handles.ans_bpm_c15,'Enable','on');
set(handles.ans_bpm_c16,'Enable','on');


n=1;

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');
set(handles.pc_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(n)));
set(handles.soft_address1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue');
set(handles.ext_address,'String',num2str(temp.value(n)));



inj_offset=str2double(get(handles.inj_offset,'String'));

temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay');
set(handles.sdc1,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay');
set(handles.lin_canon,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay');
set(handles.boo_bpm,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay');
set(handles.lt1_emittance,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay');
set(handles.lt1_MC1,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay');
set(handles.lt1_MC2,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay');
set(handles.lt1_osc,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay');
set(handles.boo_dcct,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay');
set(handles.boo_nod,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay');
set(handles.boo_inj_septum,'String',num2str(temp.value(n)-inj_offset));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay');
set(handles.boo_inj_kicker,'String',num2str(temp.value(n)-inj_offset));




temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
set(handles.alim_dipole,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
set(handles.alim_qf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
set(handles.alim_qd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay');
set(handles.alim_sf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay');
set(handles.alim_sd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay');
set(handles.boo_rf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay');
set(handles.lin_modulateur,'String',num2str(temp.value(n)-inj_offset));



ext_offset=str2double(get(handles.ext_offset,'String'));


temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay');
set(handles.boo_ext_dof,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay');
set(handles.boo_ext_sept_p,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay');
set(handles.boo_ext_sept_a,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay');
set(handles.boo_ext_kicker,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay');
set(handles.sdc2,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay');
set(handles.lt2_emittance,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay');
set(handles.lt2_osc,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay');
set(handles.lt2_bpm,'String',num2str(temp.value(n)-ext_offset));


temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay');
set(handles.ans_inj_k1,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay');
set(handles.ans_inj_k2,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay');
set(handles.ans_inj_k3,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay');
set(handles.ans_inj_k4,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay');
set(handles.ans_inj_sept_p,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay');
set(handles.ans_inj_sept_a,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay');
set(handles.ans_dcct,'String',num2str(temp.value(n)-ext_offset));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay');
set(handles.ans_bpm,'String',num2str(temp.value(n)-ext_offset));
set(handles.ans_bpm_c01,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c02,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c03,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c04,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c05,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c06,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c07,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c08,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c09,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c10,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c11,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c12,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c13,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c14,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c15,'String',num2str(temp.value(n)-ext_offset));
temp=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay');
set(handles.ans_bpm_c16,'String',num2str(temp.value(n)-ext_offset));

%status soft checked on linac
temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent');
if (temp.value(n)==2)
    set(handles.soft_button,'Value',0);
elseif (temp.value(n)==5)
    set(handles.soft_button,'Value',1);
end

%status tables
temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue');
offset=temp.value(1)*52;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TablesCurrentDepth');
n=temp.value;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionDelayTable');
table=temp.value(1:n);
set(handles.edit_filling_relecture_tables,'String',[num2str(table)]);  

% --- Executes on button press in soft_button.
function soft_button_Callback(hObject, eventdata, handles)
% hObject    handle to soft_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of soft_button

etat=get(hObject,'Value');
tout=0.;
if (etat==0)
    event=int32(2) ;% adresse de l'injection
       

    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',int32(0)); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',event); pause(tout); 
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',event);
    tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Reset');  
    event=int32(3) ;% adresse de l'extraction
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',event);pause(tout);
    tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Reset');
    tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',event);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',event);pause(tout);
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Reset');
    
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigEvent',event);pause(tout);
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.1', 'Reset');
       
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigEvent',event);pause(tout);
    tango_command_inout2('ANS-C01/SY/LOCAL.Ainj.2',  'Reset');
    %tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    

    % special modulateur
    inj=str2double(get(handles.inj_address,'String'));
    soft=str2double(get(handles.soft_address,'String'));
    temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay');
    delay=temp.value(1)-(soft)+0.00568;
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay',delay);
    
    
elseif (etat==1)
    event=int32(5) ;% adresse de l'injection
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',event); pause(tout);     
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',event); pause(tout);
    tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent',event); pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',event);
    tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',event);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',event);pause(tout);
    tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',event);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigEvent',event);pause(tout);
    %tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent',event);pause(tout);
    tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);
    tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);  
    tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent',event);pause(tout);     
    
    % special modulateur
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareEvent',int32(1)); pause(tout);
    inj=str2double(get(handles.inj_address,'String'));
    soft=str2double(get(handles.soft_address,'String'));
    temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay');
    delay=temp.value(1)+(soft);
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay',delay);
    start_soft
end
display('ok change address')


% --- Executes on button press in push_soft.
function push_soft_Callback(hObject, eventdata, handles)
% hObject    handle to push_soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'Enable','Off')

bouton=get(handles.soft_button,'Value');
mode=get(handles.listbox_fillingmode,'Value');
[clk_pc,clk_soft]=fix_quart;
handles.clk_pc =clk_pc;
handles.clk_soft=clk_soft;

dt=1.5;
temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur0=temp.value;
q1=0;
q2=0;
n=0;

if (bouton==1)
    modeinj='Injection soft';
    fprintf('%s   %s  Remplissage = %d\n',datestr(clock),modeinj,mode);
    boucle=int16(str2double(get(handles.edit_Nshot_soft,'String')));
    if (mode<=4)
        for k=1:boucle
            i=int16(mode);
            clk1=handles.clk_pc(i);
            clk2=handles.clk_soft(i);
            tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk1);
            tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk2);
            tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
            pause(dt)
            [q1,q2,n]=getcharge(q1,q2,n);
        end
    elseif (mode>4)&&(mode<=7)
        for k=1:boucle
            for i=1:(mode-3)
                clk1=handles.clk_pc(i);
                clk2=handles.clk_soft(i);
                tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk1);
                tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk2);
                tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
                pause(dt)
                [q1,q2,n]=getcharge(q1,q2,n);
            end
        end    
    elseif (mode==8)   
        for k=1:boucle
            clk1=handles.clk_pc(1);
            clk2=handles.clk_soft(1);
            bunch=1 + (0:12)*32;
            [dtour,dpaquet]=bucketnumber(bunch);    
            clk_pc  =int32(dtour) +  int32(clk1);
            clk_soft=int32(dtour)  + int32(clk2);
            for i=1:13
                tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk_pc(i));
                tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk_soft(i));
                tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');
                pause(dt)
                [q1,q2,n]=getcharge(q1,q2,n);
            end
        end    
    end
    clk1=handles.clk_pc(1);
    clk2=handles.clk_soft(1);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay',clk1);
    tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay',clk2);
    
    pause(1);
    temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur=temp.value;
    dcur=anscur-anscur0;
    r1=0;
    if (q1~=0)
       r1=int16(q2/q1*100); 
    end
    r2=0;
    if (q2~=0)
       r2=int16(dcur/q2*0.524*416/184*100);
    end
    if     (r1<0)
        r1=0;
    elseif(r1>100)
        r1=100;
    end
    if    (r2<0)
        r2=0;
    elseif(r2>100)
        r2=100;
    end
    q1=q1/n;
    q2=q2/n;  

    set(handles.edit_qlt1,'String',num2str(q1,'%5.2f'));
    set(handles.edit_iboo,'String',num2str(q2/0.524,'%5.2f'));
    set(handles.edit_dians,'String',num2str(dcur/n,'%5.2f'));
    set(handles.edit_rboo,'String',num2str(r1));
    set(handles.edit_rans,'String',num2str(r2));
    set(handles.edit_cycle,'String',num2str(n,'%g'));
    set(handles.edit_dians1,'String',num2str(dcur,'%5.2f'));
    set(handles.edit_courant_total,'String', num2str(anscur,'%5.2f'));
    
    
elseif(bouton==0)
    modeinj='Injection 3 Hz';
    laps=str2double(get(handles.edit_laps,'String'));
    fprintf('%s   %s  Remplissage = %d\n',datestr(clock),modeinj,mode);
    start_3Hz
    pause(laps)
    stop_3Hz
    
    pause(1);
    temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur=temp.value;
    dcur=anscur-anscur0;
    n=int16(laps/0.340);
    
    set(handles.edit_qlt1,'String','--');
    set(handles.edit_iboo,'String','--');
    set(handles.edit_dians,'String','--');
    set(handles.edit_rboo,'String','--');
    set(handles.edit_rans,'String','--');
    set(handles.edit_cycle,'String',num2str(n,'%g'));
    set(handles.edit_dians1,'String',num2str(dcur,'%5.2f'));
    set(handles.edit_courant_total,'String', num2str(anscur,'%5.2f'));

end



set(hObject,'Enable','On');


function periode_edit_Callback(hObject, eventdata, handles)
% hObject    handle to periode_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of periode_edit as text
%        str2double(get(hObject,'String')) returns contents of periode_edit as a double

val_multishot = get(handles.on,'Value');

if val_multishot
    errordlg('positionner le trigger a OFF !','Attention');
    return
else
    handles.periode = str2double(get(hObject,'String'));

    % change timer Infinite loop
    timer1=timer('StartDelay',1,...
        'ExecutionMode','fixedRate','Period',handles.periode,'TasksToExecute',Inf);
    timer1.TimerFcn = {@fonction_alex, hObject,eventdata, handles};
    setappdata(handles.figure1,'Timer',timer1);

    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function periode_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to periode_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uibuttongroup_SelectionChangeFcn(hObject,eventdata,handles)

% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

timer1 = getappdata(handles.figure1,'Timer');
switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % démarrage du trigger
        stop(timer1);
       set(handles.push_soft,'Enable','On');
       
    case 'radiobutton2'
        % stop du trigger 
        set(handles.push_soft,'Enable','Off');
        start(timer1);
        
end

function fonction_alex(arg1,arg2,hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

push_soft_Callback(hObject,eventdata,handles)





%% What to do before closing the application
function Closinggui(obj, event, handles, figure1)

% Get default command line output from handles structure
answer = questdlg('Fermer softsynchro ?',...
    'Exit softsynchro',...
    'Yes','No','Yes');

switch answer
    case 'Yes'           
        delete(handles); %Delete Timer        
        delete(figure1); %Close gui
    otherwise
        disp('Closing aborted')
end



% --- Executes on button press in button_softmoins.
function button_softmoins_Callback(hObject, eventdata, handles)
% hObject    handle to button_softmoins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
step=temp.value(1)-51*0.52243;
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay',step);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(1)));

% decale adress inj et extract d'une super-periode
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');
clkinj=int32(temp.value(1)+5*52);
clkext=int32(temp.value(1)/52+10);
tango_write_attribute2('ANS/SY/CENTRAL', 'TInjStepDelay',clkinj);
tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue',clkext);

%status soft checked on linac
temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent');
if (temp.value(1)==2)
   %
elseif (temp.value(1)==5)
    dt=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
    inj_offset=str2double(get(handles.inj_offset,'String'));
    delay=dt.value(1)+inj_offset;
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay',delay);
    temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay');
    set(handles.lin_modulateur,'String',num2str(temp.value(1)-inj_offset));
end

% --- Executes on button press in button_softplus.
function button_softplus_Callback(hObject, eventdata, handles)
% hObject    handle to button_softplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
step=temp.value(1)+52*0.52243;
tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay',step);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(1)));

% dcale adress inj et extract d'une super-periode
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');
clkinj=int32(temp.value(1)+5*52);
clkext=int32(temp.value(1)/52+10);
tango_write_attribute2('ANS/SY/CENTRAL', 'TInjStepDelay',clkinj);
tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue',clkext);

%status soft checked on linac
temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent');
if (temp.value(1)==2)
   %
elseif (temp.value(1)==5)
    dt=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
    inj_offset=str2double(get(handles.inj_offset,'String'));
    delay=dt.value(1)+inj_offset;
    tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay',delay);
    temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay');
    set(handles.lin_modulateur,'String',num2str(temp.value(1)-inj_offset));
end

% --- Executes on button press in button_injmoins.
function button_injmoins_Callback(hObject, eventdata, handles)
% hObject    handle to button_injmoins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
step=temp.value(1)-51*0.52243;
tango_write_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay',step);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(1)));



% --- Executes on button press in button_injplus.
function button_injplus_Callback(hObject, eventdata, handles)
% hObject    handle to button_injplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
step=temp.value(1)+52*0.52243;
tango_write_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay',step);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(1)));



function boo_ext_dof_Callback(hObject, eventdata, handles)
% hObject    handle to boo_ext_dof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_ext_dof as text
%        str2double(get(hObject,'String')) returns contents of boo_ext_dof as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_ext_dof_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_ext_dof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_ext_sept_p_Callback(hObject, eventdata, handles)
% hObject    handle to boo_ext_sept_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_ext_sept_p as text
%        str2double(get(hObject,'String')) returns contents of boo_ext_sept_p as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_ext_sept_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_ext_sept_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_ext_sept_a_Callback(hObject, eventdata, handles)
% hObject    handle to boo_ext_sept_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_ext_sept_a as text
%        str2double(get(hObject,'String')) returns contents of boo_ext_sept_a as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function boo_ext_sept_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_ext_sept_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boo_ext_kicker_Callback(hObject, eventdata, handles)
% hObject    handle to boo_ext_kicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boo_ext_kicker as text
%        str2double(get(hObject,'String')) returns contents of boo_ext_kicker as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function boo_ext_kicker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boo_ext_kicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_inj_sept_p_Callback(hObject, eventdata, handles)
% hObject    handle to ans_inj_sept_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_inj_sept_p as text
%        str2double(get(hObject,'String')) returns contents of ans_inj_sept_p as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function ans_inj_sept_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_inj_sept_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_inj_sept_a_Callback(hObject, eventdata, handles)
% hObject    handle to ans_inj_sept_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_inj_sept_a as text
%        str2double(get(hObject,'String')) returns contents of ans_inj_sept_a as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function ans_inj_sept_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_inj_sept_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_inj_k1_Callback(hObject, eventdata, handles)
% hObject    handle to ans_inj_k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_inj_k1 as text
%        str2double(get(hObject,'String')) returns contents of ans_inj_k1 as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay',delay);



% --- Executes during object creation, after setting all properties.
function ans_inj_k1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_inj_k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_inj_k2_Callback(hObject, eventdata, handles)
% hObject    handle to ans_inj_k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_inj_k2 as text
%        str2double(get(hObject,'String')) returns contents of ans_inj_k2 as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function ans_inj_k2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_inj_k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_inj_k3_Callback(hObject, eventdata, handles)
% hObject    handle to ans_inj_k3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_inj_k3 as text
%        str2double(get(hObject,'String')) returns contents of ans_inj_k3 as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function ans_inj_k3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_inj_k3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_inj_k4_Callback(hObject, eventdata, handles)
% hObject    handle to ans_inj_k4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_inj_k4 as text
%        str2double(get(hObject,'String')) returns contents of ans_inj_k4 as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function ans_inj_k4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_inj_k4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_dcct_Callback(hObject, eventdata, handles)
% hObject    handle to ans_dcct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_dcct as text
%        str2double(get(hObject,'String')) returns contents of ans_dcct as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_dcct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_dcct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);
tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);



% --- Executes during object creation, after setting all properties.
function ans_bpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ext_address_Callback(hObject, eventdata, handles)
% hObject    handle to ext_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ext_address as text
%        str2double(get(hObject,'String')) returns contents of ext_address as a double
%'ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue'

delay=str2double(get(hObject,'String'));
tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue',delay);

% --- Executes during object creation, after setting all properties.
function ext_address_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ext_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function soft_address1_Callback(hObject, eventdata, handles)
% hObject    handle to soft_address1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of soft_address1 as text
%        str2double(get(hObject,'String')) returns contents of soft_address1 as a double



% --- Executes during object creation, after setting all properties.
function soft_address1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to soft_address1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_extmoins.
function button_extmoins_Callback(hObject, eventdata, handles)
% hObject    handle to button_extmoins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue');
step=temp.value(1)-52*0.52243;
tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue',step);
temp=tango_read_attribute2('ANS/SY/CENTRAL','ExtractionOffsetTimeValue');
set(handles.ext_address,'String',num2str(temp.value(1)));

% --- Executes on button press in button_extplus.
function button_extplus_Callback(hObject, eventdata, handles)
% hObject    handle to button_extplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue');
step=temp.value(1)+52*0.52243;
tango_write_attribute2('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue',step);
temp=tango_read_attribute2('ANS/SY/CENTRAL','ExtractionOffsetTimeValue');
set(handles.ext_address,'String',num2str(temp.value(1)));

function sdc2_Callback(hObject, eventdata, handles)
% hObject    handle to sdc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdc2 as text
%        str2double(get(hObject,'String')) returns contents of sdc2 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function sdc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lt2_emittance_Callback(hObject, eventdata, handles)
% hObject    handle to lt2_emittance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lt2_emittance as text
%        str2double(get(hObject,'String')) returns contents of lt2_emittance as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay',delay);
tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function lt2_emittance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lt2_emittance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lt2_bpm_Callback(hObject, eventdata, handles)
% hObject    handle to lt2_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lt2_bpm as text
%        str2double(get(hObject,'String')) returns contents of lt2_bpm as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function lt2_bpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lt2_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lt2_osc_Callback(hObject, eventdata, handles)
% hObject    handle to lt2_osc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lt2_osc as text
%        str2double(get(hObject,'String')) returns contents of lt2_osc as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function lt2_osc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lt2_osc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lin_modulateur_Callback(hObject, eventdata, handles)
% hObject    handle to lin_modulateur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lin_modulateur as text
%        str2double(get(hObject,'String')) returns contents of lin_modulateur as a double
inj_offset=str2double(get(handles.inj_offset,'String'));
delay=str2double(get(hObject,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function lin_modulateur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lin_modulateur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inj_offset_Callback(hObject, eventdata, handles)
% hObject    handle to inj_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inj_offset as text
%        str2double(get(hObject,'String')) returns contents of inj_offset as a double

inj_offset=str2double(get(hObject,'String'));
ext_offset=str2double(get(handles.ext_offset,'String'));
save('synchro_offset', 'inj_offset' , 'ext_offset')

%LIN
delay=str2double(get(handles.lin_canon,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTimeDelay',delay);

delay=str2double(get(handles.lin_modulateur,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTimeDelay',delay);

delay=str2double(get(handles.sdc1,'String'))+inj_offset;
tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',delay);


% LT1
delay=str2double(get(handles.lt1_MC2,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',delay);

delay=str2double(get(handles.lt1_MC1,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',delay);

delay=str2double(get(handles.lt1_emittance,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',delay);

delay=str2double(get(handles.lt1_osc,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',delay);


% BOO
delay=str2double(get(handles.boo_inj_septum,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay',delay);

delay=str2double(get(handles.boo_inj_kicker,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay',delay);

delay=str2double(get(handles.boo_bpm,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay',delay);
tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigTimeDelay',delay);
tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigTimeDelay',delay);
tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigTimeDelay',delay);


delay=str2double(get(handles.boo_nod,'String'))+inj_offset;
tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay',delay);

delay=str2double(get(handles.boo_dcct,'String'))+inj_offset;
tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',delay);



% --- Executes during object creation, after setting all properties.
function inj_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inj_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ext_offset_Callback(hObject, eventdata, handles)
% hObject    handle to ext_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ext_offset as text
%        str2double(get(hObject,'String')) returns contents of ext_offset as a double

ext_offset=str2double(get(hObject,'String'));
inj_offset=str2double(get(handles.inj_offset,'String'));
save('synchro_offset', 'inj_offset' , 'ext_offset')

%BOO
delay=str2double(get(handles.boo_ext_dof,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay',delay);

delay=str2double(get(handles.boo_ext_sept_p,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay',delay);

delay=str2double(get(handles.boo_ext_sept_a,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay',delay);

delay=str2double(get(handles.boo_ext_kicker,'String'))+ext_offset;
tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay',delay);

delay=str2double(get(handles.sdc2,'String'))+ext_offset;
tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay',delay);

%LT2
delay=str2double(get(handles.lt2_bpm,'String'))+ext_offset;
tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',delay);

delay=str2double(get(handles.lt2_osc,'String'))+ext_offset;
tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay',delay);

delay=str2double(get(handles.lt2_emittance,'String'))+ext_offset;
tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay',delay);

%ANS

delay=str2double(get(handles.ans_inj_sept_a,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay',delay);

delay=str2double(get(handles.ans_inj_sept_p,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay',delay);

delay=str2double(get(handles.ans_inj_k1,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay',delay);

delay=str2double(get(handles.ans_inj_k2,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay',delay);

delay=str2double(get(handles.ans_inj_k3,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay',delay);

delay=str2double(get(handles.ans_inj_k4,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay',delay);



% --- Executes during object creation, after setting all properties.
function ext_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ext_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Acquisition_address.
function Acquisition_address_Callback(hObject, eventdata, handles)
% hObject    handle to Acquisition_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.inj_offset,'Enable','off');
set(handles.sdc1,'Enable','off');
set(handles.lin_canon,'Enable','off');
set(handles.boo_bpm,'Enable','off');
set(handles.lt1_emittance,'Enable','off');
set(handles.lt1_MC1,'Enable','off');
set(handles.lt1_MC2,'Enable','off');
set(handles.lt1_osc,'Enable','off');
set(handles.boo_dcct,'Enable','off');
set(handles.boo_nod,'Enable','off');
set(handles.boo_inj_septum,'Enable','off');
set(handles.boo_inj_kicker,'Enable','off');
set(handles.alim_dipole,'Enable','off');
set(handles.alim_qf,'Enable','off');
set(handles.alim_qd,'Enable','off');
set(handles.alim_sf,'Enable','off');
set(handles.alim_sd,'Enable','off');
set(handles.boo_rf,'Enable','off');
set(handles.lin_modulateur,'Enable','off');
set(handles.ext_offset,'Enable','off');
set(handles.boo_ext_dof,'Enable','off');
set(handles.boo_ext_sept_p,'Enable','off');
set(handles.boo_ext_sept_a,'Enable','off');
set(handles.boo_ext_kicker,'Enable','off');
set(handles.sdc2,'Enable','off');
set(handles.lt2_emittance,'Enable','off');
set(handles.lt2_osc,'Enable','off');
set(handles.lt2_bpm,'Enable','off');
set(handles.ans_inj_k1,'Enable','off');
set(handles.ans_inj_k2,'Enable','off');
set(handles.ans_inj_k3,'Enable','off');
set(handles.ans_inj_k4,'Enable','off');
set(handles.ans_inj_sept_p,'Enable','off');
set(handles.ans_inj_sept_a,'Enable','off');
set(handles.ans_bpm,'Enable','off');
set(handles.ans_dcct,'Enable','off');
set(handles.ans_bpm_c01,'Enable','off');
set(handles.ans_bpm_c02,'Enable','off');
set(handles.ans_bpm_c03,'Enable','off');
set(handles.ans_bpm_c04,'Enable','off');
set(handles.ans_bpm_c05,'Enable','off');
set(handles.ans_bpm_c06,'Enable','off');
set(handles.ans_bpm_c07,'Enable','off');
set(handles.ans_bpm_c08,'Enable','off');
set(handles.ans_bpm_c09,'Enable','off');
set(handles.ans_bpm_c10,'Enable','off');
set(handles.ans_bpm_c11,'Enable','off');
set(handles.ans_bpm_c12,'Enable','off');
set(handles.ans_bpm_c13,'Enable','off');
set(handles.ans_bpm_c14,'Enable','off');
set(handles.ans_bpm_c15,'Enable','off');
set(handles.ans_bpm_c16,'Enable','off');

n=1;

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');
set(handles.pc_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue');
set(handles.ext_address,'String',num2str(temp.value(n)));


temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent');
set(handles.sdc1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmEvent');
set(handles.lin_canon,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent');
set(handles.boo_bpm,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent');
set(handles.lt1_emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event');
set(handles.lt1_MC1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event');
set(handles.lt1_MC2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent');
set(handles.lt1_osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent');
set(handles.boo_dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent');
set(handles.boo_nod,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent');
set(handles.boo_inj_septum,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent');
set(handles.boo_inj_kicker,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpEvent');
set(handles.alim_dipole,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfEvent');
set(handles.alim_qf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdEvent');
set(handles.alim_qd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfEvent');
set(handles.alim_sf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdEvent');
set(handles.alim_sd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfEvent');
set(handles.boo_rf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareEvent');
set(handles.lin_modulateur,'String',num2str(temp.value(n)));





temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent');
set(handles.boo_ext_dof,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent');
set(handles.boo_ext_sept_p,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent');
set(handles.boo_ext_sept_a,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent');
set(handles.boo_ext_kicker,'String',num2str(temp.value(n)));



temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent');
set(handles.sdc2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent');
set(handles.lt2_emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent');
set(handles.lt2_osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent');
set(handles.lt2_bpm,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent');
set(handles.ans_inj_k1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigEvent');
set(handles.ans_inj_k2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigEvent');
set(handles.ans_inj_k3,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigEvent');
set(handles.ans_inj_k4,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigEvent');
set(handles.ans_inj_sept_p,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigEvent');
set(handles.ans_inj_sept_a,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent');
set(handles.ans_dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent');
set(handles.ans_bpm,'String',num2str(temp.value(n)));
set(handles.ans_bpm_c01,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c02,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c03,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c04,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c05,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c06,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c07,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c08,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c09,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c10,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c11,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c12,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c13,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c14,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c15,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent');
set(handles.ans_bpm_c16,'String',num2str(temp.value(n)));



% --- Executes on button press in button_offinj_moins.
function button_offinj_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_offinj_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=str2double(get(handles.inj_offset,'String'));
step=temp-52*0.52243;
set(handles.inj_offset,'String',step);
inj_offset_Callback(handles.inj_offset, eventdata, handles);

% --- Executes on button press in button_offinj_plus.
function button_offinj_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_offinj_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=str2double(get(handles.inj_offset,'String'));
step=temp+52*0.52243;
set(handles.inj_offset,'String',step);
inj_offset_Callback(handles.inj_offset, eventdata, handles);

% --- Executes on button press in button_offext_moins.
function button_offext_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_offext_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=str2double(get(handles.ext_offset,'String'));
step=temp-52*0.52243;
set(handles.ext_offset,'String',step);
ext_offset_Callback(handles.ext_offset, eventdata, handles);

% --- Executes on button press in button_offext_plus.
function button_offext_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_offext_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=str2double(get(handles.ext_offset,'String'));
step=temp+52*0.52243;
set(handles.ext_offset,'String',step);
ext_offset_Callback(handles.ext_offset, eventdata, handles);


% --- Executes on button press in button_bpm.
function button_bpm_Callback(hObject, eventdata, handles)
% hObject    handle to button_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_bpm

bpm=get(hObject,'Value');

if (bpm==0)
   set(handles.panel_bpm,'Visible','off');
elseif (bpm==1)
    set(handles.panel_bpm,'Visible','on');
end



function ans_bpm_c01_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c01 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c01 as a double

ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',delay);

% --- Executes during object creation, after setting all properties.
function ans_bpm_c01_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ans_bpm_c02_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c02 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c02 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c02_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c03_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c03 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c03 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c03_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c03 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c04_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c04 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c04 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c04_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c05_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c05 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c05 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c05_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c05 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c06_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c06 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c06 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c06_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c07_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c07 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c07 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c07_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c07 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c08_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c08 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c08 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c08_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c09_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c09 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c09 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c09_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c09 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c10_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c10 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c10 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c11_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c11 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c11 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c12_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c12 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c12 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c13_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c13 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c13 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c14_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c14 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c14 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c15_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c15 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c15 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ans_bpm_c16_Callback(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ans_bpm_c16 as text
%        str2double(get(hObject,'String')) returns contents of ans_bpm_c16 as a double
ext_offset=str2double(get(handles.ext_offset,'String'));
delay=str2double(get(hObject,'String'))+ext_offset;
tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',delay);


% --- Executes during object creation, after setting all properties.
function ans_bpm_c16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ans_bpm_c16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filling_relecture_tables_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filling_relecture_tables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filling_relecture_tables as text
%        str2double(get(hObject,'String')) returns contents of edit_filling_relecture_tables as a double


% --- Executes during object creation, after setting all properties.
function edit_filling_relecture_tables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filling_relecture_tables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit72_Callback(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit72 as text
%        str2double(get(hObject,'String')) returns contents of edit72 as a double


% --- Executes during object creation, after setting all properties.
function edit72_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit72 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filling_relecture_bunch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filling_relecture_bunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filling_relecture_bunch as text
%        str2double(get(hObject,'String')) returns contents of edit_filling_relecture_bunch as a double


% --- Executes during object creation, after setting all properties.
function edit_filling_relecture_bunch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filling_relecture_bunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_filling_entrer_bunch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filling_entrer_bunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filling_entrer_bunch as text
%        str2double(get(hObject,'String')) returns contents of edit_filling_entrer_bunch as a double


% --- Executes during object creation, after setting all properties.
function edit_filling_entrer_bunch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filling_entrer_bunch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_update.
function button_update_Callback(hObject, eventdata, handles)
% hObject    handle to button_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('*****Update des 16 cartes locales******\n')
r=tango_command_inout2('ANS/SY/LOCAL.SDC.1',  'Update');retour_update('ANS/SY/LOCAL.SDC.1',r);
r=tango_command_inout2('LT1/SY/LOCAL.LINAC.1','Update');retour_update('LT1/SY/LOCAL.LINAC.1',r);

r=tango_command_inout2('BOO/SY/LOCAL.Binj.1',  'Update');    retour_update('BOO/SY/LOCAL.Binj.1',r);
r=tango_command_inout2('BOO/SY/LOCAL.Alim.1',  'Update'); retour_update('BOO/SY/LOCAL.Alim.1',r);
r=tango_command_inout2('BOO/SY/LOCAL.DG.3', 'Update');retour_update('BOO/SY/LOCAL.DG.3',r);
r=tango_command_inout2('BOO/SY/LOCAL.Bext.1',  'Update');retour_update('BOO/SY/LOCAL.Bext.1',r);

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
fprintf('**************************************\n')
%retour_command=vect
%fprintf('16 zéro = OK : %d\n',vect)

% --- Executes on button press in button_trigstatus.
function button_trigstatus_Callback(hObject, eventdata, handles)
% hObject    handle to button_trigstatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.inj_offset,'Enable','off');
set(handles.sdc1,'Enable','off');
set(handles.lin_canon,'Enable','off');
set(handles.boo_bpm,'Enable','off');
set(handles.lt1_emittance,'Enable','off');
set(handles.lt1_MC1,'Enable','off');
set(handles.lt1_MC2,'Enable','off');
set(handles.lt1_osc,'Enable','off');
set(handles.boo_dcct,'Enable','off');
set(handles.boo_nod,'Enable','off');
set(handles.boo_inj_septum,'Enable','off');
set(handles.boo_inj_kicker,'Enable','off');
set(handles.alim_dipole,'Enable','off');
set(handles.alim_qf,'Enable','off');
set(handles.alim_qd,'Enable','off');
set(handles.alim_sf,'Enable','off');
set(handles.alim_sd,'Enable','off');
set(handles.boo_rf,'Enable','off');
set(handles.lin_modulateur,'Enable','off');
set(handles.ext_offset,'Enable','off');
set(handles.boo_ext_dof,'Enable','off');
set(handles.boo_ext_sept_p,'Enable','off');
set(handles.boo_ext_sept_a,'Enable','off');
set(handles.boo_ext_kicker,'Enable','off');
set(handles.sdc2,'Enable','off');
set(handles.lt2_emittance,'Enable','off');
set(handles.lt2_osc,'Enable','off');
set(handles.lt2_bpm,'Enable','off');
set(handles.ans_inj_k1,'Enable','off');
set(handles.ans_inj_k2,'Enable','off');
set(handles.ans_inj_k3,'Enable','off');
set(handles.ans_inj_k4,'Enable','off');
set(handles.ans_inj_sept_p,'Enable','off');
set(handles.ans_inj_sept_a,'Enable','off');
set(handles.ans_bpm,'Enable','off');
set(handles.ans_dcct,'Enable','off');
set(handles.ans_bpm_c01,'Enable','off');
set(handles.ans_bpm_c02,'Enable','off');
set(handles.ans_bpm_c03,'Enable','off');
set(handles.ans_bpm_c04,'Enable','off');
set(handles.ans_bpm_c05,'Enable','off');
set(handles.ans_bpm_c06,'Enable','off');
set(handles.ans_bpm_c07,'Enable','off');
set(handles.ans_bpm_c08,'Enable','off');
set(handles.ans_bpm_c09,'Enable','off');
set(handles.ans_bpm_c10,'Enable','off');
set(handles.ans_bpm_c11,'Enable','off');
set(handles.ans_bpm_c12,'Enable','off');
set(handles.ans_bpm_c13,'Enable','off');
set(handles.ans_bpm_c14,'Enable','off');
set(handles.ans_bpm_c15,'Enable','off');
set(handles.ans_bpm_c16,'Enable','off');


n=1;

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcTimeDelay');
set(handles.pc_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
set(handles.inj_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
set(handles.soft_address,'String',num2str(temp.value(n)));

temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetTimeValue');
set(handles.ext_address,'String',num2str(temp.value(n)));



temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTrigStatus');
set(handles.sdc1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'lpmTrigStatus');
set(handles.lin_canon,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTrigStatus');
set(handles.boo_bpm,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTrigStatus');
set(handles.lt1_emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TrigStatus');
set(handles.lt1_MC1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TrigStatus');
set(handles.lt1_MC2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'oscTrigStatus');
set(handles.lt1_osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTrigStatus');
set(handles.boo_dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTrigStatus');
set(handles.boo_nod,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTrigStatus');
set(handles.boo_inj_septum,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTrigStatus');
set(handles.boo_inj_kicker,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTrigStatus');
set(handles.alim_dipole,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTrigStatus');
set(handles.alim_qf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTrigStatus');
set(handles.alim_qd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTrigStatus');
set(handles.alim_sf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTrigStatus');
set(handles.alim_sd,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.RF.1', 'rfTrigStatus');
set(handles.boo_rf,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT1/SY/LOCAL.LINAC.1', 'spareTrigStatus');
set(handles.lin_modulateur,'String',num2str(temp.value(n)));





temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTrigStatus');
set(handles.boo_ext_dof,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTrigStatus');
set(handles.boo_ext_sept_p,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTrigStatus');
set(handles.boo_ext_sept_a,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTrigStatus');
set(handles.boo_ext_kicker,'String',num2str(temp.value(n)));



temp=tango_read_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTrigStatus');
set(handles.sdc2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTrigStatus');
set(handles.lt2_emittance,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTrigStatus');
set(handles.lt2_osc,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTrigStatus');
set(handles.lt2_bpm,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTrigStatus');
set(handles.ans_inj_k1,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTrigStatus');
set(handles.ans_inj_k2,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTrigStatus');
set(handles.ans_inj_k3,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTrigStatus');
set(handles.ans_inj_k4,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTrigStatus');
set(handles.ans_inj_sept_p,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTrigStatus');
set(handles.ans_inj_sept_a,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTrigStatus');
set(handles.ans_dcct,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTrigStatus');
set(handles.ans_bpm,'String',num2str(temp.value(n)));
set(handles.ans_bpm_c01,'String',num2str(temp.value(n)));

temp=tango_read_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c02,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c03,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c04,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c05,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c06,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c07,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c08,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c09,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c10,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c11,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c12,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c13,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c14,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c15,'String',num2str(temp.value(n)));
temp=tango_read_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTrigStatus');
set(handles.ans_bpm_c16,'String',num2str(temp.value(n)));



% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on selection change in listbox_fillingmode.
function listbox_fillingmode_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_fillingmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_fillingmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_fillingmode
pattern=get(hObject,'String');
mode=get(hObject,'Value');
fprintf('***************************************************\n')
fprintf('Mode de remplissage sélectionné : %s\n',pattern{mode})
fprintf('***************************************************\n')

% Prépare les tables pour le 3 Hz

quart=[1 105 209 313];
temp=tango_read_attribute('ANS/SY/CENTRAL', 'ExtractionOffsetClkStepValue');
offset=temp.value(1)*52;

if (mode<=4)
    bunch=quart(mode);
elseif (mode>4)&&(mode<=7)
    bunch=quart(1:(mode-3));
elseif (mode==8)   
    dbunch=4*8;
    bunch=(0:12)*dbunch;
end

[dtour,dpaquet]=bucketnumber(bunch);
table=int32([length(bunch) dtour dpaquet]);
tango_command_inout('ANS/SY/CENTRAL','SetTables',table);
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TablesCurrentDepth');
n=temp.value;
temp=tango_read_attribute2('ANS/SY/CENTRAL', 'ExtractionDelayTable');
table=temp.value(1:n);
set(handles.edit_filling_relecture_tables,'String',[num2str(table)]);
set(handles.edit_filling_relecture_bunch, 'String',[num2str(bunch)]);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox_fillingmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_fillingmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_fix.
function button_fix_Callback(hObject, eventdata, handles)
% hObject    handle to button_fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[clk_pc,clk_soft]=fix_quart;
handles.clk_pc  =clk_pc;
handles.clk_soft=clk_soft;

% n=1;
% temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TPcStepDelay');
% clk1=temp.value(n);
% temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftStepDelay');
% clk2=temp.value(n);
% 
% jump=int32([0 39 26 13]);
% handles.clk_pc  =jump +  int32(clk1);
% handles.clk_soft=jump  + int32(clk2);

guidata(hObject, handles);



function edit_Nshot_soft_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nshot_soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nshot_soft as text
%        str2double(get(hObject,'String')) returns contents of edit_Nshot_soft as a double


% --- Executes during object creation, after setting all properties.
function edit_Nshot_soft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nshot_soft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_laps_Callback(hObject, eventdata, handles)
% hObject    handle to edit_laps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_laps as text
%        str2double(get(hObject,'String')) returns contents of edit_laps as a double


% --- Executes during object creation, after setting all properties.
function edit_laps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_laps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_qlt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qlt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qlt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_qlt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_qlt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qlt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_iboo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_iboo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_iboo as text
%        str2double(get(hObject,'String')) returns contents of edit_iboo as a double


% --- Executes during object creation, after setting all properties.
function edit_iboo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_iboo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dians_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dians (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dians as text
%        str2double(get(hObject,'String')) returns contents of edit_dians as a double


% --- Executes during object creation, after setting all properties.
function edit_dians_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dians (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rlt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rlt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rlt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_rlt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_rlt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rlt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rboo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rboo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rboo as text
%        str2double(get(hObject,'String')) returns contents of edit_rboo as a double


% --- Executes during object creation, after setting all properties.
function edit_rboo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rboo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rans_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rans as text
%        str2double(get(hObject,'String')) returns contents of edit_rans as a double


% --- Executes during object creation, after setting all properties.
function edit_rans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dians1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dians1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dians1 as text
%        str2double(get(hObject,'String')) returns contents of edit_dians1 as a double


% --- Executes during object creation, after setting all properties.
function edit_dians1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dians1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cycle as text
%        str2double(get(hObject,'String')) returns contents of edit_cycle as a double


% --- Executes during object creation, after setting all properties.
function edit_cycle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_courant_total_Callback(hObject, eventdata, handles)
% hObject    handle to edit_courant_total (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_courant_total as text
%        str2double(get(hObject,'String')) returns contents of edit_courant_total as a double


% --- Executes during object creation, after setting all properties.
function edit_courant_total_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_courant_total (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


