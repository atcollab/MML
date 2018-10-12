function varargout = setliberaconfig(varargin)

% SETLIBERACONFIG([deviceList | 'diag'])
%
% This function sets the default configuration for the Liberas. The
% optional parameters are:
%
% deviceList    A vector of nx2 specifying which devices to configure
% 'diag'        (String) configure the diagnostic BPM
%
% If no parameters are set, the configuration will be applied to all the
% liberas that are enabled in middleLayer ("aspinit").
%
% e.g. >> setliberaconfig
%      >> setliberaconfig([1 2; 1 3; 1 4; 1 5;])
%      >> setliberaconfig('diag')
%
% 13/08/0009 Eugene Added comments and modified to add deviceList options

% 21/11/2012 Removed Topup Check as added event to topup_timing.pcf JT
% if getpv('TS01FPC01:FILL_CMD') == 7
%     % If in Topup

%     setpv('TS01EVR01:TTL01_EVENT_CODE_CMD',3); % Gun event
% else
%     % Set the BPM trigger to Storage Ring BPM event
%     setpv('TS01EVR01:TTL01_EVENT_CODE_CMD',13);
% end

error('**** Need to run setliberabconfig for the Brilliance+ units ****');

% configure the diagnostic BPM only
if nargin > 0 && ischar(varargin{1}) && strcmpi(lower(varargin{1}),'diag')
    disp('Configuring Diagnostic BPM'); 
    fprintf('Setting SWITCHES to 255\n');
    setlibera('ENV_SWITCHES_SP',255,[-1 -1]);

    % Digital signal conditioning
    fprintf('Turning _ON_ DSC\n');
    setlibera('ENV_DSC_SP',2,[-1 -1]);
    
    % Auto Gain Control 
    fprintf('Turning _ON_ AGC\n');
    setlibera('ENV_AGC_SP',1,[-1 -1]);
    
    % Interlocks
    fprintf('Turning _OFF_ Interlocks\n');
    setlibera('ENV_ILK_MODE_SP',0,[-1 -1]);
    pause(5);
    setlibera('ENV_SET_INTERLOCK_PARAM_CMD.PROC',0,[-1 -1]);
    
    % Setting gains on the Diag libera
    fprintf('Setting Kx and Ky...\n');
    setlibera('ENV_KX_SP',14.8e6,[-1 -1]);
    setlibera('ENV_KY_SP',15.1e6,[-1 -1]);
    
    % Setting offsets on the Diag libera
    fprintf('Setting x_offset and y_offset...\n');
    setlibera('ENV_X_OFFSET_SP',-810474,[-1 -1]);
    setlibera('ENV_Y_OFFSET_SP',+386743,[-1 -1]);
    
    fprintf('Setting Swithing Synchronisation to External');
    setlibera('ENV_EXTSWITCH_SP',1,[-1 -1]);
    fprintf('  done.\n');

    fprintf('Turning Spike Removal OFF: \n');
    setliberasr('off','off',[-1 -1]);
    fprintf('  done.\n');

    fprintf('Setting PLL offset tune to 434 units (~17 kHz): \n');
    setlibera('ENV_PLL_OFFSETTUNE_SP',434,[-1 -1]);
    setlibera('ENV_PLL_COMPTUNE_SP',1,[-1 -1]);
    fprintf('  done.\n');
    
    return
elseif nargin > 0 && isnumeric(varargin{1})
    deviceList = varargin{1};
else
    deviceList = getlist('BPMx');
end

if ~(nargin > 0 && isnumeric(varargin{1}))
    % If configuring for specific Liberas, its been unlikely I'd want to
    % change the timing. So when specifying the deviceList don't run this
    % part.
    
    % Set the delay. This has been optimised for topup and should also work for
    % normal operation.
    setliberatiming
end

bpmstatus = getfamilydata('BPMx','Status',deviceList);

% Switches
fprintf('Setting SWITCHES to 255\n');
setlibera('ENV_SWITCHES_SP',255,deviceList);

% Digital signal conditioning
fprintf('Turning _ON_ DSC\n');
setlibera('ENV_DSC_SP',2,deviceList);

fprintf('  Setting Libera Interlocks ... ');
% Setting HW interlock parameters
% Limits have been changed after reevaluation of raytrace information
% 18-10-2007 ET
xlimits = [-1 1]; %mm
ylimits = [-1 1]; %mm

% Below is a list of BPMs that need the orbit interlock. Have added 2's and
% 6's as backups if the primary ones fail. [2 2; and 2 3] aer for the IR
% mirror.
templist = [ [[1:14]' ones(14,1)];   [[1:14]' ones(14,1)*7]; 
             [[1:14]' ones(14,1)*2]; [[1:14]' ones(14,1)*6]; [2 3] ];
ind = findrowindex(templist,deviceList);
devlist = deviceList(sort(ind),:);
if ~isempty(devlist)
    % 0 = disable; 1 = position; 3 = position and gain
    setlibera('ENV_ILK_MODE_SP',0,deviceList); % turn everything else off and only turn specific ones on.
    setlibera('ENV_ILK_MODE_SP',3,devlist);
    setlibera('ENV_ILK_X_LOW_SP',xlimits(1)*1e6,devlist);
    setlibera('ENV_ILK_X_HIGH_SP',xlimits(2)*1e6,devlist);
    setlibera('ENV_ILK_Y_LOW_SP',ylimits(1)*1e6,devlist);
    setlibera('ENV_ILK_Y_HIGH_SP',ylimits(2)*1e6,devlist);
    setlibera('ENV_ILK_OF_LIMIT_SP',1900,devlist);
    % The duration changed to match the rough duration of a standard fill
    % pattern in the ring in raw ADC samples.
    setlibera('ENV_ILK_OF_DUR_SP',40,devlist);
end

% Backup interlocks (ultra conservative here)
templist = [[1:14]' ones(14,1)*2]; [[1:14]' ones(14,1)*6];
ind = findrowindex(templist,deviceList);
devlist = deviceList(sort(ind),:);
if ~isempty(devlist)
    setlibera('ENV_ILK_Y_LOW_SP',-0.5*1e6,devlist);
    setlibera('ENV_ILK_Y_HIGH_SP',0.5*1e6,devlist);
end

% IR interlock (something different from the rest)
templist = [2 2; 2 3];
ind = findrowindex(templist,deviceList);
devlist = devlist(sort(ind),:);
if ~isempty(devlist)
    setlibera('ENV_ILK_Y_LOW_SP',-0.7*1e6,devlist);
    setlibera('ENV_ILK_Y_HIGH_SP',0.7*1e6,devlist);
end

% Measured at 18.45 mA on 16/02/07
gain_limit = [...
    -26.00000000 -26.00000000 -26.00000000 -24.00000000 -24.00000000 -26.00000000 -26.00000000, ... %
    -27.00000000 -30.00000000 -32.00000000 -30.00000000 -30.00000000 -30.00000000 -30.00000000, ... %
    -30.00000000 -33.00000000 -34.00000000 -33.00000000 -34.00000000 -34.00000000 -34.00000000, ... %
    -28.00000000 -28.00000000 -27.00000000 -28.00000000 -29.00000000 -26.00000000 -26.00000000, ... %
    -27.00000000 -27.00000000 -28.00000000 -27.00000000 -27.00000000 -25.00000000 -25.00000000, ... %
    -33.00000000 -33.00000000 -35.00000000 -34.00000000 -34.00000000 -29.00000000 -29.00000000, ... %
    -37.00000000 -37.00000000 -38.00000000 -38.00000000 -37.00000000 -32.00000000 -32.00000000, ... %
    -31.00000000 -31.00000000 -32.00000000 -32.00000000 -32.00000000 -28.00000000 -28.00000000, ... %
    -29.00000000 -28.00000000 -30.00000000 -29.00000000 -30.00000000 -28.00000000 -27.00000000, ... %
    -29.00000000 -30.00000000 -32.00000000 -32.00000000 -32.00000000 -29.00000000 -29.00000000, ... %
    -29.00000000 -29.00000000 -30.00000000 -30.00000000 -30.00000000 -29.00000000 -31.00000000, ... %
    -32.00000000 -30.00000000 -32.00000000 -33.00000000 -33.00000000 -33.00000000 -34.00000000, ... %
    -27.00000000 -28.00000000 -28.00000000 -26.00000000 -27.00000000 -25.00000000 -26.00000000, ... %
    -27.00000000 -26.00000000 -27.00000000 -28.00000000 -28.00000000 -28.00000000 -28.00000000, ... %
];

% Measured at 25 mA on 22/02/07
gain_limit = [...
  -24 -23 -23 -23 -23 -24 -24, ... %
  -24 -23 -29 -28 -29 -28 -27, ... %
  -31 -31 -32 -31 -32 -31 -31, ... %
  -26 -27 -26 -26 -27 -23 -24, ... %
  -24 -25 -26 -26 -25 -23 -23, ... %
  -31 -32 -32 -31 -32 -27 -26, ... %
  -35 -34 -36 -35 -35 -30 -30, ... %
  -29 -28 -29 -30 -28 -26 -26, ... %
  -26 -26 -28 -26 -27 -27 -25, ... %
  -26 -28 -29 -29 -30 -26 -26, ... %
  -26 -27 -28 -27 -27 -28 -29, ... %
  -29 -29 -29 -31 -30 -31 -32, ... %
  -25 -26 -26 -24 -24 -23 -24, ... %
  -26 -24 -26 -26 -26 -26 -26, ... %
  ];

% Measured at 26.7 mA on 17/11/2008
% Changed thresholds for sector 7 after move. Cable attenuation reduced by
% 6 dB. ET 2/8/2009
gain_limit = [...
  -23 -22 -23 -21 -21 -23 -23, ... %
  -23 -22 -29 -27 -28 -27 -27, ... %
  -29 -29 -31 -30 -31 -31 -31, ... %
  -25 -26 -26 -26 -26 -22 -22, ... %
  -23 -24 -25 -24 -23 -22 -21, ... %
  -30 -30 -32 -31 -31 -27 -26, ... %
  [-33 -33 -34 -34 -33 -29 -29]+6, ... %
  -28 -28 -29 -29 -28 -26 -24, ... %
  -26 -25 -27 -26 -27 -26 -23, ... %
  -26 -28 -29 -29 -29 -26 -26, ... %
  -26 -26 -27 -27 -27 -28 -26, ... %
  -28 -28 -29 -30 -30 -30 -30, ... %
  -24 -25 -25 -23 -23 -22 -23, ... %
  -24 -23 -24 -25 -25 -26 -25, ... %
  ]; 
% However as the AGC is slow to respond the gain limits should be put at a
% lower level comparable to 

% Ensure that a column vector is passed to setlibera.
temp = gain_limit(dev2elem('BPMx',deviceList));
setlibera('ENV_ILK_GAIN_LIMIT_SP',temp(:),deviceList);
% Apply changes. This also resets the orbit interlock status PV.
setlibera('ENV_SET_INTERLOCK_PARAM_CMD',1,deviceList);

% Acknowledge all interlocks
setlibera('ENV_INTERLOCK_CLEAR_CMD.PROC',1,deviceList);

fprintf('  done.\n');

% As of 22/09/2011 Software orbit interlock has been removed. Eugene
% fprintf('  Disabling software orbit interlock...');
% for i=[1 2 3 4 5 6 7 8 9 10 11 12 13 14]
%     try
%         setpv(sprintf('SR%02dOI01:INHIBIT_ENABLE_CMD.DISP',i),0);
%         pause(0.01);
%         setpv(sprintf('SR%02dOI01:INHIBIT_ENABLE_CMD',i),1);
%     catch
%     end
% end;
% fprintf('  done.\n');


fprintf('  Setting Libera Gain ... ');
K = [14.593 14.648];
libera_gain_x = [ ...
    +0.966948080 +0.959619910 +0.959120392 +0.959046416 +0.958646839 +0.970136269 +0.989077507, ... %
    +0.962305519 +1.000000000 +0.972453818 +0.973353564 +0.968318612 +0.974381125 +0.950104340, ... %
    +0.955556319 +0.967719387 +0.981479354 +0.967697565 +0.974265951 +0.974843991 +0.960286102, ... %
    +0.955195998 +0.962080805 +0.966617065 +0.963776590 +1.000000000 +0.962251920 +0.950797707, ... %
    +0.962338934 +0.960510260 +1.000000000 +0.963476055 +0.955816561 +0.970940062 +0.970461463, ... %
    +0.978357029 +0.960498444 +0.978981418 +0.975108996 +0.967525095 +1.000000000 +0.995110939, ... %
    +1.008955830 +0.981430592 +1.000000000 +0.975632632 +0.983720220 +0.965493949 +0.968582952, ... %
    +0.961121710 +0.966910076 +0.961221400 +0.980075750 +0.965634395 +0.965313494 +0.955373284, ... %
    +0.970222644 +0.965991662 +0.962625146 +0.966684034 +1.000000000 +0.959439683 +0.957108540, ... %
    +0.963204585 +0.966602116 +0.984932228 +0.968120932 +0.972003650 +0.973590996 +0.979101961, ... %
    +0.952306249 +1.000000000 +0.964035998 +0.974901575 +0.985506540 +0.968637792 +0.982478924, ... %
    +0.983423472 +0.971033202 +0.968951290 +0.974224051 +0.981495416 +0.975066573 +0.965662919, ... %
    +0.962029114 +0.959208439 +0.967355776 +0.967418693 +0.971780196 +1.000000000 +0.957020986, ... %
    +0.976673428 +0.973211075 +0.964885897 +0.968629156 +0.960083213 +0.959900844 +0.945449626, ... %
    ]';
libera_gain_y = [ ...
    +0.948742740 +0.938985980 +0.947990664 +0.946717526 +0.943606693 +0.948187874 +0.919157421, ... %
    +0.942776941 +1.000000000 +0.946087417 +0.956274522 +0.947370487 +0.949872141 +0.946387610, ... %
    +0.939869535 +0.954926521 +0.956387595 +0.949416686 +0.953505592 +0.953622843 +0.954557915, ... %
    +0.945121854 +0.952457360 +0.947382619 +0.941596137 +1.000000000 +0.936874260 +0.928534297, ... %
    +0.942307791 +0.945010554 +1.000000000 +0.946576270 +0.946095974 +0.940937320 +0.940093187, ... %
    +0.939533330 +0.948664068 +0.953825209 +0.952652917 +0.956446497 +1.000000000 +0.921532602, ... %
    +0.959464550 +0.950304327 +1.000000000 +0.953212616 +0.958565862 +0.947571387 +0.946256864, ... %
    +0.947723060 +0.946544009 +0.945606560 +0.962324655 +0.953574090 +0.949310515 +0.946090734, ... %
    +0.950022254 +0.933364762 +0.943970019 +0.952200155 +1.000000000 +0.935012402 +0.943822892, ... %
    +0.948076061 +0.948695079 +0.955976906 +0.949857838 +0.946005079 +0.948099472 +0.998813326, ... %
    +0.936645213 +1.000000000 +0.938436145 +0.951387541 +0.970085370 +0.943411291 +0.943139410, ... %
    +0.955283538 +0.949711620 +0.952274079 +0.958000353 +0.953091159 +0.941295894 +0.948895146, ... %
    +0.942522818 +0.936837423 +0.944267089 +0.940357974 +0.947760848 +1.000000000 +0.921421809, ... %
    +0.925439928 +0.938130282 +0.942509420 +0.951921198 +0.942846824 +0.946266672 +0.951273619, ... %
    ]';
% 16/02/2007
libera_gain_x = [ ... 
  +0.98065084 +0.96332305 +0.96462458 +0.97356900 +0.96644755 +0.98972762 +0.99803758, ... %
  +0.97381483 +1.00000000 +0.97937956 +0.98981618 +0.98112604 +0.98608984 +0.95923814, ... %
  +0.95555632 +0.97971727 +1.00418594 +0.97887852 +0.98570080 +0.99278104 +0.97781389, ... %
  +0.96079200 +0.97471975 +0.96661706 +0.97214864 +1.04170927 +0.96953238 +0.94940742, ... %
  +0.97111888 +0.96728025 +1.04651477 +0.97728357 +0.96134764 +0.97719961 +0.98916880, ... %
  +1.00224357 +0.97100221 +0.99091069 +0.99486417 +0.98754895 +1.03052325 +1.00773195, ... %
  +1.03127963 +1.01229856 +1.03881681 +0.99565998 +1.01411043 +0.97823481 +0.98682531, ... %
  +0.96897460 +0.97478013 +0.96496404 +1.00582362 +0.97265235 +0.97059168 +0.96498306, ... %
  +0.98836325 +0.97360393 +0.96967122 +0.97685603 +1.04347456 +0.96842185 +0.96794714, ... %
  +0.96987239 +0.97460713 +1.01118380 +0.98267390 +0.98871913 +0.99071220 +1.00808455, ... %
  +0.94231696 +1.04594128 +0.97280204 +0.99082037 +1.00855885 +0.98444284 +1.01422470, ... %
  +1.03416337 +0.97676445 +0.98023853 +1.00049481 +1.00887827 +0.99040517 +0.98213874, ... %
  +0.97292523 +0.96235993 +0.97823893 +0.97860437 +0.98810766 +1.03935436 +0.96070000, ... %
  +0.98200130 +0.98785254 +0.95847647 +0.97832909 +0.95822393 +0.96253495 +0.95473355, ... %
]';
libera_gain_y = [ ... 
  +0.97309509 +0.95609923 +0.96630216 +0.96348775 +0.95850788 +0.96687943 +0.91988411, ... %
  +0.95833878 +1.00000000 +0.96101345 +0.97624167 +0.96241716 +0.96955358 +0.96275598, ... %
  +0.93986954 +0.97532650 +0.97840062 +0.96031310 +0.97333007 +0.97804858 +0.97561475, ... %
  +0.96234509 +0.97390607 +0.94738262 +0.95395284 +1.07350723 +0.94489729 +0.93738772, ... %
  +0.95643798 +0.95852768 +1.06902251 +0.96104282 +0.95822695 +0.95902437 +0.95678273, ... %
  +0.95319748 +0.96729898 +0.97248842 +0.96621831 +0.97749538 +1.07041318 +0.92861579, ... %
  +1.00004803 +0.97045198 +1.07282384 +0.96641823 +0.98364057 +0.96840075 +0.96511461, ... %
  +0.96646593 +0.96477837 +0.95773646 +0.98867225 +0.97471819 +0.96884309 +0.96058673, ... %
  +0.96605015 +0.93746399 +0.95458147 +0.97029753 +1.07443478 +0.94686388 +0.95509890, ... %
  +0.96180766 +0.96899984 +0.97873461 +0.96592276 +0.96368095 +0.96553179 +1.07651530, ... %
  +0.94872454 +1.07492964 +0.95261031 +0.96855645 +1.00765275 +0.94137132 +0.94387467, ... %
  +0.96791978 +0.97084230 +0.96651960 +0.98027098 +0.97387417 +0.95433885 +0.97518112, ... %
  +0.95650968 +0.94694534 +0.95358627 +0.94820797 +0.96586596 +1.07797176 +0.92007440, ... %
  +0.93155173 +0.95037365 +0.95099987 +0.96492413 +0.95059941 +0.95620621 +0.95743179, ... %
]';

% setlibera('ENV_KX_SP',K(1).*libera_gain_x(find(bpmstatus))*1e6);
% setlibera('ENV_KY_SP',K(2).*libera_gain_y(find(bpmstatus))*1e6);

% 9-3-2008 Eugenee: Make gains uniform for now. This needs to be revisited
setlibera('ENV_KX_SP',14.8e6,deviceList);
setlibera('ENV_KY_SP',15.1e6,deviceList);

fprintf('  done.\n');


% With the new I-Tech epics driver commissioning we need to make sure
% certain features are turned off first.
% fprintf('\nSetting Gains\n');
setgains('auto',deviceList);

fprintf('Setting Swithing Synchronisation to External');
setlibera('ENV_EXTSWITCH_SP',1,deviceList);
fprintf('  done.\n');

fprintf('Turning Spike Removal OFF: \n')
setliberasr('off','off',deviceList);
fprintf('  done.\n');

% 30/03/2016 Eugene change default offset tuning from 125 to 110, to shift
% the major noise peaks to above 500 Hz.
% 31/03/2016 Eugene: further investigation showed pll offset = 434 was
% better still.
fprintf('Setting PLL offset tune to 434 units (17.36 kHz): \n');
setlibera('ENV_PLL_OFFSETTUNE_SP',434,deviceList);
setlibera('ENV_PLL_COMPTUNE_SP',1,deviceList);
fprintf('  done.\n');

% Libera synchronisation MUST be after setting the PLL tune and offset
% tune.
fprintf('Machine time INITIALISATION (will take 5 seconds)')
setliberasync(deviceList);
fprintf('  done.\n');



fprintf('-------------[  BR Libera ]-------------\n')
try
    setliberabr;
catch
    lasterr
end
fprintf('-------------[ LTB/BTS Libera ]-------------\n')
try
    setliberaconfig_tl;
catch
    lasterr
end

% temporary
fprintf('*** TEMP PV CORRECTIONS (FANS) ***\n');
% deviceList = getlist('BPMx');
setlibera('ENV_FRONT_VENT_ACT_MONITOR.HIHI',5500,deviceList);
setlibera('ENV_FRONT_VENT_ACT_MONITOR.LOLO',3500,deviceList);
setlibera('ENV_FRONT_VENT_ACT_MONITOR.HIGH',5500,deviceList);
setlibera('ENV_FRONT_VENT_ACT_MONITOR.LOW',3500,deviceList);
setlibera('ENV_BACK_VENT_ACT_MONITOR.HIHI',5500,deviceList);
setlibera('ENV_BACK_VENT_ACT_MONITOR.LOLO',3500,deviceList);
setlibera('ENV_BACK_VENT_ACT_MONITOR.HIGH',5500,deviceList);
setlibera('ENV_BACK_VENT_ACT_MONITOR.LOW',3500,deviceList);

fprintf('*** TEMP PV CORRECTIONS (DD seek point and Ignore trig) ***\n');
% deviceList = getlist('BPMx');
setlibera('DD1_SEEK_POINT_SP',0,deviceList);
setlibera('DD2_SEEK_POINT_SP',0,deviceList);
setlibera('DD3_SEEK_POINT_SP',0,deviceList);
setlibera('DD4_SEEK_POINT_SP',0,deviceList);
setlibera('DD5_SEEK_POINT_SP',0,deviceList);

setlibera('ADC_IGNORE_TRIG_SP',0,deviceList);
setlibera('DD1_IGNORE_TRIG_SP',0,deviceList);
setlibera('DD2_IGNORE_TRIG_SP',1,deviceList);
setlibera('DD3_IGNORE_TRIG_SP',0,deviceList);
setlibera('DD4_IGNORE_TRIG_SP',1,deviceList);
setlibera('DD5_IGNORE_TRIG_SP',0,deviceList);


return








% Set to 1 to set the attenuation factors for the liberas. Refer to the
% attenuation table below to determine exactly what attenuations are used.
setLiberaAttenuation = 0;

if setLiberaAttenuation
    fprintf('  Setting Libera Attenuation ... ');
    
    [pin att1_list att2_list] = textread('libera_attn_table3.txt','%d %d %d','headerlines',1);

    BPMcableattenuation = [...
            -6.6500     -5.9750     -5.9250     -5.6000     -5.4500     -6.3750     -6.3750, ... % Sector 1
            -6.8250     -6.5000    -12.2750    -11.9500    -11.5250    -10.9000    -10.8250, ... % 2
           -13.3750    -13.5750    -14.8250    -14.4000    -14.3250    -14.7750    -14.8000, ... % 3
            -9.4250     -9.3500    -10.8500    -10.4250    -10.4000     -5.9000     -5.9000, ... % 4
            -7.1000     -7.0000     -8.4000     -7.9000     -7.8000     -5.4000     -5.4750, ... % 5
           -13.7750    -13.7150    -15.3250    -14.8250    -14.7000    -10.3000    -10.3000, ... % 6
           -16.6650    -16.5225    -18.1550    -17.7575    -17.3075    -12.7400    -12.7125, ... % 7
           -11.9150    -11.5875    -13.0550    -12.5450    -12.3350     -9.0550     -9.1575, ... % 8
           -10.0225     -9.7075    -11.0775    -10.7075    -10.6400     -8.6800     -8.4350, ... % 9
           -11.4725    -11.3575    -12.4475    -12.1825    -11.9750     -9.6700     -9.6575, ... %10
            -9.9525     -9.7900    -10.6475    -10.5100    -10.4750    -11.5050    -11.5725, ... %11
           -12.9225    -12.6525    -14.0425    -13.6075    -13.4225    -14.1350    -14.0025, ... %12
            -8.7000     -8.8750     -8.3250     -7.7250     -7.4200     -6.4150     -6.5250, ... %13
            -8.0925     -7.7950     -9.0725     -8.5625     -8.4475     -9.2050     -9.2225, ... %14
        ];

    % Beam power -12 dBm at 70.0 mA --> mean(getam('FTx', 'Maxadc')) = 1312.
    % Beam power -14 dBm at 49.8 mA --> mean(getam('FTx', 'Maxadc')) = 1319.
    % Beam power -15 dBm at 45.5 mA --> mean(getam('FTx', 'Maxadc')) = 1384.
    % Beam power -17 dBm at 35.0 mA --> mean(getam('FTx', 'Maxadc')) = 1306.
    % Beam power -18 dBm at 32.4 mA --> mean(getam('FTx', 'Maxadc')) = 1345.
    % Beam power -19 dBm at 29.7 mA --> mean(getam('FTx', 'Maxadc')) = 1356.
    
    % With an even fill the maximum ADC values have decreased a lot to get
    % the same signal level as before we need to apply a factor of 0.11
%     beam_power = fix(getam('DCCT')*0.11/3 - 28);
    beam_power = fix(110*0.11/3 - 28);
    beam_power = -20;
    
    power_into_libera = beam_power + BPMcableattenuation;
    
    bpmstatus = getfamilydata('BPMx','Status');
    setlibera('ENV_GAIN_SP',round(power_into_libera(find(bpmstatus)))');
    
%     att1 = zeros(size(family2dev('BPMx',0),1));
%     att2 = att1;
%     for i=1:length(power_into_libera)
%         att1(i) = interp1(pin,att1_list,power_into_libera(i),'nearest');
%         att2(i) = interp1(pin,att2_list,power_into_libera(i),'nearest');
%     end
%     
%     bpmstatus = getfamilydata('BPMx','Status');
%     setlibera('CF_ATT1_S_SP',att1(find(bpmstatus)));
%     setlibera('CF_ATT2_S_SP',att2(find(bpmstatus)));
    
    fprintf('  done.\n');
end
