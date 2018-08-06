function varargout = OptCtrl_bts_tls(varargin)
% OptCtrl_bts_tls MATLAB code for OptCtrl_bts_tls.fig
%      OptCtrl_bts_tls, by itself, creates a new OptCtrl_bts_tls or raises the existing
%      singleton*.
%
%      H = OptCtrl_bts_tls returns the handle to a new OptCtrl_bts_tls or the handle to
%      the existing singleton*.
%
%      OptCtrl_bts_tls('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OptCtrl_bts_tls.M with the given input arguments.
%
%      OptCtrl_bts_tls('Property','Value',...) creates a new OptCtrl_bts_tls or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OptCtrl_bts_tls_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OptCtrl_bts_tls_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OptCtrl_bts_tls

% Last Modified by GUIDE v2.5 14-May-2012 11:38:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OptCtrl_bts_tls_OpeningFcn, ...
                   'gui_OutputFcn',  @OptCtrl_bts_tls_OutputFcn, ...
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


% --- Executes just before OptCtrl_bts_tls is made visible.
function OptCtrl_bts_tls_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OptCtrl_bts_tls (see VARARGIN)

% Choose default command line output for OptCtrl_bts_tls
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
switch2physics;
plotoptics(handles);
set(handles.QM1,'String',getsp('QM',[1 1]));
set(handles.QM1S,'Value',getsp('QM',[1 1]));
set(handles.QM2,'String',getsp('QM',[1 2]));
set(handles.QM2S,'Value',getsp('QM',[1 2]));
set(handles.QM3,'String',getsp('QM',[1 3]));
set(handles.QM3S,'Value',getsp('QM',[1 3]));
set(handles.QM4,'String',getsp('QM',[1 4]));
set(handles.QM4S,'Value',getsp('QM',[1 4]));
set(handles.QM5,'String',getsp('QM',[1 5]));
set(handles.QM5S,'Value',getsp('QM',[1 5]));
set(handles.QM6,'String',getsp('QM',[1 6]));
set(handles.QM6S,'Value',getsp('QM',[1 6]));
set(handles.QM7,'String',getsp('QM',[1 7]));
set(handles.QM7S,'Value',getsp('QM',[1 7]));
set(handles.QM8,'String',getsp('QM',[1 8]));
set(handles.QM8S,'Value',getsp('QM',[1 8]));
set(handles.QM9,'String',getsp('QM',[1 9]));
set(handles.QM9S,'Value',getsp('QM',[1 9]));
set(handles.QM10,'String',getsp('QM',[1 10]));
set(handles.QM10S,'Value',getsp('QM',[1 10]));
set(handles.QM11,'String',getsp('QM',[1 11]));
set(handles.QM11S,'Value',getsp('QM',[1 11]));
set(handles.QM12,'String',getsp('QM',[1 12]));
set(handles.QM12S,'Value',getsp('QM',[1 12]));
set(handles.QM13,'String',getsp('QM',[1 13]));
set(handles.QM13S,'Value',getsp('QM',[1 13]));
set(handles.QM14,'String',getsp('QM',[1 14]));
set(handles.QM14S,'Value',getsp('QM',[1 14]));
set(handles.QM15,'String',getsp('QM',[1 15]));
set(handles.QM15S,'Value',getsp('QM',[1 15]));
set(handles.QM16,'String',getsp('QM',[1 16]));
set(handles.QM16S,'Value',getsp('QM',[1 16]));
set(handles.QM17,'String',getsp('QM',[1 17]));
set(handles.QM17S,'Value',getsp('QM',[1 17]));
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax,'String',num2str(AlfaX(1)));
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay,'String',num2str(AlfaY(1)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax,'String',num2str(BetaX(1)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay,'String',num2str(BetaY(1)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx,'String',num2str(EtaX(1)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy,'String',num2str(EtaY(1)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx,'String',num2str(EtaPX(1)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy,'String',num2str(EtaPY(1)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% UIWAIT makes OptCtrl_bts_tls wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OptCtrl_bts_tls_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function [ax, h1, h2] = plotoptics(handles)
%PLOTTWISS - Plot the optical functions and tune of the present lattice


%[TD, Tune] = twissring(RING,0,1:(length(RING)+1),'chrom');

[BetaX, BetaY, Sx, Sy, Tune] = modeltwiss('Beta', 'All');
%BetaX(1), BetaY(1)

[EtaX, EtaY] = modeltwiss('Eta', 'All');
%EtaX(1), EtaY(1)

[N, Nsymmetry] = getnumberofsectors;
L = getfamilydata('Circumference');
Lsector = L / Nsymmetry;

i = 1:length(Sx);
i(find(Sx > Lsector)) = [];
% i(end+1) = i(end) + 1;   % 2009/11/15

%figure
% clf reset;
axes(handles.axes1);
[ax,h1,h2] = plotyy(Sx(i), [BetaX(i) BetaY(i)], Sx(i), [EtaX(i) EtaY(i)]);

xlabel('Position [meters]');
%ylabel('[meters]');
title('Optical Functions');
%axis tight;

set(get(ax(1),'ylabel'),'string','{\it\beta}  [meters]');
%set(get(ax(1),'ylabel'),'string','{\it\beta_x}   {\it\beta_y  [meters]}');
set(get(ax(2),'ylabel'),'string','{\it\eta [meters]}');


% Plot 1 sector
axes(ax(2));
%axis tight;
a2 = axis;
if ~isempty(L) && ~isempty(N)
    a2(1) = 0;
    a2(2) = Lsector;
end

% Make room for the lattice
DeltaY = a2(4) - a2(3);
a2(3) = a2(3) - .12 * DeltaY;
%a2(4) = a2(4) + .08 * DeltaY;
axis(a2);

axes(ax(1));
%axis tight
a1 = axis;
if ~isempty(L) && ~isempty(N)
    a1(2) = Lsector;
end

% Make room for the lattice
DeltaY = a1(4) - a1(3);
a1(3) = a1(3) - .12 * DeltaY;
%a1(4) = a1(4) + .08 * DeltaY;
axis([a2(1:2) a1(3:4)]);


% Draw the lattice
a = axis;
hold on;
drawlattice(a(3)+.06*DeltaY, .05*DeltaY, ax(1), Lsector);
axis(a);
hold off;


legend('{\it\beta_x}', '{\it\beta_y }', 0);

ax(end+1) = gca;
% linkaxes(ax, 'x');

axes(ax(2));



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM1_Callback(hObject, eventdata, handles)
% hObject    handle to QM1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM1,'String'));
set(handles.QM1S,'Value',Value);
setsp('QM',Value,[1 1]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM1 as text
%        str2double(get(hObject,'String')) returns contents of QM1 as a double


% --- Executes during object creation, after setting all properties.
function QM1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM2_Callback(hObject, eventdata, handles)
% hObject    handle to QM2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM2,'String'));
set(handles.QM2S,'Value',Value);
setsp('QM',Value,[1 2]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM2 as text
%        str2double(get(hObject,'String')) returns contents of QM2 as a double


% --- Executes during object creation, after setting all properties.
function QM2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM3_Callback(hObject, eventdata, handles)
% hObject    handle to QM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM3,'String'));
set(handles.QM3S,'Value',Value);
setsp('QM',Value,[1 3]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM3 as text
%        str2double(get(hObject,'String')) returns contents of QM3 as a double


% --- Executes during object creation, after setting all properties.
function QM3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM5_Callback(hObject, eventdata, handles)
% hObject    handle to QM5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM5,'String'));
set(handles.QM5S,'Value',Value);
setsp('QM',Value,[1 5]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM5 as text
%        str2double(get(hObject,'String')) returns contents of QM5 as a double


% --- Executes during object creation, after setting all properties.
function QM5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Q3B_Callback(hObject, eventdata, handles)
% hObject    handle to Q3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.Q3B,'String'));
set(handles.Q3BS,'Value',Value);
setsp('Q3B',Value);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
% Hints: get(hObject,'String') returns contents of Q3B as text
%        str2double(get(hObject,'String')) returns contents of Q3B as a double


% --- Executes during object creation, after setting all properties.
function Q3B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM4_Callback(hObject, eventdata, handles)
% hObject    handle to QM4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM4,'String'));
set(handles.QM4S,'Value',Value);
setsp('QM',Value,[1 4]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM4 as text
%        str2double(get(hObject,'String')) returns contents of QM4 as a double


% --- Executes during object creation, after setting all properties.
function QM4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM6_Callback(hObject, eventdata, handles)
% hObject    handle to QM6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM6,'String'));
set(handles.QM6S,'Value',Value);
setsp('QM',Value,[1 6]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM6 as text
%        str2double(get(hObject,'String')) returns contents of QM6 as a double


% --- Executes during object creation, after setting all properties.
function QM6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM7_Callback(hObject, eventdata, handles)
% hObject    handle to QM7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM7,'String'));
set(handles.QM7S,'Value',Value);
setsp('QM',Value,[1 7]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM7 as text
%        str2double(get(hObject,'String')) returns contents of QM7 as a double


% --- Executes during object creation, after setting all properties.
function QM7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Q4B_Callback(hObject, eventdata, handles)
% hObject    handle to Q4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.Q4B,'String'));
set(handles.Q4BS,'Value',Value);
setsp('Q4B',Value);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
% Hints: get(hObject,'String') returns contents of Q4B as text
%        str2double(get(hObject,'String')) returns contents of Q4B as a double


% --- Executes during object creation, after setting all properties.
function Q4B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Q4A_Callback(hObject, eventdata, handles)
% hObject    handle to Q4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.Q4A,'String'));
set(handles.Q4AS,'Value',Value);
setsp('Q4A',Value);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
% Hints: get(hObject,'String') returns contents of Q4A as text
%        str2double(get(hObject,'String')) returns contents of Q4A as a double


% --- Executes during object creation, after setting all properties.
function Q4A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM1S_Callback(hObject, eventdata, handles)
% hObject    handle to QM1S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM1S,'Value');
set(handles.QM1,'String',Value);
setsp('QM',Value,[1 1]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM1S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM1S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function QM2S_Callback(hObject, eventdata, handles)
% hObject    handle to QM2S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM2S,'Value');
set(handles.QM2,'String',Value);
setsp('QM',Value,[1 2]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM2S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM2S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM3S_Callback(hObject, eventdata, handles)
% hObject    handle to QM3S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM3S,'Value');
set(handles.QM3,'String',Value);
setsp('QM',Value,[1 3]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM3S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM3S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM4S_Callback(hObject, eventdata, handles)
% hObject    handle to QM4S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM4S,'Value');
set(handles.QM4,'String',Value);
setsp('QM',Value,[1 4]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM4S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM4S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM5S_Callback(hObject, eventdata, handles)
% hObject    handle to QM5S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM5S,'Value');
set(handles.QM5,'String',Value);
setsp('QM',Value,[1 5]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM5S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM5S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM6S_Callback(hObject, eventdata, handles)
% hObject    handle to QM6S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM6S,'Value');
set(handles.QM6,'String',Value);
setsp('QM',Value,[1 6]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM6S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM6S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM7S_Callback(hObject, eventdata, handles)
% hObject    handle to QM7S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM7S,'Value');
set(handles.QM7,'String',Value);
setsp('QM',Value,[1 7]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM7S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM7S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Q3BS_Callback(hObject, eventdata, handles)
% hObject    handle to Q3BS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.Q3BS,'Value');
set(handles.Q3B,'String',Value);
setsp('Q3B',Value);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Q3BS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q3BS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Q4AS_Callback(hObject, eventdata, handles)
% hObject    handle to Q4AS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.Q4AS,'Value');
set(handles.Q4A,'String',Value);
setsp('Q4A',Value);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Q4AS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q4AS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Q4BS_Callback(hObject, eventdata, handles)
% hObject    handle to Q4BS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.Q4BS,'Value');
set(handles.Q4B,'String',Value);
setsp('Q4B',Value);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Q4BS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q4BS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alfax_Callback(hObject, eventdata, handles)
% hObject    handle to alfax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THERING
THERING{1}.TwissData.alpha(1) = str2num(get(handles.alfax,'String'));
plotoptics(handles);
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of alfax as text
%        str2double(get(hObject,'String')) returns contents of alfax as a double


% --- Executes during object creation, after setting all properties.
function alfax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alfax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betax_Callback(hObject, eventdata, handles)
% hObject    handle to betax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THERING
THERING{1}.TwissData.beta(1) = str2num(get(handles.betax,'String'));
plotoptics(handles);
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of betax as text
%        str2double(get(hObject,'String')) returns contents of betax as a double


% --- Executes during object creation, after setting all properties.
function betax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dx_Callback(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THERING
THERING{1}.TwissData.Dispersion(1) = str2num(get(handles.dx,'String'));
plotoptics(handles);
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of dx as text
%        str2double(get(hObject,'String')) returns contents of dx as a double


% --- Executes during object creation, after setting all properties.
function dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alfay_Callback(hObject, eventdata, handles)
% hObject    handle to alfay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THERING
THERING{1}.TwissData.alpha(2) = str2num(get(handles.alfay,'String'));
plotoptics(handles);
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of alfay as text
%        str2double(get(hObject,'String')) returns contents of alfay as a double


% --- Executes during object creation, after setting all properties.
function alfay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alfay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betay_Callback(hObject, eventdata, handles)
% hObject    handle to betay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THERING
THERING{1}.TwissData.beta(2) = str2num(get(handles.betay,'String'));
plotoptics(handles);
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of betay as text
%        str2double(get(hObject,'String')) returns contents of betay as a double


% --- Executes during object creation, after setting all properties.
function betay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dy_Callback(hObject, eventdata, handles)
% hObject    handle to dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global THERING
% THERING{1}.TwissData.Dispersion(3) = str2num(get(handles.dy,'String'));
% plotoptics(handles);
% [AlfaX, AlfaY] = modeltwiss('alpha');
% [BetaX, BetaY] = modeltwiss('beta');
% [EtaX, EtaY] = modeltwiss('eta');
% set(handles.alfax2,'String',num2str(AlfaX(end)));
% set(handles.alfay2,'String',num2str(AlfaY(end)));
% set(handles.betax2,'String',num2str(BetaX(end)));
% set(handles.betay2,'String',num2str(BetaY(end)));
% set(handles.dx2,'String',num2str(EtaX(end)));
% set(handles.dy2,'String',num2str(EtaY(end)));
% Hints: get(hObject,'String') returns contents of dy as text
%        str2double(get(hObject,'String')) returns contents of dy as a double


% --- Executes during object creation, after setting all properties.
function dy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alfax2_Callback(hObject, eventdata, handles)
% hObject    handle to alfax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alfax2 as text
%        str2double(get(hObject,'String')) returns contents of alfax2 as a double


% --- Executes during object creation, after setting all properties.
function alfax2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alfax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betax2_Callback(hObject, eventdata, handles)
% hObject    handle to betax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betax2 as text
%        str2double(get(hObject,'String')) returns contents of betax2 as a double


% --- Executes during object creation, after setting all properties.
function betax2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dx2_Callback(hObject, eventdata, handles)
% hObject    handle to dx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx2 as text
%        str2double(get(hObject,'String')) returns contents of dx2 as a double


% --- Executes during object creation, after setting all properties.
function dx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alfay2_Callback(hObject, eventdata, handles)
% hObject    handle to alfay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alfay2 as text
%        str2double(get(hObject,'String')) returns contents of alfay2 as a double


% --- Executes during object creation, after setting all properties.
function alfay2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alfay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betay2_Callback(hObject, eventdata, handles)
% hObject    handle to betay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betay2 as text
%        str2double(get(hObject,'String')) returns contents of betay2 as a double


% --- Executes during object creation, after setting all properties.
function betay2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dy2_Callback(hObject, eventdata, handles)
% hObject    handle to dy2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy2 as text
%        str2double(get(hObject,'String')) returns contents of dy2 as a double


% --- Executes during object creation, after setting all properties.
function dy2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit49 as text
%        str2double(get(hObject,'String')) returns contents of edit49 as a double


% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dx22_Callback(hObject, eventdata, handles)
% hObject    handle to dx22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx22 as text
%        str2double(get(hObject,'String')) returns contents of dx22 as a double


% --- Executes during object creation, after setting all properties.
function dx22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double


% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dy22_Callback(hObject, eventdata, handles)
% hObject    handle to dy22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy22 as text
%        str2double(get(hObject,'String')) returns contents of dy22 as a double


% --- Executes during object creation, after setting all properties.
function dy22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit47 as text
%        str2double(get(hObject,'String')) returns contents of edit47 as a double


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ddx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ddx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ddy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ddy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ddx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ddx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ddy2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ddy2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ddx_Callback(hObject, eventdata, handles)
% hObject    handle to ddx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THERING
THERING{1}.TwissData.Dispersion(2) = str2num(get(handles.ddx,'String'));
plotoptics(handles);
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of ddx as text
%        str2double(get(hObject,'String')) returns contents of ddx as a double



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double


% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit55_Callback(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit55 as text
%        str2double(get(hObject,'String')) returns contents of edit55 as a double


% --- Executes during object creation, after setting all properties.
function edit55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit56_Callback(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit56 as text
%        str2double(get(hObject,'String')) returns contents of edit56 as a double


% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit57_Callback(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit57 as text
%        str2double(get(hObject,'String')) returns contents of edit57 as a double


% --- Executes during object creation, after setting all properties.
function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit58 as text
%        str2double(get(hObject,'String')) returns contents of edit58 as a double


% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM8_Callback(hObject, eventdata, handles)
% hObject    handle to QM8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM8,'String'));
set(handles.QM8S,'Value',Value);
setsp('QM',Value,[1 8]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM8 as text
%        str2double(get(hObject,'String')) returns contents of QM8 as a double


% --- Executes during object creation, after setting all properties.
function QM8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM9_Callback(hObject, eventdata, handles)
% hObject    handle to QM9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM9,'String'));
set(handles.QM9S,'Value',Value);
setsp('QM',Value,[1 9]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM9 as text
%        str2double(get(hObject,'String')) returns contents of QM9 as a double


% --- Executes during object creation, after setting all properties.
function QM9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM10_Callback(hObject, eventdata, handles)
% hObject    handle to QM10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM10,'String'));
set(handles.QM10S,'Value',Value);
setsp('QM',Value,[1 10]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM10 as text
%        str2double(get(hObject,'String')) returns contents of QM10 as a double


% --- Executes during object creation, after setting all properties.
function QM10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM12_Callback(hObject, eventdata, handles)
% hObject    handle to QM12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM12,'String'));
set(handles.QM12S,'Value',Value);
setsp('QM',Value,[1 12]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM12 as text
%        str2double(get(hObject,'String')) returns contents of QM12 as a double


% --- Executes during object creation, after setting all properties.
function QM12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM11_Callback(hObject, eventdata, handles)
% hObject    handle to QM11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM11,'String'));
set(handles.QM11S,'Value',Value);
setsp('QM',Value,[1 11]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM11 as text
%        str2double(get(hObject,'String')) returns contents of QM11 as a double


% --- Executes during object creation, after setting all properties.
function QM11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM13_Callback(hObject, eventdata, handles)
% hObject    handle to QM13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM13,'String'));
set(handles.QM13S,'Value',Value);
setsp('QM',Value,[1 13]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM13 as text
%        str2double(get(hObject,'String')) returns contents of QM13 as a double


% --- Executes during object creation, after setting all properties.
function QM13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function QM8S_Callback(hObject, eventdata, handles)
% hObject    handle to QM8S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM8S,'Value');
set(handles.QM8,'String',Value);
setsp('QM',Value,[1 8]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM8S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM8S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM9S_Callback(hObject, eventdata, handles)
% hObject    handle to QM9S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM9S,'Value');
set(handles.QM9,'String',Value);
setsp('QM',Value,[1 9]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM9S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM9S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM10S_Callback(hObject, eventdata, handles)
% hObject    handle to QM10S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM10S,'Value');
set(handles.QM10,'String',Value);
setsp('QM',Value,[1 10]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM10S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM10S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM11S_Callback(hObject, eventdata, handles)
% hObject    handle to QM11S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM11S,'Value');
set(handles.QM11,'String',Value);
setsp('QM',Value,[1 11]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM11S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM11S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM12S_Callback(hObject, eventdata, handles)
% hObject    handle to QM12S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM12S,'Value');
set(handles.QM12,'String',Value);
setsp('QM',Value,[1 12]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM12S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM12S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM13S_Callback(hObject, eventdata, handles)
% hObject    handle to QM13S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM13S,'Value');
set(handles.QM13,'String',Value);
setsp('QM',Value,[1 13]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM13S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM13S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double


% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit68_Callback(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit68 as text
%        str2double(get(hObject,'String')) returns contents of edit68 as a double


% --- Executes during object creation, after setting all properties.
function edit68_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit68 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit69_Callback(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit69 as text
%        str2double(get(hObject,'String')) returns contents of edit69 as a double


% --- Executes during object creation, after setting all properties.
function edit69_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit69 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit70_Callback(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit70 as text
%        str2double(get(hObject,'String')) returns contents of edit70 as a double


% --- Executes during object creation, after setting all properties.
function edit70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM14_Callback(hObject, eventdata, handles)
% hObject    handle to QM14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM14,'String'));
set(handles.QM14S,'Value',Value);
setsp('QM',Value,[1 14]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM14 as text
%        str2double(get(hObject,'String')) returns contents of QM14 as a double


% --- Executes during object creation, after setting all properties.
function QM14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM16_Callback(hObject, eventdata, handles)
% hObject    handle to QM16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM16,'String'));
set(handles.QM16S,'Value',Value);
setsp('QM',Value,[1 16]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM16 as text
%        str2double(get(hObject,'String')) returns contents of QM16 as a double


% --- Executes during object creation, after setting all properties.
function QM16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM15_Callback(hObject, eventdata, handles)
% hObject    handle to QM15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM15,'String'));
set(handles.QM15S,'Value',Value);
setsp('QM',Value,[1 15]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM15 as text
%        str2double(get(hObject,'String')) returns contents of QM15 as a double


% --- Executes during object creation, after setting all properties.
function QM15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QM17_Callback(hObject, eventdata, handles)
% hObject    handle to QM17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = str2num(get(handles.QM17,'String'));
set(handles.QM17S,'Value',Value);
setsp('QM',Value,[1 17]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'String') returns contents of QM17 as text
%        str2double(get(hObject,'String')) returns contents of QM17 as a double


% --- Executes during object creation, after setting all properties.
function QM17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function QM14S_Callback(hObject, eventdata, handles)
% hObject    handle to QM14S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM14S,'Value');
set(handles.QM14,'String',Value);
setsp('QM',Value,[1 14]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM14S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM14S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM15S_Callback(hObject, eventdata, handles)
% hObject    handle to QM15S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM15S,'Value');
set(handles.QM15,'String',Value);
setsp('QM',Value,[1 15]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM15S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM15S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM16S_Callback(hObject, eventdata, handles)
% hObject    handle to QM16S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM16S,'Value');
set(handles.QM16,'String',Value);
setsp('QM',Value,[1 16]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM16S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM16S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function QM17S_Callback(hObject, eventdata, handles)
% hObject    handle to QM17S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.QM17S,'Value');
set(handles.QM17,'String',Value);
setsp('QM',Value,[1 17]);
plotoptics(handles);
global THERING
[AlfaX, AlfaY] = modeltwiss('alpha');
[BetaX, BetaY] = modeltwiss('beta');
[EtaX, EtaY] = modeltwiss('eta');
[EtaPX, EtaPY] = modeltwiss('EtaPrime');
set(handles.alfax2,'String',num2str(AlfaX(end)));
set(handles.alfay2,'String',num2str(AlfaY(end)));
set(handles.betax2,'String',num2str(BetaX(end)));
set(handles.betay2,'String',num2str(BetaY(end)));
set(handles.dx2,'String',num2str(EtaX(end)));
set(handles.dy2,'String',num2str(EtaY(end)));
set(handles.ddx2,'String',num2str(EtaPX(end)));
set(handles.ddy2,'String',num2str(EtaPY(end)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function QM17S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QM17S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
