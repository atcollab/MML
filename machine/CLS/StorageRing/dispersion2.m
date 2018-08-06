function varargout = dispersion2(varargin)
% DISPERSION2 M-file for dispersion2.fig
%      DISPERSION2, by itself, creates a new DISPERSION2 or raises the existing
%      singleton*.
%
%      H = DISPERSION2 returns the handle to a new DISPERSION2 or the handle to
%      the existing singleton*.
%
%      DISPERSION2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPERSION2.M with the given input arguments.
%
%      DISPERSION2('Property','Value',...) creates a new DISPERSION2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dispersion2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dispersion2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dispersion2

% Last Modified by GUIDE v2.5 28-Jan-2007 12:52:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dispersion2_OpeningFcn, ...
                   'gui_OutputFcn',  @dispersion2_OutputFcn, ...
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


% --- Executes just before dispersion2 is made visible.
function dispersion2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dispersion2 (see VARARGIN)


% Choose default command line output for dispersion2
handles.output = hObject;


%--------------------------------------------------------------------------
%Initializes variables
%Opens communication with epics
%--------------------------------------------------------------------------
handles.QFAPvName=['QFA1401-01:dac';'QFA1401-02:dac';'QFA1402-01:dac';'QFA1402-02:dac';'QFA1403-01:dac';'QFA1403-02:dac';'QFA1404-01:dac';'QFA1404-02:dac';'QFA1405-01:dac';'QFA1405-02:dac';'QFA1406-01:dac';'QFA1406-02:dac';'QFA1407-01:dac';'QFA1407-02:dac';'QFA1408-01:dac';'QFA1408-02:dac';'QFA1409-01:dac';'QFA1409-02:dac';'QFA1410-01:dac';'QFA1410-02:dac';'QFA1411-01:dac';'QFA1411-02:dac';'QFA1412-01:dac';'QFA1412-02:dac'];

for n=[1:24]
    handles.QFAH(n)=mcaopen(handles.QFAPvName(n,:));
end

handles.QFBPvName=['QFB1401-01:dac';'QFB1401-02:dac';'QFB1402-01:dac';'QFB1402-02:dac';'QFB1403-01:dac';'QFB1403-02:dac';'QFB1404-01:dac';'QFB1404-02:dac';'QFB1405-01:dac';'QFB1405-02:dac';'QFB1406-01:dac';'QFB1406-02:dac';'QFB1407-01:dac';'QFB1407-02:dac';'QFB1408-01:dac';'QFB1408-02:dac';'QFB1409-01:dac';'QFB1409-02:dac';'QFB1410-01:dac';'QFB1410-02:dac';'QFB1411-01:dac';'QFB1411-02:dac';'QFB1412-01:dac';'QFB1412-02:dac'];

for n=[1:24]
    handles.QFBH(n)=mcaopen(handles.QFBPvName(n,:));
end

handles.QFCPvName=['QFC1401-01:dac';'QFC1401-02:dac';'QFC1402-01:dac';'QFC1402-02:dac';'QFC1403-01:dac';'QFC1403-02:dac';'QFC1404-01:dac';'QFC1404-02:dac';'QFC1405-01:dac';'QFC1405-02:dac';'QFC1406-01:dac';'QFC1406-02:dac';'QFC1407-01:dac';'QFC1407-02:dac';'QFC1408-01:dac';'QFC1408-02:dac';'QFC1409-01:dac';'QFC1409-02:dac';'QFC1410-01:dac';'QFC1410-02:dac';'QFC1411-01:dac';'QFC1411-02:dac';'QFC1412-01:dac';'QFC1412-02:dac'];

for n=[1:24]
    handles.QFCH(n)=mcaopen(handles.QFCPvName(n,:));
end

%Declare quad feedback and open communication

handles.QFAPvNameFbk=['QFA1401-01:adc';'QFA1401-02:adc';'QFA1402-01:adc';'QFA1402-02:adc';'QFA1403-01:adc';'QFA1403-02:adc';'QFA1404-01:adc';'QFA1404-02:adc';'QFA1405-01:adc';'QFA1405-02:adc';'QFA1406-01:adc';'QFA1406-02:adc';'QFA1407-01:adc';'QFA1407-02:adc';'QFA1408-01:adc';'QFA1408-02:adc';'QFA1409-01:adc';'QFA1409-02:adc';'QFA1410-01:adc';'QFA1410-02:adc';'QFA1411-01:adc';'QFA1411-02:adc';'QFA1412-01:adc';'QFA1412-02:adc'];

for n=[1:24]
    handles.QFAFbkH(n)=mcaopen(handles.QFAPvNameFbk(n,:));
end

handles.QFBPvNameFbk=['QFB1401-01:adc';'QFB1401-02:adc';'QFB1402-01:adc';'QFB1402-02:adc';'QFB1403-01:adc';'QFB1403-02:adc';'QFB1404-01:adc';'QFB1404-02:adc';'QFB1405-01:adc';'QFB1405-02:adc';'QFB1406-01:adc';'QFB1406-02:adc';'QFB1407-01:adc';'QFB1407-02:adc';'QFB1408-01:adc';'QFB1408-02:adc';'QFB1409-01:adc';'QFB1409-02:adc';'QFB1410-01:adc';'QFB1410-02:adc';'QFB1411-01:adc';'QFB1411-02:adc';'QFB1412-01:adc';'QFB1412-02:adc'];

for n=[1:24]
    handles.QFBFbkH(n)=mcaopen(handles.QFBPvNameFbk(n,:));
end

handles.QFCPvNameFbk=['QFC1401-01:adc';'QFC1401-02:adc';'QFC1402-01:adc';'QFC1402-02:adc';'QFC1403-01:adc';'QFC1403-02:adc';'QFC1404-01:adc';'QFC1404-02:adc';'QFC1405-01:adc';'QFC1405-02:adc';'QFC1406-01:adc';'QFC1406-02:adc';'QFC1407-01:adc';'QFC1407-02:adc';'QFC1408-01:adc';'QFC1408-02:adc';'QFC1409-01:adc';'QFC1409-02:adc';'QFC1410-01:adc';'QFC1410-02:adc';'QFC1411-01:adc';'QFC1411-02:adc';'QFC1412-01:adc';'QFC1412-02:adc'];

for n=[1:24]
    handles.QFCFbkH(n)=mcaopen(handles.QFCPvNameFbk(n,:));
end


handles.Neg_Radio_State = 0;
handles.Pos_Radio_State = 0;
handles.Dispersion = 0.15;
handles.StartVal = 1;


%Declare quad values for the different dispersions
handles.QuadValues = [0.3 1.99228 1.49173 1.98553
                        0.29 1.98945 1.48760 1.9898
                        0.28 1.98671 1.48351 1.99403
                        0.27 1.98406 1.47945 1.9982
                        0.26 1.98150 1.47543 2.00233
                        0.25 1.97903 1.47144 2.00642
                        0.24 1.97663 1.46749 2.01047
                        0.23 1.97431 1.46357 2.01448
                        0.22 1.97207 1.45967 2.01845
                        0.21 1.96990 1.45581 2.02238
                        0.20 1.96780 1.45197 2.02628
                        0.19 1.96576 1.44816 2.03015
                        0.18 1.96379 1.44437 2.03398
                        0.17 1.96188 1.44061 2.03778
                        0.16 1.96003 1.43687 2.04156
                        0.15 1.95815 1.43330 2.04530
                        0.14 1.95649 1.42946 2.04902
                        0.13 1.95481 1.42579 2.05271
                        0.12 1.95317 1.42214 2.05637
                        0.11 1.95159 1.41851 2.06001
                        0.10 1.94997 1.41504 2.06363
                        0.09 1.94857 1.41130 2.06722
                        0.08 1.94712 1.40773 2.07079
                        0.07 1.94572 1.40417 2.07434
                        0.06 1.94437 1.40064 2.07786
                        0.05 1.94297 1.39726 2.08137
                        0.04 1.94178 1.39361 2.08485
                        0.03 1.94054 1.39012 2.08832
                        0.02 1.93935 1.38665 2.09177
                        0.01 1.93819 1.38319 2.09520
                        0 1.93697 1.37990 2.09861
                        -0.01 1.93597 1.37632 2.10200
                        -0.02 1.93492 1.37291 2.10538
                        -0.03 1.93389 1.36951 2.10874
                        -0.04 1.93290 1.36613 2.11209
                        -0.05 1.93186 1.36290 2.11542
                        -0.06 1.93102 1.35940 2.11873
                        -0.07 1.93012 1.35606 2.12203
                        -0.08 1.92925 1.35273 2.12532
                        -0.09 1.92841 1.34941 2.12859
                        -0.10 1.92750 1.34624 2.13185
                        -0.11 1.92681 1.34281 2.13509
                        -0.12 1.92604 1.33952 2.13833
                        -0.13 1.92531 1.33625 2.14154
                        -0.14 1.92460 1.33299 2.14475
                        -0.15 1.92383 1.32989 2.14795
                        -0.16 1.92325 1.32651 2.15113
                        -0.17 1.92261 1.32328 2.15430
                        -0.18 1.92200 1.32007 2.15746
                        -0.19 1.92141 1.31686 2.16061  
                        -0.20 1.92075 1.31381 2.16375
                        -0.21 1.92028 1.31049 2.16687
                        -0.22 1.91975 1.30732 2.16999
                        -0.23 1.91925 1.30415 2.17310
                        -0.24 1.91876 1.30100 2.17619  
                        -0.25 1.91820 1.29800 2.17928
                        -0.26 1.91784 1.29472 2.18236
                        -0.27 1.91740 1.29160 2.18543  
                        -0.28 1.91699 1.28848 2.18848 
                        -0.29 1.91659 1.28538 2.19153 
                        -0.30 1.91613 1.28243 2.19458
                        -0.31 1.91585 1.27920 2.19761 
                        -0.32 1.91551 1.27612 2.20063 
                        -0.33 1.91518 1.27305 2.20365
                        -0.34 1.91487 1.26999 2.20666  
                        -0.35 1.91449 1.26708 2.20966
                        -0.36 1.91429 1.26390 2.21265 
                        -0.37 1.91403 1.26086 2.21563 
                        -0.38 1.91378 1.25784 2.21861 
                        -0.39 1.91354 1.25482 2.22158 
                        -0.40 1.91323 1.25195 2.22454
                        -0.41 1.91311 1.24881 2.22750 
                        -0.42 1.91292 1.24582 2.23045 
                        -0.43 1.91274 1.24283 2.23339 
                        -0.44 1.91257 1.23985 2.23632 
                        -0.45 1.91233 1.23703 2.23925
                        -0.46 1.91227 1.23392 2.24217     
                        -0.47 1.91214 1.23097 2.24509
                        -0.48 1.91203 1.22802 2.24799
                        -0.49 1.91192 1.22508 2.25090
                        -0.50 1.91174 1.22229 2.25380
                        -0.51 1.91166 1.21937 2.25669
                        -0.52 1.91159 1.21645 2.25957
                        -0.53 1.91153 1.21354 2.26245
                        -0.54 1.91148 1.21064 2.26532
                        -0.55 1.91144 1.20775 2.26819
                        -0.56 1.91141 1.20486 2.27105
                        -0.57 1.91140 1.20198 2.27391
                        -0.58 1.91139 1.19910 2.27676
                        -0.59 1.91140 1.19626 2.27961
                        -0.60 1.91141 1.19338 2.28245
                        -0.61 1.91152 1.19038 2.28528
                        -0.62 1.91155 1.18753 2.28811 
                        -0.63 1.91159 1.18469 2.29094 
                        -0.64 1.91164 1.18186 2.29376
                        -0.65 1.91170 1.17904 2.29658];
 
 %Declare increment values                       
 handles.IncrementValues = [0.001
                            0.002
                            0.003
                            0.004
                            0.005
                            0.006
                            0.007
                            0.008
                            0.009];


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dispersion2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = dispersion2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%Pop up menu to select the current dispersion
%--------------------------------------------------------------------------
% --- Executes on selection change in Current_Popup.
function Current_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Current_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Current_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Current_Popup


% --- Executes during object creation, after setting all properties.
function Current_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Current_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%Pop up menu to select the next dispersion
%--------------------------------------------------------------------------
% --- Executes on selection change in Desired_Popup.
function Desired_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Desired_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Desired_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Desired_Popup


% --- Executes during object creation, after setting all properties.
function Desired_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Desired_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%Applies the desired change
%--------------------------------------------------------------------------
% --- Executes on button press in Apply_Push.
function Apply_Push_Callback(hObject, eventdata, handles)
% hObject    handle to Apply_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get current dispersion index from popup menu
handles.CurrentVal=get(handles.Current_Popup,'Value');
%Get current dispersion string list
handles.Current_String_List=get(handles.Current_Popup,'String');
%Get current dispersion string
handles.Current_Selected_String=handles.Current_String_List{handles.CurrentVal};
%Get current quad values from table
handles.QFACurrent=handles.QuadValues(handles.CurrentVal,2);
handles.QFBCurrent=handles.QuadValues(handles.CurrentVal,3);
handles.QFCCurrent=handles.QuadValues(handles.CurrentVal,4);

%Get desired dispersion index from popup menu
handles.DesiredVal=get(handles.Desired_Popup,'Value');
%Get desired dispersion string list
handles.Desired_String_List=get(handles.Desired_Popup,'String');
%Get desired dispersion string
handles.Desired_Selected_String=handles.Desired_String_List{handles.DesiredVal};
%Get desired quad values from table
handles.QFADesired=handles.QuadValues(handles.DesiredVal,2);
handles.QFBDesired=handles.QuadValues(handles.DesiredVal,3);
handles.QFCDesired=handles.QuadValues(handles.DesiredVal,4);

%Display message to user
set(handles.Display_Edit,'String','Moving to new dispersion');

%Get current dac values 
for n=[1:24]
    handles.QFA(n) = mcaget(handles.QFAH(n));
    handles.QFB(n) = mcaget(handles.QFBH(n));
    handles.QFC(n) = mcaget(handles.QFCH(n));
 end

%Calculate change required for quads
handles.QFAChange=(handles.QFADesired-handles.QFACurrent)/handles.QFACurrent;
handles.QFBChange=(handles.QFBDesired-handles.QFBCurrent)/handles.QFBCurrent;
handles.QFCChange=(handles.QFCDesired-handles.QFCCurrent)/handles.QFCCurrent;



%Calculate and apply new quad values
for n=[1:24]
    handles.QFA(n)=handles.QFA(n)+(handles.QFA(n)*handles.QFAChange);
    handles.QFB(n)=handles.QFB(n)+(handles.QFB(n)*handles.QFBChange);
    handles.QFC(n)=handles.QFC(n)+(handles.QFC(n)*handles.QFCChange);
    mcaput(handles.QFAH(n), handles.QFA(n));
    mcaput(handles.QFBH(n), handles.QFB(n));
    mcaput(handles.QFCH(n), handles.QFC(n)); 
end

%Pause to allow feedback to match set point and to avoid error messages
pause(3);

%Check feedback
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFA(n))>10000
        handles.count = handles.count+1;
    	if handles.count == 10
            msg = [handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFB(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg = [handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFC(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
        	msg = [handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%Display results
handles.Dispersion = handles.QuadValues(handles.DesiredVal,1);
handles.results=['Dispersion has been adjusted to ' handles.Desired_Selected_String];
set(handles.Display_Edit,'String',handles.results);
set(handles.Current_Popup,'Value',handles.DesiredVal);
guidata(hObject,handles);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%Closes the program
%--------------------------------------------------------------------------
% --- Executes on button press in close_pushbutton.
function close_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to close_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

response=questdlg('Are you sure you want to quit?','Confirm Close','Yes','No','Yes');
switch response 
    case {'No'}
    case {'Yes'}
        delete(handles.figure1)
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%Edit text box to display feedback from the program
%--------------------------------------------------------------------------
function Display_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Display_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Display_Edit as text
%        str2double(get(hObject,'String')) returns contents of Display_Edit as a double


% --- Executes during object creation, after setting all properties.
function Display_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Display_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%Popup menu to select increment
%--------------------------------------------------------------------------
% --- Executes on selection change in Increment_Popup.
function Increment_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Increment_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Increment_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Increment_Popup


% --- Executes during object creation, after setting all properties.
function Increment_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Increment_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%Positive Radio Button Toggle State
%--------------------------------------------------------------------------
% --- Executes on button press in Pos_Radio.
function Pos_Radio_Callback(hObject, eventdata, handles)
handles.Pos_Radio_State = get(hObject,'Value');
guidata(hObject,handles);
% hObject    handle to Pos_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Pos_Radio
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Negative Radio Button Toggle State
%--------------------------------------------------------------------------
% --- Executes on button press in Neg_Radio.
function Neg_Radio_Callback(hObject, eventdata, handles)
handles.Neg_Radio_State = get(hObject,'Value');
guidata(hObject,handles);
% hObject    handle to Neg_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Neg_Radio
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%Apply Increment Push Button
%--------------------------------------------------------------------------
% --- Executes on button press in Increment_Push.
function Increment_Push_Callback(hObject, eventdata, handles)

% hObject    handle to Increment_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get starting dispersion index from popup menu
handles.StartVal=get(handles.Current_Popup,'Value');

%Get starting quad values from table
handles.QFAStart=handles.QuadValues(handles.StartVal,2);
handles.QFBStart=handles.QuadValues(handles.StartVal,3);
handles.QFCStart=handles.QuadValues(handles.StartVal,4);

%Get increment index from popup menu
handles.IncrementVal=get(handles.Increment_Popup,'Value'); 


%Get current dac values 
for n=[1:24]
    handles.QFA(n) = mcaget(handles.QFAH(n));
    handles.QFB(n) = mcaget(handles.QFBH(n));
    handles.QFC(n) = mcaget(handles.QFCH(n));
end

if (handles.Pos_Radio_State==1.0 && handles.Neg_Radio_State==1.0)
    msg = ['Please select either positive OR negative for the increment direction.'];
    msgbox(msg,'ERROR','warn');
    set(handles.Pos_Radio,'Value',0);
    set(handles.Neg_Radio,'Value',0);
    handles.Pos_Radio_State=0;
    handles.Neg_Radio_State=0;
elseif (handles.Pos_Radio_State==0 && handles.Neg_Radio_State==0)
    msg = ['Please select either positive OR negative for the increment direction.'];
    msgbox(msg,'ERROR','warn');
    set(handles.Pos_Radio,'Value',0);
    set(handles.Neg_Radio,'Value',0);
    handles.Pos_Radio_State=0;
    handles.Neg_Radio_State=0;
elseif (handles.Pos_Radio_State==1.0)
    if (handles.StartVal==1)
        msg = ['A dispersion of 0.30m is the greatest dispersion possible.'];
        msgbox(msg,'ERROR','warn');  
        set(handles.Pos_Radio,'Value',0);
        set(handles.Neg_Radio,'Value',0);
        handles.Pos_Radio_State=0;
        handles.Neg_Radio_State=0;
    else
        %Get numerical increment from array
        handles.Increment=handles.IncrementValues(handles.IncrementVal);
        handles.FinishVal = handles.StartVal-1;
        handles.QFAFinish=handles.QuadValues(handles.FinishVal,2);
        handles.QFBFinish=handles.QuadValues(handles.FinishVal,3);
        handles.QFCFinish=handles.QuadValues(handles.FinishVal,4);
        %Display message to user
        set(handles.Display_Edit,'String','Moving to new dispersion');
        %Calculate change required for quads
        handles.QFAChange=(handles.IncrementVal*0.1*(handles.QFAFinish-handles.QFAStart))/(handles.QFAStart);
        handles.QFBChange=(handles.IncrementVal*0.1*(handles.QFBFinish-handles.QFBStart))/(handles.QFBStart);
        handles.QFCChange=(handles.IncrementVal*0.1*(handles.QFCFinish-handles.QFCStart))/(handles.QFCStart);

        
        %Calculate and apply new quad values
        for n=[1:24]
            handles.QFA(n)=handles.QFA(n)+(handles.QFA(n)*handles.QFAChange);
            handles.QFB(n)=handles.QFB(n)+(handles.QFB(n)*handles.QFBChange);
            handles.QFC(n)=handles.QFC(n)+(handles.QFC(n)*handles.QFCChange);
            mcaput(handles.QFAH(n), handles.QFA(n));
            mcaput(handles.QFBH(n), handles.QFB(n));
            mcaput(handles.QFCH(n), handles.QFC(n)); 
        end

        %Pause to allow feedback to match set point and to avoid error messages
        pause(3);

        %Check feedback
        for n=[1:24]
          handles.count = 0;
          handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
          while abs(handles.QFAFbk(n)-handles.QFA(n))>10000
             handles.count = handles.count+1;
                if handles.count == 10
                  msg = [handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
                  msgbox(msg,'ERROR','warn');
                  break;
                end
              pause(0.5);
              handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
          end
            handles.count = 0;
            handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
            while abs(handles.QFBFbk(n)-handles.QFB(n))>10000
                handles.count = handles.count+1;
                if handles.count == 10
                    msg = [handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
                    msgbox(msg,'ERROR','warn');
                    break;
                end
                pause(0.5);
                handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
            end
            handles.count=0;
            handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
            while abs(handles.QFCFbk(n)-handles.QFC(n))>10000
                handles.count = handles.count+1;
                if handles.count == 10
                    msg = [handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
                    msgbox(msg,'ERROR','warn');
                    break;
                end
                pause(0.5);
                handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
            end
        end
        %Display results
        format short
        handles.Dispersion = handles.Dispersion + handles.Increment;
        handles.DispersionString = num2str(handles.Dispersion);
        handles.results=['Dispersion has been adjusted to ' handles.DispersionString];
        set(handles.Display_Edit,'String',handles.results);
        if (abs(handles.Dispersion-(handles.QuadValues(handles.FinishVal,1)))<0.0001)
            set(handles.Current_Popup,'Value',handles.FinishVal);
        end
    end
elseif (handles.Neg_Radio_State==1.0)
    if (handles.StartVal==96)
        msg = ['A dispersion of -0.65m is the lowest dispersion possible.'];
        msgbox(msg,'ERROR','warn');
        set(handles.Pos_Radio,'Value',0);
        set(handles.Neg_Radio,'Value',0);
        handles.Pos_Radio_State=0;
        handles.Neg_Radio_State=0;
    else
        %Get numerical increment from array
        handles.Increment=handles.IncrementValues(handles.IncrementVal)*-1;
        handles.FinishVal=handles.StartVal+1;
        handles.QFAFinish=handles.QuadValues(handles.FinishVal,2);
        handles.QFBFinish=handles.QuadValues(handles.FinishVal,3);
        handles.QFCFinish=handles.QuadValues(handles.FinishVal,4);
        %Display message to user
        set(handles.Display_Edit,'String','Moving to new dispersion');
        %Calculate change required for quads
        handles.QFAChange=(handles.IncrementVal*0.1*(handles.QFAFinish-handles.QFAStart))/(handles.QFAStart);
        handles.QFBChange=(handles.IncrementVal*0.1*(handles.QFBFinish-handles.QFBStart))/(handles.QFBStart);
        handles.QFCChange=(handles.IncrementVal*0.1*(handles.QFCFinish-handles.QFCStart))/(handles.QFCStart);
  
        %Calculate and apply new quad values
        for n=[1:24]
            handles.QFA(n)=handles.QFA(n)+(handles.QFA(n)*handles.QFAChange);
            handles.QFB(n)=handles.QFB(n)+(handles.QFB(n)*handles.QFBChange);
            handles.QFC(n)=handles.QFC(n)+(handles.QFC(n)*handles.QFCChange);
            mcaput(handles.QFAH(n), handles.QFA(n));
            mcaput(handles.QFBH(n), handles.QFB(n));
            mcaput(handles.QFCH(n), handles.QFC(n)); 
        end

        %Pause to allow feedback to match set point and to avoid error messages
        pause(3);

        %Check feedback
        for n=[1:24]
            handles.count = 0;
            handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
            while abs(handles.QFAFbk(n)-handles.QFA(n))>10000
                handles.count = handles.count+1;
                if handles.count == 10
                    msg = [handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
                    msgbox(msg,'ERROR','warn');
                    break;
                end
                pause(0.5);
                handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
            end
            handles.count = 0;
            handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
            while abs(handles.QFBFbk(n)-handles.QFB(n))>10000
                handles.count = handles.count+1;
                if handles.count == 10
                    msg = [handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
                    msgbox(msg,'ERROR','warn');
                    break;
                end
                pause(0.5);
                handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
            end
            handles.count=0;
            handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
            while abs(handles.QFCFbk(n)-handles.QFC(n))>10000
                handles.count = handles.count+1;
                if handles.count == 10
                    msg = [handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
                    msgbox(msg,'ERROR','warn');
                    break;
                end
                pause(0.5);
                handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
            end
        end
        %Display results

        handles.Dispersion = handles.Dispersion + handles.Increment;
        handles.DispersionString = num2str(handles.Dispersion);
        handles.results=['Dispersion has been adjusted to ' handles.DispersionString];
        set(handles.Display_Edit,'String',handles.results);
        if (abs(handles.Dispersion-(handles.QuadValues(handles.FinishVal,1)))<0.0001)
            set(handles.Current_Popup,'Value',handles.FinishVal);
        end
    end
end

guidata(hObject,handles);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

