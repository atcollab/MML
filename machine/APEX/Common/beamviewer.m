function varargout = beamviewer(varargin)
% BEAMVIEWER MATLAB code for beamviewer.fig
%      BEAMVIEWER, by itself, creates a new BEAMVIEWER or raises the existing
%      singleton*.
%
%      H = BEAMVIEWER returns the handle to a new BEAMVIEWER or the handle to
%      the existing singleton*.
%
%      BEAMVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAMVIEWER.M with the given input arguments.
%
%      BEAMVIEWER('Property','Value',...) creates a new BEAMVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beamviewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beamviewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beamviewer

% Last Modified by GUIDE v2.5 30-Oct-2013 16:36:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @beamviewer_OpeningFcn, ...
    'gui_OutputFcn',  @beamviewer_OutputFcn, ...
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


% --- Executes just before beamviewer is made visible.
function beamviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beamviewer (see VARARGIN)

% Choose default command line output for beamviewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beamviewer wait for user response (see UIRESUME)
%uiwait(handles.figure1);

% Check if the AO exists (this is required for stand-alone applications)
checkforao;


% Camera setup
if strcmpi(getfamilydata('Machine'), 'APEX')
    CamList = {
        'None',                           ''
        'Laser Camera (LCam1)',           'LCam1'
        'Screen 1 Camera (SCam1)',        'SCam1'
        'Emit. Meas. Slit 1 (EMCam1)',    'EMCam1'
        'Screen 2 Camera (SCam2)',        'SCam2'
        'Screen 3 Camera (SCam3)',        'SCam3'
        'Spectrometer Camera (SpecCam1)', 'SpecCam1'
        'UED Screen 1 Camera (UCam1)',    'UCam1'
        'UED Screen 2 Camera (UCam2)',    'UCam2'
        'UED EX 1 Camera (UEXCam1)',      'UEXCam1'
        };
    % GC1380H
    %Nrows = 1024;
    %Ncols = 1360;

    % Manta
    %Nrows = 1038;
    %Ncols = 1390;
else
    % ALS
    % Label PV 
    % Set Defaults:  Exp, Gain (GTL1=5 LTB1=21), Delay, size, ???
    % Light and paddles
    % Tempsave -> push to GTB view
    % Pixels / mm?
    CamList = {
      % Label    BaseName  ActiveIf (PaddleIn)
        'None'  ,  '',     ''
        'GTL #1',  'GTL1', 'GTL_____TV1____BM10'
        'GTL #2',  'GTL1', 'GTL_____TV2____BM04'
        'LN #1',   'LN1',  'LN______TV1____BM10'
        'LN #2',   'LN2',  'LN______TV2____BM04'
        'LTB #1',  'LTB1', 'LTB_____TV1____BM00'
        'LTB #2',  'LTB2', 'LTB_____TV2____BM06'
        'LTB #3',  'LTB3', 'LTB_____TV3____BM00'
       %'LTB #4',  'LTB4', 'LTB_____TV4____BM06'
       %'LTB #5',  'LTB5', 'LTB_____TV5____BM00'
       %'LTB #6',  'LTB6', 'LTB_____TV6____BM08'
       %'BL 3.1',  'BL31', ''
       %'BL 7.2',  'BL72', ''
        };
    % Manta
    %Nrows = 1038;
    %Ncols = 1390;
end

setappdata(handles.figure1, 'CameraInputData', CamList);
set(handles.Camera_Select, 'String', CamList(:,1));

%CamData = Cam.Image;
%CamData.Data = 0 * CamData.Data;
CamData.DataTime  = [];
CamData.SigmaX    = [];
CamData.CentroidX = [];
CamData.OffsetX   = [];
CamData.SigmaY    = [];
CamData.CentroidY = [];
CamData.OffsetY   = [];
CamData.NAvg      = 0;
setappdata(handles.figure1, 'CameraData', CamData);

% Camera setup
%CamName = getcameraname(handles);
Camera_Select_Callback(hObject, eventdata, handles);

% Set the colormap
FigureColormap_Callback(hObject, eventdata, handles);
 
 
%set(handles.image_ax,'PlotBoxAspectRatio',[1392 1040 1]);
handles.profy = plot(handles.axes_vertical,   NaN, NaN);
%set(handles.axes_vertical, 'view', [270 90]);
handles.profx = plot(handles.axes_horizontal, NaN, NaN);

handles.profxzoom = plot(handles.axes_horizontal_zoom, [NaN NaN], [NaN NaN; NaN NaN]);
handles.profyzoom = plot(handles.axes_vertical_zoom,   [NaN NaN], [NaN NaN; NaN NaN]);

%set(handles.axes_main,       'Units','pixels');
%set(handles.axes_zoom,       'Units','pixels');
%set(handles.axes_vertical,   'Units','pixels');
%set(handles.axes_horizontal, 'Units','pixels');

% set(handles.axes_vertical,   'XTickLabel', []);
% set(handles.axes_vertical,   'YTickLabel', []);
% set(handles.axes_horizontal, 'XTickLabel', []);
% set(handles.axes_horizontal, 'YTickLabel', []);

%hlink = linkprop([handles.axes_main handles.axes_vertical],{'YLim','XLim'});
%linkaxes([handles.axes_main handles.axes_vertical],   'y');
%linkaxes([handles.axes_main handles.axes_horizontal], 'x');

% First plot
axes(handles.axes_main);
handles.imageplot = imagesc(NaN*2^14*rand(1024,1360), [0 2^12-1]);

axes(handles.axes_zoom);
handles.zoomplot = imagesc(NaN*2^14*rand(1024,1360), [0 2^12-1]);

% set(handles.axes_main, 'XTick',[]);
% set(handles.axes_main, 'XTickLabel','');
% set(handles.axes_main, 'YTick',[]);
% set(handles.axes_main, 'YTickLabel','');
set(handles.axes_main, 'PlotBoxAspectRatio', [1.3281 1 1]);
set(handles.axes_zoom, 'PlotBoxAspectRatio', [1.3281 1 1]);

Cam.Image = [];
Cam.Bg    = [];
setappdata(handles.figure1, 'Image', Cam);

set(handles.imageplot, 'ButtonDownFcn', {@axes_main_ButtonDownFcn,handles});
set(handles.zoomplot,  'ButtonDownFcn', {@axes_zoom_ButtonDownFcn,handles});


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


% Draw the figure
set(handles.figure1, 'Visible', 'On');
%drawnow expose

start(handles.CameraTimer);


% --- Outputs from this function are returned to the command line.
function varargout = beamviewer_OutputFcn(hObject, eventdata, handles)
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



function [CamName, CameraNumber] = getcameraname(handles)
CameraNumber = get(handles.Camera_Select, 'Value');
CamList = getappdata(handles.figure1, 'CameraInputData');
CamName = CamList{CameraNumber,2};



function varargout = Camera_Timer_Callback(hObject, eventdata, handles)

[CamName, CamNum] = getcameraname(handles);
if CamNum == 1
    pause(.2);
    return
end


% GC1380H
%Nrows = 1024;
%Ncols = 1360;

% Manta
%Nrows = 1038;
%Ncols = 1390;

%axes(handles.axes_main);
%axes(handles.axes_zoom);

if get(handles.Continuous, 'Value') == 1
    % Get image
    Cam      = getappdata(handles.figure1, 'Image');
    CamName  = getcameraname(handles);
    NAvg     = get(handles.ImageAverages, 'Value');
    NImages  = 1;
    PlotFlag = get(handles.Menu_ShowAll, 'UserData');
    
    if NAvg == 1
        NAvg = 0;
    end
    try
        Cam.Image = getcam(CamName, NAvg, NImages, PlotFlag);
    catch
        fprintf('%s\n', lasterr);
        fprintf('   Error getting the camera image.\n');
        return
    end
    
    setappdata(handles.figure1, 'Image', Cam);
    
    % Fix & Update graphs, etc.
    [SigmaX, CentroidX, AmpX, OffsetX, SigmaY, CentroidY, AmpY, OffsetY, TimeStamp] = updategraphics(handles, Cam);
    
    set(handles.Continuous, 'String', 'Continuous capture is on');
    set(handles.Continuous, 'BackgroundColor', [1 1 1]*.5);
    drawnow;
    

    
    %%%%%%%%%%%%%%%%%%
    % Laser Feedback %
    %%%%%%%%%%%%%%%%%%
    if strcmpi(CamName, 'LCam1') && (get(handles.LaserCentroidFeedback, 'Value') == 1 || get(handles.LaserPowerFeedback, 'Value')==1)
        % Power meter
        LaserPower = getpv('Laser:Power:LowRange');
        ICT1_Current_Uncal= getpv('BLM:0:dac20_max');
        
        % ICT1 calibration using fast EPS readings (june 5,2014 calibration)
       
        I11=0;
        I12=.304768;
        C11=14;
        C12=1837;
        m1=(I12-I11)/(C12-C11);
        q1=I12-m1*C12;
        ICT1Current_mA=ICT1_Current_Uncal*m1+q1;
 
        

        CamData = getappdata(handles.figure1, 'CameraData');
        Xgoal = str2double(get(handles.Goal_LaserCentroidX, 'String'));
        Ygoal = str2double(get(handles.Goal_LaserCentroidY, 'String'));
        Pgoal = str2double(get(handles.Goal_LaserPower,     'String'));

        FBGainCentroid = str2double(get(handles.Gain_LaserCentroid, 'String'));
        FBNAvgCentroid = get(handles.NAvg_LaserCentroid, 'Value');
                
        GainPower = str2double(get(handles.Gain_LaserPower, 'String'));
        NAvgPower = get(handles.NAvg_LaserPower, 'Value');
        
        if get(handles.LaserCentroidFeedback, 'Value') == 1
            CamData.FBCentroidX = [CamData.FBCentroidX CentroidX];
            CamData.FBCentroidY = [CamData.FBCentroidY CentroidY];
        end
        if get(handles.LaserPowerFeedback, 'Value') == 1
            CamData.FBAmpX = [CamData.FBAmpX AmpX];
            CamData.FBAmpY = [CamData.FBAmpY AmpY];
            CamData.FBPower = [CamData.FBPower ICT1Current_mA];
            %CamData.FBPower = [CamData.FBPower LaserPower];
            %CamData.ICT1Current = [CamData.ICT1Current ICT1Current_mA];
        end
        % Average counter for centroid
        if get(handles.LaserCentroidFeedback, 'Value') == 1 && length(CamData.FBCentroidX) >= FBNAvgCentroid  && length(CamData.FBCentroidY) >= FBNAvgCentroid
            
            % These numbers may change
            %umperpixel = 12.2;
            MotorStepsPerPixelX = -.02/400;   % .02/28  % motor counts / pixel
            MotorStepsPerPixelY = .02/300;   % .02/28  % motor counts / pixel

            x = MotorStepsPerPixelX * (Xgoal - mean(CamData.FBCentroidX));
            y = MotorStepsPerPixelY * (Ygoal - mean(CamData.FBCentroidY));
                        
            Xact = getpvonline('Laser:HCathode.VAL');
            Yact = getpvonline('Laser:VCathode.VAL');
            
            % Note this set doesn't return until the motor is stopped!
            if get(handles.LaserCentroidFeedback, 'Value')==1
                setpvonline('Laser:HCathode.VAL', Xact + FBGainCentroid * x);
                setpvonline('Laser:VCathode.VAL', Yact + FBGainCentroid * y);
                fprintf('  Laser Centroid Feedback Step: %s  XGoal=%d   YGoal=%d   Xdelta=%.5f   Ydelta=%.5f\n', datestr(now,31), Xgoal, Ygoal, FBGainCentroid*x, FBGainCentroid*y);
            end
            
            % Clear the averaging
            CamData.FBCentroidX = [];
            CamData.FBCentroidY = [];
 
            %pause(2);
        else
          %  fprintf('  Laser Feedback NAvg: %d   (%s)\n', length(CamData.FBCentroidX), datestr(now,31));
        end
        
        
        % Average counter for power
        if get(handles.LaserPowerFeedback, 'Value') == 1 && length(CamData.FBPower) >= NAvgPower  % length(CamData.AmpX) >= NAvgPower
            
            % These numbers may change
            ModeSelector=2;
            if ModeSelector==0
                % Use laser power meter
                MotorStepsPerAmp = 65/12500;   % motor counts / power units
                a = MotorStepsPerAmp * (Pgoal - mean(CamData.FBPower));
            elseif ModeSelector==1
                % Use Amplitude fit
                MotorStepsPerAmp = abs(50)/(950);   % motor counts / Amplitude
                a = MotorStepsPerAmp * (Pgoal - mean(CamData.FBAmpX));
            else
                % Use ICT1 Current
                MotorStepsPerAmp = 10/0.05;   % motor counts / Current in mA
                a = MotorStepsPerAmp * (Pgoal - mean(CamData.FBPower));
            end
            Aact = getpvonline('Laser:StageMask.VAL');
            
            if get(handles.LaserPowerFeedback, 'Value') == 1
                Val = Aact + GainPower * a;
                if 1
                    % Use laser power meter
                    if Val < -55
                        Val = -55;
                    elseif Val > 5
                        Val = 5;
                    end
                else
                    if Val < -55
                        Val = -55;
                    elseif Val > 5
                        Val = 5;
                    end
                end
              
                setpvonline('Laser:StageMask.VAL', Val);
                fprintf('  Laser Power Feedback Step:   %s  AmpGoal=%d Delta=%.5f, Setpoint=%.5f\n', datestr(now,31), Pgoal, GainPower*a, Val);
            end
            
            % Clear the averaging
            CamData.FBAmpX = [];
            CamData.FBAmpY = [];
            CamData.FBPower = [];
 
            %pause(2);
        else
            %fprintf('  Laser Feedback NAvg: %d   (%s)\n', length(CamData.FBCentroidX), datestr(now,31));
        end
       
        setappdata(handles.figure1, 'CameraData', CamData);
    end
    
else
    set(handles.Continuous, 'String', 'Continuous capture is off');
    set(handles.Continuous, 'BackgroundColor', [1 1 1]*.72);
    
    % Turn off feedbacks
    set(handles.LaserCentroidFeedback, 'Value', 0);
    set(handles.LaserPowerFeedback,    'Value', 0);
    LaserCentroidFeedback_Callback(hObject, eventdata, handles);
    LaserPowerFeedback_Callback(hObject, eventdata, handles);
    pause(.2);
end


% Update the EPICS PVs

% Exposure time
ExposureTimeRBV = getpv([CamName, ':cam1:AcquireTime_RBV']);
set(handles.ExposureTimeRBV, 'String', num2str(ExposureTimeRBV));

% Acquire period
AcquirePeriodRBV = getpv([CamName, ':cam1:AcquirePeriod_RBV']);
set(handles.AcquirePeriodRBV, 'String', num2str(AcquirePeriodRBV));

% Gain
CameraGainRBV = getpv([CamName, ':cam1:Gain_RBV']);
set(handles.CameraGainRBV, 'String', num2str(CameraGainRBV));




    
% --- Executes on button press in Plot_Profiles.
function [SigmaX, CentroidX, AmpX, OffsetX, SigmaY, CentroidY, AmpY, OffsetY, TimeStamp] = updategraphics(handles, Cam)

% Toggle button is pressed, take appropriate action

if nargin < 2
    Cam = getappdata(handles.figure1, 'Image');
end

% Changes to image
if get(handles.Background_Show, 'Value') == 1
    Cam.Image = Cam.Bg;
elseif isempty(Cam.Image)
    Cam.Image = Cam.Bg;
    Cam.Image.Data = NaN * Cam.Image.Data;
    %c = get(handles.imageplot, 'CData');
    %set(handles.imageplot, 'CData', NaN*c);
    %return
elseif get(handles.Background_Subtraction, 'Value') == 1
    Cam.Image.Data = Cam.Image.Data - Cam.Bg.Data;
end

try
    TimeStamp = Cam.Image.DataTime;
catch
    % Can it get here???
    TimeStamp = now;
end

x = [1 Cam.Image.Cols]+Cam.Image.ColOffset;
y = [1 Cam.Image.Rows]+Cam.Image.RowOffset;
c = reshape(Cam.Image.Data, Cam.Image.Cols, Cam.Image.Rows)';

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


% Zoomed projection

set(handles.zoomplot, 'CData', c);
set(handles.zoomplot, 'XData', x(1):x(2));
set(handles.zoomplot, 'YData', y(1):y(2));

% set(handles.axes_zoom, 'CLim', [0 500]);

% Force to an integer
XLim = get(handles.axes_zoom, 'XLim');
YLim = get(handles.axes_zoom, 'YLim');

% Make sure it's not smaller/bigger than the data
if XLim(1) < x(1); XLim(1) = x(1); end;
if XLim(2) > x(2); XLim(2) = x(2); end;
if YLim(1) < y(1); YLim(1) = y(1); end;
if YLim(2) > y(2); YLim(2) = y(2); end;

if XLim(1) > x(2); XLim(1) = x(1); end;
if XLim(2) < x(1); XLim(2) = x(2); end;
if YLim(1) > y(2); YLim(1) = y(1); end;
if YLim(2) < y(1); YLim(2) = y(2); end;

XLim(1) =  ceil(XLim(1));
XLim(2) = floor(XLim(2));
YLim(1) =  ceil(YLim(1));
YLim(2) = floor(YLim(2));

set(handles.axes_zoom, 'XLim', XLim);
set(handles.axes_zoom, 'YLim', YLim);

c = c((YLim(1):YLim(2))-Cam.Image.RowOffset, (XLim(1):XLim(2))-Cam.Image.ColOffset);

XProjection = sum(c, 1) / size(c, 1);
YProjection = sum(c, 2) / size(c, 2);
set(handles.profxzoom(1), 'XData', XLim(1):XLim(2), 'YData', XProjection);
set(handles.profyzoom(1), 'XData', YLim(1):YLim(2), 'YData', YProjection);


% Gaussian fit
if strcmpi(get(handles.Menu_GaussianFit,'Checked'),'On')
    try
        
        xx = XLim(1):XLim(2);
        [SigmaX, CentroidX, AmpX, OffsetX, xx, yy]=GaussianFitFS(xx(:)', XProjection(:)');

        %[SigmaX, CentroidX, AmpX, OffsetX, r, yy] = beam_fit_gaussian(xx(:), XProjection(:));

        %Xoff = min(XProjection);
        %XProjection = XProjection - Xoff;
        %xx = XLim(1):XLim(2);
        %[Xmax, ii] = max(XProjection);
        %x_reduced = find(XProjection > Xmax/2);
        %f = fit(xx(x_reduced)', XProjection(x_reduced)', 'gauss1');
        %yy = f.a1 .* exp(-1*((xx-f.b1) ./ f.c1).^2) + Xoff;
        %SigmaX = f.c1/sqrt(2);
        
        set(handles.profxzoom(2), 'XData', xx, 'YData', yy);
        set(handles.HorizontalProjectionText, 'String', {'Projection onto the Horizontal Plane', sprintf('Sigma=%.3f  Centroid=%.3f  Amp=%.3f  Offset=%.3f', SigmaX, CentroidX, AmpX, OffsetX)});
    catch
        SigmaX=NaN; CentroidX=NaN; OffsetX=NaN;
        set(handles.HorizontalProjectionText, 'String', {' ','Projection onto the Horizontal Plane'});
        set(handles.profxzoom(2), 'XData', [NaN NaN], 'YData', [NaN NaN]);
    end
    
    try
        xx = YLim(1):YLim(2);
        [SigmaY, CentroidY, AmpY, OffsetY, xx, yy]=GaussianFitFS(xx(:)', YProjection(:)');

        %[SigmaY, CentroidY, AmpY, OffsetY, r, yy] = beam_fit_gaussian(xx(:), YProjection(:));
        set(handles.profyzoom(2), 'XData', xx, 'YData', yy);
        set(handles.VerticalProjectionText, 'String', {'Projection onto the Vertical Plane', sprintf('Sigma=%.3f  Centroid=%.3f  Amp=%.3f  Offset=%.3f', SigmaY, CentroidY, AmpY, OffsetY)});
    catch
        AmpX=NaN; AmpY=NaN; SigmaY=NaN; CentroidY=NaN; OffsetY=NaN;
        set(handles.VerticalProjectionText, 'String', {'  ','Projection onto the Vertical Plane'});
        set(handles.profyzoom(2), 'XData', [NaN NaN], 'YData', [NaN NaN]);
    end
    
    % Save
    CamData = getappdata(handles.figure1, 'CameraData');
    CamData.DataTime  = [CamData.DataTime  Cam.Image.DataTime];
    CamData.SigmaX    = [CamData.SigmaX    SigmaX];
    CamData.CentroidX = [CamData.CentroidX CentroidX];
    CamData.OffsetX   = [CamData.OffsetX   OffsetX];
    CamData.SigmaY    = [CamData.SigmaY    SigmaY];
    CamData.CentroidY = [CamData.CentroidY CentroidY];
    CamData.OffsetY   = [CamData.OffsetY   OffsetY];
    setappdata(handles.figure1, 'CameraData', CamData);
    
    % Add logic for extra PV writes:
    if strcmpi(getfamilydata('Machine'),'APEX')
        %if strcmpi(Cam.Image.Name, 'LCam1') && ~isnan(AmpX)
            setpvonline([Cam.Image.Name, ':Stat:AmplitudeX'], AmpX);
            setpvonline([Cam.Image.Name, ':Stat:SigmaX'],     SigmaX);
            setpvonline([Cam.Image.Name, ':Stat:CentroidX'],  CentroidX);
            setpvonline([Cam.Image.Name, ':Stat:OffsetX'],    OffsetX);
           %setpvonline([Cam.Image.Name, ':Stat:ResidualX'],  ResidualX);
            
            setpvonline([Cam.Image.Name, ':Stat:AmplitudeY'], AmpY);
            setpvonline([Cam.Image.Name, ':Stat:SigmaY'],     SigmaY);
            setpvonline([Cam.Image.Name, ':Stat:CentroidY'],  CentroidY);
            setpvonline([Cam.Image.Name, ':Stat:OffsetY'],    OffsetY);
           %setpvonline([Cam.Image.Name, ':Stat:ResidualY'],  ResidualY);
        %end
    end
else
    SigmaX=[]; CentroidX=[]; AmpX=[]; OffsetX=[]; SigmaY=[]; CentroidY=[]; AmpY=[]; OffsetY=[];
    set(handles.HorizontalProjectionText, 'String', {' ', 'Projection onto the Horizontal Plane'});
    set(handles.VerticalProjectionText,   'String', {' ', 'Projection onto the Vertical Plane'});
end

set(handles.axes_horizontal_zoom, 'XLim', XLim);
set(handles.axes_vertical_zoom,   'XLim', YLim);

% try
%     xall = YLim(1):YLim(2);
%     [Xmax, ii] = max(XProjection);
%     xx = find(XProjection > Xmax/2);
%     f = fit(xall(xx)', XProjection(xx)', 'gauss1');
%     yy = f.a1 .* exp(-1*((xall-f.b1) ./ f.c1).^2);
%     set(handles.profxzoom(2), 'XData', xall, 'YData', yy);
%     set(handles.VerticalProjectionText, 'String', sprintf('Vertical Projection \\sigma %.f', f.c1/sqrt(2)));
% catch
%     set(handles.VerticalProjectionText, 'String', 'Vertical Projection');
% end

%set(handles.XProfileMaxZoom, 'String', sprintf('%.1f', max(XProjection)));
%set(handles.YProfileMaxZoom, 'String', sprintf('%.1f', max(YProjection)));


% Get PVs made
% x/y:Amplitude Offset-> Xoff Sigma -> f.c1/sqrt(2)) Centroid->b1
% 5 Camera: LCam, 3 SCams

% % Just for now - autoscale ???
% if min(YProjection)==max(YProjection)
%     set(handles.axes_vertical,   'YLimMode', 'auto');
% else
%     set(handles.axes_vertical,   'YLim', [min(YProjection) max(YProjection)]);
% end
% if min(XProjection)==max(XProjection)
%     set(handles.axes_horizontal, 'YLimMode', 'auto');
% else
%     set(handles.axes_horizontal, 'YLim', [min(XProjection) max(XProjection)]);
% end


if any(size(Cam.Image.ImageNumber) > 1)
    set(handles.Camera_ImageNumber, 'String', sprintf('%d to %d', min(Cam.Image.ImageNumber), max(Cam.Image.ImageNumber)));
else
    set(handles.Camera_ImageNumber, 'String', sprintf('%d', Cam.Image.ImageNumber));
end

drawnow


% Fernando's Gaussian Fit (UNDER TEST!!!)
function [Sigma, Centroid, Amp, Offset, xg, yg]=GaussianFitFS(x,y)
        nx=size(x);
        ny=size(y);
        jj=0.;
        PeakPercent=0.6;
        try
            if nx==ny
                % First fit cycle is used for calculating the actual offset
                y0=0;
                y0=min(y);
                yred=y-y0;
                ym=max(yred);
                yh=0.;
                xh=0.;
                jj=0;
                for i=1:nx(2)
                    if yred(i)>PeakPercent*ym
                        jj=jj+1;
                        yh(jj)=yred(i);
                        xh(jj)=x(i);
                    end
                end
                w=log(yh);
                p=polyfit(xh,w,2);
                Sigma=sqrt(-1./2./p(1));
                Centroid=-p(2)/2/p(1);
                Amp=exp(p(3)-p(2)^2/4./p(1));
                xg=x;
                yg=y0+Amp*exp(-(xg-Centroid).^2/2/Sigma^2);
                yh1=mean(y-yg);
                
                y0=y0+yh1;% Actual offset value
                Offset=y0;
                
                % Second fit cycle calculate the Gaussian fit values other than offset
                yred=y-y0;
                ym=max(yred);
                yh=0.;
                xh=0.;
                jj=0;
                for i=1:nx(2)
                    if yred(i)>PeakPercent*ym
                        jj=jj+1;
                        yh(jj)=yred(i);
                        xh(jj)=x(i);
                    end
                end
                w=log(yh);
                p=polyfit(xh,w,2);
                Sigma=sqrt(-1./2./p(1));
                Centroid=-p(2)/2/p(1);
                Amp=exp(p(3)-p(2)^2/4./p(1));
                xg=x;
                yg=y0+Amp*exp(-(xg-Centroid).^2/2/Sigma^2);
            else
                ['ERROR: input variables have different size']
            end
        catch
            ['ERROR: the fit was not executed']
        end
% End Fernando's Fit


% --- Executes on button press in Background_Show.
function Background_Show_Callback(hObject, eventdata, handles)
if get(handles.Background_Show, 'Value') == 1
    % Start updating image    
    set(handles.Background_Show, 'String', 'Show background is on');
    set(handles.Background_Show, 'BackgroundColor', [1 1 1]*.5);

    set(handles.Continuous,             'Enable', 'Off');
    set(handles.OneShot,                'Enable', 'Off');
    %set(handles.Background_Acquire,    'Visible', 'Off');
    set(handles.Background_Subtraction, 'Enable', 'Off');
else
    % Stop updating image
    set(handles.Background_Show, 'String', 'Show background is off');    
    set(handles.Background_Show, 'BackgroundColor', [1 1 1]*.72);

    set(handles.Continuous,             'Enable', 'On');
    set(handles.OneShot,                'Enable', 'On');
    %set(handles.Background_Acquire,    'Visible', 'On');
    set(handles.Background_Subtraction, 'Enable', 'On');
end

% Update graphs, etc.
updategraphics(handles);



% --- Executes on button press in OneShot.
function OneShot_Callback(hObject, eventdata, handles)

% If continuous capture is off
if get(handles.Continuous, 'Value') == 0
    % Get image
    Cam       = getappdata(handles.figure1, 'Image');
    CamName   = getcameraname(handles);
    NAvg      = get(handles.ImageAverages, 'Value');
    NImages   = 1;
    PlotFlag  = get(handles.Menu_ShowAll, 'UserData');
    
    if NAvg == 1
        NAvg = 0;
    end
    try
        Cam.Image = getcam(CamName, NAvg, NImages, PlotFlag);
    catch
        fprintf('%s\n', lasterr);
        fprintf('   Error getting the camera image.\n');
        return
    end
    setappdata(handles.figure1, 'Image', Cam);
    
    % Update graphs, etc.
    updategraphics(handles, Cam);
end


% --- Executes on button press in Background_Subtraction.
function Background_Subtraction_Callback(hObject, eventdata, handles)

if get(handles.Background_Subtraction, 'Value') == 1
    % Start updating image    
    set(handles.Background_Subtraction, 'String', 'Background subtracted');
    set(handles.Background_Subtraction, 'BackgroundColor', [1 1 1]*.5);
else
    % Stop updating image
    set(handles.Background_Subtraction, 'String', 'Background subtraction off');    
    set(handles.Background_Subtraction, 'BackgroundColor', [1 1 1]*.72);
end

% Update graphs, etc.
updategraphics(handles);


% --- Executes on button press in Background_Acquire.
function Background_Acquire_Callback(hObject, eventdata, handles)

if get(handles.Background_Acquire, 'Value') == 1   
    % Get image
    Cam      = getappdata(handles.figure1, 'Image');
    CamName  = getcameraname(handles);
    NAvg     = get(handles.Background_Averages, 'Value');
    NImages  = 1;
    PlotFlag  = get(handles.Menu_ShowAll, 'UserData');
    
    if isempty(CamName)
        set(handles.Background_Acquire, 'Value', 0);
        return;
    end
    
    % Start
    %set(handles.Background_Acquire, 'Value', 1);
    set(handles.Background_Acquire, 'String', 'Acquiring');
    set(handles.Background_Acquire, 'BackgroundColor', [1 1 1]*.5);
    drawnow;
    
    % How to aquire the background
    if strcmpi(getfamilydata('Machine'),'APEX')
        if strcmpi(CamName, 'LCam1')
            % Move the beam off LCam1
            HCathodeStart = getpv('Laser:HCathode');
            setpv('Laser:HCathode', 6.05);
            pause(1.0);
        else
            % Close the shutter
            ShutterOpenState   = getpvonline('Laser:Shutter:Open',   'double');
            ShutterClosedState = getpvonline('Laser:Shutter:Closed', 'double');
            setpvonline('Laser:Shutter:CloseReq', 1);
            pause(1.0);
        end
    elseif strcmpi(getfamilydata('Machine'),'ALS')
        % GTL, BR, BTS
    end
    
    try
        Cam.Bg = getcam(CamName, NAvg, NImages, PlotFlag);
    catch
        fprintf('%s\n', lasterr);
        fprintf('   Error getting the camera image.\n');
        return
    end
    
    setappdata(handles.figure1, 'Image', Cam);
    
    set(handles.Background_Show, 'Enable', 'On');
    set(handles.Background_Subtraction,     'Enable', 'On');
    %set(handles.Background_Subtraction,     'Value', 1);
    Background_Subtraction_Callback(hObject, eventdata, handles);
    
    % Complete
    set(handles.Background_Acquire, 'String', 'Acquire Background');
    set(handles.Background_Acquire, 'BackgroundColor', [1 1 1]*.72);
    set(handles.Background_Acquire, 'Value', 0);
    
    if strcmpi(getfamilydata('Machine'),'APEX')
        if strcmpi(CamName, 'LCam1')
            setpv('Laser:HCathode', HCathodeStart);
            pause(.5);
        else
            % Return the shutter state, or just open???
            setpv('Laser:Shutter:OpenReq', 1);
            pause(.5);
        end
    elseif strcmpi(getfamilydata('Machine'),'ALS')
        % GTL, BR, BTS
    end

    set(handles.Background_Subtraction, 'Value', 1);
    Background_Subtraction_Callback(hObject, eventdata, handles);

else
    % Reset???
end

function varargout = Camera_Timer_Error(hObject, eventdata, handles)
try
    if isfield(handles,'CameraTimer')
        stop(handles.CameraTimer);
        delete(handles.CameraTimer);
    end
catch
    fprintf('Error deleting the timer.\n');
end


% --------------------------------------------------------------------
function Menu_PopPlot_Callback(hObject, eventdata, handles)

% axes(handles.axes_main);
% popplot;

Cam = getappdata(handles.figure1, 'Image');

h = figure;
h_image = imagesc(reshape(Cam.Image.Data, Cam.Image.Cols, Cam.Image.Rows)', [0 2^12-1]);
set(gca, 'PlotBoxAspectRatio',[1.3281 1 1]);

% Replace with axis_main incase the backgroud was subtracted, etc.
c = get(handles.imageplot, 'CData');
x = get(handles.imageplot, 'XData');
y = get(handles.imageplot, 'YData');
set(h_image, 'CData', c);
set(h_image, 'XData', x);
set(h_image, 'YData', y);


% set(h, 'XTick',[]);
% set(h, 'XTickLabel','');
% set(h, 'YTick',[]);
% set(h, 'YTickLabel','');

% uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
%     '*.*','All Files' },'Save Image',...
%     strcat('/remote/apex/data/Gun/',date,'new_image.tif'));


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
% Camera gain setup
CamName = getcameraname(handles);

if strcmpi(getfamilydata('Machine'), 'APEX')
    if strcmpi(CamName, 'LCam1')
        set(handles.LaserFeedback_Panel_Centroid, 'Visible', 'On');
        set(handles.LaserFeedback_Panel_Power,    'Visible', 'On');
        set(handles.LaserCentroidFeedback, 'Value', 0);
        LaserCentroidFeedback_Callback(hObject, eventdata, handles);
        LaserPowerFeedback_Callback(hObject, eventdata, handles);
    else
        set(handles.LaserFeedback_Panel_Centroid, 'Visible', 'Off');
        set(handles.LaserFeedback_Panel_Power,    'Visible', 'Off');
        set(handles.LaserCentroidFeedback, 'Value', 0);
    end
end

if isempty(CamName)
    % Stop timer, if running
    %if strcmpi(get(handles.CameraTimer,'Running'), 'on')
    %    stop(handles.CameraTimer);
    %end
    return;
end

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

% Acquire Period
AcquirePeriod = getpv([CamName, ':cam1:AcquirePeriod']);
set(handles.Camera_Period, 'String', num2str(AcquirePeriod));
AcquirePeriodRBV = getpv([CamName, ':cam1:AcquirePeriod_RBV']);
set(handles.CameraGainRBV, 'String', num2str(AcquirePeriodRBV));

% Camera setup
% Connection, ...
% LCam1:cam1:ShutterMode
% LCam1:cam1:ImageMode
% LCam1:cam1:TriggerMode
% LCam1:cam1:TriggerEvent
% LCam1:cam1:TriggerSoftware
% LCam1:cam1:ColorMode
% LCam1:cam1:SizeX
% LCam1:cam1:SizeY
% LCam1:cam1:SizeX_RBV'
% LCam1:cam1:SizeY_RBV'
setpvonline([CamName, ':cam1:DataType'],       1, 'double', 1);      % 0=UInt8  1=UInt16
setpvonline([CamName, ':cam1:ArrayCallbacks'], 1, 'double', 1);      % Waveform array callbacks

% Plugins Enabled
setpvonline([CamName, ':image1:EnableCallbacks'], 1, 'double', 1);   % Image
%setpvonline([CamName, ':Proc1:EnableCallbacks'],  1, 'double', 1);   % Processing
%setpvonline([CamName, ':ROI1:EnableCallbacks'],   1, 'double', 1);   % ROI 1
%setpvonline([CamName, ':Stats1:EnableCallbacks'], 1, 'double', 1);   % Statistics 1

% Remove Matlab background subtraction if it's a different camera
Cam = getappdata(handles.figure1, 'Image');
if ~isempty(Cam) && ~isempty(Cam.Bg) && ~strcmpi(CamName, Cam.Bg.Name)
    Cam.Bg = [];
    setappdata(handles.figure1, 'Image', Cam);
    set(handles.Background_Subtraction, 'Value', 0);
    Background_Subtraction_Callback(hObject, eventdata, handles);
end

% Single=0, Multiple=1, Continuous=2
setpvonline([CamName, ':cam1:ImageMode'], 2, 'double', 1);

% TriggerMode: FreeRun=0, Sync1=1, Sync2=2, Sync3=3, Sync4=4, FixRate=5, Software=6
if strcmpi(getfamilydata('Machine'), 'ALS') && length(CamName)>=2 && strcmpi(CamName(1:2),'BL')
    % For ALS BL -> FreeRun
    setpvonline([CamName, ':cam1:TriggerMode'],   5, 'double', 1);
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
setpvonline([CamName, ':cam1:PSByteRate'], 10e6, 'double', 1);

% Start a monitor on the ArrayData
try
    % Check if already a monitor (or lcaClear it?)
    lcaNewMonitorValue([CamName, ':image1:ArrayData']);
catch
    % Start a monitor  (does it matter if lcaSetMonitor has already been run?)
    %MaxCols = getpvonline([CamName, ':cam1:MaxSizeX_RBV']);
    %MaxRows = getpvonline([CamName, ':cam1:MaxSizeY_RBV']);
    %lcaSetMonitor([CamName, ':image1:ArrayData'], MaxRows*MaxCols, 'native');  % It appears to need 3 times the size (color?)?
    lcaSetMonitor([CamName, ':image1:ArrayData']); 
end

% Start Acquire
setpvonline([CamName, ':cam1:Acquire'], 1, 'double', 1);



% --- Executes during object creation, after setting all properties.
function Camera_Select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


function Camera_Period_Callback(hObject, eventdata, handles)
%        str2double(get(hObject,'String')) returns contents of Camera_Period as a double
Value = str2num(get(handles.Camera_Period, 'String'));
if ~isempty(Value)
    CamName = getcameraname(handles);
    setpv([CamName, ':cam1:AcquirePeriod'], Value);
end

% --- Executes during object creation, after setting all properties.
function Camera_Period_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in FigureColormap.
function FigureColormap_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.FigureColormap,'String'));
cmap     = contents{get(handles.FigureColormap,'Value')};
colormap(handles.figure1, cmap); 


% --- Executes during object creation, after setting all properties.
function FigureColormap_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function axes_main_ButtonDownFcn(hObject, eventdata, handles)

try
    %  [xmin ymin width height]
    a = getrect(get(hObject,'parent'),'ButtonDown');
catch
    return
end
    
if length(a) == 4
    x = [a(1) a(1)+a(3)];
    y = [a(2) a(2)+a(4)];
    
    XLim = get(handles.axes_main, 'XLim');
    YLim = get(handles.axes_main, 'YLim');
        
    if x(1) < XLim(1); x(1) = XLim(1); end;
    if x(2) > XLim(2); x(2) = XLim(2); end;
    if y(1) < YLim(1); y(1) = YLim(1); end;
    if y(2) > YLim(2); y(2) = YLim(2); end;
    
    if x(1) < x(2) && y(1) < y(2)
        set(handles.axes_zoom, 'XLim', x);
        set(handles.axes_zoom, 'YLim', y);
        
        % Update graphs, etc.
        updategraphics(handles);
    else
        fprintf('   Problem resizing graph.\n   Make sure you draw the resize box on the graph that you clicked on.\n');
    end
else
    a
end

%point1 = get(gcbf,'CurrentPoint') % button down detected
%rect = [point1(1,1) point1(1,2) 50 100]
%[r2] = dragrect(rect)


function axes_zoom_ButtonDownFcn(hObject, eventdata, handles)

%  [xmin ymin width height]
a = getrect(get(hObject,'parent'),'ButtonDown');

if length(a) == 4
    x = [a(1) a(1)+a(3)];
    y = [a(2) a(2)+a(4)];
    
    XLim = get(handles.axes_main, 'XLim');
    YLim = get(handles.axes_main, 'YLim');
        
    if x(1) < XLim(1); x(1) = XLim(1); end;
    if x(2) > XLim(2); x(2) = XLim(2); end;
    if y(1) < YLim(1); y(1) = YLim(1); end;
    if y(2) > YLim(2); y(2) = YLim(2); end;
    
    if x(1) < x(2) && y(1) < y(2)
        set(handles.axes_zoom, 'XLim', x);
        set(handles.axes_zoom, 'YLim', y);
        
        % Update graphs, etc.
        updategraphics(handles);
    else
        fprintf('   Problem resizing graph.\n   Make sure you draw the resize box on the graph that you clicked on.\n');
    end
else
    a
end



% --- Executes during object creation, after setting all properties.
function ImageAverages_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Background_Averages_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Menu_ShowAll_Callback(hObject, eventdata, handles)

if strcmpi(get(handles.Menu_ShowAll,'Checked'),'On') 
    set(handles.Menu_ShowAll, 'Checked', 'Off');
    set(handles.Menu_ShowAll, 'UserData', 0);
else
    set(handles.Menu_ShowAll, 'Checked', 'On');
    set(handles.Menu_ShowAll, 'UserData', 1001);  % Figure number to plot to
end


% --------------------------------------------------------------------
function Menu_GaussianFit_Callback(hObject, eventdata, handles)
if strcmpi(get(handles. Menu_GaussianFit,'Checked'),'On') 
    set(handles. Menu_GaussianFit, 'Checked', 'Off');
else
    set(handles. Menu_GaussianFit, 'Checked', 'On');
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
function Menu_Exit_Callback(hObject, eventdata, handles)
h = handles;
figure1_DeleteFcn(hObject, eventdata, handles);
close(h.figure1);

% --- Executes on button press in button_image_tool.
function Menu_ImageTool_Callback(hObject, eventdata, handles)
imcontrast(handles.axes_main);


% function ImageHistogram_Callback(hObject, eventdata, handles)
% Cam = getappdata(handles.figure1, 'Image');
% if get(handles.Background_Subtraction, 'Value') == 1
%     Bg = getappdata(handles.figure1, 'Background_Subtraction');
%     Cam.Image.Data = Cam.Image.Data - Bg.Data;
% end
% 
% c = reshape(Cam.Image.Data, Cam.Image.Cols, Cam.Image.Rows)';
% hfig = figure;
% imhist(c);


% % --- Executes on button press in checkbox_enhance.
% function checkbox_enhance_Callback(hObject, eventdata, handles)
% cb_value = get(hObject, 'Value');
% if cb_value > 0.5 % checkbox selected
%     Icurr = getappdata(handles.axes_main, 'current_image');
%     Cam = imadjust(Icurr);
%     set_image(Cam, 'enhanced');
% else
%     % fall back to previous image
%     Cam = get_image('previous');
%     set_image(Cam, 'current');
% end

% function append_to_clipboard(data, handles)
% current_cb = clipboard('paste')
% txt = strcat(current_cb, data)
% clipboard('copy', txt);
%
%clipboard('copy', get_centroid_txt(handles));
%append_to_clipboard( get_rms_txt(handles) );
    


% --------------------------------------------------------------------
function Menu_LoadOldData_Callback(hObject, ~, handles)
%[filename, path] = uigetfile({'*.jpg; *.bmp; *.gif; *.png', 'Image files'}, ...
%    'Image file selector (jpg, bmp, gif, png)');
%image_path = strcat(path, filename);
%Cam = imread(image_path);

DirectoryName = getfamilydata('Directory','Image');
if isempty(DirectoryName)
    DirectoryName = [getfamilydata('Directory','DataRoot') 'Image', filesep];
end
[FileName, DirectoryName] = uigetfile('*.mat', 'Load Image File to ...', DirectoryName);
if FileName == 0
    return
end
FileName = [DirectoryName, FileName];
load(FileName);

if exist('Cam', 'var')
elseif exist('Image', 'var')
    Cam = Image;
elseif exist('Images', 'var')
    Cam = Images;
else
    fprintf('  An image structure was not found.  The load funtions isn''t very robust yet. \n');
    fprintf('  It just looks for variable names Cam, Image, or Images.\n');
    return;
end

if ~(isfield(Cam,'Image') && isfield(Cam,'Bg'))
    fprintf('  This file doesn''t have the expected image structure format.\n');
    return
end

setappdata(handles.figure1, 'Image', Cam);

CamList = getappdata(handles.figure1, 'CameraInputData');
CamNum = 1;
for i = 1:size(CamList)
    if strcmp(Cam.Image.Name, CamList{i,2})
        CamNum = i;
        break;
    end
end
set(handles.Camera_Select, 'Value', CamNum);
Camera_Select_Callback(hObject, [], handles);

if ~isempty(Cam.Bg)
    set(handles.Background_Subtraction, 'Enable', 'On');
    set(handles.Background_Show,        'Enable', 'On');
else
    set(handles.Background_Subtraction, 'Enable', 'Off');
    set(handles.Background_Show,        'Enable', 'Off');
end

% Update graphs, etc.
updategraphics(handles);


   
% --- Executes on button press in LaserPowerFeedback.
function LaserPowerFeedback_Callback(hObject, eventdata, handles)

if get(handles.LaserPowerFeedback, 'Value') == 1
    % Start updating image    
    set(handles.LaserPowerFeedback, 'String', 'Power feedback is on');
    set(handles.LaserPowerFeedback, 'BackgroundColor', [1 1 1]*.5);
    set(handles.Menu_GaussianFit, 'Checked', 'On');
    set(handles.Continuous, 'Value', 1);
    
    CamData = getappdata(handles.figure1, 'CameraData');
    CamData.FBAmpX = [];
    CamData.FBAmpY = [];
    CamData.FBPower = [];
    setappdata(handles.figure1, 'CameraData', CamData);

else
    % Stop updating image
    set(handles.LaserPowerFeedback, 'String', 'Power feedback is off');    
    set(handles.LaserPowerFeedback, 'BackgroundColor', [1 1 1]*.72);
end
    

% --- Executes on button press in LaserCentroidFeedback.
function LaserCentroidFeedback_Callback(hObject, eventdata, handles)

if get(handles.LaserCentroidFeedback, 'Value') == 1
    % Start updating image    
    set(handles.LaserCentroidFeedback, 'String', 'Laser feedback is on');
    set(handles.LaserCentroidFeedback, 'BackgroundColor', [1 1 1]*.5);
    set(handles.Menu_GaussianFit, 'Checked', 'On');
    set(handles.Continuous, 'Value', 1);
    
    CamData = getappdata(handles.figure1, 'CameraData');
    CamData.FBCentroidX = [];
    CamData.FBCentroidY = [];
    setappdata(handles.figure1, 'CameraData', CamData);

else
    % Stop updating image
    set(handles.LaserCentroidFeedback, 'String', 'Laser feedback is off');    
    set(handles.LaserCentroidFeedback, 'BackgroundColor', [1 1 1]*.72);
end


function Goal_LaserCentroidX_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.Goal_LaserCentroidX, 'String'));
set(handles.Goal_LaserCentroidX, 'String', num2str(Value));

% --- Executes during object creation, after setting all properties.
function Goal_LaserCentroidX_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Goal_LaserCentroidY_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.Goal_LaserCentroidY, 'String'));
set(handles.Goal_LaserCentroidY, 'String', num2str(Value));

function Goal_LaserCentroidY_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NAvg_LaserCentroid.
function NAvg_LaserCentroid_Callback(hObject, eventdata, handles)

function NAvg_LaserCentroid_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Gain_LaserCentroid_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.Gain_LaserCentroid, 'String'));
set(handles.Gain_LaserCentroid, 'String', num2str(Value));

% --- Executes during object creation, after setting all properties.
function Gain_LaserCentroid_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Goal_LaserPower_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.Goal_LaserPower, 'String'));
set(handles.Goal_LaserPower, 'String', num2str(Value));


% --- Executes during object creation, after setting all properties.
function Goal_LaserPower_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NAvg_LaserPower.
function NAvg_LaserPower_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function NAvg_LaserPower_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gain_LaserPower_Callback(hObject, eventdata, handles)
%        str2double(get(hObject,'String')) returns contents of Gain_LaserPower as a double


% --- Executes during object creation, after setting all properties.
function Gain_LaserPower_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function LaserFeedback_Panel_Centroid_CreateFcn(hObject, eventdata, handles)
function LaserFeedback_Panel_Power_CreateFcn(hObject, eventdata, handles)
