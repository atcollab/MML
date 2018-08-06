function varargout = orbitz_AT(varargin)
% ORBITZ_AT M-file for orbitz_AT.fig
%      ORBITZ_AT, by itself, creates a new ORBITZ_AT or raises the existing
%      singleton*.
%
%      H = ORBITZ_AT returns the handle to a new ORBITZ_AT or the handle to
%      the existing singleton*.
%
%      ORBITZ_AT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ORBITZ_AT.M with the given input arguments.
%
%      ORBITZ_AT('Property','Value',...) creates a new ORBITZ_AT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before orbitz_AT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to orbitz_AT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help orbitz_AT

% Last Modified by GUIDE v2.5 30-Mar-2006 18:44:14

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @orbitz_AT_OpeningFcn, ...
                   'gui_OutputFcn',  @orbitz_AT_OutputFcn, ...
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


% --- Executes just before orbitz_AT is made visible.
function orbitz_AT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to orbitz_AT (see VARARGIN)

% Choose default command line output for orbitz_AT
handles.output = hObject;

if ~strcmp(getfamilydata('SubMachine'),'Booster')
    error('Load Booster first');
end

handles.K1 = 0;
handles.ncorrx = 22;
handles.nbpmx  = 22;
% Update handles structure
guidata(hObject, handles);
gettune_Callback(hObject, eventdata, handles);

% UIWAIT makes orbitz_AT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = orbitz_AT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_ratio_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'Value') returns position of slider
%        gettune(hObject,'Min') and gettune(hObject,'Max') to determine range of slider

set(handles.edit_ratio,'String',...
    num2str(get(handles.slider_ratio,'Value')));

% --- Executes during object creation, after setting all properties.
function slider_ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_VP_Callback(hObject, eventdata, handles)
% hObject    handle to slider_VP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'Value') returns position of slider
%        gettune(hObject,'Min') and gettune(hObject,'Max') to determine range of slider
set(handles.edit_VP,'String',...
    num2str(get(handles.slider_VP,'Value')));

% --- Executes during object creation, after setting all properties.
function slider_VP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_VP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edit_ratio_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit_ratio as text
%        str2double(gettune(hObject,'String')) returns contents of edit_ratio as a double


% --- Executes during object creation, after setting all properties.
function edit_ratio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_VP_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit_VP as text
%        str2double(gettune(hObject,'String')) returns contents of edit_VP as a double


% --- Executes during object creation, after setting all properties.
function edit_VP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_corr_orb (lecture orbite+corr).
function get_corr_orb_Callback(hObject, eventdata, handles)
% hObject    handle to get_corr_orb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% lecture orbite et correcteurs horizontaux

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncorrx=handles.ncorrx;
nbpmx =handles.nbpmx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
istart = str2num(get(handles.edit_tdeb,'String'));     % depart lecture BPM
iend   =  str2num(get(handles.edit_tfin,'String'));      % fin lecture BPM

global betcX betcY phacX phacY Scx Scy nux nuz;
global betbX betbY phabX phabY Sbx Sby;

clear hs on

% Get BPM to use in correction
nbpm = 0;

for i = 1:nbpmx;
   text = ['BPM',int2str(i)];
   hs(i) = get(handles.(text),'Value');
   nbpm = nbpm+hs(i);
end 
set(handles.edit_Nbpm,'String', [num2str(nbpm),' BPM']);

% Get correctors to use in correction
ncorr = 0;

for i = 1:ncorrx;
   text = ['CORR',int2str(i)];
   on(i) = get(handles.(text),'Value');
   ncorr = ncorr+on(i);
end

set(handles.edit_Ncorr,'String',...
    [num2str(ncorr),' CORR']);

clear s_bz s_cz

s_bz = Sby;
s_cz = Scy;

[Xm,Zm] = getboobpm(nbpmx,iend,istart);

clear Zr Zr2
% Zr2=0;
% 
% for j=1:nbpmx,
%     Zr(j)=Zm(j);
%     Zr2 = Zr2 + Zr(j)*Zr(j);   
% end
Zr2 =std(Zm(1:nbpmx),1);
%Zr2 = sqrt(Zr2/j)   % ecart type orbite

set(handles.edit_Xrms,'String',[num2str(Zr2),' mm rms']);

K2 = getam('VCOR');

axes(handles.axes_orbit)
    plot(s_bz,Zm,'-ok','MarkerFaceColor','k');
    xlim([0 156]); ylim([-4 4]);
    set(handles.axes_orbit,'XTick',[]);
    ylabel('Orbite');
    grid on

axes(handles.axes_lattice)
   drawlattice_alex
   set(handles.axes_lattice,'YTick',[],'XTick',[]);
   
axes(handles.axes_corr)  
    bar(s_cz,K2,0.5)
    ylabel('I (A)');xlabel('Position S');
    xlim([0 156]);ylim([-1.5 1.5])

% --- Executes on button press in calcul_corr (calcul corr).
function calcul_corr_Callback(hObject, eventdata, handles)
% hObject    handle to calcul_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global betcX betcY phacX phacY Scx Scy nux nuz;
global betbX betbY phabX phabY Sbx Sby;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncorrx = handles.ncorrx;
nbpmx  = handles.nbpmx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step   = get(handles.slider_ratio,'Value');         % correction progressive
maxvp  = get(handles.slider_VP,'Value');           % valeur propre
istart = str2num(get(handles.edit_tdeb,'String'));     % depart lecture BPM
iend   = str2num(get(handles.edit_tfin,'String'));      % fin lecture BPM

clear hs on
% Get BPM to use
nbpm = 0;
for i=1:nbpmx;
   text=['BPM',int2str(i)];
   hs(i)=get(handles.(text),'Value');
   nbpm=nbpm+hs(i);
end 

set(handles.edit_Nbpm,'String',...
    [num2str(nbpm),' BPM']);

% Get corrector to use
ncorr = 0;
for i=1:ncorrx;
   text=['CORR',int2str(i)];
   on(i)=get(handles.(text),'Value');
   ncorr=ncorr+on(i);
end 
set(handles.edit_Ncorr,'String',...
    [num2str(ncorr),' CORR']);

clear s_bx s_cx

s_bz = Sby;
s_cz = Scy;

clear beta_corrz phi_corrz s_corrz

% on remplit la matrice C tel que X=C.K
i=0;
clear beta_bpmz  phi_bpmz s_bpmz

for j=1:nbpmx
    if (hs(j)==1) 
       i=i+1; 
       beta_bpmz(i) = betbY(j);
       phi_bpmz(i)  = phabY(j);
       s_bpmz(i)    = Sby(j);
    end    
end

beta_bpmz

nbpmxr = i;
% cote correcteurs sur chaque qp defoc, on commence sur un qd (inj booster)
i=0;
clear beta_corrz phi_corrz s_corrz

for j=1:ncorrx,
    if (on(j)==1)
       i=i+1; 
       beta_corrz(i)=betcY(j);
       phi_corrz(i)=phacY(j);
       s_corrz(i)=Scy(j);
    end   
end
beta_corrz
ncorrxr = i;
% matrice Cc cas fermee cyclique
clear Cc

c3 = 2*sin(nuz/2);
for i = 1:nbpmxr,
   for j = 1:ncorrxr
      c1 = sqrt(beta_bpmz(i)*beta_corrz(j));
      c2 = cos(nuz/2-abs(phi_bpmz(i)-phi_corrz(j)));
      Cc(i,j) = c1*c2/c3;
   end
end



%  cote vecteur X repesentant les defaut d'orbites mesuree en mm
%  bloc = offset a retrancher

[Xm,Zm] = getboobpm(nbpmx,iend,istart);

    

clear Zr
i = 0;
for j=1:nbpmx,
    if (hs(j)==1) 
       i=i+1;
       Zr(i) = Zm(j);
    end    
end

% Resolution par SVD matrice Cc cyclique sur X
clear Xcorr Cci K
[U,S,V] = svds(Cc,ncorrxr);
vp = diag(S)
for i=1:min(nbpmxr,ncorrxr)
    if(S(i,i)<=maxvp)
        S(i,i)=0;
    else
        S(i,i)=1/S(i,i);
    end    
end   
Cci = V*S*U';
K   = -Cci*transpose(Zr);    
% en mrad

clear nb K0 K1 K2 K3
j = 0;
for i=1:ncorrx,
    nb(i)=i;
end

j = 0;
sumcorr=0;
for i=1:ncorrx
    if(on(i)==0)
        K1(i)=0;
    else
        j = j+1;
        K1(i) = K(j)/1.2*step;           % en Ampere
        sumcorr = sumcorr + K1(i);
    end    
end

handles.K1 = K1;


K2 = getam('VCOR');save('zcoortemp','K2')
K3 = K2 + K1';

axes(handles.axes_orbit)
    plot(vp,'-ok','MarkerFaceColor','k');
    xlim([0 22]);
    ylabel('Valeur propres');
    grid on

axes(handles.axes_corr)
    bar(s_cz,K3,0.5)
    ylabel('I (A)');xlabel('Position S');
    xlim([0 156]);ylim([-1.5 1.5])

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in apply_corr (applique corr).
function apply_corr_Callback(hObject, eventdata, handles)
% hObject    handle to apply_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ncorrx=handles.ncorrx;
nbpmx =handles.nbpmx;
K1=handles.K1;
for i=1:ncorrx,
    if (K1(i)<1.5)
       stepsp('VCOR',K1(i),[i 1]);
    end    
end 
%K1=[0];

% --- Executes on button press in Back_corr.
function Back_corr_Callback(hObject, eventdata, handles)
% hObject    handle to Back_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ncorrx=handles.ncorrx;
nbpmx =handles.nbpmx;
load('zcoortemp','K2');
for i=1:ncorrx,
    if (K2(i)<1.5)
       setsp('VCOR',K2(i),[i 1]);
    end    
end


% --- Executes on button press in get_and_correction (lecture + calcul+ appl).
function get_and_correction_Callback(hObject, eventdata, handles)
% hObject    handle to get_and_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Correction orbite horizontale
global betcX betcY phacX phacY Scx Scy nux nuz;
global betbX betbY phabX phabY Sbx Sby;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncorrx=handles.ncorrx;
nbpmx =handles.nbpmx;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step=get(handles.slider_ratio,'Value');         % correction progressive
maxvp=get(handles.slider_VP,'Value');           % valeur propre
istart =str2num(get(handles.edit_tdeb,'String'));     % depart lecture BPM
iend =  str2num(get(handles.edit_tfin,'String'));      % fin lecture BPM

clear hs on
nbpm=0;
for i=1:nbpmx;
   text=['BPM',int2str(i)];
   hs(i)=get(handles.(text),'Value');
   nbpm=nbpm+hs(i);
end 
set(handles.edit_Nbpm,'String',...
    [num2str(nbpm),' BPM']);
ncorr=0;
for i=1:ncorrx;
   text=['CORR',int2str(i)];
   on(i)=get(handles.(text),'Value');
   ncorr=ncorr+on(i);
end 
set(handles.edit_Ncorr,'String',...
    [num2str(ncorr),' CORR']);

clear s_bx s_cx
s_bz=Sby;
s_cz=Scy;

clear beta_corrx phi_corrx s_corrx

% on rempli la matrice C tel que X=C.K
i=0;
clear beta_bpmx  phi_bpmx s_bpmx
for j=1:nbpmx
    if (hs(j)==1) 
       i=i+1; 
       beta_bpmz(i)=betbY(j);
       phi_bpmz(i)=phabY(j);
       s_bpmz(i)=Sby(j);
    end    
end

nbpmxr=i;
% cot� correcteurs sur chaque qp defoc, on commence sur un qd (inj booster)
i=0;
clear beta_corrx phi_corrx s_corrx
for j=1:ncorrx,
    if (on(j)==1)
       i=i+1; 
       beta_corrz(i)=betcY(j);
       phi_corrz(i)=phacY(j);
       s_corrz(i)=Scy(j);
    end   
end

ncorrxr=i;
% matrice Cc cas fermee cyclique
clear Cc
c3=2*sin(nuz/2);
for i = 1:nbpmxr,
   for j = 1:ncorrxr
      c1=sqrt(beta_bpmz(i)*beta_corrz(j));
      c2=cos(nuz/2-abs(phi_bpmz(i)-phi_corrz(j)));
      Cc(i,j) = c1*c2/c3;
   end
end



%  cote vecteur X repesentant les defaut d'orbites mesuree en mm
%  bloc = offset a retrancher

[Xm,Zm]=getboobpm(nbpmx,iend,istart);
Zr2 =std(Zm(1:nbpmx),1);
%Zr2 = sqrt(Zr2/j)   % ecart type orbite

set(handles.edit_Xrms,'String',[num2str(Zr2),' mm rms']);


clear Zr
i=0;
for j=1:nbpmx,
    if (hs(j)==1) 
       i=i+1;
       Zr(i)=Zm(j);
    end    
end

% Resolution par SVD matrice Cc cyclique sur X
clear Xcorr Cci K
[U,S,V] = svds(Cc,ncorrxr);
vp=diag(S);
for i=1:min(nbpmxr,ncorrxr)
    if(S(i,i)<=maxvp)
        S(i,i)=0;
    else
        S(i,i)=1/S(i,i);
    end    
end   
Cci=V*S*U';
K=-Cci*transpose(Zr);    
% en mrad



clear nb K0 K1 K2
j=0;
for i=1:ncorrx,
    nb(i)=i;
end
j=0;
sumcorr=0;
for i=1:ncorrx
    if(on(i)==0)
        K1(i)=0;
    else
        j=j+1;
        K1(i)=K(j)/1.2*step;           % en Ampere
        sumcorr =sumcorr + K1(i);
    end    
end

K2=getam('VCOR','simulator'); save('zcoortemp','K2')
for i=1:ncorrx,
    if (K1(i)<1.5)
       stepsp('VCOR',K1(i),[i 1]);
    end    
end 
K3=K2+K1';


% après corr
[Xc,Zc]=getboobpm(nbpmx,iend,istart);

axes(handles.axes_orbit)
    plot(s_bz,Zm,'-ok','MarkerFaceColor','k'); hold on
    plot(s_bz,Zc,'-or','MarkerFaceColor','r'); hold off
    xlim([0 156]); ylim([-4 4]);
    ylabel('Orbite');
    grid on

axes(handles.axes_corr)
    bar(s_cz,K3,0.5)
    ylabel('I (A)');xlabel('Position S');
    xlim([0 156]);ylim([-1.5 1.5])













function Nuz_mes_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit3 as text
%        str2double(gettune(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function Nuz_mes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Energy_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit4 as text
%        str2double(gettune(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function Energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Nux_mes_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit5 as text
%        str2double(gettune(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function Nux_mes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkbox1.
function BPM1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function BPM2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function BPM3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function BPM4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function BPM5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function BPM6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function BPM7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function BPM8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox9.
function BPM9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function BPM10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function BPM11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in BPM12.
function BPM12_Callback(hObject, eventdata, handles)
% hObject    handle to BPM12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM12


% --- Executes on button press in BPM13.
function BPM13_Callback(hObject, eventdata, handles)
% hObject    handle to BPM13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM13


% --- Executes on button press in BPM14.
function BPM14_Callback(hObject, eventdata, handles)
% hObject    handle to BPM14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM14


% --- Executes on button press in BPM15.
function BPM15_Callback(hObject, eventdata, handles)
% hObject    handle to BPM15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM15


% --- Executes on button press in BPM16.
function BPM16_Callback(hObject, eventdata, handles)
% hObject    handle to BPM16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM16


% --- Executes on button press in BPM17.
function BPM17_Callback(hObject, eventdata, handles)
% hObject    handle to BPM17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM17


% --- Executes on button press in BPM18.
function BPM18_Callback(hObject, eventdata, handles)
% hObject    handle to BPM18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM18


% --- Executes on button press in BPM19.
function BPM19_Callback(hObject, eventdata, handles)
% hObject    handle to BPM19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM19


% --- Executes on button press in BPM20.
function BPM20_Callback(hObject, eventdata, handles)
% hObject    handle to BPM20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM20


% --- Executes on button press in BPM21.
function BPM21_Callback(hObject, eventdata, handles)
% hObject    handle to BPM21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM21


% --- Executes on button press in BPM22.
function BPM22_Callback(hObject, eventdata, handles)
% hObject    handle to BPM22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of BPM22




% --- Executes on button press in CORR1.
function CORR1_Callback(hObject, eventdata, handles)
% hObject    handle to CORR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR1


% --- Executes on button press in CORR2.
function CORR2_Callback(hObject, eventdata, handles)
% hObject    handle to CORR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR2


% --- Executes on button press in CORR3.
function CORR3_Callback(hObject, eventdata, handles)
% hObject    handle to CORR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR3


% --- Executes on button press in CORR4.
function CORR4_Callback(hObject, eventdata, handles)
% hObject    handle to CORR4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR4


% --- Executes on button press in CORR5.
function CORR5_Callback(hObject, eventdata, handles)
% hObject    handle to CORR5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR5


% --- Executes on button press in CORR6.
function CORR6_Callback(hObject, eventdata, handles)
% hObject    handle to CORR6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR6


% --- Executes on button press in CORR7.
function CORR7_Callback(hObject, eventdata, handles)
% hObject    handle to CORR7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR7



% --- Executes on button press in CORR8.
function CORR8_Callback(hObject, eventdata, handles)
% hObject    handle to CORR7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR8



% --- Executes on button press in CORR9.
function CORR9_Callback(hObject, eventdata, handles)
% hObject    handle to CORR7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR9




% --- Executes on button press in CORR10.
function CORR10_Callback(hObject, eventdata, handles)
% hObject    handle to CORR10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR10


% --- Executes on button press in CORR11.
function CORR11_Callback(hObject, eventdata, handles)
% hObject    handle to CORR11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR11


% --- Executes on button press in CORR12.
function CORR12_Callback(hObject, eventdata, handles)
% hObject    handle to CORR12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR12


% --- Executes on button press in CORR13.
function CORR13_Callback(hObject, eventdata, handles)
% hObject    handle to CORR13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR13


% --- Executes on button press in CORR14.
function CORR14_Callback(hObject, eventdata, handles)
% hObject    handle to CORR14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR14


% --- Executes on button press in CORR15.
function CORR15_Callback(hObject, eventdata, handles)
% hObject    handle to CORR15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR15


% --- Executes on button press in CORR16.
function CORR16_Callback(hObject, eventdata, handles)
% hObject    handle to CORR16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR16


% --- Executes on button press in CORR17.
function CORR17_Callback(hObject, eventdata, handles)
% hObject    handle to CORR17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR17


% --- Executes on button press in CORR18.
function CORR18_Callback(hObject, eventdata, handles)
% hObject    handle to CORR18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR18


% --- Executes on button press in CORR19.
function CORR19_Callback(hObject, eventdata, handles)
% hObject    handle to CORR19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR19


% --- Executes on button press in CORR20.
function CORR20_Callback(hObject, eventdata, handles)
% hObject    handle to CORR20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR20


% --- Executes on button press in CORR21.
function CORR21_Callback(hObject, eventdata, handles)
% hObject    handle to CORR21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR21


% --- Executes on button press in CORR22.
function CORR22_Callback(hObject, eventdata, handles)
% hObject    handle to CORR22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: gettune(hObject,'Value') returns toggle state of CORR22



function edit_Nbpm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nbpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit_Nbpm as text
%        str2double(gettune(hObject,'String')) returns contents of edit_Nbpm as a double


% --- Executes during object creation, after setting all properties.
function edit_Nbpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Nbpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Ncorr_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ncorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit_Ncorr as text
%        str2double(gettune(hObject,'String')) returns contents of edit_Ncorr as a double


% --- Executes during object creation, after setting all properties.
function edit_Ncorr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ncorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Xrms_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Xrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit_Xrms as text
%        str2double(gettune(hObject,'String')) returns contents of edit_Xrms as a double


% --- Executes during object creation, after setting all properties.
function edit_Xrms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Xrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tdeb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tdeb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit_tdeb as text
%        str2double(gettune(hObject,'String')) returns contents of edit_tdeb as a double


% --- Executes during object creation, after setting all properties.
function edit_tdeb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tdeb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tfin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tfin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of edit_tfin as text
%        str2double(gettune(hObject,'String')) returns contents of edit_tfin as a double


% --- Executes during object creation, after setting all properties.
function edit_tfin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tfin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = gettune(hObject,'String') returns listbox1 contents as cell array
%        contents{gettune(hObject,'Value')} returns selected item from listbox1


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



function Nux_mod_Callback(hObject, eventdata, handles)
% hObject    handle to Nux_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of Nux_mod as text
%        str2double(gettune(hObject,'String')) returns contents of Nux_mod as a double


% --- Executes during object creation, after setting all properties.
function Nux_mod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nux_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nuz_mod_Callback(hObject, eventdata, handles)
% hObject    handle to Nuz_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: gettune(hObject,'String') returns contents of Nuz_mod as text
%        str2double(gettune(hObject,'String')) returns contents of Nuz_mod as a double


% --- Executes during object creation, after setting all properties.
function Nuz_mod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nuz_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gettune.
function gettune_Callback(hObject, eventdata, handles)
% hObject    handle to gettune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global betcX betcY phacX phacY Scx Scy nux nuz;
global betbX betbY phabX phabY Sbx Sby;

energy=str2num(get(handles.Energy,'String'));
setenergy(energy, 'model');
[tune]=gettune('Model');
set(handles.Nux_mod,'String',num2str(tune(1)));
set(handles.Nuz_mod,'String',num2str(tune(2)));

[betcX, betcY, Scx, Scy, Tune] = modeltwiss('beta','VCOR');
[phacX, phacY, Scx, Scy, Tune] = modeltwiss('phase','VCOR');
[betbX, betbY, Sbx, Sby, Tune] = modeltwiss('beta','BPMz');
[phabX, phabY, Sbx, Sby, Tune] = modeltwiss('phase','BPMz');
nux = Tune(1)*2*pi;
nuz = Tune(2)*2*pi;

% --- Executes on button press in fittune.
function fittune_Callback(hObject, eventdata, handles)
% hObject    handle to fittune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global betcX betcY phacX phacY Scx Scy nux nuz;
global betbX betbY phabX phabY Sbx Sby;

energy = str2num(get(handles.Energy,'String')); % GeV
setenergy(energy, 'model');
nux   =  str2double(get(handles.Nux_mes,'String'));
nuz   =  str2double(get(handles.Nuz_mes,'String'));
target = [nux ; nuz];
tune0 = gettune('Model');
dt = target - tune0;

dI = 0.01;
stepsp('QF','Model',+dI); tune1 = gettune('Model');stepsp('QF','model',-dI);
stepsp('QD','Model',+dI); tune2 = gettune('Model');stepsp('QD','model',-dI);
A=-[tune0(1)-tune1(1) tune0(1)-tune2(1) ; tune0(2)-tune1(2) tune0(2)-tune2(2)]/dI;

stepI = linsolve(A,dt);
stepsp('QF','model',stepI(1));
stepsp('QD','model',stepI(2));
[tune]=gettune('Model');
set(handles.Nux_mod,'String',num2str(tune(1)));
set(handles.Nuz_mod,'String',num2str(tune(2)));

[betcX, betcY, Scx, Scy, Tune] = modeltwiss('beta','VCOR');
[phacX, phacY, Scx, Scy, Tune] = modeltwiss('phase','VCOR');
[betbX, betbY, Sbx, Sby, Tune] = modeltwiss('beta','BPMz');
[phabX, phabY, Sbx, Sby, Tune] = modeltwiss('phase','BPMz');

% transform tune to phase advance
nux = Tune(1)*2*pi;
nuz = Tune(2)*2*pi;




