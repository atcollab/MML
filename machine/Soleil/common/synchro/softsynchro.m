function varargout = softsynchro(varargin)
% SOFTSYNCHRO M-file for softsynchro.fig
%      
%% handles.periode = periode en seconde
%% fonction_alex : fonction trigger (à remplir)
%
% See also: 

% Edit the above text to modify the response to help softsynchro

% Last Modified by GUIDE v2.5 20-Apr-2006 15:06:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @softsynchro_OpeningFcn, ...
                   'gui_OutputFcn',  @softsynchro_OutputFcn, ...
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


% --- Executes just before softsynchro is made visible.
function softsynchro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to softsynchro (see VARARGIN)

% Choose default command line output for softsynchro
handles.output = hObject;

% periode du trigger par defaut = 4/3
handles.periode = 1.333;
set(handles.edit1,'String',num2str(handles.periode));

% Creates timer Infinite loop
timer1=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',handles.periode,'TasksToExecute',Inf);
timer1.TimerFcn = {@fonction_alex, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer',timer1);

% button group sur on/off timer du trigger
h = uibuttongroup('visible','off','Position',[0.1 0.1 0.8 0.45],...
    'Title','Trigger','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
u1 = uicontrol('Style','Radio','String','OFF','Tag','radiobutton1',...
    'pos',[80 25 90 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
u2 = uicontrol('Style','Radio','String','ON','Tag','radiobutton2',...
    'pos',[80 65 90 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});

set(h,'SelectedObject',u1); 
set(h,'Visible','on');

%% Set closing gui function
set(handles.figure1,'CloseRequestFcn',{@Closinggui,timer1,handles.figure1});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes softsynchro wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = softsynchro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

handles.periode = str2double(get(hObject,'String'));

% change timer Infinite loop
timer1=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',handles.periode,'TasksToExecute',Inf);
timer1.TimerFcn = {@fonction_alex, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer',timer1);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
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
       
    case 'radiobutton2'
        % stop du trigger 
        start(timer1);
        
end

function fonction_alex(arg1,arg2,hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%  FONCTION ALEX
disp('ça marche !!')
tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent')







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
