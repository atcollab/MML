function varargout = NombreOnde_AL_DCCT(varargin)
% NOMBREONDE_AL_DCCT M-file for NombreOnde_AL_DCCT.fig
%      NOMBREONDE_AL_DCCT, by itself, creates a new NOMBREONDE_AL_DCCT or raises the existing
%      singleton*.
%
%      H = NOMBREONDE_AL_DCCT returns the handle to a new NOMBREONDE_AL_DCCT or the handle to
%      the existing singleton*.
%
%      NOMBREONDE_AL_DCCT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOMBREONDE_AL_DCCT.M with the given input arguments.
%
%      NOMBREONDE_AL_DCCT('Property','Value',...) creates a new NOMBREONDE_AL_DCCT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NombreOnde_AL_DCCT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NombreOnde_AL_DCCT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help NombreOnde_AL_DCCT

% Last Modified by GUIDE v2.5 14-Dec-2006 05:47:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NombreOnde_AL_DCCT_OpeningFcn, ...
                   'gui_OutputFcn',  @NombreOnde_AL_DCCT_OutputFcn, ...
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


% --- Executes just before NombreOnde_AL_DCCT is made visible.
function NombreOnde_AL_DCCT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NombreOnde_AL_DCCT (see VARARGIN)

if ~strcmp(getfamilydata('SubMachine'),'Booster')
    error('Load Booster first');
end

% Choose default command line output for NombreOnde_AL_DCCT
handles.Stop_NO = 0;
handles.output = hObject;
handles.X_NO   = hObject;
handles.Z_NO   = hObject;
handles.X_Pos  = hObject;
handles.Z_Pos  = hObject;
%handles.Q=hObject;
handles.Stop_var=hObject;
%handles.PQfft=hObject;
handles.PXfft = hObject;
handles.PZfft = hObject;

setappdata(handles.figure1, 'hplot1', 0);
setappdata(handles.figure1, 'hplot2', 0);
setappdata(handles.figure1, 'hplot3', 0);
setappdata(handles.figure1, 'hplot4', 0);
setappdata(handles.figure1, 'hplot5', 0);
setappdata(handles.figure1, 'hlegend1', 0);
setappdata(handles.figure1, 'hlegend2', 0);
setappdata(handles.figure1, 'hlegend3', 0);

% Update handles structure
guidata(hObject, handles);

cla(handles.Onde_X);
cla(handles.Onde_Z);
cla(handles.Position_X);
cla(handles.Position_Z);
cla(handles.DCCT);


% --- Outputs from this function are returned to the command line.
function varargout = NombreOnde_AL_DCCT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function dev_name_NO_Callback(hObject, eventdata, handles)
% hObject    handle to dev_name_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev_name_NO as text
%        str2double(get(hObject,'String')) returns contents of dev_name_NO as a double
dev      = get(handles.dev_name_NO,'String');
val_dev  = get(handles.dev_name_NO,'value');

if val_dev ~=1
    tango_set_timeout(dev{val_dev},30000);
    dec     = tango_read_attribute2(dev{val_dev},'DDDecimationFactor');
    set(handles.Current_mode_NO,'String',dec.value(1));

    Nvalues = tango_read_attribute2(dev{val_dev},'DDBufferSize');
    set(handles.Nsamples_NO,'String',num2str(Nvalues.value(1)));
end

% --- Executes during object creation, after setting all properties.
function dev_name_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev_name_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Nsamples_NO_Callback(hObject, eventdata, handles)
% hObject    handle to profondeur_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of profondeur_NO as text
%        str2double(get(hObject,'String')) returns contents of profondeur_NO as a double
Nvaleurs = int32(str2num(get(handles.Nsamples_NO,'String')));
dev      = get(handles.dev_name_NO,'String');
val_dev  = get(handles.dev_name_NO,'value');

tango_write_attribute2(dev{val_dev},'DDBufferSize',Nvaleurs);

% --- Executes during object creation, after setting all properties.
function Nsamples_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to profondeur_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Change_mode_NO.
function Change_mode_NO_Callback(hObject, eventdata, handles)
% hObject    handle to Change_mode_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Change_mode_NO contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Change_mode_NO
val     = get(handles.Change_mode_NO,'Value');
dev     = get(handles.dev_name_NO,'String');
val_dev = get(handles.dev_name_NO,'value');

switch val
    case 1
        tango_write_attribute2(dev{val_dev},'Mode','MODE_FT') 
    case 2
        tango_write_attribute2(dev{val_dev},'Mode','MODE_TT') 
    case 3
         tango_write_attribute2(dev{val_dev},'Mode','MODE_BN') 
         set(handles.Current_mode_NO,'String','Boo Normal');
         set(handles.Nsamples_NO,'string',num2str(10169));
end;

% Read mod and update GUI
mode = tango_read_attribute2(dev{val_dev},'Mode');
set(handles.Current_mode_NO,'String',mode.value);

% --- Executes during object creation, after setting all properties.
function Change_mode_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Change_mode_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Current_mode_NO_Callback(hObject, eventdata, handles)
% hObject    handle to Current_mode_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_mode_NO as text
%        str2double(get(hObject,'String')) returns contents of Current_mode_NO as a double
Nvaleurs = uint16(str2double(get(hObject,'String')));
dev      = get(handles.dev_name_NO,'String');
val_dev  = get(handles.dev_name_NO,'value');

tango_write_attribute2(dev{val_dev},'DDDecimationFactor',Nvaleurs);

% --- Executes during object creation, after setting all properties.
function Current_mode_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Current_mode_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton14.
function Generate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val_dev1 = get(handles.dev_name_NO,'value');
val_dev2 = get(handles.dev_name_Pos,'value');

if val_dev1 == 1 || val_dev2 == 1
    warndlg('Select BPMs first !');
    return;
end

valeur  = get(handles.Aquisition_continue,'Value');

if valeur == 1
        T=timer('TimerFcn',{@Timer_NO_Callback,hObject, eventdata,handles},'ExecutionMode','fixedSpacing','Period',1);    
        setappdata(handles.figure1,'Stop_NO',0);
        start(T);
else
    handles = getandplotdata(hObject, eventdata, handles);
end
    
guidata(hObject,handles);


function Timer_NO_Callback(obj,event,hObject, eventdata, handles)

handles = getandplotdata(hObject, eventdata, handles);

Stop_NO = getappdata(handles.figure1,'Stop_NO');
if Stop_NO == 1
    stop(obj);
    delete(obj);
    return
end


function handles = getandplotdata(hObject, eventdata, handles)

%% First panel
dev     = get(handles.dev_name_NO,'String');
val_dev = get(handles.dev_name_NO,'value');

Nsamples=int32(str2num(get(handles.Nsamples_NO,'String')));

Attr_name_list={'XPosDD'};
argout = tango_read_attributes2(dev{val_dev},Attr_name_list);

handles.X = argout(1).value;
guidata(hObject, handles);

istart   = str2num(get(handles.Start_NO,'String'));
nbpoints = str2num(get(handles.profondeur_NO,'String'));
iend     = istart + nbpoints-1;
Xval(1:nbpoints) = handles.X(istart:iend);

Xfft     = fft(Xval,nbpoints);
PXfft    = Xfft.* conj(Xfft) / nbpoints;

PXfft([1 2 nbpoints]) = 0; %% ???

% skip points ????
n1 = int16(nbpoints/20)
n2 = int16(nbpoints-n1)
%%
frev = 1.91414; % MHz

mx    = max(PXfft(n1:n2));
nux   = (find(PXfft==max(PXfft(n1:n2)))-1)/ nbpoints;
fnux  = (1-nux)*frev;
f352x = (nux)*frev + 352.183; % Frf

f = (1:nbpoints)/nbpoints;

hplot1   = getappdata(handles.figure1, 'hplot1');
hlegend1 = getappdata(handles.figure1, 'hlegend1');
legendstr1 = ['nux=', num2str(1-nux(1)),'   fexc=',num2str(fnux(1)),'   fdetec=',num2str(f352x(1))];

if hplot1 == 0
    hplot1 = plot(handles.Onde_X,f,PXfft(1:(nbpoints)));
    hlegend1 = legend(handles.Onde_X,legendstr1);
    set(hlegend1,'FontSize',20);
    ylabel(handles.Onde_X,'X')
    set(handles.Onde_X,'XTickLabel',[]);
    grid(handles.Onde_X, 'on');
else
    set(hplot1,'XData', f, 'YData', PXfft(1:(nbpoints)));
    set(hlegend1,'String', legendstr1);
end
      
set(handles.Onde_X,'YLim',[0 1.2*mx]);

handles.PXfft = PXfft;

X_display=0;
X_display=handles.X;
X_display=X_display(2:size(X_display,2)); 

Echelle = str2num(get(handles.Echelle,'String'));

hplot3   = getappdata(handles.figure1, 'hplot3');

if hplot3 == 0
    hplot3 = plot(handles.Position_X, X_display);
    ylabel(handles.Position_X, 'mm');
    grid(handles.Position_X, 'on')
else
    set(hplot3, 'YData', X_display);
end

set(handles.Position_X,'YLim',[-6 6]);
set(handles.Position_X,'XLim',[0 Echelle]);
set(handles.Position_X,'XTickLabel',[]);
guidata(hObject, handles);

%% Second panel
dev      = get(handles.dev_name_Pos,'String');
val_dev  = get(handles.dev_name_Pos,'value');
Nsamples = int32(str2num(get(handles.Nsamples_Pos,'String')));
Attr_name_list={'ZPosDD'};
argout   = tango_read_attributes2(dev{val_dev},Attr_name_list);
handles.Z=argout(1).value;

Zval(1:nbpoints) = handles.Z(istart:iend);

Zfft     = fft(Zval,nbpoints);
PZfft    = Zfft.* conj(Zfft) / nbpoints ;
PZfft(1) = 0;
PZfft(2) = 0;
PZfft(nbpoints) = 0;

mz       = max(PZfft(n1:n2));
nuz      = (find(PZfft==max(PZfft(n1:n2)))-1)/ nbpoints;
fnuz     = (1-nuz(1))*1.91414;
f352z    = (nuz)*1.91414+352.183;

hplot2     = getappdata(handles.figure1, 'hplot2');
hlegend2   = getappdata(handles.figure1, 'hlegend2');
legendstr2 = ['nuz=', num2str(1-nuz(1)),'  fexc=',num2str(fnuz(1)),'   fdetec=',num2str(f352z(1))];

if hplot2 == 0
    hplot2 = plot(handles.Onde_Z,f,PZfft(1:(nbpoints)))
    hlegend2 = legend(handles.Onde_Z,legendstr2);
    set(hlegend2,'FontSize',20);
    ylabel(handles.Onde_Z,'Z');
    xlabel(handles.Onde_Z,'Tune');
    grid(handles.Onde_Z, 'on');
else
    set(hplot2,'XData', f, 'YData', PZfft(1:(nbpoints)));
    set(hlegend2,'String', legendstr2);
end

set(handles.Onde_Z,'YLim',[0 1.2*mz]);
    
Z_display=0;
Z_display=handles.Z;
Z_display=Z_display(2:size(Z_display,2)); 

handles.PZfft=PZfft;

hplot4   = getappdata(handles.figure1, 'hplot4');
if hplot4 == 0
    hplot4 = plot(handles.Position_Z, Z_display);
    ylabel(handles.Position_Z, 'mm');
    xlabel(handles.Position_Z, 'Turn number')
    grid(handles.Position_Z, 'on')
else
    set(hplot4, 'YData', Z_display);
end
set(handles.Position_Z,'YLim',[-6 6]);
set(handles.Position_Z,'XLim',[0 Echelle]);


%% Third panel
% plot courant

temp=tango_read_attribute2('BOO-C01/DG/DCCT','iV');
cur=temp.value-0.09;
%cur=[1:340]/340*-5;
hplot5   = getappdata(handles.figure1, 'hplot5');
if hplot5 == 0
     %hplot5 = plot(handles.DCCT,cur,'-r','LineWidth',2);
     hplot5 = stairs(handles.DCCT,cur,'r');
     ylabel(handles.DCCT, 'I mA');
     xlabel(handles.DCCT, 'Time ms')
     grid(handles.DCCT, 'on')
else
    set(hplot5, 'YData', cur);
end
set(handles.DCCT,'YLim',[-6 1]);
set(handles.DCCT,'XLim',[0 length(cur)]);


setappdata(handles.figure1, 'hplot1', hplot1);
setappdata(handles.figure1, 'hplot2', hplot2);
setappdata(handles.figure1, 'hplot3', hplot3);
setappdata(handles.figure1, 'hplot4', hplot4);
setappdata(handles.figure1, 'hplot5', hplot5);
setappdata(handles.figure1, 'hlegend1', hlegend1);
setappdata(handles.figure1, 'hlegend2', hlegend2);

guidata(hObject, handles);


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.figure1,'Stop_NO',1);
disp('CONTINUOUS LOOP STOPPED')


% --- Executes on button press in Aquisition_continue.
function Aquisition_continue_Callback(hObject, eventdata, handles)
% hObject    handle to Aquisition_continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Aquisition_continue

val = get(hObject,'Value');

if val
    setappdata(handles.figure1,'Stop_NO',0);
else
    setappdata(handles.figure1,'Stop_NO',1);
end

function Filename_Callback(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filename as text
%        str2double(get(hObject,'String')) returns contents of Filename as a double


% --- Executes during object creation, after setting all properties.
function Filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global X Z Q PXfft PQfft PZfft;

Nsamples = str2num(get(handles.Nsamples_NO,'String'));
dev      = get(handles.dev_name_NO,'String');
val_dev  = get(handles.dev_name_NO,'value');
mode     = tango_read_attribute2(dev{val_dev},'Mode');
filename = get(handles.Filename,'String')
X        = handles.X;
Z        = handles.Z;
%Q=handles.Q;
PXfft   = handles.PXfft;
PZfft   = handles.PZfft;

% Saving data
dirname = getfamilydata('Directory','TurnByTurnTune');
pwd_old = pwd;
cd(dirname);

if strcmp(filename, 'Filename');
    filename = tune;
end

filename = appendtimestamp(filename);
save(filename,'Nsamples','mode','X','Z','PXfft','PZfft');
cd(pwd_old);


% --- Executes on button press in Detection.
function Detection_Callback(hObject, eventdata, handles)
% hObject    handle to Detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Detection

function Start_NO_Callback(hObject, eventdata, handles)
% hObject    handle to Start_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Start_NO as text
%        str2double(get(hObject,'String')) returns contents of Start_NO as a double

% --- Executes during object creation, after setting all properties.
function Start_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Start_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function profondeur_NO_Callback(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filename as text
%        str2double(get(hObject,'String')) returns contents of Filename as a double


% --- Executes during object creation, after setting all properties.
function profondeur_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in dev_name_Pos.
function dev_name_Pos_Callback(hObject, eventdata, handles)
% hObject    handle to dev_name_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dev_name_Pos contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dev_name_Pos
dev     = get(handles.dev_name_Pos,'String');
val_dev = get(handles.dev_name_Pos,'value');

if val_dev ~=1
    tango_set_timeout(dev{val_dev},30000);
    dec     = tango_read_attribute2(dev{val_dev},'DDDecimationFactor');
    set(handles.Current_mode_Pos,'String',dec.value(1));

    Nvalues  = tango_read_attribute2(dev{val_dev},'DDBufferSize');
    set(handles.Nsamples_Pos,'String',num2str(Nvalues.value(1)));
end

% --- Executes during object creation, after setting all properties.
function dev_name_Pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev_name_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Echelle_Callback(hObject, eventdata, handles)
% hObject    handle to Echelle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Echelle as text
%        str2double(get(hObject,'String')) returns contents of Echelle as a double


% --- Executes during object creation, after setting all properties.
function Echelle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Echelle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Change_mode_Pos.
function Change_mode_Pos_Callback(hObject, eventdata, handles)
% hObject    handle to Change_mode_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Change_mode_Pos contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Change_mode_Pos
val     = get(handles.Change_mode_Pos,'Value')
dev     = get(handles.dev_name_Pos,'String')
val_dev = get(handles.dev_name_Pos,'value')

switch val
    case 1
        tango_write_attribute(dev{val_dev},'Mode','MODE_FT') 
        %test_erreur_tango;
    case 2
        tango_write_attribute(dev{val_dev},'Mode','MODE_TT') 
        %test_erreur_tango;
    case 3
         tango_write_attribute(dev{val_dev},'Mode','MODE_BN') 
         set(handles.Current_mode_NO,'String','Boo Normal');
         set(handles.Nsamples_NO,'string',num2str(10169));
end;
mode = tango_read_attribute2(dev{val_dev},'Mode');
set(handles.Current_mode_Pos,'String',mode.value);


% --- Executes during object creation, after setting all properties.
function Change_mode_Pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Change_mode_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Current_mode_Pos_Callback(hObject, eventdata, handles)
% hObject    handle to Current_mode_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_mode_Pos as text
%        str2double(get(hObject,'String')) returns contents of Current_mode_Pos as a double
Nvaleurs = uint16(str2double(get(hObject,'String')));
dev      = get(handles.dev_name_Pos,'String');
val_dev  = get(handles.dev_name_Pos,'value');

tango_write_attribute2(dev{val_dev},'DDDecimationFactor',Nvaleurs);

% --- Executes during object creation, after setting all properties.
function Current_mode_Pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Current_mode_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nsamples_Pos_Callback(hObject, eventdata, handles)
% hObject    handle to Nsamples_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nsamples_Pos as text
%        str2double(get(hObject,'String')) returns contents of Nsamples_Pos as a double
Nvaleurs = int32(str2num(get(handles.Nsamples_Pos,'String')));
dev      = get(handles.dev_name_Pos,'String');
val_dev  = get(handles.dev_name_Pos,'value');

tango_write_attribute2(dev{val_dev},'DDBufferSize',Nvaleurs);
set(handles.Echelle,'String',Nvaleurs); 

% --- Executes during object creation, after setting all properties.
function Nsamples_Pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nsamples_Pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

