function varargout = correction_tour1_singval(varargin)
% CORRECTION_TOUR1_SINGVAL M-file for correction_tour1_singval.fig
%      CORRECTION_TOUR1_SINGVAL, by itself, creates a new CORRECTION_TOUR1_SINGVAL or raises the existing
%      singleton*.
%
%      H = CORRECTION_TOUR1_SINGVAL returns the handle to a new CORRECTION_TOUR1_SINGVAL or the handle to
%      the existing singleton*.
%
%      CORRECTION_TOUR1_SINGVAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRECTION_TOUR1_SINGVAL.M with the given input arguments.
%
%      CORRECTION_TOUR1_SINGVAL('Property','Value',...) creates a new CORRECTION_TOUR1_SINGVAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before correction_tour1_singval_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to correction_tour1_singval_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help correction_tour1_singval

% Last Modified by GUIDE v2.5 17-Mar-2006 15:59:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @correction_tour1_singval_OpeningFcn, ...
                   'gui_OutputFcn',  @correction_tour1_singval_OutputFcn, ...
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

% --- Executes just before correction_tour1_singval is made visible.
function correction_tour1_singval_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to correction_tour1_singval (see VARARGIN)

% Choose default command line output for correction_tour1_singval
handles.output = hObject;
if iscell(varargin) && ~isempty(varargin)
    
    % store handle from caller
    handles.caller = varargin{1}.figure1;
    
    % Get values from Application-Defined data
    %handles.energie_edit38=findobj(allchild(handles.caller3),...
    %    'Tag','energie_edit38');
    handles.nb_correcteurs_H_edit17 = findobj(allchild(handles.caller),...
        'Tag','nb_correcteurs_H_edit17');
    
    
    % matrice singular values
    S = getappdata(handles.caller,'S');
    V = diag(S);
    
    % initalisation popupmenu
    set(handles.val_sing_H_popupmenu1, 'String',...
        {'liste valeurs singuli�res', V(:)});
        %{'liste valeurs singuli�res', sprintf('%3.2f',V(:))});
    
    % positionner le popup � la derni�re valeur (on prend par d�faut toutes
    % les valeurs propres
    set(handles.val_sing_H_popupmenu1,'Value',length(V)+1);
    setappdata(handles.caller,'valvp',length(V));
    k = get(handles.val_sing_H_popupmenu1,'Value') - 1;
    
    % plot des valeurs singuli�res
    name=['axes' num2str(1)];
    axes(handles.(name));
    if size(S,2)==0
        %disp('toto');
        xdata = 1;
        V = [0];
    else
        xdata = 1:length(V);
    end
    plot(xdata,V,'rs-','Tag','line1');
    hold on
    set(handles.(name), 'YGrid','On');
    set(handles.(name), 'XGrid','On');
    set(gca, 'YMinorTick','On');
    %set(handles.(name), 'XMinorTick','On');
    xlabel(handles.(name),'no de la valeur singuli�re');
    ylabel(handles.(name),'valeur singuli�re');
    if size(S,2)>0
        xlim([1 xdata(end)]);
    else
        
    end
    
    % positionner le curseur � la valeur propre choisie
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

% This sets up the initial plot - only do when we are invisible
% so window can get raised using correction_tour1_singval.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes correction_tour1_singval wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = correction_tour1_singval_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in rafraichir_pushbutton1.
function rafraichir_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to rafraichir_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% axes(handles.axes1);
% cla;

% recalculer la matrice S

% nbre de correcteurs utilis�s dans la correction SVD
nbcorrSVD = get(handles.nb_correcteurs_H_edit17,'String');
nbcorrSVD = str2num(nbcorrSVD);
% correcteur actuellement selectionn�
valCH = getappdata(handles.caller,'n_selection_CH');
%if isequal(valCH,0)|isequal(valCH,1)
if valCH<nbcorrSVD
    errordlg('avancez � un nombre ad�quat de correecteurs !','Attention');
    % sortir de la fonction
    return
end
Meff = getappdata(handles.caller,'Meff');
BPMx = getappdata(handles.caller,'BPMx');
HCOR = getappdata(handles.caller,'HCOR');

% on tiend compte du status du BPM, eventuellement mis � 0 pour cause de
% lecture non fiable, ou bien ??
BPMx_status = family2status('BPMx');

% extraire la matrice 
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
% nbBPM  = flag;
% liste_dev_BPM = elem2dev('BPMx',liste_elem_BPM);
% HCOR_liste = getappdata(handles.figure1,'HCOR_liste');
% liste_dev_HCOR = HCOR_liste(valCH-nbcorrSVD+1:valCH,:);
% BPMindex = family2atindex('BPMx',liste_dev_BPM);
% spos = getspos('BPMx');
% hcm = getsp('HCOR',liste_dev_HCOR,'struct');
[U,S,V] = svd(Meffloc);
setappdata(handles.caller,'S',S);




% matrice singular values

V = diag(S);

% initalisation popupmenu
set(handles.val_sing_H_popupmenu1, 'String',...
    {'liste valeurs singuli�res', V(:)});
    %{'liste valeurs singuli�res', sprintf('%3.2f',V(:))});

% positionner le popup � la derni�re valeur (on prend par d�faut toutes
% les valeurs propres
set(handles.val_sing_H_popupmenu1,'Value',length(V)+1);
setappdata(handles.caller,'valvp',length(V));
k = get(handles.val_sing_H_popupmenu1,'Value') - 1;
if k==0
    k = 1;
end
% replot des orbites
h     = get(handles.axes1,'Children');
hline = findobj(h,'-regexp','Tag','line[1,2]');

% plot des valeurs singuli�res
name=['axes' num2str(1)];
axes(handles.(name));
xdata = 1:length(V);

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


% --- Executes on selection change in val_sing_H_popupmenu1.
function val_sing_H_popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to val_sing_H_popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns val_sing_H_popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from val_sing_H_popupmenu1


S = getappdata(handles.caller,'S');

% attribution du numero de la valeur propre (on enl�ve le titre)
valvp = get(hObject,'Value')-1;

setappdata(handles.caller,'valvp',valvp)
handles.valvp = getappdata(handles.caller,'valvp');
% % Update handles structure
guidata(hObject, handles);

h     = get(handles.axes1,'Children');
hline = findobj(h,'-regexp','Tag','line[2]');

% plot de la valeur singuli�re limite selectionn�e
name=['axes' num2str(1)];
axes(handles.(name));

% matrice singular values
S = getappdata(handles.caller,'S');
V = diag(S);
set(hline(1),'XData',valvp,'YData',V(valvp),'Visible','On');


disp('hello')


% --- Executes during object creation, after setting all properties.
function val_sing_H_popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to val_sing_H_popupmenu1 (see GCBO)
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

