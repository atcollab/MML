function varargout = Ringcycling(varargin)
% RINGCYCLING M-file for Ringcycling.fig
%      RINGCYCLING, by itself, creates a new RINGCYCLING or raises the existing
%      singleton*.
%
%      H = RINGCYCLING returns the handle to a new RINGCYCLING or the handle to
%      the existing singleton*.
%
%      RINGCYCLING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RINGCYCLING.M with the given input arguments.
%
%      RINGCYCLING('Property','Value',...) creates a new RINGCYCLING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Ringcycling_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Ringcycling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also : getcyclecurve, magnetcycle, LT1cycling, setcycling, cyclingcommand

% Edit the above text to modify the response to help Ringcycling

% Last Modified by GUIDE v2.5 07-Jun-2006 19:57:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ringcycling_OpeningFcn, ...
                   'gui_OutputFcn',  @Ringcycling_OutputFcn, ...
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


% --- Executes just before Ringcycling is made visible.
function Ringcycling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ringcycling (see VARARGIN)

% Choose default command line output for Ringcycling
handles.output = hObject;

% A MODIFIER ULTERIEUREMENT : INACTIVATION DES FONCTIONS
% CYCLAGE CORRECTEURS / ALL 
set(handles.checkbox_HCOR,'Value',0);
set(handles.checkbox_VCOR,'Value',0);
set(handles.checkbox_all,'Value',0);
set([handles.checkbox_all,handles.checkbox_HCOR,handles.checkbox_VCOR],...
    'Enable','off');

% par défaut type cyclage sur 'full'
set(handles.popupmenu_type,'Value',2);

% button group sur switch mode simulation ou online 
h = uibuttongroup('visible','off','Position',[0.70 0.46 .20 .10],...
    'Title','','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
u1 = uicontrol('Style','Radio','String','premier élément','Tag','radiobutton1',...
    'pos',[10 25 120 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
u2 = uicontrol('Style','Radio','String','toute la famille','Tag','radiobutton2',...
    'pos',[10 0.95 120 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});

set(h,'SelectedObject',u1);  % No selection
set(h,'Visible','on');

% mode de plot
handles.mode = '1element';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Ringcycling wait for user response (see UIRESUME)
% uiwait(handles.figure1);
list = {'Present', 'Golden', 'UserSelect'};
set(handles.popupmenu_file,'String',list);

list = {'Simple', 'Full', 'startup'};
set(handles.popupmenu_type,'String',list);

list = {'Load cycling curve','Start', 'Stop', 'Init', 'Pause', 'Resume'};
set(handles.popupmenu_command,'String',list);

% --- Outputs from this function are returned to the command line.
function varargout = Ringcycling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_none.
function checkbox_none_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_none
val = get(hObject,'Value');

if val
    set(handles.checkbox_BEND,'Value',0);
    set(handles.checkbox_Q1,'Value',0);
    set(handles.checkbox_HCOR,'Value',0);
    set(handles.checkbox_VCOR,'Value',0);
    set(handles.checkbox_all,'Value',0);
end

% --- Executes on button press in checkbox_all.
function checkbox_all_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_all
val = get(hObject,'Value');

if val
    set(handles.checkbox_BEND,'Value',1);
    
    % Quad
    
    for k =1:length(length(findmemberof('QUAD')))
        Name = strcat('Q',num2str(k));
        set(handles.(['checkbox_',Name]),'Value',1)
    end
    
    % Sextu        
    set(handles.checkbox_S1,'Value',1);
    set(handles.checkbox_S2,'Value',1);
    set(handles.checkbox_S3,'Value',1);
    set(handles.checkbox_S4,'Value',1);
    set(handles.checkbox_S5,'Value',1);
    set(handles.checkbox_S6,'Value',1);
    set(handles.checkbox_S7,'Value',1);
    set(handles.checkbox_S8,'Value',1);
    set(handles.checkbox_S9,'Value',1);
    set(handles.checkbox_S10,'Value',1);
    % Dipoles
    set(handles.checkbox_HCOR,'Value',1);
    set(handles.checkbox_VCOR,'Value',1);
    % none
    set(handles.checkbox_none,'Value',0);
end


% --- Executes on button press in checkbox_BEND.
function checkbox_BEND_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BEND (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BEND

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);
val = get(handles.checkbox_BEND,'Value');
valQ1 = get(handles.checkbox_Q1,'Value');valQ2 = get(handles.checkbox_Q2,'Value');
valQ3 = get(handles.checkbox_Q3,'Value');valQ4 = get(handles.checkbox_Q4,'Value');
valQ5 = get(handles.checkbox_Q5,'Value');valQ6 = get(handles.checkbox_Q6,'Value');
valQ7 = get(handles.checkbox_Q7,'Value');valQ8 = get(handles.checkbox_Q8,'Value');
valQ9 = get(handles.checkbox_Q9,'Value');valQ10 = get(handles.checkbox_Q10,'Value');
valQtous = get(handles.checkbox_AllQuad,'Value');
valeurs = [valQ1 valQ2 valQ3 valQ4 valQ5 valQ6 valQ7 valQ8 valQ9 valQ10 valQtous];
test = ones(11,1)'*0;

if val
    
    if ~isequal(valeurs,test)
        errordlg('conflit entre Quad et Dipole !','Erreur');
        set(handles.checkbox_BEND,'Value',0);
        return
    end
    
    % exclure la montee des sextu et quad
    for k = 1:length(findmemberof('QUAD'))
        Name = strcat('Q',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','off')
    end
    set(handles.checkbox_AllQuad,'Enable','off');

    set(handles.checkbox_AllSextu,'Enable','off')
    for k = 1:length(findmemberof('SEXT'))
        Name = strcat('S',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','off')
    end
    

else
    val2 = get(handles.checkbox_AllQuad,'Value');
    if val2==0
        
        % rendre possible la montee des sextu et quad
        for k = 1:length(findmemberof('QUAD'))
            Name = strcat('Q',num2str(k));
            set(handles.(['checkbox_',Name]),'Enable','on')
        end
        set(handles.checkbox_AllQuad,'Enable','on');

        set(handles.checkbox_AllSextu,'Enable','on')
        for k = 1:length(findmemberof('SEXT'))
            Name = strcat('S',num2str(k));
            set(handles.(['checkbox_',Name]),'Enable','on')
        end

    end
end



% --- Executes on button press in checkbox_Q1.
function checkbox_Q1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q1

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_HCOR.
function checkbox_HCOR_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_HCOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_HCOR

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_VCOR.
function checkbox_VCOR_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_VCOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_VCOR

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in pushbutton_apply.
function pushbutton_apply_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = get(handles.popupmenu_command,'String');
command = contents{get(handles.popupmenu_command,'Value')};

switch command
    case {'Load cycling curve','Start','Stop','Init','Pause','Resume'}
        cyclemagnet_local(command,handles);
    otherwise
        error('Unknown ommand name: %s ', command);
end

function cyclemagnet_local(command,handles)

%     [CycleIndex, CycleAO] = isfamily(CycleFamily);
% 
%     rep = tango_group_command_inout2(CycleAO.GroupId,'State',1,0);

Family={'QC13','BEND',...
    'Q1','Q2','Q3','Q4','Q5',...
    'Q6','Q7','Q8','Q9','Q10',...
    'S1','S2','S3','S4','S5',...
    'S6','S7','S8','S9','S10',...
    'HCOR','VCOR'};    
    
Families = {};
for k =1:length(Family)
    if get(handles.(['checkbox_',Family{k}]),'Value')
        Families = {Families{:}, Family{k}};
    end
end

switch command
    case {'Start'}
        % get cycling file
        contents = get(handles.popupmenu_file,'String');
        file = contents{get(handles.popupmenu_file,'Value')};

        % get cycling file
        contents = get(handles.popupmenu_type,'String');
        type = contents{get(handles.popupmenu_type,'Value')};

        magnetcycle(type,file,Families,'NoDisplay','NoConfig');
        
    case {'Load cycling curve'}
        
        contents = get(handles.popupmenu_file,'String');
        file = contents{get(handles.popupmenu_file,'Value')};

        % get cycling file
        contents = get(handles.popupmenu_type,'String');
        type = contents{get(handles.popupmenu_type,'Value')};

        magnetcycle(type,file,Families,'NoDisplay','NoConfig','NoApply');
        
        
    case {'Stop','Init','Pause','Resume'}
        for k =1:length(Families)
            CycleFamily = ['Cycle' Families{k}];
            cyclingcommand(CycleFamily,command);
        end
end

% --- Executes on selection change in popupmenu_command.
function popupmenu_command_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_command contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_command

% --- Executes during object creation, after setting all properties.
function popupmenu_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_type.
function popupmenu_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_type


% --- Executes during object creation, after setting all properties.
function popupmenu_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_file.
function popupmenu_file_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_file contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_file


% --- Executes during object creation, after setting all properties.
function popupmenu_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox_Q2.
function checkbox_Q2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q2

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q3.
function checkbox_Q3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q3

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q4.
function checkbox_Q4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q4

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q5.
function checkbox_Q5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q5

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q6.
function checkbox_Q6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q6

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q7.
function checkbox_Q7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q7

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q8.
function checkbox_Q8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q8

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q9.
function checkbox_Q9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q9

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_Q10.
function checkbox_Q10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Q10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Q10

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S1.
function checkbox_S1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S1

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S2.
function checkbox_S2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S2

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S2.
function checkbox_S3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S3


% --- Executes on button press in checkbox_S4.
function checkbox_S4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S4

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S5.
function checkbox_S5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S5

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S6.
function checkbox_S6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S6

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S7.
function checkbox_S7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S7

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S8.
function checkbox_S8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S8

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S9.
function checkbox_S9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S9

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_S10.
function checkbox_S10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_S10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_S10

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);

% --- Executes on button press in checkbox_AllQuad.
function checkbox_AllQuad_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_AllQuad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AllQuad

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);
val = get(handles.checkbox_AllQuad,'Value');

if val
    set(handles.checkbox_noneQuad,'Value',0);      
    for k = 1:length(findmemberof('QUAD'))
        Name = strcat('Q',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','off')
        set(handles.(['checkbox_',Name]),'Value',1)
    end
    
    % exclure la montee des dipoles et sextus
    for k = 1:length(findmemberof('SEXT'))
        Name = strcat('S',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','off')
    end
    set(handles.checkbox_AllSextu,'Enable','off');
    set(handles.checkbox_BEND,'Enable','off');   
end

% --- Executes on button press in checkbox_AllSextu.
function checkbox_AllSextu_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_AllSextu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AllSextu

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);
val = get(handles.checkbox_AllSextu,'Value');

if val
    set(handles.checkbox_NoneSextu,'Value',0);    
      
    for k = 1:length(findmemberof('SEXT'))
        Name = strcat('S',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','off');
        set(handles.(['checkbox_',Name]),'Value',1)
    end
    % exclure la montee des dipoles et quad
    for k = 1:length(findmemberof('QUAD'))
        Name = strcat('Q',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','off')
    end
    set(handles.checkbox_AllQuad,'Enable','off');
    set(handles.checkbox_BEND,'Enable','off');

else
    
    for k = 1:length(findmemberof('SEXT'))
        Name = strcat('S',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','on')
    end
    % rendre possible la montee des dipoles et quad
    for k = 1:length(findmemberof('QUAD'))
        Name = strcat('Q',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','on')
    end
    set(handles.checkbox_AllQuad,'Enable','on');
    set(handles.checkbox_BEND,'Enable','on');
end



% --- Executes on button press in courbe_pushbutton.
function courbe_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to courbe_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% valBEND = get(handles.checkbox_BEND,'Value');
% valQ1 = get(handles.checkbox_Q1,'Value');valQ2 = get(handles.checkbox_Q2,'Value');
% valQ3 = get(handles.checkbox_Q3,'Value');valQ4 = get(handles.checkbox_Q4,'Value');
% valQ5 = get(handles.checkbox_Q5,'Value');valQ6 = get(handles.checkbox_Q6,'Value');
% valQ7 = get(handles.checkbox_Q7,'Value');valQ8 = get(handles.checkbox_Q8,'Value');
% valQ9 = get(handles.checkbox_Q9,'Value');valQ10 = get(handles.checkbox_Q10,'Value');
% valQtous = get(handles.checkbox_AllQuad,'Value');
% valS1 = get(handles.checkbox_S1,'Value');valS2 = get(handles.checkbox_S2,'Value');
% valQ3 = get(handles.checkbox_S3,'Value');valS4 = get(handles.checkbox_S4,'Value');
% valS5 = get(handles.checkbox_S5,'Value');valS6 = get(handles.checkbox_S6,'Value');
% valS7 = get(handles.checkbox_S7,'Value');valS8 = get(handles.checkbox_S8,'Value');
% valS9 = get(handles.checkbox_S9,'Value');valS10 = get(handles.checkbox_S10,'Value');
% valStous = get(handles.checkbox_AllSextu,'Value');
% %valeurs = [valQ1 valQ2 valQ3 valQ4 valQ5 valQ6 valQ7 valQ8 valQ9 valQ10 valQtous];
% test = ones(11,1)'*0;

%  for i = 1:10
%       name = strcat('valQ',num2str(i))
%        if eval(name)

name=['axes' num2str(1)];
axes(handles.(name));

Family={'BEND',...
    'Q1','Q2','Q3','Q4','Q5',...
    'Q6','Q7','Q8','Q9','Q10',...
    'S1','S2','S3','S4','S5',...
    'S6','S7','S8','S9','S10',...
    'HCOR','VCOR'};    
    
for k =1:length(Family)
    if get(handles.(['checkbox_',Family{k}]),'Value')
        Name = strcat('Cycle',Family{k});
        %Name = Family{k};

        vect = getfamilydata(Name,'DeviceName');
        if strcmp(handles.mode,'1element')
            jend = 1;
        elseif strcmp(handles.mode,'lafamille')
            jend = length(vect);
        end

        % plot de la courbe de cyclage du premier element magnetique de la
        % famille)
        for j = 1:jend
            curve = getcyclecurve(vect{j});

            if iscell(curve)
                for k=1:length(curve),
                    n = size(curve{k}.Data,1);
                    % time vector
                    cums = cumsum(curve{k}.Data(:,2))';
                    x = [cums; cums];
                    x = reshape(x,1,2*n);
                    x = [0 x(1:end-1)];

                    % amplitude vector
                    y = [curve{k}.Data(:,1),curve{k}.Data(:,1)]';
                    y = reshape(y,1,2*n);


                    plot(x,y,'b.-');
                    xlabel('Temps (s)');
                    ylabel('Courant [A]');
                    ylim([min(y) max(y)*1.05]);
                    title(['Cycling curve for ' curve{k}.DeviceName]);
                    grid on
                end
            else
                n = size(curve,1);
                % time vector
                cums = cumsum(curve(:,2))';
                x = [cums; cums];
                x = reshape(x,1,2*n);
                x = [0 x(1:end-1)];

                % amplitude vector
                y = [curve(:,1),curve(:,1)]';
                y = reshape(y,1,2*n);


                plot(x,y,'b.-');
                xlabel('Temps (s)');
                ylabel('Courant [A]');
                ylim([min(y)*1.1 max(y)*1.1]);
                title('courbe de cyclage');

                grid on

            end


            hold on
        end
        hold on
    end
end



% --- Executes on button press in checkbox_QC13.
function checkbox_QC13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_QC13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_QC13

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);
val = get(handles.checkbox_QC13,'Value');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton_singledevice.
function pushbutton_singledevice_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_singledevice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function uibuttongroup_SelectionChangeFcn(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here
        % 'Mode' = 'Simulation';
        handles.mode = '1element';
       
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        % '.Mode' = 'Machine';
        handles.mode = 'lafamille';
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in checkbox_noneQuad.
function checkbox_noneQuad_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_noneQuad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_noneQuad

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);
val = get(handles.checkbox_noneQuad,'Value');

if val
    set(handles.checkbox_AllQuad,'Value',0);
    for k = 1:length(findmemberof('QUAD'))
        Name = strcat('Q',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','on')
        set(handles.(['checkbox_',Name]),'Value',0)
    end

    % rendre possible la montee des dipoles et sextus
    for k = 1:length(findmemberof('SEXT'))
        Name = strcat('S',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','on')
    end
    set(handles.checkbox_AllSextu,'Enable','on');
    set(handles.checkbox_BEND,'Enable','on');
end


% --- Executes on button press in checkbox_NoneSextu.
function checkbox_NoneSextu_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_NoneSextu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_NoneSextu

set(handles.checkbox_all,'Value',0);
set(handles.checkbox_none,'Value',0);
val = get(handles.checkbox_NoneSextu,'Value');

if val
    set(handles.checkbox_AllSextu,'Value',0);    
    for k = 1:length(findmemberof('SEXT'))
        Name = strcat('S',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','on')
        set(handles.(['checkbox_',Name]),'Value',0)
    end

    % rendre possible la montee des dipoles et quad
    for k = 1:length(findmemberof('QUAD'))
        Name = strcat('Q',num2str(k));
        set(handles.(['checkbox_',Name]),'Enable','on')
    end
    set(handles.checkbox_AllQuad,'Enable','on');
    set(handles.checkbox_BEND,'Enable','on');
end