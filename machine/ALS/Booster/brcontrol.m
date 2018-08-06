function varargout = brcontrol(varargin)
%brcontrol M-file for brcontrol.fig
%      brcontrol, by itself, creates a new brcontrol or raises the existing
%      singleton*.
%
%      H = brcontrol returns the handle to a new brcontrol or the handle to
%      the existing singleton*.
%
%      brcontrol('Property','Value',...) creates a new brcontrol using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to brcontrol_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      brcontrol('CALLBACK') and brcontrol('CALLBACK',hObject,...) call the
%      local function named CALLBACK in brcontrol.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help brcontrol

% Added subroutine to change lca set and put parameters so digital controller table loads work more dependably - true problem not yet solved. 12-14-10, T.Scarvie and C.Steier

% Last Modified by GUIDE v2.5 20-Jan-2016 17:06:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @brcontrol_OpeningFcn, ...
    'gui_OutputFcn',  @brcontrol_OutputFcn, ...
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


% Revision History
% 2009-01-04 - Creation date


% For the compiler
%#function setoperationalmode, machineconfig, resetudferrors, epicsdatabasechanges


% --- Executes just before brcontrol is made visible.
function brcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for brcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes brcontrol wait for user response (see UIRESUME)
% uiwait(handles.BRControl);


%%%%%%%%%%%%%%%%%%%%%%
% Location on Screen %
%%%%%%%%%%%%%%%%%%%%%%
ScreenDefault = get(0, 'Units');
AppDefault = get(hObject, 'Units');

set(0, 'Units', 'Pixels');
set(hObject, 'Units', 'Pixels');

ScreenSize = get(0, 'ScreenSize');
AppSize = get(hObject, 'Position');

% Set the application location
%set(hObject, 'Position', [20 (ScreenSize(4)-AppSize(4)-30) AppSize(3) AppSize(4)]);

set(0, 'Units', ScreenDefault);
set(hObject, 'Units', AppDefault);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALS Initialization Below %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if the AO exists (this is required for stand-alone applications)
checkforao;

if strcmpi(getmode('BEND'),'Online') && any(getpv('BEND','Gain') > 0.4)
    % Normal mode
    set(handles.EnergySaverText, 'String', 'Energy Saver Off');
    set(handles.EnergySaver ,    'String', 'Activate Energy Saver');
else
    % Energy saver on
    set(handles.EnergySaverText, 'String', 'Energy Saver On');
    set(handles.EnergySaver    , 'String', 'Return to Normal Mode');    
end

if ispc
    % Table loads not working from windows yet.
    set(handles.RFRampTable, 'Enable', 'Off');    
    set(handles.SFRampTable, 'Enable', 'Off');    
    set(handles.SDRampTable, 'Enable', 'Off');    

    % Works for new controller
    % set(handles.QFRampTable, 'Enable', 'Off');
    % set(handles.QDRampTable, 'Enable', 'Off');
    % set(handles.BENDRampTable, 'Enable', 'Off');
else
    % Remove the QF Table server
    % set(handles.QFCopy, 'Visible', 'Off');
    % p = get(handles.RampingFrame, 'Position');
    % p(3) = 200;
    % set(handles.RampingFrame, 'Position', p);
    % p = get(handles.BRControl, 'Position');
    % p(3) = 210;
    % set(handles.BRControl, 'Position', p);
end


%%%%%%%%%%%%%%%
% Setup Timer %
%%%%%%%%%%%%%%%
UpdatePeriod = 1;

t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@RefreshGUI_Callback,handles});
%set(t, 'TimerFcn', ['brcontrol(''RefreshGUI_Callback'',', sprintf('%.30f',handles.BRControl), ',',sprintf('%.30f',handles.BRControl), ', [])']);
%set(t, 'StartFcn', ['brcontrol(''Timer_Start'',', sprintf('%.30f',handles.BRControl), ',',sprintf('%.30f',handles.BRControl), ', [])']);
set(t, 'UserData', handles);
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'brcontrolTimer');

% Save handles
handles.TimerHandle = t;
guidata(handles.BRControl, handles);
%setappdata(handles.BRControl, 'HandleStructure', handles);  % faze this out!!!

start(t);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in HWInit.
function HWInit_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'Initialize various parameter in the Booster',' ','Initialize the Booster hardware?'},'HWINIT','Yes','No','No');
drawnow;

if strcmp(StartFlag,'Yes')
    hwinit;
    fprintf('   Booster hardware initialization complete.\n');
else
    fprintf('   Booster hardware initialization canceled.\n');
    return
end


% --- Outputs from this function are returned to the command line.
function varargout = brcontrol_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function CloseRequestFcn(hObject, eventdata, handles)

% try
%     h = getappdata(handles.BRControl, 'HandleStructure');
%     if isfield(h,'TimerHandle')
%         stop(h.TimerHandle);
%         delete(h.TimerHandle);
%         %h = rmfield(h);
%     end
% catch
%     fprintf('   Trouble stopping the BR scope timer on exit.\n');
% end

% delete(hObject) closes the figure
delete(hObject);

% --- Executes during object deletion, before destroying properties.
function DeleteFcn(hObject, eventdata, handles)
% If timer is on, then turn it off by deleting the timer handle
try
    %handles = getappdata(handles.BRControl, 'HandleStructure');
    if isfield(handles,'TimerHandle')
        stop(handles.TimerHandle);
        delete(handles.TimerHandle);
       % handles = rmfield(handles);
    end
catch
    fprintf('   Trouble stopping the brcontrol timer on exit.\n');
end



% --- Executes on button press in TurnOff.
function TurnOff_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   ********************************\n');
fprintf('   **  Turn Booster Magnets Off  **\n');
fprintf('   ********************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg({'This function will stop the ramp, zero,','and turn off the booster magnets.',' ','Turn off the BR magnet power supplies?'},'Turn Off','Yes','No','No');
drawnow;

if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   ******************************************\n');
    fprintf('   **  Turning Booster Power Supplies Off  **\n');
    fprintf('   ******************************************\n');
    a = clock; 
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

    % Set SF & SD off
    try
        SFOff_Callback(hObject, eventdata, handles);
        SDOff_Callback(hObject, eventdata, handles);
        fprintf('\n   Presently this function only turns off SF & SD\n');

        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   **************************************\n');
        fprintf('   **  Booster Power Supplies Are Off  **\n');
        fprintf('   **************************************\n\n');
    catch
        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   *****************************************************************\n');
        fprintf('   **  A Problem Occurred Turning Off the Booster Power Supplies  **\n');
        fprintf('   *****************************************************************\n\n');
    end

else
    fprintf('   *****************************************************\n');
    fprintf('   **  Booster magnet power supply turn off canceled  **\n');
    fprintf('   *****************************************************\n');
    return
end



% --- Executes on button press in TurnOn.
function TurnOn_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   *******************************\n');
fprintf('   **  Turn Booster Magnets On  **\n');
fprintf('   *******************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg({'This function will turn on and enable','the ramping of the booster magnets.',' ','Turn on the BR magnet power supplies?'},'Turn Off','Yes','No','No');
drawnow;

if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   *****************************************\n');
    fprintf('   **  Turning Booster Power Supplies On  **\n');
    fprintf('   *****************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

    % Set SF & SD on
    try
        fprintf('   1. Turning SF on (if necessary)\n');
        OnFlag = getpv('SF', 'On');
        if any(OnFlag==0)
            setpv('SF', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
            pause(1);
            setpv('SF', 'Setpoint',  0);
            setpv('SF', 'OnControl', 1);
        end
        fprintf('   2. Turning SD on (if necessary)\n');

        OnFlag = getpv('SD', 'On');
        if any(OnFlag==0)
            setpv('SD', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
            pause(1);
            setpv('SD', 'Setpoint',  0);
            setpv('SD', 'OnControl', 1);
        end

        fprintf('\n   Presently this function only turns on SF & SD\n');

        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   *************************************\n');
        fprintf('   **  Booster Power Supplies Are On  **\n');
        fprintf('   *************************************\n\n');
    catch
        a = clock;
        fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
        fprintf('   ****************************************************************\n');
        fprintf('   **  A Problem Occurred Turning On the Booster Power Supplies  **\n');
        fprintf('   ****************************************************************\n\n');
    end

else
    fprintf('   ****************************************************\n');
    fprintf('   **  Booster magnet power supply turn on canceled  **\n');
    fprintf('   ****************************************************\n');
    return
end



% --- Executes on button press in QFRampTable.
function QFRampTable_Callback(hObject, eventdata, handles)
% if ispc
%     uiwait(warndlg({'Unfortunately the table downloads to the mini-IOC','can only be done on a Unix platform at the moment.','           (I''m working on it.  G. Portmann)'}', 'Booster PS Table Load'));
%     return
% end

fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster QF Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

h = figure;
setboosterrampqf('DisplayOnly');  % Just to display the waveform that will be downloaded
StartFlag = questdlg(sprintf('Start the QF Ramp Table Load?'),'QF Ramp Table Load','Yes','Cancel','Cancel');
close(h);
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster QF ramp table\n');
%     setlcaparams(1);
    setboosterrampqf('NoDisplay');
%     setlcaparams(0);

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster QF ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster QF ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end


% --- Executes on button press in QDRampTable.
function QDRampTable_Callback(hObject, eventdata, handles)
% if ispc
%     uiwait(warndlg({'Unfortunately the table downloads to the mini-IOC','can only be done on a Unix platform at the moment.','           (I''m working on it.  G. Portmann)'}', 'Booster PS Table Load'));
%     return
% end

fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster QD Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

h = figure;
setboosterrampqd('DisplayOnly');  % Just to display the waveform that will be downloaded
StartFlag = questdlg(sprintf('Start the QD Ramp Table Load?'),'QD Ramp Table Load','Yes','Cancel','Cancel');
close(h);
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster QD ramp table\n');
%     setlcaparams(1);
    setboosterrampqd('NoDisplay');
%     setlcaparams(0);
    
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster QD ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster QD ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end



% --- Executes on button press in SFRampTable.
function SFRampTable_Callback(hObject, eventdata, handles)
if ispc
    uiwait(warndlg({'Unfortunately the table downloads to the mini-IOC','can only be done on a Unix platform at the moment.','           (I''m working on it.  G. Portmann)'}', 'Booster PS Table Load'));
    return
end

fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster SF Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

h = figure;
setboosterrampsf('DisplayOnly');  % Just to display the waveform that will be downloaded
StartFlag = questdlg(sprintf('Start the SF Ramp Table Load?'),'SF Ramp Table Load','Yes','Cancel','Cancel');
close(h);
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster SF ramp table\n');
    setboosterrampsf('NoDisplay');

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster SF ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster SF ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end


% --- Executes on button press in SDRampTable.
function SDRampTable_Callback(hObject, eventdata, handles)
if ispc
    uiwait(warndlg({'Unfortunately the table downloads to the mini-IOC','can only be done on a Unix platform at the moment.','           (I''m working on it.  G. Portmann)'}', 'Booster PS Table Load'));
    return
end

fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster SD Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

h = figure;
setboosterrampsd('DisplayOnly');  % Just to display the waveform that will be downloaded
StartFlag = questdlg(sprintf('Start the SD Ramp Table Load?'),'SD Ramp Table Load','Yes','Cancel','Cancel');
close(h);
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster SD ramp table\n');
    setboosterrampsd('NoDisplay');

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster SD ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster SD ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end


% --- Executes on button press in BENDRampTable.
function BENDRampTable_Callback(hObject, eventdata, handles)

fprintf('\n');
fprintf('   ***************************************\n');
fprintf('   **  Loading Booster BEND Ramp Table  **\n');
fprintf('   ***************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

h = figure;
setboosterrampbend('DisplayOnly');  % Just to display the waveform that will be downloaded
StartFlag = questdlg(sprintf('Start the BEND Ramp Table Load?'),'BEND Ramp Table Load','Yes','Cancel','Cancel');
close(h);
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster BEND ramp table\n');
%     setlcaparams(1);
    setboosterrampbend('NoDisplay');
%     setlcaparams(0);
    %pause(1);
    %setboosterrampbend('NoDisplay');

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster BEND ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *************************************************\n');
    fprintf('   **  Error loading the booster BEND ramp table  **\n');
    fprintf('   *************************************************\n\n');
end


% --- Executes on button press in RFRampTable.
function RFRampTable_Callback(hObject, eventdata, handles)
if ispc
    uiwait(warndlg({'Unfortunately the table downloads to the mini-IOC','can only be done on a Unix platform at the moment.','           (I''m working on it.  G. Portmann)'}', 'Booster PS Table Load'));
    return
end

fprintf('\n');
fprintf('   *************************************\n');
fprintf('   **  Loading Booster RF Ramp Table  **\n');
fprintf('   *************************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

h = figure;
setboosterramprf('DisplayOnly');  % Just to display the waveform that will be downloaded
StartFlag = questdlg(sprintf('Start the RF Ramp Table Load?'),'RF Ramp Table Load','Yes','Cancel','Cancel');
close(h);
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Canceled   **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('   Loading the booster RF ramp table\n');
    setboosterramprf('NoDisplay');

    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **    Table Load Complete   **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf('   %s \n', lasterr);
    fprintf('   Error setting the booster RF ramp table! \n\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  Error loading the booster RF ramp table  **\n');
    fprintf('   ***********************************************\n\n');
end



% --- Executes on button press in QFOff.
function QFOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn off booster QF?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.QFOn,  'Value', 0);
set(handles.QFOff, 'Value', 1);

% Disable the ramp before turning off
QFDisable_Callback(hObject, eventdata, handles);
pause(1);

% Zero the setpoint and turn off
setpv('QF', 'Setpoint',  0);
pause(2);
setpv('QF', 'OnControl', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in QFOn.
function QFOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn on booster QF?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.QFOff, 'Value', 0);
set(handles.QFOn,  'Value', 1);

setpv('QF', 'OnControl', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in QDOff.
function QDOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn off booster QD?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.QDOn,  'Value', 0);
set(handles.QDOff, 'Value', 1);

% Disable the ramp before turning off
QDDisable_Callback(hObject, eventdata, handles);
pause(1);

% Zero the setpoint and turn off
setpv('QD', 'Setpoint',  0);
pause(2);
setpv('QD', 'OnControl', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in QDOn.
function QDOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn on booster QD?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.QDOff, 'Value', 0);
set(handles.QDOn,  'Value', 1);

setpv('QD', 'OnControl', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in QFDisable.
function QFDisable_Callback(hObject, eventdata, handles)
set(handles.QFEnable, 'Value', 0);
setpv('QF', 'EnableRamp', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in QFEnable.
function QFEnable_Callback(hObject, eventdata, handles)
set(handles.QFDisable, 'Value', 0);
setpv('QF', 'EnableRamp', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in QDDisable.
function QDDisable_Callback(hObject, eventdata, handles)
set(handles.QDEnable, 'Value', 0);
setpv('QD', 'EnableRamp', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in QDEnable.
function QDEnable_Callback(hObject, eventdata, handles)
set(handles.QDDisable, 'Value', 0);
setpv('QD', 'EnableRamp', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in SFOff.
function SFOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn off booster SF?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.SFOn,  'Value', 0);
set(handles.SFOff, 'Value', 1);

% Disable the ramp before turning off
SextDisable_Callback(hObject, eventdata, handles);
pause(1);

% Zero the setpoint and turn off
setpv('SF', 'Setpoint',  0);
pause(2);
setpv('SF', 'OnControl', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in SFOn.
function SFOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn on booster SF?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.SFOff, 'Value', 0);
set(handles.SFOn,  'Value', 1);

setpv('SF', 'OnControl', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in SDOff.
function SDOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn off booster SD?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.SDOn,  'Value', 0);
set(handles.SDOff, 'Value', 1);

% Disable the ramp before turning off
SextDisable_Callback(hObject, eventdata, handles);
pause(1);

% Zero the setpoint & turn off
setpv('SD', 'Setpoint',  0);
pause(2);
setpv('SD', 'OnControl', 0);


%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in SDOn.
function SDOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn on booster SD?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.SDOff, 'Value', 0);
set(handles.SDOn,  'Value', 1);

setpv('SD', 'OnControl', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);

% --- Executes on button press in SDDisable.
function SextDisable_Callback(hObject, eventdata, handles)
set(handles.SFEnable, 'Value', 0);
set(handles.SDEnable, 'Value', 0);
set(handles.SFDisable, 'Value', 1);
set(handles.SDDisable, 'Value', 1);
setpv('SF', 'EnableRamp', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in SDEnable.
function SextEnable_Callback(hObject, eventdata, handles)
set(handles.SFEnable, 'Value', 1);
set(handles.SDEnable, 'Value', 1);
set(handles.SFDisable, 'Value', 0);
set(handles.SDDisable, 'Value', 0);
setpv('SF', 'EnableRamp', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in BENDOff.
function BENDOff_Callback(hObject, eventdata, handles)

if any(getpv('BEND','Gain') > .4)
    StartFlag = questdlg({'Energy Saver is not on!!!','This will trip the power supply.  It is highly','unadvisable to turn off the BEND without','going into Energy Saver mode first.',' ','Turn off booster BEND?'},'Booster BEND Control','Yes','Cancel','Cancel');
    if ~strcmp(StartFlag,'Yes')
        return;
    end
else
    StartFlag = questdlg('Turn off booster BEND?','Booster BEND Control','Yes','Cancel','Cancel');
    if ~strcmp(StartFlag,'Yes')
        return;
    end
end

set(handles.BENDOn,  'Value', 0);
set(handles.BENDOff, 'Value', 1);

% Disable the ramp before turning off
BENDDisable_Callback(hObject, eventdata, handles);
pause(1);

% Zero the setpoint and turn off
setpv('BEND', 'Setpoint',  0);
pause(3);
setpv('BEND', 'OnControl', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in BENDOn.
function BENDOn_Callback(hObject, eventdata, handles)
if any(getpv('BEND','Gain') > .4)
    StartFlag = questdlg({'Energy Saver is not on!!!','This will trip the power supply.  It is highly','unadvisable to turn on the BEND without','being in Energy Saver mode.',' ','Turn on booster BEND?'},'Booster BEND Control','Yes','Cancel','Cancel');
    if ~strcmp(StartFlag,'Yes')
        return;
    end
else
    StartFlag = questdlg('Turn on booster BEND?','Booster BEND Control','Yes','Cancel','Cancel');
    if ~strcmp(StartFlag,'Yes')
        return;
    end
end

set(handles.BENDOff, 'Value', 0);
set(handles.BENDOn,  'Value', 1);

setpv('BEND', 'OnControl', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in BENDDisable.
function BENDDisable_Callback(hObject, eventdata, handles)
set(handles.BENDEnable, 'Value', 0);

setpv('BEND', 'EnableRamp', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in BENDEnable.
function BENDEnable_Callback(hObject, eventdata, handles)
set(handles.BENDDisable, 'Value', 0);

setpv('BEND', 'EnableRamp', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in RFOff.
function RFOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn off booster RF?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.RFOn, 'Value', 0);
setpv('RF', 'OnControl', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in RFOn.
function RFOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg('Turn on booster RF?','Booster Control','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

set(handles.RFOff, 'Value', 0);
setpv('RF', 'OnControl', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in RFDisable.
function RFDisable_Callback(hObject, eventdata, handles)
set(handles.RFEnable, 'Value', 0);
setpv('RF', 'EnableRamp', 0);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in RFEnable.
function RFEnable_Callback(hObject, eventdata, handles)
set(handles.RFDisable, 'Value', 0);
setpv('RF', 'EnableRamp', 1);

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in EnergySaver.
function EnergySaver_Callback(hObject, eventdata, handles)

ModeString = get(handles.EnergySaver, 'String');
StartFlag = questdlg({ModeString},'Energy Saver','Yes','Cancel','Cancel');
if ~strcmp(StartFlag,'Yes')
    return;
end

% updated default scale values to our nominal operating values as of 11-03-2010 - C. Steier (all digital power supply controllers now)
default_qfscale   = 0.9641;
default_qdscale   = 0.8687;
default_bendscale = 0.5313;

stepvec_dn = [100:-1:90 88:-2:70 66:-4:30];
stepvec_up = [30:4:66 70:2:88 90:0.5:100];

if strcmpi(get(handles.EnergySaver, 'String'), 'Return to Normal Mode')
    % Return to normal mode
    set(handles.EnergySaver,     'Enable', 'Off');
    set(handles.EnergySaverText, 'String', 'Energy Saver');
    set(handles.EnergySaver    , 'String', 'Ramping Energy Up');
    
    % Get the normal operation gains
    GainCell = get(handles.EnergySaver, 'UserData');
    if isempty(GainCell)
        restore_qfscale   = default_qfscale;
        restore_qdscale   = default_qdscale;
        restore_bendscale = default_bendscale;
        %soundtada;
        %uiwait(warndlg({'The 1.9 GeV gain setting are unknown (either because it''s the first ramp','up of the booster after a shutdown or the application was','closed while in energy saver mode).  The default values will be used.','  ','            Tuning the booster will likely be needed!'}', 'Energy Saver'));
        StartFlag = questdlg({'The 1.9 GeV gain setting are unknown!', 'Typically this is because it''s the first ramp up of the booster after', 'a shutdown or the application was closed while in energy saver mode.', ' ', 'The default values will be used.  Hence,', 'some tuning of the booster will likely be needed!','  ', 'Do you still want to return to Normal Mode?'},'Energy Saver','Yes','Cancel','Cancel');
        if ~strcmp(StartFlag,'Yes')
            return;
        end
        
    else
        restore_qfscale   = GainCell{1};
        restore_qdscale   = GainCell{2};
        restore_bendscale = GainCell{3};
    end
    
    
    disp('   Restore Normal Operation ');
    for loop = stepvec_up
        fprintf('BEND = %g, QF = %g, QD = %g\n', loop/100*restore_bendscale, loop/100*restore_qfscale,loop/100*restore_qdscale);
        setpv('QF', 'Gain', loop/100*restore_qfscale);
        setpv('QD', 'Gain', loop/100*restore_qdscale);
        setpv('BEND', 'Gain', loop/100*restore_bendscale);
        %             setpv('BR1_____QFIE_GNAC01', loop/100*restore_qfscale);
        %             setpv('BR1_____QDIE_GNAC02', loop/100*restore_qdscale);
        %             setpv('BR1_____B_IE_GNAC00', loop/100*restore_bendscale);
        pause(1.4);
    end
    pause(10);
    setpv('QF', 'Gain', restore_qfscale);
    setpv('QD', 'Gain', restore_qdscale);
    setpv('BEND', 'Gain', restore_bendscale);
    %         setpv('BR1_____QFIE_GNAC01', restore_qfscale);
    %         setpv('BR1_____QDIE_GNAC02', restore_qdscale);
    %         setpv('BR1_____B_IE_GNAC00', restore_bendscale);
    pause(1);
    
    
    % Change buttons for energy save
    set(handles.EnergySaverText, 'String', 'Energy Saver Off');
    set(handles.EnergySaver ,    'String', 'Activate Energy Saver');
    set(handles.EnergySaver, 'Enable', 'On');
else
    % Activate Energy Saver
    set(handles.EnergySaver, 'Enable', 'Off');
    set(handles.EnergySaverText, 'String', 'Energy Saver');
    set(handles.EnergySaver    , 'String', 'Ramping Energy Down');
    
    disp('   Activating Energy Saver Mode');
    restore_qfscale   = getpv('QF','Gain',[1 1]);
    restore_qdscale   = getpv('QD','Gain',[1 1]);
    restore_bendscale = getpv('BEND','Gain',[1 1]);
    %         restore_qfscale   = getpv('BR1_____QFIE_GNAC01');
    %         restore_qdscale   = getpv('BR1_____QDIE_GNAC02');
    %         restore_bendscale = getpv('BR1_____B_IE_GNAC00');
    
    % Store the gains in user data
    GainCell = {restore_qfscale, restore_qdscale, restore_bendscale};
    set(handles.EnergySaver, 'UserData', GainCell);
    
    for loop = stepvec_dn
        fprintf('BEND = %g, QF = %g, QD = %g\n',loop/100*restore_bendscale, loop/100*restore_qfscale,loop/100*restore_qdscale);
        setpv('QF', 'Gain', loop/100*restore_qfscale);
        setpv('QD', 'Gain', loop/100*restore_qdscale);
        setpv('BEND', 'Gain', loop/100*restore_bendscale);
        %             setpv('BR1_____QFIE_GNAC01', loop/100*restore_qfscale);
        %             setpv('BR1_____QDIE_GNAC02', loop/100*restore_qdscale);
        %             setpv('BR1_____B_IE_GNAC00', loop/100*restore_bendscale);
        pause(1.4);
    end
    
    % Change buttons for normal mode
    set(handles.EnergySaverText, 'String', 'Energy Saver On');
    set(handles.EnergySaver    , 'String', 'Return to Normal Mode');
    set(handles.EnergySaver, 'Enable', 'On');
end

%RefreshGUI_Callback(hObject, eventdata, handles);


% --- Executes on button press in BRWaveforms.
function BRWaveforms_Callback(hObject, eventdata, handles)
brwaveforms;

% --------------------------------------------------------------------
function MachineConfigGolden_Callback(hObject, eventdata, handles)
machineconfig('Golden');


% --------------------------------------------------------------------
function MachineConfigFile_Callback(hObject, eventdata, handles)
machineconfig('');


% --- Executes on button press in DCCTScope.
%function DCCTScope_Callback(hObject, eventdata, handles)
%brscopesnew;




% --- Executes on button press in RefreshGUI.
function RefreshGUI_Callback(hObject, eventdata, handles)
% Expects the figure handle as hObject

%handles = getappdata(hObject, 'HandleStructure');

QFsmall = getappdata(handles.BRControl, 'QFsmall');
QDsmall = getappdata(handles.BRControl, 'QDsmall');


% Is OnControl
a = getpv('SF','OnControl');
if all(a)
    set(handles.SFOn,  'Value', 1);
    set(handles.SFOff, 'Value', 0);
else
    set(handles.SFOn,  'Value', 0);
    set(handles.SFOff, 'Value', 1);
end

a = getpv('SD','OnControl');
if all(a)
    set(handles.SDOn,  'Value', 1);
    set(handles.SDOff, 'Value', 0);
else
    set(handles.SDOn,  'Value', 0);
    set(handles.SDOff, 'Value', 1);
end

% a = getpv('QF','OnControl');
% if all(a)
%     set(handles.QFOn,  'Value', 1);
%     set(handles.QFOff, 'Value', 0);
% else
%     set(handles.QFOn,  'Value', 0);
%     set(handles.QFOff, 'Value', 1);
% end
% 
% a = getpv('QD','OnControl');
% if all(a)
%     set(handles.QDOn,  'Value', 1);
%     set(handles.QDOff, 'Value', 0);
% else
%     set(handles.QDOn,  'Value', 0);
%     set(handles.QDOff, 'Value', 1);
% end

% a = getpv('BEND','OnControl');
% if all(a)
%     set(handles.BENDOn,  'Value', 1);
%     set(handles.BENDOff, 'Value', 0);
% else
%     set(handles.BENDOn,  'Value', 0);
%     set(handles.BENDOff, 'Value', 1);
% end
% 
% a = getpv('RF','OnControl');
% if all(a)
%     set(handles.RFOn,  'Value', 1);
%     set(handles.RFOff, 'Value', 0);
% else
%     set(handles.RFOn,  'Value', 0);
%     set(handles.RFOff, 'Value', 1);
% end


% Is EnableRamp
a = getpv('SF','EnableRamp');
if all(a)
    set(handles.SFEnable,  'Value', 1);
    set(handles.SFDisable, 'Value', 0);
else
    set(handles.SFEnable,  'Value', 0);
    set(handles.SFDisable, 'Value', 1);
end

a = getpv('SD','EnableRamp');
if all(a)
    set(handles.SDEnable,  'Value', 1);
    set(handles.SDDisable, 'Value', 0);
else
    set(handles.SDEnable,  'Value', 0);
    set(handles.SDDisable, 'Value', 1);
end

a = getpv('QF','EnableRamp');
if all(a)
    set(handles.QFEnable,  'Value', 1);
    set(handles.QFDisable, 'Value', 0);
else
    set(handles.QFEnable,  'Value', 0);
    set(handles.QFDisable, 'Value', 1);
end

a = getpv('QD','EnableRamp');
if all(a)
    set(handles.QDEnable,  'Value', 1);
    set(handles.QDDisable, 'Value', 0);
else
    set(handles.QDEnable,  'Value', 0);
    set(handles.QDDisable, 'Value', 1);
end

a = getpv('BEND','EnableRamp');
if all(a)
    set(handles.BENDEnable,  'Value', 1);
    set(handles.BENDDisable, 'Value', 0);
else
    set(handles.BENDEnable,  'Value', 0);
    set(handles.BENDDisable, 'Value', 1);
end

a = getpv('RF','EnableRamp');
if all(a)
    set(handles.RFEnable,  'Value', 1);
    set(handles.RFDisable, 'Value', 0);
else
    set(handles.RFEnable,  'Value', 0);
    set(handles.RFDisable, 'Value', 1);
end


% Look for a change in the QF table in Hiroshi's app
if get(handles.QFCopy,'Value')
    QFsmallnew = getpv('QF', 'ILCTrim');
    setappdata(handles.BRControl, 'QFsmall', QFsmallnew);
    
    if isempty(QFsmall) || any(QFsmallnew~=QFsmall)
        FontSize = get(handles.HeartBeat, 'FontSize');
        set(handles.HeartBeat, 'FontSize', 8);        
        set(handles.HeartBeat, 'String', 'Loading Table...');
        drawnow;
%         setlcaparams(1);
        setboosterrampqf('NoDisplay');
%         setlcaparams(0);
        set(handles.HeartBeat, 'FontSize', FontSize);
    end
    
    % Heart beat
    a = get(handles.HeartBeat, 'UserData')+1;
    set(handles.HeartBeat, 'UserData', a);
    set(handles.HeartBeat, 'String', num2str(a));
else
    % Heart beat
    a = get(handles.HeartBeat, 'UserData')+1;
    set(handles.HeartBeat, 'UserData', a);
    set(handles.HeartBeat, 'String', num2str(-1*a));
end
    
% Look for a change in the QD table in Hiroshi's app
if get(handles.QDCopy,'Value')
    QDsmallnew = getpv('QD', 'ILCTrim');
    setappdata(handles.BRControl, 'QDsmall', QDsmallnew);
    
    if isempty(QDsmall) || any(QDsmallnew~=QDsmall)
        FontSize = get(handles.HeartBeat, 'FontSize');
        set(handles.HeartBeat, 'FontSize', 8);        
        set(handles.HeartBeat, 'String', 'Loading Table...');
        drawnow;
%         setlcaparams(1);
        setboosterrampqd('NoDisplay');
%         setlcaparams(0);
        set(handles.HeartBeat, 'FontSize', FontSize);
    end
    
    % Heart beat
    a = get(handles.HeartBeat, 'UserData')+1;
    set(handles.HeartBeat, 'UserData', a);
    set(handles.HeartBeat, 'String', num2str(a));
else
    % Heart beat
    a = get(handles.HeartBeat, 'UserData')+1;
    set(handles.HeartBeat, 'UserData', a);
    set(handles.HeartBeat, 'String', num2str(-1*a));
end

% --------------------------------------------------------------------
function LoadBRQFWaveform_Callback(hObject, eventdata, handles)

QFCopy = get(handles.QFCopy, 'Value');
if QFCopy
    warndlg({'The Table Server is on!  So the golden ramp table is continually being','download to the PS controller along with the QFity correction.',' ','If you want to download only the golden waveform, turn off the Table Server first.'},'QF Golden Waveform');
    return;
end

fprintf('   Updating the BR QF table with the golden table ... ');
tic;
BR_QF_Ramp_Table = getgoldenramptablequad;
lcaPut('BR1:QF:RAMPSET', BR_QF_Ramp_Table, 'int32');
setpv('BR1:QF:SWAP_TABLE', 1);
fprintf(' complete (%.1f sec to download table) %s\n', toc, datestr(now,31));


% --------------------------------------------------------------------
function SaveBRQFWaveform_Callback(hObject, eventdata, handles)

% First disable table writes
QFCopy = get(handles.QFCopy, 'Value');
if QFCopy
    set(handles.QFCopy, 'Value', 0);
    pause(1.25);
    fprintf('   Turning off the "Table Server"\n');
end

BR_QF_Ramp_Table = getramptablequad;

% Operations data directory
DirectoryName = getfamilydata('Directory','OpsData');
FileName = [DirectoryName, 'QF_Ramptable_Golden.mat'];

save(FileName, 'BR_QF_Ramp_Table');
fprintf('   BR QF table save to %s\n', FileName);

fprintf('   Before turning back on the "Table Server" the QF Linearity Corrector 100 point table must be zeroed!!!\n');
fprintf('   Loading QF_zero.txt and clicking the Write button is one way to do it.\n\n');

% --------------------------------------------------------------------
function LoadBRQDWaveform_Callback(hObject, eventdata, handles)

QDCopy = get(handles.QDCopy, 'Value');
if QDCopy
    warndlg({'The Table Server is on!  So the golden ramp table is continually being','download to the PS controller along with the linearity correction.',' ','If you want to download only the golden waveform, turn off the Table Server first.'},'QD Golden Waveform');
    return;
end

fprintf('   Updating the BR QD table with the golden table ... ');
tic;
[BR_QF_Ramp_Table,BR_QD_Ramp_Table] = getgoldenramptablequad;
lcaPut('BR1:QD:RAMPSET', BR_QD_Ramp_Table, 'int32');
setpv('BR1:QD:SWAP_TABLE', 1);
fprintf(' complete (%.1f sec to download table) %s\n', toc, datestr(now,31));


% --------------------------------------------------------------------
function SaveBRQDWaveform_Callback(hObject, eventdata, handles)

% First disable table writes
QDCopy = get(handles.QDCopy, 'Value');
if QDCopy
    set(handles.QDCopy, 'Value', 0);
    pause(1.25);
    fprintf('   Turning off the "Table Server"\n');
end

[BR_QF_Ramp_Table,BR_QD_Ramp_Table] = getramptablequad;

% Operations data directory
DirectoryName = getfamilydata('Directory','OpsData');
FileName = [DirectoryName, 'QD_Ramptable_Golden.mat'];

save(FileName, 'BR_QD_Ramp_Table');
fprintf('   BR QD table save to %s\n', FileName);

fprintf('   Before turning back on the "Table Server" the QD Linearity Corrector 100 point table must be zeroed!!!\n');
fprintf('   Loading QD_zero.txt and clicking the Write button is one way to do it.\n\n');

function setlcaparams(varargin)

%set lca put and get parameters so digital controller table loads work reasonably - 12-14-10, T.Scarvie and C.Steier
if nargin<1
    mode = 0;
else
    mode = varargin{1};
end

if mode == 0;
    disp('  Setting lcaSetTimeout to 0.1s (default)');
    lcaSetTimeout(0.1); %default is 0.1
    disp('  Setting lcaSetRetryCount to 200 tries (default)');
    lcaSetRetryCount(200); %default is 200
elseif mode == 1;
    disp('  Setting lcaSetTimeout to 2s');
    lcaSetTimeout(2); %default is 0.1
    disp('  Setting lcaSetRetryCount to 50 tries');
    lcaSetRetryCount(50); %default is 200
else
    disp('  Unknown option passed to setlacparams');
end


% --------------------------------------------------------------------
function BPMInit_Callback(hObject, eventdata, handles)
bpminit;
fprintf('   BPM Init Complete (brcontrol)\n');
