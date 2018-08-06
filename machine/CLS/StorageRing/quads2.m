function varargout = quads2(varargin)
% $Header: MatlabApplications/acceleratorcontrol/cls/quads2.m 1.2.1.1 2007/07/06 10:42:43CST Tasha Summers (summert) Exp  $
%QUADS2 M-file for quads2.fig
%      QUADS2, by itself, creates a new QUADS2 or raises the existing
%      singleton*.
%
%      H = QUADS2 returns the handle to a new QUADS2 or the handle to
%      the existing singleton*.
%
%      QUADS2('Property','Value',...) creates a new QUADS2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to quads2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      QUADS2('CALLBACK') and QUADS2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in QUADS2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help quads2

% Last Modified by GUIDE v2.5 18-Jul-2006 08:35:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quads2_OpeningFcn, ...
                   'gui_OutputFcn',  @quads2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes just before quads2 is made visible.
function quads2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for quads2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Declare quad names and open communication
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



%Get current dac values and assign to another variable

for n=[1:24]
    handles.QFA(n) = mcaget(handles.QFAH(n));
    handles.QFB(n) = mcaget(handles.QFBH(n));
    handles.QFC(n) = mcaget(handles.QFCH(n));
    handles.QFAModified(n) = handles.QFA(n);
    handles.QFBModified(n) = handles.QFB(n);
    handles.QFCModified(n) = handles.QFC(n);
end

%Set initial values
handles.StrFreqMove = [];
handles.Ratio_QFA_Radio_State=0;
handles.Ratio_QFB_Radio_State=0;
handles.Ratio_QFC_Radio_State=0;
handles.FreqMove = 0;
handles.Ratio = 0;
handles.Present = 1;
handles.Desired = 1;
handles.QFAPercent = 0;
handles.QFBPercent = 0;
handles.QFCPercent = 0;

%Max Percent Change is expressed as a decimal, and not a percent, here
handles.maxpercentchange = 0.2;
handles.maxratiochange = 0.2;
%Actual Max Tune Change is handles.maxtunechange*20 (so 200 kHz)
handles.maxtunechange = 10;
%Used to plot set points and feedback
handles.x=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24];

%Initialize edit text boxes
set(handles.Tune_Edit1,'String','0');
set(handles.Percent_QFA_Edit,'String','0');
set(handles.Percent_QFB_Edit,'String','0');
set(handles.Percent_QFC_Edit,'String','0');
set(handles.Ratio_Present_Edit,'String','1');
set(handles.Ratio_Desired_Edit,'String','1');
set(handles.Ratio_QFA_Radio,'Value',0);
set(handles.Ratio_QFB_Radio,'Value',0);
set(handles.Ratio_QFC_Radio,'Value',0);
set(handles.Results_Edit,'String','');

%Save changes
guidata(hObject,handles);


% UIWAIT makes quads2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = quads2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Tune_Edit1_Callback(hObject, eventdata, handles)
% hObject    handle to Tune_Edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get frequency change requested by user
handles.StrFreqMove = get(hObject,'String');
handles.FreqMove = (str2double(handles.StrFreqMove))/20;

%check whether frequency is a number
if isnan(handles.FreqMove)
    errordlg('You must enter a numeric value','Bad Input','modal')
    set(handles.Tune_Edit1,'String','0');
    handles.FreqMove = 0;
end

%check whether frequency is over max allowed change
if abs(handles.FreqMove)>handles.maxtunechange
    errordlg('Tunes cannot be changed by more than 200 kHz','Bad Input','modal')
    set(handles.Tune_Edit1,'String','0');
    handles.FreqMove = 0;
end


guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of Tune_Edit1 as text
%        str2double(get(hObject,'String')) returns contents of Tune_Edit1 as a double
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% --- Executes on button press in Reset_Push.--Resets quads to last saved
% values
function Reset_Push_Callback(hObject, eventdata, handles)

%Resets to last saved values
handles.QFAModified = handles.QFA;
handles.QFBModified = handles.QFB;
handles.QFCModified = handles.QFC;

for n=[1:24]
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n));
end

%Resets all text boxes, radio buttons, and variables
handles.FreqMove = 0;
handles.Ratio = 0;
handles.Present = 1;
handles.Desired = 1;
handles.QFAPercent = 0;
handles.QFBPercent = 0;
handles.QFCPercent = 0;
set(handles.Results_Edit,'String','');
set(handles.Tune_Edit1,'String','0');
set(handles.Percent_QFA_Edit,'String','0');
set(handles.Percent_QFB_Edit,'String','0');
set(handles.Percent_QFC_Edit,'String','0');
set(handles.Ratio_Present_Edit,'String','1');
set(handles.Ratio_Desired_Edit,'String','1');
handles.Ratio_QFA_Radio_State=0;
handles.Ratio_QFB_Radio_State=0;
handles.Ratio_QFC_Radio_State=0;
set(handles.Ratio_QFA_Radio,'Value',0);
set(handles.Ratio_QFB_Radio,'Value',0);
set(handles.Ratio_QFC_Radio,'Value',0);
set(handles.Results_Edit,'String','Resetting to Previously Saved Setting');

%Feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');
axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%Display whether move was completed
set(handles.Results_Edit,'String','Reset Complete');

guidata(hObject,handles);

% hObject    handle to Reset_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push1.--adjusts tune
function Tune_Push1_Callback(hObject, eventdata, handles)

%Vy-->
set(handles.Results_Edit,'String','Adjusting Tunes');

%Calculate and set new dac
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*-.00139*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*0.0032*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*-.00009*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n));           
end

%Feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');

axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%Displays appropriate message to user
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);

% hObject    handle to Tune_Push1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push2.--adjusts tune
function Tune_Push2_Callback(hObject, eventdata, handles)

%Vx-->
set(handles.Results_Edit,'String','Adjusting Tunes');

%calculate and apply appropriate change
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*-.00249*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*0.00225*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*-.00025*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n));
end

%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plots feedback and set points
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');
axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);
% hObject    handle to Tune_Push2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push3.--adjusts tune
function Tune_Push3_Callback(hObject, eventdata, handles)

%<--Vy
set(handles.Results_Edit,'String','Adjusting Tunes');

%calculate and apply appropriate change
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*.00137*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*-0.00317*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*.00002*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n));
end

%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');

axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);
% hObject    handle to Tune_Push3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push4.--adjusts tune
function Tune_Push4_Callback(hObject, eventdata, handles)

%<--Vx
set(handles.Results_Edit,'String','Adjusting Tunes');

%calculate and apply appropriate change
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*.00231*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*-.00209*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*.00026*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n)); 
end

%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot feedback and set points
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');

axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);

% hObject    handle to Tune_Push4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push5.
function Tune_Push5_Callback(hObject, eventdata, handles)

%-->-->
set(handles.Results_Edit,'String','Adjusting Tunes');

%calculate and apply change
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*-.00389*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*0.00546*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*-.0003*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n)); 
end

%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');
axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);

% hObject    handle to Tune_Push5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push6.
function Tune_Push6_Callback(hObject, eventdata, handles)

%<--<--
set(handles.Results_Edit,'String','Adjusting Tunes');

%calculate and apply change
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*.00368*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*-0.00525*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*.00028*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n)); 
end
 
%Feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');

axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);

% hObject    handle to Tune_Push6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push7.
function Tune_Push7_Callback(hObject, eventdata, handles)
%--><--
set(handles.Results_Edit,'String','Adjusting Tunes');

%calculate and apply change
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*.00093*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*0.00111*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*.00023*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n));  
end
 
%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');
axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);

% hObject    handle to Tune_Push7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Tune_Push8.
function Tune_Push8_Callback(hObject, eventdata, handles)
%<-- -->
set(handles.Results_Edit,'String','Adjusting Tunes');

%calculate and apply change
for n=[1:24]
    handles.QFAModified(n)=handles.QFAModified(n) + (handles.QFAModified(n)*-.00111*handles.FreqMove);
    handles.QFBModified(n)=handles.QFBModified(n) + (handles.QFBModified(n)*-.00093*handles.FreqMove);
    handles.QFCModified(n)=handles.QFCModified(n) + (handles.QFCModified(n)*-.00025*handles.FreqMove);
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n));   
end
 
%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');

axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.FreqMove==0
    set(handles.Results_Edit,'String','No Change Applied');
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);

% hObject    handle to Tune_Push8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Exit_Push.
function Exit_Push_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%creates a question box to make sure the user wants to quit
response=questdlg('Are you sure you want to quit?','Confirm Close','Yes','No','Yes');
switch response 
    case {'No'}
    case {'Yes'}
        delete(handles.figure1)
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Percent_QFA_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Percent_QFA_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get string of percent from user
handles.StrQFAPercent = get(hObject,'String');
%change to numeric percent
handles.QFAPercent = (str2double(handles.StrQFAPercent))*.01;

%check whether input is a number
if isnan(handles.QFAPercent)
    errordlg('You must enter numeric values for percent','Bad Input','modal')
    set(handles.Percent_QFA_Edit,'String','0');
    handles.QFAPercent = 0;
end

%Check whether exceeds max allowed value
if abs(handles.QFAPercent)>handles.maxpercentchange
    errordlg('You cannot change quads by more than 20%','Bad Input','modal')
    set(handles.Percent_QFA_Edit,'String','0');
    handles.QFAPercent = 0;
end

guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Percent_QFA_Edit as text
%        str2double(get(hObject,'String')) returns contents of Percent_QFA_Edit as a double
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function Percent_QFA_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Percent_QFA_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Percent_QFC_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Percent_QFC_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get percent string from user
handles.StrQFCPercent = get(hObject,'String');
%convert to number and decimal
handles.QFCPercent = (str2double(handles.StrQFCPercent))*.01;

%check whether input is a number
if isnan(handles.QFCPercent)
    errordlg('You must enter numeric values for percent','Bad Input','modal')
    set(handles.Percent_QFC_Edit,'String','0');
    handles.QFCPercent = 0;
end

%check whether within allowable limits
if abs(handles.QFCPercent)>handles.maxpercentchange
    errordlg('You cannot change quads by more than 20%','Bad Input','modal')
    set(handles.Percent_QFC_Edit,'String','0');
    handles.QFCPercent = 0;
end


guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Percent_QFC_Edit as text
%        str2double(get(hObject,'String')) returns contents of Percent_QFC_Edit as a double
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function Percent_QFC_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Percent_QFC_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Percent_QFB_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Percent_QFB_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get string of percent from user
handles.StrQFBPercent = get(hObject,'String');
%convert to decimal
handles.QFBPercent = (str2double(handles.StrQFBPercent))*.01;

%check whether input is a number
if isnan(handles.QFBPercent)
    errordlg('You must enter numeric values for percent','Bad Input','modal')
    set(handles.Percent_QFB_Edit,'String','0');
    handles.QFBPercent = 0;
end

%check whether within allowable limits
if abs(handles.QFBPercent)>handles.maxpercentchange
    errordlg('You cannot change quads by more than 20%','Bad Input','modal')
    set(handles.Percent_QFB_Edit,'String','0');
    handles.QFBPercent = 0;
end


guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Percent_QFB_Edit as text
%        str2double(get(hObject,'String')) returns contents of Percent_QFB_Edit as a double
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function Percent_QFB_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Percent_QFB_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Percent_Apply_Push.
function Percent_Apply_Push_Callback(hObject, eventdata, handles)
% hObject    handle to Percent_Apply_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Results_Edit,'String','Changing Quadrupoles');

%calculate and apply change
 for n=[1:24]
    handles.QFAModified(n) = handles.QFAModified(n) + handles.QFA(n)*handles.QFAPercent;
    handles.QFBModified(n) = handles.QFBModified(n) + handles.QFB(n)*handles.QFBPercent;
    handles.QFCModified(n) = handles.QFCModified(n) + handles.QFC(n)*handles.QFCPercent;
    mcaput(handles.QFAH(n), handles.QFAModified(n));
    mcaput(handles.QFBH(n), handles.QFBModified(n));
    mcaput(handles.QFCH(n), handles.QFCModified(n));
 end
  
%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');
axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display appropriate message
if handles.QFAPercent==0&&handles.QFBPercent==0&&handles.QFCPercent==0
    set(handles.Results_Edit,'String','No Change Applied')
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Ratio_Present_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Ratio_Present_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get string input from user
handles.StrPresent = get(hObject,'String');
%convert to number
handles.Present = str2double(handles.StrPresent);

%check whether input is a number
if isnan(handles.Present)
    errordlg('You must enter numeric values','Bad Input','modal')
    set(handles.Ratio_Present_Edit,'String','1');
    handles.Present = 1;
end

guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Ratio_Present_Edit as text
%        str2double(get(hObject,'String')) returns contents of Ratio_Present_Edit as a double
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.-------
function Ratio_Present_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ratio_Present_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Ratio_Desired_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Ratio_Desired_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get input from user
handles.StrDesired = get(hObject,'String');
%convert input to number
handles.Desired = str2double(handles.StrDesired);

%check whether input is a number
if isnan(handles.Desired)
    errordlg('You must enter numeric values','Bad Input','modal')
    set(handles.Ratio_Desired_Edit,'String','1');
    handles.Desired = 1;
end

guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Ratio_Desired_Edit as text
%        str2double(get(hObject,'String')) returns contents of Ratio_Desired_Edit as a double
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function Ratio_Desired_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ratio_Desired_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Ratio_Apply_Push.------------------------
function Ratio_Apply_Push_Callback(hObject, eventdata, handles)
% hObject    handle to Ratio_Apply_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%calculate ratio
handles.Ratio = (handles.Desired-handles.Present)/handles.Present;


%check whether ratio is valid
if isnan(handles.Ratio)||isinf(handles.Ratio)
    errordlg('Present value cannot be 0','Bad Input','modal')
    set(handles.Ratio_Present_Edit,'String','1');
    set(handles.Ratio_Desired_Edit,'String','1');
    handles.Ratio = 0;
    handles.Present=1;
    handles.Desired=1;
end

%check whether ratio is within allowable limits
if abs(handles.Ratio)>handles.maxratiochange
    errordlg('Ratio change must be less than 0.2','Bad Input','modal')
    set(handles.Ratio_Present_Edit,'String','1');
    set(handles.Ratio_Desired_Edit,'String','1');
    handles.Ratio = 0;
    handles.Present=1;
    handles.Desired=1;
end

set(handles.Results_Edit,'String','Applying Change');

%calculate and apply change if QFA radio button is selected
if (handles.Ratio_QFA_Radio_State==1.0)
    for n=[1:24]
        handles.QFAModified(n) = handles.QFAModified(n) + handles.QFAModified(n)*handles.Ratio;
        mcaput(handles.QFAH(n), handles.QFAModified(n));
    end
end  

%calculate and apply change if QFB radio button is selected
if (handles.Ratio_QFB_Radio_State==1.0)
    for n=[1:24]
        handles.QFBModified(n) = handles.QFBModified(n) + handles.QFBModified(n)*handles.Ratio;
        mcaput(handles.QFBH(n), handles.QFBModified(n));
    end
end

%calculate and apply change if QFB radio button is selected
if (handles.Ratio_QFC_Radio_State==1.0)
    for n=[1:24]
        handles.QFCModified(n) = handles.QFCModified(n) + handles.QFCModified(n)*handles.Ratio;
        mcaput(handles.QFCH(n), handles.QFCModified(n));
    end
end
 
%feedback check
for n=[1:24]
    handles.count = 0;
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    while abs(handles.QFAFbk(n)-handles.QFAModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFAPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
            msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    end
    handles.count = 0;
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    while abs(handles.QFBFbk(n)-handles.QFBModified(n))>10000
    	handles.count = handles.count+1;
    	if handles.count == 10
            msg=[handles.QFBPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    end
    handles.count=0;
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    while abs(handles.QFCFbk(n)-handles.QFCModified(n))>10000
        handles.count = handles.count+1;
        if handles.count == 10
            msg=[handles.QFCPvName(n,1:10) ' set point could not be reached within 10000 adc.'];
        	msgbox(msg,'ERROR','warn');
            break;
        end
        pause(0.5);
        handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
    end
end
 
%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');
axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

%display apropriate message
if handles.Ratio==0
    set(handles.Results_Edit,'String','No Change Applied')
else
    set(handles.Results_Edit,'String','Move Accomplished');
end

guidata(hObject,handles);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Ratio_QFA_Radio.-------------------------
function Ratio_QFA_Radio_Callback(hObject, eventdata, handles)
% hObject    handle to Ratio_QFA_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Ratio_QFA_Radio_State = get(hObject,'Value');
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of Ratio_QFA_Radio


%--------------------------------------------------------------------------
% --- Executes on button press in Ratio_QFB_Radio.-------------------------
function Ratio_QFB_Radio_Callback(hObject, eventdata, handles)
% hObject    handle to Ratio_QFB_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Ratio_QFB_Radio_State = get(hObject,'Value');
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of Ratio_QFB_Radio
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Ratio_QFC_Radio.-------------------------
function Ratio_QFC_Radio_Callback(hObject, eventdata, handles)
% hObject    handle to Ratio_QFC_Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Ratio_QFC_Radio_State = get(hObject,'Value');
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of Ratio_QFC_Radio
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Zero_Push.
function Zero_Push_Callback(hObject, eventdata, handles)
set(handles.Results_Edit,'String','Saving Settings');

%save settings
for n=[1:24]
    handles.QFA(n) = mcaget(handles.QFAH(n));
    handles.QFB(n) = mcaget(handles.QFBH(n));
    handles.QFC(n) = mcaget(handles.QFCH(n));
    handles.QFAModified(n) = handles.QFA(n);
    handles.QFBModified(n) = handles.QFB(n);
    handles.QFCModified(n) = handles.QFC(n);
end

%reset text boxes, variables, and radio buttons
handles.FreqMove = 0;
handles.Ratio = 0;
handles.Present = 1;
handles.Desired = 1;
handles.QFAPercent = 0;
handles.QFBPercent = 0;
handles.QFCPercent = 0;
set(handles.Tune_Edit1,'String','0');
set(handles.Percent_QFA_Edit,'String','0');
set(handles.Percent_QFB_Edit,'String','0');
set(handles.Percent_QFC_Edit,'String','0');
set(handles.Ratio_Present_Edit,'String','1');
set(handles.Ratio_Desired_Edit,'String','1');
handles.Ratio_QFA_Radio_State=0;
handles.Ratio_QFB_Radio_State=0;
handles.Ratio_QFC_Radio_State=0;
set(handles.Ratio_QFA_Radio,'Value',0);
set(handles.Ratio_QFB_Radio,'Value',0);
set(handles.Ratio_QFC_Radio,'Value',0);

%display message
set(handles.Results_Edit,'String','Quad Settings Saved');

%plot set points and feedback
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');
axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

guidata(hObject,handles);
% hObject    handle to Zero_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function Results_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Results_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Results_Edit as text
%        str2double(get(hObject,'String')) returns contents of Results_Edit as a double
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function Results_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Results_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% --- Executes on button press in Refresh_Push.
function Refresh_Push_Callback(hObject, eventdata, handles)
set(handles.Results_Edit,'String','Refreshing Plots');

%get feedback
for n=[1:24]
    handles.QFAFbk(n) = mcaget(handles.QFAFbkH(n));
    handles.QFBFbk(n) = mcaget(handles.QFBFbkH(n));
    handles.QFCFbk(n) = mcaget(handles.QFCFbkH(n));
end

%plot feedback and set points
axes(handles.QFA_Axes);
plot(handles.x,handles.QFAModified,handles.x,handles.QFAFbk);
legend('Set Point','Feedback');

axes(handles.QFB_Axes);
plot(handles.x,handles.QFBModified,handles.x,handles.QFBFbk);

axes(handles.QFC_Axes);
plot(handles.x,handles.QFCModified,handles.x,handles.QFCFbk);

set(handles.Results_Edit,'String','Plots Refreshed');

guidata(hObject,handles);

% hObject    handle to Refresh_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/quads2.m  $
% Revision 1.2.1.1 2007/07/06 10:42:43CST Tasha Summers (summert) 
% Initial revision
% Member added to project e:/Projects/matlab/project.pj
% Revision 1.1 2007/03/05 18:01:15CST summert 
% Initial revision
% Member added to project e:/Projects/matlab/project.pj
