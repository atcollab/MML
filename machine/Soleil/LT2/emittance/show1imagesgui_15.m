function varargout = show1imagesgui_15(varargin)  % EN COURS !!!!!!
% show1imagesgui_15 M-file for show1imagesgui_15.fig
%      show1imagesgui_15, by itself, creates a new show1imagesgui_15 or raises the existing
%      singleton*.
%
%      H = show1imagesgui_15 returns the handle to a new show1imagesgui_15 or the handle to
%      the existing singleton*.
%
%      show1imagesgui_15('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in show1imagesgui_15.M with the given input arguments.
%
%      show1imagesgui_15('Property','Value',...) creates a new show1imagesgui_15 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show1imagesgui_15_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show1imagesgui_15_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show1imagesgui_15

% Last Modified by GUIDE v2.5 11-Oct-2005 18:37:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show1imagesgui_15_OpeningFcn, ...
                   'gui_OutputFcn',  @show1imagesgui_15_OutputFcn, ...
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


% --- Executes just before show1imagesgui_15 is made visible.
function show1imagesgui_15_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show1imagesgui_15 (see VARARGIN)

% Choose default command line output for show1imagesgui_15

% Choose default command line output for test_1
handles.output = hObject;

if iscell(varargin) && ~isempty(varargin)
    
    % store handle from caller
    handles.caller = varargin{1}.figure1;
    
    % Get nbiterations value from Application-Defined data
    handles.nbiterations = getappdata(handles.caller, 'nbiterations');
    handles.nbenregistrs = getappdata(handles.caller, 'nbenregistrs');
    handles.Q4courant=getappdata(handles.caller,'Q4courant');
    handles.nbenregistrements = getappdata(handles.caller, 'nbenregistrements');
    handles.tailles = getappdata(handles.caller, 'tailles');
    handles.ResultsData = getappdata(handles.caller, 'ResultsData');
    handles.listbox=findobj(allchild(handles.caller),'Tag','listbox1');
    handles.remove_pushbutton=findobj(allchild(handles.caller),'Tag','remove_pushbutton');  
    handles.plot_pushbutton=findobj(allchild(handles.caller),'Tag','plot_pushbutton');
    handles.restaurer_pushbutton15=findobj(allchild(handles.caller),'Tag','restaurer_pushbutton15');
    handles.nbacqu_edit13=findobj(allchild(handles.caller),'Tag','nbacqu_edit13');
    handles.largeur_option=getappdata(handles.caller, 'largeur_option');
    handles.vect_colonne_noire=getappdata(handles.caller, 'vect_colonne_noire');
    handles.vect_ligne_noire=getappdata(handles.caller, 'vect_ligne_noire');
    handles.G=getappdata(handles.caller, 'G');
    handles.device_name = getappdata(handles.caller, 'device_name');
    setappdata(handles.caller,'selection_fenetre_H',num2str(0));
    setappdata(handles.caller,'selection_fenetre_V',num2str(0));
    setappdata(handles.caller,'Rabotage',num2str(0));
    set(handles.rayon_fenetre_H_edit16,'String',num2str(1));
    set(handles.rayon_fenetre_V_edit17,'String',num2str(1));
    
    % button group sur squeeze du vecteur sumcolomn
% h = uibuttongroup('visible','off','Position',[0.05 .9 .12 .08],...
%     'Title','Image','TitlePosition','centertop');
% u1 = uicontrol('Style','Radio','String','ON','Tag','radiobutton1',...
%     'pos',[2 .9 45 30],'parent',h,'HandleVisibility','off');
% u2 = uicontrol('Style','Radio','String','OFF','Tag','radiobutton2',...
%     'pos',[50 .9 45 30],'parent',h,'HandleVisibility','off');
h = uibuttongroup('visible','off');
u1 = uicontrol('Style','Radio','String','ON','Tag','radiobutton1',...
    'pos',[35. 28. 45 30],'parent',h,'HandleVisibility','off');
u2 = uicontrol('Style','Radio','String','OFF','Tag','radiobutton2',...
     'pos',[75. 28. 45 30],'parent',h,'HandleVisibility','off');
set(h,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn,handles});
set(h,'SelectedObject',u2);  % No selection
set(h,'Visible','on');

v = uibuttongroup('visible','off');
v1 = uicontrol('Style','Radio','String','ON','Tag','radiobutton1',...
    'pos',[440. 390. 45 30],'parent',v,'HandleVisibility','off');
v2 = uicontrol('Style','Radio','String','OFF','Tag','radiobutton2',...
     'pos',[440. 360. 45 30],'parent',v,'HandleVisibility','off');
set(v,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn_V,handles});
set(v,'SelectedObject',v2);  % No selection
set(v,'Visible','on');

r = uibuttongroup('visible','off');
r1 = uicontrol('Style','Radio','String','ON','Tag','radiobutton1',...
    'pos',[400. 28. 45 30],'parent',r,'HandleVisibility','off');
r2 = uicontrol('Style','Radio','String','OFF','Tag','radiobutton2',...
     'pos',[440. 28. 45 30],'parent',r,'HandleVisibility','off');
set(r,'SelectionChangeFcn',...
    {@uibuttongroup_SelectionChangeFcn_R,handles});
set(r,'SelectedObject',r2);  % No selection
set(r,'Visible','on');



    % Update handles structure
    guidata(hObject, handles);

else
    
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show1imagesgui_15 wait for user response (see UIRESUME)
% uiwait(handles.main);

%______________________________________________________________________
% profil horizontal
handles.vect_colonne_noire=getappdata(handles.caller, 'vect_colonne_noire');

   
name=['axes' num2str(1)];
axes(handles.(name)); %axis image ; 

%formation d'une image

    %toto=faisceau(rowmax,columnmax,rowmax/10,columnmax/5,rowmax/2,columnmax/2,20);

device_name = getappdata(handles.caller,'device_name');

%axes1=findobj(allchild(handles.figure1),'Tag','axes1');
%axes(handles.axes1);
dev=device_name.videograbber;

%toto=tango_read_attribute(dev,'image');
toto=tango_read_attribute(dev,'corrected_image');
%image(toto.value,'CDataMapping','scaled');
image(toto.value,'CDataMapping','scaled','Parent',handles.axes1)
rowmax=size(toto.value,1);
columnmax=size(toto.value,2);

%imagesc(toto.value,'Parent',handles.axes1);
colormap(gray);    

% calcul des projections
sumcolumn=sum(toto.value(:,:));
%sauvegarde du profil horizontal brut
setappdata(handles.caller, 'profil_H',sumcolumn);


% test si on a bien cree une image dans faisceau
if isequal(size(sumcolumn),size(handles.vect_colonne_noire))
    % on soustraie l'image sans faisceau
    sumcolumn=sumcolumn-handles.vect_colonne_noire;
else
    errordlg('vous n avez pas fait d''image sans faisceau','Error');
end

% seul souci : les pixels rendus n�gatifs dans l'op�ration pr�cedente. On
% les passe sauvagement � 0 !
for i=1:length(sumcolumn)
    if sumcolumn(i)<0 
        sumcolumn(i)=0;
    end
end


handles.largeur_option=getappdata(handles.caller, 'largeur_option');

% cas o� aucune option de calcul pour la largeur n'a �t� s�lectionn�
if isequal(handles.largeur_option,0)
    errordlg('vous n avez pas fait votre choix pour la taille de faisceau','Error');
end

% fit par gaussienne
if isequal(handles.largeur_option,1)
    
    %xdata=1:columnmax+1;
    xdata=1:columnmax;
    ValMaxc=max(sumcolumn);ValMinc=min(sumcolumn);
    x0=[10 250 ValMaxc];
    % option on enl�ve min :
    %[ac,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumcolumn-ValMinc)
    % option : on enl�ve l'image noire (fait pr�c�demment) :
    [ac,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumcolumn);
    rmsH=ac(1);
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsH*grossissement);
    val=sprintf('%0.2f',rmsH*handles.G)
    % impression du rayon en mm
    set(handles.rmsH_edit11,'String',val);
    sumHstd=0;

    %plot du r�sultat
    %F=ac(3)*exp(-(xdata-ac(2)).*(xdata-ac(2))/(2*ac(1)*ac(1)))+ValMinc;
    F=ac(3)*exp(-(xdata-ac(2)).*(xdata-ac(2))/(2*ac(1)*ac(1)));
    name=['axes' num2str(2)];
    axes(handles.(name));
    plot(xdata,sumcolumn,'k-');
    xlim([0 length(sumcolumn)])
    hold on
    plot(xdata,F,'b-')
    hold off

end


% vrai rms
if isequal(handles.largeur_option,2)
    
    ValMaxc=max(sumcolumn);ValMinc=min(sumcolumn);
    sumcolumn=sumcolumn-ValMinc;
    vect=1:length(sumcolumn);
    sumcolumn1=sumcolumn/sum(sumcolumn);
    smoy=sum(sumcolumn1.*vect);
    tata=(vect-smoy).*(vect-smoy);
    srms=sum(sumcolumn1.*tata);
    rmsH=sqrt(srms);
    
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsH*grossissement);
    
    val=sprintf('%0.2f',rmsH*handles.G);
    % impression du rayon en mm
    set(handles.rmsH_edit11,'String',val);
    
    %plot du r�sultat
    xdata=1:columnmax;
    name=['axes' num2str(2)];
    axes(handles.(name));
    plot(xdata,sumcolumn+ValMinc,'k-');
    xlim([0 length(sumcolumn)])
    hold on
    %plot(xdata,F,'b-')
    hold off

end

% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% profil vertical
handles.vect_ligne_noire=getappdata(handles.caller, 'vect_ligne_noire');

   
name=['axes' num2str(1)];
axes(handles.(name)); %axis image ; 

%     %formation d'une image
%     rowmax=513;
%     columnmax=701;
%     toto=faisceau(rowmax,columnmax,rowmax/10,columnmax/5,rowmax/2,columnmax/2,20);
% calcul des projections
sumrow=sum(toto.value(:,:)');
%sauvegarde du profil horizontal brut
setappdata(handles.caller, 'profil_V',sumrow);


% test si on a bien cree une image dans faisceau  
if isequal(size(sumrow),size(handles.vect_ligne_noire))
    % on soustraie l'image sans faisceau
    sumrow=sumrow-handles.vect_ligne_noire;
else
    % a priori inutile (alarme d�j� lev�e en horizontal)  errordlg('vous n avez pas fait d image sans faisceau','Error');
end

% seul souci : les pixels rendus n�gatifs dans l'op�ration pr�cedente. On
% les passe sauvagement � 0 !
for i=1:length(sumrow)
    if sumrow(i)<0 
        sumrow(i)=0;
    end
end


%     handles.largeur_option=getappdata(handles.caller, 'largeur_option');

% fit par gaussienne
if isequal(handles.largeur_option,1)
    
    %xdata=1:rowmax+1;
    xdata=1:rowmax;
    ValMaxr=max(sumrow);ValMinr=min(sumrow);
    x0=[10 250 ValMaxr];
    % option on enl�ve min :
    %[ac,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumcolumn-ValMinc)
    % option : on enl�ve l'image noire (fait pr�c�demment) :
    [ar,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumrow);
    rmsV=ar(1);
    
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsV*grossissement);
    
    val=sprintf('%0.2f',rmsV*handles.G);
    % impression du rayon en mm
    set(handles.rmsV_edit12,'String',val);
    sumVstd=0;

    %plot du r�sultat
    %F=ac(3)*exp(-(xdata-ac(2)).*(xdata-ac(2))/(2*ac(1)*ac(1)))+ValMinc;
    Fr=ar(3)*exp(-(xdata-ar(2)).*(xdata-ar(2))/(2*ar(1)*ar(1)));
    name=['axes' num2str(3)];
    axes(handles.(name));
    plot(xdata,sumrow,'k-');
    xlim([0 length(sumrow)])
    hold on
    plot(xdata,Fr,'b-')
    hold off

end


% vrai rms
if isequal(handles.largeur_option,2)
    
    ValMaxr=max(sumrow);ValMinr=min(sumrow);
    sumrow=sumrow-ValMinr;
    vect=1:length(sumrow);
    sumrow1=sumrow/sum(sumrow);
    smoy=sum(sumrow1.*vect);
    toto=(vect-smoy).*(vect-smoy);
    srms=sum(sumrow1.*toto);
    rmsV=sqrt(srms);
    
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsV*grossissement);
    
    val=sprintf('%0.2f',rmsV*handles.G);
    % impression du rayon en mm
    set(handles.rmsV_edit12,'String',val);
    
    %plot du r�sultat
    xdata=1:rowmax;
    name=['axes' num2str(3)];
    axes(handles.(name));
    plot(xdata,sumrow+ValMinr,'k-');
    xlim([0 length(sumrow)])
    hold on
    %plot(xdata,F,'b-')
    hold off

end

%_______________________________________________________________

% 
% 
% 
%     rowmax=80;
%     columnmax=100;
%     B=[];
% 
%     %for i=1:handles.nbiterations
%     for i=1:1  
%         name=['axes' num2str(i)];
%         axes(handles.(name)); %axis image ;  
%         faisceau(513,701,120,50,-150,50,10);
%         B(i,:,:) = rand(rowmax,columnmax);
%         sumcolumn=sum(squeeze(B(i,:,:)));sumrow=sum(squeeze(B(i,:,:))');
%         sumV(i)=sum(sumcolumn);sumH(i)=sum(sumrow);
%     % 	axes(handles.(name)); %axis image ;    
%     % 	ima(i)=image(squeeze(B(i,:,:)),'CDataMapping','scaled'); 
%     end
% 
%     sumHmean=mean(sumH);sumVmean=mean(sumV);sumHstd=std(sumH);sumVstd=std(sumV);
% 
%     set(handles.rmsH_edit11,'String',sumHmean);
%     sumHstd=0;
% 
%     set(handles.rmsV_edit12,'String',sumVmean);
% 
%     sumVstd=0;

% --- Outputs from this function are returned to the command line.
function varargout = show1imagesgui_15_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;  % ???

% --- Executes on button press in pushbutton1.
function recommencer_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.vect_colonne_noire=getappdata(handles.caller, 'vect_colonne_noire');
selection_fenetre_H = getappdata(handles.caller,'selection_fenetre_H');
selection_fenetre_V = getappdata(handles.caller,'selection_fenetre_V');
Rabotage = getappdata(handles.caller,'Rabotage')

name=['axes' num2str(1)];
axes(handles.(name)); %axis image ; 

%formation d'une image
device_name = getappdata(handles.caller,'device_name');
dev=device_name.videograbber;
%toto=tango_read_attribute(dev,'image');
toto=tango_read_attribute(dev,'corrected_image');
image(toto.value,'CDataMapping','scaled','Parent',handles.axes1)
rowmax=size(toto.value,1);
columnmax=size(toto.value,2);
colormap(gray);    

% calcul des projections
sumcolumn=sum(toto.value(:,:));
%sauvegarde du profil horizontal brut
setappdata(handles.caller, 'profil_H',sumcolumn);


% test si on a bien cree une image dans faisceau
if isequal(size(sumcolumn),size(handles.vect_colonne_noire))
    % on soustraie l'image sans faisceau
    %sumcolumn=sumcolumn-handles.vect_colonne_noire;
else
    errordlg('vous n avez pas fait d''image sans faisceau','Error');
end

% seul souci : les pixels rendus n�gatifs dans l'op�ration pr�cedente. On
% les passe sauvagement � 0 !
for i=1:length(sumcolumn)
    if sumcolumn(i)<0 
        sumcolumn(i)=0;
    end
end


handles.largeur_option=getappdata(handles.caller, 'largeur_option');

% cas o� aucune option de calcul pour la largeur n'a �t� s�lectionn�
if isequal(handles.largeur_option,0)
    errordlg('vous n avez pas fait votre choix pour la taille de faisceau','Error');
end


% fit par gaussienne
if isequal(handles.largeur_option,1)
    
    xdata=1:columnmax;
    ValMaxc=max(sumcolumn);ValMinc=min(sumcolumn);
    x0=[10 250 ValMaxc];
    % option on enl�ve min :
    %[ac,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumcolumn-ValMinc)
    % option : on enl�ve l'image noire (fait pr�c�demment) :
    [ac,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumcolumn);
    rmsH=ac(1);
    
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsH*grossissement);
    
    val=sprintf('%0.2f',rmsH*handles.G);
    % impression du rayon en mm
    set(handles.rmsH_edit11,'String',val);
    sumHstd=0;

    %plot du r�sultat
    %F=ac(3)*exp(-(xdata-ac(2)).*(xdata-ac(2))/(2*ac(1)*ac(1)))+ValMinc;
    F=ac(3)*exp(-(xdata-ac(2)).*(xdata-ac(2))/(2*ac(1)*ac(1)));
    name=['axes' num2str(2)];
    axes(handles.(name));
    plot(xdata,sumcolumn,'k-');
    xlim([0 length(sumcolumn)])
    hold on
    plot(xdata,F,'b-')
    hold off

end


% vrai rms
if isequal(handles.largeur_option,2)

    % test !
%Z = load('-mat','/home/matlabML/measdata/LT1data/emittance/2005-10-10_4/profilH_2_38.mat');
%Z = load('-mat','/home/matlabML/measdata/LT1data/emittance/2005-09-23_1/profilH_3_38.mat');
% Z = load('-mat','/home/matlabML/measdata/LT1data/emittance/2005-10-10_4/profilH_3_38.mat');
% sumcolumn = Z.vect_H;
    
    if isequal(Rabotage,num2str(1))&isequal(selection_fenetre_H,num2str(1))
        errordlg('Attention deselectionnez une option !! ...','Error'); 
    elseif isequal(Rabotage,num2str(1))
        [Y,I] = max(sumcolumn);
        sumcolumn = sumcolumn - Y*0.01;
        for i = 1 : length(sumcolumn)   
            if sumcolumn(i)<0
                sumcolumn(i) = 0;
            end
        end
    elseif isequal(selection_fenetre_H,num2str(1))
         res= get(handles.rayon_fenetre_H_edit16,'String');
         rayon_fenetre_H = str2num(res);
         rayon_pixel_H = rayon_fenetre_H/handles.G;
         [Y,I] = max(sumcolumn);
         sumcolumn = sumcolumn(I-rayon_pixel_H : I+rayon_pixel_H);
         %sumcolumn = sumcolumn(640/2-rayon_pixel_H : 640/2+rayon_pixel_H);
    end
    
    ValMaxc=max(sumcolumn);ValMinc=min(sumcolumn);
    sumcolumn=sumcolumn-ValMinc;
    vect=1:length(sumcolumn);
    sumcolumn1=sumcolumn/sum(sumcolumn);
    smoy=sum(sumcolumn1.*vect);
    titi=(vect-smoy).*(vect-smoy);
    srms=sum(sumcolumn1.*titi);
    rmsH=sqrt(srms);
    
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsH*grossissement);
    
    val=sprintf('%0.2f',rmsH*handles.G);
    % impression du rayon en mm
    set(handles.rmsH_edit11,'String',val);
    
    %plot du r�sultat
    columnmax=size(sumcolumn,2);
    xdata=1:columnmax;
    name=['axes' num2str(2)];
    axes(handles.(name));
    plot(xdata,sumcolumn+ValMinc,'k-');
    xlim([0 length(sumcolumn)])
    hold on
    %plot(xdata,F,'b-')
    hold off

end

% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

handles.vect_ligne_noire=getappdata(handles.caller, 'vect_ligne_noire');

   
name=['axes' num2str(1)];
axes(handles.(name)); %axis image ; 

%     %formation d'une image
%     rowmax=513;
%     columnmax=701;
%     toto=faisceau(rowmax,columnmax,rowmax/10,columnmax/5,rowmax/2,columnmax/2,20);
% calcul des projections
sumrow=sum(toto.value(:,:)');
%sauvegarde du profil horizontal brut
setappdata(handles.caller, 'profil_V',sumrow);


% test si on a bien cree une image dans faisceau
if isequal(size(sumrow),size(handles.vect_ligne_noire))
    % on soustraie l'image sans faisceau
    %sumrow=sumrow-handles.vect_ligne_noire;
else
    errordlg('vous n avez pas fait d image sans faisceau','Error');
end

% seul souci : les pixels rendus n�gatifs dans l'op�ration pr�cedente. On
% les passe sauvagement � 0 !
for i=1:length(sumrow)
    if sumrow(i)<0 
        sumrow(i)=0;
    end
end


%     handles.largeur_option=getappdata(handles.caller, 'largeur_option');

% fit par gaussienne
if isequal(handles.largeur_option,1)
    
    xdata=1:rowmax;
    ValMaxr=max(sumrow);ValMinr=min(sumrow);
    x0=[10 250 ValMaxr];
    % option on enl�ve min :
    %[ac,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumcolumn-ValMinc)
    % option : on enl�ve l'image noire (fait pr�c�demment) :
    [ar,resnorm] = lsqcurvefit(@myfun_gaussienne,x0,xdata,sumrow);
    rmsV=ar(1);
    
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsV*grossissement);
    
    val=sprintf('%0.2f',rmsV*handles.G);
    % impression du rayon en mm
    set(handles.rmsV_edit12,'String',val);
    sumVstd=0;

    %plot du r�sultat
    %F=ac(3)*exp(-(xdata-ac(2)).*(xdata-ac(2))/(2*ac(1)*ac(1)))+ValMinc;
    Fr=ar(3)*exp(-(xdata-ar(2)).*(xdata-ar(2))/(2*ar(1)*ar(1)));
    name=['axes' num2str(3)];
    axes(handles.(name));
    plot(xdata,sumrow,'k-');
    xlim([0 length(sumrow)])
    hold on
    plot(xdata,Fr,'b-')
    hold off

end


% vrai rms
if isequal(handles.largeur_option,2)

        % test !
%ZV = load('-mat','/home/matlabML/measdata/LT1data/emittance/2005-10-10_4/profilV_2_38.mat');
% ZV = load('-mat','/home/matlabML/measdata/LT1data/emittance/2005-10-10_4/profilV_3_38.mat');
% sumrow = ZV.vect_V;

    if isequal(Rabotage,num2str(1))&isequal(selection_fenetre_H,num2str(1))
        errordlg('Attention deselectionnez une option !! ...','Error'); 
    elseif isequal(Rabotage,num2str(1))
        [Y,I] = max(sumrow);
        sumrow = sumrow - Y*0.01;
        for i = 1 : length(sumrow)   
            if sumrow(i)<0
                sumrow(i) = 0;
            end
        end 
    elseif isequal(selection_fenetre_V,num2str(1))
         res= get(handles.rayon_fenetre_V_edit17,'String');
         rayon_fenetre_V = str2num(res);
         rayon_pixel_V = rayon_fenetre_V/handles.G;
         [Y,I] = max(sumrow)
         %sumrow = sumrow(480/2-rayon_pixel_V : 480/2+rayon_pixel_V);
         sumrow = sumrow(I-rayon_pixel_V : I+rayon_pixel_V);
    end
    
    
    ValMaxr=max(sumrow);ValMinr=min(sumrow);
    sumrow=sumrow-ValMinr;
    vect=1:length(sumrow);
    sumrow1=sumrow/sum(sumrow);
    smoy=sum(sumrow1.*vect);
    toto=(vect-smoy).*(vect-smoy);
    srms=sum(sumrow1.*toto);
    rmsV=sqrt(srms);
    
    %grossissement= str2num(handles.G);
    %val=sprintf('%0.2f',rmsV*grossissement);
    
    val=sprintf('%0.2f',rmsV*handles.G);
    % impression du rayon en mm
    set(handles.rmsV_edit12,'String',val);
    
    %plot du r�sultat
    rowmax = length(sumrow);
    xdata=1:rowmax;
    name=['axes' num2str(3)];
    axes(handles.(name));
    plot(xdata,sumrow+ValMinr,'k-');
    xlim([0 length(sumrow)])
    hold on
    %plot(xdata,F,'b-')
    hold off

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


% --- Executes during object creation, after setting all properties.
function rmsH_edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmsH_edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rmsH_edit11_Callback(hObject, eventdata, handles)
% hObject    handle to rmsH_edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmsH_edit11 as text
%        str2double(get(hObject,'String')) returns contents of rmsH_edit11 as a double


% --- Executes during object creation, after setting all properties.
function rmsV_edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmsV_edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rmsV_edit12_Callback(hObject, eventdata, handles)
% hObject    handle to rmsV_edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmsV_edit12 as text
%        str2double(get(hObject,'String')) returns contents of rmsV_edit12 as a double


% ------------------------------------------------------------
% Callback for the Store push button
% ------------------------------------------------------------
% --- Executes on button press in enregistrer_pushbutton.
function enregistrer_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to enregistrer_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%handles.nbenregistrs=handles.nbenregistrs + 1;

LargH=str2num(get(handles.rmsH_edit11,'String'));
LargV=str2num(get(handles.rmsV_edit12,'String'));
%%sigH=str2num(get(handles.edit13,'String'));
%%sigV=str2num(get(handles.edit14,'String'));
sigH=0;
sigV=0;


%handles.tailles=[ handles.tailles ; LargH sigH LargV sigV ]
handles.tailles=[  LargH sigH LargV sigV ];
setappdata(handles.caller,'tailles',handles.tailles);

guidata(hObject, handles);

% Retrieve old results data structure
handles.ResultsData = getappdata(handles.caller,'ResultsData');
%handles.nbenregistrements
if isfield(handles,'ResultsData') & ~isempty(handles.ResultsData)
	ResultsData = handles.ResultsData;
	% Determine the maximum run number currently used.
	maxNum = ResultsData(length(ResultsData)).RunNumber;
	ResultNum = maxNum+1;
    ik =length(ResultsData);
else, % Set up the results data structure
%    ResultsData = struct('nbenregistrs',[],'LargeurH',[],...
    ResultsData = struct('RunName',[],'RunNumber',[],'LargeurH',[],...
        'sigmaH',[],'LargeurV',[],...
		'sigmaV',[],'Q4courant',[],...
        'G',[],'option_L',[],'date','');
	ResultNum = 1;
    ik = 0;
end

if isequal(ResultNum,1),
	%--Enable the Plot and Remove buttons
	set([handles.remove_pushbutton,handles.plot_pushbutton,...
        handles.restaurer_pushbutton15],'Enable','on') ;
%     %ouvrir le dossier pour l'enregistrement des profils
%    prompt={'entrer un nom de r�pertoire'};
%    name='SAUVEGARDE DES PROFILS';
%    numlines=1;
%    defaultanswer={'JJMMAA_n1'};
%    options.Resize='on';
%    options.WindowStyle='normal';
%    options.Interpreter='tex';
%    val=0;
%     while isequal(val,0)
%     directory=inputdlg(prompt,name,numlines,defaultanswer,options);
%         if ~isequal(directory,{})
%             if ~isdir(strcat('/home/PM/tordeux/matlab_test/',directory{:}))
%                 mkdir /home/PM/tordeux/matlab_test/directory;
%                 val=1;
%             else    
%                 button = questdlg('ce dossier existe ! voulez-vous continuer?','ATTENTION','oui','non','non') ; 
%                 if isequal(button,'oui')
%                     val=1;
%                 end
%             end     
%         else
%             %avoir deja cre� une directory de secours pour si on a fait "cancel"..
%             directory={'secours'};
%             val=1;
%         end
%     end
%    chemin=strcat('/home/PM/tordeux/matlab_test/',directory{:});
%    cd(chemin);
end

w=getappdata(handles.caller,'tailles');
handles.Q4courant=getappdata(handles.caller,'Q4courant');
handles.G=getappdata(handles.caller,'G');
handles.largeur_option=getappdata(handles.caller, 'largeur_option');
moment=datestr(now);

ik = ik + 1;
ResultsData(ik).RunName = ['Point ',num2str(ResultNum)];
ResultsData(ik).RunNumber = ResultNum;
ResultsData(ik).LargeurH = w(1);
ResultsData(ik).sigmaH = w(2);
ResultsData(ik).LargeurV = w(3);
ResultsData(ik).sigmaV = w(4);
ResultsData(ik).Q4courant = handles.Q4courant;
ResultsData(ik).G =handles.G;
ResultsData(ik).option_L =handles.largeur_option;
ResultsData(ik).date=moment;

% Build the new results list string for the listbox
ResultsStr = get(handles.listbox,'String');
Qcour=handles.Q4courant;
i1=sprintf(' %9.2f \n',Qcour);
i2=sprintf(' %9.2f \n',w(1));
i3=sprintf(' %9.2f \n',w(2));
i4=sprintf(' %9.2f \n',w(3));
i5=sprintf(' %9.2f \n',w(4));
i6=sprintf(' %9.3f \n',handles.G);
i7=sprintf(' %4.0f \n',handles.largeur_option);


if isequal(ResultNum,1)
	ResultsStr = {['Point 1',...
        i1,i2,i3,i4,i5,i6,i7,'  ',moment]};
%         num2str(Qcour),'     ',num2str(w(1)),'     ',num2str(w(2)),...
%         '    ',num2str(w(3)),'     ',num2str(w(4)),...
%         '     ',num2str(handles.G),'     ',num2str(handles.largeur_option),'     ',moment...
%         ]};
else
	
    ResultsStr = [ResultsStr; {['Point ',num2str(ResultNum),...
        i1,i2,i3,i4,i5,i6,i7,'  ',moment]}];
end
set(handles.listbox,'String',ResultsStr);
set(handles.listbox,'Value',size(ResultsStr,1));


% Store the new ResultsData
handles.ResultsData = ResultsData;
setappdata(handles.caller,'ResultsData',ResultsData);
set(handles.nbacqu_edit13,'String', num2str(size(ResultsStr,1)));


guidata(hObject, handles);


% Enregistrer sur machine locale
G=getappdata(handles.caller,'G');
vect_H=getappdata(handles.caller, 'profil_H');
Name=strcat('profilH_',num2str(ResultNum),'_',num2str(handles.G*1000));
save(Name,'moment', 'G','vect_H') ;

vect_V=getappdata(handles.caller, 'profil_V');
Name=strcat('profilV_',num2str(ResultNum),'_',num2str(handles.G*1000));
save(Name,'moment', 'G','vect_V') ;

%eval(['save ',strcat('profilH_',num2str(ResultNum)),  moment vect_H]) ;

%function pushbutton2_Callback(hObject, eventdata, handles)
%% NE FAIT RIEN



function rayon_fenetre_H_edit16_Callback(hObject, eventdata, handles)
% hObject    handle to rayon_fenetre_H_edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rayon_fenetre_H_edit16 as text
%        str2double(get(hObject,'String')) returns contents of rayon_fenetre_H_edit16 as a double


% --- Executes during object creation, after setting all properties.
function rayon_fenetre_H_edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rayon_fenetre_H_edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rayon_fenetre_V_edit17_Callback(hObject, eventdata, handles)
% hObject    handle to rayon_fenetre_V_edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rayon_fenetre_V_edit17 as text
%        str2double(get(hObject,'String')) returns contents of rayon_fenetre_V_edit17 as a double


% --- Executes during object creation, after setting all properties.
function rayon_fenetre_V_edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rayon_fenetre_V_edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uibuttongroup_SelectionChangeFcn(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here
        disp('selection d''une fenetre <-')
        setappdata(handles.caller,'selection_fenetre_H',num2str(1));
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        disp('arret selection de fenetre ->')
        setappdata(handles.caller,'selection_fenetre_H',num2str(0));
end

function uibuttongroup_SelectionChangeFcn_V(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here
        disp('selection d''une fenetre <-')
        setappdata(handles.caller,'selection_fenetre_V',num2str(1));
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        disp('arret selection de fenetre ->')
        setappdata(handles.caller,'selection_fenetre_V',num2str(0));
end


function uibuttongroup_SelectionChangeFcn_R(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(get(hObject,'SelectedObject'),'Tag')  % Get Tag of selected object
    case 'radiobutton1'
        % code piece when radiobutton1 is selected goes here
        disp('Rabotage à 1% <-')
        setappdata(handles.caller,'Rabotage',num2str(1));
    case 'radiobutton2'
        % code piece when radiobutton2 is selected goes here 
        disp('Rabotage à 1% ->')
        setappdata(handles.caller,'Rabotage',num2str(0));
end