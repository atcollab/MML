function varargout = DserverBPM(varargin)
% DSERVERBPM M-file for DserverBPM.fig
%      DSERVERBPM, by itself, creates a new DSERVERBPM or raises the existing
%      singleton*.
%
%      H = DSERVERBPM returns the handle to a new DSERVERBPM or the handle to
%      the existing singleton*.
%
%      DSERVERBPM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSERVERBPM.M with the given input arguments.
%
%      DSERVERBPM('Property','Value',...) creates a new DSERVERBPM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DserverBPM_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DserverBPM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help DserverBPM

% Last Modified by GUIDE v2.5 05-Sep-2005 16:02:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DserverBPM_OpeningFcn, ...
                   'gui_OutputFcn',  @DserverBPM_OutputFcn, ...
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


% --- Executes just before DserverBPM is made visible.
function DserverBPM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DserverBPM (see VARARGIN)

% Choose default command line output for DserverBPM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DserverBPM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DserverBPM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dev_name_Callback(hObject, eventdata, handles)
% hObject    handle to dev_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dev_name as text
%        str2double(get(hObject,'String')) returns contents of dev_name as a double
dev=get(handles.dev_name,'String')
val_dev=get(handles.dev_name,'value')
mode=tango_read_attribute(dev{val_dev},'Mode');
set(handles.Current_mode,'String',mode.value);


Nvalues=tango_read_attribute(dev{val_dev},'NumSamples');
set(handles.Nsamples,'String',num2str(Nvalues.value(1)));

% --- Executes during object creation, after setting all properties.
function dev_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dev_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function Nsamples_Callback(hObject, eventdata, handles)
% hObject    handle to Nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nsamples as text
%        str2double(get(hObject,'String')) returns contents of Nsamples as a double
Nvaleurs=int32(str2num(get(handles.Nsamples,'String')));
dev=get(handles.dev_name,'String');
val_dev=get(handles.dev_name,'value');
tango_write_attribute(dev{val_dev},'NumSamples',Nvaleurs);
if tango_error==-1
    tango_print_error_stack;
    error('Write attribute');
    return
end
    
%test_erreur_tango;
argout=tango_read_attribute2(dev{val_dev},'NumSamples');
%test_erreur_tango;
if argout.value(1)~=Nvaleurs
    disp('Le nombre de valeurs demandees n a pas ete mis a jour');
end
% --- Executes during object creation, after setting all properties.
function Nsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Change_mode.
function Change_mode_Callback(hObject, eventdata, handles)
% hObject    handle to Change_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Change_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Change_mode
val=get(handles.Change_mode,'Value')
dev=get(handles.dev_name,'String')
val_dev=get(handles.dev_name,'value')

switch val
    case 1
        tango_write_attribute(dev{val_dev},'Mode','MODE_FT') 
        %test_erreur_tango;
    case 2
        tango_write_attribute(dev{val_dev},'Mode','MODE_TT') 
        %test_erreur_tango;
    case 3
         tango_write_attribute(dev{val_dev},'Mode','MODE_BN') 
         set(handles.Current_mode,'String','Boo Normal');
         set(handles.Nsamples,'string',num2str(10169));
end;
mode=tango_read_attribute(dev{val_dev},'Mode')
%test_erreur_tango;
set(handles.Current_mode,'String',mode.value);

% --- Executes during object creation, after setting all properties.
function Change_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Change_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Current_mode_Callback(hObject, eventdata, handles)
% hObject    handle to Current_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_mode as text
%        str2double(get(hObject,'String')) returns contents of Current_mode as a double


% --- Executes during object creation, after setting all properties.
function Current_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Current_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Get_mode.
function Get_mode_Callback(hObject, eventdata, handles)
% hObject    handle to Get_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dev=get(handles.dev_name,'String')
val_dev=get(handles.dev_name,'value')
mode=tango_read_attribute(dev{val_dev},'Mode');
set(handles.Current_mode,'String',mode.value);

% --- Executes on button press in pushbutton14.
function Get_data_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X Z Q Sum Va Vb Vc Vd Stop;

dev=get(handles.dev_name,'String');
val_dev=get(handles.dev_name,'value');

Nsamples=int32(str2num(get(handles.Nsamples,'String')));
%tango_write_attribute(dev{val_dev},'NumSamples',Nsamples);
%test_erreur_tango;

tango_set_timeout(dev{val_dev},30000);
tango_get_timeout(dev{val_dev});
Attr_name_list={'XPosVector','ZPosVector','QuadVector','SumVector','VaVector','VbVector','VcVector','VdVector'};
Stop=0;
while Stop==0,
String=get(handles.Moyennage,'String');
val=get(handles.Moyennage,'Value');
Moyenne=str2num(String{val})
val=get(handles.Aquisition_continue,'Value');
switch val
    case 0
        Stop=1;
    case 1
        Stop=0;
end
argout=tango_read_attributes(dev{val_dev},Attr_name_list);
%test_erreur_tango;
X=argout(1).value;
Z=argout(2).value;
Q=argout(3).value;
Sum=argout(4).value;
Va=argout(5).value;
Vb=argout(6).value;
Vc=argout(7).value;
Vd=argout(8).value;

X_display=0;
Z_display=0;
Q_display=0;
Sum_display=0;
Va_display=0;
Vb_display=0;
Vc_display=0;
Vd_display=0;

if (Moyenne==1)
    X_display=X;
    Z_display=Z;
    Q_display=Q;
    Sum_display=Sum;
    Va_display=Va;
    Vb_display=Vb;
    Vc_display=Vc;
    Vd_display=Vd;
    
else
    for i=1:Moyenne:Nsamples,    
     X_display=[X_display,mean(X(i:i+Moyenne-1))];
     Z_display=[Z_display,mean(Z(i:i+Moyenne-1))];
     Q_display=[Q_display,mean(Q(i:i+Moyenne-1))];
     Sum_display=[Sum_display,mean(Sum(i:i+Moyenne-1))];
     Va_display=[Va_display,mean(Va(i:i+Moyenne-1))];
     Vb_display=[Vb_display,mean(Vb(i:i+Moyenne-1))];
     Vc_display=[Vc_display,mean(Vc(i:i+Moyenne-1))];
     Vd_display=[Vd_display,mean(Vd(i:i+Moyenne-1))];
     
    end
    X_display=X_display(2:size(X_display,2)); 
    Z_display=Z_display(2:size(Z_display,2)); 
    Q_display=Q_display(2:size(Q_display,2)); 
    Sum_display=Sum_display(2:size(Sum_display,2));
    Va_display=Va_display(2:size(Va_display,2));
    Vb_display=Vb_display(2:size(Vb_display,2));
    Vc_display=Vc_display(2:size(Vc_display,2));
    Vd_display=Vd_display(2:size(Vd_display,2));
    
end

axes(handles.Graph_X);
plot(X_display);ylabel('mm');
title('X');
set(handles.Graph_X,'YLim',[-5 5]);
%set(handles.Graph_X,'XLim',[0 200]);

axes(handles.Graph_Z);
plot(Z_display);
title('Z');ylabel('mm');
set(handles.Graph_Z,'YLim',[-5 5]);
%set(handles.Graph_Z,'XLim',[0 200]);

axes(handles.Graph_Q);
plot(Q_display);title('Q');ylabel('mm');
set(handles.Graph_Q,'YLim',[-5 5]);
%set(handles.Graph_Q,'XLim',[0 200]);

axes(handles.Graph_Somme);
plot(Sum_display);title('Somme');
%set(handles.Graph_Somme,'YLim',[0 1.2e9]);
%set(handles.Graph_Somme,'XLim',[0 200]);

val=get(handles.Display_channels,'Value');
switch val
    case 0
    case 1
        figure(1)
        subplot(2,2,1);plot(Va); title('VA'); 
        subplot(2,2,2);plot(Vb); title('VB'); 
        subplot(2,2,3);plot(Vc); title('VC'); 
        subplot(2,2,4);plot(Vd); title('VD'); 
end
        

       
val=get(handles.Detection,'Value');
switch val
    case 0
    case 1
        [Max_sum,I]=max(Sum_display)
        seuil=0.9*Max_sum;
        indices=find(Sum_display>seuil);
        figure(2)
        subplot(2,2,1);plot(indices,X_display(indices)); title('X');
        valeur=num2str(X_display(indices));
         legend(valeur);
        subplot(2,2,2);plot(indices,Z_display(indices)); title('Z');
        valeur=num2str(Z_display(indices));
         legend(valeur);
        subplot(2,2,3);plot(indices,Q_display(indices)); title('Q');
        subplot(2,2,4);plot(indices,Sum_display(indices)); title('Sum'); 
end
        
 pause(1);
end
          





% --- Executes on button press in Display_channels.
function Display_channels_Callback(hObject, eventdata, handles)
% hObject    handle to Display_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Display_channels
global Va Vb Vc Vd;
val=get(handles.Display_channels,'Value');
switch val
    case 0
    case 1
        figure(1)
        subplot(2,2,1);plot(Va); title('VA'); 
        subplot(2,2,2);plot(Vb); title('VB'); 
        subplot(2,2,3);plot(Vc); title('VC'); 
        subplot(2,2,4);plot(Vd); title('VD'); 
end



% --- Executes on selection change in Moyennage.
function Moyennage_Callback(hObject, eventdata, handles)
% hObject    handle to Moyennage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Moyennage contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Moyennage
global X Z Q Sum Va Vb Vc Vd;
Nsamples=str2num(get(handles.Nsamples,'String'));
String=get(handles.Moyennage,'String');
val=get(handles.Moyennage,'Value');
Moyenne=str2num(String{val})

hX=get(handles.Graph_X,'children');
hZ=get(handles.Graph_Z,'children');
hQ=get(handles.Graph_Q,'children');
hSum=get(handles.Graph_Somme,'children');

    
X_display=0;
Z_display=0;
Q_display=0;
Sum_display=0;
Va_display=0;
Vb_display=0;
Vc_display=0;
Vd_display=0;

if (Moyenne==1)
    X_display=X;
    Z_display=Z;
    Q_display=Q;
    Sum_display=Sum;
    Va_display=Va;
    Vb_display=Vb;
    Vc_display=Vc;
    Vd_display=Vd;
else
    for i=1:Moyenne:Nsamples,    
        X_display=[X_display,mean(X(i:i+Moyenne-1))];
        Z_display=[Z_display,mean(Z(i:i+Moyenne-1))];
        Q_display=[Q_display,mean(Q(i:i+Moyenne-1))];
        Sum_display=[Sum_display,mean(Sum(i:i+Moyenne-1))];
        Va_display=[Va_display,mean(Va(i:i+Moyenne-1))];
        Vb_display=[Vb_display,mean(Vb(i:i+Moyenne-1))];
        Vc_display=[Vc_display,mean(Vc(i:i+Moyenne-1))];
        Vd_display=[Vd_display,mean(Vd(i:i+Moyenne-1))];
    end
    X_display=X_display(2:size(X_display,2)); 
    Z_display=Z_display(2:size(Z_display,2)); 
    Q_display=Q_display(2:size(Q_display,2)); 
    Sum_display=Sum_display(2:size(Sum_display,2));
    Va_display=Va_display(2:size(Va_display,2));
    Vb_display=Vb_display(2:size(Vb_display,2));
    Vc_display=Vc_display(2:size(Vc_display,2));
    Vd_display=Vd_display(2:size(Vd_display,2));

end

set(hX,'YData',X_display);
set(hZ,'YData',Z_display);
set(hQ,'YData',Q_display);
set(hSum,'YData',Sum_display);
val=get(handles.Display_channels,'Value');
switch val
    case 0
    case 1
        figure(1)
        subplot(2,2,1);plot(Va_display); title('VA'); 
        subplot(2,2,2);plot(Vb_display); title('VB'); 
        subplot(2,2,3);plot(Vc_display); title('VC'); 
        subplot(2,2,4);plot(Vd_display); title('VD'); 
end

% --- Executes during object creation, after setting all properties.
function Moyennage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Moyennage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Stop;
Stop=1;



% --- Executes on button press in Aquisition_continue.
function Aquisition_continue_Callback(hObject, eventdata, handles)
% hObject    handle to Aquisition_continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Aquisition_continue





function Filename_Callback(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filename as text
%        str2double(get(hObject,'String')) returns contents of Filename as a double


% --- Executes during object creation, after setting all properties.
function Filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X Z Q Sum Va Vb Vc Vd;
Nsamples=str2num(get(handles.Nsamples,'String'));
dev=get(handles.dev_name,'String');
val_dev=get(handles.dev_name,'value');
mode=tango_read_attribute(dev{val_dev},'Mode');
filename=get(handles.Filename,'String')
%filepath=['c:\testni\ESRF\',filename]
save(filename,'Nsamples','mode','X','Z','Q','Sum','Va','Vb','Vc','Vd');


% --- Executes on button press in Detection.
function Detection_Callback(hObject, eventdata, handles)
% hObject    handle to Detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Detection


