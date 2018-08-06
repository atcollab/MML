function varargout = fae_v4(varargin)
% FAE_V4 M-file for fae_v4.fig
%      FAE_V4, by itself, creates a new FAE_V4 or raises the existing
%      singleton*.
%
%      H = FAE_V4 returns the handle to a new FAE_V4 or the handle to
%      the existing singleton*.
%
%      FAE_V4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FAE_V4.M with the given input arguments.
%
%      FAE_V4('Property','Value',...) creates a new FAE_V4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fae_v4_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fae_v4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help fae_v4

% Last Modified by GUIDE v2.5 19-Sep-2005 16:49:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fae_v4_OpeningFcn, ...
                   'gui_OutputFcn',  @fae_v4_OutputFcn, ...
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

% --- Executes just before fae_v4 is made visible.
function fae_v4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fae_v4 (see VARARGIN)

% Choose default command line output for fae_v4
handles.output = hObject;

% devices Servers Tango
device_name.morsdroit = 'lt1/dg/fae-mors.droit'
device_name.morsgauche = 'lt1/dg/fae-mors.gauche'
device_name.scan = 'lt1/dg/fae-scan'
device_name.fente = 'lt1/dg/fae-fente'
device_name.scan1D = 'lt1/dg/fae-scan1D'
%device_name.dipole = 'LT1/AEsim/D.1'
device_name.dipole = 'LT1/AE/D.1'
setappdata(handles.figure1,'device_name',device_name);

%         % �talonnage du dip�le (cette partie pourrait �tre revue avec les fonctions mml
%         setappdata(handles.figure1,'B0',0.000119);
%         setappdata(handles.figure1,'B1',4.8861*0.0001);


% Creates timer Infinite loop
timer1=timer('StartDelay',1,...
    'ExecutionMode','fixedRate','Period',1,'TasksToExecute',Inf);
    %'ExecutionMode','fixedRate','Period',1,'TasksToExecute',Inf);
timer1.TimerFcn = {@fae_timer, hObject,eventdata, handles};
setappdata(handles.figure1,'Timer',timer1);

start(timer1);

%% Set closing gui function
set(handles.figure1,'CloseRequestFcn',{@Closinggui,timer1,handles.figure1});
%set(handles.figure1,'CloseRequestFcn',{@Closinggui,handles.figure1});

% Update handles structure
guidata(hObject, handles);
    

% % taille_spectrum = size(xdata,2)

    
% % This sets up the initial plot - only do when we are invisible
% % so window can get raised using fae_v4.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes fae_v4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fae_v4_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in NewData_pushbutton1.
function NewData_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to NewData_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% ACQUISITION
device_name = getappdata(handles.figure1,'device_name');
dev = device_name.scan;
vectx=tango_read_attribute(dev,'actuators_data');
fonction_error;
xdata = vectx.value;
setappdata(handles.figure1,'xdata',xdata);

% vecty=tango_read_attribute(dev,'sensors_data');
% ydata = vecty.value;

dev = device_name.scan1D;
% lecture des deux mesureurs de charge ensemble
%- build attribute list
mc_name_list = {'Sensor1Data', 'Sensor2Data'};
%- read attributes
mc_val_list = tango_read_attributes(dev, mc_name_list);
%- always check error
if (tango_error == -1)
  %- handle error 
  tango_print_error_stack;
  return;
end
%- store 'Sensor1Data' value in local variable
ydatamc1 = mc_val_list(1).value;
%- store 'Sensor2Data' value in local variable
ydatamc2 = mc_val_list(2).value;

% affichage de la charge et calibre du mesureur 1
% attention le calibre n'est pour l'instant pas associé à une date... il a
% pu changer lorsqu'on active le traitement par MATLAB !!!!
% -> trouver une solution
set(handles.mc1_charge_edit5,'String',num2str(ydatamc1(1)));

device = 'LT1/DG/MC';
ict1Gain_val = tango_read_attribute(device,'ict1Gain');
ict1Gain = ict1Gain_val.value(1);
ict2Gain_val = tango_read_attribute(device,'ict2Gain');
ict2Gain = ict2Gain_val.value(1);
if (tango_error == -1)
  %- handle error 
  tango_print_error_stack;
  return;
end
set(handles.mc1_calibre_edit6,'String',num2str(ict1Gain));
set(handles.mc2_calibre_edit9,'String',num2str(ict2Gain));


% % setappdata(handles.figure1,'ydata',ydata);
setappdata(handles.figure1,'ydatamc1',ydatamc1);
setappdata(handles.figure1,'ydatamc2',ydatamc2);

% horodatage du scan :
dev = device_name.scan;
res = tango_read_attribute(dev,'measureDate');
%%res = tango_read_attribute('tests/scanserver/1','measureDate');
String1 = datenum('1-January-1970');
% equation correcte :
%String2 = double(res.value)/(60*60*24) + String1;
% equation en attendant la remise à l'heure locale du CPU
String2 = double(res.value + 2*60*60)/(60*60*24) + String1;
date =  datestr(String2,'dd-mmm-yyyy HH:MM:SS');

% horodatage du scan : en attendant :
% device_name = getappdata(handles.figure1,'device_name');
% structure = tango_read_attribute(device_name.dipole,'current');
% date = datestr(structure.time)

set(handles.horodatage_edit1,'String',date);
setappdata(handles.figure1,'Date',date);

%% AFFICHAGE ET TRAITEMENT
% on écrase les vecteurs données re - calculées  (lissées, énergie)
% et le nom de fichier
nul = [];
setappdata(handles.figure1,'yfiltre',nul);
setappdata(handles.figure1,'Dfiltre',nul);
setappdata(handles.figure1,'xdata2',nul);
setappdata(handles.figure1,'ydata2',nul);
set(handles.nom_fichier_edit7,'String',[]);

% test sur type de spectre
log1=get(handles.Dipfixe_radiobutton1,'Value');
log2=get(handles.Fenfixe_radiobutton2,'Value');
log3=get(handles.Gap_radiobutton3,'Value');

% normaliser les charges !!
ydata = ydatamc2./ydatamc1;
% on remplace les valeurs infinies par 0
ydata(isnan(ydata))=0;

% calcul de l'énergie du faisceau / dispersion à la fente d'analyse
LT1init;
global THERING;
AO = getao;

% sauvegarder le mode du simulateur optics_LT1
mode = getmode('BEND')
if isequal(mode,'Simulator')
    switch2online
end    

twissdatain.ElemIndex=1;
twissdatain.SPos=0;
twissdatain.ClosedOrbit=[1e-3 0 2e-3 0]'*0;
twissdatain.M44=eye(4);
twissdatain.beta= [8.1 8.1];
twissdatain.alpha= [0 0];
twissdatain.mu= [0 0];
twissdatain.Dispersion= [0 0 0 0]';
TD = twissline(THERING,0.0,twissdatain,1:length(THERING),'chroma');
ETA = cat(2,TD.Dispersion)';

index = atindex(THERING);
num = index.COLL;
dispersion = ETA(num,1);
    

%% cas du dipôle fixe (1 mors actuator)
if isequal(log1,1)
    
%testA    Idip = getam('BEND');
% %             B0 = getappdata(handles.figure1,'B0');
% %             B1 = getappdata(handles.figure1,'B1');
% % 
%     [C, Leff, MagnetType, A] = magnetcoefficients('BEND');
%     B0 = A(9);
%     B1 = A(8);
%     Integrale = B0 + B1 * Idip;
%     angle = 15 * pi / 180;
% %             Bro = Integrale / angle
%     E0 = 0.51099906 ;
% %             Ec = E0 * ( sqrt(1 + (Bro*0.29979)*(Bro*0.29979)/((E0*0.001)*(E0*0.001))) - 1 )
%     Ec = getenergy('Online')*1e3 - E0;
%%Ec = 100    
%%Idip = 170
% en attendant la reconnexion des équipements, simulation !
% %     xdata = [-25:0.25:25];
    xmin = min(xdata);
    xmax = max(xdata);
    sizex = size(xdata,2);

    
    % test sur une fonction erf pour le spectre integr�
% %     z=-200:2:200;
% %     ydata=(erf(z.*(1/50))-erf(-100.*(1/50)))/(erf(100.*(1/50))-erf(-100.*(1/50)));
    sizey = size(ydata,2);

    
% %     % ydatab = donn�es avec bruit superpos�
% %     coefficient = 0.0003;
% %     ydatab = ydata+ coefficient *(1./abs(sqrt(ydata))).*randn(size(ydata));
% %     toto = ydatab(51);
% %     ydatab(51) = 0;
    ydatab = ydata;
    % on dérive les données bruit�es (Dbruit) 
    %D = diff(ydata)./diff(xdata);
    Dbruit = diff(ydatab)./diff(xdata);
   
    xdata2 = Ec *(1 - xdata*0.001 /dispersion );
    xmin = min(xdata2);
    xmax = max(xdata2);
    sizex2 = size(xdata2,2);
     
    ResultsStr = {['I dipôle [A] = ',num2str(Idip)],...
        ['Ec sur l''axe [MeV] = ',num2str(Ec)],['D FAE [m] = ',num2str(dispersion)]};
    set(handles.listbox1,'String',ResultsStr);
    setappdata(handles.figure1,'Idip',num2str(Idip));
    setappdata(handles.figure1,'Ecaxe',num2str(Ec));
    setappdata(handles.figure1,'DFAE',num2str(dispersion));
    
    % graphe avec labels et valeurs ligne de transfert déduits des courants
    % sur la machine
    %______________________________________________________________________
    axes(handles.axes1);
    cla
    plot(xdata,ydatab,'r')    
    xlim([xmin xmax]);
    xlabel('déplacement du mors en mm');
    ylabel('charge normalisée (qMC2/qMC1)');
    title('intégrale du spectre','FontAngle','italic','FontSize',12,'FontWeight','bold');
    %axis tight  
    legend('données brutes',2);
    legend('boxoff');
    grid on;
    drawnow;
    
    %__________________________________________________________________________
    axes(handles.axes2);
    cla
  
% test largeur gaussienne � +/- 1 sigma___________
% % x = [-25:0.25:25];
% % variance = 20.25;
% % imaxx = 0.1;
% % centrex = 0;
% % g=imaxx*exp(-(x-centrex).*(x-centrex)/(2*variance));
% %     
% % plot(xdata(1:sizex-1),Dbruit,'r',...
% %     x,g*max(Dbruit)/max(g),'b') 
% % xlim([min(xdata) max(xdata)]);
%____________________________________

    plot(xdata2(1:sizex-1),Dbruit,'r');
    xlim([xmin xmax]);
    xlabel('Energie en MeV');
    ylabel('charge normalisée');
    title('spectre','FontAngle','italic','FontSize',12,'FontWeight','bold');
    drawnow;
    
    setappdata(handles.figure1,'ydata2',Dbruit);
    
    %____________________________________________________________________
    % calcul de largeur du spectre
    Itot = max(ydata);
    Ipartielle = 0;
    sizey = size(ydata,2);
    j = 1;
    i = 1;
    
    while abs(Ipartielle/Itot) < 0.3173
       
        if (ydatab(sizey-j+1)-ydatab(sizey-j)) < (ydatab(i+1)-ydatab(i))
            Ipartielle = Ipartielle + (ydatab(sizey-j+1)-ydatab(sizey-j));
            j = j+1;
        else
            Ipartielle = Ipartielle + (ydatab(i+1)-ydatab(i));
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpx = sizey - ifinal - jfinal + 2;
    %pasMeV = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeV = Nbpx * pasMeV;
    pasmm = xdata(2) - xdata(1);
    Largeurmm = Nbpx * pasmm;
    
    % graphe du mesureur de charge n01
    %______________________________________________________________________
    axes(handles.axes3);
    cla
    plot(xdata2(1:sizex-1),ydatamc1(1:sizex-1),'b');
    xlim([min(xdata2) max(xdata2)]);
    xlabel('Energie en MeV');
    ylabel('charge (nC)');
    title('mesureur de charge n°1','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on;
    drawnow;
    
end

%% cas de la fente fixe (dipôle actuator)
if isequal(log2,1)
    
    % valeur de gap et du centre du gap
    structure = tango_read_attribute(device_name.fente,'Gap');
    gap = structure.value(1);
    structure = tango_read_attribute(device_name.fente,'Position');
    position = structure.value(1);
    valgap=sprintf('%2.1f',gap);
    resolution = 100*gap*1e-3/(dispersion);
    valresolution = sprintf('%2.1f',abs(resolution));
    valposition=sprintf('%2.1f',position);
    
    %     xdata = [30:230];
    xmin = min(xdata);
    xmax = max(xdata);
    sizex = size(xdata,2);
    
    % %     z=-100:100;
    %     %%1% variance = 0.25;
    %     variance = 0.001;
    %     imazz = 1;
    %     centrez = 30;
    %     ydata=imazz*exp(-(z/50-centrez/50).*(z/50-centrez/50)/(2*variance));
    sizey = size(ydata,2);
    
    %     % ydatab = donn�es avec bruit superpos�
    %     %%1% coef = 0.0002;
    %     %coef = 0.001;
    %     coef = 0.005;
    %     %ydatab = ydata+coef*(1./abs(sqrt(ydata))).*randn(size(ydata));
    %     ydatab = ydata+coef*(1./abs(sqrt(ydata + 0.01))).*randn(size(ydata));
    ydatab = ydata;
    maxydatab = max(ydatab);

    ResultsStr = {['Gap = ',valgap,' mm'],...
        ['Position du gap = ',valposition,' mm'],['Résolution = ',valresolution,' %']};
    set(handles.listbox1,'String',ResultsStr);
    
%     [C, Leff, MagnetType, A] = magnetcoefficients('BEND');
%     B0 = A(9);
%     B1 = A(8);
%     angle = 15 * pi / 180;
%     E0 = 0.51099906 ;
%     xdata2 = E0 *  (sqrt(1 + ((B0 + xdata* B1 ).*0.29979/ angle).*...
%         ((B0 + xdata* B1 ).*0.29979/ angle)/((E0*0.001)*(E0*0.001))) - 1 );

    
    for i = 1:size(xdata,2)
            xdata2(i) = 1000 * hw2physics('BEND','Setpoint',xdata(i),[1 1]);
    end
    xdata2 = xdata2 * (1 - position*0.001/dispersion);
    xmin2 = min(xdata2);
    xmax2 = max(xdata2);
    sizex2 = size(xdata2,2);

      
%% PLOT   
    %_____________________________________________________________________
    axes(handles.axes1);
    cla
    
    % %         % test largeur gaussienne � +/- 1 sigma___________
    % % % %x = [-25:0.25:25];
    % % x = [30:1:230];
    % % variance = 625;
    % % imaxx = 0.1;
    % % centrex = 160;
    % % g=imaxx*exp(-(x-centrex).*(x-centrex)/(2*variance));
    % %     
    % % plot(xdata(1:sizex),ydatab,'r',...
    % %     x,g*max(ydatab)/max(g),'b') 
    % % xlim([min(xdata) max(xdata)]);
    %____________________________________
    plot(xdata,ydatab,'r');
    xlim([xmin xmax]);
    xlabel('courant du dipôle en A');
    ylabel('charge normalisée (qMC2/qMC1)');
    title('spectre brut','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on
    %_____________________________________________________________________
    axes(handles.axes2);
    cla   
    % le calcul de xdata2 doit tenir compte du d�calage du gap par rapport
    % à l'axe théorique (valeur de l'attribut position)

    plot(xdata2,ydatab,'r');
    xlim([xmin2 xmax2]);
    
    xlabel('Energie en MeV');
    ylabel('charge normalisée');
    title('spectre corrigé','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on
    %______________________________________________________________________
    axes(handles.axes3);
    cla
    
    plot(xdata2(1:sizex-1),ydatamc1(1:sizex-1),'b');
    xlim([xmin2 xmax2]);
    xlabel('Energie en MeV');
    ylabel('charge (nC)');
    title('mesureur de charge n°1','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on;
    drawnow;
   
%% calcul de largeur du spectre non lissé
    %Itot = max(yfiltre1)
    
    Itot = trapz(xdata2(1:size(ydatab,2)),ydatab(1:size(ydatab,2)));
    
    sizey = size(ydatab,2);
    Ipartielle = 0;
    j = 1;
    i = 1;
    dx = xdata2(sizey) - xdata2(sizey - 1);
    
    
    while abs(Ipartielle/Itot) < 0.3173
       
        if ydatab(sizey-j+1) < ydatab(i+1)
            Ipartielle = Ipartielle + ydatab(sizey-j)*dx;
            j = j+1;
        else
            Ipartielle = Ipartielle + ydatab(i)*dx;
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasAf = xdata(2) - xdata(1);
    LargeurAf = Nbpxf * pasAf;
    
    
     [Y,I] = max(ydatab);
     dpsurp = 100 * LargeurMeVf / xdata2(I);
     val1=sprintf('%2.2f',dpsurp);
     %dpsurpcorr = sqrt(dpsurp*dpsurp - 0.5*0.5);
     dpsurpcorr = sqrt(dpsurp*dpsurp - resolution*resolution);
     val2=sprintf('%2.2f',dpsurpcorr);
     ResultsStr = get(handles.listbox1,'String');
     
     ResultsStr = {ResultsStr{:},...
         [],['Largeur corrigée du spectre non lissé : (Epeack =' ,sprintf('%2.3f',xdata2(I)),' MeV)'],...
        ['68 % des e- dans ',val2,' % de Epeack']}';
    set(handles.listbox1,'String',ResultsStr);
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Ipartielle = 0;
    j = 1;
    i = 1;
    dx = xdata2(sizey) - xdata2(sizey - 1);
    
    
    while abs(Ipartielle/Itot) < 0.20
       
        if ydatab(sizey-j+1) < ydatab(i+1)
            Ipartielle = Ipartielle + ydatab(sizey-j)*dx;
            j = j+1;
        else
            Ipartielle = Ipartielle + ydatab(i)*dx;
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasAf = xdata(2) - xdata(1);
    LargeurAf = Nbpxf * pasAf;
    
    
     [Y,I] = max(ydatab);
     dpsurp = 100 * LargeurMeVf / xdata2(I);
     val1=sprintf('%2.2f',dpsurp);
     %dpsurpcorr = sqrt(dpsurp*dpsurp - 0.5*0.5);
     dpsurpcorr = sqrt(dpsurp*dpsurp - resolution*resolution);
     val2=sprintf('%2.2f',dpsurpcorr);
     ResultsStr = get(handles.listbox1,'String');
     
     ResultsStr = {ResultsStr{:}, ...
        ['80 % des e- dans ',val2,' % de Epeack']}';
    set(handles.listbox1,'String',ResultsStr);
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    Ipartielle = 0;
    j = 1;
    i = 1;
    dx = xdata2(sizey) - xdata2(sizey - 1);
    
    
    while abs(Ipartielle/Itot) < 0.10
       
        if ydatab(sizey-j+1) < ydatab(i+1)
            Ipartielle = Ipartielle + ydatab(sizey-j)*dx;
            j = j+1;
        else
            Ipartielle = Ipartielle + ydatab(i)*dx;
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasAf = xdata(2) - xdata(1);
    LargeurAf = Nbpxf * pasAf;
    
    
     [Y,I] = max(ydatab);
     dpsurp = 100 * LargeurMeVf / xdata2(I);
     val1=sprintf('%2.2f',dpsurp);
     %dpsurpcorr = sqrt(dpsurp*dpsurp - 0.5*0.5);
     dpsurpcorr = sqrt(dpsurp*dpsurp - resolution*resolution);
     val2=sprintf('%2.2f',dpsurpcorr);
     ResultsStr = get(handles.listbox1,'String');
     
     ResultsStr = {ResultsStr{:}, ...
        ['90 % des e- dans ',val2,' % de Epeack']}';
     set(handles.listbox1,'String',ResultsStr);
   

end

%% cas de la position du gap actuator
if isequal(log3,1)
    
    % valeur de l'aimant et de la largeur du gap
    % la valeur de l'aimant représente l'énergie sur l'axe
    structure = tango_read_attribute(device_name.fente,'Gap');
    gap = structure.value(1);
    valgap=sprintf('%2.1f',gap);
    
    dev = device_name.dipole;
    structure = tango_read_attribute(dev,'current');
    courant = structure.value(1);
    energie = 1000*hw2physics('BEND','Setpoint',courant,[1 1])
    set(handles.repositionner_edit3,'String',num2str(energie));
    
    resolution = 100*gap*1e-3/(dispersion);
    valresolution = sprintf('%2.2f',abs(resolution));
    
    %__________________________________________________________________
    xdata2 = energie * (1 - xdata.*0.001/dispersion);
    xmin = min(xdata);xmax = max(xdata);sizex = size(xdata,2);
    xmin2 = min(xdata2);xmax2 = max(xdata2);sizex2 = size(xdata2,2);
    sizey = size(ydata,2);
    
    %__________________________________________________________________
    %ydatab = ydata;
    ydata2 = -ydata./(gap*0.001*xdata2/dispersion);
    maxydata2 = max(ydata2);
    % integrale du spectre
    integraleydata2 = ydatamc1(1) * trapz(xdata2,ydata2);
    valintegrale = sprintf('%2.2f',integraleydata2)
    ResultsStr = {['Gap = ',valgap,' mm'],...
        ['Résolution = ',valresolution,' %']};
    set(handles.listbox1,'String',ResultsStr);
    set(handles.mc2_charge_edit8,'String',valintegrale);
    
%% PLOT
    %_____________________________________________________________________
    axes(handles.axes1);
    cla
    plot(xdata,ydata,'r')    
    xlim([xmin xmax]);
    xlabel('deplacement du gap en mm');
    ylabel('charge normalisée (qMC2/qMC1)');
    title('spectre brut','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on
    %_____________________________________________________________________
    axes(handles.axes2);
    cla
    plot(xdata2,ydata2,'r')   
    xlim([xmin2 xmax2]);
    
    xlabel('Energie en MeV');
    ylabel('charge normalisée (qMC2/qMC1/MeV)');
    title('spectre corrigé','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on
    %______________________________________________________________________
    axes(handles.axes3);
    cla
    
    plot(xdata2(1:sizex-1),ydatamc1(1:sizex-1),'b');
    xlim([xmin2 xmax2]);
    xlabel('Energie en MeV');
    ylabel('charge (nC)');
    title('mesureur de charge n°1','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on;
    drawnow;
    
%%  calcul de largeur du spectre non lissé
    pourcentage_1sigma = 0.3173;
    pourcentage_80pc = 0.2;
    pourcentage_90pc = 0.1;

    [Y,I] = max(ydata2);
    largeur_MeV_1sigma = largeur_pourcentage(xdata2,ydata2,pourcentage_1sigma)
    largeur_MeV_80pc = largeur_pourcentage(xdata2,ydata2,pourcentage_80pc)
    largeur_MeV_90pc = largeur_pourcentage(xdata2,ydata2,pourcentage_90pc)
    dpsurp_1sigma = 100 * largeur_MeV_1sigma / xdata2(I);
    largeur_MeV_80pc = largeur_pourcentage(xdata2,ydata2,pourcentage_80pc)
    dpsurp_80pc = 100 * largeur_MeV_80pc / xdata2(I);
    largeur_MeV_90pc = largeur_pourcentage(xdata2,ydata2,pourcentage_90pc)
    dpsurp_90pc = 100 * largeur_MeV_90pc / xdata2(I);

    valdpsurp_1sigma = sprintf('%2.2f',dpsurp_1sigma)
    valdpsurp_80pc = sprintf('%2.2f',dpsurp_80pc)
    valdpsurp_90pc = sprintf('%2.2f',dpsurp_90pc)
    ResultsStr = get(handles.listbox1,'String');
    ResultsStr = {ResultsStr{:},...
    [],['Largeur du spectre  : (Epeack = ',sprintf('%2.3f',xdata2(I)),' MeV)'],...
    ['68 % des e- dans ',valdpsurp_1sigma,' % de Epeack'],...
    ['80 % des e- dans ',valdpsurp_80pc,' % de Epeack'],...
    ['90 % des e- dans ',valdpsurp_90pc,' % de Epeack']}';
    set(handles.listbox1,'String',ResultsStr);
    
end

    
setappdata(handles.figure1,'xdata',xdata);
setappdata(handles.figure1,'xdata2',xdata2);
setappdata(handles.figure1,'ydata',ydata);
setappdata(handles.figure1,'ydata2',ydata2);




if isequal(mode,'Simulator')
    switch2sim
    test_mode = getmode('BEND')
end

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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Dipfixe_radiobutton1.
function Dipfixe_radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to Dipfixe_radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Dipfixe_radiobutton1

% cas du dip�le fixe
% log1=get(handles.Dipfixe_radiobutton1,'Value');
% log2=get(handles.Fenfixe_radiobutton2,'Value');
% 
% if isequal(log1,1)



% --- Executes on button press in Fenfixe_radiobutton2.
function Fenfixe_radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to Fenfixe_radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Fenfixe_radiobutton2

% labels


% --- Executes on button press in Lissage_pushbutton2.
function Lissage_pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to Lissage_pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% test du mode 
test_mode = getmode('BEND')

log1=get(handles.Dipfixe_radiobutton1,'Value');
log2=get(handles.Fenfixe_radiobutton2,'Value');

xdata = getappdata(handles.figure1,'xdata');
xdata2 = getappdata(handles.figure1,'xdata2');
ydatab = getappdata(handles.figure1,'ydata');
xmin = min(xdata);
xmax = max(xdata);
xmax2 = max(xdata2);
sizex = size(xdata,2);
sizex2 = size(xdata2,2);

%______________________________________________________________________
axes(handles.axes1);
hold on

% yfiltre lisse ydata bruit�
a=1;
%windowSize=round(sizex/10)
%windowSize=round(sizex/20)
windowSize = str2double(get(handles.WindowSize_edit2,'String'));

b = ones(1,windowSize)/windowSize;
yfiltre=filter(b,a,ydatab);

% yfiltre1 repositionne yfiltre au milieu de la fen�tre windowsize
yfiltre1=yfiltre(ceil(windowSize/2):sizex);

plot(...
xdata(1:size(yfiltre1,2)),yfiltre1(1:size(yfiltre1,2))); 
%xdata(1:size(yfiltre1,2)-ceil(windowSize/2)),yfiltre1(1:size(yfiltre1,2)-ceil(windowSize/2)));    
%xlim([xmin xmax]);

legend('données brutes','données lissées',2);
legend('boxoff');
grid on;

%__________________________________________________________________________
axes(handles.axes2);
hold on
% cas du dip�le fixe
if isequal(log1,1)
    
    % on d�rive les donn�es liss�es (Dfiltre)

    %D = diff(ydata)./diff(xdata);
    Dfiltre = diff(yfiltre1(1:sizex-ceil(windowSize/2)))./diff(xdata(1:sizex-ceil(windowSize/2)));
    plot(...
        xdata2(1:size(Dfiltre,2)),Dfiltre(1:size(Dfiltre,2))); 
       % xdata2(ceil(windowSize/2):sizex-ceil(windowSize/2)-1),Dfiltre(ceil(windowSize/2):sizex-ceil(windowSize/2)-1),'b');
    %xlim([xmin xmax]);
    %ylim([min(Dfiltre(ceil(windowSize/2):sizex-ceil(windowSize/2)-1) ) ...
    %    max(Dfiltre(ceil(windowSize/2):sizex-ceil(windowSize/2)-1))]);

    setappdata(handles.figure1,'Dfiltre',Dfiltre);
    
    %____________________________________________________________________
    % calcul de largeur du spectre
    Itot = max(yfiltre1);
    sizey = size(yfiltre1,2);
    Ipartielle = 0;
    j = 1;
    i = 1;
    
    while abs(Ipartielle/Itot) < 0.3173
       
        if (yfiltre1(sizey-j+1)-yfiltre1(sizey-j)) < (yfiltre1(i+1)-yfiltre1(i))
            Ipartielle = Ipartielle + (yfiltre1(sizey-j+1)-yfiltre1(sizey-j));
            j = j+1;
        else
            Ipartielle = Ipartielle + (yfiltre1(i+1)-yfiltre1(i));
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasmmf = xdata(2) - xdata(1);
    Largeurmmf = Nbpxf * pasmmf;
    
    
    [Y,I] = max(Dfiltre);
    dpsurp = 100 * LargeurMeVf / xdata2(I);
    val=sprintf('%2.2f',dpsurp);
    ResultsStr = get(handles.listbox1,'String');
    ResultsStr = {ResultsStr{:},...
        [],['Largeur du spectre  : (Epeack = ',sprintf('%2.3f',xdata2(I)),' MeV)'],...
        ['68 % des e- dans ',val,' % de Epeack']}';
    set(handles.listbox1,'String',ResultsStr);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Ipartielle = 0;
    j = 1;
    i = 1;
    
    while abs(Ipartielle/Itot) < 0.2
       
        if (yfiltre1(sizey-j+1)-yfiltre1(sizey-j)) < (yfiltre1(i+1)-yfiltre1(i))
            Ipartielle = Ipartielle + (yfiltre1(sizey-j+1)-yfiltre1(sizey-j));
            j = j+1;
        else
            Ipartielle = Ipartielle + (yfiltre1(i+1)-yfiltre1(i));
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasmmf = xdata(2) - xdata(1);
    Largeurmmf = Nbpxf * pasmmf;
    
    
    [Y,I] = max(Dfiltre);
    dpsurp = 100 * LargeurMeVf / xdata2(I);
    val=sprintf('%2.2f',dpsurp);
    ResultsStr = get(handles.listbox1,'String');
    ResultsStr = {ResultsStr{:}, ...
        ['80 % des e- dans ',val,' % de Epeack']}'  ;  
        %['Largeur � 80 % =  ',val,' %']}'
    set(handles.listbox1,'String',ResultsStr);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Ipartielle = 0;
    j = 1;
    i = 1;
    
    while abs(Ipartielle/Itot) < 0.1
       
        if (yfiltre1(sizey-j+1)-yfiltre1(sizey-j)) < (yfiltre1(i+1)-yfiltre1(i))
            Ipartielle = Ipartielle + (yfiltre1(sizey-j+1)-yfiltre1(sizey-j));
            j = j+1;
        else
            Ipartielle = Ipartielle + (yfiltre1(i+1)-yfiltre1(i));
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasmmf = xdata(2) - xdata(1);
    Largeurmmf = Nbpxf * pasmmf;
    
    
    [Y,I] = max(Dfiltre);
    dpsurp = 100 * LargeurMeVf / xdata2(I);
    val=sprintf('%2.2f',dpsurp);
    ResultsStr = get(handles.listbox1,'String');
    ResultsStr = {ResultsStr{:}, ...
        ['90 % des e- dans ',val,' % de Epeack']}';
        %['Largeur � 90 % =  ',val,' %']}'
    set(handles.listbox1,'String',ResultsStr);
    
end

% cas du dip�le fixe
if isequal(log2,1)
    
    % on �crase la donn�e Dfiltre
    setappdata(handles.figure1,'Dfiltre',[]);
    
    plot(...
    xdata2(1:size(yfiltre1,2)),yfiltre1(1:size(yfiltre1,2))); 
    %xdata(1:size(yfiltre1,2)-ceil(windowSize/2)),yfiltre1(1:size(yfiltre1,2)-ceil(windowSize/2)));    
    %xlim([xmin xmax]);

    %____________________________________________________________________
    % calcul de largeur du spectre
    %Itot = max(yfiltre1)
    
    Itot = trapz(xdata2(1:size(yfiltre1,2)),yfiltre1(1:size(yfiltre1,2)));
    
    sizey = size(yfiltre1,2);
    Ipartielle = 0;
    j = 1;
    i = 1;
    dx = xdata2(sizey) - xdata2(sizey - 1);
    
    
    while abs(Ipartielle/Itot) < 0.3173
       
        if yfiltre1(sizey-j+1) < yfiltre1(i+1)
            Ipartielle = Ipartielle + yfiltre1(sizey-j)*dx;
            j = j+1;
        else
            Ipartielle = Ipartielle + yfiltre1(i)*dx;
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasmmf = xdata(2) - xdata(1);
    Largeurmmf = Nbpxf * pasmmf;
    
    
     [Y,I] = max(yfiltre1);
     dpsurp = 100 * LargeurMeVf / xdata2(I);
     val1=sprintf('%2.2f',dpsurp);
     dpsurpcorr = sqrt(dpsurp*dpsurp - 0.5*0.5);
     val2=sprintf('%2.2f',dpsurpcorr);
     ResultsStr = get(handles.listbox1,'String');
     ResultsStr = {ResultsStr{:}, ...
         [],['Largeur corrigée du spectre lissé : (Epeack =' ,sprintf('%2.3f',xdata2(I)),' MeV)'],...
         [' 68 % des e- dans ',val2,' % de Epeack'],...
         }';
    set(handles.listbox1,'String',ResultsStr);
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ipartielle = 0;
    j = 1;
    i = 1;
    dx = xdata2(sizey) - xdata2(sizey - 1);
    
    
    while abs(Ipartielle/Itot) < 0.2
       
        if yfiltre1(sizey-j+1) < yfiltre1(i+1)
            Ipartielle = Ipartielle + yfiltre1(sizey-j)*dx;
            j = j+1;
        else
            Ipartielle = Ipartielle + yfiltre1(i)*dx;
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasmmf = xdata(2) - xdata(1);
    Largeurmmf = Nbpxf * pasmmf;
    
    
     [Y,I] = max(yfiltre1);
     dpsurp = 100 * LargeurMeVf / xdata2(I);
     val1=sprintf('%2.2f',dpsurp);
     dpsurpcorr = sqrt(dpsurp*dpsurp - 0.5*0.5);
     val2=sprintf('%2.2f',dpsurpcorr);
     ResultsStr = get(handles.listbox1,'String');
     ResultsStr = {ResultsStr{:}, ...
         [' 80 % des e- dans ',val2,' % de Epeack'],...
         }';
    set(handles.listbox1,'String',ResultsStr);
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Ipartielle = 0;
    j = 1;
    i = 1;
    dx = xdata2(sizey) - xdata2(sizey - 1);
    
    
    while abs(Ipartielle/Itot) < 0.1
       
        if yfiltre1(sizey-j+1) < yfiltre1(i+1)
            Ipartielle = Ipartielle + yfiltre1(sizey-j)*dx;
            j = j+1;
        else
            Ipartielle = Ipartielle + yfiltre1(i)*dx;
            i = i+1;
        end
        
    end
    
    ifinal = i;
    jfinal = j;
    Nbpxf = sizey - ifinal - jfinal + 2;
    %pasMeVf = xdata2(2) - xdata2(1);
    pasMeVf = (max(xdata)-min(xdata))/sizex;
    LargeurMeVf = Nbpxf * pasMeVf;
    pasmmf = xdata(2) - xdata(1);
    Largeurmmf = Nbpxf * pasmmf;
    
    
     [Y,I] = max(yfiltre1);
     dpsurp = 100 * LargeurMeVf / xdata2(I);
     val1=sprintf('%2.2f',dpsurp);
     dpsurpcorr = sqrt(dpsurp*dpsurp - 0.5*0.5);
     val2=sprintf('%2.2f',dpsurpcorr);
     ResultsStr = get(handles.listbox1,'String');
     ResultsStr = {ResultsStr{:}, ...
         [' 90 % des e- dans ',val2,' % de Epeack'],...
         }';
    set(handles.listbox1,'String',ResultsStr);
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

setappdata(handles.figure1,'yfiltre',yfiltre1);


function horodatage_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to horodatage_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of horodatage_edit1 as text
%        str2double(get(hObject,'String')) returns contents of horodatage_edit1 as a double


% --- Executes during object creation, after setting all properties.
function horodatage_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horodatage_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WindowSize_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to WindowSize_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WindowSize_edit2 as text
%        str2double(get(hObject,'String')) returns contents of WindowSize_edit2 as a double


% --- Executes during object creation, after setting all properties.
function WindowSize_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WindowSize_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sauvegarder_pushbutton6.
function sauvegarder_pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to sauvegarder_pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

log1=get(handles.Dipfixe_radiobutton1,'Value');
log2=get(handles.Fenfixe_radiobutton2,'Value');
log3=get(handles.Gap_radiobutton3,'Value')

% Determine file and directory name
FileName = '1';

%DirectoryName = '/home/PM/nadolski/controlroom/measdata/LT1data/';
DirectoryName = getfamilydata('Directory','FAEData');


TimeStamp = getappdata(handles.figure1,'Date');

% en attendant le time stamp de Florent
%TimeStamp = clock;

% Append date_Time to FileName
FileName = sprintf('%s_%s', datestr(TimeStamp,31), FileName);
FileName(11) = '_';
FileName(14) = '-';
FileName(17) = '-';

%FileName = appendtimestamp(FileName, clock);
[FileName, DirectoryName] = uiputfile('*','Save Lattice to ...', [DirectoryName FileName]);
if FileName == 0 
    fprintf('   File not saved (getmachineconfig)\n');
    return;
end

% afficher le nom du fichier
set(handles.nom_fichier_edit7,'String',FileName);

% Save all data in structure to file
DirStart = pwd;
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);  
xdata = getappdata(handles.figure1,'xdata');
ydata = getappdata(handles.figure1,'ydata');
xdata2 = getappdata(handles.figure1,'xdata2');
yfiltre = getappdata(handles.figure1,'yfiltre');
ydatamc1 = getappdata(handles.figure1,'ydatamc1');
ResultsStr = get(handles.listbox1,'String');
horodatage = get(handles.horodatage_edit1,'String');
mc1_charge =   get(handles.mc1_charge_edit5,'String');
mc1_calibre = get(handles.mc1_calibre_edit6,'String');
mc2_charge =   get(handles.mc2_charge_edit8,'String');
mc2_calibre = get(handles.mc2_calibre_edit9,'String');

try
    % cas du dip�le fixe
    if isequal(log1,1)
       Dfiltre = getappdata(handles.figure1,'Dfiltre'); 
       ydata2 = getappdata(handles.figure1,'ydata2'); 
       save(FileName, 'xdata', 'ydata','xdata2','ydata2',...
            'yfiltre','ydatamc1','Dfiltre','ResultsStr','log1','log2','log3',...
            'horodatage',...
            'mc1_charge','mc1_calibre','mc2_charge','mc2_calibre')

    elseif  isequal(log2,1)
       save(FileName, 'xdata', 'ydata','xdata2','yfiltre','ydatamc1',...
           'ResultsStr','log1','log2','log3','horodatage','mc1_charge','mc1_calibre','mc2_charge','mc2_calibre')   
       
    else
        ydata2 = getappdata(handles.figure1,'ydata2'); 
        save(FileName, 'xdata', 'ydata','xdata2','ydata2','yfiltre','ydatamc1',...
           'ResultsStr','log1','log2','log3','horodatage','mc1_charge','mc1_calibre','mc2_charge','mc2_calibre') 
    end
    
catch
    cd(DirStart);
    return
end
cd(DirStart);


% --- Executes on button press in restaurer_pushbutton7.
function restaurer_pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to restaurer_pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DirectoryName = getfamilydata('Directory','FAEData')
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
    set(handles.listbox1,'String',ResultsStr);
    set(handles.horodatage_edit1,'String',horodatage);
    set(handles.mc1_charge_edit5,'String',mc1_charge);
    set(handles.mc1_calibre_edit6,'String',mc1_calibre);
    set(handles.mc2_charge_edit8,'String',mc2_charge);
    set(handles.mc2_calibre_edit9,'String',mc2_calibre);
    setappdata(handles.figure1,'ydata',ydata);
    setappdata(handles.figure1,'xdata2',xdata2);
    setappdata(handles.figure1,'xdata',xdata);
    setappdata(handles.figure1,'ydata2',ydata2);
    set(handles.nom_fichier_edit7,'String',FileName);
    % _____________________________________________________________________
    axes(handles.axes1);
    cla
    

    %if isequal(log1,1)
    plot(xdata,ydata,'r',...
            xdata(1:size(yfiltre,2)),yfiltre(1:size(yfiltre,2)));
    %else
       % plot(xdata,ydata,'r',...
       %     xdata(1:size(yfiltre,2)),yfiltre1(1:size(yfiltre,2))); 
    %end
    
    xlim([min(xdata) max(xdata)]);
    
% %     if isequal(log1,1)
% %         xlabel('déplacement du mors en mm');
% %         ylabel('charge normalisée');
% %         title('intégrale du spectre','FontAngle','italic','FontSize',12,'FontWeight','bold');
% %         
%     elseif isequal(log2,1)
%         xlabel('courant du dipôle en A');
%         ylabel('charge normalisée');
%         title('spectre brut','FontAngle','italic','FontSize',12,'FontWeight','bold');
%     else
        xlabel('déplacement du gap en mm');
        ylabel('charge normalisée (qMC2/qMC1)');
        title('spectre brut','FontAngle','italic','FontSize',12,'FontWeight','bold');
 %%   end
    %axis tight
    
    legend('données brutes',2);
    legend('boxoff');
    grid on;
    drawnow;
    
    %______________________________________________________________________
    axes(handles.axes2);
    cla
    
    sizex = size(xdata2,2);

% %     if isequal(log2,1)
% %         set(handles.Fenfixe_radiobutton2,'Value',1);
% %         setappdata(handles.figure1,'yfiltre',yfiltre);
% %         plot(xdata2,ydata,'r',...
% %              xdata2(1:size(yfiltre,2)),yfiltre(1:size(yfiltre,2)))
% %         
% %     elseif isequal(log1,1)
% %         set(handles.Dipfixe_radiobutton1,'Value',1);
% %         setappdata(handles.figure1,'Dfiltre',Dfiltre);
% %         setappdata(handles.figure1,'ydata2',ydata2);
% %         plot(xdata2(1:sizex-1),ydata2,'r',...
% %             xdata2(1:size(Dfiltre,2)),Dfiltre(1:size(Dfiltre,2))); 
% %     else
        
        set(handles.Gap_radiobutton3,'Value',1);
        %setappdata(handles.figure1,'yfiltre',yfiltre);
        plot(xdata2,ydata2,'r',...
             xdata2(1:size(yfiltre,2)),yfiltre(1:size(yfiltre,2)))
 %%  end
    xlim([min(xdata2) max(xdata2)]);
    xlabel('Energie en MeV');
    ylabel('charge normalisée (qMC2/qMC1/MeV)');
    title('spectre','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on;
    drawnow;
    
    %______________________________________________________________________
    axes(handles.axes3);
    cla
  
    plot(xdata2(1:sizex-1),ydatamc1(1:sizex-1),'b');
    xlim([min(xdata2) max(xdata2)]);
    
    xlabel('Energie en MeV');
    ylabel('charge (nC)');
    title('mesureur de charge n°1','FontAngle','italic','FontSize',12,'FontWeight','bold');
    grid on;
    drawnow;
    
    
catch
    cd(DirStart);
    return
end
cd(DirStart);


function repositionner_edit3_Callback(hObject, eventdata, handles)
% hObject    handle to repositionner_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repositionner_edit3 as text
%        str2double(get(hObject,'String')) returns contents of repositionner_edit3 as a double


% --- Executes during object creation, after setting all properties.
function repositionner_edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repositionner_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in repositionner_pushbutton8.
function repositionner_pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to repositionner_pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% voir si l'on fait un scaling sur les quadrup�les aval � D1, de sorte �
% assurer un transport correct jusqu'� ARMO

% test si un lissage a �t� effectu�. Su oui le max est pris sur la fonction
% liss�e sinon sur les donn�es brutes
log1=get(handles.Dipfixe_radiobutton1,'Value');
log2=get(handles.Fenfixe_radiobutton2,'Value');
log3=get(handles.Gap_radiobutton3,'Value');

device_name = getappdata(handles.figure1,'device_name');
yfiltre = getappdata(handles.figure1,'yfiltre');
Dfiltre = getappdata(handles.figure1,'Dfiltre'); 
ydata2 = getappdata(handles.figure1,'ydata2');
ydata = getappdata(handles.figure1,'ydata');
xdata2 = getappdata(handles.figure1,'xdata2');
xdata = getappdata(handles.figure1,'xdata');
Imax = 0;

if isequal(log1,1)
    
    if isequal(Dfiltre,[]) & isequal(ydata2,[])
        errordlg('vous n''avez pas rentré de données !','Attention');
        return
    elseif isequal(Dfiltre,[])
        [Y,Imax] = max(ydata2);
   
    else 
        [Y,Imax] = max(Dfiltre);
    end

% balayage du dipole on souhaite replacer le dipole sur la valeur donnant
% le pic de charge
elseif isequal(log2,1)
    if isequal(yfiltre,[]) & isequal(ydata,[])
        errordlg('vous n''avez pas rentré de données !','Attention');
        return
    elseif isequal(yfiltre,[])
        [Y,Imax] = max(ydata);
    
    else 
        [Y,Imax] = max(yfiltre);
    end
    energie = xdata2(Imax);
    set(handles.repositionner_edit3,'String',num2str(energie));
    %courant = physics2hw('BEND','Setpoint',energie/1000,[1 1]);
    courant = xdata(Imax);
    offset = 0.220;
    tango_write_attribute(device_name.dipole,'current',courant+offset);

% balayage du gap on souhaite replacer le gap à la valeur 0 tout simplement !
elseif isequal(log3,1)
    if isequal(yfiltre,[]) & isequal(ydata,[])
        errordlg('vous n''avez pas rentré de données !','Attention');
        return
    else
        tango_write_attribute(device_name.fente,'Position',0)
    end
    
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%% What to do before closing the application
function Closinggui(obj, event, handles, figure1)

% Get default command line output from handles structure
answer = questdlg('Fermer Mesure de Spectre ?',...
    'Mesure de Spectre',...
    'Yes','No','Yes');

switch answer
    case 'Yes'           
        delete(handles); %Delete Timer        
        delete(figure1); %Close gui
    otherwise
        disp('Closing aborted')
end


% --- Executes on button press in zoom1_pushbutton.
function zoom1_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to zoom1_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom on


% --- Executes on button press in zoomoff_pushbutton.
function zoomoff_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomoff_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off



function mc1_charge_edit5_Callback(hObject, eventdata, handles)
% hObject    handle to mc1_charge_edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mc1_charge_edit5 as text
%        str2double(get(hObject,'String')) returns contents of mc1_charge_edit5 as a double


% --- Executes during object creation, after setting all properties.
function mc1_charge_edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mc1_charge_edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mc1_calibre_edit6_Callback(hObject, eventdata, handles)
% hObject    handle to mc1_calibre_edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mc1_calibre_edit6 as text
%        str2double(get(hObject,'String')) returns contents of mc1_calibre_edit6 as a double


% --- Executes during object creation, after setting all properties.
function mc1_calibre_edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mc1_calibre_edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nom_fichier_edit7_Callback(hObject, eventdata, handles)
% hObject    handle to nom_fichier_edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nom_fichier_edit7 as text
%        str2double(get(hObject,'String')) returns contents of nom_fichier_edit7 as a double


% --- Executes during object creation, after setting all properties.
function nom_fichier_edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nom_fichier_edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mc2_charge_edit8_Callback(hObject, eventdata, handles)
% hObject    handle to mc2_charge_edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mc2_charge_edit8 as text
%        str2double(get(hObject,'String')) returns contents of mc2_charge_edit8 as a double


% --- Executes during object creation, after setting all properties.
function mc2_charge_edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mc2_charge_edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mc2_calibre_edit9_Callback(hObject, eventdata, handles)
% hObject    handle to mc2_calibre_edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mc2_calibre_edit9 as text
%        str2double(get(hObject,'String')) returns contents of mc2_calibre_edit9 as a double


% --- Executes during object creation, after setting all properties.
function mc2_calibre_edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mc2_calibre_edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


