function varargout = booster(varargin)
% BOOSTER M-file for booster.fig
%      BOOSTER, by itself, creates a new BOOSTER or raises the existing
%      singleton*.
%
%      H = BOOSTER returns the handle to a new BOOSTER or the handle to
%      the existing singleton*.
%
%      BOOSTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOOSTER.M with the given input arguments.
%
%      BOOSTER('Property','Value',...) creates a new BOOSTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before booster_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to booster_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help booster

% Last Modified by GUIDE v2.5 29-Sep-2005 17:24:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @booster_OpeningFcn, ...
                   'gui_OutputFcn',  @booster_OutputFcn, ...
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


% --- Executes just before booster is made visible.
function booster_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to booster (see VARARGIN)

% Choose default command line output for booster
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes booster wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = booster_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in New_Orbit.
function New_Orbit_Callback(hObject, eventdata, handles)
% hObject    handle to New_Orbit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Stop;
Selected_BPMs=1:1:22;
%orbit=rand(22,1);
%axes(handles.Xinj)
%plot(Selected_BPMs,orbit)
liste={'xInj','zInj','xExt','zExt'};
Stop=0;
while Stop==0,
argout=tango_read_attributes('BOO/DG/BPM-Manager',liste);
Xinj=argout(1).value;
Zinj=argout(2).value;
Xext=argout(3).value;
Zext=argout(4).value;
axes(handles.Xinj);
plot(Xinj);title('X injection');
set(handles.Xinj,'XLim',[1 22]);
axes(handles.Zinj);
plot(Zinj);title('Z injection');
set(handles.Zinj,'XLim',[1 22]);
axes(handles.Xext);
plot(Xext);title('X extraction');
set(handles.Xext,'XLim',[1 22]);
axes(handles.Zext);
plot(Zext);title('Z extraction');
set(handles.Zext,'XLim',[1 22]);


pause(1);
end





% --- Executes on selection change in Dev_Name_Xcyc.
function Dev_Name_Xcyc_Callback(hObject, eventdata, handles)
% hObject    handle to Dev_Name_Xcyc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Dev_Name_Xcyc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dev_Name_Xcyc



% --- Executes during object creation, after setting all properties.
function Dev_Name_Xcyc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dev_Name_Xcyc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Dev_Name_Zcyc.
function Dev_Name_Zcyc_Callback(hObject, eventdata, handles)
% hObject    handle to Dev_Name_Zcyc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Dev_Name_Zcyc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Dev_Name_Zcyc


% --- Executes during object creation, after setting all properties.
function Dev_Name_Zcyc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dev_Name_Zcyc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function N_samples_Callback(hObject, eventdata, handles)
% hObject    handle to N_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_samples as text
%        str2double(get(hObject,'String')) returns contents of N_samples as a double


% --- Executes during object creation, after setting all properties.
function N_samples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Stop;
Stop=1;

