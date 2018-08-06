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
%2015-03-09
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beamviewer

% Last Modified by GUIDE v2.5 15-Sep-2016 12:48:51

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
        'None', ''
        'Laser Cam1',  'LCam1'
        'Screen Cam1', 'SCam1'
        'Screen Cam2', 'SCam2'
        'Screen Cam3', 'SCam3'
        'Screen Cam4', 'SCam4'
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
        'BL 7.2',    'BL72', ''
        };
    % Manta
    Nrows = 1038;
    Ncols = 1390;
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
%% plot rectangle around the beam
handles.rectangle = rectangle('Position',[0,0,1,1]);
set(handles.rectangle,'EdgeColor',[0.5,0,0]);
set(handles.rectangle,'LineStyle','--');
set(handles.rectangle,'Visible','Off');
%
setappdata(handles.rectangle,'Size',150);
setappdata(handles.rectangle,'CenX',0);
setappdata(handles.rectangle,'CenY',0);
setappdata(handles.rectangle,'BSize',150);
setappdata(handles.rectangle,'BCenX',0);
setappdata(handles.rectangle,'BCenY',0);

axes(handles.axes_zoom);
handles.zoomplot = imagesc(NaN*2^14*rand(1024,1360), [0 2^12-1]);

% set(handles.axes_main, 'XTick',[]);
% set(handles.axes_main, 'XTickLabel','');
% set(handles.axes_main, 'YTick',[]);
% set(handles.axes_main, 'YTickLabel','');
set(handles.axes_main, 'PlotBoxAspectRatio', [1.3281 1 1]);
set(handles.axes_zoom, 'PlotBoxAspectRatio', [1.3281 1 1]);

setappdata(handles.figure1,'Continuous_Dis', 0);

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


if strcmpi(getfamilydata('Machine'),'ALS') && (strcmpi(CamName, 'BL31') || strcmpi(CamName, 'BL72'))
    cur = getdcct;
    if (cur>1.0) &&  (getappdata(handles.figure1,'Continuous_Dis')==1)
        set(handles.Continuous,'Value',1);
        set(handles.Continuous, 'String', 'Continuous capture is on');
        set(handles.Continuous, 'BackgroundColor', [1 1 1]*.5);
        
         setappdata(handles.figure1,'Continuous_Dis', 0)
        drawnow;
    end
end

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
    
    % Update graphs, etc.Camera_Timer_Callback
     if strcmpi(getfamilydata('Machine'),'ALS') && (strcmpi(Cam.Image.Name, 'BL31') || strcmpi(Cam.Image.Name, 'BL72'))
         cur = getdcct;
         if (cur<1.0)
             pause(0.5);
             try
                 Cam.Image = getcam(CamName, NAvg, NImages, PlotFlag);
             catch
                 fprintf('%s\n', lasterr);
                 fprintf('   Error getting the camera image.\n');
                 return
             end
  
             setappdata(handles.figure1, 'Image', Cam);
             
             %set(handles.Continuous,'Value',0);
             %set(handles.Continuous, 'String', 'Continuous capture is off');
             %set(handles.Continuous, 'BackgroundColor', [1 1 1]*.72);            
             
             [SigmaX, CentroidX, AmpX, OffsetX, SigmaY, CentroidY, AmpY, OffsetY, TimeStamp] = updategraphics(handles, Cam);
             set(handles.Continuous,'Value',0);
             setappdata(handles.figure1,'Continuous_Dis', 1);
             
             fprintf('  The continuous mode is disabled due to the beam current is less than 1 mA\n');

             drawnow;
    
         else
             [SigmaX, CentroidX, AmpX, OffsetX, SigmaY, CentroidY, AmpY, OffsetY, TimeStamp] = updategraphics(handles, Cam);
             set(handles.Continuous, 'String', 'Continuous capture is on');
             set(handles.Continuous, 'BackgroundColor', [1 1 1]*.5);
             drawnow;
         end
     else
         [SigmaX, CentroidX, AmpX, OffsetX, SigmaY, CentroidY, AmpY, OffsetY, TimeStamp] = updategraphics(handles, Cam);
         set(handles.Continuous, 'String', 'Continuous capture is on');
         set(handles.Continuous, 'BackgroundColor', [1 1 1]*.5);
         drawnow;
    
     end
   

    
    %%%%%%%%%%%%%%%%%%
    % Laser Feedback %
    %%%%%%%%%%%%%%%%%%
    if strcmpi(CamName, 'LCam1') && (get(handles.LaserFeedback, 'Value')==1 || get(handles.EnergyFeedback, 'Value') == 1)
        CamData = getappdata(handles.figure1, 'CameraData');
        Xgoal = str2double(get(handles.LaserFeedback_X, 'String'));
        Ygoal = str2double(get(handles.LaserFeedback_Y, 'String'));
        Agoal = str2double(get(handles.EnergyGoal,      'String'));

        FBGain = str2double(get(handles.LaserFeedback_Gain, 'String'));
        FBNAvg = get(handles.LaserFeedback_NAvg, 'Value');
                
        CamData.FBCentroidX = [CamData.FBCentroidX CentroidX];
        CamData.FBCentroidY = [CamData.FBCentroidY CentroidY];
        CamData.FBAmpX = [CamData.FBAmpX AmpX];
        CamData.FBAmpY = [CamData.FBAmpY AmpY];
        
        % Average counter
        if length(CamData.FBCentroidX) >= FBNAvg  && length(CamData.FBCentroidY) >= FBNAvg
            
            % These numbers may change
            umperpixel = 12.2;
            MotorStepsPerPixelX = .05/440;   % .02/28  % motor counts / pixel
            MotorStepsPerPixelY = .05/310;   % .02/28  % motor counts / pixel
            MotorStepsPerAmp = (-50 + 99)/(450-43);   % motor counts / Amp

            x = MotorStepsPerPixelX * (Xgoal - mean(CamData.FBCentroidX));
            y = MotorStepsPerPixelY * (Ygoal - mean(CamData.FBCentroidY));
            
            a = MotorStepsPerAmp * (Agoal - mean(CamData.FBAmpX));
            
            Xact = getpvonline('Laser:HCathode.VAL');
            Yact = getpvonline('Laser:VCathode.VAL');
            Aact = getpvonline('Laser:StageMask.VAL');
            
            % Note this set doesn't return until the motor is stopped!
            if get(handles.LaserFeedback, 'Value')==1
                setpvonline('Laser:HCathode.VAL', Xact + FBGain * x);
                setpvonline('Laser:VCathode.VAL', Yact + FBGain * y);
                fprintf('  Laser Feedback Position Step: %s  XGoal=%d   YGoal=%d   Xdelta=%.5f   Ydelta=%.5f\n', datestr(now,31), Xgoal, Ygoal, FBGain * x, FBGain * y);
            end
            
            if get(handles.EnergyFeedback, 'Value') == 1
                Val = Aact + FBGain * a;
                if Val < -99
                    Val = -99;
                elseif Val > -50
                    Val = -50;
                end
                setpvonline('Laser:StageMask.VAL', Val);
                fprintf('  Laser Feedback Energy Step:   %s  AmpGoal=%d Delta=%.5f, Setpoint=%.5f\n', datestr(now,31), Agoal, FBGain * a, Val);
            end
            
            % Clear the averaging
            CamData.FBCentroidX = [];
            CamData.FBCentroidY = [];
            CamData.FBAmpX = [];
            CamData.FBAmpY = [];
 
            pause(2);
        else
            fprintf('  Laser Feedback NAvg: %d   (%s)\n', length(CamData.FBCentroidX), datestr(now,31));
        end
        
        setappdata(handles.figure1, 'CameraData', CamData);
    end
    
else
    set(handles.Continuous, 'String', 'Continuous capture is off');
    set(handles.Continuous, 'BackgroundColor', [1 1 1]*.72);
    
    % Turn off feedbacks
    set(handles.LaserFeedback, 'Value', 0);
    LaserFeedback_Callback(hObject, eventdata, handles);
    
    set(handles.EnergyFeedback, 'Value', 0);
    EnergyFeedback_Callback(hObject, eventdata, handles);

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
    if (Cam.Image.Cols == Cam.Bg.Cols) &&(Cam.Image.Rows == Cam.Bg.Rows)
        Cam.Image.Data = Cam.Image.Data - Cam.Bg.Data;
    else
        disp('   ?? wrong background format');
        return;
    end
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

if strcmpi(Cam.Image.Name, 'BL31')
    CaliFactorX =1.3196;
    CaliFactorY =1.3196;
    %re-align and re-calibrate the camera at 07-13-2015,  the new calibration factors are
     CaliFactorX =1.8852;
     CaliFactorY =1.8852;
elseif strcmpi(Cam.Image.Name, 'BL72')
  
     try
         zoom_pos = getpv('bl72:OptemZoomZLo');
     catch
         disp('Cant not get the zoom lens position');
         zoom_pos = 20000;
     end
     %10-26-2016 calibration data
     pos_vec = [0 2000 4000 6000  8000  1000  12000  14000  16000  18000 20000];
     %distance between 2 pinhole in horizontal direction (1000 um)
     dis_vec = [ 116.6014  139.3988  164.6587  194.9275  231.1051  273.9367  325.1340  387.6127  464.2587  558.2826  674.7075];
     dis_vec = 1000*(6.08+2.04)/6.08./dis_vec;  % pixel size at the image plane,phosor (um)
     dis_vec = dis_vec*6.08/2.04; % pixel size at the source point
     CaliFactorX = spline(pos_vec,dis_vec,zoom_pos);
     
     CaliFactorY = CaliFactorX;
else
    CaliFactorX =1;
    CaliFactorY =1;
end
% Gaussian fit
if strcmpi(get(handles.Menu_GaussianFit,'Checked'),'On')
    try
        xx = XLim(1):XLim(2);
        if strcmpi(getfamilydata('Machine'),'ALS') && (strcmpi(Cam.Image.Name, 'BL31') ||strcmpi(Cam.Image.Name, 'BL72'))
            cur =getdcct;
            if cur>1.0 % if current less than 1.0, fitting is not implemented
                [SigmaX, CentroidX, AmpX, OffsetX, r, yy] = beam_fit_gaussian(xx(:), XProjection(:));
            else
                SigmaX = 0;
                CentroidX = 0;
                AmpX = 0;
                OffsetX = 0;
                r = 0;
                yy = zeros(1,length(xx));
            end
        else
            [SigmaX, CentroidX, AmpX, OffsetX, r, yy] = beam_fit_gaussian(xx(:), XProjection(:));
        end
        %Xoff = min(XProjection);
        %XProjection = XProjection - Xoff;
        %xx = XLim(1):XLim(2);
        %[Xmax, ii] = max(XProjection);
        %x_reduced = find(XProjection > Xmax/2);
        %f = fit(xx(x_reduced)', XProjection(x_reduced)', 'gauss1');
        %yy = f.a1 .* exp(-1*((xx-f.b1) ./ f.c1).^2) + Xoff;
        %SigmaX = f.c1/sqrt(2);
        
        set(handles.profxzoom(2), 'XData', xx, 'YData', yy);
        set(handles.HorizontalProjectionText, 'String', {'Projection onto the Horizontal Plane', sprintf('Sigma=%.3f  Centroid=%.3f  Amp=%.3f  Offset=%.3f', SigmaX*CaliFactorX, CentroidX, AmpX, OffsetX)});
   
    catch
        AmpX=NaN; SigmaX=NaN; CentroidX=NaN; OffsetX=NaN;
        set(handles.HorizontalProjectionText, 'String', {' ','Projection onto the Horizontal Plane'});
        set(handles.profxzoom(2), 'XData', [NaN NaN], 'YData', [NaN NaN]);
    end
    
    try
        xx = YLim(1):YLim(2);
        if strcmpi(getfamilydata('Machine'),'ALS') && (strcmpi(Cam.Image.Name, 'BL31') || strcmpi(Cam.Image.Name, 'BL72'))
            cur = getdcct;
            if cur>1.0
                [SigmaY, CentroidY, AmpY, OffsetY, r, yy] = beam_fit_gaussian(xx(:), YProjection(:));
            else
                SigmaY = 0;
                CentroidY = 0;
                AmpY = 0;
                OffsetY = 0;
                r = 0;
                yy = zeros(1,length(xx));
            end
        else
            [SigmaY, CentroidY, AmpY, OffsetY, r, yy] = beam_fit_gaussian(xx(:), YProjection(:));
        end
        
        set(handles.profyzoom(2), 'XData', xx, 'YData', yy);
        set(handles.VerticalProjectionText, 'String', {'Projection onto the Vertical Plane', sprintf('Sigma=%.3f  Centroid=%.3f  Amp=%.3f  Offset=%.3f', SigmaY*CaliFactorY, CentroidY, AmpY, OffsetY)});
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
        if strcmpi(Cam.Image.Name, 'LCam1') && ~isnan(AmpX)
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
        end
    elseif strcmpi(getfamilydata('Machine'),'ALS')
       
        if strcmpi(Cam.Image.Name, 'BL31') && ~isnan(AmpX) && (SigmaX<100)&&(SigmaY<100)&&(SigmaX>1)&&(SigmaY>1)
            if strcmpi(get(handles.Menu_PVsWrite,'Checked'),'On')
                try
                    setpvonline('beamline31:XRMSAve',round(SigmaX*CaliFactorX*10)/10);
                    setpvonline('beamline31:YRMSAve',round(SigmaY*CaliFactorY*10)/10);
                    setpvonline('beamline31:XCentAve',CentroidX);
                    setpvonline('beamline31:YCentAve',CentroidY);
                catch
                    disp(' ++');
                end
            end
           
            setappdata(handles.rectangle,'BCenX',CentroidX);
            setappdata(handles.rectangle,'BCenY',CentroidY);
            setappdata(handles.rectangle,'BSize',150);
                   
        elseif strcmpi(Cam.Image.Name, 'BL72') && ~isnan(AmpX) && (SigmaX<100)&&(SigmaY<100)&&(SigmaX>1)&&(SigmaY>1)
            if strcmpi(get(handles.Menu_PVsWrite,'Checked'),'On')
                try
                    setpvonline('bl72:XRMSAve',round(SigmaX*CaliFactorX*10)/10);
                    setpvonline('bl72:YRMSAve',round(SigmaY*CaliFactorY*10)/10);
                    setpvonline('bl72:XCentAve',CentroidX);
                    setpvonline('bl72:YCentAve',CentroidY);
                catch
                    disp(' ++');
                end
            end
           
            setappdata(handles.rectangle,'BCenX',CentroidX);
            setappdata(handles.rectangle,'BCenY',CentroidY);
            setappdata(handles.rectangle,'BSize',max([7*SigmaX,7*SigmaY]));
        else
            if strcmpi(get(handles.Menu_PVsWrite,'Checked'),'On')
                try
                    if strcmpi(Cam.Image.Name, 'BL31')
                        setpvonline('beamline31:XRMSAve',0);
                        setpvonline('beamline31:YRMSAve',0);
                        setpvonline('beamline31:XCentAve',0);
                        setpvonline('beamline31:YCentAve',0);
                    elseif strcmpi(Cam.Image.Name, 'BL72')
                        setpvonline('bl72:XRMSAve',0);
                        setpvonline('bl72:YRMSAve',0);
                        setpvonline('bl72:XCentAve',0);
                        setpvonline('bl72:YCentAve',0);
                    else
                    end
                catch
                    disp(' ++');
                end
            end
            setappdata(handles.rectangle,'BCenX',round(Cam.Image.Cols/2));
            setappdata(handles.rectangle,'BCenY',round(Cam.Image.Rows/2));
            setappdata(handles.rectangle,'BSize',min([round(Cam.Image.Cols/2),round(Cam.Image.Rows/2)]));
        end
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
CamName   = getcameraname(handles);
FrameRate = getpv([CamName,':cam1:ArrayRate_RBV']);
set(handles.Camera_FrameRate, 'String', sprintf('%d', FrameRate));

drawnow



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
    CamName   = getcameraname(handles);
    if isempty(CamName)
        fprintf('   Error Camera is not found.\n')
        return;
    end
    Cam       = getappdata(handles.figure1, 'Image');
    
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
            setpv('Laser:HCathode', 6.2);
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
    set(handles.Background_Save, 'Enable', 'On');

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

Cam = get_image('current');

h = figure;
imagesc(reshape(Cam.Image.Data, Cam.Image.Cols, Cam.Image.Rows)', [0 2^12-1]);
set(gca, 'PlotBoxAspectRatio',[1.3281 1 1]);

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
    set(handles.Background_Show, 'Value', 0);

    set(handles.Background_Show, 'Enable', 'Off');
    set(handles.Background_Subtraction,     'Enable', 'Off');
    set(handles.Background_Save, 'Enable', 'Off');
    
    Background_Subtraction_Callback(hObject, eventdata, handles);

end

if strcmpi(getfamilydata('Machine'), 'APEX')
    if strcmpi(CamName, 'LCam1')
        set(handles.LaserFeedback_Panel, 'Visible', 'On');
        set(handles.LaserFeedback, 'Value', 0);
        LaserFeedback_Callback(hObject, eventdata, handles);
    else
        set(handles.LaserFeedback_Panel, 'Visible', 'Off');
        set(handles.LaserFeedback, 'Value', 0);
    end
elseif strcmpi(getfamilydata('Machine'), 'ALS')
    if strcmpi(CamName, 'BL31') 
       set(handles. Menu_GaussianFit, 'Checked', 'On');
       set(handles. Menu_PVsWrite, 'Checked', 'On');
       set(handles.Camera_FrameRate,'Visible','On');
       set(handles.Camera_Frame,'Visible','On');
       set(handles.rectangle,'Visible','On');
       set(handles.Beam_Zoom_Cen,'Visible','On');
       set(handles.Beam_Zoom_Cen,'Enable','On');
       set(handles.Beam_Zoom_Up,'Visible','On');
       set(handles.Beam_Zoom_Up,'Enable','On');      
       set(handles.Beam_Zoom_Down,'Visible','On');
       set(handles.Beam_Zoom_Down,'Enable','On');
       set(handles.Beam_Zoom_Left,'Visible','On');
       set(handles.Beam_Zoom_Left,'Enable','On');
       set(handles.Beam_Zoom_Right,'Visible','On');
       set(handles.Beam_Zoom_Right,'Enable','On');      
       set(handles.Beam_Zoom_In,'Visible','On');
       set(handles.Beam_Zoom_In,'Enable','On');
       set(handles.Beam_Zoom_Out,'Visible','On');
       set(handles.Beam_Zoom_Out,'Enable','On');  
       set(handles.Beam_Zoom_Select,'Visible','Off');
       set(handles.Beam_Zoom_Select,'Enable','Off');     
    elseif strcmpi(CamName, 'BL72')
       set(handles. Menu_GaussianFit, 'Checked', 'On');
       set(handles. Menu_PVsWrite, 'Checked', 'On');
       set(handles.Camera_FrameRate,'Visible','On');
       set(handles.Camera_Frame,'Visible','On');
       set(handles.rectangle,'Visible','On');
       set(handles.Beam_Zoom_Cen,'Visible','On');
       set(handles.Beam_Zoom_Cen,'Enable','On');
       set(handles.Beam_Zoom_Up,'Visible','On');
       set(handles.Beam_Zoom_Up,'Enable','On');      
       set(handles.Beam_Zoom_Down,'Visible','On');
       set(handles.Beam_Zoom_Down,'Enable','On');
       set(handles.Beam_Zoom_Left,'Visible','On');
       set(handles.Beam_Zoom_Left,'Enable','On');
       set(handles.Beam_Zoom_Right,'Visible','On');
       set(handles.Beam_Zoom_Right,'Enable','On');      
       set(handles.Beam_Zoom_In,'Visible','On');
       set(handles.Beam_Zoom_In,'Enable','On');
       set(handles.Beam_Zoom_Out,'Visible','On');
       set(handles.Beam_Zoom_Out,'Enable','On');
       set(handles.Beam_Zoom_Select,'Visible','On');
       set(handles.Beam_Zoom_Select,'Enable','On'); 
       setappdata(handles.rectangle,'Size',50);
       setappdata(handles.rectangle,'BSize',50);
      
       set(handles.FigureColormap,'Value',3)
       colormap(handles.figure1, 'Hot');
    else
       set(handles. Menu_GaussianFit, 'Checked', 'Off');
       set(handles. Menu_PVsWrite, 'Checked', 'Off');
       set(handles.Camera_FrameRate,'Visible','Off');
       set(handles.Camera_Frame,'Visible','Off');
       set(handles.rectangle,'Visible','Off');
       set(handles.Beam_Zoom_Cen,'Visible','Off');
       set(handles.Beam_Zoom_Cen,'Enable','Off');
       set(handles.Beam_Zoom_Up,'Visible','Off');
       set(handles.Beam_Zoom_Up,'Enable','Off');      
       set(handles.Beam_Zoom_Down,'Visible','Off');
       set(handles.Beam_Zoom_Down,'Enable','Off');
       set(handles.Beam_Zoom_Left,'Visible','Off');
       set(handles.Beam_Zoom_Left,'Enable','Off');
       set(handles.Beam_Zoom_Right,'Visible','Off');
       set(handles.Beam_Zoom_Right,'Enable','Off');      
       set(handles.Beam_Zoom_In,'Visible','Off');
       set(handles.Beam_Zoom_In,'Enable','Off');
       set(handles.Beam_Zoom_Out,'Visible','Off');
       set(handles.Beam_Zoom_Out,'Enable','Off'); 
       set(handles.Beam_Zoom_Select,'Visible','Off');
       set(handles.Beam_Zoom_Select,'Enable','Off'); 
    end
    
end

% Single=0, Multiple=1, Continuous=2
setpvonline([CamName, ':cam1:ImageMode'], 2, 'double', 1);

% TriggerMode: FreeRun=0, Sync1=1, Sync2=2, Sync3=3, Sync4=4, FixRate=5, Software=6
if strcmpi(getfamilydata('Machine'), 'ALS') && length(CamName)>=2 && strcmpi(CamName(1:2),'BL')
    % For ALS BL -> FreeRun
    if ~strcmpi(CamName, 'BL31') || ~strcmpi(CamName, 'BL72') % for BL31 Cam, keep the setting
        setpvonline([CamName, ':cam1:TriggerMode'],   5, 'double', 1);
        setpvonline([CamName, ':cam1:AcquirePeriod'], 1, 'double', 1);  % AcquirePeriod [seconds]
    end
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
if ~strcmpi(CamName, 'BL31') || ~strcmpi(CamName, 'BL72')
      setpvonline([CamName, ':cam1:PSByteRate'], 10e6, 'double', 1);
end

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
function FigureColormap_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function axes_main_ButtonDownFcn(hObject, eventdata, handles)

CamName   = getcameraname(handles);
if strcmpi(CamName, 'BL31') || strcmpi(CamName, 'BL72')
        return;
end

try
    %  [xmin ymin width height]
    a = getrect(get(hObject,'parent'),'ButtonDown');
catch
    fprintf('   %sn\n', lasterr);
    fprintf('   Image processing TB required for the getrect function used in beamviewer.\n');
    fprintf('   We might have run out of licenses.\n');
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

CamName   = getcameraname(handles);
if strcmpi(CamName, 'BL31') || strcmpi(CamName, 'BL72') 
        return;
end

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
function Menu_PVsWrite_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_PVsWrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(handles. Menu_PVsWrite,'Checked'),'On') 
    set(handles. Menu_PVsWrite, 'Checked', 'Off');
else
    set(handles. Menu_PVsWrite, 'Checked', 'On');
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
[filename, path] = uigetfile({'*.jpg; *.bmp; *.gif; *.png', 'Image files'}, ...
    'Image file selector (jpg, bmp, gif, png)');
image_path = strcat(path, filename);
Cam = imread(image_path);

   

% --- Executes on button press in LaserFeedback.
function LaserFeedback_Callback(hObject, eventdata, handles)

if get(handles.LaserFeedback, 'Value') == 1
    % Start updating image    
    set(handles.LaserFeedback, 'String', 'Laser feedback is on');
    set(handles.LaserFeedback, 'BackgroundColor', [1 1 1]*.5);
    set(handles.Menu_GaussianFit, 'Checked', 'On');
    set(handles.Continuous, 'Value', 1);
    
    CamData = getappdata(handles.figure1, 'CameraData');
    CamData.FBCentroidX = [];
    CamData.FBCentroidY = [];
    CamData.FBAmpX = [];
    CamData.FBAmpY = [];
    setappdata(handles.figure1, 'CameraData', CamData);

else
    % Stop updating image
    set(handles.LaserFeedback, 'String', 'Laser feedback is off');    
    set(handles.LaserFeedback, 'BackgroundColor', [1 1 1]*.72);
end


function LaserFeedback_X_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.LaserFeedback_X, 'String'));
set(handles.LaserFeedback_X, 'String', num2str(Value));

% --- Executes during object creation, after setting all properties.
function LaserFeedback_X_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LaserFeedback_Y_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.LaserFeedback_Y, 'String'));
set(handles.LaserFeedback_Y, 'String', num2str(Value));

function LaserFeedback_Y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LaserFeedback_NAvg.
function LaserFeedback_NAvg_Callback(hObject, eventdata, handles)

function LaserFeedback_NAvg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LaserFeedback_Gain_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.LaserFeedback_Gain, 'String'));
set(handles.LaserFeedback_Gain, 'String', num2str(Value));

% --- Executes during object creation, after setting all properties.
function LaserFeedback_Gain_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in EnergyFeedback.
function EnergyFeedback_Callback(hObject, eventdata, handles)

if get(handles.EnergyFeedback, 'Value') == 1
    % Start updating image    
    set(handles.EnergyFeedback, 'String', 'Energy feedback is on');
    set(handles.EnergyFeedback, 'BackgroundColor', [1 1 1]*.5);
    set(handles.Menu_GaussianFit, 'Checked', 'On');
    set(handles.Continuous, 'Value', 1);
    
    CamData = getappdata(handles.figure1, 'CameraData');
    CamData.FBCentroidX = [];
    CamData.FBCentroidY = [];
    CamData.FBAmpX = [];
    CamData.FBAmpY = [];
    setappdata(handles.figure1, 'CameraData', CamData);

else
    % Stop updating image
    set(handles.EnergyFeedback, 'String', 'Energy feedback is off');    
    set(handles.EnergyFeedback, 'BackgroundColor', [1 1 1]*.72);
end
    


function EnergyGoal_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.EnergyGoal, 'String'));
set(handles.EnergyGoal, 'String', num2str(Value));


% --- Executes during object creation, after setting all properties.
function EnergyGoal_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Background_Load.
function Background_Load_Callback(hObject, eventdata, handles)
% hObject    handle to Background_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.Background_Load, 'Value') == 1   
    % Get image
    Cam      = getappdata(handles.figure1, 'Image');
    CamName  = getcameraname(handles);
   
    % Start
    %set(handles.Background_Load, 'Value', 1);
    set(handles.Background_Load, 'String', 'Loading');
    set(handles.Background_Load, 'BackgroundColor', [1 1 1]*.5);
    drawnow;
    
    if isempty(CamName)
        set(handles.Background_Load, 'Value', 0);
        set(handles.Background_Load, 'String', 'Load Background');
        set(handles.Background_Load, 'BackgroundColor', [1 1 1]*.72);
        fprintf('   Error Camera is not found.\n')
        return;
    end
        
   
    if strcmpi(getfamilydata('Machine'),'ALS')
        
        DirectoryName = getfamilydata('Directory', 'DataRoot');
        DirectoryName = [DirectoryName '/Image/' CamName];
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a background data file', DirectoryName);
        if FileName == 0
            S = [];
            FileName = [];
            set(handles.Background_Load, 'Value', 0);
            set(handles.Background_Load, 'String', 'Load Background');
            set(handles.Background_Load, 'BackgroundColor', [1 1 1]*.72);
            fprintf('   Background loading canceled.\n')
            return;
        end
        
        FileName = [DirectoryName FileName];
        try
            Im = load(FileName);  
            Cam.Bg = Im.Bg;   
            
        catch
            fprintf('%s\n', lasterr);
            fprintf('   Error loading the background image.\n');
            return;
        end
    end
    setappdata(handles.figure1, 'Image', Cam);
    
    set(handles.Background_Show, 'Enable', 'On');
    set(handles.Background_Subtraction,     'Enable', 'On');
    set(handles.Background_Save, 'Enable', 'On');

    %set(handles.Background_Subtraction,     'Value', 1);
    Background_Subtraction_Callback(hObject, eventdata, handles);
    
    % Complete
    set(handles.Background_Load, 'String', 'Load Background');
    set(handles.Background_Load, 'BackgroundColor', [1 1 1]*.72);
    set(handles.Background_Load, 'Value', 0);
    
    if strcmpi(getfamilydata('Machine'),'ALS')
        % GTL, BR, BTS
    end

    set(handles.Background_Subtraction, 'Value', 1);
    Background_Subtraction_Callback(hObject, eventdata, handles);

else
    % Reset???
end

% --- Executes on button press in Background_Save.
function Background_Save_Callback(hObject, eventdata, handles)
% hObject    handle to Background_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.Background_Save, 'Value') == 1)
    % Get image
    Cam      = getappdata(handles.figure1, 'Image');
    CamName  = getcameraname(handles);
   
    % Start
    %set(handles.Background_Load, 'Value', 1);
    set(handles.Background_Save, 'String', 'Saving');
    set(handles.Background_Save, 'BackgroundColor', [1 1 1]*.5);
    drawnow;
    
    if isempty(CamName)
        set(handles.Background_Save, 'String', 'Save Background');
        set(handles.Background_Save, 'BackgroundColor', [1 1 1]*.72);
        set(handles.Background_Save, 'Value', 0);
        fprintf('   Error Camera is not found.\n')
        return;
    end
    

    if strcmpi(getfamilydata('Machine'),'ALS') && ~isempty(Cam.Bg)
        Bg = Cam.Bg;
        
        DirectoryName = getfamilydata('Directory', 'DataRoot');
        DirectoryName = [DirectoryName '/Image/' CamName,'/'];
        Exp = getpv([CamName, ':cam1:AcquireTime']);;
        Gain = getpv([CamName, ':cam1:Gain']);
        FileName = [CamName,'_Background_Exp',num2str(Exp),'_Gain',num2str(Gain)];
        FileName = appendtimestamp(FileName);
        FileName =[FileName,'.mat'];
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select background image file', [DirectoryName FileName]);
        drawnow;
        if FileName == 0
            set(handles.Background_Save, 'String', 'Save Background');
            set(handles.Background_Save, 'BackgroundColor', [1 1 1]*.72);
            set(handles.Background_Save, 'Value', 0);
            
            disp('   Background saving canceled.');
            
            return
        end
        try
            FileName = [DirectoryName, FileName];
            save(FileName,'Bg');
       
        catch
            fprintf('%s\n', lasterr);
            fprintf('   Error saving the background image.\n');
            return;
    end
    
  end
   
    % Complete
    set(handles.Background_Save, 'String', 'Save Background');
    set(handles.Background_Save, 'BackgroundColor', [1 1 1]*.72);
    set(handles.Background_Save, 'Value', 0);
    
 
  
else
    % Reset???
end


% --- Executes on button press in Beam_Zoom_Cen.
function Beam_Zoom_Cen_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_Cen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CentroidX = getappdata(handles.rectangle,'BCenX');
CentroidY = getappdata(handles.rectangle,'BCenY');
size  =getappdata(handles.rectangle,'BSize');

setappdata(handles.rectangle,'CenY',CentroidY);
setappdata(handles.rectangle,'CenX',CentroidX);
setappdata(handles.rectangle,'Size',size);

 x = [CentroidX-size CentroidX+size];
 y = [CentroidY-size CentroidY+size];
    
 XLim = get(handles.axes_main, 'XLim');
 YLim = get(handles.axes_main, 'YLim');
        
 if x(1) < XLim(1); x(1) = XLim(1); end;
 if x(2) > XLim(2); x(2) = XLim(2); end;
 if y(1) < YLim(1); y(1) = YLim(1); end;
 if y(2) > YLim(2); y(2) = YLim(2); end;
 
 if x(1) < x(2) && y(1) < y(2)
     set(handles.axes_zoom, 'XLim', x);
     set(handles.axes_zoom, 'YLim', y);

 end

 try
     set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
 catch
     
 end
 
 updategraphics(handles);


% --- Executes on button press in Beam_Zoom_Up.
function Beam_Zoom_Up_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CentroidX = getappdata(handles.rectangle,'CenX');
CentroidY = getappdata(handles.rectangle,'CenY');

CentroidY = CentroidY -10;
setappdata(handles.rectangle,'CenY',CentroidY);

size  =getappdata(handles.rectangle,'Size');

 x = [CentroidX-size CentroidX+size];
 y = [CentroidY-size CentroidY+size];
    
 XLim = get(handles.axes_main, 'XLim');
 YLim = get(handles.axes_main, 'YLim');
        
 if x(1) < XLim(1); x(1) = XLim(1); end;
 if x(2) > XLim(2); x(2) = XLim(2); end;
 if y(1) < YLim(1); y(1) = YLim(1); end;
 if y(2) > YLim(2); y(2) = YLim(2); end;
 
 if x(1) < x(2) && y(1) < y(2)
     set(handles.axes_zoom, 'XLim', x);
     set(handles.axes_zoom, 'YLim', y);

 end
 
 try
     set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
 catch
     
 end
 
 
 updategraphics(handles);

% --- Executes on button press in Beam_Zoom_Left.
function Beam_Zoom_Left_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CentroidX = getappdata(handles.rectangle,'CenX');
CentroidY = getappdata(handles.rectangle,'CenY');

CentroidX = CentroidX -10;
setappdata(handles.rectangle,'CenX',CentroidX);

size  =getappdata(handles.rectangle,'Size');

 x = [CentroidX-size CentroidX+size];
 y = [CentroidY-size CentroidY+size];
    
 XLim = get(handles.axes_main, 'XLim');
 YLim = get(handles.axes_main, 'YLim');
        
 if x(1) < XLim(1); x(1) = XLim(1); end;
 if x(2) > XLim(2); x(2) = XLim(2); end;
 if y(1) < YLim(1); y(1) = YLim(1); end;
 if y(2) > YLim(2); y(2) = YLim(2); end;
 
 if x(1) < x(2) && y(1) < y(2)
     set(handles.axes_zoom, 'XLim', x);
     set(handles.axes_zoom, 'YLim', y);

 end
 try
     set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
 catch
     
 end
 
 
 updategraphics(handles);

% --- Executes on button press in Beam_Zoom_Right.
function Beam_Zoom_Right_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CentroidX = getappdata(handles.rectangle,'CenX');
CentroidY = getappdata(handles.rectangle,'CenY');

CentroidX = CentroidX +10;
setappdata(handles.rectangle,'CenX',CentroidX);
size  =getappdata(handles.rectangle,'Size');

 x = [CentroidX-size CentroidX+size];
 y = [CentroidY-size CentroidY+size];
    
 XLim = get(handles.axes_main, 'XLim');
 YLim = get(handles.axes_main, 'YLim');
        
 if x(1) < XLim(1); x(1) = XLim(1); end;
 if x(2) > XLim(2); x(2) = XLim(2); end;
 if y(1) < YLim(1); y(1) = YLim(1); end;
 if y(2) > YLim(2); y(2) = YLim(2); end;
 
 if x(1) < x(2) && y(1) < y(2)
     set(handles.axes_zoom, 'XLim', x);
     set(handles.axes_zoom, 'YLim', y);

 end
 
 try
     set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
 catch
     
 end
 
 
 updategraphics(handles);

% --- Executes on button press in Beam_Zoom_Down.
function Beam_Zoom_Down_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CentroidX = getappdata(handles.rectangle,'CenX');
CentroidY = getappdata(handles.rectangle,'CenY');

CentroidY = CentroidY +10;
setappdata(handles.rectangle,'CenY',CentroidY);
size  =getappdata(handles.rectangle,'Size');

 x = [CentroidX-size CentroidX+size];
 y = [CentroidY-size CentroidY+size];
    
 XLim = get(handles.axes_main, 'XLim');
 YLim = get(handles.axes_main, 'YLim');
        
 if x(1) < XLim(1); x(1) = XLim(1); end;
 if x(2) > XLim(2); x(2) = XLim(2); end;
 if y(1) < YLim(1); y(1) = YLim(1); end;
 if y(2) > YLim(2); y(2) = YLim(2); end;
 
 if x(1) < x(2) && y(1) < y(2)
     set(handles.axes_zoom, 'XLim', x);
     set(handles.axes_zoom, 'YLim', y);

 end
 try
     set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
 catch
     
 end
 
 
 updategraphics(handles);

% --- Executes on button press in Beam_Zoom_In.
function Beam_Zoom_In_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CentroidX = getappdata(handles.rectangle,'CenX');
CentroidY = getappdata(handles.rectangle,'CenY');

size  =getappdata(handles.rectangle,'Size');
size = size-10;
if (size<=0)
    size =10;
end

setappdata(handles.rectangle,'Size',size);

 x = [CentroidX-size CentroidX+size];
 y = [CentroidY-size CentroidY+size];
    
 XLim = get(handles.axes_main, 'XLim');
 YLim = get(handles.axes_main, 'YLim');
        
 if x(1) < XLim(1); x(1) = XLim(1); end;
 if x(2) > XLim(2); x(2) = XLim(2); end;
 if y(1) < YLim(1); y(1) = YLim(1); end;
 if y(2) > YLim(2); y(2) = YLim(2); end;
 
 if x(1) < x(2) && y(1) < y(2)
     set(handles.axes_zoom, 'XLim', x);
     set(handles.axes_zoom, 'YLim', y);

 end
 try
     set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
 catch
     
 end
 
 
 updategraphics(handles);

% --- Executes on button press in Beam_Zoom_Out.
function Beam_Zoom_Out_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_Out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CentroidX = getappdata(handles.rectangle,'CenX');
CentroidY = getappdata(handles.rectangle,'CenY');

size  =getappdata(handles.rectangle,'Size');
size = size+10;
if (size>400)
    size =400;
end

setappdata(handles.rectangle,'Size',size);

 x = [CentroidX-size CentroidX+size];
 y = [CentroidY-size CentroidY+size];
    
 XLim = get(handles.axes_main, 'XLim');
 YLim = get(handles.axes_main, 'YLim');
        
 if x(1) < XLim(1); x(1) = XLim(1); end;
 if x(2) > XLim(2); x(2) = XLim(2); end;
 if y(1) < YLim(1); y(1) = YLim(1); end;
 if y(2) > YLim(2); y(2) = YLim(2); end;
 
 if x(1) < x(2) && y(1) < y(2)
     set(handles.axes_zoom, 'XLim', x);
     set(handles.axes_zoom, 'YLim', y);

 end
 try
     set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
 catch
     
 end
 
 
 updategraphics(handles);


% --- Executes on button press in Beam_Zoom_Select.
function Beam_Zoom_Select_Callback(hObject, eventdata, handles)
% hObject    handle to Beam_Zoom_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Beam_Zoom_Select
 
set(handles.Beam_Zoom_Select,'Value',1);
set(handles.Beam_Zoom_Select, 'BackgroundColor', [1 1 1]*.5);
drawnow;


try
    %  [xmin ymin width height]
    %a = getrect(get(hObject,'parent'),'ButtonDown');
    a = getrect(handles.axes_main,'ButtonDown');
catch
    fprintf('   %sn\n', lasterr);
    fprintf('   Image processing TB required for the getrect function used in beamviewer.\n');
    fprintf('   We might have run out of licenses.\n');
    
    set(handles.Beam_Zoom_Select,'Value',0);
    set(handles.Beam_Zoom_Select, 'BackgroundColor', [1 1 1]);
    drawnow;
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
        
        try
            set(handles.rectangle,'Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
        catch
     
        end
        % Update graphs, etc.
        updategraphics(handles);
    else
        fprintf('   Problem resizing graph.\n   Make sure you draw the resize box on the graph that you clicked on.\n');
    end
else
    a
end

setappdata(handles.rectangle,'CenY',a(2)+a(4)/2);
setappdata(handles.rectangle,'CenX',a(1)+a(3)/2);
setappdata(handles.rectangle,'Size',max([a(4)/2,a(3)/2]));

set(handles.Beam_Zoom_Select,'Value',0);
set(handles.Beam_Zoom_Select, 'BackgroundColor', [1 1 1]);
drawnow;
