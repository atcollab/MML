function varargout = graphit_bpm(varargin)
% GRAPHIT_BPM M-file for graphit_bpm.fig
%      GRAPHIT_BPM, by itself, creates a new GRAPHIT_BPM or raises the existing
%      singleton*.
%
%      H = GRAPHIT_BPM returns the handle to a new GRAPHIT_BPM or the handle to
%      the existing singleton*.
%
%      GRAPHIT_BPM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPHIT_BPM.M with the given input arguments.
%
%      GRAPHIT_BPM('Property','Value',...) creates a new GRAPHIT_BPM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graphit_bpm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graphit_bpm_OpeningFcn via varargin.
%
%      *See GUI SPosShift on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graphit_bpm

% Last Modified by GUIDE v2.5 19-Oct-2011 15:08:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @graphit_bpm_OpeningFcn, ...
    'gui_OutputFcn',  @graphit_bpm_OutputFcn, ...
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


% --- Executes just before graphit_bpm is made visible.
function graphit_bpm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graphit_bpm (see VARARGIN)


RemoveBPMDeviceList = [];

% Choose default command line output for graphit_bpm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graphit_bpm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% Check if the MML was initialized (needed for standalone)
checkforao;


% input parameters to start this application
% in web mode - expecting Web on/off
if(~isempty(varargin)&& length(varargin) == 2)
    if(strcmpi(varargin{1}, 'Web'))
        WebFlag = varargin{2};
        setappdata(handles.figure1, 'WriteToWebFlag',WebFlag);
        setappdata(handles.figure1, 'WriteToWebTimeBack',24); % load 24 hours of data for web 
       
    end
    
end

% Channel names
%Family = {'DCCT','BPMx','BPMy','ID','EPU'};
%Field  = {'Monitor','Monitor','Monitor','Monitor','Monitor'};
Family = 'BPMx';
Field  = 'Monitor';
DeviceList = getbpmlist(Family, 'Bergoz', 'UserDisplay');

% Remove BPMs
i = findrowindex(RemoveBPMDeviceList, DeviceList);
DeviceList(i,:) = [];


ChannelNames = family2channel(Family, Field, DeviceList);
ArchiverGetString = deblank(ChannelNames(1,:));
for i = 2:size(ChannelNames,1)
    ArchiverGetString = [ArchiverGetString, '|', deblank(ChannelNames(i,:))];
end

BPMxIndex = (1:size(DeviceList,1)).';
BPMxFlag = ones(1,size(DeviceList,1)).';
PlotDeviceList = [DeviceList , BPMxIndex , BPMxFlag];

setappdata(handles.figure1, 'Family', Family);
setappdata(handles.figure1, 'Field', Field);
setappdata(handles.figure1, 'DeviceList', DeviceList);
setappdata(handles.figure1, 'SPosition', getspos(Family, DeviceList));
setappdata(handles.figure1, 'AutoScaleX', 'On');
setappdata(handles.figure1, 'AutoScaleY', 'On');
setappdata(handles.figure1, 'XLimit', [0 1]);
setappdata(handles.figure1,'PlotDeviceList', PlotDeviceList);

% Offset scaling gain off the y-axis w.r.t. the s-position of the element
SPosGain = .0025;
setappdata(handles.figure1, 'SPosGain', SPosGain);


%try
drawlatticelocal(0, 1.1, handles.LatticeAxes);


if strcmpi(get(handles.SPosShift, 'Checked'),'on')
    h = get(handles.axes1, 'YLabel');
    set(h, 'Visible', 'Off');
    h = get(handles.axes2, 'YLabel');
    set(h, 'Visible', 'Off');
    
    %     h= get(handles.LatticeAxes,'YLabel');
    %     set(h, 'String', 'BPMx', 'FontWeight','Bold','FontSize', 4);
    %     set(h, 'Visible', 'On');
else
    h = get(handles.axes1, 'YLabel');
    set(h, 'Visible', 'On');
    h = get(handles.axes2, 'YLabel');
    set(h, 'Visible', 'On');
end


FigColor = get(handles.figure1,'color');
set(handles.LatticeAxes,'Color',FigColor);
set(handles.LatticeAxes,'XColor',FigColor);
set(handles.LatticeAxes,'YColor',FigColor);
set(handles.LatticeAxes,'Box','Off');
set(handles.LatticeAxes,'XMinorTick','Off');
set(handles.LatticeAxes,'XMinorGrid','Off');
set(handles.LatticeAxes,'YMinorTick','Off');
set(handles.LatticeAxes,'YMinorGrid','Off');
set(handles.LatticeAxes,'XTickLabel',[]);
set(handles.LatticeAxes,'YTickLabel',[]);
set(handles.LatticeAxes,'XTick',[]);
set(handles.LatticeAxes,'YTick',[]);
%set(handles.LatticeAxes,'YLim', [0 L]);
set(handles.LatticeAxes,'XLim', [-1.5 1.5]);
set(handles.LatticeAxes,'Visible','Off');

% Add callback on each lattice element
% set(handles.LatticeAxes ,'ButtonDownFcn','plotfamily(''Lattice_ButtonDown'',gcbo,[],guidata(gcbo))');
%h = get(handles.LatticeAxes,'Children');
%for i = 1:length(h)
%    %ATIndex = get(h(i), 'UserData');
%    set(h(i), 'ButtonDownFcn', 'epicsarchivegui(''Lattice_ButtonDown'',gcbo,[],guidata(gcbo))');
%end
%catch
%end

%%%%%%%%%%%%%%%%%%%%%%%
% Setup the line here %
%%%%%%%%%%%%%%%%%%%%%%%

% Save the zoom button down and line identification callbacks
ZoomCallBack = @(hObject,eventdata)graphit_bpm('AxesButtonDown_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'ZoomCallBack', ZoomCallBack);

IdentifyLine_CallBack = @(hObject,eventdata)graphit_bpm('IDLine_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'IDLineCallBack', IdentifyLine_CallBack);

YZoomCallBack = @(hObject,eventdata)graphit_bpm('YAxesButtonDown_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'YZoomCallBack', YZoomCallBack);



ColorOrder = get(handles.axes1,'ColorOrder');

% data cursor call back: override default UpdateFcn
dcm_obj = datacursormode(handles.figure1);
set(dcm_obj,'UpdateFcn',@updatedatacursor);


% Setup the BPMx axes
L = getfamilydata('Circumference');
for i = 1:size(DeviceList,1)
    N_Color = rem(i-1,size(ColorOrder,1))+1;
    LineColor = ColorOrder(N_Color,:);
    hline1(i) = plot(handles.axes1, [NaN NaN], SPosGain*[0 L], '-', 'Color', LineColor);
    %hline(i) = popplot1(handles.axes1, randn(1,2), SPosGain*[0 L], '-', 'Color', LineColor);
    set(handles.axes1, 'NextPlot', 'Add');
    
    % Save the line info so it can be easily identified on ButtonDown
    set(hline1(i),'UserData', i);
    
    % Set the default line callback
    %set(hline(i), 'ButtonDownFcn', AxesButtonDown_CallBack);
    set(hline1(i), 'ButtonDownFcn', IdentifyLine_CallBack);
end
set(handles.axes1, 'NextPlot', 'Replace');
set(handles.axes1, 'YLimMode', 'Auto');
set(handles.axes1, 'YTickLabel',[]);
set(handles.axes1, 'YTickLabelMode', 'Manual');

% If reploting the 'ButtonDownFcn' callback gets wiped out
%set(handles.axes1, 'ButtonDownFcn', AxesButtonDown_CallBack);
set(handles.axes1, 'ButtonDownFcn', '');

h = get(handles.axes1, 'YLabel');
set(h, 'String', 'Horizontal Orbit [mm]', 'FontWeight','Bold');
set(h, 'Visible', 'Off');


% Link the axes
drawnow;
dy = get(handles.axes1, 'YLim');
set(handles.LatticeAxes, 'YLim', dy(1:2)/SPosGain);

set(handles.figure1, 'Visible', 'On');

% Set the UICONTEXTMENU to the ylabel object and Lattice
% Right Click on label/lattice to see menu with channel/line info
hcontext=uicontextmenu;
set(get(handles.LatticeAxes, 'Children'),'uicontextmenu',hcontext);
set(h,'uicontextmenu',hcontext);


% Lattice is displayed SR 12 TOP - SR 1 BOTTOM
for it =size(ChannelNames,1):-1:1
    
    SR = DeviceList(it);    
    if(it < size(ChannelNames,1) && SR == DeviceList(it + 1))       
        subitem(it) = uimenu(item(SR), 'Label',sprintf('%s.%s(%d,%d)  %s', Family, Field,DeviceList(it,:),ChannelNames(it,:)));
        set(subitem(it),'Callback',IdentifyLine_CallBack, 'UserData',hline1(it),'ForegroundColor', get(hline1(it),'Color'));
    else
        item(SR) = uimenu(hcontext, 'Label',sprintf('SR %d',SR));
        subitem(it) = uimenu(item(SR), 'Label',sprintf('%s.%s(%d,%d)  %s', Family, Field,DeviceList(it,:),ChannelNames(it,:)));
        set(subitem(it),'Callback',IdentifyLine_CallBack, 'UserData',hline1(it),'ForegroundColor', get(hline1(it),'Color'));
    end
    
end
setappdata(handles.figure1, 'LabelXItems', subitem);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repeat for LatticeAxes2 and axes2 - BPMy
% add BPMy
YFamily = 'BPMy';
YDeviceList = getbpmlist(YFamily, 'Bergoz', 'UserDisplay');
YChannelNames = family2channel(YFamily, Field, YDeviceList);

YArchiverGetString = deblank(YChannelNames(1,:));
for i = 2:size(YChannelNames,1)
    YArchiverGetString = [YArchiverGetString, '|', deblank(YChannelNames(i,:))];
end

% set flag for EditBPM List
BPMyIndex = (1:size(YDeviceList,1)).';
BPMyFlag = ones(1,size(YDeviceList,1)).';
YPlotDeviceList = [YDeviceList , BPMyIndex , BPMyFlag];

setappdata(handles.figure1, 'YFamily', YFamily);
setappdata(handles.figure1, 'YDeviceList', YDeviceList);
setappdata(handles.figure1, 'YSPosition', getspos(YFamily, YDeviceList));
setappdata(handles.figure1, 'YPlotDeviceList', YPlotDeviceList);

% now repeat for axes2 and LaticesAxes2 all that was set above
drawlatticelocal(0, 1.1, handles.LatticeAxes2);

FigColor = get(handles.figure1,'color');
set(handles.LatticeAxes2,'Color',FigColor);
set(handles.LatticeAxes2,'XColor',FigColor);
set(handles.LatticeAxes2,'YColor',FigColor);
set(handles.LatticeAxes2,'Box','Off');
set(handles.LatticeAxes2,'XMinorTick','Off');
set(handles.LatticeAxes2,'XMinorGrid','Off');
set(handles.LatticeAxes2,'YMinorTick','Off');
set(handles.LatticeAxes2,'YMinorGrid','Off');
set(handles.LatticeAxes2,'XTickLabel',[]);
set(handles.LatticeAxes2,'YTickLabel',[]);
set(handles.LatticeAxes2,'XTick',[]);
set(handles.LatticeAxes2,'YTick',[]);
%set(handles.LatticeAxes2,'YLim', [0 L]);
set(handles.LatticeAxes2,'XLim', [-1.5 1.5]);
set(handles.LatticeAxes2,'Visible','Off');

LineInfo ={};

% Setup the BPMy axes (axes2)
L = getfamilydata('Circumference');
for i = 1:size(YDeviceList,1)
    N_Color = rem(i-1,size(ColorOrder,1))+1;
    LineColor = ColorOrder(N_Color,:);
    hline2(i) = plot(handles.axes2, [NaN NaN], SPosGain*[0 L], '-', 'Color', LineColor);
    set(handles.axes2, 'NextPlot', 'Add');
    
    % Save the line info so it can be easily identified on ButtonDown
    set(hline2(i),'UserData', i);
    
    % Set the default line callback
    set(hline2(i), 'ButtonDownFcn', IdentifyLine_CallBack);
end
set(handles.axes2, 'NextPlot', 'Replace');
set(handles.axes2, 'YLimMode', 'Auto');
set(handles.axes2, 'YTickLabel',[]);
set(handles.axes2, 'YTickLabelMode', 'Manual');

h = get(handles.axes2, 'YLabel');
set(h, 'String', 'Vertical Orbit [mm]', 'FontWeight','Bold');
set(h, 'Visible', 'Off');

% If reploting the 'ButtonDownFcn' callback gets wiped out
set(handles.axes2, 'ButtonDownFcn', '');


% Link the axes
drawnow;
dy = get(handles.axes2, 'YLim');
set(handles.LatticeAxes2, 'YLim', dy(1:2)/SPosGain);


% Set the UICONTEXTMENU to the ylabel object and Lattice
% Right Click on label/lattice to see menu with channel/line info
hcontext=uicontextmenu;
set(get(handles.LatticeAxes2, 'Children'),'uicontextmenu',hcontext);
set(h,'uicontextmenu',hcontext);


for it =size(YChannelNames,1):-1:1  
    
      SR = DeviceList(it);
       
      if(it < size(YChannelNames,1) && SR == DeviceList(it + 1))          
          subitem(it) = uimenu(item(SR), 'Label',sprintf('%s.%s(%d,%d)  %s',YFamily, Field,YDeviceList(it,:),YChannelNames(it,:)));
          set(subitem(it),'Callback',IdentifyLine_CallBack, 'UserData',hline2(it),'ForegroundColor', get(hline2(it),'Color'));
      else
          item(SR) = uimenu(hcontext, 'Label',sprintf('SR %d',SR));
          subitem(it) = uimenu(item(SR), 'Label',sprintf('%s.%s(%d,%d)  %s',YFamily, Field,YDeviceList(it,:),YChannelNames(it,:)));
          set(subitem(it),'Callback',IdentifyLine_CallBack, 'UserData',hline2(it),'ForegroundColor', get(hline2(it),'Color'));
      end
end
setappdata(handles.figure1, 'LabelYItems', subitem);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ID: graph n. 3 axes3
% Channel names
IDFamily ='ID';
VGap_Channels = family2channel(IDFamily,'Monitor');
EPUFamily = 'EPU';
HGap_Channels = family2channel(EPUFamily,'Monitor');
IDChannelNames = strvcat(VGap_Channels, HGap_Channels );

IDDeviceList = family2dev(IDFamily, 'Monitor');
EPUDeviceList = family2dev(EPUFamily, 'Monitor');
IDDeviceList = vertcat(IDDeviceList,EPUDeviceList);

IDArchiverGetString = deblank(IDChannelNames(1,:));
for i = 2:size(IDChannelNames,1)
    IDArchiverGetString = [IDArchiverGetString, '|', deblank(IDChannelNames(i,:))];
end

% TODO what about the following info for ID and EPU????
% setappdata(handles.figure1, 'IDFamily', IDFamily);
setappdata(handles.figure1, 'IDDeviceList', IDDeviceList);


LineInfo ={};

% Setup the ID axes (axes3)
for i = 1:size(IDChannelNames,1)
    % same colororder as graphit (ID)
    ColorOrder = [
        0            0            .5      %  1 BLUE
        0            1            0       %  2 GREEN (pale)
        1            0            0       %  3 RED
        0            1            1       %  4 CYAN
        1            0            1       %  5 MAGENTA (pale)
        1            1            0       %  6 YELLOW (pale)
        0            0            0       %  7 BLACK
        0            0.75         0.75    %  8 TURQUOISE
        0            0.5          0       %  9 GREEN (dark)
        0.75         0.75         0       % 10 YELLOW (dark)
        1            0.50         0.25    % 11 ORANGE
        0.75         0            0.75    % 12 MAGENTA (dark)
        0.49         0.49          0.49     % 13 GREY
        0.8          0.7          0.6     % 14 BROWN (pale)
        0.6          0.5          0.4 ];  % 15 BROWN (pale)
    
    
    N_Color = rem(i-1,size(ColorOrder,1))+1;
    LineColor = ColorOrder(N_Color,:);
    hline3(i) = plot(handles.axes3, [NaN NaN],[NaN NaN], '-', 'Color', LineColor);
    
    set(handles.axes3, 'NextPlot', 'Add');
    if(i<=size(VGap_Channels,1))
        LineInfo{i}={i,'ID'};
    else
        LineInfo{i}={i,'EPU'};
    end
    % Save the line info so it can be easily identified on ButtonDown
    set(hline3(i),'UserData', LineInfo{i});
    % Set the default line callback
    set(hline3(i), 'ButtonDownFcn', IdentifyLine_CallBack);
end
set(handles.axes3, 'NextPlot', 'Replace');
% set(handles.axes3, 'YLimMode', 'Auto');
set(handles.axes3, 'YLim',[-45 60]); % set YLim as in graphit

set(handles.axes3, 'YTickLabelMode', 'Auto');
set(handles.axes3, 'YTickMode',      'Auto');

h = get(handles.axes3, 'YLabel');
set(h, 'String', 'ID & EPU [mm]', 'FontWeight','Bold');


% If reploting the 'ButtonDownFcn' callback gets wiped out
set(handles.axes3, 'ButtonDownFcn', '');


% Set the UICONTEXTMENU to the ylabel object
% Right Click on label to see menu with channel/line info
hcontext=uicontextmenu;
set(h,'uicontextmenu',hcontext);
for it =1:size(IDChannelNames,1)
    Family=LineInfo{it};
    item(it) = uimenu(hcontext, 'Label',sprintf('%s.%s(%d,%d)  %s', Family{2}, Field,IDDeviceList(it,:),IDChannelNames(it,:)));   
    set(item(it),'Callback',IdentifyLine_CallBack, 'UserData',hline3(it),'ForegroundColor', get(hline3(it),'Color'));

end


% Cell arrays of data for the 3 graphs: BPMx/BPMy/ID
ChannelNamesSet = {ChannelNames, YChannelNames, IDChannelNames};
ArchiverGetStringSet = {ArchiverGetString, YArchiverGetString, IDArchiverGetString};
setappdata(handles.figure1, 'ArchiverGetStringSet', ArchiverGetStringSet);
setappdata(handles.figure1, 'ChannelNamesSet', ChannelNamesSet);
setappdata(handles.figure1, 'LineHandlesSet', {hline1 , hline2, hline3});


% added to synch the 3 x axes
linkaxes([handles.axes1 handles.axes2 handles.axes3],'x');


% java side of Matlab
hToolbar = findall(handles.figure1,'tag','uitoolbar1');
% Add a JText to the toolbar
jToolbar = get(get(hToolbar,'JavaContainer'),'ComponentPeer');

if ~isempty(jToolbar)
    jToolbar(1).addSeparator;
    jText = javax.swing.JTextField('Mouse click on line to display channel info');
    
    jText.setForeground(java.awt.Color(0.25,0.25,0.7));
    jText.setMaximumSize(java.awt.Dimension(280,38));
    jText.setMinimumSize(java.awt.Dimension(250,38));
    jText.setEditable(false);
    jText.setToolTipText('Mouse click on line to display channel info');
    
    jToolbar(1).add(jText,25); %25th position, after last icon
    jToolbar(1).repaint;
    jToolbar(1).revalidate;
    
    % is this OK? check for Memory...
    set(jText,'tag','TextTool');
    setappdata(handles.figure1, 'jText', jText);
else
    setappdata(handles.figure1, 'jText', []);
end

if ~isempty(jToolbar)
    jToolbar(1).addSeparator;
    jLabel = javax.swing.JLabel('');
    jLabel.setForeground(java.awt.Color(0.75,0,0));
    jLabel.setMinimumSize(jLabel.getPreferredSize());
    jLabel.setToolTipText('Info bar');
    jToolbar(1).add(jLabel,27); %26th position, after JText separator
    jToolbar(1).addSeparator;
    jToolbar(1).repaint;
    jToolbar(1).revalidate;
    
    set(jLabel,'tag','LabelTool');
    setappdata(handles.figure1, 'jLabel', jLabel);
else
    setappdata(handles.figure1, 'jLabel', []);
end


% set icons on zoomin/zoomou 6 buttons
try
    yIcon = fullfile(matlabroot,'/toolbox/matlab/icons/zoomminus.mat');
    % [cdata,map] = imread(yIcon);
    cdata = importdata(yIcon);
    
    set(handles.Graph1ZoomOutVertical,'CDATA',cdata);
    set(handles.Graph2ZoomOutVertical,'CDATA',cdata);
    set(handles.Graph3ZoomOutVertical,'CDATA',cdata);
    
catch ME
    set(handles.Graph1ZoomOutVertical,'String','-');
    set(handles.Graph2ZoomOutVertical,'String','-');
    set(handles.Graph3ZoomOutVertical,'String','-');
end

%set the zoomin zoom out icons as the button background next to axes
set(handles.Graph1ZoomInVertical,'CDATA',get(handles.YZoomToggle, 'CData'));
set(handles.Graph2ZoomInVertical,'CDATA',get(handles.YZoomToggle, 'CData'));
set(handles.Graph3ZoomInVertical,'CDATA',get(handles.YZoomToggle, 'CData'));



DisplaySettings(handles);

% save originals YLims for reset graphs 
YLimReset.axes1 = get(handles.axes1, 'YLim');
YLimReset.axes2 = get(handles.axes2, 'YLim');
YLimReset.axes3 = get(handles.axes3, 'YLim');
YLimReset.Lattice =get(handles.LatticeAxes, 'YLim');
YLimReset.Lattice2 =get(handles.LatticeAxes2, 'YLim');
setappdata(handles.figure1,'YLimReset',YLimReset);


% set figure for web mode
% resize off / store YLim for axis
if(strcmpi(getappdata(handles.figure1, 'WriteToWebFlag'),'On'))
    
    % 1. create an invisible figure for web page
    Units    = get(handles.figure1, 'Units');
    Position = get(handles.figure1, 'Position');
    h2=figure('Visible', 'off', 'Units', Units, 'Position',Position, 'Toolbar', 'None', 'MenuBar', 'None');
    setappdata(handles.figure1, 'PrintFigure',h2);
      
      
    % 2. create an invisible figure for web page
%     Units    = get(handles.figure1, 'Units');
%     Position = get(handles.figure1, 'Position');
%     h3=figure('Visible', 'off', 'Units', Units, 'Position',Position, 'Toolbar', 'None', 'MenuBar', 'None');
%     setappdata(handles.figure1, 'PrintFigure10Min',h3);
    
    % must reset figure1 as current figure
    set(0,'CurrentFigure',handles.figure1);   
end





% Display Menu settings in Menu bar.
function DisplaySettings(handles)

if strcmpi(get(handles.Golden, 'Checked'),'On')
    offsetString = '"Golden Orbit Removed"';
elseif strcmpi(get(handles.Offset, 'Checked'),'On')
    offsetString = '"Offset Orbit Removed"';
elseif strcmpi(get(handles.SPosShift, 'Checked'),'On')
    offsetString = '"S-Position Shift - Golden Orbit"';
elseif strcmpi(get(handles.LastPoint, 'Checked'),'On')
    offsetString = '"Last Point Subtracted"';
elseif strcmpi(get(handles.FirstPoint, 'Checked'),'On')
    offsetString = '"First Point Subtracted"';
else
    offsetString = 'Raw Data';
end


%TimerSett = 'Mode Timer: Update Period = ';
if strcmpi(get(handles.interval_10s, 'Checked'),'On')
    TimerInterval ='10s';
elseif strcmpi(get(handles.interval_20s, 'Checked'),'On')
    TimerInterval = '20s';
elseif strcmpi(get(handles.interval_30s, 'Checked'),'On')
    TimerInterval = '30s';
elseif strcmpi(get(handles.interval_60s, 'Checked'),'On')
    TimerInterval = '60s';
else
    %default timer interval = 30s
    TimerInterval = '30s';
end
TimerSett = sprintf(' - - Update period %s', TimerInterval);

if strcmpi(get(handles.window24h, 'Checked'),'On')
    TimerWindow = '24h';
elseif strcmpi(get(handles.window12h, 'Checked'),'On')
    TimerWindow = '12h';
elseif strcmpi(get(handles.window8h, 'Checked'),'On')
    TimerWindow = '8h';
elseif strcmpi(get(handles.window6h, 'Checked'),'On')
    TimerWindow = '6h';
elseif strcmpi(get(handles.window1h, 'Checked'),'On')
    TimerWindow = '1h';
else
    %default timer window = 24 h
    TimerWindow = '24h';
end

TimerWindow = sprintf('Max. Time Window = %s', TimerWindow);

oldlist = getappdata(handles.figure1, 'PlotDeviceList');
stringX = '';
stringY = '';
if(find(oldlist(:,4) <1))
    stringX = ' - - BPMx list changed';
end
oldlist = getappdata(handles.figure1, 'YPlotDeviceList');
if(find(oldlist(:,4) <1))
    stringY = ' - - BPMy list changed';
end

stringWeb='';
if strcmpi(getappdata(handles.figure1,'WriteToWebFlag'),'on')
    stringWeb = ' - - Publish to Web Page';
end

set(handles.settingsDisplay, 'Label', ['            "', offsetString, '"      ', TimerSett, stringX, stringY, stringWeb]);
% can use html for controls ?!
% this is to override disabled menu foreground color
listStr =['<html><font Color="blue"/>' offsetString TimerSett stringX stringY stringWeb '</html>'] ;
set(handles.settingsDisplay,'label', listStr);

function IDLine_Callback(hObject, eventdata, handles)

ChannelNamesSet = getappdata(handles.figure1, 'ChannelNamesSet');

if(strcmpi(get(hObject,'Type'), 'uimenu'))
    
    hObject = get(hObject,'UserData');
    
end


if(get(hObject,'Parent') == handles.axes1)
    
    iLine= get(hObject, 'UserData');
    Family       = getappdata(handles.figure1, 'Family');
    Field        = getappdata(handles.figure1, 'Field');
    DeviceList   = getappdata(handles.figure1, 'DeviceList');
    ChannelNames = ChannelNamesSet{1};
    
elseif(get(hObject,'Parent') == handles.axes2)
    
    iLine= get(hObject, 'UserData');
    Family       = getappdata(handles.figure1, 'YFamily');
    Field        = getappdata(handles.figure1, 'Field');
    DeviceList   = getappdata(handles.figure1, 'YDeviceList');
    ChannelNames = ChannelNamesSet{2};
    
elseif(get(hObject,'Parent') == handles.axes3)
    
    % more than one Family for lines in graphs 3.
    iLineInfo = get(hObject, 'UserData');
    Family=iLineInfo{2};
    iLine = iLineInfo{1};
    Field        = getappdata(handles.figure1, 'Field');
    DeviceList   = getappdata(handles.figure1, 'IDDeviceList');
    ChannelNames = ChannelNamesSet{3};
end


% write to Java text field in toolbar
jText = getappdata(handles.figure1, 'jText');

PresentMarker = get(hObject, 'Marker');
if strcmpi(PresentMarker, '.')
    % Turn off line identification
    set(hObject, 'Marker', 'none');
    % set(handles.IDLine, 'Visible', 'Off');
    % This might cause memory leak....(not set allowed on JAva Obj / use java methods instead?!
    % set(jText,'text','Mouse click on line to display channel info');
    jText.setText('Mouse click on line to display channel info');
else
    % set(handles.IDLine, 'String', sprintf('%s.%s(%d,%d)  %s', Family, Field, DeviceList(iLine,:), deblank(ChannelNames(iLine,:))));
    % set(handles.IDLine, 'Visible', 'On');
    
    % write to Java text field in toolbar
    jText.setText(sprintf('%s.%s(%d,%d)  %s', Family, Field,DeviceList(iLine,:), deblank(ChannelNames(iLine,:))));
    
    %first clear any existing Marked line on 3 graphs
    hlineSet = getappdata(handles.figure1, 'LineHandlesSet');
    for p=1:3
        hline = hlineSet{p};
        for i = 1:length(hline)
            set(hline(i), 'Marker', 'none');
        end
    end
    % now set marker
    set(hObject, 'Marker', '.');
    
    % Could display x, y position
end
drawnow;



% Timer Callback function, called when the timer
% is started:
% call LoadData.
function Timer_Callback(hObject, eventdata, handles)

timeback = getappdata(handles.figure1, 'DataRetrievalInterval');
timewindow = getappdata(handles.figure1, 'TimerWindow');

%set(handles.TimerRunning, 'String', sprintf('Timer triggered at %s  [Max. Time Window= %d h - Update Period= %d s]', datestr(now),timewindow, timeback));
fprintf('Timer triggered at %s  [Max. Time Window= %d h - Update Period= %d s]\n', datestr(now),timewindow, timeback);

LoadData(handles);

AutoScaleAxis_Callback([], [], handles);

% create a jpeg image of the gui and post it to a web page
if strcmpi(getappdata(handles.figure1, 'WriteToWebFlag'),'on')
    WriteToWebHowOften = getappdata(handles.figure1, 'WriteToWebHowOften');
    n = WriteToWebHowOften/timeback;
    if(rem(get(handles.thetimer, 'TasksExecuted'),n) == 0)
        WriteToWebPage(handles);
    end
end



% --- Outputs from this function are returned to the command line.
function varargout = graphit_bpm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

if(strcmpi(getappdata(handles.figure1, 'WriteToWebFlag'),'On'))
    PlotAndPublish(handles);
end

function LoadData(handles, TimeBack, EndTime)
% Load new data from archiver.
%
% TimeBack [seconds]-time interval to be retrieved
% EndTime -Matlab time(datenumber) - end time for time interval to retrieve
% new data to PLot;
% call java client to retrieve data from archiver;
% Timer:
% - Concatenate new data loaded with existing data if any;
% - (drop data if old dataset older than 24 h).
% - time interval for new dataset is set by user through gui.
% - Default interval retrieval is 30 s.

persistent client


% Java label
jLabel = getappdata(handles.figure1, 'jLabel');
jLabel.setForeground(java.awt.Color.red);
jLabel.setText('Retrieving data');
drawnow;


% Add to the dynamic Java path (just once)
JaveDynmicJars = javaclasspath('-dynamic');
JarFile = fullfile(getmmlroot,'hlc','archiveviewer','archiveviewer.jar');
if ~any(strcmpi(JarFile, JaveDynmicJars))
    javaaddpath(JarFile);
end


% Get the application data
ArchiverGetStringSet = getappdata(handles.figure1, 'ArchiverGetStringSet');
ChannelNamesSet      = getappdata(handles.figure1, 'ChannelNamesSet');
% Get data already in the PLot, if any
% this should happen only for the timer
toldSet = getappdata(handles.figure1, 'ArchivedTimeSet');


% n. of graphs in the gui to PLot
ngraph = 3; % maybe this set at the first function call

rightNow = now;% time reference \ EndTime for timer

% Timer call
if nargin < 2
    EndTime =rightNow;
    % Likely from the timer callback, get time back from appdata
    TimeBack = getappdata(handles.figure1, 'DataRetrievalInterval');
    TimeWindow = getappdata(handles.figure1, 'TimerWindow');
    
    
    % Best to start from the last point in the table
    if ~isempty(toldSet)
        told =toldSet{1};
        
        % LastTime = max(cellfun(@max, told));
        temp = told;
        temp(cellfun(@isempty,temp)) = {NaN};
        LastTime = max(cellfun(@max, temp));
        
        % application was running and data was loaded
        % now start the timer:
        % if told more than 24 hours ago
        % drop old data and start new data collection
        if((EndTime -LastTime)< 1)
            TimeBack = 24*60*60*(EndTime - LastTime);% convert to seconds
        else
            %TODO: enough or need to clear graph?!
            setappdata(handles.figure1, 'ArchivedDataSet', {});
            setappdata(handles.figure1, 'ArchivedTimeSet', {});
            
            setappdata(handles.figure1, 'ArchivedStartTime', EndTime-TimeBack/60/60/24);
        end;
    else
        % save start time to compute XLim for the graphs
        % as timestamps might fall outside of retrieval time
        setappdata(handles.figure1, 'ArchivedStartTime', EndTime-TimeBack/60/60/24);
        
    end
    
    % Just to add some overlap
    TimeBack = TimeBack-5;
    
    %set(handles.InfoWindow, 'String', sprintf('Retrieving data (%.1d seconds) ...', TimeBack));
    fprintf('Retrieving data (%.1d seconds)\n', TimeBack);
    jLabel.setForeground(java.awt.Color.red);
    jLabel.setText(sprintf('Retrieving data (%d seconds)', ceil(TimeBack)));
else % not timer call, clear old data
    
    %TODO: enough or need to clear graph?!
    setappdata(handles.figure1, 'ArchivedDataSet', {});
    setappdata(handles.figure1, 'ArchivedTimeSet', {});
    
    % save start time to compute XLim for the graphs
    % as timestamps might fall outside of retrieval time
    setappdata(handles.figure1, 'ArchivedStartTime', EndTime-TimeBack/60/60/24);
    
    fprintf('Retrieving data (%.2f minutes)\n', TimeBack/60);
    jLabel.setForeground(java.awt.Color.red);
    jLabel.setText(sprintf('Retrieving data (%.2f minutes)', TimeBack/60));
end
drawnow;

%UTC matlab time reference difference
DateNumber1970 = 719529;  %datenum('1-Jan-1970');

EndTimeMillisec = (EndTime-DateNumber1970)*24*60*60*1000;% EndTime in millisec (local) Pacific Time
EndTimeOffset = java.util.Calendar.getInstance.getTimeZone().getOffset(EndTimeMillisec);% time difference  (ms) between UTC and Pacific Time(local)

% convert MATLAB end time to UTC/archiver time
end_tf = (EndTime-DateNumber1970-EndTimeOffset/24/1000/60/60)*24*60*60*1000;
%end_tf = (EndTime-DateNumber1970+TimeOffset/24)*24*60*60*1000;

% save start time to compute XLim for the graphs
% as timestamps might fall outside of retrieval time
setappdata(handles.figure1, 'ArchivedEndTime', EndTime);


for p=1:ngraph
    
    
    
    fprintf('\n\n +++++++++++++++Graph n=%d \n', p);
    jLabel.setText(sprintf('Retrieving data..graph n=%d',p));
    
    set(handles.InfoWindow,'Foreground', 'Blue');
    % this should take care of connection errors
    try
        % Setup the connection
        if isempty(client)
            tic
            client = epics.archiveviewer.clients.channelarchiver.ArchiverClient();
            % client.connect('http://apps1.als.lbl.gov:8080/RPC2', []);
            client.connect('http://apps1.als.lbl.gov:8080/cgi-bin/ArchiveDataServer.cgi ',[]);
            fprintf('client setup time = %.3f seconds\n', toc);
        end
    catch ME
        jLabel.setForeground(java.awt.Color.red);
        jLabel.setText('Error connecting to archiver!');
        fprintf('\nError connecting to the Archiver %s\n\n',ME.message);
        drawnow;
        
        client=[];
        sleep(30);
        return;
    end
    
    
    % Search
    tic
    try
        x = client.getAvailableArchiveDirectories();
    catch ME
        jLabel.setForeground(java.awt.Color.red);
        jLabel.setText('Error retrieving data!');
        %set(handles.InfoWindow,'Foreground', 'Red', 'String', sprintf('Error connecting to the archiver %s',ME.message));
        fprintf('\nError retrieving data %s\n',ME.message);
        drawnow;
        
        client=[];
        sleep(30);
        return;
    end
    
    
    
    try
        ChannelSearch = client.search(x(1), ArchiverGetStringSet{p}, []);
    catch ME
        jLabel.setForeground(java.awt.Color.red);
        jLabel.setText('client.search error!');
        fprintf('\nclient.search error %s\n',ME.message);
        drawnow;
        
        client=[];
        sleep(30);
        return;
    end
    
    fprintf('   client.search time = %.3f seconds\n', toc);
    
    
    try
        % If at least on channel found, check archiving start time
        % assuming the same archiving start time for all channels...
        if(~isempty(ChannelSearch))
            
            z = client.getAVEInfo(ChannelSearch(1));
            ArchiverStartTime = z.getArchivingStartTime(); %a reference time for data in the archiver
            offS = java.util.Calendar.getInstance.getTimeZone().getOffset(ArchiverStartTime);
            if( (ArchiverStartTime+ offS)/1000/60/60/24+DateNumber1970  > getappdata(handles.figure1, 'ArchivedStartTime'))
                set(handles.InfoWindow,'Foreground', 'Red', 'String', sprintf('Archived data is only available from %s', datestr((ArchiverStartTime+offS)/1000/60/60/24+DateNumber1970)));
                return;
            end
            
            % if not all channels were retrieved, just warn user.
            % Listing all channels here, not just the ones missing...
            % TODO: change this to list just the missing channels
            if(length(ChannelSearch) <  size(ChannelNamesSet{p},1))
                fprintf('Channel Not Found in Archiver [%s]\n', ArchiverGetStringSet{p});
                jLabel.setForeground(java.awt.Color.red);
                jLabel.setText('Channel Not Found in Archiver');
            end
            
        else% no channels found for this graph, skip graph and continue
            fprintf('No Channel Found in Archiver [%s]', ArchiverGetStringSet{p});
            jLabel.setForeground(java.awt.Color.red);
            jLabel.setText('No Channel Found in Archiver');
            
            % skip this graph only
            % return;
            continue;
        end
        
    catch ME
        jLabel.setForeground(java.awt.Color.red);
        jLabel.setText('Error connecting to archiver!');
        fprintf('\nError connecting to the Archiver %s\n\n',ME.message);
        drawnow;
        
        client=[];
        sleep(30);
        return;
    end
    
    % Convert to msec
    time_interval= 1000*TimeBack;
    
    % retrieve data in batches for large interval
    
    time_batch= 2*60*60*1000; % 2 hours in ms, retrieve data in batches
    % for ID/IDEPU set 45 minutes since these are sampled at faster rate
    if(p>2)
         time_batch= 45*60*1000;
    end
    
    times = fix(time_interval/time_batch);% should return integer part of division
    remainder= rem(time_interval,time_batch);% returns remainder after division
    
    
    % now iterate to retrieve data in batches
    for k=times:-1:0
        
        start_t = end_tf-(time_batch*k+remainder);
        end_t= end_tf -(time_batch*(k-1)+remainder);
        
        % case times=0 and remainder>0
        if(k==0)
            if(remainder>0)
                end_t= end_tf;
            else
                break;
            end
        end
        
        % display info window text message
        %tempS = get(handles.InfoWindow,'String');
        %set(handles.InfoWindow, 'String', sprintf('%s...%d/%d graph n=%d/%d',tempS, (times-k+1),(times+1),p,(ngraph)));
        fprintf('Retieving data ... %d/%d graph n=%d/%d\n', (times-k+1),(times+1),p,(ngraph));
        %drawnow;
        
        % Get data already in the PLot
        aoldSet = getappdata(handles.figure1, 'ArchivedDataSet');
        toldSet = getappdata(handles.figure1, 'ArchivedTimeSet');
        
        if(isempty(aoldSet))
            for m=1:ngraph
                aoldSet{m} = {};
                toldSet{m} = {};
            end
        end
        
        
        % catch any Java exception
        try
            % Retrive data
            % Methods: raw linear spreadsheet PLot-binning average
            r = client.getRetrievalMethod('raw');
            % r = client.getRetrievalMethod('linear');
            % r = client.getRetrievalMethod('spreadsheet');
            % r = client.getRetrievalMethod('PLot-binning');
            % r = client.getRetrievalMethod('average');
            
            req_obj = epics.archiveviewer.RequestObject(start_t, end_t, r, 3000);
            
            %fprintf('retrieve start time= %s \n', datestr(start_t/1000/60/60/24 + DateNumber1970 - 7/24));
            fprintf('retrieve end time= %s \n', datestr(end_t/1000/60/60/24 + DateNumber1970  + EndTimeOffset/1000/60/60/24));
            %tic
            data = client.retrieveData(ChannelSearch, req_obj, []);
            %fprintf('   client.retrieveData time = %.3f seconds\n', toc);
            if(size(data,1)<1)
                jLabel.setForeground(java.awt.Color.red);
                jLabel.setText('No data found in archiver!');
                fprintf('No data found in archiver!\n\n');
                drawnow;
                
                % skip this graph only...
                continue;
            end
        catch ME
            jLabel.setForeground(java.awt.Color.red);
            jLabel.setText('Error connecting to archiver!');
            fprintf('\nError connecting to the Archiver %s\n\n',ME.message);
            drawnow;
            
            client=[];
            sleep(30);
            return;
        end
        
        
        %tic
        % Need to initialize this (either [] or NaN)
        t{size(ChannelNamesSet{p},1)} =[];
        a{size(ChannelNamesSet{p},1)} =[];
        
        % convert java vector to a matlab cell
        datacell = cell(data);
        
        %for i = 1:size(ChannelNamesSet{p},1)
        for i = 1:size(datacell,1)
            
            %NamesSort = char(ChannelSearch(i).getName());
            % convert java string to matlab char
            NamesSort = char(datacell{i}.getAVEntry().getName());
            ii = findrowindex(NamesSort, ChannelNamesSet{p});
            %NPoints(i,1) = data(i).getNumberOfValues();
            % this might throw an exception!!!
            % should catch this
            NPoints(i,1) = datacell{i}.getNumberOfValues();
            
            for j = 1:NPoints(i)
                % t{ii}(j) = data(i).getTimestampInMsec(j-1);
                % a{ii}(j) = data(i).getValue(j-1).firstElement();
                t{ii}(j) = datacell{i}.getTimestampInMsec(j-1);
                a{ii}(j) = datacell{i}.getValue(j-1).firstElement();
                
            end
        end
        
        
        %fprintf('For loop time = %.3f seconds\n', toc);
        
        % if no data, i.e. empty data
        % check if no error: should never happen as cell array initialized
        % to empty now
        if(size(a,2) ~= size(ChannelNamesSet{p},1) || size(t,2) ~= size(ChannelNamesSet{p},1))
            fprintf('Possible Data Error\n');
        end
        
        %  fprintf('\n For Loop MinT = %s',datestr(MinT/1000/60/60/24 + DateNumber1970 -7/24));
        
        
        
        % Convert time back from UTC/Archiver time to MATLAB time (Pacific
        % Time)
        % Get Time difference between UTC time and Pacific Time, this changes for
        % DST
        % TimeOffsetMilliSec = java.util.Calendar.getInstance.getTimeZone().getOffset(start_t);
        % startMin = min(cellfun(@min, t));
        % empty not ok otherwise
        temp=t;
        temp(cellfun(@isempty,temp)) = {NaN};
        startMin = min(cellfun(@min, temp));
        
        TimeOffsetMilliSec = java.util.Calendar.getInstance.getTimeZone().getOffset(startMin);
        % if DST changes within this time interval
        if(TimeOffsetMilliSec ~= java.util.Calendar.getInstance.getTimeZone().getOffset(end_t))
            %tic
            for i = 1:size(t,2)
                if(~isempty(t{i}))
                    for m =1: length(t{i})
                        % should return the timedifference in millisecond including daylightsaving
                        % time from UTC time to pacific time
                        dst = java.util.Calendar.getInstance.getTimeZone().getOffset(t{i}(m));
                        t{i}(m) = t{i}(m)/1000/60/60/24 + DateNumber1970 + dst/1000/60/60/24;
                    end
                end
            end
            %fprintf('   Convert time loop = %.3f seconds\n', toc);
        else %
            for i = 1:size(t,2)
                if(~isempty(t{i}))
                    % Time in Matlab datenum format
                    t{i} = t{i}/1000/60/60/24 + DateNumber1970 + TimeOffsetMilliSec/1000/60/60/24;
                end
            end
        end
        
        
        % Merge new data with existing one
        % For timer: drop data out of Time Window
        if(isempty(aoldSet{p})) % No old data in graph
            aoldSet{p} = a;
            toldSet{p} = t;
            
            % Save the archived data
            setappdata(handles.figure1, 'ArchivedDataSet', aoldSet);
            setappdata(handles.figure1, 'ArchivedTimeSet', toldSet);
            
            
        else %old data in graph
            aold = aoldSet{p};
            told = toldSet{p};
            %timer call (nargin <2)
            if nargin < 2
                % first, drop data out of Time Window set in timer menu...
                % empty not ok otherwise
                temp=told;
                temp(cellfun(@isempty,temp)) = {NaN};
                toldMin = min(cellfun(@min, temp));
                if(rightNow-toldMin > TimeWindow/24)
                    %if(rightNow-told{1}(1)> TimeWindow/24)
                    
                    index = size(told,2);
                    for i=1:index
                        m = told{i}<rightNow - TimeWindow/24;
                        told{i}(m)=[];
                        aold{i}(m)=[];
                    end
                    
                    if(p<2)
                        % update ArchivedStartTime
                        % This is used to set XLim Inf: it is a problem
                        % because it might reset the interval [Xlimit]
                        % too far back for some of the graphs..so check
                        % this
                        if(getappdata(handles.figure1,'ArchivedStartTime') < rightNow - TimeWindow/24)
                            setappdata(handles.figure1, 'ArchivedStartTime',rightNow - TimeWindow/24);
                        end
                    end
                end;
            end;
            
            
            % Now add new values if timespamps overlap values should not be added.
            index = size(aold,2);
            % check for overlapping timestamps
            for i=1:index
                if(~isempty(told{i}))
                    m = find(t{i} > told{i}(end));
                    aold{i} = [aold{i} a{i}(m)];
                    told{i} = [told{i} t{i}(m)];
                else
                    aold{i} = a{i};
                    told{i} = t{i};
                end
                
            end
            
            aoldSet{p} = aold;
            toldSet{p} = told;
            % Save the archived data
            setappdata(handles.figure1, 'ArchivedDataSet', aoldSet);
            setappdata(handles.figure1, 'ArchivedTimeSet', toldSet);
            
        end
        
        clear t;
        clear a;
        clear told;
        clear aold;
        clear req_obj;
        clear data;
        clear datacell;
        % end retrieve batch of data
    end
    
    clear ChannelSearch;
    
    % Modify data for plotting
    % repeat last point in time if no points within last 30s.
    % before plotting data
    dataToPlot = aoldSet{p};
    tToPlot = toldSet{p};
    
    last30SecRef = EndTime - 30/60/60/24; % 30 sec back in time - in Matlab time
    
    for i = 1:size(dataToPlot,2)
        % if {i}(end) is empty this is throwing exception
        % {i}(end) might come from empty data for one of the channels...
        % BUT if {i}(end) is NaN the statement is not executed...
        if(~isempty(tToPlot{i}) && tToPlot{i}(end)< last30SecRef)
            % fprintf('Found a point outside [Tinf %s]  [Tref %s EndTime %s] \n',datestr(tToPlot{i}(end)),datestr(last30SecRef),datestr(EndTime));
            tfake = last30SecRef;
            datafake = dataToPlot{i}(end);
            tToPlot{i} = [tToPlot{i} tfake];
            dataToPlot{i} = [dataToPlot{i} datafake];
            % fprintf('Adding fake point [T %s]  [Data %d] \n',datestr(tfake),datafake);
        end
    end
    aoldSet{p} = dataToPlot;
    toldSet{p} = tToPlot;
    % need to save data as
    setappdata(handles.figure1, 'ArchivedDataSet', aoldSet);
    setappdata(handles.figure1, 'ArchivedTimeSet', toldSet);
    
    % Update each PLot at the end for each graph
    plotachiveddata(handles,p);
    drawnow;
    
    clear aoldSet;
    clear toldSet;
    clear dataToPlot;
    clear tToPlot;
    
    % end for loop for graphs
end


% Simply display time interval in info window as XLim being displayed in
% Graph
XLimit = getappdata(handles.figure1,'XLimit');
set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));
drawnow;


% Java label
jLabel = getappdata(handles.figure1, 'jLabel');
jLabel.setText(' ');




function plotachiveddata(handles,WhichPlot)

if WhichPlot==1
    
    axesh = handles.axes1;
    axesLattice = handles.LatticeAxes;
    Family       = getappdata(handles.figure1, 'Family');
    DeviceList   = getappdata(handles.figure1, 'DeviceList');
    s = getappdata(handles.figure1, 'SPosition'); % is this distinction necessary?
    PlotLine = getappdata(handles.figure1, 'PlotDeviceList');
    
    linkaxes([handles.axes1 handles.axes2 handles.axes3],'x');
    
elseif WhichPlot==2
    
    axesh = handles.axes2;
    axesLattice = handles.LatticeAxes2;
    Family       = getappdata(handles.figure1, 'YFamily');
    DeviceList   = getappdata(handles.figure1, 'YDeviceList');
    s = getappdata(handles.figure1, 'YSPosition');
    PlotLine = getappdata(handles.figure1, 'YPlotDeviceList');
    
elseif WhichPlot==3
    
    axesh = handles.axes3;
    Family =[];
    %Family       = getappdata(handles.figure1, 'IDFamily');
    DeviceList   = getappdata(handles.figure1, 'IDDeviceList');
    
end

% Tick direction -- In or Out???
set(axesh, 'TickDir', 'Out');

% Get "global" data
hlineSet = getappdata(handles.figure1, 'LineHandlesSet');
DataSet  = getappdata(handles.figure1, 'ArchivedDataSet');
tSet     = getappdata(handles.figure1, 'ArchivedTimeSet');


% empty PLot
if(isempty(tSet))
    return;
end


Data = DataSet{WhichPlot};
t = tSet{WhichPlot};
hline = hlineSet{WhichPlot};

% empty PLot
if(isempty(t))
    return;
end


% Get figure data (menues, buttons, etc.)
% Check if offset/golden/first point/last point/none selected from menu
if strcmpi(get(handles.Golden, 'Checked'),'On')
    OffsetRemoval = 2;
elseif strcmpi(get(handles.Offset, 'Checked'),'On')
    OffsetRemoval = 1;
elseif strcmpi(get(handles.SPosShift, 'Checked'),'On')
    OffsetRemoval = 3;
elseif strcmpi(get(handles.FirstPoint, 'Checked'),'On')
    OffsetRemoval = 4;
elseif strcmpi(get(handles.LastPoint, 'Checked'),'On')
    OffsetRemoval = 5;
else
    OffsetRemoval =0;
end


SPosGain = getappdata(handles.figure1, 'SPosGain');  % Should be a menu (separate on/off from the gain)

if(WhichPlot<3)
    if OffsetRemoval == 1 % Offset Menu Item - only axes1/axes2
        
        Offset = getoffset(Family, DeviceList);
        
        for i = 1:size(Data,2)
            if(~isempty(Data{i}))
                if(PlotLine(i,4) >0) % Plot BPM yes/no
                    set(hline(i), 'XData', t{i}, 'YData',  Data{i} - Offset(i));
                else
                    set(hline(i), 'XData', NaN, 'YData',  NaN);
                end
            end
        end
    elseif OffsetRemoval == 2 % Golden Menu item - only axes1/axes2
        
        Offset = getgolden(Family, DeviceList);
        
        for i = 1:size(Data,2)
            if(~isempty(Data{i}))
                if(PlotLine(i,4) >0) % Plot BPM yes/no
                    set(hline(i), 'XData', t{i}, 'YData',  Data{i} - Offset(i));
                else
                    set(hline(i), 'XData', NaN, 'YData',  NaN);
                end
            end
        end
    elseif OffsetRemoval == 3 % SPosition Menu Item - applies only to 1/2 graphs
        % Subtract SPos shift and golden orbit (was the first point):
        % First point is better in someways, but if the beam is lost the graph goes crazy
        Offset = getgolden(Family, DeviceList);
        
        for i = 1:size(Data,2)
            if(~isempty(Data{i}))
                if(PlotLine(i,4) >0) % Plot BPM yes/no
                    set(hline(i), 'XData', t{i}, 'YData',  Data{i} - Offset(i) + SPosGain*s(i));    % Golden value
                    %               set(hline(i), 'XData', t{i}, 'YData',  Data{i} - Data{i}(1) + SPosGain*s(i));
                else
                    set(hline(i), 'XData', NaN, 'YData',  NaN);
                end
            end
        end
        
    elseif OffsetRemoval == 4 % First Point Menu Item - applies only to 1/2 graphs
        % subtract First Point
        
        for i = 1:size(Data,2)
            if(~isempty(Data{i}))
                if(PlotLine(i,4) >0) % Plot BPM yes/no
                    
                    set(hline(i), 'XData', t{i}, 'YData',  Data{i} - Data{i}(1));
                else
                    set(hline(i), 'XData', NaN, 'YData',  NaN);
                end
            end
        end
        
        
    elseif OffsetRemoval == 5 % Last Point Menu Item - applies only to 1/2 graphs
        % subtract Last Point
        
        for i = 1:size(Data,2)
            if(~isempty(Data{i}))
                if(PlotLine(i,4) >0) % Plot BPM yes/no
                    
                    set(hline(i), 'XData', t{i}, 'YData',  Data{i} - Data{i}(end));
                else
                    set(hline(i), 'XData', NaN, 'YData',  NaN);
                end
            end
        end
        
        
    elseif OffsetRemoval == 0 % None Menu Item - no offset
        
        for i = 1:size(Data,2)
            if(~isempty(Data{i}))
                if(PlotLine(i,4) >0) % Plot BPM yes/no
                    
                    set(hline(i), 'XData', t{i}, 'YData',  Data{i});
                    
                else
                    set(hline(i), 'XData', NaN, 'YData',  NaN);
                end
            end
        end
    end
    
elseif WhichPlot >2 % Graph 3: plot raw data with no offset
    for i = 1:size(Data,2)
        if(~isempty(Data{i}))
            set(hline(i), 'XData', t{i}, 'YData',  Data{i});
        end
    end
end


% PLot
XLimit = [Inf -Inf];

% graph 1 and 2 only; SPosShift does not apply to 3rd graph
if WhichPlot<3 && OffsetRemoval==3
    
    
    % Compute and store XLimit based on first graph
    % assume graph n. 1 non empty
    if(WhichPlot<2)
        
        temp=t;
        temp(cellfun(@isempty,temp)) = {NaN};
        XMax = max(cellfun(@max, temp));
        
        if(XMax> getappdata(handles.figure1,'ArchivedStartTime'))
            XLimit = [getappdata(handles.figure1,'ArchivedStartTime'), XMax];
        else
            XLimit = [getappdata(handles.figure1,'ArchivedStartTime'),getappdata(handles.figure1,'ArchivedEndTime')];
        end
        setappdata(handles.figure1, 'XLimit', XLimit);
    else
        XLimit = getappdata(handles.figure1,'XLimit');
    end
    
    
    
    set(axesh, 'YGrid', 'On');
    AutoScaleY = getappdata(handles.figure1, 'AutoScaleY');
    if strcmpi(AutoScaleY, 'On')
        set(axesh, 'YLimMode', 'Auto');
        drawnow;
    end
    set(axesh, 'YLimMode', 'Manual');
    
    
    % Draw Lattice
    if exist('axesLattice','var')
        set(axesLattice, 'XLim', [-1.5 1.5]);
        
        % Link the axes
        dy = get(axesh, 'YLim');
        % axes2 and axes1 only
        set(axesLattice, 'YLim', dy(1:2)/SPosGain);
        
        set(axesh, 'YTickLabel',[]);
        set(axesh, 'YTickLabelMode', 'Manual');
        
        h = get(axesh, 'YLabel');
        set(h, 'Visible', 'Off');
        
        
    else
        
        h = get(axesh, 'YLabel');
        set(h, 'Visible', 'On')
    end
    
    
    % TODO: check this
    % the following added see clear function
    % if not set and YTick cleared, then YTick empty
    set(axesh, 'YTickMode', 'Auto');
    drawnow;
    
else % axes 3 plotted here....
    
    % Compute and store XLimit based on first graph
    if(WhichPlot<2)
        
        temp=t;
        temp(cellfun(@isempty,temp)) = {NaN};
        XMax = max(cellfun(@max, temp));
        
        if(XMax> getappdata(handles.figure1,'ArchivedStartTime'))
            XLimit = [getappdata(handles.figure1,'ArchivedStartTime'), XMax];
        else
            XLimit = [getappdata(handles.figure1,'ArchivedStartTime'),getappdata(handles.figure1,'ArchivedEndTime')];
        end
        setappdata(handles.figure1, 'XLimit', XLimit);
    else
        XLimit = getappdata(handles.figure1,'XLimit');
    end
    
    
    
    set(axesh, 'YGrid', 'On');
    set(axesh, 'YTickLabelMode', 'Auto');
    % TODO: check this
    % the following added see clear function
    % if not set and YTick cleared, then YTick empty
    set(axesh, 'YTickMode', 'Auto');
    
    
    AutoScaleY = getappdata(handles.figure1, 'AutoScaleY');
    if strcmpi(AutoScaleY, 'On')
        set(axesh, 'YLimMode', 'Auto');
        drawnow;
    end
    set(axesh, 'YLimMode', 'Manual');
    
    
    if WhichPlot < 3 && exist('axesLattice','var')
        % axes1 / axes2 only
        set(axesLattice, 'XLim', [-10 -9]); % A cheap way to get rid of the lattice
        
        h = get(axesh, 'YLabel');
        set(h, 'Visible', 'On')
        
    end
end


set(axesh, 'XLimMode', 'Manual');
AutoScaleX = getappdata(handles.figure1, 'AutoScaleX');
if strcmpi(AutoScaleX, 'On')
    set(axesh, 'XLim', XLimit);
end



% Change the date string because Matlab is stupid
set(axesh, 'XTickLabel',[]);
set(axesh, 'XTickLabelMode', 'Manual');
set(axesh, 'XTickLabel', datestr(get(axesh,'XTick'),'HH:MM:SS'));


% TODO: check this, if printing year/mm/dd is wrong....
% datestr(get(handles.axes1,'xticklabel'),'yyyy-mm-dd HH:MM:ss')
% set(axes,'xticklabel', datestr(get(handles.axes1,'xtick'),'YYYY-MM-DD HH:mm:ss'));

% Display the vertical mm/div
DisplayMMPerDivision(handles,axesh);

drawnow;



% Axes1/axes2/axes3/ ButtonDown
function AxesButtonDown_Callback(hObject, eventdata, handles)

% s = getappdata(handles.figure1, 'SPosition'); % nOT used why here???
SPosGain = getappdata(handles.figure1, 'SPosGain');  % Should be a menu
if strcmpi(get(handles.SPosShift, 'Checked'),'Off')
    SPosGain = 1;
end

% If the mouse is on a line, then switch the handle to the axes
if ~any(hObject == [handles.axes1 handles.axes2 handles.axes3])
    hObject = get(hObject,'parent');
end

if(hObject == handles.axes1)
    
    % Axis resize
    point1 = get(handles.axes1,'CurrentPoint');  % button down detected
    finalRect = rbbox;                           % return figure units
    point2 = get(handles.axes1,'CurrentPoint');  % button up detected
    point1 = point1(1,1:2);                      % extract x and y
    point2 = point2(1,1:2);
    pp1 = min(point1,point2);                    % calculate locations
    pp2 = max(point1,point2);                    % calculate locations
    offset = abs(point1-point2);                 % and dimensions
    xx = [pp1(1) pp1(1)+offset(1) pp1(1)+offset(1) pp1(1) pp1(1)];
    yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];
    
    if any((point2-point1)==0)
        % Auto scale the graph
        %setappdata(handles.figure1, 'DrawLattice', 'On');
        AutoScaleAxis_Callback(hObject, eventdata, handles);
    else
        dx = [pp1(1) pp2(1)];
        dy = [pp1(2) pp2(2)];
        
        %datestr(dx(1))
        
        %set(handles.axes1, 'XLimMode', 'Manual');
        set(handles.axes1, 'XLim', dx);
        set(handles.axes1, 'YLim', dy);
        
        
        if(strcmpi(get(handles.SPosShift, 'Checked'),'on'))
            % Scale the lattice axes
            set(handles.LatticeAxes, 'XLim', [-1.5 1.5]);
            set(handles.LatticeAxes, 'YLim', dy(1:2)/SPosGain);
            
            set(handles.axes1, 'YTickMode', 'Auto');
        else
            set(handles.axes1, 'YTickMode', 'Auto');
            set(handles.axes1, 'YTickLabelMode', 'Auto');
        end
        
        
        setappdata(handles.figure1, 'AutoScaleX', 'Off');
        setappdata(handles.figure1, 'AutoScaleY', 'Off');       
        
    end
    
    
    set(handles.axes1,'xticklabel', datestr(get(handles.axes1,'xtick'),'HH:MM:SS'));
    set(handles.axes2,'xticklabel', datestr(get(handles.axes2,'xtick'),'HH:MM:SS'));
    set(handles.axes3,'xticklabel', datestr(get(handles.axes3,'xtick'),'HH:MM:SS'));
    
    % Display the vertical mm/div
    DisplayMMPerDivision(handles,handles.axes1);
    
    drawnow;
    
elseif(hObject== handles.axes2)
    
    % Axis resize
    point1 = get(handles.axes2,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(handles.axes2,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    pp1 = min(point1,point2);            % calculate locations
    pp2 = max(point1,point2);            % calculate locations
    offset = abs(point1-point2);         % and dimensions
    xx = [pp1(1) pp1(1)+offset(1) pp1(1)+offset(1) pp1(1) pp1(1)];
    yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];
    
    if any((point2-point1)==0)
        % Auto scale the graph
        AutoScaleAxis_Callback(hObject, eventdata, handles);
    else
        dx = [pp1(1) pp2(1)];
        dy = [pp1(2) pp2(2)];
        
        set(handles.axes2, 'XLim', dx);
        set(handles.axes2, 'YLim', dy);
        
        %         timeSet = getappdata(handles.figure1, 'ArchivedTimeSet');
        %         if(pp1(1) <= min(cellfun(@min, timeSet{2})))
        if(strcmpi(get(handles.SPosShift, 'Checked'),'on'))
            % Scale the lattice axes
            set(handles.LatticeAxes2, 'XLim', [-1.5 1.5]);
            set(handles.LatticeAxes2, 'YLim', dy(1:2)/SPosGain);
            
            set(handles.axes2, 'YTickMode', 'Auto');
        else
            set(handles.axes2, 'YTickMode', 'Auto');
            set(handles.axes2, 'YTickLabelMode', 'Auto');
        end
        
        setappdata(handles.figure1, 'AutoScaleX', 'Off');
        setappdata(handles.figure1, 'AutoScaleY', 'Off');
    end
    
    set(handles.axes1,'xticklabel', datestr(get(handles.axes1,'xtick'),'HH:MM:SS'));
    set(handles.axes2,'xticklabel', datestr(get(handles.axes2,'xtick'),'HH:MM:SS'));
    set(handles.axes3,'xticklabel', datestr(get(handles.axes3,'xtick'),'HH:MM:SS'));
    
    % Display the vertical mm/div
    DisplayMMPerDivision(handles,handles.axes2);
    
elseif(hObject== handles.axes3)
    
    % Axis resize
    point1 = get(handles.axes3,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(handles.axes3,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    pp1 = min(point1,point2);            % calculate locations
    pp2 = max(point1,point2);            % calculate locations
    offset = abs(point1-point2);         % and dimensions
    xx = [pp1(1) pp1(1)+offset(1) pp1(1)+offset(1) pp1(1) pp1(1)];
    yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];
    
    if any((point2-point1)==0)
        % Auto scale the graph
        AutoScaleAxis_Callback(hObject, eventdata, handles);
    else
        dx = [pp1(1) pp2(1)];
        dy = [pp1(2) pp2(2)];
        
        set(handles.axes3, 'XLim', dx);
        set(handles.axes3, 'YLim', dy);
        
        setappdata(handles.figure1, 'AutoScaleX', 'Off');
        setappdata(handles.figure1, 'AutoScaleY', 'Off');
    end
    
    
    set(handles.axes1,'xticklabel', datestr(get(handles.axes1,'xtick'),'HH:MM:SS'));
    set(handles.axes2,'xticklabel', datestr(get(handles.axes2,'xtick'),'HH:MM:SS'));
    set(handles.axes3,'xticklabel', datestr(get(handles.axes3,'xtick'),'HH:MM:SS'));
    
    % Display the vertical mm/div
    DisplayMMPerDivision(handles,handles.axes3);
end


XLimit = get(handles.axes1, 'XLim');
set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));


drawnow;



% --------------------------------------------------------------------
function Print_Callback(hObject, eventdata, handles)
% hObject    handle to Print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% platform independent dialog does not work on Paola's PC
printdlg('-setup',handles.figure1);
%printdlg('-crossplatform',handles.figure1);



% --------------------------------------------------------------------
function PrintPreview_Callback(hObject, eventdata, handles)
% hObject    handle to PrintPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printpreview(handles.figure1);



% % Offset menu: SPosShift item - applies only to BPM graphs
% % Apply S-Pos Shift and subtract first point.
% --------------------------------------------------------------------
function SPosShift_Callback(hObject, eventdata, handles)

if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.SPosShift,'Checked','on');
    set(handles.Golden,'Checked','off');
    set(handles.Offset,'Checked','off');
    set(handles.FirstPoint,'Checked','off');
    set(handles.LastPoint,'Checked','off');
    set(handles.None,'Checked','off');
    
    set(handles.resetGraph,'Enable','on');
end


DisplaySettings(handles);

% Update all plots
plotachiveddata(handles,1);
AutoScaleAxis1y(handles,1);

plotachiveddata(handles,2);
AutoScaleAxis1y(handles,2);



% Offset menu: Golden item - applies only to BPM graphs
% --------------------------------------------------------------------
function Golden_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    
    set(handles.SPosShift,'Checked','off');
    set(handles.Golden,'Checked','on');
    set(handles.Offset,'Checked','off');
    set(handles.FirstPoint,'Checked','off');
    set(handles.LastPoint,'Checked','off');
    set(handles.None,'Checked','off');
    
    set(handles.resetGraph,'Enable','off');
end

DisplaySettings(handles);

% Update the PLot
plotachiveddata(handles,1);
AutoScaleAxis1y(handles,1);

plotachiveddata(handles,2);
AutoScaleAxis1y(handles,2);



% Offset menu: Offset item - applies only to BPM graphs
% --------------------------------------------------------------------
function Offset_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    
    set(handles.SPosShift,'Checked','off');
    set(handles.Golden,'Checked','off');
    set(handles.Offset,'Checked','on');
    set(handles.FirstPoint,'Checked','off');
    set(handles.LastPoint,'Checked','off');
    set(handles.None,'Checked','off');
    
    set(handles.resetGraph,'Enable','off');
    
end

DisplaySettings(handles);

plotachiveddata(handles,1);
AutoScaleAxis1y(handles,1);

plotachiveddata(handles,2);
AutoScaleAxis1y(handles,2);



% Offset menu: None item: applies only to BPMs graphs
% --------------------------------------------------------------------
function None_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    
    set(handles.SPosShift,'Checked','off');
    set(handles.Golden,'Checked','off');
    set(handles.Offset,'Checked','off');
    set(handles.FirstPoint,'Checked','off');
    set(handles.LastPoint,'Checked','off');
    set(handles.None,'Checked','on');
    
    set(handles.resetGraph,'Enable','off');
end

DisplaySettings(handles);

plotachiveddata(handles,1);
AutoScaleAxis1y(handles,1);

plotachiveddata(handles,2);
AutoScaleAxis1y(handles,2);



% Subtract LastPoint menu: applies to 1/2 graphs
% --------------------------------------------------------------------
function LastPoint_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    
    set(handles.SPosShift,'Checked','off');
    set(handles.Golden,'Checked','off');
    set(handles.Offset,'Checked','off');
    set(handles.FirstPoint,'Checked','off');
    set(handles.LastPoint,'Checked','on');
    set(handles.None,'Checked','off');
    
    set(handles.resetGraph,'Enable','off');
    
end

DisplaySettings(handles);

% Update all the plots
plotachiveddata(handles,1);
AutoScaleAxis1y(handles,1);

plotachiveddata(handles,2);
AutoScaleAxis1y(handles,2);



% Subtract FirstPoint menu: applies to 1/2 graphs
% --------------------------------------------------------------------
function FirstPoint_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    
    set(handles.SPosShift,'Checked','off');
    set(handles.Golden,'Checked','off');
    set(handles.Offset,'Checked','off');
    set(handles.FirstPoint,'Checked','on');
    set(handles.LastPoint,'Checked','off');
    set(handles.None,'Checked','off');
    
    set(handles.resetGraph,'Enable','off');
    
end

DisplaySettings(handles);

% Update all the plots
plotachiveddata(handles,1);
AutoScaleAxis1y(handles,1);

plotachiveddata(handles,2);
AutoScaleAxis1y(handles,2);


% Autoscale after plotting,
% after (every time) new data is plotted (including timer mode).
% Called also when the user clicks on the ZoomOut Button
function AutoScaleAxis_Callback(hObject, eventdata, handles)

% Expand to full axis then put the y-axes back to manual
SPosGain = getappdata(handles.figure1, 'SPosGain');  % Should be a menu
if strcmpi(get(handles.SPosShift, 'Checked'),'Off')
    SPosGain = 1;
end

% AutoScale X and Y if user clicks on ZoomOut Button
% Autoscale the vertical:only for the axes where the user clicks on 
% if(strcmpi(get(hObject,'Type'),'uipushtool')) 
% if(strcmpi(get(hObject,'Tag'),'YZoomToggle') || strcmpi(get(hObject,'Tag'),'ZoomOut') || strcmpi(get(hObject,'Tag'),'ZoomToggle'))
if(strcmpi(get(hObject,'Tag'),'ZoomOut'))
    setappdata(handles.figure1, 'AutoScaleX', 'On');
    setappdata(handles.figure1, 'AutoScaleY', 'On');
    set(handles.axes1, 'XTickMode', 'auto');
    set(handles.axes2, 'XTickMode', 'auto');
    set(handles.axes3, 'XTickMode', 'auto');
elseif(hObject == handles.axes1)
    % zoom out-> let autoscale
    set(handles.axes1, 'YLimMode', 'auto');
 elseif(hObject == handles.axes2)   
     % zoom out-> let autoscale
    set(handles.axes2, 'YLimMode', 'auto');
elseif(hObject == handles.axes3)   
     % zoom out-> let autoscale
    set(handles.axes3, 'YLimMode', 'auto');   
end


% GRAPH 1
% Autoscale the vertical, then turn it back to manual
% if not in zoom mode

AutoScaleY =getappdata(handles.figure1, 'AutoScaleY');

% this function is called also with timer on
% do not autoscale if zoom in
if strcmpi(AutoScaleY, 'On')
    set(handles.axes1, 'YLimMode', 'auto');
    drawnow;
    set(handles.axes1, 'YLimMode', 'manual');
end


% Link the lattice axes
dy = get(handles.axes1, 'YLim');
set(handles.LatticeAxes, 'YLimMode', 'manual');
set(handles.LatticeAxes, 'YLim', dy(1:2)/SPosGain);
drawnow;
DisplayMMPerDivision(handles,handles.axes1);


% Use the saved limits
XLimit = getappdata(handles.figure1, 'XLimit');
AutoScaleX = getappdata(handles.figure1, 'AutoScaleX');

% this function is called also with timer on
% do not autoscale if zoom in
if strcmpi(AutoScaleX, 'On')
    set(handles.axes1, 'XLimMode', 'manual');
    set(handles.axes1, 'XLim', XLimit);
end


% added after reset10Min since xticks are manually set there
% assuming 10 minutes interval so ticks are spaced
if strcmpi(get(handles.axes1, 'XTickMode'),'Manual')
    set(handles.axes1, 'XTick', []);
    xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
    set(handles.axes1, 'XTick', [xtick1:1/60/24:XLimit(2)]);%%
else
    set(handles.axes1, 'XTick', []);
    set(handles.axes1, 'XTickMode', 'Auto');
end

% this function is called also with timer on
% do not autoscale if zoom in
if strcmpi(AutoScaleY, 'On')
    set(handles.axes2, 'YLimMode', 'auto');
    drawnow;
    set(handles.axes2, 'YLimMode', 'manual');
end

% Link the lattice axes
dy = get(handles.axes2, 'YLim');
set(handles.LatticeAxes2, 'YLimMode', 'manual');
set(handles.LatticeAxes2, 'YLim', dy(1:2)/SPosGain);

drawnow;
DisplayMMPerDivision(handles,handles.axes2);

% this function is called also with timer on
% do not autoscale if zoom in
if strcmpi(AutoScaleX, 'On')
    set(handles.axes2, 'XLimMode', 'manual');
    set(handles.axes2, 'XLim', XLimit);
end

% added after reset10Min since xticks are manually set there
% assuming 10 minutes interval so ticks are spaced
if strcmpi(get(handles.axes2, 'XTickMode'),'Manual')
    set(handles.axes2, 'XTick', []);
    xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
    set(handles.axes2, 'XTick', [xtick1:1/60/24:XLimit(2)]);%%
else    
    set(handles.axes2, 'XTick', []);
    set(handles.axes2, 'XTickMode', 'Auto');
end

% this function is called also with timer on
% do not autoscale if zoom in
if strcmpi(AutoScaleY, 'On')
    
    set(handles.axes3, 'YLimMode', 'auto');
    drawnow;
    set(handles.axes3, 'YLimMode', 'manual');
end

DisplayMMPerDivision(handles,handles.axes3);

% this function is called also with timer on
% do not autoscale if zoom in
if strcmpi(AutoScaleX, 'On')    
    set(handles.axes3, 'XLimMode', 'manual');
    set(handles.axes3, 'XLim', XLimit);  
end



% added after reset10Min since xticks are manually set there
% assuming 10 minutes interval so ticks are spaced
if strcmpi(get(handles.axes3, 'XTickMode'),'Manual')
    set(handles.axes3, 'XTick', []);
    xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
    set(handles.axes3, 'XTick', [xtick1:1/60/24:XLimit(2)]);%%
else    
    set(handles.axes3, 'XTick', []);
    set(handles.axes3, 'XTickMode', 'Auto');
end

set(handles.axes1, 'XTickLabel',[]);
set(handles.axes2, 'XTickLabel',[]);
set(handles.axes3, 'XTickLabel',[]);
set(handles.axes2, 'XTickLabelMode', 'Manual');
set(handles.axes1, 'XTickLabelMode', 'Manual');
set(handles.axes3, 'XTickLabelMode', 'Manual');


% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(handles.axes1,'XTickLabel', datestr(get(handles.axes1,'xtick'),'HH:MM:SS'));
set(handles.axes2,'XTickLabel', datestr(get(handles.axes2,'xtick'),'HH:MM:SS'));
set(handles.axes3,'XTickLabel', datestr(get(handles.axes3,'xtick'),'HH:MM:SS'));


% Autoscale future updates
% commented out for timer case and zoom in mode
% setappdata(handles.figure1, 'AutoScaleX', 'On');
XLimit = get(handles.axes1, 'XLim');
set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));
drawnow;

% Autoscale Y - do not touch X
% Lattice is updated if present
function YAutoScaleAxis_Callback(hObject, eventdata, handles)

% Expand to full axis then put the y-axes back to manual
SPosGain = getappdata(handles.figure1, 'SPosGain');  % Should be a menu
if strcmpi(get(handles.SPosShift, 'Checked'),'Off')
    SPosGain = 1;
end

% YZoom out does not affect LAttice
if(hObject == handles.axes1)
    % GRAPH 1
    % Autoscale the vertical, then turn it back to manual
    set(handles.axes1, 'YLimMode', 'auto');
    drawnow;
    set(handles.axes1, 'YLimMode', 'manual');
end

% Link the lattice axes,when LAttice is there
dy = get(handles.axes1, 'YLim');
set(handles.LatticeAxes, 'YLimMode', 'manual');
set(handles.LatticeAxes, 'YLim', dy(1:2)/SPosGain);
drawnow;
DisplayMMPerDivision(handles,handles.axes1);



% GRAPH 2
if(hObject == handles.axes2)
    set(handles.axes2, 'YLimMode', 'auto');
    drawnow;
    set(handles.axes2, 'YLimMode', 'manual');
end

% Link the lattice axes
dy = get(handles.axes2, 'YLim');
set(handles.LatticeAxes2, 'YLimMode', 'manual');
set(handles.LatticeAxes2, 'YLim', dy(1:2)/SPosGain);
drawnow;
DisplayMMPerDivision(handles,handles.axes2);

% set(handles.axes2, 'XLimMode', 'manual');
% set(handles.axes2, 'XLim', XLimit);


% GRAPH 3
if(hObject == handles.axes3)
    set(handles.axes3, 'YLimMode', 'auto');
    drawnow;
    set(handles.axes3, 'YLimMode', 'manual');
end
DisplayMMPerDivision(handles,handles.axes3);



% Autoscale future updates
setappdata(handles.figure1, 'AutoScaleX', 'On');
setappdata(handles.figure1, 'AutoScaleY', 'On');


drawnow



% --------------------------------------------------------------------
function AutoScaleAxis1y(handles,WhichPlot)

if WhichPlot==1
    
    axes = handles.axes1;
    latticeAxes = handles.LatticeAxes;
elseif WhichPlot==2
    
    axes = handles.axes2;
    latticeAxes = handles.LatticeAxes2;
    
elseif WhichPlot==3
    
    axes = handles.axes3;
    
end

% Expand to full axis then put the y-axes back to manual
SPosGain = getappdata(handles.figure1, 'SPosGain');  % Should be a menu
if strcmpi(get(handles.SPosShift, 'Checked'),'Off')
    SPosGain = 1;
end

% Autoscale the vertical, then turn it back to manual
set(axes, 'YLimMode', 'auto');
drawnow;
set(axes, 'YLimMode', 'manual');

if(WhichPlot<3)
    % Link the lattice axes
    dy = get(axes, 'YLim');
    set(latticeAxes, 'YLimMode', 'manual');
    set(latticeAxes, 'YLim', dy(1:2)/SPosGain);
    
end
% Autoscale vertical on future updates
setappdata(handles.figure1, 'AutoScaleY', 'On');

DisplayMMPerDivision(handles,axes);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% Stop and delete the timer.
if(strcmpi(getappdata(handles.figure1, 'WriteToWebFlag'),'On'))
    selection = questdlg(['Close ' get(handles.figure1,'Name') '? Closing the application will stop updating the web page.'],...
        ['Close ' get(handles.figure1,'Name') '...'],...
        'Yes','No','Yes');
else
    
    selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
        ['Close ' get(handles.figure1,'Name') '...'],...
        'Yes','No','Yes');

end
if ~strcmpi(selection,'Yes')
    return;
end



if isfield(handles,'thetimer')
    try
        stop(handles.thetimer);
        delete(handles.thetimer);
    catch ME
    end
end



% delete hidden figures
try
    h = getappdata(handles.figure1, 'PrintFigure');
    delete(h);
catch ME
end
% Hint: delete(hObject) closes the figure
delete(handles.figure1);



% --------------------------------------------------------------------
function StartStopTimer_OffCallback(hObject, eventdata, handles)
% User sets timer toggle button off:
% stop the timer ( timer is deleted when user closes window).
% Enable manuale update buttons.

if isfield(handles,'thetimer')
    stop(handles.thetimer);
    delete(handles.thetimer);
    handles = rmfield(handles, 'thetimer');
end

% enable the timer menu item
set(handles.interval_10s,'Enable','on');
set(handles.interval_20s,'Enable','on');
set(handles.interval_30s,'Enable','on');
set(handles.interval_60s,'Enable','on');

% enable the timer menu item
set(handles.window24h,'Enable','on');
set(handles.window12h,'Enable','on');
set(handles.window8h,'Enable','on');
set(handles.window6h,'Enable','on');
set(handles.window1h,'Enable','on');

% enable the manual load data / clear buttons in the tool menu
set(handles.Plot24Hours,'Enable','on');
set(handles.Plot12Hours,'Enable','on');
set(handles.Plot8Hours,'Enable','on');
set(handles.Plot6Hours,'Enable','on');
set(handles.PlotHour,'Enable','on');
set(handles.Plot30Minutes,'Enable','on');
set(handles.Plot1Minute,'Enable','on');
set(handles.ClearGraph,'Enable','on');
set(handles.PlotInterval,'Enable','on');
set(handles.T1TimePlot,'Enable','on');
set(handles.T2TimePlot,'Enable','on');

% set(handles.TimerRunning, 'Visible', 'Off');
set(handles.StartStopTimer, 'ToolTipString', 'Start continuous updates');



% User sets timer toggle button on:
% create and start the timer(call Timer_Callback).
% Disable Timer menu while timer is running.
% Disable Manual data load menu while timer is running.
% Disable Manual update button while timer is running.
%
% Disable load data/ buttons while timer is running.
% --------------------------------------------------------------------
function StartStopTimer_OnCallback(hObject, eventdata, handles)

% hObject    handle to StartStopTimer (see GCBO)

if strcmpi(get(handles.interval_10s, 'Checked'),'On')
    TimerInterval = 10;
elseif strcmpi(get(handles.interval_20s, 'Checked'),'On')
    TimerInterval = 20;
elseif strcmpi(get(handles.interval_30s, 'Checked'),'On')
    TimerInterval = 30;
elseif strcmpi(get(handles.interval_60s, 'Checked'),'On')
    TimerInterval = 60;
else
    %default timer interval = 30s
    TimerInterval = 30;
end


if strcmpi(get(handles.window24h, 'Checked'),'On')
    TimerWindow = 24;
elseif strcmpi(get(handles.window12h, 'Checked'),'On')
    TimerWindow = 12;
elseif strcmpi(get(handles.window8h, 'Checked'),'On')
    TimerWindow = 8;
elseif strcmpi(get(handles.window6h, 'Checked'),'On')
    TimerWindow = 6;
elseif strcmpi(get(handles.window1h, 'Checked'),'On')
    TimerWindow = 1;
else
    %default timer window = 24 h
    TimerWindow = 24;
end


% disable the timer menu item
set(handles.interval_10s,'Enable','off');
set(handles.interval_20s,'Enable','off');
set(handles.interval_30s,'Enable','off');
set(handles.interval_60s,'Enable','off');

% disable the timer menu item
set(handles.window24h,'Enable','off');
set(handles.window12h,'Enable','off');
set(handles.window8h,'Enable','off');
set(handles.window6h,'Enable','off');
set(handles.window1h,'Enable','off');

% disable the manual load data / clear buttons in the tool menu
set(handles.Plot24Hours,'Enable','off');
set(handles.Plot12Hours,'Enable','off');
set(handles.Plot8Hours,'Enable','off');
set(handles.Plot6Hours,'Enable','off');
set(handles.PlotHour,'Enable','off');
set(handles.Plot30Minutes,'Enable','off');
set(handles.Plot1Minute,'Enable','off');
set(handles.ClearGraph,'Enable','off');

set(handles.PlotInterval,'Enable','off');
set(handles.T1TimePlot,'Enable','off');
set(handles.T2TimePlot,'Enable','off');

setappdata(handles.figure1, 'DataRetrievalInterval', TimerInterval);
setappdata(handles.figure1, 'TimerWindow', TimerWindow);


% start the timer to load data every tot sec
startTheTimer(handles);


% handles.thetimer = timer;
%
% set(handles.thetimer,'ExecutionMode','fixedRate','BusyMode','drop','Period',TimerInterval);
% set(handles.thetimer,'TimerFcn',{@Timer_Callback,handles});
%
% guidata(hObject, handles);
% start(handles.thetimer);


set(handles.StartStopTimer, 'ToolTipString', 'Stop continuous updates');



function startTheTimer(handles)

TimerPeriod  = getappdata(handles.figure1, 'DataRetrievalInterval');

% start the timer to load data every tot sec
handles.thetimer = timer;

set(handles.thetimer,'ExecutionMode','fixedRate','BusyMode','drop','Period',TimerPeriod);
set(handles.thetimer,'TimerFcn',{@Timer_Callback,handles});

guidata(handles.figure1, handles);
start(handles.thetimer);




% --------------------------------------------------------------------
function interval_10s_Callback(hObject, eventdata, handles)
% hObject    handle to interval_10s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.interval_10s,'Checked','on');
    set(handles.interval_20s,'Checked','off');
    set(handles.interval_30s,'Checked','off');
    set(handles.interval_60s,'Checked','off');
end
DisplaySettings(handles);



% --------------------------------------------------------------------
function interval_20s_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.interval_10s,'Checked','off');
    set(handles.interval_20s,'Checked','on');
    set(handles.interval_30s,'Checked','off');
    set(handles.interval_60s,'Checked','off');
end
DisplaySettings(handles);



% --------------------------------------------------------------------
function interval_30s_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.interval_10s,'Checked','off');
    set(handles.interval_20s,'Checked','off');
    set(handles.interval_30s,'Checked','on');
    set(handles.interval_60s,'Checked','off');
end
DisplaySettings(handles);



% --------------------------------------------------------------------
function interval_60s_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.interval_10s,'Checked','off');
    set(handles.interval_20s,'Checked','off');
    set(handles.interval_30s,'Checked','off');
    set(handles.interval_60s,'Checked','on');
end
DisplaySettings(handles);



% --------------------------------------------------------------------
function ClearGraph_ClickedCallback(hObject, eventdata, handles)
% Clear graph call back:
% Clear archiveddata and archived time
% clear graph 1/graph 2/ graph 3
% clear info windows

% Get the application data
setappdata(handles.figure1, 'ArchivedDataSet', {});
setappdata(handles.figure1, 'ArchivedTimeSet', {});
setappdata(handles.figure1, 'ArchivedStartTime', []);
setappdata(handles.figure1, 'ArchivedEndTime', []);

hlineSet = getappdata(handles.figure1, 'LineHandlesSet');

SPosGain = getappdata(handles.figure1, 'SPosGain');  % Should be a menu
if strcmpi(get(handles.SPosShift, 'Checked'),'Off')
    SPosGain = 1;
end

L = getfamilydata('Circumference');

% Clear graph 1
hline = hlineSet{1};
for i = 1:length(hline)
    % Turn off line identification
    set(hline(i), 'Marker', 'none');
    
    set(hline(i), 'XData', [NaN NaN], 'YData',   SPosGain*[0 L]);
end

% Clear graph 2
hline = hlineSet{2};
for i = 1:length(hline)
    % Turn off line identification
    set(hline(i), 'Marker', 'none');
    
    set(hline(i), 'XData', [NaN NaN], 'YData',   SPosGain*[0 L]);
end

% Clear graph 3
hline = hlineSet{3};
for i = 1:length(hline)
    % Turn off line identification
    set(hline(i), 'Marker', 'none');
    
    set(hline(i), 'XData', [NaN NaN], 'YData',  [NaN NaN]);
end

% Don't clear the XTick because they don't come back
set(handles.axes1, 'XTickMode', 'Auto');
set(handles.axes2, 'XTickMode', 'Auto');
set(handles.axes3, 'XTickMode', 'Auto');

set(handles.axes1, 'XTicklabel', []);
set(handles.axes2, 'XTicklabel', []);
set(handles.axes3, 'XTicklabel', []);

set(handles.axes1, 'YTick',[]);
set(handles.axes2, 'YTick',[]);
set(handles.axes3, 'YTick',[]);

DisplayMMPerDivision(handles,handles.axes1);
DisplayMMPerDivision(handles,handles.axes2);
DisplayMMPerDivision(handles,handles.axes3);

% clear text in info window
set(handles.InfoWindow, 'String', sprintf(''));
%set(handles.IDLine, 'String',sprintf(''));

% JTextField on ToolBar
jText = getappdata(handles.figure1, 'jText');
jText.setText('Mouse click on line to display channel info');
% set(handles.TimerRunning, 'Visible', 'Off');



% called in web mode to load tot. number of hours of data
% and start the timer for updates and print to web.
% Disable most menu and menu bar.
function PlotAndPublish(handles)

% should disable everything
set(handles.OffsetMenu,'Enable','off');
set(handles.LoadMode,'Enable','off');

% TODO: refactor this, in a function
if strcmpi(get(handles.interval_10s, 'Checked'),'On')
    TimerPeriod = 10;
elseif strcmpi(get(handles.interval_20s, 'Checked'),'On')
    TimerPeriod = 20;
elseif strcmpi(get(handles.interval_30s, 'Checked'),'On')
    TimerPeriod = 30;
elseif strcmpi(get(handles.interval_60s, 'Checked'),'On')
    TimerPeriod = 60;
else
    %default timer interval = 30s
    TimerPeriod = 30;
end

if strcmpi(get(handles.window24h, 'Checked'),'On')
    TimerWindow = 24;
elseif strcmpi(get(handles.window12h, 'Checked'),'On')
    TimerWindow = 12;
elseif strcmpi(get(handles.window8h, 'Checked'),'On')
    TimerWindow = 8;
elseif strcmpi(get(handles.window6h, 'Checked'),'On')
    TimerWindow = 6;
elseif strcmpi(get(handles.window1h, 'Checked'),'On')
    TimerWindow = 1;
else
    %default timer window = 24 h
    TimerWindow = 24;
end


% disable the manual load data / clear buttons in the tool menu
set(handles.Plot24Hours,'Enable','off');
set(handles.Plot12Hours,'Enable','off');
set(handles.Plot8Hours,'Enable','off');
set(handles.Plot6Hours,'Enable','off');
set(handles.PlotHour,'Enable','off');
set(handles.Plot30Minutes,'Enable','off');
set(handles.Plot1Minute,'Enable','off');
set(handles.ClearGraph,'Enable','off');

set(handles.PlotInterval,'Enable','off');
set(handles.T1TimePlot,'Enable','off');
set(handles.T2TimePlot,'Enable','off');
set(handles.StartStopTimer,'Enable','off');
% set(handles.ZoomToggle,'Enable','off');
% set(handles.ZoomOut,'Enable','off');
% set(handles.YZoomToggle,'Enable','off');



% PLot the last 8 hours
TimeBack = getappdata(handles.figure1, 'WriteToWebTimeBack')*60*60;
if(isempty(TimeBack))
    TimeBack = 60*60*1; % default 1 hour, if not set
end

% TimeBack = 60*60*6; % Plot last 6 hours
% EndTime=now;
% LoadData(handles, TimeBack,EndTime);
% AutoScaleAxis_Callback(hObject, eventdata, handles);

EndTime = now;
LoadData(handles, TimeBack, EndTime);
% AutoScaleAxis_Callback([], [], handles);
resetGraph_Callback([], [], handles);

setappdata(handles.figure1, 'DataRetrievalInterval', TimerPeriod);
setappdata(handles.figure1, 'TimerWindow', TimerWindow);
setappdata(handles.figure1, 'WriteToWebHowOften', 2*TimerPeriod);

startTheTimer(handles);







% Called when the user presses the Plot 6 hours button on the toolbar.
% Call LoadData to load 6 hours of data and PLot.
% --------------------------------------------------------------------
function Plot6Hours_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot12Hours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

TimeBack = 60*60*6; % Plot last 6 hours
EndTime=now;
LoadData(handles, TimeBack,EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);

EnableToolBarButtons(handles);



% Called when the user presses the PLot 8 hours button on the toolbar.
% Call LoadData to load last 8 hours of data and PLot.
% --------------------------------------------------------------------
function Plot8Hours_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot8Hours (see GCBO)


% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

TimeBack = 60*60*8;% Plot last 8 hours
EndTime=now;
LoadData(handles, TimeBack,EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);

EnableToolBarButtons(handles);



% Called when the user presses the Plot 12 hours button on the toolbar.
% Call LoadData to load 12 hours of data and PLot.
% --------------------------------------------------------------------
function Plot12Hours_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot12Hours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

TimeBack = 60*60*12;% Plot last 12 hours
EndTime=now;
LoadData(handles, TimeBack,EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);

EnableToolBarButtons(handles);


% --------------------------------------------------------------------
function Plot24Hours_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot24Hours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

TimeBack = 60*60*24;%Plot last 24 hours
EndTime = now; % EndTime is 0 hours back
LoadData(handles, TimeBack,EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);

EnableToolBarButtons(handles);



% --------------------------------------------------------------------
function PlotHour_ClickedCallback(hObject, eventdata, handles)

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

% PLot the last hour
TimeBack = 60*60;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);

EnableToolBarButtons(handles);



% --------------------------------------------------------------------
function Plot30Minutes_ClickedCallback(hObject, eventdata, handles)

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

% PLot the last 30 minutes
TimeBack = 30*60;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);

EnableToolBarButtons(handles);



% --------------------------------------------------------------------
function Plot1Minute_ClickedCallback(hObject, eventdata, handles)

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)


% PLot the last minute
TimeBack = 60;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);



% more than one Family for lines in graphs 3.


Field        = getappdata(handles.figure1, 'Field');
DeviceList   = getappdata(handles.figure1, 'IDDeviceList');
ChannelNamesSet = getappdata(handles.figure1, 'ChannelNamesSet');
ChannelNames = ChannelNamesSet{3};
LineSet = getappdata(handles.figure1, 'LineHandlesSet');
Lines = LineSet{3};
for k =1:size(ChannelNames, 1)
    iLineInfo = get(Lines(k), 'UserData');
    Family=iLineInfo{2};
    iLine = iLineInfo{1};
    arr{k,:} = sprintf('%s.%s(%d,%d)  %s', Family, Field,DeviceList(iLine,:), deblank(ChannelNames(iLine,:)));
end
hl=legend(handles.axes3,arr);
Children = get(hl, 'Children') ;

for k=1:length(Children)
    if(strcmpi(get(Children(k), 'Type'), 'Line'))
        set(Children(k), 'LineWidth', 9);
    end
end



EnableToolBarButtons(handles);



% Disable Toolbar buttons/ for plotting
function EnableToolBarButtons(handles)

%enable toolbar buttons
set(handles.Plot24Hours,'Enable','on');
set(handles.Plot12Hours,'Enable','on');
set(handles.Plot8Hours,'Enable','on');
set(handles.Plot6Hours,'Enable','on');
set(handles.PlotHour,'Enable','on');
set(handles.Plot30Minutes,'Enable','on');
set(handles.Plot1Minute,'Enable','on');
set(handles.ClearGraph,'Enable','on');
set(handles.StartStopTimer,'Enable','on');
set(handles.PlotInterval,'Enable','on');
set(handles.T1TimePlot,'Enable','on');
set(handles.T2TimePlot,'Enable','on');



% Enable Toolbar buttons
function DisableToolBarButtons(hObject, handles)

if(handles.Plot24Hours ~= hObject)
    set(handles.Plot24Hours,'Enable','off');
end

if(handles.Plot12Hours ~= hObject)
    set(handles.Plot12Hours,'Enable','off');
end

if(handles.Plot8Hours ~= hObject)
    set(handles.Plot8Hours,'Enable','off');
end
if(handles.Plot6Hours ~= hObject)
    set(handles.Plot6Hours,'Enable','off');
end
if(handles.PlotHour ~= hObject)
    set(handles.PlotHour,'Enable','off');
end

if(handles.Plot30Minutes ~= hObject)
    set(handles.Plot30Minutes,'Enable','off');
end

if(handles.Plot1Minute ~= hObject)
    set(handles.Plot1Minute,'Enable','off');
end

if(handles.ClearGraph ~= hObject)
    set(handles.ClearGraph,'Enable','off');
end

if(handles.StartStopTimer ~= hObject)
    set(handles.StartStopTimer,'Enable','off');
end

if(handles.PlotInterval ~= hObject)
    set(handles.PlotInterval,'Enable','off');
end

if(handles.T1TimePlot ~= hObject)
    set(handles.T1TimePlot,'Enable','off');
end

if(handles.T2TimePlot ~= hObject)
    set(handles.T2TimePlot,'Enable','off');
end



function h = drawlatticelocal(Offset, Scaling, hAxes)
%DRAWLATTICELOCAL - Draws the AT lattice to a figure
%  h = drawlatticelocal(Offset {0}, Scaling {1}, hAxes {gca})
%
%  h - handle to each element drawn
%
%  Programmers Notes
%  1. The AT index is stored in the Userdata of each symbol.
%     get(h(i),'Userdata')
%  2. To set a callback on an element use:
%     set(h(i),'ButtonDownFcn', FunctionName);
%  3. To set a context menu (right mouse menu) on an element use:
%     hcmenu = uicontextmenu;
%     set(h(i),'UIContextMenu', hcmenu);
%     h1 = uimenu(hcmenu, 'Label', 'Run #1', 'Callback', 'disp(''Run #1'');');
%     h2 = uimenu(hcmenu, 'Label', 'Run #2', 'Callback', 'disp(''Run #2'');');
%     h3 = uimenu(hcmenu, 'Label', 'Run #3', 'Callback', 'disp(''Run #3'');');


% To do:
% 1. Draw insertion devices
% 2.


THERING = alslat_for_drawing;

CorrectorFlag = 0;

% Minimum icon width in meters (also in drawquadrupolelocal)
MinIconWidth = .03;

if nargin < 1
    Offset = 0;
end
Offset = Offset(1);
if nargin < 2
    Scaling = 1;
end
Scaling = Scaling(1);

if nargin < 3
    hAxes = gca;
end


SPositions = findspos(THERING, 1:length(THERING)+1);
L = SPositions(end);
%L = getfamilydata('Circumference');

plot(hAxes, [0 0]+Offset, [0 L], 'k');

% Remember the hold state then turn hold on
HoldState = ishold(hAxes);
hold(hAxes, 'on');


% Make default icons for elements of different physical types
h = [];
for i = 1:length(THERING)
    NumberOfFinds = 0;
    
    SPos = SPositions(i);
    
    if isfield(THERING{i},'BendingAngle') || strcmpi(THERING{i}.FamName,'BEND')
        % make icons for bending magnets
        NumberOfFinds = NumberOfFinds + 1;
        IconHeight = .3;
        IconColor = [1 1 0];
        IconWidth = THERING{i}.Length;
        if IconWidth < MinIconWidth    % meters
            IconWidth = MinIconWidth;
            SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
        end
        vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
        vy = [IconHeight IconHeight -IconHeight -IconHeight];
        h(length(h)+1) = patch(Scaling*vy+Offset, vx, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        
        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        %set(h(end), 'EdgeColor', IconColor);
        
    elseif isfield(THERING{i},'K')
        % Quadrupole
        NumberOfFinds = NumberOfFinds + 1;
        
        IconWidth = THERING{i}.Length;
        
        if THERING{i}.K == 0
            % Is it a skew quad?
            % Focusing quadrupole
            IconHeight = .55;
            IconColor = [1 0 0];
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + L/2;
            end
            vx = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
            vy = [0          IconHeight               0      -IconHeight    0];
        elseif THERING{i}.K >= 0
            % Focusing quadrupole
            IconHeight = .8;
            IconColor = [1 0 0];
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + L/2;
            end
            vx = [SPos SPos+IconWidth/2  SPos+IconWidth SPos+IconWidth/2 SPos];
            vy = [0          IconHeight               0      -IconHeight    0];
        else
            % Defocusing quadrupole
            IconHeight = .7;
            IconColor = [0 0 1];
            if IconWidth < MinIconWidth % meters
                % Center about starting point
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + L/2;
            end
            vx = [SPos+.4*IconWidth    SPos    SPos+IconWidth  SPos+.6*IconWidth  SPos+IconWidth    SPos      SPos+.4*IconWidth];
            vy = [     0            IconHeight   IconHeight          0              -IconHeight  -IconHeight    0];
        end
        h = patch(Scaling*vy+Offset, vx, IconColor,'LineStyle','-', 'Parent',hAxes);
        %set(h, 'EdgeColor', IconColor);
        set(h(end), 'UserData', i);
        
    elseif isfield(THERING{i},'PolynomB') && length(THERING{i}.PolynomB)>2 && (THERING{i}.PolynomB(3) || any(strcmpi(THERING{i}.FamName,{'SF','SFF','SD','SDD','HSF','HSD'})))
        % Sextupole
        %Shrinkage = .05;
        NumberOfFinds = NumberOfFinds + 1;
        if THERING{i}.PolynomB(3)>0 || any(strcmpi(THERING{i}.FamName,{'SF','SFF','HSF'}))
            % Focusing sextupole
            IconHeight = .7;
            IconColor = [1 0 1];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            %LShrinkage = Shrinkage * IconWidth;
            %vx = [SPos+LShrinkage          SPos+.33*IconWidth+LShrinkage  SPos+.66*IconWidth-LShrinkage  SPos+IconWidth-LShrinkage  SPos+IconWidth-LShrinkage  SPos+.66*IconWidth-LShrinkage   SPos+.33*IconWidth+LShrinkage  SPos+LShrinkage  SPos+LShrinkage];
            %vy = [IconHeight/3                      IconHeight                     IconHeight                   IconHeight/3               -IconHeight/3                -IconHeight                      -IconHeight           -IconHeight/3     IconHeight/3 ];
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        else
            % Defocusing sextupole
            IconHeight = .7;
            IconColor = [0 1 0];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
            %vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            %vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        end
        h(length(h)+1) = patch(Scaling*vy+Offset, vx, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        %set(h(end), 'EdgeColor', IconColor);
        
    elseif isfield(THERING{i},'PolynomB') && length(THERING{i}.PolynomB)>3 && (THERING{i}.PolynomB(4) || any(strcmpi(THERING{i}.FamName,{'Octupole','OCTU'})))
        % Octupole
        NumberOfFinds = NumberOfFinds + 1;
        if THERING{i}.PolynomB(4)>0
            % Focusing octupole
            IconHeight = .6;
            IconColor = [0 .5 .5];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        else
            % Defocusing octupole
            IconHeight = .6;
            IconColor = [.5 .5 0];
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos          SPos+.33*IconWidth  SPos+.66*IconWidth  SPos+IconWidth   SPos+IconWidth   SPos+.66*IconWidth  SPos+.33*IconWidth      SPos          SPos];
            vy = [IconHeight/3      IconHeight          IconHeight        IconHeight/3    -IconHeight/3      -IconHeight          -IconHeight     -IconHeight/3  IconHeight/3];
        end
        h(length(h)+1) = patch(Scaling*vy+Offset, vx, IconColor,'LineStyle','-', 'Parent',hAxes);
        set(h(end), 'UserData', i);
        %if IconWidth < .1 % meters
        %    set(h(end), 'EdgeColor', IconColor);
        %end
        %set(h(end), 'EdgeColor', IconColor);
        
    elseif (isfield(THERING{i},'Frequency') && isfield(THERING{i},'Voltage')) || any(strcmpi(THERING{i}.FamName,{'Cavity','RFCavity'}))
        % RF cavity
        NumberOfFinds = NumberOfFinds + 1;
        IconColor = [1 0.5 0];
        if THERING{i}.Length == 0
            h(length(h)+1) = plot(hAxes, 0+Offset, SPos, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 4);
        else
            IconHeight = .15;
            IconWidth = THERING{i}.Length;
            if IconWidth < MinIconWidth    % meters
                IconWidth = MinIconWidth;
                SPos = SPos - IconWidth/2 + THERING{i}.Length/2;
            end
            vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
            vy = [IconHeight IconHeight -IconHeight -IconHeight];
            h(length(h)+1) = patch(Scaling*vy+Offset, vx, IconColor,'LineStyle','-', 'Parent',hAxes);
            set(h(end), 'EdgeColor', IconColor);
        end
        set(h(end), 'UserData', i);
        
    elseif strcmpi(THERING{i}.FamName,'BPM')
        % BPM
        NumberOfFinds = NumberOfFinds + 1;
        IconColor = 'k';
        h(length(h)+1) = plot(hAxes, 0+Offset, SPos, '.', 'Color', IconColor);
        %h(length(h)+1) = popplot1(hAxes, 0, SPos, 'o', 'MarkerFaceColor', IconColor, 'Color', IconColor, 'MarkerSize', 1.5)
        set(h(end), 'UserData', i);
        
    elseif CorrectorFlag && any(strcmpi(THERING{i}.FamName,{'VCM'})) && isfield(THERING{i},'KickAngle')
        % Corrector
        NumberOfFinds = NumberOfFinds + 1;
        
        IconWidth = THERING{i}.Length;
        IconHeight = 1.1;
        vx = [SPos   SPos];
        
        % Should draw a line above for a HCM and below for a VCM
        % for now draw a line above and below
        IconColor = [0 0 0];
        vy = [-IconHeight 0];
        if IconWidth < MinIconWidth
            h(length(h)+1) = plot(hAxes, Scaling*vy+Offset, vx, 'Color', IconColor, 'LineWidth', 1.5);
        else
            IconWidth = THERING{i}.Length;
            vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
            vy = [0 0 -IconHeight -IconHeight];
            %vy = [IconHeight IconHeight -IconHeight -IconHeight];
            h(length(h)+1) = patch(Scaling*vy+Offset, vx, IconColor, 'LineStyle', '-', 'Parent',hAxes);
            if IconWidth < MinIconWidth*2 % meters
                set(h(end), 'EdgeColor', IconColor);
            end
        end
        set(h(end), 'UserData', i);
        
    elseif CorrectorFlag && any(strcmpi(THERING{i}.FamName,{'HCM'})) && isfield(THERING{i},'KickAngle')
        % Corrector
        NumberOfFinds = NumberOfFinds + 1;
        
        IconWidth = THERING{i}.Length;
        IconHeight = 1.1;
        vx = [SPos   SPos];
        
        IconColor = [0 0 0];
        vy = [0 IconHeight];
        if IconWidth < MinIconWidth
            h(length(h)+1) = plot(hAxes, Scaling*vy+Offset, vx, 'Color', IconColor, 'LineWidth', 1.5);
        else
            IconWidth = THERING{i}.Length;
            vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
            vy = [IconHeight IconHeight 0 0];
            %vy = [IconHeight IconHeight -IconHeight -IconHeight];
            h(length(h)+1) = patch(Scaling*vy+Offset, vx, IconColor, 'LineStyle', '-', 'Parent',hAxes);
            if IconWidth < MinIconWidth*2 % meters
                set(h(end), 'EdgeColor', IconColor);
            end
        end
        set(h(end), 'UserData', i);
        
    elseif CorrectorFlag && any(strcmpi(THERING{i}.FamName,{'COR'})) && isfield(THERING{i},'KickAngle')
        % Corrector
        NumberOfFinds = NumberOfFinds + 1;
        
        IconWidth = THERING{i}.Length;
        IconHeight = 1.1;
        vx = [SPos   SPos];
        
        IconColor = [0 0 0];
        vy = [-IconHeight IconHeight];
        if IconWidth < MinIconWidth
            h(length(h)+1) = plot(hAxes, Scaling*vy+Offset, vx, 'Color', IconColor, 'LineWidth', 1.5);
        else
            IconWidth = THERING{i}.Length;
            vx = [SPos SPos+IconWidth SPos+IconWidth SPos];
            vy = [IconHeight IconHeight -IconHeight -IconHeight];
            h(length(h)+1) = patch(Scaling*vy+Offset, vx, IconColor, 'LineStyle', '-', 'Parent',hAxes);
            if IconWidth < MinIconWidth*2 % meters
                set(h(end), 'EdgeColor', IconColor);
            end
        end
        set(h(end), 'UserData', i);
    end
end


% Leave the hold state as it was at the start
if ~HoldState
    hold(hAxes, 'off');
end

a = axis(hAxes);
axis(hAxes, [a(1:2) 0 L]);



% --------------------------------------------------------------------
function timewindow_Callback(hObject, eventdata, handles)
% hObject    handle to timewindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function timerfrequency_Callback(hObject, eventdata, handles)
% hObject    handle to timerfrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function window24h_Callback(hObject, eventdata, handles)
% hObject    handle to window24h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.window24h,'Checked','on');
    set(handles.window12h,'Checked','off');
    set(handles.window8h,'Checked','off');
    set(handles.window6h,'Checked','off');
    set(handles.window1h,'Checked','off');
end

DisplaySettings(handles);


% --------------------------------------------------------------------
function window12h_Callback(hObject, eventdata, handles)
% hObject    handle to window12h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.window24h,'Checked','off');
    set(handles.window12h,'Checked','on');
    set(handles.window8h,'Checked','off');
    set(handles.window6h,'Checked','off');
    set(handles.window1h,'Checked','off');
end
DisplaySettings(handles);

% --------------------------------------------------------------------
function window8h_Callback(hObject, eventdata, handles)
% hObject    handle to window8h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.window24h,'Checked','off');
    set(handles.window12h,'Checked','off');
    set(handles.window8h,'Checked','on');
    set(handles.window6h,'Checked','off');
    set(handles.window1h,'Checked','off');
end

DisplaySettings(handles);

% --------------------------------------------------------------------
function window6h_Callback(hObject, eventdata, handles)
% hObject    handle to window6h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.window24h,'Checked','off');
    set(handles.window12h,'Checked','off');
    set(handles.window8h,'Checked','off');
    set(handles.window6h,'Checked','on');
    set(handles.window1h,'Checked','off');
end

DisplaySettings(handles);


% --------------------------------------------------------------------
function window1h_Callback(hObject, eventdata, handles)
% hObject    handle to window1h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.window24h,'Checked','off');
    set(handles.window12h,'Checked','off');
    set(handles.window8h,'Checked','off');
    set(handles.window6h,'Checked','off');
    set(handles.window1h,'Checked','on');
end

DisplaySettings(handles);



% --------------------------------------------------------------------
function RemoveBPMx_Callback(hObject, eventdata, handles)
% Callback for Reomve BPMx Menu item
% Update list of BPMx to PLot/ not to PLot
% Update graph

% error here???
%editlist(family2dev('BPMx'), 'BPMx', family2status('BPMx'))
oldlist = getappdata(handles.figure1, 'PlotDeviceList');
CheckList = oldlist(:,4);
%[newlist, index] = editlist(getbpmlist('BPMx', 'Bergoz'),'BPMx');
[newlist, index, CloseFlag] = editlist(getbpmlist('BPMx', 'Bergoz', 'UserDisplay'),'BPMx',CheckList);
if(~CloseFlag)
    oldlist(:, 4)=0; % first reset all to 0
    oldlist(index, 4)=1;% set present rows to one
    setappdata(handles.figure1, 'PlotDeviceList',oldlist);
else
    return
end
plotachiveddata(handles,1);
%AutoScaleAxis1y(handles,1);

%first clear any existing Marked line on 3 graphs
hlineSet = getappdata(handles.figure1, 'LineHandlesSet');
items = getappdata(handles.figure1, 'LabelXItems'); 
for p=1:3
    hline = hlineSet{p};
    for i = 1:length(hline)
        if(find(index == i))
            set(hline(i), 'Marker', 'none');
            jText = getappdata(handles.figure1, 'jText');
            jText.setText('Mouse click on line to display channel info');
            set(items(i), 'Enable', 'On');
        else
            set(items(i), 'Enable', 'Off');
        end
    end
end

DisplaySettings(handles);



% --------------------------------------------------------------------
function RemoveBPMy_Callback(hObject, eventdata, handles)
% Callback for Reomve BPMx Menu item
% Update list of BPMy to PLot/ not to PLot
% Update graph.

oldlist = getappdata(handles.figure1, 'YPlotDeviceList');
CheckList = oldlist(:,4);
[newlist, index, CloseFlag] = editlist(getbpmlist('BPMy', 'Bergoz', 'UserDisplay'),'BPMy',CheckList);
if(~CloseFlag)
    oldlist(:, 4)=0; % first reset all to 0
    oldlist(index, 4)=1;% set present rows to one
    setappdata(handles.figure1, 'YPlotDeviceList',oldlist);
else
    return
end
plotachiveddata(handles,2);
AutoScaleAxis1y(handles,2);

%first clear any existing Marked line on 3 graphs
hlineSet = getappdata(handles.figure1, 'LineHandlesSet');
% if BPM removed, disable corresponding menu item on context menu
items = getappdata(handles.figure1, 'LabelYItems'); 
for p=1:3
    hline = hlineSet{p};
    for i = 1:length(hline)
        if(find(index == i))
            set(hline(i), 'Marker', 'none');
            jText = getappdata(handles.figure1, 'jText');
            jText.setText('Mouse click on line to display channel info');
            set(items(i), 'Enable', 'On');
        else           
            set(items(i), 'Enable', 'Off');
        end
    end
end
DisplaySettings(handles);


%----------------------------------------------------------------------
% called by the timer to post a png image of the gui to a web page.
%----------------------------------------------------------------------
function WriteToWebPage(handles)


if ispc
    % this is path for Windows
    ImageDir = '\\Als-filer\alswebdata\mainpage\';
%     ImageDir = '\\Als-filer\alswebdata\cr\';% testing
else
    ImageDir = '/home/als2/www/htdoc/dynamic_pages/incoming/mainpage/';
%     ImageDir = '/home/als2/www/htdoc/dynamic_pages/incoming/cr/'; % testing
end

%Testing
% ImageDir = '\\Als-filer\physbase\machine\ALS\Common\';

f2 = 'Graphit_SRBPM';
f3 = 'Graphit_SRBPM10Min';

% set first hidden figure
h2 = getappdata(handles.figure1, 'PrintFigure');
clf(h2);

% copy to hidden figure for printing
% but exclude menu bar and toolbar
h2handles(1) = copyobj(handles.InfoWindow, h2);


h2handles(2) = copyobj(handles.axes1, h2);
h2handles(3) = copyobj(handles.axes2, h2);
h2handles(4) = copyobj(handles.axes3, h2);
h2handles(5) = copyobj(handles.LatticeAxes, h2);
h2handles(6) = copyobj(handles.LatticeAxes2, h2);
h2handles(7) = copyobj(handles.MMPerDivision1, h2);
h2handles(8) = copyobj(handles.MMPerDivision1Unit, h2);
h2handles(9) = copyobj(handles.MMPerDivision2, h2);
h2handles(10) = copyobj(handles.MMPerDivision2Unit, h2);
h2handles(11) = copyobj(handles.MMPerDivision3, h2); 
h2handles(12) = copyobj(handles.MMPerDivision3Unit, h2);

setappdata(handles.figure1, 'HiddenFigureHandles',h2handles);
% reset axis for hidden figure before printing
resetHiddenGraph(handles);
drawnow

% jpeg will be the same size as what is on the screen
% This could be trouble, we might want to force the position width and height???

set(h2,'PaperPositionMode','Auto');
set(h2,'InvertHardcopy','off');

try
   
    print(h2, '-dpng', '-r90', [ImageDir, f2], '-loose');

catch ME
    jLabel = getappdata(handles.figure1, 'jLabel');
    jLabel.setForeground(java.awt.Color.red);
    jLabel.setText('Error writing to Web Page');
    fprintf('\nError writing to %s %s \n\n',ImageDir , ME.message);
end

% reset axis for hidden figure before printing
% now just display the last 10 minutes and print
resetHiddenGraph10Min(handles);
drawnow
try
   
    print(h2, '-dpng', '-r90', [ImageDir, f3], '-loose');
    
catch ME
    jLabel = getappdata(handles.figure1, 'jLabel');
    jLabel.setForeground(java.awt.Color.red);
    jLabel.setText('Error writing to Web Page');
    fprintf('\nError writing to %s %s \n\n',ImageDir , ME.message);
end



% reset Axis to initial values from saved values
% [for hidden figure to be printed for web page]
% YLim values saved at start up.
function resetHiddenGraph(handles)

h2 =getappdata(handles.figure1, 'PrintFigure');
h2handles = getappdata(handles.figure1, 'HiddenFigureHandles');
YLimReset = getappdata(handles.figure1, 'YLimReset');
SPosGain = getappdata(handles.figure1, 'SPosGain');

hwindow =0;
XLimit =[];


%   InfoWindow  is not printed for a matlab bug, so set invisible
set(h2handles(1),'Visible', 'Off');

% matlab bug, uicontrol  is NOT PRINTED if figure invisible,
% so need to set a textbox with DMM per division text
ann1 = annotation(h2,'textbox',get(h2handles(7),'Position'),'FontSize',10,...
'Color','Black', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'), 'Visible', 'Off');
ann11 =annotation(h2,'textbox',get(h2handles(8),'Position'),'FontSize',10,...
'Color','Black', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'), 'Visible', 'Off');
ann2 =annotation(h2,'textbox',get(h2handles(9),'Position'),'FontSize',10,...
'Color','Black', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'), 'Visible', 'Off');
ann22=annotation(h2,'textbox',get(h2handles(10),'Position'),'FontSize',10,...
'Color','Black', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'), 'Visible', 'Off');
ann3=annotation(h2,'textbox',get(h2handles(11),'Position'),'FontSize',10,...
'Color','Black', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'), 'Visible', 'Off');
ann33=annotation(h2,'textbox',get(h2handles(12),'Position'),'FontSize',10,...
'Color','Black', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'), 'Visible', 'Off');





% reset Axes1
% set X and Y Grid off
set(h2handles(2),'YGrid', 'On', 'XGrid', 'Off');
% reset original YTick
set(h2handles(2), 'YTickLabel',[]);
set(h2handles(2), 'YLimMode','manual');
set(h2handles(2), 'YLim',YLimReset.axes1);
% set(h2handles(5), 'YLim',YLimReset.Lattice);
set(h2handles(2), 'YTick',[]);
set(h2handles(2), 'YTickMode', 'Auto');
set(get(h2handles(2), 'YLabel'),'Visible', 'Off');

% Link the lattice axes
dy = get(h2handles(2), 'YLim');
set(h2handles(5), 'YLim', dy(1:2)/SPosGain);


% Display the vertical mm/div
YTick = get(h2handles(2),'YTick');
if length(YTick) > 1
    dYTick = YTick(2)-YTick(1);
    if dYTick < .1
        set(ann1, 'String', num2str(1000*dYTick));
        set(ann11, 'String', ' um/div ');
    else
        set(ann1, 'String', num2str(dYTick));
        set(ann11, 'String', ' mm/div ');
    end
    
    set(ann1, 'Visible', 'On');
    set(ann11, 'Visible', 'On');
else
    set(ann1, 'Visible', 'Off');
    set(ann11, 'Visible', 'Off');
end
drawnow;
% Use the saved limits for visible figure
% not sure if this is ok for the hidden graph
XLimit = getappdata(handles.figure1, 'XLimit');
set(h2handles(2), 'XLimMode', 'manual');
set(h2handles(2), 'XLim', XLimit);

% Now try to set the xtick on the exact hour mark...
% XLimit(2) = XLimit(2)- rem(XLmit(2), 60/60/24);
xtick1 = XLimit(1)+1/24-rem(XLimit(1), 60/60/24);
set(h2handles(2), 'XTickMode', 'Manual');%%
set(h2handles(2), 'XTick',[xtick1:2/24:XLimit(2)]);%%


set(h2handles(2), 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(h2handles(2),'XTickLabel', datestr(get(h2handles(2),'xtick'),'HH:MM'));

% reset Axes2
% set X and Y Grid off
set(h2handles(3),'YGrid', 'On', 'XGrid', 'Off');
% reset original YTick
set(h2handles(3), 'YTickLabel',[]);
set(h2handles(3), 'YLimMode','manual');
set(h2handles(3), 'YLim',YLimReset.axes2);
% set(h2handles(6), 'YLim',YLimReset.Lattice2);
set(h2handles(3), 'YTick',[]);
set(h2handles(3), 'YTickMode', 'Auto');
set(get(h2handles(3), 'YLabel'),'Visible', 'Off');

% Link the lattice axes
dy = get(h2handles(3), 'YLim');
set(h2handles(6), 'YLim', dy(1:2)/SPosGain);

drawnow;
set(h2handles(3), 'XLimMode', 'manual');
set(h2handles(3), 'XLim', XLimit);


% Now try to set the xtick on the exact hour mark...
% XLimit(2) = XLimit(2)- rem(XLmit(2), 60/60/24);
xtick1 = XLimit(1)+1/24-rem(XLimit(1), 60/60/24);
set(h2handles(3), 'XTickMode', 'Manual');%%
set(h2handles(3), 'XTick',[xtick1:2/24:XLimit(2)]);%%

set(h2handles(3), 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(h2handles(3),'XTickLabel', datestr(get(h2handles(3),'xtick'),'HH:MM'));

% Display the vertical mm/div
YTick = get(h2handles(3),'YTick');
if length(YTick) > 1
    dYTick = YTick(2)-YTick(1);
    if dYTick < .1
        set(ann2, 'String', num2str(1000*dYTick));
        set(ann22, 'String', ' um/div ');
    else
        set(ann2, 'String', num2str(dYTick));
        set(ann22, 'String', ' mm/div ');
    end
    
    set(ann2, 'Visible', 'On');
    set(ann22, 'Visible', 'On');
else
    set(ann2, 'Visible', 'Off');
    set(ann22, 'Visible', 'Off');
end



% Reset Axes3
% set X and Y Grid off
set(h2handles(4),'YGrid', 'Off', 'XGrid', 'Off');
% reset original YTick
set(h2handles(4), 'YTickLabel',[]);
set(h2handles(4), 'YLimMode','manual');
set(h2handles(4), 'YLim',YLimReset.axes3);

set(h2handles(4), 'YTick',[]);
set(h2handles(4), 'YTickMode', 'Auto');
set(h2handles(4), 'YTickLabelMode','Manual');
set(h2handles(4), 'YTickLabel',get(h2handles(4), 'YTick'));
drawnow;
set(h2handles(4), 'XLimMode', 'manual');
set(h2handles(4), 'XLim', XLimit);

% Now try to set the xtick on the exact hour mark...
% XLimit(2) = XLimit(2)- rem(XLmit(2), 60/60/24);
xtick1 = XLimit(1)+1/24-rem(XLimit(1), 60/60/24);
set(h2handles(4), 'XTickMode', 'Manual');%%
set(h2handles(4), 'XTick',[xtick1:2/24:XLimit(2)]);%%

set(h2handles(4), 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(h2handles(4),'XTickLabel', datestr(get(h2handles(4),'xtick'),'HH:MM'));

% Display the vertical mm/div
YTick = get(h2handles(4),'YTick');
if length(YTick) > 1
    dYTick = YTick(2)-YTick(1);
    if dYTick < .1
        set(ann3, 'String', num2str(1000*dYTick));
        set(ann33, 'String', ' um/div ');
    else
        set(ann3, 'String', num2str(dYTick));
        set(ann33, 'String', ' mm/div ');
    end
    
    set(ann3, 'Visible', 'On');
    set(ann33, 'Visible', 'On');
else
    set(ann3, 'Visible', 'Off');
    set(ann33, 'Visible', 'Off');
end

% matlab bug, uicontrol (InfoWindow) is NOT PRINTED if figure invisible,
% so need to set a textbox with InfowWindow text
h2handles(13) = annotation(h2,'textbox',get(h2handles(1),'Position'),...
    'String',sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))),'FontSize',12,...
'Color','Blue', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'));
setappdata(handles.figure1, 'HiddenFigureHandles', h2handles);

drawnow;


% Reset hidden figure XLimit to display only last 10 minutes
% for printing
function resetHiddenGraph10Min(handles)

hfhandles = getappdata(handles.figure1, 'HiddenFigureHandles');

% reset Axes1 XLimit only

% drawnow;
% Use the saved limits for visible figure
% not sure if this is ok for the hidden graph
XLimit = getappdata(handles.figure1, 'XLimit');
set(hfhandles(2), 'XLimMode', 'manual');
XLimit = [XLimit(2)-10/60/24, XLimit(2)];% last 10 minutes only
set(hfhandles(2), 'XLim', XLimit);

% now try to set ticks on the exact hours/minutes mark...
set(hfhandles(2), 'XTickMode', 'Manual');%%
xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
set(hfhandles(2), 'XTick', [xtick1:1/60/24:XLimit(2)]);%%

set(hfhandles(2), 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(hfhandles(2),'XTickLabel', datestr(get(hfhandles(2),'xtick'),'HH:MM:SS'));

% reset Axes2 XLimit
set(hfhandles(3), 'XLimMode', 'manual');
set(hfhandles(3), 'XLim', XLimit);

% now try to set ticks on the exact hours/minutes mark...
set(hfhandles(3), 'XTickMode', 'Manual');%%
xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
set(hfhandles(3), 'XTick', [xtick1:1/60/24:XLimit(2)]);%%

set(hfhandles(3), 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(hfhandles(3),'XTickLabel', datestr(get(hfhandles(3),'xtick'),'HH:MM:SS'));



% Reset Axes3 XLimit
set(hfhandles(4), 'XLimMode', 'manual');
set(hfhandles(4), 'XLim', XLimit);

% now try to set ticks on the exact hours/minutes mark...
set(hfhandles(4), 'XTickMode', 'Manual');%%
xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
set(hfhandles(4), 'XTick', [xtick1:1/60/24:XLimit(2)]);%%

set(hfhandles(4), 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(hfhandles(4),'XTickLabel', datestr(get(hfhandles(4),'xtick'),'HH:MM:SS'));


% matlab bug, uicontrol (InfoWindow) is NOT PRINTED if figure invisible,
% so need to set a textbox with InfowWindow text
% reset 10 Minutes time interval in the annotation text box used for
% InfoWindow
set(hfhandles(13),'String',sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))),'FontSize',12);
drawnow;



% Called when user presses the <<P>> button on the toolbar.
% PLot data for selected date interval
% Date/Time interval is set by user
% with T1 T2 buttons on toolbar
% disable toolbar buttons while plotting interval.
% --------------------------------------------------------------------
function PlotInterval_ClickedCallback(hObject, eventdata, handles)

% T1/T2 matlab time
% conversion from  matlab time to archiver time in LoadData
T1Time = getappdata(handles.figure1, 'PlotT1Time');
T2Time = getappdata(handles.figure1, 'PlotT2Time');

jLabel = getappdata(handles.figure1, 'jLabel');

% ignore future time
if(T1Time > now)
    
    jLabel.setForeground(java.awt.Color.red);
    jLabel.setText(sprintf('%s',strcat('[T1 Not Valid Date:' , datestr(T1Time),']')));
    
    drawnow;
    return;
elseif(T2Time > now)
    
    jLabel.setForeground(java.awt.Color.red);
    jLabel.setText(sprintf('%s',strcat('[T2 Not Valid Date:' , datestr(T2Time),']')));
    
    drawnow;
    return;
end



stringT2 = datestr(T1Time);
stringT1 = datestr(T2Time);
if(~isempty(stringT1) && ~isempty(stringT2) )
    
    jLabel.setForeground(java.awt.Color.blue);
    jLabel.setText(sprintf('%s',strcat('[T1=',stringT1,'/', 'T2=' , stringT2,']')));
    
elseif(~isempty(stringT1))
    
    jLabel.setForeground(java.awt.Color.blue);
    jLabel.setText(sprintf('%s',strcat('[T1=' , stringT1,']')));
    
elseif(~isempty(stringT2))
    
    jLabel.setForeground(java.awt.Color.blue);
    jLabel.setText(sprintf('%s',strcat('[T1=' , stringT2,']')));
    
end




% EndTime / StartTime is matlab time
% Convert time back to seconds
% also user might invert start and end time
% so make it positive !!!
TimeBack = abs(T1Time - T2Time)*24*60*60;
% now determine End Time for Time Interval to PLot
if(T1Time > T2Time)
    
    EndTime = T1Time;
    
elseif(T1Time < T2Time)
    
    EndTime = T2Time;
    
else
    
    jLabel.setForeground(java.awt.Color.red);
    jLabel.setText(sprintf('%s','Please set T1 T2 for Time Interval'));
    
    return;
    
end


% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles);


LoadData(handles, TimeBack,EndTime);
AutoScaleAxis_Callback(hObject, eventdata, handles);


% disable toolbar buttons  while plotting
EnableToolBarButtons(handles);





% Called when user presses the <<T2>> button on the toolbar.
% A DatePicker widget is displayed for user to select T2 time for
% PLot interval.
% --------------------------------------------------------------------
function T2TimePlot_ClickedCallback(hObject, eventdata, handles)

T2 = getappdata(handles.figure1,'PlotT2Time');
if(~isempty(T2))
    T2 = uigetdate(T2,'   T2');
else
    T2 = uigetdate(now,'   T2');
end

setappdata(handles.figure1,'PlotT2Time',T2);

% display T2 info Tooltip
if(~isempty(T2))
    set(handles.T2TimePlot,'Tooltip',datestr(T2));
else
    set(handles.T2TimePlot,'Tooltip','T2 Time to Plot');
end

% display T2 info in Tiemer Info window
T1string = datestr(getappdata(handles.figure1,'PlotT1Time'));

if(~isempty(T1string))
    
    jLabel = getappdata(handles.figure1, 'jLabel');
    jLabel.setForeground(java.awt.Color.blue);
    jLabel.setText(sprintf('%s',strcat('[T1=',T1string,'-', 'T2=' , datestr(T2),']')));
    
else
    jLabel = getappdata(handles.figure1, 'jLabel');
    jLabel.setForeground(java.awt.Color.blue);
    jLabel.setText(sprintf('%s',strcat('[T2=' , datestr(T2),']')));
    
end

drawnow;



% Called when user presses the <<T1>> button on the toolbar.
% A DatePicker widget is displayed for user to select T1 time for
% PLot interval.
% --------------------------------------------------------------------
function T1TimePlot_ClickedCallback(hObject, eventdata, handles)


T1 = getappdata(handles.figure1,'PlotT1Time');
if ~isempty(T1)
    % start date picker widget with latest time set
    T1 = uigetdate(T1, '   T1');
else
    T1 = uigetdate(now, '   T1');
end
setappdata(handles.figure1,'PlotT1Time',T1);

% display T1 info Tooltip
if(~isempty(T1))
    set(handles.T1TimePlot,'Tooltip',datestr(T1));
else
    set(handles.T1TimePlot,'Tooltip','T1 Time to Plot');
end

T2string = datestr(getappdata(handles.figure1,'PlotT2Time'));

if(~isempty(T2string))
    
    jLabel = getappdata(handles.figure1, 'jLabel');
    jLabel.setForeground(java.awt.Color.blue);
    jLabel.setText(sprintf('%s',strcat('[T1=',datestr(T1),'-', 'T2=' , T2string,']')));
    
else
    
    jLabel = getappdata(handles.figure1, 'jLabel');
    jLabel.setForeground(java.awt.Color.blue);
    jLabel.setText(sprintf('%s',strcat('[T1=' , datestr(T1),']')));
    
end

drawnow;



% update MMPerDivision Display next to corresponding PLot
function DisplayMMPerDivision(handles,axesh)

if(axesh == handles.axes1)
    MMPerDivision = handles.MMPerDivision1;
    MMPerDivisionUnit = handles.MMPerDivision1Unit;
elseif(axesh == handles.axes2)
    MMPerDivision = handles.MMPerDivision2;
    MMPerDivisionUnit = handles.MMPerDivision2Unit;
elseif(axesh == handles.axes3)
    MMPerDivision = handles.MMPerDivision3;
    MMPerDivisionUnit = handles.MMPerDivision3Unit;
end

% Display the vertical mm/div
YTick = get(axesh,'YTick');
if length(YTick) > 1
    dYTick = YTick(2)-YTick(1);
    if dYTick < .1
        set(MMPerDivision, 'String', num2str(1000*dYTick));
        set(MMPerDivisionUnit, 'String', ' um/div ');
    else
        set(MMPerDivision, 'String', num2str(dYTick));
        set(MMPerDivisionUnit, 'String', ' mm/div ');
    end
    
    set(MMPerDivision, 'Visible', 'On');
    set(MMPerDivisionUnit, 'Visible', 'On');
else
    set(MMPerDivision, 'Visible', 'Off');
    set(MMPerDivisionUnit, 'Visible', 'Off');
end


drawnow;


% override default data tips function
function [txt]= updatedatacursor(empt,event_obj)
% Customizes text of data tips
% could be in m-file.

%this should display only existing datapoints
% in data set like the line marker.

Data = get(event_obj.Target, 'XData');
% get(envent_obj.Target, 'UserData') -> line number
pos = get(event_obj,'Position');
if(find(Data == pos(1))>0)
    txt = {['Time: ',datestr(pos(1))],['Value: ',num2str(pos(2))]};
else
    txt = {['Time:Not a real point ',datestr(pos(1))],['Value: ',num2str(pos(2))]};
end


% Enable YZoom Toggle Button.
% Set ButtonDown Function to YZoom.
% Disable XY Zoom Toggle Button.
% --------------------------------------------------------------------
function YZoomToggle_OnCallback(hObject, eventdata, handles)
% hObject    handle to YZoomToggle (see GCBO)

if( strcmpi(get(handles.ZoomToggle,'State'),'On'))
    set(handles.ZoomToggle, 'State','Off');
end

YZoomCallBack   = getappdata(handles.figure1, 'YZoomCallBack');
hlineSet        = getappdata(handles.figure1, 'LineHandlesSet');


% for the 3 graphs
for p=1:3
    hline = hlineSet{p};
    
    for i = 1:length(hline)
        set(hline(i), 'ButtonDownFcn', YZoomCallBack);
        
        % Turn off line identification
        set(hline(i), 'Marker', 'none');
    end
end
%set(handles.IDLine, 'Visible', 'Off');
jText = getappdata(handles.figure1, 'jText');
jText.setText(' ');
set(handles.axes1, 'ButtonDownFcn', YZoomCallBack);
set(handles.axes2, 'ButtonDownFcn', YZoomCallBack);
set(handles.axes3, 'ButtonDownFcn', YZoomCallBack);



% Enable YZoom Toggle Button.
% --------------------------------------------------------------------
function YZoomToggle_OffCallback(hObject, eventdata, handles)
% hObject    handle to YZoomToggle (see GCBO)

IDLineCallBack = getappdata(handles.figure1, 'IDLineCallBack');
hlineSet          = getappdata(handles.figure1, 'LineHandlesSet');

% for the 3 graphs
for p=1:3
    hline = hlineSet{p};
    for i = 1:length(hline)
        set(hline(i), 'ButtonDownFcn', IDLineCallBack);
    end
end

if( strcmpi(get(handles.ZoomToggle,'State'),'Off'))
    jText = getappdata(handles.figure1, 'jText');
    jText.setText('Mouse click on line to display channel info');
end
set(handles.axes1, 'ButtonDownFcn', '');
set(handles.axes2, 'ButtonDownFcn', '');
set(handles.axes3, 'ButtonDownFcn', '');



function YAxesButtonDown_Callback(hObject, eventdata, handles)
% s = getappdata(handles.figure1, 'SPosition');
SPosGain = getappdata(handles.figure1, 'SPosGain');  % Should be a menu
if strcmpi(get(handles.SPosShift, 'Checked'),'Off')
    SPosGain = 1;
end


% If the mouse is on a line, then switch the handle to the axes
if ~any(hObject == [handles.axes1 handles.axes2 handles.axes3])
    hObject = get(hObject,'parent');
end


if(hObject == handles.axes1)
    % Axis resize
    point1 = get(handles.axes1,'CurrentPoint');  % button down detected
    finalRect = rbbox;                           % return figure units
    point2 = get(handles.axes1,'CurrentPoint');  % button up detected
    point1 = point1(1,1:2);                      % extract x and y
    point2 = point2(1,1:2);
    pp1 = min(point1,point2);                    % calculate locations
    pp2 = max(point1,point2);                    % calculate locations
    offset = abs(point1-point2);                 % and dimensions
    
    yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];
    
    if any((point2-point1)==0)
        % Auto scale the graph
        YAutoScaleAxis_Callback(hObject, eventdata, handles);
        
    else
        
        dy = [pp1(2) pp2(2)];
        
        set(handles.axes1, 'YLim', dy);
        %datestr(get(handles.axes1, 'XLim'))
        
        set(handles.LatticeAxes, 'YLim', dy(1:2)/SPosGain);
        
        %get(handles.LatticeAxes, 'YLim')
        setappdata(handles.figure1, 'AutoScaleX', 'On');
        setappdata(handles.figure1, 'AutoScaleY', 'Off');
    end
    
    
    % Display the vertical mm/div
    DisplayMMPerDivision(handles,handles.axes1);
    
elseif(hObject== handles.axes2)
    
    % Axis resize
    point1 = get(handles.axes2,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(handles.axes2,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    pp1 = min(point1,point2);            % calculate locations
    pp2 = max(point1,point2);            % calculate locations
    offset = abs(point1-point2);         % and dimensions
    
    yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];
    
    if any((point2-point1)==0)
        % Auto scale the graph
        YAutoScaleAxis_Callback(hObject, eventdata, handles);
    else
        dy = [pp1(2) pp2(2)];
        
        set(handles.axes2, 'YLim', dy);
        
        set(handles.LatticeAxes2, 'YLim', dy(1:2)/SPosGain);
        
        setappdata(handles.figure1, 'AutoScaleX', 'On');
        setappdata(handles.figure1, 'AutoScaleY', 'Off');
    end
    
    
    % Display the vertical mm/div
    DisplayMMPerDivision(handles,handles.axes2);
    
elseif(hObject== handles.axes3)
    
    % Axis resize
    point1 = get(handles.axes3,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(handles.axes3,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    pp1 = min(point1,point2);            % calculate locations
    pp2 = max(point1,point2);            % calculate locations
    offset = abs(point1-point2);         % and dimensions
    
    yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];
    
    if any((point2-point1)==0)
        % Auto scale the graph
        YAutoScaleAxis_Callback(hObject, eventdata, handles);
    else
        dy = [pp1(2) pp2(2)];
        
        set(handles.axes3, 'YLim', dy);
        
        setappdata(handles.figure1, 'AutoScaleX', 'On');
        setappdata(handles.figure1, 'AutoScaleY', 'Off');
    end
    
    
    % Display the vertical mm/div
    DisplayMMPerDivision(handles,handles.axes3);
end


% Disable Zoom.
% Reset Button Down function.
% Enable YZoomToggle Button to avoid conflict
% --------------------------------------------------------------------
function ZoomToggle_OffCallback(hObject, eventdata, handles)


IDLineCallBack = getappdata(handles.figure1, 'IDLineCallBack');
hlineSet          = getappdata(handles.figure1, 'LineHandlesSet');


for p=1:3
    
    hline = hlineSet{p};
    
    for i = 1:length(hline)
        set(hline(i), 'ButtonDownFcn', IDLineCallBack);
    end
    
end
if( strcmpi(get(handles.YZoomToggle,'State'),'Off'))
    jText = getappdata(handles.figure1, 'jText');
    jText.setText('Mouse click on line to display channel info');
end
set(handles.axes1, 'ButtonDownFcn', '');
set(handles.axes2, 'ButtonDownFcn', '');
set(handles.axes3, 'ButtonDownFcn', '');



% --------------------------------------------------------------------
function ZoomToggle_OnCallback(hObject, eventdata, handles)

if( strcmpi(get(handles.YZoomToggle,'State'),'On'))
    set(handles.YZoomToggle, 'State','Off');
end

ZoomCallBack = getappdata(handles.figure1, 'ZoomCallBack');
hlineSet     = getappdata(handles.figure1, 'LineHandlesSet');

for p=1:3
    hline = hlineSet{p};
    for i = 1:length(hline)
        set(hline(i), 'ButtonDownFcn', ZoomCallBack);
        
        % Turn off line identification
        set(hline(i), 'Marker', 'none');
    end
    
end
%set(handles.IDLine, 'Visible', 'Off');
jText = getappdata(handles.figure1, 'jText');
jText.setText('');
set(handles.axes1, 'ButtonDownFcn', ZoomCallBack);
set(handles.axes2, 'ButtonDownFcn', ZoomCallBack);
set(handles.axes3, 'ButtonDownFcn', ZoomCallBack);



% --------------------------------------------------------------------
function PopPlot1_Callback(hObject, eventdata, handles)
a = figure;

b = copyobj(handles.axes1, a);
set(b, 'Position',[0.13 0.11 0.775 0.815]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

set(b, 'XLimMode', 'auto');
set(b, 'XTickMode', 'auto');
set(b, 'XTickLabelMode', 'auto');
%XTick = get(b, 'XTick');

datetick x

set(b, 'YLimMode', 'auto');
set(b, 'YTickMode', 'auto');
set(b, 'YTickLabelMode', 'auto');

xlabel(b, 'Time');
ylabel(b, 'Horizontal Orbit [mm]');
orient portrait


% --------------------------------------------------------------------
function PopPlot2_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes2, a);
set(b, 'Position',[0.13 0.11 0.775 0.815]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

set(b, 'XLimMode', 'auto');
set(b, 'XTickLabelMode', 'auto');
set(b, 'XLimMode', 'auto');
%XTick = get(b, 'XTick');
datetick x

%set(b, 'YLimMode', 'auto');

xlabel(b, 'Time');
ylabel(b, 'Vertical Orbit [mm]');
orient portrait


% --------------------------------------------------------------------
function PopPlot3_Callback(hObject, eventdata, handles)
a = figure;
b = copyobj(handles.axes3, a);
set(b, 'Position',[0.13 0.11 0.775 0.815]);
set(b, 'ButtonDownFcn','');
set(b, 'XAxisLocation','Bottom');

set(b, 'XLimMode', 'auto');
set(b, 'XTickLabelMode', 'auto');
set(b, 'XLimMode', 'auto');
%XTick = get(b, 'XTick');
datetick x

%set(b, 'YLimMode', 'auto');

xlabel(b, 'Time');
%ylabel(b, 'ID & EPU [mm]');
orient portrait


% --------------------------------------------------------------------
function settingsDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to settingsDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Graph1ZoomInVertical.
function Graph1ZoomInVertical_Callback(hObject, eventdata, handles)
% from plotfamily
a = axis(handles.axes1);
ChangeFactor = 1.15;
del = (1/ChangeFactor-1)*(a(4)-a(3));
axis((handles.axes1), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

a = axis(handles.LatticeAxes);
ChangeFactor = 1.15;
del = (1/ChangeFactor-1)*(a(4)-a(3));
axis((handles.LatticeAxes), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

% try to use matlab zoom functions
% zoom yon;
% zoom(handles.axes1, 1.08);
% zoom(handles.LatticeAxes, 1.08);
% zoom off;
% 
setappdata(handles.figure1, 'AutoScaleY', 'Off');
DisplayMMPerDivision(handles,handles.axes1);

% --- Executes on button press in Graph1ZoomOutVertical.
function Graph1ZoomOutVertical_Callback(hObject, eventdata, handles)
% from plotfamily
a = axis(handles.axes1);
ChangeFactor = 1.15;
del = (ChangeFactor-1)*(a(4)-a(3));
axis((handles.axes1), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

a = axis(handles.LatticeAxes);
ChangeFactor = 1.15;
del = (ChangeFactor-1)*(a(4)-a(3));
axis((handles.LatticeAxes), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

setappdata(handles.figure1, 'AutoScaleY', 'Off');
DisplayMMPerDivision(handles,handles.axes1);

% --- Executes on button press in Graph2ZoomInVertical.
function Graph2ZoomInVertical_Callback(hObject, eventdata, handles)
% from plotfamily
a = axis(handles.axes2);
ChangeFactor = 1.15;
del = (1/ChangeFactor-1)*(a(4)-a(3));
axis((handles.axes2), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

a = axis(handles.LatticeAxes2);
ChangeFactor = 1.15;
del = (1/ChangeFactor-1)*(a(4)-a(3));
axis((handles.LatticeAxes2), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

setappdata(handles.figure1, 'AutoScaleY', 'Off');
DisplayMMPerDivision(handles,handles.axes2);

% --- Executes on button press in Graph2ZoomOutVertical.
function Graph2ZoomOutVertical_Callback(hObject, eventdata, handles)
% from plotfamily
a = axis(handles.axes2);
ChangeFactor = 1.15;
del = (ChangeFactor-1)*(a(4)-a(3));
axis((handles.axes2), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

a = axis(handles.LatticeAxes2);
ChangeFactor = 1.15;
del = (ChangeFactor-1)*(a(4)-a(3));
axis((handles.LatticeAxes2), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

setappdata(handles.figure1, 'AutoScaleY', 'Off');
DisplayMMPerDivision(handles,handles.axes2);


% --- Executes on button press in Graph3ZoomInVertical.
function Graph3ZoomInVertical_Callback(hObject, eventdata, handles)
a = axis(handles.axes3);
ChangeFactor = 1.15;
del = (1/ChangeFactor-1)*(a(4)-a(3));
axis((handles.axes3), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

setappdata(handles.figure1, 'AutoScaleY', 'Off');
DisplayMMPerDivision(handles,handles.axes3);

% --- Executes on button press in Graph3ZoomOutVertical.
function Graph3ZoomOutVertical_Callback(hObject, eventdata, handles)
a = axis(handles.axes3);
ChangeFactor = 1.15;
del = (ChangeFactor-1)*(a(4)-a(3));
axis((handles.axes3), [a(1) a(2) a(3)-del/2 a(4)+del/2]);
% set(hObject, 'Value', 0);

setappdata(handles.figure1, 'AutoScaleY', 'Off');
DisplayMMPerDivision(handles,handles.axes3);


% --------------------------------------------------------------------
function GraphOptions_Callback(hObject, eventdata, handles)
% hObject    handle to GraphOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function resetGraph_Callback(hObject, eventdata, handles)
% hObject    handle to resetGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

YLimReset = getappdata(handles.figure1, 'YLimReset');
SPosGain = getappdata(handles.figure1, 'SPosGain');


if strcmpi(get(handles.SPosShift, 'Checked'),'Off')

    return;
    
end


% reset Axes1
% reset original YTick
set(handles.axes1, 'YTickLabel',[]);
set(handles.axes1, 'YLimMode','manual');
set(handles.axes1, 'YLim',YLimReset.axes1);

set(handles.axes1, 'YTick',[]);
set(handles.axes1, 'YTickMode', 'Auto');

if strcmpi(get(handles.SPosShift, 'Checked'),'On')
    
     % Link the axes
    dy = get(handles.axes1, 'YLim');    
    set(handles.LatticeAxes, 'YLim', dy(1:2)/SPosGain); 
    
    set(get(handles.axes1, 'YLabel'),'Visible', 'Off');
else
    set(handles.axes1, 'YTickLabelMode','Auto');
end
% % Display the vertical mm/div
DisplayMMPerDivision(handles,handles.axes1)

% % Use the saved limits for visible figure

XLimit = getappdata(handles.figure1, 'XLimit');
set(handles.axes1, 'XLimMode', 'manual');
set(handles.axes1, 'XLim', XLimit);

set(handles.axes1, 'XTick',[]);
set(handles.axes1, 'XTickMode', 'Auto');

set(handles.axes1, 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(handles.axes1,'XTickLabel', datestr(get(handles.axes1,'xtick'),'HH:MM:SS'));

% reset Axes2
% reset original YTick
set(handles.axes2, 'YTickLabel',[]);
set(handles.axes2, 'YLimMode','manual');
set(handles.axes2, 'YLim',YLimReset.axes2);

set(handles.axes2, 'YTick',[]);
set(handles.axes2, 'YTickMode', 'Auto');

if strcmpi(get(handles.SPosShift, 'Checked'),'On')
   
    % Link the axes
    dy = get(handles.axes2, 'YLim');
    set(handles.LatticeAxes2, 'YLim', dy(1:2)/SPosGain);   
    %set(handles.LatticeAxes2, 'YLim',YLimReset.Lattice2); 

    set(get(handles.axes2, 'YLabel'),'Visible', 'Off');
    
else
    set(handles.axes2, 'YTickLabelMode','Auto');
end
% Display the vertical mm/div
DisplayMMPerDivision(handles,handles.axes2)

% Use the saved limits for visible figure
% not sure if this is ok for the hidden graph
XLimit = getappdata(handles.figure1, 'XLimit');
set(handles.axes2, 'XLimMode', 'manual');
set(handles.axes2, 'XLim', XLimit);

set(handles.axes2, 'XTick',[]);
set(handles.axes2, 'XTickMode', 'Auto');

set(handles.axes2, 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(handles.axes2,'XTickLabel',datestr(get(handles.axes2,'xtick'),'HH:MM:SS'));



% reset Axes3
% reset original YTick
set(handles.axes3, 'YTickLabel',[]);
set(handles.axes3, 'YLimMode','manual');
set(handles.axes3, 'YLim',YLimReset.axes3);

set(handles.axes3, 'YTick',[]);
set(handles.axes3, 'YTickMode', 'Auto');
set(handles.axes3, 'YTickLabelMode','Auto');

set(get(handles.axes3, 'YLabel'),'Visible', 'On');

% Display the vertical mm/div
DisplayMMPerDivision(handles,handles.axes3)

% Use the saved limits for visible figure
% not sure if this is ok for the hidden graph
XLimit = getappdata(handles.figure1, 'XLimit');
set(handles.axes3, 'XLimMode', 'manual');
set(handles.axes3, 'XLim', XLimit);
set(handles.axes3, 'XTickLabel',[]);

set(handles.axes3, 'XTick',[]);
set(handles.axes3, 'XTickMode', 'Auto');


% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(handles.axes3,'XTickLabel',datestr(get(handles.axes3,'xtick'),'HH:MM:SS'));

set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));

setappdata(handles.figure1, 'AutoScaleY', 'Off');
setappdata(handles.figure1, 'AutoScaleX', 'On');

drawnow


%Calles when the user selects the Graph/Last 10 Min options
%reset XLim to display only the latest 10 minutes in the graph.
%Currently behaves as x zoom in the last 10 minutes: i.e. if timer on
%and set10Minutes, then the graph will display the last 10 minutes and
%not autoscale x.
% --------------------------------------------------------------------
function Reset10MinGraph_Callback(hObject, eventdata, handles)
% hObject    handle to Reset10MinGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset Axes1 XLimit only

% Use the saved limits for visible figure
XLimit = getappdata(handles.figure1, 'XLimit');

% time interval is less than 10 min
if (XLimit(2)-10/60/24 <= XLimit(1)) 
    
    return;
    
end


XLimit = [XLimit(2)-10/60/24, XLimit(2)];% last 10 minutes only


setappdata(handles.figure1, 'AutoScaleX', 'Off');
    
set(handles.axes1, 'XLimMode', 'manual');
set(handles.axes1, 'XLim', XLimit);

% now try to set ticks on the exact hours/minutes mark...
set(handles.axes1, 'XTickMode', 'Manual');%%
xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
set(handles.axes1, 'XTick', [xtick1:1/60/24:XLimit(2)]);%%

set(handles.axes1, 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(handles.axes1,'XTickLabel', datestr(get(handles.axes1,'xtick'),'HH:MM:SS'));

% reset Axes2 XLimit
set(handles.axes2, 'XLimMode', 'manual');
set(handles.axes2, 'XLim', XLimit);

% now try to set ticks on the exact hours/minutes mark...
set(handles.axes2, 'XTickMode', 'Manual');%%
xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
set(handles.axes2, 'XTick', [xtick1:1/60/24:XLimit(2)]);%%

set(handles.axes2, 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(handles.axes2,'XTickLabel', datestr(get(handles.axes2,'xtick'),'HH:MM:SS'));


% Reset Axes3 XLimit
set(handles.axes3, 'XLimMode', 'manual');
set(handles.axes3, 'XLim', XLimit);

% now try to set ticks on the exact hours/minutes mark...
set(handles.axes3, 'XTickMode', 'Manual');%%
xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
set(handles.axes3, 'XTick', [xtick1:1/60/24:XLimit(2)]);%%

set(handles.axes3, 'XTickLabel',[]);
% added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
set(handles.axes3,'XTickLabel', datestr(get(handles.axes3,'xtick'),'HH:MM:SS'));

% reset 10 Minutes time interval in the InfoWindow
set(handles.InfoWindow,'String',sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));
drawnow; 
