function varargout = topoff_injection_newtimingsystem(varargin)
%TOPOFF_INJECTION_NEWTIMINGSYSTEM M-file for topoff_injection_newtimingsystem.fig
%      TOPOFF_INJECTION_NEWTIMINGSYSTEM, by itself, creates a new TOPOFF_INJECTION_NEWTIMINGSYSTEM or raises the existing
%      singleton*.
%
%      H = TOPOFF_INJECTION_NEWTIMINGSYSTEM returns the handle to a new TOPOFF_INJECTION_NEWTIMINGSYSTEM or the handle to
%      the existing singleton*.
%
%      TOPOFF_INJECTION_NEWTIMINGSYSTEM('Property','Value',...) creates a new TOPOFF_INJECTION_NEWTIMINGSYSTEM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to topoff_injection_newtimingsystem_openingfcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TOPOFF_INJECTION_NEWTIMINGSYSTEM('CALLBACK') and TOPOFF_INJECTION_NEWTIMINGSYSTEM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TOPOFF_INJECTION_NEWTIMINGSYSTEM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help
% topoff_injection_newtimingsystem

% Revision History:
%
% 2012-12-17 Christoph Steier
% Adjusted extraction wait delays and moved some trigger disable commands to avoid double injector shots that
% happen occasionally due to network delay and can get lost at high energy in the booster.
%
% 2017-09-01 - Major changes to work with the new MRF timing system
%              Removed start_inj_trig and Topoff_cam_inj_field_delta_SP since it gets handled by the timing sequencer
%              Compare against topoff_injection_dualcam.m for all the changes
%
% Last Modified by GUIDE v2.5 06-Sep-2017 21:56:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @topoff_injection_newtimingsystem_OpeningFcn, ...
    'gui_OutputFcn',  @topoff_injection_newtimingsystem_OutputFcn, ...
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

% --- Executes just before topoff_injection_newtimingsystem is made visible.

function topoff_injection_newtimingsystem_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)


% Choose default command line output for topoff_injection_newtimingsystem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes topoff_injection_newtimingsystem wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% Location on Screen (GP: add 9/2009)
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
    set(handles.CheckboxCAM,                   'Value', 0);
    set(handles.CheckboxBunchCurrentEqualizer, 'Value', 0);         % New bunch current equalizer that fills low current buckets disabled in two bunch
    set(handles.CheckboxCleaning,              'Value', 1);
    set(handles.FillCamBuckets,                'Enable', 'off');
    set(handles.EqualizeFill,                  'Enable', 'off');
else
    set(handles.CheckboxCAM,                   'Value', 1);
    set(handles.CheckboxBunchCurrentEqualizer, 'Value', 1);          % New bunch current equalizer that fills low current buckets is now default in multibunch modes.
    set(handles.CheckboxCleaning,              'Value', 1);
end

set(handles.TopOffStaticTextMode,   'String',sprintf(' %s',getfamilydata('OperationalMode')),'ForegroundColor',[0 0 0]);
set(handles.TopOffStaticTextModeCAM,'String',sprintf(' '),'ForegroundColor',[0 0 0]);

set(handles.CheckboxLINAC,    'Value', 0);
set(handles.CheckboxBooster,  'Value', 0);
set(handles.CheckboxBTS,      'Value', 0);
set(handles.CheckboxParasite, 'Value', 0);

setappdata(handles.TOPOFF, 'TOPOFF_FLAG', 0);

set(handles.TopOffStop, 'Enable', 'off');

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.FillCamBuckets, 'Enable', 'off');
    set(handles.CheckboxCAM,    'Enable', 'off');
    set(handles.CheckboxBunchCurrentEqualizer, 'Enable', 'off');    % New bunch current equalizer that fills low current buckets disabled in two bunch
else
    set(handles.FillCamBuckets, 'Enable', 'on');
    set(handles.CheckboxCAM,    'Enable', 'on');
    set(handles.CheckboxBunchCurrentEqualizer, 'Enable', 'on');     % New bunch current equalizer can be enabled by user in multibunch mode
end

global startbias cam_bucket % start_rf_gain 

% Recheck the fill pattern if Physics10 changed
[fill_pattern, cam_bucket, GunBunches] = fillpattern_local;


% start_rf_gain=getpv('BR4_____XMIT___GNAC01');
% if (start_rf_gain < 0.2) || (start_rf_gain>0.75)
%     start_rf_gain=0.745;
% end

startbias = 30;   % ???

% Setup the ztec for the BTS ICTs
try
    fprintf('   Setting the BTS ICT ztec scope parameters.\n');
    ztec = als_waveforms_setup('BTS ICTs');
    ztec = ztec_setup(ztec);
catch
    fprintf('An error occurred setting the ztec scope.  Check the scope with als_waveforms!\n');
end

    
function [fill_pattern, cam_bucket, GunBunches] = fillpattern_local

GunBunches = 4;

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
    GunBunches = 1;
end


% --- Executes on button press in TopOffStop.
function TopOffStop_Callback(~, ~, handles)
setappdata(handles.TOPOFF, 'TOPOFF_FLAG', 0);



% --- Executes on button press in TopOffStart.
function TopOffStart_Callback(~, ~, handles)

global startbias cam_bucket   % start_rf_gain

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

minimumdt = 14.0;      % minimum time between injectiions [s]
minimumeff = 0.4;      % injection efficiency at which alarm happens (fraction of 1.0)

PreSRInjPrepTime = 1.4 + 1.4 + .2;

% Adds a BR cycle to pulse the non-SR fast magnets one cycle before injection
SR_PrepFlag = 0;
if SR_PrepFlag
    PreSRInjPrepTime = PreSRInjPrepTime + 1.4;  % Add another cycle
end

% Last bucket filled (could be by topoff, bucketloading, ...)
a = getpv('TimInjReq');
BucketNumber = a(1);  % getpv('TimTargetBucket') isn't right

goalcurr = getpv('Topoff_goal_current_SP');          % current to keep [mA]
if (goalcurr>500) || (goalcurr<17)
    goalcurr=500;
    setpvonline('Topoff_goal_current_SP',goalcurr);
end
goalcurr_cam = getpv('Topoff_cam_goal_current_SP');        % target current for cam_bucket [mA]
if (goalcurr_cam>5) || (goalcurr_cam<0.5)
    goalcurr_cam=2;
    setpvonline('Topoff_cam_goal_current_SP',goalcurr_cam);
end
max_cam_freq = 6;    % cam bucket is not targeted more often than every (6+1)=7th shot

% Recheck the fill pattern if Physics10 changed
[fill_pattern, cam_bucket, GunBunches] = fillpattern_local;

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
        setpvonline('Topoff_goal_current_SP',goalcurr);
    end
end

set(handles.TopOffStaticTextMode,'String',sprintf(' %s, Goal Current = %d mA',getfamilydata('OperationalMode'),goalcurr),'ForegroundColor',[0 0 0]);

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.TopOffStaticTextModeCAM,'String',sprintf(' '),'ForegroundColor',[0 0 0]);
else
    set(handles.TopOffStaticTextModeCAM,'String',sprintf(' CAM Goal Current = %.1f mA',goalcurr_cam),'ForegroundColor',[0 0 0]);
end

% startbias = getpv('EG______BIAS___AC01');
startbias = 30;
if startbias > 50
    startbias = 30;
end

% start_rf_gain=getpv('BR4_____XMIT___GNAC01');

fprintf('\n\n');

% Make sure bucket loading is stopped!!!
if getpvonline('bucket:control:cmd', 'double') ==  1
    fprintf('   It''s best to stop bucket loading when a fill is complete.\n');
    fprintf('   It must be stopped for when the shutters are open!!!\n');
    fprintf('   I''ll stop it before starting topoff but please verify it is off.\n\n');
    setpvonline('bucket:control:cmd', 0);
    soundquestion_nobits;
    pause(2);
end


bcminit_local;

% Open all paddles
OpenAllPaddles;
fprintf('Opening all paddles (if not already open) ...\n');


tmpindex=find(fill_pattern == BucketNumber);
if ~isempty(tmpindex)
    bunch_index=tmpindex(1) + 1;  % Added a +1 since BucketNumber was the last one filled (GJP 2017-09-01)
    if bunch_index > length(fill_pattern)
        bunch_index=1;
    end
else
    bunch_index=1;
end

% pre-initialize all local variables that might be displayed/used before being assigned a value below
cam_counter=0;last_cam_index=1;
inj_single=0;
paddle_index=0;
booster_counter=0;
bts_counter=0;
cleaning_counter=0;
tv1pos=0;tv3pos=0;tv4pos=0;tv5pos=0;tv6pos=0;
btstv1pos=0;btstv2pos=0;btstv3pos=0;btstv4pos=0;btstv5pos=0;btstv6pos=0;
br1tv1pos=0;br1tv2pos=0;br1tv3pos=0;br3tv1pos=0;br4tv1pos=0;

BucketNumber = fill_pattern(bunch_index);
InhibitFlag = 0;

% Disable buttons
set(handles.TopOffStart,    'Enable', 'off');
set(handles.EditParams,     'Enable', 'off');
set(handles.TopOffStop,     'Enable', 'on');
set(handles.FillCamBuckets, 'Enable', 'off');
set(handles.EqualizeFill,   'Enable', 'off');

[StateNumber, StateString] = getsrstate;
if StateNumber >= 0
    set(handles.InfoText,'String',StateString,'ForegroundColor','b');
else
    set(handles.InfoText,'String',StateString,'ForegroundColor','r');
end
drawnow;

t1 = 0;     % variable used to check whether EPICS timestamp of beam current is stale
WarnNum=0;  % loop variable to avoid sendingt an alarm on every cycle

TimeAtLastSRInjection = gettime - minimumdt - PreSRInjPrepTime + .2;  % Initialize with an immediate injection
TuningModeInProgress = 0;

                    
%%%%%%%%%%%%%%%%%%%%%%%
% Start TO Loop %
%%%%%%%%%%%%%%%%%%%%%%%

% Sync to the start of the booster cycle
[Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, Timeout after 2 seconds

while 1
    TimeSinceLastSRInjection = gettime - TimeAtLastSRInjection;   % Seconds
    if abs(TimeSinceLastSRInjection)>1800    % This patch is necessary to deal with switching from PDST to PST
        TimeAtLastSRInjection = gettime;
        TimeSinceLastSRInjection = 0;  
    end

    try
        set(handles.TopOffStaticTextBucket,   'String', sprintf('Bucket = %d',     BucketNumber), 'ForegroundColor', [0 0 0]);  %%% Check how these get updated???
        set(handles.TopOffStaticTextGunWidth, 'String', sprintf('Gun bunches = %d',GunBunches),   'ForegroundColor', [0 0 0]);
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
        curr_meas_time = gettime; 
        [startcurr,tout,t2,errnum] = getdcct; 
        %startcurr2 = getpvonline('SR09S___DCCT___AM03');    % IRM alias channel for sector 9 DCCT (same as SR:DCCT which is used by cmm:beam_current in getdcct)
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
        
        % Check if the booster is ramping to 1.9 GeV  (was based on BR Bend max amps)
        BoosterErrorFlag = 0;
        if getpvonline('TimExtrFieldCounterRaw') < 270000    % The 1.9 GeV value is about 294200, the measurement stops in energy saving at ~200,000
            soundquestion_nobits;
            fprintf('Gauss clock ticks are low -> Is the booster ramping to 1.9 GeV (energy saver off, ...)?\n');
            BoosterErrorFlag = 1;
        end
                
        if BoosterErrorFlag
            % Not sure what to do here.  Pause and see if the condition eventually gets cleared by the operators. 
            pause(5);
            
        elseif (startcurr<16)
            fprintf('Beam current is below interlock threshold!\n');
            % exit_cleanup;      % exit cleanup will already be called below
            fprintf('Stopping top-off injection!\n');
            soundquestion_nobits;
            break;
        elseif (getpvonline('ETI_SR_INJ_MODE_DBNCA','double')~=1) || (getpvonline('ETI_SR_INJ_MODE_DBNCB','double')~=1) || (getpvonline('ETI_TOP_OFF_MODE_DBNCA','double')~=1)  || (getpvonline('ETI_TOP_OFF_MODE_DBNCB','double')~=1)
            fprintf('Top-off Interlock has tripped (Top-off Mode or Inj Mode went to zero in readback from ETI chassis)!\n');
            % exit_cleanup;      % exit cleanup will already be called below
            fprintf('Stopping top-off injection!\n');
            soundquestion_nobits;
            break;
        elseif (getpvonline('ETI_SR_ENERGY_MATCH_LATCHA','double')~=1) || (getpvonline('ETI_SR_ENERGY_MATCH_LATCHB','double')~=1)
            fprintf('Top-off Interlock has tripped (Energy Match Interlock)!\n');
            % exit_cleanup;      % exit cleanup will already be called below
            fprintf('Stopping top-off injection!\n');
            soundquestion_nobits;
            break;
        elseif (getpvonline('ETI_SR_LATTICE_MATCH_LATCHA','double')~=1) || (getpvonline('ETI_SR_LATTICE_MATCH_LATCHB','double')~=1)
            fprintf('Top-off Interlock has tripped (Lattice Match Interlock)!\n');
            % exit_cleanup;      % exit cleanup will already be called below
            fprintf('Stopping top-off injection!\n');
            soundquestion_nobits;
            break;
        % The following lines are currently commented out, since there has been a readback problem of the topoff interlock - however, the functionality of stopping topoff
        % is still provided by the getdcct < 16 mA check above
        % elseif (getpvonline('ETI_SR_BEAM_I_LATCHA')~=1) || (getpvonline('ETI_SR_BEAM_I_LATCHB')~=1)
        %     fprintf('Top-off Interlock has tripped (Beam Current Interlock)!\n');
        %     % exit_cleanup;      % exit cleanup will already be called below
        %     fprintf('Stopping top-off injection!\n');
        %     soundquestion_nobits;
        %     break;
        elseif (getpvonline('SRBeam_Mag_I_MonA','double')>505)
            fprintf('Topoff beam current interlock channel A reports current > 505 mA!\n');
            % exit_cleanup;      % exit cleanup will already be called below
            fprintf('Stopping top-off injection!\n');
            soundquestion_nobits;
            break;
        elseif (startcurr<goalcurr) && (TimeSinceLastSRInjection > (minimumdt - PreSRInjPrepTime))  
            % Topoff
            % Note 1: this if state is already sync'd to the start of the booster cycle
            % Note 2: a booster cycle gets added back later for removing paddles
            t1=t2;

            % Read fill pattern from bunch current monitor to allow for bunch current equalizer to work (measured at injection cycle start)
            bunchQ = getpvonline('SR1:BCM:BunchQ_WF');   % bunchQ should be the bunch current before injection (bunchQnew is read after injection)
            
            % There is time to set the bias here???
            
            % Storge ring prep: add to BR cycle to trigger most of the fast magnets
            % If we need this, mode 41 needs to be defined. Presently it the same as the default mode???
            if SR_PrepFlag
                % Needs to be tested???
                if (get(handles.CheckboxBTS, 'Value')== 1)
                    % BTS tuning is the same as a storage ring prep
                    Mode = 30;
                    TimInjReq = singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag);
                else
                    % BTS tuning with a gun inhibit is the SR prep for now
                    % Should use mode 41 but the storage ring injection prep mode is not set properly at the moment
                    Mode = 30;
                    TimInjReq = singleshotinjection(BucketNumber, GunBunches, Mode, 1);
                end
                [Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, Timeout after 2 seconds
            end           
            
            %%% Should always check if a paddle is in???
            if (get(handles.CheckboxLINAC, 'Value')== 1)
                paddle_index=paddle_index+1;
                tv1pos=getpvonline('LTB_____TV1____BC16', 'double');
                tv3pos=getpvonline('LTB_____TV3____BC16', 'double');
                tv4pos=getpvonline('LTB_____TV4____BC18', 'double');
                tv5pos=getpvonline('LTB_____TV5____BC16', 'double');
                tv6pos=getpvonline('LTB_____TV6____BC19', 'double');
                fprintf('Pulling LTB paddles for top-off injection (if not already open)\n');
                % setpvonline('BR4_____XMIT___GNAC01',start_rf_gain);
                setpvonline('LTB_____TV1____BC16',0);
                setpvonline('LTB_____TV3____BC16',0);
                setpvonline('LTB_____TV4____BC18',0);
                setpvonline('LTB_____TV5____BC16',0);
                setpvonline('LTB_____TV6____BC19',0);
                % pause(2);
            end
            if (get(handles.CheckboxBooster, 'Value')== 1)
                booster_counter=booster_counter+1;
                br1tv1pos=getpvonline('BR1_____TV1____BC18', 'double');
                br1tv2pos=getpvonline('BR1_____TV2____BC16', 'double');
                br1tv3pos=getpvonline('BR1_____TV3____BC18', 'double');
                br3tv1pos=getpvonline('BR3_____TV1____BC16', 'double');
                br4tv1pos=getpvonline('BR4_____TV1____BC16', 'double');
                fprintf('Pulling Booster paddles for top-off injection (if not already open)\n');
                setpvonline('BR1_____TV1____BC18',0);
                setpvonline('BR1_____TV2____BC16',0);
                setpvonline('BR1_____TV3____BC18',0);
                setpvonline('BR3_____TV1____BC16',0);
                setpvonline('BR4_____TV1____BC16',0);
                % pause(2);
            end
            if (get(handles.CheckboxBTS, 'Value')== 1)
                bts_counter=bts_counter+1;
                btstv1pos=getpvonline('BTS_____TV1____BC16', 'double'); % I would add a stale from the present time
                btstv2pos=getpvonline('BTS_____TV2____BC18', 'double');
                btstv3pos=getpvonline('BTS_____TV3____BC18', 'double');
                btstv4pos=getpvonline('BTS_____TV4____BC16', 'double');
                btstv5pos=getpvonline('BTS_____TV5____BC18', 'double');
                btstv6pos=getpvonline('BTS_____TV6____BC20', 'double');
                fprintf('Pulling BTS paddles for top-off injection (if not already open)\n');
                setpvonline('BTS_____TV1____BC16',0);
                setpvonline('BTS_____TV2____BC18',0);
                setpvonline('BTS_____TV3____BC18',0);
                setpvonline('BTS_____TV4____BC16',0);
                setpvonline('BTS_____TV5____BC18',0);
                setpvonline('BTS_____TV6____BC20',0);
                % pause(2);
            end
            
            % There might be a chance that beam gets unintentionally
            % cleaned out if bunch cleaner is left on - have observed this
            % sometimes before that single network commands to bunch
            % cleaner get lost. So before every injection the cleaner gets
            % checked and if it is still on, it is switched off.
            %  if getpvonline('bcleanEnable')
            %      setpvonline('bcleanEnable',0);
            %      disp('Found bunch cleaning on before injection ... Turning it OFF');
            %  end
            setbunchcleaning_local('Off');
                                    
            % setpvonline('BR1_____QD_PSREBC00',1);     % temporary workaround, only pulse booster QD when needed, to lower temperature of choke
            % setpvonline('BR1_____QF_PSREBC00',1);     % temporary workaround, only pulse booster QF when needed, to lower temperature of choke
            
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
                       
            Mode = 40;  % Storage ring injection
            TimInjReq = singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag);
            
            % Sync to the start of the next booster cycle to allow for paddle delays etc.
            [Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, since that's when this cycle with start
            
            [btscharge,extractflag] = wait_for_extraction;
            tmp = TimeAtLastSRInjection;
            TimeAtLastSRInjection = gettime;  % At the start of the booster cycle (about .4 seconds earlier than extraction)
            TimeBetweenFills = TimeAtLastSRInjection - tmp;

            % setpvonline('BR1_____QD_PSREBC00',0);     % temporary workaround, only pulse booster QD when needed, to lower temperature of choke
            % setpvonline('BR1_____QF_PSREBC00',0);     % temporary workaround, only pulse booster QF when needed, to lower temperature of choke     
            
            if TuningModeInProgress && get(handles.CheckboxLINAC, 'Value')== 1
                fprintf('Putting LTB paddles back into previous position for LINAC tuning\n');
                % start_rf_gain=getpvonline('BR4_____XMIT___GNAC01');
                % setpvonline('BR4_____XMIT___GNAC01',0);
                setpvonline('LTB_____TV1____BC16',tv1pos);
                setpvonline('LTB_____TV3____BC16',tv3pos);
                setpvonline('LTB_____TV4____BC18',tv4pos);
                setpvonline('LTB_____TV5____BC16',tv5pos);
                setpvonline('LTB_____TV6____BC19',tv6pos);
            end
            
            if TuningModeInProgress && get(handles.CheckboxBooster, 'Value')== 1
                fprintf('Putting Booster paddles back into previous position for Booster tuning\n');
                setpvonline('BR1_____TV1____BC18',br1tv1pos);
                setpvonline('BR1_____TV2____BC16',br1tv2pos);
                setpvonline('BR1_____TV3____BC18',br1tv3pos);
                setpvonline('BR3_____TV1____BC16',br3tv1pos);
                setpvonline('BR4_____TV1____BC16',br4tv1pos);
            end
            
            if TuningModeInProgress && get(handles.CheckboxBTS, 'Value')== 1
                fprintf('Putting BTS paddles back into previous position for BTS tuning\n');
                setpvonline('BTS_____TV1____BC16',btstv1pos);
                setpvonline('BTS_____TV2____BC18',btstv2pos);
                setpvonline('BTS_____TV3____BC18',btstv3pos);
                setpvonline('BTS_____TV4____BC16',btstv4pos);
                setpvonline('BTS_____TV5____BC18',btstv5pos);
                setpvonline('BTS_____TV6____BC20',btstv6pos);
            end
            
            if extractflag==0
                soundquestion_nobits;
                fprintf('Timeout, no extraction reached!\n');
                inj_rate = 0;
                setpvonline('BTS_To_SR_Injection_Rate',   0);
                setpvonline('BR_To_BTS_Extracted_Charge', 0);
                if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') && (get(handles.CheckboxCleaning, 'Value')== 1) && (BucketNumber~=319)
                    setbunchcleaning_local('On');
                    cleaning_counter=cleaning_counter+1;
                %else
                %    pause(0.5);
                end
                bunchQ_new=getpvonline('SR1:BCM:BunchQ_WF');
            else
                if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch') && (get(handles.CheckboxCleaning, 'Value')== 1) && (BucketNumber~=319)
                    setbunchcleaning_local('On');
                    cleaning_counter=cleaning_counter+1;
                %else
                %    pause(1.5);
                end
                
                % BCM sync's to evt 70, so .3 seconds after extraction should be enough for new data.
                % DCCT should only need .2 seconds of delay after extraction
                % Can add more than .3 delay here since a new request will miss the next cycle anyways 
                pause(1.0);
                
                time_diff = (gettime-curr_meas_time); 
                lifetime  = getpvonline('Topoff_lifetime_AM');       % Who is computing this???
                stopcurr  = getdcct;    % Has some over head in getdcct
                %stopcurr2 = getpvonline('SR09S___DCCT___AM03');           % IRM channel for sector 9 DCCT. Same as cmm:beam_current which uses SR:DCCT  (GJP 2017-09-01)???
               
                % if (time_diff < 1) || (time_diff>60)
                %     time_diff = 1.4;
                % end
                if (lifetime < 0.2) || (lifetime > 20)
                    lifetime = 5;
                end
                
                eff  = ((stopcurr -(startcurr -time_diff*startcurr /3600/lifetime))/1.5)/(btscharge/5);
                %eff2 = ((stopcurr2-(startcurr2-time_diff*startcurr2/3600/lifetime))/1.5)/(btscharge/5);
                %eff3 = ((stopcurr2-(startcurr2-      2.0*startcurr2/3600/lifetime))/1.5)/(btscharge/5);
                
                %inj_rate = (stopcurr2-(startcurr2-time_diff*startcurr2/3600/lifetime));
                inj_rate = (stopcurr-(startcurr-time_diff*startcurr/3600/lifetime));
                fprintf('%s:  Injection efficiency %g    Time between SR fills %.2f\n', datestr(now), eff, TimeBetweenFills);
                
                %BCMDelay = 0;  % Not needed since there is delay above for the DCCT after extraction (was 2)
                %pause(BCMDelay);
                bunchQ_new=getpvonline('SR1:BCM:BunchQ_WF');
                
                if (GunBunches>1) || strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')  % Why would GunBunches be > 1 in To-Bunch ???
                    setpvonline('BTS_To_SR_Injection_Efficiency', eff);
                    setpvonline('BTS_To_SR_Injection_Rate', inj_rate);
                    setpvonline('BR_To_BTS_Extracted_Charge',btscharge/5);
                end

                if eff<minimumeff
                    if get(handles.CheckboxLINAC, 'Value') || get(handles.CheckboxBooster, 'Value') || get(handles.CheckboxBTS, 'Value')
                        fprintf('Injection efficiency is low - audible warning is disabled in LINAC/Booster/BTS tuning mode\n');
                    else
                        soundquestion_nobits;
                        fprintf('Injection efficiency is low\n');
                    end
                end
                
                % The following section checks if a single bunch injection happened, within the multibunch bunch
                % train (i.e. an injection commanded by the bunch current equalizer), whether
                % the targeted bunch increased by at least 0.25*injection_rate. If not, the
                % bunch equalizer gets de-selected (fail safe handling
                % that should capture a stalled BCM or if the BCM is shifted by
                % one or more buckets).

                if inj_single==1
                    if any(BucketNumber==bucketlist)  % This should always to true
                        if ((bunchQ_new(BucketNumber)-bunchQ(BucketNumber))<(0.25*inj_rate)) && (inj_rate>0.2)
                            soundquestion_nobits;
                            fprintf('Bunch current of targeted low current bunch increased by less than %.2f mA - Is the bunch current monitor working?\n',0.25*inj_rate);
                            disp('Disabling bunch current equalizer for now!');
                            set(handles.CheckboxBunchCurrentEqualizer, 'Value', 0);  % Do we want to give it another try before stopping???
                        end
                    end
                end
            end
            
            % Increment the fill counters and pick the next bucket
            LastBucketNumber = BucketNumber;
            bunch_index=bunch_index+1;
            cam_counter=cam_counter+1;
            if bunch_index>length(fill_pattern)
                bunch_index=1;
            end

            if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                cam1now=getcamcurrent_local('Cam1_current');cam2now=getcamcurrent_local('Cam2_current');
                if ((cam1now~=startcam1) || (cam2now~=startcam2)) && (cam1now>5) && (cam1now<startcurr)  && (cam2now>5) && (cam2now<startcurr)
                    if cam1now<cam2now
                        BucketNumber = fill_pattern(1);
                    else
                        BucketNumber = fill_pattern(2);
                    end
                else
                    BucketNumber = fill_pattern(bunch_index);
                end
            else
                BucketNumber = fill_pattern(bunch_index);
            end

            if length(cam_bucket)==1
                cam_curr=getcamcurrent_local('Cam2_current');
            else
                cam_curr=min([getcamcurrent_local('Cam1_current') getcamcurrent_local('Cam2_current')]);
            end
           
            % The following section determines which bucket to target next
            % if bunch current equalizer is selected. It has a lower
            % priority than CAM targeting, i.e. it only gets executed if
            % minimum number of injections since last single bunch
            % injection has elapsed, and CAM bucket is still above goal.
            % Threshold is that at least one bunch of multibunch train has
            % to be low by 0.28 mA compared to average of multibunch train.
            if (cam_counter>max_cam_freq) && (cam_curr>goalcurr_cam) && (mean(bunchQ_new(bucketlist))-min(bunchQ_new(bucketlist))>0.28) && (get(handles.CheckboxBunchCurrentEqualizer, 'Value')== 1)

                goalcurr = getpvonline('Topoff_goal_current_SP')+0.4;

                bucketlist_corrected=bucketlist;
                rmind = bunchQ_new(bucketlist)<0.05*mean(bunchQ_new(bucketlist)); % Do not target bunches with very low charge (potential bug of BCM showing erroneous zero readings for isolated buckets)
                bucketlist_corrected(rmind)=[];
                if ~isempty(bucketlist_corrected)
                    [maxdiff,diffind]=max(mean(bunchQ_new(bucketlist_corrected))-bunchQ_new(bucketlist_corrected));     % find bunch that has the lowest charge
                    BucketNumber = bucketlist_corrected(diffind);
                    fprintf('Filling low charge bucket next: Targeting bucket %d which is %.2f mA below average\n',BucketNumber,maxdiff);
                    cam_counter=0;          % Reset cam counter, so that next single bunch injection does not happen before minimum interval set above            
                    
                    GunBunches = 1;
                    startbias=getpvonline('EG______BIAS___AC01');
                    setpvonline('EG______BIAS___AC01',23.7);

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
                    % on and afterwards the BIAS is returned to multibunch settings.
                    inj_single=1;                  
                else
                    disp('Empty bucketlist_corrected - all bunches seem to be close to nominal charge / or empty');
                end

            elseif (cam_counter>max_cam_freq) && (cam_curr<goalcurr_cam) && (get(handles.CheckboxCAM, 'Value')== 1)
                fprintf('Filling CAM bucket next\n');
                goalcurr = getpvonline('Topoff_goal_current_SP')+0.4;
                
                fprintf('current cam current = %g, %g mA\n',getcamcurrent_local('Cam1_current'),getcamcurrent_local('Cam2_current'));
                cam_counter=0;
                if length(cam_bucket)==1
                    BucketNumber = cam_bucket(1);
                    last_cam_index=1;
                else
                    if (getcamcurrent_local('Cam1_current')>1) && (getcamcurrent_local('Cam2_current')>1)
                        if getcamcurrent_local('Cam1_current') < getcamcurrent_local('Cam2_current')
                            BucketNumber = cam_bucket(1);
                            last_cam_index=1;
                        else
                            BucketNumber = cam_bucket(2);
                            last_cam_index=2;
                        end
                    else
                        if last_cam_index>1
                            BucketNumber = cam_bucket(1);
                            last_cam_index=1;
                        else
                            BucketNumber = cam_bucket(2);
                            last_cam_index=2;
                        end
                    end
                end            
                
                GunBunches = 1;
                startbias=getpvonline('EG______BIAS___AC01');
                
                if (get(handles.CheckboxCleaning, 'Value')== 1)
                    setpvonline('EG______BIAS___AC01',23.7);
                elseif getpvonline('EG______BIAS___AC01')>34
                    setpvonline('EG______BIAS___AC01',34);
                end
                
                bunch_index=bunch_index-1;
                if bunch_index<1
                    bunch_index=length(fill_pattern);
                end
                inj_single=1;
            else
                if inj_single==1
                    if (get(handles.CheckboxCleaning, 'Value')== 1)
                        if ((BucketNumber==(cam_bucket(end)+4)) || (BucketNumber==(cam_bucket(1)+4)))
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
                    goalcurr = getpvonline('Topoff_goal_current_SP');

                    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                        if (goalcurr>40) || (goalcurr<17)
                            disp('Goal current value outside of range for twobunch, defaulting to 35 mA');
                            goalcurr=35;
                            GunBunches = 4;
                            setpvonline('Topoff_goal_current_SP',goalcurr)
                        end
                    else
                        disp('Returning BIAS to multibunch values');
                        
                        GunBunches = 4;  % Was gunwidth (setpvonline('GTL_____TIMING_AC02',gunwidth)), should I force 4 or will it automatically be right??? what if multibunch is 3???
                        
                        setpvonline('EG______BIAS___AC01',startbias);
                        if (goalcurr>500) || (goalcurr<17)
                            disp('Goal current value outside of range for multibunch, defaulting to 500 mA');
                            goalcurr=500;
                            setpvonline('Topoff_goal_current_SP',goalcurr);
                        end
                    end
                    
                end
            end
            
            if (get(handles.CheckboxParasite, 'Value')== 1)
                if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                    fprintf('Intentionally filling parasite bunch into bucket 319, will pause cleaning for 1 shot!\n');
                    BucketNumber = 319;
                else
                    fprintf('Intentionally filling parasite bunch into bucket %d, will pause cleaning for 10 s afterwards!\n',cam_bucket(end)+4);
                    BucketNumber = cam_bucket(end)+4;
                    setpvonline('EG______BIAS___AC01',36);  % 36?  Is this just a know parasite producer bias???
                end
                set(handles.CheckboxParasite, 'Value', 0);
                GunBunches = 1;
                inj_single=1;
            end

            % The following section is a feature. It was added because several non-timing users (including Matthew Marcus) had complained about
            % the distortion the normal two bunch cleaning causes to the beam. So now cleaning after most injections only targets the 8 ns parasite
            % coming from the injector (similar to multi bunch mode, just with slightly different bunch numbers, i.e. main bunches are 154 and 318, whereas dual
            % cam buckets are 150 and 318). Only after every 20th injection are all bunches (besides the two main ones) targeted for cleaning to avoid
            % slow buildup of diffusion from Touschek scattering. This new feature has been active since the second 2bunch run in 2011. C. Steier
            if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                if (cleaning_counter>20) || (BucketNumber==319)
                    cleaning_counter=0;
                    switch_bclean_settings(0);
                else
                    switch_bclean_settings(1);
                end
            end
                        
            set(handles.TopOffStaticTextBucket,'String',sprintf('Bucket = %d',BucketNumber),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextGunWidth,'String',sprintf('Gun Bunches = %d',GunBunches),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextCurrent,'String',sprintf('Current = %.1f mA, CAM = %.1f, %.1f mA',getdcct,getcamcurrent_local('Cam1_current'),getcamcurrent_local('Cam2_current')),'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextEfficiency,'String',sprintf('BTS = %.2f nC, efficiency = %.2f',btscharge/5,eff),'ForegroundColor',[0 0 0]);
            drawnow;          
            
        else
            % No errors, no SR injection -> time of other stuff
            
            % Check if the tuning checkboxes are off (can happen by operator or counter)
            if (get(handles.CheckboxLINAC, 'Value')== 0) && (get(handles.CheckboxBooster, 'Value')== 0) && (get(handles.CheckboxBTS, 'Value')== 0)
                TuningModeInProgress = 0;
            else
                
                % Don't start tuning until after an SR injection
                % If way below the goal current, are tuning modes allowed?
                if TuningModeInProgress || (minimumdt - TimeSinceLastSRInjection) > 7   % Should be time on the lifetime (ie, estimated time until the next fill)
                    % Look for a tuning requiest
                    if (get(handles.CheckboxLINAC, 'Value')== 1)
                        Mode = 10;
                    elseif (get(handles.CheckboxBooster, 'Value')== 1)
                        Mode = 20;
                    elseif (get(handles.CheckboxBTS, 'Value')== 1)
                        Mode = 30;
                    else
                        Mode = 0;
                    end
                    
                    if Mode
                        TuningModeInProgress = 1;
                        TimInjReq = singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag);
                        % I could set the bias here and always tune into bucket 1 with 4 gun bunches???
                        %TimInjReq = singleshotinjection(1, 4, Mode, InhibitFlag);
                        
                        % Sync to the start of the booster cycle
                        [Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, Timeout after 2 seconds
                    end
                end
            end
            
            % Add some delay just slow down the while loop a touch
            if TuningModeInProgress == 0
                pause(.05);
            else
                pause(.02);
            end
            
            % Contantly check to make sure bucket loading is stopped!!!
            if getpvonline('bucket:control:cmd', 'double') ==  1
                fprintf('\n\n');
                fprintf('   It''s best to stop bucket loading when a fill is complete.\n');
                fprintf('   It must be stopped for when the shutters are open!!!\n');
                fprintf('   I''ll stop it before filling the cam bucket but please verify it is off.\n\n');
                setpvonline('bucket:control:cmd', 0);
                soundquestion_nobits;
            end
        end   % End of huge if statement
        
        if getappdata(handles.TOPOFF, 'TOPOFF_FLAG') == 0
            % Stop TopOff and clean up
            break
        end
        
        
    catch ME
        fprintf('An error occurred (%s) ... Exiting program\n',ME.identifier);
        exit_cleanup;
        try
            % Enable buttons
            set(handles.TopOffStart, 'Enable', 'on');
            set(handles.EditParams,  'Enable', 'on');
            set(handles.TopOffStop,  'Enable', 'off');
            if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
                set(handles.FillCamBuckets, 'Enable', 'off');
            else
                set(handles.FillCamBuckets, 'Enable', 'on');
                set(handles.EqualizeFill,   'Enable', 'on');
            end
            
            set(handles.TopOffStaticTextBucket,     'String', sprintf('Bucket = ____'),                      'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextGunWidth,   'String', sprintf('Gun Bunches = ____'),                 'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextCurrent,    'String', sprintf('Current = ____ mA, CAM = __, __ mA'), 'ForegroundColor',[0 0 0]);
            set(handles.TopOffStaticTextEfficiency, 'String', sprintf('BTS = ____ nC, efficiency = ____'),   'ForegroundColor',[0 0 0]);
        catch ME
            fprintf('   %s \n',ME.identifier);
            % GUI must have been closed
        end
        return
    end        % End huge try-catch
end            % End huge while loop

% Top-off stopped by operator request or a problem -> reset all parameters

try
    % Enable buttons
    set(handles.TopOffStart,  'Enable', 'on');
    set(handles.EditParams,   'Enable', 'on');
    set(handles.TopOffStop,   'Enable', 'off');
    set(handles.EqualizeFill, 'Enable', 'on');
    if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
        set(handles.FillCamBuckets, 'Enable', 'off');
    else
        set(handles.FillCamBuckets, 'Enable', 'on');
    end
    set(handles.TopOffStaticTextBucket,     'String', sprintf('Bucket = ____'),                      'ForegroundColor',[0 0 0]);
    set(handles.TopOffStaticTextGunWidth,   'String', sprintf('Gun Bunches = ____'),                 'ForegroundColor',[0 0 0]);
    set(handles.TopOffStaticTextCurrent,    'String', sprintf('Current = ____ mA, CAM = __, __ mA'), 'ForegroundColor',[0 0 0]);
    set(handles.TopOffStaticTextEfficiency, 'String', sprintf('BTS = ____ nC, efficiency = ____'),   'ForegroundColor',[0 0 0]);
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
function varargout = topoff_injection_newtimingsystem_OutputFcn(~, ~, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

    

%-------------------------------------------------
function [btscharge,extractflag, Err]=wait_for_extraction(varargin)

% Note: After you sync to extraction it probably isn't possible to injection in the 
%       next BR cycle.  It's just not enough time to write the data before the timing 
%       sequencer stops waiting and begin preparing for the next BR cycle.

t0 = clock;

Err         = 0;
extractflag = 0;
btscharge1  = 0;
btscharge2  = 0;

try
    trigcnt0 = getpvonline('ztec13:Inp1WaveCount', 'double');
catch ME
    fprintf('Error reading ztec scope (%s)\n',ME.identifier);
    trigcnt0 = 0;
end

% Sync to KE
[Counter, Ts, Err] = synctoevt(48, 4);   % Sync to KE, Timeout after 2 seconds
if Err
    fprintf('Error sync''ing to extraction!!!');
end

% This seems to work, but data from the electronecs looks questionable (2017-09-03 GJP)
%btscharge = getam(['BTS_____ICT01__AM00';'BTS_____ICT02__AM01'], 0:.05:.3);  % These always update and slowly decay -> really difficult to used!!!
%btscharge1 = max(btscharge(1,:));
%btscharge2 = max(btscharge(2,:));

try
    trigcnt1=getpvonline('ztec13:Inp1WaveCount', 'double');
    %BTS_ICT1 = getpvonline(['BTS:ICT1';'BTS:ICT2']);  % From the ztec13 scope, includes offset correction
catch ME
    fprintf('Error reading ztec scope (%s)\n',ME.identifier);
    trigcnt1=trigcnt0;
end

if (trigcnt1>trigcnt0)  % (btscharge1>1.0)  || (btscharge2>1.0) % || (trigcnt1>trigcnt0)
    fprintf('Extraction from booster detected after %.2f seconds.\n', etime(clock,t0));
    extractflag=1;
    % btscharge1=getam('BTS_____ICT01__AM00');
    % btscharge2=(-1)*getam('BTS_____ICT02__AM01');
    % btscharge=max([btscharge1 btscharge2]);
    % if btscharge1>2.0
    %     btscharge=btscharge1;
    %  else
          try    % Check this after moving ztec13 to an MRF trigger
              ictdata=lcaGet('ztec13:Inp1ScaledWave',1000);
              % btscharge=(-1.5*5)*min(ictdata);
              [~,ictind]=min(ictdata);
              btscharge=sum(ictdata(ictind-22:ictind+35))/(-2.92);
          catch ME
              fprintf('Error reading ICT (%s)\n',ME.identifier);
              btscharge=0;
          end
    % end
else
    btscharge=0;
end
% if abs(btscharge1-btscharge2)>1.0
%     disp('BTS ICT1 and ICT2 charge disagrees - there might be problem with one ICT');
% end

return


%-------------------------------------------------
function TimInjReq = singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag)

global TimeOfLastShotRequest   % Just for debug purposes 

handles=guidata(gcbo);
TimInjReq = [];

if nargin<3
    fprintf('  3 or 4 inputs needed in \n');
    return
end
if nargin<3 || isempty(Mode)
    % Look for a tuning requiest
    if (get(handles.CheckboxLINAC, 'Value')== 1)
        Mode = 10;
    elseif (get(handles.CheckboxBooster, 'Value')== 1)
        Mode = 20;
    elseif (get(handles.CheckboxBTS, 'Value')== 1)
        Mode = 30;
    else
        Mode = 0;
    end
end
if nargin<4
    InhibitFlag = 0;
end
%InhibitFlag = 1;   % No gun for testing

if Mode
    TimeOfLastShotRequest0 = TimeOfLastShotRequest;
    TimeOfLastShotRequest  = now;
    if isempty(TimeOfLastShotRequest0)
        TimeOfLastShotRequest0 = TimeOfLastShotRequest;
    end
    
    fprintf('Mode %d, Bucket %d, Gun bunches %d, Bias SP%.1f AM%.1f V  (%s dT=%6.3f from the last request).\n', Mode, BucketNumber, GunBunches, getpvonline('EG______BIAS___AC01'), getpvonline('EG______BIAS___AM01'), datestr(TimeOfLastShotRequest,'HH:MM:SS.FFF'), 24*60*60*(TimeOfLastShotRequest-TimeOfLastShotRequest0));
    TimInjReq = srinjectoneshot(BucketNumber, GunBunches, Mode, InhibitFlag);
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
%     if (any(WF(:,2)~=getpvonline('bcleanSetPattern')')) || (getpvonline('bcleanPatternOffset')~= 0) || (getpvonline('bcleanSetFreqS')~=6000)
%         disp('Switching to cleaning all bunches, except 154 and 318');
%         setpvonline('bcleanSetPattern', WF(:,2)');
%         setpvonline('bcleanPatternOffset', 0);
%         setpvonline('bcleanSetFreqS',6000);
%         pause(1);
%     end
% elseif varargin{1}==1
%     b = zeros(1,328);
%     b((fill_pattern(1)+2):(fill_pattern(1)+6)) =  1;
%     b((fill_pattern(2)+2):(fill_pattern(2)+6)) = -1;
%     if (any(b~=getpvonline('bcleanSetPattern'))) || (getpvonline('bcleanPatternOffset')~= 11) || (getpvonline('bcleanSetFreqS')~=32000)
%         disp('Switching to cleaning only 8 ns parasite bunches after 154 and 318');
%         setpvonline('bcleanSetPattern', b);
%         setpvonline('bcleanPatternOffset', 11);
%         setpvonline('bcleanSetFreqS',32000);
%         pause(1);
%     end
% end

if varargin{1}==0
        disp('Switching to cleaning 6 buckets, each, behind 154 and 318');
        setpvonline('IGPF:TFBX:CLEAN:PATTERN','155:164 319:328');
        setpvonline('IGPF:TFBX:CLEAN:SPAN',0.03);
        pause(1);
elseif varargin{1}==1
        disp('Switching to cleaning only 8 ns parasite behind 154 and 318');
        setpvonline('IGPF:TFBX:CLEAN:PATTERN','156:164 320:328');
        setpvonline('IGPF:TFBX:CLEAN:SPAN',0.03);
end

return
     

%-------------------------------------------------
function exit_cleanup(varargin)
global startbias
%fprintf('Putting LTB TV6 paddle into linac beam (on exit)\n');
%setpvonline('LTB_____TV6____BC19',255);
%pause(2);

%fprintf('Re-enabling injector - but keeping SR injection triggers OFF\n');
% Booster RF
% setpvonline('BR4_____XMIT___GNAC01',start_rf_gain);


if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
else
    fprintf('Setting gun bias to %g (on exit)\n',startbias);
    setpvonline('EG______BIAS___AC01',startbias);
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
    %setpvonline('GTL_____TIMING_BC00',0);
    % setpvonline('BR1_____QD_PSREBC00',0);     % temporary workaround, only pulse booster QD when needed, to lower temperature of choke
    % setpvonline('BR1_____QF_PSREBC00',0);     % temporary workaround, only pulse booster QF when needed, to lower temperature of choke
    setpvonline('LTB_____TV1____BC16',0);
    setpvonline('LTB_____TV3____BC16',0);
    setpvonline('LTB_____TV4____BC18',0);
    setpvonline('LTB_____TV5____BC16',0);
    setpvonline('LTB_____TV6____BC19',0);
    % setpvonline('BR4_____XMIT___GNAC01',start_rf_gain);
end

if get(hObject,'Value') == 1
    fprintf('Putting in LTB TV6 for LINAC tuning (to avoid high energy losses in Booster)\n');  % not needed with tuning mode???
    setpvonline('LTB_____TV6____BC19',1);
    fprintf('Putting in LTB TV3 and switching video channel so that you can optimize LINAC\n');
    
    setpvonline('LTB_____TV3____BC16',255);
    setpvonline('LTB_____TV3LIT_BC17',255);
    % start_rf_gain=getpvonline('BR4_____XMIT___GNAC01');
end


% --- Executes on button press in CheckboxBooster.
function CheckboxBooster_Callback(hObject, ~, ~)
% hObject    handle to CheckboxBooster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 0
    fprintf('Pulling Booster paddles for top-off injection (if not already open)\n');
    fprintf('Also as measure to avoid radiation trips disabling gun trigger\n');

    % setpvonline('BR1_____QD_PSREBC00',0);     % temporary workaround, only pulse booster QD when needed, to lower temperature of choke
    % setpvonline('BR1_____QF_PSREBC00',0);     % temporary workaround, only pulse booster QF when needed, to lower temperature of choke
    setpvonline('BR1_____TV1____BC18',0);
    setpvonline('BR1_____TV2____BC16',0);
    setpvonline('BR1_____TV3____BC18',0);
    setpvonline('BR3_____TV1____BC16',0);
    setpvonline('BR4_____TV1____BC16',0);
end

                                                    
% --- Executes on button press in CheckboxBTS.
function CheckboxBTS_Callback(hObject, ~, ~)
% hObject    handle to CheckboxBTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 0
    fprintf('Pulling BTS paddles for top-off injection (if not already open)\n');
    fprintf('Also as measure to avoid radiation trips disabling gun trigger\n');
    
    % setpvonline('BR1_____QD_PSREBC00',0);     % temporary workaround, only pulse booster QD when needed, to lower temperature of choke
    % setpvonline('BR1_____QF_PSREBC00',0);     % temporary workaround, only pulse booster QF when needed, to lower temperature of choke
    setpvonline('BTS_____TV1____BC16',0);
    setpvonline('BTS_____TV2____BC18',0);
    setpvonline('BTS_____TV3____BC18',0);
    setpvonline('BTS_____TV4____BC16',0);
    setpvonline('BTS_____TV5____BC18',0);
    setpvonline('BTS_____TV6____BC20',0);
end

                                                        
% --- Executes on button press in CheckboxCleaning.
function CheckboxCleaning_Callback(~, ~, ~)
% hObject    handle to CheckboxCleaning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


                                                            
% --- Executes on button press in CheckboxParasite.
function CheckboxParasite_Callback(~, ~, ~)
% hObject    handle to CheckboxParasite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

                                                                
% --- Executes on button press in CheckboxBunchCurrentQualizer.
function CheckboxBunchCurrentEqualizer_Callback(~, ~, ~)
% hObject    handle to CheckboxBunchCurrentEqualizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

                                                                    
% --- Executes on button press in EditParams.
function EditParams_Callback(~, ~, ~)
% hObject    handle to EditParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

goalcurrent = getpvonline('Topoff_goal_current_SP');
if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    if (goalcurrent>40) || (goalcurrent<17)
        disp('Goal current value outside of range for twobunch, defaulting to 35 mA');
        setpvonline('Topoff_goal_current_SP',35)
    end
end

prompt={'Goal Current', 'CAM Goal Current'};
def={num2str(getpvonline('Topoff_goal_current_SP')), num2str(getpvonline('Topoff_cam_goal_current_SP'))};
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

    try
        setpvonline('Topoff_goal_current_SP',goal);
        setpvonline('Topoff_cam_goal_current_SP',camgoal);

        fprintf('   Setting new topoff parameters: Goal = %d mA, CAM goal = %.1f, %.1f mA\n',goal,camgoal,camgoal);
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

handles=guidata(gcbo);

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

set(handles.EditParams,   'Enable', 'off');
set(handles.TopOffStart,  'Enable', 'off');
set(handles.TopOffStop,   'Enable', 'off');
set(handles.EqualizeFill, 'Enable', 'off');

bcminit_local;

GunBunches = 1;
Mode = 40;
InhibitFlag = 0;

try
    
    % Make sure bucket loading is stopped!!!
    if getpvonline('bucket:control:cmd', 'double') ==  1
        fprintf('\n\n');
        fprintf('   It''s best to stop bucket loading when a fill is complete.\n');
        fprintf('   It must be stopped for when the shutters are open!!!\n');
        fprintf('   I''ll stop it before filling the cam bucket but please verify it is off.\n\n');
        setpvonline('bucket:control:cmd', 0);
        soundquestion_nobits;
    end

    goalcurr = getpvonline('Topoff_goal_current_SP');           % current to keep [mA]
    if (goalcurr>500) || (goalcurr<17)
        goalcurr=500;
        setpvonline('Topoff_goal_current_SP',goalcurr);
    end
    goalcurr_cam = getpvonline('Topoff_cam_goal_current_SP');   % target current for cam_bucket [mA]
    if (goalcurr_cam>5) || (goalcurr_cam<0.5)
        goalcurr_cam=2;
        setpvonline('Topoff_cam_goal_current_SP',goalcurr_cam);
    end
    
    if length(cam_bucket)==1
        StartFlag = questdlg({'This function will fill the cam bucket.  Note, the','Gunwidth get''s set automatically by the timing system.', ' ',sprintf('Is ok to fill bucket %d to %.1fmA?', cam_bucket(1), goalcurr_cam)},'Single Bunch','Yes','No','No');
    else
        StartFlag = questdlg({'This function will fill the cam buckets.  Note, the','Gunwidth get''s set automatically by the timing system.',' ',sprintf('Is ok to fill bucket %d and %d to %.1fmA?', cam_bucket(1), cam_bucket(2), goalcurr_cam)},'Single Bunch','Yes','No','No');
    end
    
    if strcmp(StartFlag,'Yes')
        % Open paddles
        OpenAllPaddles;
        pause(1.4);

        num_injections = 1;
        
        if length(cam_bucket)>1
            
            BucketNumber = cam_bucket(1);
            fprintf('Filling bucket %d\n', BucketNumber);

            while (getdcct<goalcurr) && (getcamcurrent_local('Cam1_current')<goalcurr_cam)
                
                singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag);
                
                % Sync to post extraction, Timeout after 2 seconds
                [Counter, Ts, Err] = synctoevt(68, 2);
                if Err
                    fprintf('Error sync''ing to post extraction (evt 68)!!!');
                end
                pause(.2);  % Check when the BCM updates relative to evt 68???

                fprintf('Cam 1 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam1_current'),goalcurr_cam);
                if getcamcurrent_local('Cam1_current')<((num_injections*0.075)-0.5)
                    warning('topoff_injection_dualcam:cam_monitor','Cam Bucket seems to not accumulate electrons - check Cam bucket monitoring program or tune up injector/injection efficiency');
                    soundtada;
                    break
                end
                num_injections=num_injections+1;
            end
    
            BucketNumber = cam_bucket(2);
            fprintf('Filling bucket %d\n', BucketNumber);
            num_injections = 1;

            while (getdcct<goalcurr) && (getcamcurrent_local('Cam2_current')<goalcurr_cam)

                singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag);
                
                % Sync to post extraction, Timeout after 2 seconds
                [Counter, Ts, Err] = synctoevt(68, 2);
                if Err
                    fprintf('Error sync''ing to post extraction (evt 68)!!!');
                end
                pause(.2);  % Check when the BCM updates relative to evt 68???


                fprintf('Cam 2 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam2_current'),goalcurr_cam);
                if getcamcurrent_local('Cam2_current')<((num_injections*0.1)-0.5)
                    warning('topoff_injection_dualcam:cam_monitor','Cam Bucket seems to not accumulate electrons - check Cam bucket monitoring program or tune up injector/injection efficiency');
                    soundtada;
                    break
                end
                num_injections=num_injections+1;
            end
            
            fprintf('Finished: Cam 1 current = %.1f mA, Cam 2 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam1_current'),getcamcurrent_local('Cam2_current'),goalcurr_cam);

        else
            
            BucketNumber = cam_bucket(1);
            fprintf('Filling bucket %d\n', BucketNumber);

            while (getdcct<goalcurr) && (getcamcurrent_local('Cam2_current')<goalcurr_cam)
                                
                singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag);
                
                % Sync to post extraction, Timeout after 2 seconds
                [Counter, Ts, Err] = synctoevt(68, 2);
                if Err
                    fprintf('Error sync''ing to post extraction (evt 68)!!!');
                end
                pause(.2);  % Check when the BCM updates relative to evt 68???

                fprintf('Cam 2 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam2_current'),goalcurr_cam);
                if getcamcurrent_local('Cam2_current')<((num_injections*0.075)-0.5)
                    warning('topoff_injection_dualcam:cam_monitor','Cam Bucket seems to not accumulate electrons - check Cam bucket monitoring program or tune up injector/injection efficiency');
                    soundtada;
                    break
                end
                num_injections=num_injections+1;
            end

            fprintf('Finished: Cam 1 current = %.1f mA (goal = %.1f was read from Topoff_cam_goal_current_SP PV)\n',getcamcurrent_local('Cam1_current'),goalcurr_cam);
        end
    end
    
    exit_cleanup
    disp('Exiting cam bucket filling ...');

catch ME
    fprintf('Error %s\n',ME.identifier) 
    
    exit_cleanup
    % exit_cleanup actually disable storage ring injection pulsed magnets (since that is what one wants to do
    % when disabling top-off. However, here we want to go back into a state where Hiroshi's program can continue
    % filling multibunch. So the next three setpv commands accomplish that.
    
    % Make sure LTB TV3 is retracted
    setpvonline('LTB_____TV3____BC16',0);
    setpvonline('LTB_____TV3LIT_BC17',0);

    disp('Exiting cam bucket filling on an error condition ...');
end

set(handles.EditParams,   'Enable', 'on');
set(handles.TopOffStart,  'Enable', 'on');
set(handles.TopOffStop,   'Enable', 'off');
set(handles.EqualizeFill, 'Enable', 'on');

return

                                                                            
% --- Executes on button press in EqualizeFill.
function EqualizeFill_Callback(~, ~, ~)
% hObject    handle to FillCamBuckets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(gcbo);

if get(handles.EqualizeFill,'Value') == 0
    set(handles.EqualizeFill, 'String', 'Stopping equalization');
    return
end

EqualizingButtonString = get(handles.EqualizeFill, 'String');
set(handles.EqualizeFill, 'String', 'Equalizing on!');

[fill_pattern, ~, ~] = fillpattern_local;

if getpv('sr:user_beam')
    set(handles.EqualizeFill, 'Value', 0);
    set(handles.EqualizeFill, 'String', EqualizingButtonString);
    warning('topoff_injection_dualcam:user_beam','This routine should only be used, if the user beam shutters are closed (because it makes use of full booster frequency)');
    return
end

if (getdcct<350) || (getdcct>getpv('Topoff_goal_current_SP'))
    set(handles.EqualizeFill, 'Value', 0);
    set(handles.EqualizeFill, 'String', EqualizingButtonString);
    warning('topoff_injection_dualcam:getdcct','This routine should only be used, if the beam current is above 350 mA and below the topoff current setpoint');
    return
end

if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.EqualizeFill, 'Value', 0);
    set(handles.EqualizeFill, 'String', EqualizingButtonString);
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
    set(handles.EqualizeFill, 'Value', 0);
    set(handles.EqualizeFill, 'String', EqualizingButtonString);
    warning('topoff_injection_dualcam:bucketlist','Bucket list length is outside expected range (40-328 entries). The bucket list has %d entries!',length(bucketlist));
    return
end

bcminit_local;

open_paddle_flag = 1;
BucketNumber = 0;
GunBunches = 1;
Mode = 40;         % Storage ring injection
InhibitFlag = 0;   % No gun inhibit
LastBucketFilled = -1;

% Set bias to single bunch
startbias = getpvonline('EG______BIAS___AC01');
setpvonline('EG______BIAS___AC01', 23.7);

set(handles.EditParams,     'Enable', 'off');
set(handles.TopOffStart,    'Enable', 'off');
set(handles.TopOffStop,     'Enable', 'off');
set(handles.FillCamBuckets, 'Enable', 'off');

try
    disp('Equalizing the fill pattern started.  Toggle the control or insert the LTB TV6 paddle to stop.');
    
    % Make sure bucket loading is stopped!!!
    if getpvonline('bucket:control:cmd', 'double') ==  1
        fprintf('\n\n');
        fprintf('   It''s best to stop bucket loading when a fill is complete.\n');
        fprintf('   It must be stopped for when the shutters are open!!!\n');
        fprintf('   I''ll stop it before starting equalization but please verify it is off.\n\n');
        setpvonline('bucket:control:cmd', 0);
        soundquestion_nobits;
        pause(2);
    end

    goalcurr = getpvonline('Topoff_goal_current_SP');          % current to keep [mA]
    if (goalcurr>500) || (goalcurr<17)
        goalcurr=500;
        setpvonline('Topoff_goal_current_SP',goalcurr);
    end
    
    OpenAllPaddles;
    pause(2);
    
    % Sync to the start of the next booster cycle to allow for paddle delays etc.
    [Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, since that's when this cycle with start
    
    % Read fill pattern to decide which bucket to target for bunch current equalizer
    bunchQ = getpv('SR1:BCM:BunchQ_WF');
    iLoop = 0;
    while (getdcct<goalcurr) && (mean(bunchQ(bucketlist))-min(bunchQ(bucketlist))>0.33) ...   % below topoff goal and equalizer needed
            && (max(bunchQ(bucketlist))-mean(bunchQ(bucketlist))<1.0) ...                     % safety mechanism - stopif fill pattern gets bad
            && ((getpvonline('LTB_____TV6____BC19','double')==0) || open_paddle_flag)         % Method for operators to stop routine by putting LTB paddle in
        
        iLoop = iLoop + 1;
        
        % Look for equalizer button to stop
        if get(handles.EqualizeFill,'Value') == 0
            break;
        end
        
        bucketlist_corrected = bucketlist;
        
        % Do not target bunches with very low charge (potential bug of BCM showing erroneous zero readings for isolated buckets)
        rmind = bunchQ(bucketlist) < 0.05*mean(bunchQ(bucketlist));
        bucketlist_corrected(rmind) = [];
        
        % Remove the last bunch to avoid having to delay the BCM read and missing a cycle
        ilast = find(bucketlist_corrected==LastBucketFilled);
        bucketlist_corrected(ilast) = [];
        
        if ~isempty(bucketlist_corrected)
            [maxdiff,diffind]=max(mean(bunchQ(bucketlist_corrected))-bunchQ(bucketlist_corrected));    % find bunch that has the lowest charge
            next_bucket = bucketlist_corrected(diffind);
            
            BucketsLeft = sum((mean(bunchQ(bucketlist_corrected))-bunchQ(bucketlist_corrected))>0.33);
            fprintf('Filling low charge bucket %d which is %.2f mA (>0.33 mA) below average (%d buckets left)\n',next_bucket,maxdiff, BucketsLeft);
            
            BucketNumber = next_bucket;
            singleshotinjection(BucketNumber, GunBunches, Mode, InhibitFlag);
            
            %[btscharge,extractflag] = wait_for_extraction;   % After sync'ing to extraction, there isn't enough time to target a bucket on the next fill
            [Counter, Ts, Err] = synctoevt(10, 2);            % Sync to start, since that's when this cycle will start
            
            % Need to time the BCM relative to extraction plus about .3 seconds
            % but that not working right so I'm injection every other shot at the moment
            %[Counter, Ts, Err] = synctoevt(10, 2);   % Sync to start, since that's when this cycle with start
            %pause(.4);  % Needed for the BCM, but it's tight timing to make a request before the end of the sequence
        else
            disp('All low charge buckets are empty - not filling because this could be BCM error');
            break
        end
        
        % Read fill pattern to decide which bucket to target for bunch current equalizer
        [bunchQ, ~, ts1]     = getpv('SR1:BCM:BunchQ_WF');
        %[bunchQ_Inj, ~, ts1] = getpv('SR1:BCM:BunchQinj_WF');
        
        if iLoop > 1
            fprintf('Filled bucket %d, I = %.2f (dI=%.2f) mA\n', LastBucketFilled, bunchQ(LastBucketFilled)-LastbunchQ(LastBucketFilled));
                                    
            % Check for a fill
            if max(abs(bunchQ-LastbunchQ))<0.01   % add stale data after an injection (24*60*60*(now - ts1)) > (1.4*2) 
               warning('topoff_injection:BCM','BCM not showing injection - is it set up correctly?');
               soundtada;
               break
            end
        end
        
        LastBucketFilled = BucketNumber;
        LastbunchQ = bunchQ;

        if (max(bunchQ(bucketlist))-mean(bunchQ(bucketlist))) > 1.0
            soundtada;
            disp('One bunch is more than 1.0 mA higher than average. ');
            disp('This could be because bunch current monitor is mistimed or cam bunch was filled first.');
            disp('Terminating equalizer ...');
            break
        end

        % Need to break for out of fill bunches increasing is current
        % Cam bucket < camgoal (5 mA) AND the other out of fill bunches less than ~1 (parasite levels)
        
        
        % Break on total attempts before have to start equalization again
        %if iLoop > 100???
        %    break
        %end
    end
    
%     if getpvonline('LTB_____TV6____BC19', 'double')
%         soundtada;
%         disp('The LINAC TV6 paddle was inserted. Terminating equalizer ...');
%     end
    
    if get(handles.EqualizeFill,'Value') == 0
        disp('Terminating equalizer by operator request ...');
    end
    
    % Reset bias
    setpvonline('EG______BIAS___AC01', startbias);

    set(handles.EqualizeFill, 'Value', 0);

    exit_cleanup
    disp('Exiting equalizer ...');
    
catch ME
    fprintf('Hitting catch statement ... An error occurred (%s)\n',ME.identifier);
    exit_cleanup;
    disp('Exiting equalizer with errors ...');
end

set(handles.EditParams,  'Enable', 'on');
set(handles.TopOffStart, 'Enable', 'on');
set(handles.TopOffStop,  'Enable', 'off');
if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
    set(handles.FillCamBuckets, 'Enable', 'off');
else
    set(handles.FillCamBuckets, 'Enable', 'on');
end

set(handles.EqualizeFill, 'Value', 0);
set(handles.EqualizeFill, 'String', EqualizingButtonString);
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
    
%     if (getpvonline('IGPF:TFBX:CLEAN:SPAN')<0.01) & (Delay < 5)
%         Delay = 5;
%     end

    if strcmpi(InputCommand, 'On')
        % Turn on (if it's not already on)
%        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
%        %now using TFB bunch cleaner in Two bunch mode as well
        if 0
            if ~getpvonline('bcleanEnable')
                setpvonline('bcleanEnable', 1);
                fprintf('   Bunch cleaning turn on\n');
            end
        else
            if ~strcmp(getpvonline('IGPF:TFBX:CLEAN:ENABLE'),'Enable')
                setpvonline('IGPF:TFBX:CLEAN:ENABLE',1);
                fprintf('   Bunch cleaning turn on for %f s\n',Delay);
            end
        end
        % Turn off
        pause(Delay);
%        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
%        %now using TFB bunch cleaner in Two bunch mode as well
        if 0
            setpvonline('bcleanEnable', 0);
            fprintf('   Bunch cleaning turn off\n');
        else
            % setpvonline('bcleanEnable', 0);
            setpvonline('IGPF:TFBX:CLEAN:ENABLE',0);
            fprintf('   Bunch cleaning turn off\n');
        end
    else
%        if strcmp(getfamilydata('OperationalMode'), '1.9 GeV, Two-Bunch')
%        %now using TFB bunch cleaner in Two bunch mode as well
        if 0
            if getpvonline('bcleanEnable')
                msgflag = 1;
            else
                msgflag = 0;
            end
            % Turn off
            setpvonline('bcleanEnable', 0);
            if msgflag
                fprintf('   Bunch cleaning turn off\n');
            end
        else
            if strcmp(getpvonline('IGPF:TFBX:CLEAN:ENABLE'),'Enable')
                msgflag = 1;
            else
                msgflag = 0;
            end
            % Turn off
            % setpvonline('bcleanEnable', 0);
            setpvonline('IGPF:TFBX:CLEAN:ENABLE',0);
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
    bunchQ=getpvonline('SR1:BCM:BunchQ_WF');
    
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
    camcurr=getpvonline(InputCommand);
end
    
if isnan(camcurr)
    camcurr = 0;
end

return


function OpenAllPaddles

% GTL
setpvonline('GTL_____TV1____BC23',0);
setpvonline('GTL_____TV2____BC21',0);

% Lniac
setpvonline('LN______TV1____BC23',0);
setpvonline('LN______TV2____BC21',0);


% LTB
setpvonline('LTB_____TV1____BC16',0);
setpvonline('LTB_____TV3____BC16',0);
setpvonline('LTB_____TV4____BC18',0);
setpvonline('LTB_____TV5____BC16',0);
setpvonline('LTB_____TV6____BC19',0);

% BR
setpvonline('BR1_____TV1____BC18',0);
setpvonline('BR1_____TV2____BC16',0);
setpvonline('BR1_____TV3____BC18',0);
setpvonline('BR3_____TV1____BC16',0);
setpvonline('BR4_____TV1____BC16',0);

% BTS
setpvonline('BTS_____TV1____BC16',0);
setpvonline('BTS_____TV2____BC18',0);
setpvonline('BTS_____TV3____BC18',0);
setpvonline('BTS_____TV4____BC16',0);
setpvonline('BTS_____TV5____BC18',0);
setpvonline('BTS_____TV6____BC20',0);

return


function bcminit_local

% Make sure the BCM updates fast enough
try
    setpv('SR1:BCM:poll.SCAN', 8);   % 8 -> 5 Hz
catch
    fprintf('There was a problem setting the scan rate on bunch current monitor!!!\n');
end

return
