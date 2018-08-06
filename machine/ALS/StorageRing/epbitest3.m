function varargout = epbitest3(varargin)
% EPBITEST3 MATLAB code for epbitest3.fig
%      EPBITEST3, by itself, creates a new EPBITEST3 or raises the existing
%      singleton*.
%
%      H = EPBITEST3 returns the handle to a new EPBITEST3 or the handle to
%      the existing singleton*.
%
%      EPBITEST3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EPBITEST3.M with the given input arguments.
%
%      EPBITEST3('Property','Value',...) creates a new EPBITEST3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before epbitest3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to epbitest3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help epbitest3

% Last Modified by GUIDE v2.5 20-Aug-2012 13:17:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @epbitest3_OpeningFcn, ...
    'gui_OutputFcn',  @epbitest3_OutputFcn, ...
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


% --- Executes just before epbitest3 is made visible.
function epbitest3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to epbitest3 (see VARARGIN)

% Choose default command line output for epbitest3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes epbitest3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% to do:
% * Local bump?
% * plot/publish a saved file
% * resize figure
% * document


set(handles.JHOpenMonitor,   'String', '');
set(handles.JHClosedMonitor, 'String', '');


% IDList VCMList UpperDelta LowerDelta
EPBI_Input = [
    %[ 1 1] [ 2 2]  -8  9
    %[ 2 1] [ 3 2]  -8  9
    %[ 3 1] [ 4 2]  -8  9
    [ 4 1] [ 5 2]  -8  9
    [ 5 1] [ 6 2] -14 13
    [ 6 1] [ 7 2] -18 15
    %    [ 6 2] [ 7 2] -15 15
    [ 7 1] [ 8 2] -14 14
    [ 8 1] [ 9 2]  -9 11     % Note: this power supply is ringing badly!!!
    [ 9 1] [10 2] -13 14
    [10 1] [11 2] -12 15
    [11 1] [12 2] -10 10
    [12 1] [ 1 2] -15 15
    ];


% Make the table
for i = 1:size(EPBI_Input,1)
    data{i,1} = EPBI_Input(i,1);
    data{i,2} = false;
    data{i,3} = family2common('VCM', EPBI_Input(i,3:4));
    data{i,4} = EPBI_Input(i,5);
    data{i,5} = 'Upper';
end

columnname =   {'Sector',  'Select',  'Corrector', 'Delta',    'Upper/Lower'};
columnformat = {'numeric', 'logical', 'char',      'numeric', {'Upper' 'Lower'}};
columneditable = [false true false true true];
colwdt = {40 45 100 70 90};  % Set columns width

%TableWidth = sum(cell2mat(colwdt))+60;

handles.Plot{1} = plot(handles.axes1, [1 2], NaN);
handles.Plot{2} = plot(handles.axes2, [1 2], NaN*rand(2,2));
handles.Plot{3} = plot(handles.axes3, [1 2], NaN*rand(10,2));
handles.Plot{4} = plot(handles.axes4, [1 2], NaN*rand(2,2));

ylabel(handles.axes1, 'VCM [Amps]');
ylabel(handles.axes2, 'Orbit [mm]');
ylabel(handles.axes3, 'TC [C]');
ylabel(handles.axes4, 'Relay');
xlabel(handles.axes4, 'Time [Seconds]');

h_table = uitable(handles.figure1, ...
    'Units','normalized', ...
    'Position', [0.01 0.6 0.31 0.25], ...
    'Data', data,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth', colwdt, ...
    'ColumnEditable', columneditable,...
    'RowName',[], ...
    'RearrangeableColumns', 'off', ...
    'ToolTipString', '', ...
    'UserData', EPBI_Input, ...
    'CellEditCallback',{@TableEdit}, ...
    'CellSelectionCallback',{@TableSelection}, ...
    'Tag', 'Table');
handles.table = h_table;

% Update handles structure
guidata(hObject, handles);


function TableSelection(varargin)
h         = varargin{1};   % Table handle
TableInfo = varargin{2};   % Table info structure

if ~isempty(TableInfo.Indices)
    handles = guidata(get(h,'parent'));
    data = get(varargin{1}, 'Data');
    if TableInfo.Indices(1,2) == 3
        % Col 3 select - Corrector
        EPBI_Input = get(varargin{1}, 'UserData');
        
        VCM  = family2common('VCM');
        List = family2dev('VCM');
        [VCMNnew, i, CloseFlag] = editlist(VCM, ' ', zeros(size(VCM,1),1));
        if ~CloseFlag && ~isempty(i)
            data{TableInfo.Indices(1,1),3} = deblank(VCM(i(1),:));
            %Dev = List(i,:);
            set(varargin{1}, 'Data', data);
        end
        EPBI.Sector    = data{TableInfo.Indices(1,1), 1};
        EPBI.CMCommon  = deblank(data{TableInfo.Indices(1,1), 3});
        EPBI.CMDelta   = data{TableInfo.Indices(1,1), 4};
        EPBI.Direction = data{TableInfo.Indices(1,1), 5};
        setappdata(handles.figure1, 'EPBI', EPBI);
        
        set(handles.ApplyKick, 'Enable', 'Off');
    end
end
drawnow;


function TableEdit(varargin)

h         = varargin{1};   % Table handle
TableInfo = varargin{2};   % Table info structure
EPBI_Input = get(varargin{1}, 'UserData');
data = get(varargin{1}, 'Data');
handles = guidata(get(h,'parent'));

if TableInfo.Indices(1,2) == 2
    % Col 2 edit - Sector
    for i = 1:size(data,1)
        data{i,2} = false;
    end
    data{TableInfo.Indices(1,1), TableInfo.Indices(1,2)} = true;
    EPBI.Desc = 'EPBI Test3';
    EPBI.Sector    = data{TableInfo.Indices(1,1), 1};
    EPBI.Direction = data{TableInfo.Indices(1,1), 5};
    SetupAll = getepbichannelnames(EPBI.Sector);
    if strcmpi(EPBI.Direction, 'Upper')
        EPBI.Setup = SetupAll.HeaterA0;
    else
        EPBI.Setup = SetupAll.HeaterB0;
    end
    EPBI.Setup.Throttle = SetupAll.Throttle;
elseif TableInfo.Indices(1,2) == 4
    % Col 4 edit - rememder the delta
    EPBI = getappdata(handles.figure1, 'EPBI');
    EPBI_Input = get(varargin{1}, 'UserData');
    if strcmpi(data{TableInfo.Indices(1,1),5}, 'Upper')
        EPBI_Input(TableInfo.Indices(1,1),5) =  data{TableInfo.Indices(1,1),4};
    else
        EPBI_Input(TableInfo.Indices(1,1),6) =  data{TableInfo.Indices(1,1),4};
    end
    set(varargin{1}, 'UserData', EPBI_Input);
elseif TableInfo.Indices(1,2) == 5
    % Col 5 edit
    EPBI = getappdata(handles.figure1, 'EPBI');
    EPBI_Input = get(varargin{1}, 'UserData');
    if strcmpi(TableInfo.NewData, 'Upper')
        data{TableInfo.Indices(1,1),4} = EPBI_Input(TableInfo.Indices(1,1),5);
    else
        data{TableInfo.Indices(1,1),4} = EPBI_Input(TableInfo.Indices(1,1),6);
    end
end
set(varargin{1}, 'Data', data);
%p = get(varargin{1}, 'Position')
%set(varargin{1}, 'Position', [p(1)+.2*p(3) p(2:4)]);

EPBI.Sector    = data{TableInfo.Indices(1,1), 1};
EPBI.CMCommon  = deblank(data{TableInfo.Indices(1,1), 3});
EPBI.CMDelta   = data{TableInfo.Indices(1,1), 4};
EPBI.Direction = data{TableInfo.Indices(1,1), 5};
[EPBI.CMDevice, EPBI.CMFamily, ErrorFlag] = common2dev(EPBI.CMCommon);
setappdata(handles.figure1, 'EPBI', EPBI);

set(handles.PreKick,   'Enable', 'On');
set(handles.ApplyKick, 'Enable', 'Off');
set(handles.Restore,   'Enable', 'Off');
set(handles.Publish,   'Enable', 'Off');
drawnow;


% --- Outputs from this function are returned to the command line.
function varargout = epbitest3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PreKick.
function PreKick_Callback(hObject, eventdata, handles)

EPBI = getappdata(handles.figure1, 'EPBI');
EPBI.TCLimit = getpv(EPBI.Setup.Limit);

ChannelNames = [
    EPBI.Setup.TC;
    EPBI.Setup.IntlkSum
    ];

% Add 2 BPMs and the corrector AM
% In the future: add a BPM sum signal
% Note: cmm:beam_current is too slow
if EPBI.Sector == 12
    ChannelNameX = family2channel('BPMx','Monitor', [EPBI.Sector 1; EPBI.Sector 9]);
    ChannelNameY = family2channel('BPMy','Monitor', [EPBI.Sector 1; EPBI.Sector 9]);
else
    ChannelNameX = family2channel('BPMx','Monitor', [EPBI.Sector 1; EPBI.Sector+1 1]);
    ChannelNameY = family2channel('BPMy','Monitor', [EPBI.Sector 1; EPBI.Sector+1 1]);
end
ChannelNameVCM = family2channel(EPBI.CMFamily, 'Monitor', EPBI.CMDevice);
MoreChannels = [
    ChannelNameX
    ChannelNameY
    ChannelNameVCM
    ];
ChannelNames = strvcat(ChannelNames, MoreChannels);

EPBI.ChannelNames = ChannelNames;

% The EPBI PV update rate is 20 msec / throttle (ie, 50 Hz max)
setpv(EPBI.Setup.Throttle, 1);

% More TC resolution for EDM etc.
setpv(EPBI.Setup.TC, 'MDEL', 0);
pause(.1);

% Higher the bandwidth of the BPMs
BPMxTimeConstant = getpv('BPMx', 'TimeConstant', getbpmlist('Bergoz'));
BPMyTimeConstant = getpv('BPMy', 'TimeConstant', getbpmlist('Bergoz'));
setpv('BPMx', 'TimeConstant', .001);
setpv('BPMy', 'TimeConstant', .001);

% Setup the corrector
RampRateStart = getpv(EPBI.CMFamily, 'RampRate', EPBI.CMDevice);
setpv(EPBI.CMFamily, 'RampRate', 1000, EPBI.CMDevice);

% Starting CM setpoint
EPBI.CMSetpoint = getpv(EPBI.CMFamily, 'Setpoint', EPBI.CMDevice);

% Save the original setpoints
set(handles.PreKick, 'UserData', {RampRateStart, BPMxTimeConstant, BPMyTimeConstant});


% Enable the EPBI recorder
setpv('EPBI_TR_ARM_BC', 1);

% Make sure all the monitor channels are connected
[Data0, t, TimeStamp] = getpv(ChannelNames);

set(handles.ApplyKick, 'Enable', 'On');
set(handles.Restore,   'Enable', 'On');
set(handles.Publish,   'Enable', 'Off');

setappdata(handles.figure1, 'EPBI', EPBI);


% Add local bump???


drawnow


% --- Executes on button press in ApplyKick.
function ApplyKick_Callback(hObject, eventdata, handles)

EPBI = getappdata(handles.figure1, 'EPBI');

KickQuestion = questdlg(sprintf('Apply Kick for Sector %d %s?', EPBI.Sector, EPBI.Direction), 'EPBI Test #3', 'Yes', 'No', 'No');
if strcmp(KickQuestion, 'Yes')
    %   1. Local bump is needed before kicking
    %   2. If it doesn't kill the beam, adjust the kick or local bump
    
    %  Apply kick and get data
    t0 = gettime;
    setpv(EPBI.CMFamily, 'Setpoint', EPBI.CMSetpoint+EPBI.CMDelta, EPBI.CMDevice, 0);
    t1 = gettime;
    [Data, EPBI.t, EPBI.TimeStamp] = getpv(EPBI.ChannelNames, 0:.002:2);
    t2 = gettime;
    
    % Reset the corrector setpoint
    setpv(EPBI.CMFamily, 'Setpoint', EPBI.CMSetpoint, EPBI.CMDevice, 0);
    
    % Split the data up
    EPBI.TC = Data(1:size(EPBI.Setup.TC,1),:);
    Data(1:size(EPBI.Setup.TC,1),:) = [];
    
    EPBI.IntlkSum = Data(1:size(EPBI.Setup.IntlkSum,1),:);
    Data(1:size(EPBI.Setup.IntlkSum,1),:) = [];

    EPBI.X = Data(1:2,:);
    EPBI.Y = Data(3:4,:);
    EPBI.CMRBV = Data(5,:);

    % Waveform data recorder (assuming a trip occured)  ->  change this to getepbiwaveform(EPBI.Sector)???
    % Note: DataTime is last point in the waveform
    try
        for i = 1:9
            if Sector==5
                [EPBI.WF.TCUP(i,:), tmp, EPBI.WF_TimeStamp(i,1)] = getpv(sprintf('SR%02dW___TCUP%d_WF_AM', EPBI.Sector, i));
            else
                [EPBI.WF.TCUP(i,:), tmp, EPBI.WF_TimeStamp(i,1)] = getpv(sprintf('SR%02dS___TCUP%d_WF_AM', EPBI.Sector, i));
            end
        end
        clear tmp
    catch
    end
    
    setappdata(handles.figure1, 'EPBI', EPBI);
    set(handles.SaveData,   'Enable', 'On');
    
    % Plot
    PlotEPBIData(hObject, eventdata, handles);
end


function PlotEPBIData(hObject, eventdata, handles)
EPBI = getappdata(handles.figure1, 'EPBI');

set(handles.Plot{1}(1), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.CMRBV);

% set(handles.Plot{2}(1), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.X(1,:));
% set(handles.Plot{2}(2), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.X(2,:));

set(handles.Plot{2}(1), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.Y(1,:));
set(handles.Plot{2}(2), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.Y(2,:));

for i = 1:size(EPBI.TC,1)
    set(handles.Plot{3}(i), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.TC(i,:));
end

set(handles.Plot{4}(1), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.IntlkSum(1,:));
set(handles.Plot{4}(2), 'XData', EPBI.t-EPBI.t(1), 'YData', EPBI.IntlkSum(2,:));


% --- Executes on button press in SaveData.
function SaveData_Callback(hObject, eventdata, handles)

EPBI = getappdata(handles.figure1, 'EPBI');

% Save data
if ispc
    DirectoryPath = 'M:\EPBI\Test3_Data\';
else
    DirectoryPath = '/home/als/physdata/EPBI/Test3_Data/';
end

if strcmpi(EPBI.Direction, 'Upper')
    FileName = sprintf('EPBI_Test3_Sector%d_Upper', EPBI.Sector);
else
    FileName = sprintf('EPBI_Test3_Sector%d_Lower', EPBI.Sector);
end
FileName = [DirectoryPath, FileName];
FileName = appendtimestamp(FileName, clock);
save(FileName, 'EPBI');
fprintf('   Test #3 complete.  Data saved to %s', FileName);

set(handles.Restore,   'Enable', 'On');
set(handles.Publish,   'Enable', 'On');


% --- Executes on button press in Restore.
function Restore_Callback(hObject, eventdata, handles)

EPBI = getappdata(handles.figure1, 'EPBI');

% The EPBI PV update rate is 20 msec / throttle (ie, 50 Hz max)
setpv(EPBI.Setup.Throttle, 5);  % 10 Hz is typical

% Reset the ramp rates and time contants
DataStart = get(handles.PreKick, 'UserData');
setpv(EPBI.CMFamily, 'RampRate', DataStart{1}, EPBI.CMDevice);
setpv('BPMx', 'TimeConstant', DataStart{2}, getbpmlist('Bergoz'));
setpv('BPMy', 'TimeConstant', DataStart{3}, getbpmlist('Bergoz'));

set(handles.ApplyKick, 'Enable', 'Off');
set(handles.Publish,   'Enable', 'Off');


% --- Executes on button press in Publish.
function Publish_Callback(hObject, eventdata, handles)

%Plot EPBI Test 3
% plotepbitest3(EPBIFile);

%Publish
publish_epbi(EPBIFile)


% --- Executes on button press in OpenScrapers.
function OpenScrapers_Callback(hObject, eventdata, handles)
TimeOut = 20;

set(handles.JHClosedMonitor, 'String', '');
set(handles.JHOpenMonitor,   'String', 'Working');
set(handles.JHOpenMonitor,   'ForegroundColor', [0 .7 0]);

IsOpen = open_jh_scrapers('Set');
t0 = clock;
while ~IsOpen
    if etime(clock,t0)>TimeOut
        break;
    end
    pause(1);
    IsOpen = open_jh_scrapers('Check');
end

if IsOpen
    set(handles.JHOpenMonitor, 'String', 'Scrapers are open');
    set(handles.JHOpenMonitor, 'ForegroundColor', [0 0 .7]);
else
    set(handles.JHOpenMonitor, 'String', 'Scrapers are not Open!');
    set(handles.JHOpenMonitor, 'ForegroundColor', [.7 0 0]);
end


% --- Executes on button press in CloseScraper.
function CloseScraper_Callback(hObject, eventdata, handles)

TimeOut = 20;

set(handles.JHOpenMonitor,   'String', '');
set(handles.JHClosedMonitor, 'String', 'Working');
set(handles.JHClosedMonitor, 'ForegroundColor', [0 .7 0]);

IsClosed = close_jh_scrapers('Set');
t0 = clock;
while IsClosed
    if etime(clock,t0)<TimeOut
        break;
    end
    pause(1);
    IsClosed = close_jh_scrapers('Check');
end

if IsClosed
    set(handles.JHClosedMonitor, 'String', 'Scrapers are closed');
    set(handles.JHClosedMonitor, 'ForegroundColor', [0 0 .7]);
else
    set(handles.JHClosedMonitor, 'String', 'Scrapers are not closed!');
    set(handles.JHClosedMonitor, 'ForegroundColor', [.7 0 0]);
end


% --- Executes on button press in LocalBump.
function LocalBump_Callback(hObject, eventdata, handles)
% hObject    handle to LocalBump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
