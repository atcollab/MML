function varargout = optics_LT1_LT2(varargin)
%OPTICS_LT1_LT2 - M-file for optics_LT1_LT2.fig
%      OPTICS_LT1_LT2, by itself, creates a new OPTICS_LT1_LT2 or raises the existing
%      singleton*.
%
%      H = OPTICS_LT1_LT2 returns the handle to a new OPTICS_LT1_LT2 or the handle to
%      the existing singleton*.
%
%      OPTICS_LT1_LT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTICS_LT1_LT2.M with the given input arguments.
%
%      OPTICS_LT1_LT2('Property','Value',...) creates a new OPTICS_LT1_LT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optics_LT1_LT2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optics_LT1_LT2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optics_LT1_LT2

% Last Modified by GUIDE v2.5 09-Mar-2005 10:49:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optics_LT1_LT2_OpeningFcn, ...
                   'gui_OutputFcn',  @optics_LT1_LT2_OutputFcn, ...
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

% --- Executes just before optics_LT1_LT2 is made visible.
function optics_LT1_LT2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optics_LT1_LT2 (see VARARGIN)

% Choose default command line output for optics_LT1_LT2
handles.output = hObject;

%mat: utilite ???
setappdata(handles.figure1, 'twissdatain',struct([]));

% construct initial twiss parameters

Machine = getfamilydata('SubMachine');

switch Machine
    case {'LT1'}

        twissdatain.ElemIndex  = 1;
        twissdatain.SPos       = 0;
        twissdatain.ClosedOrbit= [1e-3 0 2e-3 0]'*0;
        twissdatain.M44        = eye(4);
        twissdatain.beta       = [8.1 8.1];
        twissdatain.alpha      = [0 0];
        twissdatain.mu         = [0 0];
        twissdatain.Dispersion = [0 0 0 0]';
        set(handles.figure1,'Name', 'LT1 Optical functions');
        
    case {'LT2'}
        
        twissdatain.ElemIndex  = 1;
        twissdatain.SPos       = 0;
        twissdatain.ClosedOrbit= [1e-3 0 2e-3 0]'*0;
        twissdatain.M44        = eye(4);
        twissdatain.beta       = [6.0 6.0];
        twissdatain.alpha      = [-1.8 1.5];
        twissdatain.mu         = [0 0];
        twissdatain.Dispersion = [0 0 0 0]';
        set(handles.figure1,'Name', 'LT2 Optical functions');

    otherwise
        error('No Machine loaded')        
end

setappdata(handles.figure1, 'twissdatain0',twissdatain);
handles.restart = 1;

%% Initialize structure for handling LT1 and LT2 magnets
handles = init_handles(handles);

% Update handles structure
guidata(hObject, handles);

AO = getao;
% setappdata(handles.figure1,'AOmagnet', AO);

%set(handles.(name),'Max',9, 'Min', -9)

% min et max des sliders (figé à l'ouverture puis modifiable par SETBAR)
val_max = getmaxsp('QP');
val_min = getminsp('QP');

%% Number of sliders    
handles.sliderNumber = 7;

for k = 1:handles.sliderNumber,
    name = strcat('sliderQP',num2str(k))
    set(handles.(name),'Max',val_max(k),'Min',val_min(k));
end


%% liste de aimants a controler (menu deroulant)
list = [AO.QP.CommonNames;...
        AO.CH.CommonNames; ...
        AO.CV.CommonNames
        ];

%% Automatic configuration for sliders
for k = 1:handles.sliderNumber
    name = ['popupmenu_bar' num2str(k)];
    set(handles.(name),'String',list);
    set(handles.(name),'Value',k);
end

%% graphe par defaut
axes(handles.axes1);
handles.xtype = 'spos';
handles.ytype = 'beta';

%% initialisation AT et IHM
handles = restart(handles);

%% Read Tango values
%read_tango(handles);

% UIWAIT makes optics_LT1_LT2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(0,'DefaultAxesXgrid','on','DefaultAxesYgrid','on');

%% graphe symboles
axes(handles.axes2);
drawlattice(0,0.8);
set(handles.axes2,'Xlim',[handles.spos(1) handles.spos(end)], ...
    'XTick',[],'YTick',[]);


% Update handles structure
guidata(hObject, handles);

%% -------------------------------------
function handles = computeTwiss(handles)
% update ATmodel
% compute new twiss parameters
% 
global THERING;

%%% parameters at the entrance of the line
% twissdatain.ElemIndex=1;
% twissdatain.SPos=0;
% twissdatain.ClosedOrbit=[1e-3 0 2e-3 0]'*0;
% twissdatain.M44=eye(4);
% 
% if isequal(isfield(twissdatain,'beta'),0)
 
 if handles.restart == 1
     twissdatain = getappdata(handles.figure1,'twissdatain0');
     handles.restart = 0;
 else
     twissdatain = getappdata(handles.figure1,'twissdatain');
 end
%     twissdatain.beta= [8.1 8.1];
%     twissdatain.alpha= [0 0];
% else
%     twissdatain = getappdata(handles.figure1,'twissdatain')
% end

% twissdatain.mu= [0 0];
% twissdatain.Dispersion= [0 0 0 0]';

%%% get twiss paramaters
TD = twissline(THERING,0.0,twissdatain,1:length(THERING),'chroma');

handles.twissdatain = twissdatain;
handles.beta  = cat(1,TD.beta);
handles.cod   = cat(2,TD.ClosedOrbit)';
handles.eta   = cat(2,TD.Dispersion)';
handles.spos  = cat(1,TD.SPos);
handles.phase = cat(1,TD.mu);

setappdata(handles.figure1,'twissdatain',twissdatain);

% --- Outputs from this function are returned to the command line.
function varargout = optics_LT1_LT2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function sliderQP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderQP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function sliderQP1_Callback(hObject, eventdata, handles)
% hObject    handle to sliderQP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles = setslider(hObject,handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editQP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','green');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function editQP1_Callback(hObject, eventdata, handles)
% hObject    handle to editQP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQP1 as text
%        str2double(get(hObject,'String')) returns contents of editQP1 as a double
handles = setedit(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderQP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderQP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function sliderQP2_Callback(hObject, eventdata, handles)
% hObject    handle to sliderQP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = setslider(hObject,handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editQP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function editQP2_Callback(hObject, eventdata, handles)
% hObject    handle to editQP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQP2 as text
%        str2double(get(hObject,'String')) returns contents of editQP2 as a double
handles = setedit(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderQP3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderQP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function sliderQP3_Callback(hObject, eventdata, handles)
% hObject    handle to sliderQP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = setslider(hObject,handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editQP3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function editQP3_Callback(hObject, eventdata, handles)
% hObject    handle to editQP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQP3 as text
%        str2double(get(hObject,'String')) returns contents of editQP3 as a double
handles = setedit(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editQP4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQP4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function editQP4_Callback(hObject, eventdata, handles)
% hObject    handle to editQP4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQP4 as text
%        str2double(get(hObject,'String')) returns contents of editQP4 as a double
handles = setedit(handles);


% --- Executes during object creation, after setting all properties.
function sliderQP4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderQP4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sliderQP4_Callback(hObject, eventdata, handles)
% hObject    handle to sliderQP4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = setslider(hObject,handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editQP5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQP5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function editQP5_Callback(hObject, eventdata, handles)
% hObject    handle to editQP5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQP5 as text
%        str2double(get(hObject,'String')) returns contents of editQP5 as a double
handles = setedit(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderQP5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderQP5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function sliderQP5_Callback(hObject, eventdata, handles)
% hObject    handle to sliderQP5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = setslider(hObject,handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderQP6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderQP6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function sliderQP6_Callback(hObject, eventdata, handles)
% hObject    handle to sliderQP6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = setslider(hObject,handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editQP6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQP6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function editQP6_Callback(hObject, eventdata, handles)
% hObject    handle to editQP6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQP6 as text
%        str2double(get(hObject,'String')) returns contents of editQP6 as a double
handles = setedit(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editQP7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editQP7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function editQP7_Callback(hObject, eventdata, handles)
% hObject    handle to editQP7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editQP7 as text
%        str2double(get(hObject,'String')) returns contents of editQP7 as a double
handles = setedit(handles);


% --- Executes during object creation, after setting all properties.
function sliderQP7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderQP7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on slider movement.
function sliderQP7_Callback(hObject, eventdata, handles)
% hObject    handle to sliderQP7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles = setslider(hObject,handles);
guidata(hObject, handles);

%-----------------------------------------------------------------------
function plot_axes(handles,quoi)
%%% fonction generique

axes(handles.axes1); cla; hold on;

switch handles.xtype
    case 'spos'
        x=handles.(handles.xtype);
    case 'phase'
        x=handles.(handles.xtype); x = x(:,1);
end

switch quoi
    case 'beta'
        plot(x,handles.beta(:,1),'r.-'); 
        plot(x,handles.beta(:,2),'b.-'); 
        ylabel('\beta (m)');
        %mat
   %ylim([0 130]);
        
    case 'eta'        
        plot(x,handles.eta(:,1),'r.-');
        plot(x,handles.eta(:,3),'b.-');
        ylabel('\eta (m)');
    case 'cod'        
        plot(x,handles.cod(:,1)*1e3,'r.-');
        plot(x,handles.cod(:,3)*1e3,'b.-');
        ylabel('cod (mm)');
    case 'phase'        
        plot(x,handles.phase(:,1),'r.-');
        plot(x,handles.phase(:,2),'b.-');
        ylabel('phase ');
end
axis([x(1) x(end) -inf inf]);
datalabel on

%--------------------------------------------------------------------------
function handles = setslider(hObject, handles)
%%% fonction generique pour un slider de type aimant

AOmagnet = getappdata(handles.figure1,'AOmagnet'); %% get LT1 structure
%% extrait le numero
tagstring = get(hObject,'Tag');
num = tagstring(regexp(tagstring,'\d'));
magnet0 = ['QP' num2str(num)];
val =  get(hObject,'Value');
str = num2str(val);
set(handles.(['edit' magnet0]),'string',str);

%% Cherche le nom de l'aimant
h = handles.(['popupmenu_bar' num]);
contents = get(h,'String');
magnet = contents{get(h,'Value')};
handles = setATmagnet(handles,magnet,val);

AOmagnet.(magnet(1:2)).ModelVal(str2double(magnet(end))) = val;

% save data
setappdata(handles.figure1,'AOmagnet',AOmagnet)

%--------------------------------------------------------------------------
function handles = setATmagnet(handles,magnet,val)
% function handles = setATmagnet(handles,magnet,val)
% set  val as new setvalue of element 'magnet' 
% Replot current graph

AOmagnet= getappdata(handles.figure1,'AOmagnet'); % get magnet AO

% set value to AT model
setsp(common2family(magnet), val, common2dev(magnet),'Model');

% Recompute twiss parameters
handles = computeTwiss(handles);
% Replot everything
plot_axes(handles,handles.ytype);
%mat
%ylim([0 130]);

%--------------------------------------------------------------------------
function handles = setedit(handles)
% function setedit(handles)
% generic callback for an edit box

AOmagnet= getappdata(handles.figure1,'AOmagnet'); % get magnet AO

%% construction automatique du nom du slider
val = str2double(get(gcbo,'String'));
tagstring = get(gcbo,'Tag');
num = tagstring(regexp(tagstring,'\d'));
magnet0=['QP' num2str(num)];
name = handles.(['slider' magnet0]);
%% Cherche le nom de l'aimant
h = handles.(['popupmenu_bar' num]);
contents = get(h,'String');
magnet = contents{get(h,'Value')};

%%% Test si dans les limites
if val<get(name,'Max') && val> get(name,'Min')
  set(name,'Value',val);
  handles = setATmagnet(handles,magnet,val);
  AOmagnet.(magnet(1:2)).ModelVal(str2double(magnet(end))) = val;
else % message d'erreur
  warndlg('Wrong value for K','Edit Box','Modal')
  set(hObject,'String',num2str(get(name,'Value')));
end

% Save data
setappdata(handles.figure1,'AOmagnet',AOmagnet); 

%---------------------------------
function mutual_exclude(off)
% function mutual_exclude(off)
% fonction pour faire des radioboutons
set(off,'Value',0);

% --- Executes during object creation, after setting all properties.
function popupmenu_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_y.
function popupmenu_y_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_y contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_y
contents = get(hObject,'String');
plot_axes(handles, contents{get(hObject,'Value')});
%mat
     %ylim([0 130]);
handles.ytype = contents{get(hObject,'Value')};       
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu_x.
function popupmenu_x_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_x contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_x
contents = get(hObject,'String');        
handles.xtype = contents{get(hObject,'Value')};       
guidata(hObject, handles);
plot_axes(handles, handles.ytype);
%mat
      %ylim([0 130]);

% --- Executes during object creation, after setting all properties.
function popupmenu_plane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_plane.
function popupmenu_plane_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_plane contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_plane


% --- Executes on button press in pushbutton_reload.
function pushbutton_reload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = restart(handles);
guidata(hObject,handles);

%--------------------------------------------------------
function handles = restart(handles)
% function handles = restart(handles)
% Reinitialise la maille et l'IHM

AD = getad;
run(AD.ATModel); %% Load lattice
global THERING
% MAT ET LAURENT : TEMPORAIRE
%warning('66 MeV');
%setenergymodel(0.066);

%
setappdata(handles.figure1, 'LT1', THERING);

handles.restart = 1;
handles         = computeTwiss(handles);

plot_axes(handles,handles.ytype);
%mat
   
%ylim([0 130]);

handles.modelMagnetVal  = {'chModelVal', 'cvModelVal', ...
    'quadrupoleModelVal', 'dipoleModelVal'};

store_model_values(handles);

% Relaod Accelerator Object
AO  = getao; 

%% Initialise les sliders et editboxes
for k = 1:handles.sliderNumber
    name = ['popupmenu_bar' num2str(k)];
    contents = get(handles.(name),'String');
    magnet = contents{get(handles.(name),'Value')};
    
    Qname = ['QP' num2str(k)];   
    
    % Read AT values
    val  = getam(common2family(magnet),common2dev(magnet),'Model');
    
    set(handles.(['slider' Qname]),'Value', val);
    set(handles.(['edit' Qname]),'string', num2str(val));
end


% --- Executes during object creation, after setting all properties.
function popupmenu_bar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_bar1.
function popupmenu_bar1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_bar1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bar1

setbar(handles);

%----------------------------------------------------------
function setbar(handles)
%% aimant selectionne
contents = get(gcbo,'String');
magnet = contents{get(gcbo,'Value')}

%% mets a jour l'IHM pour cet aimant
tagstring = get(gcbo,'Tag');
num = tagstring(regexp(tagstring,'\d'));
slidername = ['sliderQP' num]; 
editboxname = ['editQP' num]; 

AOmagnet  = getappdata(handles.figure1,'AOmagnet'); 

switch magnet
    case AOmagnet.CH.CommonNames
        val_max = getmaxsp('CH');
        for k = 1:7
            name = strcat('sliderQP',num2str(k))
            set(handles.(name),'Max',val_max);
        end
        val = AOmagnet.CH.ModelVal(str2double(magnet(end)));
    case AOmagnet.CV.CommonNames
        val = AOmagnet.CV.ModelVal(str2double(magnet(end)));
    case AOmagnet.QP.CommonNames
        val = AOmagnet.QP.ModelVal(str2double(magnet(end)));
end

str = num2str(val);
set(handles.(slidername),'Value',val); % writes slider
set(handles.(editboxname),'String',str); % writes editbox

% --- Executes during object creation, after setting all properties.
function popupmenu_bar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu_bar2.
function popupmenu_bar2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_bar2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bar2
setbar(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_bar3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu_bar3.
function popupmenu_bar3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_bar3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bar3
setbar(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_bar4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu_bar4.
function popupmenu_bar4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_bar4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bar4
setbar(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_bar5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu_bar5.
function popupmenu_bar5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_bar5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bar5
setbar(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_bar6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_bar6.
function popupmenu_bar6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_bar6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bar6
setbar(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_bar7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu_bar7.
function popupmenu_bar7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bar7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_bar7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bar7
setbar(handles);


% --- Executes on button press in pushbutton_refresh.
function pushbutton_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------------------------------------------------
function read_tango(handles)
% Reads Tango values for LT1.

% Get magnet AO
AOmagnet = getappdata(handles.figure1,'AOmagnet');
FamilyName = fieldnames(AOmagnet); 

for k1 = 1:length(FamilyName)
        % get attribute readback value
        magnet = AOmagnet.(FamilyName{k1});
        AOmagnet.(FamilyName{k1}).TangoVal = ...
            getam(FamilyName{k1},'Online');
end

% save data
setappdata(handles.figure1,'AOmagnet',AOmagnet)

%--------------------------------------------------------------------------
function write_tango(handles);
%-- Writes Tango values
%% Ecriture courant aimant sur les devices serveurs

% Get magnet AO
AOmagnet = getappdata(handles.figure1,'AOmagnet');

FamilyName = fieldnames(AOmagnet); 
for k1 = 1:length(FamilyName)
    magnet = AOmagnet.(FamilyName{k1});
    setsp(magnet, magnet.ModelVal,'Online');
end

%--------------------------------------------------------------------------
function devicelist = get_device_name(machine,property,magnet)
% get device list from mapping read in tango database

map        = tango_get_db_property(machine,property);
sep        = cell2mat(regexpi(map,'::','once'))-1;
devicelist = regexprep(map,[magnet '\d*::'],'')';

% --- Executes during object creation, after setting all properties.
function pushbutton_reload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in pushbutton_model2online.
function pushbutton_model2online_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_model2online (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AOmagnet      = getappdata(handles.figure1,'AOmagnet'); %% get LT1 structure

user_response = questdlg('Do you want to write setvalues to LT1?');
switch user_response
    case{'No','Cancel'}
        return;
    case{'Yes'}
        FamilyName = fieldnames(AOmagnet);
        for k1 = 1:length(FamilyName)
            AOmagnet.(FamilyName{k1}).TangoVal = ...
                AOmagnet.(FamilyName{k1}).ModelVal;
        end
        write_tango(handles);
end

% save data
setappdata(handles.figure1,'AOmagnet',AOmagnet)

% --- Executes on button press in pushbutton_online2model.
function pushbutton_online2model_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_online2model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Online values stored in model values except dipoles
user_response = questdlg('Do you want to read TANGO setvalues from LT1?');
switch user_response
    case{'No','Cancel'}
        return;
    case{'Yes'}
        read_tango(handles);
end

AOmagnet    = getappdata(handles.figure1,'AOmagnet'); %% get LT1 structure

FamilyName = fieldnames(AOmagnet); 
for k1 = 1:length(FamilyName)    
        AOmagnet.(FamilyName{k1}).ModelVal = AOmagnet.(FamilyName{k1}).TangoVal;
end
        
%% Initialise les sliders et editboxes
for k = 1:handles.sliderNumber
    name = ['popupmenu_bar' num2str(k)];
    contents = get(handles.(name),'String');
    magnet = contents{get(handles.(name),'Value')};
    
    Qname = ['QP' num2str(k)];   
    
    switch magnet
        case AOmagnet.QP.CommonNames            
            val = AOmagnet.QP.TangoVal(str2double(magnet(end)));
        case AOmagnet.CH.CommonNames
            val = AOmagnet.CH.TangoVal(str2double(magnet(end)));
        case AOmagnet.CV.CommonNames
            val = AOmagnet.CV.TangoVal(str2double(magnet(end)));
    end
    
    set(handles.(['slider' Qname]),'Value', val);
    set(handles.(['edit' Qname]),'string', num2str(val));
end

set_model_values(handles);

handles = computeTwiss(handles);
plot_axes(handles,handles.ytype);
%mat
        %ylim([0 130]);
% Update handles structure
guidata(hObject, handles);

%% Update date
set(handles.text_date,'String',datestr(now,0));

%save data
setappdata(handles.figure1,'AOmagnet',AOmagnet);

%--------------------------------------------------------------------------
function handles = init_handles(handles)
%% Inits structure storing all the magnet data

%% AT model used
% global THERING;

A1 = getao; % Load AO for the first time
AOmagnet = [];
list = findmemberof('Magnet');
for k = 1:length(list)
    AOmagnet.(list{k}) = A1.(list{k});
end
clear A1;

%save data
setappdata(handles.figure1,'AOmagnet',AOmagnet);

store_model_values(handles);

%% Update time
set(handles.text_date,'String',datestr(now,0));

%--------------------------------------------------------------------------
function store_model_values(handles)
%% Stores model values in AOmagnet 

AOmagnet = getappdata(handles.figure1,'AOmagnet'); % get AOmagnet structure

% Loop over magnet types
FamilyName = fieldnames(AOmagnet);

for k1 = 1:length(FamilyName)
    AOmagnet.(FamilyName{k1}).ModelVal = getam(FamilyName{k1},'Model');
end

setappdata(handles.figure1,'AOmagnet',AOmagnet);

%--------------------------------------------------------------------------
function set_model_values(handles)
% Set Modelvalue into LT1 AT model

AOmagnet = getappdata(handles.figure1,'AOmagnet'); % get AOmagnet structure

%% Set model values to AT
FamilyName = fieldnames(AOmagnet); 

for k1 = 1:length(FamilyName)
    magnet = AOmagnet.(FamilyName{k1});
    setsp(FamilyName{k1}, magnet.ModelVal,'Model');
end


%--------------------------------------------------------------------------
function submenu_print_setpoint_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_print_setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------
function submenu_print_model_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_print_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% -------------------------------------------------------------------------
function submenu_save_setpoint_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_save_setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% -------------------------------------------------------------------------
function submenu_save_model_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_save_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% -------------------------------------------------------------------------
function submenu_load_setpoint_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_load_setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------
function submenu_load_model_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_load_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function submenu_dump_model_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_dump_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get magnet AO
AOmagnet = getappdata(handles.figure1,'AOmagnet');

fprintf('  DeviceName     Model   s(m)   phasex betax(m) etax(m) xcod(mm) phasez betaz(m) etaz(m) zcod(mm)\n')

FamilyName = fieldnames(AOmagnet); 
for k1 = 1:length(FamilyName)
    alias = AOmagnet.(FamilyName{k1});
    for k2 = 1 : length(AOmagnet.(FamilyName{k1}).CommonNames)
        fprintf('%15s %6.2f %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f  %6.2f \n', ...
            alias.DeviceName{k2}, alias.ModelVal(k2), ... 
            handles.spos(alias.AT.ATIndex(k2),1), handles.phase(alias.AT.ATIndex(k2),1), ...
            handles.beta(alias.AT.ATIndex(k2),1), handles.eta(alias.AT.ATIndex(k2),1), ...
            handles.cod(alias.AT.ATIndex(k2),1), ...
            handles.phase(alias.AT.ATIndex(k2),2), ...
            handles.beta(alias.AT.ATIndex(k2),2), handles.eta(alias.AT.ATIndex(k2),2), ...
            handles.cod(alias.AT.ATIndex(k2),2));
    end
end


%--------------------------------------------------------------------------
function submenu_dump_setpoint_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_dump_setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get magnet AO
AOmagnet = getappdata(handles.figure1,'AOmagnet');

fprintf('\n\n  DeviceName     TANGO\n')

FamilyName = fieldnames(AOmagnet); 
for k1 = 1:length(FamilyName)
    for k2 = 1 : length(AOmagnet.(FamilyName{k1}).CommonNames)
        alias = AOmagnet.(FamilyName{k1});
        fprintf('%15s %6.2f \n', alias.DeviceName{k2}, ...
            alias.TangoVal(k2));
    end
end


%--------------------------------------------------------------------------
function submenu_dump_soleil_setpoint_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_dump_soleil_setpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('\n\n  DeviceName     Model  TANGO\n')

% Get magnet AO
AOmagnet = getappdata(handles.figure1,'AOmagnet');

FamilyName = fieldnames(AOmagnet); 
for k1 = 1:length(FamilyName)
    for k2 = 1 : length(AOmagnet.(FamilyName{k1}).CommonNames)
        alias = AOmagnet.(FamilyName{k1});
        fprintf('%15s %6.2f %6.2f\n', alias.DeviceName{k2}, ...
            alias.ModelVal(k2), alias.TangoVal(k2));
    end
end


% --------------------------------------------------------------------
function twiss_parameters_Callback(hObject, eventdata, handles)
% hObject    handle to twiss_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function submenu_twissparameters_entry_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_twissparameters_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

twiss_parameters_entry(handles)



