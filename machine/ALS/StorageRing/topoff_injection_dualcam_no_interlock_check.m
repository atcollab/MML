function varargout = topoff_injection_dualcam(varargin)
%TOPOFF_INJECTION_DUALCAM M-file for topoff_injection_dualcam.fig
%      TOPOFF_INJECTION_DUALCAM, by itself, creates a new TOPOFF_INJECTION_DUALCAM or raises the existing
%      singleton*.
%
%      H = TOPOFF_INJECTION_DUALCAM returns the handle to a new TOPOFF_INJECTION_DUALCAM or the handle to
%      the existing singleton*.
%
%      TOPOFF_INJECTION_DUALCAM('Property','Value',...) creates a new TOPOFF_INJECTION_DUALCAM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to TOPOFF_INJECTION_DUALCAM_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TOPOFF_INJECTION_DUALCAM('CALLBACK') and TOPOFF_INJECTION_DUALCAM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TOPOFF_INJECTION_DUALCAM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help
% topoff_injection_dualcam

% Revision History:
%
% 2012-12-17 Christoph Steier
% Adjusted extraction wait delays and moved some trigger disable commands to avoid double injector shots that
% happen occasionally due to network delay and can get lost at high energy in the booster.

% Last Modified by GUIDE v2.5 04-Oct-2010 15:24:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @topoff_injection_dualcam_OpeningFcn, ...
    'gui_OutputFcn',  @topoff_injection_dualcam_OutputFcn, ...
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
%#function goldenpage, setoperationalmode

% --- Executes just before topoff_injection_dualcam is made visible.

function topoff_injection_dualcam_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)


% Choose default command line output for topoff_injection_dualcam
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes topoff_injection_dualcam wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% Location on Screen (GP add 9/2009 for)
ScreenDefault = get(0, 'Units');
AppDefault = get(hObject, 'Units');

set(0, 'Units', 'Pixels');
set(hObject, 'Units', 'Pixels');

ScreenSize = get(0, 'ScreenSize');
AppSize = get(hObject, 'Position');

% Set the application location
SRControlHeight = 780;
set(hObject, 'Position', [20 (ScreenSize(4)-AppSize(4)-SRControlHeight-30) AppSize(3) AppSize(4)]);

set(0, 'Units', ScreenDefault);
set(hObject, 'Units', AppDefault);


% ALS Initialization Below

% Check if the AO exists
checkforao;

% Initialize
lcaSetTimeout(0.6);
lcaSetRetryCount(5);

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.CheckboxCAM, 'Value', 0);
    set(handles.CheckboxBunchCurrentEqualizer, 'Value', 0);         % New bunch current equalizer that fills low current buckets disabled in two bunch
    set(handles.CheckboxCleaning, 'Value', 1);
    set(handles.FillCamBuckets,              'Enable', 'off');
    set(handles.EqualizeFill,              'Enable', 'off');
else
    set(handles.CheckboxCAM, 'Value', 1);
    set(handles.CheckboxBunchCurrentEqualizer, 'Value', 1);          % New bunch current equalizer that fills low current buckets is now default in multibunch modes.
    set(handles.CheckboxCleaning, 'Value', 1);
end

set(handles.TopOffStaticTextMode,'String',sprintf(' %s',getfamilydata('OperationalMode')),'ForegroundColor',[0 0 0]);
set(handles.TopOffStaticTextModeCAM,'String',sprintf(' '),'ForegroundColor',[0 0 0]);

set(handles.CheckboxLINAC, 'Value', 0);

set(handles.CheckboxBooster, 'Value', 0);

set(handles.CheckboxBTS, 'Value', 0);

set(handles.CheckboxParasite, 'Value', 0);

setappdata(handles.TOPOFF, 'TOPOFF_FLAG', 0);

set(handles.TopOffStop,              'Enable', 'off');

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.FillCamBuckets, 'Enable', 'off');
    set(handles.CheckboxCAM, 'Enable', 'off');
    set(handles.CheckboxBunchCurrentEqualizer, 'Enable', 'off');    % New bunch current equalizer that fills low current buckets disabled in two bunch
else
    set(handles.FillCamBuckets, 'Enable', 'on');
    set(handles.CheckboxCAM, 'Enable', 'on');
    set(handles.CheckboxBunchCurrentEqualizer, 'Enable', 'on');     % New bunch current equalizer can be enabled by user in multibunch mode
end

global start_inj_trig start_inj_trig_mrf startbias cam_bucket % start_rf_gain 

% Recheck the fill pattern if Physics10 changed
[fill_pattern, cam_bucket, gunwidth] = fillpattern_local;

measured_inj_field_trig=getpv('TimInjFieldCounterFiltd');
if abs(measured_inj_field_trig-5000)<500
    disp('Setting old (unused) injection field trigger [Gauss clock] to match actual injection field (as measured by new timing system)');
    setpv('BR1_____TIMING_AC00',measured_inj_field_trig);
end

measured_ext_field_trig=getpv('TimExtrFieldCounterFiltd');
if abs(measured_ext_field_trig-294300)<2000
    disp('Setting old (unused) extraction field trigger [Gauss clock] to match actual extraction field (as measured by new timing system)');
    setpv('BR1_____TIMING_AC04',measured_ext_field_trig);
end

pause(1);

start_inj_trig=getpv('BR1_____TIMING_AM00');
if abs(start_inj_trig-5000)>1000
    start_inj_trig=5000;
end

start_inj_trig_mrf=getpv('GaussClockInjectionFieldTrigger');
if abs(start_inj_trig_mrf-1.862e6)>3.724e5
    start_inj_trig_mrf=1.862e6;
end

% start_rf_gain=getpv('BR4_____XMIT___GNAC01');
% if (start_rf_gain < 0.2) || (start_rf_gain>0.75)
%     start_rf_gain=0.745;
% end

startbias = 30;


    
function [fill_pattern, cam_bucket, gunwidth] = fillpattern_local

% Gunwidth for 4 gun bunches in ns
gunwidth = 36;

% Use this for dual cam buckets
PseudoSingleBunch = getpv('Physics10');  %getfamilydata('PseudoSingleBunch');
if PseudoSingleBunch==1    % ~isempty(PseudoSingleBunch) && strcmpi(PseudoSingleBunch,'On')
    % Camshaft kicker mode
    fprintf(2, '   NOTE:  special camshaft kicker topoff mode.  Single cam mode!\n');
    cam_bucket = 318;        % target bucket for camshaft bunch (1-328)
    fill_pattern = [ ...
        9:16:(272-12) 10:16:(272-12) 11:16:(272-12) 12:16:(272-12) ...
        1:16:(272-12) 2:16:(272-12) 3:16:(272-12) 4:16:(272-12)]+16;   % 17 to 276 targeted, 17 to 288 actual (0, 4, 8, 12), MB fill pattern
    %     fill_pattern = [ ...
    %         9:16:(272-12) 10:16:(272-12) 11:16:(272-12) 12:16:(272-12) ...
    %         1:16:(272-12) 2:16:(272-12) 3:16:(272-12) 4:16:(272-12)]+16+10;   % 27 to 286 targeted, 27 to 298 actual (0, 4, 8, 12), MB fill pattern
elseif PseudoSingleBunch==2    % ~isempty(PseudoSingleBunch) && strcmpi(PseudoSingleBunch,'On')
    % fprintf(2, '   NOTE:  special topoff mode.  Single cam mode for BL 11.0.2!\n');
    %Single cam bucket
    cam_bucket = 318;        % target bucket for camshaft bunch (1-328)
    %   cam_bucket = 292;        % target bucket for camshaft bunch (1-328)
    fill_pattern = [ ...
        9:16:(302-16) 10:16:(302-16) 11:16:(302-16) 12:16:(302-16) ...
        1:16:(302-16) 2:16:(302-16) 3:16:(302-16) 4:16:(302-16) ...
        ];     % single camshaft MB pattern, gap same length as dual cam
elseif PseudoSingleBunch==3    % ~isempty(PseudoSingleBunch) && strcmpi(PseudoSingleBunch,'On')
    % fprintf(2, '   NOTE:  special topoff mode.  Single cam mode for BL 11.0.2!\n');
    %Single cam bucket
    cam_bucket = 308;        % target bucket for camshaft bunch (1-328)
    %   cam_bucket = 292;        % target bucket for camshaft bunch (1-328)
    fill_pattern = [ ...
        9:16:(302-16) 10:16:(302-16) 11:16:(302-16) 12:16:(302-16) ...
        1:16:(302-16) 2:16:(302-16) 3:16:(302-16) 4:16:(302-16) ...
        ];     % single camshaft MB pattern, gap same length as dual cam
else
    %Dual cam
    cam_bucket = [150 318];        % target bucket for camshaft bunch (1-328)
    %   cam_bucket = 292;        % target bucket for camshaft bunch (1-328)
    fill_pattern = [ ...
        9:16:(128-12) 167:16:(302-12) 10:16:(128-12) 168:16:(302-12) 11:16:(128-12) 169:16:(302-12) 12:16:(128-12) 170:16:(302-12) ...
        1:16:(128-12) 159:16:(302-12) 2:16:(128-12) 160:16:(302-12) 3:16:(128-12) 161:16:(302-12) 4:16:(128-12) 162:16:(302-12) ...
        ];     % dual camshaft MB pattern
    %   fill_pattern = [ ...
    %       9:16:(256-12) 10:16:(256-12) 11:16:(256-12) 12:16:(256-12) ...
    %       1:16:(256-12) 2:16:(256-12) 3:16:(256-12) 4:16:(256-12)];     % 256 bunch, 4 gun bunches, MB fill pattern
end

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    fill_pattern = [154 318];
    cam_bucket = [154 318];        % target bucket for camshaft bunch - not really used in two bunch mode
    gunwidth = 12;
end


% --- Executes on button press in TopOffStop.
function TopOffStop_Callback(~, ~, handles)
setappdata(handles.TOPOFF, 'TOPOFF_FLAG', 0);



% --- Executes on button press in TopOffStart.
function TopOffStart_Callback(~, ~, handles)

setappdata(handles.TOPOFF, 'TOPOFF_FLAG', 1);

StartFlag = questdlg('Is it OK to start top off?','Top Off','Yes','No','No');
drawnow;
if strcmp(StartFlag,'No')

    a = clock;
    fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
    fprintf('   ********************\n');
    fprintf('   **  Top Off Exit  **\n');
    fprintf('   ********************\n\n');
    pause(0);
    return
end

minimumdt = 10;          % minimum time between injectiions [s]
% actual time between injections is 2 seconds longer
minimumeff = 0.4;        % injection efficiency at which alarm happens (fraction of 1.0)
goalcurr = getpv('Topoff_goal_current_SP');          % current to keep [mA]
if (goalcurr>500) || (goalcurr<17)
    goalcurr=500;
    setpv('Topoff_goal_current_SP',goalcurr);
end
goalcurr_cam = getpv('Topoff_cam_goal_current_SP');        % target current for cam_bucket [mA]
if (goalcurr_cam>6) || (goalcurr_cam<1)
    goalcurr_cam=4;
    setpv('Topoff_cam_goal_current_SP',goalcurr_cam);
end
max_cam_freq = 6;    % cam bucket is not targeted more often than every (6+1)=7th shot

global start_inj_trig start_inj_trig_mrf startbias cam_bucket % start_rf_gain

% Recheck the fill pattern if Physics10 changed
[fill_pattern, cam_bucket, gunwidth] = fillpattern_local;

% Bunch current equalizer needs unique list of multibunch buckets
if length(fill_pattern)>10
    bucketlist = unique([fill_pattern fill_pattern+4 fill_pattern+8 fill_pattern+12]);  % Taking into account that multibunch fill is with 4 gun bunches
else
    bucketlist = unique(fill_pattern);
end

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    goalcurr = getpv('Topoff_goal_current_SP');          % current to keep [mA]
    if (goalcurr>40) || (goalcurr<17)
        goalcurr=35;
        setpv('Topoff_goal_current_SP',goalcurr);
    end
end

set(handles.TopOffStaticTextMode,'String',sprintf(' %s, Goal Current = %d mA',getfamilydata('OperationalMode'),goalcurr),'ForegroundColor',[0 0 0]);

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.TopOffStaticTextModeCAM,'String',sprintf(' '),'ForegroundColor',[0 0 0]);
else
    set(handles.TopOffStaticTextModeCAM,'String',sprintf(' CAM Goal Current = %.1f mA',goalcurr_cam),'ForegroundColor',[0 0 0]);
end

% startbias=getpv('EG______BIAS___AC01');
startbias = 30;
if startbias>50
    startbias=30;
end

start_inj_trig=getpv('BR1_____TIMING_AM00');
if abs(start_inj_trig-5000)>1000
    start_inj_trig=5000;
end

start_inj_trig_mrf=getpv('GaussClockInjectionFieldTrigger');
if abs(start_inj_trig_mrf-1.862e6)>3.724e5
    start_inj_trig_mrf=1.862e6;
end

% start_rf_gain=getpv('BR4_____XMIT___GNAC01');

fprintf('\n\n');
fprintf('Disabling injection triggers and booster beam ...\n');
enable_disable_triggers(0);
pause(2);

fprintf('Opening LTB TV6 paddle (if not already open) ...\n');
setpv('LTB_____TV6____BC19',0);
pause(1);

% Switching bucket loading from table mode to direct bucket control
fprintf('Bucket loading is controlled directly by this program\n');
setpv('SR01C___TIMING_AC11',0);
setpv('SR01C___TIMING_AC13',0);

tmpindex=find(fill_pattern==getpv('SR01C___TIMING_AC08'));
if ~isempty(tmpindex)
    bunch_index=tmpindex(1);
else
    bunch_index=1;
end

% pre-initialize all local variables that might be displayed/used before being
% assigned a value below
cam_counter=0;last_cam_index=1;
inj_single=0;
paddle_index=0;
booster_counter=0;
bts_counter=0;
cleaning_counter=0;
tv1pos=0;tv3pos=0;tv4pos=0;tv5pos=0;tv6pos=0;
btstv1pos=0;btstv2pos=0;btstv3pos=0;btstv4pos=0;btstv5pos=0;btstv6pos=0;
br1tv1pos=0;br1tv2pos=0;br1tv3pos=0;br3tv1pos=0;br4tv1pos=0;
next_bucket=1;
eff2=0; inj_rate = 0;

setpv('SR01C___TIMING_AC08',fill_pattern(bunch_index));

fprintf('Setting gun width to %d ns\n',gunwidth);
setpv('GTL_____TIMING_AC02',gunwidth+1);
pause(2);
setpv('GTL_____TIMING_AC02',gunwidth);

pause(0.5);

% Disable buttons
set(handles.TopOffStart,                'Enable', 'off');
set(handles.EditParams,                'Enable', 'off');
set(handles.TopOffStop,              'Enable', 'on');
set(handles.FillCamBuckets,              'Enable', 'off');

drawnow;

[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
end

t1 = 0;  % variable used to check whether EPICS timestamp of beam current is stale
WarnNum=0; % loop variable to avoid sendingt an alarm on every cycle

%%%%%%%%%%%%%%%%%%%%%%%
% Start TO Loop %
%%%%%%%%%%%%%%%%%%%%%%%

while 1
    try
        set(handles.TopOffStaticTextBucket,  'String',sprintf('Bucket = %d',getpv('SR01C___TIMING_AM08')),'ForegroundColor',[0 0 0]);
        set(handles.TopOffStaticTextGunWidth,'String',sprintf('Gun Width = %d ns',getpv('GTL_____TIMING_AC02')),'ForegroundColor',[0 0 0]);
        [StateNumber, StateString] = getsrstate;
        if StateNumber >= 0
            set(handles.InfoText,'String',StateString,'ForegroundColor','b');
        else
            set(handles.InfoText,'String',StateString,'ForegroundColor','r');
        end
        drawnow;

        if getappdata(handles.TOPOFF, 'TOPOFF_FLAG') == 0
            % Stop TopOff and clean up
            break
        end
        [startcurr,tout,t2,errnum]=getdcct; curr_meas_time = gettime; startcurr2=1000*getpvonline('SR05W___DCCT2__AM01');
        startcam1=getcamcurrent_local('Cam1_current');
        startcam2=getcamcurrent_local('Cam2_current');

        if (t2==t1)
            WarnNum=WarnNum+1;
            % Send alphapage to operator pager the first time then after 20 injections
            if (WarnNum==1 || WarnNum==20)
                sendmail('5108120447@txt.att.net','ALERT',' DCCT data is stale!!');
                if (WarnNum==20)
                    WarnNum=0;
                end
            end
            soundquestion_nobits;
            fprintf('DCCT timestamp is stale - this could be a network or controls problem\n');
            fprintf('Current = %g mA, tout = %g s, DataTime = %s, errorcode = %d\n',startcurr,tout,datestr(t2),errnum);
            warning('topoff_injection_dualcam:getdcct','You should confirm that DCCT is still working. If it is truly stopped, stop topoff until it is fixed.');
        end

        if (startcurr<(16))
            fprintf('Beam current is below interlock threshold!\n');
            %            exit_cleanup;      % exit cleanup will already be called below
            fprintf('Stopping top-off injection!\n');
            soundquestion_nobits;
            break;
%         elseif (getpv('ETI_SR_INJ_MODE_DBNCA')~=1) || (getpv('ETI_SR_INJ_MODE_DBNCB')~=1) || (getpv('ETI_TOP_OFF_MODE_DBNCA')~=1)  || (getpv('ETI_TOP_OFF_MODE_DBNCB')~=1)
%             fprintf('Top-off Interlock has tripped (Top-off Mode or Inj Mode went to zero in readback from ETI chassis)!\n');
%             %            exit_cleanup;      % exit cleanup will already be called below
%             fprintf('Stopping top-off injection!\n');
%             soundquestion_nobits;
%             break;
%         elseif (getpv('ETI_SR_ENERGY_MATCH_LATCHA')~=1) || (getpv('ETI_SR_ENERGY_MATCH_LATCHB')~=1)
%             fprintf('Top-off Interlock has tripped (Energy Match Interlock)!\n');
%             %            exit_cleanup;      % exit cleanup will already be called below
%             fprintf('Stopping top-off injection!\n');
%             soundquestion_nobits;
%             break;
%         elseif (getpv('ETI_SR_LATTICE_MATCH_LATCHA')~=1) || (getpv('ETI_SR_LATTICE_MATCH_LATCHB')~=1)
%             fprintf('Top-off Interlock has tripped (Lattice Match Interlock)!\n');
%             %            exit_cleanup;      % exit cleanup will already be called below
%             fprintf('Stopping top-off injection!\n');
%             soundquestion_nobits;
%             break;
% The following lines are currently commented out, since there has been a readback problem of the topoff interlock - however, the functionality of stopping topoff
% is still provided buy the getdcct < 16 mA check above
%         elseif (getpv('ETI_SR_BEAM_I_LATCHA')~=1) || (getpv('ETI_SR_BEAM_I_LATCHB')~=1)
%             fprintf('Top-off Interlock has tripped (Beam Current Interlock)!\n');
%             %            exit_cleanup;      % exit cleanup will already be called below
%             fprintf('Stopping top-off injection!\n');
%             soundquestion_nobits;
%             break;
        elseif (getpv('SRBeam_Mag_I_MonA')>505)
            fprintf('Topoff beam current interlock channel A reports current > 505 mA!\n');
            %            exit_cleanup;      % exit cleanup will already be called below
            fprintf('Stopping top-off injection!\n');
            soundquestion_nobits;
            break;
        elseif (startcurr<goalcurr)
            t1=t2;
            if ~inj_single
                start_inj_trig=getpv('BR1_____TIMING_AM00');
                start_inj_trig_mrf=getpv('GaussClockInjectionFieldTrigger');
            end
            if (get(handles.CheckboxLINAC, 'Value')== 1)
                paddle_index=paddle_index+1;
                tv1pos=getpv('LTB_____TV1____BC16');
                tv3pos=getpv('LTB_____TV3____BC16');
                tv4pos=getpv('LTB_____TV4____BC18');
                tv5pos=getpv('LTB_____TV5____BC16');
                tv6pos=getpv('LTB_____TV6____BC19');
                fprintf('Pulling LTB paddles for top-off injection (if not already open)\n');
                % setpv('BR4_____XMIT___GNAC01',start_rf_gain);
                setpv('LTB_____TV1____BC16',0);
                setpv('LTB_____TV3____BC16',0);
                setpv('LTB_____TV4____BC18',0);
                setpv('LTB_____TV5____BC16',0);
                setpv('LTB_____TV6____BC19',0);
                %                pause(2);
            end
            if (get(handles.CheckboxBooster, 'Value')== 1)
                booster_counter=booster_counter+1;
                br1tv1pos=getpv('BR1_____TV1____BC18');
                br1tv2pos=getpv('BR1_____TV2____BC16');
                br1tv3pos=getpv('BR1_____TV3____BC18');
                br3tv1pos=getpv('BR3_____TV1____BC16');
                br4tv1pos=getpv('BR4_____TV1____BC16');
                fprintf('Pulling Booster paddles for top-off injection (if not already open)\n');
                setpv('BR1_____TV1____BC18',0);
                setpv('BR1_____TV2____BC16',0);
                setpv('BR1_____TV3____BC18',0);
                setpv('BR3_____TV1____BC16',0);
                setpv('BR4_____TV1____BC16',0);
                %               pause(2);
            end
            if (get(handles.CheckboxBTS, 'Value')== 1)
                bts_counter=bts_counter+1;
                btstv1pos=getpv('BTS_____TV1____BC16');
                btstv2pos=getpv('BTS_____TV2____BC18');
                btstv3pos=getpv('BTS_____TV3____BC18');
                btstv4pos=getpv('BTS_____TV4____BC16');
                btstv5pos=getpv('BTS_____TV5____BC18');
                btstv6pos=getpv('BTS_____TV6____BC20');
                fprintf('Pulling BTS paddles for top-off injection (if not already open)\n');
                setpv('BTS_____TV1____BC16',0);
                setpv('BTS_____TV2____BC18',0);
                setpv('BTS_____TV3____BC18',0);
                setpv('BTS_____TV4____BC16',0);
                setpv('BTS_____TV5____BC18',0);
                setpv('BTS_____TV6____BC20',0);
                %                pause(2);
            end

            if (get(handles.CheckboxBTS, 'Value')== 1)
                pause(1.4);
            end

            % There might be a chance that beam gets unintentionally
            % cleaned out if bunch cleaner is left on - have observed this
            % sometimes before that single network commands to bunch
            % cleaner get lost. So before every injection the cleaner gets
            % checked and if it is still on, it is switched off.
%             if getpv('bcleanEnable')
%                 setpv('bcleanEnable',0);
%                 disp('Found bunch cleaning on before injection ... Turning it OFF');
%             end
            setbunchcleaning_local('Off');

            peakflag=wait_for_booster_peak_field;
            if peakflag==0
                soundquestion_nobits;
                fprintf('Timeout, no booster peak field reached within 1.5s - is booster pulsing?\n');
            end

            % GUN trigger
            setpvonline('GTL_____TIMING_BC00',1);

            % Booster Injection Kicker
            setpvonline('BR1_____KI_P___BC17',1);

            if paddle_index>8
                fprintf('Timeout for LINAC tuning - to preserve live of paddles ... Disabling LINAC tuning!\n');
                set(handles.CheckboxLINAC, 'Value', 0);
                paddle_index=0;
            end
            if booster_counter>8
                fprintf('Timeout for Booster tuning - to preserve live of paddles and reduce radiation levels... Disabling Booster tuning!\n');
                set(handles.CheckboxBooster, 'Value', 0);
                booster_counter=0;
            end
            if bts_counter>8
                fprintf('Timeout for BTS tuning - to preserve live of paddles and reduce radiation levels... Disabling BTS tuning!\n');
                set(handles.CheckboxBTS, 'Value', 0);
                bts_counter=0;
            end

            % Read fill pattern from bunch current monitor to allow for
            % bunch current equalizer to work.
            bunchQ=getpv('SR1:BCM:BunchQ_WF');

            pause(0.2);
            enable_disable_triggers(1);

            fprintf('Targeting bucket %d, gun width = %d\n',getpv('SR01C___TIMING_AM08'),getpv('GTL_____TIMING_AC02'));

            [btscharge,extractflag]=wait_for_extraction;
            % GUN trigger
            setpvonline('GTL_____TIMING_BC00',0);
            % Booster Injection Kicker
            setpvonline('BR1_____KI_P___BC17',0);
            % SR injection thick septum
            setpvonline('SR01S___SEK_P__BC23',0);
            % SR injection thin septum
            setpvonline('SR01S___SEN_P__BC22',0);
            % SR injection bumps (4 magnets)
            setpvonline('SR01S___BUMP1P_BC22',0);
            if extractflag==0 % the waittime above should be long enough (waiting any longer could create another gun pulse), but sometimes ICT signals seem a little delayed ...
                [btscharge,extractflag]=wait_for_extraction; % so wait again up to another cycle (but without requesting LINAC beam or triggers)
            end
            pause(0.47);
            enable_disable_triggers(0);

            if (get(handles.CheckboxLINAC, 'Value')== 1)
                fprintf('Putting LTB paddles back into previous position for LINAC tuning\n');
                % start_rf_gain=getpv('BR4_____XMIT___GNAC01');
                % setpv('BR4_____XMIT___GNAC01',0);
                setpv('LTB_____TV1____BC16',tv1pos);
                setpv('LTB_____TV3____BC16',tv3pos);
                setpv('LTB_____TV4____BC18',tv4pos);
                setpv('LTB_____TV5____BC16',tv5pos);
                setpv('LTB_____TV6____BC19',tv6pos);
            end

            if (get(handles.CheckboxBooster, 'Value')== 1)
                fprintf('Putting Booster paddles back into previous position for Booster tuning\n');
                setpv('BR1_____TV1____BC18',br1tv1pos);
                setpv('BR1_____TV2____BC16',br1tv2pos);
                setpv('BR1_____TV3____BC18',br1tv3pos);
                setpv('BR3_____TV1____BC16',br3tv1pos);
                setpv('BR4_____TV1____BC16',br4tv1pos);
            end

            if (get(handles.CheckboxBTS, 'Value')== 1)
                fprintf('Putting BTS paddles back into previous position for BTS tuning\n');
                setpv('BTS_____TV1____BC16',btstv1pos);
                setpv('BTS_____TV2____BC18',btstv2pos);
                setpv('BTS_____TV3____BC18',btstv3pos);
                setpv('BTS_____TV4____BC16',btstv4pos);
                setpv('BTS_____TV5____BC18',btstv5pos);
                setpv('BTS_____TV6____BC20',btstv6pos);
            end

            if extractflag==0
                soundquestion_nobits;
                fprintf('Timeout, no extraction reached within 0.2+1.2 s\n');
                if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') && (get(handles.CheckboxCleaning, 'Value')== 1) && (getpv('SR01C___TIMING_AM08')~=319)
                    setbunchcleaning_local('On');
                    cleaning_counter=cleaning_counter+1;
                else
                    pause(0.5);
                end
            else
                if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') && (get(handles.CheckboxCleaning, 'Value')== 1) && (getpv('SR01C___TIMING_AM08')~=319)
                    setbunchcleaning_local('On');
                    cleaning_counter=cleaning_counter+1;
                else
                    pause(1.5);
                end
                stopcurr=getdcct; time_diff = (gettime-curr_meas_time); lifetime=getpv('Topoff_lifetime_AM'); stopcurr2=1000*getpvonline('SR05W___DCCT2__AM01');
                if (time_diff < 1) || (time_diff>60)
                    time_diff = 1.4;
                end
                if (lifetime < 0.2) || (lifetime > 20)
                    lifetime = 5;
                end
                eff=((stopcurr-(startcurr-time_diff*startcurr/3600/lifetime))/1.5)/(btscharge/5);
                eff2=((stopcurr2-(startcurr2-time_diff*startcurr2/3600/lifetime))/1.5)/(btscharge/5);
                eff3=((stopcurr2-(startcurr2-2.0*startcurr2/3600/lifetime))/1.5)/(btscharge/5);
                inj_rate = (stopcurr2-(startcurr2-time_diff*startcurr2/3600/lifetime));
                fprintf('%s: Injection efficiency %g (%g, %g)\n',datestr(now),eff2,eff,eff3);

                if (getpv('GTL_____TIMING_AC02')>12) || strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                    setpv('BTS_To_SR_Injection_Efficiency', eff2);
                    setpv('BTS_To_SR_Injection_Rate', inj_rate);
                    setpv('BR_To_BTS_Extracted_Charge',btscharge/5);
                end

                if eff2<minimumeff
                    if get(handles.CheckboxLINAC, 'Value') || get(handles.CheckboxBooster, 'Value') || get(handles.CheckboxBTS, 'Value')
                        fprintf('Injection efficiency is low - audible warning is disabled in LINAC/Booster/BTS tuning mode\n');
                    else
                        soundquestion_nobits;
                        fprintf('Injection efficiency is low\n');
                    end
                end
            end

            % The following section checks if a single bunch injection
            % happened, within the multibunch bunch train (i.e. an
            % injection commanded by the bunch current equalizer), whether
            % the targeted bunch increased by at least 0.1 mA. If not, the
            % bunch current monitor gets de-selected (fail safe handling
            % that should capture a stalled BCM or if the BCM is shifted by
            % one or more buckets).
            if inj_single==1
                if any(getpv('SR01C___TIMING_AM08')==bucketlist)
                    pause(2);  % Wait for 2 seconds to allow for BCM averaging to settle
                    bunchQ_new=getpv('SR1:BCM:BunchQ_WF');
                    if ((bunchQ_new(next_bucket)-bunchQ(next_bucket))<(0.25*inj_rate)) & (inj_rate>0.15)
                        soundquestion_nobits;
                        fprintf('Bunch current of targeted low current bunch increased by less than %.2f mA - Is the bunch current monitor working?\n',0.25*inj_rate);
                        disp('Disabling bunch current equalizer for now!');
                        set(handles.CheckboxBunchCurrentEqualizer, 'Value', 0);
                    end
                end
            end


            bunch_index=bunch_index+1;cam_counter=cam_counter+1;
            if bunch_index>length(fill_pattern)
                bunch_index=1;
            end

            if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                cam1now=getcamcurrent_local('Cam1_current');cam2now=getcamcurrent_local('Cam2_current');
                if ((cam1now~=startcam1) || (cam2now~=startcam2)) && (cam1now>5) && (cam1now<startcurr)  && (cam2now>5) && (cam2now<startcurr)
                    if cam1now<cam2now
                        setpv('SR01C___TIMING_AC08',fill_pattern(1));
                    else
                        setpv('SR01C___TIMING_AC08',fill_pattern(2));
                    end
                else
                    setpv('SR01C___TIMING_AC08',fill_pattern(bunch_index));
                end
            else
                setpv('SR01C___TIMING_AC08',fill_pattern(bunch_index));
            end

            if length(cam_bucket)==1
                cam_curr=getcamcurrent_local('Cam2_current');
            else
                cam_curr=min([getcamcurrent_local('Cam1_current') getcamcurrent_local('Cam2_current')]);
            end

            % Read fill pattern to decide which bucket to target for bunch
            % current equalizer
            bunchQ=getpv('SR1:BCM:BunchQ_WF');

            % The following section determines which bucket to target next
            % if bunch current equalizer is selected. It has a lower
            % priority than CAM targeting, i.e. it only gets executed if
            % minimum number of injections since last single bunch
            % injection has elapsed, and CAM bucket is still above goal.
            % Threshold is that at least one bunch of multibunch train has
            % to be low by 0.28 mA compared to average of multibunch train.
            if (cam_counter>max_cam_freq) && (cam_curr>goalcurr_cam) && (mean(bunchQ(bucketlist))-min(bunchQ(bucketlist))>0.28) && (get(handles.CheckboxBunchCurrentEqualizer, 'Value')== 1)
                goalcurr = getpv('Topoff_goal_current_SP')+0.4;

                bucketlist_corrected=bucketlist;
                rmind = bunchQ(bucketlist)<0.05*mean(bunchQ(bucketlist)); % Do not target bunches with very low charge (potential bug of BCM showing erroneous zero readings for isolated buckets)
                bucketlist_corrected(rmind)=[];
                if ~isempty(bucketlist_corrected)
                    [maxdiff,diffind]=max(mean(bunchQ(bucketlist_corrected))-bunchQ(bucketlist_corrected));     % find bunch that has the lowest charge
                    next_bucket = bucketlist_corrected(diffind);
                    fprintf('Filling low charge bucket next: Targeting bucket %d which is %.2f mA below average\n',next_bucket,maxdiff);
                    cam_counter=0;          % Reset cam counter, so that next single bunch injection does not happen before minimum interval set above

                    if getpv('SR01C___TIMING_AM11') || getpv('SR01C___TIMING_AM13');
                        % Switching bucket loading from table mode to direct bucket control
                        fprintf('Bucket loading is controlled directly by this program\n');
                        setpv('SR01C___TIMING_AC11',0);
                        setpv('SR01C___TIMING_AC13',0);
                    end

                    % Do normal switching of injection field trigger and
                    % gun BIAS for single bunch injection
                    injtrigdelta=getpv('Topoff_cam_inj_field_delta_SP');
                    if isnan(injtrigdelta) || (injtrigdelta>150) || (injtrigdelta<0)
                        injtrigdelta=35;
                    end

                    setpv('SR01C___TIMING_AC08',next_bucket);

                    start_inj_trig=getpv('BR1_____TIMING_AM00');
                    start_inj_trig_mrf=getpv('GaussClockInjectionFieldTrigger');
                    fprintf('Setting injection field trigger to %d\n',start_inj_trig+injtrigdelta);
                    setpv('BR1_____TIMING_AC00',start_inj_trig+injtrigdelta);
                    deltaMRF=round(start_inj_trig_mrf*(injtrigdelta/12500)/250)*250;
                    setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf+deltaMRF);
                    setpv('GTL_____TIMING_AC02',12);
                    startbias=getpv('EG______BIAS___AC01');
                    setpv('EG______BIAS___AC01',23.7);

                    % Make sure correct bucket gets targeted in next
                    % scheduled fill pattern injection (bunch_index got
                    % incremented above, and will get incremented again, so
                    % without this correction, one fill pattern entry would
                    % get skipped).
                    bunch_index=bunch_index-1;
                    if bunch_index<1
                        bunch_index=length(fill_pattern);
                    end

                    % inj_single is controls behavior of loop on next
                    % execution (same as for CAM and parasite). If it is
                    % set, after the next injection cleaning is switched
                    % on and afterwards settings for injection field
                    % trigger and BIAS are returned to multibunch
                    % settings.
                    inj_single=1;

                else
                    disp('Empty bucketlist_corrected - all bunches seem to be close to nominal charge / or empty');
                end


            elseif (cam_counter>max_cam_freq) && (cam_curr<goalcurr_cam) && (get(handles.CheckboxCAM, 'Value')== 1)
                fprintf('Filling CAM bucket next\n');
                goalcurr = getpv('Topoff_goal_current_SP')+0.4;

                if getpv('SR01C___TIMING_AM11') || getpv('SR01C___TIMING_AM13');
                    % Switching bucket loading from table mode to direct bucket control
                    fprintf('Bucket loading is controlled directly by this program\n');
                    setpv('SR01C___TIMING_AC11',0);
                    setpv('SR01C___TIMING_AC13',0);
                end

                injtrigdelta=getpv('Topoff_cam_inj_field_delta_SP');
                if isnan(injtrigdelta) || (injtrigdelta>150) || (injtrigdelta<0)
                    injtrigdelta=35;
                end

                fprintf('current cam current = %g, %g mA\n',getcamcurrent_local('Cam1_current'),getcamcurrent_local('Cam2_current'));
                cam_counter=0;
                if length(cam_bucket)==1
                    setpv('SR01C___TIMING_AC08',cam_bucket(1));
                    last_cam_index=1;
                else
                    if (getcamcurrent_local('Cam1_current')>1) && (getcamcurrent_local('Cam2_current')>1)
                        if getcamcurrent_local('Cam1_current') < getcamcurrent_local('Cam2_current')
                            setpv('SR01C___TIMING_AC08',cam_bucket(1));
                            last_cam_index=1;
                        else
                            setpv('SR01C___TIMING_AC08',cam_bucket(2));
                            last_cam_index=2;
                        end
                    else
                        if last_cam_index>1
                            setpv('SR01C___TIMING_AC08',cam_bucket(1));
                            last_cam_index=1;
                        else
                            setpv('SR01C___TIMING_AC08',cam_bucket(2));
                            last_cam_index=2;
                        end
                    end
                end

                start_inj_trig=getpv('BR1_____TIMING_AM00');
                start_inj_trig_mrf=getpv('GaussClockInjectionFieldTrigger');
                fprintf('Setting injection field trigger to %d\n',start_inj_trig+injtrigdelta);
                setpv('BR1_____TIMING_AC00',start_inj_trig+injtrigdelta);
                    deltaMRF=round(start_inj_trig_mrf*(injtrigdelta/12500)/250)*250;
                    setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf+deltaMRF);
                setpv('GTL_____TIMING_AC02',12);
                startbias=getpv('EG______BIAS___AC01');

                if (get(handles.CheckboxCleaning, 'Value')== 1)
                    setpv('EG______BIAS___AC01',23.7);
                elseif getpv('EG______BIAS___AC01')>34
                    setpv('EG______BIAS___AC01',34);
                end

                bunch_index=bunch_index-1;
                if bunch_index<1
                    bunch_index=length(fill_pattern);
                end
                inj_single=1;
            else
                if inj_single==1
                    if (get(handles.CheckboxCleaning, 'Value')== 1)
                        if ((getpv('SR01C___TIMING_AM08')==(cam_bucket(end)+4)) || (getpv('SR01C___TIMING_AM08')==(cam_bucket(1)+4)))
                            disp('Intentional parasite fill detected: Waiting 10 seconds before switching on bunch cleaning');
                            pause(10);
                        end
                        if ~strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                            setbunchcleaning_local('On',0.25);
                            cleaning_counter=cleaning_counter+1;
                        end
                    else
                        pause(0.5);
                    end

                    fprintf('Returning to normal fill (multibunch/twobunch)\n');
                    inj_single=0;

                    goalcurr = getpv('Topoff_goal_current_SP');

                    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                        if (goalcurr>40) || (goalcurr<17)
                            disp('Goal current value outside of range for twobunch, defaulting to 35 mA');
                            goalcurr=35;
                            setpv('Topoff_goal_current_SP',goalcurr)
                        end
                    else
                        disp('Returning BIAS, gunwidth and injection field trigger to multibunch values');
                        fprintf('Setting injection field trigger to %d\n',start_inj_trig);
                        setpv('BR1_____TIMING_AC00',start_inj_trig);
                        setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf);
                        % setpv('BR1_____TIMING_AC00',getpv('BR1_____TIMING_AM00')-injtrigdelta);
                        setpv('GTL_____TIMING_AC02',gunwidth);
                        setpv('EG______BIAS___AC01',startbias);
                        if (goalcurr>500) || (goalcurr<17)
                            disp('Goal current value outside of range for multibunch, defaulting to 500 mA');
                            goalcurr=500;
                            setpv('Topoff_goal_current_SP',goalcurr);
                        end
                    end

                end
            end

            if (get(handles.CheckboxParasite, 'Value')== 1)
                if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                    fprintf('Intentionally filling parasite bunch into bucket 319, will pause cleaning for 1 shot!\n');
                    setpv('SR01C___TIMING_AC08',319);
                else
                    fprintf('Intentionally filling parasite bunch into bucket %d, will pause cleaning for 10 s afterwards!\n',cam_bucket(end)+4);
                    setpv('SR01C___TIMING_AC08',cam_bucket(end)+4);
                    setpv('EG______BIAS___AC01',36);
                end
                setpv('GTL_____TIMING_AC02',12);
                set(handles.CheckboxParasite, 'Value', 0);
                inj_single=1;
            end

            % The following section is a feature. It was added because several non-timing users (including Matthew Marcus) had complained about
            % the distortion the normal two bunch cleaning causes to the beam. So now cleaning after most injections only targets the 8 ns parasite
            % coming from the injector (similar to multi bunch mode, just with slightly different bunch numbers, i.e. main bunches are 154 and 318, whereas dual
            % cam buckets are 150 and 318). Only after every 20th injection are all bunches (besides the two main ones) targeted for cleaning to avoid
            % slow buildup of diffusion from Touschek scattering. This new feature has been active since the second 2bunch run in 2011. C. Steier
            if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                if (cleaning_counter>20) || (getpv('SR01C___TIMING_AM08')==319)
                    cleaning_counter=0;
                    switch_bclean_settings(0);
                else
                    switch_bclean_settings(1);
                end
            end

            pause(0.5);
            set(handles.TopOffStaticTextBucket,'String',sprintf('Bucket = %d',getpv('SR01C___TIMING_AM08')),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextGunWidth,'String',sprintf('Gun Width = %d ns',getpv('GTL_____TIMING_AC02')),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextCurrent,'String',sprintf('Current = %.1f mA, CAM = %.1f, %.1f mA',getdcct,getcamcurrent_local('Cam1_current'),getcamcurrent_local('Cam2_current')),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextEfficiency,'String',sprintf('BTS = %.2f nC, efficiency = %.2f',btscharge/5,eff2),'ForegroundColor',[0 0 0]);
            drawnow;
            startpause=gettime;
            % New timing system does not allow booster bend delay changes anymore - Christoph Steier, 2015-01-10, so removed delay adjustment
            adjusted_dt = minimumdt - 1.4; % -1.4 is for one booster cycle without any additional delay
            while (gettime-startpause)<adjusted_dt
                if abs(gettime-startpause)>1800              % This patch is necessary to deal with switching from PDST to PST
                    startpause=gettime;
                end
                pause(0.5);
                if getappdata(handles.TOPOFF, 'TOPOFF_FLAG') == 0
                    % Stop TopOff and clean up
                    break
                end
            end
        else
            enable_disable_triggers(0);
        end
        pause(1.4);
    catch ME
        fprintf('An error occurred (%s) ... Exiting program\n',ME.identifier);
        exit_cleanup;
        try
            % Enable buttons
            set(handles.TopOffStart,               'Enable', 'on');
            set(handles.EditParams,               'Enable', 'on');
            set(handles.TopOffStop,              'Enable', 'off');
            if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                set(handles.FillCamBuckets,              'Enable', 'off');
            else
                set(handles.FillCamBuckets,              'Enable', 'on');
            end

            set(handles.TopOffStaticTextBucket,'String',sprintf('Bucket = ____'),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextGunWidth,'String',sprintf('Gun Width = ____ ns'),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextCurrent,'String',sprintf('Current = ____ mA, CAM = __, __ mA'),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextEfficiency,'String',sprintf('BTS = ____ nC, efficiency = ____'),'ForegroundColor',[0 0 0]);
        catch ME
            fprintf('   %s \n',ME.identifier);
            % GUI must have been closed
        end
        return
    end
end
% End top-off, reset all parameters
try
    % Enable buttons
    set(handles.TopOffStart, 'Enable', 'on');
    set(handles.EditParams,  'Enable', 'on');
    set(handles.TopOffStop,  'Enable', 'off');
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
        set(handles.FillCamBuckets, 'Enable', 'off');
    else
        set(handles.FillCamBuckets, 'Enable', 'on');
    end
    set(handles.TopOffStaticTextBucket,    'String',sprintf('Bucket = ____'),'ForegroundColor',[0 0 0]);
    set(handles.TopOffStaticTextGunWidth,  'String',sprintf('Gun Width = ____ ns'),'ForegroundColor',[0 0 0]);
    set(handles.TopOffStaticTextCurrent,   'String',sprintf('Current = ____ mA, CAM = __, __ mA'),'ForegroundColor',[0 0 0]);
    set(handles.TopOffStaticTextEfficiency,'String',sprintf('BTS = ____ nC, efficiency = ____'),'ForegroundColor',[0 0 0]);
    exit_cleanup;
catch ME
    fprintf('   %s \n',ME.identifier);
    % GUI must have been closed
end

a = clock;
fprintf('   %s %d:%d:%.0f\n', date, a(4), a(5), a(6));
[~, StateString] = getsrstate;
try
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
catch ME
    fprintf('   %s \n',ME.identifier);
    % GUI must have been closed
end
fprintf('   ***********************\n');
fprintf('   **  Top Off Stopped  **\n');
fprintf('   ***********************\n\n');
                

% --- Executes on button press in CheckboxCAM.
function CheckboxCAM_Callback(~, ~, ~)


% --- Outputs from this function are returned to the command line.
function varargout = topoff_injection_dualcam_OutputFcn(~, ~, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

                        
%-------------------------------------------------
function peakflag=wait_for_booster_peak_field(varargin)
t0=gettime;peakflag=0;
% New Timing system does not support booster delay adjustment, so remoevd added delay here - Christoph Steier, 2015-01-10
while ((gettime-t0)<1.5)
    % Changed to use readback from Bend magnet DPSC, instead of miniIOC
    % bend_curr=getam('BR1_____B_IE___AM00');
    bend_curr=getam('BR1_____B__PS__AM00');
    pause(0.1);
    % Changed to use readback from Bend magnet DPSC, instead of miniIOC
    % if getam('BR1_____B_IE___AM00')<(bend_curr-0.1)
    if getam('BR1_____B__PS__AM00')<(bend_curr-1e5)
        fprintf('Passed booster peak field - synchronizing timing\n');
        peakflag=1;
        break
    end
end
return
                            
%-------------------------------------------------
function [btscharge,extractflag]=wait_for_extraction(varargin)

t0=gettime;extractflag=0;btscharge1=0;btscharge2=0;
try
    trigcnt0=getpv('ztec13:Inp1WaveCount');
catch ME
    fprintf('Error reading ztec scope (%s)\n',ME.identifier);
    trigcnt0=0;
end

% New Timing system does not support booster delay adjustment, so remoevd added delay here - Christoph Steier, 2015-01-10
while ((gettime-t0)<(1.4-0.2)) % 1.4 seconds is booster cycle, 0.2 second wait already happens before this function is entered
    btscharge1=getam('BTS_____ICT01__AM00');
    btscharge2=getam('BTS_____ICT02__AM01');
    try
        trigcnt1=getpv('ztec13:Inp1WaveCount');
    catch ME
        fprintf('Error reading ztec scope (%s)\n',ME.identifier);
        trigcnt1=trigcnt0;
    end

    if (trigcnt1>trigcnt0)  % (btscharge1>1.0)  || (btscharge2>1.0) % || (trigcnt1>trigcnt0)
        fprintf('Extraction from booster detected\n');
        extractflag=1;
        pause(0.1);
        %        btscharge1=getam('BTS_____ICT01__AM00');
        %        btscharge2=(-1)*getam('BTS_____ICT02__AM01');
        %        btscharge=max([btscharge1 btscharge2]);
        %        if btscharge1>2.0
        %            btscharge=btscharge1;
        %         else
        try
            ictdata=lcaGet('ztec13:Inp1ScaledWave',1000);
            % btscharge=(-1.5*5)*min(ictdata);
            [~,ictind]=min(ictdata);
            btscharge=sum(ictdata(ictind-22:ictind+35))/(-2.92);
        catch ME
            fprintf('Error reading ICT (%s)\n',ME.identifier);
            btscharge=0;
        end
        %         end
        break
    else
        btscharge=0;
    end
    pause(0.05);
end
% if abs(btscharge1-btscharge2)>1.0
%     disp('BTS ICT1 and ICT2 charge disagrees - there might be problem with one ICT');
% end
return
                                
%-------------------------------------------------
function enable_disable_triggers(varargin)
if nargin~=1
    fprintf('enable_disable_triggers: You need to provide one input argument\n');
    return
end

handles=guidata(gcbo);

if varargin{1}==0
    if (get(handles.CheckboxLINAC, 'Value')== 0) && (get(handles.CheckboxBooster, 'Value')== 0) && (get(handles.CheckboxBTS, 'Value')== 0)
        % GUN trigger
        setpvonline('GTL_____TIMING_BC00',0);
    else
        % GUN trigger
        setpvonline('GTL_____TIMING_BC00',1);
    end
    if (get(handles.CheckboxBooster, 'Value')== 0) && (get(handles.CheckboxBTS, 'Value')== 0)
        % Booster Injection Kicker
        setpvonline('BR1_____KI_P___BC17',0);
        % Booster Extraction Bump Magnets (3 magnets)
        setpvonline('BR2_____BUMP_P_BC21',0);
        % Booster Extraction Kicker
        setpvonline('BR2_____KE_P___BC17',0);
    else
        % Booster Injection Kicker
        setpvonline('BR1_____KI_P___BC17',1);
        % Booster Extraction Bump Magnets (3 magnets)
        setpvonline('BR2_____BUMP_P_BC21',1);
        % Booster Extraction Kicker
        setpvonline('BR2_____KE_P___BC17',1);
    end
    if (get(handles.CheckboxBTS, 'Value')== 0)
        % Booster extraction thin septum
        setpvonline('BR2_____SEN_P__BC22',0);
        % Booster extraction thick septum
        setpvonline('BR2_____SEK_P__BC23',0);
    else
        % Booster extraction thin septum
        setpvonline('BR2_____SEN_P__BC22',1);
        % Booster extraction thick septum
        setpvonline('BR2_____SEK_P__BC23',1);
    end
    % SR injection thick septum
    setpvonline('SR01S___SEK_P__BC23',0);
    % SR injection thin septum
    setpvonline('SR01S___SEN_P__BC22',0);
    % SR injection bumps (4 magnets)
    setpvonline('SR01S___BUMP1P_BC22',0);
elseif varargin{1}==1
    % GUN trigger
    setpvonline('GTL_____TIMING_BC00',1);
    % Booster Injection Kicker
    setpvonline('BR1_____KI_P___BC17',1);
    % Booster Extraction Bump Magnets (3 magnets)
    setpvonline('BR2_____BUMP_P_BC21',1);
    % Booster Extraction Kicker
    setpvonline('BR2_____KE_P___BC17',1);
    % Booster extraction thin septum
    setpvonline('BR2_____SEN_P__BC22',1);
    % Booster extraction thick septum
    setpvonline('BR2_____SEK_P__BC23',1);
    % SR injection thick septum
    setpvonline('SR01S___SEK_P__BC23',1);
    % SR injection thin septum
    setpvonline('SR01S___SEN_P__BC22',1);
    % SR injection bumps (4 magnets)
    setpvonline('SR01S___BUMP1P_BC22',1);
end

return
                                    
%-------------------------------------------------
function switch_bclean_settings(varargin)

fill_pattern = fillpattern_local;

if nargin~=1
    fprintf('switch_bclean_settings: You need to provide one input argument\n');
    return
end

if ~strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    disp('switch_bclean_settings: Returning without change to settings. Only active in two bunch mode');
    return;
end

% Now using new TFB bunch cleaner in Two Bunch mode as well, section below
% was for old cleaner

% if varargin{1}==0
%     WF = bunchcleanerwaveform(0);
%     if (any(WF(:,2)~=getpv('bcleanSetPattern')')) || (getpv('bcleanPatternOffset')~= 0) || (getpv('bcleanSetFreqS')~=6000)
%         disp('Switching to cleaning all bunches, except 154 and 318');
%         setpv('bcleanSetPattern', WF(:,2)');
%         setpv('bcleanPatternOffset', 0);
%         setpv('bcleanSetFreqS',6000);
%         pause(1);
%     end
% elseif varargin{1}==1
%     b = zeros(1,328);
%     b((fill_pattern(1)+2):(fill_pattern(1)+6)) =  1;
%     b((fill_pattern(2)+2):(fill_pattern(2)+6)) = -1;
%     if (any(b~=getpv('bcleanSetPattern'))) || (getpv('bcleanPatternOffset')~= 11) || (getpv('bcleanSetFreqS')~=32000)
%         disp('Switching to cleaning only 8 ns parasite bunches after 154 and 318');
%         setpv('bcleanSetPattern', b);
%         setpv('bcleanPatternOffset', 11);
%         setpv('bcleanSetFreqS',32000);
%         pause(1);
%     end
% end

if varargin{1}==0
        disp('Switching to cleaning 6 buckets, each, behind 154 and 318');
        setpvonline('IGPF:TFBY:CLEAN:PATTERN','155:161 319:325');
        setpvonline('IGPF:TFBY:CLEAN:SPAN',0.03);
        pause(1);
elseif varargin{1}==1
        disp('Switching to cleaning only 8 ns parasite behind 154 and 318');
        setpvonline('IGPF:TFBY:CLEAN:PATTERN','156:161 320:325');
        setpvonline('IGPF:TFBY:CLEAN:SPAN',0.03);
end

return
                                        
%-------------------------------------------------
function exit_cleanup(varargin)
global start_inj_trig start_inj_trig_mrf startbias
fprintf('Putting LTB TV6 paddle into linac beam\n');
setpv('LTB_____TV6____BC19',255);
pause(2);
fprintf('Re-enabling injector - but keeping SR injection triggers OFF\n');
% Booster RF
% setpv('BR4_____XMIT___GNAC01',start_rf_gain);
% GUN trigger
setpv('GTL_____TIMING_BC00',1);
% Booster Injection Kicker
setpv('BR1_____KI_P___BC17',1);
% Booster Extraction Bump Magnets (3 magnets)
setpv('BR2_____BUMP_P_BC21',1);
% Booster Extraction Kicker
setpv('BR2_____KE_P___BC17',1);
% Booster extraction thin septum
setpv('BR2_____SEN_P__BC22',1);
% Booster extraction thick septum
setpv('BR2_____SEK_P__BC23',1);
% Switch bucket timing control back to table
fprintf('Bucket timing control switched back to table, i.e. SRinject\n');
setpv('SR01C___TIMING_AC11',255);
setpv('SR01C___TIMING_AC13',255);
% Switch gun back to multibunch injection trigger
fprintf('Setting injection field trigger to %d\n',start_inj_trig);
setpv('BR1_____TIMING_AC00',start_inj_trig);
setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf);
if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    fprintf('Setting gun width to 12 ns\n');
    setpv('GTL_____TIMING_AC02',12);
else
    fprintf('Setting gun width to 36 ns\n');
    setpv('GTL_____TIMING_AC02',36);
    fprintf('Setting gun bias to %g\n',startbias);
    setpv('EG______BIAS___AC01',startbias);
end
pause(1);
return


% --- Executes on button press in CheckboxLINAC.
function CheckboxLINAC_Callback(hObject, ~, ~)
% hObject    handle to CheckboxLINAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global start_rf_gain

if get(hObject,'Value') == 0
fprintf('Pulling LTB paddles for top-off injection (if not already open)\n');
fprintf('Also as measure to avoid radiation trips disabling gun trigger\n');
setpv('GTL_____TIMING_BC00',0);
setpv('LTB_____TV1____BC16',0);
setpv('LTB_____TV3____BC16',0);
setpv('LTB_____TV4____BC18',0);
setpv('LTB_____TV5____BC16',0);
setpv('LTB_____TV6____BC19',0);
% setpv('BR4_____XMIT___GNAC01',start_rf_gain);
end

if get(hObject,'Value') == 1
fprintf('Putting in LTB TV6 for LINAC tuning (to avoid high energy losses in Booster)\n');
setpv('LTB_____TV6____BC19',1);
fprintf('Putting in LTB TV3 and switching video channel so that you can optimize LINAC\n');
setpv('ltb_video_mux',6);
setpv('LTB_____TV3____BC16',255);
setpv('LTB_____TV3LIT_BC17',255);
% start_rf_gain=getpv('BR4_____XMIT___GNAC01');
end

% --- Executes on button press in CheckboxBooster.
function CheckboxBooster_Callback(hObject, ~, ~)
% hObject    handle to CheckboxBooster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 0
    fprintf('Pulling Booster paddles for top-off injection (if not already open)\n');
    fprintf('Also as measure to avoid radiation trips disabling gun trigger\n');
    setpv('GTL_____TIMING_BC00',0);
    setpv('BR1_____TV1____BC18',0);
    setpv('BR1_____TV2____BC16',0);
    setpv('BR1_____TV3____BC18',0);
    setpv('BR3_____TV1____BC16',0);
    setpv('BR4_____TV1____BC16',0);
end

% Hint: get(hObject,'Value') returns toggle state of CheckboxBooster

                                                    
% --- Executes on button press in CheckboxBTS.
function CheckboxBTS_Callback(hObject, ~, ~)
% hObject    handle to CheckboxBTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 0
    fprintf('Pulling BTS paddles for top-off injection (if not already open)\n');
    fprintf('Also as measure to avoid radiation trips disabling gun trigger\n');
    setpv('GTL_____TIMING_BC00',0);
    setpv('BTS_____TV1____BC16',0);
    setpv('BTS_____TV2____BC18',0);
    setpv('BTS_____TV3____BC18',0);
    setpv('BTS_____TV4____BC16',0);
    setpv('BTS_____TV5____BC18',0);
    setpv('BTS_____TV6____BC20',0);
end

% Hint: get(hObject,'Value') returns toggle state of CheckboxBTS
                                                        
% --- Executes on button press in CheckboxCleaning.
function CheckboxCleaning_Callback(~, ~, ~)
% hObject    handle to CheckboxCleaning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckboxCleaning

                                                            
% --- Executes on button press in CheckboxParasite.
function CheckboxParasite_Callback(~, ~, ~)
% hObject    handle to CheckboxParasite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckboxParasite
                                                                
% --- Executes on button press in CheckboxBunchCurrentQualizer.
function CheckboxBunchCurrentEqualizer_Callback(~, ~, ~)
% hObject    handle to CheckboxBunchCurrentEqualizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckboxBunchCurrentEqualizer

                                                                    
% --- Executes on button press in EditParams.
function EditParams_Callback(~, ~, ~)
% hObject    handle to EditParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

goalcurrent = getpv('Topoff_goal_current_SP');
if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    if (goalcurrent>40) || (goalcurrent<17)
        disp('Goal current value outside of range for twobunch, defaulting to 35 mA');
        setpv('Topoff_goal_current_SP',35)
    end
end

prompt={'Goal Current', 'CAM Goal Current', 'CAM Injection Trigger DELTA'};
def={num2str(getpv('Topoff_goal_current_SP')), num2str(getpv('Topoff_cam_goal_current_SP')), num2str(getpv('Topoff_cam_inj_field_delta_SP'))};
titlestr='Topoff Parameter Setup';
lineNo=1;
answer=inputdlg(prompt,titlestr,lineNo,def);
if ~isempty(answer)
    newgoal = str2double(answer{1});
    if isempty(newgoal)
        disp('   Goal Current value cannot be empty.  No change made.');
    else
        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
            if (newgoal>40) || (newgoal<17)
                disp('Goal current value outside of range for twobunch, defaulting to 35 mA');
                newgoal=35;
            end
        else
            if (newgoal>500) || (newgoal<17)
                disp('Goal current value outside of range, defaulting to 500 mA');
                newgoal=500;
            end
        end
        goal = newgoal;
    end
    newgoal = str2double(answer{2});
    if isempty(newgoal)
        disp('   CAM Goal Current value cannot be empty.  No change made.');
    else
        if (newgoal>6) || (newgoal<1)
            disp('CAM goal current value outside of range, defaulting to 5 mA');
            newgoal=4;
        end
        camgoal = newgoal;
    end
    newdelta = str2double(answer{3});
    if isempty(newdelta)
        disp('   Injection Trigger DELTA value cannot be empty.  No change made.');
    else
        if (newdelta>150) || (newdelta<0)
            disp('   Injection Trigger DELTA value outside range. Defaulting to 35.');
            newdelta=35;
        end
        deltatrig = newdelta;
    end

    try
        setpv('Topoff_goal_current_SP',goal);
        setpv('Topoff_cam_goal_current_SP',camgoal);
        setpv('Topoff_cam_inj_field_delta_SP',deltatrig);
        fprintf('   Setting new topoff parameters: Goal = %d mA, CAM goal = %.1f, %.1f mA, Inj. Trig. DELTA = %d tics\n',goal,camgoal,camgoal,deltatrig);
    catch ME
        fprintf('   %s \n',ME.identifier);
        disp('   Trouble setting Topoff parameters!');
    end
end

return
                                                                        
% --- Executes on button press in FillCamBuckets.
function FillCamBuckets_Callback(~, ~, ~)
% hObject    handle to FillCamBuckets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global start_inj_trig start_inj_trig_mrf

[~, cam_bucket, ~] = fillpattern_local;

if getpv('sr:user_beam')
    warning('topoff_injection_dualcam:user_beam','This routine should only be used, if the user beam shutters are closed (because it makes use of full booster frequency)');
    return
end

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    warning('topoff_injection_dualcam:OperationalMode','This routine should only be used in multibunch mode (not in two-bunch)');
    return
end

if (length(cam_bucket)<1) || (length(cam_bucket)>2)
    warning('topoff_injection_dualcam:cam_bucket','Cam bucket vector needs to have one or two entries. The cam_bucket vector has %d entries!',length(cam_bucket));
    return
end

try
    
    fprintf('Putting in LTB TV3 and switching video channel so that you can confirm whether there is only one LINAC bunch\n');
    setpv('ltb_video_mux',6);
    setpv('LTB_____TV3____BC16',255);
    setpv('LTB_____TV3LIT_BC17',255);

    pause(0.5);

    goalcurr = getpv('Topoff_goal_current_SP');          % current to keep [mA]
    if (goalcurr>500) || (goalcurr<17)
        goalcurr=500;
        setpv('Topoff_goal_current_SP',goalcurr);
    end
    goalcurr_cam = getpv('Topoff_cam_goal_current_SP');        % target current for cam_bucket [mA]
    if (goalcurr_cam>6) || (goalcurr_cam<1)
        goalcurr_cam=4;
        setpv('Topoff_cam_goal_current_SP',goalcurr_cam);
    end


    start_inj_trig=getpv('BR1_____TIMING_AM00');
    if abs(start_inj_trig-5000)>1000
        start_inj_trig=5000;
    end

    start_inj_trig_mrf=getpv('GaussClockInjectionFieldTrigger');
    if abs(start_inj_trig_mrf-1.862e6)>3.724e5
        start_inj_trig_mrf=1.862e6;
    end

    injtrigdelta=getpv('Topoff_cam_inj_field_delta_SP');
    if isnan(injtrigdelta) || (injtrigdelta>150) || (injtrigdelta<0)
        injtrigdelta=35;
    end

    % Switching bucket loading from table mode to direct bucket control
    fprintf('Bucket loading is controlled directly by this program\n');
    setpv('SR01C___TIMING_AC11',0);
    setpv('SR01C___TIMING_AC13',0);

    fprintf('Filling bucket %d\n',cam_bucket(1));
    setpv('SR01C___TIMING_AC08',cam_bucket(1));

    fprintf('Setting gun width to %d ns\n',12);
    setpv('GTL_____TIMING_AC02',13);
    pause(2);
    setpv('GTL_____TIMING_AC02',12);

    fprintf('Setting booster injection field trigger to %d for single bunch (delta = %d)\n',start_inj_trig+injtrigdelta,injtrigdelta);
    setpv('BR1_____TIMING_AC00',start_inj_trig+injtrigdelta);
                    deltaMRF=round(start_inj_trig_mrf*(injtrigdelta/12500)/250)*250;
                    setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf+deltaMRF);

    enable_disable_triggers(1);
    
    StartFlag = questdlg({'This function will fill the cam buckets','Gunwidth has been set automatically.',' ','Have you checked whether there is only one bunch on LTB TV3?'},'Single Bunch','Yes','No','No');

    setpv('LTB_____TV3____BC16',0);
    setpv('LTB_____TV3LIT_BC17',0);

    if strcmp(StartFlag,'Yes')

        num_injections = 1;

        if length(cam_bucket)>1

            while (getdcct<goalcurr) && (getcamcurrent_local('Cam1_current')<goalcurr_cam)
                fprintf('Opening LTB TV6 paddle (if not already open) ...\n');
                setpv('LTB_____TV6____BC19',0);
                pause(1.4);
                fprintf('Cam 1 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam1_current'),goalcurr_cam);
                if getcamcurrent_local('Cam1_current')<((num_injections*0.075)-0.5)
                    warning('topoff_injection_dualcam:cam_monitor','Cam Bucket seems to not accumulate electrons - check Cam bucket monitoring program or tune up injector/injection efficiency');
                    soundtada;
                    break
                end
                num_injections=num_injections+1;
            end

            fprintf('Putting LTB TV6 paddle into linac beam\n');
            setpv('LTB_____TV6____BC19',255);
            pause(2);

            fprintf('Filling bucket %d\n',cam_bucket(2));
            setpv('SR01C___TIMING_AC08',cam_bucket(2));

            pause(1.0);

            num_injections = 1;

            while (getdcct<goalcurr) && (getcamcurrent_local('Cam2_current')<goalcurr_cam)
                fprintf('Opening LTB TV6 paddle (if not already open) ...\n');
                setpv('LTB_____TV6____BC19',0);
                pause(1.4);
                fprintf('Cam 2 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam2_current'),goalcurr_cam);
                if getcamcurrent_local('Cam2_current')<((num_injections*0.1)-0.5)
                    warning('topoff_injection_dualcam:cam_monitor','Cam Bucket seems to not accumulate electrons - check Cam bucket monitoring program or tune up injector/injection efficiency');
                    soundtada;
                    break
                end
                num_injections=num_injections+1;
            end
        else
            while (getdcct<goalcurr) && (getcamcurrent_local('Cam2_current')<goalcurr_cam)
                fprintf('Opening LTB TV6 paddle (if not already open) ...\n');
                setpv('LTB_____TV6____BC19',0);
                pause(1.4);
                fprintf('Cam 2 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam2_current'),goalcurr_cam);
                if getcamcurrent_local('Cam2_current')<((num_injections*0.075)-0.5)
                    warning('topoff_injection_dualcam:cam_monitor','Cam Bucket seems to not accumulate electrons - check Cam bucket monitoring program or tune up injector/injection efficiency');
                    soundtada;
                    break
                end
                num_injections=num_injections+1;
            end

            fprintf('Putting LTB TV6 paddle into linac beam\n');
            setpv('LTB_____TV6____BC19',255);
            fprintf('Finished: Cam 1 current = %.1f mA, Cam 2 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam1_current'),getcamcurrent_local('Cam2_current'),goalcurr_cam);
            pause(2);

        end
    end

    fprintf('Putting LTB TV6 paddle into linac beam\n');
    setpv('LTB_____TV6____BC19',255);
    pause(0.5);

    fprintf('Setting booster injection field trigger to %d for multi bunch\n',start_inj_trig);
    setpv('BR1_____TIMING_AC00',start_inj_trig);
    setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf);
    pause(0.5);
    exit_cleanup
    % exit_cleanup actually disable storage ring injection pulsed magnets (since that is what one wants to do
    % when disabling top-off. However, here we want to go back into a state where Hiroshi's program can continue
    % filling multibunch. So the next three setpv commands accomplish that.

    % SR injection thick septum
    setpv('SR01S___SEK_P__BC23',1);
    % SR injection thin septum
    setpv('SR01S___SEN_P__BC22',1);
    % SR injection bumps (4 magnets)
    setpv('SR01S___BUMP1P_BC22',1);

    disp('Exiting ...');

catch ME
    fprintf('Error %s\n',ME.identifier)
    fprintf('Setting booster injection field trigger to %d for multi bunch\n',start_inj_trig);
    setpv('BR1_____TIMING_AC00',start_inj_trig);
    setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf);

    exit_cleanup
    % exit_cleanup actually disable storage ring injection pulsed magnets (since that is what one wants to do
    % when disabling top-off. However, here we want to go back into a state where Hiroshi's program can continue
    % filling multibunch. So the next three setpv commands accomplish that.

    % SR injection thick septum
    setpv('SR01S___SEK_P__BC23',1);
    % SR injection thin septum
    setpv('SR01S___SEN_P__BC22',1);
    % SR injection bumps (4 magnets)
    setpv('SR01S___BUMP1P_BC22',1);

    % Make sure LTB TV3 is retracted
    setpv('LTB_____TV3____BC16',0);
    setpv('LTB_____TV3LIT_BC17',0);

    disp('Exiting ...');
end

return
                                                                            
% --- Executes on button press in EqualizeFill.
function EqualizeFill_Callback(~, ~, ~)
% hObject    handle to FillCamBuckets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global start_inj_trig start_inj_trig_mrf

[fill_pattern, ~, ~] = fillpattern_local;

if getpv('sr:user_beam')
    warning('topoff_injection_dualcam:user_beam','This routine should only be used, if the user beam shutters are closed (because it makes use of full booster frequency)');
    return
end

if (getdcct<350) || (getdcct>getpv('Topoff_goal_current_SP'))
    warning('topoff_injection_dualcam:getdcct','This routine should only be used, if the beam current is above 350 mA and below the topoff current setpoint');
    return
end

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    warning('topoff_injection_dualcam:OperationalMode','This routine should only be used in multibunch mode (not in two-bunch)');
    return
end

% Bunch current equalizer needs unique list of multibunch buckets
if length(fill_pattern)>10
    bucketlist = unique([fill_pattern fill_pattern+4 fill_pattern+8 fill_pattern+12]);  % Taking into account that multibunch fill is with 4 gun bunches
else
    bucketlist = unique(fill_pattern);
end

if (length(bucketlist)<40) || (length(bucketlist)>328)
    warning('topoff_injection_dualcam:bucketlist','Bucket list length is outside expected range (40-328 entries). The bucket list has %d entries!',length(bucketlist));
    return
end

open_paddle_flag = 1;

try
    goalcurr = getpv('Topoff_goal_current_SP');          % current to keep [mA]
    if (goalcurr>500) || (goalcurr<17)
        goalcurr=500;
        setpv('Topoff_goal_current_SP',goalcurr);
    end

    start_inj_trig=getpv('BR1_____TIMING_AM00');
    if abs(start_inj_trig-5000)>1000
        start_inj_trig=5000;
    end

    start_inj_trig_mrf=getpv('GaussClockInjectionFieldTrigger');
    if abs(start_inj_trig_mrf-1.862e6)>3.724e5
        start_inj_trig_mrf=1.862e6;
    end

    injtrigdelta=getpv('Topoff_cam_inj_field_delta_SP');
    if isnan(injtrigdelta) || (injtrigdelta>150) || (injtrigdelta<0)
        injtrigdelta=35;
    end

    fprintf('Setting gun width to %d ns\n',12);
    setpv('GTL_____TIMING_AC02',13);
    pause(2);
    setpv('GTL_____TIMING_AC02',12);

    fprintf('Setting booster injection field trigger to %d for single bunch (delta = %d)\n',start_inj_trig+injtrigdelta,injtrigdelta);
    setpv('BR1_____TIMING_AC00',start_inj_trig+injtrigdelta);
                    deltaMRF=round(start_inj_trig_mrf*(injtrigdelta/12500)/250)*250;
                    setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf+deltaMRF);
    
    fprintf('Putting LTB TV6 paddle into linac beam\n');
    setpv('LTB_____TV6____BC19',255);
    pause(2);
    enable_disable_triggers(1);
    
    % Switching bucket loading from table mode to direct bucket control
    fprintf('Bucket loading is controlled directly by this program\n');
    setpv('SR01C___TIMING_AC11',0);
    setpv('SR01C___TIMING_AC13',0);
    
    % Read fill pattern to decide which bucket to target for bunch
    % current equalizer
    bunchQ=getpv('SR1:BCM:BunchQ_WF');
    
    while (getdcct<goalcurr) && (mean(bunchQ(bucketlist))-min(bunchQ(bucketlist))>0.33) ... % below topoff goal and equalizer needed
            && (max(bunchQ(bucketlist))-mean(bunchQ(bucketlist))<1.0) ...                   % safety mechanism - stopif fill pattern gets bad
            && ((getpv('LTB_____TV6____BC19')==0) || open_paddle_flag)                      % Method for operators to stop routine by putting LTB paddle in
            
        bucketlist_corrected=bucketlist;
        rmind = bunchQ(bucketlist)<0.05*mean(bunchQ(bucketlist)); % Do not target bunches with very low charge (potential bug of BCM showing erroneous zero readings for isolated buckets)
        bucketlist_corrected(rmind)=[];
        if ~isempty(bucketlist_corrected)
            [maxdiff,diffind]=max(mean(bunchQ(bucketlist_corrected))-bunchQ(bucketlist_corrected));     % find bunch that has the lowest charge
            next_bucket = bucketlist_corrected(diffind);
            fprintf('Filling low charge bucket %d which is %.2f mA (>0.33 mA) below average (%d buckets left)\n',next_bucket,maxdiff, ...
                sum((mean(bunchQ(bucketlist_corrected))-bunchQ(bucketlist_corrected))>0.33) );
            setpv('SR01C___TIMING_AC08',next_bucket);
            
        else
            disp('All low charge buckets are empty - not filling because this could be BCM error');
            break
        end
        
        if open_paddle_flag == 1
            fprintf('Opening LTB TV6 paddle (if not already open) ...\n');
            setpv('LTB_____TV6____BC19',0);
            open_paddle_flag = 0;
        end
        wait_for_extraction; % wait for extraction
        pause(1.4);

        % Read fill pattern to decide which bucket to target for bunch
        % current equalizer
        bunchQ_new=getpv('SR1:BCM:BunchQ_WF');

        fprintf('Filled bucket %d, delta I = %.2f mA\n',next_bucket,bunchQ_new(next_bucket)-bunchQ(next_bucket));
        if max(abs((bunchQ_new-bunchQ)))<0.01
            warning('topoff_injection_dualcam:BCM','Targeted bucket seems to not accumulate charge - is BCM set up correctly?');
            soundtada;
            break
        end
        bunchQ=bunchQ_new;
    end
    
    if getpv('LTB_____TV6____BC19')
        soundtada;
        disp('The LINAC TV6 paddle was inserted. Terminating equalizer ...');
    end
    
    fprintf('Putting LTB TV6 paddle into linac beam\n');
    setpv('LTB_____TV6____BC19',255);
    pause(0.5);

    if (max(bunchQ)-mean(bunchQ(bucketlist))>1.0)
        soundtada;
        disp('One bunch is more than 1.0 mA higher than average. ');
        disp('This could be because bunch current monitor is mistimed or cam bunch was filled first.');
        disp('Terminating equalizer ...');
    end
    
    fprintf('Setting booster injection field trigger to %d for multi bunch\n',start_inj_trig);
    setpv('BR1_____TIMING_AC00',start_inj_trig);
    setpv('GaussClockInjectionFieldTrigger',start_inj_trig_mrf);
    pause(0.5);
    exit_cleanup
    % exit_cleanup actually disable storage ring injection pulsed magnets (since that is what one wants to do
    % when disabling top-off. However, here we want to go back into a state where Hiroshi's program can continue
    % filling multibunch. So the next three setpv commands accomplish that.
    
    % SR injection thick septum
    setpv('SR01S___SEK_P__BC23',1);
    % SR injection thin septum
    setpv('SR01S___SEN_P__BC22',1);
    % SR injection bumps (4 magnets)
    setpv('SR01S___BUMP1P_BC22',1);
    
    disp('Exiting ...');
    
catch ME
    fprintf('Hitting catch statement ... An error occurred (%s)\n',ME.identifier);
    fprintf('setting booster injection field trigger to %d for multi bunch\n',start_inj_trig);
    setpv('br1_____timing_ac00',start_inj_trig);
    setpv('gaussclockinjectionfieldtrigger',start_inj_trig_mrf);
    
    exit_cleanup
    % exit_cleanup actually disable storage ring injection pulsed magnets (since that is what one wants to do
    % when disabling top-off. however, here we want to go back into a state where hiroshi's program can continue
    % filling multibunch. so the next three setpv commands accomplish that.
    
    % sr injection thick septum
    setpv('SR01S___SEK_P__BC23',1);
    % sr injection thin septum
    setpv('SR01S___SEN_P__BC22',1);
    % sr injection bumps (4 magnets)
    setpv('SR01S___BUMP1P_BC22',1);
    
    % make sure ltb tv3 is retracted
    setpv('LTB_____TV3____BC16',0);
    setpv('LTB_____TV3LIT_BC17',0);
    
    disp('exiting ...');
end

return
                                                                            
% The following routine was originally a separate routine. However, it
% should only be used by topoff software, so it makes more sense to have it
% as a local function in here.
%
% Changes from the original routine include an additional option for a
% variable delay (eps-30 seconds - default is 1 s), as well as a bug fix
% for turn off. Now, if the bunch cleaner gets stuck on (because a turn off
% command does not get executed - which we have seen, potentially because of network
% problems) it will get turned off with the proper delay, the next time after an on command is
% executed.

function setbunchcleaning_local(varargin)
%SETBUNCHCLEANING_LOCAL - Set the bunch cleaning system On or Off
%

%  To turn on:  setbunchcleaning_local('On')
%
%  To turn on:  setbunchcleaning_local('Off')
%

handles=guidata(gcbo);

if (get(handles.CheckboxCleaning, 'Value')== 1)
    
    if nargin < 1
        InputCommand = 'On'; Delay = 1;
    elseif nargin < 2
        InputCommand = varargin{1}; Delay = 1;
    elseif isnumeric(varargin{2})
        InputCommand = varargin{1}; Delay = varargin{2};
    else
        InputCommand = varargin{1}; Delay = 1;
    end
    
    if isnan(Delay)
        Delay = 1;
    end
    
    if (Delay <= 0) || (Delay > 30)
        Delay = 1;
    end
    
%     if (getpvonline('IGPF:TFBY:CLEAN:SPAN')<0.01) & (Delay < 5)
%         Delay = 5;
%     end

    if strcmpi(InputCommand, 'On')
        % Turn on (if it's not already on)
%        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
%        %now using TFB bunch cleaner in Two bunch mode as well
        if 0
            if ~getpv('bcleanEnable')
                setpv('bcleanEnable', 1);
                fprintf('   Bunch cleaning turn on\n');
            end
        else
            if ~strcmp(getpvonline('IGPF:TFBY:CLEAN:ENABLE'),'Enable')
                setpvonline('IGPF:TFBY:CLEAN:ENABLE',1);
                fprintf('   Bunch cleaning turn on for %f s\n',Delay);
            end
        end
        % Turn off
        pause(Delay);
%        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
%        %now using TFB bunch cleaner in Two bunch mode as well
        if 0
            setpv('bcleanEnable', 0);
            fprintf('   Bunch cleaning turn off\n');
        else
            setpv('bcleanEnable', 0);
            setpvonline('IGPF:TFBY:CLEAN:ENABLE',0);
            fprintf('   Bunch cleaning turn off\n');
        end
    else
%        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
%        %now using TFB bunch cleaner in Two bunch mode as well
        if 0
            if getpv('bcleanEnable')
                msgflag = 1;
            else
                msgflag = 0;
            end
            % Turn off
            setpv('bcleanEnable', 0);
            if msgflag
                fprintf('   Bunch cleaning turn off\n');
            end
        else
            if strcmp(getpvonline('IGPF:TFBY:CLEAN:ENABLE'),'Enable')
                msgflag = 1;
            else
                msgflag = 0;
            end
            % Turn off
            setpv('bcleanEnable', 0);
            setpvonline('IGPF:TFBY:CLEAN:ENABLE',0);
            if msgflag
                fprintf('   Bunch cleaning turn off\n');
            end
        end
    end
end

return

function camcurr=getcamcurrent_local(varargin)
% function camcurr=getcamcurrent_local(varargin)
%

global cam_bucket

if nargin < 1
    InputCommand = 'Cam1_current';
else
    InputCommand = varargin{1};
end

if 1    
    bunchQ=getpv('SR1:BCM:BunchQ_WF');
    
    if strcmp(InputCommand,'Cam1_current')
        if ~isempty(cam_bucket)
            camcurr=bunchQ(cam_bucket(1));
        else
            camcurr=0;
        end
    elseif strcmp(InputCommand,'Cam2_current')
        if length(cam_bucket)>1
            camcurr=bunchQ(cam_bucket(2));
        elseif length(cam_bucket)==1
            camcurr=bunchQ(cam_bucket(1));
        else
            camcurr=0;
        end
    else
        camcurr=0;
    end    
else    
    camcurr=getpv(InputCommand);
end
    
if isnan(camcurr)
    camcurr = 0;
end

return
