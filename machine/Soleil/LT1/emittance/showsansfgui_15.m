function varargout = showsansfgui_15(varargin)  % EN COURS !!!!!!
% showsansfgui_15 M-file for showsansfgui_15.fig
%      showsansfgui_15, by itself, creates a new showsansfgui_15 or raises the existing
%      singleton*.
%
%      H = showsansfgui_15 returns the handle to a new showsansfgui_15 or the handle to
%      the existing singleton*.
%
%      showsansfgui_15('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in showsansfgui_15.M with the given input arguments.
%
%      showsansfgui_15('Property','Value',...) creates a new showsansfgui_15 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before showsansfgui_15_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to showsansfgui_15_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help showsansfgui_15

% Last Modified by GUIDE v2.5 30-Aug-2004 18:40:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @showsansfgui_15_OpeningFcn, ...
                   'gui_OutputFcn',  @showsansfgui_15_OutputFcn, ...
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


% --- Executes just before showsansfgui_15 is made visible.
function showsansfgui_15_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to showsansfgui_15 (see VARARGIN)

% Choose default command line output for showsansfgui_15

% Choose default command line output for test_1
handles.output = hObject;

if iscell(varargin) && ~isempty(varargin)
    
    % store handle from caller
    handles.caller2 = varargin{1}.figure1;
    
    % Get value from Application-Defined data
%     handles.nbiterations = getappdata(handles.caller, 'nbiterations');
%     handles.nbenregistrs = getappdata(handles.caller, 'nbenregistrs');
%     %handles.Qcourant=getappdata(handles.caller,'Qcourant');
%     handles.nbenregistrements = getappdata(handles.caller, 'nbenregistrements');
%     handles.tailles = getappdata(handles.caller, 'tailles');
%     handles.ResultsData = getappdata(handles.caller, 'ResultsData');
%     handles.listbox=findobj(allchild(handles.caller),'Tag','listbox1');
%     handles.remove_pushbutton=findobj(allchild(handles.caller),'Tag','remove_pushbutton');  
%     handles.plot_pushbutton=findobj(allchild(handles.caller),'Tag','plot_pushbutton');
%     handles.restaurer_pushbutton15=findobj(allchild(handles.caller),'Tag','restaurer_pushbutton15');
%     handles.largeur_option=getappdata(handles.caller, 'largeur_option');
    handles.G=getappdata(handles.caller2, 'G');    
    handles.vect_colonne_noire=getappdata(handles.caller2, 'vect_colonne_noire');
    handles.vect_ligne_noire=getappdata(handles.caller2, 'vect_ligne_noire');
    device_name = getappdata(handles.caller2, 'device_name');
    
    % Update handles structure
    guidata(hObject, handles);

else
    
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes showsansfgui_15 wait for user response (see UIRESUME)
% uiwait(handles.main);

% d�calage du shutter de la cam�ra en microsecondes (au moins 200 ms, �
% tester !!!)
% affiche le shutter delay avant :
disp('avant changement = ')
ShutterDelayvalue = tango_command_inout(device_name.videograbber,'GetShutterDelay')
%pause(0.5);
tango_command_inout(device_name.videograbber,'SetShutterDelay',200000.);
pause(1);
disp('pendant changement = ')
tango_command_inout(device_name.videograbber,'GetShutterDelay')

%generation d'une image noire
    % rowmax=513;
    % columnmax=701;
    % p=0.2;
    % toto = p*rand(rowmax+1,columnmax+1);

device_name = getappdata(handles.caller2,'device_name');

%axes1=findobj(allchild(handles.figure1),'Tag','axes1');
%axes(handles.axes1);
dev=device_name.videograbber;

toto=tango_read_attribute(dev,'image');
%toto=tango_read_attribute(dev,'corrected_image');
image(toto.value,'CDataMapping','scaled');
image(toto.value,'CDataMapping','scaled','Parent',handles.axes1)
rowmax=size(toto.value,1);
columnmax=size(toto.value,2);

%imagesc(toto.value,'Parent',handles.axes1);
colormap(gray);    

%projections
    % sumcolumn=sum(toto(:,:));
    % sumrow=sum(toto(:,:)');
sumcolumn=sum(toto.value(:,:));
sumrow=sum(toto.value(:,:)');

%plot de l'image noire et des profils
name=['axes' num2str(1)];
axes(handles.(name)); %axis image ; 
image(toto.value,'CDataMapping','scaled')

%xdata=1:columnmax+1;
xdata=1:columnmax;
name=['axes' num2str(2)];
axes(handles.(name));
plot(xdata,sumcolumn,'k-');
xlim([0 length(sumcolumn)]);

%xdata=1:rowmax+1;
xdata=1:rowmax;
name=['axes' num2str(3)];
axes(handles.(name));
plot(xdata,sumrow,'k-');
xlim([0 length(sumrow)]);
%hold on

%hold off

setappdata(handles.caller2, 'vect_colonne_noire',sumcolumn);
setappdata(handles.caller2, 'vect_ligne_noire',sumrow);

% repositionner � la valeur de d�part le shutter de la cam�ra !!
% ???
% tango_command_inout(device_name.videograbber,'SetShutterDelay',200000.);
tango_command_inout(device_name.videograbber,'SetShutterDelay', ShutterDelayvalue);
disp('ShutterDelay remis comme avant ? = ')
tango_command_inout(device_name.videograbber,'GetShutterDelay')

% --- Outputs from this function are returned to the command line.
function varargout = showsansfgui_15_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;  % ???


% --- Executes on button press in enregistrer_pushbutton1.
function enregistrer_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to enregistrer_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

moment=datestr(now);


%   maintenant fait dans emittance_v15 !!
%         %ouvrir le dossier pour l'enregistrement des profils noires
%         prompt={'entrer un nom de r�pertoire'};
%         name='SAUVEGARDE DES PROFILS';
%         numlines=1;
%         defaultanswer={'JJMMAA_n1'};
%         options.Resize='on';
%         options.WindowStyle='normal';
%         options.Interpreter='tex';
%         val=0;
%         while isequal(val,0)
%         directory=inputdlg(prompt,name,numlines,defaultanswer,options);
%                 if ~isequal(directory,{})
%                     if ~isdir(strcat('/home/PM/tordeux/matlab_test/',directory{:}))
% 
%                         chemin=strcat('/home/PM/tordeux/matlab_test/',directory{:})
%                         %cd  /home/PM/tordeux/matlab_test/
%                         mkdir(chemin)
%                         val=1;
%                     else    
%                         button = questdlg('ce dossier existe ! voulez-vous continuer?','ATTENTION','oui','non','non')  ;
%                         if isequal(button,'oui')
%                             val=1;
%                         end
%                     end     
%                 else
%                     %avoir deja cre� une directory de secours pour si on a fait "cancel"..
%                     directory={'secours'};
%                     val=1;
%                 end
%         end
%         chemin=strcat('/home/PM/tordeux/matlab_test/',directory{:});
%         cd(chemin);
% 


% Enregistrer sur machine locale
% on associe une image de noire avec le grandissement en �m/pixel (pb du point !..)
G = getappdata(handles.caller2, 'G'); 
vect_H=getappdata(handles.caller2, 'vect_colonne_noire');
Name=strcat('vect_colonne_noire_',num2str(handles.G*1000));
save(Name,'moment', 'G','vect_H') ;

vect_V=getappdata(handles.caller2, 'vect_ligne_noire');
Name=strcat('vect_ligne_noire_',num2str(handles.G*1000));
save(Name,'moment','G', 'vect_V') ;