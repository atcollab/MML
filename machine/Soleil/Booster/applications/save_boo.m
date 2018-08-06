function varargout = save_boo(varargin)
% SAVE_BOO M-file for save_boo.fig
%      SAVE_BOO, by itself, creates a new SAVE_BOO or raises the existing
%      singleton*.
% 
%
%      SAVE_BOO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVE_BOO.M with the given input arguments.
%
%      SAVE_BOO('Property','Value',...) creates a new SAVE_BOO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before save_boo_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to save_boo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help save_boo

% Last Modified by GUIDE v2.5 30-May-2006 09:30:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @save_boo_OpeningFcn, ...
                   'gui_OutputFcn',  @save_boo_OutputFcn, ...
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


% --- Executes just before save_boo is made visible.
function save_boo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to save_boo (see VARARGIN)

% Choose default command line output for save_boo
handles.output = hObject;
button_update_boo_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes save_b
% Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
% pwdold = pwd;
% cd(Directory);
% 
% cd(pwdold);oo wait for user response (see UIRESUME)
% % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = save_boo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_save_all.
function button_save_all_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file=appendtimestamp('boo_all');
set(handles.edit_file,'String',file);

% commentaire
    boo=load_param;
    boo.date   =datestr(clock);
    boo.comment=get(handles.edit_legend,'String');
    % commentaire
    orbit=load_orbit_corr;
    orbit.date   =datestr(clock);
    orbit.comment=get(handles.edit_legend,'String');
    % commentaire
    timing=get_synchro;
    timing.date   =datestr(clock);
    timing.comment=get(handles.edit_legend,'String');
    
% sauvegarde
Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
save(file, 'boo' ,'timing' ,'orbit');
cd(pwdold);




% --- Executes on button press in button_save_param.
function button_save_param_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% save parameter

file=appendtimestamp('boo');
set(handles.edit_file,'String',file);

% commentaire
    boo=load_param;
    boo.date   =datestr(clock);
    boo.comment=get(handles.edit_legend,'String');
    boo
% sauvegarde
Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
save(file, 'boo');
cd(pwdold);



% --- Executes on button press in button_save_orbir_corr.
function button_save_orbir_corr_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_orbir_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% save parameter
file=appendtimestamp('orbit');
set(handles.edit_file,'String',file);

% commentaire
    orbit=load_orbit_corr;
    orbit.date   =datestr(clock);
    orbit.comment=get(handles.edit_legend,'String');
    orbit
    
% sauvegarde
Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
save(file, 'orbit');
cd(pwdold);


% --- Executes on button press in button_save_synchro.
function button_save_synchro_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_synchro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file=appendtimestamp('timing');
set(handles.edit_file,'String',file);

% commentaire
    timing=get_synchro;
    timing.date   =datestr(clock);
    timing.comment=get(handles.edit_legend,'String');
    timing
    
% sauvegarde
Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
save(file, 'timing');
cd(pwdold);


function edit_legend_Callback(hObject, eventdata, handles)
% hObject    handle to edit_legend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_legend as text
%        str2double(get(hObject,'String')) returns contents of edit_legend as a double
get(hObject,'String')

% --- Executes during object creation, after setting all properties.
function edit_legend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_legend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_file_Callback(hObject, eventdata, handles)
% hObject    handle to edit_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_file as text
%        str2double(get(hObject,'String')) returns contents of edit_file as a double


% --- Executes during object creation, after setting all properties.
function edit_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_update_boo.
function button_update_boo_Callback(hObject, eventdata, handles)
% hObject    handle to button_update_boo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);

listefile = dir('boo_*') ;
comment={};
separateur={};
for i=1:length(listefile)
  load(listefile(i).name);
  comment=strvcat(comment , boo.comment);
  separateur=strvcat(separateur , ' ==> ' );
end
[sorted_names,sorted_index] = sortrows({listefile.name}');
handles.files_names=sorted_names;
handles.files_index=sorted_index;
handles.files_comment=comment;
guidata(hObject, handles);

ttt=strcat(sorted_names,separateur,comment);
set(handles.listbox1,'String',ttt,'Value',1)
cd(pwdold);



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

num=get(hObject,'Value');
file=handles.files_names(num);
txt=strcat('Selection = ',file );
set(handles.edit_file,'String',txt);


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_load_boo.
function button_load_boo_Callback(hObject, eventdata, handles)
% hObject    handle to button_load_boo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num=get(handles.listbox1,'Value')
file=handles.files_names{num}
Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
load(file)
cd(pwdold);
boo
%   boo timing  orbit

% load
    setam('HCOR',boo.corrx);
    setam('VCOR',boo.corrz);
    writeattribute('LT1/AE/CV.2/current', boo.cv2 );
    writeattribute('LT1/AE/CV.3/current', boo.cv3 );
    writeattribute('BOO/AE/dipole/current',boo.DIPcurrent);
    writeattribute('BOO/AE/QF/current',boo.QFcurrent);
    writeattribute('BOO/AE/QD/current',boo.QDcurrent);
    writeattribute('BOO/AE/SF/current',boo.SFcurrent);
    writeattribute('BOO/AE/SD/current',boo.SDcurrent);
    writeattribute('BOO/AE/dipole/waveformOffset',boo.DIPoffset);
    writeattribute('BOO/AE/QF/waveformOffset',boo.QFpoffset);
    writeattribute('BOO/AE/QD/waveformOffset',boo.QDpoffset);
    writeattribute('BOO/AE/SF/waveformOffset',boo.SFpoffset);
    writeattribute('BOO/AE/SD/waveformOffset',boo.SDpoffset);
    
    
    writeattribute('BOO-C01/EP/AL_K.Inj/voltage',boo.KINJvoltage);
    writeattribute('BOO-C22/EP/AL_SEP_P.Inj/voltage',boo.SPINJvoltage);
    writeattribute('BOO-C10/EP/AL_DOF.1/voltagePeakValue',boo.DOF1EXTvoltage);
    writeattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue',boo.DOF2EXTvoltage);
    writeattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue',boo.DOF3EXTvoltage);
    writeattribute('BOO-C10/EP/AL_K.Ext/voltage',boo.KEXTvoltage);
    writeattribute('BOO-C11/EP/AL_SEP_P.Ext.1/serialVoltage',boo.SPEXTvoltage);
    writeattribute('BOO-C12/EP/AL_SEP_A.Ext/voltage,',boo.SAEXTvoltage);
    
  


% --- Executes on button press in button_update_timing.
function button_update_timing_Callback(hObject, eventdata, handles)
% hObject    handle to button_update_timing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);

listefile = dir('timing_*') ;
comment={};
separateur={};
for i=1:length(listefile)
  load(listefile(i).name);
  comment=strvcat(comment , timing.comment);
  separateur=strvcat(separateur , ' ==> ' );
end
[sorted_names,sorted_index] = sortrows({listefile.name}');
handles.files_names=sorted_names;
handles.files_index=sorted_index;
handles.files_comment=comment;
guidata(hObject, handles);

ttt=strcat(sorted_names,separateur,comment);
set(handles.listbox1,'String',ttt,'Value',1)
cd(pwdold);


% --- Executes on button press in button_display.
function button_display_Callback(hObject, eventdata, handles)
% hObject    handle to button_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

boo=[];timing=[];
num=get(handles.listbox1,'Value');
file=handles.files_names{num}
Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
load(file);
cd(pwdold);

format long
boo
timing

save('Workspace','boo')


% --- Executes on button press in button_load_timing.
function button_load_timing_Callback(hObject, eventdata, handles)
% hObject    handle to button_load_timing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num=get(handles.listbox1,'Value')
file=handles.files_names{num}
load_synchro(file)

% %   boo timing  orbit
% tout=0.2;
% if (length(timing.lin_lpm)==1)  % ancien
%     tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',timing.sdc1);pause(tout);
%     tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmTimeDelay',timing.lin_lpm);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay',timing.boo_bpm);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigTimeDelay',timing.boo_bpm);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigTimeDelay',timing.boo_bpm);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigTimeDelay',timing.boo_bpm);pause(tout);     
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',timing.lt1_emittance);pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',timing.lt1_mc1);pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',timing.lt1_mc2);pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',timing.lt1_osc);pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',timing.boo_dcct);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay',timing.boo_nod);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_inj);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay',timing.boo_k_inj);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',timing.boo_dp);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',timing.boo_qf);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',timing.boo_qd);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',timing.boo_sf);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',timing.boo_sd);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay',timing.boo_rf);pause(tout);
%     tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay',timing.sdc2);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay',timing.boo_dof_ext);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_ext);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay',timing.boo_sep_a_ext);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay',timing.boo_k_ext);pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.lt2_bpm);pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay',timing.lt2_osc);pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay',timing.lt2_emittance);pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceTimeDelay',timing.lt2_emittance);pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay',timing.ans_k1_inj);pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay',timing.ans_k2_inj);pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay',timing.ans_k3_inj);pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay',timing.ans_k4_inj);pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay',timing.ans_sep_p_inj);pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay',timing.ans_sep_a_inj);pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.ans_bpm01);pause(tout);
%     tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm02);pause(tout);
%     tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm03);pause(tout);
%     tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm04);pause(tout);
%     tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm05);pause(tout);
%     tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm06);pause(tout);
%     tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm07);pause(tout);
%     tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm08);pause(tout);
%     tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm09);pause(tout);
%     tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm10);pause(tout);  
%     tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm11);pause(tout);  
%     tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm12);pause(tout);  
%     tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm13);pause(tout);  
%     tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm14);pause(tout);  
%     tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm15);pause(tout);  
%     tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm16);pause(tout);   
%     tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay',timing.ans_dcct);pause(tout)
%     
% elseif (length(timing.lin_lpm)==2)  % nouveau avec spm
%     display('Delay')
%     tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscTimeDelay',timing.sdc1(1));pause(tout);
%     tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmTimeDelay',timing.lin_lpm(1));pause(tout);
%     if isfield('timing','lin_spm');tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacTimeDelay',timing.lin_spm(1));pause(tout);end
%     tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigTimeDelay',timing.boo_bpm(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigTimeDelay',timing.boo_bpm(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigTimeDelay',timing.boo_bpm(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigTimeDelay',timing.boo_bpm(1));pause(tout);     
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceTimeDelay',timing.lt1_emittance(1));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1TimeDelay',timing.lt1_mc1(1));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2TimeDelay',timing.lt1_mc2(1));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscTimeDelay',timing.lt1_osc(1));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booTimeDelay',timing.boo_dcct(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigTimeDelay',timing.boo_nod(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_inj(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigTimeDelay',timing.boo_k_inj(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',timing.boo_dp(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',timing.boo_qf(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',timing.boo_qd(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',timing.boo_sf(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',timing.boo_sd(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.RF.1', 'rfTimeDelay',timing.boo_rf(1));pause(tout);
%     tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareTimeDelay',timing.sdc2(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigTimeDelay',timing.boo_dof_ext(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigTimeDelay',timing.boo_sep_p_ext(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigTimeDelay',timing.boo_sep_a_ext(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigTimeDelay',timing.boo_k_ext(1));pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.lt2_bpm(1));pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctTimeDelay',timing.lt2_osc(1));pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvTimeDelay',timing.lt2_emittance(1));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceTimeDelay',timing.lt2_emittance(1));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigTimeDelay',timing.ans_k1_inj(1));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigTimeDelay',timing.ans_k2_inj(1));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigTimeDelay',timing.ans_k3_inj(1));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigTimeDelay',timing.ans_k4_inj(1));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigTimeDelay',timing.ans_sep_p_inj(1));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigTimeDelay',timing.ans_sep_a_inj(1));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigTimeDelay',timing.ans_bpm01(1));pause(tout);
%     tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm02(1));pause(tout);
%     tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm03(1));pause(tout);
%     tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm04(1));pause(tout);
%     tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm05(1));pause(tout);
%     tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm06(1));pause(tout);
%     tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm07(1));pause(tout);
%     tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm08(1));pause(tout);
%     tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm09(1));pause(tout);
%     tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm10(1));pause(tout);  
%     tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm11(1));pause(tout);  
%     tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm12(1));pause(tout);  
%     tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm13(1));pause(tout);  
%     tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm14(1));pause(tout);  
%     tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm15(1));pause(tout);  
%     tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigTimeDelay',timing.ans_bpm16(1));pause(tout);   
%     tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctTimeDelay',timing.ans_dcct(1));pause(tout);
%     display('Event')
%     tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'oscEvent',int32(timing.sdc1(2)));pause(tout);
%     tango_write_attribute2('LIN/SY/LOCAL.LPM.1', 'lpmEvent',int32(timing.lin_lpm(2)));pause(tout);
%     if isfield('timing','lin_spm');tango_write_attribute2('LIN/SY/LOCAL.SPM.1', 'spmLinacEvent',int16(timing.lin_spm(2)));pause(tout);end
%     tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-bta.trigEvent',int32(timing.boo_bpm(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.1', 'bpm-btd.trigEvent',int32(timing.boo_bpm(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.2', 'bpm-btb.trigEvent',int32(timing.boo_bpm(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-btc.trigEvent',int32(timing.boo_bpm(2)));pause(tout);     
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'emittanceEvent',int32(timing.lt1_emittance(2)));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.1Event',int32(timing.lt1_mc1(2)));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'mc.2Event',int32(timing.lt1_mc2(2)));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'oscEvent',int32(timing.lt1_osc(2)));pause(tout);
%     tango_write_attribute2('LT1/SY/LOCAL.DG.1', 'dcct-booEvent',int32(timing.boo_dcct(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'bpm-onde.trigEvent',int32(timing.boo_nod(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'sep-p.trigEvent',int32(timing.boo_sep_p_inj(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Binj.1', 'k.trigEvent',int32(timing.boo_k_inj(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpEvent',int32(timing.boo_dp(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfEvent',int32(timing.boo_qf(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdEvent',int32(timing.boo_qd(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfEvent',int32(timing.boo_sf(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdEvent',int32(timing.boo_sd(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.RF.1', 'rfEvent',int32(timing.boo_rf(2)));pause(tout);
%     tango_write_attribute2('ANS/SY/LOCAL.SDC.1', 'spareEvent',int32(timing.sdc2(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'dof.trigEvent',int32(timing.boo_dof_ext(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-p.trigEvent',int32(timing.boo_sep_p_ext(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'sep-a.trigEvent',int32(timing.boo_sep_a_ext(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.Bext.1', 'k.trigEvent',int32(timing.boo_k_ext(2)));pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.2', 'bpm.trigEvent',int32(timing.lt2_bpm(2)));pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'osc-fctEvent',int32(timing.lt2_osc(2)));pause(tout);
%     tango_write_attribute2('LT2/SY/LOCAL.DG.1', 'mrsvEvent',int32(timing.lt2_emittance(2)));pause(tout);
%     tango_write_attribute2('BOO/SY/LOCAL.DG.3', 'emittanceEvent',int32(timing.lt2_emittance(2)));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k1.trigEvent',int32(timing.ans_k1_inj(2)));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k2.trigEvent',int32(timing.ans_k2_inj(2)));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k3.trigEvent',int32(timing.ans_k3_inj(2)));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.1', 'k4.trigEvent',int32(timing.ans_k4_inj(2)));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-p.trigEvent',int32(timing.ans_sep_p_inj(2)));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.Ainj.2', 'sep-a.trigEvent',int32(timing.ans_sep_a_inj(2)));pause(tout);
%     tango_write_attribute2('ANS-C01/SY/LOCAL.DG.2', 'bpm.trigEvent',int32(timing.ans_bpm01(2)));pause(tout);
%     tango_write_attribute2('ANS-C02/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm02(2)));pause(tout);
%     tango_write_attribute2('ANS-C03/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm03(2)));pause(tout);
%     tango_write_attribute2('ANS-C04/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm04(2)));pause(tout);
%     tango_write_attribute2('ANS-C05/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm05(2)));pause(tout);
%     tango_write_attribute2('ANS-C06/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm06(2)));pause(tout);
%     tango_write_attribute2('ANS-C07/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm07(2)));pause(tout);
%     tango_write_attribute2('ANS-C08/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm08(2)));pause(tout);
%     tango_write_attribute2('ANS-C09/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm09(2)));pause(tout);
%     tango_write_attribute2('ANS-C10/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm10(2)));pause(tout);  
%     tango_write_attribute2('ANS-C11/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm11(2)));pause(tout);  
%     tango_write_attribute2('ANS-C12/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm12(2)));pause(tout);  
%     tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm13(2)));pause(tout);  
%     tango_write_attribute2('ANS-C14/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm14(2)));pause(tout);  
%     tango_write_attribute2('ANS-C15/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm15(2)));pause(tout);  
%     tango_write_attribute2('ANS-C16/SY/LOCAL.DG.1', 'bpm.trigEvent',int32(timing.ans_bpm16(2)));pause(tout);   
%     tango_write_attribute2('ANS-C13/SY/LOCAL.DG.1', 'dcctEvent',int32(timing.ans_dcct(2)));pause(tout);
%  end
    
