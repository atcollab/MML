
function varargout = emittance_v2(varargin)
% EMITTANCE_V2 M-file for emittance_v2.fig
%      EMITTANCE_V2, by itself, creates a new EMITTANCE_V2 or raises the existing
%      singleton*.
%
%      H = EMITTANCE_V2 returns the handle to a new EMITTANCE_V2 or the handle to
%      the existing singleton*.
%
%      EMITTANCE_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMITTANCE_V2.M with the given input arguments.
%
%      EMITTANCE_V2('Property','Value',...) creates a new EMITTANCE_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before emittance_v2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to emittance_v2_OpeningFcn via varargin.
%

%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help emittance_v2

% Last Modified by GUIDE v2.5 22-Jul-2005 14:22:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @emittance_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @emittance_v2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before emittance_v2 is made visible.
function emittance_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to emittance_v2 (see VARARGIN)

% initialisation de l'ACCELERATOR_OBJECT
LT1init

% creation nouveau champ
handles.output = hObject;
handles.number_errors=0.;
handles.nbsigmas=0;

%essai
%handles.nbremove=0;
handles.nbrestore=0;

val=0;
faisc=[];
st= struct([]);
cellule=cell(1,1);
%st2= struct([]);
%st3=struct([]);
handles.Sauver=struct([]);
vect_colonne_noire=[];
vect_ligne_noire=[];
directory_principale='';
directory_sauvegarde='';
setappdata(handles.figure1,'tailles',faisc);
setappdata(handles.figure1,'nbenregistrs',2);
setappdata(handles.figure1,'ResultsData',st);
setappdata(handles.figure1,'nbenregistrements',st);
setappdata(handles.figure1,'Sauver',st);
setappdata(handles.figure1,'Ecran',cellule);
setappdata(handles.figure1,'largeur_option',val);
setappdata(handles.figure1,'vect_colonne_noire',vect_colonne_noire);
setappdata(handles.figure1,'vect_ligne_noire',vect_ligne_noire);
setappdata(handles.figure1, 'G',0.043);
% initialisation drapeau pour dialogue 'sauvegarde sur disque' ____
setappdata(handles.figure1,'init_sauvegarde',val);
% directory principale (d�pend de l'utilisateur !!!)
setappdata(handles.figure1,'directory_principale',directory_principale);
setappdata(handles.figure1,'directory_sauvegarde',directory_sauvegarde);

handles.nbenregistrs=getappdata(handles.figure1,'nbenregistrs')

% Creates timer Infinite loop
timer1=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',.333,'TasksToExecute',Inf);
timer1.TimerFcn = {@mycallback, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer',timer1);

% button group sur l'image en continu
h = uibuttongroup('visible','off','Position',[0.05 .9 .12 .08],...
    'Title','Image','TitlePosition','centertop');
u1 = uicontrol('Style','Radio','String','ON','Tag','radiobutton1',...
    'pos',[2 .9 45 30],'parent',h,'HandleVisibility','off');
u2 = uicontrol('Style','Radio','String','OFF','Tag','radiobutton2',...
    'pos',[50 .9 45 30],'parent',h,'HandleVisibility','off');

% set(h,'SelectionChangeFcn',@selcbk);
set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});

set(h,'SelectedObject',u2);  % No selection
set(h,'Visible','on');

% positionne par défaut la lentille basse (plus de sensibilité pour les réglages)
set(handles.Lenthaute_radiobutton7,'Value',0);
set(handles.tata_radiobutton10,'Value',1);

%% Set closing gui function
set(handles.figure1,'CloseRequestFcn',{@Closinggui,timer1,handles.figure1});


% Update handles structure
guidata(hObject, handles);

%%%if strcmp(get(hObject,'Visible'),'off')
%%%    initialize_gui(hObject, handles);
%%%end

% UIWAIT makes emittance_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = emittance_v2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% % --- Executes during object creation, after setting all properties.

initialize_gui(gcbf, handles);

function initialize_gui(fig_handle, handles)


%____________________________________________________________________
% d�finir les alias pour les devices 
device_name.videograbber = 'lt1/dg/emit-vg';
device_name.iris = 'lt1/dg/emit-iris';
device_name.lentille_haute = 'lt1/dg/emit-l.haut';
device_name.lentille_basse = 'lt1/dg/emit-l.bas';
device_name.miroir = 'lt1/dg/emit-mc';
device_name.backlight = 'lt1/dg/emit-bl';
device_name.ecran = 'lt1/dg/emit-ecr';
device_name.Q1 = 'lt1/AE/Q.1';
device_name.Q2 = 'lt1/AE/Q.2';
device_name.Q3 = 'lt1/AE/Q.3';
device_name.Q4 = 'lt1/AE/Q.4';
% test % device_name.H1 = 'lt1/AE/CH.1';
% device_name.H2 = 'lt1/AE/CH.2';
% device_name.V1 = 'lt1/AE/CV.1';
setappdata(handles.figure1,'device_name',device_name);

%____________________________________________________________________
% directory de sauvegarde en attente

%uibuttongroup
%     prompt={'entrez votre directory de travail'};
%     name='DIRECTORY PRINCIPALE';
%     numlines=1;
%     defaultanswer={'/home/PM/tordeux/matlab_test/'};
% 
%     options.Resize='on';
%     options.WindowStyle='normal';
%     options.Interpreter='tex';
%     nom=inputdlg(prompt,name,numlines,defaultanswer,options);
%     if ~isempty(nom)
%         setappdata(handles.figure1,'directory_principale',nom{:});
%     end
% 
%     directory_principale=getappdata(handles.figure1,'directory_principale');

%DirectoryName = '/home/PM/nadolski/controlroom/measdata/LT1data/';
directory_principale = getfamilydata('Directory','EMITData');
phrase=strcat(directory_principale ,'?');
set(handles.directory_sauvegarde_edit28,'String',phrase);
setappdata(handles.figure1,'directory_principale',directory_principale);

%____________________________________________________________________
% inscrire les courants effectifs des aimants de la machine

valQ1= (read_magnet(device_name.Q1)); 
set(handles.Q1courant_edit,'String',sprintf('%3.2f',valQ1));
resQ1 = str2double(get(handles.Q1courant_edit,'String'));
setappdata(handles.figure1,'Q1courant',resQ1);

valQ2= (read_magnet(device_name.Q2)); 
set(handles.Q2courant_edit,'String',sprintf('%3.2f',valQ2));
resQ2 = str2double(get(handles.Q2courant_edit,'String'));
setappdata(handles.figure1,'Q2courant',resQ2);

valQ3= (read_magnet(device_name.Q3)); 
set(handles.Q3courant_edit,'String',sprintf('%3.2f',valQ3));
resQ3 = str2double(get(handles.Q3courant_edit,'String'));
setappdata(handles.figure1,'Q3courant',resQ3);

valQ4= (read_magnet(device_name.Q4)); 
set(handles.Q4courant_edit,'String',sprintf('%3.2f',valQ4));
resQ4 = str2double(get(handles.Q4courant_edit,'String'));
setappdata(handles.figure1,'Q4courant',resQ4);

%test % valH1= (read_magnet(device_name.H1)); 
% set(handles.H1courant_edit,'String',sprintf('%3.2f',valH1));
% resH1 = str2double(get(handles.H1courant_edit,'String'));
% setappdata(handles.figure1,'H1courant',resH1);
% 
% valH2= (read_magnet(device_name.H2)); 
% set(handles.H2courant_edit,'String',sprintf('%3.2f',valH2));
% resH2 = str2double(get(handles.H2courant_edit,'String'));
% setappdata(handles.figure1,'H2courant',resH2);
% 
% valV1= (read_magnet(device_name.V1)); 
% set(handles.V1courant_edit,'String',sprintf('%3.2f',valV1));
% resV1 = str2double(get(handles.V1courant_edit,'String'));
% setappdata(handles.figure1,'V1courant',resV1);

%____________________________________________________________________
% insrire une valeur par d�faut de calibration ???
set(handles.G_edit12,'String',num2str(43));
clear('figh');

%____________________________________________________________________
% mettre off le bouton calibration de l'image
set([handles.calibOFF_radiobutton6],'Value',1);

%____________________________________________________________________
% exclure la possibilit� de calibrer et de bouger les lentilles
set([handles.Lenthaute_radiobutton7,handles.tata_radiobutton10,...
 handles.ppp_pushbutton18,handles.pp_pushbutton19,handles.p_pushbutton20...
 handles.mmm_pushbutton21,handles.mm_pushbutton22,handles.m_pushbutton23...
 ,handles.backlight_popupmenu3,...
 handles.Gmax_pushbutton26,handles.Gmoy_pushbutton27,handles.Gmin_pushbutton28,...
 handles.qualite_edit23,handles.G_edit12,...
    handles.pos1_edit29,handles.pos2_edit30...
    handles.text45,handles.text39,handles.text26,handles.text41...
    handles.calib_pushbutton7],'Enable','off')
% handles.backlight_pushbutton24,handles.iris_pushbutton25,...

%____________________________________________________________________
% positionner le miroir HORS, eteindre le backlight
% tango_command_inout('lt1/emit/mirror','Off');
% tango_command_inout('lt1/emit/backlight','SetBrightness',uint16(0));
tango_command_inout(device_name.miroir,'Off');
tango_command_inout(device_name.backlight,'SetBrightness',uint16(0));
%___________________________________________________________________
% position des lentilles pour les differents grandissements, en nombre de pas
setappdata(handles.figure1,'posl1Gmax',3000);
setappdata(handles.figure1,'posl2Gmax',35130);
setappdata(handles.figure1,'posl1Gmoy',8650);
setappdata(handles.figure1,'posl2Gmoy',26500);
setappdata(handles.figure1,'posl1Gmin',0);
setappdata(handles.figure1,'posl2Gmin',3925);

%____________________________________________________________________
% positionner les voyants des but�es lentilles � leur valeur vraies

%dev=device_name.lentille_haute;
dev=device_name.lentille_haute;
errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');


% errorstatus=21 d�c�l�ration ou arr�t d� � un limit switch sens +
% errorstatus=3  limitswitch forward
% errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens -
% errorstatus=4  limitswitch backward

if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

else
        % cas ou l'axe est en butee backward (en haut)
        if isequal(errorstatus,22)|isequal(errorstatus,4)
            set(handles.LHBH_edit25,'BackgroundColor','red');
        end
        % cas ou l'axe est en butee forward (en bas)
        if isequal(errorstatus,21)|isequal(errorstatus,3)
            set(handles.LHBB_edit24,'BackgroundColor','red');
        end

end         


dev=device_name.lentille_basse

errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

else
        % cas ou l'axe est en butee backward (en haut)
        if isequal(errorstatus,22)|isequal(errorstatus,4)
            set(handles.LBBH_edit26,'BackgroundColor','red');
        end
        % cas ou l'axe est en butee forward (en bas)
        if isequal(errorstatus,21)|isequal(errorstatus,3)
            set(handles.LBBB_edit27,'BackgroundColor','red');
        end
end           


%____________________________________________________________________
% allumer en rouge le grandissement effectif

posl1Gmax=getappdata(handles.figure1,'posl1Gmax');
posl2Gmax=getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy=getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy=getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin=getappdata(handles.figure1,'posl1Gmin');
posl2Gmin=getappdata(handles.figure1,'posl2Gmin');


dev1=device_name.lentille_haute;
dev2=device_name.lentille_basse;

str1=tango_read_attribute(dev1,'AxisCurrentPosition');
str2=tango_read_attribute(dev2,'AxisCurrentPosition');
position1=str1.value(1);
position2=str2.value(1);

set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);

if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

else
        % cas du grandissement max
        if isequal(position1,posl1Gmax)&isequal(position2,posl2Gmax)
            set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);
        end
        % cas du grandissement moyen
        if isequal(position1,posl1Gmoy)&isequal(position2,posl2Gmoy)
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);
        end
        % cas du grandissement min
        if isequal(position1,posl1Gmin)&isequal(position2,posl2Gmin)
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
        end

end           

%________________________________________________________________________
% �crire les valeurs effectives de positions des lentilles

pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
set(handles.pos2_edit30,'String',num2str(pos2.value(1)));


%set(handles.nbacqu_edit13,'String',num2str(handles.nbenregistrs));
%set(handles.nbacqu_edit13,'String',num2str(handles.nbenregistrs));

% --- Executes during object creation, after setting all properties.
function lent1_slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lent1_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% du temps ou il y avait des sliders....
%         % --- Executes on slider movement.
%         function lent1_slider1_Callback(hObject, eventdata, handles)
%         % hObject    handle to lent1_slider1 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    structure with handles and user data (see GUIDATA)
% 
%         % Hints: get(hObject,'Value') returns position of slider
%         %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 
%         set(handles.lent1_edit5,'String',...
%             num2str(get(handles.lent1_slider1,'Value')));
% 
%         % --- Executes during object creation, after setting all properties.
%         function lent1_edit5_CreateFcn(hObject, eventdata, handles)
%         % hObject    handle to lent1_edit5 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    empty - handles not created until after all CreateFcns called
% 
%         % Hint: edit controls usually have a white background on Windows.
%         %       See ISPC and COMPUTER.
%         if ispc
%             set(hObject,'BackgroundColor','white');
%         else
%             set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%         end


%         function lent1_edit5_Callback(hObject, eventdata, handles)
%         % hObject    handle to lent1_edit5 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    structure with handles and user data (see GUIDATA)
% 
%         % Hints: get(hObject,'String') returns contents of lent1_edit5 as text
%         %        str2double(get(hObject,'String')) returns contents of lent1_edit5 as a double
% 
% 
%         val = str2double(get(handles.lent1_edit5,'String'));
%         % Determine whether val is a number between 0 and 1
%         if isnumeric(val) & length(val)==1 & ...
%             val >= get(handles.lent1_slider1,'Min') & ...
%             val <= get(handles.lent1_slider1,'Max')
%             set(handles.lent1_slider1,'Value',val);
%         else
%         % Increment the error count, and display it
%             handles.number_errors = handles.number_errors+1;
%             guidata(hObject,handles); % store the changes
%             set(handles.lent1_edit5,'String',...
%             ['Caramba ',...
%         %num2str(handles.number_errors),' Times']);
%             '']);
%         end
% 
% 
%         % --- Executes during object creation, after setting all properties.
%         function lent2_slider2_CreateFcn(hObject, eventdata, handles)
%         % hObject    handle to lent2_slider2 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    empty - handles not created until after all CreateFcns called
% 
%         % Hint: slider controls usually have a light gray background, change
%         %       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
%         usewhitebg = 1;
%         if usewhitebg
%             set(hObject,'BackgroundColor',[.9 .9 .9]);
%         else
%             set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%         end
% 
% 
%         % --- Executes on slider movement.
%         function lent2_slider2_Callback(hObject, eventdata, handles)
%         % hObject    handle to lent2_slider2 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    structure with handles and user data (see GUIDATA)
% 
%         % Hints: get(hObject,'Value') returns position of slider
%         %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 
%         set(handles.lent2_emitV_edit19,'String',...
%             num2str(get(handles.lent2_slider2,'Value')));
% 
%         % --- Executes during object creation, after setting all properties.
%         function lent2_emitV_edit19_CreateFcn(hObject, eventdata, handles)
%         % hObject    handle to lent2_emitV_edit19 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    empty - handles not created until after all CreateFcns called
% 
%         % Hint: edit controls usually have a white background on Windows.
%         %       See ISPC and COMPUTER.
%         if ispc
%             set(hObject,'BackgroundColor','white');
%         else
%             set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
%         end
% 
% 
% 
%         function lent2_emitV_edit19_Callback(hObject, eventdata, handles)
%         % hObject    handle to lent2_emitV_edit19 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    structure with handles and user data (see GUIDATA)
% 
%         % Hints: get(hObject,'String') returns contents of lent2_emitV_edit19 as text
%         %        str2double(get(hObject,'String')) returns contents of lent2_emitV_edit19 as a double
% 
%         val = str2double(get(handles.lent2_emitV_edit19,'String'));
%         % Determine whether val is a number between 0 and 1
%         if isnumeric(val) & length(val)==1 & ...
%             val >= get(handles.lent2_slider2,'Min') & ...
%             val <= get(handles.lent2_slider2,'Max')
%             set(handles.lent2_slider2,'Value',val);
%         else
%         % Increment the error count, and display it
%             handles.number_errors = handles.number_errors+1;
%             guidata(hObject,handles); % store the changes
%             set(handles.lent2_emitV_edit19,'String',...
%             ['Zut ',...
%         %num2str(handles.number_errors),'']);
%             '']);
%         end

% --- Executes on button press in calib_pushbutton7.
function calib_pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to calib_pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% alias
device_name=getappdata(handles.figure1,'device_name');
dev=device_name.videograbber;

tango_command_inout(dev,'Calibrate');
%ATTENTION PEUT ETRE ATTRIBUTS  AVEC un SSSSS
if isequal(tango_error,-1)
    
    %errordlg('erreur TANGO...','Error');
    tango_print_error_stack;
    diag = tango_error_stack;
    errordlg(diag(1).desc);
else   
    
    res=tango_read_attribute(dev,'calibration_quality');
    % on teste la qualit� de la calibration  FACTEUR 996.0
    % le 10 septembre MATLAB a pris lamain sur le code de NL pour le
    % crit�re. attention � 990 on est dans les choux
    if res.value>996.0
        val=sprintf('%3.2f',res.value);
        set(handles.qualite_edit23,'String',val);
        tango_read_attribute(dev,'x_magnification_factor');
        val=sprintf('%2.1f',1000*ans.value);
        set(handles.G_edit12,'String',val);
        setappdata(handles.figure1, 'G',str2num(val)/1000)
        
        %dev='lt1/dg/emit-vg';
        pause(1);
        toto=tango_read_attribute(dev,'corrected_image');
        figure(2);
        imagesc(toto.value);
        colormap(gray);

    else
        errordlg('la calibration a echou�e ...','Error'); 
    end
    
end




% --- Executes during object creation, after setting all properties.
function fit_popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fit_popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in fit_popupmenu1.
function fit_popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to fit_popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fit_popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fit_popupmenu1

val = get(hObject,'Value');
switch val
case 1
    largeur_option=0;
case 2
    % fit par gaussienne
    largeur_option=1;

case 3
    % vrai rms
    largeur_option=2;
    
case 4
    % rayon � X %
    largeur_option=3;
end
setappdata(handles.figure1,'largeur_option',largeur_option);

% --- Executes on button press in mesure_pushbutton8.
function mesure_pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to mesure_pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%nbiterations=0;
%nombre1=get(handles.fit_popupmenu1, 'String');

popup_sel_index = get(handles.nbiter_popupmenu2, 'Value');
nombre2=get(handles.nbiter_popupmenu2, 'String');
Name = nombre2{popup_sel_index};
nbiterat=str2num(Name(1));
setappdata(handles.figure1, 'nbiterations',nbiterat);
set(handles.nbiter_edit37,'String',Name(1));
switch popup_sel_index
    case 1
         errordlg('selectionnez un nombre d''iterations','Error');
	     %error('Select a number of acquisitions'); %exprimez votre choix 
    case 2
        %test de la pause : pause(10); 
        show1imagesgui_15(handles);     
         
    case 3
         show5imagesgui_15(handles);    
    case 4
         show10imagesgui(handles);
        
end


% --- Executes on button press in plot_pushbutton.
function plot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ResultsData=getappdata(handles.figure1,'ResultsData');
handles.matrx=[];
handles.matry=[];
for ik=1:length(handles.ResultsData)
    handles.matrx(ik,1)=handles.ResultsData(ik).Q4courant;
    handles.matrx(ik,2)=handles.ResultsData(ik).LargeurH;
    errorx(ik)=2*handles.ResultsData(ik).sigmaH;
    handles.matry(ik,1)=handles.ResultsData(ik).Q4courant;
    handles.matry(ik,2)=handles.ResultsData(ik).LargeurV;
    errory(ik)=2*handles.ResultsData(ik).sigmaV;
end

clear('figure3');
figure(3);
toto1=handles.matrx(:,1)
toto2=handles.matrx(:,2)

%plot(handles.matrx(:,1),handles.matrx(:,2),'d')
%%plot(handles.matry(:,1),handles.matry(:,2),'d')
    % %'--rs','LineWidth',2,...
    % %                'MarkerEdgeColor','k',...
    % %                'MarkerFaceColor','g',...
    %  %               'MarkerSize',8)
    % 
    %  
    % %%t=[4.298 3.5 3.9 4.6 5.1 5.6 6.2]';
    % %%y=[2.3 13.5 7. 0.85 1.8 6.3 22.]';
    % %plot(t,y,'+'),grid on
X = [ones(size(handles.matrx(:,1)))  handles.matrx(:,1)  handles.matrx(:,1).^2];
a=X\handles.matrx(:,2);
Tmin=min(handles.matrx(:,1));
Tmax=max(handles.matrx(:,1));
T=[Tmin:0.1:Tmax]';
Z = [ones(size(T))  T  T.^2]*a;
hold on
plot(T,Z,'r-',handles.matrx(:,1),handles.matrx(:,2),'ro'), grid on


Y = [ones(size(handles.matry(:,1)))  handles.matry(:,1)  handles.matry(:,1).^2];
a=Y\handles.matry(:,2);
Tmin=min(handles.matry(:,1));
Tmax=max(handles.matry(:,1));
T=[Tmin:0.1:Tmax]';
Z = [ones(size(T))  T  T.^2]*a;
hold on
plot(T,Z,'b-',handles.matry(:,1),handles.matry(:,2),'b+'), grid on

% exemple de label des axes avec symboles grecs :
xlabel('-\pi \leq \Theta \leq \pi')
ylabel('sin(\Theta)')
title('Plot of sin(\Theta)')
text(-pi/4,sin(-pi/4),'\leftarrow sin(-\pi\div4)',...
     'HorizontalAlignment','left')
 
% nos labels
xlabel('Courant quadrupolaire (A)')
ylabel('Largeur faisceau (mm2')
title('Courbe de focalisation')

% Q1courant de 1 � 10 A
%T=[1:0.1:10]';
%Y = [ones(size(T))  T  T.^2]*a;
%%figure(1);
%hold on
%figure(4)
%plot(T,Y,'-',handles.matrx(:,1),handles.matrx(:,2),'o'), grid on
%hold on

% barre d'erreur
% hold on
% errorbar(handles.matrx(:,1),handles.matrx(:,2),errorx) 


% --- Executes during object creation, after setting all properties.
function Q1courant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q1courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Q1courant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Q1courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Q1courant_edit as text
%        str2double(get(hObject,'String')) returns contents of Q1courant_edit as a double


ecriture('Q1',handles)



function ecriture(aimant,handles)

device_name = getappdata(handles.figure1,'device_name');
Name = strcat(aimant,'courant_edit');
res = str2double(get(handles.(Name),'String'));
valmax=tango_get_attribute_config(device_name.(aimant),'current');

if res > str2double(valmax.max_value)
    set(handles.(Name),'BackgroundColor','red');
    errordlg('Courant superieur � valeur maximale !','ALARME');
    guidata(gcbo,handles);
    old = tango_read_attribute(device_name.(aimant),'current');
    set(handles.(Name),'String',num2str(old.value(1)));
    pause(2);
    set(handles.(Name),'BackgroundColor','green');
else
    set(handles.(Name),'BackgroundColor','green');
    Name2 =[aimant 'courant'];
    setappdata(handles.figure1,Name2,res);
    tango_write_attribute(device_name.(aimant),'current',res);
end


% --- Executes during object creation, after setting all properties.
function H1courant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H1courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function H1courant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to H1courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H1courant_edit as text
%        str2double(get(hObject,'String')) returns contents of H1courant_edit as a double

ecriture('H1',handles)



% --- Executes during object creation, after setting all properties.
function V1courant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V1courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function V1courant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to V1courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ecriture('V1',handles)


% ------- lecture de valeurs dans les devices servers Tango ----------
function Cour=read_magnet(dev)

attr_val = tango_read_attribute(dev,'current');
if (tango_error == -1)
  %- handle error 
  tango_print_error_stack;
  fprintf(1,'TracyServer Error %s\n',dev)
  return;
end
Cour=attr_val.value(1);

% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function nbiter_popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbiter_popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'Nbre iterations par acquisition','1 iteration par acquisition'...
    ,'5 iterations par acquisition'...
    });

% --- Executes on selection change in nbiter_popupmenu2.
function nbiter_popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to nbiter_popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns nbiter_popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nbiter_popupmenu2


% % --- Executes on button press in camera_control_togglebutton.
% function camera_control_togglebutton_Callback(hObject, eventdata, handles)
% % hObject    handle to camera_control_togglebutton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of camera_control_togglebutton
% button_state = get(hObject,'Value');
% if button_state == get(hObject,'Max')
%     % toggle button is pressed
% elseif button_state == get(hObject,'Min')
%     % toggle button is not pressed
% end


% � d�truire
%         % --- Executes on button press in camera_image_togglebutton.
%         function camera_image_togglebutton_Callback(hObject, eventdata, handles)
%         % hObject    handle to camera_image_togglebutton (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    structure with handles and user data (see GUIDATA)
% 
%         % Hint: get(hObject,'Value') returns toggle state of camera_image_togglebutton
%         button_state = get(hObject,'Value');
%         if button_state == get(hObject,'Max')
%             % toggle button is pressed
%         elseif button_state == get(hObject,'Min')
%             % toggle button is not pressed
%         end
% 
%         %camera_image(handles);
% 
% 
%         %     name=['axes' num2str(1)];
%         %    axes(handles.(name))
%         % timer1 = timer('Period', 2,'TasksToExecute', 
%         % Inf,'ExecutionMode','fixedRate');
% 
%         %     t=timer('StartDelay',1,'TimerFcn',@mycallback,...
%         %     'ExecutionMode','fixedRate','Period',0.333,'TasksToExecute',10);
% 
%         % timer1=timer('StartDelay',1,...
%         %     'ExecutionMode','fixedRate','Period',0.333,'TasksToExecute',10);
%         % timer1.TimerFcn = {@mycallback, hObject,eventdata, handles};
% 
%         %figure(1);
%         %axes(handles.axes1);
%         timer1 = getappdata(handles.figure1,'Timer');
%         start(timer1);

%     % --- Executes on button press in imageOFF_radiobutton.
%     function imageOFF_radiobutton_Callback(hObject, eventdata, handles)
%     % hObject    handle to imageOFF_radiobutton (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     % handles    structure with handles and user data (see GUIDATA)
% 
%     % Hint: get(hObject,'Value') returns toggle state of imageOFF_radiobutton
% 
%     timer1 = getappdata(handles.figure1,'Timer');
%     delete(timer1);


% % function buttongroup(hObject, eventdata, handles)
% % h = uibuttongroup('visible','off','Position',[0 .9 .1 .1]);
% % u0 = uicontrol('Style','Radio','String','Option 1',...
% %     'pos',[10 350 80 30],'parent',h,'HandleVisibility','off');
% % u1 = uicontrol('Style','Radio','String','Option 2',...
% %     'pos',[10 250 80 30],'parent',h,'HandleVisibility','off');
% % u2 = uicontrol('Style','Radio','String','Option 3',...
% %     'pos',[10 150 80 30],'parent',h,'HandleVisibility','off');
% % set(h,'SelectionChangeFcn',@selcbk);
% % set(h,'SelectedObject',[]);  % No selection
% % set(h,'Visible','on');

% function selcbk(source,eventdata)
% disp(source);
% disp('toto');
% disp([eventdata.EventName,'  ',... 
%      get(eventdata.OldValue,'String'),'  ', ...
%      get(eventdata.NewValue,'String')]);
% disp(get(get(source,'SelectedObject'),'String'));

function uibuttongroup_SelectionChangeFcn(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

timer1 = getappdata(handles.figure1,'Timer');
switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here
        disp('image video <-')
        start(timer1);
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        disp('image video ->')
        stop(timer1);
end


%     % --- Executes on button press in imageON_radiobutton.
%     function imageON_radiobutton_Callback(hObject, eventdata, handles)
%     % hObject    handle to imageON_radiobutton (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     % handles    structure with handles and user data (see GUIDATA)
% 
%     % Hint: get(hObject,'Value') returns toggle state of imageON_radiobutton
% 
%     timer1 = getappdata(handles.figure1,'Timer');
%     start(timer1);


function mutual_exclude(off)
set(off,'Value',0)

% --- Executes on button press in calibON_radiobutton5.
function calibON_radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to calibON_radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calibON_radiobutton5
off = [handles.calibOFF_radiobutton6];
mutual_exclude(off)

% alias
device_name = getappdata(handles.figure1,'device_name');

% positionner le miroir EN, allumer le backlight
tango_command_inout(device_name.miroir,'On');
tango_command_inout(device_name.backlight,'SetBrightness',uint16(6));

%____________________________________________________________________
% positionner le popupmenu du backlight a la valeur effective
lumiere=tango_command_inout(device_name.backlight,'GetBrightness');

%- check error
if (tango_error == -1)
      %- handle error
      tango_print_error_stack;
      return;
else
    set(handles.backlight_popupmenu3,'Value',lumiere);
end

%rendre la possibilit� de calibrer et de bouger les lentilles
set([handles.Lenthaute_radiobutton7,handles.tata_radiobutton10,...
     handles.ppp_pushbutton18,handles.pp_pushbutton19,handles.p_pushbutton20...
     handles.mmm_pushbutton21,handles.mm_pushbutton22,handles.m_pushbutton23...
     handles.backlight_popupmenu3,...
     handles.Gmax_pushbutton26,handles.Gmoy_pushbutton27,handles.Gmin_pushbutton28,...
     handles.qualite_edit23,handles.G_edit12,...
     handles.pos1_edit29,handles.pos2_edit30...
     handles.text45,handles.text39,handles.text26,handles.text41...
        handles.calib_pushbutton7],'Enable','on')
% handles.backlight_pushbutton24,handles.iris_pushbutton25,...

% --- Executes on button press in calibOFF_radiobutton6.
function calibOFF_radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to calibOFF_radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calibOFF_radiobutton6
off = [handles.calibON_radiobutton5];
mutual_exclude(off)

% alias

device_name = getappdata(handles.figure1,'device_name');
%getappdata(handles.figure1,'backlight');

% positionner le miroir HORS, eteindre le backlight
tango_command_inout(device_name.miroir,'Off');
tango_command_inout(device_name.backlight,'SetBrightness',uint16(0));

%% inserer l'écran YAG
%tango_command_inout(device_name.ecran,'Insert');
%fonction_error;

%exclure la possibilit� de calibrer et de bouger les lentilles
set([handles.Lenthaute_radiobutton7,handles.tata_radiobutton10,...
     handles.ppp_pushbutton18,handles.pp_pushbutton19,handles.p_pushbutton20...
     handles.mmm_pushbutton21,handles.mm_pushbutton22,handles.m_pushbutton23...
     handles.backlight_popupmenu3,...
     handles.Gmax_pushbutton26,handles.Gmoy_pushbutton27,handles.Gmin_pushbutton28,...
     handles.qualite_edit23,handles.G_edit12,...
        handles.pos1_edit29,handles.pos2_edit30...
        handles.text45,handles.text39,handles.text26,handles.text41...
        handles.calib_pushbutton7],'Enable','off')
%handles.backlight_pushbutton24,handles.iris_pushbutton25,...

% --- Executes during object creation, after setting all properties.
function G_edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G_edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function G_edit12_Callback(hObject, eventdata, handles)
% hObject    handle to G_edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G_edit12 as text
%        str2double(get(hObject,'String')) returns contents of G_edit12 as a double





% ------------------------------------------------------------
% Callback for the Remove push button
% ------------------------------------------------------------
% --- Executes on button press in remove_pushbutton.
function remove_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to remove_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Callback of the uicontrol handles.RemoveButton.
%essai
%handles.nbremove=handles.nbremove+1

currentVal = get(handles.listbox1,'Value')
resultsStr = get(handles.listbox1,'String')
numResults = size(resultsStr,1)


% Remove the data and list entry for the selected value

handles.Ecran=getappdata(handles.figure1,'Ecran');
% handles.Sauver contient la structure du r�sultat � effacer
handles.Sauver=getappdata(handles.figure1,'Sauver');
if isequal( handles.Ecran,{[]})
    handles.Ecran= resultsStr(currentVal);
else
    handles.Ecran=[ handles.Ecran ; resultsStr(currentVal)];
end
resultsStr(currentVal) =[];
resultats=getappdata(handles.figure1,'ResultsData');
%%NumeroRemove=resultats(currentVal).RunNumber;
if isequal( handles.Sauver,struct([]))
    handles.Sauver=resultats(currentVal);
else
    handles.Sauver=[handles.Sauver  resultats(currentVal)];
end

resultats(currentVal)=[];
setappdata(handles.figure1,'ResultsData',resultats);
handles.ResultsData = resultats;

%essai
%restoreRes(handles.nbremove)=resultats(currentVal)
%handles.restore=handles.remove+1;
if ~isequal(numResults,1)
    set([handles.restaurer_pushbutton15],'Enable','on')
end
% If there are no other entries, disable the Remove and Plot button
% and change the list sting to <empty>
if isequal(numResults,1)
	resultsStr = {'<vide !!>'};
	currentVal = 1;
	set([handles.remove_pushbutton,handles.plot_pushbutton,...
        handles.restaurer_pushbutton15],'Enable','off')	
end



% Ensure that list box Value is valid, then reset Value and String
currentVal = min(currentVal,size(resultsStr,1));
set(handles.listbox1,'Value',currentVal,'String',resultsStr)

% Store the new ResultsData
setappdata(handles.figure1,'Sauver',handles.Sauver);
setappdata(handles.figure1,'Ecran',handles.Ecran);
set(handles.nbacqu_edit13,'String', num2str(size(resultsStr,1)));

% affiche le nombre de data utilis�s dans le calcul d'�mittance
%%en attente   set(handles.nbacqu_edit13,'String',num2str(length(resultats)));

guidata(hObject, handles);

% --- Executes on button press in emittance_pushbutton12.
function emittance_pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to emittance_pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% calcul d'emittance

handles.ResultsData = getappdata(handles.figure1,'ResultsData');
largeur_option = getappdata(handles.figure1,'largeur_option');

switch largeur_option
case 1
    % fit par gaussienne largeur_option = 1
    set(handles.type_edit36,'String','rms (fit)');
case 2
    % vrai rms largeur_option = 2
    set(handles.type_edit36,'String','vrai rms');
    
case 3
    % rayon � X % largeur_option = 3
    set(handles.type_edit36,'String','à X %');
end


% les vecteurs sx et sy sont déjà les valeurs moyenn�es sur nbiter iterations
for i=1:length(handles.ResultsData)
    sx(i) = handles.ResultsData(i).LargeurH;
    sy(i) = handles.ResultsData(i).LargeurV;
    I(i)= handles.ResultsData(i).Q4courant;
end
%%I = [1 2 3 4]

% transformation courant - force quadrupolaire
% �talonnage de Q7 (si on a le temps pr�f�rez �talonnage Q4, mais pas trop important)
% ATTENTION n�cessit� de connaotre m'�nergie de la ligne (he oui ce n'est
% pas simple) A RENTRER A LA MAIN DANS L'INTERFACE
res = get(handles.energie_edit38,'String');
if isequal(res,'ENERGIE')
    errordlg('vous n''avez pas rentré l''énergie de la ligne !','Attention');
    return
end
Energie = Str2num(get(handles.energie_edit38,'String'))*0.001;
%t = amp2k4LT1(I,[-1.49e-6 2.59e-5 -1.93e-4 4.98e-2 8.13e-4 ]/0.15 , 1,Energie)
%Family, Field, Amps, DeviceList, Energy, C, K2AmpScaleFactor
 t = amp2k4LT1('QP','SetPoint',I, [1 4], Energie,[-1.49e-6 2.59e-5 -1.93e-4 4.98e-2 8.13e-4 ]/0.15,1)
%t = hw2physics('QP','Setpoint',I,[1 4],Energie)';
%% tests !
%t=[4.298 3.5 3.9 4.6 5.1 5.6 6.2]';
%sx=[1.641  3.823 2.703 0.977 1.173 2.424 4.074];
%sy=[1.641  3.823 2.703 0.977 1.173 2.424 4.074];

% constantes de la ligne de transfert
% valeur vérifiée sur 3D D Zerbib 11 février 2005

Drift = [0.150 1.669 0.85415 2.400 0.950 3.79286];
%     % point 0 simulation barelattice_LT1 � entr�e Lmag Q1
%     drift1 = 1.669
%     % sortie Lmag Q1 entr�e Lmag Q2
%     drift2 = 1.00415 - 0.150 = 0.85415
%     % sortie Lmag Q2 entr�e Lmag Q3
%     drift3 = 2.550 - 0.150 = 2.400
%     % sortie Lmag Q3 entr�e Lmag Q4
%     drift4 = 1.100 - 0.150 = 0.95
%     % sortie L magn�tique Qp�le - centre �mittance
%     drift5 = 3867,86 - 150/2 =  3792.86
setappdata(handles.figure1,'Drift',Drift)
Lq = Drift(1);
Ld = Drift(6);
Md = [1 Ld ; 0 1];

% plan HORIZONTAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcul des elements de la matrice de transport entre le Qpole et le point de mesure

% tailles en unité standard
sx = sx * 0.001;
sx2=sx.*sx;

Mx11=zeros(length(t),1);
Mx12=zeros(length(t),1);
for i = 1:length(t)
        clear('Mxq','Mxtransport')
        Mxq=[cos(Lq*sqrt(t(i)))  (1/sqrt(t(i)))*sin(Lq*sqrt(t(i))) ; ...
        -sqrt(t(i))*sin(Lq*sqrt(t(i)))  cos(Lq*sqrt(t(i)))];
        Mxtransport=Md*Mxq;
        Mx11(i)=Mxtransport(1,1);
        Mx12(i)=Mxtransport(1,2);
end

% *********** methode Belbeoch **********************
A=Mx11.*Mx11;
B=Mx12.*Mx12;
F=2*Mx11.*Mx12 ;
    
Z=[A'*A A'*B A'*F ; B'*A B'*B B'*F ; ...
           F'*A F'*B F'*F];
H=[A'*sx2' ; B'*sx2' ; F'*sx2'];
   
twissx=Z\H;
% twissx(1) = sigma11(point origine) = Eps beta
% twissx(2) = sigma22(point origine) = Eps gamma
% twissx(3) = sigma12(point origine) = - Eps alpha
epsx = sqrt(twissx(1)*twissx(2)-twissx(3)*twissx(3));
% affichage de l'emittance en mm mrad
emittanceH = sprintf('%3.2f',epsx*1e6) ;
set(handles.emitH_edit18,'String',emittanceH);
setappdata(handles.figure1,'Twissx',twissx);

% plan VERTICAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calcul des elements de la matrice de transport entre le Qpole et le point de mesure

sy = sy * 1e-3;
sy2=sy.*sy;

My11=zeros(length(t),1);
My12=zeros(length(t),1);
for i = 1:length(t)
        clear('Myq','Mytransport')
        Myq=[cosh(Lq*sqrt(t(i)))  (1/sqrt(t(i)))*sinh(Lq*sqrt(t(i))) ; ...
        sqrt(t(i))*sinh(Lq*sqrt(t(i)))  cosh(Lq*sqrt(t(i)))];
        Mytransport=Md*Myq;
        My11(i)=Mytransport(1,1);
        My12(i)=Mytransport(1,2);
end

% *********** methode Belbeoch **********************
A=My11.*My11;
B=My12.*My12;
F=2*My11.*My12 ;
    
Z=[A'*A A'*B A'*F ; B'*A B'*B B'*F ; ...
           F'*A F'*B F'*F];
H=[A'*sy2' ; B'*sy2' ; F'*sy2'];
   
twissy=Z\H;
epsy = sqrt(twissy(1)*twissy(2)-twissy(3)*twissy(3));
emittanceV = sprintf('%3.2f',epsy*1e6) ;
set(handles.emitV_edit19,'String',emittanceV);
setappdata(handles.figure1,'Twissy',twissy);



%         %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%         % Mesure de l'emittance par fit "Belbeoch" et distribution normale des
%         % erreurs de mesures
% 
%         % valeurs exactes gradient t
%         % valeurs exactes tailles de faisceau se
%         % pourc = pourcentage d'erreur maximum sur la mesure de taille
%         % Lq = Longueur du quadrupole
%         % Ld = longueur du drift Qpole - point de mesure
%         %---------------------------------------------------------
%         % 
% 
%         %cla(figure(1));
% 
%         % methode de calcul
%         method = 'moyenne des acquisitions';
%         %method = 'moyenne des emittances'
% 
%         % erreur sur les mesures de taille / nb d'iterations sur une mesure/ pour
%         % tester la validite de la methode : nb de tests 
%         sigma = 0.35;
%         % ? nbiter=5;
%         nbiter=1;
%         nbtests=30000;
% 
%         % valeurs exactes de forces quadrupolaires et tailles de faisceau
%         t=[4.298 3.5 3.9 4.6 5.1 5.6 6.2]';
%         se=[1.641  3.823 2.703 0.977 1.173 2.424 4.074];
% 
%         % initialisations
%         % ? eps=zeros(nbiter,1);
%         eps=zeros(nbtests,1);
%         Lq=0.15;
%         Ld=3.8915;
%         Md=[1 Ld ; 0 1];
%         st2=zeros(nbiter,length(t));
%         meanst2=zeros(1,length(t));
% 
%         nbcomplexes=0;
%         stdeps=1.;
%         g=0;
%         Z=zeros(3,3);
% 
% 
%         % calcul des elements de la matrice de transport entre le Qpole et le point
%         % de mesure
%         M11=zeros(length(t),1);
%         M12=zeros(length(t),1);
%         for i = 1:length(t)
%                 clear('Mq','Mtransport')
%                 Mq=[cos(Lq*sqrt(t(i)))  (1/sqrt(t(i)))*sin(Lq*sqrt(t(i))) ; ...
%                 -sqrt(t(i))*sin(Lq*sqrt(t(i)))  cos(Lq*sqrt(t(i)))];
%                 Mtransport=Md*Mq;
%                 M11(i)=Mtransport(1,1);
%                 M12(i)=Mtransport(1,2);
%         end
% 
% 
%         for j = 1:nbtests
% 
%         % calcul de l'emittance avec moyenne prealable de chaque acquisition sur les nbiter
%         %iterations (5 dans le menu) (distribution normale dans cette simulation)
%         for i=1:length(t)
%             s=se(i)+sigma*se(i)*randn(nbiter,1);
%             s2=s.*s;
%             meanst2(i)=mean(s2);
%         end
% 
%         % *********** methode Belbeoch **********************
%         A=M11.*M11;
%         B=M12.*M12;
%         F=2*M11.*M12 ;
% 
%         Z=[A'*A A'*B A'*F ; B'*A B'*B B'*F ; ...
%                    F'*A F'*B F'*F];
%         H=[A'*meanst2' ; B'*meanst2' ; F'*meanst2'];
% 
%         citer=Z\H;
%         eps(j)=sqrt(citer(1)*citer(2)-citer(3)*citer(3));
%         nbcomplexes = 1-isreal(eps(j)) + nbcomplexes;
%         if isequal(isreal(eps(j)),0)
%             epsilon(j) = 0;
%         else 
%             epsilon(j) = eps(j);
%         end
% 
% 
%         % emittanceH=num2str(eps) ;   
%         % set(handles.emitH_edit18,'String',emittanceH);
% 
% 
%         end
% 
%         moyenne = mean(epsilon)*length(eps)/(length(eps)-nbcomplexes);
%         for j=1:length(eps)
%             if isequal(epsilon(j),0)
%                 sepsilon(j) = moyenne;
%             else
%                 sepsilon(j) = epsilon(j);
%             end
%         end
%         standard = std(sepsilon)*sqrt(length(eps)/(length(eps)-nbcomplexes));
%         disp(['nbcomplexes=' sprintf('%0.5g',nbcomplexes) '  sigma tailles=' sprintf('%0.5g',sigma) ...
%                     '  nbiter=' sprintf('%0.5g',nbiter) ...
%                 '  nbtests=' sprintf('%0.5g',nbtests) '  meaneps=' ...
%                 sprintf('%0.5g',moyenne) '  stdeps=' sprintf('%0.5g',standard)] )
%         disp(' ')
% 
%         %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  
% 


% --- Executes during object creation, after setting all properties.
function nbacqu_edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbacqu_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function nbacqu_edit13_Callback(hObject, eventdata, handles)
% hObject    handle to nbacqu_edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbacqu_edit13 as text
%        str2double(get(hObject,'String')) returns contents of nbacqu_edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function emitH_edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emitH_edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% emittance horizonale



function emitH_edit18_Callback(hObject, eventdata, handles)
% hObject    handle to emitH_edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emitH_edit18 as text
%        str2double(get(hObject,'String')) returns contents of emitH_edit18 as a double


% --- Executes during object creation, after setting all properties.
function emitV_edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emitV_edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function emitV_edit19_Callback(hObject, eventdata, handles)
% hObject    handle to emitV_edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emitV_edit19 as text
%        str2double(get(hObject,'String')) returns contents of emitV_edit19 as a double


% --- Executes on button press in ellipseH_pushbutton13.
function ellipseH_pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to ellipseH_pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ellipseH_v16(handles)


% --- Executes when figure1 window is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes on button press in radiobutton7_bh_l1.
function Lenthaute_radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7_bh_l1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Lenthaute_radiobutton7
autre = [handles.tata_radiobutton10];
mutual_exclude(autre)




% --- Executes on button press in radiobutton10_bh_l2.
function tata_radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10_bh_l2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10_bh_l2
autre = [handles.Lenthaute_radiobutton7];
mutual_exclude(autre)






% --- Executes on button press in restaurer_pushbutton15.
function restaurer_pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to restaurer_pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Restore the data and list entry for the last deleted value        
ResultsStr = get(handles.listbox1,'String');
handles.Sauver=getappdata(handles.figure1,'Sauver');
handles.Ecran=getappdata(handles.figure1,'Ecran');
handles.ResultsData=getappdata(handles.figure1,'ResultsData');

LastValue=length(handles.Sauver) ;
toto=handles.Sauver(LastValue);
titi=handles.Ecran(LastValue);
Numero=toto.RunNumber;
Nombre=length(handles.ResultsData);
reussite=0;

if Numero>handles.ResultsData(Nombre).RunNumber
    handles.ResultsData=[handles.ResultsData toto];
    ResultsStr = [ResultsStr ; titi];
else 
    i=0;      
    while isequal(reussite,0) & (i<(length(handles.ResultsData)))
            i=  i+1  ;
            if Numero>handles.ResultsData(Nombre-i+1).RunNumber
                handles.ResultsData=[handles.ResultsData(1:Nombre-i+1) toto handles.ResultsData(Nombre-i+2:end)];
                ResultsStr = [ResultsStr(1:Nombre-i+1) ; titi;ResultsStr(Nombre-i+2:end) ];
                reussite=reussite+1;
            end
        
    end
    if isequal(reussite,0)  
        handles.ResultsData=[toto handles.ResultsData];
        ResultsStr = [titi ; ResultsStr];
    end
    
end

% Build the new results list string for the listbox
set(handles.listbox1,'String',ResultsStr);

% Store the new ResultsData
handles.Sauver(LastValue)=[];
handles.Ecran(LastValue)=[];
setappdata(handles.figure1,'Sauver',handles.Sauver)
setappdata(handles.figure1,'Ecran',handles.Ecran)
setappdata(handles.figure1,'ResultsData',handles.ResultsData);

% affiche le nombre de data utilis�s dans le calcul d'�mittance
set(handles.nbacqu_edit13,'String', num2str(size(ResultsStr,1)));


% d�sactiver le bouton restaurer si la liste est vide
if isequal(LastValue,1)
	set([handles.restaurer_pushbutton15],'Enable','off')	
end
guidata(hObject, handles);


% --- Executes on button press in mesuressfaisceau_pushbutton16.
function mesuressfaisceau_pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to mesuressfaisceau_pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% sauvegarde sur disque de l'ensemble des acquisitions avec et sans
% faisceau, proposee lorsque aucune acquisition avec faiseau n'est encore
% faite
entree=    getappdata(handles.figure1,'ResultsData');
directory_principale = getappdata(handles.figure1,'directory_principale');
if isequal(length(entree),0)
    
       %ouvrir le dossier pour l'enregistrement des profils
       prompt={'entrer un nom de r�pertoire'};
       name='SAUVEGARDE SUR DISQUE';
       numlines=1;
       defaultanswer={strcat(datestr(clock,29),'_1')};
       options.Resize='on';
       options.WindowStyle='normal';
       options.Interpreter='tex';
       
       % on ne propose la boite de dialogue qu'une seule fois
       % ulterieurement, si on souhaite changer de directory de sauvegarde,
       % cela se fait interactivement dans le '   ' 
       val=getappdata(handles.figure1,'init_sauvegarde');
       directory_principale=getappdata(handles.figure1,'directory_principale');
       
       while isequal(val,0)
            directory=inputdlg(prompt,name,numlines,defaultanswer,options);
            % chemin=strcat('/home/PM/tordeux/matlab_test/',directory{:});
            %%directory_sauvegarde=strcat(directory_principale,directory{:});
            directory_sauvegarde=strcat(directory_principale,directory{:},'/');
            setappdata(handles.figure1,'directory_sauvegarde',directory_sauvegarde);
            
            
            % cas ou un nom de directory a �t� rentr�
            if ~isequal(directory,{})
                % cas ou la directory n'existe pas
                %%if ~isdir(strcat('/home/PM/tordeux/matlab_test/',directory{:}))
                if ~isdir(directory_sauvegarde)   
%                     mkdir(chemin)
%                     cd(chemin);
                    mkdir(directory_sauvegarde)
                    cd(directory_sauvegarde);
                    
                    setappdata(handles.figure1,'init_sauvegarde',1);
                    val=getappdata(handles.figure1,'init_sauvegarde');
                    set(handles.directory_sauvegarde_edit28,'String',directory_sauvegarde);
                    
                % cas ou la directory existe deja
                else    
                    button = questdlg('ce dossier existe ! voulez-vous continuer?','ATTENTION','oui','non','non') ; 
                    if isequal(button,'oui')
                        
%                         cd(chemin);
                        cd(directory_sauvegarde);  
                        
                        setappdata(handles.figure1,'init_sauvegarde',1);
                        val=getappdata(handles.figure1,'init_sauvegarde');
                        set(handles.directory_sauvegarde_edit28,'String',directory_sauvegarde);
          
                    else
                        % retour � la case d�part 
                        
                    end
                end     
            
            % cas ou on a refus� de rentrer un nom de directory
            else
                
                errordlg('vous n''avez pas s�lectionn� de directory de sauvegarde !','Attention');
                
                setappdata(handles.figure1,'init_sauvegarde',1);
                val=getappdata(handles.figure1,'init_sauvegarde');
            end
            
       end

end


showsansfgui_15(handles); 


%__________________________________________________________________________
% --- Executes on button press in Gmax_pushbutton26.
function Gmin_pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to Gmax_pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% alias
device_name = getappdata(handles.figure1,'device_name');

% recuperer les valeurs de position des lentilles pour ce grandissement
posl1Gmin=getappdata(handles.figure1,'posl1Gmin');
posl2Gmin=getappdata(handles.figure1,'posl2Gmin');

set(handles.Lenthaute_radiobutton7,'Value',0);
set(handles.tata_radiobutton10,'Value',0);

% eteindre un voyant grandissement �ventuellement allum�
set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);

dev=device_name.lentille_haute


errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

if (tango_error == -1)
      %- handle error
      tango_print_error_stack;
      return;
      errordlg('erreur tango !','Erreur');

else
    % cas ou l'axe n'est pas en butee backward (en haut)
    % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens -
    % errorstatus=4  limitswitch backward
    
     if ~isequal(errorstatus,22)&~isequal(errorstatus,4)

        % si on est en but�e basse forward on �teind le voyant
        if isequal(errorstatus,21)|isequal(errorstatus,3)
             set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
        end 
         
        % aller en butee haute
        tango_command_inout(dev,'AxisBackward');
        
        % on attent que l'axe se mette en mouvement
        %temporisation_mvt_axis(dev);
        if (temporisation_mvt_axis(dev) == -1)
         % abort 
        end
        
        % attendre la fin de la commande
        while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
            set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
            pause(0.2);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);
            pause(0.2);
            % on affiche la position de la lentille
            pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%             set(handles.Lenthaute_radiobutton7,'BackgroundColor','green')
%             pause(0.5);
        end
        % on affiche la position de la lentille
        pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
        %set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
    end

    % % si le moteur n'est pas en butee ce n'est pas normal..
    % if ~isequal(tango_command_inout(dev,'AxisGetMotionStatus'),-1)
    %     % probleme !
    %     errordlg('bizzare, vous n''etes pas en but�e...?!','Erreur');

    % indiquer la butee haute sur moteur 1 (lentille haute)
    set(handles.LHBH_edit25,'BackgroundColor','red');
    
    % definir la position 0
    tango_command_inout(dev,'AxisDefinePosition',0);
    
    % avancer du nombre de pas exact correspondant au grandissement : 0
    
    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
        set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
        pause(0.2);
        set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);
        pause(0.2);
        % on affiche la position de la lentille
        pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%         set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
%         pause(0.5);
    end
    
    % on affiche la position de la lentille
    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
    
    %set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
    

end   
 
dev=device_name.lentille_basse

errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

if (tango_error == -1)
      %- handle error
      tango_print_error_stack;
      return;
      errordlg('erreur tango !','Erreur');

else
    % cas ou l'axe n'est pas en butee backward (en haut)
    % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens -
    % errorstatus=4  limitswitch backward
    
    if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
    
        % si on est en but�e basse forward on �teind le voyant
        if isequal(errorstatus,21)|isequal(errorstatus,3)
             set(handles.LBBB_edit26,'BackgroundColor',[0.702 0.702 0.702]);
        end 
        
        % aller en butee haute backward
        tango_command_inout(dev,'AxisBackward');
        
        % on attent que l'axe se mette en mouvement
        %temporisation_mvt_axis(dev);
        if (temporisation_mvt_axis(dev) == -1)
         % abort 
        end
        
        % attendre la fin de la commande
        while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
            set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
            pause(0.2);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);
            pause(0.2);
            % on affiche la position de la lentille
            pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
            set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
%             pause(0.2);
%             set(handles.tata_radiobutton10,'BackgroundColor','green');
%             pause(0.2);
%             set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
        end
        % on affiche la position de la lentille
        pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
        set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
        % set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
    end
    
    %     % si le moteur n'est pas en butee ce n'est pas normal..
    %     if ~isequal(tango_command_inout(dev,'AxisGetMotionStatus'),-1)
    %         % probleme !
    %         errordlg('bizzare, vous n''etes pas en but�e...?!','Erreur');
    %     else

    % definir la position 0
    tango_command_inout(dev,'AxisDefinePosition',0);
    % on affiche la position de la lentille
    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
    
    % eteindre le voyant rouge butee backward s'il est allum�
    set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
    
    % avancer du nombre de pas exact correspondant au grandissement 
    tango_command_inout(dev,'AxisGoToPosition',posl2Gmin);
     
    % on attent que l'axe se mette en mouvement
    %temporisation_mvt_axis(dev);
    if (temporisation_mvt_axis(dev) == -1)
         % abort 
    end
        
    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
        set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
        pause(0.2);
        set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);
        pause(0.2);
        % on affiche la position de la lentille
        pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
%         pause(0.2);
%         set(handles.tata_radiobutton10,'BackgroundColor','green');
%         pause(0.2);
%         set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
    end
 
    % on affiche la position de la lentille
    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
        % �teindre le vert
        %set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
        

end   

% allumer le voyant rouge Gmin
pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition')
pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition')
test1 = test_position(pos1.value(1),posl1Gmin,5);
test2 = test_position(pos2.value(1),posl2Gmin,5);
if test1 == 1&test2==1
    set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
end

%__________________________________________________________________________
% --- Executes on button press in Gmoy_pushbutton27.
function Gmoy_pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to Gmoy_pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% recuperer les valeurs de position des lentilles pour ce grandissement
posl1Gmoy=getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy=getappdata(handles.figure1,'posl2Gmoy');
device_name = getappdata(handles.figure1,'device_name');

set(handles.Lenthaute_radiobutton7,'Value',0);
set(handles.tata_radiobutton10,'Value',0);

% eteindre un voyant grandissement �ventuellement allum�
set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);

dev=device_name.lentille_haute

errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

if (tango_error == -1)
      %- handle error
      tango_print_error_stack;
      return;
      errordlg('erreur tango !','Erreur');

else
    % cas ou l'axe n'est pas en butee backward (en haut)
    % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens -
    % errorstatus=4  limitswitch backward
    
     if ~isequal(errorstatus,22)&~isequal(errorstatus,4)

        % si on est en but�e basse forward on �teind le voyant
        if isequal(errorstatus,21)|isequal(errorstatus,3)
             set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
        end 
         
        % aller en butee haute
        tango_command_inout(dev,'AxisBackward');
        
        % on attent que l'axe se mette en mouvement
        if (temporisation_mvt_axis(dev) == -1)
         % abort 
        end
        
        % attendre la fin de la commande
        while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
            set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            pause(0.2);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            pause(0.2);
            % on affiche la position de la lentille
            pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%             set(handles.Lenthaute_radiobutton7,'BackgroundColor','green')
%             pause(0.5);
        end
        % on affiche la position de la lentille
        pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%             set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
    end

    % % si le moteur n'est pas en butee ce n'est pas normal..
    % if ~isequal(tango_command_inout(dev,'AxisGetMotionStatus'),-1)
    %     % probleme !
    %     errordlg('bizzare, vous n''etes pas en but�e...?!','Erreur');

    % indiquer la butee haute sur moteur 1 (lentille haute)
    set(handles.LHBH_edit25,'BackgroundColor','red');
    
    % definir la position 0
    tango_command_inout(dev,'AxisDefinePosition',0);
    fonction_error
    % on affiche la position de la lentille
    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
    
    status0 =  tango_command_inout(dev,'AxisGetMotionStatus')
    % avancer du nombre de pas exact correspondant au grandissement moyen : 
    tango_command_inout(dev,'AxisGoToPosition',posl1Gmoy);
    fonction_error
    % eteindre le voyant but�e haute
    set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
   
    % on attent que l'axe se mette en mouvement
    %temporisation_mvt_axis(dev);
    if (temporisation_mvt_axis(dev) == -1)
        error =  tango_command_inout(dev,'AxisGetMotionStatus')
        disp('lentille haute')
        % abort 
    end
    
    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
        set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
        pause(0.2);
        set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
        pause(0.2);
        % on affiche la position de la lentille
        pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%         pause(0.2);
%         set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
%         pause(0.2);
%         set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
    end
    
    % on affiche la position de la lentille
    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
    set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
    
end   
 
dev=device_name.lentille_basse

errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

if (tango_error == -1)
      %- handle error
      tango_print_error_stack;
      return;
      errordlg('erreur tango !','Erreur');

else
    % cas ou l'axe n'est pas en butee backward (en haut)
    % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens -
    % errorstatus=4  limitswitch backward
    
    if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
    
        % si on est en but�e basse forward on �teind le voyant
        if isequal(errorstatus,21)|isequal(errorstatus,3)
             set(handles.LBBB_edit26,'BackgroundColor',[0.702 0.702 0.702]);
        end 
        
        % aller en butee haute backward
        tango_command_inout(dev,'AxisBackward');
        
        % on attent que l'axe se mette en mouvement
        %temporisation_mvt_axis(dev);
        if (temporisation_mvt_axis(dev) == -1)
         % abort 
         disp('moy : abort')
        end

        % au cas o� la but�e haute est allum�e on l'�teint
        set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
        
        while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1) 
            set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            pause(0.2);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            pause(0.2);
            % on affiche la position de la lentille
            %pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
            %set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
            set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
%             pause(0.2);
%             set(handles.tata_radiobutton10,'BackgroundColor','green');
%             pause(0.2);
%             set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
        end 
        
        % set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
    end
    
    %     % si le moteur n'est pas en butee ce n'est pas normal..
    %     if ~isequal(tango_command_inout(dev,'AxisGetMotionStatus'),-1)
    %         % probleme !
    %         errordlg('bizzare, vous n''etes pas en but�e...?!','Erreur');
    %     else

    % definir la position 0
    tango_command_inout(dev,'AxisDefinePosition',0);
    fonction_error;
    
    % on affiche la position de la lentille
    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));

    % eteindre le voyant rouge butee backward s'il est allum�
    set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);

    % avancer du nombre de pas exact correspondant au grandissement
    tango_command_inout(dev,'AxisGoToPosition',posl2Gmoy);
    
    % on attent que l'axe se mette en mouvement
    if (temporisation_mvt_axis(dev) == -1)
        error =  tango_command_inout(dev,'AxisGetMotionStatus')
        % abort 
    end

    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
        set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
        pause(0.2);
        set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
        pause(0.2);
        % on affiche la position de la lentille
        pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
    end
    
    % on affiche la position de la lentille
    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
%         % �teindre le vert
%         set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
    

end   

% allumer le voyant rouge Gmoy
pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition')
pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition')
test1 = test_position(pos1.value(1),posl1Gmoy,5);
test2 = test_position(pos2.value(1),posl2Gmoy,5);
if test1 == 1&test2==1
    set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
end

%__________________________________________________________________________
% --- Executes on button press in Gmin_pushbutton28.
function Gmax_pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to Gmin_pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% recuperer les valeurs de positions des lentilles pour ce grandissement
posl1Gmax=getappdata(handles.figure1,'posl1Gmax');
posl2Gmax=getappdata(handles.figure1,'posl2Gmax');
device_name = getappdata(handles.figure1,'device_name');

set(handles.Lenthaute_radiobutton7,'Value',0);
set(handles.tata_radiobutton10,'Value',0);

% eteindre un voyant grandissement �ventuellement allum�

set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]);



dev=device_name.lentille_haute

errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

if (tango_error == -1)
      %- handle error
      tango_print_error_stack;
      return;
      errordlg('erreur tango !','Erreur');

else
    % cas ou l'axe n'est pas en butee backward (en haut)
    % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens -
    % errorstatus=4  limitswitch backward
    
     if ~isequal(errorstatus,22)&~isequal(errorstatus,4)

        % si on est en but�e basse forward on �teind le voyant
        if isequal(errorstatus,21)|isequal(errorstatus,3)
             set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
        end 
         
        % aller en butee haute
        tango_command_inout(dev,'AxisBackward');
        
        % on attent que l'axe se mette en mouvement
        %temporisation_mvt_axis(dev);
        if (temporisation_mvt_axis(dev) == -1)
         % abort 
        end
        
        % attendre la fin de la commande
        while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
            set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            pause(0.2);
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            pause(0.2);
            % on affiche la position de la lentille
            pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
            set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%             pause(0.2);
%             set(handles.Lenthaute_radiobutton7,'BackgroundColor','green')
%             pause(0.2);
%             set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702])
        end
        % on affiche la position de la lentille
        pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
            %set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
    end

    % % si le moteur n'est pas en butee ce n'est pas normal..
    % if ~isequal(tango_command_inout(dev,'AxisGetMotionStatus'),-1)
    %     % probleme !
    %     errordlg('bizzare, vous n''etes pas en but�e...?!','Erreur');

    % indiquer la butee haute sur moteur 1 (lentille haute)
    set(handles.LHBH_edit25,'BackgroundColor','red');
    
    % definir la position 0
    tango_command_inout(dev,'AxisDefinePosition',0);
    % on affiche la position de la lentille
    pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
    
    % avancer du nombre de pas exact correspondant au grandissement max :
    tango_command_inout(dev,'AxisGoToPosition',posl1Gmax);
    % eteindre le voyant but�e haute
    set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
         
    % on attent que l'axe se mette en mouvement
    %temporisation_mvt_axis(dev); 
    if (temporisation_mvt_axis(dev) == -1)
         % abort 
    end
    
    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
        set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
        pause(0.2);
        set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
        pause(0.2);
        % on affiche la position de la lentille
        pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%         pause(0.2);
%         set(handles.Lenthaute_radiobutton7,'BackgroundColor','green')
%         pause(0.2);
%         set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702])
    end
    % on affiche la position de la lentille
    pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
        %set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
    
    
end   
 
dev=device_name.lentille_basse

errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

if (tango_error == -1)
      %- handle error
      tango_print_error_stack;
      return;
      errordlg('erreur tango !','Erreur');

else
    % cas ou l'axe n'est pas en butee backward (en haut)
    % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens -
    % errorstatus=4  limitswitch backward
    
    if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
    
        % si on est en but�e basse forward on �teind le voyant
        if isequal(errorstatus,21)|isequal(errorstatus,3)
             set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
        end 
        
        % aller en butee haute backward
        tango_command_inout(dev,'AxisBackward');
        
        % on attent que l'axe se mette en mouvement
        %temporisation_mvt_axis(dev); 
        if (temporisation_mvt_axis(dev) == -1)
         % abort 
        end
            
        % attendre la fin de la commande
            % set(handles.tata_radiobutton10,'BackgroundColor','green');
        while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
            set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            pause(0.2);
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            pause(0.2);
            % on affiche la position de la lentille
            pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
            set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
%             pause(0.2);
%             set(handles.tata_radiobutton10,'BackgroundColor','green');
%             pause(0.2);
%             set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
        end
        % on affiche la position de la lentille
        pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
            %set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
            % set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
    end
    
    %     % si le moteur n'est pas en butee ce n'est pas normal..
    %     if ~isequal(tango_command_inout(dev,'AxisGetMotionStatus'),-1)
    %         % probleme !
    %         errordlg('bizzare, vous n''etes pas en but�e...?!','Erreur');
    %     else

    % definir la position 0
    tango_command_inout(dev,'AxisDefinePosition',0);
    % on affiche la position de la lentille
    pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
    
    % eteindre le voyant rouge butee backward s'il est allum�
    set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
    
    % avancer du nombre de pas exact correspondant au grandissement MAX ...
    tango_command_inout(dev,'AxisGoToPosition',posl2Gmax);
    
    % on attent que l'axe se mette en mouvement
    %temporisation_mvt_axis(dev); 
    if (temporisation_mvt_axis(dev) == -1)
         % abort 
    end
            
    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
        set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
        pause(0.2);
        set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
        pause(0.2);
        % on affiche la position de la lentille
        pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
%         pause(0.2);
%         set(handles.tata_radiobutton10,'BackgroundColor','green');
%         pause(0.2);
%         set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
    end
    % on affiche la position de la lentille
    pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
    %     % �teindre le vert
    %     set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);

end   

% allumer le voyant Gmax en rouge
pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition')
pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition')
test1 = test_position(pos1.value(1),posl1Gmax,5);
test2 = test_position(pos2.value(1),posl2Gmax,5);
if test1 == 1&test2==1
    set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
end

%__________________________________________________________________________
% --- Executes on button press in ppp_pushbutton18.
function ppp_pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to ppp_pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logdev1=get(handles.Lenthaute_radiobutton7,'Value');
logdev2=get(handles.tata_radiobutton10,'Value');
posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
device_name = getappdata(handles.figure1,'device_name');

if isequal(logdev1,0)&isequal(logdev2,0)
    errordlg('selectionnez une lentille','ATTENTION');
else
    if isequal(logdev1,1)
        dev=device_name.lentille_haute;
        nbpas=5000;
    else
        dev=device_name.lentille_basse;
        nbpas=10000;
    end
    
    errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

    else
        % cas ou l'axe n'est pas en butee forward (en bas)
        % errorstatus=21 d�c�l�ration ou arr�t d� � un limit switch sens +
        % errorstatus=3  limitswitch forward

        if ~isequal(errorstatus,21)&~isequal(errorstatus,3)
 
            % si on �tait en but�e backward, on �teind le voyant
            if isequal(errorstatus,22)|isequal(errorstatus,4)
                if isequal(logdev1,1)
                    set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
                else
                    set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
                end
            end
            
            % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
            
            % on descend vers la but�e forward
            tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
        
            % temporisation : 
            %temporisation_mvt_axis(dev);
            if (temporisation_mvt_axis(dev) == -1)
                % abort 
            end
 
            while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                
                if isequal(logdev1,1)
                    
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                    pause(0.2);
                    drawnow;
                else
                    
                    set(handles.tata_radiobutton10,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                    pause(0.2);
                    drawnow;
                    
                end
                %pause(0.5);
            end
            
            pause(0.5);
            % on �teind le vert � la fin du mouvement
            % on �crit une derni�re fois la position de la lentille
            if isequal(logdev1,1)
                set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                set(handles.pos1_edit29,'String',num2str(pos1.value(1)));

            else
                set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
            end
            
            % si on est arriv� en but�e forward on allume le voyant
            errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor','red');
                else
                    set(handles.LBBB_edit27,'BackgroundColor','red');
                end 
            end
            
            % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
      
            pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
            if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
            end
            
        else 
            errordlg('d�j� en butee ou erreur','ATTENTION');
        end
    end
end

% 
% 
% logdev1=get(handles.Lenthaute_radiobutton7,'Value');
% logdev2=get(handles.tata_radiobutton10,'Value');
% posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
% posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
% posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
% posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
% posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
% posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
% 
% if isequal(logdev1,0)&isequal(logdev2,0)
%     errordlg('selectionnez une lentille','ATTENTION');
% else
%     if isequal(logdev1,1)
%         dev=device_name.lentille_haute;
%         nbpas=5000;
%     else
%         dev=device_name.lentille_basse;
%         nbpas=10000;
%     end
%     
%     errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
% 
%     if (tango_error == -1)
%         %- handle error
%         tango_print_error_stack;
%         return;
%         errordlg('erreur tango !','Erreur');
% 
%     else
%         % cas ou l'axe n'est pas en butee forward (en bas)
%         % errorstatus=21 d�c�l�ration ou arr�t d� � un limit switch sens +
%         % errorstatus=3  limitswitch forward
% 
%         if ~isequal(errorstatus,21)&~isequal(errorstatus,3)
%  
%             % si on �tait en but�e backward, on �teind le voyant
%             if isequal(errorstatus,22)|isequal(errorstatus,4)
%                 if isequal(logdev1,1)
%                     set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
%                 else
%                     set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
%                 end
%             end
%             
%             % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
%             set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
%             set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
%             set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
%             
%             
%             % on descend vers la but�e forward
%             tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
%         
%             % temporisation : 
%             pause(0.2);
%             while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
%                 if isequal(logdev1,1)
%                     set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
%                 else
%                     set(handles.tata_radiobutton10,'BackgroundColor','green');
%                 end
%                 pause(0.5);
%             end
%             
%             % on �teind le vert � la fin du mouvement
%             if isequal(logdev1,1)
%                 set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
%             else
%                 set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
%             end
%             
%             % si on est arriv� en but�e forward on allume le voyant
%             errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
%             if isequal(errorstatus,21)|isequal(errorstatus,3)
%                 if isequal(logdev1,1)
%                     set(handles.LHBB_edit24,'BackgroundColor','red');
%                 else
%                     set(handles.LBBB_edit27,'BackgroundColor','red');
%                 end 
%             end
%             
%             % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
%       
%             pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%             pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
%             if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
%                 set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
%             elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
%                 set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
%             elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
%                 set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
%             end
%             
%         else 
%             errordlg('d�j� en butee ou erreur','ATTENTION');
%         end
%     end
% end
% 



% --- Executes on button press in pp_pushbutton19.
function pp_pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pp_pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logdev1=get(handles.Lenthaute_radiobutton7,'Value');
logdev2=get(handles.tata_radiobutton10,'Value');
posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
device_name = getappdata(handles.figure1,'device_name');

if isequal(logdev1,0)&isequal(logdev2,0)
    errordlg('selectionnez une lentille','ATTENTION');
else
    if isequal(logdev1,1)
        dev=device_name.lentille_haute;
        nbpas=500;
    else
        dev=device_name.lentille_basse;
        nbpas=1000;
    end
    
    errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

    else
        % cas ou l'axe n'est pas en butee forward (en bas)
        % errorstatus=21 d�c�l�ration ou arr�t d� � un limit switch sens +
        % errorstatus=3  limitswitch forward

        if ~isequal(errorstatus,21)&~isequal(errorstatus,3)
 
            % si on �tait en but�e backward, on �teind le voyant
            if isequal(errorstatus,22)|isequal(errorstatus,4)
                if isequal(logdev1,1)
                    set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
                else
                    set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
                end
            end
            
            % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
            
            % on descend vers la but�e forward
            tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
        
            % temporisation : 
            %temporisation_mvt_axis(dev);
            if (temporisation_mvt_axis(dev) == -1)
                % abort 
            end
 
            while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                
                if isequal(logdev1,1)
                    
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                    pause(0.2);
                    drawnow;
                else
                    
                    set(handles.tata_radiobutton10,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                    pause(0.2);
                    drawnow;
                    
                end
                %pause(0.5);
            end
            
            pause(0.5);
            % on �teind le vert � la fin du mouvement
            % on �crit une derni�re fois la position de la lentille
            if isequal(logdev1,1)
                set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                set(handles.pos1_edit29,'String',num2str(pos1.value(1)));

            else
                set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
            end
            
            % si on est arriv� en but�e forward on allume le voyant
            errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor','red');
                else
                    set(handles.LBBB_edit27,'BackgroundColor','red');
                end 
            end
            
            % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
      
            pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
            if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
            end
            
        else 
            errordlg('d�j� en butee ou erreur','ATTENTION');
        end
    end
end




% --- Executes on button press in p_pushbutton20.
function p_pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to p_pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logdev1=get(handles.Lenthaute_radiobutton7,'Value');
logdev2=get(handles.tata_radiobutton10,'Value');
posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
device_name = getappdata(handles.figure1,'device_name');

if isequal(logdev1,0)&isequal(logdev2,0)
    errordlg('selectionnez une lentille','ATTENTION');
else
    if isequal(logdev1,1)
        dev=device_name.lentille_haute;
        nbpas=50;
    else
        dev=device_name.lentille_basse;
        nbpas=100;
    end
    
    errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

    else
        % cas ou l'axe n'est pas en butee forward (en bas)
        % errorstatus=21 d�c�l�ration ou arr�t d� � un limit switch sens +
        % errorstatus=3  limitswitch forward

        if ~isequal(errorstatus,21)&~isequal(errorstatus,3)
 
            % si on �tait en but�e backward, on �teind le voyant
            if isequal(errorstatus,22)|isequal(errorstatus,4)
                if isequal(logdev1,1)
                    set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
                else
                    set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
                end
            end
            
            % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
            
            
            % on descend vers la but�e forward
            tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
        
            % temporisation : 
            %temporisation_mvt_axis(dev);
            if (temporisation_mvt_axis(dev) == -1)
                % abort 
            end
            
            %pause(0.2);
            while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                if isequal(logdev1,1)
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                else
                    set(handles.tata_radiobutton10,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                end
                
            end
            
            pause(0.5);
            % on �teind le vert � la fin du mouvement
            % on �crit une derni�re fois la position de la lentille
            
            if isequal(logdev1,1)
                set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                % on affiche la position de la lentille
                pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                
            else
                set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                
            end
            
            % si on est arriv� en but�e forward on allume le voyant
            
            errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor','red');
                    
                else
                    set(handles.LBBB_edit27,'BackgroundColor','red');

                end 
            end
            
            % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
      
            pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
            if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
            end
            
        else 
            errordlg('d�j� en butee ou erreur','ATTENTION');
        end
    end
end

% --- Executes on button press in m_pushbutton23.
function mmm_pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to m_pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logdev1=get(handles.Lenthaute_radiobutton7,'Value');
logdev2=get(handles.tata_radiobutton10,'Value');
posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
device_name = getappdata(handles.figure1,'device_name');

if isequal(logdev1,0)&isequal(logdev2,0)
    errordlg('selectionnez une lentille','ATTENTION');
else
    if isequal(logdev1,1)
        dev=device_name.lentille_haute;
        nbpas=-5000;
    else
        dev=device_name.lentille_basse;
        nbpas=-10000;
    end
    
    errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

    else
        % cas ou l'axe n'est pas en butee backward (en haut)
        % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens +
        % errorstatus=4  limitswitch forward

        if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
 
            % si on �tait en but�e forward, on �teind le voyant
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
                else
                    set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
                end
            end
            
             % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
            
            
            % on monte vers la but�e backward
            tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
            if (tango_error == -1)
                %- handle error
                tango_print_error_stack;
                return;
                errordlg('erreur tango !','Erreur');

            else
            
                % temporisation : 
                %temporisation_mvt_axis(dev);
                if (temporisation_mvt_axis(dev) == -1)
                    % abort 
                end

                if isequal(logdev1,1)
                    
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                        % on affiche la position de la lentille
                        pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                        pause(0.2);
                        drawnow;
                    end
                    
                else
                    
                    set(handles.tata_radiobutton10,'BackgroundColor','green'); 
                    while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                        % on affiche la position de la lentille
                        pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                        pause(0.2);
                        drawnow;
                    end
                    
                end
%                 while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
%                     disp('dans la boucle tant que mvt')
%                     if isequal(logdev1,1)
%                         disp('je dois afficher le vert')
%                         pause(0.1);
%                         set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
%                         % on affiche la position de la lentille
%                         pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%                         %pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
%                         set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%                         %set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
%                     else
%                         set(handles.tata_radiobutton10,'BackgroundColor','green');
%                         % on affiche la position de la lentille
%                         %pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%                         pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
%                         %set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%                         set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
% 
%                     end
%                 end

                pause(0.5);
                % on �teind le vert � la fin du mouvement
                % on �crit une derni�re fois la position de la lentille

                if isequal(logdev1,1)
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                    %pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                    %set(handles.pos2_edit30,'String',num2str(pos2.value(1)
                    %));

                else
                    set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                    %pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                    %set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));

                end

                % si on est arriv� en but�e backward on allume le voyant
                errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
                if isequal(errorstatus,22)|isequal(errorstatus,4)
                    if isequal(logdev1,1)
                        set(handles.LHBH_edit25,'BackgroundColor','red');
                    else
                        set(handles.LBBH_edit26,'BackgroundColor','red');
                    end 
                end

                % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci

                pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                    set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
                elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                    set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
                elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                    set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
                end
            end
        else 
            errordlg('d�j� en butee ou erreur','ATTENTION');
        end
    end
end




%     % --- Executes on button press in mmm_pushbutton21.
%     function mmm_pushbutton21_Callback(hObject, eventdata, handles)
%     % hObject    handle to mmm_pushbutton21 (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     % handles    structure with handles and user data (see GUIDATA)
% 
%     logdev1=get(handles.Lenthaute_radiobutton7,'Value');
%     logdev2=get(handles.tata_radiobutton10,'Value');
%     posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
%     posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
%     posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
%     posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
%     posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
%     posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
% 
%     if isequal(logdev1,0)&isequal(logdev2,0)
%         errordlg('selectionnez une lentille','ATTENTION');
%     else
%         if isequal(logdev1,1)
%             dev=device_name.lentille_haute;
%             nbpas=-5000;
%         else
%             dev=device_name.lentille_basse;
%             nbpas=-10000;
%         end
% 
%         errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
% 
%         if (tango_error == -1)
%             %- handle error
%             tango_print_error_stack;
%             return;
%             errordlg('erreur tango !','Erreur');
% 
%         else
%             % cas ou l'axe n'est pas en butee backward (en haut)
%             % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens +
%             % errorstatus=4  limitswitch forward
% 
%             if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
% 
%                 % si on �tait en but�e forward, on �teind le voyant
%                 if isequal(errorstatus,21)|isequal(errorstatus,3)
%                     if isequal(logdev1,1)
%                         set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
%                     else
%                         set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
%                     end
%                 end
% 
%                 % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
%                 set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
%                 set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
%                 set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
% 
%                 % on monte vers la but�e backward
%                 tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
% 
%                 % temporisation : 
%                 pause(0.2);
%                 while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
%                     if isequal(logdev1,1)
%                         set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
%                     else
%                         set(handles.tata_radiobutton10,'BackgroundColor','green');
%                     end
%                     pause(0.5);
%                 end
% 
%                 % on �teind le vert � la fin du mouvement
%                 if isequal(logdev1,1)
%                     set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
%                 else
%                     set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
%                 end
% 
%                 % si on est arriv� en but�e backward on allume le voyant
%                 errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
%                 if isequal(errorstatus,22)|isequal(errorstatus,4)
%                     if isequal(logdev1,1)
%                         set(handles.LHBH_edit25,'BackgroundColor','red');
%                     else
%                         set(handles.LBBH_edit26,'BackgroundColor','red');
%                     end 
%                 end
% 
%                 % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
% 
%                 pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%                 pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
%                 if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
%                     set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
%                 elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
%                     set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
%                 elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
%                     set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
%                 end
% 
% 
%             else 
%                 errordlg('d�j� en butee ou erreur','ATTENTION');
%             end
%         end
%     end

% --- Executes on button press in m_pushbutton23.
function mm_pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to m_pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logdev1=get(handles.Lenthaute_radiobutton7,'Value');
logdev2=get(handles.tata_radiobutton10,'Value');
posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
device_name = getappdata(handles.figure1,'device_name');

if isequal(logdev1,0)&isequal(logdev2,0)
    errordlg('selectionnez une lentille','ATTENTION');
else
    if isequal(logdev1,1)
        dev=device_name.lentille_haute;
        nbpas=-500;
    else
        dev=device_name.lentille_basse;
        nbpas=-1000;
    end
    
    errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

    else
        % cas ou l'axe n'est pas en butee backward (en haut)
        % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens +
        % errorstatus=4  limitswitch forward

        if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
 
            % si on �tait en but�e forward, on �teind le voyant
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
                else
                    set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
                end
            end
            
             % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
            
            
            % on monte vers la but�e backward
            tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
            if (tango_error == -1)
                %- handle error
                tango_print_error_stack;
                return;
                errordlg('erreur tango !','Erreur');

            else
            
                % temporisation : 
                %temporisation_mvt_axis(dev);
                if (temporisation_mvt_axis(dev) == -1)
                    % abort 
                end

                while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                    
                    if isequal(logdev1,1)
                        set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                        % on affiche la position de la lentille
                        pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                        pause(0.2);
                        drawnow;
                        
                    else
                        
                        set(handles.tata_radiobutton10,'BackgroundColor','green');
                        % on affiche la position de la lentille
                        pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                        pause(0.2);
                        drawnow;

                    end
                end

                pause(0.5);
                % on �teind le vert � la fin du mouvement
                % on �crit une derni�re fois la position de la lentille

                if isequal(logdev1,1)
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));

                else
                    set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));

                end

                % si on est arriv� en but�e backward on allume le voyant
                errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
                if isequal(errorstatus,22)|isequal(errorstatus,4)
                    if isequal(logdev1,1)
                        set(handles.LHBH_edit25,'BackgroundColor','red');
                    else
                        set(handles.LBBH_edit26,'BackgroundColor','red');
                    end 
                end

                % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci

                pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                    set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
                elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                    set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
                elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                    set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
                end
            end
        else 
            errordlg('d�j� en butee ou erreur','ATTENTION');
        end
    end
end

% 
% 
%     % --- Executes on button press in mm_pushbutton22.
%     function mm_pushbutton22_Callback(hObject, eventdata, handles)
%     % hObject    handle to mm_pushbutton22 (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     % handles    structure with handles and user data (see GUIDATA)
% 
% 
%     logdev1=get(handles.Lenthaute_radiobutton7,'Value');
%     logdev2=get(handles.tata_radiobutton10,'Value');
%     posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
%     posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
%     posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
%     posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
%     posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
%     posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
% 
%     if isequal(logdev1,0)&isequal(logdev2,0)
%         errordlg('selectionnez une lentille','ATTENTION');
%     else
%         if isequal(logdev1,1)
%             dev=device_name.lentille_haute;
%             nbpas=-500;
%         else
%             dev=device_name.lentille_basse;
%             nbpas=-1000;
%         end
% 
%         errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
% 
%         if (tango_error == -1)
%             %- handle error
%             tango_print_error_stack;
%             return;
%             errordlg('erreur tango !','Erreur');
% 
%         else
%             % cas ou l'axe n'est pas en butee backward (en haut)
%             % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens +
%             % errorstatus=4  limitswitch forward
% 
%             if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
% 
%                 % si on �tait en but�e forward, on �teind le voyant
%                 if isequal(errorstatus,21)|isequal(errorstatus,3)
%                     if isequal(logdev1,1)
%                         set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
%                     else
%                         set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
%                     end
%                 end
% 
%                 % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
%                 set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
%                 set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
%                 set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
% 
%                 % on monte vers la but�e backward
%                 tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
%                 if (tango_error == -1)
%                     %- handle error
%                     tango_print_error_stack;
%                     return;
%                     errordlg('erreur tango !','Erreur');
% 
%                 else
% 
%                 % temporisation : 
%                 pause(0.2);
%                 while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
%                     if isequal(logdev1,1)
%                         set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
%                     else
%                         set(handles.tata_radiobutton10,'BackgroundColor','green');
%                     end
%                     pause(0.5);
%                 end
% 
%                 % on �teind le vert � la fin du mouvement
%                 if isequal(logdev1,1)
%                     set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
%                 else
%                     set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
%                 end
% 
%                 % si on est arriv� en but�e backward on allume le voyant
%                 errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
%                 if isequal(errorstatus,22)|isequal(errorstatus,4)
%                     if isequal(logdev1,1)
%                         set(handles.LHBH_edit25,'BackgroundColor','red');
%                     else
%                         set(handles.LBBH_edit26,'BackgroundColor','red');
%                     end 
%                 end
% 
%                 % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
% 
%                 pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%                 pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
%                 if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
%                     set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
%                 elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
%                     set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
%                 elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
%                     set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
%                 end
% 
%                 end
%             else 
%                 errordlg('d�j� en butee ou erreur','ATTENTION');
%             end
%         end
%     end


% --- Executes on button press in m_pushbutton23.
function m_pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to m_pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

logdev1=get(handles.Lenthaute_radiobutton7,'Value');
logdev2=get(handles.tata_radiobutton10,'Value');
posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
device_name = getappdata(handles.figure1,'device_name');

if isequal(logdev1,0)&isequal(logdev2,0)
    errordlg('selectionnez une lentille','ATTENTION');
else
    if isequal(logdev1,1)
        dev=device_name.lentille_haute;
        nbpas=-50;
    else
        dev=device_name.lentille_basse;
        nbpas=-100;
    end
    
    errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

    else
        % cas ou l'axe n'est pas en butee backward (en haut)
        % errorstatus=22 d�c�l�ration ou arr�t d� � un limit switch sens +
        % errorstatus=4  limitswitch forward

        if ~isequal(errorstatus,22)&~isequal(errorstatus,4)
 
            % si on �tait en but�e forward, on �teind le voyant
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
                else
                    set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
                end
            end
            
             % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
            set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
            set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
            
            
            % on monte vers la but�e backward
            tango_command_inout(dev,'AxisGoToRelativePosition',nbpas);
            if (tango_error == -1)
                %- handle error
                tango_print_error_stack;
                return;
                errordlg('erreur tango !','Erreur');

            else
            
                % temporisation : 
                %temporisation_mvt_axis(dev);
                if (temporisation_mvt_axis(dev) == -1)
                    % abort 
                end
                
                while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                    if isequal(logdev1,1)
                        set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                        % on affiche la position de la lentille
                        pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                        set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                    else
                        set(handles.tata_radiobutton10,'BackgroundColor','green');
                        % on affiche la position de la lentille
                        pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                        set(handles.pos2_edit30,'String',num2str(pos2.value(1)));

                    end
                end

                pause(0.5);
                % on �teind le vert � la fin du mouvement
                % on �crit une derni�re fois la position de la lentille

                if isequal(logdev1,1)
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));

                else
                    set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                    pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));

                end

                % si on est arriv� en but�e backward on allume le voyant
                errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
                if isequal(errorstatus,22)|isequal(errorstatus,4)
                    if isequal(logdev1,1)
                        set(handles.LHBH_edit25,'BackgroundColor','red');
                    else
                        set(handles.LBBH_edit26,'BackgroundColor','red');
                    end 
                end

                % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci

                pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
                pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
                if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                    set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
                elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                    set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
                elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                    set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
                end
            end
        else 
            errordlg('d�j� en butee ou erreur','ATTENTION');
        end
    end
end


%         % --- Executes on button press in backlight_pushbutton24.
%         function backlight_pushbutton24_Callback(hObject, eventdata, handles)
%         % hObject    handle to backlight_pushbutton24 (see GCBO)
%         % eventdata  reserved - to be defined in a future version of MATLAB
%         % handles    structure with handles and user data (see GUIDATA)
% 
%         prompt={'entrer une intensit� * entier entre 0 et 10'};
%         name='backlight';
%         numlines=1;
%         lumiere=tango_command_inout('lt1/emit/backlight','GetBrightness');
%         %- check error
%         if (tango_error == -1)
%               %- handle error
%               tango_print_error_stack;
%               return;
%         else
%             defaultanswer={num2str(lumiere)};
%         end
%         options.Resize='on';
%         options.WindowStyle='normal';
%         options.Interpreter='tex';
%         intensite=inputdlg(prompt,name,numlines,defaultanswer,options);
%         if ~isempty(intensite)
%             tango_command_inout('lt1/emit/backlight','SetBrightness',uint16(str2num(intensite{:})));
%         end
% 
%     % --- Executes on button press in iris_pushbutton25.
%     function iris_pushbutton25_Callback(hObject, eventdata, handles)
%     % hObject    handle to iris_pushbutton25 (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     % handles    structure with handles and user data (see GUIDATA)
% 
%     %      %entrer les deux variables vitesse et intensite pour l'iris
%     %        prompt={'entrer la vitesse - valeur entre 1 et 3','entrer l''intensite - valeur entre 1 et 10'};
%     %        name='IRIS';
%     %        numlines=1;
%     %        defaultanswer={'3','10'};
%     %        options.Resize='on';
%     %        options.WindowStyle='normal';
%     %        options.Interpreter='tex';
%     %        val=0;
%     %     %     while isequal(val,0)
%     %         choix=inputdlg(prompt,name,numlines,defaultanswer,options);
%     %     %         if ~isequal(directory,{})
%     %     %             if ~isdir(strcat('/home/PM/tordeux/matlab_test/',directory{:}))
%     %     %                 mkdir /home/PM/tordeux/matlab_test/directory;
%     %     %                 val=1;
%     %     %             else    
%     %     %                 button = questdlg('ce dossier existe ! voulez-vous continuer?','ATTENTION','oui','non','non')  
%     %     %                 if isequal(button,'oui')
%     %     %                     val=1;
%     %     %                 end
%     %     %             end     
%     %     %         else
%     %     %             %avoir deja cre� une directory de secours pour si on a fait "cancel"..
%     %     %             directory={'secours'};
%     %     %             val=1;
%     %     %         end
%     %     %     end
% 
%     IRIS(handles);
% 


function qualite_edit23_Callback(hObject, eventdata, handles)
% hObject    handle to qualite_edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qualite_edit23 as text
%        str2double(get(hObject,'String')) returns contents of qualite_edit23 as a double


% --- Executes during object creation, after setting all properties.
function qualite_edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qualite_edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function LHBB_edit24_Callback(hObject, eventdata, handles)
% hObject    handle to LHBB_edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LHBB_edit24 as text
%        str2double(get(hObject,'String')) returns contents of LHBB_edit24 as a double


% --- Executes during object creation, after setting all properties.
function LHBB_edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LHBB_edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function LHBH_edit25_Callback(hObject, eventdata, handles)
% hObject    handle to LHBH_edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LHBH_edit25 as text
%        str2double(get(hObject,'String')) returns contents of LHBH_edit25 as a double


% --- Executes during object creation, after setting all properties.
function LHBH_edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LHBH_edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function LBBH_edit26_Callback(hObject, eventdata, handles)
% hObject    handle to LBBH_edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LBBH_edit26 as text
%        str2double(get(hObject,'String')) returns contents of LBBH_edit26 as a double


% --- Executes during object creation, after setting all properties.
function LBBH_edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LBBH_edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function LBBB_edit27_Callback(hObject, eventdata, handles)
% hObject    handle to LBBB_edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LBBB_edit27 as text
%        str2double(get(hObject,'String')) returns contents of LBBB_edit27 as a double


% --- Executes during object creation, after setting all properties.
function LBBB_edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LBBB_edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in fondGmax_pushbutton29.
function fondGmax_pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to fondGmax_pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fondGmoy_pushbutton30.
function fondGmoy_pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to fondGmoy_pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fondGmin_pushbutton31.
function fondGmin_pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to fondGmin_pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function directory_sauvegarde_edit28_Callback(hObject, eventdata, handles)
% hObject    handle to directory_sauvegarde_edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directory_sauvegarde_edit28 as text
%        str2double(get(hObject,'String')) returns contents of directory_sauvegarde_edit28 as a double


% % directory principale (d�pend de l'utilisateur !!!)
% setappdata(handles.figure1,'directory_principale',directory_principale);
% 
% % directory de sauvegarde en attente
% setappdata(handles.figure1,'directory_principale','/home/PM/tordeux/matlab_test/');
% directory_principale=getappdata(handles.figure1,'directory_principale');
% phrase=strcat(directory_principale,'?');

directory_sauvegarde=get(handles.directory_sauvegarde_edit28,'String');
setappdata(handles.figure1,'directory_sauvegarde',directory_sauvegarde);

% cas ou la directory n'existe pas
%if ~isdir(strcat('/home/PM/tordeux/matlab_test/',directory{:}))
if  ~isdir(   directory_sauvegarde)
%                     mkdir(chemin)
%                     cd(chemin);
    mkdir(directory_sauvegarde)
    cd(directory_sauvegarde);

    %setappdata(handles.figure1,'init_sauvegarde',1);
    %val=getappdata(handles.figure1,'init_sauvegarde');
    %set(handles.directory_sauvegarde_edit28,'String',directory_sauvegarde);
    setappdata(handles.figure1,'directory_sauvegarde',directory_sauvegarde);

% cas ou la directory existe deja
else    
    button = questdlg('ce dossier existe ! voulez-vous continuer?','ATTENTION','oui','non','non') ; 
    if isequal(button,'oui')

%                         cd(chemin);
        cd(directory_sauvegarde);  

        %setappdata(handles.figure1,'init_sauvegarde',1);
        %val=getappdata(handles.figure1,'init_sauvegarde');
        %set(handles.directory_sauvegarde_edit28,'String',directory_sauvegarde);
        setappdata(handles.figure1,'directory_sauvegarde',directory_sauvegarde);

    else
        % retour � la case d�part 

    end
end     



% --- Executes during object creation, after setting all properties.
function directory_sauvegarde_edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directory_sauvegarde_edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in backlight_popupmenu3.
function backlight_popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to backlight_popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns backlight_popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from backlight_popupmenu3

%alias
device_name = getappdata(handles.figure1,'device_name');
dev = device_name.backlight;

val = get(hObject,'Value');
switch val
case 1
tango_command_inout(dev,'SetBrightness',uint16(0));    
case 2
tango_command_inout(dev,'SetBrightness',uint16(1));  
case 3
tango_command_inout(dev,'SetBrightness',uint16(2));  
case 4
tango_command_inout(dev,'SetBrightness',uint16(3));  
case 5
tango_command_inout(dev,'SetBrightness',uint16(4));  
case 6
tango_command_inout(dev,'SetBrightness',uint16(5));  
case 7
tango_command_inout(dev,'SetBrightness',uint16(6));  
case 8
tango_command_inout(dev,'SetBrightness',uint16(7));  
case 9
tango_command_inout(dev,'SetBrightness',uint16(8));  
case 10
tango_command_inout(dev,'SetBrightness',uint16(9));  
case 11
tango_command_inout(dev,'SetBrightness',uint16(10));  

end

% --- Executes during object creation, after setting all properties.
function backlight_popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backlight_popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'0','1','2','3','4','5','6',...
    '7','8','9','10',...
    });


function pos1_edit29_Callback(hObject, eventdata, handles)
% hObject    handle to pos1_edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pos1_edit29 as text
%        str2double(get(hObject,'String')) returns contents of pos1_edit29 as a double

% encore � faire !!


% posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
% posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
% posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
% posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
% posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
% posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
% device_name = getappdata(handles.figure1,'device_name');
%     
% numeropas = get(handles.pos1_edit29,'String');
% errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
% 
% if (tango_error == -1)
%     %- handle error
%     tango_print_error_stack;
%     return;
%     errordlg('erreur tango !','Erreur');
% 
% else
%         % cas ou l'axe n'est pas en butee forward (en bas)
%         % errorstatus=21 d�c�l�ration ou arr�t d� � un limit switch sens +
%         % errorstatus=3  limitswitch forward
% 
%         if ~isequal(errorstatus,21)&~isequal(errorstatus,3)
%  
%             % si on �tait en but�e backward, on �teind le voyant
%             if isequal(errorstatus,22)|isequal(errorstatus,4)
%                 if isequal(logdev1,1)
%                     set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
%                 else
%                     set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
%                 end
%             end
%             
%             % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
%             set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
%             set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
%             set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
%             
%             
%             % on bouge
%             tango_command_inout(dev,'AxisGoToPosition',numeropas);
%         
%             % temporisation : 
%             temporisation_mvt_axis(dev);
%             
%             while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
%                 
%                 set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
%                 % on affiche la position de la lentille
%                 pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%                 set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
% 
%             end
%             
%             pause(0.5);
%             % on �teind le vert � la fin du mouvement
%             % on �crit une derni�re fois la position de la lentille
%  
%                 set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
%                 % on affiche la position de la lentille
%                 pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%                 set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
%                             
%             % si on est arriv� en but�e forward on allume le voyant
%             
%             errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
%             if isequal(errorstatus,21)|isequal(errorstatus,3)
%                 if isequal(logdev1,1)
%                     set(handles.LHBB_edit24,'BackgroundColor','red');
%                     
%                 else
%                     set(handles.LBBB_edit27,'BackgroundColor','red');
% 
%                 end 
%             end
%             
%             % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
%       
%             pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
%             pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
%             if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
%                 set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
%             elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
%                 set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
%             elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
%                 set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
%             end
%             
%         else 
%             errordlg('d�j� en butee ou erreur','ATTENTION');
%         end
%     end
% end
% 

% --- Executes during object creation, after setting all properties.
function pos1_edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pos1_edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pos2_edit30_Callback(hObject, eventdata, handles)
% hObject    handle to pos2_edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pos2_edit30 as text
%        str2double(get(hObject,'String')) returns contents of pos2_edit30 as a double


% --- Executes during object creation, after setting all properties.
function pos2_edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pos2_edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in F_iris_pushbutton32.
function F_iris_pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to F_iris_pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

device_name = getappdata(handles.figure1,'device_name');
dev = device_name.iris
type = 'CloseX';
vitesse = '1';
click = '5';
commandename=strcat(type,vitesse);
tango_command_inout(dev,commandename,int32(str2num(click)));


% --- Executes on button press in FF_iris_pushbutton33.
function FF_iris_pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to FF_iris_pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

device_name = getappdata(handles.figure1,'device_name');
dev = device_name.iris
type = 'CloseX';
vitesse = '2';
click = '5';
commandename=strcat(type,vitesse);
tango_command_inout(dev,commandename,int32(str2num(click)));


% --- Executes on button press in FFF_iris_pushbutton34.
function FFF_iris_pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to FFF_iris_pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

device_name = getappdata(handles.figure1,'device_name');
dev = device_name.iris
type = 'CloseX';
vitesse = '3';
click = '5';
commandename=strcat(type,vitesse);
tango_command_inout(dev,commandename,int32(str2num(click)));


% --- Executes on button press in O_iris_pushbutton35.
function O_iris_pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to O_iris_pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

device_name = getappdata(handles.figure1,'device_name');
dev = device_name.iris
type = 'OpenX';
vitesse = '1';
click = '5';
commandename=strcat(type,vitesse);
tango_command_inout(dev,commandename,int32(str2num(click)));


% --- Executes on button press in OO_iris_pushbutton36.
function OO_iris_pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to OO_iris_pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

device_name = getappdata(handles.figure1,'device_name');
dev = device_name.iris
type = 'OpenX';
vitesse = '2';
click = '5';
commandename=strcat(type,vitesse);
tango_command_inout(dev,commandename,int32(str2num(click)));


% --- Executes on button press in OOO_iris_pushbutton38.
function OOO_iris_pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to OOO_iris_pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

device_name = getappdata(handles.figure1,'device_name');
dev = device_name.iris
type = 'OpenX';
vitesse = '3';
click = '5';
commandename=strcat(type,vitesse);
tango_command_inout(dev,commandename,int32(str2num(click)));


%% What to do before closing the application
function Closinggui(obj, event, handles, figure1)

%device_name = getappdata(handles.figure1,'device_name');

% Get default command line output from handles structure
answer = questdlg('Fermer Emittance ?',...
    'Exit Programme Emittance',...
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



function Q2courant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Q2courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Q2courant_edit as text
%        str2double(get(hObject,'String')) returns contents of Q2courant_edit as a double


ecriture('Q2',handles)


% --- Executes during object creation, after setting all properties.
function Q2courant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q2courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function H2courant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to H2courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H2courant_edit as text
%        str2double(get(hObject,'String')) returns contents of H2courant_edit as a double

ecriture('H2',handles)


% --- Executes during object creation, after setting all properties.
function H2courant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H2courant_edit (see GCBO)
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



function Q3courant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Q3courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Q3courant_edit as text
%        str2double(get(hObject,'String')) returns contents of Q3courant_edit as a double

ecriture('Q3',handles)



% --- Executes during object creation, after setting all properties.
function Q3courant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q3courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Q4courant_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Q4courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Q4courant_edit as text
%        str2double(get(hObject,'String')) returns contents of Q4courant_edit as a double

ecriture('Q4',handles)



% --- Executes during object creation, after setting all properties.
function Q4courant_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q4courant_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function type_edit36_Callback(hObject, eventdata, handles)
% hObject    handle to type_edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of type_edit36 as text
%        str2double(get(hObject,'String')) returns contents of type_edit36 as a double


% --- Executes during object creation, after setting all properties.
function type_edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type_edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nbiter_edit37_Callback(hObject, eventdata, handles)
% hObject    handle to nbiter_edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbiter_edit37 as text
%        str2double(get(hObject,'String')) returns contents of nbiter_edit37 as a double


% --- Executes during object creation, after setting all properties.
function nbiter_edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbiter_edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function energie_edit38_Callback(hObject, eventdata, handles)
% hObject    handle to energie_edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energie_edit38 as text
%        str2double(get(hObject,'String')) returns contents of energie_edit38 as a double


% --- Executes during object creation, after setting all properties.
function energie_edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energie_edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in imprimer_pushbutton7.
function imprimer_pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to imprimer_pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine file and directory name
FileName = '1';

DirectoryName = getappdata(handles.figure1,'directory_sauvegarde');

% Append date_Time to FileName
%FileName = sprintf('%s_%s', 'tableau', FileName);
FileName = sprintf( '%s_%s','tableau', FileName);

%FileName = appendtimestamp(FileName, clock);
[FileName, DirectoryName] = uiputfile('*','Save Lattice to ...', [DirectoryName FileName]);
if FileName == 0 
    fprintf('   File not saved (getmachineconfig)\n');
    return;
end

% Save all data in structure to file
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);  

ResultsStr = get(handles.listbox1,'String');

try
    save(FileName,'ResultsStr')
    %save(FileName,'ResultsStr','-ascii')
    %save -ascii mydata.dat
catch
    cd(DirStart);
    return
end
cd(DirStart);




% --- Executes during object creation, after setting all properties.
function imprimer_pushbutton17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imprimer_pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


% --- Executes on selection change in camera_controle_popupmenu4.
function camera_controle_popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to camera_controle_popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns camera_controle_popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from camera_controle_popupmenu4

device_name = getappdata(handles.figure1,'device_name');
dev = device_name.videograbber;

val = get(hObject,'Value');
switch val
   
case 2
tango_command_inout(dev,'AutoAdjustRefLevels');  
disp('AutoAdjustRefLevels')
case 3
tango_command_inout(dev,'EnableCorrectedImage');  
case 4
tango_command_inout(dev,'EnableCorrectedProfiles');  
case 5
tango_command_inout(dev,'EnableProfiles');  
case 6
tango_command_inout(dev,'DisableCorrectedImage');  
case 7
tango_command_inout(dev,'DisableCorrectedProfiles');  
case 8
tango_command_inout(dev,'DisableProfiles');

case 9
tango_command_inout(dev,'GetExposureTime');
% on donne la possibilité de modifier le exposuretime
res = tango_command_inout(dev,'GetExposureTime');
prompt={'ExposureTime'};
name='GetExposureTime';
numlines=1;
defaultanswer={num2str(res)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
time = inputdlg(prompt,name,numlines,defaultanswer,options);
tango_command_inout(dev,'SetExposureTime',str2num(time{:}));

case 10
% on donne la possibilité de modifier le shutterdelay
res = tango_command_inout(dev,'GetShutterDelay');
prompt={'ShutterDelay'};
name='GetShutterDelay';
numlines=1;
defaultanswer={num2str(res)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
delay = inputdlg(prompt,name,numlines,defaultanswer,options);
tango_command_inout(dev,'SetShutterDelay',str2num(delay{:}));

case 11
res = tango_command_inout(dev,'State');
errordlg(res,'State');
case 12
res = tango_command_inout(dev,'Status');
errordlg(res,'Status');
end


% --- Executes during object creation, after setting all properties.
function camera_controle_popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to camera_controle_popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in controle_lentilles_popupmenu5.
function controle_lentilles_popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to controle_lentilles_popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns controle_lentilles_popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from controle_lentilles_popupmenu5


device_name = getappdata(handles.figure1,'device_name');
logdev1=get(handles.Lenthaute_radiobutton7,'Value');
logdev2=get(handles.tata_radiobutton10,'Value');
posl1Gmax = getappdata(handles.figure1,'posl1Gmax');
posl2Gmax = getappdata(handles.figure1,'posl2Gmax');
posl1Gmoy = getappdata(handles.figure1,'posl1Gmoy');
posl2Gmoy = getappdata(handles.figure1,'posl2Gmoy');
posl1Gmin = getappdata(handles.figure1,'posl1Gmin');
posl2Gmin = getappdata(handles.figure1,'posl2Gmin');
device_name = getappdata(handles.figure1,'device_name');

if isequal(logdev1,0)&isequal(logdev2,0)
    errordlg('selectionnez une lentille','ATTENTION');
else
    if isequal(logdev1,1)
        dev=device_name.lentille_haute;       
    else
        dev=device_name.lentille_basse;     
    end
    
    errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        return;
        errordlg('erreur tango !','Erreur');

    else
        
        val = get(hObject,'Value');
        switch val

        case 2
        prompt={'Entrez une position'};
        name='AxisDefinePosition';
        numlines=1;
        defaultanswer={ num2str(0) };
        options.Resize='on';
        options.WindowStyle='normal';
        options.Interpreter='tex';
        toto = inputdlg(prompt,name,numlines,defaultanswer,options);
        if ~isequal(toto,{})
            tango_command_inout(dev,'AxisDefinePosition',str2num(toto{:}));
            fonction_error;
            
            if isequal(logdev1,1)
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
            else
                    % on affiche la position de la lentille
                    pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
            end
            
        end

        case 3
        res = tango_command_inout(dev,'AxisGetErrorStatus');  
        errordlg(num2str(res),'AxisGetErrorStatus');

        case 4
        res = tango_command_inout(dev,'AxisGetMotionStatus');  
        errordlg(num2str(res),'AxisGetMotionStatus');

        case 5
        prompt={'Entrez une position de destination'};
        name='AxisGoToPosition';
        numlines=1;
        defaultanswer={ num2str(0) };
        options.Resize='on';
        options.WindowStyle='normal';
        options.Interpreter='tex';
        toto = inputdlg(prompt,name,numlines,defaultanswer,options);
        if ~isequal(toto,{})
            
            posref=tango_read_attribute(dev,'AxisCurrentMotorPosition');
            fonction_error;
            
            if str2num(toto{:})>posref.value
                % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
                set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
                
                % si on �tait en but�e backward, on �teind le voyant
                if isequal(errorstatus,22)|isequal(errorstatus,4)
                    if isequal(logdev1,1)
                        set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
                    else
                        set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
                    end
                end
                
            elseif str2num(toto{:})<posref.value
                
                % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
                set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
                
                % si on �tait en but�e forward, on �teind le voyant
                if isequal(errorstatus,21)|isequal(errorstatus,3)
                    if isequal(logdev1,1)
                        set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
                    else
                        set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
                    end
                end
                
            else
                return;
            end
            
            % on déplace l'axe jusqu'à la position demandée
            tango_command_inout(dev,'AxisGoToPosition',str2num(toto{:}));
            % on attent que l'axe se mette en mouvement
            if (temporisation_mvt_axis(dev) == -1)
             % abort 
            end

            % attendre la fin de la commande en clignotant
            while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                if isequal(logdev1,1)
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                else
                    set(handles.tata_radiobutton10,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                end
            end

            pause(0.5);
            % on �teind le vert � la fin du mouvement
            % on �crit une derni�re fois la position de la lentille

            if isequal(logdev1,1)
                set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                % on affiche la position de la lentille
                pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                set(handles.pos1_edit29,'String',num2str(pos1.value(1)));

            else
                set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                set(handles.pos2_edit30,'String',num2str(pos2.value(1)));

            end
        
            % si on est arriv� en but�e forward on allume le voyant  
            errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
            fonction_error;
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor','red');
                else
                    set(handles.LBBB_edit27,'BackgroundColor','red');
                end 
            end

            % si on est arriv� en but�e backward on allume le voyant  
            errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
            if isequal(errorstatus,22)|isequal(errorstatus,4)
                if isequal(logdev1,1)
                    set(handles.LHBH_edit25,'BackgroundColor','red');
                else
                    set(handles.LBBH_edit26,'BackgroundColor','red');
                end 
            end

            % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
            pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
            if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
            end
        end
        
        case 6
        prompt={'Entrez une position relative de destination'};
        name='AxisGoToRelativePosition';
        numlines=1;
        defaultanswer={ num2str(0) };
        options.Resize='on';
        options.WindowStyle='normal';
        options.Interpreter='tex';
        toto = inputdlg(prompt,name,numlines,defaultanswer,options);
        if ~isequal(toto,{})
            
            posref=tango_read_attribute(dev,'AxisCurrentMotorPosition');
            fonction_error;
            
            if str2num(toto{:})>0
                % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
                set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
                
                % si on �tait en but�e backward, on �teind le voyant
                if isequal(errorstatus,22)|isequal(errorstatus,4)
                    if isequal(logdev1,1)
                        set(handles.LHBH_edit25,'BackgroundColor',[0.702 0.702 0.702]);
                    else
                        set(handles.LBBH_edit26,'BackgroundColor',[0.702 0.702 0.702]);
                    end
                end
                
            elseif str2num(toto{:})<0
                
                % pour le cas o� on �tait dans les conditions d'un grandissement, �teindre tous les voyants rouges grandissements
                set(handles.fondGmax_pushbutton29,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmoy_pushbutton30,'BackgroundColor',[0.979 1.0 0.822]);
                set(handles.fondGmin_pushbutton31,'BackgroundColor',[0.979 1.0 0.822]); 
                
                % si on �tait en but�e forward, on �teind le voyant
                if isequal(errorstatus,21)|isequal(errorstatus,3)
                    if isequal(logdev1,1)
                        set(handles.LHBB_edit24,'BackgroundColor',[0.702 0.702 0.702]);
                    else
                        set(handles.LBBB_edit27,'BackgroundColor',[0.702 0.702 0.702]);
                    end
                end
                
            else
                return;
            end
            
            % on déplace l'axe jusqu'à la position demandée
            tango_command_inout(dev,'AxisGoToRelativePosition',str2num(toto{:}));
            % on attent que l'axe se mette en mouvement
            if (temporisation_mvt_axis(dev) == -1)
             % abort 
            end

            % attendre la fin de la commande en clignotant
            while isequal(tango_command_inout(dev,'AxisGetMotionStatus'),1)
                if isequal(logdev1,1)
                    set(handles.Lenthaute_radiobutton7,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                    set(handles.pos1_edit29,'String',num2str(pos1.value(1)));
                else
                    set(handles.tata_radiobutton10,'BackgroundColor','green');
                    % on affiche la position de la lentille
                    pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                    set(handles.pos2_edit30,'String',num2str(pos2.value(1)));
                end
            end

            pause(0.5);
            % on �teind le vert � la fin du mouvement
            % on �crit une derni�re fois la position de la lentille

            if isequal(logdev1,1)
                set(handles.Lenthaute_radiobutton7,'BackgroundColor',[0.702 0.702 0.702]);
                % on affiche la position de la lentille
                pos1=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                set(handles.pos1_edit29,'String',num2str(pos1.value(1)));

            else
                set(handles.tata_radiobutton10,'BackgroundColor',[0.702 0.702 0.702]);
                pos2=tango_read_attribute(dev,'AxisCurrentMotorPosition');
                set(handles.pos2_edit30,'String',num2str(pos2.value(1)));

            end
        
            % si on est arriv� en but�e forward on allume le voyant  
            errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
            fonction_error;
            if isequal(errorstatus,21)|isequal(errorstatus,3)
                if isequal(logdev1,1)
                    set(handles.LHBB_edit24,'BackgroundColor','red');
                else
                    set(handles.LBBB_edit27,'BackgroundColor','red');
                end 
            end

            % si on est arriv� en but�e backward on allume le voyant  
            errorstatus=tango_command_inout(dev,'AxisGetErrorStatus');
            if isequal(errorstatus,22)|isequal(errorstatus,4)
                if isequal(logdev1,1)
                    set(handles.LHBH_edit25,'BackgroundColor','red');
                else
                    set(handles.LBBH_edit26,'BackgroundColor','red');
                end 
            end

            % si on est sur une position d�termin�e d'un grandissement, allumer en rouge celui-ci
            pos1=tango_read_attribute(device_name.lentille_haute,'AxisCurrentMotorPosition');
            pos2=tango_read_attribute(device_name.lentille_basse,'AxisCurrentMotorPosition');
            if isequal(pos1.value(1),posl1Gmax)&isequal(pos2.value(1),posl2Gmax)
                set(handles.fondGmax_pushbutton29,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmoy)&isequal(pos2.value(1),posl2Gmoy)
                set(handles.fondGmoy_pushbutton30,'BackgroundColor','red');
            elseif isequal(pos1.value(1),posl1Gmin)&isequal(pos2.value(1),posl2Gmin) 
                set(handles.fondGmin_pushbutton31,'BackgroundColor','red');
            end
        end
        
        
        case 11
        res = tango_command_inout(dev,'State');
        errordlg(res,'State');
        case 12
        res = tango_command_inout(dev,'Status');
        errordlg(res,'Status');
        
        end
    end
end
            
    



% --- Executes during object creation, after setting all properties.
function controle_lentilles_popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controle_lentilles_popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in emitV_pushbutton39.
function emitV_pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to emitV_pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ellipseV_pushbutton40.
function ellipseV_pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to ellipseV_pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ellipseV_v16(handles)
