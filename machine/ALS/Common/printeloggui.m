function varargout = printeloggui(varargin)
% PRINTELOGGUI M-file for printeloggui.fig
%      PRINTELOGGUI by itself, creates a new PRINTELOGGUI or raises the
%      existing singleton*.
%
%      H = PRINTELOGGUI returns the handle to a new PRINTELOGGUI or the handle to
%      the existing singleton*.
%
%      PRINTELOGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRINTELOGGUI.M with the given input arguments.
%
%      PRINTELOGGUI('Property','Value',...) creates a new PRINTELOGGUI or raises the
%      existing singleton*.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help printeloggui

% Last Modified by GUIDE v2.5 11-Aug-2014 22:26:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @printeloggui_OpeningFcn, ...
                   'gui_OutputFcn',  @printeloggui_OutputFcn, ...
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

% --- Executes just before printeloggui is made visible.
function printeloggui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to printeloggui (see VARARGIN)

% Choose default command line output for printeloggui
handles.output = 'Cancel';

% Update handles structure
guidata(hObject, handles);


% Inputs:  Author, Subject, Category, ScalingFlag
FigureNumbers = [];
Logbook = 'Operations';
Author = 'Guest';
Category = 'Other';
ScalingFlag = 1;
Subject = 'Matlab Figure';
DisplayFlag = 1;
TextString = 'Print from Matlab worked!';
ScalingFlag = 1;

if length(varargin) >= 1
    FigureNumbers = varargin{1};
end
if length(varargin) >= 2
    Logbook = varargin{2};
end
if length(varargin) >= 3
    Author = varargin{3};
end
if length(varargin) >= 4
    Category = varargin{4};
end
if length(varargin) >= 5
    Subject = varargin{5};
end
if length(varargin) >= 6
    TextString = varargin{6};
end
if length(varargin) >= 7
    ScalingFlag = varargin{7};
end


% Set to gui
if isempty(FigureNumbers)
    set(handles.FigureNumbers, 'String', '[]');
else
    %if datenum(version('-date')) > datenum(2014,6,1)
    %    astring = num2str(FigureNumbers(1).Number);
    %    for i = 2:length(FigureNumbers)
    %        astring = [astring, ' ', num2str(round(FigureNumbers(i).Number))];
    %    end
    %else
        astring = num2str(FigureNumbers(1));
        for i = 2:length(FigureNumbers)
            astring = [astring, ' ', num2str(round(FigureNumbers(i)))];
        end
    %end
    set(handles.FigureNumbers, 'String', astring);
end

List = get(handles.Logbook,'String');
i = find(strcmpi(Logbook,List)==1);
if ~isempty(i)
    set(handles.Logbook, 'Value', i);
end

Logbook_Callback(hObject, eventdata, handles);

List = get(handles.Author,'String');
i = find(strcmpi(Author,List)==1);
if ~isempty(i)
    set(handles.Author, 'Value', i);
end

List = get(handles.Category,'String');
i = find(strcmpi(Category,List)==1);
if ~isempty(i)
    set(handles.Category, 'Value', i);
end

set(handles.Subject,   'String', Subject);
set(handles.TextField, 'String', TextString);

if ScalingFlag
    set(handles.FixedSize,   'Value', 1);
    set(handles.FixedSizeNo, 'Value', 0);
else
    set(handles.FixedSize,   'Value', 0);
    set(handles.FixedSizeNo, 'Value', 1);
end



% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
% if(nargin > 3)
%     for index = 1:2:(nargin-3),
%         if nargin-3==index, break, end
%         switch lower(varargin{index})
%          case 'title'
%           set(hObject, 'Name', varargin{index+1});
%          case 'string'
%           set(handles.text1, 'String', varargin{index+1});
%         end
%     end
% end

% % Determine the position of the dialog - centered on the callback figure
% % if available, else, centered on the screen
% FigPos=get(0,'DefaultFigurePosition');
% OldUnits = get(hObject, 'Units');
% set(hObject, 'Units', 'pixels');
% OldPos = get(hObject,'Position');
% FigWidth = OldPos(3);
% FigHeight = OldPos(4);
% if isempty(gcbf)
%     ScreenUnits=get(0,'Units');
%     set(0,'Units','pixels');
%     ScreenSize=get(0,'ScreenSize');
%     set(0,'Units',ScreenUnits);
% 
%     FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
%     FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
% else
%     GCBFOldUnits = get(gcbf,'Units');
%     set(gcbf,'Units','pixels');
%     GCBFPos = get(gcbf,'Position');
%     set(gcbf,'Units',GCBFOldUnits);
%     FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
%                    (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
% end
% FigPos(3:4)=[FigWidth FigHeight];
% set(hObject, 'Position', FigPos);
% set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=questIconMap;

Img=image(IconData, 'Parent', handles.axes1);
set(handles.figure1, 'Colormap', IconCMap);

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes printeloggui wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = printeloggui_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure

s = get(handles.FigureNumbers, 'String');
varargout{1} = str2num(s);

i = get(handles.Logbook, 'Value');
s = get(handles.Logbook, 'String');
if iscell(s)
    varargout{2} = s{i};
else
    varargout{2} = s;
end

i = get(handles.Author, 'Value');
s = get(handles.Author, 'String');
if iscell(s)
    varargout{3} = s{i};
else
    varargout{3} = s;
end

i = get(handles.Category, 'Value');
s = get(handles.Category, 'String');
if iscell(s)
    varargout{4} = s{i};
else
    varargout{4} = s;
end

varargout{5} = get(handles.Subject, 'String');
if strcmpi(varargout{5},'Subject?')
    varargout{5} = 'Matlab Figure';
end

varargout{6} = get(handles.TextField, 'String');
if strcmpi(varargout{6},'Entry?')
    varargout{6} = ' ';
end

if get(handles.FixedSize, 'Value') == 1
    varargout{7} = 1;  %'Yes';
else
    varargout{7} = 0;  %'No';
end

if strcmpi(handles.output, 'Print to eLog')
    varargout{8} = 'Print';
else
    varargout{8} = 'Cancel';
end

% The figure can be deleted now
delete(handles.figure1);


% --- Executes on button press in PrinteLog.
function PrinteLog_Callback(hObject, eventdata, handles)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs to get the updated handles structure.
uiresume(handles.figure1);



% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs to get the updated handles structure.
uiresume(handles.figure1);



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, just close it
    delete(handles.figure1);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.figure1);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.figure1);
end    


% --- Executes on selection change in Logbook.
function Logbook_Callback(hObject, eventdata, handles)

% Categories change with the logbook
i = get(handles.Logbook, 'Value');
s = get(handles.Logbook, 'String');
c = get(handles.Category, 'String');
if any(strcmpi(s{i},{'Physics','Orbit','Timing','Instrumentation','Test'}))
    Categories = {
        'BBA - Beam based alignment'
        'BPM'
        'Bug report'
        'Computer'
        'Electrical'
        'EPS'
        'Information'
        'Machine setup'
        'Mechanical'
        'Network'
        'Other'
        'RF'
        'RSS'
        'Safety'
        'Shift report'
        'Vacuum'
        'Water'
        };
    
    %if get(handles.Category, 'Value') > length(Categories)
    set(handles.Category, 'String', Categories);
    if length(c) ~= length(Categories)
        % Default
        set(handles.Category, 'Value', 9);
    end

elseif any(strcmpi(s{i},{'HLC','Controls'}))
    Categories = {
        'Software'
        'Hardware'
        'Network'
        'Other'
        };

    %if get(handles.Category, 'Value') > length(Categories)
    if length(c) ~= length(Categories)
        % Default
        set(handles.Category, 'Value', 3);
    end
    set(handles.Category, 'String', Categories);
end

drawnow;


% --- Executes on selection change in Author.
function Author_Callback(hObject, eventdata, handles)


function TextField_Callback(hObject, eventdata, handles)


function FigureNumbers_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of FigureNumbers as text
%        str2double(get(hObject,'String')) returns contents of FigureNumbers as a double


% --- Executes during object creation, after setting all properties.
function FigureNumbers_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


