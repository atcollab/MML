function varargout = ellipseH_v16(varargin)  % EN COURS !!!!!!
% ellipseH_v16 M-file for ellipseH_v16.fig
%      ellipseH_v16, by itself, creates a new ellipseH_v16 or raises the existing
%      singleton*.
%
%      H = ellipseH_v16 returns the handle to a new ellipseH_v16 or the handle to
%      the existing singleton*.
%
%      ellipseH_v16('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ellipseH_v16.M with the given input arguments.
%
%      ellipseH_v16('Property','Value',...) creates a new ellipseH_v16 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ellipseH_v16_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ellipseH_v16_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ellipseH_v16

% Last Modified by GUIDE v2.5 26-Aug-2004 16:51:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ellipseH_v16_OpeningFcn, ...
                   'gui_OutputFcn',  @ellipseH_v16_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ellipseH_v16 is made visible.
function ellipseH_v16_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ellipseH_v16 (see VARARGIN)

% Choose default command line output for ellipseH_v16

% Choose default command line output for test_1
handles.output = hObject;

if iscell(varargin) && ~isempty(varargin)
    
    % store handle from caller
    handles.caller3 = varargin{1}.figure1;
    
    % Get values from Application-Defined data
    handles.energie_edit38=findobj(allchild(handles.caller3),'Tag','energie_edit38');
    IQ = getam('QP');
    
    twissx = getappdata(handles.caller3,'Twissx');
    twissy = getappdata(handles.caller3,'Twissy');
    epsx = sqrt(twissx(1)*twissx(2)-twissx(3)*twissx(3));
    epsy = sqrt(twissy(1)*twissy(2)-twissy(3)*twissy(3));
    
    % calcul de l'ellipse en amont du quad 4 :
    alphax = -twissx(3)/epsx;
    betax = twissx(1)/epsx;
    gammax = twissx(2)/epsx;
    % xint = sqrt(epsx *epsx  / twissx(2));
    % ymax = max(max(y1),max(y2));
    % EPSX = xint * ymax
    % disp('c''est incroyable')
    
    alphay = -twissy(3)/epsy;
    betay = twissy(1)/epsy;
    gammay = twissy(2)/epsy;
    
    % calcul de l'ellipse en amont de LT1 (point d'entr�e de la ligne de "optics_LT1") :  
    global THERING
    index = atindex(THERING);
    ao = getao;
    valQ = getam('QP');
    % � introduire quand OK
    setsp('QP',valQ,'model');
    
    % en attente de d�bogage k2amp
    valD = getam('BEND');
    energie = bend2GeV('BEND',valD);
    setenergymodel(energie);
    setsp('BEND',valD,'model');
    indQ = ao.QP.AT.ATIndex;
    lastind = indQ(4,1);
    res = inverseline(THERING , lastind ,  betax , betay ,- alphax ,- alphay );
    betax0 = res(1,1);
    betay0 = res(1,2);
    alphax0 = res(2,1);
    alphay0 = res(2,2);
    gammax0 = (1 + alphax0*alphax0) / betax0 ;
    gammay0 = (1 + alphay0*alphay0) / betay0 ;

    % �crire resultats en entr�e de ligne th�orique
    Namebeta = strcat('beta_edit',num2str((5-1)*3 + 1));
    Namegamma = strcat('gamma_edit',num2str((5-1)*3 + 2));
    Namealpha = strcat('alpha_edit',num2str((5-1)*3 + 3));
    set(handles.(Namebeta),'String',sprintf('%3.2f',betax0));
    set(handles.(Namegamma),'String',sprintf('%3.2f',gammax0));
    set(handles.(Namealpha),'String',sprintf('%3.2f',alphax0));
    
%     Namebeta = strcat('beta_edit',num2str((6-1)*3 + 1));
%     Namegamma = strcat('gamma_edit',num2str((6-1)*3 + 2));
%     Namealpha = strcat('alpha_edit',num2str((6-1)*3 + 3));
%     set(handles.(Namebeta),'String',sprintf('%3.2f',betay0));
%     set(handles.(Namegamma),'String',sprintf('%3.2f',gammay0));
%     set(handles.(Namealpha),'String',sprintf('%3.2f',alphay0));
    
    %%% parameters at the entrance of the line
    twissdatain.ElemIndex=1;
    twissdatain.SPos=0;
    twissdatain.ClosedOrbit=[1e-3 0 2e-3 0]'*0;
    twissdatain.M44=eye(4);
    twissdatain.beta= [betax0 betay0];
    twissdatain.alpha= [alphax0 alphay0];
    twissdatain.mu= [0 0];
    twissdatain.Dispersion= [0 0 0 0]';

    index = atindex(THERING);
    
    ECR0 = index.BPM(1);
    ECR1 = index.BPM(2);
    FAE = index.COLL ;
    
    %%% get twiss paramaters at typical points
    TD = twissline(THERING,0.0,twissdatain,1:length(THERING),'chroma');
    
    betaxECR0 = TD(ECR0).beta(1);
    alphaxECR0 = TD(ECR0).alpha(1);
    gammaxECR0  = (1 + alphaxECR0*alphaxECR0) / betaxECR0;
%     betayECR0 = TD(ECR0).beta(2);
%     alphayECR0 = TD(ECR0).alpha(2);
%     gammayECR0  = (1 + alphayECR0*alphayECR0) / betayECR0;
    
    betaxECR1 = TD(ECR1).beta(1);
    alphaxECR1 = TD(ECR1).alpha(1);
    gammaxECR1  = (1 + alphaxECR1*alphaxECR1) / betaxECR1;
%     betayECR1 = TD(ECR1).beta(2);
%     alphayECR1 = TD(ECR1).alpha(2);
%     gammayECR1  = (1 + alphayECR1*alphayECR1) / betayECR1;
    
    
    graphe(1,epsx,betaxECR0,alphaxECR0,gammaxECR0,handles);
    %graphe(3,epsy,betayECR0,alphayECR0,gammayECR0,handles);
    graphe(2,epsx,betaxECR1,alphaxECR1,gammaxECR1,handles);
    %graphe(4,epsy,betayECR1,alphayECR1,gammayECR1,handles);
    
    % Update handles structure
    guidata(hObject, handles);

else
    
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ellipseH_v16 wait for user response (see UIRESUME)
% uiwait(handles.main);


% 
% --- Outputs from this function are returned to the command line.
function varargout = ellipseH_v16_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;  % ???



% % --- Executes on button press in pushbutton1.
% function recommencer_pushbutton1_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


function beta_edit1_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit4_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit7_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit10_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit13_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit16_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit2_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit5_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit8_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit11_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit14_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit17_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit3_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit6_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit9_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit12_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit15_Callback(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit18_Callback(hObject, eventdata, handles)
% NE FAIT RIEN

function beta_edit1_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit4_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit7_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit10_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit13_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function beta_edit16_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit2_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit5_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit8_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit11_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit14_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function gamma_edit17_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit3_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit6_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit9_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit12_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit15_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN
function alpha_edit18_CreateFcn(hObject, eventdata, handles)
% NE FAIT RIEN






function twissdebut = inverseline(THERING,lastind,betax0,betay0,alphax0,alphay0)
% inversion de la partie droite de LT1 

global INVSTRAIGHTLINE;
INVSTRAIGHTLINE = { };
for i=1:lastind-1
    INVSTRAIGHTLINE{i} = THERING{lastind-i};
end
twissdatain.ElemIndex=1;
twissdatain.SPos=0;
twissdatain.ClosedOrbit=[1e-3 0 2e-3 0]'*0;
twissdatain.M44=eye(4);
twissdatain.beta= [betax0 betay0];
twissdatain.alpha= [alphax0 alphay0];

% tests
%twissdatain.beta= [23.247 7.9566];
%twissdatain.alpha= [10.946 -5.2186];
%wissdatain.beta= [9.4707   18.0971];
%twissdatain.alpha= [-6.9443    7.9509];

twissdatain.mu= [0 0];
twissdatain.Dispersion= [0 0 0 0]';

%%% get twiss paramaters
TD = twissline(INVSTRAIGHTLINE,0.0,twissdatain,1:length(INVSTRAIGHTLINE),'chroma');
twissdebut(1,:) = TD(end).beta;
twissdebut(2,:) = TD(end).alpha;


function graphe(naxe,epsilon,beta,alpha,gamma,handles)

name=['axes' num2str(naxe)];
axes(handles.(name)); %axis image ; 

xx = -sqrt(epsilon * beta):sqrt(epsilon * beta)/50:sqrt(epsilon * beta);
zx1 = - alpha * xx / beta + sqrt(epsilon * beta - xx.*xx) / beta;
zx2 = - alpha * xx / beta - sqrt(epsilon * beta - xx.*xx) / beta;

plot(xx*1000,real(zx1*1000),'r',xx*1000,real(zx2*1000),'r')
xlim([-5 5]);
%ylim([-5 5]);

Namebeta = strcat('beta_edit',num2str((naxe-1)*3 + 1));
Namegamma = strcat('gamma_edit',num2str((naxe-1)*3 + 2));
Namealpha = strcat('alpha_edit',num2str((naxe-1)*3 + 3));
set(handles.(Namebeta),'String',sprintf('%3.2f',beta));
set(handles.(Namegamma),'String',sprintf('%3.2f',gamma));
set(handles.(Namealpha),'String',sprintf('%3.2f',alpha));
