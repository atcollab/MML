function varargout = tango_archiving_config(varargin)
% TANGO_ARCHIVING_CONFIG M-file for tango_archiving_config.fig
%      TANGO_ARCHIVING_CONFIG, by itself, creates a new TANGO_ARCHIVING_CONFIG or raises the existing
%      singleton*.
%
%      H = TANGO_ARCHIVING_CONFIG returns the handle to a new TANGO_ARCHIVING_CONFIG or the handle to
%      the existing singleton*.
%
%      TANGO_ARCHIVING_CONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TANGO_ARCHIVING_CONFIG.M with the given input arguments.
%
%      TANGO_ARCHIVING_CONFIG('Property','Value',...) creates a new TANGO_ARCHIVING_CONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tango_archiving_config_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tango_archiving_config_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help tango_archiving_config

% Last Modified by GUIDE v2.5 07-Apr-2005 09:47:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @tango_archiving_config_OpeningFcn, ...
    'gui_OutputFcn',  @tango_archiving_config_OutputFcn, ...
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

%
% Written by Laurent S. Nadolski


% --- Executes just before tango_archiving_config is made visible.
function tango_archiving_config_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tango_archiving_config (see VARARGIN)

% Choose default command line output for tango_archiving_config
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tango_archiving_config wait for user response (see UIRESUME)
% uiwait(handles.figure1);

disp('TANGO Archiving Configurator');

%% Look for archiving manager TANGO name in static Database
archivingmanager = cell2mat(tango_get_db_property('archivage','archivingmanager'));
tango_set_timeout(archivingmanager,30000);

setappdata(handles.figure1,'archivingmanager', archivingmanager);

%% Initialize database {HDB} and machine {LT1}
handles.database='HDB';
guidata(hObject, handles);

hdbmenu_Callback(hObject, eventdata, handles);
uimenu_anneau_Callback(handles.uimenu_LT1, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = tango_archiving_config_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in popupmenu_group.
function popupmenu_group_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_group contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_group

contents = get(hObject,'String');
num      = get(hObject,'Value');
group    = contents{num};

setappdata(handles.figure1,'group', group);

AO       = getappdata(handles.figure1,'AO');

% Status one devices
valid  = find(AO.(group).Status);

% Update Group list
set(handles.listbox_group,'String',AO.(group).DeviceName(valid));

set(handles.popupmenu_command,'BackgroundColor','red');

% Builds up attribut list for selected group
attributeList = tango_get_attribute_list(AO.(group).DeviceName{valid(1)});

num = get(handles.popupmenu_attribute,'Value');
if num > length(attributeList)
    num = 1;
    set(handles.popupmenu_attribute,'Value',num);
end
set(handles.popupmenu_attribute,'String',attributeList);

popupmenu_attribute_Callback(handles.popupmenu_attribute, eventdata, handles);

%setback selected element and property to first one
set(handles.listbox_property,'Value',1);
set(handles.listbox_group,'Value',1);


% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_attribute.
function popupmenu_attribute_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_attribute contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_attribute

contents  = get(hObject,'String');
num       = get(hObject,'Value');
attribute = contents{num};

setappdata(handles.figure1,'attribute', attribute);

% --- Executes during object creation, after setting all properties.
function popupmenu_attribute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_command.
function popupmenu_command_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_command contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_command

%% Set color to Green
set(handles.popupmenu_command,'BackgroundColor','green');

contents  = get(hObject,'String');
num       = get(hObject,'Value');
command  = contents{num};

setappdata(handles.figure1,'command', command);

group     = getappdata(handles.figure1,'group');
attribute = getappdata(handles.figure1,'attribute');
AO        = getappdata(handles.figure1,'AO');

% Status one devices
valid  = find(AO.(group).Status);

% Construct DeviceName/AttributName list
%host = getenv('TANGO_HOST'); %% TODO PAS PROPRE mais pour rester conforme avec archiving
%fullTangoNames = strcat('//',host,'/',AO.(group).DeviceName(valid), '/', attribute);
fullTangoNames = strcat(AO.(group).DeviceName(valid), '/', attribute);
archivingmanager = getappdata(handles.figure1,'archivingmanager');

if (get(handles.checkbox_all,'Value') == 0)
    %% Get selected element
    idx = get(handles.listbox_property,'Value');
    fullTangoNamesV = fullTangoNames(idx);
else % All the same
    fullTangoNamesV = fullTangoNames';
end

% Select database
switch handles.database
    case 'HDB'
        command = [command 'Hdb'];
    case 'TDB'
        command = [command 'Tdb'];
end

% switchyard on commands
switch command(1:end-3)
    case {'IsArchived'} % check archiving state
        argin = fullTangoNames';
        list = tango_command_inout2(archivingmanager,command,argin)';
        set(handles.listbox_property,'String',list);

    case {'GetArchivingMode'} % Get archiving mode
        list = [];
        for k = 1:length(fullTangoNames)
            argin = fullTangoNames{k};
            answer = tango_command_inout2(archivingmanager,command,argin);
            list = [list ; format_output_list(answer)];
        end

        %% Format data for fast print out
        Name = strcat(AO.(group).DeviceName(valid), '/', attribute);
        [n1 n2] = size(list);
        Strcell = cell(n2+1,n1);
        Strcell(end,:) = Name;
        Strcell(1:end-1,:) = num2cell(list');

        %% TODO: location for file, check fopen is OK
        directory = getfamilydata('Directory','Archiving');
        filename = [directory 'summarymodedata.txt'];
        %filename = tempname;
        [fid message] = fopen(filename,'w');
        if fid == -1
            message
            return;
        end

        fprintf(fid,['# ',handles.database ' DATABASE: File generated on' ...
            ' %s\n'],datestr(now));
        fprintf(fid,['# Periodic Mode      Absolute Mode       ' ...
            '  Relative Mode       TANGO attribute Name   \n']);
        fprintf(fid,['#      T(s)    T(s)     min      max     ' ...
            'T(s)     min      max    \n']);
        fprintf(fid,'    %7.1f %7.1f %8.2f %8.2f %7.1f %8.2f %8.2f  %s\n',Strcell{:});
        fclose(fid);

        % edit 'modedata.txt'
        if isunix
            system(['nedit ', filename, ' &']);  % much faster
%             eval(['edit ' filename])
        else
            eval(['edit ' filename])
        end

    case {'ArchivingStart'}% Start archiving

        %% Selects archiving mode
        mode = archiving_panel_mode(handles.database);
               
        if isstruct(mode) % means not canceled
            %% Build up the argument for sIntermediatetarting archiving
            %% Check for different modes selected by user
            argin = BuildArgin(fullTangoNamesV, mode,handles);
            
            if isnumeric(argin) && argin == -1
                disp('No Archiving mode selected, does nothing');
                return;
            end
            
            start_archiving(archivingmanager,command,argin,handles);

            %% Force a IsArchived call to check if everything as
            %% expected
            set(handles.popupmenu_command,'Value',1);
            popupmenu_command_Callback(hObject, eventdata, handles);
        end

    case {'ArchivingStop'}% Stop archiving
        argin = fullTangoNamesV';
        error = tango_command_inout2(archivingmanager,command,argin);
        display_archiving_error(error,handles);

        set(handles.popupmenu_command,'Value',1);
        popupmenu_command_Callback(hObject, eventdata, handles);

    case {'ArchivingModif'}% Get archiving mode
        list = []; % clear list
        % build list
        for k = 1:length(fullTangoNamesV) % length(fullTangoNames) % Get the first one if a list
            argin = fullTangoNamesV{k};
            answer = tango_command_inout2(archivingmanager,['GetArchivingMode' command(end-2:end)],argin);
            list = [list ; format_output_list(answer)];
        end

        % Selects archiving mode
        % List contains existing archiving modes to be modified
        mode = archiving_panel_mode(handles.database,list);

        if isstruct(mode) % means not canceled

            %% Build up the argument for starting archiving
            %% Check for different modes selected by user
            argin = BuildArgin(fullTangoNamesV, mode,handles);

            start_archiving(archivingmanager,command,argin,handles);

            %% Force a IsArchived call to check if everything as
            %% expected
            set(handles.popupmenu_command,'Value',1);
            popupmenu_command_Callback(hObject, eventdata, handles);
        end

    otherwise
        disp('Command not implemented')
end

% Update handles structure
guidata(handles.figure1, handles);


function argin = BuildArgin(fullTangoNames, mode, handles)
% Build up the argument for starting archiving
% Check for different modes selected by user

[temp ismodeselected] = findkeyword(mode.selection,'1');
if ismodeselected == 0 % no mode selected
    argin = -1;
    return;
    
elseif ismodeselected == 1 % at least an archiving mode selected
    
    %Load balancing
    
    %% standard header
    % 1. archiver name for load balancing feature
    % 2. group feature true or false (not implemented to the end)
    switch mode.grouped
        case '0'
            header = {'toto', 'false'};
        case '1'
            % Force to flase since not yet implemented in matlab gui
            header = {'toto', 'false'};
            % header = {'toto', 'true'};
    end
    
    %% Not required fields set to default values
    % 1. data type
    % 2. data format
    % 3. writable
    % 4. device in charge
    % 5. Trigger time
    
    header_attribute = { '0', '0', '0', '','NULL'};

    % header length for each attribut
    % depends on the mode selection
    len = 6;
    len_mode = 0;
    
    % number of attributes to archive
    nb = length(fullTangoNames);
    
    % mode parametrization
    mode_P ={};
    mode_A ={};
    mode_R ={};
    mode_string = {};

    if str2double(mode.selection{1}) == 1 %% Periodic mode
        len = len + 3;
        len_mode = len_mode + 2;
        if strcmpi(handles.database,'HDB')
            mode.periodic.period = [mode.periodic.period '000']; % ms
        end
        mode_P = {'MODE_P', mode.periodic.period};
    end

    if str2double(mode.selection{2}) == 1 % Absolute mode
        len = len + 4;
        len_mode = len_mode + 4;
        if strcmpi(handles.database,'HDB')
            mode.absolute.period = [mode.absolute.period '000']; % ms
        end
        mode_A = {'MODE_A', mode.absolute.period,...
            mode.absolute.lowerlimit, mode.absolute.upperlimit};
    end

    if str2double(mode.selection{3}) == 1 %Relative mode
        len = len + 4;
        len_mode = len_mode + 4;
        if strcmpi(handles.database,'HDB')
            mode.relative.period = [mode.relative.period '000']; % ms
        end
        mode_R = {'MODE_R', mode.relative.period,...
            mode.relative.lowerlimit,mode.relative.upperlimit};
    end

    mode_string = {mode_P{:}, mode_R{:}, mode_A{:}};
    
    switch handles.database %% Select database
        case 'TDB' %% Intermediate DATABASE
            len = len +3;
            len_mode = len_mode + 3;
            mode_string = {mode_string{:}, 'TDB_SPEC', ...
                mode.exportwindow, mode.keepingwindow};
        case 'HDB' %% Historical DATABASE
            % No extra arguments
    end
    
    argin = header;
    
    % loop over list of attributed to be archived
    for k = 1:nb        
        argin = {argin{:}, num2str(len), fullTangoNames{k}, ...
            header_attribute{:}, num2str(len_mode), mode_string{:}};
    end
     
end

function start_archiving(archivingmanager,command,argin,handles)
% START_ARCHIVING - Start or modify an archiving
%
% INPUTS
% archivingmanager - TANGO name of the archiving manager
% command - start or modify archiving, could be 
%         - ArchivingStart 
%         - ArchivingModif 
%         - ArchivingStartIntermediate 
%         - ArchivingModifIntermediate
% argin - inputs arguments related to command (see archivingmanager doc )
%
error = tango_command_inout2(archivingmanager,command,argin);

display_archiving_error(error,handles);

function display_archiving_error(error,handles)
%DISPLAY_ARCHIVING_ERROR - Display error reason
% Errorhandler
% See archivingmanager documentation for details

switch error
    case 0
        %% start succeeded
        return;
    case 1
        disp('All the given attribute already archiving process')
    case 2
        disp('start failed')
    case 3
        % stop succeeded
        return;
    case 4
        disp('All giving attributs are not in archiving process');
    case 5
        disp('Stop failed');
    case 6
        %% Modif succeeded
        return;
    case 7
        disp('All given attributes are not in historic archiving');
    case 8
        disp('modif failed');
    case 9
        disp('No running [H/T]dbArchiver')
    case 10
        disp('All the attribute do not exist in static DB')
    case 11
        disp('database not connected')
    case 12
        disp('device cannot talk to the database')
    otherwise
        disp('Unknown error')
end

warning(['Error with ', handles.database,' database']);


% --- Executes during object creation, after setting all properties.
function popupmenu_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox_group.
function listbox_group_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_group contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_group

set(handles.listbox_property,'Value',get(hObject,'Value'));
set(handles.listbox_property,'ListboxTop',get(hObject,'ListboxTop'));


% --- Executes during object creation, after setting all properties.
function listbox_group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox_property.
function listbox_property_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_property (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_property contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_property

set(handles.listbox_group,'Value', get(hObject,'Value'));
set(handles.listbox_group,'ListboxTop', get(hObject,'ListboxTop'));

%set(handles.edit_value,'String',contents{get(hObject,'Value')});

% --- Executes during object creation, after setting all properties.
function listbox_property_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_property (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in checkbox_all.
function checkbox_all_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_all

function edit_value_Callback(hObject, eventdata, handles)
% hObject    handle to edit_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_value as text
%        str2double(get(hObject,'String')) returns contents of edit_value as a double

value = get(hObject,'String');

group     = getappdata(handles.figure1,'group');
attribute = getappdata(handles.figure1,'attribute');
property  = getappdata(handles.figure1,'property');
AO        = getappdata(handles.figure1,'AO');

%% Status one devices
valid  = find(AO.(group).Status);

if (get(handles.checkbox_all,'Value') == 0)
    %% Get selectedd element
    idx = get(handles.listbox_property,'Value');
    tango_set_attribute_property(strcat(AO.(group).DeviceName{valid(idx)}, ...
        '/',attribute),property, value)
else % All the same
    tango_set_attribute_property(strcat(AO.(group).DeviceName(valid), ...
        '/',attribute),property, value)
end
%% Status one devices
valid  = find(AO.(group).Status);

%% refresh display
popupmenu_property_Callback(handles.popupmenu_command,eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --------------------------------------------------------------------
function uimenu_linac_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_linac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function uimenu_LT1_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_LT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~strcmpi(getsubmachinename, 'LT1')
    LT1init;
end
handles = init_uimenu(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

%%%--------------------------------------------------------------------
function handles = init_uimenu(hObject, eventdata, handles)

setappdata(handles.figure1,'AO', getao);

%% Checked box
all = findobj(get(hObject,'Parent'),'Type','UImenu');
set(all, 'Checked', 'Off');
set(hObject, 'Checked', 'On');

%% Initializes popupmenu w/ first element, first attribute, first property
listgroup = findmemberof('Archivable');

set(handles.popupmenu_group,'String',listgroup);
setappdata(handles.figure1,'group', listgroup{1});

popupmenu_group_Callback(handles.popupmenu_group, eventdata, handles);

%% Initializes command popup menu w/ list of archivingmanager available
%% commands
% res = tango_command_list_query(archivingmanager);
% listcmd = {res.cmd_name};
listcmd = {'IsArchived','GetArchivingMode', 'ArchivingStart', ...
    'ArchivingStop','ArchivingModif'};
set(handles.popupmenu_command,'String',listcmd);
value = find(strcmp(listcmd,'IsArchived'));
set(handles.popupmenu_command,'Value',value);
setappdata(handles.figure1,'command', value);

% --------------------------------------------------------------------
function uimenu_booster_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_booster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~strcmpi(getsubmachinename, 'Booster')
    boosterinit
end
init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function uimenu_LT2_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_LT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~strcmpi(getsubmachinename, 'LT2')
   LT2init;
end
init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function uimenu_anneau_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_anneau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~strcmpi(getsubmachinename, 'StorageRing') 
    soleilinit;
end
init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function hdbmenu_Callback(hObject, eventdata, handles)
% hObject    handle to menuhdb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.hdbmenu,'checked','On');
set(handles.tdbmenu,'checked','Off');
handles.database='HDB';
set(handles.mainuipanel,'Title','TANGO HDB Configurator', ...
    'ForegroundColor',[0, 0.5, 0]);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function tdbmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tdbmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tdbmenu,'checked','On');
set(handles.hdbmenu,'checked','Off');
handles.database='TDB';
set(handles.mainuipanel,'Title','TANGO TDB Configurator','ForegroundColor','b');
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_loadbalancing.
function checkbox_loadbalancing_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_loadbalancing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_loadbalancing

function list = format_output_list(varargin)

cellarray = varargin{:};

list = zeros(1,7);

% Periodical mode: just get archiving period
[cellarray index] = findkeyword2(cellarray,'MODE_P');
if index ~= 0
    list(1) = str2double(cellarray(index))/1e3; % seconds
end

% Absolute mode: just get archiving period and variation limits
[cellarray index] = findkeyword2(cellarray,'MODE_A');
if index ~= 0
    list(2) = str2double(cellarray(index))/1e3; % seconds
    list(3) = str2double(cellarray(index+1)); % decreasing variation (%)
    list(4) = str2double(cellarray(index+2)); % increasing variation (%)
end

% Relative mode: just get archiving period and variation limits
[cellarray index] = findkeyword2(cellarray,'MODE_R');
if index ~= 0
    list(5) = str2double(cellarray(index))/1e3; % seconds
    list(6) = str2double(cellarray(index+1)); % decreasing variation (%)
    list(7) = str2double(cellarray(index+2)); % increasing variation (%)
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox_group.
function listbox_group_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% TODO: works only if right button pressed
%       do not know how to do for left button
val = get(handles.listbox_group,'Value');
set(handles.listbox_property,'Value',val);


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function savemenu_Callback(hObject, eventdata, handles)
% hObject    handle to savemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

summarymenu_Callback(hObject, eventdata, handles);
directory = getfamilydata('Directory','Archiving');
filename1 = [directory appendtimestamp('config')];
filename0 = [directory 'config.dat'];
copyfile(filename0,filename1);

% --------------------------------------------------------------------
function summarymenu_Callback(hObject, eventdata, handles)
% hObject    handle to summarymenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AO        = getappdata(handles.figure1,'AO');
archivingmanager = getappdata(handles.figure1,'archivingmanager');

%grouplist = intersect(findmemberof('Magnet'),findmemberof('Archivable'));
grouplist = findmemberof('Archivable');

% get database name
switch handles.database
    case 'HDB'
        dbName = 'Hdb';
    case 'TDB'
        dbName = 'Tdb';
end

directory = getfamilydata('Directory','Archiving');
%filename = [directory appendtimestamp('config')];
filename = [directory 'config.dat'];
fid = fopen(filename,'w');

fprintf(fid,['# ',handles.database ' DATABASE: File generated on' ...
    ' %s\n'],datestr(now));
fprintf(fid,['# Periodic Mode      Absolute Mode       ' ...
    '  Relative Mode       TANGO attribute Name   \n']);
fprintf(fid,['#      T(s)    T(s)     min      max     ' ...
    'T(s)     min      max    \n']);

for k1 = 1:length(grouplist),
    % loop of group of devices
    %get attribut list
    % Status one devices
    valid  = find(AO.(grouplist{k1}).Status);

    for k2 = 1:length(valid)
        % loop over devices
        % Builds up attribut list for selected groups
        attributeList = tango_get_attribute_list(AO.(grouplist{k1}).DeviceName{valid(k2)});
        for k3 = 1:length(attributeList),
            % loop over attributes
            %check if archived
            try
                argin = strcat(AO.(grouplist{k1}).DeviceName(valid(k2)), '/', attributeList{k3});
                arstatus = tango_command_inout2(archivingmanager,['IsArchived' dbName], argin);
            catch
                fprintf('Erreur with attribute %s\n Action aborted \n', attributeList{k3});
                return;
            end
            if arstatus
                %get Archiving modes
                answer = tango_command_inout2(archivingmanager,['GetArchivingMode' dbName], argin{:});
                list = format_output_list(answer);

                %% Format data for fast print out
%                 Name = strcat(AO.(groupLIST(k1)).DeviceName(valid(k2)), '/', attributelist{k3});
                Name = argin;
                [n1 n2] = size(list);
                Strcell = cell(n2+1,n1);
                Strcell(end,:) = Name;
                Strcell(1:end-1,:) = num2cell(list');
                fprintf(fid,'    %7.1f %7.1f %8.2f %8.2f %7.1f %8.2f %8.2f  %s\n',Strcell{:});
            end
        end
    end
end

fclose(fid);

% show file
if isunix
    system(['nedit ', filename, ' &']);  % much faster
else
    eval(['edit ' filename])
end


% --------------------------------------------------------------------
function loadmenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Not implemented yet')
