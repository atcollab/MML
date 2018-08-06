function varargout = apexmain(varargin)
% APEXMAIN MATLAB code for apexmain.fig
%      APEXMAIN, by itself, creates a new APEXMAIN or raises the existing
%      singleton*.
%
%      H = APEXMAIN returns the handle to a new APEXMAIN or the handle to
%      the existing singleton*.
%
%      APEXMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APEXMAIN.M with the given input arguments.
%
%      APEXMAIN('Property','Value',...) creates a new APEXMAIN or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before apexmain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to apexmain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help apexmain

% Last Modified by GUIDE v2.5 30-Mar-2011 23:42:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @apexmain_OpeningFcn, ...
                   'gui_OutputFcn',  @apexmain_OutputFcn, ...
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

% --- Executes just before apexmain is made visible.
function apexmain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to apexmain (see VARARGIN)

% Choose default command line output for apexmain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles);

% UIWAIT makes apexmain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = apexmain_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in calculate.
function Gun_Callback(hObject, eventdata, handles)


% --- Executes on button press in Solenoids.
function Solenoids_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles)

% Background image


ButtonDownFcn = get(handles.BackgroundAxes, 'ButtonDownFcn');

ImData = imread('APEX_Layout_PhaseI.png');
h = image(ImData, 'Parent', handles.BackgroundAxes);
axis(handles.BackgroundAxes, 'image');
set(handles.BackgroundAxes, 'XTickLabel', []);
set(handles.BackgroundAxes, 'YTickLabel', []);
set(handles.BackgroundAxes, 'XTick', []);
set(handles.BackgroundAxes, 'YTick', []);
 
set(h, 'ButtonDownFcn', ButtonDownFcn);
set(handles.BackgroundAxes, 'ButtonDownFcn', ButtonDownFcn);

%Launcher_Callback(hObject, eventdata, handles)

% Update handles structure
% guidata(handles.figure1, handles);


% --- Executes on button press in Emittance.
function Emittance_Callback(hObject, eventdata, handles)



% --- Executes on button press in Emittance.
function Launcher_Callback(hObject, eventdata, handles)
% Look for where mouse is on the image

figure1_CurrentPoint = get(handles.figure1, 'CurrentPoint')
Axes_CurrentPoint = get(handles.BackgroundAxes, 'CurrentPoint')
