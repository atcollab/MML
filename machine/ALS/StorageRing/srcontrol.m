function varargout = srcontrol(varargin)
%SRCONTROL M-file for srcontrol.fig
%      SRCONTROL, by itself, creates a new SRCONTROL or raises the existing
%      singleton*.
%
%      H = SRCONTROL returns the handle to a new SRCONTROL or the handle to
%      the existing singleton*.
%
%      SRCONTROL('Property','Value',...) creates a new SRCONTROL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to srcontrol_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SRCONTROL('CALLBACK') and SRCONTROL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SRCONTROL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help srcontrol

% Last Modified by GUIDE v2.5 19-Sep-2016 16:21:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @srcontrol_OpeningFcn, ...
    'gui_OutputFcn',  @srcontrol_OutputFcn, ...
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


% For the compiler
%#function goldenpage, setoperationalmode, machineconfig, getlfbconfig, gettfbconfig, getthcconfig, showtfb, settfbconfig, showthc, setthcconfig, epicsdatabasechanges, saveusergaps, resetudferrors

% setlfbconfig -> not ready yet


% known bugs/problems (May 2001):
% - IDBPM averaging might be a bit too long for orbit feedback
%        solved after Superbend shutdown ... Instead of averaging, digital low pass filters are used
% - gap2tune does not give correct answers for wiggler and potentially other IDs -> orbit feedback
%        seems to be OK for other IDs, has been corrected for wiggler (fit to insertion device
%        compensation table)
% - chicanes do not work in orbit feedback
%        solved. One problem was that orbit response matrizes were mis-scaled by factor of two.
%        Second problem was different time constant of power supply control. Solved by moving controls
%        of center chicanes to cPCI (and magnets are fast, hysteresis free, aircore coils).
%        Center chicane in sector 4 is now routinely used in orbit feedback. Sector 11 to follow soon.
% - zero reading of ID gap dumps beam
%        solved in srcontrol5, still a problem in srcontrol5_hightune (but that routine has to be completely
%        rewritten because of all recent changes to srcontrol5, anyhow). For gap readings below the minimum
%        allowed gap for a device, the tune feedforward disables itself.
% - cycling of lattice causes frequent power supply failures
%        solved by changing the cycling procedure. 1.5 GeV operation is now on the upper hysteresis branch
%        as was the 1.9 GeV injection lattice before.
% - frequently stalled data in IDBPM readout
%        solved with new BPM readouts and digital filtering. Seems to have been a resolution problem
%        of the digital averaging algorithm.
% - magnet ramp tables are not in perfect agreement with magnetic measurements
%        Does not appear to be a serious problem. Superbends are slightly out of sync with other magnets,
%        but this does not cause any negative effects while ramping.
% - no good way to operate with injection at 1.5 GeV and storage energy below that
%        There now is a reasonable way to inject at 1.5 GeV and ramp down to lower storage energy. But
%        it has to be tested again after implementing new (and more) chicanes ...

% revision history
% 2001-05-10, Christoph Steier
% check whether readback from insertion device is significantly (more than 1 mm) below minimum
% gap, to avoid false zero readings of insertion device gaps to cause the tune feed forward
% to implement false huge correction (and dump the beam). If the insertion device gap readbacks
% gets more than 1 mm below the nominal minimum gap, the routine now assumes the insertion device
% to be open.
%
% 2001-08-30 and during Superbend commissioning, Christoph Steier, Tom Scarvie, Winni Decking
% various changes have been made to incorporate the Superbends and some other new equipment
% installed in the Superbend shutdown. This included some changes to programs being called by srcontrol
% (like srload, srcycle, srramp, ...). The main changes within srcontrol were in the orbit
% correction and slow orbit feedback routines (incorporating frequency feedback, ...)
%
% 2002-05-04, Christoph Steier
% added new IDBPMs, modified orbit feedback to use trim DACs, removed LSB toggling in vertical
% orbit feedback, ...
%
% 2002-07-29, T.Scarvie
% added check of CM trim currents to warn of problems that might rail the orbit feedback
%
% 2002-07-31, Christoph Steier
% increased the gain of the RF frequency feedback from 1/50 of the gain of the horizontal
% orbit feedback to 1/20. Reason was that the frequency feedback was reacting a bit too slow if all
% insertion device gaps are closed at once at high speed at the beginning of a fill.
%
% 2002-08-05, C.Steier, T.Scarvie
% Added conditional to reduce orbit feedback gain if running in two-bunch mode
%
% 2003-06-02, T.Scarvie
% Added loop inside orbit feedback to reset the SR11 chicane M1 and M2 motors every 20s to combat drift problem
%
% 2003-06-18, C. Steier
% Disabled loop to periodically reset chicane in SR11. Al Robb replaced power supply, seems to be no problem anymore.
%
% 2004-05-10, C. Steier
% The list of all BBPMs is now set up automatically be calling getlist('BBPMx'). This way, new BBPMs have to be added
% at fewer places in the software. It should now be sufficient to modify getlist and run the orbit response matrix
% rountine (getsmat) once to enable use of the new BBPMs.
%
% 2004-05-14, C. Steier
% Modified parameters for ramprate reduction (in srramp and here). Previous parameters were slightly too
% cautious. Increased initial slow ramprate to 0.4 A/s.
%
% 2004-05-14, C. Steier
% Incorporated insertion device compensation schemes for nu_y = 9.2 lattice.
%
% 2004-06-14, T.Scarvie
% Added controls for fast orbit feedback
%
% 2004-06-21, C. Steier
% Added tune feedforward (in the global tune compensation scheme for the nu_y=9.2 lattice) for the shift
% dependent tune shift of the EPUs, as well as a skew quadrupole feedforward for the EPU im sector 11
% (both only active in parallel mode so far).
%
% 2005-02-13, T.Scarvie
% Separated horizontal and vertical planes for setting Fast Feedback PIDs
%
% 2008-07-31, T.Scarvie
% Added checks to orbit correction to warn if SR bumps are on
%
% 2009-02-04, C. Steier
% Added code to implement MERLIN tune FF, also fixed bug in tune FF for EPU 4.1
%
% 2010-09-16, C. Steier
% Adjusted gain of RF frequency in feedback to take new voltage divider into account.
%
% 2010-11-15, C. Steier
% Changed steprf call in orbit correction to steprf_hp, a new routine, that implements the
% WaitFlag correctly for the ALS. This should fix the slow orbit correction but not affect
% any other routines that make use of the more precise way to set the RF frequency.
%
% 2012, C. Steier
% Optimized code for orbit feedback and particularly tune/beta beating FF.
% Main change is that FF is only calculated for the one gap that has
% changed. This resulted in a substantial speed up of the SOFB/FF loop.
%
% 2013, C. Steier
% Many small changes to orbit feedback to get it working smoothly after
% shutdown. Also incorporated new tune FF/beta beating FF for the new low
% emittance lattice.
%
% 2017, C. Steier
% Removed all legacy sections for tune compensation for lattices no longer
% used in production, since some of those had not been updated for recent device additions. 

% --- Executes just before srcontrol is made visible.
function srcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for srcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes srcontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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
set(hObject, 'Position', [20 (ScreenSize(4)-AppSize(4)-30) AppSize(3) AppSize(4)]);

set(0, 'Units', ScreenDefault);
set(hObject, 'Units', AppDefault);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALS Initialization Below %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if the AO exists
checkforao;

% Initialize
BSCramprate = getfamilydata('BSCRampRate');
if isempty(BSCramprate) || isnan(BSCramprate)
    BSCramprate = 0.4;
    setfamilydata(BSCramprate, 'BSCRampRate');
end


if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.CheckboxFOFB, 'Value', 0);
else
    set(handles.CheckboxFOFB, 'Value', 1);
end

if strcmp(getfamilydata('OperationalMode'), 'Pseudo-Single Bunch (0.18,0.25)') | strcmp(getfamilydata('OperationalMode'), '1.9 GeV, TopOff') | strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.CheckboxTuneFB, 'Enable', 'on');
    set(handles.CheckboxTuneFB, 'Value', 1);
else
    set(handles.CheckboxTuneFB, 'Enable', 'on');
    set(handles.CheckboxTuneFB, 'Value', 0);
end

setpvonline('SR_mode',getfamilydata('OperationalMode'));

% if strcmp(getfamilydata('OperationalMode'), '1.5 GeV, Inject at 1.23') || strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Inject at 1.353')
%     set(handles.CheckboxTune, 'Value', 0);
% else
set(handles.CheckboxTune, 'Value', 1);
% end

% Initialize the feedback loops
setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
OrbitCorrection_Init(handles);
SOFB_Init(handles);
FOFB_Init(handles);

% Update database channels
CheckInputs(handles);

%setup email preferences for operator cell phone warnings
setpref('Internet','E_mail','SRControl@als.lbl.gov');
setpref('Internet','SMTP_Server','csg.lbl.gov')


% Pseudo Single Bunch
PseudoSingleBunch = getfamilydata('PseudoSingleBunch');
if isempty(PseudoSingleBunch) || strcmpi(PseudoSingleBunch,'Off')
    set(handles.PseudoSingleBunch,'Checked','Off');
    setpv('Physics10',3);           % Before 2014-01-27 was 2 - i.e. 1:296, 318;, now set to 3, i.e. 1:296, 308. Affects topoff, hwinit (bclean), ...
else
    set(handles.PseudoSingleBunch,'Checked','On');
    setpv('Physics10',1);
end



function OrbitCorrection_Init(handles)
% Orbit Correction Setup

RFCorrFlag = 1;

[HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit('TopOfFill');

if RFCorrFlag
    HSV = HSV + 1;
end

%  ORBIT CORRECTION STRUCTURE (OCS)
OCSx.BPM = family2datastruct('BPMx', 'Monitor', HBPM.DeviceList);
OCSx.CM  = family2datastruct('HCM',  'Setpoint', HCM.DeviceList);
%OCSx.BPM = getam('BPMx', HBPM.DeviceList, 'struct');
%OCSx.CM  = getsp('HCM',  HCM.DeviceList,  'struct');
OCSx.GoalOrbit = getgolden(OCSx.BPM, 'numeric');
OCSx.NIter           = 1;
OCSx.SVDIndex        = 1:HSV;
OCSx.IncrementalFlag = 'No';
OCSx.FitRF           = RFCorrFlag;

OCSy.BPM = family2datastruct('BPMy', 'Monitor', VBPM.DeviceList);
OCSy.CM  = family2datastruct('VCM',  'Setpoint', VCM.DeviceList);
%OCSy.BPM = getam('BPMy', VBPM.DeviceList, 'struct');
%OCSy.CM  = getsp('VCM',  VCM.DeviceList,  'struct');
OCSy.GoalOrbit = getgolden(OCSy.BPM, 'numeric');
OCSy.NIter           = 1;
OCSy.SVDIndex        = 1:VSV;
OCSy.IncrementalFlag = 'No';
OCSy.FitRF           = 0;

% SaveMenu vectors
OCS.OCSx = OCSx;
OCS.OCSy = OCSy;
set(handles.OrbitCorrection_Edit, 'Userdata', OCS);


% Insertion devices
%LocalBumplist = []
LocalBumplist = [
    % 1 1
    % 2 1
    % 3 1
    % 4 1 %this bump removed since it is distorting orbit - reason unknown - 3-23-09 - T.Scarvie
    % 4 2
    %%5 1
    % 6 1
    % 6 2
    %%7 1
    %%8 1
    %%9 1 %this bump removed since HCM(8,8) is misbehaving - 2/17/09 - T.Scarvie
    %%10 1
    %%11 1
    %%11 2
    %%12 1
    ];
set(handles.OrbitCorrection, 'Userdata', LocalBumplist);



function SOFB_Init(handles)

[HBPM, VBPM, HCM, VCM, HSV, VSV] = ocsinit('SOFB');
Energy = getfamilydata('Energy');

OCSx.BPM = family2datastruct('BPMx', HBPM.DeviceList);
OCSx.CM  = family2datastruct('HCM', HCM.DeviceList);
%OCSx.BPM = getx(HBPM.DeviceList, 'struct');
%OCSx.CM  = getsp('HCM', HCM.DeviceList, 'struct');
OCSx.GoalOrbit = getgolden(OCSx.BPM, 'numeric');
OCSx.SVDIndex = 1:HSV;
OCSx.NIter = 1;
OCSx.IncrementalFlag = 'No';

OCSx.BPM.DeviceList = HBPM.DeviceList;
OCSy.BPM.DeviceList = VBPM.DeviceList;
OCSx.CM.DeviceList = HCM.DeviceList;
OCSy.CM.DeviceList = VCM.DeviceList;

% Convert to shorter variable names
BPMlist1 = OCSx.BPM.DeviceList;
HCMlist1 = OCSx.CM.DeviceList;
VCMlist1 = OCSy.CM.DeviceList;

% Sensitivity matrix (include energy so that the BEND can be anywhere)
Sx = getrespmat('BPMx', BPMlist1, 'HCM', HCMlist1, Energy);
Sy = getrespmat('BPMy', BPMlist1, 'VCM', VCMlist1, Energy);

% Check for missing response matrix data
if any(any(isnan(Sx)))
    fprintf('   Warning: The horizontal response matrix is missing some data!\n');
    Sx(isnan(Sx)) = 0;
end
if any(any(isnan(Sy)))
    fprintf('   Warning: The vertical response matrix is missing some data!\n');
    Sy(isnan(Sy)) = 0;
end

if get(handles.CheckboxRF,'Value') == 1
    OCSx.FitRF = 1;
    OCSx.SVDIndex = 1:HSV+1;
else
    OCSx.FitRF = 0;
    OCSx.SVDIndex = 1:HSV;
end

OCSy.BPM = family2datastruct('BPMy', VBPM.DeviceList);
OCSy.CM  = family2datastruct('VCM', VCM.DeviceList);
%OCSy.BPM = gety(VBPM.DeviceList, 'struct');
%OCSy.CM  = getsp('VCM', VCM.DeviceList, 'struct');
OCSy.GoalOrbit = getgolden(OCSy.BPM, 'numeric');
OCSy.SVDIndex = 1:VSV;
OCSy.NIter = 1;
OCSy.IncrementalFlag = 'No';
OCSy.FitRF = 0;

% Build the OCS structures
OCSx.BPM = getam('BPMx', BPMlist1, 'struct');
OCSx.CM  = getsp('HCM',  HCMlist1, 'struct');
OCSx.GoalOrbit = getgolden(OCSx.BPM, 'numeric');

OCSy.BPM = getam('BPMy', BPMlist1, 'struct');
OCSy.CM  = getsp('VCM',  VCMlist1, 'struct');
OCSy.GoalOrbit = getgolden(OCSy.BPM, 'numeric');

% Clear some variable so that they get recalculated in orbitcorrectionmethods
OCSx.BPMWeight = [];
OCSx.CMWeight  = [];
OCSx.Eta = [];
OCSx.Flags = {'GoldenDisp'};

OCSy.BPMWeight = [];
OCSy.CMWeight  = [];
OCSy.Eta = [];
OCSy.Flags = {};

% Calculate the new orbit correction structure (just to get SVx & SVy)
[OCSx, Sx, SVx, Ux, Vx] = orbitcorrectionmethods(OCSx, Sx);
[OCSy, Sy, SVy, Uy, Vy] = orbitcorrectionmethods(OCSy, Sy);

SOFB.OCSx = OCSx;
SOFB.OCSy = OCSy;
OCS = SOFB;
set(handles.SOFB_Edit, 'Userdata', SOFB);
set(handles.SOFB_Edit, 'Userdata', OCS);


function FOFB_Init(handles)
FOFBFreq = 1000;
% User operations 9/14-10/17/2004: P=0.5, I=120, D=0.0015 (for both planes)
% below are known good values for user ops as of 8-1-2005
% updated for new PSB lattice (quick and dirty optimization) 2014-11-02 -
% larger orbit response  because of tune closer to integer in x
HorP = 1.5*0.5*2/1.5; %/1.5 values added 2-18-09 due to FOFB trips during injection pulse + network trouble - T.Scarvie
HorI = 0.5*300/1.5;
HorD = 2*0.002/1.5;
VertP = 0.6*1;
VertI = 0.75*0.6*100;
VertD = 0.33*1*0.0015;

% SaveMenu vectors
FOFB.FOFBFreq = FOFBFreq;
FOFB.HorP = HorP;
FOFB.HorI = HorI;
FOFB.HorD = HorD;
FOFB.VertP = VertP;
FOFB.VertI = VertI;
FOFB.VertD = VertD;
set(handles.FOFB_Edit,'Userdata',FOFB);

% FOFB Alarm Handler Initialization
setpv('Physics1',0);
setpv('Physics1.HIGH',1);
setpv('Physics1.HIHI',1);
setpv('Physics1.HSV','MINOR');
setpv('Physics1.HHSV','MAJOR');


% --- CheckInputs
function CheckInputs(handles)
SR_Mode = getfamilydata('OperationalMode');
Energy = getfamilydata('Energy');
InjectionEnergy = getfamilydata('InjectionEnergy');

setsrstatechannels;

if Energy > 1.55 && InjectionEnergy < 1.55
    set(handles.Injection, 'String', ['Setup For Injection (Ramp Down)']);
    set(handles.Production,'String', ['Setup For Users (Ramp Up)']);
elseif Energy < 1.45
    set(handles.Injection, 'String', ['Setup For Injection (Ramp Up+cycle)']);
    set(handles.Production,'String', ['Setup For Users, ',num2str(round(10*Energy)/10),' GeV (Ramp Down)']);
else
    set(handles.Injection, 'String', ['Setup For Injection (', num2str(round(10*InjectionEnergy)/10),' GeV)']);
    set(handles.Production,'String', ['Setup For Users  (',    num2str(round(10*Energy)/10),         ' GeV)']);
end
set(handles.StaticHeaderText, 'String', SR_Mode);

[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
end



% --- Executes on button press in HWInit.
function HWInit_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'Initialize various parameter in the storage ring','like BPM averages, magnet ramp rates, etc.',' ','Initialize the storage ring hardware?'},'HWINIT','Yes','No','No');
drawnow;
if strcmp(StartFlag,'Yes')
    hwinit;
else
    fprintf('   Storage ring hardware initialization canceled.\n');
    return
end



% --- Executes on button press in TurnOff.
function TurnOff_Callback(hObject, eventdata, handles)
% To do: add sector turn off
StartFlag = questdlg({'This function will slowly ramp down','all the SR magnets then turn them off.',' ','Turn off the SR magnet power supplies?'},'Turn Off','Yes','No','No');
if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   ***********************************************\n');
    fprintf('   **  Turning Storage Ring Power Supplies Off  **\n');
    fprintf('   ***********************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    drawnow;
    
    try
        setpv('SR_STATE', 6.1);
        [StateNumber, StateString] = getsrstate;
        set(handles.InfoText, 'String', StateString, 'ForegroundColor', 'b');
        
        % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
        write_alarms_srmags_nominal;
        
        turnoffmps;
        
        setpv('SR_STATE', 6);
        [StateNumber, StateString] = getsrstate;
        set(handles.InfoText, 'String', StateString, 'ForegroundColor', 'b');
    catch
        setpv('SR_STATE', -6);
        [StateNumber, StateString] = getsrstate;
        set(handles.InfoText, 'String', StateString, 'ForegroundColor', 'r');
    end
    
    a = clock;
    datestr1 = date;
    fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
    fprintf('   *******************************************\n');
    fprintf('   **  Storage Ring Power Supplies Are Off  **\n');
    fprintf('   *******************************************\n\n');
else
    fprintf('   Storage ring magnet power supply turn off canceled.\n');
    return
end



% --- Executes on button press in TurnOn.
function TurnOn_Callback(hObject, eventdata, handles)
StartFlag = questdlg({'This function will turn on with zero setpoint [and reset if necessary]','all the SR magnets power supplies that are not presently on.',' ','Turn on the SR magnet power supplies?'},'Turn Off','Yes','No','No');
if strcmp(StartFlag,'Yes')
    fprintf('\n');
    fprintf('   **********************************************\n');
    fprintf('   **  Turning Storage Ring Power Supplies On  **\n');
    fprintf('   **********************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    drawnow;
    
    try
        setpv('SR_STATE', 7.1);
        [StateNumber, StateString] = getsrstate;
        set(handles.InfoText, 'String', StateString, 'ForegroundColor', 'b');
        
        % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
        write_alarms_srmags_nominal;
        
        turnonmps;
        
        setpv('SR_STATE', 7);
        [StateNumber, StateString] = getsrstate;
        set(handles.InfoText, 'String', StateString, 'ForegroundColor', 'b');
    catch
        setpv('SR_STATE', -7);
        [StateNumber, StateString] = getsrstate;
        set(handles.InfoText, 'String', StateString, 'ForegroundColor', 'r');
    end
    
    a = clock;
    datestr1 = date;
    fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
    fprintf('   ******************************************\n');
    fprintf('   **  Storage Ring Power Supplies Are On  **\n');
    fprintf('   ******************************************\n\n');
else
    fprintf('   Storage ring magnet power supply turn on canceled.\n');
    return
end


% --- Executes on button press in GoldenLattice.
function GoldenLattice_Callback(hObject, eventdata, handles)
StartFlag = questdlg( ...
    {'You are requesting to save the SR golden lattice.','This must be done with ID Gap open with SOFB & FOFB channels zeroed.','Be very, very careful about saving a new golden lattice.','This is typically only done by Tom, Christoph, or Greg.',' ','If you want to save the lattice to a new file','cancel and select the "Save SR Lattice to File" menu.', ' ', 'Save/Overwrite the SR Golden Lattice?'}, ...
    'Save/Overwrite the SR Golden Lattice','Save','Cancel','Cancel');

if strcmp(StartFlag,'Save')
    fprintf('\n');
    fprintf('   **********************************************\n');
    fprintf('   **  Saving the Storage Ring Golden Lattice  **\n');
    fprintf('   **********************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    drawnow;
    
    try
        getmachineconfig('Golden');
    catch
        fprintf('%s\n',lasterr);
        disp('   An error occurred while saving the golden lattice');
    end
    
    a = clock;
    datestr1 = date;
    fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
    fprintf('   *****************************************\n');
    fprintf('   **  Storage Ring Golden Lattice Saved  **\n');
    fprintf('   *****************************************\n\n');
end

% --- Executes on button press in InjectionLattice.
function InjectionLattice_Callback(hObject, eventdata, handles)
StartFlag = questdlg( ...
    {'You are requesting to save the SR injection lattice.','This must be done with ID Gap open with SOFB & FOFB channels zeroed.','Be very, very careful about saving a new injection lattice.','This is typically only done by Tom, Christoph, or Greg.',' ','If you want to save the lattice to a new file','cancel and select the "Save SR Lattice to File" menu.', ' ', 'Save/Overwrite the SR Injection Lattice?'}, ...
    'Save/Overwrite the SR Injection Lattice','Save','Cancel','Cancel');

if strcmp(StartFlag,'Save')
    fprintf('\n');
    fprintf('   *************************************************\n');
    fprintf('   **  Saving the Storage Ring Injection Lattice  **\n');
    fprintf('   *************************************************\n');
    a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    drawnow;
    
    try
        getmachineconfig('Injection');
    catch
        fprintf('%s\n',lasterr);
        disp('   An error occurred while saving the injection lattice');
    end
    
    a = clock;
    datestr1 = date;
    fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
    fprintf('   ********************************************\n');
    fprintf('   **  Storage Ring Injection Lattice Saved  **\n');
    fprintf('   ********************************************\n\n');
end


% --- Executes on button press in Cycle.
function Cycle_Callback(hObject, eventdata, handles)
SR_Mode = getfamilydata('OperationalMode');
Energy = getfamilydata('Energy');
InjectionEnergy = getfamilydata('InjectionEnergy');

GapFlag = 0;          % get(handles.SRCTRLRadioGaps,'Value')
BumpMagnetFlag = 0;   % get(handles.SRCTRLRadioBumps,'Value');

CheckInputs(handles);

fprintf('\n');
fprintf('   **************************\n');
fprintf('   **  Storage Ring Cycle  **\n');
fprintf('   **************************\n');
a = clock; fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

% Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
write_alarms_srmags_nominal;

[StartFlag, FullCycleFlag, BSCFlag, ChicSQFlag, FinalLattice] = srcontrol_cycle;


if strcmp(StartFlag,'No')
    fprintf('   **************************\n');
    fprintf('   **    Cycle  Canceled   **\n');
    fprintf('   **************************\n\n');
    % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
    write_alarms_srmags_single;
    return
end


% Start the cycle
setpv('SR_STATE', 1.1);
[StateNumber, StateString] = getsrstate;
set(handles.InfoText,'String',StateString,'ForegroundColor','b');

try
    if GapFlag
        % Make sure that the gaps are open with FF off
        if any(getsp('IDpos') ~= maxsp('IDpos'))
            % Set IDs at max velocity w/ velocity profile off
            disp('   Insertion device gaps are not open.');
            disp('   Opening all gaps at maximum speed.');
            setff([], 1, 0);
            disp('   Gap control disabled.');
            disp('   Feed forward enabled.');
            pause(1);
            setid([], maxsp('IDpos'), maxsp('IDvel'), 1, 0, 1);
            disp('   Gaps opened.');
            a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
        end
    end
    
    % Disable the feed forward
    setff([], 0, 0);
    disp('   Feed forward and gap control disabled.');
    pause(1);
    
    
    % Full or mini cycle
    %if strcmp(FullCycleFlag, 'Yes')
    srcycle(BSCFlag, ChicSQFlag, FullCycleFlag);
    
    % Final lattice load
    if strcmpi(FinalLattice, 'Injection')
        if abs(getenergy('Production')-getenergy) < 1e-6
            fprintf('   Loading the injection lattice   ...');
            [ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
            if strcmpi(BSCFlag,'No')
                i = findrowindex([1 1], ConfigSetpoint.BEND.Setpoint.DeviceList);
                ConfigSetpoint.BEND.Setpoint.Data       = ConfigSetpoint.BEND.Setpoint.Data(i);
                ConfigSetpoint.BEND.Setpoint.DeviceList = ConfigSetpoint.BEND.Setpoint.DeviceList(i,:);
                ConfigSetpoint.BEND.Setpoint.Status     = ConfigSetpoint.BEND.Setpoint.Status(i);
            end
            setmachineconfig(ConfigSetpoint, -1);
        else
            fprintf('   Injection lattice was not loaded since the storage ring energy is %.2f GeV.\n', getenergy);
        end
    elseif strcmpi(FinalLattice, 'Production')
        if abs(getenergy('Production')-getenergy) < 1e-6
            fprintf('   Loading the production lattice   ...');
            [ConfigSetpoint, ConfigMonitor] = getproductionlattice;
            if strcmpi(BSCFlag,'No')
                i = findrowindex([1 1], ConfigSetpoint.BEND.Setpoint.DeviceList);
                ConfigSetpoint.BEND.Setpoint.Data       = ConfigSetpoint.BEND.Setpoint.Data(i);
                ConfigSetpoint.BEND.Setpoint.DeviceList = ConfigSetpoint.BEND.Setpoint.DeviceList(i,:);
                ConfigSetpoint.BEND.Setpoint.Status     = ConfigSetpoint.BEND.Setpoint.Status(i);
            end
            setmachineconfig(ConfigSetpoint, -1);
        else
            fprintf('   Production lattice was not loaded since the storage ring energy is %.2f GeV.\n', getenergy);
        end
    end
    a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    
    setpv('SR_STATE', 1);
    
    % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
    write_alarms_srmags_single;
    
    a = clock;
    datestr1 = date;
    fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
    [StateNumber, StateString] = getsrstate;
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    fprintf('   **********************************************\n');
    fprintf('   **  SR Cycle complete, ready for injection  **\n');
    fprintf('   **********************************************\n\n');
    
    %     else
    %         % Mini Cycle
    %         % Usually it a 1.9 - 1.5 - 1.9 cycle
    %         EnergyPresent = getenergy;
    %
    %         if strcmp(BSCFlag, 'Yes')
    %             SuperBendFlag = 'SuperBend';
    %         else
    %             SuperBendFlag = 'NoSuperBend';
    %         end
    %
    %         if EnergyPresent < 1.5
    %             error('A mini-cycle can only be used if the present energy is above 1.5 GeV.');
    %         elseif EnergyPresent > 1.7
    %             % Mini cycle down and back up
    %             fprintf('   Ramping to lower hysteresis lattice.\n');
    %             srramp('Lower', SuperBendFlag);
    %
    %             fprintf('   Ramping to upper hysteresis lattice.\n');
    %             srramp('Upper', SuperBendFlag);
    %         else
    %             % Mini cycle up and back down
    %             fprintf('   Ramping to upper hysteresis lattice.\n');
    %             srramp('Upper', SuperBendFlag);
    %
    %             fprintf('   Ramping to lower hysteresis lattice.\n');
    %             srramp('Lower', SuperBendFlag);
    %         end
    %
    %         % Final lattice
    %         if strcmpi(FinalLattice, 'Injection')
    %             if abs(getenergy('Injection')-getenergy) < 1e-6
    %                 % Load the injection lattice
    %                 fprintf('   Loading the injection lattice\n');
    %                 srload('Injection');
    %                 a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    %                 setpv('SR_STATE',1);
    %             else
    %                 fprintf('   Injection lattice was not loaded since the storage ring energy is %.2f GeV.\n', getenergy);
    %                 setpv('SR_STATE',3);  % This is not quite correcct
    %             end
    %         elseif strcmpi(FinalLattice, 'Production')
    %             if abs(getenergy('Production')-getenergy) < 1e-6
    %                 % Load the production lattice
    %                 fprintf('   Loading the production lattice\n');
    %                 srload('Production');
    %                 a = clock; fprintf('   Completed %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    %                 setpv('SR_STATE',2);
    %             else
    %                 fprintf('   Production lattice was not loaded since the storage ring energy is %.2f GeV.\n', getenergy);
    %                 setpv('SR_STATE',3);  % This is not quite correcct
    %             end
    %         else
    %             setpv('SR_STATE',3);  % This is not quite correcct
    %             fprintf('   No lattice loaded!!!\n');
    %         end
    %
    %         a = clock;
    %         datestr1 = date;
    %         fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
    %         [StateNumber, StateString] = getsrstate;
    %         set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    %         fprintf('   ******************************\n');
    %         fprintf('   **  SR Mini-Cycle Complete  **\n');
    %         fprintf('   ******************************\n\n');
    %     end
    
catch
    fprintf(2, '   %s \n', lasterr);
    fprintf(2, '   Cycle failed due to error condition! \n\n');
    setpv('SR_STATE',-1);
    a = clock;
    datestr1 = date;
    [StateNumber, StateString] = getsrstate;
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    fprintf(2, '   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
    fprintf(2, '   **********************************\n');
    fprintf(2, '   **  Problem cycling SR lattice  **\n');
    fprintf(2, '   **********************************\n\n');
end




% --- Executes on button press in Injection.
function Injection_Callback(hObject, eventdata, handles)
SR_Mode = getfamilydata('OperationalMode');
Energy = getfamilydata('Energy');
InjectionEnergy = getfamilydata('InjectionEnergy');

GapFlag = 0;          % get(handles.SRCTRLRadioGaps,'Value')
BumpMagnetFlag = 0;   % get(handles.SRCTRLRadioBumps,'Value');

CheckInputs(handles);

fprintf('\n');
if abs(getenergy - InjectionEnergy) > 0.05
    fprintf('   ***************************************************\n');
    fprintf('   **  Setup For %.2f GeV Injection (with ramping)  **\n', InjectionEnergy);
    fprintf('   ***************************************************\n');
    set_alarmhandler_AHU_thresholds_inject;
    StartFlag = questdlg(sprintf('Start setup for injection, %.2f GeV?',InjectionEnergy),'Injection Setup','Ramp quickly','Ramp slowly','Cancel','Cancel');
else
    fprintf('   *************************************************\n');
    fprintf('   **  Setup For On Energy Injection at %.2f GeV  **\n', InjectionEnergy);
    fprintf('   *************************************************\n');
    StartFlag = questdlg(sprintf('Start setup for injection, %.2f GeV?',InjectionEnergy),'Injection Setup','Yes','Cancel','Cancel');
end
a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
if strcmp(StartFlag,'Cancel')
    fprintf('   ********************************\n');
    fprintf('   **  Injection Setup Canceled  **\n');
    fprintf('   ********************************\n\n');
    %set_alarmhandler_thresholds_new;
    return
elseif strcmp(StartFlag,'Ramp quickly')
    sounderror;
    BSCFastFlag = questdlg(sprintf('Are you sure you want to ramp the Superbends at 0.8A/s?!?\n\nThis is dangerous if they are below ~200A and the main Bend is at operating current - the ramp rate will not be automatically reduced if they are getting warm!'),'ALERT:     SUPERBEND QUENCH POSSIBLE!','Yes','Cancel','Cancel');
    if strcmp(BSCFastFlag,'Yes')
        fprintf('Setting Superbend ramp rates to 0.8A/s. The temperatures WILL NOT be monitored as they ramp up!!\n');
        setfamilydata(0.8, 'BSCRampRate');
    elseif strcmp('BSCFastFlag','Cancel')
        fprintf('Not changing magnets - Superbend ramp rates set to 0.4A/s.\n');
        setfamilydata(0.4, 'BSCRampRate');
        return
    end
elseif strcmp(StartFlag,'Ramp slowly')
    setfamilydata(0.4, 'BSCRampRate');
end
drawnow;

try
    if GapFlag
        setff([],1,0);
        disp('   Gap control disabled');
        disp('   Feed forward enabled');
        pause(1);
        
        % Set IDs at max velocity w/ velocity profile off
        if any(getsp('IDpos') ~= maxsp('IDpos'))
            disp('   Opening all gaps');
            setid([], maxsp('IDpos'), maxsp('IDvel'), 1, 0, 1);
        end
        
        disp('   Gaps are open');
        disp('   Feed forward and gap control disabled');
        a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
    else
        disp('   Feed forward and gap control disabled');
    end
    
    setff([], 0, 0);
    pause(1);
    
    % Ramp if necessary
    if abs(getenergy - InjectionEnergy) > 0.05
        % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
        write_alarms_srmags_nominal;
        set(handles.InfoText,'String','Ramping Down','ForegroundColor','b');
        drawnow;
        ErrorFlag = srramp('Injection');
        if ErrorFlag
            error('Superbends over temperature.');
        end
        pause(2);
    end
    
    % Load injection lattice
    srload('Injection');
    
    setpv('SR_STATE',2);

    write_alarms_srmags_single;
    
catch
    fprintf(2, '   %s \n',lasterr);
    fprintf(2, '   Injection lattice setup failed due to error condition! \n\n');
    setpv('SR_STATE', -2);
end


date;
a = clock;
datestr1=date;
fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    if Energy <= 1.5
        fprintf('   *******************************************************************************\n');
        fprintf('   **  Function complete:  the storage ring is setup for injection at %.2f GeV  **\n', Energy);
        fprintf('   *******************************************************************************\n');
    else
        fprintf('   **********************************************************************************************\n');
        fprintf('   **  Function complete:  the storage ring is setup for injection at %.2f GeV (upper branch)  **\n', InjectionEnergy);
        fprintf('   **********************************************************************************************\n\n');
    end
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    fprintf(2, '   ************************************\n');
    fprintf(2, '   **  Problem with injection setup  **\n');
    fprintf(2, '   ************************************\n\n');
end

%soundchord;

setfamilydata(0.8, 'BSCRampRate');


% --- Executes on button press in Production.
function Production_Callback(hObject, eventdata, handles)
SR_Mode = getfamilydata('OperationalMode');
Energy = getfamilydata('Energy');
InjectionEnergy = getfamilydata('InjectionEnergy');

GapFlag = 0;          % get(handles.SRCTRLRadioGaps,'Value')
BumpMagnetFlag = 0;   % get(handles.SRCTRLRadioBumps,'Value');

CheckInputs(handles);

fprintf('\n');
if abs(getenergy - InjectionEnergy) > 0.05
    fprintf('   ********************************************************\n');
    fprintf('   **  Setup For %.2f GeV User Operation (with ramping)  **\n', Energy);
    fprintf('   ********************************************************\n');
    StartFlag = questdlg(sprintf('Start setup for users, %.1f GeV?',Energy),'User Setup','Ramp quickly','Ramp slowly','Cancel','Cancel');
else
    fprintf('   *****************************************\n');
    fprintf('   **  Setup For %.2f GeV User Operation  **\n', Energy);
    fprintf('   *****************************************\n');
    StartFlag = questdlg(sprintf('Start setup for users, %.1f GeV?',Energy),'User Setup','Yes','Cancel','Cancel');
end
a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));

if strcmp(StartFlag,'Cancel')
    fprintf('   ***************************\n');
    fprintf('   **  User Setup Canceled  **\n');
    fprintf('   ***************************\n\n');
    return
elseif strcmp(StartFlag,'Ramp quickly')
    sounderror;
    BSCFastFlag = questdlg(sprintf('Are you sure you want to ramp the Superbends at 0.8A/s?!?\n\nThis is dangerous if they are below ~200A and the main Bend is at operating current - the ramp rate will not be automatically reduced if they are getting warm!'),'ALERT:     SUPERBEND QUENCH POSSIBLE!','Yes','Cancel','Cancel');
    if strcmp(BSCFastFlag,'Yes')
        fprintf('Setting Superbend ramp rates to 0.8A/s. The temperatures WILL NOT be monitored as they ramp up!!\n');
        setfamilydata(0.8, 'BSCRampRate');
    elseif strcmp('BSCFastFlag','Cancel')
        fprintf('Not changing magnets - Superbend ramp rates set to 0.4A/s.\n');
        setfamilydata(0.4, 'BSCRampRate');
        return
    end
elseif strcmp(StartFlag,'Ramp slowly')
    setfamilydata(0.4, 'BSCRampRate');
end
drawnow;

try
    if GapFlag
        % Make sure that the gaps are open
        if any(getsp('IDpos') ~= maxsp('IDpos'))
            % Set IDs at max velocity w/ velocity profile off
            disp('   Insertion device gaps are not open');
            disp('   Opening all gaps at maximum speed');
            setff([], 1, 0);
            disp('   Gap control disabled');
            disp('   Feed forward enabled');
            pause(1);
            setid([], maxsp('IDpos'), maxsp('IDvel'), 1, 0, 1);
            disp('   Gaps opened');
            disp('   Feed forward and gap control disabled');
            a = clock; fprintf('   %s %d:%d:%.0f\n',date, a(4), a(5), a(6));
        else
            disp('   Feed forward and gap control disabled');
        end
    else
        disp('   Feed forward and gap control disabled');
    end
    
    setff([], 0, 0);
    pause(1);
    
    % Ramp if necessary
    if abs(getenergy - InjectionEnergy) > 0.05
        % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
        write_alarms_srmags_nominal;
        set(handles.InfoText,'String','Ramping Up','ForegroundColor','b');
        drawnow;
        ErrorFlag = srramp('Production');
        if ErrorFlag
            error('Superbends over temperature.');
        end
        pause(2);
    end
    
    % Load production lattice
    srload('Production');
    
    
    if GapFlag
        setff([], 1, 0);
        disp('   Gap control disabled');
        disp('   Feed forward enable');
        pause(1);
        disp('   Insertion device velocity profile boolean control off');
        disp('   Closing all gaps at maximum speed');
        
        % Set IDs at max velocity w/ velocity profile off
        [Position, Velocity, RunFlag, UserGap] = getid;
        setid([], UserGap, maxsp('IDvel'), 1, 0, 1);
        
        % TurnOff velocity profile on
        disp('   Insertion device velocity profile boolean control is on');
        setid([], [], maxsp('IDvel'), 1, 1, 0);
        
        disp('   Gaps are closed');
        setff([4;7;8;9;10;12], 1, 1);
        setff(5, 1, 0);
        disp('   Gap control enabled (except sector 5 (W16))');
    end
    
        write_alarms_srmags_single;
        
    %set_alarmhandler_thresholds_new;
    setpv('SR_STATE',3);
    
catch
    fprintf(2, '   %s \n', lasterr);
    fprintf(2, '   User lattice setup failed due to error condition! \n\n');
    setpv('SR_STATE', -3);
end

% Give JH scrapers a chance to move
% pause(15);

a = clock;
datestr1 = date;
fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    disp(['   **************************************************************************']);
    disp(['   **  Function complete:  the storage ring is setup for users at ',sprintf('%.1f',Energy),' GeV  **']);
    disp(['   **************************************************************************']);
    fprintf('\n');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    disp(['   *************************************']);
    disp(['   **  Problem with production setup  **']);
    disp(['   *************************************']);
    fprintf('\n');
end

setfamilydata(0.8, 'BSCRampRate');

% For BL6.0.x, set lower setpoint limit for IVID to 12.5mm until beamlines are surveyed below that value
%try
%    setpv('SR06U___GDS1PS_AC00.DRVL',12.5);
%    disp('  Setting SR06U___GDS1PS_AC00.DRVL to 12.5mm (lower limit for IVID');
%catch
%    fprintf(2, '   %s \n',lasterr);
%    disp('  Trouble setting lower limit for IVID to 12.5mm!');
%end


% --- Executes on button press in OperationalMode.
function OperationalMode_Callback(hObject, eventdata, handles)
fprintf('\n');
fprintf('   **********************************************\n');
fprintf('   **  Changing Storage Ring Operational Mode  **\n');
fprintf('   **********************************************\n');
setoperationalmode;
setpvonline('SR_mode',getfamilydata('OperationalMode'));
CheckInputs(handles);
fprintf('   ****************************\n');
fprintf('   **  Mode Change Complete  **\n');
fprintf('   ****************************\n');
fprintf('\n');


% --- Executes on button press in CheckForProblems.
function CheckForProblems_Callback(hObject, eventdata, handles)

SR_Mode = getfamilydata('OperationalMode');

CheckInputs(handles);

NumErrors = 0;
fprintf('\n');
disp('   ***********************************');
disp('   **  Checking Storage Ring State  **');
disp('   ***********************************');
a = clock;
fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

%FileName = getpv('SR_LATTICE_FILE','String');   % Last srload file name (in OLD MIDDLE LAYER nomenclature!!)

GeVnow = bend2gev;
if GeVnow == getfamilydata('Energy')
    [ConfigSetpoint, ConfigMonitor, FileName] = getproductionlattice;
elseif GeVnow == getfamilydata('InjectionEnergy')
    [ConfigSetpoint, ConfigMonitor, FileName] = getinjectionlattice;
else
    FileName = '';
end

[StateNumber, StateString] = getsrstate;
fprintf('   Storage ring operational mode: %s\n', SR_Mode);
if StateNumber < 0
    fprintf('   Storage ring state error: %s\n', StateString);
    NumErrors = NumErrors + 1;
else
    fprintf('   Storage ring state: %s\n', StateString);
end
if StateNumber==0
    % Storage ring state unknown
    NumErrors = NumErrors + 1;
elseif abs(StateNumber)==1 || abs(StateNumber)==2
    FileNameGoal = [getfamilydata('Directory','OpsData') getfamilydata('OpsData','InjectionFile') '.mat'];
    if ~strcmp(FileName, FileNameGoal)
        fprintf('   Lattice file %s should be loaded but it appears that %s is loaded.\n', getfamilydata('OpsData','InjectionFile'), FileName);
        NumErrors = NumErrors + 1;
    end
else
    FileNameGoal = [getfamilydata('Directory','OpsData') getfamilydata('OpsData','LatticeFile') '.mat'];
    if ~strcmp(FileName, FileNameGoal)
        fprintf('   Lattice file %s should be loaded but it appears that %s is loaded.\n', getfamilydata('OpsData','LatticeFile'), FileName);
        NumErrors = NumErrors + 1;
    end
end


% Check all SR magnets
if isempty(FileName)
    fprintf('   Goal setpoints will not be checked since the last lattice load is unknown.\n');
    NumErrors1 = checksrmags('');
else
    %NumErrors1 = checksrmags([getfamilydata('Directory','OpsData') FileName]);
    NumErrors1 = checksrmags(FileName);
end
if NumErrors1 == 0
    fprintf('   SR magnets power supplies are OK.\n');
end
NumErrors = NumErrors + NumErrors1;


% Check RF frequency
if isempty(FileName)
    fprintf('   RF frequency will not be checked since the last lattice load is unknown.\n');
else
    %load([getfamilydata('Directory','OpsData'), FileName]);
    load(FileName);
    [tmp, RFHPCounterPresent] = getrf;
    if abs(RFHPCounterPresent-ConfigSetpoint.RF.Setpoint.Data) > .002
        NumErrors = NumErrors + 1;
        fprintf('   RF frequency should be %f, presently it is %f MHz (as measured by the HP counter).\n', ConfigSetpoint.RF.Setpoint.Data, RFHPCounterPresent);
    else
        fprintf('   RF frequency is OK (HP counter is %f MHz, at the time of the lattice save it was %f MHz).\n', RFHPCounterPresent, ConfigSetpoint.RF.Setpoint.Data);
    end
end


% Check for orbit problems
if (StateNumber >= 3) && (getdcct > 2)   % Production lattice is loaded with beam in the machine
    Xtol = 0.070;
    Ytol = 0.060;
    NumErrors1 = checksrorbit([],Xtol,Ytol);
    if NumErrors1
        fprintf('   SR orbit in the ID straight sections or at Bergoz BPMs deviates more than allowed from the golden orbit.\n');
    else
        fprintf('   SR orbit in the ID straight sections and at Bergoz BPMs is OK.\n');
        fprintf('   The orbit is within %.3f mm horizontally and %.3f mm vertically', Xtol, Ytol);
    end
    NumErrors = NumErrors + NumErrors1;
else
    fprintf('   Storage ring orbit was not checked.\n');
end


a = clock;
datestr1=date;
fprintf('   %s %d:%d:%.0f\n', datestr1, a(4), a(5), a(6));
if NumErrors
    disp('   *********************************');
    disp('   **  Storage Ring Has Problems  **');
    disp('   *********************************');
else
    disp('   **********************************');
    disp('   **  Storage Ring Lattice is OK  **');
    disp('   **********************************');
end
fprintf('   \n');

[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
end


% --- Executes on button press in GoldenPage.
function GoldenPage_Callback(hObject, eventdata, handles)
goldenpage;


% --- Executes on button press in OrbitCorrection.
function OrbitCorrection_Callback(hObject, eventdata, handles)

Energy  = getfamilydata('Energy');

fprintf('\n');
fprintf('   *********************************\n');
fprintf('   **  Starting Orbit Correction  **\n');
fprintf('   *********************************\n');
a = clock;
fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));

StartFlag = questdlg(sprintf('Start orbit correction, %.1f GeV?', Energy), 'Orbit Correction', 'Yes', 'No', 'No');
drawnow;
if strcmp(StartFlag,'No')
    fprintf('   ********************************\n');
    fprintf('   **  Orbit Correction Aborted  **\n');
    fprintf('   ********************************\n');
    fprintf('\n');
    return
end


% Set the BPM attenuators
% try
%     fprintf('   BPM Init (only attenuators) (srcontrol)\n');
%     bpminit('Attn Only');
%     fprintf('   BPM Init (only attenuators) Complete (srcontrol)\n');
% catch
% end

% try
%     %fprintf('   Cell Controller Init (srcontrol)\n');
%     cellcontrollerinit;
%     fprintf('   Cell Controller Init Complete (srcontrol)\n');
% catch
% end


% Get vectors
FB            = get(handles.OrbitCorrection_Edit, 'Userdata');
LocalBumplist = get(handles.OrbitCorrection,      'Userdata');

% Write file with FB.OCSx and FB.OCSy for orbit correction debugging
try
    FB_OCS_Filename = sprintf('N:\\machine\\ALS\\StorageRing\\debug\\OC_debug_tempfile_%s', datestr(now,30));
    save(FB_OCS_Filename, 'FB');
catch
    disp('Saving orbit correction debug file did not work');
end


CheckInputs(handles);

% Start question dialog box was here

if getdcct < 2     % Don't correct the orbit if the current is too small
    fprintf(2, '   Orbit not corrected due to small current.\n');
    return
end

% if abs(Energy-bend2gev(getpv('BEND','Setpoint',[1 1])))>  0.05     % Don't use this routine for the injection lattice
%     fprintf('   This routine should only be used for the production energy: Correction aborted\n');
%     return
% end

SR_STATE_OLD = getpvonline('SR_STATE','Double');
setpv('SR_STATE', 4);
[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
end


try
    % savemenu current BPM timeconstant - will reset to this after correction
    BPMtimeconstantOC = getbpmtimeconstant;
    fprintf('   Current Bergoz BPM time constant is %.1fs\n', BPMtimeconstantOC);
    
    % 2 Hz update rate on IDBPMs
    disp('   Bergoz BPM time constant set to 0.5s.')
    %setbpmtimeconstant(0.5)
    pause(2);
    
    % TurnOff off feed forward
    fprintf('   Turning feed forward off.\n');
    [FFEnableBM, FFEnableBC] = getff;
    setff([], 0);
    pause(1);  % Increased the pause from .2 to 1 (GJP)
    
    write_alarms_srmags_single;

    %% The check below doesn't make sense in Top-off mode since bumps are always on
    %     % Check whether bumps and kickers are on, pulsing, and at high enough currents to disturb the beam.
    %     % If so, warn to turnoff off and re-correct orbit.
    %     try
    %         if (getpv('SR01S___BUMP1__BC21')==1 && getpv('SR01S___BUMP1P_BC22')==1 && getpv('SR01S___BUMP1__AM00')>2500) ||...
    %                 (getpv('SR01S___SEK____BC21')==1 && getpv('SR01S___SEK_P__BC23')==1 && getpv('SR01S___SEK____AM02')>600) ||...
    %                 (getpv('SR01S___SEN____BC20')==1 && getpv('SR01S___SEN_P__BC22')==1 && getpv('SR01S___SEN____AM00')>800);
    %             soundtada;
    %             fprintf('   \n');
    %             fprintf('   *****************************************************************\n');
    %             fprintf('   ** One or more of the pulsed SR injection magnets is still on! **\n');
    %             fprintf('   **      Please turn them off then re-correct the orbit...      **\n');
    %             fprintf('   *****************************************************************\n');
    %             fprintf('   \n');
    %         end
    %     catch
    %         disp('**Problem checking the state of the bumps and kickers - please check that they are not pulsing.');
    %     end
catch
    fprintf(2, '   %s \n', lasterr);
    fprintf(2, '   Orbit correction setup failed due to error condition! \n\n');
    setpv('SR_STATE', -4);
    [StateNumber, StateString] = getsrstate;
    if StateNumber >= 0
        set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    else
        set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    end
    
    % Reset BPM timeconstant to whatever it was before correction
    %setbpmtimeconstant(BPMtimeconstantOC);
    fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);
    return
end

% Index used by steppv for setting correctors in loop
iNotHCMChicane = find(FB.OCSx.CM.DeviceList(:,2) < 10);
iHCMChicane    = find(FB.OCSx.CM.DeviceList(:,2) == 10);
iNotVCMChicane = find(FB.OCSy.CM.DeviceList(:,2) < 10);
iVCMChicane    = find(FB.OCSy.CM.DeviceList(:,2) == 10);


% Pseudo single bunch - scale the orbit by the voltage in the kicker
if strcmpi(get(handles.PseudoSingleBunch,'Checked'),'On')
    % It would be ok to remove the above if
    [xKick, yKick] = getpseudosinglebunchkick(FB.OCSy.BPM.DeviceList);
    % There is about 10 um of coupling that we might want to compensate for as well?
    FB.OCSy.GoalOrbit = FB.OCSy.GoalOrbit + yKick;
end


fprintf('   Starting horizontal and vertical global orbit correction (SVD method).\n');
for iloop = 1:3
    try
        % Use the following to get corrector settings in OCS without setting them, so the values can be checked
        FB.OCSx = setorbit(FB.OCSx, 'Nodisplay', 'Nosetsp');
        FB.OCSy = setorbit(FB.OCSy, 'Nodisplay', 'Nosetsp');
        
        if any(abs(FB.OCSx.CM.Delta(iNotHCMChicane)) > 5)
            disp('   Orbit Correction is changing some horizontal corrector(s) > 5A!!');
        end
        if any(abs(FB.OCSy.CM.Delta(iNotVCMChicane)) > 5)
            disp('   Orbit Correction is changing some vertical corrector(s) > 5A!!');
        end
        if any(abs(FB.OCSx.CM.Delta(iHCMChicane)) > 10)
            disp('   Orbit Correction is changing some horizontal chicane corrector(s) > 10A!!');
        end
        if any(abs(FB.OCSy.CM.Delta(iVCMChicane)) > 10)
            disp('   Orbit Correction is changing some vertical chicane corrector(s) > 10A!!');
        end
        
        % Correct RF
        % Added factor 4 to slow down for laser-lock at BL11.0.1 - 3-14-08, T.Scarvie
        rf0 = getrf;
        nRFsteps = 4*ceil(abs(FB.OCSx.DeltaRF/10e-6));
        if nRFsteps > 100
            nRFsteps = 100;
        end
        for loop = 1:nRFsteps
            steprf_hp(FB.OCSx.DeltaRF/nRFsteps,0);
        end
        fprintf('   %d. nRFsteps = %d, RF change = %.1f Hz\n',iloop, nRFsteps, FB.OCSx.DeltaRF*1e6);
        %               fprintf('   %d. RF change = %.1f Hz, nRFsteps = %d, DelRF = %.1f Hz\n',iloop, (getrf-rf0)*1e6, nRFsteps, FB.OCSx.DeltaRF*1e6);
        
        % Correct horizontal and vertical corrections
        FB.OCSx.CM.Data = FB.OCSx.CM.Data + FB.OCSx.CM.Delta;
        FB.OCSy.CM.Data = FB.OCSy.CM.Data + FB.OCSy.CM.Delta;
        
        % Start vertical correctors moving
        setpv(FB.OCSy.CM,0);
        % Correct horizontal
        setpv(FB.OCSx.CM,-1);
        % Correct vertical
        setpv(FB.OCSy.CM,-2);
        
        % Check for current in machine - stop orbit correction if DCCT < 2mA
        if (getdcct < 2)
            error('**There is less than 2mA in the machine! Stopping orbit correction.');
        end
        
        % Check state of gaps - stop orbit correction if any are moving
        GAPrunflag = getpv('ID','RunFlag');
        if any(GAPrunflag-round(GAPrunflag))
            error('**One or more of the gaps are moving! Stopping orbit correction.');
        end
        
        x = FB.OCSx.GoalOrbit - getx(FB.OCSx.BPM.DeviceList);
        y = FB.OCSy.GoalOrbit - gety(FB.OCSy.BPM.DeviceList);
        fprintf('   %d. Horizontal RMS = %.3f mm\n', iloop, norm(x)/sqrt(length(x)));
        fprintf('   %d.   Vertical RMS = %.3f mm\n', iloop, norm(y)/sqrt(length(y)));
        
    catch
        fprintf('   %s \n',lasterr);
        fprintf('   Orbit correction failed due to error condition!\n  Fix the problem, reload the lattice (srload), and try again.  \n\n');
        setpv('SR_STATE',-4);
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(handles.InfoText,'String',StateString,'ForegroundColor','b');
        else
            set(handles.InfoText,'String',StateString,'ForegroundColor','r');
        end
        
        % Reset BPM timeconstant to whatever it was before correction
        %setbpmtimeconstant(BPMtimeconstantOC);
        fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);
        return
    end
end

% Set user bumps w/o sextupole correctors
try
    %turnoff up corrector speed here to quicken setting bumps
    HCMramprate = getpv('HCM', 'RampRate');
    VCMramprate = getpv('VCM', 'RampRate');
    setpv('HCM', 'RampRate', 10, [], 0);
    setpv('VCM', 'RampRate', 10, [], 0);
    
    if ~isempty(LocalBumplist)
        fprintf('   Setting local bumps in the straight sections.\n');
        for loop = 1:size(LocalBumplist,1)
            
            % Check for current in machine - stop orbit correction if DCCT < 2mA
            if (getdcct < 2)
                error('** There is less than 2mA in the machine! Stopping local bumps.');
            end
            
            % Check state of gaps - stop setting bumps if any are moving
            GAPrunflag = getpv('ID','RunFlag');
            if any(GAPrunflag-round(GAPrunflag))
                error('** One or more of the gaps are moving! Stopping local bumps.');
            end
            
            HCMoldsp = getsp('HCM', FB.OCSx.CM.DeviceList);
            VCMoldsp = getsp('VCM', FB.OCSy.CM.DeviceList);
            
            if any(LocalBumplist(loop,1) == [4 6 11])
                if LocalBumplist(loop,2) == 0
                    % Upstream bump
                    [i,iRemove] = findrowindex([LocalBumplist(loop,1)-1 10;LocalBumplist(loop,1)-1 11;LocalBumplist(loop,1)-1 12;LocalBumplist(loop,1) 1],FB.OCSx.BPM.DeviceList);
                    if isempty(iRemove)
                        setbumps(LocalBumplist(loop,:), 1);
                    else
                        fprintf('\n   BPMs missing from Sector(%02d,%02d) - skipping local bump for that sector.\n\n', LocalBumplist(loop,:));
                    end
                elseif LocalBumplist(loop,2) == 1
                    % Upstream bump
                    [i,iRemove] = findrowindex([LocalBumplist(loop,1)-1 10;LocalBumplist(loop,1)-1 11;],FB.OCSx.BPM.DeviceList);
                    if isempty(iRemove)
                        setbumps(LocalBumplist(loop,:), 1);
                    else
                        fprintf('\n   BPMs missing from Sector(%02d,%02d) - skipping local bump for that sector.\n\n', LocalBumplist(loop,:));
                    end
                else
                    % Downstream bump
                    [i, iRemove] = findrowindex([LocalBumplist(loop,1)-1 12;LocalBumplist(loop,1) 1],FB.OCSx.BPM.DeviceList);
                    if isempty(iRemove)
                        setbumps(LocalBumplist(loop,:), 1);
                    else
                        fprintf('\n   BPMs missing from Sector(%02d,%02d) - skipping local bump for that sector.\n\n', LocalBumplist(loop,:));
                    end
                end
            else
                [i,iRemove] = findrowindex([LocalBumplist(loop,1)-1 10;LocalBumplist(loop,1) 1],FB.OCSx.BPM.DeviceList);
                if isempty(iRemove)
                    setbumps(LocalBumplist(loop,:), 1);
                else
                    fprintf('\n   BPMs missing from Sector %02d - skipping local bump for that sector.\n\n', LocalBumplist(loop,1));
                end
            end
            
            HCMnewsp = getsp('HCM', FB.OCSx.CM.DeviceList);
            VCMnewsp = getsp('VCM', FB.OCSy.CM.DeviceList);
            % Remove center chicane trim from corrector check
            if (max(abs(HCMoldsp(iNotHCMChicane)-HCMnewsp(iNotHCMChicane))) > 5) || (max(abs(VCMoldsp(iNotVCMChicane)-VCMnewsp(iNotVCMChicane))) > 5)
                error('**Setbumps caused some corrector magnet currents to change by more than 5(Horiz)/10(Vert) A!');
            end
            % Now check center chicane trims
            if (max(abs(HCMoldsp(iNotHCMChicane)-HCMnewsp(iNotHCMChicane))) > 10) || (max(abs(VCMoldsp(iNotVCMChicane)-VCMnewsp(iNotVCMChicane))) > 15)
                error('**Setbumps caused some chicane trim magnet currents to change by more than 10(Horiz)/15(Vert) A!');
            end
        end
    end
    
    % Restore corrector ramp rates
    setpv('HCM', 'RampRate', HCMramprate, [], 0);
    setpv('VCM', 'RampRate', VCMramprate, [], 0);
    
catch
    fprintf('   %s \n',lasterr);
    fprintf('   Setbumps failed due to error condition!  Fix the problem, reload the lattice (srload), and try again.\n\n');
    setpv('SR_STATE',-4);
    [StateNumber, StateString] = getsrstate;
    if StateNumber >= 0
        set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    else
        set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    end
    
    % Reset BPM timeconstant to whatever it was before correction
    %setbpmtimeconstant(BPMtimeconstantOC);
    fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);
    return
end

% Repeat orbit correction with setting for SOFB (to avoid corrector magnets reaching large amplitudes when feedback starts)
fprintf('   Starting horizontal and vertical global orbit correction using SOFB configuration (SVD method).\n');
% Get vectors
FB = get(handles.SOFB_Edit,'Userdata');
% Index used by steppv for setting correctors in loop
iNotHCMChicane = find(FB.OCSx.CM.DeviceList(:,2) < 10);
iHCMChicane    = find(FB.OCSx.CM.DeviceList(:,2) == 10);
iNotVCMChicane = find(FB.OCSy.CM.DeviceList(:,2) < 10);
iVCMChicane    = find(FB.OCSy.CM.DeviceList(:,2) == 10);


for iloop = 1:3
    try
        % Use the following to get corrector settings in OCS without setting them, so the values can be checked
        FB.OCSx = setorbit(FB.OCSx, 'Nodisplay', 'Nosetsp');
        FB.OCSy = setorbit(FB.OCSy, 'Nodisplay', 'Nosetsp');
        
        if any(abs(FB.OCSx.CM.Delta(iNotHCMChicane)) > 5)
            disp('   Orbit Correction is changing some horizontal corrector(s) > 5A!!');
        end
        if any(abs(FB.OCSy.CM.Delta(iNotVCMChicane)) > 5)
            disp('   Orbit Correction is changing some vertical corrector(s) > 5A!!');
        end
        if any(abs(FB.OCSx.CM.Delta(iHCMChicane)) > 10)
            disp('   Orbit Correction is changing some horizontal chicane corrector(s) > 10A!!');
        end
        if any(abs(FB.OCSy.CM.Delta(iVCMChicane)) > 10)
            disp('   Orbit Correction is changing some vertical chicane corrector(s) > 10A!!');
        end
        
        % Correct RF
        % Added factor 4 to slow down for laser-lock at BL11.0.1 - 3-14-08, T.Scarvie
        rf0 = getrf;
        nRFsteps = 4*ceil(abs(FB.OCSx.DeltaRF/10e-6));
        if nRFsteps > 100
            nRFsteps = 100;
        end
        for loop = 1:nRFsteps
            steprf_hp(FB.OCSx.DeltaRF/nRFsteps,0);
        end
        fprintf('   %d. nRFsteps = %d, RF change = %.1f Hz\n',iloop, nRFsteps, FB.OCSx.DeltaRF*1e6);
        %               fprintf('   %d. RF change = %.1f Hz, nRFsteps = %d, DelRF = %.1f Hz\n',iloop, (getrf-rf0)*1e6, nRFsteps, FB.OCSx.DeltaRF*1e6);
        
        % Correct horizontal and vertical corrections
        FB.OCSx.CM.Data = FB.OCSx.CM.Data + FB.OCSx.CM.Delta;
        FB.OCSy.CM.Data = FB.OCSy.CM.Data + FB.OCSy.CM.Delta;
        
        % Start vertical correctors moving
        setpv(FB.OCSy.CM,0);
        % Correct horizontal
        setpv(FB.OCSx.CM,-1);
        % Correct vertical
        setpv(FB.OCSy.CM,-2);
        
        % Check for current in machine - stop orbit correction if DCCT < 2mA
        if (getdcct < 2)
            error('**There is less than 2mA in the machine! Stopping orbit correction.');
        end
        
        % Check state of gaps - stop orbit correction if any are moving
        GAPrunflag = getpv('ID','RunFlag');
        if any(GAPrunflag-round(GAPrunflag))
            error('**One or more of the gaps are moving! Stopping orbit correction.');
        end
        
        
        
        x = FB.OCSx.GoalOrbit - getx(FB.OCSx.BPM.DeviceList);
        y = FB.OCSy.GoalOrbit - gety(FB.OCSy.BPM.DeviceList);
        fprintf('   %d. Horizontal RMS = %.3f mm\n', iloop, norm(x)/sqrt(length(x)));
        fprintf('   %d.   Vertical RMS = %.3f mm\n', iloop, norm(y)/sqrt(length(y)));
        
    catch
        fprintf('   %s \n',lasterr);
        fprintf('   Orbit correction failed due to error condition!\n  Fix the problem, reload the lattice (srload), and try again.  \n\n');
        setpv('SR_STATE',-4);
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(handles.InfoText,'String',StateString,'ForegroundColor','b');
        else
            set(handles.InfoText,'String',StateString,'ForegroundColor','r');
        end
        
        % Reset BPM timeconstant to whatever it was before correction
        %setbpmtimeconstant(BPMtimeconstantOC);
        fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);
        return
    end
end

% Reset BPM timeconstant to whatever it was before correction
%setbpmtimeconstant(BPMtimeconstantOC);
fprintf('   Bergoz BPM time constant set back to %.1fs\n', BPMtimeconstantOC);

% TurnOff feed forward back to it's original state
if any(FFEnableBC)
    fprintf('   Turning feed forward back on.\n');
    setff([], FFEnableBC);
end

a = clock;
fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    setpv('SR_STATE',4.1);
    [StateNumber, StateString] = getsrstate;
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    fprintf('   *********************************\n');
    fprintf('   **  Orbit Correction Complete  **\n');
    fprintf('   *********************************\n\n');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    fprintf('   *************************************\n');
    fprintf('   **  Problem With Orbit Correction  **\n');
    fprintf('   *************************************\n\n');
end



% --- Executes on button press in FeedbackStop.
function FeedbackStop_Callback(hObject, eventdata, handles)
setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);



% --- Executes on button press in FeedbackStart.
function FeedbackStart_Callback(hObject, eventdata, handles)

PseudoSingleBunch = getfamilydata('PseudoSingleBunch');
if ~isempty(PseudoSingleBunch) && strcmpi(PseudoSingleBunch,'On')
    % Check the kicker
    KickerVoltageControl = getpvonline('SR02S___CK_AMP_AC00');
    
    if KickerVoltageControl ~= 1000
        KickerQuestion = questdlg(strvcat('The kicker voltage is not 1000 volts!',' ','Please set manually.'),'Pseudo Single Bunch','Continue','Stop','Stop');
        drawnow;
        if strcmp(KickerQuestion,'Stop')
            a = clock;
            fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
            fprintf('   ***************************\n');
            fprintf('   **  Orbit Feedback Exit  **\n');
            fprintf('   ***************************\n\n');
            pause(0);
            return
        end
    end
end


% Set the BPM attenuators
% try
%     fprintf('   BPM Init (only attenuators) (srcontrol)\n');
%     bpminit('Attn Only');
%     fprintf('   BPM Init (only attenuators) Complete (srcontrol)\n');
% catch
% end

%try
%    %fprintf('   Cell Controller Init (srcontrol)\n');
%    cellcontrollerinit;
%    fprintf('   Cell Controller Init Complete (srcontrol)\n');
%catch
%end


setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 1);

SR_Mode = getfamilydata('OperationalMode');
Energy  = getfamilydata('Energy');
SR_GeV  = getenergy;

CheckInputs(handles);

FBloopIter = 1;
if get(handles.CheckboxFOFB,'Value') == 1
    StartFOFBFlag = 1;
else
    StartFOFBFlag = 0;
end


% Feedback loop setup
PlotInfoFlag   = 0;          % Plot micado stuff
LoopDelay      = 1.0;        % Period of feedback loop [seconds], make sure the BPM averaging is correct
VCM_LSB        = .00366211;
VCMCHICANE_LSB = .002441;    % 80 max?,  Note: not fully implemented

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    Xgain  = 0.2;
    Ygain  = 0.1;
else
    Xgain  = 0.7;
    Ygain  = 0.8;
    % Problem with BPM noise on 2012-02-22
    % Xgain  = 0.4;
    % Ygain  = 0.2;
end

% Load lattice set for tune feed forward
ConfigSetpoint = getproductionlattice;
QFsp = ConfigSetpoint.QF.Setpoint.Data;
QDsp = ConfigSetpoint.QD.Setpoint.Data;
TuneW16Min = gap2tune([5 1], 13.23, 1.8909);

% Tune response matrix
SR_TUNE_MATRIX = gettuneresp({'QF','QD'}, {[],[]}, getenergy('Production'));
%SR_TUNE_MATRIX = [0.1838   -0.0246
%                 -0.1237    0.1443];

SQSFsp = amp2k('SQSF','Setpoint',ConfigSetpoint.SQSF.Setpoint.Data);
SQSDsp = amp2k('SQSD','Setpoint',ConfigSetpoint.SQSD.Setpoint.Data);

% tune FF for IVID, which does have a significant horizontal as well as
% vertical one
if ispc
    load '\\als-filer\physdata\matlab\StorageRingData\PseudoSingleBunch\ID\ivid_tuneshift_measurement_20150526_2.mat'
elseif ismac
    load '/Volumes/physdata/matlab/StorageRingData/PseudoSingleBunch/ID/ivid_tuneshift_measurement_20150526_2.mat'
else
    load '/home/als/physdata/matlab/StorageRingData/PseudoSingleBunch/ID/ivid_tuneshift_measurement_20150526_2.mat'
end

dnux61 = 0.85*(nux-nux(1));
dnuy61 = 1.2*(nuy-nuy(1));
gap61 = gaps;

% tune FF for EPUs (data exist for 4.1,6.2,7.2,11.1 and 11.2 parallel and antiparallel
% as well as 4.2 parallel (MERLIN is not supposed to be used in
% antiparallel mode)
if ispc
    % load 'm:\matlab\srdata\epu\tuneshift_2d_tables\epu_tunetables_2d_20070723.mat'
    % load 'm:\matlab\srdata\epu\tuneshift_2d_tables\epu_tunetables_2d_20120904.mat'
    % load '\\als-filer\physdata\matlab\srdata\epu\tuneshift_2d_tables\epu_tunetables_2d_20141107.mat'
    load '\\als-filer\physdata\matlab\srdata\epu\tuneshift_2d_tables\epu_tunetables_2d_20170501.mat'
elseif ismac
    % load '/Volumes/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20120904.mat'
    % load '/Volumes/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20141107.mat'
    load '/Volumes/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20170501.mat'
else
    % load '/home/als/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20070723.mat'
    % load '/home/als/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20120904.mat'
    % load '/home/als/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20141107.mat'
    load '/home/als/physdata/matlab/srdata/epu/tuneshift_2d_tables/epu_tunetables_2d_20170501.mat'
end

% Pre initialize variables for tune feedback
lastnux = 0; newnux = 0;
lastnuy = 0; newnuy = 0;
tuneFBdnux = 0;
tuneFBdnuy = 0;
changedtuneflag = 0;

% ID tune compensation does not work in the injection lattice, so ...
if abs(Energy - bend2gev)>  0.05     % Don't use this routine for the injection lattice
    fprintf('   This routine should only be used for the production energy: Orbit feedback aborted\n');
    return
end


try
    fprintf('\n');
    fprintf('   *******************************\n');
    fprintf('   **  Starting Orbit Feedback  **\n');
    fprintf('   *******************************\n');
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   Note: the Matlab command window will be used to display status information.\n');
    fprintf('         It cannot be used to enter commands during slow orbit feedback.\n');
    
    % SaveMenu current BPM timeconstant - will reset to this when feedback stops
    BPMtimeconstantOFB = getbpmtimeconstant;
    fprintf('   Current Bergoz BPM time constant is %.1fs\n', BPMtimeconstantOFB);
    
    % >= 2 Hz update rate on IDBPMs
    disp('   Bergoz BPM time constant set to 0.2s.')
    %setbpmtimeconstant(0.2)
    pause(1.1);
    
    write_alarms_srmags_single;
    
    % For FOFB alarm handler
    setpv('Physics1',0);
    
    
    %% The check below doesn't make sense in Top-off mode since bumps are always on
    %     % Check whether bumps and kickers are on and warn to turnoff off before starting feedback if necessary
    %     try
    %         if (getsp('SR01S___BUMP1__BC21')==1 && getsp('SR01S___BUMP1P_BC22')==1) || (getsp('SR01S___SEK____BC21')==1 && getsp('SR01S___SEK_P__BC23')==1) || (getsp('SR01S___SEN____BC20')==1 && getsp('SR01S___SEN_P__BC22')==1)
    %             soundtada;
    %             fprintf('   \n');
    %             fprintf('   *********************************************************************************\n');
    %             fprintf('   ** One or more of the pulsed SR injection magnets is still on!  Turn them off! **\n');
    %             fprintf('   *********************************************************************************\n');
    %             fprintf('   \n');
    %         end
    %     catch
    %         fprintf('   %s \n',lasterr);
    %         disp('**Problem checking the state of the bumps and kickers - please check that they are not pulsing.');
    %     end
    
    % Get vectors
    FB = get(handles.SOFB_Edit,'Userdata');
    
    GoalOrbitY0 = FB.OCSy.GoalOrbit;   % Save the zero kick golden orbit
    
    % Pseudo single bunch
    PSBFlag = 0;
    if strcmpi(get(handles.PseudoSingleBunch,'Checked'),'On')
        % It would be ok to remove the above if (assuming the kicker channels are working)
        [xKick, yKick, PSBFlag] = getpseudosinglebunchkick(FB.OCSy.BPM.DeviceList);
        FB.OCSy.GoalOrbit = GoalOrbitY0 + yKick;
    end
    
    BPMlist1 = FB.OCSx.BPM.DeviceList;
    BPMlistnonBergoz = getbpmlist('nonBergoz');
    HCMlist1 = FB.OCSx.CM.DeviceList;
    VCMlist1 = FB.OCSy.CM.DeviceList;
    Xivec = FB.OCSx.SVDIndex;
    Yivec = FB.OCSy.SVDIndex;
    Xgoal = FB.OCSx.GoalOrbit;
    Ygoal = FB.OCSy.GoalOrbit;
    
    iNotHCMChicane = find(HCMlist1(:,2) < 10); %used by steppv's for setting correctors in loop
    iHCMChicane    = find(HCMlist1(:,2) == 10);
    iNotVCMChicane = find(VCMlist1(:,2) <  10);
    iVCMChicane    = find(VCMlist1(:,2) == 10);
    
    % Sensitivity matrix for setting fast feedback setpoints
    Sx1 = getrespmat('BPMx', BPMlist1, 'HCM', HCMlist1, [], Energy);
    Sy1 = getrespmat('BPMy', BPMlist1, 'VCM', VCMlist1, [], Energy);
    SxnonBergoz = getrespmat('BPMx', BPMlistnonBergoz, 'HCM', HCMlist1, [], Energy);
    SynonBergoz = getrespmat('BPMy', BPMlistnonBergoz, 'VCM', VCMlist1, [], Energy);
    
catch
    fprintf('\n  %s \n',lasterr);
    
    % Reset Bergoz BPM time constant to whatever it was before feedback started
    fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
    %setbpmtimeconstant(BPMtimeconstantOFB);
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *************************************************************\n');
    fprintf('   **  Orbit feedback could not start due to error condition  **\n');
    fprintf('   *************************************************************\n\n');
    return
end

StartFlag = questdlg(strvcat('','Is it OK to start orbit feedback?'),'Orbit Feedback','Yes','No','No');
drawnow;
if strcmp(StartFlag,'No')
    % Reset Bergoz BPM time constant to whatever it was before feedback started
    fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
    %setbpmtimeconstant(BPMtimeconstantOFB);
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ***************************\n');
    fprintf('   **  Orbit Feedback Exit  **\n');
    fprintf('   ***************************\n\n');
    pause(0);
    return
end

SR_STATE_OLD = getpv('SR_STATE');
setpv('SR_STATE', 5);
[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
end
fprintf('   Using %d E-vectors horizontally.\n', length(Xivec));
fprintf('   Using %d E-vectors vertically.\n',   length(Yivec));
fprintf('   Starting slow orbit correction every %.1f seconds.\n', LoopDelay);

IDSector = getlist('ID');
addQFsp=zeros(24,length(IDSector));
addQDsp=zeros(24,length(IDSector));
EPUlist = find((IDSector(:,1)==4) | (IDSector(:,1)==7) | (IDSector(:,1)==11) | ((IDSector(:,1)==6) & (IDSector(:,2)==2)));
oldgap=210*ones(size(IDSector,1),1);
oldShift=zeros(size(oldgap));

% EPUs excite nux = .25 resonance in vertical linear polarization mode!
% therefore with EPU tune feedforward
% running, we want to move our nominal working point away (just below) the .25 resonance.
%
% The following tune correction moves nominal
% nu_x from .25 to .245 - this should be enough for well set up lattices.
%
% 24 QF+ 24 QD
staticOffset = inv(SR_TUNE_MATRIX) * [-0.005;0];    %  DelAmps =  [QF; QD];


try
    % Get and display data
    x = FB.OCSx.GoalOrbit - getx(FB.OCSx.BPM.DeviceList);
    y = FB.OCSy.GoalOrbit - gety(FB.OCSy.BPM.DeviceList);
    STDx = norm(x)/sqrt(length(x));
    STDy = norm(y)/sqrt(length(y));
    set(handles.SRCTRLStaticTextHorizontal,'String',sprintf('Horizontal RMS = %.4f mm',STDx),'ForegroundColor',[0 0 0]);
    set(handles.SRCTRLStaticTextVertical,'String',sprintf('Vertical RMS = %.4f mm',STDy),'ForegroundColor',[0 0 0]);
    
    % write goldenorbit values to Fast Orbit Feedback
    try
        write_goldenorbit_ffb(PSBFlag);
    catch
        fprintf('   %s \n',lasterr);
        disp('write_goldenorbit_ffb did not work!');
    end
    
    % check to see if FOFB is running; if it is, don't turn it off when starting SOFB
    if getpvonline('SR01____FFBON__BM00','Double')==1
        % do nothing if FOFB is already on
    else
        % open the loop to enable data logging
        setpvonline('SR01____FFBON__BC00',2);
    end
    
    % display state of FOFB system on SRCONTROL GUI
    %     FOFBStatus = [getpv('SR01____FFBON__BM00') getpv('SR02____FFBON__BM00') getpv('SR03____FFBON__BM00')...
    %         getpv('SR04____FFBON__BM00') getpv('SR05____FFBON__BM00') getpv('SR06____FFBON__BM00')...
    %         getpv('SR07____FFBON__BM00') getpv('SR08____FFBON__BM00') getpv('SR09____FFBON__BM00')...
    %         getpv('SR10____FFBON__BM00') getpv('SR11____FFBON__BM00') getpv('SR12____FFBON__BM00')];
    %     FOFBStatusStr = ['    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    ';'    '];
    FOFBStatus = getpvonline('SR01____FFBON__BM00','Double');
    FOFBStatusStr = '    ';
    for loop = 1:size(FOFBStatus,2)
        if FOFBStatus(loop)==0
            FOFBStatusStr(loop,:) = 'OFF ';
        elseif FOFBStatus(loop)==1
            FOFBStatusStr(loop,:) = 'ON  ';
        elseif FOFBStatus(loop)==2
            FOFBStatusStr(loop,:) = 'OPEN';
        else
            FOFBStatusStr(loop,:) = 'BAD ';
        end
    end
    set(handles.SRCTRLStaticTextFOFB01,'String',sprintf('01 %s',FOFBStatusStr(1,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB02,'String',sprintf('02 %s',FOFBStatusStr(2,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB03,'String',sprintf('03 %s',FOFBStatusStr(3,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB04,'String',sprintf('04 %s',FOFBStatusStr(4,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB05,'String',sprintf('05 %s',FOFBStatusStr(5,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB06,'String',sprintf('06 %s',FOFBStatusStr(6,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB07,'String',sprintf('07 %s',FOFBStatusStr(7,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB08,'String',sprintf('08 %s',FOFBStatusStr(8,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB09,'String',sprintf('09 %s',FOFBStatusStr(9,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB10,'String',sprintf('10 %s',FOFBStatusStr(10,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB11,'String',sprintf('11 %s',FOFBStatusStr(11,:)),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB12,'String',sprintf('12 %s',FOFBStatusStr(12,:)),'ForegroundColor',[0 0 0]);
    
catch
    
    fprintf('\n  %s \n',lasterr);
    
    % Reset Bergoz BPM time constant to whatever it was before feedback started
    fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
    %setbpmtimeconstant(BPMtimeconstantOFB);
    
    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   *************************************************************\n');
    fprintf('   **  Orbit feedback could not start due to error condition  **\n');
    fprintf('   *************************************************************\n\n');
    
    setpv('SR_STATE',SR_STATE_OLD);
    
    [StateNumber, StateString] = getsrstate;
    if StateNumber >= 0
        set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    else
        set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    end
    return
end


% Disable buttons
set(handles.TurnOn,               'Enable', 'off');
set(handles.TurnOff,              'Enable', 'off');
set(handles.HWInit,               'Enable', 'off');
set(handles.FeedbackStart,        'Enable', 'off');
set(handles.FeedbackStop,         'Enable', 'on');
set(handles.Cycle,                'Enable', 'off');
set(handles.Injection,            'Enable', 'off');
set(handles.Production,           'Enable', 'off');
set(handles.OperationalMode,      'Enable', 'off');
set(handles.CheckForProblems,     'Enable', 'off');
set(handles.GoldenPage,           'Enable', 'off');
set(handles.OrbitCorrection,      'Enable', 'off');
set(handles.OrbitCorrection_Edit, 'Enable', 'off');
set(handles.SOFB_Edit,            'Enable', 'off');
set(handles.FOFB_Edit,            'Enable', 'off');
% set(handles.Close,                'Enable', 'off');
drawnow;


% Initialize feedback loop
StartTime = gettime;
StartErrorTime = gettime;
Xold = getx(FB.OCSx.BPM.DeviceList);
Yold = gety(FB.OCSy.BPM.DeviceList);
HWarnNum = 0;
VWarnNum = 0;
FOFBWarnNum = 0;
HQMOFM_stalenum = 0;
RFWarnNum = 0;
pause(LoopDelay);

N_HCM = size(HCMlist1,1);
N_VCM = size(VCMlist1,1);

N_RFMO = 1;

if get(handles.CheckboxRF,'Value') == 1
    [FB.OCSx, RF, OCSx0] = setorbit(FB.OCSx,'SetRF','Nodisplay','Nosetsp');
else
    [FB.OCSx, RF, OCSx0] = setorbit(FB.OCSx,'Nodisplay','Nosetsp');
end
[FB.OCSx, Smatx, Sx, Ux, Vx] = orbitcorrectionmethods(FB.OCSx);

[FB.OCSy, junk, OCSy0] = setorbit(FB.OCSy,'Nodisplay','Nosetsp');
[FB.OCSy, Smaty, Sy, Uy, Vy] = orbitcorrectionmethods(FB.OCSy);


%%%%%%%%%%%%%%%%%%%%%%%
% Start Feedback Loop %
%%%%%%%%%%%%%%%%%%%%%%%

% fftest=figure;

% check to see if FOFB is running; if it is, don't turn it off when starting SOFB
if getpvonline('SR01____FFBON__BM00','Double')==1
    fprintf('   Fast Orbit Feedback is already running at %.0f Hz.\n', getpv('SR01____FFBFREQAM00'));
    % do nothing if FOFB is already on
else
    % put FOFB in open loop so beamnoise gets recorded even if FOFB is not enabled
    setpvonline('SR01____FFBON__BC00',2);
    % FOFB alarm handler
    setpvonline('Physics1',0);
end

while 1
    try
        t00 = gettime;
        
        % Check if GUI has been closed
        if isempty(gcbf)
            lasterr('SRCONTROL DISAPPEARED!');
            error('SRCONTROL DISAPPEARED!');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%
        % Fast orbit feedback %
        %%%%%%%%%%%%%%%%%%%%%%%
        if getpvonline('SR01____FFBON__BM00','Double')==1
            % do nothing if FOFB is already on
        else
            if StartFOFBFlag == 1 && FBloopIter > 3
                setpvonline('SR01____FFBON__BC00',2);
                pause(0.001);
                setpvonline('SR01____FFBON__BC00',1);
                StartFOFBFlag = 0;
                pause(0.001);
                FOFBOnStatus = [getpvonline('SR01____FFBON__BM00','Double') getpvonline('SR02____FFBON__BM00','Double') getpvonline('SR03____FFBON__BM00','Double')...
                    getpvonline('SR04____FFBON__BM00','Double') getpvonline('SR05____FFBON__BM00','Double') getpvonline('SR06____FFBON__BM00','Double')...
                    getpvonline('SR07____FFBON__BM00','Double') getpvonline('SR08____FFBON__BM00','Double') getpvonline('SR09____FFBON__BM00','Double')...
                    getpvonline('SR10____FFBON__BM00','Double') getpvonline('SR11____FFBON__BM00','Double') getpvonline('SR12____FFBON__BM00','Double')];
                if any(FOFBOnStatus==0) || any(FOFBOnStatus==2)
                    setpvonline('SR01____FFBON__BC00',2); % open FOFB loop
                    disp('************************************************************************************************************');
                    disp('** Problem turning on Fast Orbit Feedback system...                                                       **');
                    disp('** Check status of ffbsecXX crates - BUT REMEMBER THAT A CRATE REBOOT WILL TURN OFF QUADS IN THAT SECTOR! **');
                    disp('** Suggest disabling the "Fast Orbit Correction" checkbox and starting Orbit Feedback again.              **');
                    disp('************************************************************************************************************');
                    % FOFB alarm handler
                    setpvonline('Physics1',1);
                else
                    fprintf('   Starting Fast Orbit Feedback at %.0f Hz.\n', getpvonline('SR01____FFBFREQAM00','Double'));
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Horizontal plane "feedback" %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if get(handles.CheckboxSOFB,'Value') == 1
            
            % Get orbit and check that the BPMs are different from the last update
            Xnew = getx(FB.OCSx.BPM.DeviceList);
            XnewnonBergoz = getx(BPMlistnonBergoz);
            
            % Don't feedback if the current is too small
            if getdcct < 2
                setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                fprintf('   %s: Orbit feedback stopped due to low beam current (<2mA)\n',datestr(now));
                disp('emailing beamisoff.txt to Operator Cellphone');
                sendmail('5108120447@txt.att.net','ALERT','Beam is off!!!');
                
                % stop and open FOFB to flush setpoints to main corrector ACs
                fprintf('   Stop/starting FFB to flush out hidden setpoints.\n');
                setpv('SR01____FFBON__BC00',0);
                pause(0.001);
                setpv('SR01____FFBON__BC00',2);
                % FOFB message and alarm handler
                fprintf('   Fast Orbit Feedback has turned off due to low beam current.\n');
                setpv('Physics1',1);
                break;
            end
            
            x = Xgoal - Xnew;
            STDx = norm(x)/sqrt(length(x));
            
            if any(Xold == Xnew)
                a = clock;
                N_Stale_Data_Points = find((Xold==Xnew)==1);
                for loop = N_Stale_Data_Points'
                    fprintf('   Stale data: BPMx(%2d,%d), feedback step skipped (%s %d:%d:%.0f). \n', FB.OCSx.BPM.DeviceList(loop,1), FB.OCSx.BPM.DeviceList(loop,2), date, a(4), a(5), a(6));
                end
            else
                
                % If chicane correctors are getting out of range, change motor chicanes to help out (this is likely happening due to action of feed-forward tables)
                chicane_corr_max = 15;
                motor_chicane_delta = 0.2;
                motor_chicane_velocity = 0.5;

                try
                    for ChicaneSector = [4 6 11] %[4 6 7 11]
                        if (abs(getpv('HCM','DAC',[ChicaneSector-1 10]))>chicane_corr_max) && (abs(getam('HCM',[ChicaneSector-1 10]))>chicane_corr_max/5)
                            if ChicaneSector == 6
                                correction_step = sign(getpv('HCM','DAC',[ChicaneSector-1 10]))*motor_chicane_delta;
                            else
                                correction_step = -sign(getpv('HCM','DAC',[ChicaneSector-1 10]))*motor_chicane_delta;
                            end
                            setpv('HCMCHICANEM','RampRate',motor_chicane_velocity,[ChicaneSector 1;ChicaneSector 2]);
                            steppv('HCMCHICANEM',correction_step,[ChicaneSector 1;ChicaneSector 2]);
                            fprintf('   Changed the setpoints of the SR%02d motor chicanes %.1f degrees to get corrector back into good range\n',ChicaneSector,correction_step);
                        end
                    end                    
                catch
                    fprintf('   %s \n',lasterr);
                end
                
                % Compute horizontal correction
                FB.OCSx.BPM.Data = Xnew;
                FB.OCSx = orbitcorrectionmethods(FB.OCSx, Smatx, Sx, Ux, Vx);
                
                % reduced feedback gain (implemented by Greg Portmann, December 2000)
                % reduced to 0.1, C. Steier, 2001-09-04, IDBPMs are noisy at the moment
                % increased back to 0.8 C. Steier, 2001-09-29, IDBPMs filtering + direct DAC read/write + all SVDs (no arc BPMs)
                % increased to 1.0, C. Steier, 2002-05-04, trim DACs
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Should probably actively allocate X's size to prevent possible memory leak %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                X = [Xgain .* FB.OCSx.CM.Delta; 0.05*FB.OCSx.DeltaRF/4.988e-3*10];
                
                %%%X = Xgain .* (FB.OCSx.CM.Data - OCSx0.CM.Data);
                
                % Check corrector trim values + next step values, warn or stop FB as necessary
                HCMtrimSP=getpv('HCM','Trim',HCMlist1);
                HCMSP=getpv('HCM','DAC',HCMlist1);
                HCMAM=getpv('HCM','Monitor',HCMlist1);
                HCMtrimSP_next = HCMtrimSP + X(1:N_HCM);
                if max(abs(HCMtrimSP_next)) > 3.99
                    HCMtrimnum=find(abs(HCMtrimSP_next) > 3.99);
                    
                    % Print message to screen
                    fprintf('\n');
                    fprintf('***One or more of the horizontal correctors is at its maximum!! Stopping orbit feedback. \n');
                    fprintf('   %s\n',datestr(now));
                    for loop = HCMtrimnum'
                        fprintf('   %s is one of the problem correctors.\n',getname('HCM','Trim',HCMlist1(loop,:)));
                    end
                    
                    % Send alphapage to operator pager
                    fprintf('   Emailing SOFBstoppedmessage.txt to Operator Cellphone.\n');
                    sendmail('5108120447@txt.att.net','ALERT','The SLOW orbit feedback has STOPPED!!');
                    setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                    
                    setpv('SR_STATE', -5);
                    [StateNumber, StateString] = getsrstate;
                    if StateNumber >= 0
                        set(handles.InfoText,'String',StateString,'ForegroundColor','b');
                    else
                        set(handles.InfoText,'String',StateString,'ForegroundColor','r');
                    end
                end
                
                % Check chicane trim coil values + next step values, warn or stop FB as necessary
                if ~isempty(iHCMChicane)
                    HCMCHICANEtrimSP = getpv('HCM','Setpoint',HCMlist1(iHCMChicane,:));
                    HCMCHICANEtrimSP_next = HCMCHICANEtrimSP + X(iHCMChicane);
                    if max(abs(HCMCHICANEtrimSP_next)) > 19.9
                        HCMCHICANEtrimnum = find(abs(HCMCHICANEtrimSP_next) > 19.9);
                        
                        % Print message to screen
                        fprintf('\n');
                        fprintf('***One or more of the horizontal chicane trim coil correctors is at its maximum!! Stopping orbit feedback. \n');
                        fprintf('   %s\n',datestr(now));
                        for loop = HCMCHICANEtrimnum'
                            fprintf('   %s is one of the problem correctors.\n',getname('HCM','Setpoint',HCMlist1(iHCMChicane(loop,:),:)));
                        end
                        %fprintf('***Maybe try resetting the setpoints of the motor chicanes in case they are drifting...\n');
                        
                        % Send alphapage to operator pager
                        fprintf('   Emailing SOFBstoppedmessage.txt to Operator Cellphone.\n');
                        sendmail('5108120447@txt.att.net','ALERT','The SLOW orbit feedback has STOPPED!!');
                        setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                        
                        setpv('SR_STATE', -5);
                        [StateNumber, StateString] = getsrstate;
                        if StateNumber >= 0
                            set(handles.InfoText,'String',StateString,'ForegroundColor','b');
                        else
                            set(handles.InfoText,'String',StateString,'ForegroundColor','r');
                        end
                    end
                end
                
                if getappdata(handles.SRCONTROL, 'FEEDBACK_FLAG') == 0
                    % Turnoff off then open FOFB loop (turnoff off to transfer correctors, then open to enable logging)
                    if getpvonline('SR01____FFBON__BC00','Double')==1
                        fprintf('   Stopping Fast Orbit Feedback.\n');
                    end
                    setpv('SR01____FFBON__BC00',0);
                    pause(0.5);
                    setpv('SR01____FFBON__BC00',2);
                    % FOFB alarm handler
                    fprintf('   %s: Fast Orbit Feedback has turned off.\n',datestr(now));
                    setpv('Physics1',1);
                    break;
                end
                
                % fprintf('End of feedback loop: %f \n\n',gettime-t00);
                % pause(0);
                
                if (max(abs(HCMtrimSP+HCMSP-HCMAM))>0.5) && (getpvonline('SR01____FFBON__BM00','Double')==1)
                    % hidden setpoint of fast orbit feedback has grown
                    % large, time to resynchronize setpoint by very briefly
                    % stopping and restarting FFB
                    fprintf('   %s: Flushing out hidden FFB setpoints (due to HCMs)\n',datestr(now));
                    setpv('SR01____FFBON__BC00',0,0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',2,0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',1,0);
                    pause(1);
                end
                
                if max(abs(HCMtrimSP_next) > 3)
                    HCMtrimnum=find(abs(HCMtrimSP_next) > 3);
                    HWarnNum=HWarnNum+1;
                    if (HWarnNum==1 || rem(HWarnNum,120)==0)
                        
                        % Print message to screen every two minutes
                        fprintf('\n');
                        fprintf('***One or more of the horizontal corrector trims is above 3A or below -3A! \n');
                        fprintf('   %s\n',datestr(now));
                        for loop = HCMtrimnum'
                            fprintf('   %s is one of the problem correctors.\n',getname('HCM','Trim',HCMlist1(loop,:)));
                        end
                        fprintf('   The orbit feedback is still working but this problem should be investigated. \n');
                        
                        % Send alphapage to operator pager the first time then at 10 minutes
                        if (HWarnNum==1 || HWarnNum==600)
                            fprintf('   Emailing SOFBwarningmessageHCM.txt to Operator Cellphone.\n');
                            sendmail('5108120447@txt.att.net','ALERT','One of the horizontal corrector trims is above 3A or below -3A!');
                        end
                    end
                elseif ~isempty(iHCMChicane) && max(abs(HCMCHICANEtrimSP_next) > 15)
                    HCMCHICANEtrimnum=find(abs(HCMCHICANEtrimSP_next) > 15);
                    HWarnNum=HWarnNum+1;
                    if (HWarnNum==1 || rem(HWarnNum,120)==0)
                        
                        % Print message to screen every two minutes
                        fprintf('\n');
                        fprintf('***One or more of the horizontal chicane corrector trim coils is above 15A or below -15A! \n');
                        fprintf('   %s\n',datestr(now));
                        for loop = HCMCHICANEtrimnum'
                            fprintf('   %s is one of the problem correctors.\n',getname('HCM','Setpoint',HCMlist1(iHCMChicane(loop,:),:)));
                        end
                        fprintf('   The orbit feedback is still working but this problem should be investigated. \n');
                        
                        % Send alphapage to operator pager the first time then at 10 minutes
                        if (HWarnNum==1 || HWarnNum==600)
                            fprintf('   Emailing SOFBwarningmessageHCMCHICANE.txt to Operator Cellphone.\n');
                            sendmail('5108120447@txt.att.net','ALERT','One of the horizontal chicane corrector trims is above 15A or below -15A!');
                        end
                    end
                else
                    HWarnNum=0;
                end
                
                % Don't feedback if the current is too small
                if getdcct < 2
                    setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                    fprintf('   %s: Orbit feedback stopped due to low beam current (<2mA)\n',datestr(now));
                    fprintf('   Emailing beamisoff.txt to Operator Cellphone.\n');
                    sendmail('5108120447@txt.att.net','ALERT','Beam is off!!!');
                    
                    % stop and open FOFB to flush setpoints to main corrector ACs
                    fprintf('   Stop/starting FFB to flush out hidden setpoints.\n');
                    setpv('SR01____FFBON__BC00',0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',2);
                    % FOFB alarm handler
                    fprintf('   Fast Orbit Feedback has turned off due to low beam current.\n');
                    setpv('Physics1',1);
                    break;
                end
                
                if N_HCM > 0
                    steppv('HCM', 'Trim',  X(iNotHCMChicane), HCMlist1(iNotHCMChicane,:), 0);
                    if ~isempty(iHCMChicane)
                        steppv('HCM', 'Setpoint', X(iHCMChicane), HCMlist1(iHCMChicane,:), 0);
                    end
                end
                
                % Write fast orbit feedback setpoints
                if 1
                    %write_goldenorbit_ffb_2planes(1, Xnew(1:size(BPMlist1,1))+Sx1*X(1:N_HCM)+Sx3*X(length(X))/20, BPMlist1);
                    % should be corrected to include result of next frequency step ...
                    write_goldenorbit_ffb_2planesb(1,Xnew(1:size(BPMlist1,1))+Sx1*X(1:N_HCM),BPMlist1,XnewnonBergoz+SxnonBergoz*X(1:N_HCM),BPMlistnonBergoz);
                    % write_goldenorbit_ffb_2planes(1,Xnew(1:size(BPMlist1,1))+Sx1*X(1:N_HCM),BPMlist1);
                end
                
                %fprintf('Horizontal Done: %f \n',gettime-t00);
                
                % RF feedback
                HQMOFMsp_last = getpvonline('EG______HQMOFM_AC01');
                
                if get(handles.CheckboxRF,'Value') == 1
                    if N_RFMO > 0
                        if abs(X(end)) < .1
                            % if abs(FB.OCSx.DeltaRF/3) < .01
                            steppv('EG______HQMOFM_AC01', X(end));
                        else
                            steppv('EG______HQMOFM_AC01', 0.1*sign(X(end)));
                        end
                    end
                    
                    HQMOFMsp_now = getpvonline('EG______HQMOFM_AC01');
                    
                    % Check whether RF is at it's modulation limit
                    if abs(HQMOFMsp_now) >= 9.99
                        RFWarnNum = RFWarnNum + 1;
                        % Print message to screen every two minutes if it's pegged
                        if (RFWarnNum==1 || rem(RFWarnNum,120)==0)
                            fprintf('\n');
                            fprintf('***The RF modulation (PV: EG______HQMOFM_AC01) is pegged at +/- 10V, so it seems the RF frequency should be re-centered. \n');
                            fprintf('***Note that changing the center frequency of the Master Oscillator will trip off the RF! \n');
                            fprintf('***The orbit feedback is still partially working but this problem should be resolved. \n');
                            fprintf('   %s\n',datestr(now));
                            
                            % Send alphapage to operator pager the first time then at 10 minutes
                            if (RFWarnNum==1 || RFWarnNum==600)
                                fprintf('\n');
                                fprintf('   %s: Emailing SOFBstaleRFmessage.txt to Operator Cellphone.\n', datestr(now));
                                sendmail('5108120447@txt.att.net','ALERT','The RF is not responding to orbit feedback changes!');
                            end
                        end
                    else
                        RFWarnNum = 0;
                    end
                    
                    % Check for stale RF feedback
                    if HQMOFMsp_last == HQMOFMsp_now
                        HQMOFM_stalenum = HQMOFM_stalenum + 1;
                        if HQMOFM_stalenum == 30 % warn and message to pager if stale for 30 secs
                            fprintf('\n');
                            fprintf('   %s\n',datestr(now));
                            fprintf('***The RF is not responding to orbit feedback changes! \n');
                            fprintf('***The orbit feedback is still partially working but this problem should be resolved. \n');
                            fprintf('***miniIOC in LI09 controls the EG______HQMOFM_AC01 channel, which sets the RF frequency. \n');
                            fprintf('   Emailing SOFBstaleRFmessage.txt to Operator Cellphone.\n');
                            sendmail('5108120447@txt.att.net','ALERT','The RF is not responding to orbit feedback changes!');
                        end
                        if rem(HQMOFM_stalenum,120)==0 % message to screen every 2 minutes
                            fprintf('\n');
                            fprintf('***%s: The RF is not responding to orbit feedback changes!\n',datestr(now));
                        end
                    else
                        HQMOFM_stalenum = 0;
                    end
                end
                
                %fprintf('RF Done: %f \n',gettime-t00);
                
                Xold = Xnew;
            end % End horizontal correction
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Vertical plane "feedback" %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Get orbit and check that the BPMs are different from the last update
            Ynew = gety(FB.OCSy.BPM.DeviceList);
            YnewnonBergoz = gety(BPMlistnonBergoz);
            
            % Don't feedback if the current is too small
            if getdcct < 2
                setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                fprintf('   %s: Orbit feedback stopped due to low beam current (<2mA)\n',datestr(now));
                fprintf('   Emailing beamisoff.txt to Operator Cellphone.\n');
                sendmail('5108120447@txt.att.net','ALERT','Beam is off!!!');
                
                % stop and open FOFB to flush setpoints to main corrector ACs
                fprintf('   Stop/starting FFB to flush out hidden setpoints.\n');
                setpv('SR01____FFBON__BC00',0);
                pause(0.001);
                setpv('SR01____FFBON__BC00',2);
                % FOFB alarm handler
                fprintf('   Fast Orbit Feedback has turned off due to low beam current.\n');
                setpv('Physics1',1);
                break;
            end
            
            % Pseudo single bunch - scale the orbit by the voltage in the kicker
            if strcmpi(get(handles.PseudoSingleBunch,'Checked'),'On')
                % It would be ok to remove the above if (assuming the kicker channels are working)
                [xKick, yKick] = getpseudosinglebunchkick(FB.OCSy.BPM.DeviceList);
                Ygoal = GoalOrbitY0 + yKick;
                FB.OCSy.GoalOrbit = GoalOrbitY0 + yKick;
            end
            
            y = Ygoal - Ynew;
            STDy = norm(y)/sqrt(length(y));
            
            if any(Yold == Ynew)
                a = clock;
                N_Stale_Data_Points = find((Yold==Ynew)==1);
                for loop = N_Stale_Data_Points'
                    fprintf('   Stale data: BPMy(%2d,%d), feedback step skipped (%s %d:%d:%.0f). \n', FB.OCSy.BPM.DeviceList(loop,1), FB.OCSy.BPM.DeviceList(loop,2), date, a(4), a(5), a(6));
                end
            else
                % Compute vertical correction
                FB.OCSy.BPM.Data = Ynew;
                FB.OCSy = orbitcorrectionmethods(FB.OCSy, Smaty, Sy, Uy, Vy);
                
                % reduced feedback gain, C. Steier, 2001-03-25
                % reduced to 0.1, C. Steier, 2001-09-04, IDBPMs are noisy at the moment
                % increased back to 0.8, C. Steier, 2001-09-29, IDBPMs filtering + direct DAC read/write + all SVDs (no arc BPMs)
                % set to unity gain, C. Steier, 2002-05-04, trim DACs
                Y = Ygain .* FB.OCSy.CM.Delta;
                %%%Y = Ygain .* (FB.OCSy.CM.Data - OCSy0.CM.Data);
                
                % Just SVD correction
                % warning('Not using "micado" correction in the vertical plane.');
                
                % Check for trim values+next step values, warn or stop FB as necessary
                VCMtrimSP = getpv('VCM', 'Trim', VCMlist1);
                VCMSP=getpv('VCM','DAC',VCMlist1);
                VCMAM=getpv('VCM','Monitor',VCMlist1);
                VCMtrimSP_next = VCMtrimSP + Y(1:N_VCM);
                if max(abs(VCMtrimSP_next)) > 3.99
                    VCMtrimnum=find(abs(VCMtrimSP_next) > 3.99);
                    
                    % Print message to screen
                    fprintf('\n');
                    fprintf('***One or more of the vertical correctors is at its maximum!! Stopping orbit feedback. \n');
                    fprintf('   %s\n',datestr(now));
                    for loop = VCMtrimnum'
                        fprintf('   %s is one of the problem correctors.\n',getname('VCM','Trim',VCMlist1(loop,:)));
                    end
                    
                    % send alphapage to operator pager
                    fprintf('   Emailing SOFBstoppedmessage.txt to Operator Cellphone.\n');
                    sendmail('5108120447@txt.att.net','ALERT','The SLOW orbit feedback has STOPPED!!');
                    setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                    
                    setpv('SR_STATE', -5);
                    [StateNumber, StateString] = getsrstate;
                    if StateNumber >= 0
                        set(handles.InfoText,'String',StateString,'ForegroundColor','b');
                    else
                        set(handles.InfoText,'String',StateString,'ForegroundColor','r');
                    end
                end
                
                % Check chicane trim coil values + next step values, warn or stop FB as necessary
                if ~isempty(iVCMChicane)
                    VCMCHICANEtrimSP=getpv('VCM','Setpoint',VCMlist1(iVCMChicane,:));
                    VCMCHICANEtrimSP_next = VCMCHICANEtrimSP + Y(iVCMChicane);
                    if max(abs(VCMCHICANEtrimSP_next)) > 19.9
                        VCMCHICANEtrimnum=find(abs(VCMCHICANEtrimSP_next) > 19.9);
                        
                        % print message to screen
                        fprintf('\n');
                        fprintf('***One or more of the vertical chicane trim coil correctors is at its maximum!! Stopping orbit feedback. \n');
                        fprintf('   %s\n',datestr(now));
                        for loop = VCMCHICANEtrimnum'
                            fprintf('   %s is one of the problem correctors.\n',getname('VCM','Setpoint',VCMlist1(iVCMChicane(loop,:),:)));
                        end
                        %fprintf('***Maybe try resetting the setpoints of the motor chicanes in case they are drifting...\n');
                        
                        % send alphapage to operator pager
                        fprintf('   Emailing SOFBstoppedmessage.txt to Operator Cellphone.\n');
                        sendmail('5108120447@txt.att.net','ALERT','The SLOW orbit feedback has STOPPED!!');
                        setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                        
                        setpv('SR_STATE', -5);
                        [StateNumber, StateString] = getsrstate;
                        if StateNumber >= 0
                            set(handles.InfoText,'String',StateString,'ForegroundColor','b');
                        else
                            set(handles.InfoText,'String',StateString,'ForegroundColor','r');
                        end
                    end
                end
                
                if getappdata(handles.SRCONTROL, 'FEEDBACK_FLAG') == 0
                    % turnoff off then open FOFB loop (turnoff off to transfer correctors, then open to enable logging)
                    if getpvonline('SR01____FFBON__BC00','Double')==1
                        fprintf('   %s: Stopping Fast Orbit Feedback.\n', datestr(now));
                    end
                    setpv('SR01____FFBON__BC00',0);
                    pause(0.5);
                    setpv('SR01____FFBON__BC00',2);
                    break;
                end
                
                %fprintf('End of feedback loop: %f \n\n',gettime-t00);
                % pause(0);
                
                if (max(abs(VCMtrimSP+VCMSP-VCMAM))>0.5) && (getpvonline('SR01____FFBON__BM00','Double')==1)
                    % hidden setpoint of fast orbit feedback has grown
                    % large, time to resynchronize setpoint by very briefly
                    % stopping and restarting FFB
                    fprintf('   %s: Flushing out hidden FFB setpoints (due to VCMs)\n',datestr(now));
                    setpv('SR01____FFBON__BC00',0,0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',2,0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',1,0);
                    pause(1);
                end
                
                if max(abs(VCMtrimSP_next) > 3) % Changed to 3 A - new corrector scaling
                    VCMtrimnum=find(abs(VCMtrimSP_next) > 3);
                    VWarnNum=VWarnNum+1;
                    if (VWarnNum==1 || rem(VWarnNum,120)==0)
                        
                        % Print message to screen every two minutes
                        fprintf('\n');
                        fprintf('***One or more of the vertical corrector trims is above 3A or below -3A!\n');
                        fprintf('   %s\n',datestr(now));
                        for loop = VCMtrimnum'
                            fprintf('   %s is one of the problem correctors.\n',getname('VCM','Trim',VCMlist1(loop,:)));
                        end
                        fprintf('   The orbit feedback is still working but this problem should be investigated.\n');
                        
                        % Send alphapage to operator pager the first time then at 10 minutes
                        if (VWarnNum==1 || VWarnNum==600)
                            fprintf('   Emailing SOFBwarningmessageVCM.txt to Operator Cellphone.\n');
                            sendmail('5108120447@txt.att.net','ALERT','One of the vertical corrector trims is above 3A or below -3A!');
                        end
                    end
                elseif ~isempty(iVCMChicane) && max(abs(VCMCHICANEtrimSP_next) > 15)
                    VCMCHICANEtrimnum=find(abs(VCMCHICANEtrimSP_next) > 15);
                    VWarnNum=VWarnNum+1;
                    if (VWarnNum==1 || rem(VWarnNum,120)==0)
                        
                        % Print message to screen every two minutes
                        fprintf('\n');
                        fprintf('***One or more of the vertical chicane corrector trim coils is above 15A or below -15A!\n');
                        fprintf('   %s\n',datestr(now));
                        for loop = VCMCHICANEtrimnum'
                            fprintf('   %s is one of the problem correctors.\n',getname('VCM','Setpoint',VCMlist1(iVCMChicane(loop,:),:)));
                        end
                        fprintf('   The orbit feedback is still working but this problem should be investigated.\n');
                        
                        % All motor chicanes have harmonic drives now, so slipping should be impossible - 6-4-08 - T.Scarvie
                        % %reset motor chicanes in case they are drifting
                        % try
                        % 		fprintf('  Resetting the setpoints of the motor chicanes in case they are drifting...\n');
                        %     	setpv('HCMCHICANEM','Setpoint',ConfigSetpoint.HCMCHICANEM.Setpoint.Data,[],0);
                        % catch
                        %       fprintf('   %s \n',lasterr);
                        % end
                        
                        %send alphapage to operator pager the first time then at 10 minutes
                        if (VWarnNum==1 || VWarnNum==600)
                            fprintf('   Emailing SOFBwarningmessageVCMCHICANE.txt to Operator Cellphone.\n');
                            sendmail('5108120447@txt.att.net','ALERT','One of the vertical chicane corrector trims is above 15A or below -15A!');
                        end
                    end
                else
                    VWarnNum=0;
                end
                
                % Don't feedback if the current is too small
                if getdcct < 2
                    setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                    fprintf('   %s: Orbit feedback stopped due to low beam current (<2mA)\n',datestr(now));
                    fprintf('   Emailing beamisoff.txt to Operator Cellphone.\n');
                    sendmail('5108120447@txt.att.net','ALERT','Beam is off!!!');
                    
                    % stop and open FOFB to flush setpoints to main corrector ACs
                    fprintf('   Stop/starting FFB to flush out hidden setpoints.\n');
                    setpv('SR01____FFBON__BC00',0);
                    pause(0.001);
                    setpv('SR01____FFBON__BC00',2);
                    % FOFB alarm handler
                    fprintf('   Fast Orbit Feedback has turned off due to low beam current.\n');
                    setpv('Physics1',1);
                    break;
                end
                
                if N_VCM > 0
                    steppv('VCM','Trim', Y(iNotVCMChicane), VCMlist1(iNotVCMChicane,:), 0);
                    if ~isempty(iVCMChicane)
                        steppv('VCM','Setpoint', Y(iVCMChicane), VCMlist1(iVCMChicane,:), 0);
                    end
                end
                
                % Write fast orbit feedback setpoints
                if 1
                    write_goldenorbit_ffb_2planesb(2,Ynew(1:size(BPMlist1,1))+Sy1*Y(1:N_VCM),BPMlist1,YnewnonBergoz+SynonBergoz*Y(1:N_VCM),BPMlistnonBergoz);
                    % write_goldenorbit_ffb_2planes(2,Ynew(1:size(BPMlist1,1))+Sy1*Y(1:N_VCM),BPMlist1);
                end
            end
            
            Yold = Ynew;
            
            %fprintf('Vertical Done: %f \n',gettime-t00);
        end % End orbit correction
        
        
        %%%%%%%%%%%%%%%%%%%%%
        % Tune feed forward %
        %%%%%%%%%%%%%%%%%%%%%
        % We should do a Sector limit check
        
        tic;
        if get(handles.CheckboxTune,'Value') == 1
            if strcmp(SR_Mode, 'Pseudo-Single Bunch (0.18,0.25)') || ...
                    strcmp(SR_Mode, '1.9 GeV, Two-Bunch')  % Two
                    % Bunch mode was switched to low emittance lattice on
                    % 2015-08-05
                    
                % The vectorized gets were put outside of loop for speed reasons
                %
                % should also set up QFfac, Quadelem, Quadlist structures outside loop
                
                try
                    newnux = getpv('Topoff_nux_AM');
                    newnuy = getpv('Topoff_nuy_AM');
                catch
                    disp('Problem reading tune measurement');
                end

                if get(handles.CheckboxTuneFB,'Value') == 1
                        if (newnux~=lastnux) && (newnuy~=lastnuy)
                            if (abs(newnux-16.165)<0.04) && (abs(newnuy-9.25)<0.04)
                                tuneFBdnux=tuneFBdnux+0.1*(16.165-newnux);
                                tuneFBdnuy=tuneFBdnuy+0.1*(9.25-newnuy);
                                lastnux=newnux; lastnuy=newnuy;
                                changedtuneflag = 1;
                            end
                        end
                    if abs(tuneFBdnux)>0.04
                        tuneFBdnux=0.04*sign(tuneFBdnux);
                    end
                    if abs(tuneFBdnuy)>0.04
                        tuneFBdnuy=0.04*sign(tuneFBdnuy);
                    end
                else
                    tuneFBdnux=0; tuneFBdnuy=0;
                end

                set(handles.SRCTRLStaticTextTuneFB,'String',sprintf('nux/nuy %.4f/%.4f corrx/y = %.4f/%.4f',newnux,newnuy,tuneFBdnux,tuneFBdnuy),'ForegroundColor',[0 0 0]);

                try
                    actualgap = getid(IDSector);
                    EPU71min_gap_limit = getpvonline('sr07u1:Vgap_target_min');
                    if EPU71min_gap_limit < 14.0
                        setpvonline('sr07u1:Vgap_target_min', 14);
                        warning('   Somehow EPU7-1 minimump gap limit was below 14mm. It has been reset to 14mm.');soundtada;
                    end
                catch
                    warning('   Problem getting ID gap reading!');
                    sounderror;sounderror;
                    sendmail('5108120447@txt.att.net','ALERT','Orbit Feedback can''t read an ID Gap!');
                    actualgap = oldgap;
                end
                [gapmin,gapmax] = gaplimit(IDSector);
                corrind = find(actualgap<(gapmin-1));
                actualgap(corrind)=gapmax(corrind);
                Shift=zeros(size(actualgap));
                try
                    Shift(EPUlist)=getpv('EPU');
                catch
                    warning('   Problem getting EPU shift reading!');
                    sounderror;sounderror;
                    sendmail('5108120447@txt.att.net','ALERT','Orbit Feedback can''t read an EPU Shift!');
                    Shift = oldShift;
                end
                IDchangedList = find((abs(actualgap-oldgap)>0.005) | (abs(Shift-oldShift)>0.005));
                
                if ~isempty(IDchangedList) | changedtuneflag
                    %   disp('   Gap is changing!');
                    
                    changedtuneflag = 0;
                    oldgap=actualgap;
                    oldShift=Shift;
                    
                    for loop = 1:length(IDchangedList)
                        gapnum=IDchangedList(loop);
                        % Change in tune and [QF;QD] from maximum gap
                        if (IDSector(gapnum,1) == 4) || (IDSector(gapnum,1) == 6) || (IDSector(gapnum,1) == 7) || (IDSector(gapnum,1) == 11) % EPU straights
                            if (IDSector(gapnum,2) == 1) && (IDSector(gapnum,1) ~= 6)
                                modenamestr = sprintf('SR%02dU___ODS1M__DC00',IDSector(gapnum,1)); % upstream EPUs minus IVID (6,1)
                            else % if IDSector(gapnum,2) == 2
                                modenamestr = sprintf('SR%02dU___ODS2M__DC00',IDSector(gapnum,1)); % downstream EPUs
                            end
                            epumode = getpvonline(modenamestr,'Double');
                            if (IDSector(gapnum,1) == 4) && (IDSector(gapnum,2) == 1) % go throuch each EPU separately
                                if (epumode == 0) % parallel mode
                                    DeltaNuX = 20.9/13.65*interp2(gap41p',shift41p',dnux41p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap41p',shift41p',dnuy41p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                elseif (epumode == 1) % anti-parallel mode
                                    DeltaNuX = 20.9/13.65*interp2(gap41a',shift41a',dnux41a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap41a',shift41a',dnuy41a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                else % mode 2 exists, but not used during user ops
                                    DeltaNuX = 0;
                                    DeltaNuY = gap2tune(IDSector(gapnum, :), actualgap(gapnum), SR_GeV);
                                end
                            elseif (IDSector(gapnum,1) == 4) && (IDSector(gapnum,2) == 2)
                                if (epumode == 0)
                                    DeltaNuX = 20.9/13.65*interp2(gap42p',shift42p',dnux42p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap42p',shift42p',dnuy42p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                else
                                    DeltaNuX = 0;
                                    DeltaNuY = 0;
                                    %disp('WARNING: EPU 4.2 is not in parallel polarization mode! It should always be operated in mode 0!');
                                end
                            elseif (IDSector(gapnum,1) == 6) && (IDSector(gapnum,2) == 1)
                                    DeltaNuX = interp1(gap61,dnux61,actualgap(gapnum),'linear','extrap');
                                    DeltaNuY = interp1(gap61,dnuy61,actualgap(gapnum),'linear','extrap');
                            elseif (IDSector(gapnum,1) == 6) && (IDSector(gapnum,2) == 2)
                                if (epumode == 0)
                                    DeltaNuX = 20.9/13.65*interp2(gap62p',shift62p',dnux62p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap62p',shift62p',dnuy62p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                elseif (epumode == 1)
                                    DeltaNuX = 20.9/13.65*1.5*interp2(gap62a',shift62a',dnux62a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap62a',shift62a',dnuy62a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                else
                                    DeltaNuX = -20.9/13.65*sqrt(gap2tune(IDSector(gapnum,:),actualgap(gapnum), SR_GeV))/30;
                                    DeltaNuY = gap2tune(IDSector(gapnum,:),actualgap(gapnum), SR_GeV);
                                end
                            elseif (IDSector(gapnum,1) == 7) && (IDSector(gapnum,2) == 1)
                                if (epumode == 0)
                                    DeltaNuX = interp2(gap71p',shift71p',dnux71p',actualgap(gapnum),Shift(gapnum),'linear',0);    
                                    DeltaNuY = interp2(gap71p',shift71p',dnuy71p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                elseif (epumode == 1)
                                    DeltaNuX = -0.5*gap2tune(IDSector(gapnum,:),actualgap(gapnum), SR_GeV);     % currently only correct for zero shift
                                    DeltaNuY = gap2tune(IDSector(gapnum,:),actualgap(gapnum), SR_GeV);
                                else
                                    DeltaNuX = -0.5*gap2tune(IDSector(gapnum,:),actualgap(gapnum), SR_GeV);     % this is an approximate fit to measured tune shift data
                                    DeltaNuY = gap2tune(IDSector(gapnum,:),actualgap(gapnum), SR_GeV);
                                end
                            elseif (IDSector(gapnum,1) == 7) && (IDSector(gapnum,2) == 2)
                                if (epumode == 0)
                                    DeltaNuX = interp2(gap72p',shift72p',dnux72p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap72p',shift72p',dnuy72p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                elseif (epumode == 1)
                                    DeltaNuX = interp2(gap72a',shift72a',dnux72a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap72a',shift72a',dnuy72a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                else
                                    DeltaNuX = 0;
                                    DeltaNuY = gap2tune(IDSector(gapnum,:),actualgap(gapnum), SR_GeV);
                                end
                            elseif (IDSector(gapnum,1) == 11) && (IDSector(gapnum,2) == 1)
                                if (epumode == 0)
                                    DeltaNuX = 20.9/13.65*interp2(gap111p',shift111p',dnux111p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap111p',shift111p',dnuy111p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                elseif (epumode == 1)
                                    DeltaNuX = 20.9/13.65*interp2(gap111a',shift111a',dnux111a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap111a',shift111a',dnuy111a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                else
                                    DeltaNuX = 0;
                                    DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
                                end
                            elseif (IDSector(gapnum,1) == 11) && (IDSector(gapnum,2) == 2)
                                if (epumode == 0)
                                    DeltaNuX = 20.9/13.65*interp2(gap112p',shift112p',dnux112p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap112p',shift112p',dnuy112p',actualgap(gapnum),Shift(gapnum),'linear',0);
                                elseif (epumode == 1)
                                    DeltaNuX = 20.9/13.65*1.25*interp2(gap112a',shift112a',dnux112a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                    DeltaNuY = interp2(gap112a',shift112a',dnuy112a',actualgap(gapnum),Shift(gapnum),'linear',0);
                                else
                                    DeltaNuX = 0;
                                    DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);   % variation of vertical tune shift with phase is small for EPUs
                                end
                            else
                                DeltaNuX = 0; % only EPUs assumed to cause shift of nuy (here inside EPU straights)
                                DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);
                            end
                            
                        else
                            DeltaNuX = 0; % only EPUs assumed to cause shift of nux (here outside EPU straights)
                            DeltaNuY = gap2tune(IDSector(gapnum,:), actualgap(gapnum), SR_GeV);
                        end
                        
                        DelQF = zeros(length(QFsp),1);
                        DelQD = zeros(length(QFsp),1); %%% why not use QDsp?
                        
                        fraccorr = 0.85*DeltaNuY ./ TuneW16Min; % original MAD sim for nuy corr done with specific ID -> now all corr normalized with that & fudge factor
                        
                        % Find which quads to change (local beta beating correction
                        % (horizontal for EPU, vertical otherwise)
                        QuadList = [IDSector(gapnum,1)-1 2; IDSector(gapnum,1) 1]; %US and DS quads
                        QuadElem = dev2elem('QF',QuadList); % in reality use QF and QD ... % resulting list of quads used for ID comp
                        
                        % global vertical tune correction
                        % 24 QF+ 24 QD
                        DeltaAmps = inv(SR_TUNE_MATRIX) * [(fraccorr*2.01e-4); fraccorr*(-0.039666)];    %  Fitting in MAD required MUX=16.180201, MUY=9.210334
                        
                        DelQF = DelQF + DeltaAmps(1,:); % summing local beating and global nuy corr
                        DelQD = DelQD + DeltaAmps(2,:);
                        
                        % local horizontal tune correction (is also nearly a beta beating correction) only nonzero for EPUs!
                        % 2 QF + 2 QD
                        DeltaAmpsLocal = 12*inv(SR_TUNE_MATRIX) * [-DeltaNuX;0];                     %  DelAmps =  [QF; QD];
                        DelQF(QuadElem) = DelQF(QuadElem)+DeltaAmpsLocal(1,1); % summing above corr and local nux corr
                        DelQD(QuadElem) = DelQD(QuadElem)+DeltaAmpsLocal(2,1);
                        
                        % nominal with global tunecorr
                        % KQDS1                                     -2.575071E+00
                        % KQFS1                                      2.317283E+00
                        % KQDAS1                                    -5.253899E-01
                        % KQFAS1                                     3.266732E+00
                        % KQD                                       -2.671221E+00
                        % KQF                                        2.306557E+00
                        % KQFA                                       3.219072E+00
                        
                        %% SPR3W,no super bend,
                        % KQD3W                                     -2.694874E+00
                        % KQD2W                                     -2.694874E+00
                        % KQF3W                                      2.309639E+00
                        % KQF2W                                      2.309639E+00
                        
                        %% SPRS3W, superbend at the upstream of the wiggler
                        % KQD3W                                     -2.694892E+00
                        % KQD2W                                     -2.598573E+00
                        % KQF3W                                      2.309654E+00
                        % KQF2W                                      2.320298E+00
                        
                        % local vertical beta beating correction (should be used together with above global tune correction)
                        % 2 QF + 2QD
                        if (IDSector(gapnum,1)==6) || (IDSector(gapnum,1)==7) || (IDSector(gapnum,1)==10) || (IDSector(gapnum,1)==11)
                            QFfac = ([2.309639/2.306557; 2.309639/2.306557]-1) * fraccorr;
                            QDfac = ([-2.6948741/-2.671221; -2.694874/-2.671221]-1) * fraccorr;
                        elseif (IDSector(gapnum,1)==5) || (IDSector(gapnum,1)==9)
                            QFfac = ([2.320298/2.317283; 2.309654/2.306557]-1) * fraccorr;
                            QDfac = ([-2.598573/-2.575071; -2.694892/-2.671221]-1) * fraccorr;
                        elseif (IDSector(gapnum,1)==4) || (IDSector(gapnum,1)==8) || (IDSector(gapnum,1)==12)
                            QFfac = ([2.309654/2.306557; 2.320298/2.317283]-1) * fraccorr;
                            QDfac = ([-2.694892/-2.671221; -2.598573/-2.575071]-1) * fraccorr;
                        else
                            QFfac = zeros(2,1);
                            QDfac = zeros(2,1);
                        end
                        
                        DelQF(QuadElem,:) = DelQF(QuadElem,:) + QFfac.*QFsp(QuadElem,:); % suming above corr with local betay corr (= corr factor * SP)
                        DelQD(QuadElem,:) = DelQD(QuadElem,:) + QDfac.*QDsp(QuadElem,:);
                        
                        % add all tune and beta beating corrections for this one ID to the summed up correction vectors for all IDs
                        addQFsp(:,gapnum) = DelQF;
                        addQDsp(:,gapnum) = DelQD;
                        
                        % Skew FF for IVID
                        if 0%(IDSector(gapnum,1)==6)
                            % scale=(gap2tune([6 1])/0.005)*0.1;
                            % KAC lattice does not have dispersion bump, so skew FF for IVID is not necessary
                            scale = 0;
                            [SQSFincr, SQSDincr] = set_etaywave_nux1618_nuy925_20skews_skewFF(scale);
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            % should add a limit check here %
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            setpv('SQSF', 'Setpoint', SQSFsp+SQSFincr, [], 0, 'Physics');
                            setpv('SQSD', 'Setpoint', SQSDsp+SQSDincr, [], 0, 'Physics');
                        end
                    end
                    
                    %                    addQFspvec= sum(addQFsp,2)+ staticOffset(1,:);
                    %                    addQDspvec= sum(addQDsp,2) + staticOffset(2,:);
                    
                    tuneFBAmps = inv(SR_TUNE_MATRIX) * [tuneFBdnux; tuneFBdnuy];    
                    addQFspvec= sum(addQFsp,2)+tuneFBAmps(1,1);
                    addQDspvec= sum(addQDsp,2)+tuneFBAmps(2,1);
                    %                     figure(2);
                    %                     subplot(2,1,1);
                    %                     bar(addQFspvec);
                    %                     subplot(2,1,2);
                    %                     bar(addQDspvec);
                    
                    % Set quadrupoles using main setpoint channels
                    setpv('QF', QFsp+addQFspvec,[], 0);
                    setpv('QD', QDsp+addQDspvec,[], 0);
                    % % Set quadrupoles using FF setpoint channels
                    % setpv('QF', 'FF', addQFspvec, [], 0);
                    % setpv('QD', 'FF', addQDspvec, [], 0);
                    
                    % Update .HIGH, .HIHI, .LOW, and .LOLO fields of power supply AM channels for alarm handler
                    write_alarms_srmags_qfqd(QFsp+addQFspvec,QDsp+addQDspvec);
                end
                
            else
                disp('  No tune FF algorithm for non-production modes yet ...');
                set(handles.CheckboxTune, 'Value', 1);
            end
        end
        
        ffdeltaquad_delay = toc;
        %         fprintf('tune FF delay = %.2f seconds\n',ffdeltaquad_delay);
        %         fprintf('Tune Done: %.2f \n',gettime-t00);
        
        % Output info to screen
        set(handles.SRCTRLStaticTextHorizontal,'String',sprintf('Horizontal RMS = %.4f mm',STDx),'ForegroundColor',[0 0 0]);
        set(handles.SRCTRLStaticTextVertical,'String',sprintf('Vertical RMS = %.4f mm',STDy),'ForegroundColor',[0 0 0]);
        
        %send message to Operator cell phone if FOFB has tripped off (i.e., gone to OFF or OPEN mode for any reason)
        FOFBStatus = getpvonline('SR01____FFBON__BM00','Double');
        
        if any(FOFBStatus~=1) && (FBloopIter>3)
            FOFBWarnNum = FOFBWarnNum + 1;
            % Send alphapage the first time FOFB trips then again at 10 minutes if it is still off (if FOFB checkbox is selected)
            if (FOFBWarnNum==1 || FOFBWarnNum==600) && get(handles.CheckboxFOFB,'Value') == 1
                fprintf('   Emailing FOFBstoppedmessage.txt to Operator Cellphone.\n');
                sendmail('5108120447@txt.att.net','ALERT','The FAST orbit feedback has STOPPED!!');
                % FOFB alarm handler
                soundtada
                fprintf('   %s: Fast Orbit Feedback has stopped!\n', datestr(now));
                setpvonline('Physics1',1);
            end
        else
            if FOFBWarnNum > 1
                fprintf('   %s: Fast Orbit Feedback is running again!\n', datestr(now));
                FOFBWarnNum=0;
            end
            setpvonline('Physics1',0);
        end
        
        %display status of FOFB on SRCONTROL GUI
        for loop = 1:size(FOFBStatus,2)
            if FOFBStatus(loop)==0
                FOFBStatusStr(loop,:) = 'OFF ';
            elseif FOFBStatus(loop)==1
                FOFBStatusStr(loop,:) = 'ON  ';
            elseif FOFBStatus(loop)==2
                FOFBStatusStr(loop,:) = 'OPEN';
            else
                FOFBStatusStr(loop,:) = 'BAD ';
            end
        end
        set(handles.SRCTRLStaticTextFOFB01,'String',sprintf('01 %s',FOFBStatusStr(1,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB02,'String',sprintf('02 %s',FOFBStatusStr(2,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB03,'String',sprintf('03 %s',FOFBStatusStr(3,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB04,'String',sprintf('04 %s',FOFBStatusStr(4,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB05,'String',sprintf('05 %s',FOFBStatusStr(5,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB06,'String',sprintf('06 %s',FOFBStatusStr(6,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB07,'String',sprintf('07 %s',FOFBStatusStr(7,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB08,'String',sprintf('08 %s',FOFBStatusStr(8,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB09,'String',sprintf('09 %s',FOFBStatusStr(9,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB10,'String',sprintf('10 %s',FOFBStatusStr(10,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB11,'String',sprintf('11 %s',FOFBStatusStr(11,:)),'ForegroundColor',[0 0 0]);
        %         set(handles.SRCTRLStaticTextFOFB12,'String',sprintf('12 %s',FOFBStatusStr(12,:)),'ForegroundColor',[0 0 0])
        
        % fprintf('End of feedback operations: %.2f \n\n',gettime-t00);
        
        % Wait for next update time or stop request
        while (gettime-t00) < LoopDelay
            %disp('interval could be shorter')
            pause(.05);
            % Check if GUI has been closed
            if isempty(gcbf)
                setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
                lasterr('SRCONTROL DISAPPEARED!');
                error('SRCONTROL DISAPPEARED!');
            end
            
            % Check if Stop button was pressed
            if getappdata(handles.SRCONTROL, 'FEEDBACK_FLAG') == 0
                % turn off then open FOFB loop (turnoff off to transfer correctors, then open to enable logging)
                if getpvonline('SR01____FFBON__BC00','Double')==1
                    fprintf('   Stopping Fast Orbit Feedback.\n');
                end
                setpv('SR01____FFBON__BC00',0);
                pause(0.5);
                setpv('SR01____FFBON__BC00',2);
                break;
            end
        end
        
        
        if getappdata(handles.SRCONTROL, 'FEEDBACK_FLAG') == 0
            % turn off then open FOFB loop (turnoff off to transfer correctors, then open to enable logging)
            if getpvonline('SR01____FFBON__BC00','Double')==1
                fprintf('   Stopping Fast Orbit Feedback.\n');
            end
            setpv('SR01____FFBON__BC00',0);
            pause(0.5);
            setpv('SR01____FFBON__BC00',2);
            break;
        end
        
        StartErrorTime = gettime;
        
    catch
        %    while 0
        fprintf('\n  %s \n',lasterr);
        
        % Quit if error exists for more than 20 seconds
        if gettime-StartErrorTime>20 || getappdata(handles.SRCONTROL, 'FEEDBACK_FLAG')==0
            fprintf('   %s: Orbit feedback stopped due to error condition. \n\n',datestr(now));
            
            %send alphapage to operator pager
            fprintf('   Emailing SOFBstoppedmessage.txt to Operator Cellphone.\n');
            sendmail('5108120447@txt.att.net','ALERT','The SLOW orbit feedback has STOPPED!!');
            setappdata(handles.SRCONTROL, 'FEEDBACK_FLAG', 0);
            
            setpv('SR_STATE', -5);
            [StateNumber, StateString] = getsrstate;
            if StateNumber >= 0
                set(handles.InfoText,'String',StateString,'ForegroundColor','b');
            else
                set(handles.InfoText,'String',StateString,'ForegroundColor','r');
            end
        else
            a = clock;
            fprintf('   Orbit feedback was paused due to error condition (%s %d:%d:%.0f). \n', date, a(4), a(5), a(6));
            fprintf('   Orbit feedback has automatically restarted and is running. \n\n');
        end
        
        if getappdata(handles.SRCONTROL, 'FEEDBACK_FLAG') == 0
            % turn off then open FOFB loop (turnoff off to transfer correctors, then open to enable logging)
            if getpvonline('SR01____FFBON__BC00','Double')==1
                fprintf('   Stopping Fast Orbit Feedback.\n');
            end
            setpv('SR01____FFBON__BC00',0);
            pause(0.5);
            setpv('SR01____FFBON__BC00',2);
            break;
        end
        
        if (LoopDelay>0)
            pause(LoopDelay);
        else
            pause(1);
        end
    end
    
    if getappdata(handles.SRCONTROL, 'FEEDBACK_FLAG')==0
        % Turn off then open FOFB loop (turnoff off to transfer correctors, then open to enable logging)
        if getpvonline('SR01____FFBON__BC00','Double')==1
            fprintf('   Stopping Fast Orbit Feedback.\n');
        end
        setpv('SR01____FFBON__BC00',0);
        pause(0.5);
        setpv('SR01____FFBON__BC00',2);
        break;
    end
    
    %fprintf('End of feedback loop: %f \n\n',gettime-t00);
    
    % This loop delays the turnon of Fast Feedback system
    if FBloopIter < 5
        FBloopIter = FBloopIter + 1;
    end
end  % End of feedback loop


% End feedback, reset all parameters
try
    % Enable buttons
    set(handles.TurnOn,               'Enable', 'on');
    set(handles.TurnOff,              'Enable', 'on');
    set(handles.HWInit,               'Enable', 'on');
    set(handles.FeedbackStart,        'Enable', 'on');
    set(handles.FeedbackStop,         'Enable', 'off');
    set(handles.Cycle,                'Enable', 'on');
%     set(handles.Injection,            'Enable', 'on');
    set(handles.Production,           'Enable', 'on');
    set(handles.OperationalMode,      'Enable', 'on');
    set(handles.CheckForProblems,     'Enable', 'on');
    set(handles.GoldenPage,           'Enable', 'on');
    set(handles.OrbitCorrection,      'Enable', 'on');
    set(handles.OrbitCorrection_Edit, 'Enable', 'on');
    set(handles.SOFB_Edit,            'Enable', 'on');
    set(handles.FOFB_Edit,            'Enable', 'on');
    %    set(handles.Close,                'Enable', 'on');
    
    set(handles.SRCTRLStaticTextHorizontal,'String',sprintf('Horizontal RMS = _____ mm'),'ForegroundColor',[0 0 0]);
    set(handles.SRCTRLStaticTextVertical,'String',sprintf('Vertical RMS = _____ mm'),'ForegroundColor',[0 0 0]);
    
    set(handles.SRCTRLStaticTextFOFB01,'String',sprintf('01 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB02,'String',sprintf('02 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB03,'String',sprintf('03 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB04,'String',sprintf('04 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB05,'String',sprintf('05 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB06,'String',sprintf('06 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB07,'String',sprintf('07 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB08,'String',sprintf('08 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB09,'String',sprintf('09 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB10,'String',sprintf('10 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB11,'String',sprintf('11 ____'),'ForegroundColor',[0 0 0]);
    %     set(handles.SRCTRLStaticTextFOFB12,'String',sprintf('12 ____'),'ForegroundColor',[0 0 0]);
catch
    fprintf('   %s \n',lasterr);
    % GUI must have been closed
end


% Reset Bergoz BPM time constant to whatever it was before feedback started
fprintf('   Bergoz BPM time constant set back to %.1f\n', BPMtimeconstantOFB);
%setbpmtimeconstant(BPMtimeconstantOFB);


a = clock;
fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    setpv('SR_STATE', 5.1);
    [StateNumber, StateString] = getsrstate;
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
    fprintf('   ******************************\n');
    fprintf('   **  Orbit Feedback Stopped  **\n');
    fprintf('   ******************************\n\n');
else
    [StateNumber, StateString] = getsrstate;
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
    fprintf('   ****************************************\n');
    fprintf('   **  Problem With Slow Orbit Feedback  **\n');
    fprintf('   ****************************************\n\n');
end




% --- Executes on button press in OrbitCorrection_Edit.
function OrbitCorrection_Edit_Callback(hObject, eventdata, handles)

Energy = getfamilydata('Energy');

% Get the main OCS structure for orbit correction
OCS           = get(handles.OrbitCorrection_Edit, 'Userdata');
LocalBumplist = get(handles.OrbitCorrection,      'Userdata');

% Convert to shorter variable names
BPMlist1 = OCS.OCSx.BPM.DeviceList;
HCMlist1 = OCS.OCSx.CM.DeviceList;
VCMlist1 = OCS.OCSy.CM.DeviceList;

% Loop to edit orbit correction parameters
h_EditFigure = figure;
EditFlag = 0;
while EditFlag ~= 7
    % Sensitivity matrix (include energy so that the BEND can be anywhere)
    Sx = getrespmat('BPMx', BPMlist1, 'HCM', HCMlist1, Energy);
    Sy = getrespmat('BPMy', BPMlist1, 'VCM', VCMlist1, Energy);
    
    % Check for missing response matrix data
    if any(any(isnan(Sx)))
        fprintf('   Warning: The horizontal response matrix is missing some data!\n');
        Sx(isnan(Sx)) = 0;
    end
    if any(any(isnan(Sy)))
        fprintf('   Warning: The vertical response matrix is missing some data!\n');
        Sy(isnan(Sy)) = 0;
    end
    
    % Build the OCS structures
    OCS.OCSx.BPM = getam('BPMx', BPMlist1, 'struct');
    OCS.OCSx.CM  = getsp('HCM',  HCMlist1, 'struct');
    OCS.OCSx.GoalOrbit = getgolden(OCS.OCSx.BPM, 'numeric');
    
    OCS.OCSy.BPM = getam('BPMy', BPMlist1, 'struct');
    OCS.OCSy.CM  = getsp('VCM',  VCMlist1, 'struct');
    OCS.OCSy.GoalOrbit = getgolden(OCS.OCSy.BPM, 'numeric');
    
    % Clear some variable so that they get recalculated in orbitcorrectionmethods
    OCS.OCSx.BPMWeight = [];
    OCS.OCSx.CMWeight  = [];
    OCS.OCSx.Eta = [];
    OCS.OCSx.Flags = {'GoldenDisp'};
    
    OCS.OCSy.BPMWeight = [];
    OCS.OCSy.CMWeight  = [];
    OCS.OCSy.Eta = [];
    OCS.OCSy.Flags = {};
    
    % Calculate the new orbit correction structure (just to get SVx & SVy)
    [OCS.OCSx, Sx, SVx, Ux, Vx] = orbitcorrectionmethods(OCS.OCSx, Sx);
    [OCS.OCSy, Sy, SVy, Uy, Vy] = orbitcorrectionmethods(OCS.OCSy, Sy);
    
    figure(h_EditFigure);
    subplot(2,1,1);
    semilogy(SVx,'b');
    hold on;
    semilogy(SVx(OCS.OCSx.SVDIndex),'xr');
    ylabel('Horizontal');
    title('Response Matrix Singular Values (Orbit Correction)');
    hold off;
    subplot(2,1,2);
    semilogy(SVy,'b');
    hold on;
    semilogy(SVy(OCS.OCSy.SVDIndex),'xr');
    xlabel('Singular Value Number');
    ylabel('Vertical');
    hold off;
    drawnow;
    
    % Edit menu
    if OCS.OCSx.FitRF
        EditFlag = menu('Change Orbit Correction Parameters?','Singular Values','HCM List','VCM List','BPM List',...
            'Remove RF Frequency (currently included)','Local Bump List','Continue');
    else
        EditFlag = menu('Change Orbit Correction Parameters?','Singular Values','HCM List','VCM List','BPM List',...
            'Include RF Frequency (currently not used)','Local Bump List','Continue');
    end
    
    if EditFlag == 1
        prompt={'Enter the horizontal E-vector numbers (Matlab vector format):','Enter the vertical E-vector numbers (Matlab vector format):'};
        def={sprintf('[%d:%d]',1,OCS.OCSx.SVDIndex(end)),sprintf('[%d:%d]',1,OCS.OCSy.SVDIndex(end))};
        titlestr='SVD Orbit Correction';
        lineNo=1;
        answer=inputdlg(prompt,titlestr,lineNo,def);
        if ~isempty(answer)
            XivecNew = fix(str2num(answer{1}));
            if isempty(XivecNew)
                fprintf('   Horizontal E-vector cannot be empty.  No change made.\n');
            else
                if any(XivecNew<=0) || max(XivecNew)>length(diag(SVx))
                    fprintf('   Singular value number most be between 1 & %d inclusively.  No change made.\n', length(diag(SVx)));
                else
                    OCS.OCSx.SVDIndex = XivecNew;
                end
            end
            YivecNew = fix(str2num(answer{2}));
            if isempty(YivecNew)
                fprintf('   Vertical E-vector cannot be empty.  No change made.\n');
            else
                if any(YivecNew<=0) || max(YivecNew)>length(diag(SVy))
                    fprintf('   Singular value number most be between 1 & %d inclusively.  No change made.\n', length(diag(SVy)));
                else
                    OCS.OCSy.SVDIndex = YivecNew;
                end
            end
        end
    end
    
    if EditFlag == 2
        List= family2dev('HCM', 0);
        CheckList = zeros(size(List,1),1);
        iDev = findrowindex(HCMlist1, List);
        CheckList(iDev) = 1;
        newList = editlist(List, 'HCM', CheckList);
        if isempty(newList)
            fprintf('   Horizontal corrector magnet list cannot be empty.  No change made.\n');
        else
            HCMlist1 = newList;
        end
    end
    
    if EditFlag == 3
        List= family2dev('VCM', 0);
        CheckList = zeros(size(List,1),1);
        iDev = findrowindex(VCMlist1, List);
        CheckList(iDev) = 1;
        newList = editlist(List, 'VCM', CheckList);
        if isempty(newList)
            fprintf('   Vertical corrector magnet cannot be empty.  No change made.\n');
        else
            VCMlist1 = newList;
        end
    end
    
    if EditFlag == 4
        %List = getbpmlist('Bergoz', 'IgnoreStatus');
        %List = getbpmlist('IgnoreStatus');
        List = getbpmlist;
        CheckList = zeros(size(List,1),1);
        iDev = findrowindex(BPMlist1, List);
        CheckList(iDev) = 1;
        newList = editlist(List, 'BPM', CheckList);
        if isempty(newList)
            fprintf('   BPM list cannot be empty.  No change made.\n');
        else
            BPMlist1 = newList;
        end
    end
    
    if EditFlag == 5
        % RF
        if OCS.OCSx.FitRF
            OCS.OCSx.FitRF = 0;
        else
            OCS.OCSx.FitRF = 1;
        end
    end
    
    if EditFlag == 6
        % Insertion devices
        List= family2dev('ID', 0);
        CheckList = zeros(size(List,1),1);
        iDev = findrowindex(LocalBumplist, List);
        CheckList(iDev) = 1;
        LocalBumplist = editlist(List, 'ID', CheckList);
    end
end
close(h_EditFigure);

% SaveMenu the changes
set(handles.OrbitCorrection_Edit, 'Userdata', OCS);
set(handles.OrbitCorrection,      'Userdata', LocalBumplist);




% --- Executes on button press in SOFB_Edit.
function SOFB_Edit_Callback(hObject, eventdata, handles)

Energy = getfamilydata('Energy');

% Get the main OCS structure for SOFB
OCS = get(handles.SOFB_Edit, 'Userdata');

% Convert to shorter variable names
BPMlist1 = OCS.OCSx.BPM.DeviceList;
HCMlist1 = OCS.OCSx.CM.DeviceList;
VCMlist1 = OCS.OCSy.CM.DeviceList;

% Loop to edit SOFB parameters
h_EditFigure = figure;
EditFlag = 0;
while EditFlag ~= 5
    % Sensitivity matrix (include energy so that the BEND can be anywhere)
    Sx = getrespmat('BPMx', BPMlist1, 'HCM', HCMlist1, Energy);
    Sy = getrespmat('BPMy', BPMlist1, 'VCM', VCMlist1, Energy);
    
    % Check for missing response matrix data
    if any(any(isnan(Sx)))
        fprintf('   Warning: The horizontal response matrix is missing some data!\n');
        Sx(isnan(Sx)) = 0;
    end
    if any(any(isnan(Sy)))
        fprintf('   Warning: The vertical response matrix is missing some data!\n');
        Sy(isnan(Sy)) = 0;
    end
    
    if get(handles.CheckboxRF,'Value') == 1
        OCS.OCSx.FitRF = 1;
    end
    
    % Build the OCS structures
    OCS.OCSx.BPM = getam('BPMx', BPMlist1, 'struct');
    OCS.OCSx.CM  = getsp('HCM',  HCMlist1, 'struct');
    OCS.OCSx.GoalOrbit = getgolden(OCS.OCSx.BPM, 'numeric');
    
    OCS.OCSy.BPM = getam('BPMy', BPMlist1, 'struct');
    OCS.OCSy.CM  = getsp('VCM',  VCMlist1, 'struct');
    OCS.OCSy.GoalOrbit = getgolden(OCS.OCSy.BPM, 'numeric');
    
    % Clear some variable so that they get recalculated in orbitcorrectionmethods
    OCS.OCSx.BPMWeight = [];
    OCS.OCSx.CMWeight  = [];
    OCS.OCSx.Eta = [];
    OCS.OCSx.Flags = {'GoldenDisp'};
    
    OCS.OCSy.BPMWeight = [];
    OCS.OCSy.CMWeight  = [];
    OCS.OCSy.Eta = [];
    OCS.OCSy.Flags = {};
    
    % Calculate the new orbit correction structure (just to get SVx & SVy)
    [OCS.OCSx, Sx, SVx, Ux, Vx] = orbitcorrectionmethods(OCS.OCSx, Sx);
    [OCS.OCSy, Sy, SVy, Uy, Vy] = orbitcorrectionmethods(OCS.OCSy, Sy);
    
    figure(h_EditFigure);
    subplot(2,1,1);
    semilogy(SVx,'b');
    hold on;
    semilogy(SVx(OCS.OCSx.SVDIndex),'xr');
    ylabel('Horizontal');
    title('Response Matrix Singular Values (Orbit Feedback)');
    hold off;
    subplot(2,1,2);
    semilogy(SVy,'b');
    hold on;
    semilogy(SVy(OCS.OCSy.SVDIndex),'xr');
    xlabel('Singular Value Number');
    ylabel('Vertical');
    hold off;
    drawnow;
    
    % Edit menu
    EditFlag = menu('Change Parameters?', 'Singular Values', 'HCM List', 'VCM List', 'BPM List', 'Continue');
    
    if EditFlag == 1
        prompt={'Enter the horizontal E-vector numbers (Matlab vector format):','Enter the vertical E-vector numbers (Matlab vector format):'};
        def={sprintf('[%d:%d]',1,OCS.OCSx.SVDIndex(end)),sprintf('[%d:%d]',1,OCS.OCSy.SVDIndex(end))};
        titlestr='SVD Orbit Feedback';
        lineNo=1;
        answer=inputdlg(prompt,titlestr,lineNo,def);
        if ~isempty(answer)
            XivecNew = fix(str2num(answer{1}));
            if isempty(XivecNew)
                fprintf('   Horizontal E-vector cannot be empty.  No change made.\n');
            else
                if any(XivecNew<=0) || max(XivecNew)>length(diag(SVx))
                    fprintf('   Singular value number most be between 1 & %d inclusively.  No change made.\n', length(diag(SVx)));
                else
                    OCS.OCSx.SVDIndex = XivecNew;
                end
            end
            YivecNew = fix(str2num(answer{2}));
            if isempty(YivecNew)
                fprintf('   Vertical E-vector cannot be empty.  No change made.\n');
            else
                if any(YivecNew<=0) || max(YivecNew)>length(diag(SVy))
                    fprintf('   Singular value number most be between 1 & %d inclusively.  No change made.\n', length(diag(SVy)));
                else
                    OCS.OCSy.SVDIndex = YivecNew;
                end
            end
        end
    end
    
    if EditFlag == 2
        List= family2dev('HCM', 'Trim', 0);
        CheckList = zeros(size(List,1),1);
        iDev = findrowindex(HCMlist1, List);
        CheckList(iDev) = 1;
        newList = editlist(List, 'HCMtrim', CheckList);
        if isempty(newList)
            fprintf('   Horizontal corrector magnet list cannot be empty.  No change made.\n');
        else
            HCMlist1 = newList;
        end
    end
    
    if EditFlag == 3
        List= family2dev('VCM', 'Trim', 0);
        CheckList = zeros(size(List,1),1);
        iDev = findrowindex(VCMlist1, List);
        CheckList(iDev) = 1;
        newList = editlist(List, 'VCMtrim', CheckList);
        if isempty(newList)
            fprintf('   Vertical corrector magnet list cannot be empty.  No change made.\n');
        else
            VCMlist1 = newList;
        end
    end
    
    if EditFlag == 4
        %List = getbpmlist('Bergoz', 'IgnoreStatus');
        %List = getbpmlist('IgnoreStatus');
        List = getbpmlist;
        CheckList = zeros(size(List,1),1);
        iDev = findrowindex(BPMlist1, List);
        CheckList(iDev) = 1;
        newList = editlist(List, 'BPM', CheckList);
        if isempty(newList)
            fprintf('   BPM list cannot be empty.  No change made.\n');
        else
            BPMlist1 = newList;
        end
    end
    
    %if EditFlag == 5
    %    OCS.FFTypeFlag = questdlg(sprintf('Do you want to use a fully local or a combined local/global compensation of IDs? (nuy=9.2 only)'),'Tune FF','Local','Global', 'Global');
    %    if strcmp(OCS.FFTypeFlag,'Local')
    %        disp(['   The tune FF will use 8 local quadrupoles to compensate beta beating and tune shift']);
    %        disp(['   from each ID.']);
    %    elseif strcmp(OCS.FFTypeFlag,'Global')
    %        disp(['   The tune FF will use 4 local quadrupoles to compensate beta beating and all QF+QD']);
    %        disp(['   to compensate tune shift from each ID.']);
    %    end
    %end
end
close(h_EditFigure);

% SaveMenu the changes
set(handles.SOFB_Edit, 'Userdata', OCS);




% --- Executes on button press in FOFB_Edit.
function FOFB_Edit_Callback(hObject, eventdata, handles)

% Get vectors
FOFB = get(handles.FOFB_Edit, 'Userdata');
FOFBFreq = FOFB.FOFBFreq;
HorP  = FOFB.HorP;
HorI  = FOFB.HorI;
HorD  = FOFB.HorD;
VertP = FOFB.VertP;
VertI = FOFB.VertI;
VertD = FOFB.VertD;

% Add button to change #ivectors, CMs, IDBPMs,
EditFlag = 0;
while EditFlag ~= 3
    %EditFlag = menu('Change Parameters?', 'Fast Feedback Frequency', 'PID Values', 'HCM List', 'VCM List', ...
    %   'IDBPM List', 'BBPM List', 'Continue');
    % Use menu below until other FFB config routines work (then also uncomment options 3,4,5,6 below)
    EditFlag = menu('Change Parameters?', 'Fast Feedback Frequency', 'PID Values', 'Continue');
    
    if EditFlag == 1
        % Data rate change
        prompt={'Enter the desired Fast Feedback Frequency (1-1000 Hz)'};
        def={num2str(FOFBFreq)};
        titlestr='Fast Feedback Setup';
        lineNo=1;
        answer=inputdlg(prompt,titlestr,lineNo,def);
        if ~isempty(answer)
            FOFBFreq = fix(str2num(answer{1}));
            if isempty(FOFBFreq)
                disp('   Frequency value cannot be empty.  No change made.');
                FOFBFreq = getsp('SR01____FFBFREQAC00');
            else
                if FOFBFreq < 1 || FOFBFreq > 1000
                    disp('   Frequency must be between 1 and 1000 Hz.  No change made.');
                    FOFBFreq = getsp('SR01____FFBFREQAC00');
                end
            end
            setsp('SR01____FFBFREQAC00',FOFBFreq   ); % change freq
            pause(0.5);
            fprintf('   Fast orbit feedback frequency is running at %.0f Hz.\n', getpvonline('SR01____FFBFREQAM00','Double'));
        else
            FOFBFreq = getsp('SR01____FFBFREQAC00');
        end
    end
    
    if EditFlag == 2
        % edit  PIDs
        % User defaults are set in initialization routine elsewhere in this
        % code (FOFB_Init)
        prompt={'P horizontal', 'I horizontal', 'D horizontal', 'P vertical', 'I vertical', 'D vertical'};
        def={num2str(HorP), num2str(HorI), num2str(HorD), num2str(VertP), num2str(VertI), num2str(VertD)};
        titlestr='Fast Feedback PID Setup';
        lineNo=1;
        answer=inputdlg(prompt,titlestr,lineNo,def);
        if ~isempty(answer)
            HorPnewnum = str2num(answer{1});
            if isempty(HorPnewnum)
                disp('   HorP value cannot be empty.  No change made.');
            else
                HorP = HorPnewnum;
            end
            HorInewnum = str2num(answer{2});
            if isempty(HorInewnum)
                disp('   HorI value cannot be empty.  No change made.');
            else
                HorI = HorInewnum;
            end
            HorDnewnum = str2num(answer{3});
            if isempty(HorDnewnum)
                disp('   HorD value cannot be empty.  No change made.');
            else
                HorD = HorDnewnum;
            end
            VertPnewnum = str2num(answer{4});
            if isempty(VertPnewnum)
                disp('   VertP value cannot be empty.  No change made.');
            else
                VertP = VertPnewnum;
            end
            VertInewnum = str2num(answer{5});
            if isempty(VertInewnum)
                disp('   VertI value cannot be empty.  No change made.');
            else
                VertI = VertInewnum;
            end
            VertDnewnum = str2num(answer{6});
            if isempty(VertDnewnum)
                disp('   VertD value cannot be empty.  No change made.');
            else
                VertD = VertDnewnum;
            end
            
            try
                write_pid_ffb2_patch(HorP, HorI, HorD, VertP, VertI, VertD);
                fprintf('   Setting FFB gains to Horizontal P=%.2f, I=%.1f, D=%.4f;  Vertical P=%.2f, I=%.1f, D=%.4f\n', HorP, HorI, HorD, VertP, VertI, VertD);
            catch
                fprintf('   %s \n',lasterr);
                disp('   Trouble setting Fast Orbit Feedback parameters!');
            end
        end
    end
    
    %if EditFlag == 3
    %   disp('   This function not yet available.');
    %   % change HCM List
    %end
    %
    %if EditFlag == 4
    %   disp('   This function not yet available.');
    %   % change VCM List
    %end
    %
    %if EditFlag == 5
    %   disp('   This function not yet available.');
    %   % change IDBPM List
    %end
    %
    %if EditFlag == 6
    %   disp('   This function not yet available.');
    %   % change BBPM List
    %end
end

% SaveMenu vectors
FOFB.FOFBFreq = FOFBFreq;
FOFB.HorP = HorP;
FOFB.HorI = HorI;
FOFB.HorD = HorD;
FOFB.VertP = VertP;
FOFB.VertI = VertI;
FOFB.VertD = VertD;

set(handles.FOFB_Edit, 'Userdata', FOFB);



% --- Executes on button press in CheckboxSOFB.
function CheckboxSOFB_Callback(hObject, eventdata, handles)

% --- Executes on button press in CheckboxFOFB.
function CheckboxFOFB_Callback(hObject, eventdata, handles)

% --- Executes on button press in CheckboxTune.
function CheckboxTune_Callback(hObject, eventdata, handles)

% --- Executes on button press in CheckboxRF.
function CheckboxRF_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkboxtunefb.
function CheckboxTuneFB_Callback(hObject, eventdata, handles)

% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
close(gcbf);

% --- Outputs from this function are returned to the command line.
function varargout = srcontrol_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function PseudoSingleBunch_Callback(hObject, eventdata, handles)

if strcmpi(get(hObject,'Checked'),'On')
    set(hObject,'Checked','Off');
    setfamilydata('Off', 'PseudoSingleBunch');
    setpv('Physics10',3);    % Before 2014-01-27 was 2 - i.e. 1:296, 318;, now set to 3, i.e. 1:296, 308. Affects topoff, hwinit (bclean), ...
else
    set(hObject,'Checked','On');
    setfamilydata('On', 'PseudoSingleBunch');
    setpv('Physics10',1);
end


% --------------------------------------------------------------------
function BCM_Set_Callback(hObject, eventdata, handles)
setbcm;


% --------------------------------------------------------------------
function CheckCaenSR_Callback(hObject, eventdata, handles)

checkcaen('SR');
fprintf('   Caen SR 20A check complete.\n\n');

% --------------------------------------------------------------------
function InitCaenSR_Callback(hObject, eventdata, handles)
try
    setcaen('Init SR', '');
    %fprintf('   Caen SR 20A initializion complete.\n\n');
catch
    fprintf(2, '%s\n\n', lasterr);
    fprintf(2, 'Problem when initializing a Caen power supply.\n\n');
end


% --------------------------------------------------------------------
function CheckCaenSR60_Callback(hObject, eventdata, handles)
checkcaen('SR60');
fprintf('   Caen SR 60A check complete.\n\n');

% --------------------------------------------------------------------
function InitCaenSR60_Callback(hObject, eventdata, handles)
try
    setcaen('Init SR60', '');
    %fprintf('   Caen SR 60A initializion complete.\n\n');
catch
    fprintf(2, '%s\n\n', lasterr);
    fprintf(2, 'Problem when initializing a Caen power supply.\n\n');
end


% --------------------------------------------------------------------
function BPMInit_Callback(hObject, eventdata, handles)
bpminit;
fprintf('   BPM Init Complete (srcontrol)\n');


% --------------------------------------------------------------------
function ccinit_Callback(hObject, eventdata, handles)
cellcontrollerinit;
fprintf('   Cell Controller Init Complete (srcontrol)\n');
