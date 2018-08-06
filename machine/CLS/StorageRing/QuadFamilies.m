 function varargout = QuadFamilies(varargin)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/QuadFamilies.m 1.2 2007/03/02 09:02:52CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% QUADFAMILIES M-file for QuadFamilies.fig
%      QUADFAMILIES, by itself, creates a new QUADFAMILIES or raises the existing
%      singleton*.
%
%      H = QUADFAMILIES returns the handle to a new QUADFAMILIES or the handle to
%      the existing singleton*.
%
%      QUADFAMILIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUADFAMILIES.M with the given input arguments.
%
%      QUADFAMILIES('Property','Value',...) creates a new QUADFAMILIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QuadFamilies_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QuadFamilies_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QuadFamilies

% Last Modified by GUIDE v2.5 22-Oct-2003 19:46:15
% ----------------------------------------------------------------------------------------------

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QuadFamilies_OpeningFcn, ...
                   'gui_OutputFcn',  @QuadFamilies_OutputFcn, ...
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
% add some user defines here

% --- Executes just before QuadFamilies is made visible.
function QuadFamilies_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QuadFamilies (see VARARGIN)
USECA = 0;
% Choose default command line output for QuadFamilies
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QuadFamilies wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QuadFamilies_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function QFASlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QFASlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
a=getsp('QFA');
set(hObject,'Value',[a(1)]);
set(handles.('QFAFld'),'String', a(1));

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function QFASlider_Callback(hObject, eventdata, handles)
% hObject    handle to QFASlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
x=get(hObject,'Value');

setpv('QFA','Setpoint',x);
      
fprintf('QFASlider = %f\n',x);
set(handles.('QFAFld'),'String', x);

% --- Executes during object creation, after setting all properties.
function QFBSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QFBSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
a=getsp('QFB');
set(hObject,'Value',[a(1)]);
set(handles.('QFBFld'),'String', get(hObject,'Value'));
% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function QFBSlider_Callback(hObject, eventdata, handles)
% hObject    handle to QFBSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
x = get(hObject,'Value');

setpv('QFB','Setpoint',x);
    
fprintf('QFBSlider = %f\n',x);
set(handles.('QFBFld'),'String', x);


% --- Executes during object creation, after setting all properties.
function QFCSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QFCSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
a=getsp('QFC');
set(hObject,'Value',[a(1)]);
% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function QFCSlider_Callback(hObject, eventdata, handles)
% hObject    handle to QFCSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
x = get(hObject,'Value');
setpv('QFC','Setpoint',x);
 
fprintf('QFCSlider = %f\n',x);

%set(handles.('QFCFld'),'String', x);

% --- Executes on button press in SweepABtn.
function SweepABtn_Callback(hObject, eventdata, handles)
% hObject    handle to SweepABtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%curSp=getsp('QFA');
%set(handles.('origQFAValFld'),'String', curSp(1));

	r = get(hObject,'Value'); 
	% Hint: get(hObject,'Value') returns toggle state of SweepABtn
	step = str2double(get(handles.('StepSizeA'),'String'));
	range = str2double(get(handles.('UpperRangeAEdt'),'String'));
	N = (range*2)/ step;
	%curPos = get(handles.('QFASlider'),'Value');
	curSp=getsp('QFA');
	curPos = curSp(1);
	fprintf('orig QFASlider = %f\n',curSp(1));
	
	for i = 1:N
        %keep looping until the operator clicks the radio off
        if(get(hObject,'Value') == 1)
            %start at the bottom of range and move up
            x = (i*step) + curPos - range;
            setpv('QFA','Setpoint',x);
            set(handles.('QFASlider'),'Value',x);
            fprintf('QFASlider = %f\n',x);
            set(handles.('QFAFld'),'String', x);
            pause(5);
            
        else
            %kick out
            break;
        end
        
	end
    fprintf('QFASlider Sweep Complete\n');
    busy = 0;
    set(hObject,'Value',0)
    
%if the radio btn is still on then we want to go back to teh original val
%else leave as is (where ever it was clicked off
%if(get(hObject,'Value') == 1)
    %reset the value to the original one
%    set(handles.('QFASlider'),'Value',curSp(1));
%    fprintf('unDoing QFASlider move back to %f\n',curSp(1));
%    set(handles.('QFAFld'),'String', curSp(1));
%end

% --- Executes during object creation, after setting all properties.
function UpperRangeAEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpperRangeAEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function UpperRangeAEdt_Callback(hObject, eventdata, handles)
% hObject    handle to UpperRangeAEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UpperRangeAEdt as text
%        str2double(get(hObject,'String')) returns contents of UpperRangeAEdt as a double


% --- Executes during object creation, after setting all properties.
function LowerRangeAEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowerRangeAEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function LowerRangeAEdt_Callback(hObject, eventdata, handles)
% hObject    handle to LowerRangeAEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowerRangeAEdt as text
%        str2double(get(hObject,'String')) returns contents of LowerRangeAEdt as a double


% --- Executes on button press in UndoABtn.
function UndoABtn_Callback(hObject, eventdata, handles)
% hObject    handle to UndoABtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2double(get(handles.('origQFAValFld'),'String'));
setpv('QFA','Setpoint',val);
set(handles.('QFASlider'),'Value',val);
fprintf('QFASlider = %f\n',val);
set(handles.('QFAFld'),'String', val);

% --- Executes on button press in GrabABtn.
function GrabABtn_Callback(hObject, eventdata, handles)
% hObject    handle to GrabABtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curSp=getsp('QFA');
set(handles.('origQFAValFld'),'String', curSp(1));

% --- Executes during object creation, after setting all properties.
function StepSizeA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StepSizeA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function StepSizeA_Callback(hObject, eventdata, handles)
% hObject    handle to StepSizeA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepSizeA as text
%        str2double(get(hObject,'String')) returns contents of StepSizeA as a double


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3


% --- Executes during object creation, after setting all properties.
function UpperRangeBEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpperRangeBEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function UpperRangeBEdt_Callback(hObject, eventdata, handles)
% hObject    handle to UpperRangeBEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UpperRangeBEdt as text
%        str2double(get(hObject,'String')) returns contents of UpperRangeBEdt as a double


% --- Executes on button press in UndoBBtn.
function UndoBBtn_Callback(hObject, eventdata, handles)
% hObject    handle to UndoBBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2double(get(handles.('origQFBValFld'),'String'));
setpv('QFB','Setpoint',val);
set(handles.('QFBSlider'),'Value',val);
fprintf('QFBSlider = %f\n',val);
set(handles.('QFBFld'),'String', val);

% --- Executes on button press in GrabBBtn.
function GrabBBtn_Callback(hObject, eventdata, handles)
% hObject    handle to GrabBBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curSp=getsp('QFB');
set(handles.('origQFBValFld'),'String', curSp(1));

% --- Executes during object creation, after setting all properties.
function StepSizeB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StepSizeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function StepSizeB_Callback(hObject, eventdata, handles)
% hObject    handle to StepSizeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepSizeB as text
%        str2double(get(hObject,'String')) returns contents of StepSizeB as a double


% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton4


% --- Executes during object creation, after setting all properties.
function UpperRangeCEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpperRangeCEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function UpperRangeCEdt_Callback(hObject, eventdata, handles)
% hObject    handle to UpperRangeCEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UpperRangeCEdt as text
%        str2double(get(hObject,'String')) returns contents of UpperRangeCEdt as a double


% --- Executes on button press in UndoCBtn.
function UndoCBtn_Callback(hObject, eventdata, handles)
% hObject    handle to UndoCBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = str2double(get(handles.('origQFCValFld'),'String'));
setpv('QFC','Setpoint',val);
set(handles.('QFCSlider'),'Value',val);
fprintf('QFCSlider = %f\n',val);
set(handles.('QFCFld'),'String', val);

% --- Executes on button press in GrabCBtn.
function GrabCBtn_Callback(hObject, eventdata, handles)
% hObject    handle to GrabCBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curSp=getsp('QFC');
set(handles.('origQFCValFld'),'String', curSp(1));

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function StepSizeC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StepSizeC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function StepSizeC_Callback(hObject, eventdata, handles)
% hObject    handle to StepSizeC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepSizeC as text
%        str2double(get(hObject,'String')) returns contents of StepSizeC as a double


% --- Executes on button press in SweepBBtn.
function SweepBBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SweepBBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SweepBBtn
%curSp=getsp('QFB');
%set(handles.('origQFBValFld'),'String', curSp(1));

	r = get(hObject,'Value'); 
	% Hint: get(hObject,'Value') returns toggle state of SweepABtn
	step = str2double(get(handles.('StepSizeB'),'String'));
	range = str2double(get(handles.('UpperRangeBEdt'),'String'));
	N = (range*2)/ step;
	%curPos = get(handles.('QFBSlider'),'Value');
	curSp=getsp('QFB');
	curPos = curSp(1);
	fprintf('orig QFBSlider = %f\n',curSp(1));
	
	for i = 1:N
        %keep looping until the operator clicks the radio off
        if(get(hObject,'Value') == 1)
            %start at the bottom of range and move up
            x = (i*step) + curPos - range;
            setpv('QFB','Setpoint',x);
            set(handles.('QFBSlider'),'Value',x);
            fprintf('QFBSlider = %f\n',x);
            set(handles.('QFBFld'),'String', x);
            pause(5);
            
        else
            %kick out
            break;
        end
        
	end
    fprintf('QFBSlider Sweep Complete\n');
    busy = 0;
    set(hObject,'Value',0)


% --- Executes on button press in SweepCBtn.
function SweepCBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SweepCBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SweepCBtn
%curSp=getsp('QFC');
%set(handles.('origQFCValFld'),'String', curSp(1));

	r = get(hObject,'Value'); 
	% Hint: get(hObject,'Value') returns toggle state of SweepCBtn
	step = str2double(get(handles.('StepSizeC'),'String'));
	range = str2double(get(handles.('UpperRangeCEdt'),'String'));
	N = (range*2)/ step;
	%curPos = get(handles.('QFCSlider'),'Value');
	curSp=getsp('QFC');
	curPos = curSp(1);
	fprintf('orig QFCSlider = %f\n',curSp(1));
	
	for i = 1:N
        %keep looping until the operator clicks the radio off
        if(get(hObject,'Value') == 1)
            %start at the bottom of range and move up
            x = (i*step) + curPos - range;
            setpv('QFC','Setpoint',x);
            set(handles.('QFCSlider'),'Value',x);
            fprintf('QFCSlider = %f\n',x);
            set(handles.('QFCFld'),'String', x);
            pause(5);
            
        else
            %kick out
            break;
        end
        
	end
    fprintf('QFCSlider Sweep Complete\n');
    busy = 0;
    set(hObject,'Value',0)

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/QuadFamilies.m  $
% Revision 1.2 2007/03/02 09:02:52CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
