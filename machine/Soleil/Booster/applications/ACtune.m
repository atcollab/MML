function varargout = ACtune(varargin)
% ACTUNE M-file for ACtune.fig
%      ACTUNE, by itself, creates a new ACTUNE or raises the existing
%      singleton*.
%
%      H = ACTUNE returns the handle to a new ACTUNE or the handle to
%      the existing singleton*.
%
%      ACTUNE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTUNE.M with the given input arguments.
%
%      ACTUNE('Property','Value',...) creates a new ACTUNE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ACtune_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ACtune_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ACtune

% Last Modified by GUIDE v2.5 27-Apr-2006 14:46:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ACtune_OpeningFcn, ...
                   'gui_OutputFcn',  @ACtune_OutputFcn, ...
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


% --- Executes just before ACtune is made visible.
function ACtune_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ACtune (see VARARGIN)

% Choose default command line output for ACtune
handles.output = hObject;

if ~strcmp(getfamilydata('SubMachine'),'Booster')
    error('Load Booster first');
end

m1   =[1.1931   -0.1543 ; -0.2537    1.2602 ] ; 
acqf=200.*18.48/2*sin(18.48*.020);
acqd=150.*18.48/2*sin(18.48*.020);
r =110/2750;
% dtune = M *  QFoffset  QDoffset  QFcur  QDcur  delayQF  delay QD  (A et seconde)
M = [m1(1,1) m1(1,2)  r*m1(1,1) r*m1(1,2) -acqf*m1(1,1) -acqd*m1(1,2); ...
     m1(2,1) m1(2,2)  r*m1(2,1) r*m1(2,2) -acqf*m1(2,1) -acqd*m1(2,2); ...
     r*m1(1,1) r*m1(1,2) r*m1(1,1) r*m1(1,2) 0         0           ; ...
     r*m1(2,1) r*m1(2,2) r*m1(2,1) r*m1(2,2) 0         0           ; ...
     m1(1,1) m1(1,2)  r*m1(1,1) r*m1(1,2) acqf*m1(1,1) acqd*m1(1,2); ...
     m1(2,1) m1(2,2)  r*m1(2,1) r*m1(2,2) acqf*m1(2,1) acqd*m1(2,2)];
 
handles.M=M; 
% alim
    boo.DIPcurrent=readattribute('BOO/AE/D.1/current'        ,'Setpoint');
    boo.DIPoffset =readattribute('BOO/AE/D.1/waveformOffset' ,'Setpoint');
    boo.QFcurrent=readattribute('BOO/AE/QF/current'          ,'Setpoint');
    boo.QFpoffset =readattribute('BOO/AE/QF/waveformOffset'  ,'Setpoint');
    boo.QDcurrent=readattribute('BOO/AE/QD/current'          ,'Setpoint');
    boo.QDpoffset =readattribute('BOO/AE/QD/waveformOffset'  ,'Setpoint');
    boo.SFcurrent=readattribute('BOO/AE/SF/current'          ,'Setpoint');
    boo.SFpoffset =readattribute('BOO/AE/SF/waveformOffset'  ,'Setpoint');
    boo.SDcurrent=readattribute('BOO/AE/SD/current'          ,'Setpoint');
    boo.SDpoffset =readattribute('BOO/AE/SD/waveformOffset'  ,'Setpoint');
% synchro
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
    boo.DIPdelay=temp.value(1);
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
    boo.QFdelay=temp.value(1);
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
    boo.QDdelay=temp.value(1);
handles.boo=boo;



% Update handles structure
guidata(hObject, handles);


% UIWAIT makes ACtune wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ACtune_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function x_inj_Callback(hObject, eventdata, handles)
% hObject    handle to x_inj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_inj as text
%        str2double(get(hObject,'String')) returns contents of x_inj as a double


% --- Executes during object creation, after setting all properties.
function x_inj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_inj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_ext_Callback(hObject, eventdata, handles)
% hObject    handle to x_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_ext as text
%        str2double(get(hObject,'String')) returns contents of x_ext as a double


% --- Executes during object creation, after setting all properties.
function x_ext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_retour_Callback(hObject, eventdata, handles)
% hObject    handle to x_retour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_retour as text
%        str2double(get(hObject,'String')) returns contents of x_retour as a double


% --- Executes during object creation, after setting all properties.
function x_retour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_retour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_x_inj_plus.
function button_x_inj_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_inj_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tune =str2double(get(handles.x_inj,'String'));
tune=tune+0.05;
set(handles.x_inj,'String',num2str(tune));

% --- Executes on button press in button_x_ext_plus.
function button_x_ext_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_ext_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tune =str2double(get(handles.x_ext,'String'));
tune=tune+0.05;
set(handles.x_ext,'String',num2str(tune));

% --- Executes on button press in button_x_retour_plus.
function button_x_retour_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_retour_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.x_retour,'String'));
tune=tune+0.05;
set(handles.x_retour,'String',num2str(tune));

% --- Executes on button press in button_x_inj_moins.
function button_x_inj_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_inj_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.x_inj,'String'));
tune=tune-0.05;
set(handles.x_inj,'String',num2str(tune));

% --- Executes on button press in button_x_ext_moins.
function button_x_ext_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_ext_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.x_ext,'String'));
tune=tune-0.05;
set(handles.x_ext,'String',num2str(tune));

% --- Executes on button press in button_x_retour_moins.
function button_x_retour_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_retour_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tune =str2double(get(handles.x_retour,'String'));
tune=tune-0.05;
set(handles.x_retour,'String',num2str(tune));


% --- Executes on button press in button_x_plus.
function button_x_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tune =str2double(get(handles.x_inj,'String'));
tune=tune+0.05;
set(handles.x_inj,'String',num2str(tune));
tune =str2double(get(handles.x_ext,'String'));
tune=tune+0.05;
set(handles.x_ext,'String',num2str(tune));
tune =str2double(get(handles.x_retour,'String'));
tune=tune+0.05;
set(handles.x_retour,'String',num2str(tune));

% --- Executes on button press in button_x_zero.
function button_x_zero_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tune=0;
set(handles.x_inj,'String',num2str(tune));
set(handles.x_ext,'String',num2str(tune));
set(handles.x_retour,'String',num2str(tune));

% --- Executes on button press in button_x_moins.
function button_x_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_x_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tune =str2double(get(handles.x_inj,'String'));
tune=tune-0.05;
set(handles.x_inj,'String',num2str(tune));
tune =str2double(get(handles.x_ext,'String'));
tune=tune-0.05;
set(handles.x_ext,'String',num2str(tune));
tune =str2double(get(handles.x_retour,'String'));
tune=tune-0.05;
set(handles.x_retour,'String',num2str(tune));



function z_inj_Callback(hObject, eventdata, handles)
% hObject    handle to z_inj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_inj as text
%        str2double(get(hObject,'String')) returns contents of z_inj as a double


% --- Executes during object creation, after setting all properties.
function z_inj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_inj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_ext_Callback(hObject, eventdata, handles)
% hObject    handle to z_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_ext as text
%        str2double(get(hObject,'String')) returns contents of z_ext as a double


% --- Executes during object creation, after setting all properties.
function z_ext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_z_inj_plus.
function button_z_inj_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_inj_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_inj,'String'));
tune=tune+0.05;
set(handles.z_inj,'String',num2str(tune));

% --- Executes on button press in button_z_ext_plus.
function button_z_ext_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_ext_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_ext,'String'));
tune=tune+0.05;
set(handles.z_ext,'String',num2str(tune));


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_z_inj_moins.
function button_z_inj_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_inj_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_inj,'String'));
tune=tune-0.05;
set(handles.z_inj,'String',num2str(tune));

% --- Executes on button press in button_z_ext_moins.
function button_z_ext_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_ext_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_ext,'String'));
tune=tune-0.05;
set(handles.z_ext,'String',num2str(tune));

% --- Executes on button press in button_z_retour_moins.
function button_z_retour_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_retour_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_retour,'String'));
tune=tune-0.05;
set(handles.z_retour,'String',num2str(tune));

function z_retour_Callback(hObject, eventdata, handles)
% hObject    handle to z_retour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_retour as text
%        str2double(get(hObject,'String')) returns contents of z_retour as a double


% --- Executes during object creation, after setting all properties.
function z_retour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_retour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_z_plus.
function button_z_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_inj,'String'));
tune=tune+0.05;
set(handles.z_inj,'String',num2str(tune));
tune =str2double(get(handles.z_ext,'String'));
tune=tune+0.05;
set(handles.z_ext,'String',num2str(tune));
tune =str2double(get(handles.z_retour,'String'));
tune=tune+0.05;
set(handles.z_retour,'String',num2str(tune));

% --- Executes on button press in button_z_zero.
function button_z_zero_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tune=0;
set(handles.z_inj,'String',num2str(tune));
set(handles.z_ext,'String',num2str(tune));
set(handles.z_retour,'String',num2str(tune));

% --- Executes on button press in button_z_moins.
function button_z_moins_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_moins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_inj,'String'));
tune=tune-0.05;
set(handles.z_inj,'String',num2str(tune));
tune =str2double(get(handles.z_ext,'String'));
tune=tune-0.05;
set(handles.z_ext,'String',num2str(tune));
tune =str2double(get(handles.z_retour,'String'));
tune=tune-0.05;
set(handles.z_retour,'String',num2str(tune));

% --- Executes on button press in button_z_retour_plus.
function button_z_retour_plus_Callback(hObject, eventdata, handles)
% hObject    handle to button_z_retour_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tune =str2double(get(handles.z_retour,'String'));
tune=tune+0.05;
set(handles.z_retour,'String',num2str(tune));



% --- Executes on button press in button_apply.
function button_apply_Callback(hObject, eventdata, handles)
% hObject    handle to button_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xinj=str2double(get(handles.x_inj,'String')); 
xext=str2double(get(handles.x_ext,'String')) ;
xretour=str2double(get(handles.x_retour,'String')) ;
zinj=str2double(get(handles.z_inj,'String')); 
zext=str2double(get(handles.z_ext,'String')) ;
zretour=str2double(get(handles.z_retour,'String')) ;

tunex=[ xinj         xext       xretour];
tunez=[ zinj         zext       zretour];
%              x       z
dtune_inj = [tunex(1)   tunez(1)];         % dnu H  et dnu V  injection   110 MeV
dtune_ext = [tunex(2)   tunez(2)];         % dnu H  et dnu V  extraction 2750 MeV
dtune_dow = [tunex(3)   tunez(3)];         % dnu H  et dnu V  retour      110 MeV
dtune     = [dtune_inj dtune_ext dtune_dow];
%
M=handles.M;sol=inv(M)*dtune';

fprintf('  ************************** \n')
fprintf('   OFFSET  QF = %g  A \n',sol(1) )
fprintf('   OFFSET  QD = %g  A \n',sol(2) )
fprintf('   CURRENT QF = %g  A \n',sol(3) )
fprintf('   CURRENT QD = %g  A \n',sol(4) )
fprintf('   DELAY   QF = %g  µs \n',sol(5)*1e+06 )
fprintf('   DELAY   QD = %g  µs \n ',sol(6)*1e+06 )

button_load_setpoint_Callback(hObject, eventdata, handles);
boo=handles.boo;


if (sol(1)<50) & (sol(2)<50)
    
    boo.QFpoffset=boo.QFpoffset + sol(1);
    boo.QDpoffset=boo.QDpoffset + sol(2);
    boo.QFcurrent=boo.QFcurrent + sol(3);
    boo.QDcurrent=boo.QDcurrent + sol(4);
    
    boo.QFdelay  = boo.QFdelay  + sol(5)*1e+06;
    boo.QDdelay  = boo.QDdelay  + sol(6)*1e+06;
    handles.boo=boo;
    guidata(hObject, handles);
    
end

button_load_file_Callback(hObject, eventdata, handles);


ok=1;

if (ok==1)




% model pour affichage
Grf = 0.0465 +0.015;            % gradient remanent  T/m 
Grd = 0.0490 +0.0093;           % gradient remanent  T/m
af  = 0.0520 ;                  % G/I   T/m/A
ad  = 0.0517;
Br = 0.0020 ;                   % Champ remanent T
b  = 0.0013516 ;                % B/I  T/A
rho=12.3759 ;                   % rayon dipole
brhom = 9.17 ;  
deltaf=-0.00005 ;
deltad=-0.00005 ;

load 'current_ttf' time Df1 Df2 Dqf Dqd;
n=length(Df1);
dt=0.0001/6; %step temp 16 �s



%% model
Iqf0 = boo.QFcurrent;    Iqfc = boo.QFpoffset;          
Iqd0 = boo.QDcurrent;    Iqdc = boo.QDpoffset ;           
Id0  = boo.DIPcurrent;   Ibc  = boo.DIPoffset ; 
delf=deltaf + (boo.DIPdelay-boo.QFdelay)*1e-06 ; % 0.0002 -sol(5)         % avance si positif
deld=deltad + (boo.DIPdelay-boo.QDdelay)*1e-06 ; % 0.0001 -sol(6)


%courant en manipe 09-04-06
% Iqf0 =201.65 +sol(3);    Iqfc = -0.617 +sol(1);          
% Iqd0 =162.43 +sol(4);   Iqdc = -0.700  +sol(2) ;           
% Id0  =545;       Ibc  = -0.01 ; 
% delf=deltaf + 0.0002 -sol(5) ;             % avance si positif
% deld=deltad + 0.0001 -sol(6);




% calcul d�calage table pour d�lai
clear qf qd
k1=int16(delf/dt);
if (k1>0)
   qf=[Dqf(k1+1:n); Dqf(1:k1)];
else
   qf=[Dqf(n+k1:n); Dqf(1:n+k1-1)];
end
k1=int16(deld/dt);
if (k1>0)
   qd=[Dqd(k1+1:n); Dqd(1:k1)];
else
   qd=[Dqd(n+k1:n); Dqd(1:n+k1-1)];
end
Dqf1=qf;
Dqd1=qd;

clear Id Iqf Iqd
Id =Id0*(Df1+Df2)*(-28)/553.6 +Ibc;
Iqf=Iqf0*Dqf1*(-25)/201.3 + Iqfc;
Iqd=Iqd0*Dqd1*(-25)/151.04 + Iqdc;

clear pf pd p0 rf rd
pf=Grf + af*(Iqf);
pd=Grd + ad*(Iqd);
p0=Br +  b.*(Id);
rf=pf./(p0*rho);
rd=pd./(p0*rho);

table=(31 +  [0 10 20 30 100 148 200 270 280 293 ]);

ntable=int16(table*1e-03/dt);


global THERING
clear dnux dnuz tt
%switch2sim
QFI = findcells(THERING,'FamName','QPF');
QDI = findcells(THERING,'FamName','QPD');
i=0;
for k=1:length(table)
   n1=ntable(k);
   KQF=rf(n1);
   KQD=-rd(n1);
   THERING = setcellstruct(THERING,'K',QFI,KQF);
   THERING = setcellstruct(THERING,'K',QDI,KQD);
   THERING = setcellstruct(THERING,'PolynomB',QFI, KQF,2);
   THERING = setcellstruct(THERING,'PolynomB',QDI, KQD,2);
   [TD, tune] = twissring(THERING,0,1:(length(THERING)+1));
   dnux(k)=tune(1);dnuz(k)=tune(2);
end
n1=ntable(1);
n2=ntable(6);          %                 ntable(length(ntable));
fprintf('\n');
fprintf(' Tune à l injection        %g   %g: \n', dnux(1), dnuz(1))
fprintf(' Courant à l injection     %g   %g  %g: \n', (Id(n1)),(Iqf(n1)),(Iqd(n1)))
fprintf(' Courant à la redescente   %g   %g  %g: \n', (Id(n2)),(Iqf(n2)),(Iqd(n2)))
fprintf('\n');fprintf('\n');

axes(handles.axes1)
plot(table,dnux-6, '-or',table , dnuz-4,'-ob');
legend('X','Z')
xlim([0 340]); ylim([0.5 1]);
xlabel('Time (ms)'); ylabel('Tune');
grid on

end

function comment_Callback(hObject, eventdata, handles)
% hObject    handle to comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comment as text
%        str2double(get(hObject,'String')) returns contents of comment as a double


% --- Executes during object creation, after setting all properties.
function comment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

legend=get(handles.comment,'String');
Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
save_param(legend)
cd(pwdold);

% --- Executes on button press in button_load_file.
function button_load_file_Callback(hObject, eventdata, handles)
% hObject    handle to button_load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

boo=handles.boo;
boo
tout=0.5;
%Alim
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
%timing
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay',boo.DIPdelay);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay',boo.QFdelay);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay',boo.QDdelay);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sfTimeDelay',boo.DIPdelay);pause(tout);
    tango_write_attribute2('BOO/SY/LOCAL.ALIM.1', 'sdTimeDelay',boo.DIPdelay);pause(tout);


% --- Executes on button press in button_openfile.
function button_openfile_Callback(hObject, eventdata, handles)
% hObject    handle to button_openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Directory = '/home/matlabML/measdata/Boosterdata/Datatemp';
pwdold = pwd;
cd(Directory);
[FileName,PathName] = uigetfile('*.mat','Select the setpoint file');
load(FileName, 'boo');
handles.boo=boo;
set(handles.comment,'String',boo.comment);
guidata(hObject, handles);
cd(pwdold);

% --- Executes on button press in button_load_setpoint.
function button_load_setpoint_Callback(hObject, eventdata, handles)
% hObject    handle to button_load_setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% alim
    boo.DIPcurrent=readattribute('BOO/AE/D.1/current'        ,'Setpoint');
    boo.DIPoffset =readattribute('BOO/AE/D.1/waveformOffset' ,'Setpoint');
    boo.QFcurrent=readattribute('BOO/AE/QF/current'          ,'Setpoint');
    boo.QFpoffset =readattribute('BOO/AE/QF/waveformOffset'  ,'Setpoint');
    boo.QDcurrent=readattribute('BOO/AE/QD/current'          ,'Setpoint');
    boo.QDpoffset =readattribute('BOO/AE/QD/waveformOffset'  ,'Setpoint');
    boo.SFcurrent=readattribute('BOO/AE/SF/current'          ,'Setpoint');
    boo.SFpoffset =readattribute('BOO/AE/SF/waveformOffset'  ,'Setpoint');
    boo.SDcurrent=readattribute('BOO/AE/SD/current'          ,'Setpoint');
    boo.SDpoffset =readattribute('BOO/AE/SD/waveformOffset'  ,'Setpoint');
% synchro
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'dpTimeDelay');
    boo.DIPdelay=temp.value(1);
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qfTimeDelay');
    boo.QFdelay=temp.value(1);
    temp=tango_read_attribute2('BOO/SY/LOCAL.ALIM.1', 'qdTimeDelay');
    boo.QDdelay=temp.value(1);
    
handles.boo=boo;
boo
guidata(hObject, handles);
