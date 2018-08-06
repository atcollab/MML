function varargout = epbitest2(varargin)
% EPBITEST2 MATLAB code for epbitest2.fig
%      EPBITEST2, by itself, creates a new EPBITEST2 or raises the existing
%      singleton*.
%
%      H = EPBITEST2 returns the handle to a new EPBITEST2 or the handle to
%      the existing singleton*.
%
%      EPBITEST2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EPBITEST2.M with the given input arguments.
%
%      EPBITEST2('Property','Value',...) creates a new EPBITEST2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before epbitest2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to epbitest2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help epbitest2

% Last Modified by GUIDE v2.5 31-May-2016 16:18:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @epbitest2_OpeningFcn, ...
    'gui_OutputFcn',  @epbitest2_OutputFcn, ...
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


% --- Executes just before epbitest2 is made visible.
function epbitest2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to epbitest2 (see VARARGIN)

% Choose default command line output for epbitest2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

checkforao;

%Sector = get(handles.Sector, 'Value') + 3;
%EPBITEST2 = getepbichannelnames(Sector);
%EPBITEST2 = rmfield(EPBITEST2, 'Throttle');
%setappdata(handles.figure1, 'EPBIStructure', EPBITEST2);

handles.Lines = plot(handles.axes1, 1:3, NaN*rand(3,19));
%linkaxes([handles.axes1;handles.axes2;],'x');
%zoom on;
xlabel(handles.axes1, 'Time [Seconds]',  'FontSize', 18);
ylabel(handles.axes1, 'Temperature [C]', 'FontSize', 18);

set(handles.Lines(19), 'LineWidth', 5);
set(handles.Lines(19), 'Color', [0 0 0]);

%handles.Legend = legend('','','','','','','','','','', 'Location', 'NorthWest');
%set(handles.Legend, 'Interpreter', 'None');

set(handles.axes1, 'XLimMode', 'auto');
set(handles.axes1, 'YLimMode', 'auto');

if isdeployed
    % Publish is not a standalone function
    set(handles.Report, 'String', 'Save Data');
    %not the right way to set a context menu  ->set(handles.Report, 'UIContextMenu', 'HTML report can only be generated in a Matlab session.');
end

% Setup graph Timer
UpdatePeriod = .25;
t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@TCGraph_Timer_Callback, handles});
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'GraphTimer');
%set(t, 'UserData', handles);
%handles.GraphTimer = t;
setappdata(handles.figure1, 'GraphTimer', t);


% Setup HeaterControl Timer
UpdatePeriod = 30;
t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@Heater_Timer_Callback, handles});
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'HeaterTimer');
%handles.HeaterTimer = t;
setappdata(handles.figure1, 'HeaterTimer', t);

setappdata(handles.figure1, 'EPBIData', []);

% Heater & sector button init
set(handles.HeaterControl, 'String', 'Heater is Off');
set(handles.HeaterControl, 'BackgroundColor', [.702 .702 .702]);
set(handles.Sector,        'Enable', 'On');
set(handles.HeaterSelect,  'Enable', 'On');
set(handles.OnOffButton,   'Enable', 'On');
set(handles.Report,        'Enable', 'Off');

% Update handles structure 
guidata(hObject, handles);

% Sector button init
Sector_Callback(hObject, eventdata, handles);

% UIWAIT makes epbitest2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function TCGraph_Timer_Callback(hObject, eventdata, handles)

EPBI     = getappdata(handles.figure1, 'EPBIStructure');
EPBIData = getappdata(handles.figure1, 'EPBIData');
h_legend = getappdata(handles.figure1, 'h_legend');

%Sector = get(handles.Sector, 'Value') + 3;
Heater = get(handles.HeaterSelect, 'Value');
Names  = get(handles.HeaterSelect, 'UserData');

ChanNames = EPBI.(Names{Heater}).TC;
%ChanNames = EPBITEST2.(Names{HeaterSelect}).WF;

[TC, ~, EPBIData.DataTime(:,end+1)] = getpv(ChanNames);

set(handles.TimeStamp, 'String', datestr(EPBIData.DataTime(1,end),31));

t = EPBIData.t;
d = EPBIData.TC;


% Record trip state
ChanNames = EPBI.(Names{Heater}).Intlk;
[Intlk_State, ~, Intlk_State_TimeStamp] = getpv(ChanNames);

%if isfield(EPBI.(Names{Heater}), 'Intlk_State')
    Intlk_State_Old           = EPBI.(Names{Heater}).Intlk_State;
    Intlk_State_TimeStamp_Old = EPBI.(Names{Heater}).Intlk_State_TimeStamp;
%else
%    Intlk_State_Old           = Intlk_State;
%    Intlk_State_TimeStamp_Old = Intlk_State_TimeStamp;
%end


t = [t gettime];
d = [d TC];


% Look for new trips
if any(Intlk_State > Intlk_State_Old)
    if ~isempty(EPBIData.HeaterStartTime)
        HeaterOnTime = gettime - EPBIData.HeaterStartTime;
    else
        HeaterOnTime = 0;
    end

    i = find(Intlk_State > Intlk_State_Old);
    EPBIData.TripIndex(i)       = size(d,2);
    EPBIData.TripDate(i)        = now;
    EPBIData.HeaterOnTime(i)    = HeaterOnTime;
    EPBIData.TripTemperature(i) = TC(i,1);
    
    LegendCell = get(h_legend, 'String');
    for j = i(:)'
        set(handles.Lines(j+9), 'XData', t(end)-t(1), 'YData', TC(j,:));
        set(handles.Lines(j+9), 'Marker', 'diamond');
        set(handles.Lines(j+9), 'MarkerSize', 10);
        LineColor = get(handles.Lines(j), 'Color');
        set(handles.Lines(j+9), 'MarkerEdgeColor', LineColor);
        set(handles.Lines(j+9), 'MarkerFaceColor', LineColor);
        
        if HeaterOnTime > 0
            LegendCell{j} = sprintf('%s, %.2f (%.1f sec) Trip', LegendCell{j}, TC(j,1), HeaterOnTime);
        else
            LegendCell{j} = sprintf('%s, %.2f (Heater Off) Trip', LegendCell{j}, TC(j,1));
        end
    end
    set(h_legend, 'String', LegendCell);
end

% If all tripped, turn the heaterselect off
if ~any(isnan(EPBIData.TripIndex)) && get(handles.HeaterControl, 'Value')==1
    set(handles.HeaterControl, 'Value', 0);
    HeaterControl_Callback(hObject, eventdata, handles);
end

% Look if an external program turned the heater on unexpectedly
%if get(handles.HeaterControl, 'Value')==0 && getpvonline(HeatMonitor)
%end

for i = 1:size(TC,1)
    set(handles.Lines(i), 'XData', t-t(1), 'YData', d(i,:));
end
% zero the other lines
for i = size(TC,1)+1:9   % length(handles.Lines)
    set(handles.Lines(i), 'XData', NaN, 'YData', NaN);
end

%YLim = get(handles,axes,'YLim');

EPBI.(Names{Heater}).Intlk_State           = Intlk_State;
EPBI.(Names{Heater}).Intlk_State_TimeStamp = Intlk_State_TimeStamp;

EPBIData.t = t;
EPBIData.TC = d;
setappdata(handles.figure1, 'EPBIData',      EPBIData);
setappdata(handles.figure1, 'EPBIStructure', EPBI);


% Stop if measurement complete
% But don't stop if all the TC started in a latched state
if ~any(isnan(EPBIData.TripIndex))  % && any(EPBIData.TripIndex>1)
    % If measurement complete, then stop in 20 seconds
    imax = max(EPBIData.TripIndex);
    if gettime-t(imax) > 20
        set(handles.OnOffButton, 'Value', 0);
        OnOffButton_Callback(hObject, eventdata, handles);
        %set(handles.OnOffButton, 'Enable', 'Off');
        
        % Auto save data
%         if ~isempty(EPBIData.TC)
%             Sector = get(handles.Sector, 'Value') + 3;
%             Heater = get(handles.HeaterSelect, 'Value');
%             Names  = get(handles.HeaterSelect, 'UserData');
%             
%             %FileName = 'EPBITest2';
%             FileName = sprintf('EPBI_Test2_Sector%d_%s', Sector, Names{Heater});
%             FileName = appendtimestamp(FileName, EPBIData.DataTime(1,1));
%             if ispc
%                 DirectoryPath = 'M:\EPBI\Test2_Data\';
%             else
%                 DirectoryPath = '/home/als/physdata/EPBI/Test2_Data/';
%             end
%             FileName = [DirectoryPath, FileName];
%             save(FileName, 'EPBIData');
%             fprintf('   Data saved to %s\n', EPBIFileName);
%         else
%             fprintf('No data to save.\n');
%         end
    end
end

drawnow;



% --- Executes on selection change in HeaterSelect.
function HeaterSelect_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns HeaterSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HeaterSelect

EPBI = getappdata(handles.figure1, 'EPBIStructure');
GraphTimer = getappdata(handles.figure1, 'GraphTimer');

stop(GraphTimer);
pause(.1);

Names = fieldnames(EPBI);
Value = get(handles.HeaterSelect, 'Value');

N = size(EPBI.(Names{Value}).Limit, 1);

% Create the EPBIData struncture
EPBIData.TripIndex       = zeros(N,1)*NaN;
EPBIData.TripDate        = zeros(N,1)*NaN;
EPBIData.HeaterIndex     = NaN;
EPBIData.HeaterOnTime    = zeros(N,1);
EPBIData.TripTemperature = zeros(N,1)*NaN;
EPBIData.DataTime = [];
EPBIData.t  = [];   % Clear the graph
EPBIData.TC = [];   % Clear the graph
EPBIData.Limit = getpv(EPBI.(Names{Value}).Limit);
EPBIData.ChannelNames = EPBI.(Names{Value}).TC;
EPBIData.Sector = get(handles.Sector, 'Value') + 3;
EPBIData.HeaterName = Names{Value};
EPBIData.Desc = 'EPBI Test2';
setappdata(handles.figure1, 'EPBIData', EPBIData);

set(handles.Header, 'String', sprintf('EPBI Test #2 - Sector %d', EPBIData.Sector));

% Remove the lines
for i = 1:19
    set(handles.Lines(i), 'XData', NaN, 'YData', NaN);
end

% Starting interlock state
Heater = get(handles.HeaterSelect, 'Value');
Names  = get(handles.HeaterSelect, 'UserData');
ChanNames = EPBI.(Names{Heater}).Intlk;
[Intlk_State, ~, Intlk_State_TimeStamp] = getpv(ChanNames);
EPBI.(Names{Heater}).Intlk_State           = Intlk_State;
EPBI.(Names{Heater}).Intlk_State_TimeStamp = Intlk_State_TimeStamp;


% Add a legend
%LegendCell = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
%LegendCell = get(handles.Legend, 'String');
clear LegendCell
for i = 1:length(EPBIData.Limit)
    if EPBI.(Names{Heater}).Intlk_State(i) == 1
        LegendCell{i,1} = sprintf('%s: %.2f Limit, Latched at start', deblank(EPBIData.ChannelNames(i,9:end-4)), EPBIData.Limit(i));
        
        EPBIData.TripIndex(i)       = 1;
        EPBIData.TripDate(i)        = now;
        EPBIData.HeaterOnTime(i)    = 0;
        EPBIData.TripTemperature(i) = NaN;
        
    else
        LegendCell{i,1} = sprintf('%s: %.2f Limit', deblank(EPBIData.ChannelNames(i,9:end-4)), EPBIData.Limit(i));
    end
end
%set(handles.Legend, 'String', LegendCell);

legend(handles.axes1, 'Off');
h_legend = legend(handles.axes1, LegendCell, 'Location', 'NorthWest');
set(h_legend, 'Interpreter', 'None');


% Update handles structure 
setappdata(handles.figure1, 'h_legend', h_legend);
setappdata(handles.figure1, 'EPBIStructure', EPBI);
setappdata(handles.figure1, 'EPBIData', EPBIData);
 

% Start the graph
if ~strcmp(get(handles.OnOffButton, 'String'), 'Running')
    OnOffButton_Callback(hObject, eventdata, handles);
else
    start(GraphTimer);
end

drawnow;

 
% --- Executes during object creation, after setting all properties.
function HeaterSelect_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Sector.
function Sector_Callback(hObject, eventdata, handles)

GraphTimer = getappdata(handles.figure1, 'GraphTimer');

stop(GraphTimer);
pause(.1);

Sector = get(handles.Sector, 'Value') + 3;
EPBI = getepbichannelnames(Sector);
ThrottleChannels = EPBI.Throttle;
EPBI = rmfield(EPBI, 'Throttle');

setappdata(handles.figure1, 'EPBIStructure', EPBI);

Names = fieldnames(EPBI);
set(handles.HeaterSelect, 'UserData', Names);
Value = get(handles.HeaterSelect, 'Value');

NameDesc = {};
for i = 1:length(Names)
    %if ~strcmpi(Names{i},'throttle')
        NameDesc{length(NameDesc)+1,1} = EPBI.(Names{i}).HeaterDesc;
    %end
end
if Value > length(NameDesc)
    set(handles.HeaterSelect, 'Value', 1);
end
set(handles.HeaterSelect, 'String', NameDesc);


% Set the Throttle to 5
setpv(ThrottleChannels, 5);
set(handles.UpdateRateMenu, 'UserData', ThrottleChannels);

HeaterSelect_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function Sector_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Outputs from this function are returned to the command line.
function varargout = epbitest2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;



function Heater_Timer_Callback(hObject, eventdata, handles)
% persistent HeaterCounter
% 
% if isempty(HeaterCounter)
%     set(handles.HeaterControl, 'String', sprintf('Heater activated %s',datestr(now, 14)));
%     HeaterCounter = 1;
% else
%    % set(handles.HeaterControl, 'String', sprintf('HeaterSelect reactivated %s',datestr(now,14)));
%     HeaterCounter = HeaterCounter + 1;
% end
% set(handles.HeaterControl, 'BackgroundColor', [.9 0 0]);

% Reset heater on
HeaterOn = getappdata(handles.figure1, 'EPBIHeaterOn');
setpvonline(HeaterOn, 1);



% --- Executes on button press in HeaterControl.
function HeaterControl_Callback(hObject, eventdata, handles)

EPBI        = getappdata(handles.figure1, 'EPBIStructure');
EPBIData    = getappdata(handles.figure1, 'EPBIData');
HeaterTimer = getappdata(handles.figure1, 'HeaterTimer');

OnFlag = get(handles.HeaterControl, 'Value');

if OnFlag
    
    if get(handles.OnOffButton, 'Value') == 0
        % Turn the data taking on
        set(handles.OnOffButton, 'Value', 1);
        OnOffButton_Callback(hObject, eventdata, handles)
    end
    
    % Get the heaterselect control channel info
    EPBI     = getappdata(handles.figure1, 'EPBIStructure');
    EPBIData = getappdata(handles.figure1, 'EPBIData');
    Sector   = get(handles.Sector, 'Value') + 3;
    Names    = get(handles.HeaterSelect, 'UserData');
    Heater   = get(handles.HeaterSelect, 'Value');
    %HeaterString = cellstr(get(handles.HeaterSelect,'String'));
    %HeaterSelect = HeaterString{HeaterNumber};
    
    HeaterOn  = EPBI.(Names{Heater}).HeaterActivate;
    HeaterOff = EPBI.(Names{Heater}).HeaterCancel;    
    setappdata(handles.figure1, 'EPBIHeaterOn',  HeaterOn);
    setappdata(handles.figure1, 'EPBIHeaterOff', HeaterOff);
    
    set(handles.Sector,       'Enable', 'Off');
    set(handles.HeaterSelect, 'Enable', 'Off');
    set(handles.Report,       'Enable', 'Off');
    
    % Add line to plot
    if ~isempty(EPBIData.t)
        EPBIData.HeaterIndex = size(EPBIData.TC, 2);
        EPBIData.HeaterStartTime = EPBIData.t(end);
        TCmin = min(EPBIData.TC(:,end));
        TCmax = max(EPBIData.TC(:,end));
        Range = TCmax - TCmin;
        set(handles.Lines(19), 'XData', [EPBIData.HeaterStartTime EPBIData.HeaterStartTime]-EPBIData.t(1), 'YData', [TCmin-.2*Range TCmax+.2*Range]);
    else
        EPBIData.HeaterIndex = [];
        EPBIData.HeaterStartTime = gettime;
    end
    
    % Set the EPICS countdown timer
    setpv(EPBI.(Names{Heater}).HeaterTimer, 60);
    
    HeaterOn = getappdata(handles.figure1, 'EPBIHeaterOn');
    set(handles.HeaterControl, 'String', sprintf('Heater activated %s',datestr(now, 14)));
    set(handles.HeaterControl, 'BackgroundColor', [.9 0 0]);
    setpvonline(HeaterOn, 1);

    start(HeaterTimer);
else
    try
        HeaterOff = getappdata(handles.figure1, 'EPBIHeaterOff');
        setpvonline(HeaterOff, 1);
        if strcmpi(get(HeaterTimer, 'Running'), 'on')
            stop(HeaterTimer);
            %delete(HeaterTimer);
        end
        drawnow;
        setpvonline(HeaterOff, 1);

        set(handles.HeaterControl, 'String', 'Heater is Off');
        set(handles.HeaterControl, 'BackgroundColor', [.702 .702 .702]);
        set(handles.Sector,        'Enable', 'On');
        set(handles.HeaterSelect,  'Enable', 'On');
        set(handles.Report,        'Enable', 'On');

        EPBIData.HeaterIndex     = [];
        EPBIData.HeaterStartTime = [];
    catch
        fprintf('   Trouble stopping the timer.\n');
    end
end

setappdata(handles.figure1, 'EPBIData', EPBIData);



% --- Executes on button press in OnOffButton.
function OnOffButton_Callback(hObject, eventdata, handles)

GraphTimer = getappdata(handles.figure1, 'GraphTimer');

State = get(handles.OnOffButton, 'String');
Value = get(handles.OnOffButton, 'Value');
if Value == 0  % strcmp(State, 'Running');
    % Turn off
    set(handles.OnOffButton, 'String', 'Stopped');
    set(handles.OnOffButton, 'BackgroundColor', [.6 .6 .6]);
    
    if strcmpi(get(GraphTimer, 'Running'), 'on')
        stop(GraphTimer);
    end
else
    % Turn on
    set(handles.OnOffButton, 'String', 'Running');
    set(handles.OnOffButton, 'BackgroundColor', [0 .6 .4]);
    
    % Add a NaN column
    EPBIData = getappdata(handles.figure1, 'EPBIData');
    if ~isempty(EPBIData.TC)
        EPBIData.t = [EPBIData.t gettime];
        EPBIData.TC = [EPBIData.TC NaN*EPBIData.TC(:,end)];
        setappdata(handles.figure1, 'EPBIData', EPBIData);
    end
    
    if strcmpi(get(GraphTimer, 'Running'), 'off')
        start(GraphTimer);
    end
end


% --------------------------------------------------------------------
function PopPlot1_Callback(hObject, eventdata, handles)

h_legend = getappdata(handles.figure1, 'h_legend');
LegendCell = get(h_legend, 'String');

iFig = figure;
p = get(iFig, 'Position');
p(3) = 1.3*p(3);
set(iFig, 'Position', p);
iAxes = copyobj(handles.axes1, iFig); 
set(iAxes, 'Position',[0.13 0.11 0.775 0.815]); 
%set(iAxes, 'ButtonDownFcn','');
%set(iAxes, 'XAxisLocation','Bottom');
%axes1 = axis;
%xlabel(iAxes, 'Time [Seconds]');

LegendCell = get(h_legend, 'String');
h = legend(iAxes, LegendCell, 'Location', 'NorthWest');
set(h, 'Interpreter', 'None');

i = get(handles.HeaterSelect, 'Value');
Out = get(handles.HeaterSelect, 'String');
Heater = Out{i};
i = get(handles.Sector, 'Value');
Out = get(handles.Sector, 'String');
Sector = Out{i};
title(iAxes, sprintf('%s  %s', Sector , Heater), 'Fontsize',16, 'FontWeight','Bold');
xlabel(iAxes, 'Time [Seconds]',  'FontSize', 14, 'FontWeight','Bold');
ylabel(iAxes, 'Temperature [C]', 'FontSize', 14, 'FontWeight','Bold');

orient portrait


% --------------------------------------------------------------------
function SaveMenu_Callback(hObject, eventdata, handles)

EPBIData = getappdata(handles.figure1, 'EPBIData');
%EPBI     = getappdata(handles.figure1, 'EPBIStructure');

if ~isempty(EPBIData.TC)
    
    FileName = 'EPBITest2';
    FileName = appendtimestamp(FileName, EPBIData.DataTime(1,1));
    
    if ispc
        DirectoryPath = 'M:\EPBI\Test2_Data\';
    else
        DirectoryPath = '/home/als/physdata/EPBI/Test2_Data/';
    end
    
    [FileName, DirectoryPath] = uiputfile({'*.mat','MAT-files (*.mat)'},'Pick an EPBI file', [DirectoryPath, FileName]);
    if FileName == 0
        return
    end
    EPBIFileName = [DirectoryPath, FileName];
    
    save(EPBIFileName, 'EPBIData');
else
    fprintf('No data to save.\n');
end



% --- Executes on button press in Report.
function Report_Callback(hObject, eventdata, handles)

EPBI     = getappdata(handles.figure1, 'EPBIStructure');
EPBIData = getappdata(handles.figure1, 'EPBIData');

if ~isempty(EPBIData.TC)
    if strcmpi(get(handles.Report, 'String'), 'Save Data')
        SaveMenu_Callback(hObject, eventdata, handles);
    else
        Sector = get(handles.Sector, 'Value') + 3;
        Heater = get(handles.HeaterSelect, 'Value');
        Names  = get(handles.HeaterSelect, 'UserData');
        
        %FileName = 'EPBITest2';
        FileName = sprintf('EPBI_Test2_Sector%d_%s', Sector, Names{Heater});
        FileName = appendtimestamp(FileName, EPBIData.DataTime(1,1));
        if ispc
            DirectoryPath = 'M:\EPBI\Test2_Data\';
        else
            DirectoryPath = '/home/als/physdata/EPBI/Test2_Data/';
        end
        FileName = [DirectoryPath, FileName];
        save(FileName, 'EPBIData');
        pause(0);
        
        
        fprintf('   Generating a report takes a long time (I''m not sure why).\n');
        fprintf('   A done message will be printed when complete.  Please wait!!!\n');
        set(handles.Report,        'String', 'Generating');
        set(handles.Report,        'Enable', 'Off');
        set(handles.Sector,        'Enable', 'Off');
        set(handles.OnOffButton,   'Enable', 'Off');
        set(handles.HeaterSelect,  'Enable', 'Off');
        set(handles.HeaterControl, 'Enable', 'Off');
        drawnow;
        publish_epbi(FileName);
        set(handles.Report,        'String', 'Generate Report');
        set(handles.Sector,        'Enable', 'On');
        set(handles.OnOffButton,   'Enable', 'On');
        set(handles.HeaterSelect,  'Enable', 'On');
        set(handles.HeaterControl, 'Enable', 'On');
        fprintf('   Done generating report.\n\n');
        drawnow;
    end
else
    fprintf('No data to publish.\n');
end


% --------------------------------------------------------------------
function PublishMenu_Callback(hObject, eventdata, handles)

fprintf('   Generating a report takes a really, really long time (I''m not sure why).  Wait for the done message.!!!\n');
set(handles.Report,        'String', 'Generating');
set(handles.Report,        'Enable', 'Off');
set(handles.Sector,        'Enable', 'Off');
set(handles.OnOffButton,   'Enable', 'Off');
set(handles.HeaterSelect,  'Enable', 'Off');
set(handles.HeaterControl, 'Enable', 'Off');
drawnow;
publish_epbi(FileName);
set(handles.Report,        'String', 'Generate Report');
set(handles.Sector,        'Enable', 'On');
set(handles.OnOffButton,   'Enable', 'On');
set(handles.HeaterSelect,  'Enable', 'On');
set(handles.HeaterControl, 'Enable', 'On');
fprintf('   Done generating report.\n\n');
drawnow;



% --------------------------------------------------------------------
function OpenPublishedFile_Callback(hObject, eventdata, handles)

% Directory
if isunix
    EPBIRootDir = '/home/als/physdata/EPBI/Publish/Test2/';
else
    EPBIRootDir = '\\als-filer\phydata\EPBI\Publish\Test2\';
end

[PlotFile, DirectoryPath] = uigetfile({'*.html','MAT-files (*.html)'},'Pick an EPBI HTML file', 'MultiSelect', 'off', EPBIRootDir);
if PlotFile == 0
    return
end
EPBIFileName = [DirectoryPath, PlotFile];

% Open website
web(EPBIFileName);
    


% --------------------------------------------------------------------
function NewApplication_Callback(hObject, eventdata, handles)

p = get(handles.figure1, 'Position');
h = epbitest2;
set(h,'Position', [p(1)+.25*p(3) p(2)-.05*p(4) p(3:4)]);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Turn heaterselect off
try
    HeaterOff   = getappdata(handles.figure1, 'EPBIHeaterOff');
    HeaterTimer = getappdata(handles.figure1, 'HeaterTimer');
    GraphTimer = getappdata(handles.figure1, 'GraphTimer');
    
    if strcmpi(get(GraphTimer, 'Running'), 'on')
        stop(GraphTimer);
    end

    if strcmpi(get(HeaterTimer, 'Running'), 'on')
        stop(HeaterTimer);
    end
    pause(.1);
    
    if ~isempty(HeaterOff)
        setpvonline(HeaterOff, 1);
    end
catch
end

% Delete all timers
h = timerfind('Tag', 'HeaterTimer');
for i = 1:length(h)
    try
        stop(h(i));
        delete(h(i));
    catch
    end
end

% Hint: delete(hObject) closes the figure
try
    drawnow;
    pause(.1);
    %close(hObject);
    %delete(hObject);
    delete(handles.figure1);
catch
end
