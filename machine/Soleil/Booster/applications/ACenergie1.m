function varargout = ACenergie1(varargin)
% ACENERGIE1 M-file for ACenergie1.fig
%      ACENERGIE1, by itself, creates a new ACENERGIE1 or raises the existing
%      singleton*.
%
%      H = ACENERGIE1 returns the handle to a new ACENERGIE1 or the handle to
%      the existing singleton*.
%
%      ACENERGIE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACENERGIE1.M with the given input arguments.
%
%      ACENERGIE1('Property','Value',...) creates a new ACENERGIE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ACenergie1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ACenergie1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ACenergie1

% Last Modified by GUIDE v2.5 05-May-2006 10:10:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ACenergie1_OpeningFcn, ...
                   'gui_OutputFcn',  @ACenergie1_OutputFcn, ...
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


% --- Executes just before ACenergie1 is made visible.
function ACenergie1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ACenergie1 (see VARARGIN)

% Choose default command line output for ACenergie1
handles.output = hObject;

% Update handles structure/home/operateur
guidata(hObject, handles);

% UIWAIT makes ACenergie1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ACenergie1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_energie_Callback(hObject, eventdata, handles)
% hObject    handle to edit_energie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_energie as text
%        str2double(get(hObject,'String')) returns contents of edit_energie as a double


% --- Executes during object creation, after setting all properties.
function edit_energie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_energie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_apply.
function button_apply_Callback(hObject, eventdata, handles)
% hObject    handle to button_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

r=str2double(get(handles.edit_energie,'String'));



    val(1)=readattribute('BOO/AE/D.1/current'        ,'Setpoint');
    val(2)=readattribute('BOO/AE/QF/current'          ,'Setpoint');
    val(3)=readattribute('BOO/AE/QD/current'          ,'Setpoint');
    
    val(4)=readattribute('BOO-C10/EP/AL_DOF.1/voltagePeakValue');
    val(5)=readattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue');
    val(6)=readattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue');
    
    val(7)=readattribute('BOO-C10/EP/AL_K.Ext/voltage');
    val(8)=readattribute('BOO-C11/EP/AL_SEP_P.Ext.1/serialVoltage');
    val(9)=readattribute('BOO-C12/EP/AL_SEP_A.Ext/voltage');
    
    temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay');
    Tinj=temp.value(1);
    temp=tango_read_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay');
    Tsoft=temp.value(1);
    
    
    val=val*(1+r/100)
    Tinj =Tinj -  r*100 ;            %  1% = + 100 µs
    Tsoft=Tsoft-  r*100 ;            %  1% = + 100 µs
    
    
    if (val(1) >= 22)
        
        set(handles.edit_dipole,'String',' Too big !');
        set(handles.edit_qf,'String','  not');
        set(handles.edit_qd,'String',' applied !');
        set(handles.edit_energie,'String',num2str(0));
        
    else
        
        val
        Tinj
        set(handles.edit_dipole,'String',num2str(val(1)));
        set(handles.edit_qf,'String',num2str(val(2)));
        set(handles.edit_qd,'String',num2str(val(3)));
   
%     writeattribute('BOO/AE/D.1/current'         ,val(1));
%     writeattribute('BOO/AE/QF/current'          ,val(2));
%     writeattribute('BOO/AE/QD/current'          ,val(3));

%     writeattribute('BOO-C10/EP/AL_DOF.1/voltagePeakValue',val(4));
%     writeattribute('BOO-C11/EP/AL_DOF.2/voltagePeakValue',val(5));
%     writeattribute('BOO-C12/EP/AL_DOF.3/voltagePeakValue',val(6));
%     writeattribute('BOO-C10/EP/AL_K.Ext/voltage',val(7));
%     writeattribute('BOO-C11/EP/AL_SEP_P.Ext.1/serialVoltage',val(8));
%     writeattribute('BOO-C12/EP/AL_SEP_A.Ext/voltage,',val(9));
%     tango_write_attribute2('ANS/SY/CENTRAL', 'TInjTimeDelay',Tinj);
%     tango_write_attribute2('ANS/SY/CENTRAL', 'TSoftTimeDelay',Tsoft);

    end
    

function edit_dipole_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dipole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dipole as text
%        str2double(get(hObject,'String')) returns contents of edit_dipole as a double


% --- Executes during object creation, after setting all properties.
function edit_dipole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dipole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_qf_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qf as text
%        str2double(get(hObject,'String')) returns contents of edit_qf as a double


% --- Executes during object creation, after setting all properties.
function edit_qf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_qd_Callback(hObject, eventdata, handles)
% hObject    handle to edit_qd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_qd as text
%        str2double(get(hObject,'String')) returns contents of edit_qd as a double


% --- Executes during object creation, after setting all properties.
function edit_qd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_qd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


