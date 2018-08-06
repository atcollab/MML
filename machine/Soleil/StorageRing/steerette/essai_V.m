function varargout = essai_V(varargin)
% ESSAI_V M-file for essai_V.fig
%      ESSAI_V, by itself, creates a new ESSAI_V or raises the existing
%      singleton*.
%
%      H = ESSAI_V returns the handle to a new ESSAI_V or the handle to
%      the existing singleton*.
%
%      ESSAI_V('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESSAI_V.M with the given input arguments.
%
%      ESSAI_V('Property','Value',...) creates a new ESSAI_V or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before essai_V_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to essai_V_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help essai_V

% Last Modified by GUIDE v2.5 06-Apr-2006 14:22:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @essai_V_OpeningFcn, ...
                   'gui_OutputFcn',  @essai_V_OutputFcn, ...
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

% --- Executes just before essai_V is made visible.
function essai_V_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to essai_V (see VARARGIN)

% Choose default command line output for essai_V
handles.output = hObject;
if iscell(varargin) && ~isempty(varargin)
    
    % store handle from caller
    handles.caller = varargin{1}.figure1;
    
    % Get values from Application-Defined data
    %handles.energie_edit38=findobj(allchild(handles.caller3),...
    %    'Tag','energie_edit38');
    handles.nb_correcteurs_V_edit = findobj(allchild(handles.caller),...
        'Tag','nb_correcteurs_V_edit');
    
    
    % matrice singular values
    S_V = getappdata(handles.caller,'S_V');
    V = diag(S_V);
    
    % initalisation popupmenu
    set(handles.val_sing_V_popupmenu, 'String',...
        {'liste valeurs singulières', V(:)});
        %{'liste valeurs singulières', sprintf('%3.2f',V(:))});
    
    % positionner le popup à la dernière valeur (on prend par défaut toutes
    % les valeurs propres
    set(handles.val_sing_V_popupmenu,'Value',size(S_V,2)+1);
    setappdata(handles.caller,'valvp_V',size(S_V,2));
    k = get(handles.val_sing_V_popupmenu,'Value') - 1;
    
    % plot des valeurs singulières
    name=['axes' num2str(1)];
    axes(handles.(name));
    if size(S_V,2)==0
        %disp('correction_tour1_singval_V');
        xdata = 1;
        V = [0];
    else
        xdata = 1:size(S_V,2);
    end
    plot(xdata,V,'rs-','Tag','line1');
    hold on
    set(handles.(name), 'YGrid','On');
    set(handles.(name), 'XGrid','On');
    set(gca, 'YMinorTick','On');
    %set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'no de la valeur singulière');
    ylabel(handles.(name),'valeur singulière');
    if size(S_V,2)>0
        xlim([1 xdata(end)]);
    else
        
    end
    
    % positionner le curseur à la valeur propre choisie
    if k==0
        k = 1
    end
    plot(k,V(k),'rp','MarkerEdgeColor','k',...
                    'MarkerFaceColor','r',...
                    'MarkerSize',14,'Tag','line2');
    hold off
end


% Update handles structure
guidata(hObject, handles);


% UIWAIT makes essai_V wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = essai_V_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in rafraichir_V_pushbutton.
function rafraichir_V_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to rafraichir_V_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% nbre de correcteurs utilisés dans la correction SVD
nbcorrSVD_V = get(handles.nb_correcteurs_V_edit,'String');
nbcorrSVD_V = str2num(nbcorrSVD_V);
% correcteur actuellement selectionné
valCV = getappdata(handles.caller,'n_selection_CV');
%if isequal(valCV,0)|isequal(valCVV,1)
if valCV<nbcorrSVD_V
    errordlg('avancez à un nombre adéquat de correcteurs !','Attention');
    % sortir de la fonction
    return
end
Meff_V = getappdata(handles.caller,'Meff_V');
BPMz = getappdata(handles.caller,'BPMz');
VCOR = getappdata(handles.caller,'VCOR');
% extraire la matrice 
flag = 0;
liste_elem_BPM = [];
for j = 1 : length(BPMz.Position)
    if BPMz.Position(j)>VCOR.Position(valCV-nbcorrSVD_V+1)  
        if valCV~=length(VCOR.Position)&BPMz.Position(j)>VCOR.Position(valCV+1)
            break
        end
        flag = flag + 1;
        liste_elem_BPM = [liste_elem_BPM j]; 
        Meffloc_V(flag,:) = Meff_V(j,valCV-nbcorrSVD_V+1:valCV);
    end
end
% nbBPM  = flag;
% liste_dev_BPM = elem2dev('BPMx',liste_elem_BPM);
% HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
% liste_dev_HCOR = HCOR_liste(valCH-nbcorrSVD+1:valCH,:);
% BPMindex = family2atindex('BPMx',liste_dev_BPM);
% spos = getspos('BPMx');
% hcm = getsp('HCOR',liste_dev_HCOR,'struct');
[U,S_V,V] = svd(Meffloc_V);
setappdata(handles.caller,'S_V',S_V);




% matrice singular values

V = diag(S_V);

% initalisation popupmenu
set(handles.val_sing_V_popupmenu, 'String',...
    {'liste valeurs singulières', V(:)});
    %{'liste valeurs singulières', sprintf('%3.2f',V(:))});

% positionner le popup à la dernière valeur (on prend par défaut toutes
% les valeurs propres
set(handles.val_sing_V_popupmenu,'Value',size(S_V,2)+1);
setappdata(handles.caller,'valvp_V',size(S_V,2));
k = get(handles.val_sing_V_popupmenu,'Value') - 1;
if k==0
    k = 1;
end
% replot des orbites
h     = get(handles.axes1,'Children');
hline = findobj(h,'-regexp','Tag','line[1,2]');

% plot des valeurs singulières
name=['axes' num2str(1)];
axes(handles.(name));
xdata = 1:size(S_V,2);

%plot(xdata,V,'rs-','Tag','line1');
if isequal(isempty(xdata),1)
    xdata = [1];
    V = [0];
else
    xlim([1 xdata(end)]);
end
set(hline(2),'XData',xdata,'YData',V,'Visible','On');
set(hline(1),'XData',k,'YData',V(k),'Visible','On');


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


% --- Executes on selection change in val_sing_V_popupmenu.
function val_sing_V_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to val_sing_V_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns val_sing_V_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from val_sing_V_popupmenu

S_V = getappdata(handles.caller,'S_V');

% attribution du numero de la valeur propre (on enlève le titre)
valvp_V = get(hObject,'Value')-1;

setappdata(handles.caller,'valvp_V',valvp_V)
handles.valvp_V = getappdata(handles.caller,'valvp_V');
% % Update handles structure
guidata(hObject, handles);

h     = get(handles.axes1,'Children');
hline = findobj(h,'-regexp','Tag','line[2]');

% plot de la valeur singulière limite selectionnée
name=['axes' num2str(1)];
axes(handles.(name));

% matrice singular values
S_V = getappdata(handles.caller,'S_V');
V = diag(S_V);
set(hline(1),'XData',valvp_V,'YData',V(valvp_V),'Visible','On');


disp('hello')


% --- Executes during object creation, after setting all properties.
function val_sing_V_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to val_sing_V_popupmenu (see GCBO)
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

