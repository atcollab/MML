function varargout = orbitx2(varargin)
% ORBITX2 M-file for orbitx2.fig
%      ORBITX2, by itself, creates a new ORBITX2 or raises the existing
%      singleton*.
%
%      H = ORBITX2 returns the handle to a new ORBITX2 or the handle to
%      the existing singleton*.
%
%      ORBITX2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ORBITX2.M with the given input arguments.
%
%      ORBITX2('Property','Value',...) creates a new ORBITX2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before orbitx2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to orbitx2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help orbitx2

% Last Modified by GUIDE v2.5 20-Jan-2006 11:10:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @orbitx2_OpeningFcn, ...
                   'gui_OutputFcn',  @orbitx2_OutputFcn, ...
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


% --- Executes just before orbitx2 is made visible.
function orbitx2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to orbitx2 (see VARARGIN)

% Choose default command line output for orbitx2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes orbitx2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = orbitx2_OutputFcn(hObject, eventdata, handles) 
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

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

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

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
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

% Hints: get(hObject,'String') returns contents of edit_ratio as text
%        str2double(get(hObject,'String')) returns contents of edit_ratio as a double


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

% Hints: get(hObject,'String') returns contents of edit_VP as text
%        str2double(get(hObject,'String')) returns contents of edit_VP as a double


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


% --- Executes on button press in pushbutton3 (lecture orbite+corr).
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% lecture orbite horizontale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncell=44;
betax=str2num(get(handles.betamax,'String'));
b2   =betax;
b1   =str2num(get(handles.betamin,'String'));
tune=str2num(get(handles.nux,'String'));
nux=tune*2*pi;    % avance de phase
dnux=nux/ncell;  % avance de phase par maille
ds=3.5595;       % longueur maille
ncorrx=22;
nbpmx=22;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step=get(handles.slider_ratio,'Value');         % correction progressive
maxvp=get(handles.slider_VP,'Value');           % valeur propre
istart =str2num(get(handles.edit_tdeb,'String'));     % depart lecture BPM
iend =  str2num(get(handles.edit_tfin,'String'));      % fin lecture BPM

% table BPM
clear loc
loc(1) =01;loc(2) =04;loc(3) =05;loc(4) =08;loc(5) =09;loc(6)=11;
loc(7) =13;loc(8) =14;loc(9) =17;loc(10)=18;loc(11)=21;
loc(12)=23;loc(13)=26;loc(14)=27;loc(15)=30;loc(16)=31;loc(17)=33;
loc(18)=35;loc(19)=36;loc(20)=39;loc(21)=40;loc(22)=43;
clear bet
bet(1) =b1;bet(2) =b2;bet(3) =b1;bet(4) =b2;bet(5) =b1;bet(6)=b1;
bet(7) =b1;bet(8) =b2;bet(9) =b1;bet(10)=b2;bet(11)=b1;
bet(12)=b1;bet(13)=b2;bet(14)=b1;bet(15)=b2;bet(16)=b1;bet(17)=b1;
bet(18)=b1;bet(19)=b2;bet(20)=b1;bet(21)=b2;bet(22)=b1;

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


clear beta_corrx phi_corrx s_corrx
clear s_bx bx s_cx cx
for i=1:nbpmx,
    s_bx(i)=ds*loc(i)   ; bx(i)=0;
    s_cx(i)=(2*ds)*(i-1); cx(i)=0;
end




%  cote vecteur X repesentant les defaut d'orbites mesuree en mm
%  bloc = offset a retrancher
clear Zm Xm
for i=1:22
    xm=0;
    zm=0;
    
%      a=getbpmrawdata(i,'nodisplay','struct');
%      for j=istart:iend,
%         xm=xm+a.Data.X(j); % en mm
%         zm=zm+a.Data.Z(j);
%      end
%      Xm(i)=xm/(iend-istart+1);
%      Zm(i)=zm/(iend-istart+1);
     Xm(i)=(1-2*rand(1))*3;
     Zm(i)=(1-2*rand(1))*3;
end

clear Xr Xr2
Xr2=0;
for j=1:nbpmx,
    Xr(j)=Xm(j);
    Xr2 = Xr2 + Xr(j)*Xr(j);   
end
Xr2=sqrt(Xr2/j);   % ecart type orbite
set(handles.edit_Xrms,'String',[num2str(Xr2),' mm rms']);



% K2=getam('HCOR');
K2=(1-2*rand(1,ncorrx));


axes(handles.axes_orbit)

plot(s_bx,Xm,'-ok','MarkerFaceColor','k');


xlim([0 156]); ylim([-4 4]);
ylabel('Orbite');
grid on

axes(handles.axes_corr)
bar(s_cx,K2,0.5)
ylabel('I (A)');xlabel('Position S');
xlim([0 156]);ylim([-1.5 1.5])



% --- Executes on button press in pushbutton4 (calcul corr).
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5 (applique corr).
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in pushbutton1 (lecture + calcul+ appl).
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Correction orbite horizontale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncell=44;
betax=str2num(get(handles.betamax,'String'));
b2   =betax;
b1   =str2num(get(handles.betamin,'String'));
tune=str2num(get(handles.nux,'String'));
nux=tune*2*pi;    % avance de phase
dnux=nux/ncell;  % avance de phase par maille
ds=3.5595;       % longueur maille
ncorrx=22;
nbpmx=22;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step=get(handles.slider_ratio,'Value');         % correction progressive
maxvp=get(handles.slider_VP,'Value');           % valeur propre
istart =str2num(get(handles.edit_tdeb,'String'));     % depart lecture BPM
iend =  str2num(get(handles.edit_tfin,'String'));      % fin lecture BPM

% table BPM
clear loc
loc(1) =01;loc(2) =04;loc(3) =05;loc(4) =08;loc(5) =09;loc(6)=11;
loc(7) =13;loc(8) =14;loc(9) =17;loc(10)=18;loc(11)=21;
loc(12)=23;loc(13)=26;loc(14)=27;loc(15)=30;loc(16)=31;loc(17)=33;
loc(18)=35;loc(19)=36;loc(20)=39;loc(21)=40;loc(22)=43;
clear bet
bet(1) =b1;bet(2) =b2;bet(3) =b1;bet(4) =b2;bet(5) =b1;bet(6)=b1;
bet(7) =b1;bet(8) =b2;bet(9) =b1;bet(10)=b2;bet(11)=b1;
bet(12)=b1;bet(13)=b2;bet(14)=b1;bet(15)=b2;bet(16)=b1;bet(17)=b1;
bet(18)=b1;bet(19)=b2;bet(20)=b1;bet(21)=b2;bet(22)=b1;

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


clear beta_corrx phi_corrx s_corrx
clear s_bx bx s_cx cx
for i=1:nbpmx,
    s_bx(i)=ds*loc(i)   ; bx(i)=0;
    s_cx(i)=(2*ds)*(i-1); cx(i)=0;
end



% on rempli la matrice C tel que X=C.K
% cot� bpm sur chaque qp foc, on commence sur un qd (inj booster)
i=0;
clear beta_bpmx  phi_bpmx s_bpmx
for j=1:nbpmx
    if (hs(j)==1) 
       i=i+1; 
       beta_bpmx(i)=bet(j);
       phi_bpmx(i)=dnux*loc(j);
       s_bpmx(i)=ds*loc(j);
    end    
end
nbpmxr=i;
% cot� correcteurs sur chaque qp def% setsp('VCOR',0.4,[1 1])oc, on commence sur un qd (inj booster)
i=0;
clear beta_corrx phi_corrx s_corrx
for j=1:ncorrx,
    if (on(j)==1)
       i=i+1; 
       beta_corrx(i)=betax;
       phi_corrx(i)=(2*dnux)*(j-0.5);
       s_corrx(i)=(2*ds)*(j-0.5);
    end   
end
ncorrxr=i;
% matrice Cc cas fermee cyclique
clear Cc
c3=2*sin(nux/2);
for i = 1:nbpmxr,
   for j = 1:ncorrxr
      c1=sqrt(beta_bpmx(i)*beta_corrx(j));
      c2=cos(nux/2-abs(phi_bpmx(i)-phi_corrx(j)));
      Cc(i,j) = c1*c2/c3;
   end
end


%  cot� vecteur X repesentant les defaut d'orbites mesur� en mm
%  bloc = offset a retrancher
clear Zm Xm
for i=1:nbpmx
    xm=0;
    zm=0;
    
%      a=getbpmrawdata(i,'nodisplay','struct');
%      for j=istart:iend,
%         xm=xm+a.Data.X(j); % en mm
%         zm=zm+a.Data.Z(j);
%      end
%      Xm(i)=xm/(iend-istart+1);
%      Zm(i)=zm/(iend-istart+1);
     Xm(i)=(1-2*rand(1))*3;
     Zm(i)=(1-2*rand(1))*3;
end

clear Xr Xr2
Xr2=0;
i=0;
for j=1:nbpmx,
    if (hs(j)==1) 
       i=i+1;
       Xr(i)=Xm(j);
       Xr2 = Xr2 + Xr(i)*Xr(i);
    end    
end
Xr2=sqrt(Xr2/i);   % ecart type orbite
set(handles.edit_Xrms,'String',[num2str(Xr2),' mm rms']);

% Resolution par SVD matrice Cc cyclique sur X
clear Xcorr Cci K
[U,S,V] = svds(Cc,ncorrxr);
diag(S)
for i=1:min(nbpmxr,ncorrxr)
    if(S(i,i)<maxvp)
        S(i,i)=0;
    else
        S(i,i)=1/S(i,i);
    end    
end   
Cci=V*S*U';
K=-Cci*transpose(Xr);                % en mrad
Xcorr= transpose(Xr) + Cc*K*step;



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
        K2(i)=0;
    else
        j=j+1;
        K1(i)=K(j)/1.2*step;           % en Ampere
        K2(i)=K(j)/1.2;
        sumcorr =sumcorr + K1(i);
    end    
end

% K2=getam('HCOR');
% for i=1:ncorrx,
%     if (K1(i)<1.5)
%        stepsp('HCOR',K1(i),[i 1]);
%     end    
% end 

axes(handles.axes_orbit)

plot(s_bx,Xm,'-ok','MarkerFaceColor','k'); hold on
plot(s_bpmx,Xr,'or','MarkerFaceColor','r');hold off

xlim([0 156]); ylim([-4 4]);
ylabel('Orbite');
grid on

axes(handles.axes_corr)
bar(s_cx,K1,0.5)
ylabel('I (A)');xlabel('Position S');
xlim([0 156]);ylim([-1.5 1.5])













function betamin_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function betamin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nux_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function nux_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function betamax_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function betamax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%%%%%%%%%% liste BPM et correcteurs %%%%%%%%%%%%%%%%%%%%%



% --- Executes on button press in checkbox1.
function BPM1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function BPM2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function BPM3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function BPM4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function BPM5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function BPM6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function BPM7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function BPM8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox9.
function BPM9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function BPM10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function BPM11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in BPM12.
function BPM12_Callback(hObject, eventdata, handles)
% hObject    handle to BPM12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM12


% --- Executes on button press in BPM13.
function BPM13_Callback(hObject, eventdata, handles)
% hObject    handle to BPM13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM13


% --- Executes on button press in BPM14.
function BPM14_Callback(hObject, eventdata, handles)
% hObject    handle to BPM14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM14


% --- Executes on button press in BPM15.
function BPM15_Callback(hObject, eventdata, handles)
% hObject    handle to BPM15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM15


% --- Executes on button press in BPM16.
function BPM16_Callback(hObject, eventdata, handles)
% hObject    handle to BPM16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM16


% --- Executes on button press in BPM17.
function BPM17_Callback(hObject, eventdata, handles)
% hObject    handle to BPM17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM17


% --- Executes on button press in BPM18.
function BPM18_Callback(hObject, eventdata, handles)
% hObject    handle to BPM18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM18


% --- Executes on button press in BPM19.
function BPM19_Callback(hObject, eventdata, handles)
% hObject    handle to BPM19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM19


% --- Executes on button press in BPM20.
function BPM20_Callback(hObject, eventdata, handles)
% hObject    handle to BPM20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM20


% --- Executes on button press in BPM21.
function BPM21_Callback(hObject, eventdata, handles)
% hObject    handle to BPM21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM21


% --- Executes on button press in BPM22.
function BPM22_Callback(hObject, eventdata, handles)
% hObject    handle to BPM22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BPM22




% --- Executes on button press in CORR1.
function CORR1_Callback(hObject, eventdata, handles)
% hObject    handle to CORR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR1


% --- Executes on button press in CORR2.
function CORR2_Callback(hObject, eventdata, handles)
% hObject    handle to CORR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR2


% --- Executes on button press in CORR3.
function CORR3_Callback(hObject, eventdata, handles)
% hObject    handle to CORR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR3


% --- Executes on button press in CORR4.
function CORR4_Callback(hObject, eventdata, handles)
% hObject    handle to CORR4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR4


% --- Executes on button press in CORR5.
function CORR5_Callback(hObject, eventdata, handles)
% hObject    handle to CORR5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR5


% --- Executes on button press in CORR6.
function CORR6_Callback(hObject, eventdata, handles)
% hObject    handle to CORR6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR6


% --- Executes on button press in CORR7.
function CORR7_Callback(hObject, eventdata, handles)
% hObject    handle to CORR7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR7



% --- Executes on button press in CORR8.
function CORR8_Callback(hObject, eventdata, handles)
% hObject    handle to CORR7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR8



% --- Executes on button press in CORR9.
function CORR9_Callback(hObject, eventdata, handles)
% hObject    handle to CORR7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR9




% --- Executes on button press in CORR10.
function CORR10_Callback(hObject, eventdata, handles)
% hObject    handle to CORR10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR10


% --- Executes on button press in CORR11.
function CORR11_Callback(hObject, eventdata, handles)
% hObject    handle to CORR11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR11


% --- Executes on button press in CORR12.
function CORR12_Callback(hObject, eventdata, handles)
% hObject    handle to CORR12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR12


% --- Executes on button press in CORR13.
function CORR13_Callback(hObject, eventdata, handles)
% hObject    handle to CORR13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR13


% --- Executes on button press in CORR14.
function CORR14_Callback(hObject, eventdata, handles)
% hObject    handle to CORR14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR14


% --- Executes on button press in CORR15.
function CORR15_Callback(hObject, eventdata, handles)
% hObject    handle to CORR15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR15


% --- Executes on button press in CORR16.
function CORR16_Callback(hObject, eventdata, handles)
% hObject    handle to CORR16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR16


% --- Executes on button press in CORR17.
function CORR17_Callback(hObject, eventdata, handles)
% hObject    handle to CORR17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR17


% --- Executes on button press in CORR18.
function CORR18_Callback(hObject, eventdata, handles)
% hObject    handle to CORR18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR18


% --- Executes on button press in CORR19.
function CORR19_Callback(hObject, eventdata, handles)
% hObject    handle to CORR19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR19


% --- Executes on button press in CORR20.
function CORR20_Callback(hObject, eventdata, handles)
% hObject    handle to CORR20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR20


% --- Executes on button press in CORR21.
function CORR21_Callback(hObject, eventdata, handles)
% hObject    handle to CORR21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR21


% --- Executes on button press in CORR22.
function CORR22_Callback(hObject, eventdata, handles)
% hObject    handle to CORR22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CORR22



function edit_Nbpm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Nbpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Nbpm as text
%        str2double(get(hObject,'String')) returns contents of edit_Nbpm as a double


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

% Hints: get(hObject,'String') returns contents of edit_Ncorr as text
%        str2double(get(hObject,'String')) returns contents of edit_Ncorr as a double


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

% Hints: get(hObject,'String') returns contents of edit_Xrms as text
%        str2double(get(hObject,'String')) returns contents of edit_Xrms as a double


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

% Hints: get(hObject,'String') returns contents of edit_tdeb as text
%        str2double(get(hObject,'String')) returns contents of edit_tdeb as a double


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

% Hints: get(hObject,'String') returns contents of edit_tfin as text
%        str2double(get(hObject,'String')) returns contents of edit_tfin as a double


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


