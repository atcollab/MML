function varargout = btscontrol(varargin)
%BTSCONTROL M-file for btscontrol.fig
%      BTSCONTROL, by itself, creates a new BTSCONTROL or raises the existing
%      singleton*.
%
%      H = BTSCONTROL returns the handle to a new BTSCONTROL or the handle to
%      the existing singleton*.
%
%      BTSCONTROL('Property','Value',...) creates a new BTSCONTROL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to btscontrol_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BTSCONTROL('CALLBACK') and BTSCONTROL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BTSCONTROL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help btscontrol

% Last Modified by GUIDE v2.5 20-Jan-2016 17:23:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @btscontrol_OpeningFcn, ...
    'gui_OutputFcn',  @btscontrol_OutputFcn, ...
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
%#function setoperationalmode, resetudferrors, plotfamily, viewfamily, machineconfig, epicsdatabasechanges


% --- Executes just before btscontrol is made visible.
function btscontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for btscontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes btscontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% ALS Initialization Below

% Check if the AO exists
checkforao;

% Update database channels
%CheckInputs(handles);

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
GTBHeight = 325;
set(hObject, 'Position', [10 (ScreenSize(4)-AppSize(4)-GTBHeight-150) AppSize(3) AppSize(4)]);

set(0, 'Units', ScreenDefault);
set(hObject, 'Units', AppDefault);



% --- Executes on button press in HWInit.
function HWInit_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'Initialize various parameter in the BTS',' ','Initialize the BTS hardware?'},'HWINIT','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   *********************************************\n');
    fprintf('   **  BTS Hardware Initialization Cancelled  **\n');
    fprintf('   *********************************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   *****************************************\n');
    fprintf('   **  BTS Hardware Initializion Started  **\n');
    fprintf('   *****************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    hwinit;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************************\n');
    fprintf('   **  BTS Hardware Initializion Complete  **\n');
    fprintf('   ******************************************\n\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ******************************************\n');
    fprintf(2, '   **  BTS Hardware Initializion Error!!!  **\n');
    fprintf(2, '   ******************************************\n\n');
end



% --- Outputs from this function are returned to the command line.
function varargout = btscontrol_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in TurnOff.
function TurnOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will ramp down all','the BTS magnets then turn them off.',' ','Turn off the BTS magnet power supplies?'},'Turn Off','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   ****************************************\n');
    fprintf('   **  BTS Power Supplies Off Cancelled  **\n');
    fprintf('   ****************************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   **************************************\n');
    fprintf('   **  Turning BTS Power Supplies Off  **\n');
    fprintf('   **************************************\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;

    turnoffmps;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   **********************************\n');
    fprintf('   **  BTS Power Supplies Are Off  **\n');
    fprintf('   **********************************\n\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ***********************************************\n');
    fprintf(2, '   **  Error Turning BTS Power Supplies Off!!!  **\n');
    fprintf(2, '   ***********************************************\n\n');
end

set(handles.Cycle,   'Enable', 'On');
set(handles.TurnOff, 'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;


% --- Executes on button press in TurnOn.
function TurnOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will turn on with zero setpoint [and reset if necessary]','all the BTS magnets power supplies that are not presently on.',' ','Turn on the BTS magnet power supplies?'},'Turn Off','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   ***************************************\n');
    fprintf('   **  BTS Power Supplies On Cancelled  **\n');
    fprintf('   ***************************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   *************************************\n');
    fprintf('   **  Turning BTS Power Supplies On  **\n');
    fprintf('   *************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;

    turnonmps;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *********************************\n');
    fprintf('   **  BTS Power Supplies Are On  **\n');
    fprintf('   *********************************\n\n');
catch
    fprintf(2, '%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   **********************************************\n');
    fprintf(2, '   **  Error Turning BTS Power Supplies On!!!  **\n');
    fprintf(2, '   **********************************************\n\n');
end

set(handles.Cycle,   'Enable', 'On');
set(handles.TurnOff, 'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;


% --- Executes on button press in Cycle.
function Cycle_Callback(hObject, eventdata, handles)
InjectionEnergy = getfamilydata('InjectionEnergy');
ButtonName = questdlg(sprintf('Start the Booster-to-Storage Ring cycle, %.2f GeV?',InjectionEnergy), 'BTS Cycle','Cycle to Golden','Cycle to File (Selectable)', 'Cancel', 'Cancel');

switch ButtonName
    case 'Cycle to Golden'
        FileName = 'Golden';
    case 'Cycle to File (Selectable)'
        FileName = '';
    otherwise
        fprintf('\n');
        fprintf('   **************************\n');
        fprintf('   **    Cycle  Canceled   **\n');
        fprintf('   **************************\n\n');
        return
end

try
    fprintf('\n');
    fprintf('   *****************\n');
    fprintf('   **  BTS Cycle  **\n');
    fprintf('   *****************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;

    btscycle(FileName);

    %fprintf('   Loading the injection lattice   ...');
    %[ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
    %setmachineconfig(ConfigSetpoint, -1);
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  BTS Cycle Complete, Ready for Injection  **\n');
    fprintf('   ***********************************************\n\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ******************************************\n');
    fprintf(2, '   ** Cycle Failed Due to Error Condition  **\n');
    fprintf(2, '   ******************************************\n\n');
end

set(handles.Cycle,   'Enable', 'On');
set(handles.TurnOff, 'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;


% --------------------------------------------------------------------
function MachineConfigGolden_Callback(hObject, eventdata, handles)
machineconfig('Golden');


% % --- Executes on button press in MPS_EDM.
% function BRScopes_Callback(hObject, eventdata, handles)
% 
% als_waveforms('Booster RF');
% als_waveforms('Booster ICT');
% 
% 
% % --- Executes on button press in MPS_EDM.
% function MPS_EDM_Callback(hObject, eventdata, handles)
% if ispc
%     winopen('X:\ALSStartMenu\BTS\MPS_apps1_alsoper2.xcas');
% else
%     unix('/home/als/physbase/hlc/BTS/runBTS_MPS.sh');
%     %unix('/home/als/physbase/hlc/BTS/runBTS_Pulsed_Magnets.sh');
% end


% --------------------------------------------------------------------
function MachineConfigFile_Callback(hObject, eventdata, handles)
machineconfig('');



% --- Executes on button press in Injection.
% function Injection_Callback(hObject, eventdata, handles)
% %BTS_Mode = getfamilydata('OperationalMode');
% InjectionEnergy = getfamilydata('InjectionEnergy');
% StartFlag = questdlg(sprintf('Start setup for injection, %.2f GeV?',InjectionEnergy),'Injection Setup','Yes','Cancel','Cancel');
% drawnow;
% 
% if ~strcmp(StartFlag, 'Yes')
%     fprintf('\n');
%     fprintf('   ********************************\n');
%     fprintf('   **  Injection Setup Canceled  **\n');
%     fprintf('   ********************************\n\n');
%     return
% end
% 
% try
%     fprintf('\n');
%     fprintf('   *************************************************\n');
%     fprintf('   **  Setup For On Energy Injection at %.2f GeV  **\n', InjectionEnergy);
%     fprintf('   *************************************************\n');
%     a = clock;
%     fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
%     
%     % Load injection lattice
%     fprintf('   Loading the injection lattice   ...');
%     [ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
%     setmachineconfig(ConfigSetpoint, -1);
%     
%     a = clock;
%     fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
%     fprintf('   *********************************************************\n');
%     fprintf('   **  Function complete:  the BTS is setup for injection **\n');
%     fprintf('   *********************************************************\n\n');
% catch
%     fprintf('   %s \n', lasterr);
%     fprintf('   Injection lattice setup failed due to error condition! \n\n');
%     
%     a = clock;
%     fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
%     fprintf('   ****************************************\n');
%     fprintf('   **  Problem with BTS injection setup  **\n');
%     fprintf('   ****************************************\n\n');
% end



% --- Executes on button press in CheckForProblems.
function CheckForProblems_Callback(hObject, eventdata, handles)
% fprintf('\n');
% disp('   *********************************');
% disp('   **  Checking BTS for Problems  **');
% disp('   *********************************');
% a = clock;
% fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
% 
% NumErrors = 0;
% 
% [ConfigSetpoint, ConfigMonitor, FileName] = getinjectionlattice;
% 
% % Check all SR magnets
% if isempty(FileName)
%     fprintf('   Goal setpoints will not be checked since the last lattice load is unknown.\n');
%     NumErrors1 = checksrmags('');
% else
%     %NumErrors1 = checksrmags([getfamilydata('Directory','OpsData') FileName]);
%     NumErrors1 = checksrmags(FileName);
% end
% if NumErrors1 == 0
%     fprintf('   SR magnets power supplies are OK.\n');
% end
% NumErrors = NumErrors + NumErrors1;
% 
% 
% a = clock;
% fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
% if NumErrors
%     disp('   ************************');
%     disp('   **  BTS Has Problems  **');
%     disp('   ************************');
% else
%     disp('   *************************');
%     disp('   **  BTS Lattice is OK  **');
%     disp('   *************************');
% end
% fprintf('   \n');



% --- Executes on button press in GoldenPage.
function GoldenPage_Callback(hObject, eventdata, handles)
goldenpage;


% --------------------------------------------------------------------
function InitCaenBTS_Callback(hObject, eventdata, handles)
try
    setcaen('Init BTS','');
catch
    fprintf(2, '%s\n\n', lasterr);
    fprintf(2, 'Problem when initializing the Caen power supplies from the Booster to Storage Ring.\n\n');
end


% --------------------------------------------------------------------
function CheckCaenBTS_Callback(hObject, eventdata, handles)
checkcaen('BTS');


% --------------------------------------------------------------------
function BPMInit_Callback(hObject, eventdata, handles)
bpminit;
fprintf('   BPM Init Complete (btscontrol)\n');
