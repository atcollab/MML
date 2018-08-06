function varargout = graphit(varargin)
% GRAPHIT M-file for graphit.fig
%      GRAPHIT, by itself, creates a new GRAPHIT or raises the existing
%      singleton*.
%
%      H = GRAPHIT returns the handle to a new GRAPHIT or the handle to
%      the existing singleton*.
%
%      GRAPHIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPHIT.M with the given input arguments.
%
%      GRAPHIT('Property','Value',...) creates a new GRAPHIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graphit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graphit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graphit

% Last Modified by GUIDE v2.5 31-May-2011 10:50:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @graphit_OpeningFcn, ...
    'gui_OutputFcn',  @graphit_OutputFcn, ...
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
end

% --- Executes just before graphit is made visible.
function graphit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graphit (see VARARGIN)

% Choose default command line output for graphit
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graphit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% Check if the MML was initialized (needed for standalone)
checkforao;


% Save the zoom button down and line identification callbacks
ZoomCallBack = @(hObject,eventdata)graphit('AxesButtonDown_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'ZoomCallBack', ZoomCallBack);

IdentifyLine_CallBack = @(hObject,eventdata)graphit('IDLine_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'IDLineCallBack', IdentifyLine_CallBack);


YZoomCallBack = @(hObject,eventdata)graphit('YAxesButtonDown_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'YZoomCallBack', YZoomCallBack);



YLabelButtonDown =  @(hObject, eventdata)graphit('Label_ButtonDownFcn',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'YLabelButtonDown', YLabelButtonDown);

DYGrid_CallBack = @(hObject,eventdata)graphit('YGrid_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'YGridCallBack', DYGrid_CallBack);


DXGrid_CallBack = @(hObject,eventdata)graphit('XGrid_Callback',hObject,eventdata,guidata(hObject));
setappdata(handles.figure1, 'XGridCallBack', DXGrid_CallBack);


% data cursor call back: override default UpdateFcn
dcm_obj = datacursormode(handles.figure1);
set(dcm_obj,'UpdateFcn',@updatedatacursor);


if(isempty(varargin))
    fprintf('Starting %s with default set up file %s.....\n',mfilename, 'graphit_setup');
    % call set up function
    [GR, Main] = graphit_setup;
elseif(length(varargin) == 2)
    
    if(strcmpi(varargin{1}, 'Web')) % call default setup file in web mode
        fprintf('Starting %s with default set up file %s..... and WebMode %s\n',mfilename, 'graphit_setup', varargin{2});
        % call set up function
        [GR, Main] = graphit_setup('Web', varargin{2});        
    else
        try
            setup = str2func(varargin{2});
            [GR, Main] = setup();
        catch ME
            fprintf('Error reading set up file %s: %s \n',varargin{2}, ME.message);
            return;
        end
    end
elseif(length(varargin) == 4)
    try
        setup = str2func(varargin{2});
        if( ~isempty(varargin{3}) && strcmpi(varargin{3},'Web'))
            WebFlag = varargin{4};
            [GR, Main] = setup('Web', WebFlag);
        else
            [GR, Main] = setup();
        end
        %         [GR, Main] = setup();
    catch ME
        fprintf('Error reading set up file %s: %s \n',varargin{2}, ME.message);
        return;
    end
end


% set this in guide
NameS = get(handles.figure1, 'Name');
if(isempty(NameS))
    NameS = mfilename;
end

% Main figure properties
if isfield(Main, 'Title')
    Main.Title = [Main.Title NameS];
    set(handles.figure1, 'Name', Main.Title);
end
if isfield(Main, 'Units')
    set(handles.figure1, 'Units', Main.Units);
end
if isfield(Main, 'Position')
   set(handles.figure1, 'Position', Main.Position); 
end
if(isfield(Main, 'DropDataAfter')) % initialize window menu
    nh = Main.DropDataAfter; % hours
    set(handles.(sprintf('window%dh', nh)), 'Checked', 'on');   
else  
   set(handles.window24h, 'Checked', 'On');% default value anyhow... 
end

% setting Web Image default values from setup file
if(isfield(Main, 'Image'))
    setappdata(handles.figure1, 'ImageFilename' , Main.Image.Filename);
    
    
    
    
    % save WriteToWebPageFlag - if flag on: start the application in Web
    % mode (disable menu / toolbar and print an image)
    WriteToWebPageFlag = Main.Image.Write;
    if(~isempty(WriteToWebPageFlag) && (strcmpi(WriteToWebPageFlag,'on') || strcmpi(WriteToWebPageFlag,'off')))
        setappdata(handles.figure1, 'WriteToWebPageFlag', Main.Image.Write);
    end
    if(strcmpi(WriteToWebPageFlag, 'On'))
        WriteToWebHowOften = Main.Image.WritePeriod;
        if(~isempty(WriteToWebHowOften) && WriteToWebHowOften >0)
            setappdata(handles.figure1, 'WriteToWebHowOften', Main.Image.WritePeriod);
        end
        
        WriteToWebTimeBack = Main.Image.TimeBack;
        if(~isempty(WriteToWebTimeBack) && WriteToWebTimeBack >0)
            setappdata(handles.figure1, 'WriteToWebTimeBack', Main.Image.TimeBack);
%               setappdata(handles.figure1, 'WriteToWebTimeBack', 8);
              
        end
    end
end

% set the axes
% tag is lost here ....from handles....
for i =1:length(GR)
    if strcmpi(GR{i}.Style, 'axes')
        % Make the axes
        h = axes('Parent', handles.figure1, ...
            'Units', 'Normalize', ...
            'Box', 'on', ...
            'Color', [1 1 1], ...
            'Position', [.1 .1 .2 .2], ...
            'Tag', sprintf('Axes%d',i), ...
            'Visible', 'on');
         
        GR{i}.Axes.Handle= h;
        guidata(hObject, h);
    end
end


% Now iterate and set plot and graphs properties
% Assuming left graph plot first(bottom), right graph plot last (top)
for i = 1:length(GR);
    
    axesh = GR{i}.Axes.Handle;
    
    % add a context menu for each Axes to show Grid Lines.
    hcontextA(i) = uicontextmenu;
    item1 = uimenu(hcontextA(i), 'Label', 'Display X Grid');
    item2 = uimenu(hcontextA(i), 'Label', 'Display Y Grid');
    set(item1, 'Callback',DXGrid_CallBack,'Tag', 'XGridMenu');
    set(item2, 'Callback',DYGrid_CallBack,'Tag', 'YGridMenu');
    set(axesh,'uicontextmenu',hcontextA(i));
    guidata(hObject,item1);
    if(~isfield(GR{i}.Data, 'Function'))
        
        clear hline;
        for k=1: size(GR{i}.Data.ChannelNames,1)
            
            hline(k) = plot(axesh, [0 1], [NaN NaN]);
            
            % save line handle
            GR{i}.Lines.Handle(k) = hline(k);
            set(axesh, 'NextPlot', 'Add');
            
            % set button down function for each line
            set(hline(k), 'ButtonDownFcn', IdentifyLine_CallBack);
            
            
        end
        
    else % Function is defined in the set up file, only one line is drawn for this graph
        
        hline(1) = plot(axesh, [0 1], [NaN NaN]);
        
        % save line handle
        GR{i}.Lines.Handle(1)= hline(1);
        set(axesh, 'NextPlot', 'Add');
        
        set(hline(1), 'ButtonDownFcn', IdentifyLine_CallBack);
    end
    
    % Set the line properties
    Fields = fieldnames(GR{i}.Line);
    for ii = 1:length(hline)
        for jj = 1:length(Fields);
            set(hline(ii), Fields{jj}, GR{i}.Line.(Fields{jj}){ii});
        end
    end
    
    % Set the label properties
    Fields = fieldnames(GR{i}.Axes);
    for k = 1:length(Fields);
        if strcmpi(Fields{k}, 'YLabel')
            hLabel = get(axesh, 'YLabel');
            
            %set(hLabel,'String', GR{i}.Axes.(Fields{k}));
            YLabelFields = fieldnames(GR{i}.Axes.YLabel);
            for jj = 1:length(YLabelFields);
                set(hLabel, YLabelFields{jj}, GR{i}.Axes.YLabel.(YLabelFields{jj}));
            end
            
            % this is used to set the topmost graph ylabel bold for each graph
            
            if(isempty(GR{i}.AssociateWith))
                set(hLabel,'FontWeight','Bold');
            else
                if(i>GR{i}.AssociateWith)
                    set(hLabel,'FontWeight','Bold');% label is bold for the active axes
                    set(axesh, 'HitTest','Off');% by default set top axes not respond to mouse click
                    set(axesh, 'UserData','ACTIVE');% flag this axes as active (L/R axes)
                end
                
            end
            % click on Left/Righ YLabel: set Left/Right axes as active
            % to respond to mouse clicks
            set(hLabel,'ButtonDownFcn' ,YLabelButtonDown);
            
            % Set the UICONTEXTMENU to the ylabel object
            % Right Click on label to see menu
            hcontext(i)=uicontextmenu;
            % do not need the parent
            % hmenu=uimenu('parent',hcontext(i));
            
            set(hLabel,'uicontextmenu',hcontext(i));
            for it =1:size(GR{i}.Data.DisplayString,1)
                
                item(it) = uimenu(hcontext(i), 'Label', GR{i}.Data.DisplayString{it});
                
                set(item(it),'Callback',IdentifyLine_CallBack, 'UserData',GR{i}.Lines.Handle(it), 'ForegroundColor', get(GR{i}.Lines.Handle(it),'Color'));
                
            end
            
            clear hcontext;
            
            
        elseif(strcmpi(Fields{k}, 'Handle'))
            
            
        else
            set(axesh, Fields{k}, GR{i}.Axes.(Fields{k}),'Tag',sprintf('Axes%d',i));
               
            
        end
        
    end
    %                     set(axesh, 'NextPlot', 'Replace');
    %                     set(axesh, 'YLimMode', 'Auto');
    %                     set(axesh, 'YTickLabel',[]);
    %                     set(axesh, 'YTickLabelMode', 'Manual');
    clear hcontextA;
   
end





setappdata(handles.figure1, 'GR', GR);

guidata(hObject, handles);


% Now Set common Axes Properties...
setappdata(handles.figure1, 'AutoScaleX', 'On');
% not clear here how this should be used
% if YLimMode manual
setappdata(handles.figure1, 'AutoScaleY', 'Off');  % ???
setappdata(handles.figure1, 'XLimit', [0 1]);

% now link all X axes
LinkXAxes(handles);



% initialize Graph Menu Options
for i =1: length(GR)
    
    axesh = GR{i}.Axes.Handle;
    
    if(strcmpi(get(axesh,'YGrid'), 'On'))
        set(handles.DisplayYGrid, 'Checked','On');
        break;
    end
    if(strcmpi(get(axesh,'XGrid'), 'On'))
        set(handles.DisplayXGrid, 'Checked','On');
        break;
    end
    
end

fprintf('   Mouse click on line to display channel info\n');

% start application in write to web mode only
if(strcmpi(getappdata(handles.figure1, 'WriteToWebPageFlag'),'On'))
    Units    = get(handles.figure1, 'Units');
    Position = get(handles.figure1, 'Position');
    h2=figure('Visible', 'off', 'Units', Units, 'Position',Position, 'Toolbar', 'None', 'MenuBar', 'None');
    setappdata(handles.figure1, 'PrintFigure',h2);
    
    % must reset figure1 as current figure
    set(0,'CurrentFigure',handles.figure1);
    
end

DisplaySettings(handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = graphit_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

if(strcmpi(getappdata(handles.figure1, 'WriteToWebPageFlag'),'On'))
    PlotAndPublish(handles);
end
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% Print Menu Item Callback
% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% platform independent dialog does not work on Paola's PC
printdlg('-setup',handles.figure1);
%printdlg('-crossplatform',handles.figure1);
end

% PrintPreview Menu Item Callback
% --------------------------------------------------------------------
function PrintPreview_Callback(hObject, eventdata, handles)
printpreview(handles.figure1);

end



% --- Executes when user attempts to close figure1.
% If running in web mode, warn user
% ask use to confirm operation
% stop the timer
% delete PrintFigure if any
function figure1_CloseRequestFcn(hObject, eventdata, handles)

if(strcmpi(getappdata(handles.figure1, 'WriteToWebPageFlag'),'On'))
     selection = questdlg(['Close ' get(handles.figure1,'Name') '? Closing the application will stop updating the web page.'],...
        ['Close ' get(handles.figure1,'Name') '...'],...
        'Yes','No','Yes');
else   
    selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
        ['Close ' get(handles.figure1,'Name') '...'],...
        'Yes','No','Yes');
end
if ~strcmp(selection,'Yes')
    return;
end


% Stop and delete the timer.

if isfield(handles,'thetimer')
    try
        stop(handles.thetimer);
        delete(handles.thetimer);
    catch ME
        
        
    end
end

% Hint: delete(hObject) closes the figure
% delete hidden figures
try
    h = getappdata(handles.figure1, 'PrintFigure');
    delete(h);
catch ME
end

delete(handles.figure1);
end



%YZoom ToggleButton Off Callback
% --------------------------------------------------------------------
function YZoomToggle_OffCallback(hObject, eventdata, handles)
% hObject    handle to YZoomToggle (see GCBO)

IDLineCallBack = getappdata(handles.figure1, 'IDLineCallBack');
GR = getappdata(handles.figure1, 'GR');


% for all the graphs
for p=1:length(GR)
    
    % set all lines of L/R graph to respond to mouse click
    AssociateWith =GR{p}.AssociateWith;
    if( ~isempty(AssociateWith) && p> GR{p}.AssociateWith)
        
        set(GR{p}.Axes.Handle, 'HitTest','Off');
        
    end
    
    for i = 1:length(GR{p}.Lines.Handle)
        set(GR{p}.Lines.Handle(i), 'ButtonDownFcn', IDLineCallBack);
        
    end
    set(GR{p}.Axes.Handle, 'ButtonDownFcn', '');
    
end

if( strcmpi(get(handles.ZoomToggle,'State'),'Off'))
    jText = getappdata(handles.figure1, 'jText');
    jText.setText('Mouse click on line to display channel info');
end


end

% --------------------------------------------------------------------
function YZoomToggle_OnCallback(hObject, eventdata, handles)
% hObject    handle to YZoomToggle (see GCBO)
if( strcmpi(get(handles.ZoomToggle,'State'),'On'))
    set(handles.ZoomToggle, 'State','Off');
end

YZoomCallBack   = getappdata(handles.figure1, 'YZoomCallBack');
GR = getappdata(handles.figure1, 'GR');

% for all the graphs
for p=1:length(GR)
    
    % reset L/R axes to no/yes to respond on mouse click
    AssociateWith =GR{p}.AssociateWith;
    if(~isempty(AssociateWith) && p> GR{p}.AssociateWith)
        if(strcmpi(get(GR{p}.Axes.Handle, 'UserData'),'ACTIVE'))
            set(GR{p}.Axes.Handle, 'HitTest','On');
        else
            set(GR{AssociateWith}.Axes.Handle, 'HitTest','On');
        end
    end
    
    
    for i = 1:length(GR{p}.Lines.Handle)
        set(GR{p}.Lines.Handle(i), 'ButtonDownFcn', YZoomCallBack);
        
        % Turn off line identification
        % set(GR{p}.Lines.Handle(i), 'Marker', 'none');
        set(GR{p}.Lines.Handle(i), 'Marker',GR{p}.Line.Marker{i,1});
    end
    set(GR{p}.Axes.Handle, 'ButtonDownFcn', YZoomCallBack);
end

jText = getappdata(handles.figure1, 'jText');
jText.setText(' ');



end




% --------------------------------------------------------------------
function ZoomToggle_OffCallback(hObject, eventdata, handles)
% hObject    handle to ZoomToggle (see GCBO)
IDLineCallBack = getappdata(handles.figure1, 'IDLineCallBack');
GR = getappdata(handles.figure1, 'GR');

% for the 3 graphs
for p=1:length(GR)
    
    % reset mouse click response for lower axes
    % so all lines can respond to mouse click
    AssociateWith =GR{p}.AssociateWith;
    if( ~isempty(AssociateWith) && p> GR{p}.AssociateWith)
        set(GR{p}.Axes.Handle, 'HitTest','Off');
    end
    
    for i = 1:length(GR{p}.Lines.Handle)
        set(GR{p}.Lines.Handle(i), 'ButtonDownFcn', IDLineCallBack);
    end
    set(GR{p}.Axes.Handle, 'ButtonDownFcn', '');
    
end

if( strcmpi(get(handles.YZoomToggle,'State'),'Off'))
    jText = getappdata(handles.figure1, 'jText');
    jText.setText('Mouse click on line to display channel info');
end


end
% --------------------------------------------------------------------
function ZoomToggle_OnCallback(hObject, eventdata, handles)
% hObject    handle to ZoomToggle (see GCBO)
if( strcmpi(get(handles.YZoomToggle,'State'),'On'))
    set(handles.YZoomToggle, 'State','Off');
end

ZoomCallBack   = getappdata(handles.figure1, 'ZoomCallBack');
GR = getappdata(handles.figure1, 'GR');

% for the 3 graphs
for p=1:length(GR)
    
    % reset L/R axes to no/yes to respond on mouse click
    AssociateWith =GR{p}.AssociateWith;
    if(~isempty(AssociateWith) && p> GR{p}.AssociateWith)
        if(strcmpi(get(GR{p}.Axes.Handle, 'UserData'),'ACTIVE'))
            set(GR{p}.Axes.Handle, 'HitTest','On');
            %set(GR{AssociateWith}.Axes.Handle, 'HitTest','On');
        else
            set(GR{AssociateWith}.Axes.Handle, 'HitTest','On');
        end
    end
    
    for i = 1:length(GR{p}.Lines.Handle)
        set(GR{p}.Lines.Handle(i), 'ButtonDownFcn', ZoomCallBack);
        %set(GR{p}.Lines.Handle(i), 'HitTest', 'Off');
        
        % Turn off line identification
        %          set(GR{p}.Lines.Handle(i), 'Marker', 'none');
        set(GR{p}.Lines.Handle(i), 'Marker',GR{p}.Line.Marker{i,1});
    end
    set(GR{p}.Axes.Handle, 'ButtonDownFcn', ZoomCallBack);
end

jText = getappdata(handles.figure1, 'jText');
jText.setText(' ');


end

% Set Reset marker for lines when selected:
% Lines could have a specific marker (other than '.')
% set in the set up file to distinguish line.
% If line selected set '.' marker; else set line marker
% (default none).
% Called:
% if user clicks on context menu of YLabel
% if user clicks on a line
% If in Zoom-In mode, return.
function IDLine_Callback(hObject, eventdata, handles)

if( strcmpi(get(handles.ZoomToggle,'State'),'On') || strcmpi(get(handles.YZoomToggle,'State'),'On'))
    return;
end



if(strcmpi(get(hObject,'Type'), 'uimenu'))
    
    hObject = get(hObject,'UserData');
    
end

GR = getappdata(handles.figure1, 'GR');

% write to Java text field in toolbar
jText = getappdata(handles.figure1, 'jText');

% logic here: in the set up file a marker other
% than '.', can be used to identify a line when not selected.
% So when deselect line need to restore line marker.
lineMarker ='None';
for p=1:length(GR)
    for i = 1:length(GR{p}.Lines.Handle)
        if(hObject == GR{p}.Lines.Handle(i))
            % retrieve line marker if any special set.
            lineMarker = GR{p}.Line.Marker{i,1};
        end
        
    end
    
end


PresentMarker = get(hObject, 'Marker');
if strcmpi(PresentMarker, '.')
    % Marker on line can be of different types....
    % when line is not selected
    if strcmpi(lineMarker, 'None')
        % Turn off line identification
        set(hObject, 'Marker', 'none');
    else
        set(hObject, 'Marker', lineMarker);
    end
    
    % This might cause memory leak....(not set allowed on JAva Obj / use java methods instead?!
    % set(jText,'text','Mouse click on line to display channel info');
    jText.setText('Mouse click on line to display channel info');
    
else
    
    displayString ='';
    %colorL = [0.25,0.25,0.7];
    % for all the graphs
    for p=1:length(GR)
        
        for i = 1:length(GR{p}.Lines.Handle)
            
            %first clear any existing Marked line on 3 graphs
            if strcmpi(get(GR{p}.Lines.Handle(i), 'Marker'), '.')
                
                set(GR{p}.Lines.Handle(i), 'Marker', 'none');
            end
            if(hObject == GR{p}.Lines.Handle(i))
                displayString =  GR{p}.Data.DisplayString{i};
                set(hObject, 'Marker', '.');
            end
            
            
        end
        
    end
    %colorL = get(hObject, 'Color');
    % write to Java text field in toolbar
    %jText.setText(sprintf('%s ',displayString));
    
%     jText.setText(displayString);
%     drawnow;
    
    
    if(~isempty(get(hObject, 'YData')) && ~(isnan(sum(get(hObject, 'YData')))))
        jText.setText(displayString);
        drawnow;
    else
       
       displayString = [displayString '-No data'];   
       jText.setText(displayString); 
       drawnow;
    end
end
drawnow;
end





function LoadData(handles, TimeBack, EndTime)
% Load new data from archiver.
%
% TimeBack [seconds]-time interval to be retrieved
% EndTime -Matlab time(datenumber) - end time for time interval to retrieve
% new data to PLot;
% Call java client to retrieve data from archiver;
% Timer:
% - EndTime is empty: set to MATLAB now (local time).
% - Concatenate new data loaded with existing data if any;
% - (drop data if old dataset older than 24 h).
% - time interval for new dataset is set by user through gui.
% - Default interval retrieval is 30 s.
% Note: the function converts to and from MATLAB local (including DST)/UTC Archiver time
% using java Calendar functions.

persistent client


% get all info for the graphs to be plot
% i.e. n. of graphs / n of channels / channels/ channel Name etc..
GR = getappdata(handles.figure1, 'GR');

% Get data already in the PLot, if any
% this should happen only for the timer
toldSet = getappdata(handles.figure1, 'ArchivedTimeSet');

% Add to the dynamic Java path (just once)
JaveDynmicJars = javaclasspath('-dynamic');
JarFile = fullfile(getmmlroot,'hlc','archiveviewer','archiveviewer.jar');
if ~any(strcmpi(JarFile, JaveDynmicJars))
    javaaddpath(JarFile);
end

rightNow = now; % matlab time reference (local time)\ EndTime for timer
indexNE = 1;

% Timer call
if nargin < 2
    EndTime =rightNow;
    % Likely from the timer callback, get time back from appdata
    TimeBack = getappdata(handles.figure1, 'DataRetrievalInterval');
    TimeWindow = getappdata(handles.figure1, 'TimerWindow');
    
    
    % Best to start from the last point in the table
    if ~isempty(toldSet)
        % find first non empty cell of old data
        indexNE = find(~cellfun(@isempty,toldSet), 1 );
        told = toldSet{indexNE};
        % TODO: change this to the max
        temp = told; % MATLAB time
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
else % not timer call, clear old data
    
    %TODO: enough or need to clear graph?!
    setappdata(handles.figure1, 'ArchivedDataSet', {});
    setappdata(handles.figure1, 'ArchivedTimeSet', {});
    
    % save start time to compute XLim for the graphs
    % as timestamps might fall outside of retrieval time
    setappdata(handles.figure1, 'ArchivedStartTime', EndTime-TimeBack/60/60/24);
    
    fprintf('Retrieving data (%.2f minutes)\n', TimeBack/60);
end
drawnow;

%UTC matlab time reference difference
DateNumber1970 = 719529;  %datenum('1-Jan-1970');

EndTimeMillisec = (EndTime-DateNumber1970)*24*60*60*1000;% EndTime in millisec (local) Pacific Time
EndTimeOffset = java.util.Calendar.getInstance.getTimeZone().getOffset(EndTimeMillisec);% time difference  (ms) between UTC and Pacific Time(local)

% convert MATLAB end time to UTC/archiver time
end_tf = (EndTime-DateNumber1970-EndTimeOffset/24/1000/60/60)*24*60*60*1000;


% save start time to compute XLim for the graphs
% as timestamps might fall outside of retrieval time
setappdata(handles.figure1, 'ArchivedEndTime', EndTime);


ngraph = length(GR);

% iterate over number of graphs
for p=1:ngraph
    
    % create channels string for the channel in the each graph
    ArchiverGetString = deblank(GR{p}.Data.ChannelNames{1});
    % N.B.: this is needed to adjust the max. n. of points per request vs batch time vs sample period (1s) of
    % some channels: for sample period >= 10s 3 hours is OK.
    k = 1;
    if any(strcmpi(deblank(GR{p}.Data.ChannelNames{k}),{'cmm:beam_current','SR05W___DCCT2__AM01','Topoff_goal_current_SP','Topoff_cam_goal_current_SP','Topoff_cam_inj_field_delta_SP','Cam1_current','Cam2_current','Gun_To_LTB_Transfer_Efficiency','LTB_To_BR_Injection_Rate','BR_To_BTS_Extracted_Charge','BTS_To_SR_Injection_Efficiency','SR04U___GDS1PS_AM00','SR04U___GDS2PS_AM00','SR05W___GDS1PS_AM00','SR06U___GDS1PS_AM00','SR06U___GDS2PS_AM00','SR07U___GDS1PS_AM00','SR07U___GDS2PS_AM00','SR08U___GDS1PS_AM00','SR09U___GDS1PS_AM00','SR10U___GDS1PS_AM00','SR11U___GDS1PS_AM00','SR11U___GDS2PS_AM00','SR12U___GDS1PS_AM00','SR04U___ODS1PS_AM00','SR04U___ODS2PS_AM00','SR06U___ODS2PS_AM00','SR07U___ODS1PS_AM00','SR07U___ODS2PS_AM00','SR11U___ODS1PS_AM00','SR11U___ODS2PS_AM00'}))
        time_batch= 45*60*1000;% beam current sample period 1s
    else
        time_batch= 3*60*60*1000; % 3 hours in ms, retrieve data in batches
    end
    for k=2: size(GR{p}.Data.ChannelNames,1)
        ArchiverGetString = [ArchiverGetString, '|', deblank(GR{p}.Data.ChannelNames{k})];
        
        if any(strcmpi(deblank(GR{p}.Data.ChannelNames{k}),{'cmm:beam_current','SR05W___DCCT2__AM01','Topoff_goal_current_SP','Topoff_cam_goal_current_SP','Topoff_cam_inj_field_delta_SP','Cam1_current','Cam2_current','Gun_To_LTB_Transfer_Efficiency','LTB_To_BR_Injection_Rate','BR_To_BTS_Extracted_Charge','BTS_To_SR_Injection_Efficiency','SR04U___GDS1PS_AM00','SR04U___GDS2PS_AM00','SR05W___GDS1PS_AM00','SR06U___GDS1PS_AM00','SR06U___GDS2PS_AM00','SR07U___GDS1PS_AM00','SR07U___GDS2PS_AM00','SR08U___GDS1PS_AM00','SR09U___GDS1PS_AM00','SR10U___GDS1PS_AM00','SR11U___GDS1PS_AM00','SR11U___GDS2PS_AM00','SR12U___GDS1PS_AM00','SR04U___ODS1PS_AM00','SR04U___ODS2PS_AM00','SR06U___ODS2PS_AM00','SR07U___ODS1PS_AM00','SR07U___ODS2PS_AM00','SR11U___ODS1PS_AM00','SR11U___ODS2PS_AM00'}))
            time_batch= 45*60*1000;% beam current sample period 1s
        end;
    end
    
    
    
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
        fprintf('\nError retrieving data %s\n',ME.message);
        drawnow;
        client=[];
        sleep(30);
        return;
    end
    fprintf('\n\n +++++++++++++++Graph n=%d \n', p);
    
    try
        ChannelSearch = client.search(x(1), ArchiverGetString, []);
    catch ME
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
            z = client.getAVEInfo(ChannelSearch(1));% at least one channel has been retrieved !!!
            
            ArchiverStartTime = z.getArchivingStartTime(); %a reference time for data in the archiver
            offS = java.util.Calendar.getInstance.getTimeZone().getOffset(ArchiverStartTime);
            if( (ArchiverStartTime+ offS)/1000/60/60/24+DateNumber1970  > getappdata(handles.figure1, 'ArchivedStartTime'))
                set(handles.InfoWindow,'Foreground', 'Red', 'String', sprintf('Archived data is only available from %s', datestr((ArchiverStartTime+offS)/1000/60/60/24+DateNumber1970)));
                return;
            end
            
            % if not all channels were retrieved, just warn user.
            % Listing all channels here, not just the ones missing...
            % TODO: change this to list just the missing channels
            if((length(ChannelSearch) <  length(GR{p}.Data.ChannelNames)))
                fprintf('Channel Not Found in Archiver [%s]', ArchiverGetString);
            end
                                  
        else % no channels found for this graph, skip graph and continue
            fprintf('No Channel Found in Archiver [%s]', ArchiverGetString);
            % skip this graph only
            % return;
            continue;
        end
    catch ME
        fprintf('\nError connecting to the Archiver %s\n\n',ME.message);
        drawnow;
        %TODO: should sleep here before trying to reconnect...
        client=[];
        sleep(30);
        return;
    end
    
    % Convert to msec
    time_interval= 1000*TimeBack;
    
    % retrieve data in batches for large interval
    % this must be coherent with max n. of points per batch = 3000
    % n. of points available in a time interval depend on the channel sampling
    % frequency
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
        fprintf('Retrieving data ... %d/%d graph n=%d/%d\n', (times-k+1),(times+1),p,(ngraph));
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
            
            %             fprintf('retrieve start time= %s \n', datestr(start_t/1000/60/60/24 + DateNumber1970 - 7/24));
            fprintf('retrieve end time= %s \n', datestr(end_t/1000/60/60/24 + DateNumber1970  + EndTimeOffset/1000/60/60/24));
            tic
            data = client.retrieveData(ChannelSearch, req_obj, []);
            fprintf('   client.retrieveData time = %.3f seconds\n', toc);
            
            if(size(data,1)<1)
                fprintf('No data found in archiver!\n\n');
                drawnow;
                % clear client;
                % return;
                % skip this graph only...
                continue;
            end
        catch ME
            fprintf('\nError connecting to the Archiver %s\n\n',ME.message);
            drawnow;
            client=[];
            sleep(30);
            return;
        end
        
        % Need to initialize this (either [] or NaN)
        % if one channel is empty then a and t size < channelsnames!!!
        t{size(GR{p}.Data.ChannelNames,1)}=[];
        a{size(GR{p}.Data.ChannelNames,1)}=[];
        
        % convert java vector to matlab cell array
        datacell = cell(data);
        
        %tic 
        % raw data * gain - offset
        %for i = 1:size(GR{p}.Data.ChannelNames,1)
        for i =1: size(datacell,1)    
            %NamesSort = char(ChannelSearch(i).getName());
            NamesSort = char(datacell{i}.getAVEntry().getName());
            
            % Names in ChannelNames cell have quotes!!
            ii = strcmp(NamesSort, GR{p}.Data.ChannelNames);
            
            %NPoints(i,1) = data(i).getNumberOfValues;
            NPoints(i,1) = datacell{i}.getNumberOfValues();
            
            for j = 1:NPoints(i)
                %  t{ii}(j) = data(i).getTimestampInMsec(j-1);
                %  a{ii}(j) = GR{p}.Data.Gain{ii}*data(i).getValue(j-1).firstElement()-GR{p}.Data.Offset{ii};
                t{ii}(j) = datacell{i}.getTimestampInMsec(j-1);
                a{ii}(j) = GR{p}.Data.Gain{ii}*datacell{i}.getValue(j-1).firstElement()-GR{p}.Data.Offset{ii};
            end
        end
               
        %fprintf('For loop time = %.3f seconds\n', toc);
        %  fprintf('\n For Loop MinT = %s',datestr(MinT/1000/60/60/24 + DateNumber1970 -7/24));       
        
        % if no data, i.e. empty data
        % check if no error: should never happen as cell array initialized
        % to empty now
        if(size(a,2) ~= size(GR{p}.Data.ChannelNames,1) || size(t,2) ~= size(GR{p}.Data.ChannelNames,1))
            fprintf('Possible Data Error\n');
        end
        
        
        % Convert time back from UTC/Archiver time to MATLAB time (Pacific
        % Time)
        % Get Time difference between UTC time and Pacific Time (including DST), this changes for
        % DST
        
        % empty not ok otherwise
        temp=t;
        temp(cellfun(@isempty,temp)) = {NaN};
        startMin = min(cellfun(@min, temp));
        
        % startMin = min(cellfun(@min, t));
        % TimeOffsetMilliSec = java.util.Calendar.getInstance.getTimeZone().getOffset(start_t);
        TimeOffsetMilliSec = java.util.Calendar.getInstance.getTimeZone().getOffset(startMin);
        % if DST changes within this time interval
        if(TimeOffsetMilliSec ~= java.util.Calendar.getInstance.getTimeZone().getOffset(end_t))
            tic
            for i = 1:size(t,2)
                if(~isempty(t{i}))
                    for kk =1: length(t{i})
                        % should return the timedifference in millisecond including daylightsaving
                        % time from UTC time to pacific time
                        dst = java.util.Calendar.getInstance.getTimeZone().getOffset(t{i}(kk));
                        t{i}(kk) = t{i}(kk)/1000/60/60/24 + DateNumber1970 + dst/1000/60/60/24;
                    end
                end
            end
            fprintf('   Convert time loop = %.3f seconds\n', toc);
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
                %if(~isempty(told))
                % first, drop data out of Time Window set in timer menu...
                % empty not ok otherwise
                temp=told;
                temp(cellfun(@isempty,temp)) = {NaN};
                toldMin = min(cellfun(@min, temp));
                %if(rightNow-told{1}(1)> TimeWindow/24)
                if(rightNow-toldMin> TimeWindow/24)   
                    index = size(told,2);
                    for i=1:index
                        m = find(told{i}<rightNow - TimeWindow/24);
                        told{i}(m)=[];
                        aold{i}(m)=[];
                    end
                    %if(p <2)
                    % use first not empty graph as reference
                    if(p == indexNE)
                        % update ArchivedStartTime
                        % This is used to set XLim Inf: it is a problem
                        % because it might reset the interval [Xlimit]
                        % too far back for some of the graphs..
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
                
                
                % if t{i} is NaN -> m =0 get just told{i}
                % told{i} empty: get new t{i}
                % what if NaN??
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
        
        % add not to overload the data server with more than one request
        % per second
        % sleep(1);
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
        if(~isempty(tToPlot{i})  && tToPlot{i}(end)< last30SecRef)
            %         if(tToPlot{i}(end)< last30SecRef)
            %                         fprintf('Found a point outside [Tinf %s]  [Tref %s EndTime %s] \n',datestr(tToPlot{i}(end)),datestr(last30SecRef),datestr(EndTime));
            tfake = last30SecRef;
            datafake = dataToPlot{i}(end);
            tToPlot{i} = [tToPlot{i} tfake];
            dataToPlot{i} = [dataToPlot{i} datafake];
            %                         fprintf('Adding fake point [T %s]  [Data %d] \n',datestr(tfake),datafake);
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
end



% Plot DATA  for the given graph.
% Data set is saved as handles application data:
% ArchivedDataSet, ArchivedTimeSet.
% If not dataset for this graph, return.
function plotachiveddata(handles,WhichGraph)
GR = getappdata(handles.figure1, 'GR');

axes =  GR{WhichGraph}.Axes.Handle;

% Tick direction -- In or Out -- Done in the setup
%set(axes, 'TickDir', 'Out');

% Get "global" data
DataSet  = getappdata(handles.figure1, 'ArchivedDataSet');
tSet     = getappdata(handles.figure1, 'ArchivedTimeSet');

% empty PLot
if(isempty(tSet))
    return;
end

Data = DataSet{WhichGraph};
t = tSet{WhichGraph};

% empty PLot
if(isempty(t))
    return;
end

% Get figure data (menues, buttons, etc.)
% Check if first point/last point/none selected from menu
if strcmpi(get(handles.FirstPoint, 'Checked'),'On')
    OffsetRemoval = 1;
elseif strcmpi(get(handles.LastPoint, 'Checked'),'On')
    OffsetRemoval = 2;
else
    OffsetRemoval =0;
end

% pass dataset to function for this graph, before plotting
% if error, log and return.
if(isfield(GR{WhichGraph}.Data, 'Function'))
    f =  GR{WhichGraph}.Data.Function;
    % function should check for valid t Data (NaN and [] values..)
    % TODO: Check this ... function might not accept NaN..
    % Also empty value for one channel -> error
    % Here you could have different n. of points per channel
    % so need to check that...
    %     [t, Data] = f(temp{:}, Values{:});
    
    % TODO: check this, need a cell array even if one cell
    try
        [t, Data] = f(t{:}, Data{:});
    catch ME
        %set(handles.InfoWindow, 'TooltipString' ,'Function Error');
        fprintf('\nError in Function %s\n\n',ME.message);
        return;
    end
    % ONLY One line should be set here.....
end

if OffsetRemoval ==1 % Subtract First Point
    % TODO: check this, need a cell array even if one value
    for i = 1:size(Data,2)
        if(~isempty(Data{i}))
            set(GR{WhichGraph}.Lines.Handle(i), 'XData', t{i}, 'YData',  Data{i} - Data{i}(1));
        end
    end
    
elseif OffsetRemoval ==2 % Subtract last point
    % TODO: check this, need a cell array even if one value
    for i = 1:size(Data,2)
        if(~isempty(Data{i}))
            set(GR{WhichGraph}.Lines.Handle(i), 'XData', t{i}, 'YData',  Data{i} - Data{i}(end));
        end
    end
    
elseif OffsetRemoval ==0 % plot raw data with no offset
    % TODO: check this, need a cell array even if one value
    for i = 1:size(Data,2)
        if(~isempty(Data{i}))
            set(GR{WhichGraph}.Lines.Handle(i), 'XData', t{i}, 'YData',  Data{i});
        end
    end
    
end

% PLot
XLimit = [Inf -Inf];

% find first non empty graph as reference to
% compute XLimits
indexNE = find(~cellfun(@isempty,tSet),1);
                
%if(WhichGraph<2)
if(WhichGraph == indexNE)    
    LinkXAxes(handles);
    
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


% fprintf('plotdataF: YLim for axes= %d', WhichGraph)
% get(axes, 'YLim')

set(axes, 'XLimMode', 'Manual');
AutoScaleX = getappdata(handles.figure1, 'AutoScaleX');
if strcmpi(AutoScaleX, 'On')
    set(axes, 'XLim', XLimit);
end

% Change the date string
set(axes, 'XTickLabel',[]);
set(axes, 'XTickLabelMode', 'Manual');
set(axes, 'XTickLabel', datestr(get(axes,'XTick'),'HH:MM:SS'));


% TODO: check this, if printing year/mm/dd is wrong....
% datestr(get(handles.axes1,'xticklabel'),'yyyy-mm-dd HH:MM:ss')
% set(axes,'xticklabel', datestr(get(handles.axes1,'xtick'),'YYYY-MM-DD HH:mm:ss'));
drawnow;
end

% This function is called when the user clicks on one of axes.
% If in Zoom Mode then, graph is xy zoomed ( if not only one point).
function AxesButtonDown_Callback(hObject, eventdata, handles)

sel_typ = get(gcbf,'SelectionType');
switch sel_typ
    case 'normal'
        GR = getappdata(handles.figure1, 'GR');
        for i=1:length(GR)
            axesh = GR{i}.Axes.Handle;
            % If the mouse is on a line, then switch the handle to the axes
            if(hObject == axesh || get(hObject,'parent') == axesh)
                
                % Axis resize
                point1 = get(axesh,'CurrentPoint');  % button down detected
                finalRect = rbbox;                           % return figure units
                point2 = get(axesh,'CurrentPoint');  % button up detected
                point1 = point1(1,1:2);                      % extract x and y
                point2 = point2(1,1:2);
                pp1 = min(point1,point2);                    % calculate locations
                pp2 = max(point1,point2);                    % calculate locations
                offset = abs(point1-point2);                 % and dimensions
                xx = [pp1(1) pp1(1)+offset(1) pp1(1)+offset(1) pp1(1) pp1(1)];
                yy = [pp1(2) pp1(2) pp1(2)+offset(2) pp1(2)+offset(2) pp1(2)];
                
                if any((point2-point1)==0)
                    % Auto scale the graph
                    AutoScaleAxis_Callback(hObject, eventdata, handles);
                else
                    dx = [pp1(1) pp2(1)];
                    dy = [pp1(2) pp2(2)];
                    
                    
                    % set YLim-> YLim mode manual for this graph
                    set(axesh, 'XLim', dx);
                    set(axesh, 'YLim', dy);
                    for p=1:length(GR)
                        
                        axesH = GR{p}.Axes.Handle;
                        set(axesH,'xticklabel', datestr(get(axesH,'xtick'),'HH:MM:SS'));
                    end
                    
                    %Align Left and Right YTicks for pair axes
                    AssociatedWith = GR{i}.AssociateWith;
                    if(~isempty(AssociatedWith) )
                        AlignLeftAndRightYTicks(GR,i);
                    else
                        % Let MATLAB set the YTicks for single graphs.
                        set(axesh, 'YTickMode', 'Auto');
                        set(axesh, 'YTickLabelMode', 'Auto');
                    end
                    
                    % TODO: is this necessary here?
                    % This needs to be reset to manual so if Yzoom in and timer on
                    % the yzoom is mantained (same as the AutoscaleY off)
                    set(axesh, 'YLimMode','manual');
                    setappdata(handles.figure1, 'AutoScaleX', 'Off');
                    
                    drawnow;
                    break;
                end
            end
        end
        
        % Now need to reset the YTicks for the other graphs
        % only for paired graphs: this is needed otherwise the
        % as the user zooms in on one graph, the YTicks on the
        % other graph might disappear (or reduce to just one YTick)...
        for p=1:length(GR)
            axesh = GR{p}.Axes.Handle;
            if(hObject ~= axesh && get(hObject,'parent') ~= axesh)
                AlignLeftAndRightYTicks(GR, p);
            end
        end
        
        XLimit = get(GR{1}.Axes.Handle, 'XLim');
        set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));
        drawnow;
end
end


% This function is called:
% when the user clicks on Zoom Out Button (all graphs are autoscaled xy);
% when in Zoom Mode the user single clicks on the graph (only that graph is
% autoscaled y - all graphs are autoscaled x);
%--------------------------------------------------------------------
function AutoScaleAxis_Callback(hObject, eventdata, handles)

% Expand to full axis then put the y-axes back to manual
GR = getappdata(handles.figure1, 'GR');


for i=1:length(GR)
    
    axesh = GR{i}.Axes.Handle;
    
    % Autoscale the vertical:only for the axes where the user clicks on and
    % for all axes if user presses zoom out button
    if(hObject == axesh || strcmpi(get(hObject,'Type'),'uipushtool'))
        % zoom out-> let autoscale
        set(axesh, 'YLimMode', 'auto');
    else
        set(axesh, 'YLimMode', 'manual');
    end
    
    
    % Use the saved limits
    XLimit = getappdata(handles.figure1, 'XLimit');
    
    set(axesh, 'XLimMode', 'manual');
    set(axesh, 'XLim', XLimit);
    
    
    set(axesh, 'XTickLabel',[]);
    %     set(axesh, 'XTickLabelMode', 'Manual');
    
    % TODO: check this
    % added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
    set(axesh,'XTickLabel', datestr(get(axesh,'xtick'),'HH:MM:SS'));
    
    % Autoscale future updates
    setappdata(handles.figure1, 'AutoScaleX', 'On');
    
    AlignLeftAndRightYTicks(GR, i);
    
    
    drawnow
    
    
end

XLimit = get(GR{1}.Axes.Handle, 'XLim');
set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));

drawnow;

end


% Called to align the YTicks of Left and Right graphs.
% Min. number of YTicks to be displayed =5.
function AlignLeftAndRightYTicks(GR, ThisGraph)


% Need to align both left and right
% since the assumption here is that
% YLim(1) == YTick(1)
AssociatedWith = GR{ThisGraph}.AssociateWith;
if(~isempty(AssociatedWith))
    
    % Number of Left YTicks
    YTickW = get(GR{AssociatedWith}.Axes.Handle,'YTick');
    YTick = get(GR{ThisGraph}.Axes.Handle,'YTick');
    
    nYTicksW =length(YTickW);
    nYTicks =length(YTick);
    
    
    axesh = GR{ThisGraph}.Axes.Handle;
    axeshW = GR{AssociatedWith}.Axes.Handle;
    
    YLim = get(axesh, 'YLim');
    YLimW =get(GR{AssociatedWith}.Axes.Handle,'YLim');
    
    % check if ticks are already aligned
    if( YLim(1) == YTick(1) && YLimW(1) == YTickW(1))
       
%         dytick = abs(YLim(2) - YLim(1))/(nYTicks-1);
%         dytickW = abs(YLimW(2) - YLimW(1))/(nYTicksW-1);
         dytick = abs(YTick(end) - YTick(1))/(nYTicks-1);
         dytickW = abs(YTickW(end) - YTickW(1))/(nYTicksW-1); 
        % if already aligned return
        if( nYTicksW == nYTicks && dytickW == dytick)
            return;
        end
        
    end
    if(nYTicksW<5)
        nYTicksWNew =5;
    else 
        nYTicksWNew = nYTicksW;
    end
    
    set(axesh, 'YTickMode', 'Manual');
    
    % this works if you assume that left ticks start at YLim(1)    
    dYTick = abs(YLim(2)-YLim(1))/(nYTicksWNew-1);
        
    YTick = YLim(1):dYTick:YLim(2);
    YTick = YTick(:);
    
    set(axesh, 'YTick', YTick);
    
    % with linspace....
    % set(axesh, 'YTick', linspace(YLim(1),YLim(2), nYTicksWNew));    

    % if modified number of ticks, reset both graphs YTicks
    if(nYTicksWNew ~= nYTicksW)
        %         AlignLeftAndRightYTicks(GR, AssociatedWith);
        set(axeshW, 'YTickMode', 'Manual');
        
        % this works if you assume that left ticks start at YLim(1)
        dYTickW = abs(YLimW(2)-YLimW(1))/(nYTicksWNew-1);
        
        YTickW = YLimW(1):dYTickW:YLimW(2);
        YTickW = YTickW(:);        
        set(axeshW, 'YTick', YTickW);                
    end

    % with linspace....
    %     if(nYTicksWNew ~= nYTicksW)
    %         set(axeshW, 'YTick', linspace(YLimW(1),YLimW(2), nYTicksWNew));
    %     end
    
else
    return;
end



end





% --- Executes when figure1 is resized.
% Align YTicks (otherwise YTick are not aligned anymore)
function figure1_ResizeFcn(hObject, eventdata, handles)

GR = getappdata(handles.figure1, 'GR');

for i=1:length(GR)
    
    % Align Left and Right YTicks for pair axes
    AlignLeftAndRightYTicks(GR,i);
    
end

drawnow;



end



% This is called:
% after (every time) new data is plotted (including timer mode).
%--------------------------------------------------------------------
function AutoScaleAxis(handles)

% Expand to full axis then put the y-axes back to manual

GR = getappdata(handles.figure1, 'GR');


for i=1:length(GR)
    
    axesh = GR{i}.Axes.Handle;
    % debug
    %     fprintf('AutoscaleAxis all f YLim for axes=%d', i)
    %     get(axesh, 'YLim')
    
    
    % YLimMode can be either auto or manual
    set(axesh, 'YLimMode',get(axesh,'YLimMode'));
    
    
    %Align Left and Right YTicks for pair axes
    AlignLeftAndRightYTicks(GR, i);
    
    
    % Use the saved limits
    XLimit = getappdata(handles.figure1, 'XLimit');
    AutoScaleX = getappdata(handles.figure1, 'AutoScaleX');
    
    % this function is called also with timer on
    % do not autoscale if zoom in
    if strcmpi(AutoScaleX, 'On')
        set(axesh, 'XLim', XLimit);
        set(axesh, 'XLimMode', 'manual');
    end
    
    
    set(axesh, 'XTickLabel',[]);
    set(axesh, 'XTickLabelMode', 'Manual');
    
    
    % TODO: check this
    % added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
    set(axesh,'XTickLabel', datestr(get(axesh,'xtick'),'HH:MM:SS'));
    
    
end

% Autoscale future updates
% commented out for timer case and zoom in mode
% setappdata(handles.figure1, 'AutoScaleX', 'On');

XLimit = get(GR{1}.Axes.Handle, 'XLim');
set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));

drawnow;

end


% This function is call when the user clicks (left mouse click) on one of axes.
% If in YZoom Mode then, graph is y zoomed ( if not only one point).
function YAxesButtonDown_Callback(hObject, eventdata, handles)

% respond only to left mouse clicks
sel_typ = get(gcbf,'SelectionType');
switch sel_typ
    case 'normal'
        
        GR = getappdata(handles.figure1, 'GR');
        
        for i=1:length(GR)
            
            axesh = GR{i}.Axes.Handle;
            
            % If the mouse is on a line, then switch the handle to the axes
            if(hObject == axesh || (get(hObject,'parent') == axesh) )
                
                
                % Axis resize
                point1 = get(axesh,'CurrentPoint');  % button down detected
                finalRect = rbbox;                           % return figure units
                point2 = get(axesh,'CurrentPoint');  % button up detected
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
                    
                    set(axesh, 'YLim', dy);
%                     set(axesh, 'YTickMode', 'Auto');
                    
                    %Align Left and Right YTicks for pair axes
                    AssociatedWith = GR{i}.AssociateWith;
                    if(~isempty(AssociatedWith) )
                        AlignLeftAndRightYTicks(GR,i);
                        % need to align both (see function)
                        AlignLeftAndRightYTicks(GR,AssociatedWith);
                    else
                        % Let MATLAB set the YTicks for single graphs.
                        set(axesh, 'YTickMode', 'Auto');
                        set(axesh, 'YTickLabelMode', 'Auto');
                        
                    end
                    
                    
                    setappdata(handles.figure1, 'AutoScaleX', 'On');
                    setappdata(handles.figure1, 'AutoScaleY', 'Off');% not used any more ?!
                end
                
                break;
            end
        end
        
        
end

end




% Called when the graph in YZoom Mode and user single clicks (one point: y zoom out).
% Set YLimMode to Auto for that graph.
function YAutoScaleAxis_Callback(hObject, eventdata, handles)

% Expand to full axis then put the y-axes back to manual

GR = getappdata(handles.figure1, 'GR');

for i=1:length(GR)
    
    axesh = GR{i}.Axes.Handle;
    if(axesh == hObject)
        
        set(axesh, 'YLimMode', 'auto');
        
        AlignLeftAndRightYTicks(GR,i);
       
        
        break;
    end
end

drawnow;

% Autoscale future updates
setappdata(handles.figure1, 'AutoScaleX', 'On');

drawnow

end

% --------------------------------------------------------------------
function Plot1Minute_ClickedCallback(hObject, eventdata, handles)

%clear graph first
clearGraph(handles);

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

% PLot the last minute
TimeBack = 60;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis(handles);

EnableToolBarButtons(handles);

end


% --------------------------------------------------------------------
function Plot30Minutes_ClickedCallback(hObject, eventdata, handles)

%clear graph first
clearGraph(handles);

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

% PLot the last 30 minutes
TimeBack = 60*30;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis(handles);

EnableToolBarButtons(handles);

end

% --------------------------------------------------------------------
function Plot24Hours_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot24Hours (see GCBO)


%clear graph first
clearGraph(handles);

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

TimeBack = 60*60*24;%Plot last 24 hours
EndTime = now; % EndTime is 0 hours back
LoadData(handles, TimeBack,EndTime);
% AutoScaleAxis_Callback(hObject, eventdata, handles);
AutoScaleAxis(handles);
EnableToolBarButtons(handles);

end


% --------------------------------------------------------------------
function Plot12Hours_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot12Hours (see GCBO)


%clear graph first
clearGraph(handles);


% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

% PLot the last 12 hours
TimeBack = 60*60*12;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis(handles);

EnableToolBarButtons(handles);

end


function PlotAndPublish(handles)

% should disable everything
set(handles.SubtractMenu,'Enable','off');
set(handles.ModeMenu,'Enable','off');

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



% PLot the last 8 hours
TimeBack = getappdata(handles.figure1, 'WriteToWebTimeBack')*60*60;
if(isempty(TimeBack))
    TimeBack = 60*60*1; % default 1 hour, if not set in the setup file
end


EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis(handles);


setappdata(handles.figure1, 'DataRetrievalInterval', TimerPeriod);
setappdata(handles.figure1, 'TimerWindow', TimerWindow);

startTheTimer(handles);


end



% --------------------------------------------------------------------
function Plot8Hours_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot8Hours (see GCBO)


%clear graph first
clearGraph(handles);

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

% PLot the last 8 hours
TimeBack = 60*60*8;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis(handles);

EnableToolBarButtons(handles);

end

% --------------------------------------------------------------------
function Plot6Hours_ClickedCallback(hObject, ~, handles)
% hObject    handle to Plot6Hours (see GCBO)
% disable toolbar buttons  while plotting

%clear graph first
clearGraph(handles);

DisableToolBarButtons(hObject, handles)

% PLot the last 6 hours
TimeBack = 60*60*6;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis(handles);

EnableToolBarButtons(handles);
end


% --------------------------------------------------------------------
function PlotHour_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to PlotHour (see GCBO)

%clear graph first
clearGraph(handles);

% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles)

% PLot the last hour
TimeBack = 60*60;
EndTime = now;
LoadData(handles, TimeBack, EndTime);
AutoScaleAxis(handles);

EnableToolBarButtons(handles);

end

% Called when user presses the <<P>> button on the toolbar.
% PLot data for selected date interval
% Date/Time interval is set by user
% with T1 T2 buttons on toolbar
% disable toolbar buttons while plotting interval.
% If either T1 or T2 > now (future), log and return.
% T1 and T2 can be in any order.
% --------------------------------------------------------------------
function PlotInterval_ClickedCallback(hObject, eventdata, handles)

%clear graph first
clearGraph(handles);


% T1/T2 matlab time
% conversion from  matlab time to archiver time in LoadData
T1Time = getappdata(handles.figure1, 'PlotT1Time');
T2Time = getappdata(handles.figure1, 'PlotT2Time');

% ignore future time
if(T1Time > now)
    fsprintf('%s',strcat('[T1 Not Valid Date:' , datestr(T1Time),']'));
    drawnow;
    return;
elseif(T2Time > now)
    fprintf('%s',strcat('[T2 Not Valid Date:' , datestr(T2Time),']'));
    drawnow;
    return;
end

stringT2 = datestr(T1Time);
stringT1 = datestr(T2Time);
if(~isempty(stringT1) && ~isempty(stringT2) )
    fprintf('%s',strcat('[T1=',  stringT1,'/', 'T2=' , stringT2,']'));
elseif(~isempty(stringT1))
    fprintf('%s',strcat('[T1=' , stringT1,']'));
elseif(~isempty(stringT2))
    fprintf('%s',strcat('[T1=' , stringT2,']'));
end


% EndTime / StartTime is matlab time
% Convert time back to secondsal so user might invert start and end time so make it positive !!!
TimeBack = abs(T1Time - T2Time)*24*60*60;
% now determine End Time for Time Interval to PLot
if(T1Time > T2Time)
    EndTime = T1Time;
elseif(T1Time < T2Time)
    EndTime = T2Time;
else
    fprintf('%s','Please set T1 T2 for Time Interval');
    return;
end


% disable toolbar buttons  while plotting
DisableToolBarButtons(hObject, handles);


LoadData(handles, TimeBack,EndTime);
AutoScaleAxis(handles);


% disable toolbar buttons  while plotting
EnableToolBarButtons(handles);
end

% Called when user presses the <<T1>> button on the toolbar.
% A DatePicker widget is displayed for user to select T1 time for
% PLot interval.
% Date set is displayed  in info bar label.
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
    fprintf('%s',strcat('[T1=',datestr(T1),'-', 'T2=' , T2string,']'));    
else
    fprintf('%s',strcat('[T1=' , datestr(T1),']'));
end

drawnow;

end

% Called when user presses the <<T2>> button on the toolbar.
% A DatePicker widget is displayed for user to select T2 time for
% PLot interval.
%  Date set is displayed  in info bar label.
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
    fprintf('%s',strcat('[T1=',T1string,'-', 'T2=' , datestr(T2),']'));
else
    fprintf('%s',strcat('[T2=' , datestr(T2),']'));
end

drawnow;
end


% Enable Toolbar buttons after plotting
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

end
% Disable Toolbar buttons/ for plotting
% or timer running.
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
end


% User clicks on right/left YAxes Label: the corresponding
% axes should be the one responding to mouse clicks.
% If paired axes top /bottom, set HitTest property for
% corresponding axes on and associatedwith axes off.
% If single axes, return.
% FontWeight for Label is set to bold.
function Label_ButtonDownFcn(hObject, eventdata, handles)

% this responds only to left mouse clicks...
% TODO: how does this work on Unix
sel_typ = get(gcbf,'SelectionType');
switch sel_typ
    case 'normal'
        % TODO: clean up selected line if any
        GR = getappdata(handles.figure1, 'GR');
        
        for i=1: length(GR)
            if(GR{i}.Axes.Handle == get(hObject,'Parent'))
                AssociateWith = GR{i}.AssociateWith;
                if(~isempty(AssociateWith))
                    % reset only left/right fontweight
                    ylabel = get(GR{AssociateWith}.Axes.Handle, 'YLabel');
                    set(ylabel, 'FontWeight','normal');
                    set(GR{i}.Axes.Handle,'UserData','ACTIVE');
                    set(GR{AssociateWith}.Axes.Handle, 'UserData','INACTIVE');
                    if( strcmpi(get(handles.ZoomToggle,'State'),'On') || strcmpi(get(handles.YZoomToggle,'State'),'On'))
                        set(GR{i}.Axes.Handle, 'HitTest','on');
                        set(GR{AssociateWith}.Axes.Handle, 'HitTest','off');
                    end
                else
                    return;
                end
            end
        end
        
        set(hObject, 'FontWeight','Bold');
        drawnow;
end
end


% Timer Callback function, called when the timer
% is started:
% call LoadData.
function Timer_Callback(hObject, eventdata, handles)

timeback = getappdata(handles.figure1, 'DataRetrievalInterval');
timewindow = getappdata(handles.figure1, 'TimerWindow');

%set(handles.TimerRunning, 'String', sprintf('Timer triggered at %s  [Max. Time Window= %d h - Update Period= %d s]', datestr(now),timewindow, timeback));
fprintf('Timer triggered at %s  [Max. Time Window= %d h - Update Period= %d s]\n', datestr(now),timewindow, timeback);
LoadData(handles);

% Need to add something here to reset L and R.
% if autoscaleaxis is used it should be modified so that in zoom
% mode the timer does not zooms out.
AutoScaleAxis(handles);
% create a jpeg image of the gui and post it to a web page

% if write to web page flag is set:
if strcmpi(getappdata(handles.figure1, 'WriteToWebPageFlag'),'on')
    WriteToWebHowOften = getappdata(handles.figure1, 'WriteToWebHowOften');
    n = WriteToWebHowOften/timeback;
    if(rem(get(handles.thetimer, 'TasksExecuted'),n) == 0)
        try
            WriteToWebPage(handles);
        catch ME
            fprintf('EXCEPTION at WriteToWebPage. %s \n',ME.message);
        end
    end
end
end


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

set(handles.StartStopTimer, 'ToolTipString', 'Start continuous updates');

end


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

setappdata(handles.figure1, 'TimerWindow', TimerWindow);
setappdata(handles.figure1, 'DataRetrievalInterval', TimerInterval);

% start the timer to load data every tot sec
startTheTimer(handles);

% start the timer to load data every tot sec
% handles.thetimer = timer;
% 
% set(handles.thetimer,'ExecutionMode','fixedRate','BusyMode','drop','Period',TimerInterval);
% set(handles.thetimer,'TimerFcn',{@Timer_Callback,handles});
% 
% guidata(hObject, handles);
% start(handles.thetimer);

% set(handles.TimerRunning, 'Visible', 'Off');
set(handles.StartStopTimer, 'ToolTipString', 'Stop continuous updates');

end



function startTheTimer(handles)

TimerPeriod  = getappdata(handles.figure1, 'DataRetrievalInterval');

% start the timer to load data every tot sec
handles.thetimer = timer;

set(handles.thetimer,'ExecutionMode','fixedRate','BusyMode','drop','Period',TimerPeriod);
set(handles.thetimer,'TimerFcn',{@Timer_Callback,handles});

guidata(handles.figure1, handles);
start(handles.thetimer);
end

function LinkXAxes(handles)

GR = getappdata(handles.figure1, 'GR');
axesList = [GR{1}.Axes.Handle];

for i = 2:length(GR);
    
    axesh = GR{i}.Axes.Handle;
    axesList = [axesList , axesh];
end

linkaxes(axesList, 'x');
end


% --------------------------------------------------------------------
function ModeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ModeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function TimerDataLoad_Callback(hObject, eventdata, handles)
% hObject    handle to TimerDataLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function timewindow_Callback(hObject, eventdata, handles)
% hObject    handle to timewindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

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
end

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
end

% --------------------------------------------------------------------
function window8h_Callback(hObject, eventdata, handles)
% hObject    handle to window8h (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.window24h,'Checked','off');
    set(handles.window12h,'Checked','off');
    set(handles.window8h,'Checked','on');
    set(handles.window6h,'Checked','off');
    set(handles.window1h,'Checked','off');
end

DisplaySettings(handles);
end

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
end

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

% DisplaySettings(handles);
end

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
end


% --------------------------------------------------------------------
function interval_20s_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.interval_10s,'Checked','off');
    set(handles.interval_20s,'Checked','on');
    set(handles.interval_30s,'Checked','off');
    set(handles.interval_60s,'Checked','off');
end
DisplaySettings(handles);
end


% --------------------------------------------------------------------
function interval_30s_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.interval_10s,'Checked','off');
    set(handles.interval_20s,'Checked','off');
    set(handles.interval_30s,'Checked','on');
    set(handles.interval_60s,'Checked','off');
end
DisplaySettings(handles);
end


% --------------------------------------------------------------------
function interval_60s_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.interval_10s,'Checked','off');
    set(handles.interval_20s,'Checked','off');
    set(handles.interval_30s,'Checked','off');
    set(handles.interval_60s,'Checked','on');
end
DisplaySettings(handles);
end


function WriteToWebPage(handles)

%  fullpath to image file 
ImageFilename = getappdata(handles.figure1, 'ImageFilename');
ImageFilename10Min = [ImageFilename , '10Min'];

if(isempty(ImageFilename))
    fprintf('\nCannot write to Web Page:path not set. \n\n');
    return;
end

% jpeg will be the same size as what is on the screen
% This could be trouble, we might want to force the position width and height???

% Units    = get(handles.figure1, 'Units')
% Position = get(handles.figure1, 'Position')

h2 = getappdata(handles.figure1, 'PrintFigure');
clf(h2);

GR = getappdata(handles.figure1, 'GR');

% copy to hidden figure for printing
% but exclude menu bar and toolbar
h2handles(1) = copyobj(handles.InfoWindow, h2);
for gri = 1: length(GR)
    h2handles(gri+1) = copyobj(GR{gri}.Axes.Handle, h2);    
end
setappdata(handles.figure1, 'PrintFigureHandles',h2handles);

% reset axis for hidden figure before printing
resetHiddenGraph(handles);
drawnow

set(h2,'PaperPositionMode','Auto');
set(h2,'InvertHardcopy','off');

try
    print(h2, '-dpng','-r0', '-loose',ImageFilename);
%     print(h2, '-dpng','-r0', '-loose','\\Als-filer\alswebdata\cr\graphit_SRMain.png');% testing
%     saveas(h2, '-dpng','-r0', '-loose',ImageFilename);
catch ME
    fprintf('\nError writing to %s %s \n\n',ImageFilename, ME.message);
end

% reset axis for hidden figure before printing
% now just display the last 10 minutes and print
resetHiddenGraph10Min(handles);
drawnow

try
    print(h2, '-dpng','-r0', '-loose',ImageFilename10Min);
%     print(h2, '-dpng','-r0', '-loose','\\Als-filer\alswebdata\cr\graphit_SRMain10Min.png');
%     saveas(h2, '-dpng','-r0', '-loose',ImageFilename10Min);
catch ME
    fprintf('\nError writing to %s %s \n\n',ImageFilename10Min, ME.message);
end
end


% reset Axis to initial values from set up file
% for hidden figure to be printed for web page
% expects YLim stored in GR.Axes.YLim,
% otherwise need to change this.
function resetHiddenGraph(handles)

h2 =getappdata(handles.figure1, 'PrintFigure');
h2handles =  getappdata(handles.figure1, 'PrintFigureHandles');
GR = getappdata(handles.figure1, 'GR');

hwindow =0;
XLimit =[];

for ch =1:length(h2handles)
    if(strcmpi(get(h2handles(ch),'Tag'), 'InfoWindow'))
        hwindow = h2handles(ch);
%         this is not printed for a bug, so set invisible
        set(hwindow,'Visible', 'Off');
    elseif(strcmpi(get(h2handles(ch),'Type'), 'axes'))
        % now set YLim for each graph - get YLim from visible figure
        for gri =1: length(GR)
            grtag = get(GR{gri}.Axes.Handle, 'Tag');
            if(strcmpi(get(h2handles(ch),'Tag'),grtag))
                
                % set X and Y Grid off
                set(h2handles(ch),'YGrid', 'Off', 'XGrid', 'Off');
                % reset original YTick
                set(h2handles(ch), 'YTickLabel',[]);
                set(h2handles(ch), 'YLimMode','manual');
                set(h2handles(ch), 'YLim',GR{gri}.Axes.YLim);
                
                set(h2handles(ch), 'YTick',[]);
                set(h2handles(ch), 'YTickMode', 'Auto');
                set(h2handles(ch), 'YTickLabelMode','Manual');
                set(h2handles(ch), 'YTickLabel',get(h2handles(ch), 'YTick'));  
                drawnow;
                % Use the saved limits for visible figure
                % not sure if this is ok for the hidden graph
                XLimit = getappdata(handles.figure1, 'XLimit');
                set(h2handles(ch), 'XLimMode', 'manual');
                set(h2handles(ch), 'XLim', XLimit);
               
                % Now try to set the xtick on the exact hour mark...               
                % XLimit(2) = XLimit(2)- rem(XLmit(2), 60/60/24);
                xtick1 = XLimit(1)+1/24-rem(XLimit(1), 60/60/24);                
                set(h2handles(ch), 'XTickMode', 'Manual');%%
                set(h2handles(ch), 'XTick',[xtick1:2/24:XLimit(2)]);%%
                
                %%%
                set(h2handles(ch), 'XTickLabel',[]);
                
                % added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
                % set(h2handles(ch),'XTickLabel', datestr(get(h2handles(ch),'xtick'),'HH:MM:SS'));
                set(h2handles(ch),'XTickLabel', datestr(get(h2handles(ch),'xtick'),'HH:MM'));
               
            end
        end
    end
end

% matlab bug, uicontrol (InfoWindow) is NOT PRINTED if figure invisible,
% so need to set a textbox with InfowWindow text

h2handles(length(h2handles)+1) = annotation(h2,'textbox',get(hwindow,'Position'),...
    'String',sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))),'FontSize',12,...
'Color','Blue', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'));
% set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));
% save handles, since cannot find annotation handles....
setappdata(handles.figure1, 'PrintFigureHandles',h2handles);
drawnow;
end


% Reset hidden figure XLimit to display only last 10 minutes
% for printing
function resetHiddenGraph10Min(handles)

h2handles =  getappdata(handles.figure1, 'PrintFigureHandles');
GR = getappdata(handles.figure1, 'GR');

XLimit =[];

for ch =1:length(h2handles)
    
    if(strcmpi(get(h2handles(ch),'Type'), 'axes'))
        % now set XLim for each graph - get XLim from visible figure
        for gri =1: length(GR)
            grtag = get(GR{gri}.Axes.Handle, 'Tag');
            if(strcmpi(get(h2handles(ch),'Tag'),grtag))
                
                % Use the saved limits for visible figure
                % not sure if this is ok for the hidden graph
                XLimit = getappdata(handles.figure1, 'XLimit');
                XLimit = [XLimit(2)-10/60/24, XLimit(2)];% last 10 minutes only
                set(h2handles(ch), 'XLimMode', 'manual');
                set(h2handles(ch), 'XLim', XLimit);

                % now try to set ticks on the exact hours/minutes mark...
                set(h2handles(ch), 'XTickMode', 'Manual');%%
                xtick1 = XLimit(1)+1/60/24-rem(XLimit(1),60/60/60/24);
                set(h2handles(ch), 'XTick', [xtick1:1/60/24:XLimit(2)]);%%
                
%                 datetick(h2handles(ch),'x', 'HH:MM:SS');
%                 set(h2handles(ch), 'XTickLabel',[]);
                % added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
                set(h2handles(ch),'XTickLabel', datestr(get(h2handles(ch),'xtick'),'HH:MM:SS'));
            end
        end
    end
end

% matlab bug, uicontrol (InfoWindow) is NOT PRINTED if figure invisible,
% so need to set a textbox with InfowWindow text
% set(h2handles(length(h2handles)),...
%     'String',sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))),'FontSize',12,...
% 'Color','Blue', 'HorizontalAlignment', 'Center','EdgeColor',get(h2, 'Color'));

set(h2handles(length(h2handles)),...
    'String',sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));

drawnow;
end

% Display Menu settings in Menu bar.
function DisplaySettings(handles)

if strcmpi(get(handles.LastPoint, 'Checked'),'On')
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

TimerWindow = sprintf(' - Timer Window %s', TimerWindow);

stringWeb='';
% Web 
if strcmpi(getappdata(handles.figure1, 'WriteToWebPageFlag'),'on')
    stringWeb = ' - - Publish to Web Page';
end

set(handles.settingsDisplay, 'Label', ['            "', offsetString, '"      ', TimerSett,stringWeb]);
% can use html for controls ?!
% this is to override disabled menu foreground color
listStr =['<html><font Color="blue"/>' offsetString TimerSett stringWeb '</html>'] ;
set(handles.settingsDisplay,'label', listStr);
end


% --------------------------------------------------------------------
function tmplabel_Callback(hObject, eventdata, handles)
% hObject    handle to tmplabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function settingsDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to settingsDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% Callback function for Subtract First Point Menu Item.
% --------------------------------------------------------------------
function FirstPoint_Callback(hObject, eventdata, handles)
% hObject    handle to FirstPoint (see GCBO)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.FirstPoint,'Checked','on');
    set(handles.LastPoint,'Checked','off');
    set(handles.None,'Checked','off');
end

DisplaySettings(handles);

GR = getappdata(handles.figure1, 'GR');

for i=1: length(GR)
    plotachiveddata(handles,i);
    AutoScaleAxis1y(handles,i);    
end
end

% Callback function for Subtract Last Point Menu Item.
% --------------------------------------------------------------------
function LastPoint_Callback(hObject, eventdata, handles)
% hObject    handle to LastPoint (see GCBO)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.FirstPoint,'Checked','off');
    set(handles.LastPoint,'Checked','on');
    set(handles.None,'Checked','off');
end

DisplaySettings(handles);
GR = getappdata(handles.figure1, 'GR');

for i = 1: length(GR)
    plotachiveddata(handles,i);
    AutoScaleAxis1y(handles,i);
end
end


% Callback function for Subtract None Menu Item.
% --------------------------------------
function None_Callback(hObject, eventdata, handles)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.FirstPoint,'Checked','off');
    set(handles.LastPoint,'Checked','off');
    set(handles.None,'Checked','on');
end

DisplaySettings(handles);

GR = getappdata(handles.figure1, 'GR');

for i=1: length(GR)
    plotachiveddata(handles,i);
    AutoScaleAxis1y(handles,i);
end
end


% Called when Subtract /None/First/Last Point is selected.
% YLimMode to auto and autoscale the Y axes.
% --------------------------------------------------------------------
function AutoScaleAxis1y(handles,WhichGraph)

% Expand to full axis then put the y-axes back to manual

GR = getappdata(handles.figure1, 'GR');

axesh = GR{WhichGraph}.Axes.Handle;


% Autoscale the vertical, then turn it back to manual
set(axesh, 'YLimMode', 'auto');
drawnow;
%TODO: is this needed?
%set(axes, 'YLimMode', 'manual');


% Align Left and Right YTicks for pair axes
AlignLeftAndRightYTicks(GR, WhichGraph);

end

% Clear dataset, clear lines, clear graphs, reset default YLim for
% each graph; clear Tick labels
% --------------------------------------------------------------------
function ClearGraph_ClickedCallback(~, eventdata, handles)
clearGraph(handles);
end


function clearGraph(handles)

% Clear graph call back:
% Clear archiveddata and archived time
% clear all graphs
% clear info windows

% Get the application data
setappdata(handles.figure1, 'ArchivedDataSet', {});
setappdata(handles.figure1, 'ArchivedTimeSet', {});
setappdata(handles.figure1, 'ArchivedStartTime', []);
setappdata(handles.figure1, 'ArchivedEndTime', []);

GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axes = GR{p}.Axes.Handle;
    
    for i = 1:length(GR{p}.Lines.Handle)
        % Turn off line identification
        % and reset defualt line marker if any .
        set(GR{p}.Lines.Handle(i), 'Marker', GR{p}.Line.Marker{i,1});
        set(GR{p}.Lines.Handle(i), 'XData', [NaN NaN], 'YData',  [NaN NaN]);
    end
    
    % reset YLimMode and YLim to default from set up file
    if(strcmpi(GR{p}.Axes.YLimMode,'manual') && ~isempty(GR{p}.Axes.YLim))
        set(axes, 'YLim', GR{p}.Axes.YLim);
    end
    
%     set(axes, 'YGrid', 'Off', 'XGrid', 'Off');
    set(axes, 'XTicklabel', []);
    set(axes, 'YTick',[]);
    %%%    set(axes, 'YTickLabel',[]);
    %     set(axes, 'XTick',[]);
    set(axes, 'YTickMode', 'Auto');
    set(axes, 'YTickLabelMode','Auto');
    
end

setappdata(handles.figure1, 'AutoScaleX', 'On');
setappdata(handles.figure1, 'XLimit', [0 1]);

% JTextField on ToolBar
jText = getappdata(handles.figure1, 'jText');
jText.setText('Mouse click on line to display channel info');
set(handles.InfoWindow, 'String', 'Info Window');

end

% --------------------------------------------------------------------
function UpdatePeriod_Callback(hObject, eventdata, handles)
% hObject    handle to UpdatePeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end




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
end




function MenuNameCallback(hObject, eventdata, handles)
fprintf('bla');

end

% Set YGrid lines for all graphs, with menu item DisplayYGrid
% --------------------------------------------------------------------
function DisplayYGrid_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayYGrid (see GCBO)

if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.DisplayYGrid,'Checked','on');
    yflag ='on';
else
    set(handles.DisplayYGrid,'Checked','off');
    yflag ='off';
end


GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axes = GR{p}.Axes.Handle;
    
    set(axes,'YGrid',yflag);
%     AssociatedWith = GR{p}.AssociateWith;
%     if(isempty(AssociatedWith) || (~isempty(AssociatedWith) && p< AssociatedWith))
%        set(axes,'YGrid',yflag); 
%         
%     end

end

end


% --------------------------------------------------------------------
function DisplayXGrid_Callback1(hObject, eventdata, handles)
% hObject    handle to DisplayXGrid (see GCBO)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.DisplayXGrid,'Checked','on');
    xflag ='on';
else
    set(handles.DisplayXGrid,'Checked','off');
    xflag ='off';
end


GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axes = GR{p}.Axes.Handle;
    
    set(axes,'XGrid',xflag);
    
    % update axes context menu
    % anything shorter than this?!!!
    axescontextmenu = get(get(axes,'uicontextmenu'),'children');
    if(~isempty(axescontextmenu))
        a=strcmpi(get(axescontextmenu,'Tag'), 'XGridMenu');
        set(axescontextmenu(a),'Checked', xflag)
        
    end
    
end

end


% Set XGrid lines for all graphs, with menu item DisplayXGrid
% --------------------------------------------------------------------
function DisplayXGrid_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayXGrid (see GCBO)
if strcmpi(get(hObject, 'Checked'),'off')
    set(handles.DisplayXGrid,'Checked','on');
    xflag ='on';
else
    set(handles.DisplayXGrid,'Checked','off');
    xflag ='off';
end


GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axes = GR{p}.Axes.Handle;
    
    set(axes,'XGrid',xflag);
    
end

end






% --------------------------------------------------------------------
function YGrid_Callback1(hObject, eventdata, handles)
% hObject    handle to DisplayXGrid (see GCBO)
if strcmpi(get(hObject, 'Checked'),'off')
    set(hObject,'Checked','on');
    yflag ='on';
else
    set(hObject,'Checked','off');
    yflag ='off';
    set(handles.DisplayYGrid, 'Checked','Off');
end


GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    axesW = GR{p}.AssociateWith;
    
    if(get(hObject,'UserData') == axesh)
        set(axesh,'YGrid',yflag);
        if(~isempty(axesW))
            set(GR{axesW}.Axes.Handle, 'YGrid',yflag);
        end
    end
    
end

% update GRaph->YGrid menu
for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    
    if(strcmpi(get(axesh,'YGrid'), 'off'))
        set(handles.DisplayYGrid, 'Checked','Off');
        break;
    end
    set(handles.DisplayYGrid, 'Checked','On');
end




end


% --------------------------------------------------------------------
function XGrid_Callback1(hObject, eventdata, handles)
% hObject    handle to DisplayXGrid (see GCBO)
if strcmpi(get(hObject, 'Checked'),'off')
    set(hObject,'Checked','on');
    xflag ='on';
else
    set(hObject,'Checked','off');
    xflag ='off';
    set(handles.DisplayXGrid, 'Checked','Off');
end


GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    axesW = GR{p}.AssociateWith;
    
    if(get(hObject,'UserData') == axesh)
        set(axesh,'XGrid',xflag);
        if(~isempty(axesW))
            set(GR{axesW}.Axes.Handle, 'XGrid',xflag);
        end
    end
    
end


% update GRaph->XGrid menu
for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    
    if(strcmpi(get(axesh,'XGrid'), 'off'))
        set(handles.DisplayXGrid, 'Checked','Off');
        break;
    end
    set(handles.DisplayXGrid, 'Checked','On');
end


end

% Callback for XGrid Line context menu:
% user clicks on XGRid context menu: if X GRid off -> set on
% and viceversa; if any axes has grid lines off-> set GRaph Menu->XGrid
% not checked.
% --------------------------------------------------------------------
function XGrid_Callback(hObject, eventdata, handles)

GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    axesW = GR{p}.AssociateWith;
    
    %     if(get(hObject,'UserData') == axesh)
    if(get(hObject,'Parent') == get(axesh, 'UIContextMenu'))
        if(strcmpi(get(axesh,'XGrid'), 'on'))
            xflag = 'off';
        else
            xflag ='on';
        end
        set(axesh,'XGrid',xflag);
        if(~isempty(axesW))
            set(GR{axesW}.Axes.Handle, 'XGrid',xflag);
        end
    end
    
end


% update GRaph->DisplayXGrid menu
for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    
    if(strcmpi(get(axesh,'XGrid'), 'off'))
        set(handles.DisplayXGrid, 'Checked','Off');
        break;
    end
    set(handles.DisplayXGrid, 'Checked','On');
end


end


% Callback for YGrid Line context menu:
% user clicks on YGRid context menu: if Y GRid off -> set on
% and viceversa; if any axes has grid lines off-> set GRaph Menu->YGrid
% not checked.
% --------------------------------------------------------------------
function YGrid_Callback(hObject, eventdata, handles)

GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    axesW = GR{p}.AssociateWith;
    
    %     if(get(hObject,'UserData') == axesh)
    if(get(hObject,'Parent') == get(axesh, 'UIContextMenu'))
        if(strcmpi(get(axesh,'YGrid'), 'on'))
            yflag = 'off';
        else
            yflag ='on';
        end
        set(axesh,'YGrid',yflag);
        if(~isempty(axesW) && p<axesW)
            set(GR{axesW}.Axes.Handle, 'YGrid',yflag);
        end
    end
    
end


% update GRaph->YGrid menu
for p=1:length(GR)
    axesh = GR{p}.Axes.Handle;
    
    if(strcmpi(get(axesh,'YGrid'), 'off'))
        set(handles.DisplayYGrid, 'Checked','Off');
        break;
    end
    set(handles.DisplayYGrid, 'Checked','On');
end


end


% --------------------------------------------------------------------
function GraphOptions_Callback(hObject, eventdata, handles)
% hObject    handle to GraphOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function resetGraph_Callback(hObject, eventdata, handles)
% hObject    handle to resetGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GR = getappdata(handles.figure1, 'GR');

for p=1:length(GR)
    
    axesh = GR{p}.Axes.Handle;
% reset YLimMode and YLim to default from set up file
    if(~isempty(GR{p}.Axes.YLim))
        
        set(axesh, 'YTickLabel',[]);
        set(axesh, 'YLimMode','manual');
        set(axesh, 'YLim',GR{p}.Axes.YLim);
        
        set(axesh, 'YTick',[]);
        set(axesh, 'YTickMode', 'Auto');
        set(axesh, 'YTickLabelMode','Auto');
        
        
        
        % Use the saved limits
        XLimit = getappdata(handles.figure1, 'XLimit');
        
        set(axesh, 'XLimMode', 'manual');
        set(axesh, 'XLim', XLimit);
        
        setappdata(handles.figure1, 'AutoScaleX', 'On');
        set(axesh, 'XTickLabel',[]);
       
        % TODO: check this
        % added because xticklabel are wrong (year printed still wrong if not set as yyyy-mm-dd)
        set(axesh,'XTickLabel', datestr(get(axesh,'xtick'),'HH:MM:SS'));
        
    end
   
end

for p=1:length(GR)
    AlignLeftAndRightYTicks(GR, p)
   
end



XLimit = get(GR{1}.Axes.Handle, 'XLim');
set(handles.InfoWindow, 'String', sprintf('%s  to  %s', datestr(XLimit(1)), datestr(XLimit(2))));
drawnow;
end


% --------------------------------------------------------------------
function AutoscaleX_Callback(hObject, eventdata, handles)
% hObject    handle to AutoscaleX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GR = getappdata(handles.figure1, 'GR');

for i=1:length(GR)
    
    axesh = GR{i}.Axes.Handle;

    set(axesh, 'XLimMode','Auto');
end


setappdata(handles.figure1, 'AutoScaleX', 'On');

AutoScaleAxis(handles)
 
end


% --------------------------------------------------------------------
function AutoscaleY_Callback(hObject, eventdata, handles)
% hObject    handle to AutoscaleY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GR = getappdata(handles.figure1, 'GR');


for i=1:length(GR)
    axesh = GR{i}.Axes.Handle;
    if(strcmpi(get(axesh, 'YLimMode'), 'Manual'))
        AutoScaleAxis1y(handles,i)
    end
end


end
