function varargout = gtbcontrol(varargin)
%GTBCONTROL M-file for gtbcontrol.fig
%      GTBCONTROL, by itself, creates a new GTBCONTROL or raises the existing
%      singleton*.
%
%      H = GTBCONTROL returns the handle to a new GTBCONTROL or the handle to
%      the existing singleton*.
%
%      GTBCONTROL('Property','Value',...) creates a new GTBCONTROL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gtbcontrol_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GTBCONTROL('CALLBACK') and GTBCONTROL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GTBCONTROL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gtbcontrol

% Last Modified by GUIDE v2.5 22-Feb-2016 19:14:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gtbcontrol_OpeningFcn, ...
    'gui_OutputFcn',  @gtbcontrol_OutputFcn, ...
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


% --- Executes just before gtbcontrol is made visible.
function gtbcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gtbcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gtbcontrol wait for user response (see UIRESUME)
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
set(hObject, 'Position', [10 (ScreenSize(4)-AppSize(4)-20) AppSize(3) AppSize(4)]);

set(0, 'Units', ScreenDefault);
set(hObject, 'Units', AppDefault);



% --- Outputs from this function are returned to the command line.
function varargout = gtbcontrol_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;



 % --------------------------------------------------------------------
function MachineConfigGolden_Callback(hObject, eventdata, handles)
machineconfig('Golden', 'Display');


 
% --------------------------------------------------------------------
function MachineConfigFile_Callback(hObject, eventdata, handles)
machineconfig('', 'Display');
 


% --- Executes on button press in HWInit.
function HWInit_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'Initialize various parameter in the GTB',' ','Initialize the GTB hardware?'},'HWINIT','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   *********************************************\n');
    fprintf('   **  GTB Hardware Initialization Cancelled  **\n');
    fprintf('   *********************************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   *****************************************\n');
    fprintf('   **  GTB Hardware Initializion Started  **\n');
    fprintf('   *****************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    hwinit;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************************\n');
    fprintf('   **  GTB Hardware Initializion Complete  **\n');
    fprintf('   ******************************************\n\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ******************************************\n');
    fprintf(2, '   **  GTB Hardware Initializion Error!!!  **\n');
    fprintf(2, '   ******************************************\n\n');
end



% --- Executes on button press in TurnOff.
function TurnOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will turn off most of the elements in the GTL','(Power supplies, Electron Gun, Subharmonic Bunch, Modulator)',' ','Turn off the GTB?'},'Turn Off','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   ******************************\n');
    fprintf('   **  GTB Turn Off Cancelled  **\n');
    fprintf('   ******************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   ***************************\n');
    fprintf('   **  Turning the GTB Off  **\n');
    fprintf('   ***************************\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.MPSOff,  'Enable', 'Off');
    set(handles.EGOff,   'Enable', 'Off');
    set(handles.SHBOff,  'Enable', 'Off');
    set(handles.MODOff,  'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.MPSOn,   'Enable', 'Off');
    set(handles.EGOn,    'Enable', 'Off');
    set(handles.SHBOn,   'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;
    
    % Turn off magnet power supplies
    turnoffmps;
    
    % Turn off the electron gun
    turnoffeg;
    
    % Turn off EG Heater
    On = getpv('EG______HTR____BC22');
    if On == 1
        setpv('EG______HTR____BC22', 0);
        fprintf('   Turning EG heater off\n');
    else
        fprintf('   EG heater is already off\n');
    end

    % Turn off the subharmonic buncher
    turnoffshb;    

    % Turn off the modulator
    turnoffmodulator;    

    % TV
    try
        % Lamps (so they don't wear out)
        %Lamp = getpv('TV', 'Lamp');
        setpv('TV', 'LampControl', 0);
        fprintf('   Turning off the TV lamps\n');
    catch
        fprintf(2, '\n%s\n', lasterr);
        fprintf(2, '   Error turning off the TV lamps\n');
    end

    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************\n');
    fprintf('   **  GTB Is Off  **\n');
    fprintf('   ******************\n\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ************************************\n');
    fprintf(2, '   **  Error Turning Off the GTB!!!  **\n');
    fprintf(2, '   ************************************\n\n');
end

set(handles.Cycle,   'Enable', 'On');
set(handles.TurnOff, 'Enable', 'On');
set(handles.MPSOff,  'Enable', 'On');
set(handles.EGOff,   'Enable', 'On');
set(handles.SHBOff,  'Enable', 'On');
set(handles.MODOff,  'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.MPSOn,   'Enable', 'On');
set(handles.EGOn,    'Enable', 'On');
set(handles.SHBOn,   'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;


% --- Executes on button press in TurnOn.
function TurnOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will turn on most of the elements in the GTL','(Power supplies, Electron Gun, Subharmonic Bunch)',' ','Turn on the GTB?'},'Turn Off','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   ****************************\n');
    fprintf('   **  GTB All On Cancelled  **\n');
    fprintf('   ****************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   **************************\n');
    fprintf('   **  Turning the GTB On  **\n');
    fprintf('   **************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.MPSOff,  'Enable', 'Off');
    set(handles.EGOff,   'Enable', 'Off');
    set(handles.SHBOff,  'Enable', 'Off');
    set(handles.MODOff,  'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.MPSOn,   'Enable', 'Off');
    set(handles.EGOn,    'Enable', 'Off');
    set(handles.SHBOn,   'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;

    % Turn on magnet power supplies
    turnonmps;
    
    % Turn on the subharmonic buncher
    turnonshb;

    % Turn on the electron gun heater
    % Don't turn on the HV since the heater may not have been on for 5 minutes
    % turnoneg;
    % try
    %     % Heater
    %     On = getpv('EG______HTR____BC22');
    %     if On == 0
    %         setpv('EG______HTR____BC22', 1);
    %         fprintf('   Turning EG heater on\n');
    %     else
    %         fprintf('   EG heater is already on\n');
    %     end
    % catch
    %     fprintf(2, '\n%s\n', lasterr);
    %     fprintf(2, '   Error checking the electron gun heater control\n');
    % end
    fprintf('   The electron gun heater & HV was not changed.\n');

    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *********************\n');
    fprintf('   **  The GTB is On  **\n');
    fprintf('   *********************\n\n');
catch
    fprintf(2, '%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ***********************************\n');
    fprintf(2, '   **  Error Turning the GTB On!!!  **\n');
    fprintf(2, '   ***********************************\n\n');
end

set(handles.Cycle,   'Enable', 'On');
set(handles.TurnOff, 'Enable', 'On');
set(handles.MPSOff,  'Enable', 'On');
set(handles.EGOff,   'Enable', 'On');
set(handles.SHBOff,  'Enable', 'On');
set(handles.MODOff,  'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.MPSOn,   'Enable', 'On');
set(handles.EGOn,    'Enable', 'On');
set(handles.SHBOn,   'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;



% --- Executes on button press in MPSOff.
function MPSOff_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will turn off','the GTB power supplies.',' ','Turn off?'},'Turn Off','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   *******************************************\n');
    fprintf('   **  GTB Power Supply Turn Off Cancelled  **\n');
    fprintf('   *******************************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   **************************************\n');
    fprintf('   **  Turning GTB Power Supplies Off  **\n');
    fprintf('   **************************************\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.MPSOff,  'Enable', 'Off');
    set(handles.EGOff,   'Enable', 'Off');
    set(handles.SHBOff,  'Enable', 'Off');
    set(handles.MODOff,  'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.MPSOn,   'Enable', 'Off');
    set(handles.EGOn,    'Enable', 'Off');
    set(handles.SHBOn,   'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;
    
    % Turn off magnet power supplies
    turnoffmps;
    
    % Turn off the electron gun
    turnoffeg;    
    
    % Turn off the subharmonic buncher
    turnoffshb;    

    % Turn off the modulator
    turnoffmodulator;    

    % TV
    try
        % Lamps (so they don't wear out)
        %Lamp = getpv('TV', 'Lamp');
        setpv('TV', 'LampControl', 0);
        fprintf('   Turning off the TV lamps\n');
    catch
        fprintf(2, '\n%s\n', lasterr);
        fprintf(2, '   Error turning off the TV lamps\n');
    end

    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   **********************************\n');
    fprintf('   **  GTB Power Supplies are Off  **\n');
    fprintf('   **********************************\n\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ***********************************************\n');
    fprintf(2, '   **  Error Turning GTB Power Supplies Off!!!  **\n');
    fprintf(2, '   ***********************************************\n\n');
end

set(handles.Cycle,   'Enable', 'On');
set(handles.TurnOff, 'Enable', 'On');
set(handles.MPSOff,  'Enable', 'On');
set(handles.EGOff,   'Enable', 'On');
set(handles.SHBOff,  'Enable', 'On');
set(handles.MODOff,  'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.MPSOn,   'Enable', 'On');
set(handles.EGOn,    'Enable', 'On');
set(handles.SHBOn,   'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;



% --- Executes on button press in TurnOn.
function MPSOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will turn on','the GTB power supplies.',' ','Turn on?'},'Turn Off','Yes','No','No');
drawnow;

if ~strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   *************************************\n');
    fprintf('   **  GTB Power Supply On Cancelled  **\n');
    fprintf('   *************************************\n\n');
    return
end

try
    fprintf('\n');
    fprintf('   *************************************\n');
    fprintf('   **  Turning GTB Power Supplies On  **\n');
    fprintf('   *************************************\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.MPSOff,  'Enable', 'Off');
    set(handles.EGOff,   'Enable', 'Off');
    set(handles.SHBOff,  'Enable', 'Off');
    set(handles.MODOff,  'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.MPSOn,   'Enable', 'Off');
    set(handles.EGOn,    'Enable', 'Off');
    set(handles.SHBOn,   'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;

    % Turn on magnet power supplies
    turnonmps;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *********************************\n');
    fprintf('   **  GTB Power Supplies are On  **\n');
    fprintf('   *********************************\n\n');
catch
    fprintf(2, '\n%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   **********************************************\n');
    fprintf(2, '   **  Error Turning GTB Power Supplies On!!!  **\n');
    fprintf(2, '   **********************************************\n\n');
end


set(handles.Cycle,   'Enable', 'On');
set(handles.TurnOff, 'Enable', 'On');
set(handles.MPSOff,  'Enable', 'On');
set(handles.EGOff,   'Enable', 'On');
set(handles.SHBOff,  'Enable', 'On');
set(handles.MODOff,  'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.MPSOn,   'Enable', 'On');
set(handles.EGOn,    'Enable', 'On');
set(handles.SHBOn,   'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;



% --- Executes on button press in EGOff.
function EGOff_Callback(hObject, eventdata, handles)

try
    % Turn on the electron gun
    fprintf('\n');
    fprintf('   ************************************\n');
    fprintf('   **  Turning the Electron Gun Off  **\n');
    fprintf('   ************************************\n');

    turnoffeg;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ************************\n');
    fprintf('   **  Electron Gun Off  **\n');
    fprintf('   ************************\n\n');
catch
    fprintf(2, '%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   *********************************************\n');
    fprintf(2, '   **  Error Turning Off the Electron Gun!!!  **\n');
    fprintf(2, '   *********************************************\n\n');
end


% --- Executes on button press in EGOn.
function EGOn_Callback(hObject, eventdata, handles)
% Turn on the electron gun
try
    % Turn on the electron gun
    fprintf('\n');
    fprintf('   ***********************************\n');
    fprintf('   **  Turning the Electron Gun On  **\n');
    fprintf('   ***********************************\n');

    turnoneg;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************\n');
    fprintf('   **  Electron Gun On  **\n');
    fprintf('   ***********************\n\n');
catch
    fprintf(2, '%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ********************************************\n');
    fprintf(2, '   **  Error Turning On the Electron Gun!!!  **\n');
    fprintf(2, '   ********************************************\n\n');
end


% --- Executes on button press in SHBOff.
function SHBOff_Callback(hObject, eventdata, handles)
try
    % Turn off the SHB
    fprintf('\n');
    fprintf('   *******************************************\n');
    fprintf('   **  Turning the Subharmonic Buncher Off  **\n');
    fprintf('   *******************************************\n');
    
    turnoffshb;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *******************************\n');
    fprintf('   **  Subharmonic Buncher Off  **\n');
    fprintf('   *******************************\n\n');
catch
    fprintf(2, '%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ****************************************************\n');
    fprintf(2, '   **  Error Turning Off the Subharmonic Buncher!!!  **\n');
    fprintf(2, '   ****************************************************\n\n');
end


% --- Executes on button press in SHBOn.
function SHBOn_Callback(hObject, eventdata, handles)
try
    % Turn on the SHB
    fprintf('\n');
    fprintf('   ******************************************\n');
    fprintf('   **  Turning the Subharmonic Buncher On  **\n');
    fprintf('   ******************************************\n');

    turnonshb;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ******************************\n');
    fprintf('   **  Subharmonic Buncher On  **\n');
    fprintf('   ******************************\n\n');
catch
    fprintf(2, '%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ***************************************************\n');
    fprintf(2, '   **  Error Turning On the Subharmonic Buncher!!!  **\n');
    fprintf(2, '   ***************************************************\n\n');
end


% --- Executes on button press in MODOff.
function MODOff_Callback(hObject, eventdata, handles)
try
    % Turn off the modulator
    fprintf('\n');
    fprintf('   *********************************\n');
    fprintf('   **  Turning the Modulator Off  **\n');
    fprintf('   *********************************\n');

    turnoffmod;
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *********************\n');
    fprintf('   **  Modulator Off  **\n');
    fprintf('   *********************\n\n');
catch
    fprintf(2, '%s\n', lasterr);
    a = clock;
    fprintf(2, '   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf(2, '   ******************************************\n');
    fprintf(2, '   **  Error Turning Off the Modulator!!!  **\n');
    fprintf(2, '   ******************************************\n\n');
end


% --- Executes on button press in Cycle.
function Cycle_Callback(hObject, eventdata, handles)
InjectionEnergy = getfamilydata('InjectionEnergy');
%ButtonName = questdlg(sprintf('Start the Gun-To-Booster cycle, %.2f GeV?',InjectionEnergy),'GTB Cycle','Yes','Cancel','Cancel');
ButtonName = questdlg(sprintf('Start the Gun-To-Booster cycle, %.2f GeV?',InjectionEnergy), 'GTB Cycle','Cycle to Golden','Cycle to File (Selectable)', 'Cancel', 'Cancel');
drawnow;

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
    fprintf('   **  GTB Cycle  **\n');
    fprintf('   *****************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    set(handles.Cycle,   'Enable', 'Off');
    set(handles.TurnOff, 'Enable', 'Off');
    set(handles.MPSOff,  'Enable', 'Off');
    set(handles.EGOff,   'Enable', 'Off');
    set(handles.SHBOff,  'Enable', 'Off');
    set(handles.MODOff,  'Enable', 'Off');
    set(handles.TurnOn,  'Enable', 'Off');
    set(handles.MPSOn,   'Enable', 'Off');
    set(handles.EGOn,    'Enable', 'Off');
    set(handles.SHBOn,   'Enable', 'Off');
    set(handles.HWInit,  'Enable', 'Off');
    drawnow;

    gtbcycle(FileName);

    %fprintf('   Loading the injection lattice   ...');
    %[ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
    %setmachineconfig(ConfigSetpoint, -1);
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***********************************************\n');
    fprintf('   **  GTB Cycle Complete, Ready for Injection  **\n');
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
set(handles.MPSOff,  'Enable', 'On');
set(handles.EGOff,   'Enable', 'On');
set(handles.SHBOff,  'Enable', 'On');
set(handles.MODOff,  'Enable', 'On');
set(handles.TurnOn,  'Enable', 'On');
set(handles.MPSOn,   'Enable', 'On');
set(handles.EGOn,    'Enable', 'On');
set(handles.SHBOn,   'Enable', 'On');
set(handles.HWInit,  'Enable', 'On');
drawnow;



% --- Executes on button press in MPS_EDM.
function ApplicationKnown_Callback(hObject, eventdata, handles)

gtbscopes;



% --- Executes on button press in MPS_EDM.
function MPS_EDM_Callback(hObject, eventdata, handles)
if ispc
    winopen('X:\ALSStartMenu\GTB\MPS_apps1_alsoper2.xcas');
else
    unix('runGTB_MPS.sh');
    %unix('/home/als/physbase/hlc/GTB/runGTB_MPS.sh');
    %unix('/home/als/physbase/hlc/GTB/runGTB_Pulsed_Magnets.sh');
end


% --- Executes on button press in Injection.
% function Injection_Callback(hObject, eventdata, handles)
% %GTB_Mode = getfamilydata('OperationalMode');
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
%     fprintf('   **  Function complete:  the GTB is setup for injection **\n');
%     fprintf('   *********************************************************\n\n');
% catch
%     fprintf('   %s \n', lasterr);
%     fprintf('   Injection lattice setup failed due to error condition! \n\n');
%     
%     a = clock;
%     fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
%     fprintf('   ****************************************\n');
%     fprintf('   **  Problem with GTB injection setup  **\n');
%     fprintf('   ****************************************\n\n');
% end



% --- Executes on button press in CheckForProblems.
%function CheckForProblems_Callback(hObject, eventdata, handles)
% fprintf('\n');
% disp('   ***********************************');
% disp('   **  Checking Storage Ring State  **');
% disp('   ***********************************');
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
%     disp('   **  GTB Has Problems  **');
%     disp('   ************************');
% else
%     disp('   *************************');
%     disp('   **  GTB Lattice is OK  **');
%     disp('   *************************');
% end
% fprintf('   \n');


% --------------------------------------------------------------------
function InitCaenGTB_Callback(hObject, eventdata, handles)
try
    setcaen('Init GTB', '');
catch
    fprintf(2, '%s\n\n', lasterr);
    fprintf(2, 'Problem when initializing the Caen power supplies from the Gun to the Booster.\n\n');
end


% --------------------------------------------------------------------
function CheckCaenGTB_Callback(hObject, eventdata, handles)
checkcaen('GTB');


% --------------------------------------------------------------------
function InitBPM_Callback(hObject, eventdata, handles)
bpminit;
fprintf('   BPM Init Complete (gtbcontrol - bpminit)\n');


% --------------------------------------------------------------------
function hwinit_Callback(hObject, eventdata, handles)
hwinit;
fprintf('   Hardware Init Complete (gtbcontrol -> hwinit)\n');
