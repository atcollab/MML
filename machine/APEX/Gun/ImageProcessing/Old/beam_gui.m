function varargout = beam_gui(varargin)
% BEAM_GUI MATLAB code for beam_gui.fig
%      BEAM_GUI, by itself, creates a new BEAM_GUI or raises the existing
%      singleton*.
%
%      H = BEAM_GUI returns the handle to a new BEAM_GUI or the handle to
%      the existing singleton*.
%
%      BEAM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAM_GUI.M with the given input arguments.
%
%      BEAM_GUI('Property','Value',...) creates a new BEAM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beam_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beam_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beam_gui

% Last Modified by GUIDE v2.5 27-Mar-2012 13:54:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @beam_gui_OpeningFcn, ...
    'gui_OutputFcn',  @beam_gui_OutputFcn, ...
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


% --- Executes just before beam_gui is made visible.
function beam_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beam_gui (see VARARGIN)

initialize_widgets(handles);

% Choose default command line output for beam_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beam_gui wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% Camera gain setup
CamName = GetCameraName(handles);
CameraGain = getpv([CamName, ':cam1:Gain']);
set(handles.CameraGain, 'Value', round(CameraGain+1));
CameraGainRBV = getpv([CamName, ':cam1:Gain_RBV']);
set(handles.CameraGainRBV, 'String', num2str(CameraGainRBV));

AcquireTime = getpv([CamName, ':cam1:AcquireTime']);
set(handles.AcquireTime, 'String', num2str(AcquireTime));
AcquireTimeRBV = getpv([CamName, ':cam1:AcquireTime_RBV']);
set(handles.AcquireTimeRBV, 'String', num2str(AcquireTimeRBV));

AcquirePeriod = getpv([CamName, ':cam1:AcquirePeriod']);
set(handles.AcquirePeriod, 'String', num2str(AcquirePeriod));
AcquirePeriodRBV = getpv([CamName, ':cam1:AcquirePeriod_RBV']);
set(handles.AcquirePeriodRBV, 'String', num2str(AcquirePeriodRBV));
 

% Set the colormap
popupmenu_colormap_Callback(hObject, eventdata, handles);
 
 
%set(handles.image_ax,'PlotBoxAspectRatio',[1392 1040 1]);
handles.profy = plot(handles.axes_left,   NaN, NaN);
set(handles.axes_left, 'view', [270 90]);
handles.profx = plot(handles.axes_bottom, NaN, NaN);

set(handles.axes_main,   'Units','pixels');
set(handles.axes_left,   'Units','pixels');
set(handles.axes_bottom, 'Units','pixels');

set(handles.axes_left,   'XTickLabel', []);
set(handles.axes_left,   'YTickLabel', []);
set(handles.axes_bottom, 'XTickLabel', []);
set(handles.axes_bottom, 'YTickLabel', []);

linkaxes([handles.axes_main handles.axes_left],   'y');
linkaxes([handles.axes_main handles.axes_bottom], 'x');


% Setup Timer
UpdatePeriod = 0.5;

t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@Viewscreen_Timer_Callback,handles});
%set(t, 'StartFcn', ['llrf(''Timer_Start'',',    sprintf('%.30f',handles.hMainFigure), ',',sprintf('%.30f',handles.hMainFigure), ', [])']);
%set(t, 'UserData', thehandles);
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
set(t, 'ErrorFcn', {@Viewscreen_Timer_Error,handles});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'ImageGrabTimer');

handles.TimerHandle = t;


% First plot
axes(handles.axes_main);
Cam = getcam(CamName);
handles.imageplot = imagesc(reshape(Cam.Data, Cam.Cols, Cam.Rows)', [0 2^14-1]);
%handles.imageplot = imagesc(reshape(Cam.Data, Cam.Cols, Cam.Rows)');
%handles.imageplot = imagesc(ones(100,100),  'parent', handles.axes_main);
%set_image(Cam, 'current');

set(handles.axes_main, 'XTick',[]);
set(handles.axes_main, 'XTickLabel','');
set(handles.axes_main, 'YTick',[]);
set(handles.axes_main, 'YTickLabel','');
set(handles.axes_main, 'PlotBoxAspectRatio', [1.3281 1 1]);

Pmain = get(handles.axes_main,   'Position');
Pmain(1) = 148;
Pmain(2) = 2;
set(handles.axes_main, 'Position', Pmain);
% Pleft = get(handles.axes_left,   'Position');
% Pbott = get(handles.axes_bottom, 'Position');
set(handles.axes_left,   'Position', [5 Pmain(2)+6 138 516-12]);
set(handles.axes_bottom, 'Position', [Pmain(1) Pmain(2)+Pmain(4)-2 Pmain(3) 138]);


% Save handles
setappdata(0, 'ViewscreenTimer', handles);


% Add profiles
setappdata(handles.axes_main, 'current_image', Cam); 

% test full update
UpdateGraphics(handles);


% Draw the figure
set(handles.figure1,'Visible','On');
%drawnow expose

start(t);



% --- Outputs from this function are returned to the command line.
function varargout = beam_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save or grab an image from memory (previous_image, current_image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function set_image(Cam, name)
if isempty(name)
    name = 'current';
end

handles = getappdata(0, 'ViewscreenTimer');

if ~isfield(handles, 'imageplot')
    error=1;
end

%handles.axes.main
Iprev = get_image('current');
if ~isempty(Iprev)
    % 'previous' points to the current image
    setappdata(handles.axes_main, 'previous_image', Iprev);
end
% set(handles.figure1,'Visible','On');
%axes(handles.axes_main);
%imshow(Cam);
%axes(handles.axes_main);
%imagesc(Cam,[0 2^14-1]);

setappdata(handles.axes_main, strcat(name, '_image'), Cam);

if ~strcmp(name, 'current') %equal
    % 'current' always points to the current image
    setappdata(handles.axes_main, 'current_image', Cam);
end




function Cam = get_image(name)
handles = getappdata(0, 'ViewscreenTimer');
fqname = strcat(name, '_image');
Cam = getappdata(handles.axes_main, fqname);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save or grab an image from memory (previous_image, current_image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in button_capture.
function button_capture_Callback(hObject,eventdata, handles)

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    % Get image
    CamName = GetCameraName(handles);
    Cam     = getcam(CamName);
    set_image(Cam, 'current');

    % Update axes
    UpdateGraphics(handles);
    
   %set(hObject, 'String', 'Live Data On');
    set(hObject, 'String', sprintf('Live Data On (%d)', Cam.ImageNumber));

    set(hObject, 'BackgroundColor', [1 1 1]*.3);
else
    set(hObject, 'String', 'Live Data Off');    
    set(hObject, 'BackgroundColor', [1 1 1]*.72);
end


% --- Executes on button press in Plot_Profiles.
function UpdateGraphics(handles)

% Toggle button is pressed, take appropriate action

handles = getappdata(0, 'ViewscreenTimer');

Cam = get_image('current');

set(handles.imageplot, 'CData', reshape(Cam.Data, Cam.Cols, Cam.Rows)');
%set(handles.imageplot, 'XData', [1 Cam.Rows]);
%set(handles.imageplot, 'YData', [1 Cam.Cols]);

XProjection = sum(reshape(Cam.Data, Cam.Cols, Cam.Rows)',1);
YProjection = sum(reshape(Cam.Data, Cam.Cols, Cam.Rows)',2);    % clean up???
set(handles.profx, 'XData', 1:Cam.Cols, 'YData', XProjection);
set(handles.profy, 'XData', 1:Cam.Rows, 'YData', YProjection);

% Just for now - autoscale ???
if min(YProjection)==max(YProjection)
    set(handles.axes_left,   'YLimMode', 'auto');
else
    set(handles.axes_left,   'YLim', [min(YProjection) max(YProjection)]);
end
if min(XProjection)==max(XProjection)
    set(handles.axes_bottom, 'YLimMode', 'auto');
else
    set(handles.axes_bottom, 'YLim', [min(XProjection) max(XProjection)]);
end

set(handles.axes_left,   'XLim', [1 Cam.Rows]);
set(handles.axes_bottom, 'XLim', [1 Cam.Cols]);

set(handles.XProfileMin, 'String', sprintf('%.1f', min(XProjection)/length(XProjection)));
set(handles.XProfileMax, 'String', sprintf('%.1f', max(XProjection)/length(XProjection)));
set(handles.YProfileMin, 'String', sprintf('%.1f', min(YProjection)/length(YProjection)));
set(handles.YProfileMax, 'String', sprintf('%.1f', max(YProjection)/length(YProjection)));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Timer handling; These two functions are called by the timer at each period
% Timer_Error manages the error event
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function varargout = Viewscreen_Timer_Error(hObject, eventdata, handles)

if isfield(handles,'TimerHandle')
    stop(handles.TimerHandle);
    delete(handles.TimerHandle);
    rmappdata(0, 'LLRFTimer');
end


function varargout = Viewscreen_Timer_Callback(hObject, eventdata, handles)

%if handles.button_capture
button_capture_Callback(handles.button_capture,eventdata,handles)


% button_state = get(handles.button_capture,'Value');
%if button_state == get(handles.button_capture,'Max')
% handles.imageplot=getcam;
%end


% Updates
CamName = GetCameraName(handles);
CameraGainRBV = getpv([CamName, ':cam1:Gain_RBV']);
set(handles.CameraGainRBV, 'String', num2str(CameraGainRBV));
AcquireTimeRBV = getpv([CamName, ':cam1:AcquireTime_RBV']);
set(handles.AcquireTimeRBV, 'String', num2str(AcquireTimeRBV));
AcquirePeriodRBV = getpv([CamName, ':cam1:AcquirePeriod_RBV']);
set(handles.AcquirePeriodRBV, 'String', num2str(AcquirePeriodRBV));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Image setup (ROI, gain, exposure, etc...)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [threshold] = get_threshold(handles)
cb_value = get(handles.checkbox_auto_roi, 'Value');
if cb_value > 0.5 % checkbox selected
    Cam = get_image('current');
    threshold = graythresh(Cam);
else
    % read value from slider
    threshold = get(handles.slider_sensitivity, 'Value');
end

function [mrg] = get_margin(handles)
mrg = get(handles.slider_margin, 'Value');



function [roi] = show_roi(Cam, handles)
previous_roi = getappdata( handles.axes_main, 'roi');
if ~isempty(previous_roi) && isvalid(previous_roi)
    delete(previous_roi);
end
threshold = get_threshold(handles);
mrg = get_margin(handles);

roi = get_roi(Cam, threshold, mrg);
setappdata( handles.axes_main, 'roi', roi);


function select_roi_and_process(Cam, handles)
setappdata(handles.axes_main, 'selecting_roi', true);
roi = show_roi(Cam, handles);
wait(roi);
if isvalid(roi)
    process_and_display(Cam, roi, handles);
end
setappdata(handles.axes_main, 'selecting_roi', false);


% --- Executes on slider movement.
function slider_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to slider_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject, 'Value');
set( handles.text_sensitivity, 'String', num2str(value) );

Cam = get_image('current');
select_roi_and_process(Cam, handles)

% --- Executes during object creation, after setting all properties.
function slider_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in button_select_roi.
function button_select_roi_Callback(hObject, eventdata, handles)
% hObject    handle to button_select_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cam = get_image('current');
set(handles.button_roi_cancel, 'Enable', 'on');
select_roi_and_process(Cam, handles);
set(handles.button_roi_cancel, 'Enable', 'off');


% --- Executes on button press in button_histogram.
function button_histogram_Callback(hObject, eventdata, handles)
% hObject    handle to button_histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cam = get_image('current');
figure('Name', 'Histograms', 'Position', [0 0 800 600], ...
    'NumberTitle', 'off');
imhist(Cam);
no_image = isempty(Cam)
if no_image
    msgbox('No image or live source selected', 'No Image', 'warn', 'modal');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Image analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function [II] = clean_image(Cam, roi, filterFuncName)
mask = createMask(roi);
II = Cam .* cast(mask, class(Cam) );
ff = str2func(filterFuncName);
II = ff(II);



function plot_centroids(Cam, centroids, handles)
hold on
for i=1:size(centroids,1)
    plot(handles.axes_main, centroids(i,1), centroids(i,2), '*w');
end
%    if size(centroids,1) > 1
%        % FIXME: the following calculation doesn't take weights into account
%        overall_centroid = sum(centroids) / size(centroids,1);
%    else
%        overall_centroid = centroids;
%    end
%    plot(handles.axes_main, overall_centroid(1), overall_centroid(2), '+w');
hold off


function [II, xmean, ymean, Xsigma, Ysigma] = process_image(Cam, roi, handles)
II = clean_image(Cam, roi, 'wiener2');
[xmean,ymean,Xsigma,Ysigma,XYsigma,Area] = image_rms(II);
analysis_results = [xmean,ymean,Xsigma,Ysigma,XYsigma,Area];

setappdata(handles.axes_main, 'analysis_results', analysis_results);

set(handles.edit_centroid_x, 'String', xmean);
%    jEditbox_x = findjobj(handles.edit_centroid_x);
%    set(jEditbox_x, 'Editable', false);

set(handles.edit_centroid_y, 'String', ymean);
%    jEditbox_y = findjobj(handles.edit_centroid_y);
%    set(jEditbox_y, 'Editable', false);

set(handles.edit_rms_x, 'String', Xsigma);
%    jEditbox_rms_x = findjobj(handles.edit_rms_x);
%    set(jEditbox_rms_x, 'Editable', false);

set(handles.edit_rms_y, 'String', Ysigma);
%    jEditbox_rms_y = findjobj(handles.edit_rms_y);
%    set(jEditbox_rms_y, 'Editable', false);

setappdata(handles.axes_main, 'processed_image', II);

function process_and_display(Cam, roi, handles)
[II xmean ymean] = process_image(Cam, roi, handles);
set_image(II, 'processed');
plot_profiles({Cam, II}, handles);
plot_centroids(II, [xmean ymean], handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%"Create" functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function axes_left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_left


% --- Executes during object creation, after setting all properties.
function axes_main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_main


% --- Executes during object creation, after setting all properties.
function axes_bottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_bottom


% --- Executes during object creation, after setting all properties.
function text_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function slider_margin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_margin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in checkbox_auto_roi.
function checkbox_auto_roi_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_auto_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_auto_roi
Cam = get_image('current');
if get(hObject, 'Value') > 0 %ie, checked
    set(handles.slider_sensitivity, 'Enable', 'off');
    
else
    set(handles.slider_sensitivity, 'Enable', 'on');
    threshold = graythresh(Cam);
    set(handles.slider_sensitivity, 'Value', threshold);
    set(handles.text_sensitivity, 'String', threshold);
end
select_roi_and_process(Cam, handles)


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_file_exit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_colormap.
function popupmenu_colormap_Callback(hObject, eventdata, handles)
contents = cellstr(get(handles.popupmenu_colormap,'String'));
cmap     = contents{get(handles.popupmenu_colormap,'Value')};
colormap(handles.figure1, cmap); 


% --- Executes during object creation, after setting all properties.
function popupmenu_colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function slider_brightness_Callback(hObject, eventdata, handles)
% hObject    handle to slider_brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_brightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to slider_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_sharpness_Callback(hObject, eventdata, handles)
% hObject    handle to slider_sharpness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_sharpness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_sharpness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox_enhance.
function checkbox_enhance_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_enhance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_enhance
cb_value = get(hObject, 'Value');
if cb_value > 0.5 % checkbox selected
    Icurr = getappdata(handles.axes_main, 'current_image');
    Cam = imadjust(Icurr);
    set_image(Cam, 'enhanced');
else
    % fall back to previous image
    Cam = get_image('previous');
    set_image(Cam, 'current');
end



% --- Executes on button press in button_reset.
function button_reset_Callback(hObject, eventdata, handles)
% hObject    handle to button_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cam = get_image('original');
set_image(Cam, '');
initialize_widgets(handles);


function edit_centroid_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_centroid_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_centroid_x as text
%        str2double(get(hObject,'String')) returns contents of edit_centroid_x as a double


% --- Executes during object creation, after setting all properties.
function edit_centroid_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_centroid_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_centroid_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_centroid_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_centroid_y as text
%        str2double(get(hObject,'String')) returns contents of edit_centroid_y as a double


% --- Executes during object creation, after setting all properties.
function edit_centroid_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_centroid_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rms_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rms as text
%        str2double(get(hObject,'String')) returns contents of edit_rms as a double


% --- Executes during object creation, after setting all properties.
function edit_rms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rms_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rms_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rms_x as text
%        str2double(get(hObject,'String')) returns contents of edit_rms_x as a double


% --- Executes during object creation, after setting all properties.
function edit_rms_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rms_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_rms_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rms_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rms_y as text
%        str2double(get(hObject,'String')) returns contents of edit_rms_y as a double


% --- Executes during object creation, after setting all properties.
function edit_rms_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rms_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_margin_Callback(hObject, eventdata, handles)
% hObject    handle to slider_margin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject, 'Value');
set( handles.text_margin, 'String', num2str(value) );

Cam = get_image('current');
select_roi_and_process(Cam, handles)











% --- Executes on button press in button_roi_cancel.
function button_roi_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_roi_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
previous_roi = getappdata( handles.axes_main, 'roi');
if ~isempty(previous_roi) && isvalid(previous_roi)
    delete(previous_roi);
end


% --- Executes on button press in button_roi_revert.
function button_roi_revert_Callback(hObject, eventdata, handles)
% hObject    handle to button_roi_revert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cam = get_image('original');
set_image(Cam, '');
initialize_widgets(handles);


function initialize_widgets(handles)
sensitivity_slider_value = get(handles.slider_sensitivity, 'Value');
set( handles.text_sensitivity, 'String', num2str(sensitivity_slider_value) );
set(handles.checkbox_auto_roi, 'Value', 1);
set(handles.slider_sensitivity, 'Enable', 'off');

margin_slider_value = get(handles.slider_margin, 'Value');
set( handles.text_margin, 'String', num2str(margin_slider_value) );

set( handles.checkbox_enhance, 'Value', 0);

set( handles.button_roi_cancel, 'Enable', 'off');

cla(handles.axes_left);
cla(handles.axes_bottom);



function append_to_clipboard(data, handles)
current_cb = clipboard('paste')
txt = strcat(current_cb, data)
clipboard('copy', txt);

function [txt] = get_rms_txt(handles)
fmt = 'rms = [%f, %f];\n';
analysis_results = getappdata(handles.axes_main, 'analysis_results');
% analysis_results -> [xmean,ymean,Xsigma,Ysigma,XYsigma,Area];
txt = sprintf(fmt, analysis_results(3), analysis_results(4));

function [txt] = get_centroid_txt(handles)
fmt = 'centroid = [%f, %f];\n';
analysis_results = getappdata(handles.axes_main, 'analysis_results');
% analysis_results -> [xmean,ymean,Xsigma,Ysigma,XYsigma,Area];
txt = sprintf(fmt, analysis_results(1), analysis_results(2));

% --- Executes on button press in button_image_tool.
function button_image_tool_Callback(hObject, eventdata, handles)
% hObject    handle to button_image_tool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imcontrast(handles.axes_main);


% --- Executes on button press in button_analysis_copy_rms.
function button_analysis_copy_rms_Callback(hObject, eventdata, handles)
% hObject    handle to button_analysis_copy_rms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
txt = get_rms_txt(handles);
clipboard('copy', txt);

% --- Executes on button press in button_analysis_copy_centroid.
function button_analysis_copy_centroid_Callback(hObject, eventdata, handles)
% hObject    handle to button_analysis_copy_centroid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
txt = get_centroid_txt(handles);
clipboard('copy', txt);


% --- Executes on button press in button_analysis_copy_all.
function button_analysis_copy_all_Callback(hObject, eventdata, handles)
% hObject    handle to button_analysis_copy_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clipboard('copy', get_centroid_txt(handles));
append_to_clipboard( get_rms_txt(handles) );


function CamName = GetCameraName(handles)

if nargin < 1
    handles = getappdata(0, 'ViewscreenTimer');
end
CameraNumber = get(handles.Camera_select, 'Value');
CameraCell   = cellstr(get(handles.Camera_select,'String'));
CamName = CameraCell{CameraNumber};


% --- Executes on button press in button_select_file.
function button_select_file_Callback(hObject, eventdata, handles)
% hObject    handle to button_select_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, path] = uigetfile({'*.jpg; *.bmp; *.gif; *.png', 'Image files'}, ...
    'Image file selector (jpg, bmp, gif, png)');
image_path = strcat(path, filename);
Cam = imread(image_path);
setappdata(handles.axes_main, 'original_image', Cam);
set_image(Cam, 'original');
%select_roi_and_process(Cam, handles)



% --- Executes on button press in Save_image.
function Save_image_Callback(hObject, eventdata, handles)

Cam = get_image('current');

FileName = appendtimestamp(Cam.Name, clock);
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
function PopMain_Callback(hObject, eventdata, handles)

%handles = getappdata(0, 'ViewscreenTimer');
% axes(handles.axes_main);
% popplot;

Cam = get_image('current');

h = figure;
imagesc(reshape(Cam.Data, Cam.Cols, Cam.Rows)', [0 2^14-1]);
set(gca, 'PlotBoxAspectRatio',[1.3281 1 1]);

% set(h, 'XTick',[]);
% set(h, 'XTickLabel','');
% set(h, 'YTick',[]);
% set(h, 'YTickLabel','');


% uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
%     '*.*','All Files' },'Save Image',...
%     strcat('/remote/apex/data/Gun/',date,'new_image.tif'));



function XProfileMin_Callback(hObject, eventdata, handles)
% hObject    handle to XProfileMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XProfileMin as text
%        str2double(get(hObject,'String')) returns contents of XProfileMin as a double


% --- Executes during object creation, after setting all properties.
function XProfileMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XProfileMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XProfileMax_Callback(hObject, eventdata, handles)
% hObject    handle to XProfileMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XProfileMax as text
%        str2double(get(hObject,'String')) returns contents of XProfileMax as a double


% --- Executes during object creation, after setting all properties.
function XProfileMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XProfileMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YProfileMin_Callback(hObject, eventdata, handles)
% hObject    handle to YProfileMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YProfileMin as text
%        str2double(get(hObject,'String')) returns contents of YProfileMin as a double


% --- Executes during object creation, after setting all properties.
function YProfileMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YProfileMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YProfileMax_Callback(hObject, eventdata, handles)
% hObject    handle to YProfileMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YProfileMax as text
%        str2double(get(hObject,'String')) returns contents of YProfileMax as a double


% --- Executes during object creation, after setting all properties.
function YProfileMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YProfileMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CameraGain.
function CameraGain_Callback(hObject, eventdata, handles)
% hObject    handle to CameraGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CameraGain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CameraGain

% Camera gain setup
CamName = GetCameraName(handles);
%CameraGain = getpv([CamName, ':cam1:Gain']);
Value = get(handles.CameraGain, 'Value')-1;
setpv([CamName, ':cam1:Gain'], Value);


% --- Executes during object creation, after setting all properties.
function CameraGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CameraGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Camera_select.
function Camera_select_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns Camera_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Camera_select

% Camera gain setup
CamName = GetCameraName(handles);
CameraGain = getpv([CamName, ':cam1:Gain']);
set(handles.AcquireTime, 'String', num2str(CameraGain));
CameraGainRBV = getpv([CamName, ':cam1:Gain_RBV']);
set(handles.CameraGainRBV, 'String', num2str(CameraGainRBV));

% --- Executes during object creation, after setting all properties.
function Camera_select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AcquireTime_Callback(hObject, eventdata, handles)
Value = str2num(get(handles.AcquireTime, 'String'));
if ~isempty(Value)
    CamName = GetCameraName;
    setpv([CamName, ':cam1:AcquireTime'], Value);
end

% --- Executes during object creation, after setting all properties.
function AcquireTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AcquirePeriod_Callback(hObject, eventdata, handles)
%        str2double(get(hObject,'String')) returns contents of AcquirePeriod as a double
Value = str2num(get(handles.AcquirePeriod, 'String'));
if ~isempty(Value)
    CamName = GetCameraName;
    setpv([CamName, ':cam1:AcquirePeriod'], Value);
end

% --- Executes during object creation, after setting all properties.
function AcquirePeriod_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
