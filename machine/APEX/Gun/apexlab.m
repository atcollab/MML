function varargout = apexlab(varargin)
% APEXLAB MATLAB code for apexlab.fig
%      APEXLAB, by itself, creates a new APEXLAB or raises the existing
%      singleton*.
%
%      H = APEXLAB returns the handle to a new APEXLAB or the handle to
%      the existing singleton*.
%
%      APEXLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APEXLAB.M with the given input arguments.
%
%      APEXLAB('Property','Value',...) creates a new APEXLAB or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before apexlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to apexlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help apexlab

% Last Modified by GUIDE v2.5 28-Jun-2011 19:00:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @apexlab_OpeningFcn, ...
                   'gui_OutputFcn',  @apexlab_OutputFcn, ...
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

% --- Executes just before apexlab is made visible.
function apexlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to apexlab (see VARARGIN)

% Choose default command line output for apexlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles);

% UIWAIT makes apexlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = apexlab_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;



% --- Executes on button press in calculate.
function Gun_Callback(hObject, eventdata, handles)

llrf;


% --- Executes on button press in Solenoids.
function Solenoids_Callback(hObject, eventdata, handles)

fprintf('   Solenoid application coming soon.\n');


% --- Executes on button press in Emittance.
function Emittance_Callback(hObject, eventdata, handles)

fprintf('   Emmittance measurement application coming soon.\n');


% --- Executes on button press in Emittance.
function Launcher_Callback(hObject, eventdata, handles)
% Look for where mouse is on the image and possibly launch the appropriete application

%figure1_CurrentPoint = get(handles.figure1, 'CurrentPoint');
Axes_CurrentPoint = get(handles.BackgroundAxes, 'CurrentPoint');

x = Axes_CurrentPoint(1,1);
y = Axes_CurrentPoint(1,2);

%    0,    0 -> Top,    Left
% 1084, 2950 -> Bottom, Right
if x>218 && x<283 && y>45 && y<175
    fprintf('   Gun\n');
elseif x>842 && x<944 && y>74 && y<172
    fprintf('   Dipole\n');
elseif x>1027 && x<1067 && y>90 && y<133
    fprintf('   Beam dump #1\n');
elseif x>885 && x<930 && y>232 && y<280
    fprintf('   Beam dump #2\n');
else
    fprintf('   No function:  x=%.1f  y=%.1f\n', x, y);
end

    
    
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

%Position = get(handles.BackgroundAxes, 'Position');   % Points: -0.8471 4.2353 956.3294 254.9647

% Restore the button down function since it get cleared with the image command
set(h, 'ButtonDownFcn', ButtonDownFcn);
set(handles.BackgroundAxes, 'ButtonDownFcn', ButtonDownFcn);

% Update handles structure
% guidata(handles.figure1, handles);



% --- Executes on print menu.
function PrintMenu_Callback(hObject, eventdata, handles)
printdlg('-setup',handles.figure1);
%printdlg('-crossplatform',handles.figure1);


% --------------------------------------------------------------------
function CloseMenu_Callback(hObject, eventdata, handles)
delete(handles.figure1);


% --------------------------------------------------------------------
function PrintPreviewMenu_Callback(hObject, eventdata, handles)
printpreview(handles.figure1);


% --------------------------------------------------------------------
function OpenApexLab_Callback(hObject, eventdata, handles)
apexlab;


% --------------------------------------------------------------------
function OpenZtec1_Callback(hObject, eventdata, handles)

apex_waveforms;  % there is only one scope at the moment


% --------------------------------------------------------------------
function PrintELog_Callback(hObject, eventdata, handles)
%printelog(handles.figure1, 0);
printelog(gcf);
