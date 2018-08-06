function varargout = imageviewer(varargin)
% IMAGEVIEWER MATLAB code for imageviewer.fig
%      IMAGEVIEWER, by itself, creates a new IMAGEVIEWER or raises the existing
%      singleton*.
%
%      H = IMAGEVIEWER returns the handle to a new IMAGEVIEWER or the handle to
%      the existing singleton*.
%
%      IMAGEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEVIEWER.M with the given input arguments.
%
%      IMAGEVIEWER('Property','Value',...) creates a new IMAGEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageviewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageviewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageviewer

% Last Modified by GUIDE v2.5 18-Jul-2013 11:02:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @imageviewer_OpeningFcn, ...
    'gui_OutputFcn',  @imageviewer_OutputFcn, ...
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


% --- Executes just before imageviewer is made visible.
function imageviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageviewer (see VARARGIN)

% Choose default command line output for imageviewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageviewer wait for user response (see UIRESUME)
%uiwait(handles.figure1);

% Check if the AO exists (this is required for stand-alone applications)
checkforao;


% Camera setup
if strcmpi(getfamilydata('Machine'), 'APEX')
    CamList = {
        'None'       ,  ''    , ''
        'Laser Cam1' , 'LCam1', ''
        'Screen Cam1', 'SCam1', ''
        'Screen Cam2', 'SCam2', ''
        'Screen Cam3', 'SCam3', ''
        'Screen Cam4', 'SCam4', ''
        };
    % GC1380H
    Nrows = 1024;
    Ncols = 1360;
else
    % ALS
    % Label PV 
    % Set Defaults:  Exp, Gain (GTL1=5 LTB1=21), Delay, size, ???
    % Light and paddles
    % Tempsave -> push to GTB view
    % Pixels / mm?
    
    % Auto light and paddle in?
    % Buttons 
    
    CamList = {
        %                     ActiveIf (PaddleIn)
        % Label    BaseName ('' to ignor this CCD)
        'None'  ,  '',     ''
        'GTL CAM1',  'GTL1', 'GTL_____TV1____BM10'
        'GTL CAM2',  'GTL2', 'GTL_____TV2____BM04'
        'LN CAM1',   'LN1',  'LN______TV1____BM10'
        'LN CAM2',   'LN2',  'LN______TV2____BM04'
        'LTB CAM1',  'LTB1', 'LTB_____TV1____BM00'
       %'LTB CAM2',  'LTB2', ''      %'LTB_____TV2____BM06'  % Faraday Cup
        'LTB CAM3',  'LTB3', 'LTB_____TV3____BM00'
        'LTB CAM4',  'LTB4', 'LTB_____TV4____BM06'
        'LTB CAM5',  'LTB5', 'LTB_____TV5____BM00'
        'LTB CAM6',  'LTB6', 'LTB_____TV6____BM08'
        'BR1 CAM1',  'LTB6', 'BR1_____TV1____BM06'
        'BR1 CAM2',  'BR2',  'BR1_____TV2____BM00'
        'BR1 CAM3',  'BR3',  'BR1_____TV3____BC18'  % Broken monitor 'BR1_____TV3____BM06'
        'BR3 CAM1',  'BR4',  'BR3_____TV1____BM00'
        'BR4 CAM1',  'BR5',  'BR4_____TV1____BM00'
        'BTS CAM1',  'BTS1', 'BTS_____TV1____BM00'
        'BTS CAM2',  'BTS2', 'BTS_____TV2____BM06'
        'BTS CAM3',  'BTS3', 'BTS_____TV3____BM06'
        'BTS CAM4',  'BTS4', 'BTS_____TV4____BM00'
        'BTS CAM5',  'BTS5', 'BTS_____TV5____BC18'  % boolean is reverse logic 'BTS_____TV5____BM06'
        'BTS CAM6',  'BTS6', 'BTS_____TV6____BM00'
        'SR CAM1',   'SR1',  'SR01C___TV1____BM06'
        'BL 3.1',    'BL31', ''
       %'BL 7.2',    'BL72', ''
        };
    % Manta
    Nrows = 1038;
    Ncols = 1390;
    
    % Defaults???
end


setappdata(handles.figure1, 'CameraInputData', CamList);
set(handles.Camera_Select,  'String',          CamList(:,1));

% Set the colormap
%FigureColormap_Callback(hObject, eventdata, handles);
 
 
%set(handles.image_ax,'PlotBoxAspectRatio',[1392 1040 1]);
handles.profy = plot(handles.axes_vertical,   NaN, NaN, 'r', 'LineWidth', 2);
%set(handles.axes_vertical, 'view', [270 90]);
handles.profx = plot(handles.axes_horizontal, NaN, NaN, 'r', 'LineWidth', 2);

set(handles.axes_main,       'Units','pixels');
set(handles.axes_vertical,   'Units','pixels');
set(handles.axes_horizontal, 'Units','pixels');

% set(handles.axes_vertical,   'XTickLabel', []);
% set(handles.axes_vertical,   'YTickLabel', []);
% set(handles.axes_horizontal, 'XTickLabel', []);
% set(handles.axes_horizontal, 'YTickLabel', []);

% First plot
axes(handles.axes_main);
[xx,yy] = meshgrid(((0:(Ncols-1))/Ncols)+.5, ((0:(Nrows-1))/Nrows)+.5);
%a = .001*2^14*rand(Nrows,Ncols) + 100000*(sinc(30*xx) + sinc(24*yy));
a = 100000*(sinc(30*xx) + sinc(44*yy));
handles.imageplot = imagesc(a, [0 2^12-1]);

% set(handles.axes_main, 'XTick',[]);
% set(handles.axes_main, 'XTickLabel','');
% set(handles.axes_main, 'YTick',[]);
% set(handles.axes_main, 'YTickLabel','');
set(handles.axes_main, 'PlotBoxAspectRatio', [Ncols/Nrows 1 1]);

Cam.Image = [];
Cam.Bg    = [];
setappdata(handles.figure1, 'Image', Cam);

%set(handles.imageplot, 'ButtonDownFcn', {@axes_main_ButtonDownFcn,handles});


% Setup Timer
UpdatePeriod = 0.5;

t = timer;
handles.CameraTimer = t;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@Camera_Timer_Callback,handles});
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
%set(t, 'ErrorFcn', {@Camera_Timer_Error,handles});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'ImageGrabTimer');


% Update handles structure
guidata(hObject, handles);

%p = get(handles.figure1, 'Position');
%%set(handles.figure1, 'Position', [10 10 p(3:4)]);
%set(handles.figure1, 'Position', [10 80 p(3:4)]);

BackGroundColor = [0 0 .5];
set(handles.figure1,                            'Color', BackGroundColor);
set(handles.HorizontalProjectionText, 'BackGroundColor', BackGroundColor);
set(handles.VerticalProjectionText,   'BackGroundColor', BackGroundColor);
set(handles.YProfileMax,              'BackGroundColor', BackGroundColor);
set(handles.XProfileMax,              'BackGroundColor', BackGroundColor);

set(handles.axes_horizontal, 'Color', BackGroundColor);
set(handles.axes_vertical,   'Color', BackGroundColor);

set(handles.axes_main,       'XColor', [1 1 1]);
set(handles.axes_main,       'YColor', [1 1 1]);
set(handles.axes_horizontal, 'XColor', [1 1 1]);
set(handles.axes_horizontal, 'YColor', [1 1 1]);
set(handles.axes_vertical,   'XColor', [1 1 1]);
set(handles.axes_vertical,   'YColor', [1 1 1]);

set(handles.axes_horizontal, 'XGrid', 'On');
set(handles.axes_horizontal, 'YGrid', 'On');
set(handles.axes_vertical,   'XGrid', 'On');
set(handles.axes_vertical,   'YGrid', 'On');

Plot_GridOff_Callback(hObject, eventdata, handles);
Camera_Start_Callback(hObject, eventdata, handles);

set(handles.figure1, 'Visible', 'On');
%drawnow expose

% Start timer
start(handles.CameraTimer);


% --- Outputs from this function are returned to the command line.
function varargout = imageviewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% Turn off timer
try
    if isfield(handles,'CameraTimer')
        stop(handles.CameraTimer);
        delete(handles.CameraTimer);
    end
catch
    fprintf('Error deleting the timer.\n');
end


% --------------------------------------------------------------------
function Menu_Exit_Callback(hObject, eventdata, handles)
% Turn off timer
try
    if isfield(handles,'CameraTimer')
        stop(handles.CameraTimer);
        delete(handles.CameraTimer);
    end
catch
    fprintf('Error deleting the timer.\n');
end
close(handles.figure1);


% 
function UpdateGraphics(handles, Cam)

% Add CamName and timestamp !!!


if nargin < 2
    Cam = getappdata(handles.figure1, 'Image');
end

% Changes to image
if strcmpi(get(handles.Menu_ShowBackground, 'Checked'), 'On')
    Cam.Image = Cam.Bg;
elseif isempty(Cam.Image) || Cam.Image.Cols==0 || Cam.Image.Rows==0
    set(handles.YProfileMax, 'String', 'No Image');
    return;
    %Cam.Image = Cam.Bg;
    %Cam.Image.Data = NaN * Cam.Image.Data;
    %%c = get(handles.imageplot, 'CData');
    %%set(handles.imageplot, 'CData', NaN*c);
    %elseif get(handles.Background, 'Value') == 1
    % Cam.Image.Data = Cam.Image.Data - Cam.Bg.Data;
end

x = [1 Cam.Image.Cols]+Cam.Image.ColOffset;
y = [1 Cam.Image.Rows]+Cam.Image.RowOffset;
c = reshape(Cam.Image.Data, Cam.Image.Cols, Cam.Image.Rows)';

%     if strcmpi(Cam.DataType, 'UInt8')
%         %imagesc(Cam.Data(1,:), [0 2^14-1]);
%         imagesc(reshape(Cam.Data(1,:), Cam.Cols, Cam.Rows)', [0 2^8]);
%     else
%         % UInt16
%         imagesc(reshape(Cam.Data(1,:), Cam.Cols, Cam.Rows)', [0 2^12]);
%     end
%     colormap(gray);
%     axis image

set(handles.imageplot, 'CData', c);
set(handles.imageplot, 'XData', x(1):x(2));
set(handles.imageplot, 'YData', y(1):y(2));

set(handles.axes_main, 'XLim', x);  % [1 Cam.Image.Rows]
set(handles.axes_main, 'YLim', y);  % [1 Cam.Image.Cols]

% Full screen projection
XProjection = sum(c, 1) / size(c, 1);
YProjection = sum(c, 2) / size(c, 2);

set(handles.profx, 'XData', x(1):x(2), 'YData', XProjection);
set(handles.profy, 'XData', y(1):y(2), 'YData', YProjection);

set(handles.axes_vertical,   'XLim', y);
set(handles.axes_horizontal, 'XLim', x);

set(handles.XProfileMax, 'String', sprintf('%.1f', max(XProjection)));
set(handles.YProfileMax, 'String', sprintf('%.1f', max(YProjection)));

if any(size(Cam.Image.ImageNumber) > 1)
    set(handles.ImageNumber, 'String', sprintf('%d to %d', min(Cam.Image.ImageNumber), max(Cam.Image.ImageNumber)));
else
    set(handles.ImageNumber, 'String', sprintf('%d', Cam.Image.ImageNumber));
end

%Cam.Image.ImageNumber

drawnow



% --- Executes on button press in OneShot.
% function OneShot_Callback(hObject, eventdata, handles)
% 
% % If continuous capture is off
% if get(handles.Continuous, 'Value') == 0
%     % Get image
%     Cam       = getappdata(handles.figure1, 'Image');
%     CamName   = getcameraname(handles);
%     NAvg      = 1; %get(handles.ImageAverages, 'Value');
%     NImages   = 1;
%     
%     try
%         Cam.Image = getcam(CamName, NAvg, NImages, 0);
%     catch
%         fprintf('%s\n', lasterr);
%         fprintf('   Error getting the camera image.\n');
%         return
%     end
%     setappdata(handles.figure1, 'Image', Cam);
%     
%     % Update graphs, etc.
%     UpdateGraphics(handles, Cam);
% end


function varargout = Camera_Timer_Callback(hObject, eventdata, handles)

[CamName, CamNum] = getcameraname(handles);

% If passive
if get(handles.Camera_PassiveSelect, 'Value') == 1
    CamList = getappdata(handles.figure1, 'CameraInputData');
    
    % Check if a new screen is selected
    CamActive = '';
    for i = 1:size(CamList,1)
        PV_Active = CamList{i,3};
        if ~isempty(PV_Active)
            ActiveState = getpvonline(PV_Active, 'double', 1);
            if ActiveState
                % Found active camera
                CamActive = CamList{i,2};
                CamValue = i;
                break;
            end
        end
    end
    if isempty(CamActive)
        % Is nothing is active, default to None or no change
        if 0
            % None
            CamName = 'None';
            CamValue = 1;
        else
            CamValue = CamNum;
        end
        
    end
    
    if CamValue ~= CamNum
        % Select the new camera
        set(handles.Camera_Select, 'Value', CamValue);
        Camera_Select_Callback(hObject, eventdata, handles);
    end
end


% if get(handles.Continuous, 'Value') == 1

[CamName, CamNum] = getcameraname(handles);
if CamNum == 1
    pause(.2);
    return
end


% Get image
Cam       = getappdata(handles.figure1, 'Image');
NAvg      = 0; % get(handles.ImageAverages, 'Value');
NImages   = 1;

try
    Cam.Image = getcam(CamName, NAvg, NImages, 0);
catch
    fprintf('%s\n', lasterr);
    fprintf('   Error getting the camera image.\n');
    return
end

setappdata(handles.figure1, 'Image', Cam);

% Update graphs, etc.
UpdateGraphics(handles, Cam);

%     set(handles.Continuous, 'String', 'Continuous capture is on');
%     set(handles.Continuous, 'BackgroundColor', [1 1 1]*.5);
% else
%     set(handles.Continuous, 'String', 'Continuous capture is off');    
%     set(handles.Continuous, 'BackgroundColor', [1 1 1]*.72);
% end


% Update the EPICS PVs

% Exposure time
ExposureTimeRBV = getpvonline([CamName, ':cam1:AcquireTime_RBV'], 'double');
set(handles.ExposureTimeRBV, 'String', num2str(ExposureTimeRBV));

% Trigger delay
TriggerDelayRBV = getpvonline([CamName, ':cam1:TriggerDelay_RBV'], 'double');
set(handles.TriggerDelayRBV, 'String', num2str(TriggerDelayRBV));

% Gain
CameraGainRBV = getpvonline([CamName, ':cam1:Gain_RBV'], 'double');
set(handles.CameraGainRBV, 'String', num2str(CameraGainRBV));

% Camera connectionon/off
AcquireRBV = getpvonline([CamName, ':cam1:Acquire'], 'double');
if AcquireRBV
    set(handles.Camera_Stop,  'Value', 0);
    set(handles.Camera_Start, 'Value', 1);
else
    set(handles.Camera_Stop,  'Value', 1);
    set(handles.Camera_Start, 'Value', 0);
end

% Light

% Paddle

%pause(.1);



function varargout = Camera_Timer_Error(hObject, eventdata, handles)
try
    if isfield(handles,'CameraTimer')
        stop(handles.CameraTimer);
        delete(handles.CameraTimer);
    end
catch
    fprintf('Error deleting the timer.\n');
end


function [CamName, CameraNumber] = getcameraname(handles)
CameraNumber = get(handles.Camera_Select, 'Value');
CamList = getappdata(handles.figure1, 'CameraInputData');
CamName = CamList{CameraNumber,2};


% % --- Executes on button press in button_select_file.
% function button_select_file_Callback(hObject, eventdata, handles)
% % hObject    handle to button_select_file (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [filename, path] = uigetfile({'*.jpg; *.bmp; *.gif; *.png', 'Image files'}, ...
%     'Image file selector (jpg, bmp, gif, png)');
% image_path = strcat(path, filename);
% Cam = imread(image_path);
% setappdata(handles.axes_main, 'original_image', Cam);
% set_image(Cam, 'original');
% %select_roi_and_process(Cam, handles)


function XProfileMax_Callback(hObject, eventdata, handles)
function YProfileMax_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function XProfileMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function YProfileMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Camera_Gain.
function Camera_Gain_Callback(hObject, eventdata, handles)
% Camera gain setup
CamName = getcameraname(handles);
%Camera_Gain = getpv([CamName, ':cam1:Gain']);
Value = get(handles.Camera_Gain, 'Value')-1;
setpv([CamName, ':cam1:Gain'], Value);


% --- Executes during object creation, after setting all properties.
function Camera_Gain_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Camera_Select.
function Camera_Select_Callback(hObject, eventdata, handles)

drawnow;

% Camera gain setup
[CamName, CamNumber] = getcameraname(handles);

CameraNumber = get(handles.Camera_Select, 'Value');
CamList = getappdata(handles.figure1, 'CameraInputData');
Cams = CamList(:,2);

% First stop the cameras (excepth the beamline cameras)
%  * Saves the image for viewing
%  * Saves the network
for i = 1:length(Cams)
    if length(Cams{i})>=2 && ~strcmpi(Cams{i}(1:2),'BL')
        setpvonline([Cams{i}, ':cam1:Acquire'], 0, 'double', 1);
    end
end

if isempty(CamName)
    % Stop timer, if running
    %if strcmpi(get(handles.CameraTimer,'Running'), 'on')
    %    stop(handles.CameraTimer);
    %end
    return;
end

% Make sure cameras is connected
setpvonline([CamName, ':cam1:AsynIO.CNCT'], 1, 'double', 1);
% Make sure all cameras are connected???
% for i = 1:length(Cams)
%     if length(Cams{i})>=2 && ~strcmpi(Cams{i}(1:2),'BL')
%         setpvonline([Cams{i}, ':cam1:AsynIO.CNCT'], 1, 'double', 1);
%     end
% end


% Camera setup

% Gain
CameraGain = getpv([CamName, ':cam1:Gain']);
set(handles.Camera_Gain, 'Value',round(CameraGain+1));
CameraGainRBV = getpv([CamName, ':cam1:Gain_RBV']);
set(handles.CameraGainRBV, 'String', num2str(CameraGainRBV));

% Exposure Time
Exposure = getpv([CamName, ':cam1:AcquireTime']);
set(handles.Camera_ExposureTime, 'String', num2str(Exposure));
ExposureRBV = getpv([CamName, ':cam1:AcquireTime_RBV']);
set(handles.CameraGainRBV, 'String', num2str(ExposureRBV));

% Trigger Delay
TriggerDelay = getpv([CamName, ':cam1:TriggerDelay']);
set(handles.Camera_TriggerDelay, 'String', num2str(TriggerDelay));
TriggerDelayRBV = getpv([CamName, ':cam1:TriggerDelay_RBV']);
set(handles.CameraGainRBV, 'String', num2str(TriggerDelayRBV));

% Camera setup
% Connection, ...
% LCam1:cam1:ShutterMode
% LCam1:cam1:TriggerEvent
% LCam1:cam1:TriggerSoftware
% LCam1:cam1:ColorMode
% LCam1:cam1:SizeX
% LCam1:cam1:SizeY
setpvonline([CamName, ':cam1:ArrayCallbacks'], 1, 'double', 1);      % Waveform array callbacks
setpvonline([CamName, ':cam1:DataType'],       1, 'double', 1);      % 1-UInt16, 0-UInt8

% Plugins Enabled Or Disabled, comment for "don't care"
setpvonline([CamName, ':image1:EnableCallbacks'], 1, 'double', 1);   % Image
%setpvonline([CamName, ':Proc1:EnableCallbacks'],  1, 'double', 1);   % Processing
%setpvonline([CamName, ':ROI1:EnableCallbacks'],   1, 'double', 1);   % ROI 1
%setpvonline([CamName, ':Stats1:EnableCallbacks'], 1, 'double', 1);   % Statistics 1

% Single=0, Multiple=1, Continuous=2
setpvonline([CamName, ':cam1:ImageMode'], 2, 'double', 1);

% TriggerMode: FreeRun=0, Sync1=1, Sync2=2, Sync3=3, Sync4=4, FixRate=5, Software=6
if strcmpi(getfamilydata('Machine'), 'ALS') && length(CamName)>=2 && strcmpi(CamName(1:2),'BL')
    % For ALS BL -> FreeRun
    setpvonline([CamName, ':cam1:TriggerMode'],   0, 'double', 1);
    setpvonline([CamName, ':cam1:AcquirePeriod'], 1, 'double', 1);  % AcquirePeriod [seconds]
elseif strcmpi(getfamilydata('Machine'), 'ALS')
    % For ALS BL -> Sync1
    setpvonline([CamName, ':cam1:TriggerMode'],   1, 'double', 1);
    setpvonline([CamName, ':cam1:AcquirePeriod'], 1, 'double', 1);  % AcquirePeriod [seconds]
else
    % External trigger
    if strcmpi(getfamilydata('Machine'), 'APEX')
        setpvonline([CamName, ':cam1:TriggerMode'],   2, 'double', 1);  % Sync1 In 2
        setpvonline([CamName, ':cam1:AcquirePeriod'], 2, 'double', 1);  % AcquirePeriod [seconds] (Not used when triggering)
    else
        % ALS
        setpvonline([CamName, ':cam1:TriggerMode'],   1, 'double', 1);  % Sync1 In 1
        setpvonline([CamName, ':cam1:AcquirePeriod'], 2, 'double', 1);  % AcquirePeriod [seconds] (Not used when triggering)
    end
end

% Protect the network!
% Bytes/sec   FrameRate   FramePeriod
%    89e6  ->  30.0 Hz
%    80e6  ->  27.0 Hz
%    75e6  ->  25.3 Hz
%    50e6  ->  16.8 Hz
%    25e6  ->   8.4 Hz
%    10e6  ->   3.7 Hz     .27 seconds    (was 9 MB/s on apex network monitor)             
%     5e6  ->   1.7 Hz
%     1e6  ->   0.34 Hz    2.9 seconds
if strcmpi(CamName, 'BL31')
    stop(handles.CameraTimer);
    set(handles.CameraTimer, 'Period', .1);
    start(handles.CameraTimer);
else
    stop(handles.CameraTimer);
    set(handles.CameraTimer, 'Period', .5);
    setpvonline([CamName, ':cam1:PSByteRate'], 10e6, 'double', 1);
    start(handles.CameraTimer);
end

% % Start a monitor on the ArrayData
% try
%     % Check if already a monitor (or lcaClear it?)
%     lcaNewMonitorValue([CamName, ':image1:ArrayData']);
% catch
%     % Start a monitor  (does it matter if lcaSetMonitor has already been run?)
%     %MaxCols = getpvonline([CamName, ':cam1:MaxSizeX_RBV']);
%     %MaxRows = getpvonline([CamName, ':cam1:MaxSizeY_RBV']);
%     %lcaSetMonitor([CamName, ':image1:ArrayData'], MaxRows*MaxCols, 'native');  % It appears to need 3 times the size (color?)?
%     lcaSetMonitor([CamName, ':image1:ArrayData']); 
% end

% Maybe start acquire
if get(handles.Camera_Start,'Value') == 1 || get(handles.Camera_PassiveSelect, 'Value') == 1
    % Start camera if Start button is down or in Passive select mode
    %setpvonline([CamName, ':cam1:Acquire'], 1, 'double', 1);
    Camera_Start_Callback(hObject, eventdata, handles);
else
    % Call stop
    Camera_Stop_Callback(hObject, eventdata, handles)
end

% Start timer, if stopped
if strcmpi(get(handles.CameraTimer,'Running'), 'off')
    fprintf('   Re-starting the timing.\n');
    start(handles.CameraTimer);
end

drawnow;



% --- Executes during object creation, after setting all properties.
function Camera_Select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Camera_PassiveSelect.
function Camera_PassiveSelect_Callback(hObject, eventdata, handles)

if get(handles.Camera_PassiveSelect, 'Value') == 1
    set(handles.Camera_Select, 'Enable', 'Off')
else
    set(handles.Camera_Select, 'Enable', 'On')
end


function Camera_ExposureTime_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.Camera_ExposureTime, 'String'));
if ~isempty(Value)
    CamName = getcameraname(handles);
    setpv([CamName, ':cam1:AcquireTime'], Value);
end

% --- Executes during object creation, after setting all properties.
function Camera_ExposureTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Camera_TriggerDelay_Callback(hObject, eventdata, handles)
%        str2double(get(hObject,'String')) returns contents of Camera_TriggerDelay as a double
Value = str2num(get(handles.Camera_TriggerDelay, 'String'));
if ~isempty(Value)
    CamName = getcameraname(handles);
    setpv([CamName, ':cam1:TriggerDelay'], Value);
end

% --- Executes during object creation, after setting all properties.
function Camera_TriggerDelay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function axes_main_ButtonDownFcn(hObject, eventdata, handles)

% %  [xmin ymin width height]
% a = getrect(get(hObject,'parent'),'ButtonDown');
% 
% if length(a) == 4
%     x = [a(1) a(1)+a(3)];
%     y = [a(2) a(2)+a(4)];
%     
%     XLim = get(handles.axes_main, 'XLim');
%     YLim = get(handles.axes_main, 'YLim');
%         
%     if x(1) < XLim(1); x(1) = XLim(1); end;
%     if x(2) > XLim(2); x(2) = XLim(2); end;
%     if y(1) < YLim(1); y(1) = YLim(1); end;
%     if y(2) > YLim(2); y(2) = YLim(2); end;
%     
%     if x(1) < x(2) && y(1) < y(2)
%         set(handles.axes_zoom, 'XLim', x);
%         set(handles.axes_zoom, 'YLim', y);
%         
%         % Update graphs, etc.
%         UpdateGraphics(handles);
%     else
%         fprintf('   Problem resizing graph.\n   Make sure you draw the resize box on the graph that you clicked on.\n');
%     end
% else
%     a
% end
% 
% %point1 = get(gcbf,'CurrentPoint') % button down detected
% %rect = [point1(1,1) point1(1,2) 50 100]
% %[r2] = dragrect(rect)


% function axes_zoom_ButtonDownFcn(hObject, eventdata, handles)
%
% %  [xmin ymin width height]
% a = getrect(get(hObject,'parent'),'ButtonDown');
% 
% if length(a) == 4
%     x = [a(1) a(1)+a(3)];
%     y = [a(2) a(2)+a(4)];
%     
%     XLim = get(handles.axes_main, 'XLim');
%     YLim = get(handles.axes_main, 'YLim');
%         
%     if x(1) < XLim(1); x(1) = XLim(1); end;
%     if x(2) > XLim(2); x(2) = XLim(2); end;
%     if y(1) < YLim(1); y(1) = YLim(1); end;
%     if y(2) > YLim(2); y(2) = YLim(2); end;
%     
%     if x(1) < x(2) && y(1) < y(2)
%         set(handles.axes_zoom, 'XLim', x);
%         set(handles.axes_zoom, 'YLim', y);
%         
%         % Update graphs, etc.
%         UpdateGraphics(handles);
%     else
%         fprintf('   Problem resizing graph.\n   Make sure you draw the resize box on the graph that you clicked on.\n');
%     end
% else
%     a
% end


% --------------------------------------------------------------------
function Menu_ShowBackground_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function ColorMap_Gray_Callback(hObject, eventdata, handles)
colormap(handles.figure1, 'Gray');
set(handles.ColorMap_Jet,  'Checked', 'Off');
set(handles.ColorMap_Gray, 'Checked', 'On');

% --------------------------------------------------------------------
function ColorMap_Jet_Callback(hObject, eventdata, handles)
colormap(handles.figure1, 'Jet');
set(handles.ColorMap_Jet,  'Checked', 'On');
set(handles.ColorMap_Gray, 'Checked', 'Off');


% --- Executes on button press in Plot_GridOff.
function Plot_GridOff_Callback(hObject, eventdata, handles)
set(handles.Plot_GridOn,  'Value', 0);
set(handles.Plot_GridOff, 'Value', 1);
set(handles.axes_main, 'XGrid', 'Off');
set(handles.axes_main, 'YGrid', 'Off');
set(handles.axes_main, 'XMinorGrid', 'Off');
set(handles.axes_main, 'YMinorGrid', 'Off');


% --- Executes on button press in Plot_GridOn.
function Plot_GridOn_Callback(hObject, eventdata, handles)
set(handles.Plot_GridOn,  'Value', 1);
set(handles.Plot_GridOff, 'Value', 0);
set(handles.axes_main, 'XGrid', 'On');
set(handles.axes_main, 'YGrid', 'On');
set(handles.axes_main, 'XMinorGrid', 'Off');
set(handles.axes_main, 'YMinorGrid', 'Off');


% --- Executes on button press in Camera_Stop.
function Camera_Stop_Callback(hObject, eventdata, handles)
set(handles.Camera_Stop,  'Value', 1);
set(handles.Camera_Start, 'Value', 0);

CamName = getcameraname(handles);
if ~(strcmpi(CamName, 'None') || isempty(CamName))
    setpvonline([CamName, ':cam1:Acquire'], 0, 'double', 1);
    pause(.1);
end

% --- Executes on button press in Camera_Start.
function Camera_Start_Callback(hObject, eventdata, handles)
set(handles.Camera_Stop,  'Value', 0);
set(handles.Camera_Start, 'Value', 1);

CamName = getcameraname(handles);
if ~(strcmpi(CamName, 'None') || isempty(CamName))
    setpvonline([CamName, ':cam1:Acquire'], 1, 'double', 1);
    pause(.1);
end



% --------------------------------------------------------------------
function Menu_Save_Image_Callback(hObject, eventdata, handles)

Cam = getappdata(handles.figure1, 'Image');

FileName = appendtimestamp(Cam.Image.Name, clock);
DirectoryName = getfamilydata('Directory','Image');
if isempty(DirectoryName)
    DirectoryName = [getfamilydata('Directory','DataRoot') 'Image', filesep];
end

% Make sure default directory exists
DirStart = pwd;
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
cd(DirStart);

[FileName, DirectoryName] = uiputfile('*.mat', 'Save Image File to ...', [DirectoryName FileName]);
if FileName == 0
    FileName = '';
    return
end
FileName = [DirectoryName, FileName];

% Make sure the directory exists
[DirectoryName, FileName, Ext] = fileparts(FileName);
DirStart = pwd;
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
save(FileName, 'Cam');
fprintf('   Camera data saved to %s.mat\n', [DirectoryName FileName]);
if ErrorFlag
    fprintf('   Warning: %s was not the desired directory\n', DirectoryName);
end
cd(DirStart);
    

% --------------------------------------------------------------------
function Menu_PopMain_Callback(hObject, eventdata, handles)

% axes(handles.axes_main);
% popplot;

Cam = getappdata(handles.figure1, 'Image');

if isempty(Cam) || ~isfield(Cam,'Image') || isempty(Cam.Image)
    return
end

h = figure;
imagesc(reshape(Cam.Image.Data, Cam.Image.Cols, Cam.Image.Rows)', [0 2^12-1]);
haxes = gca;
set(haxes, 'PlotBoxAspectRatio',[1.3281 1 1]);

% Change colormap
if strcmpi(get(handles.ColorMap_Gray, 'Checked'), 'On')
    colormap(h, 'Gray');
elseif strcmpi(get(handles.ColorMap_Jet, 'Checked'), 'On')
    colormap(h, 'Jet');
end


if get(handles.Plot_GridOn,  'Value') == 1
    set(haxes, 'XGrid', 'On');
    set(haxes, 'YGrid', 'On');
    set(haxes, 'XMinorGrid', 'Off');
    set(haxes, 'YMinorGrid', 'Off');
else
    set(haxes, 'XGrid', 'Off');
    set(haxes, 'YGrid', 'Off');
    set(haxes, 'XMinorGrid', 'Off');
    set(haxes, 'YMinorGrid', 'Off');
end

% set(haxes, 'XTick',[]);
% set(haxes, 'XTickLabel','');
% set(haxes, 'YTick',[]);
% set(haxes, 'YTickLabel','');

% uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
%     '*.*','All Files' },'Save Image',...
%     strcat('/remote/apex/data/Gun/',date,'new_image.tif'));
