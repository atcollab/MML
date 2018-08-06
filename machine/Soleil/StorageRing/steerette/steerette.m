function varargout = steerette(varargin)
% STEERETTE M-file for steerette.fig
%      STEERETTE, by itself, creates a new STEERETTE or raises the existing
%      singleton*.
%
%      H = STEERETTE returns the handle to a new STEERETTE or the handle to
%      the existing singleton*.
%
%      STEERETTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEERETTE.M with the given input arguments.
%
%      STEERETTE('Property','Value',...) creates a new STEERETTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before steerette_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to steerette_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help steerette

% Last Modified by GUIDE v2.5 30-May-2006 17:40:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @steerette_OpeningFcn, ...
                   'gui_OutputFcn',  @steerette_OutputFcn, ...
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

% --- Executes just before steerette is made visible.
function steerette_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to steerette (see VARARGIN)

% Choose default command line output for steerette
handles.output = hObject;

setappdata(handles.figure1, 'BPMxList', family2dev('BPMx'));
setappdata(handles.figure1, 'BPMzList', family2dev('BPMz'));
setappdata(handles.figure1,'BPMxDeviceListPR',[]); 
% orbite premier tour avec  kick pour mesure partie entiere nombre d'onde
setappdata(handles.figure1,'orbite_x_coup1',0);
setappdata(handles.figure1,'orbite_z_coup1',0);
setappdata(handles.figure1,'orbite_x_coup2',0);
setappdata(handles.figure1,'orbite_z_coup2',0);
% enregistrement valeur correcteurs fermeture tour
setappdata(handles.figure1,'val_corr_CH_PR',0);
setappdata(handles.figure1,'val_corr_CV_PR',0);

% compteur du nombre d'acquisition orbite transport pour calcul nombre d'onde
setappdata(handles.figure1,'compteur',0);

% initialisation de la machine
if isempty(getao) 
        disp('Warning: CHARGER L''AcceleratorObjects !!!!!!!');
        return
else
        Machine = getfamilydata('SubMachine');
        switch Machine
            case 'StorageRing'
                %% 
            case 'Booster'
                %%%
            otherwise                
            disp('Warning: Machine not recognized!');
            return
        end
end

% nom nomenclature et positions des correcteurs actifs, positions BPM actifs
HCOR.DeviceName = family2tangodev('HCOR');% getfamilydata('HCOR','DeviceName',family2dev('HCOR'));
VCOR.DeviceName = family2tangodev('VCOR');% getfamilydata('VCOR','DeviceName',family2dev('VCOR'));
HCOR.DeviceList = family2dev('HCOR');% getfamilydata('HCOR','DeviceName',family2dev('HCOR'));
VCOR.DeviceList = family2dev('VCOR');% getfamilydata('VCOR','DeviceName',family2dev('VCOR'));
HCOR.Position = getspos('HCOR');% getfamilydata('HCOR','Position',family2dev('HCOR'));
VCOR.Position =  getspos('VCOR');% getfamilydata('VCOR','Position',family2dev('VCOR'));
BPMx.Position = getspos('BPMx');% getfamilydata('BPMx','Position',family2dev('BPMx'));
BPMz.Position = getspos('BPMz');% getfamilydata('BPMz','Position',family2dev('BPMz'));
BPMx.DeviceList = family2dev('BPMx');
BPMz.DeviceList = family2dev('BPMz');
setappdata(handles.figure1,'HCOR',HCOR);
setappdata(handles.figure1,'VCOR',VCOR);
setappdata(handles.figure1,'BPMx',BPMx);
setappdata(handles.figure1,'BPMz',BPMz);

% initalisation popupmenu
set(handles.CH_popupmenu2, 'String', {'liste correcteurs horizontaux', HCOR.DeviceName{:}});
set(handles.CV_popupmenu3, 'String', {'liste correcteurs verticaux', VCOR.DeviceName{:}});

% initialisation matrice singular values en H et V
S = [];S_V = [];
setappdata(handles.figure1,'S',S);
setappdata(handles.figure1,'S_V',S_V);

% initialisation nbre de correcteurs utilis�s pour la SVD (� 2 !)
setappdata(handles.nb_correcteurs_H_edit17,'String',num2str(2));
setappdata(handles.nb_correcteurs_V_edit,'String',num2str(2));

% initialisation du nombre de valeurs propres utilis�es 
% setappdata(handles.figure1,'valvp',size(S,2));
% setappdata(handles.figure1,'valvp_V',size(S_V,2));
DiagS = diag(S); DiagS_V = diag(S_V);
setappdata(handles.figure1,'valvp',length(DiagS));
setappdata(handles.figure1,'valvp_V',length(DiagS_V));



% liste des correcteurs H actifs  type : numero cellule numero correcteur
% dans la cellule
HCOR_liste = family2dev('HCOR');
VCOR_liste = family2dev('VCOR');
setappdata(handles.figure1,'HCOR_liste',HCOR_liste);
setappdata(handles.figure1,'VCOR_liste',VCOR_liste);


% nombre max de correcteurs
setappdata(handles.figure1,'maxvalCH',size(HCOR.DeviceName,1));
setappdata(handles.figure1,'maxvalCV',size(VCOR.DeviceName,1));

% numero du correcteur courant (initialisation)
setappdata(handles.figure1,'n_selection_CH',0);
setappdata(handles.figure1,'n_selection_CV',0);

% desactiver le pushbutton "correcteur precedent"
set(handles.CH_precedent_pushbutton4,'Enable','off');
set(handles.CV_precedent_pushbutton23,'Enable','off');
% desactiver le pushbutton "correcteur suivant"
set(handles.CH_suivant_pushbutton5,'Enable','off'); 
set(handles.CV_suivant_pushbutton24,'Enable','off'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% button group sur switch mode transport ou orbite fermée

set(handles.Ntours_edit,'Enable','on');% rendre impossible le controle du nombre de tours
set(handles.tour_fixe_OF_edit,'Enable','on');% rendre impossible le controle du 1er tour moyenne OF
set(handles.tour_fixe_T_edit,'Enable','on');% rendre impossible le controle du 1er tour fixe transport

w = uibuttongroup('visible','off','Position',[0.41 0.945 .55 .045],...
    'Title','Orbite','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
w1 = uicontrol('Style','Radio','String','transport - max Sum','Tag','radiobutton1',...
    'pos',[10 0.95 120 20],'parent',w,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
w2 = uicontrol('Style','Radio','String','orbite fermée','Tag','radiobutton2',...
    'pos',[320. 0.95 90 20],'parent',w,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
w3 = uicontrol('Style','Radio','String','transport - tour fixe','Tag','radiobutton3',...
    'pos',[140 0.95 120 20],'parent',w,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

handles.orbite = 'transport - tour fixe';
setappdata(handles.figure1,'Orbite','transport - tour fixe');


set(w,'SelectedObject',w3);  % No selection
set(w,'Visible','on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% button group sur switch mode simulation ou online 
h = uibuttongroup('visible','off','Position',[0.25 0.945 .15 .045],...
    'Title','Mode','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
u1 = uicontrol('Style','Radio','String','MODEL','Tag','radiobutton1',...
    'pos',[10 0.95 70 20],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
u2 = uicontrol('Style','Radio','String','Online','Tag','radiobutton2',...
    'pos',[70. 0.95 70 20],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

%handles.model = u1;
%handles.online = u2;
% 2 façons d'enregistrer la variable mode : pas propre mais fait pour gérer pb variable appelée par timer
%handles.mode = 'Model';
%setappdata(handles.figure1,'Mode','Model');
% TEST RUN !
handles.mode = 'Online';
setappdata(handles.figure1,'Mode','Online');




set(h,'SelectedObject',u2);  % No selection
set(h,'Visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creates timer Infinite loop for TIME
timer2=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',20.,'TasksToExecute',Inf);
timer2.TimerFcn = {@mycallback_steerette_heure, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer2',timer2);
start(timer2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creates timer Infinite loop
timer1=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',4.,'TasksToExecute',Inf);
timer1.TimerFcn = {@mycallback_steerette_new, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer',timer1);

%start(timer1);


% button group sur switch timer rafraichissement orbites ON OFF
g = uibuttongroup('visible','off','Position',[0.45 0.57 .15 .045],...
    'Title','Rafraichissement','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
v1 = uicontrol('Style','Radio','String','ON','Tag','radiobutton1',...
    'pos',[10 0.95 60 25],'parent',g,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
v2 = uicontrol('Style','Radio','String','  OFF','Tag','radiobutton2',...
    'pos',[90. 0.95 60 25],'parent',g,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

% handles.on  = v1;
% handles.off = v2;

% Update handles structure
guidata(hObject, handles); % ça ne mange pas de pain

set(g,'SelectedObject',v2);  % No selection
set(g,'Visible','on');

% Update handles structure
guidata(hObject, handles); % ça ne mange pas de pain

set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});
set(w,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn_orbite,handles});
set(g,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn_timer,handles});

% Update handles structure
guidata(hObject, handles); % ça ne mange pas de pain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This sets up the initial plot - only do when we are invisible
% so window can get raised using steerette.
if strcmp(get(hObject,'Visible'),'off')


    if strcmp(handles.mode,'Model')

        %t% version transport
        % g�n�ration d'une ellipse 1 sigma et d�centrement
        eps = 150e-9;betax = 3 ;betaz = 3 ;alphax = 0;alphaz = 0;
        deltax = 2e-3;deltaz = 2e-3;deltaxp = 1e-3;deltazp = 1e-3;
        X0 = [sqrt(eps * betax) + deltax 0 sqrt(eps * betaz) + deltaz 0 0 0 ;...
            0  sqrt(eps / betax) + deltaxp 0 sqrt(eps / betaz) + deltazp 0 0 ;...
            -sqrt(eps * betax)+ deltax 0 -sqrt(eps * betaz)+ deltaz 0 0 0 ;...
            0  -sqrt(eps / betax)+deltaxp 0 -sqrt(eps / betaz)+deltazp 0 0 ]';
        setappdata(handles.figure1,'orbite_entry',X0);

        % nP = nbre de particules trackees
        nP = size(X0,2);
        BPMindex = family2atindex('BPMx');
        global THERING
        nbtour = 1;
        X01 = zeros(nbtour, 6, nP*length(BPMindex));

        for k=1:nbtour,
            X01(k,:,:) = linepass(THERING, X0, BPMindex);
            %X0 = X01(k,:,end)';
        end
        Xa = squeeze(X01(1,1,:));
        Za = squeeze(X01(1,3,:));
        if nP>1
            X = [];
            Z = [];
            for nBPM = 1:length(BPMindex)
                X = [X mean(Xa((nP*(nBPM-1)+1):nP*nBPM))];
                Z = [Z mean(Za((nP*(nBPM-1)+1):nP*nBPM))];
            end
            orbite_x = X'*1000;orbite_z = Z'*1000;
            orbite_sum = 1e6*(0.75 + 0.5*rand(length(BPMindex),1))';
        else
            orbite_x = Xa*1000;orbite_z = Za*1000;
            orbite_sum = 1e6*(0.75 + 0.5*rand(length(BPMindex),1))';
        end

    else
        % entrer lecture BPM tour par tour :selectionner le premier tour
        % sortir un orbite_x et orbite_z
        % test anneau
        %BPMx.DeviceList = [1     2;1     3;1     4;1     5;1     6]
        [X Z Sum] = anabpmnfirstturns( BPMx.DeviceList ,1,7,'NoDisplay2','MaxSum');

        %
        orbite_x = X';
        orbite_z = Z';
        orbite_sum = Sum';
    end

    setappdata(handles.figure1,'orbite_x',orbite_x);
    setappdata(handles.figure1,'orbite_z',orbite_z);
    setappdata(handles.figure1,'orbite_sum',orbite_sum);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% graphe 1 : signal somme
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    name=['axes' num2str(8)];
    axes(handles.(name));
    xdata = BPMx.Position;
    %xdata = 1:length(orbite_sum);
    plot(xdata,orbite_sum,'c.-','Tag','line8');
    set(handles.(name), 'YGrid','On','Xgrid','On');
    set(gca, 'YMinorTick','On');
    set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'position du BPM');
    ylabel(handles.(name),'signal somme');
    %xlim([xdata(1) xdata(end)]);
    %ylim([0 max(orbite_sum)]);
    ylim([0 1.e8]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% graphe 2 : orbite x et z
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    name=['axes' num2str(3)];
    axes(handles.(name));
    % plot des orbites
    xdata = BPMx.Position;
    %xdata = 1:length(orbite_x);
    plot(xdata,orbite_x,'r.-','Tag','line1');
    hold on
    ydata = BPMz.Position;
    %ydata = 1:length(orbite_z);
    plot(ydata,orbite_z,'b.-','Tag','line2');
    hold on

    % plot des BPM initiaux
    k = 1;
    plot(xdata(k),orbite_x(k),'rp','MarkerEdgeColor','k',...
        'MarkerFaceColor','r',...
        'MarkerSize',12,'Tag','line3');
    hold on
    plot(xdata(k),orbite_z(k),'rp','MarkerEdgeColor','k',...
        'MarkerFaceColor','b',...
        'MarkerSize',12,'Tag','line4');
    hold off

    %% Set defaults
    set(handles.(name), 'Nextplot','Add');
    set(handles.(name), 'YGrid','On','Xgrid','On');
    set(gca, 'YMinorTick','On');
    set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'position du BPM');
    ylabel(handles.(name),'orbites (mm)');
    %xlim([xdata(1) xdata(end)]);
    %ylim([-10 10]);
    ylim([-5 5]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% graphe 3 et 4 : correcteurs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    name=['axes' num2str(9)];
    axes(handles.(name));
    xbar = HCOR.Position;
    %xbar = 1: size(HCOR.DeviceName,1);
    ybar = VCOR.Position;
    %ybar = 1:size(VCOR.DeviceName,1);
    liste = getam('HCOR',handles.mode);
    h0 = bar(xbar,liste,'r','Tag','bar1');
    xlim(handles.(name),[0 max(HCOR.Position)]);
    %xlim(handles.(name),[0 size(HCOR.DeviceName,1)+1]);
    %ylim([-1.5 1.5]);
    ylim(handles.(name),[-10 10]);
    ylabel(handles.(name),'Icorr H (A)');
    set(h0, 'FaceColor','r');

    name=['axes' num2str(10)];
    axes(handles.(name));
    liste = getam('VCOR',handles.mode);
    h1 = bar(ybar,liste,'b','Tag','bar2');
    set(h1, 'FaceColor','b');
    xlim(handles.(name),[0 max(VCOR.Position)]);
    %xlim(handles.(name),[0 size(VCOR.DeviceName,1)+1]);
    ylim(handles.(name),[-13 13]);
    xlabel(handles.(name),'position du correcteur');
    ylabel(handles.(name),'Icorr V (A)');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% graphe 11 : signal somme tour 1 et 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    name=['axes' num2str(11)];
    axes(handles.(name));

    % plot le tour 1 et 2 des BPM [1 2] à [1  7]
    List = getappdata(handles.figure1, 'BPMxList'); % BPM non deselectionné et status 1
    BPMxDeviceListPR = [ 1 2; 1 3 ; 1 4; 1 5; 1 6 ; 1 7];
    % tests !!!!!!!!!!!!!!!!!!!!!!!!!
    BPMxDeviceListPR = intersect(List,BPMxDeviceListPR,'rows');
    setappdata(handles.figure1,'BPMxDeviceListPR',BPMxDeviceListPR);

    if strcmp(handles.mode,'Model')
        disp('nothing')
        X = zeros(size(BPMxDeviceListPR,1),1);
        orbite_x_1  = X ;  orbite_x_2  = X;
        orbite_z_1 = X  ;  orbite_z_2 = X;
        orbite_sum_1  = X; orbite_sum_2  = X;
    else
        % on préfère chercher les 2 orbites lorsque on appuyera sur
        % "rafraichir orbites" ce qui supposera qu'elles auront un sens
        %X  = zeros(size(BPMxDeviceListPR),1)';Z = X;Sum = X;
        [X Y Sum] = anabpmnfirstturns(BPMxDeviceListPR,2,'NoDisplay2');   % 2 tours
        
        %
        orbite_x_1 = X(1,:)';
        orbite_z_1 = Y(1,:)';
        orbite_sum_1 = Sum(1,:)';

        orbite_x_2 = X(2,:)';
        orbite_z_2 = Y(2,:)';
        orbite_sum_2 = Sum(2,:)';
    end


    xdata = getspos('BPMx',BPMxDeviceListPR);
    plot(xdata,orbite_sum_1,'c.--','Tag','line1');
    hold on
    plot(xdata,orbite_sum_2,'c.-','Tag','line2');
    set(handles.(name), 'YGrid','On','Xgrid','On');
    set(gca, 'YMinorTick','On');
    set(handles.(name), 'XMinorTick','On');

    ylabel(handles.(name),'signal somme');
    xlim([xdata(1) xdata(end)]);
    %ylim([0 max(orbite_sum)]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% graphe 13 : orbite x et z
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    name=['axes' num2str(13)];
    axes(handles.(name));
    % plot des orbites
    xdata =getspos('BPMx',BPMxDeviceListPR);
    %xdata = 1:length(orbite_x);
    plot(xdata,orbite_x_1,'r.--','Tag','line1');
    hold on
    plot(xdata,orbite_x_2,'r.-','Tag','line2');
    hold on
    %ydata = BPMz.Position;
    %ydata = 1:length(orbite_z);
    plot(xdata,orbite_z_1,'b.--','Tag','line3');
    hold on
    plot(xdata,orbite_z_2,'b.-','Tag','line4');
    set(handles.(name), 'YGrid','On','Xgrid','On');
    set(gca, 'YMinorTick','On');
    set(handles.(name), 'XMinorTick','On');

    xlabel(handles.(name),'position du BPM');
    ylabel(handles.(name),'orbite (mm)');
    xlim([xdata(1) xdata(end)]);
    ylim([-10 10]);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  matrice efficacite :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

enregistrement = 0;
if enregistrement
    if strcmp(handles.orbite,'transport - max Sum')
        % calcul des efficacit�s des correcteurs type transport
        % eff (CORRI, BPMJ) = sqrt( betaI  * betaJ )  * sin ( phase J - phase I)
        % SI BPMJ situ� au del� de CORRI

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % plan H
        [bxHCOR,bzHCOR] = modelbeta('HCOR');
        [bxBPM,bzBPM] = modelbeta('BPMx');
        [phixHCOR,phizHCOR] = modelphase('HCOR');
        [phixBPM,phizBPM] = modelphase('BPMx');
        COEFF = hw2physics('HCOR','Setpoint',1) * 1e3 ;  % mrad/A

        for k = 1:length(HCOR.Position)
            for j = 1:length(BPMx.Position)

                if BPMx.Position(j) > HCOR.Position(k)
                    % calcul de l'efficacit�
                    Meff(j,k) = sqrt(bxHCOR(k)*bxBPM(j)) * sin(phixBPM(j) - phixHCOR(k))*COEFF(k); % mm/A
                else
                    Meff(j,k)= 0;
                end

            end
        end

        disp('***  Matrice d''efficacit� H type transport calculée en mm/A ***')

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % plan V
        [bxVCOR,bzVCOR] = modelbeta('VCOR');
        [bxBPM,bzBPM] = modelbeta('BPMz');
        [phixVCOR,phizVCOR] = modelphase('VCOR');
        [phixBPM,phizBPM] = modelphase('BPMz');
        COEFF = hw2physics('VCOR','Setpoint',1) * 1e3 ;

        for k = 1:length(VCOR.Position)
            for j = 1:length(BPMz.Position)

                if BPMz.Position(j) > VCOR.Position(k)
                    % calcul de l'efficacit�
                    Meff_V(j,k) = sqrt(bzVCOR(k)*bzBPM(j)) * sin(phizBPM(j) - phizVCOR(k))*COEFF(k);
                else
                    Meff_V(j,k)= 0;
                end

            end
        end

        disp('***  Matrice d''efficacit� V type transport calculée en mm/A ***')

        % enregistrement
        directory = getfamilydata('Directory','Steerette');
        directory_actuelle = pwd;

        cd(directory)
        % nouvelle maille avec champ de fuite dans les dipoles
        Name = 'solamor2linb_new_13mai_Meff';
        save(Name,'Meff','Meff_V','-mat');

        cd(directory_actuelle);
    else
        disp('matrice réponse déjà enregistrée');

    end
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % chargement de la matrice efficacite
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(handles.orbite,'transport - max Sum')
        directory = getfamilydata('Directory','Steerette');
        Name = 'solamor2linb_new_13mai_Meff';
        filename = strcat(directory,Name);
        S = load('-mat',filename);
        Meff = S.Meff ; Meff_V = S.Meff_V;
    else
        M = getbpmresp('Struct'); % matrice réponse type anneau
        Meff = M(1,1).Data ; Meff_V = M(2,2).Data ;
    end
end
setappdata(handles.figure1,'Meff',Meff);
setappdata(handles.figure1,'Meff_V',Meff_V);

%% Set closing gui function
set(handles.figure1,'CloseRequestFcn',{@Closinggui,timer1,handles.figure1});



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes steerette wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = steerette_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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

% % --------------------------------------------------------------------
% function CloseMenuItem_Callback(hObject, eventdata, handles)
% % hObject    handle to CloseMenuItem (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
%                      ['Close ' get(handles.figure1,'Name') '...'],...
%                      'Yes','No','Yes');
% if strcmp(selection,'No')
%     return;
% end
% 
% delete(handles.figure1)

function uibuttongroup_SelectionChangeFcn(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here       
        handles.mode = 'Model';
        setappdata(handles.figure1,'Mode','Model'); % special timer !
        
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        handles.mode = 'Online';
        setappdata(handles.figure1,'Mode','Online'); % special timer !
end

% Update handles structure
guidata(hObject, handles);

function uibuttongroup_SelectionChangeFcn_timer(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

timer1 = getappdata(handles.figure1,'Timer');
switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here
        start(timer1);
       
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        stop(timer1);
        
end


function uibuttongroup_SelectionChangeFcn_orbite(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here       
        handles.orbite = 'transport - max Sum';
        setappdata(handles.figure1,'Orbite','transport - max Sum'); %
        % charger la matrice efficacite type transport
        directory = getfamilydata('Directory','Steerette');
        Name = 'solamor2linb_new_13mai_Meff';
        filename = strcat(directory,Name);
        S = load('-mat',filename);
        Meff = S.Meff ; Meff_V = S.Meff_V;

        setappdata(handles.figure1,'Meff',Meff);
        setappdata(handles.figure1,'Meff_V',Meff_V);
        
        set(handles.Ntours_edit,'Enable','off');% rendre impossible le controle du nombre de tours
        set(handles.tour_fixe_OF_edit,'Enable','off');% rendre impossible le controle du 1er tour moyenne OF
        set(handles.tour_fixe_T_edit,'Enable','off');% rendre impossible le controle du 1er tour fixe transport
        
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here
        handles.orbite = 'orbite fermée';
        setappdata(handles.figure1,'Orbite','orbite fermée'); %
        set(handles.Ntours_edit,'Enable','on');% rendre possible le controle du nombre de tours
        % charger la matrice efficacite type anneau
        M = getbpmresp('Struct'); % matrice réponse type anneau
        Meff = M(1,1).Data ; Meff_V = M(2,2).Data ;
        setappdata(handles.figure1,'Meff',Meff);
        setappdata(handles.figure1,'Meff_V',Meff_V);
        
        set(handles.Ntours_edit,'Enable','on');% rendre impossible le controle du nombre de tours
        set(handles.tour_fixe_OF_edit,'Enable','on');% rendre impossible le controle du 1er tour moyenne OF
        set(handles.tour_fixe_T_edit,'Enable','off');% rendre impossible le controle du 1er tour fixe transport
        
   case 'radiobutton3'
        % code piece when radiobutton3 is selected goes here       
        handles.orbite = 'transport - tour fixe';
        setappdata(handles.figure1,'Orbite','transport - tour fixe'); %
        % charger la matrice efficacite type transport
        directory = getfamilydata('Directory','Steerette');
        Name = 'solamor2linb_new_13mai_Meff';
        filename = strcat(directory,Name);
        S = load('-mat',filename);
        Meff = S.Meff ; Meff_V = S.Meff_V;

        setappdata(handles.figure1,'Meff',Meff);
        setappdata(handles.figure1,'Meff_V',Meff_V);
        
        set(handles.Ntours_edit,'Enable','off');% rendre impossible le controle du nombre de tours moyenne OF
        set(handles.tour_fixe_OF_edit,'Enable','off');% rendre impossible le controle du 1er tour moyenne OF
        set(handles.tour_fixe_T_edit,'Enable','on');% rendre impossible le controle du 1er tour fixe transport
end

% Update handles structure
guidata(hObject, handles);
disp('eh ben !');

% % --- Executes on selection change in popupmenu1.
% function popupmenu1_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu1


% % --- Executes during object creation, after setting all properties.
% function popupmenu1_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenu1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc
%     set(hObject,'BackgroundColor','white');
% else
%     set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
% end
% 
% set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on selection change in CH_popupmenu2.
function CH_popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to CH_popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns CH_popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CH_popupmenu2


HCOR = getappdata(handles.figure1,'HCOR');
% attribution du numero du correcteur (on enl�ve le titre)
valCH = get(hObject,'Value')-1;
% attribution du nom du device selectionne dans "device"

switch valCH
    case 1
            %device = HCOR.DeviceName(1);
            % desactiver le pushbutton "correcteur precedent"
            set(handles.CH_precedent_pushbutton4,'Enable','off');
            % activer le pushbutton "correcteur suivant"
            set(handles.CH_suivant_pushbutton5,'Enable','on');
    case size(HCOR.DeviceName,1)
            %device = HCOR.DeviceName(size(HCOR.DeviceName,1));
            % activer le pushbutton "correcteur precedent"
            set(handles.CH_precedent_pushbutton4,'Enable','on');
            % desactiver le pushbutton "correcteur suivant"
            set(handles.CH_suivant_pushbutton5,'Enable','off');
end

for k = 2:size(HCOR.DeviceName,1)-1
    switch valCH
        case k
            %device = HCOR.DeviceName(k);
            % activer le pushbutton "correcteur precedent"
            set(handles.CH_precedent_pushbutton4,'Enable','on');
            % activer le pushbutton "correcteur suivant"
            set(handles.CH_suivant_pushbutton5,'Enable','on');
    end
end


%disp('coucou')

% afficher dans ICH_edit1 la valeur actuelle du courant du correcteur selectionne
liste = getam('HCOR',handles.mode);
valeur_corr = liste(valCH);
set(handles.ICH_edit1,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICH_slider1,'Value',valeur_corr);

% afficher dans le text l'autre nomenclature type [cell N� HCOR]
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
set(handles.HCOR_text18,'String',...
    strcat(num2str(valCH),'   [',num2str(HCOR_liste(valCH,:)),']'));

if valCH>0
    % enregistrer le numero du correcteur selectionne
    setappdata(handles.figure1,'n_selection_CH',valCH);
%     % enregistrer le nom du correcteur selectionne
%     setappdata(handles.figure1,'device_CH',device);
else
    % initialiser le nom du correcteur
    setappdata(handles.figure1,'device_CH','');
    % desactiver le pushbutton "correcteur precedent"
    set(handles.CH_precedent_pushbutton4,'Enable','off');
    % desactiver le pushbutton "correcteur suivant"
    set(handles.CH_suivant_pushbutton5,'Enable','off');
end


% rafraichir le BPM consecutif selectionn�
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
disp('hep !')


function HCOR_text18_CreateFcn(hObject, eventdata, handles)

function date_et_heure_text20_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CH_popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CH_popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%HCOR = getfamilydata('HCOR');
%HCOR = getappdata(handles.figure1,'HCOR');

% cellule = {};
% for j = 1:size(HCOR.DeviceName,1)
%     cellule = {cellule{:},strcat(num2str(HCOR.ElementList(j)),' : ',HCOR.DeviceName{j})};
% end
% set(hObject, 'String', {'liste correcteurs horizontaux', cellule{:}});        




    
% --- Executes on button press in CH_precedent_pushbutton4.
function CH_precedent_pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to CH_precedent_pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% nombre max de correcteurs H 
maxvalCH = getappdata(handles.figure1,'maxvalCH');

% numero du correcteur actuellement selectionne
valCH = getappdata(handles.figure1,'n_selection_CH');
%selectionner dans la liste le correcteur precedent
set(handles.CH_popupmenu2,'Value',valCH);
% enregistrer le nouveau numero de correcteur de la liste
valCH = valCH - 1;
setappdata(handles.figure1,'n_selection_CH',valCH);
% enregistrer le correcteur 
%setappdata(handles.figure1,'

if valCH>=maxvalCH
    % activer le pushbutton "correcteur precedent"
    set(handles.CH_precedent_pushbutton4,'Enable','on');
    % desactiver le pushbutton "correcteur suivant"
    set(handles.CH_suivant_pushbutton5,'Enable','off'); 
elseif 1>=valCH
    % desactiver le pushbutton "correcteur precedent"
    set(handles.CH_precedent_pushbutton4,'Enable','off');
    % activer le pushbutton "correcteur suivant"
    set(handles.CH_suivant_pushbutton5,'Enable','on');
else
    % activer le pushbutton "correcteur precedent"
    set(handles.CH_precedent_pushbutton4,'Enable','on');
    % activer le pushbutton "correcteur suivant"
    set(handles.CH_suivant_pushbutton5,'Enable','on');
end


% afficher dans ICH_edit1 la valeur actuelle du courant du correcteur selectionne
liste = getam('HCOR',handles.mode);
valeur_corr = liste(valCH);
set(handles.ICH_edit1,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICH_slider1,'Value',valeur_corr);

% afficher dans le text l'autre nomenclature type [cell N� HCOR]
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
set(handles.HCOR_text18,'String',...
    strcat(num2str(valCH),'   [',num2str(HCOR_liste(valCH,:)),']'));

% rafraichir le BPM consecutif selectionn�
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)



% --- Executes on button press in CH_suivant_pushbutton5.
function CH_suivant_pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to CH_suivant_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% nombre max de correcteurs H + en tete popupmenu
maxvalCH = getappdata(handles.figure1,'maxvalCH');

% numero du correcteur actuellement selectionne
valCH = getappdata(handles.figure1,'n_selection_CH');
%selectionner dans la liste le correcteur suivant
set(handles.CH_popupmenu2,'Value',valCH+2);
% enregistrer la nouvelle valeur de la liste
valCH = valCH + 1;
setappdata(handles.figure1,'n_selection_CH',valCH);
if valCH>=maxvalCH
    % activer le pushbutton "correcteur precedent"
    set(handles.CH_precedent_pushbutton4,'Enable','on');
    % desactiver le pushbutton "correcteur suivant"
    set(handles.CH_suivant_pushbutton5,'Enable','off'); 
elseif 1>=valCH
    % desactiver le pushbutton "correcteur precedent"
    set(handles.CH_precedent_pushbutton4,'Enable','off');
    % activer le pushbutton "correcteur suivant"
    set(handles.CH_suivant_pushbutton5,'Enable','on');
else
    % activer le pushbutton "correcteur precedent"
    set(handles.CH_precedent_pushbutton4,'Enable','on');
    % activer le pushbutton "correcteur suivant"
    set(handles.CH_suivant_pushbutton5,'Enable','on');
end


% afficher dans ICH_edit1 la valeur actuelle du courant du correcteur selectionne
liste = getam('HCOR',handles.mode);
valeur_corr = liste(valCH);
set(handles.ICH_edit1,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICH_slider1,'Value',valeur_corr);

% afficher dans le text l'autre nomenclature type [cell N� HCOR]
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
set(handles.HCOR_text18,'String',...
    strcat(num2str(valCH),'   [',num2str(HCOR_liste(valCH,:)),']'));

% rafraichir le BPM consecutif selectionn�
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)


function ICH_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to ICH_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ICH_edit1 as text
%        str2double(get(hObject,'String')) returns contents of ICH_edit1 as a double


% rechercher le numero du correcteur selectionne
valCH = getappdata(handles.figure1,'n_selection_CH');

% rechercher le nom du correcteur selectionne
%device = getappdata(handles.figure1,'device_CH');


% appliquer le courant entr� manuellement
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
ICH = get(handles.ICH_edit1,'String');
setsp('HCOR',str2num(ICH),HCOR_liste(valCH,:),handles.mode);

% re-initaliser le slider � cette valeur de courant
set(handles.ICH_slider1,'Value',str2num(ICH));

% replot des orbites et point et correcteur H

mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)

% % 
% % k = getappdata(handles.figure1,'n_selection_BPMx');
% % h3     = get(handles.axes3,'Children');
% % hline2 = findobj(h3,'-regexp','Tag','line[1,2,3]');
% % h9     = get(handles.axes9,'Children');
% % hbar9  = findobj(h9,'-regexp','Tag','bar[1]');
% % %h10     = get(handles.axes10,'Children');
% % %hbar10  = findobj(h10,'-regexp','Tag','bar[2]');
% % [orbite_x,orbite_z] = getbpm;
% % xdata = 1:length(orbite_x);
% % ydata = 1:length(orbite_z);
% % zdata = k;
% % 
% % liste_HCOR = getam('HCOR');
% % liste_VCOR = getam('VCOR'); 
% % 
% % % linegraphes
% % set(hline2(3),'XData',xdata,'YData',orbite_x,'Visible','On');
% % set(hline2(2),'XData',ydata,'YData',orbite_z,'Visible','On');
% % set(hline2(1),'XData',zdata,'YData',orbite_x(zdata),'Visible','On');
% % 
% % % bargraphes
% % set(hbar9(1),'YData',liste_HCOR,'Visible','On');
% % %set(hbar10(1),'YData',liste_VCOR,'Visible','On');

%disp('je craque');


% --- Executes during object creation, after setting all properties.
function ICH_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ICH_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ICH_slider1_Callback(hObject, eventdata, handles)
% hObject    handle to ICH_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% afficher dans l'editeur la valeur de courant
 set(handles.ICH_edit1,'String',...
             num2str(get(handles.ICH_slider1,'Value')));

% rechercher le numero du correcteur selectionne
valCH = getappdata(handles.figure1,'n_selection_CH');

% rechercher le nom du correcteur selectionne
%device = getappdata(handles.figure1,'device_CH');


% appliquer le courant entr� manuellement
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
ICH = get(handles.ICH_edit1,'String');
setsp('HCOR',str2num(ICH),HCOR_liste(valCH,:),handles.mode);


% replot des orbites et point et correcteur H
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)

% % % replot des orbites et point
% % k = getappdata(handles.figure1,'n_selection_BPMx');
% % h3     = get(handles.axes3,'Children');
% % hline2 = findobj(h3,'-regexp','Tag','line[1,2,3]');
% % h9     = get(handles.axes9,'Children');
% % hbar9  = findobj(h9,'-regexp','Tag','bar[1]');
% % 
% % % rafraichir les orbites
% % [orbite_x,orbite_z] = getbpm;
% % xdata = 1:length(orbite_x);
% % ydata = 1:length(orbite_z);
% % zdata = k;
% % liste_HCOR = getam('HCOR');
% % 
% % set(hline2(3),'XData',xdata,'YData',orbite_x,'Visible','On');
% % set(hline2(2),'XData',ydata,'YData',orbite_z,'Visible','On');
% % set(hline2(1),'XData',zdata,'YData',orbite_x(zdata),'Visible','On');
% % 
% % % bargraphes
% % set(hbar9(1),'YData',liste_HCOR,'Visible','On');
%disp('je craque')

% --- Executes during object creation, after setting all properties.
function ICH_slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ICH_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function fichier_sauvegarde_CH_edit13_Callback(hObject, eventdata, handles)
% hObject    handle to fichier_sauvegarde_CH_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fichier_sauvegarde_CH_edit13 as text
%        str2double(get(hObject,'String')) returns contents of fichier_sauvegarde_CH_edit13 as a double




% --- Executes during object creation, after setting all properties.
function fichier_sauvegarde_CH_edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fichier_sauvegarde_CH_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sauvegarder_CH_pushbutton20.
function sauvegarder_CH_pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to sauvegarder_CH_pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine file and directory name
FileName = 'H';
%DirectoryName = '/home/PM/nadolski/controlroom/measdata/Ringdata/';
DirectoryName = getfamilydata('Directory','Steerette');
%DirectoryName = '/home/PM/tordeux/matlab/applications/Ring/';
%% exemple pour le RCM : DirectoryName = getfamilydata('Directory','FAEData');

TimeStamp = clock;
% Append date_Time to FileName
FileName = sprintf('%s_%s', datestr(TimeStamp,31), FileName);
FileName(11) = '_';
FileName(14) = '-';
FileName(17) = '-';

[FileName, DirectoryName] = uiputfile('*','Save Lattice to ...', [DirectoryName FileName]);
if FileName == 0 
    fprintf('   File not saved (getmachineconfig)\n');
    return;
end

% afficher le nom du fichier
set(handles.fichier_sauvegarde_CH_edit13,'String',FileName);

% Save all data in structure to file

%DirStart = '/home/PM/nadolski/controlroom/measdata/Ringdata/'
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName); 
xdata = getam('HCOR',handles.mode);
% xdata = getappdata(handles.figure1,'xdata');
% ydata = getappdata(handles.figure1,'ydata');
try
   
    save(FileName, 'xdata');

catch
    cd(DirStart);
    return
end
cd(DirStart);


% --- Executes on button press in restaurer_CH_pushbutton21.
function restaurer_CH_pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to restaurer_CH_pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%DirectoryName = '/home/PM/nadolski/controlroom/measdata/Ringdata/';
DirectoryName = getfamilydata('Directory','Steerette');
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);  
[FileName, DirectoryName] = uigetfile('*','Select a file ...');
if FileName == 0 
    fprintf('  no File picked (getmachineconfig)\n');
    return;
else
    load(FileName)
end


% afficher
try
    setsp('HCOR',xdata,handles.mode);
    %setsp('VCOR',ydata);
    
    
catch
    cd(DirStart);
    return
end
cd(DirStart);


mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)



% --- Executes on button press in CH_SVD_pushbutton22.
function CH_SVD_pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to CH_SVD_pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% nbre de correcteurs utilis�s dans la correction SVD
nbcorrSVD = get(handles.nb_correcteurs_H_edit17,'String');
nbcorrSVD = str2num(nbcorrSVD);

% relire le pourcentage � appliquer sur les valeurs de correcteurs
pourcentage_H = str2num(get(handles.pourcentage_H_edit16,'String'));

% correcteur actuellement selectionn�
valCH = getappdata(handles.figure1,'n_selection_CH');
%if isequal(valCH,0)|isequal(valCH,1)
if valCH<nbcorrSVD
    errordlg('selectionnez un nombre adéquat de correcteurs !','Attention');
    % sortir de la fonction
    return
end

% chargement de la matrice efficacité. Son type est géré par le radiobutton
% "transport" "orbite fermée" :
% % if strcmp(handles.orbite,'transport - max Sum')
% %     Meff = getappdata(handles.figure1,'Meff'); % matrice d'efficacite type transport
% % else
% %     Meff = ones(120,56)*0;% introduire matrice type orbite fermée
% % end
Meff = getappdata(handles.figure1,'Meff');
handles.mode = getappdata(handles.figure1,'Mode');
handles.orbite = getappdata(handles.figure1,'Orbite');
BPMx = getappdata(handles.figure1,'BPMx'); % Orbit H
HCOR = getappdata(handles.figure1,'HCOR'); % Correcteurs H

% enregistrement des correcteurs avant correction
liste = getam('HCOR',handles.mode);
val_corr_CH = liste(valCH-nbcorrSVD+1:valCH); % Dangerux de pas travailler sur deviceliste
setappdata(handles.figure1,'val_corr_CH',val_corr_CH);

% correction SVD avec les N correcteurs et...
% tous les BPM compris entre depuis le valCH-N+1 correcteur et jusqu'au correcteur
% suivant  valCH + 1

% on tiend compte du status du BPM, eventuellement mis � 0 pour cause de
% lecture non fiable, ou bien ??
BPMxList = getappdata(handles.figure1, 'BPMxList');
if 1
    Family = 'BPMx';
    FullList = family2dev(Family);
    i = findrowindex(BPMxList, FullList);
    BPMx_status = family2status(Family)*0;
    BPMx_status(i) = 1;
else
    BPMx_status = family2status('BPMx');

end

% extraire la matrice
% l'efficacit� vis � vis d'un BPMx "inactif" est mise � 0
flag = 0;
liste_elem_BPM = [];
for j = 1 : length(BPMx.Position)
    if BPMx.Position(j)>HCOR.Position(valCH-nbcorrSVD+1)
        if valCH~=length(HCOR.Position)&BPMx.Position(j)>HCOR.Position(valCH+1)
            break
        end
        flag = flag + 1;
        liste_elem_BPM = [liste_elem_BPM j];
        Meffloc(flag,:) = Meff(j,valCH-nbcorrSVD+1:valCH) * BPMx_status(j);
    end
end
nbBPM  = flag;
% controle :
%Meffloc = Meffloc
%disp('coucou')    ; 

% correction SVD 
liste_dev_BPM = elem2dev('BPMx',liste_elem_BPM');
%% tests
%liste_dev_BPM = liste_dev_BPM(3:4,1:2)
%Meffloc = Meffloc(3:4,1:2)
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
liste_dev_HCOR = HCOR_liste(valCH-nbcorrSVD+1:valCH,:);

%%%%
BPMindex = family2atindex('BPMx',liste_dev_BPM);
spos = getspos('BPMx');

if strcmp(handles.mode,'Model')
    clear X01;
    %X0 = [0.5e-3 0.5e-3 1e-3 1e-3 0 0]';
    % g�n�ration d'une ellipse 1 sigma �ventuellement d�centr�e
    eps = 150e-9;betax = 3 ;betaz = 3 ;alphax = 0;alphaz = 0;
    deltax = 2e-3;deltaz = 2e-3;deltaxp = 1e-3;deltazp = 1e-3;
    X0 = [sqrt(eps * betax) + deltax 0 sqrt(eps * betaz) + deltaz 0 0 0 ;...
        0  sqrt(eps / betax) + deltaxp 0 sqrt(eps / betaz) + deltazp 0 0 ;...
        -sqrt(eps * betax)+ deltax 0 -sqrt(eps * betaz)+ deltaz 0 0 0 ;...
        0  -sqrt(eps / betax)+deltaxp 0 -sqrt(eps / betaz)+deltazp 0 0 ]';

    % nP = nbre de particules track�es
    nP = size(X0,2);
    setappdata(handles.figure1,'orbite_entry',X0);
    global THERING
    nbtour = 1;
    X01 = zeros(nbtour, 6, nP*length(BPMindex));

    for k=1:nbtour,
        X01(k,:,:) = linepass(THERING, X0, BPMindex);
        %X0 = X01(k,:,end)';
    end
    Xa = squeeze(X01(1,1,:));
    %Za = squeeze(X01(1,3,:));
    if nP>1
        X = [];
        %Z = [];
        for nBPM = 1:length(BPMindex)
            X = [X mean(Xa((nP*(nBPM-1)+1):nP*nBPM))];
            %Z = [Z mean(Za((nP*(nBPM-1)+1):nP*nBPM))];
        end
        X = X'; % X en m
        X = X * 1000; % X en mm
        %Z = Z';
    else
        X = Xa; % X en m
        X = X * 1000; % X en mm
        %Z = Za;
    end
else % online
    if strcmp(handles.orbite,'transport - max Sum') % orbite à corriger type transport
        %[X] = anabpmfirstturn( BPMx.DeviceList );
        %[X] = anabpmfirstturn( liste_dev_BPM,'NoDisplay' ); % X en mm premier tour ANCIENNE VERSION
        nbturns = 1;
        [X Z Sum idx] = anabpmnfirstturns( liste_dev_BPM,nbturns,'NoDisplay2'); % X en mm premier tour
        idx
        X = X';
    elseif strcmp(handles.orbite,'transport - tour fixe') % orbite à corriger type transport
        ifirstturn = str2num(get(handles.tour_fixe_T_edit,'String')); % numero du premier tour
        nbturns = 1;
        X = anabpmnfirstturns( liste_dev_BPM,nbturns,ifirstturn,'NoDisplay2','NoMaxSum'); % X en mm premier tour
        %X = anabpmnfirstturns( liste_dev_BPM,nbturns,ifirstturn,'NoDisplay2','MaxSum'); % X en mm premier tour
        X = X';
    else
        % moyenne de l'orbite à corriger sur n tours
        ifirstturn = str2num(get(handles.tour_fixe_OF_edit,'String')); % numero du premier tour
        nturns = str2num(get(handles.Ntours_edit,'String'));
        [X] = anabpmnfirstturns(liste_dev_BPM,nturns,ifirstturn,'NoDisplay2','NoMaxSum');
        X = mean(X) ;% moyenne par BPM
        X = X'; % ?? VERIFIER
    end
end
%%%

[U,S,V] = svd(Meffloc);
setappdata(handles.figure1,'S',S);
DiagS = diag(S);

% test si le nombre de valeurs propres a �t� modifi� dans l'interface 
% "valeurs singuli�res"
nbvp = getappdata(handles.figure1,'valvp');


% si le nbre n'a pas �t� modifi� et qu'il est incompatible :
% if nbvp ==0||nbvp>size(S,2)
%     nbvp = size(S,2);
if nbvp ==0||nbvp>length(DiagS)
    nbvp = length(DiagS);    
end
% affichage 
disp(strcat('nombre de valeurs propres sélectionnees :',num2str(nbvp)))

%Rmod = Meffloc * V;
Rmod1 = Meffloc * V(:,1:nbvp);
%B = Rmod\ (X );
B1 = Rmod1\ (X ); % X en mm
%DeltaCM = V * B;
DeltaCM1 = V(:,1:nbvp) * B1;
consigne = getsp('HCOR',liste_dev_HCOR,handles.mode);
% test 
val_max = getmaxsp('HCOR',liste_dev_HCOR);
val_min = getminsp('HCOR',liste_dev_HCOR);
if all((consigne-DeltaCM1* pourcentage_H*0.01)<val_max)*all((consigne-DeltaCM1* pourcentage_H*0.01)>val_min);
    stepsp('HCOR',-DeltaCM1* pourcentage_H*0.01 ,liste_dev_HCOR,handles.mode);

    mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
    mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
    mycallback_steerette_corr(1,1,hObject, eventdata, handles)
    

    % �crire la nouvelle valeur correcteur n�valCH dans l'edit
    liste = getam('HCOR',handles.mode);
    valeur_corr = liste(valCH);
    set(handles.ICH_edit1,'String',sprintf('%3.2f',valeur_corr));

    % re-initaliser le slider � cette valeur de courant
    set(handles.ICH_slider1,'Value',valeur_corr);

    disp('eh oui')
else
    consigne-DeltaCM1
    liste_dev_HCOR
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    return
end
disp('hep !')

% --- Executes on selection change in CV_popupmenu3.
function CV_popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to CV_popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns CV_popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CV_popupmenu3


VCOR = getappdata(handles.figure1,'VCOR');
% attribution du numero du correcteur (on enl�ve le titre)
valCV = get(hObject,'Value')-1;
% attribution du nom du device selectionne dans "device"

switch valCV
    case 1
            %device = HCOR.DeviceName(1);
            % desactiver le pushbutton "correcteur precedent"
            set(handles.CV_precedent_pushbutton23,'Enable','off');
            % activer le pushbutton "correcteur suivant"
            set(handles.CV_suivant_pushbutton24,'Enable','on');
    case size(VCOR.DeviceName,1)
            %device = HCOR.DeviceName(size(HCOR.DeviceName,1));
            % activer le pushbutton "correcteur precedent"
            set(handles.CV_precedent_pushbutton23,'Enable','on');
            % desactiver le pushbutton "correcteur suivant"
            set(handles.CV_suivant_pushbutton24,'Enable','off');
end

for k = 2:size(VCOR.DeviceName,1)-1
    switch valCV
        case k
            %device = HCOR.DeviceName(k);
            % activer le pushbutton "correcteur precedent"
            set(handles.CV_precedent_pushbutton23,'Enable','on');
            % activer le pushbutton "correcteur suivant"
            set(handles.CV_suivant_pushbutton24,'Enable','on');
    end
end


%disp('coucou')

% afficher dans ICH_edit1 la valeur actuelle du courant du correcteur selectionne
liste = getam('VCOR',handles.mode);
valeur_corr = liste(valCV);
set(handles.ICV_edit14,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICV_slider2,'Value',valeur_corr);

% afficher dans le text l'autre nomenclature type [cell N� VCOR]
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
set(handles.VCOR_text23,'String',...
    strcat(num2str(valCV),'   [',num2str(VCOR_liste(valCV,:)),']'));

if valCV>0
    % enregistrer le numero du correcteur selectionne
    setappdata(handles.figure1,'n_selection_CV',valCV);
%     % enregistrer le nom du correcteur selectionne
%     setappdata(handles.figure1,'device_CH',device);
else
    % initialiser le nom du correcteur
    setappdata(handles.figure1,'device_CV','');
    % desactiver le pushbutton "correcteur precedent"
    set(handles.CV_precedent_pushbutton23,'Enable','off');
    % desactiver le pushbutton "correcteur suivant"
    set(handles.CV_suivant_pushbutton24,'Enable','off');
end

% rafraichir le BPM consecutif selectionn�
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)

% % rafraichir le BPM consecutif selectionn�
% h3     = get(handles.axes3,'Children');
% hline3 = findobj(h3,'-regexp','Tag','line[4]');
% BPMz = getappdata(handles.figure1,'BPMz');
% VCOR = getappdata(handles.figure1,'VCOR');
% valCV = getappdata(handles.figure1,'n_selection_CV');
% [orbite_x,orbite_z] = getbpm;
% if valCV>0
%     for k = valCV:length(BPMz.Position)
%         if BPMz.Position(k) > VCOR.Position(valCV)
%             setappdata(handles.figure1,'n_selection_BPMz',k)
%             set(hline3(1),'XData', k, 'YData', orbite_z(k),'Visible','On');
%             break
%         end
%     end
% end


function VCOR_text23_CreateFcn(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function CV_popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CV_popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CV_precedent_pushbutton23.
function CV_precedent_pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to CV_precedent_pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% nombre max de correcteurs V 
maxvalCV = getappdata(handles.figure1,'maxvalCV');

% numero du correcteur actuellement selectionne
valCV = getappdata(handles.figure1,'n_selection_CV');
%selectionner dans la liste le correcteur precedent
set(handles.CV_popupmenu3,'Value',valCV);
% enregistrer le nouveau numero de correcteur de la liste
valCV = valCV - 1;
setappdata(handles.figure1,'n_selection_CV',valCV);
% enregistrer le correcteur 
%setappdata(handles.figure1,'

if valCV>=maxvalCV
    % activer le pushbutton "correcteur precedent"
    set(handles.CV_precedent_pushbutton23,'Enable','on');
    % desactiver le pushbutton "correcteur suivant"
    set(handles.CV_suivant_pushbutton24,'Enable','off'); 
elseif 1>=valCV
    % desactiver le pushbutton "correcteur precedent"
    set(handles.CV_precedent_pushbutton23,'Enable','off');
    % activer le pushbutton "correcteur suivant"
    set(handles.CV_suivant_pushbutton24,'Enable','on');
else
    % activer le pushbutton "correcteur precedent"
    set(handles.CV_precedent_pushbutton23,'Enable','on');
    % activer le pushbutton "correcteur suivant"
    set(handles.CV_suivant_pushbutton24,'Enable','on');
end


% afficher dans ICV_edit14 la valeur actuelle du courant du correcteur selectionne
liste = getam('VCOR',handles.mode);
valeur_corr = liste(valCV);
set(handles.ICV_edit14,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICV_slider2,'Value',valeur_corr);

% afficher dans le text l'autre nomenclature type [cell N� VCOR]
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
set(handles.VCOR_text23,'String',...
    strcat(num2str(valCV),'   [',num2str(VCOR_liste(valCV,:)),']'));

% rafraichir le BPM consecutif selectionn�
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)

% % % rafraichir le BPM consecutif selectionn�
% % h3     = get(handles.axes3,'Children');
% % hline3 = findobj(h3,'-regexp','Tag','line[4]');
% % BPMz = getappdata(handles.figure1,'BPMz');
% % VCOR = getappdata(handles.figure1,'VCOR');
% % valCV = getappdata(handles.figure1,'n_selection_CV');
% % [orbite_x,orbite_z] = getbpm;
% % if valCV>0
% %     for k = valCV:length(BPMz.Position)
% %         if BPMz.Position(k) > VCOR.Position(valCV)
% %             setappdata(handles.figure1,'n_selection_BPMz',k)
% %             set(hline3(1),'XData', k, 'YData', orbite_z(k),'Visible','On');
% %             break
% %         end
% %     end
% % end


% --- Executes on button press in CV_suivant_pushbutton24.
function CV_suivant_pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to CV_suivant_pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% nombre max de correcteurs V + en tete popupmenu
maxvalCV = getappdata(handles.figure1,'maxvalCV');

% numero du correcteur actuellement selectionne
valCV = getappdata(handles.figure1,'n_selection_CV');
%selectionner dans la liste le correcteur suivant
set(handles.CV_popupmenu3,'Value',valCV+2);
% enregistrer la nouvelle valeur de la liste
valCV = valCV + 1;
setappdata(handles.figure1,'n_selection_CV',valCV);
if valCV>=maxvalCV
    % activer le pushbutton "correcteur precedent"
    set(handles.CV_precedent_pushbutton23,'Enable','on');
    % desactiver le pushbutton "correcteur suivant"
    set(handles.CV_suivant_pushbutton24,'Enable','off'); 
elseif 1>=valCV
    % desactiver le pushbutton "correcteur precedent"
    set(handles.CV_precedent_pushbutton23,'Enable','off');
    % activer le pushbutton "correcteur suivant"
    set(handles.CV_suivant_pushbutton24,'Enable','on');
else
    % activer le pushbutton "correcteur precedent"
    set(handles.CV_precedent_pushbutton23,'Enable','on');
    % activer le pushbutton "correcteur suivant"
    set(handles.CV_suivant_pushbutton24,'Enable','on');
end


% afficher dans ICV_edit14 la valeur actuelle du courant du correcteur selectionne
liste = getam('VCOR',handles.mode);
valeur_corr = liste(valCV);
set(handles.ICV_edit14,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICV_slider2,'Value',valeur_corr);

% afficher dans le text l'autre nomenclature type [cell N� VCOR]
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
set(handles.VCOR_text23,'String',...
    strcat(num2str(valCV),'   [',num2str(VCOR_liste(valCV,:)),']'));

% rafraichir le BPM consecutif selectionn�
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)

% % rafraichir le BPM consecutif selectionn�
% h3     = get(handles.axes3,'Children');
% hline3 = findobj(h3,'-regexp','Tag','line[4]');
% BPMz = getappdata(handles.figure1,'BPMz');
% VCOR = getappdata(handles.figure1,'VCOR');
% valCV = getappdata(handles.figure1,'n_selection_CV');
% [orbite_x,orbite_z] = getbpm;
% if valCV>0
%     for k = valCV:length(BPMz.Position)
%         if BPMz.Position(k) > VCOR.Position(valCV)
%             setappdata(handles.figure1,'n_selection_BPMz',k)
%             set(hline3(1),'XData', k, 'YData', orbite_z(k),'Visible','On');
%             break
%         end
%     end
% end


function ICV_edit14_Callback(hObject, eventdata, handles)
% hObject    handle to ICV_edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ICV_edit14 as text
%        str2double(get(hObject,'String')) returns contents of ICV_edit14 as a double


% rechercher le numero du correcteur selectionne
valCV = getappdata(handles.figure1,'n_selection_CV');

% rechercher le nom du correcteur selectionne
%device = getappdata(handles.figure1,'device_CV');


% appliquer le courant entr� manuellement
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
ICV = get(handles.ICV_edit14,'String');
setsp('VCOR',str2num(ICV),VCOR_liste(valCV,:),handles.mode)

% re-initaliser le slider � cette valeur de courant
set(handles.ICV_slider2,'Value',str2num(ICV));

% replot des orbites et point et correcteur V

mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)
% k = getappdata(handles.figure1,'n_selection_BPMz');
% h3     = get(handles.axes3,'Children');
% hline2 = findobj(h3,'-regexp','Tag','line[1,2,4]');
% % h9     = get(handles.axes9,'Children');
% % hbar9  = findobj(h9,'-regexp','Tag','bar[1]');
% h10     = get(handles.axes10,'Children');
% hbar10  = findobj(h10,'-regexp','Tag','bar[2]');
% [orbite_x,orbite_z] = getbpm;
% xdata = 1:length(orbite_x);
% ydata = 1:length(orbite_z);
% zdata = k;
% 
% liste_HCOR = getam('HCOR');
% liste_VCOR = getam('VCOR'); 
% 
% % linegraphes
% set(hline2(3),'XData',xdata,'YData',orbite_x,'Visible','On');
% set(hline2(2),'XData',ydata,'YData',orbite_z,'Visible','On');
% set(hline2(1),'XData',zdata,'YData',orbite_z(zdata),'Visible','On');
% 
% 
% % bargraphes
% %set(hbar9(1),'YData',liste_HCOR,'Visible','On');
% set(hbar10(1),'YData',liste_VCOR,'Visible','On');

%disp('je craque');

% --- Executes during object creation, after setting all properties.
function ICV_edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ICV_edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ICV_slider2_Callback(hObject, eventdata, handles)
% hObject    handle to ICV_slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% afficher dans l'editeur la valeur de courant
 set(handles.ICV_edit14,'String',...
             num2str(get(handles.ICV_slider2,'Value')));

% rechercher le numero du correcteur selectionne
valCV = getappdata(handles.figure1,'n_selection_CV');

% rechercher le nom du correcteur selectionne
%device = getappdata(handles.figure1,'device_CV');


% appliquer le courant entr� manuellement
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
ICV = get(handles.ICV_edit14,'String');
setsp('VCOR',str2num(ICV),VCOR_liste(valCV,:),handles.mode);

% replot des orbites et point et correcteur V

mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)

% % replot des orbites et point
% k = getappdata(handles.figure1,'n_selection_BPMz');
% h3     = get(handles.axes3,'Children');
% hline2 = findobj(h3,'-regexp','Tag','line[1,2,4]');
% h10     = get(handles.axes10,'Children');
% hbar10  = findobj(h10,'-regexp','Tag','bar[2]');
% 
% % rafraichir les orbites
% [orbite_x,orbite_z] = getbpm;
% xdata = 1:length(orbite_x);
% ydata = 1:length(orbite_z);
% zdata = k;
% liste_VCOR = getam('VCOR');
% 
% set(hline2(3),'XData',xdata,'YData',orbite_x,'Visible','On');
% set(hline2(2),'XData',ydata,'YData',orbite_z,'Visible','On');
% set(hline2(1),'XData',zdata,'YData',orbite_z(zdata),'Visible','On');
% 
% % bargraphes
% set(hbar10(1),'YData',liste_VCOR,'Visible','On');
% %disp('je craque')



% --- Executes during object creation, after setting all properties.
function ICV_slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ICV_slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function fichier_sauvegarde_CV_edit15_Callback(hObject, eventdata, handles)
% hObject    handle to fichier_sauvegarde_CV_edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fichier_sauvegarde_CV_edit15 as text
%        str2double(get(hObject,'String')) returns contents of fichier_sauvegarde_CV_edit15 as a double


% --- Executes during object creation, after setting all properties.
function fichier_sauvegarde_CV_edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fichier_sauvegarde_CV_edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sauvegarder_CV_pushbutton25.
function sauvegarder_CV_pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to sauvegarder_CV_pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Determine file and directory name

FileName = 'V';
DirectoryName = getfamilydata('Directory','Steerette');
TimeStamp = clock;
% Append date_Time to FileName
FileName = sprintf('%s_%s', datestr(TimeStamp,31), FileName);
FileName(11) = '_';
FileName(14) = '-';
FileName(17) = '-';

[FileName, DirectoryName] = uiputfile('*','Save Lattice to ...', [DirectoryName FileName]);
if FileName == 0 
    fprintf('   File not saved (getmachineconfig)\n');
    return;
end

% afficher le nom du fichier
set(handles.fichier_sauvegarde_CV_edit15,'String',FileName);

% Save all data in structure to file

%DirStart = '/home/PM/nadolski/controlroom/measdata/Ringdata/'
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName); 
ydata = getam('VCOR',handles.mode);
% xdata = getappdata(handles.figure1,'xdata');
% ydata = getappdata(handles.figure1,'ydata');
try
   
    save(FileName, 'ydata');

catch
    cd(DirStart);
    return
end
cd(DirStart);


% --- Executes on button press in restaurer_CV_pushbutton26.
function restaurer_CV_pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to restaurer_CV_pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


DirectoryName = getfamilydata('Directory','Steerette');
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);  
[FileName, DirectoryName] = uigetfile('*','Select a file ...');
if FileName == 0 
    fprintf('  no File picked (getmachineconfig)\n');
    return;
else
    load(FileName)
end



% afficher
try
    %setsp('HCOR',xdata);
    setsp('VCOR',ydata,handles.mode);
    
    
catch
    cd(DirStart);
    return
end
cd(DirStart);


% --- Executes on button press in CV_SVD_pushbutton.
function CV_SVD_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to CV_SVD_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% nbre de correcteurs utilis�s dans la correction SVD
nbcorrSVD_V = get(handles.nb_correcteurs_V_edit,'String');
nbcorrSVD_V = str2num(nbcorrSVD_V);

% relire le pourcentage � appliquer sur les valeurs de correcteurs
pourcentage_V = str2num(get(handles.pourcentage_V_edit,'String'));

% correcteur actuellement selectionn�
valCV = getappdata(handles.figure1,'n_selection_CV');
%if isequal(valCV,0)|isequal(valCV,1)
if valCV<nbcorrSVD_V
    errordlg('selectionnez un nombre ad�quat de correcteurs !','Attention');
    % sortir de la fonction
    return
end

Meff_V = getappdata(handles.figure1,'Meff_V');
BPMz = getappdata(handles.figure1,'BPMz');
VCOR = getappdata(handles.figure1,'VCOR');

% enregistrement des correcteurs avant correction
liste = getam('VCOR',handles.mode);
val_corr_CV = liste(valCV-nbcorrSVD_V+1:valCV);
setappdata(handles.figure1,'val_corr_CV',val_corr_CV);

% correction SVD avec les N correcteurs et...
% tous les BPM compris entre depuis le valCV-N+1 correcteur et jusqu'au correcteur
% suivant  valCV + 1

% on tiend compte du status du BPM, eventuellement mis � 0 pour cause de
% lecture non fiable, ou bien ??
BPMz_status = family2status('BPMz');

% extraire la matrice
% l'efficacit� vis � vis d'un BPMz "inactif" est mise � 0
flag = 0;
liste_elem_BPM = [];
for j = 1 : length(BPMz.Position)
    if BPMz.Position(j)>VCOR.Position(valCV-nbcorrSVD_V+1)
        if valCV < length(VCOR.Position)
            if valCV~=length(VCOR.Position)&BPMz.Position(j)>VCOR.Position(valCV+1)
                break
            end
        end
        
        flag = flag + 1;
        liste_elem_BPM = [liste_elem_BPM j]; 
        Meffloc_V(flag,:) = Meff_V(j,valCV-nbcorrSVD_V+1:valCV) * BPMz_status(j);
    end
end
nbBPM  = flag;

% correction SVD 
liste_dev_BPM = elem2dev('BPMz',liste_elem_BPM');
%% tests
%liste_dev_BPM = liste_dev_BPM(3:4,1:2)
%Meffloc = Meffloc(3:4,1:2)
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
liste_dev_VCOR = VCOR_liste(valCV-nbcorrSVD_V+1:valCV,:);

%%%%
BPMindex = family2atindex('BPMz',liste_dev_BPM);
spos = getspos('BPMz');

if strcmp(handles.mode,'Model')
    clear X01;
    %X0 = [0.5e-3 0.5e-3 1e-3 1e-3 0 0]';
    % g�n�ration d'une ellipse 1 sigma �ventuellement d�centr�e
    eps = 150e-9;betax = 3 ;betaz = 3 ;alphax = 0;alphaz = 0;
    deltax = 2e-3;deltaz = 2e-3;deltaxp = 1e-3;deltazp = 1e-3;
    X0 = [sqrt(eps * betax) + deltax 0 sqrt(eps * betaz) + deltaz 0 0 0 ;...
        0  sqrt(eps / betax) + deltaxp 0 sqrt(eps / betaz) + deltazp 0 0 ;...
        -sqrt(eps * betax)+ deltax 0 -sqrt(eps * betaz)+ deltaz 0 0 0 ;...
        0  -sqrt(eps / betax)+deltaxp 0 -sqrt(eps / betaz)+deltazp 0 0 ]';

    % nP = nbre de particules track�es
    nP = size(X0,2);
    setappdata(handles.figure1,'orbite_entry',X0);
    global THERING
    nbtour = 1;
    X01 = zeros(nbtour, 6, nP*length(BPMindex));

    for k=1:nbtour,
        X01(k,:,:) = linepass(THERING, X0, BPMindex);
        %X0 = X01(k,:,end)';
    end
    %Xa = squeeze(X01(1,1,:));
    Za = squeeze(X01(1,3,:));
    if nP>1
        %X = [];
        Z = [];
        for nBPM = 1:length(BPMindex)
            %X = [X mean(Xa((nP*(nBPM-1)+1):nP*nBPM))];
            Z = [Z mean(Za((nP*(nBPM-1)+1):nP*nBPM))];
        end
        %X = X';
        Z = Z';
        Z = Z * 1000; % z en mm
    else
        %X = Xa;
        Z = Za;
        Z = Z * 1000; % z en mm
    end
else % online

    %[X Z] = anabpmfirstturn( liste_dev_BPM,'NoDisplay' ); % ancienne version
    %Z = Z';
    if strcmp(handles.orbite,'transport - max Sum') % orbite à corriger type transport
        %[X] = anabpmfirstturn( BPMx.DeviceList );
        %[X] = anabpmfirstturn( liste_dev_BPM,'NoDisplay' ); % X en mm premier tour ANCIENNE VERSION
        nbturns = 1;
        [X Z Sum idx] = anabpmnfirstturns( liste_dev_BPM,nbturns,'NoDisplay2'); % X en mm premier tour
        idx
        Z = Z';
    elseif strcmp(handles.orbite,'transport - tour fixe') % orbite à corriger type transport
        ifirstturn = str2num(get(handles.tour_fixe_T_edit,'String')); % numero du premier tour
        nbturns = 1;
        [X Z] = anabpmnfirstturns( liste_dev_BPM,nbturns,ifirstturn,'NoDisplay2','NoMaxSum'); % X en mm premier tour
        Z = Z';
    else
        % moyenne de l'orbite à corriger sur n tours
        ifirstturn = str2num(get(handles.tour_fixe_OF_edit,'String')); % numero du premier tour
        nturns = str2num(get(handles.Ntours_edit,'String'));
        [X Z] = anabpmnfirstturns(liste_dev_BPM,nturns,ifirstturn,'NoDisplay2','NoMaxSum');
        Z = mean(Z) ;% moyenne par BPM
        Z = Z'; % ?? VERIFIER
    end
end
%%%

% hcm = getsp('VCOR',liste_dev_VCOR,'struct');
[U,S_V,V] = svd(Meffloc_V);
setappdata(handles.figure1,'S_V',S_V);
DiagS_V = diag(S_V);

% test si le nombre de valeurs propres a �t� modifi� dans l'interface 
% "valeurs singuli�res"
nbvp_V = getappdata(handles.figure1,'valvp_V');


% si le nbre n'a pas �t� modifi� et qu'il est incompatible :
if nbvp_V ==0||nbvp_V>length(DiagS_V)
    nbvp_V = length(DiagS_V);
end
% affichage 
disp(strcat('nombre de valeurs propres sélectionnées :',num2str(nbvp_V)))


Rmod1 = Meffloc_V * V(:,1:nbvp_V);
B1 = Rmod1\ (Z ); % Z en mm
DeltaCM1_V = V(:,1:nbvp_V) * B1;
consigne = getsp('VCOR',liste_dev_VCOR,handles.mode);
% test 
val_max = getmaxsp('VCOR',liste_dev_VCOR);
val_min = getminsp('VCOR',liste_dev_VCOR);
if all((consigne-DeltaCM1_V* pourcentage_V*0.01)<val_max)*all((consigne-DeltaCM1_V* pourcentage_V*0.01)>val_min);
    stepsp('VCOR',-DeltaCM1_V* pourcentage_V*0.01 ,liste_dev_VCOR,handles.mode);


    mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
    mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
    mycallback_steerette_corr(1,1,hObject, eventdata, handles)
    

    % �crire la nouvelle valeur correcteur n�valCV dans l'edit
    liste = getam('VCOR',handles.mode);
    valeur_corr = liste(valCV);
    set(handles.ICV_edit14,'String',sprintf('%3.2f',valeur_corr));

    % re-initaliser le slider � cette valeur de courant
    set(handles.ICV_slider2,'Value',valeur_corr);

    disp('eh oui')
else
    consigne-DeltaCM1_V
    liste_dev_VCOR
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    return
end


% --- Executes on button press in Undo_H_pushbutton28.
function Undo_H_pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to Undo_H_pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% rechercher le numero du correcteur selectionne
valCH = getappdata(handles.figure1,'n_selection_CH');
val_corr_CH = getappdata(handles.figure1,'val_corr_CH');

% appliquer les courants precedant la correction SVD
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
setsp('HCOR',val_corr_CH,HCOR_liste(valCH-size(val_corr_CH,1)+1:valCH,:),handles.mode)

% �crire l'ancienne valeur correcteur n�valCH dans l'edit
liste = getam('HCOR',handles.mode);
valeur_corr = liste(valCH);
set(handles.ICH_edit1,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICH_slider1,'Value',valeur_corr);

disp('nous y re-voil�')

% replot des orbites et point et correcteur H

mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)



function pourcentage_H_edit16_Callback(hObject, eventdata, handles)
% hObject    handle to pourcentage_H_edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pourcentage_H_edit16 as text
%        str2double(get(hObject,'String')) returns contents of pourcentage_H_edit16 as a double


% --- Executes during object creation, after setting all properties.
function pourcentage_H_edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pourcentage_H_edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nb_correcteurs_H_edit17_Callback(hObject, eventdata, handles)
% hObject    handle to nb_correcteurs_H_edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb_correcteurs_H_edit17 as text
%        str2double(get(hObject,'String')) returns contents of nb_correcteurs_H_edit17 as a double


% --- Executes during object creation, after setting all properties.
function nb_correcteurs_H_edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb_correcteurs_H_edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in valeurs_singulieres_H_pushbutton29.
function valeurs_singulieres_H_pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to valeurs_singulieres_H_pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

correction_tour1_singval(handles);


% --- Executes on button press in Undo_V_pushbutton.
function Undo_V_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Undo_V_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% rechercher le numero du correcteur selectionne
valCV = getappdata(handles.figure1,'n_selection_CV');
val_corr_CV = getappdata(handles.figure1,'val_corr_CV');

% appliquer les courants precedant la correction SVD
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
setsp('VCOR',val_corr_CV,VCOR_liste(valCV-size(val_corr_CV,1)+1:valCV,:),handles.mode)

% �crire l'ancienne valeur correcteur n�valCH dans l'edit
liste = getam('VCOR',handles.mode);
valeur_corr = liste(valCV);
set(handles.ICV_edit14,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICV_slider2,'Value',valeur_corr);

disp('nous y re-voil�')

% replot des orbites et point et correcteur H

mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)


function pourcentage_V_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pourcentage_V_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pourcentage_V_edit as text
%        str2double(get(hObject,'String')) returns contents of pourcentage_V_edit as a double


% --- Executes during object creation, after setting all properties.
function pourcentage_V_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pourcentage_V_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nb_correcteurs_V_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nb_correcteurs_V_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb_correcteurs_V_edit as text
%        str2double(get(hObject,'String')) returns contents of nb_correcteurs_V_edit as a double


% --- Executes during object creation, after setting all properties.
function nb_correcteurs_V_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb_correcteurs_V_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in valeurs_singulieres_V_pushbutton.
function valeurs_singulieres_V_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to valeurs_singulieres_V_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%correction_tour1_singval_V(handles);
essai_V(handles);


%% What to do before closing the application
function Closinggui(obj, event, handles, figure1)

%device_name = getappdata(handles.figure1,'device_name');

% Get default command line output from handles structure
answer = questdlg('Fermer Steerette ?',...
    'Exit Programme Steerette',...
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


% --------------------------------------------------------------------
function menu_BPMx_Callback(hObject, eventdata, handles)
% hObject    handle to menu_BPMx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Build List display
Family = 'BPMx';
List = getappdata(handles.figure1, 'BPMxList');
FullList = family2dev(Family,0);    % Include bad status
CheckList = zeros(size(FullList,1),1);
i = findrowindex(List, FullList); % Find all selected Devices
CheckList(i) = 1;
List = editlist(FullList, Family, CheckList);
List = intersect(List,family2dev(Family,1)); % Exclude bad status
setappdata(handles.figure1, 'BPMxList', List);


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_BPMz_Callback(hObject, eventdata, handles)
% hObject    handle to menu_BPMz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Build List display
Family = 'BPMz';
List = getappdata(handles.figure1, 'BPMzList');
FullList = family2dev(Family,0);    % Include bad status
CheckList = zeros(size(FullList,1),1);
i = findrowindex(List, FullList); % Find all selected Devices
CheckList(i) = 1;
List = editlist(FullList, Family, CheckList);
List = intersect(List,family2dev(Family,1)); % Exclude bad status
setappdata(handles.figure1, 'BPMzList', List);


% --- Executes on button press in SVD_H_PR_pushbutton.
function SVD_H_PR_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SVD_H_PR_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% relire le pourcentage � appliquer sur les valeurs de correcteurs
pourcentage_H_PR = str2num(get(handles.pourcentage_H_PR_edit,'String'));
% BPMx = getappdata(handles.figure1,'BPMx'); % Orbit H
HCOR = getappdata(handles.figure1,'HCOR'); % Correcteurs H

%nbpm = 4;
nbpm = str2num(get(handles.nbBPM_PR_edit,'String'));

% liste des 2 BPM concernés (les 2 premiers valides)
BPMxDeviceListPR = getappdata(handles.figure1,'BPMxDeviceListPR');
BPMxliste = BPMxDeviceListPR(1:nbpm,:);

ncor = 6;
ncor = str2num(get(handles.nbcorr_PR_edit,'String'));

% liste des 2 correcteurs concernés (les 2 derniers valides)
HCORliste = HCOR.DeviceList(end-ncor+1:end,:);
setappdata(handles.figure1,'HCORliste_PR',HCORliste);
% enregistrement des correcteurs avant correction

%%%attention !
%%handles.mode = 'Model';
%%%attention !

liste = getam('HCOR',handles.mode);
liste = liste(end-ncor+1:end,:);% courant dans les derniers valides
% val_corr_CH = liste(valCH-nbcorrSVD+1:valCH); % Dangerux de pas travailler sur deviceliste
setappdata(handles.figure1,'val_corr_CH_PR',liste);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plan H
[bxHCOR,bzHCOR] = modelbeta('HCOR',HCORliste);
[bxBPM,bzBPM] = modelbeta('BPMx',BPMxliste);
[phixHCOR,phizHCOR] = modelphase('HCOR',HCORliste);
[phixBPM,phizBPM] = modelphase('BPMx',BPMxliste);
COEFF = hw2physics('HCOR','Setpoint',1) * 1e3 ;  % mrad/A
nu = modeltune;
deltaphi = 2*pi*nu(1) ; % 2 pi nux

for k = 1:ncor
    for j = 1:nbpm
        % calcul de l'efficacité
        Meff(j,k) = sqrt(bxHCOR(k)*bxBPM(j)) * sin(deltaphi + phixBPM(j) - phixHCOR(k))*COEFF(k); % mm/A
    end
end

%[X ] = anabpmnfirstturns(BPMxliste,2,'NoDisplay2');   % 2 tours sur les 2 premiers BPM valides

if strcmp(handles.orbite,'transport - max Sum') % orbite à corriger type transport
    %[X] = anabpmfirstturn( BPMx.DeviceList );
    %[X] = anabpmfirstturn( liste_dev_BPM,'NoDisplay' ); % X en mm premier tour ANCIENNE VERSION
    nbturns = 2;
    [X Z Sum idx] = anabpmnfirstturns( BPMxliste,nbturns,'NoDisplay2'); % X en mm premier tour
    idx

elseif strcmp(handles.orbite,'transport - tour fixe') % orbite à corriger type transport
    ifirstturn = str2num(get(handles.tour_fixe_T_edit,'String')); % numero du premier tour
    nbturns = 2;
    [X ] = anabpmnfirstturns( BPMxliste,nbturns,ifirstturn,'NoDisplay2','NoMaxSum'); % X en mm premier tour

else
    errordlg('selectionnez une option transport ! ', 'attention');
end
%
orbite_x_1 = X(1,:)';
%orbite_z_1 = Y(1,:)';
%orbite_sum_1 = Sum(1,:)';

orbite_x_2 = X(2,:)';
%orbite_z_2 = Y(2,:)';
%orbite_sum_2 = Sum(2,:)';

% delta d'orbite à corriger :
X = orbite_x_2 - orbite_x_1  ;% mm
difference_orbite_x = X

% end

%%%

[U,S,V] = svd(Meff);
%setappdata(handles.figure1,'S',S);
DiagS = diag(S);

% % test si le nombre de valeurs propres a �t� modifi� dans l'interface 
% % "valeurs singuli�res"
% nbvp = getappdata(handles.figure1,'valvp');
% 
% 
% % si le nbre n'a pas �t� modifi� et qu'il est incompatible :
% % if nbvp ==0||nbvp>size(S,2)
% %     nbvp = size(S,2);
% if nbvp ==0||nbvp>length(DiagS)
%     nbvp = length(DiagS);    
% end
% % affichage 
% disp(strcat('nombre de valeurs propres sélectionnees :',num2str(nbvp)))
nbvp = 2
%Rmod = Meff * V;
Rmod1 = Meff * V(:,1:nbvp);
%B = Rmod\ (X );
B1 = Rmod1\ (X );
%DeltaCM = V * B;
DeltaCM1 = V(:,1:nbvp) * B1
%DeltaCM1 = V(:,1:nbvp) * B1;
consigne = getsp('HCOR',HCORliste,handles.mode);
% test 
val_max = getmaxsp('HCOR',HCORliste);
val_min = getminsp('HCOR',HCORliste);
if all((consigne-DeltaCM1* pourcentage_H_PR*0.01)<val_max)*all((consigne-DeltaCM1* pourcentage_H_PR*0.01)>val_min);
    %%%% attention  !
    stepsp('HCOR',-DeltaCM1* pourcentage_H_PR*0.01 ,HCORliste,handles.mode);
    mycallback_steerette_orbites_PR(1,1,hObject, eventdata, handles)
    mycallback_steerette_corr(1,1,hObject, eventdata, handles)
    disp('eh oui')
else
    consigne-DeltaCM1
    HCORliste
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    return
end


% --- Executes on button press in SVD_V_PR_pushbutton.
function SVD_V_PR_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SVD_V_PR_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% relire le pourcentage � appliquer sur les valeurs de correcteurs
pourcentage_V_PR = str2num(get(handles.pourcentage_V_PR_edit,'String'));
% BPMx = getappdata(handles.figure1,'BPMx'); % Orbit H
VCOR = getappdata(handles.figure1,'VCOR'); % Correcteurs V

%nbpm = 4;
nbpm = str2num(get(handles.nbBPM_PR_edit,'String'));

% liste des 2 BPM concernés (les 2 premiers valides)
BPMxDeviceListPR = getappdata(handles.figure1,'BPMxDeviceListPR');
BPMxliste = BPMxDeviceListPR(1:nbpm,:);

ncor = 6;
ncor = str2num(get(handles.nbcorr_PR_edit,'String'));

% liste des 2 correcteurs concernés (les 2 derniers valides)
VCORliste = VCOR.DeviceList(end-ncor+1:end,:);
setappdata(handles.figure1,'VCORliste_PR',VCORliste);
% enregistrement des correcteurs avant correction

%%%attention !
%%handles.mode = 'Model';
%%%attention !

% enregistrement des correcteurs avant correction
liste = getam('VCOR',handles.mode);
liste = liste(end-ncor+1:end,:);% courant dans les derniers valides
% val_corr_CH = liste(valCH-nbcorrSVD+1:valCH); % Dangerux de pas travailler sur deviceliste
setappdata(handles.figure1,'val_corr_CV_PR',liste);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plan V
[bxVCOR,bzVCOR] = modelbeta('VCOR',VCORliste);
[bxBPM,bzBPM] = modelbeta('BPMx',BPMxliste);
[phixVCOR,phizVCOR] = modelphase('VCOR',VCORliste);
[phixBPM,phizBPM] = modelphase('BPMx',BPMxliste);
COEFF = hw2physics('VCOR','Setpoint',1) * 1e3 ;  % mrad/A
nu = modeltune;
deltaphi = 2*pi*nu(2) ; % 2 pi nuz

for k = 1:ncor
    for j = 1:nbpm
        % calcul de l'efficacité
        Meff_V(j,k) = sqrt(bzVCOR(k)*bzBPM(j)) * sin(deltaphi + phizBPM(j) - phizVCOR(k))*COEFF(k); % mm/A
    end
end

%[X Y] = anabpmnfirstturns(BPMxliste,2,'NoDisplay2');   % 2 tours sur les 2 premiers BPM valides
%
if strcmp(handles.orbite,'transport - max Sum') % orbite à corriger type transport
    %[X] = anabpmfirstturn( BPMx.DeviceList );
    %[X] = anabpmfirstturn( liste_dev_BPM,'NoDisplay' ); % X en mm premier tour ANCIENNE VERSION
    nbturns = 2;
    [X Y Sum idx] = anabpmnfirstturns( BPMxliste,nbturns,'NoDisplay2'); % X en mm premier tour
    idx

elseif strcmp(handles.orbite,'transport - tour fixe') % orbite à corriger type transport
    ifirstturn = str2num(get(handles.tour_fixe_T_edit,'String')); % numero du premier tour
    nbturns = 2;
    [X Y] = anabpmnfirstturns( BPMxliste,nbturns,ifirstturn,'NoDisplay2','NoMaxSum'); % X en mm premier tour

else
    errordlg('selectionnez une option transport ! ', 'attention');
end
%
%
%orbite_x_1 = X(1,:)';
orbite_z_1 = Y(1,:)';
%orbite_sum_1 = Sum(1,:)';

%orbite_x_2 = X(2,:)';
orbite_z_2 = Y(2,:)';
%orbite_sum_2 = Sum(2,:)';

% delta d'orbite à corriger :
Z = orbite_z_2 - orbite_z_1  ;% mm
difference_orbite_z = Z


%%%%%%%%%%%%%%%%%%%%%%%
[U,S,V] = svd(Meff_V);
DiagS = diag(S);
nbvp = 2
%Rmod = Meff_V * V;
Rmod1 = Meff_V* V(:,1:nbvp);
%B = Rmod\ (Z );
B1 = Rmod1\ (Z);
%DeltaCM = V * B;
DeltaCM1 = V(:,1:nbvp) * B1;
consigne = getsp('VCOR',VCORliste,handles.mode);
% test 
val_max = getmaxsp('VCOR',VCORliste);
val_min = getminsp('VCOR',VCORliste);
if all((consigne-DeltaCM1* pourcentage_V_PR*0.01)<val_max)*all((consigne-DeltaCM1* pourcentage_V_PR*0.01)>val_min);
    stepsp('VCOR',-DeltaCM1* pourcentage_V_PR*0.01 ,VCORliste,handles.mode);
    mycallback_steerette_orbites_PR(1,1,hObject, eventdata, handles)
    mycallback_steerette_corr(1,1,hObject, eventdata, handles)
    disp('eh oui')
else
    consigne-DeltaCM1
    VCORliste
    errordlg('un correcteur au moins dépasse les valeurs admises !','Attention');
    return
end


% --- Executes on button press in orbites_PR_pushbutton.
function orbites_PR_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to orbites_PR_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% plot le tour 1 et 2 des BPM [1 2] à [1  7]
List = getappdata(handles.figure1, 'BPMxList'); % BPM non deselectionné et status 1
BPMxDeviceListPR = [ 1 2; 1 3 ; 1 4; 1 5; 1 6 ; 1 7];
% tests
%BPMxDeviceListPR = [ 1 5];
BPMxDeviceListPR = intersect(List,BPMxDeviceListPR,'rows');
setappdata(handles.figure1,'BPMxDeviceListPR',BPMxDeviceListPR);
%handles.mode = getappdata(handles.figure1,'Mode')

if strcmp(handles.mode,'Model')
    errordlg('changer le mode  en "online" !','Attention');
    return
else

    %     [X Y Sum] = anabpmnfirstturns(BPMxDeviceListPR,2,'NoDisplay');   % 2 tours
    %     %
    %     orbite_x_1 = X(1)';
    %     orbite_z_1 = Z(1)';
    %     orbite_sum_1 = Sum(1)';
    %
    %     orbite_x_2 = X(2)';
    %     orbite_z_2 = Z(2)';
    %     orbite_sum_2 = Sum(2)';
    %
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %% graphe 11 : signal somme tour 1 et 2
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     name=['axes' num2str(11)];
    %     axes(handles.(name));
    %
    %     xdata = getspos(BPMxDeviceListPR);
    %     plot(xdata,orbite_sum_1,'c-','Tag','line1');
    %     hold on
    %     plot(xdata,orbite_sum_2,'c-','Tag','line2');
    %     set(handles.(name), 'YGrid','On');
    %     set(gca, 'YMinorTick','On');
    %     set(handles.(name), 'XMinorTick','On');
    %
    %     ylabel(handles.(name),'signal somme');
    %     %xlim([xdata(1) xdata(end)]);
    %     %ylim([0 max(orbite_sum)]);
    %
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %% graphe 13 : orbite x et z
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %     name=['axes' num2str(13)];
    %     axes(handles.(name));
    %     % plot des orbites
    %     xdata =getspos(BPMxDeviceListPR);
    %     %xdata = 1:length(orbite_x);
    %     plot(xdata,orbite_x_1,'r-','Tag','line1');
    %     hold on
    %     plot(xdata,orbite_x_2,'r--','Tag','line3');
    %     hold on
    %     ydata = BPMz.Position;
    %     %ydata = 1:length(orbite_z);
    %     plot(ydata,orbite_z_1,'b-','Tag','line2');
    %     hold on
    %     plot(ydata,orbite_z_2,'b--','Tag','line4');
    %     xlabel(handles.(name),'position du BPM');
    mycallback_steerette_orbites_PR(1,1,hObject, eventdata, handles)

end


% --- Executes on button press in Undo_V_PR_pushbutton.
function Undo_V_PR_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Undo_V_PR_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 
% % --- Executes on button press in pushbutton36.
% function Trace_nombre_onde_pushbutton_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton36 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)

ncor = str2num(get(handles.nbcorr_PR_edit,'String'));
% liste = getam('HCOR',handles.mode);
% liste = liste(end-ncor+1:end,:);
valliste = getappdata(handles.figure1,'val_corr_CV_PR');
VCORliste = getappdata(handles.figure1,'VCORliste_PR');

%%%%%%%%%%%%%%%%%%%%%%%%%
% attention !!
handles.mode = 'Model'
%%%%%%%%%%%%%%%%%%%%%%%%%%%
setsp('VCOR',valliste,VCORliste,handles.mode);
disp('nous y re-voilà')
% replot des orbites et point et correcteur V

mycallback_steerette_orbites_PR(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)



% --- Executes on button press in Nombre_onde_pushbutton.
function Nombre_onde_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Nombre_onde_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.orbite = getappdata(handles.figure1,'Orbite');

BPMx = getappdata(handles.figure1,'BPMx');
BPMxlist = BPMx.DeviceList;

if strcmp(handles.orbite,'orbite fermée')
    errordlg('changer le mode orbite en "transport" !','Attention');
    return
else
    compteur = getappdata(handles.figure1,'compteur');
    if compteur >1
        errordlg('Un coup de trop ! Faire Reset','Attention');
        return
    else

        if strcmp(handles.orbite,'transport - max Sum') % orbite à corriger type transport

            compteur = compteur + 1;
            nbturns = 1;
            [X Z Sum idx] = anabpmnfirstturns( BPMxlist,nbturns,'NoDisplay2'); % X en mm premier tour
            idx

        elseif strcmp(handles.orbite,'transport - tour fixe') % orbite à corriger type transport
            compteur = compteur + 1;
            ifirstturn = str2num(get(handles.tour_fixe_T_edit,'String')); % numero du premier tour
            nbturns = 1;
            [X Z Sum] = anabpmnfirstturns( BPMxlist,nbturns,ifirstturn,'NoDisplay2','NoMaxSum'); % X en mm premier tour

        else
            errordlg('erreur sur option transport !','attention')
        end

        %compteur = compteur + 1;
        % acquérir l'orbite premier tour (on suppose qu'on a actionné un correcteur)
        %[X Z Sum] = anabpmfirstturn(BPMxlist,'NoDisplay'); % ancienne version
        % enregistrement
        if compteur == 1
            setappdata(handles.figure1,'orbite_x_coup1',X);
            setappdata(handles.figure1,'orbite_z_coup1',Z);
        else
            setappdata(handles.figure1,'orbite_x_coup2',X);
            setappdata(handles.figure1,'orbite_z_coup2',Z);
        end
    end
    setappdata(handles.figure1,'compteur',compteur);
end

% --- Executes on button press in Undo_H_PR_pushbutton.
function Undo_H_PR_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Undo_H_PR_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ncor = str2num(get(handles.nbcorr_PR_edit,'String'));
% liste = getam('HCOR',handles.mode);
% liste = liste(end-ncor+1:end,:);
valliste = getappdata(handles.figure1,'val_corr_CH_PR');
HCORliste = getappdata(handles.figure1,'HCORliste_PR');

%%%%%%%%%%%%%%%%%%%%%%%%%
% attention !!
handles.mode = 'Model'
%%%%%%%%%%%%%%%%%%%%%%%%%%%
setsp('HCOR',valliste,HCORliste,handles.mode);
disp('nous y re-voilà')
% replot des orbites et point et correcteur H

mycallback_steerette_orbites_PR(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)


% --- Executes on button press in reset_nombre_onde_pushbutton.
function reset_nombre_onde_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to reset_nombre_onde_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.figure1,'compteur',0);

function pourcentage_H_PR_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pourcentage_H_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pourcentage_H_PR_edit as text
%        str2double(get(hObject,'String')) returns contents of pourcentage_H_PR_edit as a double


% --- Executes during object creation, after setting all properties.
function pourcentage_H_PR_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pourcentage_H_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Trace_nombre_onde_pushbutton.
function Trace_nombre_onde_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Trace_nombre_onde_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

BPMx = getappdata(handles.figure1,'BPMx');
BPMxlist = BPMx.DeviceList;
s = getspos('BPMx',BPMxlist);
orbite_x_coup1 = getappdata(handles.figure1,'orbite_x_coup1');
orbite_z_coup1 = getappdata(handles.figure1,'orbite_z_coup1');
orbite_x_coup2 = getappdata(handles.figure1,'orbite_x_coup2');
orbite_z_coup2 = getappdata(handles.figure1,'orbite_z_coup2');

difference_x = orbite_x_coup2 - orbite_x_coup1;
difference_z = orbite_z_coup2 - orbite_z_coup1;
figure(1)

plot(s,difference_x,'r.-',s,difference_z,'b.-')
%xlabel(handles.(name),'position en m');
xlabel('position en m');
%ylabel(handles.(name),'différence d''orbite en mm');
ylabel('différence d''orbite en mm');
grid on
hold off


function pourcentage_V_PR_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pourcentage_V_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pourcentage_V_PR_edit as text
%        str2double(get(hObject,'String')) returns contents of pourcentage_V_PR_edit as a double


% --- Executes during object creation, after setting all properties.
function pourcentage_V_PR_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pourcentage_V_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nbcorr_PR_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nbcorr_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbcorr_PR_edit as text
%        str2double(get(hObject,'String')) returns contents of nbcorr_PR_edit as a double


% --- Executes during object creation, after setting all properties.
function nbcorr_PR_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbcorr_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nbBPM_PR_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nbBPM_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbBPM_PR_edit as text
%        str2double(get(hObject,'String')) returns contents of nbBPM_PR_edit as a double


% --- Executes during object creation, after setting all properties.
function nbBPM_PR_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbBPM_PR_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ntours_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Ntours_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ntours_edit as text
%        str2double(get(hObject,'String')) returns contents of Ntours_edit as a double


% --- Executes during object creation, after setting all properties.
function Ntours_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ntours_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fourturns_pushbutton.
function fourturns_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fourturns_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

BPMxList = getappdata(handles.figure1, 'BPMxList');

[X Z] = anabpmnfirstturns(BPMxList,4,8,'NoDisplay','NoMaxSum');
[X1 X2 X3 X4] = deal(X(1,:),X(2,:),X(3,:),X(4,:));
[Z1 Z2 Z3 Z4] = deal(Z(1,:),Z(2,:),Z(3,:),Z(4,:));


%% Algo 4 turns de Laurent fourturnalogothm.m
nux = acos((X2-X1+X4-X3)/2./(X3-X2))/2/pi;
nuz = acos((Z2-Z1+Z4-Z3)/2./(Z3-Z2))/2/pi;

Xcod = (X3.*(X1+X3)-X2.*(X2+X4))./((X1-X4) + 3*(X3-X2));
Zcod = (Z3.*(Z1+Z3)-Z2.*(Z2+Z4))./((Z1-Z4) + 3*(Z3-Z2));

spos = getspos('BPMx',BPMxList);
figure(78)
plot(spos,Xcod,'b',spos,Zcod,'r');
xlabel('s-position [m]');
ylabel('Close orbit [mm]');
legend('Xcod','Zcod');
grid on

figure(79)
plot(spos,nux,'b',spos,nuz,'r')
xlabel('s-position [m]')
ylabel('tune fractionnal part')
title('4-turn Algorithm')
legend('nux','nuz');
grid on



function tour_fixe_OF_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tour_fixe_OF_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tour_fixe_OF_edit as text
%        str2double(get(hObject,'String')) returns contents of tour_fixe_OF_edit as a double


% --- Executes during object creation, after setting all properties.
function tour_fixe_OF_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tour_fixe_OF_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tour_fixe_T_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tour_fixe_T_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tour_fixe_T_edit as text
%        str2double(get(hObject,'String')) returns contents of tour_fixe_T_edit as a double


% --- Executes during object creation, after setting all properties.
function tour_fixe_T_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tour_fixe_T_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


