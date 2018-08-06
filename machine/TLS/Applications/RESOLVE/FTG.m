function varargout = FTG(varargin)
% FTG MATLAB code for FTG.fig
%      FTG, by itself, creates a new FTG or raises the existing
%      singleton*.
%
%      H = FTG returns the handle to a new FTG or the handle to
%      the existing singleton*.
%
%      FTG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FTG.M with the given input arguments.
%
%      FTG('Property','Value',...) creates a new FTG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FTG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FTG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FTG

% Last Modified by GUIDE v2.5 12-May-2011 15:14:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FTG_OpeningFcn, ...
                   'gui_OutputFcn',  @FTG_OutputFcn, ...
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


% --- Executes just before FTG is made visible.
function FTG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FTG (see VARARGIN)

% Choose default command line output for FTG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
switch2physics;

% UIWAIT makes FTG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FTG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
RGB = imread('FTG.bmp');
image(RGB);
set(gca,'Visible','Off');
set(gca,'Color','None');
set(gca,'XMinorTick','Off');
set(gca,'XMinorGrid','Off');
set(gca,'YMinorTick','Off');
set(gca,'YMinorGrid','Off');
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
% Hint: place code in OpeningFcn to populate axes1


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename= get(handles.Lattice_M,'UserData');
load(filename);
M2R(ConfigSetpoint,handles);
filename = get(handles.BPM_M,'UserData');
load(filename);
M2R_BPM(ConfigMonitor,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% filename = get(handles.Lattice_M,'UserData');
% load(filename);
[filename,pathname] = uiputfile('*.mat');
set(handles.pushbutton2,'UserData',[pathname,filename]);
R2M(handles);
R2M_BPM(handles);

% --- Executes on button press in Lattice_M.
function Lattice_M_Callback(hObject, eventdata, handles)
% hObject    handle to Lattice_M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.mat');
set(handles.Lattice_M,'UserData',[pathname,filename]);

% --- Executes on button press in Lattice_R.
function Lattice_R_Callback(hObject, eventdata, handles)
% hObject    handle to Lattice_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.resolve');
set(handles.Lattice_R,'UserData',[pathname,filename]);



% --- Executes on button press in BPM_M.
function BPM_M_Callback(hObject, eventdata, handles)
% hObject    handle to BPM_M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.mat');
set(handles.BPM_M,'UserData',[pathname,filename]);

% --- Executes on button press in BPM_R.
function BPM_R_Callback(hObject, eventdata, handles)
% hObject    handle to BPM_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('*.bpm');
set(handles.BPM_R,'UserData',[pathname,filename]);



function M2R(ConfigSetpoint,handles)
filename = get(handles.Lattice_R,'UserData');
fid = fopen(filename,'r+');
[filename,pathname] = uiputfile('*.resolve');
fid2 = fopen([pathname,filename],'w');
tline = fgetl(fid);
while ischar(tline)
% disp(tline);
if isempty(strfind(tline,'QUAD'))==0
    Quad = sscanf(tline(1:strfind(tline,':')-1),'%s');
    fprintf(fid2,'%s\n',tline);
    tline = fgetl(fid);
    fprintf(fid2,'%s\n',tline);
    tline = fgetl(fid);
    Str = tline(1:strfind(tline,'='));
    Data = num2str(ConfigSetpoint.(Quad).Setpoint.Data*getbrho*10);    
    fprintf(fid2,'%s\n',[Str,'   ',Data(1,:),'     ;']);
    ConfigSetpoint.(Quad).Setpoint.Data(1,:) = [];
elseif isempty(strfind(tline,'SEXT'))==0
    Sext = sscanf(tline(1:strfind(tline,':')-1),'%s');
    fprintf(fid2,'%s\n',tline);
    tline = fgetl(fid);
    fprintf(fid2,'%s\n',tline);
    tline = fgetl(fid);
    Str = tline(1:strfind(tline,'='));
    Data = num2str(ConfigSetpoint.(Sext).Setpoint.Data*getbrho*10);    
    fprintf(fid2,'%s\n',[Str,'   ',Data(1,:),'     ,']);
    ConfigSetpoint.(Sext).Setpoint.Data(1,:) = [];
% elseif isempty(strfind(tline,'BEND'))==0
%     Bend = sscanf(tline(1:strfind(tline,':')-1),'%s');
%     fprintf(fid2,'%s\n',tline);
%     tline = fgetl(fid);
%     fprintf(fid2,'%s\n',tline);
%     tline = fgetl(fid);
%     Str = tline(1:strfind(tline,'='));
%     if strfind(Bend,'KICKER')==0
%         Data = num2str(ConfigSetpoint.(Bend).Setpoint.Data*getbrho*10);
%         fprintf(fid2,'%s\n',[Str,'   ',Data,'     ;']);
%     else
%         fprintf(fid2,'%s\n',tline);
%     end
elseif isempty(strfind(tline,'XCOR'))==0
    Xcor = sscanf(tline(1:strfind(tline,':')-1),'%s');
    fprintf(fid2,'%s\n',tline);
    tline = fgetl(fid);
    Str = tline(1:strfind(tline,'='));
    Data = num2str(ConfigSetpoint.HCM.Setpoint.Data);
    fprintf(fid2,'%s\n',[Str,'   ',Data(1,:),'     ;']);
    ConfigSetpoint.HCM.Setpoint.Data(1,:) = [];
elseif isempty(strfind(tline,'YCOR'))==0
    Ycor = sscanf(tline(1:strfind(tline,':')-1),'%s');
    fprintf(fid2,'%s\n',tline);
    tline = fgetl(fid);
    Str = tline(1:strfind(tline,'='));
    Data = num2str(ConfigSetpoint.VCM.Setpoint.Data);
    fprintf(fid2,'%s\n',[Str,'   ',Data(1,:),'     ;']);
    ConfigSetpoint.VCM.Setpoint.Data(1,:) = [];
else
    fprintf(fid2,'%s\n',tline);
end
tline = fgetl(fid);
end
fclose(fid);
fclose(fid2);




function M2R_BPM(ConfigMonitor,handles)
filename = get(handles.BPM_R,'UserData');
fid = fopen(filename,'r+');
[filename,pathname] = uiputfile('*.bpm');
fid2 = fopen([pathname,filename],'w');
tline = fgetl(fid);
fprintf(fid2,'%s\n',tline);
tline = fgetl(fid);
fprintf(fid2,'%s\n',tline);
tline = fgetl(fid);
i = 1;
while ischar(tline)
% disp(tline);
if  isempty(tline)==0
    DataX = sprintf('%.15f',ConfigMonitor.BPMx.Monitor.Data(i));
    DataY = sprintf('%.15f',ConfigMonitor.BPMy.Monitor.Data(i));
    spos = getspos('BPMx');
    fprintf(fid2,'%s\n',[DataX,' ',DataY,' ',sprintf('%.6f',spos(i))]);
    i = i+1;
else
    fprintf(fid2,'%s\n',tline);
end
tline = fgetl(fid);
end
fclose(fid);
fclose(fid2);



function R2M_BPM(handles)
filename = get(handles.BPM_R,'UserData');
fid = fopen(filename,'r+');
Lattcie = get(handles.pushbutton2,'UserData');
load(Lattcie);
tline = fgetl(fid);
tline = fgetl(fid);
tline = fgetl(fid);
i = 1;
while ischar(tline)
% disp(tline);
if  isempty(tline)==0
    x = strfind(tline,' ');
    DataX = sscanf(tline(1:x(1)-1),'%f');
    DataY = sscanf(tline(x(1)+1:x(2)-1),'%f');
    ConfigMonitor.BPMx.Monitor.Data(i) = DataX;
    ConfigMonitor.BPMy.Monitor.Data(i) = DataY;
    i = i+1;
end
tline = fgetl(fid);
end
fclose(fid);
filename = get(handles.pushbutton2,'UserData');
save(filename, 'ConfigSetpoint','ConfigMonitor');

function R2M(handles)
filename = get(handles.Lattice_R,'UserData');
fid = fopen(filename,'r+');
filename = get(handles.Lattice_M,'UserData');
load(filename);
QUAD = findmemberof('QUAD');
SEXT = findmemberof('SEXT');
for i=1:length(QUAD)
    ConfigSetpoint.(cell2mat(QUAD(i))).Setpoint.Data = [];
    ConfigMonitor.(cell2mat(QUAD(i))).Monitor.Data = [];
end
for i=1:length(SEXT)
    ConfigSetpoint.(cell2mat(SEXT(i))).Setpoint.Data = [];
    ConfigMonitor.(cell2mat(SEXT(i))).Monitor.Data = [];
end
ConfigSetpoint.HCM.Setpoint.Data = [];
ConfigMonitor.HCM.Monitor.Data = [];
ConfigSetpoint.VCM.Setpoint.Data = [];
ConfigMonitor.VCM.Monitor.Data = [];
tline = fgetl(fid);
while ischar(tline)
if isempty(strfind(tline,'QUAD'))==0
    Quad = sscanf(tline(1:strfind(tline,':')-1),'%s');
    tline = fgetl(fid);
    tline = fgetl(fid);
    Data = sscanf(tline(strfind(tline,'=')+1:strfind(tline,';')-1),'%f');
    ConfigSetpoint.(Quad).Setpoint.Data = cat(1,ConfigSetpoint.(Quad).Setpoint.Data,Data/10/getbrho);
    ConfigMonitor.(Quad).Monitor.Data = cat(1,ConfigMonitor.(Quad).Monitor.Data,Data/10/getbrho);
elseif isempty(strfind(tline,'SEXT'))==0
    Sext = sscanf(tline(1:strfind(tline,':')-1),'%s');
    tline = fgetl(fid);
    tline = fgetl(fid);
    Data = sscanf(tline(strfind(tline,'=')+1:strfind(tline,';')-1),'%f');
    if isempty(Data)
        Data = sscanf(tline(strfind(tline,'=')+1:strfind(tline,',')-1),'%f');
    end
    ConfigSetpoint.(Sext).Setpoint.Data = cat(1,ConfigSetpoint.(Sext).Setpoint.Data,Data/10/getbrho);
    ConfigMonitor.(Sext).Monitor.Data = cat(1,ConfigMonitor.(Sext).Monitor.Data,Data/10/getbrho);
% elseif isempty(strfind(tline,'BEND'))==0
%     Bend = sscanf(tline(1:strfind(tline,':')-1),'%s');
%     fprintf(fid2,'%s\n',tline);
%     tline = fgetl(fid);
%     fprintf(fid2,'%s\n',tline);
%     tline = fgetl(fid);
%     Str = tline(1:strfind(tline,'='));
%     if strfind(Bend,'KICKER')==0
%         Data = num2str(ConfigSetpoint.(Bend).Setpoint.Data*getbrho*10);
%         fprintf(fid2,'%s\n',[Str,'   ',Data,'     ;']);
%     else
%         fprintf(fid2,'%s\n',tline);
%     end
elseif isempty(strfind(tline,'XCOR'))==0
    Xcor = sscanf(tline(1:strfind(tline,':')-1),'%s');
    tline = fgetl(fid);
    Data = sscanf(tline(strfind(tline,'=')+1:strfind(tline,';')-1),'%f');
    ConfigSetpoint.HCM.Setpoint.Data = cat(1,ConfigSetpoint.HCM.Setpoint.Data,Data);
    ConfigMonitor.HCM.Monitor.Data = cat(1,ConfigMonitor.HCM.Monitor.Data,Data);
elseif isempty(strfind(tline,'YCOR'))==0
    Ycor = sscanf(tline(1:strfind(tline,':')-1),'%s');
    tline = fgetl(fid);
    Data = sscanf(tline(strfind(tline,'=')+1:strfind(tline,';')-1),'%f');
    ConfigSetpoint.VCM.Setpoint.Data = cat(1,ConfigSetpoint.VCM.Setpoint.Data,Data);
    ConfigMonitor.VCM.Monitor.Data = cat(1,ConfigMonitor.VCM.Monitor.Data,Data);
end
tline = fgetl(fid);
end
fclose(fid);
filename = get(handles.pushbutton2,'UserData');
save(filename, 'ConfigSetpoint','ConfigMonitor');
