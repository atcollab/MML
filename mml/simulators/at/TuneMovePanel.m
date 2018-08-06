function varargout = TuneMovePanel(varargin)
% TUNEMOVEPANEL M-file for TuneMovePanel.fig
%      TUNEMOVEPANEL, by itself, creates a new TUNEMOVEPANEL or raises the existing
%      singleton*.
%
%      H = TUNEMOVEPANEL returns the handle to a new TUNEMOVEPANEL or the handle to
%      the existing singleton*.
%
%      TUNEMOVEPANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUNEMOVEPANEL.M with the given input arguments.
%
%      TUNEMOVEPANEL('Property','Value',...) creates a new TUNEMOVEPANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TuneMovePanel_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TuneMovePanel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% To do: 
% 1. uitable redraws over and over (Java is questionable on linux/solaris)
% 2. make work online
%    * setpoints
%    * gettune
%    * match model to the machine for beta/tune etc?
% 3. figure - betax, betay label and dispersion on a different axis
%             could use plottwiss

% Edit the above text to modify the response to help TuneMovePanel

% Last Modified by GUIDE v2.5 28-Mar-2008 15:20:58


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TuneMovePanel_OpeningFcn, ...
                   'gui_OutputFcn',  @TuneMovePanel_OutputFcn, ...
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


% --- Executes just before TuneMovePanel is made visible.
function TuneMovePanel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TuneMovePanel (see VARARGIN)

% Choose default command line output for TuneMovePanel
handles.output = hObject;

% Update handles structure
%display('Launching Tune Move Panel ....');

theReset(hObject, eventdata, handles)

%tunespaceplot([18 18.5] , [8 8.5], 8, 4, handles.webAxe);

% UIWAIT makes TuneMovePanel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TuneMovePanel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function dqField_Callback(hObject, eventdata, handles)
% hObject    handle to dqField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function dqField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dqField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in qyUpButton.
function qyUpButton_Callback(hObject, eventdata, handles)
% hObject    handle to qyUpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dQx=0;
dQy=str2double(get(handles.dqField,'string'));
thesteptune(dQx,dQy);
UpdatePlot(hObject, handles);


% --- Executes on button press in qyDownButton.
function qyDownButton_Callback(hObject, eventdata, handles)
% hObject    handle to qyDownButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dQx=0;
dQy=str2double(get(handles.dqField,'string'));
thesteptune(dQx,-dQy);
UpdatePlot(hObject, handles);


% --- Executes on button press in qxUpButton.
function qxUpButton_Callback(hObject, eventdata, handles)
% hObject    handle to qxUpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dQx=str2double(get(handles.dqField,'string'));
dQy=0;
thesteptune(dQx,dQy);
UpdatePlot(hObject, handles);


% --- Executes on button press in qxDownButton.
function qxDownButton_Callback(hObject, eventdata, handles)
% hObject    handle to qxDownButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dQx=str2double(get(handles.dqField,'string'));
dQy=0;
thesteptune(-dQx,dQy);
UpdatePlot(hObject, handles);


% --------------------------------------------------------------------
function UpdatePlot(hObject, handles)
global THERING;
[TD, tune, chrom] = twissring(THERING,0,1:handles.L+1,'chrom', 1e-8);
BETA = cat(1,TD.beta);
S  = cat(1,TD.SPos);
Disp=cat(2,TD.Dispersion);

set(handles.betax,'YData',BETA(:,1));
set(handles.qxText,'String',num2str(tune(1)));

set(handles.betay,'YData',BETA(:,2));
set(handles.qyText,'String',num2str(tune(2)));

set(handles.dx, 'YData', 100*Disp(1,:)');

delete(handles.QDot);
handles.Qx = tune(1);
handles.Qy = tune(2);
handles.QDot = line('parent',handles.webAxe,'XData',handles.Qx,'YData',handles.Qy,'Marker','+','MarkerSize',12.0);
[name, val] = quad_getsetpoint;
%handles.figure1;
quad_table('title', name, val, [0.1 0.45 0.2 0.325]);
set(handles.cxText,'String',num2str(chrom(1)));
set(handles.cyText,'String',num2str(chrom(2)));
if handles.emitCalc
    %e = getemit(TD);
    e = calcemittance;
    set(handles.emitText,'String',num2str(e(1)));
else
    set(handles.emitText,'String','No Calc');
end
guidata(hObject,handles);


% --- Executes on button press in summaryButton.
function summaryButton_Callback(hObject, eventdata, handles)
% hObject    handle to summaryButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function optionsMeno_Callback(hObject, eventdata, handles)
% hObject    handle to optionsMeno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function betaAxe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betaAxe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in emitCheckBox.
function emitCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to emitCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    handles.emitCalc=true;
    %e = getemit(TD);
    e = calcemittance;
    set(handles.emitText,'String',num2str(e(1)));
else
    % checkbox is not checked-take approriate action
    handles.emitCalc=false;
end
guidata(hObject,handles);

function thesteptune(dqx, dqy)
if strcmpi(getfamilydata('Machine'), 'ALBA')
    ALBAsteptune(dqx, dqy, 'model');
else
    steptune([dqx; dqy], 'model');
end


% --------------------------------------------------------------------
function panelResetMenu_Callback(hObject, eventdata, handles)
% hObject    handle to panelResetMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.QDot);
delete(handles.betax);
delete(handles.betay);
delete(handles.dx);
theReset (hObject, eventdata, handles)


% --------------------------------------------------------------------
function theReset(hObject, eventdata, handles)
global THERING
handles.L = length(THERING);
[TD, tune] = twissring(THERING,0,1:handles.L+1);
if isnan(tune(1))
    tune(1) = .25;
end;
if isnan(tune(2))
    tune(2)=0.25;
end;

handles.spos = findspos(THERING,1:handles.L+1);
handles.betax  = line('parent',handles.betaAxe,'XData',handles.spos,'YData',0.*handles.spos,'Color','r');
handles.betay  = line('parent',handles.betaAxe,'XData',handles.spos,'YData',0.*handles.spos,'Color','b');
handles.dx     = line('parent',handles.betaAxe,'XData',handles.spos,'YData',0.*handles.spos,'Color','g');

if strcmpi(getfamilydata('Machine'), 'ALBA')
    drawlattice_local(handles, -1, 1);
else
    drawlattice_local(handles, -1, 1);
    %drawlattice(-1, 1, handles.betaAxe);
end

xlabel(handles.betaAxe,'s - position [m]');
ylabel(handles.betaAxe,'{\it\beta}  [m]    &    {\it\eta_x}  [cm]');
xaxis([0 handles.spos(handles.L+1)/4], handles.betaAxe);
guidata(hObject,handles);
handles.Qx = tune(1);
handles.Qy = tune(2);
handles.emitCalc = false;
handles.QDot = line('parent',handles.webAxe,'XData',handles.Qx,'YData',handles.Qy,'Marker','+');
UpdatePlot(hObject, handles);
handles.webAxe;
max_order= 5;
per = 4;
window = [tune(1)-0.255 tune(1)+0.255 tune(2)-0.255 tune(2)+0.255];
for i=max_order:-1:1,
    [k, tab] = reson(i,per,window);
    hold on;
end
hold off
axis(window);
handles.betaAxe;

set(handles.emitCheckBox, 'Value',0);
%guidata(hObject,handles);


% --------------------------------------------------------------------
function [handle] = drawlattice_local(hParent, Offset, Scaling)
%DRAWLATTICE - Draws the AT lattice to a figure
%  drawlattice(Offset, Scaling)

%  Written by Greg Portmann

if nargin < 2
    Offset = 0;
end
Offset = Offset(1);
if nargin < 3
    Scaling = 1;
end
Scaling = Scaling(1);

global THERING

SPositions = findspos(THERING, 1:length(THERING)+1);
L = SPositions(end);
line('parent',hParent.betaAxe,'XData',[0 L],'YData',[0 0]+Offset,'Color','k');

% Remember the hold state then turn hold on
HoldState = ishold;
hold on;

% Make default icons for elements of different physical types
for i = 1:length(THERING)
    SPos = SPositions(i);
    if isfield(THERING{i},'BendingAngle') & THERING{i}.BendingAngle
        % make icons for bending magnets
        IconHeight = .3;
        IconColor = [1 1 0];
        IconWidth = THERING{i}.Length;
        if IconWidth < .15 % meters
            IconWidth = .15;
            SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
        end
        vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
        vy = [IconHeight IconHeight -IconHeight -IconHeight];
        h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-','parent',hParent.betaAxe);
        %if IconWidth < .1 % meters
        %    set(h, 'EdgeColor', IconColor);
        %end

    elseif isfield(THERING{i},'K') & THERING{i}.K
        % Quadrupole
        if THERING{i}.K > 0
            % Focusing quadrupole
            IconHeight = .6;
            IconColor = [1 0 0];
            IconWidth = THERING{i}.Length;
            if IconWidth < .15 % meters
                IconWidth = .15;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
            vy = [0          IconHeight               0      -IconHeight    0];
        else
            % Defocusing quadrupole
            IconHeight = .6;
            IconColor = [0 0 1];
            IconWidth = THERING{i}.Length;
            if IconWidth < .15 % meters
                IconWidth = .15;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos+.4*IconWidth    SPos    SPos+IconWidth  SPos+.6*IconWidth  SPos+IconWidth    SPos      SPos+.4*IconWidth];
            vy = [     0            IconHeight   IconHeight          0              -IconHeight  -IconHeight    0];
        end
        h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-','Parent',hParent.betaAxe);
        %if IconWidth < .1 % meters
        %    set(h, 'EdgeColor', IconColor);
        %end

    elseif isfield(THERING{i},'PolynomB') & length(THERING{i}.PolynomB)>2 & THERING{i}.PolynomB(3)
        % Sextupole
        if THERING{i}.PolynomB(3)>0
            % Focusing sextupole
            IconHeight = .5;
            IconColor = [1 0 1];
            IconWidth = THERING{i}.Length;
            if IconWidth < .1 % meters
                IconWidth = .1;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        else
            % Defocusing sextupole
            IconHeight = .5;
            IconColor = [0 1 0];
            IconWidth = THERING{i}.Length;
            if IconWidth < .1 % meters
                IconWidth = .1;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        end
        h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle','-');
        %if IconWidth < .1 % meters
        %    set(h, 'EdgeColor', IconColor);
        %end

    elseif isfield(THERING{i},'Frequency') & isfield(THERING{i},'Voltage')
        % RF cavity
        IconColor = [1 0.5 0];
        plot(SPos, 0+Offset, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 4)

    elseif strcmpi(THERING{i}.FamName,'BPM')
        % BPM
        IconColor = 'k';
        plot(SPos, 0+Offset, '.-', 'Color', IconColor)
        %plot(SPos, 0, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 1.5)

    elseif any(strcmpi(THERING{i}.FamName,{'COR','XCOR','YCOR','HCOR','VCOR'})) | isfield(THERING{i},'KickAngle')
        % Corrector
        IconHeight = .8;
        IconColor = [0 0 0];
        vx = [SPos   SPos];
        vy = [-IconHeight IconHeight];
        %plot(vx, Scaling*vy+Offset, 'Color', IconColor);
        IconWidth = THERING{i}.Length;
        vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
        vy = [IconHeight IconHeight -IconHeight -IconHeight];
        h = patch(vx, Scaling*vy+Offset, IconColor,'LineStyle', '-','parent',hParent.betaAxe);
        if IconWidth < .1 % meters
            set(h, 'EdgeColor', IconColor);
        end
    end
end


% Leave the hold state as it was at the start
if ~HoldState
    hold off
end
%yaxis([-3 3]);


% --------------------------------------------------------------------
function [name, val] = quad_getsetpoint()
quadlist = findmemberof('QUAD');
imax=size(quadlist,1);
[data] = getsp(quadlist,'Model');
for i=1:imax,
    tmp=data{i};
    name(i)=quadlist(i);
    val(i) = tmp(1);
end
val=num2cell(val);


% --------------------------------------------------------------------
function [handle] = quad_table(title, name, value, position)
% [handle, b] =  quad_table(title, name, value) title is a string name is a
% column of strings with the names of the quads value is a column of
% strings with the values of the quads handle is handle to the mathworks
% MWFrame b is a handle to mathworks MWListbox b.getSelectedRows => gets
% you the index of the row currently selected by mouse, beginning with
% zero!!! -- example: [handle, b] = gui_sheet('nice table', qualist,
% vallist)
%
% requires Java runtime environment installed and mathworks components ver. 0.5

ncol=2;
nrows=size(name,2);
data = cell(nrows,2);

for i=1:nrows,
    data(i,:) = [name(i) value(i)] ;
end;
t = uitable(data, [{'Name'} {'k'}]);
set(t,'Editable',false);
set(t,'Units','normalized')
set(t,'Position',position);
handle = t;


