function varargout = correction_tour1_v2(varargin)
% CORRECTION_TOUR1_V2 M-file for correction_tour1_v2.fig
%      CORRECTION_TOUR1_V2, by itself, creates a new CORRECTION_TOUR1_V2 or raises the existing
%      singleton*.
%
%      H = CORRECTION_TOUR1_V2 returns the handle to a new CORRECTION_TOUR1_V2 or the handle to
%      the existing singleton*.
%
%      CORRECTION_TOUR1_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRECTION_TOUR1_V2.M with the given input arguments.
%
%      CORRECTION_TOUR1_V2('Property','Value',...) creates a new CORRECTION_TOUR1_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before correction_tour1_v2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to correction_tour1_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help correction_tour1_v2

% Last Modified by GUIDE v2.5 06-Apr-2006 09:00:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @correction_tour1_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @correction_tour1_v2_OutputFcn, ...
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

% --- Executes just before correction_tour1_v2 is made visible.
function correction_tour1_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to correction_tour1_v2 (see VARARGIN)

% Choose default command line output for correction_tour1_v2
handles.output = hObject;




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
HCOR.DeviceName = getfamilydata('HCOR','DeviceName',family2dev('HCOR'));
VCOR.DeviceName = getfamilydata('VCOR','DeviceName',family2dev('VCOR'));
HCOR.Position = getfamilydata('HCOR','Position',family2dev('HCOR'));
VCOR.Position = getfamilydata('VCOR','Position',family2dev('VCOR'));
BPMx.Position = getfamilydata('BPMx','Position',family2dev('BPMx'));
BPMz.Position = getfamilydata('BPMz','Position',family2dev('BPMz'));
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
HCOR_liste = family2dev('HCOR', 1);
VCOR_liste = family2dev('VCOR', 1);
setappdata(handles.figure1,'HCOR_liste',HCOR_liste);
setappdata(handles.figure1,'VCOR_liste',VCOR_liste);

% nombre max de correcteurs
setappdata(handles.figure1,'maxvalCH',size(HCOR.DeviceName,1));
setappdata(handles.figure1,'maxvalCV',size(VCOR.DeviceName,1));

% numero du correcteur courant (initalisation)
setappdata(handles.figure1,'n_selection_CH',0);
setappdata(handles.figure1,'n_selection_CV',0);

% desactiver le pushbutton "correcteur precedent"
set(handles.CH_precedent_pushbutton4,'Enable','off');
set(handles.CV_precedent_pushbutton23,'Enable','off');
% desactiver le pushbutton "correcteur suivant"
set(handles.CH_suivant_pushbutton5,'Enable','off'); 
set(handles.CV_suivant_pushbutton24,'Enable','off'); 




% button group sur switch mode simulation ou online 
h = uibuttongroup('visible','off','Position',[0.45 0.94 .22 .045],...
    'Title','Mode','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
u1 = uicontrol('Style','Radio','String','MODEL','Tag','radiobutton1',...
    'pos',[10 0.95 90 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
u2 = uicontrol('Style','Radio','String','  ON-LINE','Tag','radiobutton2',...
    'pos',[90. 0.95 90 25],'parent',h,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

handles.model = u1;
handles.online = u2;
handles.mode = 'Model';

set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});

set(h,'SelectedObject',u1);  % No selection
set(h,'Visible','on');

% Creates timer Infinite loop
timer1=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',5.,'TasksToExecute',30);
timer1.TimerFcn = {@mycallback_steerette_new, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer',timer1);

%start(timer1);


% button group sur switch timer rafraichissement orbites ON OFF 
g = uibuttongroup('visible','off','Position',[0.45 0.57 .22 .045],...
    'Title','Rafraichissement','TitlePosition','centertop',...
    'BackgroundColor',[0.696 1.0 0.924]);
v1 = uicontrol('Style','Radio','String','ON','Tag','radiobutton1',...
    'pos',[10 0.95 90 25],'parent',g,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);
v2 = uicontrol('Style','Radio','String','  OFF','Tag','radiobutton2',...
    'pos',[90. 0.95 90 25],'parent',g,'HandleVisibility','off',...
    'BackgroundColor',[0.696 1.0 0.924]);

handles.on = v1;
handles.off = v2;

set(g,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn_timer,handles});

set(g,'SelectedObject',v2);  % No selection
set(g,'Visible','on');

% This sets up the initial plot - only do when we are invisible
% so window can get raised using correction_tour1_v2.
if strcmp(get(hObject,'Visible'),'off')

    % plot des orbites
    name=['axes' num2str(3)];
    axes(handles.(name));
    
    %a% version anneau
    %[orbite_x,orbite_z] = getbpm;
    
    if handles.mode=='Model'
    
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
        else
            orbite_x = Xa*1000;orbite_z = Za*1000;
        end
    else
        % entrer lecture BPM tour par tour
    end
%%%%%%%%%%%%%%%%%%%%%%

%     setappdata(handles.figure1,'orbite_entry',X0);
%     BPMindex = family2atindex('BPMx');
%     global THERING
%     nb = 1;
%     X01 = zeros(nb, 6, length(THERING)+1);
%     for k=1:nb,
%         X01(k,:,:) = linepass(THERING, X0, 1:length(THERING)+1);
%         %X0 = X01(k,:,end)';
%     end
%     orbite_x = squeeze(X01(:,1,BPMindex))'*1000;
%     orbite_z = squeeze(X01(:,3,BPMindex))'*1000;
    xdata = 1:length(orbite_x);
    plot(xdata,orbite_x,'r-','Tag','line1');
    hold on
    ydata = 1:length(orbite_z);
    plot(ydata,orbite_z,'b-','Tag','line2');
    hold on
    
    % plot des BPM initiaux
    k = 1;
    %plot(handles.(name),k,orbite_x(k),'rs','MarkerEdgeColor','k',...
    plot(k,orbite_x(k),'rp','MarkerEdgeColor','k',...
                    'MarkerFaceColor','r',...
                    'MarkerSize',6,'Tag','line3');
    hold on
    plot(k,orbite_z(k),'rp','MarkerEdgeColor','k',...
                    'MarkerFaceColor','b',...
                    'MarkerSize',6,'Tag','line4');
    hold off

    % Set defaults
    set(handles.(name), 'Nextplot','Add');
    set(handles.(name), 'YGrid','On');
    set(gca, 'YMinorTick','On');
    set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'no du BPM');
    ylabel(handles.(name),'orbites (mm)');
    xlim([xdata(1) xdata(end)]);
    ylim([-10 10]);
    
    % plot des correcteurs
    name=['axes' num2str(9)];
    axes(handles.(name));
    xbar = 1: size(HCOR.DeviceName,1);
    ybar = 1:size(VCOR.DeviceName,1);
    liste = getam('HCOR',handles.mode);
    h0 = bar(xbar,liste,'r','Tag','bar1');
    xlim(handles.(name),[0 size(HCOR.DeviceName,1)+1]);
    ylim(handles.(name),[-10 10]);
    ylabel(handles.(name),'Icorr H (A)');
    set(h0, 'FaceColor','r');

    name=['axes' num2str(10)];
    axes(handles.(name));
    liste = getam('VCOR',handles.mode);
    h1 = bar(ybar,liste,'b','Tag','bar2');
    set(h1, 'FaceColor','b');
    xlim(handles.(name),[0 size(VCOR.DeviceName,1)+1]);
    ylim(handles.(name),[-13 13]);
    xlabel(handles.(name),'no du correcteur');
    ylabel(handles.(name),'Icorr V (A)');

    
end

% calcul des efficacit�s des correcteurs type transport
% eff (CORRI, BPMJ) = sqrt( betaI  * betaJ )  * sin ( phase J - phase I)
% SI BPMJ situ� au del� de CORRI

% plan H
[bxHCOR,bzHCOR] = modelbeta('HCOR');
[bxBPM,bzBPM] = modelbeta('BPMx');
[phixHCOR,phizHCOR] = modelphase('HCOR');
[phixBPM,phizBPM] = modelphase('BPMx');
COEFF = hw2physics('HCOR','Setpoint',1) * 1e3 ;

for k = 1:length(HCOR.Position)
    for j = 1:length(BPMx.Position)
        
        if BPMx.Position(j) > HCOR.Position(k)
            % calcul de l'efficacit�
            Meff(j,k) = sqrt(bxHCOR(k)*bxBPM(j)) * sin(phixBPM(j) - phixHCOR(k))*COEFF(k);
        else
            Meff(j,k)= 0;
        end
        
    end
end
setappdata(handles.figure1,'Meff',Meff);
disp('***  Matrice d''efficacit� H type transport calcul�e  ***')

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
setappdata(handles.figure1,'Meff_V',Meff_V);
disp('***  Matrice d''efficacit� V type transport calcul�e  ***')

%% Set closing gui function
set(handles.figure1,'CloseRequestFcn',{@Closinggui,timer1,handles.figure1});



% Update handles structure
guidata(hObject, handles);


% UIWAIT makes correction_tour1_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = correction_tour1_v2_OutputFcn(hObject, eventdata, handles)
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
        % 'Mode' = 'Simulation';
        handles.mode = 'Model';
       
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        % '.Mode' = 'Machine';
        handles.mode = 'Online';
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
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
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
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
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
DirectoryName = '/home/PM/tordeux/matlab/applications/Ring/';
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
%ydata = getam('VCOR');
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
DirectoryName = '/home/PM/tordeux/matlab/applications/Ring';
%DirectoryName = getfamilydata('Directory','FAEData')

%DirStart = '/home/PM/nadolski/controlroom/measdata/Ringdata/';
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
    errordlg('selectionnez un nombre ad�quat de correcteurs !','Attention');
    % sortir de la fonction
    return
end

Meff = getappdata(handles.figure1,'Meff'); % matrice d'efficacite
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
BPMx_status = family2status('BPMx');

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
liste_dev_BPM = elem2dev('BPMx',liste_elem_BPM);
%% tests
%liste_dev_BPM = liste_dev_BPM(3:4,1:2)
%Meffloc = Meffloc(3:4,1:2)
HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
liste_dev_HCOR = HCOR_liste(valCH-nbcorrSVD+1:valCH,:);

%%%%
BPMindex = family2atindex('BPMx',liste_dev_BPM);
spos = getspos('BPMx');

clear X01;
%X0 = [0.5e-3 0.5e-3 1e-3 1e-3 0 0]';
% g�n�ration d'une ellipse 1 sigma �ventuellement d�centr�e
eps = 150e-9;
betax = 3 ;betaz = 3 ;
alphax = 0;alphaz = 0;
deltax = 2e-3;deltaz = 2e-3;
deltaxp = 1e-3;deltazp = 1e-3;
%     eps = 0e-9;
%     betax = 3 ;
%     alphax = 0;
%     deltax = 0e-3;
%     deltaxp = 0e-3;
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
    X = X';
    %Z = Z';
else
    X = Xa;
    %Z = Za;
end
% �crire � l'�cran
%X = X

%%%

% % % x = getx(liste_dev_BPM,'struct');
% % % x.Data
hcm = getsp('HCOR',liste_dev_HCOR,'struct');
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
disp(strcat('nombre de valeurs propres s�lectionn�es :',num2str(nbvp)))

%S = S
% % test valeurs propres
% rap = 0.1;
% nbvp = 1;
% for p = 2:length(liste_dev_HCOR);
%     if S(p,p)<rap*S(1,1);
%         break
%     end
%     nbvp = nbvp + 1;
% end

Rmod = Meffloc * V;
Rmod1 = Meffloc * V(:,1:nbvp);
% % % B5 = Rmod5\ (x.Data);
% % % B1 = Rmod1\ (x.Data);
B = Rmod\ (X * 1000);
B1 = Rmod1\ (X * 1000);

%DeltaCM = V * B;
DeltaCM1 = V(:,1:nbvp) * B1;
stepsp('HCOR',-DeltaCM1* pourcentage_H*0.01 ,liste_dev_HCOR,handles.mode);

% calcul nouvelles orbites
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
    X = X';
    %Z = Z';
else
    X = Xa;
    %Z = Za;
end
% �crire � l'�cran
%X = X
%Z = Z

%setappdata(handles.figure1,'orbite_H',X*1000);
%setappdata(handles.figure1,'orbite_V',Z*1000);
%%%

mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)

% �crire la nouvelle valeur correcteur n�valCH dans l'edit
liste = getam('HCOR',handles.mode);
valeur_corr = liste(valCH);
set(handles.ICH_edit1,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICH_slider1,'Value',valeur_corr);

disp('eh oui')

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
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
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
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
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
%DirectoryName = '/home/PM/nadolski/controlroom/measdata/Ringdata/';
DirectoryName = '/home/PM/tordeux/matlab/applications/Ring/';
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
set(handles.fichier_sauvegarde_CV_edit15,'String',FileName);

% Save all data in structure to file

%DirStart = '/home/PM/nadolski/controlroom/measdata/Ringdata/'
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName); 
%xdata = getam('HCOR');
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

%DirectoryName = '/home/PM/nadolski/controlroom/measdata/Ringdata/';
DirectoryName = '/home/PM/tordeux/matlab/applications/Ring';
%DirectoryName = getfamilydata('Directory','FAEData')

%DirStart = '/home/PM/nadolski/controlroom/measdata/Ringdata/';
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
liste_dev_BPM = elem2dev('BPMz',liste_elem_BPM);
%% tests
%liste_dev_BPM = liste_dev_BPM(3:4,1:2)
%Meffloc = Meffloc(3:4,1:2)
VCOR_liste = getappdata(handles.figure1,'VCOR_liste');
liste_dev_VCOR = VCOR_liste(valCV-nbcorrSVD_V+1:valCV,:);

%%%%
BPMindex = family2atindex('BPMz',liste_dev_BPM);
spos = getspos('BPMz');

clear X01;
%X0 = [0.5e-3 0.5e-3 1e-3 1e-3 0 0]';
% g�n�ration d'une ellipse 1 sigma �ventuellement d�centr�e
eps = 150e-9;
betax = 3 ;betaz = 3 ;
alphax = 0;alphaz = 0;
deltax = 2e-3;deltaz = 2e-3;
deltaxp = 1e-3;deltazp = 1e-3;
%     eps = 0e-9;
%     betax = 3 ;
%     alphax = 0;
%     deltax = 0e-3;
%     deltaxp = 0e-3;
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
else
    %X = Xa;
    Z = Za;
end

hcm = getsp('VCOR',liste_dev_VCOR,'struct');
[U,S_V,V] = svd(Meffloc_V);
setappdata(handles.figure1,'S_V',S_V);
DiagS_V = diag(S_V);

% test si le nombre de valeurs propres a �t� modifi� dans l'interface 
% "valeurs singuli�res"
nbvp_V = getappdata(handles.figure1,'valvp_V');


% si le nbre n'a pas �t� modifi� et qu'il est incompatible :
% if nbvp_V ==0||nbvp_V>size(S_V,2)
%     nbvp_V = size(S_V,2);
% end
if nbvp_V ==0||nbvp_V>length(DiagS_V)
    nbvp_V = length(DiagS_V);
end
% affichage 
disp(strcat('nombre de valeurs propres s�lectionn�es :',num2str(nbvp_V)))

%S = S
% % test valeurs propres
% rap = 0.1;
% nbvp = 1;
% for p = 2:length(liste_dev_HCOR);
%     if S(p,p)<rap*S(1,1);
%         break
%     end
%     nbvp = nbvp + 1;
% end

Rmod1 = Meffloc_V * V(:,1:nbvp_V);
B1 = Rmod1\ (Z * 1000);
DeltaCM1_V = V(:,1:nbvp_V) * B1;
stepsp('VCOR',-DeltaCM1_V* pourcentage_V*0.01 ,liste_dev_VCOR);

% calcul nouvelles orbites
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
else
    %X = Xa;
    Z = Za;
end

mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)

% �crire la nouvelle valeur correcteur n�valCV dans l'edit
liste = getam('VCOR',handles.mode);
valeur_corr = liste(valCV);
set(handles.ICV_edit14,'String',sprintf('%3.2f',valeur_corr));

% re-initaliser le slider � cette valeur de courant
set(handles.ICV_slider2,'Value',valeur_corr);

disp('eh oui')



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
mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
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
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
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
