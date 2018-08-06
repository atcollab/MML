function BBAgui_last(arg1,arg2)

%% PARAMETRES DES PANELS:Dimensions
fontsize=12;
hradio=12;
lradio=50;
espV=10;
espH=10;
OffNone=20;

%Panels "Qi" (pour servir des paramètres)
lpanel=10*(lradio+espH/4)+OffNone+espH;
mult=1;
hpanel=mult*hradio+(mult+1)*espV+fontsize;
hpospan=hpanel+espV;

%Panel "ALL QP"
lpanQP=2*(lradio+espH);
hpanQP=2*hradio+2*espV+fontsize;

%Panel "Plane"
lpanPlane=2*(lradio+espH);
hpanPlane= hpanQP;
% checkbox: "Horizontal"
lHrz=lradio+20;
hHrz=hradio;


% checkbox: "Vertical"
lVert=lradio+10;
hVert=hradio;


%Panel "Method"
lpanMeth=2.5*(lradio+espH);
hpanMeth= hpanQP;

% checkbox: "M.E.C."
lMec=lradio+20 ;
hMec=hradio;


% checkbox: "BMP4CM"
lBmp4cm=lradio+30;
hBmp4cm=hradio;

%Figure
largeurFig=1.8*(10*(lradio+espH)+4*espH);%10*80+2*20;
hauteurFig=20*hradio+32*espV+10*fontsize+10*espV+hpanQP+espV+fontsize;

%Plot
lPlot=largeurFig-lpanel-200;
hPlot=0.4*hauteurFig;


%pour les sextu
larSp=largeurFig-lpanel-30;
HautSp=2*hpanel+espV;


% Zone de texte: Qp en cours de mesure
lQpMes1= 6.5*lradio;
hQpMes1=2*hradio;


% Zone de texte BPM: utilisé
lBpm=2*lradio+20;
hBpm=2*hradio;

% Zone de texte BPM: utilisé
lcor=2*lradio+20;
hcor=2*hradio;

% Zone de texte: Qp mesuré précedemment
lQpMes0= lBpm;
hQpMes0= hBpm;

% Zone de texte heure de la mesure précédente
lClock=5*lradio;%+2*espH;
hClock=hBpm;



%Zone de texte:valeur offset BPM
loff= 5*lradio;
hoff=2*hradio;


%Zone de texte:RMS Fit
lrms= 11*lradio;
hrms=2*hradio;

%Zone de texte:Name File
lfich=11*lradio;
hfich=2*hradio;

% Pushbutton pour lancer le BBA
lBBA=3*lradio;
hBBA=3*hradio;

lmanu=1.2*lradio;
hmanu=2*espV;

lnbCor=lradio;
hnbCor=2*espV;

lStCor=lradio;
hStCor=2*espV;

lOffCor=lradio;
hOffCor=2*espV;

lDelais=lradio;
hDelais=2*espV;

lStQp=lradio;
hStQp=2*espV;

lWhCor=lradio;
hWhCor=2*espV;


%% PARAMETRES DES PANELS: Positions

hposrad=(hpanPlane-fontsize-hradio)/2;

%Panel "ALL QP"
HposQp=10;
VposQp=hauteurFig-hpanQP-10;

%Panel "Plane"
HposPlane=lpanQP+(lpanel-lpanQP-lpanMeth)/2-lpanPlane/2;
VposPlane=hauteurFig-hpanPlane-10;

% checkbox: "Horizontal"
HHrz= 5;
VHrz=hposrad;


% checkbox: "Vertical"
HVert=5+1*(lradio+espH)+10;
VVert=hposrad;


%Panel "Method"
%HposMeth=HposPlane+espH+lpanPlane;
HposMeth=10+lpanel-lpanMeth;%HposQp+10*(lradio+espH)+OffNone-lpanMeth;
VposMeth=hauteurFig-hpanMeth-10;

% checkbox: "M.E.C."
HMec=5;
VMec=hposrad;


% checkbox: "BMP4CM"
HBmp4cm=5+1.5*(lradio+espH)-20;
VBmp4cm=hposrad;





%pour les sextu
HposSp=lpanel+20;
VposSp=VposMeth-2*espV-hpanel-hpospan;%hauteurFig-4*(hpanel+espV)


%Plot
HposPlot=lpanel+(largeurFig-lpanel)/2-lPlot/2+espH;
VposPlot=hauteurFig/2-125;

% Zone de texte Qp en cours de mesure
HQpMes1=lpanel+(largeurFig-lpanel)/2-lQpMes1/2;%+2*espH;
VQpMes1=hauteurFig-5*espV;

% Zone de texte BPM: utilisé
HBpm=lpanel+(largeurFig-lpanel)/2+espH+lcor/2;
VBpm=13*hposrad;

% Zone de texte COR: utilisé
Hcor=lpanel+(largeurFig-lpanel)/2-lcor/2;
Vcor=13*hposrad;

% Zone de texte Qp mesuré précedemment
HQpMes0=lpanel+(largeurFig-lpanel)/2-lQpMes0-espH-lcor/2;%+2*espH;
VQpMes0=VBpm;

% Zone de texte heure de la mesure précédente
HClock=lpanel+(largeurFig-lpanel)/2-lClock/2;%+lcor/2+lBpm+2*espH;%+2*espH;
VClock=VBpm+hClock+espV;

%Zone de texte:valeur offset BPM
Hoff=lpanel+(largeurFig-lpanel)/2-loff/2;
Voff=10*hposrad;

%Zone de texte:RMS Fit
Hrms=lpanel+(largeurFig-lpanel)/2-lrms/2;
Vrms=hauteurFig-6*espV-hQpMes1;

%Zone de texte:Name File
Hfich=lpanel+(largeurFig-lpanel)/2-lfich/2;
Vfich=hauteurFig-7*espV-2*hrms;

% Pushbutton pour lancer le BBA
HBBA=lpanel+(largeurFig-lpanel)/2-lBBA/2;
VBBA=50;


Hmanu=largeurFig-1.1*lradio-espV;
Vmanu=150;

HnbCor=largeurFig-lradio-espV;
VnbCor=125;


HStCor=largeurFig-lradio-espV;
VStCor=100;

HOffCor=largeurFig-lradio-espV;
VOffCor=75;

HDelais=largeurFig-lradio-espV;
VDelais=50;

HStQp=largeurFig-lradio-espV;
VStQp=25;

HWhCor1=largeurFig-3*(lradio-espV)-espV;
VWhCor1=25;

HWhCor2=largeurFig-4*(lradio-espV)-2*espV;
VWhCor2=25;
%%5+2*(lradio+espH)+10


%%5+2*(lradio+espH)+10


if nargin<1 %Créer l'IHM

    for i=1:10
        QuadFamilyList(i)=cellstr(strcat('Q',num2str(i)));
    end

    % Paramètres des éléments de l'IHM

    %% FIGURE
    figCol=[0.93,0.75,0.51];
    f = figure( 'Visible','on',...
        'Units','pixels',...
        'Position',[100,100,largeurFig,hauteurFig],...
        'HandleVisibility','on',...
        'Name','B.B.A. -> Offsets Hunting',...
        'Tag','Ola',...
        'Color',[0.93,0.75,0.51]);
    %%
    %% AXE = Plots
    Hb=axes('Parent',f);
    set(Hb,'Units','pixels');
    set(Hb,'Tag','merit_Plot');

    get(Hb,'Tag');
    %         alors=get(Hb,'Position')
    set(Hb,'Position',[HposPlot VposPlot lPlot hPlot]);

    ze=[0 0];ord2=[0 0];ord1=[0 0];
    CorCons=[0 0];BpmRes=[0 0];merit(:,1)=[0 0];merit(:,2)=[0 0];
    center=0; y1=[-1 1];x1=[-1 1];offs=0;y2=[-2 2];
    hold on
    [Bx1,Hb1,Hb2]=plotyy(Hb,ze,ord2,ze,ord1,'plot');
    set(Bx1(1),'Tag','axe_calc_bpm');
    set(Bx1(2),'Tag','axe_calc_merit');
    set(Hb1,'Tag','calc_bpm');
    set(Hb2,'Tag','calc_merit');

    set(Hb1,'Color','black','LineStyle','-.');%,'LineStyle','--')
    set(Hb2,'Color','black','LineStyle','-.');
    %set(Bx1(1),'YLim',y1);
    %set(Bx1(2),'YLim',y2);
    axis(Bx1(1),'off');
    axis(Bx1(2),'off');

    [Ax1,Ha1,Ha2]=plotyy(Hb,CorCons,BpmRes,merit(:,1),merit(:,2) ,'plot');
    set(Ax1(1),'Tag','axe_mes_bpm');
    set(Ax1(2),'Tag','axe_mes_merit');
    set(Ha1,'Tag','mes_bpm');
    set(Ha2,'Tag','mes_merit');

    set(Ha1,'Marker','x','Color','blue');%,'LineStyle','--')
    set(Ha2,'Marker','x','Color','red');

    %x1=get(Ax1(1),'XLim');
    %set(Ax1,'Visible','off');
    %set(Ax1(1),'YLim',y1);
    %set(Ax1(2),'YLim',y2);
    axis(Ax1(1),'on')
    axis(Ax1(2),'on');
    %set(Ax1(1),'YLim',y1,'YColor','blue');
    %set(Ax1(2),'YLim',y2,'YColor','red');
    set(Ax1(1),'YColor','blue');
    set(Ax1(2),'YColor','red');

    set(get(Ax1(1),'XLabel'),'String','COR Value (amps)');
    set(get(Ax1(1),'YLabel'),'String','(mm)');
    set(get(Ax1(2),'YLabel'),'String','(mm^2)');

    pl1=plot(Hb,[center center],[-1 0],'k','LineStyle','-.');
    pl2=plot(Hb,[-1 center],[offs offs],'k','LineStyle','-.');
    pl3=plot(Hb,center,offs,'ko');
    set(pl1,'Tag','loc_off1');
    set(pl2,'Tag','loc_off2');
    set(pl3,'Tag','loc_off3');
    drawnow
    hold off

    %         [Ax1,Ha1,Ha2]=plotyy(Hb,[1 3 9],[4 5 8],[4 7 12],[1 2 3])
    %         set(Ha1,'Marker','x','Color','blue');
    %         set(Ha2,'Marker','x','Color','red');
    %         hold on
    %         axis(Ax1,'off')
    %         [Bx1,Hb1,Hb2]=plotyy(Hb,[12 20 45],[4 10 -6],[0 2 41],[1 -20 3])
    %         axis(Bx1,'on')
    %         hold off


    %     f2=uipanel( 'Parent',f,'BackgroundColor',[0.93,0.75,0.51],...
    %                 'Visible','on',...
    %                 'Units','pixels',...
    %                 'Position',[0,0,lpanel+20,hauteurFig],...
    %                 'HandleVisibility','on',...
    %                 'Visible','on');


    %%
    Hdecale=lradio+espH;
    % radio bouton manuel ou auto
    radManu=uicontrol('Parent',f,...
        'BackgroundColor',[1,0,0],...
        'Style','radiobutton',...
        'String', 'Manual',...
        'Units','pixels',...
        'Callback',     'BBAgui_last(''manu'')',...
        'Tag',   'radio_manu',...
        'Value',0,...
        'Position',[Hmanu Vmanu lmanu hmanu]);

    edNbCor=uicontrol('Parent',f,...
        'BackgroundColor',[1 1 1],...
        'Style','edit',...
        'String', '13',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_nbCor',...
        'Value',0,...
        'Position',[HnbCor VnbCor lnbCor hnbCor]);

    edStepCor=uicontrol('Parent',f,...
        'BackgroundColor',[1 1 1],...
        'Style','edit',...
        'String', '0.1',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_StCor',...
        'Value',0,...
        'Position',[HStCor VStCor lStCor hStCor]);

    edOffCor=uicontrol('Parent',f,...
        'BackgroundColor',[1 1 1],...
        'Style','edit',...
        'String', '0',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_OffCor',...
        'Value',0,...
        'Position',[HOffCor VOffCor lOffCor hOffCor]);

    edDelais=uicontrol('Parent',f,...
        'BackgroundColor',[1 1 1],...
        'Style','edit',...
        'String', '4',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_Delais',...
        'Value',0,...
        'Position',[HDelais VDelais lDelais hDelais]);

    edStQp=uicontrol('Parent',f,...
        'BackgroundColor',[1 1 1],...
        'Style','edit',...
        'String', '1.75',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_StQp',...
        'Value',0,...
        'Position',[HStQp VStQp lStQp hStQp]);

    edWhCor=uicontrol('Parent',f,...
        'BackgroundColor',[1 1 1],...
        'Style','edit',...
        'String', '1',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_WhCor',...
        'Value',0,...
        'Position',[HWhCor2 VWhCor2 lStQp hStQp]);

    %%
    textNbCor=uicontrol('Parent',f,...
        'BackgroundColor',figCol,...
        'Style','text',...
        'FontSize',12,...
        'String', 'nb Cor',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'text_nbCor',...
        'Value',0,...
        'Position',[HnbCor-Hdecale VnbCor lnbCor hnbCor]);

    textStepCor=uicontrol('Parent',f,...
        'BackgroundColor',figCol,...
        'Style','text',...
        'FontSize',12,...
        'String', 'Step Cor',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'text_StCor',...
        'Value',0,...
        'Position',[HStCor-Hdecale VStCor lStCor hStCor]);

    textOffCor=uicontrol('Parent',f,...
        'BackgroundColor',figCol,...
        'Style','text',...
        'FontSize',12,...
        'String', 'Offs Cor',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'text_OffCor',...
        'Value',0,...
        'Position',[HOffCor-Hdecale VOffCor lOffCor hOffCor]);

    textDelais=uicontrol('Parent',f,...
        'BackgroundColor',figCol,...
        'Style','text',...
        'FontSize',12,...
        'String', 'Delai',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'text_Delais',...
        'Value',0,...
        'Position',[HDelais-Hdecale VDelais lDelais hDelais]);

    textStQp=uicontrol('Parent',f,...
        'BackgroundColor',figCol,...
        'Style','text',...
        'FontSize',12,...
        'String', 'Step Qp',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'text_StQp',...
        'Value',0,...
        'Position',[HStQp-Hdecale VStQp lStQp hStQp]);

    textWhCor=uicontrol('Parent',f,...
        'BackgroundColor',figCol,...
        'Style','text',...
        'FontSize',12,...
        'String', 'Choix Cor',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'text_WhCor',...
        'Value',0,...
        'Position',[HWhCor2-Hdecale-espV VWhCor2 1.2*lWhCor hWhCor]);


    %%   % PANEL pour sélectionner ou désélectionner tous les Qp
    QpCol=[0.63,0.8,0.35];

    AllQP=uipanel('Parent',f,...
        'BackgroundColor',QpCol,...%[0,0.9,0.9]
        'FontUnits','pixels',...
        'FontWeight','bold',...
        'FontSize',fontsize,...
        'Title','ALL QP',...
        'FontSize',12,...
        'Units','pixels',...
        'Position',[HposQp VposQp lpanQP hpanQP],...
        'Visible','on');


    hposrad=(hpanQP-fontsize-hradio)/2;

    % radio button 'ALL'
    radAll=uicontrol('Parent',AllQP,...
        'BackgroundColor',QpCol,...
        'Style','radiobutton',...
        'String', 'ALL',...
        'Units','pixels',...
        'Callback',      'BBAgui_last(''typeAll'')',...
        'Tag',   'radio_All',...
        'Value',0,...
        'Position',[5 hposrad lradio hradio]);

    % radio button 'None'
    radNone=uicontrol('Parent',AllQP,...
        'BackgroundColor',QpCol,...
        'Style','radiobutton',...
        'String', 'None',...
        'Units','pixels',...
        'Callback',      'BBAgui_last(''typeNone'')',...
        'Tag',   'radio_None',...
        'Value',0,...
        'Position',[5+lradio+espH/4 hposrad lradio hradio]);



    %%  % PANEL pour sélectionner le plan de BBA
    PlCol=[1,0.8,0];
    panPlane=uipanel('Parent',f,...
        'BackgroundColor',PlCol,...
        'FontUnits','pixels',...
        'FontWeight','bold',...
        'FontSize',fontsize,...
        'Title','Plane',...
        'Units','pixels',...
        'Position',[HposPlane VposPlane lpanPlane+20 hpanPlane],...
        'Visible','on');

    hposrad=(hpanPlane-fontsize-hradio)/2;
    %             radAll=uicontrol('Parent',panPlane,...%[0.2,1,0]
    %                     'BackgroundColor',PlCol,...
    %                     'Style','radiobutton',...
    %                     'String', 'Both',...
    %                     'Units','pixels',...
    %                     'Callback',      '',...
    %                     'Tag',   'radioP_All_Plane',...
    %                     'Value',0,...
    %                     'Position',[5 hposrad lradio hradio]);

    ckb_Hrz=uicontrol('Parent',panPlane,...
        'BackgroundColor',PlCol,...
        'Style','checkbox',...
        'String', 'Horizontal',...
        'Units','pixels',...
        'Callback','BBAgui_last(''check'')',...
        'Tag',  'ckboxP_Hrz',...
        'Value',0,...
        'Position',[HHrz VHrz lHrz hHrz]);

    ckb_Vert=uicontrol('Parent',panPlane,...
        'BackgroundColor',PlCol,...
        'Style','checkbox',...
        'String', 'Vertical',...
        'Units','pixels',...
        'Callback', 'BBAgui_last(''check'')',...
        'Tag',  'ckboxP_Vert',...
        'Value',0,...
        'Position',[HVert VVert lVert hVert]);

    %% % PANEL pour sélectionner la méthode de BBA

    MetCol=[0.8,0.5,0.5];
    panMeth=uipanel('Parent',f,...
        'BackgroundColor',MetCol,...%[1,0.8,0]
        'FontUnits','pixels',...
        'FontWeight','bold',...
        'FontSize',fontsize,...
        'Title','Method',...
        'FontSize',12,...
        'Units','pixels',...
        'Position',[HposMeth-10 VposMeth lpanMeth+10 hpanMeth],...
        'Visible','on');


    %            radAll_Meth=uicontrol('Parent',panMeth,...
    %                     'BackgroundColor',MetCol,...
    %                     'Style','radiobutton',...
    %                     'String', 'Both',...
    %                     'Units','pixels',...
    %                     'Callback',      '',...
    %                     'Tag',   'radioM_All_Meth',...
    %                     'Value',0,...
    %                     'Position',[5 hposrad lradio hradio]);

    ckb_mec=uicontrol('Parent',panMeth,...
        'BackgroundColor',MetCol,...
        'Style','checkbox',...
        'String', 'M.E.C.',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'ckboxM_MEC',...
        'Value',0,...
        'Position',[HMec VMec lMec hMec]);

    ckb_bmp=uicontrol('Parent',panMeth,...
        'BackgroundColor',MetCol,...
        'Style','checkbox',...
        'String', 'Bump 4 CM',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',  'ckboxM_BMP4CM',...
        'Value',0,...
        'Position',[HBmp4cm VBmp4cm lBmp4cm hBmp4cm]);



    %% Panel pour les sextupoles
    %    SpCol=[0.63,0.8,0.35];
    %    panSp=uipanel('Parent',f,...
    %        'BackgroundColor',SpCol,...%[1,0.8,0]
    %        'FontUnits','pixels',...
    %        'FontWeight','bold',...
    %        'FontSize',fontsize,...
    %        'Title','Sextu',...
    %        'FontSize',12,...
    %        'Units','pixels',...
    %        'Position',[HposSp VposSp larSp HautSp],...
    %        'Visible','on');


    %% Bouton pour lancer le BBA
    ActCol=[0.93,0.8,0.2];

    PushAction=uicontrol('Parent',f,...
        'BackgroundColor',ActCol,...
        'Style','pushbutton',...
        'String', 'ACTION',...
        'Units','pixels',...
        'Callback',      'BBAgui_last(''action'')',...
        'Tag',   'push_Act',...
        'Value',0,...
        'Position',[HBBA VBBA lBBA hBBA]);
    %% Zone de texte pour afficher le quadrupole en cours de mesure

    TxtQp1=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',[1,1,1],...
        'Style','text',...
        'FontSize',16,...
        'String','Qp [cell elt]',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_work1',...
        'Position',[HQpMes1 VQpMes1 lQpMes1 hQpMes1]);



    %% Zone de texte pour afficher le quadrupole mesuré précedemment

    TxtQp0=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',[1,1,1],...
        'Style','text',...
        'FontSize',16,...
        'String','Qp [cell elt]',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_work0',...
        'Position',[HQpMes0 VQpMes0 lQpMes0 hQpMes0]);

    %% Zone de texte pour afficher le BPM utilisé

    TxtBpm=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',[1,1,1],...
        'Style','text',...
        'FontSize',16,...
        'String', 'BPM',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_BPM',...
        'Position',[HBpm VBpm lBpm hBpm]);

    %% Zone de texte pour afficher le COR utilisé

    TxtBpm=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',[1,1,1],...
        'Style','text',...
        'FontSize',16,...
        'String', 'COR',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_COR',...
        'Position',[Hcor Vcor lcor hcor]);

    %% Zone de texte pour afficher l'heure de la mesure précédente

    TxtClock=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',figCol,...
        'Style','text',...
        'FontSize',16,...
        'String', 'Clock',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_Clock',...
        'Position',[HClock VClock lClock hClock]);

    %% Zone de texte pour afficher la valeur de l'offset BPM

    TxtOf=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',[1,1,1],...
        'Style','text',...
        'FontSize',16,...
        'FontWeight','bold',...
        'String', 'Offset BPM',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_offset',...
        'Position',[Hoff Voff loff hoff]);

    %% Zone de texte pour la qualité du FIT

    TxtFit=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',[1,1,1],...
        'Style','text',...
        'FontSize',14,...
        'FontWeight','bold',...
        'String', 'RMS Fit',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_RMS',...
        'Position',[Hrms Vrms lrms hrms]);

    %% Zone de texte pour le nom du fichier
    TxtFile=uicontrol(   'Parent',f,...%[0.2,1,0]
        'BackgroundColor',[1,1,1],...
        'Style','text',...
        'FontSize',12,...
        'FontWeight','bold',...
        'String', 'Name File',...
        'Units','pixels',...
        'Callback',      '',...
        'Tag',   'edit_File',...
        'Position',[Hfich Vfich lfich hfich]);

    %% Boucle pour créer les 160 checkbox, les 10 panels et les radiobutton associés
    incr=0;
    multpos=0;
    hpospan=0;
    for i=1:10%10
        QuadDevList=getlist(char(QuadFamilyList(i)));
        long=length(QuadDevList);
        TitleOffset=0;

        if long == 8
            mult=1;
        elseif long == 16
            mult=2;
        elseif long==24
            mult=3;
        end

        multpos=multpos+mult;

        hpanel=mult*hradio+(mult+1)*espV+fontsize;
        %lpanel=10*(lradio+espH)+OffNone;
        hpospan=hpospan+hpanel+espV;
        % 10 Panel 'Qi'
        hp(i) = uipanel('Parent',f,...
            'BackgroundColor',QpCol,...
            'FontUnits','pixels',...
            'FontWeight','bold',...
            'FontSize',fontsize,...
            'Title',char(QuadFamilyList(i)),...
            'FontSize',12,...
            'Units','pixels',...
            'Position',[10 hauteurFig-hpanQP-espV-hpospan-10 lpanel hpanel],...
            'Visible','on');

        NameQuadFamAll=['All ' char(QuadFamilyList(i))];
        NameRadioAll=['radioQ_All_' char(QuadFamilyList(i))];

        NameQuadFamNone=['None ' char(QuadFamilyList(i))];
        NameRadioNone=['radioQ_None_' char(QuadFamilyList(i))];

        hposrad=(hpanel-fontsize-hradio)/2;

        % 10 radio button pour sélectionner les Qp par familles
        radAll(i)=uicontrol('Parent',hp(i),...
            'BackgroundColor',QpCol,...
            'Style','radiobutton',...
            'String', NameQuadFamAll,...
            'Units','pixels',...
            'Callback',      'BBAgui_last(''familyAll'')',...
            'Tag',   NameRadioAll,...
            'Value',0,...
            'Position',[5 hposrad lradio+5 hradio]);

        % 10 radio button pour désélectionner par familles
        radNone(i)=uicontrol('Parent',hp(i),...
            'BackgroundColor',QpCol,...
            'Style','radiobutton',...
            'String', NameQuadFamNone,...
            'Units','pixels',...
            'Callback',      'BBAgui_last(''familyNone'')',...
            'Tag',   NameRadioNone,...
            'Value',0,...
            'Position',[5+lradio+espH/4 hposrad lradio+OffNone hradio]);

        %% Boucle des checkbox
        for j=1:length(QuadDevList)
            QuadFamTot(j+incr)=QuadFamilyList(i);
            QuadDevTot(j+incr,:)=QuadDevList(j,:);
            ValueList(j+incr)=0;


            NameQuadDev=char(['[' num2str(QuadDevList(j,1)) '_'  num2str(QuadDevList(j,2)) ']']);
            NameControl=['ckbox_' char(QuadFamilyList(i)) '_' num2str(QuadDevList(j,1)) '_'  num2str(QuadDevList(j,2))];
            if j>0 & j<=8
                valjH=j;
                valjV=1;
            elseif j>8 & j<=16
                valjH=j-8;
                valjV=2;
            elseif j>16 & j<=24
                valjH=j-16;
                valjV=3;
            end
            % N=8,16 or 24 pour sélectionner les Qp individuellement
            cont(i,j)=uicontrol('Parent',hp(i),...
                'BackgroundColor',QpCol,...
                'Style','checkbox',...
                'String', NameQuadDev,...
                'Units','pixels',...
                'Callback',   'BBAgui_last(''check'')'   ,...%'BBAgui_last(''Ncheck'')'
                'Tag',   NameControl,...
                'Value',ValueList(j+incr),...
                'Position',[(valjH+1)*(lradio+espH/4)+OffNone hpanel-(valjV)*(hradio+espV)-espV lradio hradio]);
            %'Position',[0 0-0.3*(j-1) 0.1 .1]);
        end
        %%
        incr=incr+length(QuadDevList);

    end

    delete('guy*.mat')
    save('guytrydata1.mat','QuadFamTot','QuadDevTot')
    set(f,'Visible','on');


    %% Conditions sur les checkbox "[i j]"

elseif strcmpi(arg1,'manu')  % bouton manuel/auto

    autom=findobj('Style','radiobutton','-and','-regexp','Tag','radio_manu');
    etat=get(autom,'Value');
    if etat==1
        set(autom,'Backgroundcolor',[0,1,0]);
    elseif etat==0
        set(autom,'Backgroundcolor',[1,0,0]);
    end
    %%
elseif strcmpi(arg1,'action')  % ressortir les checkbox cochees
    %delete('guytrydata2.mat')
    clear list h lista;
    % disp('ok!!')
    f=findobj('Tag','Ola');
    set(f,'Visible','on');
    h=findobj('Style','checkbox','-and','-regexp','Tag','Q');

    length(h);
    k=1;
    for i=1:length(h)
        list(i)=get(h(i),'Value');
        lista(i)=cellstr(get(h(i),'Tag'));
        IDQuad=char(lista(i));
        if list(i)==1
            indstr=findstr(IDQuad,'_');
            family(k)=cellstr(IDQuad(indstr(1)+1:indstr(2)-1));
            cellule(k)=str2num(IDQuad(indstr(2)+1:indstr(3)-1));
            element(k)=str2num(IDQuad(indstr(3)+1:length(IDQuad)));
            QpDevList(k,1)=cellule(k);
            QpDevList(k,2)=element(k);
            k=k+1;
        end

    end
    sum(list);
    list;
    lista;
    length(list);
    %connaitre la méthode utilisée
    clear list1 h1 lista1 MetList;
    f1=findobj('Tag','Ola');
    h1=findobj('Style','checkbox','-and','-regexp','Tag','ckboxM');
    MetList=cellstr('bad');
    varMet=0;
    for u=1:length(h1)
        list1(u)=get(h1(u),'Value');
        lista1(u)=cellstr(get(h1(u),'Tag'));
        IDMeth=char(lista1(u));
        if list1(u)==1
            varMet=varMet+1;
            indstr=findstr(IDMeth,'_');
            MetList(varMet)=cellstr(IDMeth(indstr+1:length(IDMeth)));
        end
    end
    if  strcmpi(char(MetList(1)),'bad');
        MetList(1,:)=cellstr('MEC');
        hp=findobj('-and','Style','checkbox','-and','-regexp','Tag','ckboxM_MEC');
        set(hp,'Value',1);
    end

    %connaitre les plans utilisés
    clear list2 h2 lista2 PlaneList0;
    f=findobj('Tag','Ola');
    h2=findobj('-and','Style','checkbox','-and','-regexp','Tag','ckboxP');
    PlaneList0=-1;
    varPl=0;
    for v=1:length(h2)
        list2(v)=get(h2(v),'Value');
        lista2(v)=cellstr(get(h2(v),'Tag'));
        IDPlane=char(lista2(v));
        if list2(v)==1
            varPl=varPl+1;
            indstr=findstr(IDPlane,'_');
            PlaneList(varPl)=IDPlane(indstr+1);
            if     PlaneList(varPl)=='H'
                PlaneList0(varPl)=1;
            elseif PlaneList(varPl)=='V'
                PlaneList0(varPl)=2;
            end
        end
    end
    %if length(PlaneList0)>1
    %    PlaneList0=0;
    if  PlaneList0(1)<0
        PlaneList0=1;
        hp=findobj('-and','Style','checkbox','-and','-regexp','Tag','ckboxP_H');
        set(hp,'Value',1);
    end

    %%
    % Lancement du programme BBA
    %Hb=findobj('Tag','merit_Plot');
    %chHb=get(gca,'Children')


    %while ~isempty(chHb)
    %chHb=get(Hb,'Children')


    %pause(1)
    %cla(chHb(1))
    %cla(chHb(2))
    % cla(chHb(3))
    % cla(chHb(4))
    % cla(chHb(5))


    %end
    %cla(Bx1(2))
    %cla(Ax1(1))
    %cla(Ax1(2))

    G1=findobj('Tag','Ola');
    child_handles = get(G1,'Children');
    %get(child_handles,'Type');
    G1=findobj('Tag','merit_Plot');
    set(G1,'NextPlot','replace');
    hold off
    pause(5)
    format long
    PlaneList0;
    MetList;
    family;
    cellule;
    element;
    QpDevList;
    longElem=size(element);
    indice=10; %indice permet de numeroter les figures
    for w=1:length(family)
        %indice=indice+1;
        for loop=1:length(PlaneList0)
            if PlaneList0(loop)==1
                TextBpm='BPMx';
                TextDel=char('Delta_X=');
                TextCor='HCOR';
            elseif PlaneList0(loop)==2
                TextDel=char('Delta_Z=');
                TextBpm='BPMz';
                TextCor='VCOR';
            end


            pause(1);
            danow= datestr(now);
            %clear Ax1 Bx1 Ha1 Ha2 Hb1 Hb2

            % écriture dans les zones de texte
            f=findobj('Style','text','-and','-regexp','Tag','edit_work1');
            TextQp1=char([char(family(w))   '  [' num2str(QpDevList(w,1)) ' ' num2str(QpDevList(w,2)) ']  @  ' danow]);
            set(f,'String',TextQp1);

            %recherche de paramètres
            %Automatisation
            autom=findobj('Style','radiobutton','-and','-regexp','Tag','radio_manu');
            etat=get(autom,'Value');
            if etat==1
                maxloop=1;
            elseif etat==0
                maxloop=2;
                nbDeltaCor=3;
                OffCor=0;
                StepCor=1.2;
                Delais=2.5;
                StepQp=2.5;
            end



            for t=1:maxloop
                autom=findobj('Style','radiobutton','-and','-regexp','Tag','radio_manu');
                etat=get(autom,'Value');
                if etat==1
                    set(autom,'Backgroundcolor',[0,1,0]);
                    ed1=findobj('Style','edit','-and','-regexp','Tag','edit_nbCor');
                    nbDeltaCor=str2num(get(ed1,'String'));

                    ed2=findobj('Style','edit','-and','-regexp','Tag','edit_StCor');
                    StepCor=str2num(get(ed2,'String'));

                    ed3=findobj('Style','edit','-and','-regexp','Tag','edit_OffCor');
                    OffCor=str2num(get(ed3,'String'));

                    ed4=findobj('Style','edit','-and','-regexp','Tag','edit_Delais');
                    Delais=str2num(get(ed4,'String'));

                    ed5=findobj('Style','edit','-and','-regexp','Tag','edit_StQp');
                    StepQp=str2num(get(ed5,'String'));

                else
                    set(autom,'Backgroundcolor',[1,0,0])
                    ed1=findobj('Style','edit','-and','-regexp','Tag','edit_nbCor');
                    TextnbDeltaCor=num2str(nbDeltaCor);
                    set(ed1,'String',TextnbDeltaCor);

                    ed2=findobj('Style','edit','-and','-regexp','Tag','edit_StCor');
                    TextStepCor=num2str(StepCor);
                    set(ed2,'String',TextStepCor);

                    ed3=findobj('Style','edit','-and','-regexp','Tag','edit_OffCor');
                    TextOffCor=num2str(OffCor);
                    set(ed3,'String',TextOffCor);

                    ed4=findobj('Style','edit','-and','-regexp','Tag','edit_Delais');
                    TextDelais=num2str(Delais);
                    set(ed4,'String',TextDelais);

                    ed5=findobj('Style','edit','-and','-regexp','Tag','edit_StQp');
                    TextStepQp=num2str(StepQp);
                    set(ed5,'String',TextStepQp);
                end
                ed6=findobj('Style','edit','-and','-regexp','Tag','edit_WhCor');
                CorNumber=str2num(get(ed6,'String'));

                %edit_WhCor

                drawnow
                [merit,CorCons,BpmRes,offs,OffsCor,center,ze,ord1,ord2,BpmDevRes,CorDevRes,iniCor,rmsFit,NameFile,NameFilePNG] = ...
                    bba_last(family(w),QpDevList(w,:), PlaneList0(loop),char(MetList),nbDeltaCor,StepCor,OffCor,Delais,StepQp,CorNumber);
                %center

                %         G1=findobj('Tag','merit_Plot');
                %         axes(G1);
                %         cla
                %         G1=findobj('Tag','Ola');

                %        load('resu.mat')
                %        trace_bba.m

                %CorCons=CorCons-iniCor;
                %CorCons=CorCons-iniCor;
                %center=center-iniCor;

                droite=polyfit(CorCons,BpmRes,1);
                %BpmDevRes=[1 5];

                TextCor1=char([TextCor ' [' num2str(CorDevRes(1,1)) '  ' num2str(CorDevRes(1,2)) ']']);
                f=findobj('Style','text','-and','-regexp','Tag','edit_COR');
                %TextOff2=char(['RMS Fit:  ' Textrms ' mm^2']);
                set(f,'String',TextCor1);

                Textrms=num2str(round(rmsFit*10000000)/10000000);
                Delta1=merit(1,2);
                Delta2=merit(length(merit),2);
                TextDelta1=num2str(round(Delta1*100000)/100000);
                TextDelta2=num2str(round(Delta2*100000)/100000);
                f=findobj('Style','text','-and','-regexp','Tag','edit_RMS');
                TextOff2=char(['RMS Fit:  ' Textrms ' mm^2 | Min: ' TextDelta1 ' mm^2 | Max: ' TextDelta2 ' mm^2']);
                set(f,'String',TextOff2);

                f=findobj('Style','text','-and','-regexp','Tag','edit_File');
                TextOff3=char([NameFile]);
                set(f,'String',TextOff3);

                f=findobj('Style','text','-and','-regexp','Tag','edit_offset');
                TextOff1=char(['Offset ' TextBpm]);
                set(f,'String',TextOff1);

                f=findobj('Style','text','-and','-regexp','Tag','edit_BPM');
                TextOff2=char([TextBpm ' [' num2str(BpmDevRes(1,1)) '  ' num2str(BpmDevRes(1,2)) ']'] );
                set(f,'String',TextOff2);

                f=findobj('Style','text','-and','-regexp','Tag','edit_work0');
                TextQp0=char([char(family(w))   '  [' num2str(QpDevList(w,1)) ' ' num2str(QpDevList(w,2)) ']']);%  @  ' danow(13:length(danow))]);
                set(f,'String',TextQp0);

                f=findobj('Style','text','-and','-regexp','Tag','edit_Clock');
                TextClock=char(danow);%  @  ' danow(13:length(danow))]);
                set(f,'String',TextClock);
                clear x1 y1 y2


                x1=[min(CorCons)-0.1-iniCor max(CorCons)+0.1-iniCor];
                deltay11=max(BpmRes)-min(BpmRes);
                y11=[min(BpmRes) max(BpmRes)];
                y12=[min(ord2) max(ord2)];
                y1=[min([y11(1) y12(1)])-0.01*deltay11 max([y11(2) y12(2)])+0.01*deltay11];

                deltay21=max(merit(:,2))-min(merit(:,2));
                y21=[min(merit(:,2)) max(merit(:,2))];
                y22=[min(ord1) max(ord1)];
                y2=[min([y21(1) y22(1)])-0.01*deltay21 max([y21(2) y22(2)])+0.01*deltay21];
                G1=findobj('Tag','Ola');%,'-and','Tag','merit_Plot')
                drawnow
                Hb=findobj('Parent',G1,'-and','Tag','merit_Plot');
                %cla(Hb)
                %hold(Hb,'off')
                %Hb=findobj('Parent',G1,'-and','Tag','merit_Plot')

                %pl3=plot(Hb,center,offs,'Marker','o','Color','black');
                %Hb=findobj('Parent',G1,'-and','Tag','merit_Plot')
                % hold(Hb,'on')
                %Hb=findobj('Parent',G1,'-and','Tag','merit_Plot')
                %Hb=axes('Parent',f)
                set(Hb,'Units','pixels');
                %hold on
                alors=get(Hb,'Position');
                %set(Hb,'Position',[900 520 550 400]);
                set(Hb,'Color','w');

                %[Bx1,Hb1,Hb2]=plotyy(Hb,ze,ord2,ze,ord1,'plot');
                Bx11=findobj('Tag','axe_calc_bpm');
                set(Bx11,'YLim',y1);
                set(Bx11,'XLim',x1);

                Bx12=findobj('Tag','axe_calc_merit');
                set(Bx12,'XLim',x1);
                set(Bx12,'YLim',y2);

                Hb1=findobj('Tag','calc_bpm');
                set(Hb1,'XData',ze-iniCor,'YData',ord2);
                Hb2=findobj('Tag','calc_merit');
                set(Hb2,'XData',ze-iniCor,'YData',ord1);


                drawnow
                G1=findobj('Tag','Ola');


                drawnow
                %        [Ax1,Ha1,Ha2]=plotyy(Hb,CorCons,BpmRes,merit(:,1),merit(:,2) ,'plot');%,'Marker','x','Color','red')
                %refreshdata(Ax1)
                Ax11=findobj('Tag','axe_mes_bpm');
                set(Ax11,'XLim',x1);
                set(Ax11,'YLim',y1);


                Ax12=findobj('Tag','axe_mes_merit');
                set(Ax12,'XLim',x1);
                set(Ax12,'YLim',y2);


                Ha1=findobj('Tag','mes_bpm');
                set(Ha1,'XData',CorCons-iniCor,'YData',BpmRes);

                Ha2=findobj('Tag','mes_merit');
                set(Ha2,'XData',merit(:,1)-iniCor,'YData',merit(:,2));

                drawnow

                ploRes1=findobj('Tag','loc_off1');
                ploRes2=findobj('Tag','loc_off2');
                ploRes3=findobj('Tag','loc_off3');
                set(ploRes1,'XData',[center-iniCor center-iniCor],'YData',[y1(1) offs]);
                set(ploRes2,'XData',[x1(1) center-iniCor],'YData',[offs offs]);
                set(ploRes3,'XData',center-iniCor,'YData',offs);
                disp(merit(:,2))
                % %         set(Ha1,'Marker','x','Color','blue');%,'LineStyle','--')
                % %         set(Ha2,'Marker','x','Color','red');
                % %
                % %         x1=get(Ax1(1),'XLim');
                % %         %set(Ax1,'Visible','off');
                %set(Ax11,'YLim',y1);
                %set(Ax12,'YLim',y2);
                %set(Ax11,'XLim',x1);
                %set(Ax12,'XLim',x1);
                %        axis(Ax11,'on')
                %       axis(Ax12,'on');
                % %         set(Ax1(1),'YLim',y1,'YColor','blue');
                % %         set(Ax1(2),'YLim',y2,'YColor','red');
                % %         if w==1
                % %             set(get(Ax1(1),'XLabel'),'String','COR Value (amps)');
                % %             set(get(Ax1(1),'YLabel'),'String','(mm)');
                % %             set(get(Ax1(2),'YLabel'),'String','(mm^2)');
                % %         end

                %pl1=plot(Hb,[center center],[y1(1) offs],'k',[x1(1) center],[offs offs],'k',center,offs,'ko','LineStyle','-.');
                %       G1=findobj('Tag','Ola');
                %   child_handles = get(G1,'Children');
                %   get(child_handles,'Type');
                %pl2=plot(Hb,[x1(1) center],[offs offs],'Color','black','LineStyle','-.');
                %pl3=plot(Hb,center,offs,'Marker','o','Color','black');%,text(center,offs,'\leftarrow ',...


                %'HorizontalAlignment','left'))
                %axis(pl1,'off');
                %axis(pl2,'off');
                %axis(pl3,'off');

                %set(pl1 ,'Color','black','LineStyle','-.');
                %set(pl2 ,'Color','black','LineStyle','-.');



                %set(pl1,'YLim',y1);
                %set(pl2,'YLim',y1);
                %set(pl3,'YLim',y1);

                %xlabel('COR Value (amps)')
                %ylabel(Bx1(1),'(mm)')
                %ylabel(Bx1(2),'(merit)')
                drawnow;
                % hold off
                pause(2)
                Hb=findobj('Tag','merit_Plot');



                drawnow
                f=findobj('Style','text','-and','-regexp','Tag','edit_offset');
                offs1=round(100000*offs)/100;
                TextOff=char([TextDel num2str(offs1) ' µm']);
                set(f,'String',TextOff);
                %plot(Hb,[4 7 12],[1 2 3])
                drawnow
                testmerit=(merit(1,2)+merit(length(merit),2));

                mult=(0.01/testmerit)^(1/4);
                DeltaCorMax=nbDeltaCor*StepCor*mult;
                nbDeltaCor=13;
                StepCor=DeltaCorMax/(nbDeltaCor-1);
                OffCor=OffsCor;
                StepQp=StepQp*mult;

                TextQp0=char([char(family(w))   '  [' num2str(QpDevList(w,1)) ' ' num2str(QpDevList(w,2)) ']']);
                disp(TextQp0)

                TextOff2=char([TextBpm ' [' num2str(BpmDevRes(1,1)) '  ' num2str(BpmDevRes(1,2)) ']'] );
                disp(TextOff2)

                TextOff=char([TextDel num2str(offs1) ' µm']);
                disp(TextOff)

                TextCor1=char([TextCor ' [' num2str(CorDevRes(1,1)) '  ' num2str(CorDevRes(1,2)) ']']);
                disp(TextCor1)

            end


        end
        %f=findobj('Tag','Ola');
        %saveas(f,NameFilePNG,'png')
    end

    %%
elseif strcmpi(arg1,'check')


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Exclusion entre checkbox=1 et None=1
    hNone=findobj('Style','radiobutton','-and','-regexp','Tag','None');
    set(hNone,'Value',0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %save('guytrydata2.mat','list','family','cellule','element');
    %axes(handles.offset);
    %axes('Position',[600 200 300 100]);


    %% Conditions sur les boutons radio "radioQ_Qi"
elseif strcmpi(arg1,'familyAll') | strcmpi(arg1,'familyNone')
    disp('c bon')
    familyType(arg1);
    BBAgui_last('check');

    %% Conditions sur le bouton radio "radio_ALL"
elseif strcmpi(arg1,'typeAll') | strcmpi(arg1,'typeNone')
    disp('c bon')
    familyType(arg1);
    whi=['family' arg1(5:length(arg1))];
    BBAgui_last(whi);

    %elseif strcmpi(arg1,'tex')

end
%%

end




%% fonction qui permet de gérer à la fois les radioboutons "radioQ_Qi" et "radio_ALL"
function familyType(tor)
%type=tor(7:length(tor))
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
tor;
strmatch('family',tor);
cas=~isempty(strmatch('family',tor));

if cas==1 %family
    prefix='radioQ_';
    type=tor(7:length(tor));
    button1='ckbox_';
    button2='';
    index=2;
    button3='_';
    style='checkbox';
else%total
    prefix='radio_';
    type=tor(5:length(tor));
    button1='radioQ_';
    button2=[type '_'];
    button3='';
    style='radiobutton';
    index=1;
end

if strcmpi(type,'All');
    type1='All';
    type0='None';
    val=1;
else
    type1='None';
    type0='All';
    val=0;
    button1='ckbox_';
    button2='';
    index=2;
    button3='_';
    style='checkbox';
end
objTagTot0=['radio_' type0];
hobjectTot0=findobj('Style','radiobutton','-and','Tag',objTagTot0);
set(hobjectTot0,'Value',val);

objTagFam1=['radioQ_' type1];
hobjectFam1=findobj('Style','radiobutton','-and','-regexp','Tag',objTagFam1);

objTagFam0=['radioQ_' type0];
hobjectFam0=findobj('Style','radiobutton','-and','-regexp','Tag',objTagFam0);
k=1;

for i=1:length(hobjectFam1)
    if cas==1
        list(i)=get(hobjectFam1(i),'Value');
    else
        list(i)=1;
    end
    lista(i)=cellstr(get(hobjectFam1(i),'Tag'));
    IDFam=char(lista(i));
    if list(i)==1
        indstr=findstr(IDFam,'Q');
        family(k)=cellstr(IDFam(indstr(2):length(IDFam)));

        TagFind=[button1 button2 char(family(k)) button3];
        TagFindRad=['radioQ_' type0 '_' char(family(k))];

        chkb=findobj('Style',style,'-and','-regexp','Tag',TagFind);
        radQ=findobj('Style','radiobutton','-and','-regexp','Tag',TagFindRad);
        set(radQ,'Value',0);
        for j=1:length(chkb)
            set(chkb(j),'Value',val);
        end
        k=k+1;
    end

end
end
% elseif strcmpi(arg1,'familyNone') %en fct des radiobuton All Qi coch�s, cocher les checkbox des familles Qi
%     f=findobj('Name','Ola');
%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Exclusion entre radioQ_Qi=1 et radio_None=1
%     hAll=findobj('Style','radiobutton','-and','Tag','radio_ALL');
%     set(hAll,'Value',0);
%     hNoneFam=findobj('Style','radiobutton','-and','-regexp','Tag','radioQ_None')
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nteger (element number) in the RING
%     hNoneFam=findobj('Style','radiobutton','-and','-regexp','Tag','radioQ_None');
%     hAllFam =findobj('Style','radiobutton','-and','-regexp','Tag','radioQ_All');
%     %hAllFam=findobj('Style','radiobutton','-and','-regexp','Tag','radioQ_All');
%     length(hAllFam);
%     k=1;
%     for i=1:length(hNoneFam)
%         list(i)=get(hNoneFam(i),'Value');
%         lista(i)=cellstr(get(hNoneFam(i),'Tag'));
%         IDFam=char(lista(i));
%         if list(i)==1
%             indstr=findstr(IDFam,'Q');
%             family(k)=cellstr(IDFam(indstr(2):length(IDFam)));
%             TagFind=['ckbox_' char(family(k)) '_'];
%             TagFindRad=['radioQ_All_' char(family(k))];
%
%             chkb=findobj('Style','checkbox','-and','-regexp','Tag',TagFind);
%             radQ=findobj('Style','radiobutton','-and','-regexp','Tag',TagFindRad);
%             %radAll=findobj('Style','radiobutton','-and','-regexp','Tag','radio_ALL');
%             %set(radAll,'Value',0);
%             set(radQ,'Value',0)
%             for j=1:length(chkb)
%                 set(chkb(j),'Value',0);
%             end
%
%             %cellule(k)=str2num(IDQuad(indstr(2)+1:indstr(3)-1));
%             %element(k)=str2num(IDQuad(indstr(3)+1:length(IDQuad)));
%             k=k+1;
%         end
%
%     end
