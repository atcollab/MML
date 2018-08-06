
function varargout = energytunette(varargin)
% ENERGYTUNETTE M-file for energytunette.fig
%      ENERGYTUNETTE, by itself, creates a new ENERGYTUNETTE or raises the existing
%      singleton*.
%
%      H = ENERGYTUNETTE returns the handle to a new ENERGYTUNETTE or the handle to
%      the existing singleton*.
%
%      ENERGYTUNETTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENERGYTUNETTE.M with the given input arguments.
%
%      ENERGYTUNETTE('Property','Value',...) creates a new ENERGYTUNETTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before energytunette_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to energytunette_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help energytunette

% Last Modified by GUIDE v2.5 27-Apr-2006 17:56:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @energytunette_OpeningFcn, ...
                   'gui_OutputFcn',  @energytunette_OutputFcn, ...
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

% --- Executes just before energytunette is made visible.
function energytunette_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to energytunette (see VARARGIN)

% Choose default command line output for energytunette
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% etalonnage correcteurs LT2 (hors soleilinit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
etalonnage_V_LT2 = (110.6e-4/10)/getbrho('Model');
setappdata(handles.figure1,'etalonnage_V_LT2',etalonnage_V_LT2);

% position du septum passif
handles.pos_septum = -15;

% efficite des kickers exprim�e en mrad / mm de bump
handles.eff_K = 0.3331; 

% button group for kickers
h = uibuttongroup('visible','off','Position',[0.05 0.84 .41 .12],...
    'Title','bump mode','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
u1 = uicontrol('Style','Radio','String','bump symetrique','Tag','radiobutton1',...
    'pos',[10 55 140 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
% u2 = uicontrol('Style','Radio','String','bum dissymetrique couple 2 a 2','Tag','radiobutton2',...
%     'pos',[10. 30. 220 25],'parent',h,'HandleVisibility','off',...
%     'BackgroundColor',[0.696 1.0 0.924]);
u2 = uicontrol('Style','Radio','String','bum fermé','Tag','radiobutton2',...
    'pos',[10. 30. 220 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
u3 = uicontrol('Style','Radio','String','bump quelconque','Tag','radiobutton3',...
    'pos',[10. 5.00 140 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

handles.sym = u1;
handles.dissym = u2;
handles.quelconque = u3;

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

% limitation du nombre de BPM concernés par la mesure en énergie
nbmaxBPM = 10;

% on tiend compte d'éventuels BPM au status = 0
% TOUT NOUVEAU BPM MIS AU STATUS 0 DEMANDE UNE REINITIALISATION DE
% L'INTERFACE

BPMxList = family2dev(BPMxFamily, 1 ); % liste BPM actifs
BPMxListtotal = family2dev(BPMxFamily, 0 ); % liste totale
% la lsite totale est utilisée pour pouvoir avoir ne liste de numéro fixe
% de 1 à 10
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
%  matrice transport : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enregistrement = 0;
if enregistrement
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % enregistrement de la matrice transport
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    global THERING

    % mise a zero des courants quadrupoles
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

    % calcul de chaque matrice 6x6 du point d'injection jusqu'au BPM consid�r�
    %  position en metre
    % angle en radian
    % energie [-]
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
        R33(jBPM) = M66(3,3);
        R34(jBPM) = M66(3,4);
    end

    % enregistrement
    directory = getfamilydata('Directory','BPMTransport');
    directory_actuelle = pwd;
    
    cd(directory)
    %Name = 'solamor2linb_Mtransport10BPM';
    % nouvelle maille avec champ de fuite dans les dipoles
    Name = 'solamor2linb_new_13mai_Mtransport10BPM';
    save(Name,'R11','R12','R15','R33','R34','-mat');
    
    cd(directory_actuelle);
    
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % chargement de la matrice transport
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    directory = getfamilydata('Directory','BPMTransport');
    Name = 'solamor2linb_Mtransport10BPM';
    filename = strcat(directory,Name);
    S = load('-mat',filename);
    R11 = S.R11 ; R12 = S.R12 ; R15 = S.R15 ; R33 = S.R33 ; R34 = S.R34 ;
      
end

setappdata(handles.figure1,'R11',R11);
setappdata(handles.figure1,'R12',R12);
setappdata(handles.figure1,'R15',R15);
setappdata(handles.figure1,'R33',R33);
setappdata(handles.figure1,'R34',R34);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% position des elements V et H pour les bumps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Position des correcteurs verticaux : LT2 init getspos('CV') getspos('BPM')
posBPM_SP = 41.9159 ; posCV4 = 32.4109 ; posCV5 = 35.5859 ;
L1_V = posCV5 - posCV4 ;                % distance centre V4 centre V5
L2_V = posBPM_SP - posCV5 ;             % distance centre V5 point d'injection
L1_H = (50 + 500 + 800 + 300) * 1e-3;   % distance centre SA centre SP
L2_H = 1e-3 * 600/2;                    % distance centre SP point d'injection
setappdata(handles.figure1,'L1_V',L1_V);
setappdata(handles.figure1,'L2_V',L2_V);
setappdata(handles.figure1,'L1_H',L1_H);
setappdata(handles.figure1,'L2_H',L2_H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% affichage des valeurs septa et correcteurs LT2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.septum_actif_a_slider,'Min',-2,'Max',135);
set(handles.septum_actif_U_slider,'Min',-2,'Max',120);
set(handles.septum_passif_a_slider,'Min',-2,'Max',29);
set(handles.septum_passif_U_slider,'Min',-2,'Max',560);
set(handles.CV4_a_slider,'Min',-1,'Max',1);
set(handles.CV5_a_slider,'Min',-1,'Max',1);
set(handles.CV4_I_slider,'Min',-8,'Max',8);
set(handles.CV5_I_slider,'Min',-8,'Max',8);

val_HWSP =  getsp('SEP_P');
val_HWSA =  getsp('SEP_A');
set(handles.septum_passif_U_edit,'String',num2str2(val_HWSP));
set(handles.septum_actif_U_edit,'String',num2str2(val_HWSA));
set(handles.septum_passif_U_slider,'Value',val_HWSP);
set(handles.septum_actif_U_slider,'Value',val_HWSA);

val_phSP = hw2physics('SEP_P','Setpoint',val_HWSP);
val_phSA = hw2physics('SEP_A','Setpoint',val_HWSA);
set(handles.septum_passif_a_edit,'String',num2str2(val_phSP*1e3));
set(handles.septum_actif_a_edit,'String',num2str2(val_phSA*1e3));
set(handles.septum_passif_a_slider,'Value',val_phSP*1e3);
set(handles.septum_actif_a_slider,'Value',val_phSA*1e3);

val_HWCV4 = readattribute('LT2/AE/CV.4/current');
val_HWCV5 = readattribute('LT2/AE/CV.5/current');
set(handles.CV4_I_edit,'String',num2str2(val_HWCV4));
set(handles.CV5_I_edit,'String',num2str2(val_HWCV5));
set(handles.CV4_I_slider,'Value',val_HWCV4);
set(handles.CV5_I_slider,'Value',val_HWCV5);

val_phCV4 = etalonnage_V_LT2 * val_HWCV4;
val_phCV5 = etalonnage_V_LT2 * val_HWCV5;
set(handles.CV4_a_edit,'String',num2str2(val_phCV4*1e3));
set(handles.CV5_a_edit,'String',num2str2(val_phCV5*1e3));
set(handles.CV4_a_slider,'Value',val_phCV4*1e3);
set(handles.CV5_a_slider,'Value',val_phCV5*1e3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% affichage des valeurs kickers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tous les angles sont positifs en affichage
% ils sont inversés dans les fonctions pour K1 et K4
set(handles.K1_slider1,'Min',-0.1);set(handles.K1_slider1,'Max',8.4);
set(handles.K2_slider2,'Min',-0.1);set(handles.K2_slider2,'Max',8.4);
set(handles.K3_slider3,'Min',-0.1);set(handles.K3_slider3,'Max',8.4);
set(handles.K4_slider4,'Min',-0.1);set(handles.K4_slider4,'Max',8.4);

set(handles.K1_U_slider,'Min',-1);set(handles.K1_U_slider,'Max',7700);
set(handles.K2_U_slider,'Min',-1);set(handles.K2_U_slider,'Max',7700);
set(handles.K3_U_slider,'Min',-1);set(handles.K3_U_slider,'Max',7700);
set(handles.K4_U_slider,'Min',-1);set(handles.K4_U_slider,'Max',7700);

val_HW14 = getsp('K_INJ1');
val_HW23 = getsp('K_INJ2');
val_ph14 = hw2physics('K_INJ1','Setpoint',val_HW14);
val_ph23 = hw2physics('K_INJ2','Setpoint',val_HW23);
set(handles.K1_U_edit,'String',num2str2(val_HW14(1)));
set(handles.K4_U_edit,'String',num2str2(val_HW14(2)));
set(handles.K2_U_edit,'String',num2str2(val_HW23(1)));
set(handles.K3_U_edit,'String',num2str2(val_HW23(2)));

set(handles.K1_edit1,'String',num2str2(-val_ph14(1)*1e3));
set(handles.K4_edit4,'String',num2str2(-val_ph14(2)*1e3));
set(handles.K2_edit2,'String',num2str2(val_ph23(1)*1e3));
set(handles.K3_edit3,'String',num2str2(val_ph23(2)*1e3));


%% Set closing gui function
set(handles.figure1,'CloseRequestFcn',{@Closinggui,handles.figure1});


% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using energytunette.
if strcmp(get(hObject,'Visible'),'off')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % AXE 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % lire les valeurs courantes des kickers 

    teta1 = val_ph14(1)*1e3; % mrad
    teta2 = val_ph23(1)*1e3;
    teta3 = val_ph23(2)*1e3;
    teta4 = val_ph14(2)*1e3;
    
    %(on se teste sur correcteurs)
    %     teta1 = -4e-3;teta2 = 4.5e-3;teta3 = 8e-3;teta4 = -8e-3
% %     val_HW = getsp('HCOR');
% %     val_ph = 100 * hw2physics('HCOR','Setpoint',val_HW); 
% %     teta1 = - abs(val_ph(1));
% %     teta2 = abs(val_ph(2));
% %     teta3 = abs(val_ph(3));
% %     teta4 = - abs(val_ph(4));
    
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
    Ydata = [V1(1) V2(1) V3(1) V4(1) V5(1) V6(1)];
    plot(Xdata,Ydata,'rs-','Tag','line1');
    %hold on
    %plot(Xdata,Ydata*cos(30*pi/180),'bs-','Tag','line2');
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
    plot(s,orbite_x,'r.-','Tag','line1');
    hold on
    %ydata = BPMz.Position;
    axis([a -10 10]);
    plot(s,orbite_z,'b.-','Tag','line2');
    set(handles.(name), 'Nextplot','Add');
    set(handles.(name), 'YGrid','On');
    set(gca, 'YMinorTick','On');
    set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'position du BPM');
    ylabel(handles.(name),'orbites (mm)');
    
end
% afficher la position du septum
set(handles.pos_septum_text48,'String',num2str(handles.pos_septum));

% UIWAIT makes energytunette wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = energytunette_OutputFcn(hObject, eventdata, handles)
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
R33 = getappdata(handles.figure1,'R33');
R34 = getappdata(handles.figure1,'R34');

M11 = [];M12 = [];M15 = [];M33 = [];M34 = [];
for i = 1:length(liste_BPM_actif)
    M11 = [M11 R11(liste_BPM_actif(i))];
    M12 = [M12 R12(liste_BPM_actif(i))];
    M15 = [M15 R15(liste_BPM_actif(i))];
    M33 = [M33 R33(liste_BPM_actif(i))];
    M34 = [M34 R34(liste_BPM_actif(i))];
end
Matrice_BPM_actif_x = [M11' M12' M15'];
Matrice_BPM_actif_z = [M33' M34'];
disp('j''suis contente - pour l''instant')


%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
orbite_x = getappdata(handles.figure1,'orbite_x'); % orbite en mm
orbite_z = getappdata(handles.figure1,'orbite_z');

%%%%%%%%%%%%%%%%%%%%%%%%%% plan H
%test
%XBPM = [1 2 3 4 5 6 7 8 9 10]';
%XBPM = [5.59 6.96 10.86 12.13 13.40]';
[U,S,V] = svd(Matrice_BPM_actif_x);
% ici toutes les valeurs propres sont utilisees- ??
diago = diag(S);
seuil = 0.01;
for k = 1:length(diag(S))
    if diago(k)<seuil
        % on suppose que le premier est toujours superieur au seuil
        jseuil = k-1;
        break
    else
        jseuil = length(diag(S));
    end
end
nombre_de_valeur_propres_x = jseuil;
Rmod = Matrice_BPM_actif_x * V(:,1:jseuil);
B = Rmod \ (orbite_x*0.001); % orbite en metre
Xpos = V(:,1:jseuil)*B; % résultats en m rad [-]

%%%%%%%%%%%%%%%%%%%%%%%%%% plan V
[U,S,V] = svd(Matrice_BPM_actif_z);
% ici toutes les valeurs propres sont utilisees- ??
diago = diag(S);
seuil = 0.01;
for k = 1:length(diag(S))
    if diago(k)<seuil
        % on suppose que le premier est toujours superieur au seuil
        jseuil = k-1;
        break
    else
        jseuil = length(diag(S));
    end
end
nombre_de_valeur_propres_z = jseuil;
Rmod = Matrice_BPM_actif_z * V(:,1:jseuil);
B = Rmod \ (orbite_z*0.001); % orbite en metre
Zpos = V(:,1:jseuil)*B;% résultats en m rad [-]

% afficher Xpos et Zpos en mm, mrad, pourcent
set(handles.deltax_text50,'String',sprintf('%3.2f',Xpos(1)*1e3));
set(handles.deltaxp_text51,'String',sprintf('%3.2f',Xpos(2)*1e3));
set(handles.deltaE_text52,'String',sprintf('%3.2f',Xpos(3)*1e2));
set(handles.deltaz_text,'String',sprintf('%3.2f',Zpos(1)*1e3));
set(handles.deltazp_text,'String',sprintf('%3.2f',Zpos(2)*1e3));

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

%% kicker K1

val_ph = -str2double(get(hObject,'String'));
val_HW14 = physics2hw('K_INJ1','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ1',val_HW14(1),[1 1]);
% rafraichir le slider 
set(handles.K1_slider1,'Value',-val_ph);
% refraichir la tension
set(handles.K1_U_edit,'String',num2str2(val_HW14(1)));
% rafraichir le slider tension
set(handles.K1_U_slider,'Value',val_HW14(1));

if get(handles.dissym,'Value')
    % valeur d'angle identique dans K2
    val_HW23 = physics2hw('K_INJ2','Setpoint',-val_ph*1e-3);
    % appliquer à l'élément
    setsp('K_INJ2',val_HW23(1),[1 2]);
    % tester les signes !!!!!
    % rafraichir le slider angle
    set(handles.K2_slider2,'Value',-val_ph);
    % rafraichir l'éditeur angle
    set(handles.K2_edit2,'String',num2str2(-val_ph));
    % rafraichir le slider tension
    set(handles.K2_U_slider,'Value',val_HW23(1));
    % rafraichir l'éditeur tension
    set(handles.K2_U_edit,'String',num2str2(val_HW23(1)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

%% kicker K1

% afficher dans l'editeur angle
 set(handles.K1_edit1,'String',...
             num2str(get(handles.K1_slider1,'Value')));


val_ph = str2double(handles.K1_edit1,'String');
val_HW14 = physics2hw('K_INJ1','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ1',val_HW14(1),[1 1]);
% rafraichir l'éditeur tension
set(handles.K1_U_edit,'String',num2str2(val_HW14(1)));
% rafraichir le slider tension
set(handles.K1_U_slider,'Value',val_HW14(1));

if get(handles.dissym,'Value')
    % valeur d'angle identique dans K2
    val_HW23 = physics2hw('K_INJ2','Setpoint',-val_ph*1e-3);
    % appliquer à l'élément
    setsp('K_INJ2',val_HW23(1),[1 2]);
    % tester les signes !!!!!
    % rafraichir le slider angle
    set(handles.K2_slider2,'Value',-val_ph);
    % rafraichir l'éditeur angle
    set(handles.K2_slider2,'String',num2str2(-val_ph));
    % rafraichir le slider tension
    set(handles.K2_U_slider,'Value',val_HW23(1));
    % rafraichir l'éditeur tension
    set(handles.K2_U_slider,'String',num2str2(val_HW23(1)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

%% kicker K2

% afficher dans le slider angle
 set(handles.K2_slider2,'Value',...
             str2double(get(hObject,'String')));


val_ph = str2double(get(handles.K2_edit2,'String'));
val_HW23 = physics2hw('K_INJ2','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ2',val_HW23(1),[1 2]);
% rafraichir l'éditeur tension
set(handles.K2_U_edit,'String',num2str2(val_HW23(1)));
% rafraichir le slider tension
set(handles.K2_U_slider,'Value',val_HW23(1));


%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)


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

%% kicker K2

% afficher dans l'editeur angle
 set(handles.K2_edit2,'String',...
             num2str(get(handles.K2_slider2,'Value')));


val_ph = str2double(handles.K2_edit2,'String');
val_HW23 = physics2hw('K_INJ2','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ2',val_HW23(1),[1 2]);
% rafraichir l'éditeur tension
set(handles.K2_U_edit,'String',num2str2(val_HW23(1)));
% rafraichir le slider tension
set(handles.K2_U_slider,'Value',val_HW23(1));

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)


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

%% kicker K3

% afficher dans le slider angle
 set(handles.K3_slider3,'Value',...
             str2double(get(hObject,'String')));


val_ph = str2num(get(handles.K3_edit3,'String'));
val_HW23 = physics2hw('K_INJ2','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ2',val_HW23(2),[1 3]);
% rafraichir l'éditeur tension
set(handles.K3_U_edit,'String',num2str2(val_HW23(2)));
% rafraichir le slider tension
set(handles.K3_U_slider,'Value',val_HW23(2));

if get(handles.dissym,'Value')
    % valeur d'angle identique dans K4
    val_HW14 = physics2hw('K_INJ1','Setpoint',-val_ph*1e-3);
    % appliquer à l'élément
    setsp('K_INJ1',val_HW14(2),[1 4]);
    % tester les signes !!!!!
    % rafraichir le slider angle
    set(handles.K4_slider4,'Value',val_ph);
    % rafraichir l'éditeur angle
    set(handles.K4_edit4,'String',num2str2(val_ph));
    % rafraichir le slider tension
    set(handles.K4_U_slider,'Value',val_HW14(2));
    % rafraichir l'éditeur tension
    set(handles.K4_U_edit,'String',num2str2(val_HW14(2)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

%% kicker K3

% afficher dans l'editeur angle
 set(handles.K3_edit3,'String',...
             num2str(get(handles.K3_slider3,'Value')));


val_ph = str2double(handles.K3_edit3,'String');
val_HW23 = physics2hw('K_INJ2','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ2',val_HW23(1),[1 3]);
% rafraichir l'éditeur tension
set(handles.K3_U_edit,'String',num2str2(val_HW23(1)));
% rafraichir le slider tension
set(handles.K3_U_slider,'Value',val_HW23(1));

if get(handles.dissym,'Value')
    % valeur d'angle identique dans K4
    val_HW14 = physics2hw('K_INJ1','Setpoint',-val_ph*1e-3);
    % appliquer à l'élément
    setsp('K_INJ1',val_HW14(2),[1 4]);
    % tester les signes !!!!!
    % rafraichir le slider angle
    set(handles.K4_slider4,'Value',-val_ph);
    % rafraichir l'éditeur angle
    set(handles.K4_slider4,'String',num2str2(-val_ph));
    % rafraichir le slider tension
    set(handles.K4_U_slider,'Value',val_HW14(2));
    % rafraichir l'éditeur tension
    set(handles.K4_U_slider,'String',num2str2(val_HW14(2)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

%% kicker K4

val_ph = -str2double(get(hObject,'String'));
val_HW14 = physics2hw('K_INJ1','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ1',val_HW14(2),[1 4]);
% rafraichir le slider 
set(handles.K4_slider4,'Value',-val_ph);
% refraichir la tension
set(handles.K4_U_edit,'String',num2str2(val_HW14(1)));
% rafraichir le slider tension
set(handles.K4_U_slider,'Value',val_HW14(1));

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

%% kicker K4

% afficher dans l'editeur angle
 set(handles.K4_edit4,'String',...
             num2str(get(handles.K4_slider4,'Value')));


val_ph = str2double(handles.K4_edit4,'String');
val_HW14 = physics2hw('K_INJ1','Setpoint',val_ph*1e-3);
% appliquer à l'élément
setsp('K_INJ1',val_HW14(2),[1 4]);
% rafraichir l'éditeur tension
set(handles.K4_U_edit,'String',num2str2(val_HW14(2)));
% rafraichir le slider tension
set(handles.K4_U_slider,'Value',val_HW14(2));

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

L1_H = getappdata(handles.figure1,'L1_H');
L2_H = getappdata(handles.figure1,'L2_H');


deltax = str2num(get(handles.deltax_edit13,'String'));  %mm

% positionner le slider à cette valeur de bump
set(handles.deltax_slider13,'Value',deltax);

deltax = deltax * 1e-3 ;                                % m

% % % L1_H = (50 + 500 + 800 + 300) * 1e-3; % distance centre SA centre SP
% % % L2_H = 1e-3 * 600/2;                  % distance centre SP point d'injection

% % calcul angles septa actifs et septum passif
val_HW_sa = getsp('SEP_A');
val_HW_sp = getsp('SEP_P');

val_ph_sa =  - deltax / L1_H;
val_ph_sp = - val_ph_sa;

val_HW_sa = val_HW_sa + physics2HW('SEP_A','Setpoint',val_ph_sa);
val_HW_sp = val_HW_sp + physics2HW('SEP_P','Setpoint',val_ph_sp);

% appliquer
setsp('SEP_P',val_HW_sp);
setsp('SEP_A',val_HW_sa);

val_ph_sa = HW2physics('SEP_A','Setpoint',val_HW_sa);
val_ph_sp = HW2physics('SEP_P','Setpoint',val_HW_sp);

% rafraichir les edit et slider équipements
set(handles.septum_actif_a_slider,'Value',val_ph_sa*1e3);
set(handles.septum_passif_a_slider,'Value',val_ph_sp*1e3);
set(handles.septum_actif_U_slider,'Value',val_HW_sa);
set(handles.septum_passif_U_slider,'Value',val_HW_sp);
set(handles.septum_actif_a_edit,'String',num2str2(val_ph_sa*1e3));
set(handles.septum_passif_a_edit,'String',num2str2(val_ph_sp*1e3));
set(handles.septum_passif_U_edit,'String',num2str2(val_HW_sp));
set(handles.septum_actif_U_edit,'String',num2str2(val_HW_sa));

%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)


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

L1_H = getappdata(handles.figure1,'L1_H');
L2_H = getappdata(handles.figure1,'L2_H');

% afficher dans l'editeur cette valeur de bump
set(handles.deltax_edit13,'String',num2str(get(handles.deltax_slider13,'Value')));

% lire la valeur affich�e
deltax = get(handles.deltax_slider13,'Value');          % mm
deltax = deltax * 1e-3 ;                                % m

% % % L1_H = (50 + 500 + 800 + 300) * 1e-3; % distance centre SA centre SP
% % % L2_H = 1e-3 * 600/2;                  % distance centre SP point d'injection

% % calcul angles septa actifs et septum passif
val_HW_sa = getsp('SEP_A');
val_HW_sp = getsp('SEP_P');

val_ph_sa = -  deltax / L1_H;
val_ph_sp = - val_ph_sa;

val_HW_sa = val_HW_sa + physics2HW('SEP_A','Setpoint',val_ph_sa);
val_HW_sp = val_HW_sp + physics2HW('SEP_P','Setpoint',val_ph_sp);

setsp('SEP_P','Setpoint',val_HW_sp);
setsp('SEP_A','Setpoint',val_HW_sa);

val_ph_sa = HW2physics('SEP_A','Setpoint',val_HW_sa);
val_ph_sp = HW2physics('SEP_P','Setpoint',val_HW_sp);

% rafraichir les edit et slider équipements
set(handles.septum_actif_a_slider,'Value',val_ph_sa*1e3);
set(handles.septum_passif_a_slider,'Value',val_ph_sp*1e3);
set(handles.septum_actif_U_slider,'Value',val_HW_sa);
set(handles.septum_passif_U_slider,'Value',val_HW_sp);
set(handles.septum_actif_a_edit,'String',num2str2(val_ph_sa*1e3));
set(handles.septum_passif_a_edit,'String',num2str2(val_ph_sp*1e3));
set(handles.septum_passif_U_edit,'String',num2str2(val_HW_sp));
set(handles.septum_actif_U_edit,'String',num2str2(val_HW_sa));



%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)

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

L1_H = getappdata(handles.figure1,'L1_H');
L2_H = getappdata(handles.figure1,'L2_H');

deltaxp = str2num(get(handles.deltaxp_edit14,'String'));  %mm

% positionner le slider à cette valeur de bump
set(handles.deltaxp_slider14,'Value',deltaxp);

deltaxp = deltaxp * 1e-3 ;                                % m

% pour point d'injection = point fixe, rapport entre les angles septum
% passif et les septa actifs : RAP
% % % L1_H = (50 + 500 + 800 + 300) * 1e-3;
% % % L2_H = 1e-3 * 600/2;
RAP = (L1_H-L2_H) / L2_H;

val_HW_sp = getsp('SEP_P');
val_HW_sa = getsp('SEP_A');

val_ph_sp = deltaxp 
val_ph_sa = -deltaxp /RAP 

val_HW_sp = val_HW_sp + physics2HW('SEP_P','Setpoint',val_ph_sp);
val_HW_sa = val_HW_sa + physics2HW('SEP_A','Setpoint',val_ph_sa);
setsp('SEP_P',val_HW_sp);
setsp('SEP_A',val_HW_sa);

val_ph_sa = HW2physics('SEP_A','Setpoint',val_HW_sa);
val_ph_sp = HW2physics('SEP_P','Setpoint',val_HW_sp);

% rafraichir les edit et slider équipements
set(handles.septum_actif_a_slider,'Value',val_ph_sa*1e3);
set(handles.septum_passif_a_slider,'Value',val_ph_sp*1e3);
set(handles.septum_actif_U_slider,'Value',val_HW_sa);
set(handles.septum_passif_U_slider,'Value',val_HW_sp);
set(handles.septum_actif_a_edit,'String',num2str2(val_ph_sa*1e3));
set(handles.septum_passif_a_edit,'String',num2str2(val_ph_sp*1e3));
set(handles.septum_passif_U_edit,'String',num2str2(val_HW_sp));
set(handles.septum_actif_U_edit,'String',num2str2(val_HW_sa));

%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)

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

L1_H = getappdata(handles.figure1,'L1_H');
L2_H = getappdata(handles.figure1,'L2_H');

% afficher dans l'editeur la valeur de courant
 set(handles.deltaxp_edit14,'String',...
             num2str(get(handles.deltaxp_slider14,'Value')));

% lire la valeur affich�e
deltaxp = get(handles.deltaxp_slider14,'Value');
deltaxp = deltaxp * 1e-3;

% pour point d'injection = point fixe, rapport entre les angles septum
% passif et les septa actifs : RAP
% % % L1_H = (50 + 500 + 800 + 300) * 1e-3;
% % % L2_H = 1e-3 * 600/2;
RAP = (L1_H-L2_H) / L2;

val_HW_sp = getsp('SEP_P');
val_HW_sa = getsp('SEP_A');

val_ph_sp = deltaxp 
val_ph_sa = -deltaxp /RAP 

val_HW_sp = val_HW_sp + physics2HW('SEP_P','Setpoint',val_ph_sp);
val_HW_sa = val_HW_sa + physics2HW('SEP_A','Setpoint',val_ph_sa);
setsp('SEP_P','Setpoint',val_HW_sp);
setsp('SEP_A','Setpoint',val_HW_sa);

val_ph_sa = HW2physics('SEP_A','Setpoint',val_HW_sa);
val_ph_sp = HW2physics('SEP_P','Setpoint',val_HW_sp);

% rafraichir les edit et slider équipements
set(handles.septum_actif_a_slider,'Value',val_ph_sa*1e3);
set(handles.septum_passif_a_slider,'Value',val_ph_sp*1e3);
set(handles.septum_actif_U_slider,'Value',val_HW_sa);
set(handles.septum_passif_U_slider,'Value',val_HW_sp);
set(handles.septum_actif_a_edit,'String',num2str2(val_ph_sa*1e3));
set(handles.septum_passif_a_edit,'String',num2str2(val_ph_sp*1e3));
set(handles.septum_passif_U_edit,'String',num2str2(val_HW_sp));
set(handles.septum_actif_U_edit,'String',num2str2(val_HW_sa));

%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)

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

L1_V = getappdata(handles.figure1,'L1_V');
L2_V = getappdata(handles.figure1,'L2_V');
coeff = getappdata(handles.figure1,'etalonnage_V_LT2');

deltaz = str2num(get(handles.deltaz_edit15,'String'));  %mm

% positionner le slider à cette valeur de bump
set(handles.deltaz_slider15,'Value',deltaz);

deltaz = deltaz * 1e-3 ;                                % m

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % Position des correcteurs verticaux : LT2 init getspos('CV') getspos('BPM')
% % % % posBPM_SP = 41.9159 ; posCV4 = 32.4109 ; posCV5 = 35.5859 ;
% % % % 
% % % % L1_V = posCV5 - posCV4 ;                      % distance centre V4 centre V5
% % % % L2 = posBPM_SP - posCV5 ;                   % distance centre V5 point d'injection

% % calcul angles 
val_HW_v4 = getam('LT2/AE/CV.4/current');
val_HW_v5 = getam('LT2/AE/CV.5/current');

val_ph_v4 = deltaz / L1_V;
val_ph_v5 = - val_ph_v4;

val_HW_v4 = val_HW_v4 + val_ph_v4/coeff;
val_HW_v5 = val_HW_v5 + val_ph_v5/coeff;

% TEST si  les valeurs de courant sont inférieures aux valeurs max
val_max = [8 8]';
val_min = [-8 -8]';
consigne = [val_HW_v4 val_HW_v5]';
if all(consigne<val_max)*all(consigne>val_min);

    setsp('LT2/AE/CV.4/current',val_HW_v4);
    setsp('LT2/AE/CV.5/current',val_HW_v5);

    val_ph_v4 = val_HW_v4*coeff;
    val_ph_v5 = val_HW_v5*coeff;

    % rafraichir les edit et slider équipements
    set(handles.CV4_a_slider,'Value',val_ph_v4*1e3);
    set(handles.CV5_a_slider,'Value',val_ph_v5*1e3);
    set(handles.CV4_I_slider,'Value',val_HW_v4);
    set(handles.CV5_I_slider,'Value',val_HW_v5);
    set(handles.CV4_a_edit,'String',num2str2(val_ph_v4*1e3));
    set(handles.CV5_a_edit,'String',num2str2(val_ph_v5*1e3));
    set(handles.CV4_I_edit,'String',num2str2(val_HW_v4));
    set(handles.CV5_I_edit,'String',num2str2(val_HW_v5));

else
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    consigne = consigne
end
%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)




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

L1_V = getappdata(handles.figure1,'L1_V');
L2_V = getappdata(handles.figure1,'L2_V');
coeff = getappdata(handles.figure1,'etalonnage_V_LT2');

% afficher dans l'editeur cette valeur de bump
set(handles.deltaz_edit15,'String',num2str(get(handles.deltaz_slider15,'Value')));

% lire la valeur affich�e
deltaz = get(handles.deltaz_slider15,'Value');          % mm
deltaz = deltaz * 1e-3 ; 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % Position des correcteurs verticaux : LT2 init getspos('CV') getspos('BPM')
% % % % posBPM_SP = 41.9159 ; posCV4 = 32.4109 ; posCV5 = 35.5859 ;
% % % % 
% % % % L1_V = posCV5 - posCV4 ;                      % distance centre V4 centre V5
% % % % L2 = posBPM_SP - posCV5 ;                   % distance centre V5 point d'injection

% % calcul angles 
val_HW_v4 = getam('LT2/AE/CV.4/current');
val_HW_v5 = getam('LT2/AE/CV.5/current');

val_ph_v4 = deltaz / L1_V;
val_ph_v5 = - val_ph_v4;

val_HW_v4 = val_HW_v4 + val_ph_v4/coeff;
val_HW_v5 = val_HW_v5 + val_ph_v5/coeff;


% TEST si  les valeurs de courant sont inférieures aux valeurs max
val_max = [8 8]';
val_min = [-8 -8]';
consigne = [val_HW_v4 val_HW_v5]';
if all(consigne<val_max)*all(consigne>val_min);
    setsp('LT2/AE/CV.4/current',val_HW_v4);
    setsp('LT2/AE/CV.5/current',val_HW_v5);

    val_ph_v4 = val_HW_v4*coeff;
    val_ph_v5 = val_HW_v5*coeff;

    % rafraichir les edit et slider équipements
    set(handles.CV4_a_slider,'Value',val_ph_v4*1e3);
    set(handles.CV5_a_slider,'Value',val_ph_v5*1e3);
    set(handles.CV4_I_slider,'Value',val_HW_v4);
    set(handles.CV5_I_slider,'Value',val_HW_v5);
    set(handles.CV4_a_edit,'String',num2str2(val_ph_v4*1e3));
    set(handles.CV5_a_edit,'String',num2str2(val_ph_v5*1e3));
    set(handles.CV4_I_edit,'String',num2str2(val_HW_v4));
    set(handles.CV5_I_edit,'String',num2str2(val_HW_v5));

else
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    consigne = consigne
end


%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)




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

L1_V = getappdata(handles.figure1,'L1_V');
L2_V = getappdata(handles.figure1,'L2_V');
coeff = getappdata(handles.figure1,'etalonnage_V_LT2');

deltazp = str2num(get(handles.deltazp_edit16,'String'));  %mm

% positionner le slider à cette valeur de bump
set(handles.deltazp_slider16,'Value',deltazp);

deltazp = deltazp * 1e-3 ;                                % m

RAP = (L1_V-L2_V) / L2_V;

% % calcul angles 
val_HW_v4 = getam('LT2/AE/CV.4/current');
val_HW_v5 = getam('LT2/AE/CV.5/current');


val_ph_v5 = deltazp 
val_ph_v4 = -deltazp /RAP 

val_HW_v4 = val_HW_v4 + val_ph_v4/coeff;
val_HW_v5 = val_HW_v5 + val_ph_v5/coeff;

% TEST si  les valeurs de courant sont inférieures aux valeurs max
val_max = [8 8]';
val_min = [-8 -8]';
consigne = [val_HW_v4 val_HW_v5]';
if all(consigne<val_max)*all(consigne>val_min);
    setsp('LT2/AE/CV.4/current',val_HW_v4);
    setsp('LT2/AE/CV.5/current',val_HW_v5);

    val_ph_v4 = val_HW_v4*coeff;
    val_ph_v5 = val_HW_v5*coeff;

    % rafraichir les edit et slider équipements
    set(handles.CV4_a_slider,'Value',val_ph_v4*1e3);
    set(handles.CV5_a_slider,'Value',val_ph_v5*1e3);
    set(handles.CV4_I_slider,'Value',val_HW_v4);
    set(handles.CV5_I_slider,'Value',val_HW_v5);
    set(handles.CV4_a_edit,'String',num2str2(val_ph_v4*1e3));
    set(handles.CV5_a_edit,'String',num2str2(val_ph_v5*1e3));
    set(handles.CV4_I_edit,'String',num2str2(val_HW_v4));
    set(handles.CV5_I_edit,'String',num2str2(val_HW_v5));
else
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    consigne = consigne
end


%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)


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

L1_V = getappdata(handles.figure1,'L1_V');
L2_V = getappdata(handles.figure1,'L2_V');
coeff = getappdata(handles.figure1,'etalonnage_V_LT2');

% afficher dans l'editeur cette valeur de bump
set(handles.deltazp_edit16,'String',num2str(get(handles.deltazp_slider16,'Value')));

% lire la valeur affich�e
deltazp = get(handles.deltazp_slider16,'Value');          % mm
deltazp = deltazp * 1e-3;

RAP = (L1_V-L2_V) / L2_V;

% % calcul angles 
val_HW_v4 = getam('LT2/AE/CV.4/current');
val_HW_v5 = getam('LT2/AE/CV.5/current');

val_ph_v5 = deltazp 
val_ph_v4 = -deltazp /RAP 

val_HW_v4 = val_HW_v4 + val_ph_v4/coeff;
val_HW_v5 = val_HW_v5 + val_ph_v5/coeff;

% TEST si  les valeurs de courant sont inférieures aux valeurs max
val_max = [8 8]';
val_min = [-8 -8]';
consigne = [val_HW_v4 val_HW_v5]';
if all(consigne<val_max)*all(consigne>val_min);

    setsp('LT2/AE/CV.4/current',val_HW_v4);
    setsp('LT2/AE/CV.5/current',val_HW_v5);

    val_ph_v4 = val_HW_v4*coeff;
    val_ph_v5 = val_HW_v5*coeff;

    % rafraichir les edit et slider équipements
    set(handles.CV4_a_slider,'Value',val_ph_v4*1e3);
    set(handles.CV5_a_slider,'Value',val_ph_v5*1e3);
    set(handles.CV4_I_slider,'Value',val_HW_v4);
    set(handles.CV5_I_slider,'Value',val_HW_v5);
    set(handles.CV4_a_edit,'String',num2str2(val_ph_v4*1e3));
    set(handles.CV5_a_edit,'String',num2str2(val_ph_v5*1e3));
    set(handles.CV4_I_edit,'String',num2str2(val_HW_v4));
    set(handles.CV5_I_edit,'String',num2str2(val_HW_v5));
else
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    consigne = consigne
end


%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)

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
% % valeurs 4 kickers en tension
val_HW14 = physics2HW('K_INJ1','Setpoint',-val_ph_K);
val_HW23 = physics2HW('K_INJ2','Setpoint',val_ph_K);
% % appliquer les 4 valeurs 
setsp('K_INJ1',val_HW14(1));
setsp('K_INJ2',val_HW23(1));

% afficher dans edit angles des kickers
set(handles.K1_edit1,'String',num2str2(val_ph_K*1e3)); 
set(handles.K4_edit4,'String',num2str2(val_ph_K*1e3)); 
set(handles.K2_edit2,'String',num2str2(val_ph_K*1e3)); 
set(handles.K3_edit3,'String',num2str2(val_ph_K*1e3)); 

% re-initaliser les sliders angles
set(handles.K1_slider1,'Value',val_ph_K*1e3);
set(handles.K2_slider2,'Value',val_ph_K*1e3);
set(handles.K3_slider3,'Value',val_ph_K*1e3);
set(handles.K4_slider4,'Value',val_ph_K*1e3);

% afficher dans edit tension des kickers
set(handles.K1_U_edit,'String',num2str2(val_HW14(1))); 
set(handles.K4_U_edit,'String',num2str2(val_HW14(2))); 
set(handles.K2_U_edit,'String',num2str2(val_HW23(1))); 
set(handles.K3_U_edit,'String',num2str2(val_HW23(2)));

% re-initaliser les sliders tension
set(handles.K1_U_slider,'Value',val_HW14(1));
set(handles.K2_U_slider,'Value',val_HW14(2));
set(handles.K3_U_slider,'Value',val_HW23(1));
set(handles.K4_U_slider,'Value',val_HW23(2));

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)


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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(1) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(1) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(2) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(2) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
end
setappdata(handles.figure1,'num_BPM_actif',num_BPM_actif);
setappdata(handles.figure1,'BPMxList',BPMxList);
mycallbackenergytunette(1,1,hObject, eventdata, handles)


% --- Executes on button press in BPM3_checkbox.
function BPM3_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BPM3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM3_checkbox
nbmaxBPM = getappdata(handles.figure1,'nbmaxBPM');
BPMxList = getappdata(handles.figure1,'BPMxList');
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(3) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(3) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(4) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(4) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(5) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(5) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(6) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(6) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(7) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(7) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(8) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(8) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(9) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(9) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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
% mettre à jour d'éventue
num_BPM_actif = getappdata(handles.figure1,'num_BPM_actif');
BPMxListtotal = family2dev('BPMx', 0 );  

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    num_BPM_actif(10) = 1;
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
else
    % checkbox is not checked-take approriate action
    num_BPM_actif(10) = 0; 
    BPMxList = BPMxListtotal(find(num_BPM_actif),:);
    %BPMxList = intersect(BPMxList,BPMxListtotal([(1:8),(10:nbmaxBPM)],:),'rows');
    
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

% afficher dans le slider angle
 set(handles.K1_U_slider,'Value',...
             str2double(get(hObject,'String')));

 val_HW14 = str2num(get(handles.K1_U_edit,'String'));
 val_ph =  1000*hw2physics('K_INJ1','Setpoint',val_HW14);  
 % appliquer à l'élément
setsp('K_INJ1',val_HW14,[1 1]);
% rafraichir l'éditeur angle
set(handles.K1_edit1,'String',num2str2(-val_ph(1)));
% rafraichir le slider angle
set(handles.K1_slider1,'Value',-val_ph(1));

if get(handles.dissym,'Value')
    % valeur d'angle identique dans K2
    val_HW23 = physics2hw('K_INJ2','Setpoint',-val_ph(1)*1e-3);
    % appliquer à l'élément
    setsp('K_INJ2',val_HW23(2),[1 2]);
    % tester les signes !!!!!
    % rafraichir le slider angle
    set(handles.K2_slider2,'Value',-val_ph(1));
    % rafraichir l'éditeur angle
    set(handles.K2_edit2,'String',num2str2(-val_ph(1)));
    % rafraichir le slider tension
    set(handles.K2_U_slider,'Value',val_HW23(2));
    % rafraichir l'éditeur tension
    set(handles.K2_U_edit,'String',num2str2(val_HW23(2)));
end
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

set(handles.K2_U_slider,'Value',...
             str2double(get(hObject,'String')));

 val_HW23 = str2num(get(handles.K2_U_edit,'String'));
 val_ph =  1000*hw2physics('K_INJ2','Setpoint',val_HW23);  
 % appliquer à l'élément
setsp('K_INJ2',val_HW23,[1 2]);
% rafraichir l'éditeur angle
set(handles.K2_edit2,'String',num2str2(val_ph(1)));
% rafraichir le slider angle
set(handles.K2_slider2,'Value',val_ph(1));
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

% afficher dans le slider angle

 set(handles.K3_U_slider,'Value',...
             str2double(get(hObject,'String')));

 val_HW23 = str2num(get(handles.K3_U_edit,'String'));
 val_ph =  1000*hw2physics('K_INJ2','Setpoint',val_HW23);  
 % appliquer à l'élément
setsp('K_INJ2',val_HW23,[1 3]);
% rafraichir l'éditeur angle
set(handles.K3_edit3,'String',num2str2(val_ph(1)));
% rafraichir le slider angle
set(handles.K3_slider3,'Value',val_ph(1));

if get(handles.dissym,'Value')
    % valeur d'angle identique dans K4
    val_HW14 = physics2hw('K_INJ1','Setpoint',-val_ph(1)*1e-3);
    % appliquer à l'élément
    setsp('K_INJ1',val_HW14(2),[1 4]);
    % tester les signes !!!!!
    % rafraichir le slider angle
    set(handles.K4_slider4,'Value',val_ph(1));
    % rafraichir l'éditeur angle
    set(handles.K4_edit4,'String',num2str2(val_ph(1)));
    % rafraichir le slider tension
    set(handles.K4_U_slider,'Value',val_HW14(2));
    % rafraichir l'éditeur tension
    set(handles.K4_U_edit,'String',num2str2(val_HW14(2)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir l'orbite
mycallbackenergytunette(1,1,hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%% rafraichir le bump kicker
mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)



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

% afficher dans le slider angle
 set(handles.K4_U_slider,'Value',...
             str2double(get(hObject,'String')));

 val_HW14 = str2num(get(handles.K4_U_edit,'String'));
 val_ph =  1000*hw2physics('K_INJ1','Setpoint',val_HW14);  
 % appliquer à l'élément
setsp('K_INJ1',val_HW14,[1 4]);
% rafraichir l'éditeur angle
set(handles.K4_edit4,'String',num2str2(-val_ph(1)));
% rafraichir le slider angle
set(handles.K4_slider4,'Value',-val_ph(1));

mycallbackenergytunette_kicker(1,1,hObject, eventdata, handles)

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

% valeur d'angle
val_phSA = str2double(get(hObject,'String'));
val_HWSA = physics2hw('SEP_A','Setpoint',val_phSA*1e-3);
% appliquer à l'élément
setsp('SEP_A',val_HWSA);
% rafraichir le slider 
set(handles.septum_actif_a_slider,'Value',val_phSA);
% rafraichir l'élément tension
set(handles.septum_actif_U_slider,'Value',val_HWSA);
set(handles.septum_actif_U_edit,'String',num2str2(val_HWSA));


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

% valeur d'angle
val_phSP = str2double(get(hObject,'String'));
val_HWSP = physics2hw('SEP_P','Setpoint',val_phSP*1e-3);
% appliquer à l'élément
setsp('SEP_P',val_HWSP);
% rafraichir le slider 
set(handles.septum_passif_a_slider,'Value',val_phSP);
% rafraichir l'élément tension
set(handles.septum_passif_U_slider,'Value',val_HWSPA);
set(handles.septum_passif_U_edit,'String',num2str2(val_HWSP));


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

coeff = getappdata(handles.figure1,'etalonnage_V_LT2');
val_ph_v4 = str2double(get(hObject,'String'));
val_HW_v4 = val_ph_v4*1e-3 / coeff;
setsp('LT2/AE/CV.4/current',val_HW_v4);
% rafraichir les edit et slider équipements
set(handles.CV4_a_slider,'Value',val_ph_v4);
set(handles.CV4_I_slider,'Value',val_HW_v4);
set(handles.CV4_I_edit,'String',num2str2(val_HW_v4));


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

coeff = getappdata(handles.figure1,'etalonnage_V_LT2');
val_ph_v5 = str2double(get(hObject,'String'));
val_HW_v5 = val_ph_v5*1e-3 / coeff;
setsp('LT2/AE/CV.5/current',val_HW_v5);
% rafraichir les edit et slider équipements
set(handles.CV5_a_slider,'Value',val_ph_v5);
set(handles.CV5_I_slider,'Value',val_HW_v5);
set(handles.CV5_I_edit,'String',num2str2(val_HW_v5));



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

% valeur d'angle
val_HWSP = str2double(get(hObject,'String'));
val_phSP = hw2physics('SEP_P','Setpoint',val_HWSP);
% appliquer à l'élément
setsp('SEP_P',val_HWSP);
% rafraichir le slider 
set(handles.septum_passif_U_slider,'Value',val_HWSP);
% rafraichir l'élément angle
set(handles.septum_passif_a_slider,'Value',val_phSP*1000);
set(handles.septum_passif_a_edit,'String',num2str2(val_phSP*1000));

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

coeff = getappdata(handles.figure1,'etalonnage_V_LT2');
val_HW_v4 = str2double(get(hObject,'String'));
val_ph_v4 = val_HW_v4*1e3 * coeff;
setsp('LT2/AE/CV.4/current',val_HW_v4);
% rafraichir les edit et slider équipements
set(handles.CV4_a_slider,'Value',val_ph_v4);
set(handles.CV4_I_slider,'Value',val_HW_v4);
set(handles.CV4_a_edit,'String',num2str2(val_ph_v4));


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

coeff = getappdata(handles.figure1,'etalonnage_V_LT2');
val_HW_v5 = str2double(get(hObject,'String'));
val_ph_v5 = val_HW_v5*1e3 * coeff;
setsp('LT2/AE/CV.5/current',val_HW_v5);
% rafraichir les edit et slider équipements
set(handles.CV5_a_slider,'Value',val_ph_v5);
set(handles.CV5_I_slider,'Value',val_HW_v5);
set(handles.CV5_a_edit,'String',num2str2(val_ph_v5));

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

% valeur d'angle
val_HWSA = str2double(get(hObject,'String'));
val_phSA = hw2physics('SEP_A','Setpoint',val_HWSA);
% appliquer à l'élément
setsp('SEP_A',val_HWSA);
% rafraichir le slider 
set(handles.septum_actif_U_slider,'Value',val_HWSA);
% rafraichir l'élément angle
set(handles.septum_actif_a_slider,'Value',val_phSA*1000);
set(handles.septum_actif_a_edit,'String',num2str2(val_phSA*1000));



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

function value = num2str2(val)

value = num2str(val,'%6.2f');

%% What to do before closing the application
function Closinggui(obj, event, handles, figure1)

%device_name = getappdata(handles.figure1,'device_name');

% Get default command line output from handles structure
answer = questdlg('Fermer Energytunette ?',...
    'Exit Programme Energytunette',...
    'Yes','No','Yes');

switch answer
    case 'Yes'           
        delete(handles); %Delete Timer        
        delete(figure1); %Close gui
        %% extraire l'écran YAG
        %tango_command_inout(device_name.ecran,'Extract');
        %fonction_error;
    otherwise
        disp('Closing aborted')
end


