function varargout = reglage_pos_energie_v3(varargin)
% REGLAGE_POS_ENERGIE_V3 M-file for reglage_pos_energie_v3.fig
%      REGLAGE_POS_ENERGIE_V3, by itself, creates a new REGLAGE_POS_ENERGIE_V3 or raises the existing
%      singleton*.
%
%      H = REGLAGE_POS_ENERGIE_V3 returns the handle to a new REGLAGE_POS_ENERGIE_V3 or the handle to
%      the existing singleton*.
%
%      REGLAGE_POS_ENERGIE_V3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGLAGE_POS_ENERGIE_V3.M with the given input arguments.
%
%      REGLAGE_POS_ENERGIE_V3('Property','Value',...) creates a new REGLAGE_POS_ENERGIE_V3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reglage_pos_energie_v3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reglage_pos_energie_v3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reglage_pos_energie_v3

% Last Modified by GUIDE v2.5 27-Mar-2006 11:16:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reglage_pos_energie_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @reglage_pos_energie_v3_OutputFcn, ...
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

% --- Executes just before reglage_pos_energie_v3 is made visible.
function reglage_pos_energie_v3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reglage_pos_energie_v3 (see VARARGIN)

% Choose default command line output for reglage_pos_energie_v3
handles.output = hObject;


% position du septum passif
handles.pos_septum = -15;

% efficit� des kickers exprim�e en mrad / mm de bump
handles.eff_K = 0.3331; 

% button group for kickers
h = uibuttongroup('visible','off','Position',[0.05 0.84 .41 .12],...
    'Title','bump mode','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
u1 = uicontrol('Style','Radio','String','bump symetrique','Tag','radiobutton1',...
    'pos',[10 55 140 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
u2 = uicontrol('Style','Radio','String','bum dissymetrique couple 2 a 2','Tag','radiobutton2',...
    'pos',[10. 30. 220 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
u3 = uicontrol('Style','Radio','String','bump quelconque','Tag','radiobutton3',...
    'pos',[10. 5.00 140 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});

set(h,'SelectedObject',u1);  % No selection
set(h,'Visible','on');

set([handles.K1_edit1,handles.K1_slider1,...
            handles.K2_edit2,handles.K2_slider2,...
            handles.K3_edit3,handles.K3_slider3,...
            handles.K4_edit4,handles.K4_slider4,...
            handles.K1_U_edit,handles.K1_U_slider,...
            handles.K2_U_edit,handles.K2_U_slider,...
            handles.K3_U_edit,handles.K3_U_slider,...
            handles.K4_U_edit,handles.K4_U_slider,...
            ],'Enable','off')

%%%%%%%
% BPM       
%%%%%%%

BPMxFamily = 'BPMx';
BPMzFamily = 'BPMz';
% on limite la liste des BPM au dixième
% on tiend compte d'éventuels BPM au status = 0

nbmaxBPM = 10;
BPMxList = family2dev(BPMxFamily, 1 );
BPMxListtotal = family2dev(BPMxFamily, 0 );
BPMxList = intersect(BPMxList(1:nbmaxBPM,:),BPMxListtotal(1:nbmaxBPM,:),'rows');

BPMzList = family2dev(BPMzFamily, 1 );
BPMzListtotal = family2dev(BPMzFamily, 0 );
BPMzList = intersect(BPMzList(1:nbmaxBPM,:),BPMzListtotal(1:nbmaxBPM,:),'rows');

% les éventuels BPMs au status = 0 sont inactivés et checkbox value = 0
val_status = 1 - getfamilydata('BPMx','Status',BPMxListtotal(1:nbmaxBPM,:));
num_BPM_actif = [];
for k = 1:nbmaxBPM
    name = strcat('BPM',num2str(k),'_checkbox');
    if val_status(k)   
        set(handles.(name),'Enable','off');
        set(handles.(name),'Value',0);
        val = 0;
    else
        set(handles.(name),'Value',1);
        val = 1;
    end
    num_BPM_actif =[num_BPM_actif  val];
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);


% initialisation des BPM estim�s actifs pour la mesrue d'�nergie
% fonction num_BPM_actif = 1 lorsque le BPM est selectionn�, 0 sinon
% on active par d�faut les 5 premiers
% num_BPM_actif = [1 1 1 1 1 0 0 0 0 0 ];
% setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
% 
% set(handles.BPM1_checkbox,'Value',1);
% set(handles.BPM2_checkbox,'Value',1);
% set(handles.BPM3_checkbox,'Value',1);
% set(handles.BPM4_checkbox,'Value',1);
% set(handles.BPM5_checkbox,'Value',1);
% set(handles.BPM6_checkbox,'Value',0);
% set(handles.BPM7_checkbox,'Value',0);
% set(handles.BPM8_checkbox,'Value',0);
% set(handles.BPM9_checkbox,'Value',0);
% set(handles.BPM10_checkbox,'Value',0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% enregistrement de la matrice : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enregistrement = 1;
if enregistrement

    global THERING

    % mise � z�ro des courants quadrup�les
    %     setsp({'Q1','Q2','Q3',...
    %         'Q4','Q5','Q6','Q7','Q8','Q9','Q10'},0,'Model');

    tmp = family2atindex(findmemberof('QUAD'));
    for k1= 1: length(tmp)
        for k2=1:length(tmp{k1})
            ATIndex= tmp{k1}(k2);
            THERING{ATIndex}.K = 0;
            THERING{ATIndex}.PolynomB(2) = 0;
        end
    end

    % index des BPM
    index_BPM = family2atindex('BPMx');
    %index_premier_element = family2atindex('K4');
    index_premier_element = family2atindex('PtINJ');

    % calcul de chaque matrice 6x6 du point Kicker 4 jusqu'au BPM consid�r�
    for jBPM = 1:nbmaxBPM
        M66 = eye(6);
        for i = index_premier_element:index_BPM(jBPM)
            elem = THERING{i};
            Melem66 = findelemm66(elem,elem.PassMethod,[0 0 0 0 0 0]');
            M66 = Melem66 * M66;
        end
        R11(jBPM) = M66(1,1);
        R12(jBPM) = M66(1,2);
        R15(jBPM) = M66(1,5);
    end
    setappdata(handles.figure1,'R11',R11);
    setappdata(handles.figure1,'R12',R12);
    setappdata(handles.figure1,'R15',R15);


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% position des BPM acitvés
s = getspos(BPMxFamily, BPMxList);
Xmax = max(s);
setappdata(handles.figure1, 'SPosX', s);
L = getfamilydata('Circumference');
if isempty(L)
    setappdata(handles.figure1, 'AxisRange1X', [min(s) max(s)]);
else
    setappdata(handles.figure1, 'AxisRange1X', [0 Xmax]);
end
setappdata(handles.figure1,'nbmaxBPM',nbmaxBPM);

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using reglage_pos_energie_v3.
if strcmp(get(hObject,'Visible'),'off')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % AXE 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % lire les valeurs courantes des kickers 
%     val_HW14 = getam('K_INJ1');
%     val_HW23 = getam('K_INJ2');
%     val_ph14 = hw2physics('K_INJ1','Setpoint',val_HW14);
%     val_ph23 = hw2physics('K_INJ3','Setpoint',val_HW23);
%     teta1 = val_ph14(1);
%     teta2 = val_ph23(1);
%     teta3 = val_ph23(2);
%     teta4 = val_ph14(2);
    
    %(on se teste sur correcteurs)
    %     teta1 = -4e-3;teta2 = 4.5e-3;teta3 = 8e-3;teta4 = -8e-3
    val_HW = getam('HCOR');
    val_ph = 100 * hw2physics('HCOR','Setpoint',val_HW); 
    teta1 = - abs(val_ph(1));
    teta2 = abs(val_ph(2));
    teta3 = abs(val_ph(3));
    teta4 = - abs(val_ph(4));
    
    % plot du bump kicker
    name=['axes' num2str(1)];
    axes(handles.(name));

   % pas génial, il vaudrait mieux utiliser THERING en reperant les elements et
   % deduire les espaces entre equipements
    X1 = 0;X2 = 1;X3 = 4.002;X4 = 8.227;X5 = 11.229;X6 = 13;
    Ymax = 20;Ymin = -25;
    Xdata = [ X1 X2 X3 X4 X5 X6];
    V1 = [0 0]';
    V2 = [1 (X2-X1);0 1]*V1 + [0 teta1]';
    V3 = [1 (X3-X2);0 1]*V2 + [0 teta2]';
    V4 = [1 (X4-X3);0 1]*V3 + [0 teta3]';
    V5 = [1 (X5-X4);0 1]*V4 + [0 teta4]';
    V6 = [1 (X6-X5);0 1]*V5;
    Ydata = [V1(1) V2(1) V3(1) V4(1) V5(1) V6(1)]*1000;
    plot(Xdata,Ydata,'rs-','Tag','line1');
    hold on
    plot(Xdata,Ydata*cos(30*pi/180),'bs-','Tag','line2');
    set(handles.(name), 'YGrid','On');
    set(handles.(name), 'XGrid','On');
    set(gca, 'YMinorTick','On');
    %set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'s (m)');
    ylabel(handles.(name),'X (mm)');
    xlim([0 X6]);
    ylim([Ymin Ymax]);
    
    % plot du septum
    hold on
    Xs = 6.8695;ls = 0.6;
    Ys = handles.pos_septum;eps = 3.5;
    rectangle('Position',[Xs,Ys-eps,ls,eps],...
       'FaceColor','r')
          %'Curvature',[0.4],'FaceColor','r')
    hold on
    
    % plot des kickers
    l = 0.6;XK1 = X2-l/2;XK2 = X3-l/2;
    XK3 = X4-l/2;XK4 = X5-l/2;
    Y = Ymin + 1;ep = Ymax - Ymin - 2;
    rectangle('Position',[XK1,Y,l,ep],...
        'LineWidth',0.5,'LineStyle','--')
    hold on
    rectangle('Position',[XK2,Y,l,ep],...
        'LineWidth',0.5,'LineStyle','--')
    hold on
    rectangle('Position',[XK3,Y,l,ep],...
        'LineWidth',0.5,'LineStyle','--')
    hold on
    rectangle('Position',[XK4,Y,l,ep],...
        'LineWidth',0.5,'LineStyle','--')
    hold on
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot de la maille
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    name=['axes' num2str(3)];
    axes(handles.(name));
    drawlattice;
    a = getappdata(gcf, 'AxisRange1X');
    axis([a -1 1]);
    set(gca,'XTick',[-10 600]); % to erase tick labels
    set(gca,'YTick',[-10 10]);
    set(gca,'Box','off')
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % AXE 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % entrer lecture BPM tour par tour :selectionner le premier tour
    % test anneau
    %BPMxList = [1     3;1     4;1     5;1     6]
    [X Z Sum] = anabpmfirstturn( BPMxList ,'MaxSum','NoDisplay');
    orbite_x = X';
    orbite_z = Z';
    setappdata(handles.figure1,'orbite_x',orbite_x);
    setappdata(handles.figure1,'orbite_z',orbite_z);
    
    % plot des orbites premiers tours
    name=['axes' num2str(2)];
    axes(handles.(name));
    %xdata = BPMx.Position;
    plot(s,orbite_x,'r-','Tag','line1');
    hold on
    %ydata = BPMz.Position;
    axis([a -10 10]);
    plot(s,orbite_z,'b-','Tag','line2');
    set(handles.(name), 'Nextplot','Add');
    set(handles.(name), 'YGrid','On');
    set(gca, 'YMinorTick','On');
    set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'position du BPM');
    ylabel(handles.(name),'orbites (mm)');
    
end
% afficher la position du septum
set(handles.pos_septum_text48,'String',num2str(handles.pos_septum));

% UIWAIT makes reglage_pos_energie_v3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reglage_pos_energie_v3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in fit_pushbutton1.
function fit_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to fit_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
% constitution de la liste des BPM actifs
liste_BPM_actif = [];
for i = 1: length(num_BPM_actif)
    if num_BPM_actif(i)
        liste_BPM_actif = [liste_BPM_actif i];
    end
end

% constitution de la matrice de transport avec les BPM actifs
R11 = getappdata(handles.figure1,'R11');
R12 = getappdata(handles.figure1,'R12');
R15 = getappdata(handles.figure1,'R15');
orbite_x = getappdata(handles.figure1,'orbite_x');

M11 = [];M12 = [];M15 = [];
for i = 1:length(liste_BPM_actif)
    M11 = [M11 R11(liste_BPM_actif(i))];
    M12 = [M12 R12(liste_BPM_actif(i))];
    M15 = [M15 R15(liste_BPM_actif(i))];
end
Matrice_BPM_actif = [M11' M12' M15']  
disp('j''suis contente - pour l''instant')

% lire les N premiers BPM premiers tours
%test
%XBPM = [1 2 3 4 5 6 7 8 9 10]';
%XBPM = [5.59 6.96 10.86 12.13 13.40]';
[U,S,V] = svd(Matrice_BPM_actif)
% ici toutes les valeurs propres sont utilisees- ??
diago = diag(S);
seuil = 0.01;
for k = 1:length(diag(S))
    if diago(k)<seuil
        % on suppose que le premier est toujours superieur au seuil
        jseuil = k-1
        break
    else
        jseuil = length(diag(S));
    end
end
Rmod = Matrice_BPM_actif * V(:,1:jseuil);
B = Rmod \ orbite_x;
Xpos = V(:,1:jseuil)*B

% afficher Xpos
set(handles.deltax_text50,'String',sprintf('%3.2f',Xpos(1)));
set(handles.deltaxp_text51,'String',sprintf('%3.2f',Xpos(2)));
set(handles.deltaE_text52,'String',sprintf('%3.2f',Xpos(3)/10));

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function K1_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to K1_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K1_edit1 as text
%        str2double(get(hObject,'String')) returns contents of K1_edit1 as a double


% --- Executes during object creation, after setting all properties.
function K1_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K1_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K1_slider1_Callback(hObject, eventdata, handles)
% hObject    handle to K1_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K1_slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K1_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function K2_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to K2_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K2_edit2 as text
%        str2double(get(hObject,'String')) returns contents of K2_edit2 as a double


% --- Executes during object creation, after setting all properties.
function K2_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K2_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K2_slider2_Callback(hObject, eventdata, handles)
% hObject    handle to K2_slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K2_slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K2_slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function K3_edit3_Callback(hObject, eventdata, handles)
% hObject    handle to K3_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K3_edit3 as text
%        str2double(get(hObject,'String')) returns contents of K3_edit3 as a double


% --- Executes during object creation, after setting all properties.
function K3_edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K3_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K3_slider3_Callback(hObject, eventdata, handles)
% hObject    handle to K3_slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K3_slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K3_slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function K4_edit4_Callback(hObject, eventdata, handles)
% hObject    handle to K4_edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K4_edit4 as text
%        str2double(get(hObject,'String')) returns contents of K4_edit4 as a double


% --- Executes during object creation, after setting all properties.
function K4_edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K4_edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K4_slider4_Callback(hObject, eventdata, handles)
% hObject    handle to K4_slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K4_slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K4_slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function deltax_edit13_Callback(hObject, eventdata, handles)
% hObject    handle to deltax_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltax_edit13 as text
%        str2double(get(hObject,'String')) returns contents of deltax_edit13 as a double


% --- Executes during object creation, after setting all properties.
function deltax_edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltax_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function deltax_slider13_Callback(hObject, eventdata, handles)
% hObject    handle to deltax_slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% lire la valeur affich�e
deltax = num2str(get(handles.deltax_edit13,'String'));
deltax = deltax * 1e-3 % mm

L1 = (50 + 500 + 800 + 300) * 1e-3;
L2 = 1e-3 * 600/2;

% % d�duction angles septa actifs et septum passif
% val_HW_sa = getam('septa actifs...);
% val_HW_sp = getam('septum passif...);
% 
% val_ph_sa = deltax / L1;
% val_HW_sa = val_HW_sa + physics2HW('sept...','Setpoint',val_ph_sa);
% val_ph_sp = hw2physics('sept..','Setpoint',val_HW_sp);
% val_ph_sp = val_ph_sp - val_ph_sa;
% val_HW_sp = val_HW_sp + physics2HW('sept...','Setpoint',val_ph_sp);

% setsp('sept...','Setpoint',val_HW_sp);
% setsp('septactif...','Setpoint',val_HW_sa);

% re-initaliser le slider � cette valeur de bump
%set(handles.deltax_slider13,'Value',valeur_corr);

% --- Executes during object creation, after setting all properties.
function deltax_slider13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltax_slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function deltaxp_edit14_Callback(hObject, eventdata, handles)
% hObject    handle to deltaxp_edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaxp_edit14 as text
%        str2double(get(hObject,'String')) returns contents of deltaxp_edit14 as a double


% --- Executes during object creation, after setting all properties.
function deltaxp_edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaxp_edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function deltaxp_slider14_Callback(hObject, eventdata, handles)
% hObject    handle to deltaxp_slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% lire la valeur affich�e
deltaxp = num2str(get(handles.deltaxp_edit14,'String'));
deltaxp = deltaxp * 1e-3

% pour point d'injection = point fixe, rapport entre les angles septum
% passif et les septa actifs : RAP
L1 = (50 + 500 + 800 + 300) * 1e-3;
L2 = 1e-3 * 600/2;
RAP = (L1-L2) / L2;

% val_HW_sp = getam('septum...);
% val_HW_sa = getam('septa actifs...);

% val_ph_sp = deltaxp + hw2physics('sept..','Setpoint',val_HW_sp);
% val_ph_sa = deltaxp * RAP + hw2physics('sept..','Setpoint',val_HW_sa);
% val_HW_sp = physics2HW('sept...','Setpoint',val_ph_sp);
% val_HW_sa = physics2HW('septactif...','Setpoint',val_ph_sa);
% setsp('sept...','Setpoint',val_HW_sp);
% setsp('septactif...','Setpoint',val_HW_sa);

% re-initaliser le slider � cette valeur de bump
set(handles.deltaxp_slider14,'Value',valeur_corr);


% --- Executes during object creation, after setting all properties.
function deltaxp_slider14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaxp_slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function deltaz_edit15_Callback(hObject, eventdata, handles)
% hObject    handle to deltaz_edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaz_edit15 as text
%        str2double(get(hObject,'String')) returns contents of deltaz_edit15 as a double


% --- Executes during object creation, after setting all properties.
function deltaz_edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaz_edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function deltaz_slider15_Callback(hObject, eventdata, handles)
% hObject    handle to deltaz_slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function deltaz_slider15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaz_slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function deltazp_edit16_Callback(hObject, eventdata, handles)
% hObject    handle to deltazp_edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltazp_edit16 as text
%        str2double(get(hObject,'String')) returns contents of deltazp_edit16 as a double


% --- Executes during object creation, after setting all properties.
function deltazp_edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltazp_edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function deltazp_slider16_Callback(hObject, eventdata, handles)
% hObject    handle to deltazp_slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function deltazp_slider16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltazp_slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function uibuttongroup_SelectionChangeFcn(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here
        % 
        set([handles.K1_edit1,handles.K1_slider1,...
            handles.K2_edit2,handles.K2_slider2,...
            handles.K3_edit3,handles.K3_slider3,...
            handles.K4_edit4,handles.K4_slider4,...
            handles.K1_U_edit,handles.K1_U_slider,...
            handles.K2_U_edit,handles.K2_U_slider,...
            handles.K3_U_edit,handles.K3_U_slider,...
            handles.K4_U_edit,handles.K4_U_slider,...
            ],'Enable','off')
       
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        % 
        set([...
            handles.K2_edit2,handles.K2_slider2,...
            ...
            handles.K4_edit4,handles.K4_slider4,...
            ...
            handles.K2_U_edit,handles.K2_U_slider,...
            ...
            handles.K4_U_edit,handles.K4_U_slider,...
            ],'Enable','off');
        set([handles.K1_edit1,handles.K1_slider1,...
            ...
            handles.K3_edit3,handles.K3_slider3,...
            ...
            handles.K1_U_edit,handles.K1_U_slider,...
            ...
            handles.K3_U_edit,handles.K3_U_slider,...
            ...
            ],'Enable','on')
    case 'radiobutton3'
        % code piece when radiobutton1 is selected goes here
        % 
        set([handles.K1_edit1,handles.K1_slider1,...
            handles.K2_edit2,handles.K2_slider2,...
            handles.K3_edit3,handles.K3_slider3,...
            handles.K4_edit4,handles.K4_slider4,...
            handles.K1_U_edit,handles.K1_U_slider,...
            handles.K2_U_edit,handles.K2_U_slider,...
            handles.K3_U_edit,handles.K3_U_slider,...
            handles.K4_U_edit,handles.K4_U_slider,...
            ],'Enable','on')
        
end



function bump_edit21_Callback(hObject, eventdata, handles)
% hObject    handle to bump_edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bump_edit21 as text
%        str2double(get(hObject,'String')) returns contents of bump_edit21 as a double
bump = str2num(get(handles.bump_edit21,'String'));

% valeur 4 kickers en rad
val_ph_K = bump * handles.eff_K * 1e-3;
% % valeurs 4 kickers en V
% val_HW_K = physics2HW('Kick...','Setpoint',val_ph_K);
% % appliquer les 4 valeurs (transformer peut-�tre en vecteurs 4 valeurs
% % altern�es)
% setsp('Kick...', 'Setpoint',val_HW_K)

% afficher dans edit des kickers
%set(handles.K1_edit1,'String',num2str(val_HW_K(1))); % etc..

% re-initaliser le slider � cette valeur de bump
%set(handles.K1_slider1,'Value',val_HW_K(1));
%set(handles.K2_slider2,'Value',val_HW_K(2));  %etc..


% --- Executes during object creation, after setting all properties.
function bump_edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bump_edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BPM1_checkbox.
function BPM1_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM1_checkbox

nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(1) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(1) = 0;  
    BPMxList = intersect(BPMxList,BPMxListtotal(2:nbmaxBPM,:),'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)

% --- Executes on button press in BPM2_checkbox.
function BPM2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM2_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(2) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(2) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1,:); BPMxListtotal(3:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)





% 
% 
% if (get(hObject,'Value') == get(hObject,'Max'))
%     % then checkbox is checked-take approriate action
%     num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
%     num_BPM_actif(2) = 1;
%     setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
% else
%     % checkbox is not checked-take approriate action
%     num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
%     num_BPM_actif(2) = 0;
%     setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
% end

% --- Executes on button press in BPM3_checkbox.
function BPM3_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM3_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(3) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(3) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1:2,:); BPMxListtotal(4:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)



% --- Executes on button press in BPM4_checkbox.
function BPM4_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM4_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(4) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(4) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1:3,:); BPMxListtotal(5:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)


% --- Executes on button press in BPM5_checkbox.
function BPM5_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM5_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM5_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(5) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(5) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1:4,:); BPMxListtotal(6:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)

% --- Executes on button press in BPM6_checkbox.
function BPM6_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM6_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM6_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(6) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(6) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1:5,:); BPMxListtotal(7:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)

% --- Executes on button press in BPM7_checkbox.
function BPM7_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM7_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM7_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(7) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(7) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1:6,:); BPMxListtotal(8:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)

% --- Executes on button press in BPM8_checkbox.
function BPM8_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM8_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM8_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(8) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(8) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1:7,:); BPMxListtotal(9:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)

% --- Executes on button press in BPM9_checkbox.
function BPM9_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM9_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM9_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(9) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(9) = 0;  
    BPMxList = intersect(BPMxList,[BPMxListtotal(1:8,:); BPMxListtotal(10:nbmaxBPM,:)],'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)

% --- Executes on button press in BPM10_checkbox.
function BPM10_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM10_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM10_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(10) = 1;
    BPMxList = intersect(BPMxList,BPMxListtotal(1:nbmaxBPM,:),'rows');
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(10) = 0;  
    BPMxList = intersect(BPMxList,BPMxListtotal(1:9,:),'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)

function K1_U_edit_Callback(hObject, eventdata, handles)
% hObject    handle to K1_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K1_U_edit as text
%        str2double(get(hObject,'String')) returns contents of K1_U_edit as a double


% --- Executes during object creation, after setting all properties.
function K1_U_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K1_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K1_U_slider_Callback(hObject, eventdata, handles)
% hObject    handle to K1_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K1_U_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K1_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function K2_U_edit_Callback(hObject, eventdata, handles)
% hObject    handle to K2_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K2_U_edit as text
%        str2double(get(hObject,'String')) returns contents of K2_U_edit as a double


% --- Executes during object creation, after setting all properties.
function K2_U_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K2_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K2_U_slider_Callback(hObject, eventdata, handles)
% hObject    handle to K2_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K2_U_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K2_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function K3_U_edit_Callback(hObject, eventdata, handles)
% hObject    handle to K3_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K3_U_edit as text
%        str2double(get(hObject,'String')) returns contents of K3_U_edit as a double


% --- Executes during object creation, after setting all properties.
function K3_U_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K3_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K3_U_slider_Callback(hObject, eventdata, handles)
% hObject    handle to K3_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K3_U_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K3_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function K4_U_edit_Callback(hObject, eventdata, handles)
% hObject    handle to K4_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of K4_U_edit as text
%        str2double(get(hObject,'String')) returns contents of K4_U_edit as a double


% --- Executes during object creation, after setting all properties.
function K4_U_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K4_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function K4_U_slider_Callback(hObject, eventdata, handles)
% hObject    handle to K4_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function K4_U_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K4_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function septum_actif_a_edit_Callback(hObject, eventdata, handles)
% hObject    handle to septum_actif_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of septum_actif_a_edit as text
%        str2double(get(hObject,'String')) returns contents of septum_actif_a_edit as a double


% --- Executes during object creation, after setting all properties.
function septum_actif_a_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_actif_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function septum_actif_a_slider_Callback(hObject, eventdata, handles)
% hObject    handle to septum_actif_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function septum_actif_a_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_actif_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function septum_passif_a_edit_Callback(hObject, eventdata, handles)
% hObject    handle to septum_passif_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of septum_passif_a_edit as text
%        str2double(get(hObject,'String')) returns contents of septum_passif_a_edit as a double


% --- Executes during object creation, after setting all properties.
function septum_passif_a_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_passif_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function septum_passif_a_slider_Callback(hObject, eventdata, handles)
% hObject    handle to septum_passif_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function septum_passif_a_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_passif_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CV4_a_edit_Callback(hObject, eventdata, handles)
% hObject    handle to CV4_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CV4_a_edit as text
%        str2double(get(hObject,'String')) returns contents of CV4_a_edit as a double


% --- Executes during object creation, after setting all properties.
function CV4_a_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV4_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CV4_a_slider_Callback(hObject, eventdata, handles)
% hObject    handle to CV4_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function CV4_a_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV4_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CV5_a_edit_Callback(hObject, eventdata, handles)
% hObject    handle to CV5_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CV5_a_edit as text
%        str2double(get(hObject,'String')) returns contents of CV5_a_edit as a double


% --- Executes during object creation, after setting all properties.
function CV5_a_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV5_a_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CV5_a_slider_Callback(hObject, eventdata, handles)
% hObject    handle to CV5_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function CV5_a_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV5_a_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function septum_actif_U_slider_Callback(hObject, eventdata, handles)
% hObject    handle to septum_actif_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function septum_actif_U_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_actif_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function septum_passif_U_edit_Callback(hObject, eventdata, handles)
% hObject    handle to septum_passif_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of septum_passif_U_edit as text
%        str2double(get(hObject,'String')) returns contents of septum_passif_U_edit as a double


% --- Executes during object creation, after setting all properties.
function septum_passif_U_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_passif_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function septum_passif_U_slider_Callback(hObject, eventdata, handles)
% hObject    handle to septum_passif_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function septum_passif_U_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_passif_U_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CV4_I_edit_Callback(hObject, eventdata, handles)
% hObject    handle to CV4_I_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CV4_I_edit as text
%        str2double(get(hObject,'String')) returns contents of CV4_I_edit as a double


% --- Executes during object creation, after setting all properties.
function CV4_I_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV4_I_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CV4_I_slider_Callback(hObject, eventdata, handles)
% hObject    handle to CV4_I_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function CV4_I_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV4_I_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CV5_I_edit_Callback(hObject, eventdata, handles)
% hObject    handle to CV5_I_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CV5_I_edit as text
%        str2double(get(hObject,'String')) returns contents of CV5_I_edit as a double


% --- Executes during object creation, after setting all properties.
function CV5_I_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV5_I_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function CV5_I_slider_Callback(hObject, eventdata, handles)
% hObject    handle to CV5_I_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function CV5_I_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV5_I_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function septum_actif_U_edit_Callback(hObject, eventdata, handles)
% hObject    handle to septum_actif_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of septum_actif_U_edit as text
%        str2double(get(hObject,'String')) returns contents of septum_actif_U_edit as a double


% --- Executes during object creation, after setting all properties.
function septum_actif_U_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to septum_actif_U_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% bugs
% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
function edit57_CreateFcn(hObject, eventdata, handles)
function slider55_CreateFcn(hObject, eventdata, handles)
function slider56_CreateFcn(hObject, eventdata, handles)

