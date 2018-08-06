function varargout = prova_image(varargin)
% PROVA_IMAGE MATLAB code for prova_image.fig
%      PROVA_IMAGE, by itself, creates a new PROVA_IMAGE or raises the existing
%      singleton*.
%
%      H = PROVA_IMAGE returns the handle to a new PROVA_IMAGE or the handle to
%      the existing singleton*.
%
%      PROVA_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROVA_IMAGE.M with the given input arguments.
%
%      PROVA_IMAGE('Property','Value',...) creates a new PROVA_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prova_image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prova_image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prova_image

% Last Modified by GUIDE v2.5 13-Mar-2012 16:32:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prova_image_OpeningFcn, ...
                   'gui_OutputFcn',  @prova_image_OutputFcn, ...
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


% --- Executes just before prova_image is made visible.
function prova_image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prova_image (see VARARGIN)

% Choose default command line output for prova_image
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prova_image wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 handles.Camera_name='SCam1';
 
%handles.imageplot = plot(handles.imageBox, NaN, NaN);
%handles.profy = plot(handles.axes_left, NaN, NaN);
%handles.profx = plot(handles.axes_bottom, NaN, NaN);

handles.imageplot = plot(handles.imageBox, NaN, NaN);

set(handles.imageBox, 'Units','pixels');
set(handles.imageBox, 'PlotBoxAspectRatio',[1.3281 1 1]);
set(handles.imageBox, 'XTick',[]);
set(handles.imageBox, 'XTickLabel','');
set(handles.imageBox, 'YTick',[]);
set(handles.imageBox, 'YTickLabel','');


% Setup Timer
UpdatePeriod = 1;

t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn',{@Viewscreen_Timer_Callback,handles});
%set(t, 'StartFcn', ['llrf(''Timer_Start'',',    sprintf('%.30f',handles.hMainFigure), ',',sprintf('%.30f',handles.hMainFigure), ', [])']);
%set(t, 'UserData', thehandles);
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
set(t, 'ErrorFcn', {@Viewscreen_Timer_Error,handles});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'ImageGrabTimer');

handles.TimerHandle = t;

% Save handles
setappdata(0, 'ViewscreenTimer', handles);

% Draw the figure
set(handles.figure1,'Visible','On');
drawnow expose

start(t);


% --- Executes on button press in Live_Capture.
function Live_Capture_Callback(hObject, eventdata, handles)
% hObject    handle to Live_Capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Live_Capture
 button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    %I = getcam(get(handles.Camera_select,'Value'));
    %setappdata(handles.axes_main, 'current_image', I);
    %set_image( getcam(get(handles.Camera_select,'Value')), 'current', handles);
   handles.imageplot=imagesc(getcamApex('SCam1'), [0 2^14-1]);
end


%linkaxes([ handles.axes_main handles.axes_left],'y');
%linkaxes([handles.axes_main handles.axes_bottom],'x');
function varargout = Viewscreen_Timer_Error(hObject, eventdata, handles)

if isfield(handles,'TimerHandle')
        stop(handles.TimerHandle);
        delete(handles.TimerHandle);
        rmappdata(0, 'LLRFTimer');
end

   

function Viewscreen_Timer_Callback (hObject, eventdata,handles)

Live_Capture_Callback(handles.Live_Capture, eventdata, handles);



% --- Outputs from this function are returned to the command line.
function varargout = prova_image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function imageBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate imageBox
