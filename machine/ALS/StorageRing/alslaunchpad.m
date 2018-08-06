function varargout = alslaunchpad(varargin)
% ALSLAUNCHPAD M-file for alslaunchpad.fig
%      ALSLAUNCHPAD, by itself, creates a new ALSLAUNCHPAD or raises the existing
%      singleton*.
%
%      H = ALSLAUNCHPAD returns the handle to a new ALSLAUNCHPAD or the handle to
%      the existing singleton*.
%
%      ALSLAUNCHPAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALSLAUNCHPAD.M with the given input arguments.
%
%      ALSLAUNCHPAD('Property','Value',...) creates a new ALSLAUNCHPAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before alslaunchpad_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to alslaunchpad_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help alslaunchpad

% Last Modified by GUIDE v2.5 07-Nov-2005 11:10:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @alslaunchpad_OpeningFcn, ...
                   'gui_OutputFcn',  @alslaunchpad_OutputFcn, ...
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


% --- Executes just before alslaunchpad is made visible.
function alslaunchpad_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to alslaunchpad (see VARARGIN)

% Choose default command line output for alslaunchpad
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes alslaunchpad wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = alslaunchpad_OutputFcn(hObject, eventdata, handles) 
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
srcontrol;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotfamily;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
srsetup;

