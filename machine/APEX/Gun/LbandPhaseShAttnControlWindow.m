function varargout = LbandPhaseShAttnControlWindow(varargin)
% LBANDPHASESHATTNCONTROLWINDOW MATLAB code for LbandPhaseShAttnControlWindow.fig
%      LBANDPHASESHATTNCONTROLWINDOW, by itself, creates a new LBANDPHASESHATTNCONTROLWINDOW or raises the existing
%      singleton*.
%
%      H = LBANDPHASESHATTNCONTROLWINDOW returns the handle to a new LBANDPHASESHATTNCONTROLWINDOW or the handle to
%      the existing singleton*.
%
%      LBANDPHASESHATTNCONTROLWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LBANDPHASESHATTNCONTROLWINDOW.M with the given input arguments.
%
%      LBANDPHASESHATTNCONTROLWINDOW('Property','Value',...) creates a new LBANDPHASESHATTNCONTROLWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LbandPhaseShAttnControlWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LbandPhaseShAttnControlWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LbandPhaseShAttnControlWindow

% Last Modified by GUIDE v2.5 18-Sep-2015 15:36:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LbandPhaseShAttnControlWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @LbandPhaseShAttnControlWindow_OutputFcn, ...
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


% --- Executes just before LbandPhaseShAttnControlWindow is made visible.
function LbandPhaseShAttnControlWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LbandPhaseShAttnControlWindow (see VARARGIN)

% Choose default command line output for LbandPhaseShAttnControlWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% Check if the AO exists (this is required for stand-alone applications)
checkforao;


initialize_gui(hObject, handles, false);


% UIWAIT makes LbandPhaseShAttnControlWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LbandPhaseShAttnControlWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set Attenuators

IFlag=str2double(get(handles.InitFlag, 'String'));
IFlag
if IFlag==1
    L1Att0=0;
    L2Att0=0;
    L3Att0=0;
    TCavAtt0=0;
else
    L1Att0=str2double(get(handles.L1Att0, 'String'));
    L2Att0=str2double(get(handles.L2Att0, 'String'));
    L3Att0=str2double(get(handles.L3Att0, 'String'));
    TCavAtt0=str2double(get(handles.TCavAtt0, 'String'));
end

Flag1=get(handles.NoPowerL1,'Value');
if Flag1==0
    L1AttSet = str2double(get(handles.L1Att, 'String'));
    L1Flag=0;
    if (L1AttSet ~= L1Att0)
        L1Flag=1;
    end
    if (L1Flag==1) || (IFlag==1)
        LbandHP_Attenuators_SetAttnWithPhaseConstant(1,L1AttSet);
        L1AttMotorVal=getpv('HPRF:MOT:linac1att.VAL');
        [Trash,L1AttPhDegVal]=LbandHP_Attenuators_Attenuation(1,L1AttMotorVal);
        set(handles.L1Att_Ph, 'String', L1AttPhDegVal);
        
        set(handles.L1Att0,'String', L1AttSet);
    end
        L1AttMotorRBV=getpv('HPRF:MOT:linac1att.RBV');
        [L1AttdBRBV,Trash]=LbandHP_Attenuators_Attenuation(1,L1AttMotorRBV);
        set(handles.L1AttRBV, 'String', L1AttdBRBV);
else
    ColorHlp=getpv('HPRF:MOT:linac1att.RBV');
    if ColorHlp<3050
        set(handles.NoPowerL1,'BackgroundColor','red');
    end
end
        


Flag2=get(handles.NoPowerL2,'Value');
if Flag2==0
    L2AttSet = str2double(get(handles.L2Att, 'String'));
    L2Flag=0;
    if (L2AttSet ~= L2Att0)
        L2Flag=1;
    end
    if (L2Flag==1) || (IFlag==1)
        LbandHP_Attenuators_SetAttnWithPhaseConstant(2,L2AttSet);
        L2AttMotorVal=getpv('HPRF:MOT:linac2att.VAL');
        [Trash,L2AttPhDegVal]=LbandHP_Attenuators_Attenuation(2,L2AttMotorVal);
        set(handles.L2Att_Ph, 'String', L2AttPhDegVal);
        
        set(handles.L2Att0,'String', L2AttSet);
    end
        L2AttMotorRBV=getpv('HPRF:MOT:linac2att.RBV');
        [L2AttdBRBV,Trash]=LbandHP_Attenuators_Attenuation(2,L2AttMotorRBV);
        set(handles.L2AttRBV, 'String', L2AttdBRBV);
else
    ColorHlp=getpv('HPRF:MOT:linac2att.RBV');
    if ColorHlp<3050
        set(handles.NoPowerL2,'BackgroundColor','red');
    end
end

Flag3=get(handles.NoPowerL3,'Value');
if Flag3==0
    L3AttSet = str2double(get(handles.L3Att, 'String'));
    L3Flag=0;
    if (L3AttSet ~= L3Att0)
        L3Flag=1;
    end
    if (L3Flag==1) || (IFlag==1)
        LbandHP_Attenuators_SetAttnWithPhaseConstant(3,L3AttSet);
        L3AttMotorVal=getpv('HPRF:MOT:linac3att.VAL');
        [Trash,L3AttPhDegVal]=LbandHP_Attenuators_Attenuation(3,L3AttMotorVal);
        set(handles.L3Att_Ph, 'String', L3AttPhDegVal);
        
        set(handles.L3Att0,'String', L3AttSet);
    end
        L3AttMotorRBV=getpv('HPRF:MOT:linac3att.RBV');
        [L3AttdBRBV,Trash]=LbandHP_Attenuators_Attenuation(3,L3AttMotorRBV);
        set(handles.L3AttRBV, 'String', L3AttdBRBV);
else
    ColorHlp=getpv('HPRF:MOT:linac3att.RBV');
    if ColorHlp<3050
        set(handles.NoPowerL3,'BackgroundColor','red');
    end
end

FlagTCav=get(handles.NoPowerTCav,'Value');
if FlagTCav==0
    TCavAttSet = str2double(get(handles.TCavAtt, 'String'));
    TCavFlag=0;
    if (TCavAttSet ~= TCavAtt0)
        TCavFlag=1;
    end
    if (TCavFlag==1) || (IFlag==1)
        LbandHP_Attenuators_SetAttnWithPhaseConstant(0,TCavAttSet);
        TCavAttMotorVal=getpv('HPRF:MOT:deflectorAtt.VAL');
        [Trash,TCavAttPhDegVal]=LbandHP_Attenuators_Attenuation(0,TCavAttMotorVal);
        set(handles.TCavAtt_Ph, 'String', TCavAttPhDegVal);
        
        set(handles.TCavAtt0,'String', TCavAttSet);
    end
        TCavAttMotorRBV=getpv('HPRF:MOT:deflectorAtt.RBV');
        [TCavAttdBRBV,Trash]=LbandHP_Attenuators_Attenuation(0,TCavAttMotorRBV);
        set(handles.TCavAttRBV, 'String', TCavAttdBRBV);
else
    ColorHlp=getpv('HPRF:MOT:deflectorAtt.RBV');
    if ColorHlp<3050
        set(handles.NoPowerTCav,'BackgroundColor','red');
    end
end

% Set Phase Shifters
if L1Flag==1
    L1PhMot0=getpv('HPRF:MOT:linac1phase.VAL');
    L1PhSet0=LbandHP_PhaseShifters_Phase(L1PhMot0);
    set(handles.L1PhCtrl, 'String', L1PhSet0);
end
L1PhSet = str2double(get(handles.L1PhCtrl, 'String'));
L1PhMotVal=LbandHP_PhaseShifters_Motor(L1PhSet);
setpvonline('HPRF:MOT:linac1phase.VAL',L1PhMotVal,'float',1);
L1PhMotorRBV=getpv('HPRF:MOT:linac1phase.RBV');
L1PhDegRBV=LbandHP_PhaseShifters_Phase(L1PhMotorRBV);
set(handles.L1PhRBV, 'String', L1PhDegRBV);

if L2Flag==1
    L2PhMot0=getpv('HPRF:MOT:linac2phase.VAL');
    L2PhSet0=LbandHP_PhaseShifters_Phase(L2PhMot0);
    set(handles.L2PhCtrl, 'String', L2PhSet0);
end
L2PhSet = str2double(get(handles.L2PhCtrl, 'String'));
L2PhMotVal=LbandHP_PhaseShifters_Motor(L2PhSet);
setpvonline('HPRF:MOT:linac2phase.VAL',L2PhMotVal,'float',1);
L2PhMotorRBV=getpv('HPRF:MOT:linac2phase.RBV');
L2PhDegRBV=LbandHP_PhaseShifters_Phase(L2PhMotorRBV);
set(handles.L2PhRBV, 'String', L2PhDegRBV);

if L3Flag==1
    L3PhMot0=getpv('HPRF:MOT:linac3phase.VAL');
    L3PhSet0=LbandHP_PhaseShifters_Phase(L3PhMot0);
    set(handles.L3PhCtrl, 'String', L3PhSet0);
end
L3PhSet = str2double(get(handles.L3PhCtrl, 'String'));
L3PhMotVal=LbandHP_PhaseShifters_Motor(L3PhSet);
setpvonline('HPRF:MOT:linac3phase.VAL',L3PhMotVal,'float',1);
L3PhMotorRBV=getpv('HPRF:MOT:linac3phase.RBV');
L3PhDegRBV=LbandHP_PhaseShifters_Phase(L3PhMotorRBV);
set(handles.L3PhRBV, 'String', L3PhDegRBV);

if TCavFlag==1
    TCavPhMot0=getpv('HPRF:MOT:deflectorPhase.VAL');
    TCavPhSet0=LbandHP_PhaseShifters_Phase(TCavPhMot0);
    set(handles.TCavPhCtrl, 'String', TCavPhSet0);
end
TCavPhSet = str2double(get(handles.TCavPhCtrl, 'String'));
TCavPhMotVal=LbandHP_PhaseShifters_Motor(TCavPhSet);
setpvonline('HPRF:MOT:deflectorPhase.VAL',TCavPhMotVal,'float',1);
TCavPhMotorRBV=getpv('HPRF:MOT:deflectorPhase.RBV');
TCavPhDegRBV=LbandHP_PhaseShifters_Phase(TCavPhMotorRBV);
set(handles.TCavPhRBV, 'String', TCavPhDegRBV);


set(handles.InitFlag, 'String', 0);


function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.


% Initialize Phase Shifters
L1PhMotorVal=getpv('HPRF:MOT:linac1phase.VAL');
L1PhDegVal=LbandHP_PhaseShifters_Phase(L1PhMotorVal);
set(handles.L1PhCtrl, 'String', L1PhDegVal);
L1PhMotorRBV=getpv('HPRF:MOT:linac1phase.RBV');
L1PhDegRBV=LbandHP_PhaseShifters_Phase(L1PhMotorRBV);
set(handles.L1PhRBV, 'String', L1PhDegRBV);

L2PhMotorVal=getpv('HPRF:MOT:linac2phase.VAL');
L2PhDegVal=LbandHP_PhaseShifters_Phase(L2PhMotorVal);
set(handles.L2PhCtrl, 'String', L2PhDegVal);
L2PhMotorRBV=getpv('HPRF:MOT:linac2phase.RBV');
L2PhDegRBV=LbandHP_PhaseShifters_Phase(L2PhMotorRBV);
set(handles.L2PhRBV, 'String', L2PhDegRBV);

L3PhMotorVal=getpv('HPRF:MOT:linac3phase.VAL');
L3PhDegVal=LbandHP_PhaseShifters_Phase(L3PhMotorVal);
set(handles.L3PhCtrl, 'String', L3PhDegVal);
L3PhMotorRBV=getpv('HPRF:MOT:linac3phase.RBV');
L3PhDegRBV=LbandHP_PhaseShifters_Phase(L3PhMotorRBV);
set(handles.L3PhRBV, 'String', L3PhDegRBV);

TCavPhMotorVal=getpv('HPRF:MOT:deflectorPhase.VAL');
TCavPhDegVal=LbandHP_PhaseShifters_Phase(TCavPhMotorVal);
set(handles.TCavPhCtrl, 'String', TCavPhDegVal);
TCavPhMotorRBV=getpv('HPRF:MOT:deflectorPhase.RBV');
TCavPhDegRBV=LbandHP_PhaseShifters_Phase(TCavPhMotorRBV);
set(handles.TCavPhRBV, 'String', TCavPhDegRBV);

% Initialize Attenuators
L1AttMotorVal=getpv('HPRF:MOT:linac1att.VAL');
[L1AttdBVal,Trash]=LbandHP_Attenuators_Attenuation(1,L1AttMotorVal);
set(handles.L1Att, 'String', L1AttdBVal);
L1AttMotorRBV=getpv('HPRF:MOT:linac1att.RBV');
[L1AttdBRBV,L1AttPhDegVal]=LbandHP_Attenuators_Attenuation(1,L1AttMotorRBV);
set(handles.L1Att_Ph, 'String', L1AttPhDegVal);
set(handles.L1AttRBV, 'String', L1AttdBRBV);

L2AttMotorVal=getpv('HPRF:MOT:linac2att.VAL');
[L2AttdBVal,Trash]=LbandHP_Attenuators_Attenuation(2,L2AttMotorVal);
set(handles.L2Att, 'String', L2AttdBVal);
L2AttMotorRBV=getpv('HPRF:MOT:linac2att.RBV');
[L2AttdBRBV,L2AttPhDegVal]=LbandHP_Attenuators_Attenuation(2,L2AttMotorRBV);
set(handles.L2Att_Ph, 'String', L2AttPhDegVal);
set(handles.L2AttRBV, 'String', L2AttdBRBV);

L3AttMotorVal=getpv('HPRF:MOT:linac3att.VAL');
[L3AttdBVal,Trash]=LbandHP_Attenuators_Attenuation(3,L3AttMotorVal);
set(handles.L3Att, 'String', L3AttdBVal);
L3AttMotorRBV=getpv('HPRF:MOT:linac3att.RBV');
[L3AttdBRBV,L3AttPhDegVal]=LbandHP_Attenuators_Attenuation(3,L3AttMotorRBV);
set(handles.L3Att_Ph, 'String', L3AttPhDegVal);
set(handles.L3AttRBV, 'String', L3AttdBRBV);

TCavAttMotorVal=getpv('HPRF:MOT:deflectorAtt.VAL');
[TCavAttdBVal,Trash]=LbandHP_Attenuators_Attenuation(0,TCavAttMotorVal);
set(handles.TCavAtt, 'String', TCavAttdBVal);
TCavAttMotorRBV=getpv('HPRF:MOT:deflectorAtt.RBV');
[TCavAttdBRBV,TCavAttPhDegVal]=LbandHP_Attenuators_Attenuation(0,TCavAttMotorRBV);
set(handles.TCavAtt_Ph, 'String', TCavAttPhDegVal);
set(handles.TCavAttRBV, 'String', TCavAttdBRBV);

set(handles.InitFlag, 'String', 1);

set(handles.NoPowerL1,'BackgroundColor','green');
set(handles.NoPowerL2,'BackgroundColor','green');
set(handles.NoPowerL3,'BackgroundColor','green');
set(handles.NoPowerTCav,'BackgroundColor','green');

% Update handles structure
guidata(handles.figure1, handles);



function L1PhCtrl_Callback(hObject, eventdata, handles)
% hObject    handle to L1PhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L1PhCtrl as text
%        str2double(get(hObject,'String')) returns contents of L1PhCtrl as a double


% --- Executes during object creation, after setting all properties.
function L1PhCtrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L1PhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L2PhCtrl_Callback(hObject, eventdata, handles)
% hObject    handle to L2PhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L2PhCtrl as text
%        str2double(get(hObject,'String')) returns contents of L2PhCtrl as a double


% --- Executes during object creation, after setting all properties.
function L2PhCtrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L2PhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L3PhCtrl_Callback(hObject, eventdata, handles)
% hObject    handle to L3PhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L3PhCtrl as text
%        str2double(get(hObject,'String')) returns contents of L3PhCtrl as a double


% --- Executes during object creation, after setting all properties.
function L3PhCtrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L3PhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TCavPhCtrl_Callback(hObject, eventdata, handles)
% hObject    handle to TCavPhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TCavPhCtrl as text
%        str2double(get(hObject,'String')) returns contents of TCavPhCtrl as a double


% --- Executes during object creation, after setting all properties.
function TCavPhCtrl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TCavPhCtrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L1Att_Callback(hObject, eventdata, handles)
% hObject    handle to L1Att (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L1Att as text
%        str2double(get(hObject,'String')) returns contents of L1Att as a double


% --- Executes during object creation, after setting all properties.
function L1Att_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L1Att (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L1Att_Ph_Callback(hObject, eventdata, handles)
% hObject    handle to L1Att_Ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L1Att_Ph as text
%        str2double(get(hObject,'String')) returns contents of L1Att_Ph as a double


% --- Executes during object creation, after setting all properties.
function L1Att_Ph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L1Att_Ph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L2Att_Callback(hObject, eventdata, handles)
% hObject    handle to L2Att (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L2Att as text
%        str2double(get(hObject,'String')) returns contents of L2Att as a double


% --- Executes during object creation, after setting all properties.
function L2Att_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L2Att (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L3Att_Callback(hObject, eventdata, handles)
% hObject    handle to L3Att (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L3Att as text
%        str2double(get(hObject,'String')) returns contents of L3Att as a double


% --- Executes during object creation, after setting all properties.
function L3Att_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L3Att (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TCavAtt_Callback(hObject, eventdata, handles)
% hObject    handle to TCavAtt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TCavAtt as text
%        str2double(get(hObject,'String')) returns contents of TCavAtt as a double


% --- Executes during object creation, after setting all properties.
function TCavAtt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TCavAtt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NoPowerL1.
function NoPowerL1_Callback(hObject, eventdata, handles)
% hObject    handle to NoPowerL1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Flag1=get(hObject,'Value');
if Flag1~=0
    setpvonline('HPRF:MOT:linac1att.VAL',3000,'float',1);
    set(hObject,'BackgroundColor','blue')
else
    set(hObject,'BackgroundColor','green')
    L1Hlp=str2double(get(handles.L1Att,'String'));
    L1AttHlp=LbandHP_Attenuators_Motor(1,L1Hlp);
    setpvonline('HPRF:MOT:linac1att.VAL',L1AttHlp,'float',1);
end

% Hint: get(hObject,'Value') returns toggle state of NoPowerL1


% --- Executes on button press in NoPowerL2.
function NoPowerL2_Callback(hObject, eventdata, handles)
% hObject    handle to NoPowerL2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Flag2=get(hObject,'Value');
if Flag2~=0
    setpvonline('HPRF:MOT:linac2att.VAL',3000,'float',1);
    set(hObject,'BackgroundColor','blue')
else
    set(hObject,'BackgroundColor','green')
    L2Hlp=str2double(get(handles.L2Att,'String'));
    L2AttHlp=LbandHP_Attenuators_Motor(2,L2Hlp);
    setpvonline('HPRF:MOT:linac2att.VAL',L2AttHlp,'float',1);
end

% Hint: get(hObject,'Value') returns toggle state of NoPowerL2


% --- Executes on button press in NoPowerL3.
function NoPowerL3_Callback(hObject, eventdata, handles)
% hObject    handle to NoPowerL3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Flag3=get(hObject,'Value');
if Flag3~=0
    setpvonline('HPRF:MOT:linac3att.VAL',3000,'float',1);
    set(hObject,'BackgroundColor','blue')
else
    set(hObject,'BackgroundColor','green')
    L3Hlp=str2double(get(handles.L3Att,'String'));
    L3AttHlp=LbandHP_Attenuators_Motor(3,L3Hlp);
    setpvonline('HPRF:MOT:linac3att.VAL',L3AttHlp,'float',1);
end

% Hint: get(hObject,'Value') returns toggle state of NoPowerL3


% --- Executes on button press in NoPowerTCav.
function NoPowerTCav_Callback(hObject, eventdata, handles)
% hObject    handle to NoPowerTCav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FlagTCav=get(hObject,'Value');
if FlagTCav~=0
    setpvonline('HPRF:MOT:deflectorAtt.VAL',3000,'float',1);
    set(hObject,'BackgroundColor','blue')
else
    set(hObject,'BackgroundColor','green')
    TCavHlp=str2double(get(handles.TCavAtt,'String'));
    TCavAttHlp=LbandHP_Attenuators_Motor(0,TCavHlp);
    setpvonline('HPRF:MOT:deflectorAtt.VAL',TCavAttHlp,'float',1);
end

% Hint: get(hObject,'Value') returns toggle state of NoPowerTCav


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
saveLbandHPAttnPhShft
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
set(handles.pushbutton1,'BackgroundColor','red')
set(handles.pushbutton1,'String','WAIT!!!')
loadLbandHPAttnPhShft
set(handles.pushbutton1,'BackgroundColor','green')
set(handles.pushbutton1,'String','UPDATE')

Att1hlp=getpv('HPRF:MOT:linac1att.VAL');
Att1ValHlp=LbandHP_Attenuators_Attenuation(1,Att1hlp);
set(handles.L1Att,'String',Att1ValHlp);
Ph1hlp=getpv('HPRF:MOT:linac1phase.VAL');
Ph1ValHlp=LbandHP_PhaseShifters_Phase(Ph1hlp);
set(handles.L1PhCtrl,'String',Ph1ValHlp);

Att2hlp=getpv('HPRF:MOT:linac2att.VAL');
Att2ValHlp=LbandHP_Attenuators_Attenuation(2,Att2hlp);
set(handles.L2Att,'String',Att2ValHlp);
Ph2hlp=getpv('HPRF:MOT:linac2phase.VAL');
Ph2ValHlp=LbandHP_PhaseShifters_Phase(Ph2hlp);
set(handles.L2PhCtrl,'String',Ph2ValHlp);

Att3hlp=getpv('HPRF:MOT:linac3att.VAL');
Att3ValHlp=LbandHP_Attenuators_Attenuation(3,Att3hlp);
set(handles.L3Att,'String',Att3ValHlp);
Ph3hlp=getpv('HPRF:MOT:linac3phase.VAL');
Ph3ValHlp=LbandHP_PhaseShifters_Phase(Ph3hlp);
set(handles.L3PhCtrl,'String',Ph3ValHlp);

AttTCavhlp=getpv('HPRF:MOT:deflectorAtt.VAL');
AttTCavValHlp=LbandHP_Attenuators_Attenuation(0,AttTCavhlp);
set(handles.TCavAtt,'String',AttTCavValHlp);
PhTCavhlp=getpv('HPRF:MOT:deflectorPhase.VAL');
PhTCavValHlp=LbandHP_PhaseShifters_Phase(PhTCavhlp);
set(handles.TCavPhCtrl,'String',PhTCavValHlp);

% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
