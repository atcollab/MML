function varargout = betabeat(varargin)
% BETABEAT M-file for betabeat.fig
%      BETABEAT, by itself, creates a new BETABEAT or raises the existing
%      singleton*.
%
%      H = BETABEAT returns the handle to a new BETABEAT or the handle to
%      the existing singleton*.
%
%      BETABEAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BETABEAT.M with the given input arguments.
%
%      BETABEAT('Property','Value',...) creates a new BETABEAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before betabeat_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to betabeat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help betabeat

% Last Modified by GUIDE v2.5 14-Oct-2005 10:45:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @betabeat_OpeningFcn, ...
                   'gui_OutputFcn',  @betabeat_OutputFcn, ...
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


% --- Executes just before betabeat is made visible.
function betabeat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to betabeat (see VARARGIN)

% Choose default command line output for betabeat
global THERING;
handles.output = hObject;
%a25_Symplectic;
handles.THERING = THERING;
handles.refAO = getao;
handles.reftwiss=gettwiss;
handles.quadlist=findmemberof('QUAD');
handles.nmagnet= size(handles.quadlist,1);
handles.reftune=gettune;
for i=1:handles.nmagnet,
    magnet=cell2mat(handles.quadlist(i));
    a = getsp(magnet);
    handles.ref_sp{i}= a;
end
handles.bendlist = findcells(handles.THERING, 'FamName', 'BEND');
handles.nbends=size(handles.bendlist,2);
for i=1:handles.nbends,
    handles.bendK(i)=handles.THERING{handles.bendlist(i)}.K;
end
%guidata(hObject, handles);

handles.betax   =	... 
    line('parent',handles.horAxes,'XData',handles.reftwiss.s,'YData',...
    handles.reftwiss.betax,'Color','r');
xlabel(handles.horAxes,'s - position [m]');
ylabel(handles.horAxes,'\beta_x [m]');
xaxis([0 268.8], handles.horAxes);

handles.betay   =	... 
    line('parent',handles.verAxes,'XData',handles.reftwiss.s,'YData',...
    handles.reftwiss.betay,'Color','b');
xlabel(handles.verAxes,'s - position [m]');
ylabel(handles.verAxes,'\beta_y [m]');
xaxis([0 268.8], handles.verAxes);

handles.betax   =	line('parent',handles.horAxes,'XData',handles.reftwiss.s,'YData',handles.reftwiss.betax,'Color','k','Marker','+','LineStyle','none');
handles.bbetax   =	line('parent',handles.horAxes,'XData',handles.reftwiss.s,'YData',0*handles.reftwiss.betax,'Color','g');
handles.betay   =	line('parent',handles.verAxes,'XData',handles.reftwiss.s,'YData',handles.reftwiss.betay,'Color','k','Marker','+','LineStyle','none');
handles.bbetay   =	line('parent',handles.verAxes,'XData',handles.reftwiss.s,'YData',0*handles.reftwiss.betay,'Color','g');
set(handles.qxref,'String',num2str(handles.reftune(1)));
set(handles.qyref,'String',num2str(handles.reftune(2)));
guidata(hObject, handles);
% Update handles structure


% UIWAIT makes betabeat wait for user response (see UIRESUME)
% uiwait(handles.betabeat);


% --- Outputs from this function are returned to the command line.
function varargout = betabeat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function seedText_Callback(hObject, eventdata, handles)
% hObject    handle to seedText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seedText as text
%        str2double(get(hObject,'String')) returns contents of seedText as a double


% --- Executes during object creation, after setting all properties.
function seedText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seedText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function errorText_Callback(hObject, eventdata, handles)
% hObject    handle to errorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of errorText as text
%        str2double(get(hObject,'String')) returns contents of errorText as a double


% --- Executes during object creation, after setting all properties.
function errorText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setButton.
function setButton_Callback(hObject, eventdata, handles)
% hObject    handle to setButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THERING;
R_error_K=str2double(get(handles.errorText,'string'));
R_error_B=str2double(get(handles.errorBendText,'string'));
seed = str2double(get(handles.seedText,'string'));
randn('seed', seed);
set(handles.OldSeed,'String',num2str(randn('seed')));
for i=1:handles.nmagnet,
    magnet=cell2mat(handles.quadlist(i));
    nmi=size(handles.ref_sp{i},1);
    error = R_error_K*randn(nmi);
    clear new_sp;
    for j=1:nmi,
        new_sp(j) = (handles.ref_sp{i}(j))*(1+error(j));
    end
    setsp(magnet, new_sp');
end
for i=1:handles.nbends,
    error=R_error_B*randn();
    THERING{handles.bendlist(i)}.K=(1+error)*handles.bendK(i);
    THERING{handles.bendlist(i)}.PolynomB(2)=(1+error)*handles.bendK(i);
end
newA0=getao;
newtwiss=gettwiss;
newtune=gettune;

set(handles.betax,'YData',newtwiss.betax);
set(handles.bbetax,'YData',100*(handles.reftwiss.betax-newtwiss.betax)./handles.reftwiss.betax);
set(handles.betay,'YData',newtwiss.betay);
set(handles.bbetay,'YData',100*(handles.reftwiss.betay-newtwiss.betay)./handles.reftwiss.betay);

set(handles.seedText,'String',num2str(randn('seed')));
set(handles.qxnew,'String',num2str(newtune(1)));
set(handles.qynew,'String',num2str(newtune(2)));
set(handles.dqx,'String',num2str(handles.reftune(1)-newtune(1)));
set(handles.dqy,'String',num2str(handles.reftune(2)-newtune(2)));



function OldSeed_Callback(hObject, eventdata, handles)
% hObject    handle to OldSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OldSeed as text
%        str2double(get(hObject,'String')) returns contents of OldSeed as a double


% --- Executes during object creation, after setting all properties.
function OldSeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OldSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function popFigure_Callback(hObject, eventdata, handles)
% hObject    handle to popFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function popUp_Callback(hObject, eventdata, handles)
% hObject    handle to popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function popFigures_Callback(hObject, eventdata, handles)
% hObject    handle to popFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function printFig_Callback(hObject, eventdata, handles)
% hObject    handle to printFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'PaperType','A4');
get(gcf,'PaperSize')
set(gcf,'PaperPositionMode','auto');
print(gcf,'-dpdf','a.pdf')



function errorBendText_Callback(hObject, eventdata, handles)
% hObject    handle to errorBendText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of errorBendText as text
%        str2double(get(hObject,'String')) returns contents of errorBendText as a double


% --- Executes during object creation, after setting all properties.
function errorBendText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errorBendText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


