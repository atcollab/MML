function varargout = resolution(varargin)
% RESOLUTION M-file for resolution.fig
%      RESOLUTION, by itself, creates a new RESOLUTION or raises the existing
%      singleton*.
%
%      H = RESOLUTION returns the handle to a new RESOLUTION or the handle to
%      the existing singleton*.
%
%      RESOLUTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESOLUTION.M with the given input arguments.
%
%      RESOLUTION('Property','Value',...) creates a new RESOLUTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resolution_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resolution_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resolution

% Last Modified by GUIDE v2.5 02-Jul-2007 10:20:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resolution_OpeningFcn, ...
                   'gui_OutputFcn',  @resolution_OutputFcn, ...
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



function UpdatePlots(hObject,handles)
orbit=getcod;
y=1e6*orbit(3,handles.xrs);
py=1e6*orbit(4,handles.xrs);
line('parent',handles.orbitPlot,'XData',1:88,'YData',gety,'Color','b');
xlabel(handles.orbitPlot,'BPM index');
ylabel(handles.orbitPlot,'y [mm]');
line('parent',handles.cmPlot,'XData',1:88,'YData',getsp('VCM'),'Color','m');
xlabel(handles.cmPlot,'CM index');
ylabel(handles.cmPlot,'I [A]');
line('parent',handles.idPlot,'XData',y,'YData',py,...
    'Color','b','LineStyle','none', 'Marker','.');
xlabel(handles.idPlot,'y [\mum]');
ylabel(handles.idPlot,'p_y [\murad]');
svcm=std(getsp('VCM'));
line1=['Seed ',num2str(handles.sim,'%d'), ' data:'];
line2=['Corrector rms= ', num2str(svcm),' A'];
line2a= ['Corrector noise= ',num2str(1e6*svcm/10),' ppm'];
sbpm=1e3*std(gety);
line3=['BMP rms= ', num2str(sbpm),' um'];
sy=std(y);
spy=std(py);
line4=['Y rms= ', num2str(sy),' um'];
line5=['Y rms= ', num2str(spy),' urad'];
handles.sbpm(handles.sim)=sbpm;
handles.svcm(handles.sim)=svcm;
handles.sy(handles.sim)=sy;
handles.spy(handles.sim)=spy;
lineb1=['Accumulated Data for ', num2str(handles.sim,'%d'),' seeds'];
lineb2=['Corrector rms= ', num2str(mean(handles.svcm)),' A'];
lineb2a= ['Corrector noise= ',num2str(1e6*mean(handles.svcm)/10),' ppm'];
line3b=['BMP rms= ', num2str(mean(handles.sbpm)),' um'];
line4b=['Y rms= ', num2str(mean(handles.sy)),' um'];
line5b=['Y rms= ', num2str(mean(handles.spy)),' urad'];

text=char(line1,line2,line2a,line3, line4,line5, ...
    ' ',lineb1,lineb2, lineb2a,line3b,line4b,line5b);
set(handles.OutputText,'String',text);
handles.sim=handles.sim+1;
guidata(hObject, handles);
% --- Executes just before resolution is made visible.
function resolution_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resolution (see VARARGIN)

% Choose default command line output for resolution
handles.output = hObject;

% Update handles structure


% UIWAIT makes resolution wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.ati=atindex();
handles.optic=gettwiss();
handles.xrs=handles.ati.xrs;
handles.sCM=handles.optic.s(handles.ati.COR);
handles.sBPM=handles.optic.s(handles.ati.BPM);
handles.sim=1;
guidata(hObject, handles);
%UpdatePlots(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = resolution_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SetButton.
function SetButton_Callback(hObject, eventdata, handles)
% hObject    handle to SetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp 'Setting the noise in the VCM'
theRes=str2num(get(handles.noiseVal,'string'))*1E-6;
setsp('VCM', (randn(88,1)-0.5)*10*theRes);
UpdatePlots(hObject,handles)

function noiseVal_Callback(hObject, eventdata, handles)
% hObject    handle to noiseVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noiseVal as text
%        str2double(get(hObject,'String')) returns contents of noiseVal as a double


% --- Executes during object creation, after setting all properties.
function noiseVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


