function varargout = twiss_parameters_entry(varargin)
%  TWISS_PARAMETERS_ENTRY - Panel used by LT1_optics for modifying input
%                           twiss parameters
% 
%  Written by M.A Tordeux
%  Modified by L. Nadolski

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @twiss_parameters_entry_OpeningFcn, ...
                   'gui_OutputFcn',  @twiss_parameters_entry_OutputFcn, ...
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



% --- Executes just before twiss_parameters_entry is made visible.
function twiss_parameters_entry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to twiss_parameters_entry (see VARARGIN)

% Choose default command line output for twiss_parameters_entry
handles.output = hObject;

if iscell(varargin) && ~isempty(varargin)
    
    % store handle from caller
    handles.caller = varargin{1}.figure1;
    
    % Get values from Application-Defined data
    handles.twissdatain = getappdata(handles.caller, 'twissdatain');
    handles.axes1=findobj(allchild(handles.caller),'Tag','axes1');
    handles.popupmenu_x = findobj(allchild(handles.caller), 'Tag','popupmenu_x');
    handles.popupmenu_y = findobj(allchild(handles.caller), 'Tag','popupmenu_y');
    % Update handles structure
    guidata(hObject, handles);

else
    
end

% Update handles structure
guidata(hObject, handles);


% affichage des valeurs th�oriques de optics
betax = handles.twissdatain.beta(1);
betay = handles.twissdatain.beta(2);
alphax = handles.twissdatain.alpha(1);
alphay = handles.twissdatain.alpha(2);
gammax = (1 + alphax * alphax) / betax;
gammay = (1 + alphay * alphay) / betay;

set(handles.betah_edit,'String',sprintf('%3.2f',betax));
set(handles.gammah_edit,'String',sprintf('%3.2f',gammax));
set(handles.alphah_edit,'String',sprintf('%3.2f',alphax));
set(handles.betav_edit,'String',sprintf('%3.2f',betay));
set(handles.gammav_edit,'String',sprintf('%3.2f',gammay));
set(handles.alphav_edit,'String',sprintf('%3.2f',alphay));

function appliquer_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to appliquer_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of appliquer_pushbutton as text
%        str2double(get(hObject,'String')) returns contents of appliquer_pushbutton as a double

% prise en compte des nouvelles valeurs des param�tres de Twiss a l'entree
handles.twissdatain.beta(1) = str2double(get(handles.betah_edit,'String') );
handles.twissdatain.alpha(1)  = str2double(get(handles.alphah_edit,'String'));
set(handles.gammah_edit,'String',...
    sprintf('%3.2f',(1 +handles.twissdatain.alpha(1)*handles.twissdatain.alpha(1))/handles.twissdatain.beta(1) ));

handles.twissdatain.beta(2) = str2double(get(handles.betav_edit,'String') );
handles.twissdatain.alpha(2)  = str2double(get(handles.alphav_edit,'String'));
set(handles.gammav_edit,'String',...
    sprintf('%3.2f',(1 +handles.twissdatain.alpha(2)*handles.twissdatain.alpha(2))/handles.twissdatain.beta(1) ));

setappdata(handles.caller,'twissdatain',handles.twissdatain);

global THERING;

% get twiss paramaters everywhere
TD = twissline(THERING,0.0,handles.twissdatain,1:length(THERING),'chroma');

handles.beta  = cat(1,TD.beta);
handles.cod   = cat(2,TD.ClosedOrbit)';
handles.eta   = cat(2,TD.Dispersion)';
handles.spos  = cat(1,TD.SPos);
handles.phase = cat(1,TD.mu);

% lecture des popup menu de optics
valeur = get(handles.popupmenu_x, 'Value');
str = get(handles.popupmenu_x, 'String');
handles.xtype = str{valeur};
valeur = get(handles.popupmenu_y, 'Value');
str = get(handles.popupmenu_y, 'String');
handles.ytype = str{valeur};

% Replot everything
plot_axes(handles,handles.ytype);
%mat
        ylim([0 130]);
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
        ylim([0 130]);
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


% --- Outputs from this function are returned to the command line.
function varargout = twiss_parameters_entry_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;  % ???
%disp('c''est fini')
