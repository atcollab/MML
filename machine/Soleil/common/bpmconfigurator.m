 function varargout = bpmconfigurator(varargin)
% BPMCONFIGURATOR M-file for bpmconfigurator.fig
%      BPMCONFIGURATOR, by itself, creates a new BPMCONFIGURATOR or raises the existing
%      singleton*.
%
%      H = BPMCONFIGURATOR returns the handle to a new BPMCONFIGURATOR or the handle to
%      the existing singleton*.
%
%      BPMCONFIGURATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BPMCONFIGURATOR.M with the given input arguments.
%
%      BPMCONFIGURATOR('Property','Value',...) creates a new BPMCONFIGURATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bpmconfigurator_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bpmconfigurator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help bpmconfigurator

% Last Modified by GUIDE v2.5 20-Mar-2007 12:21:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bpmconfigurator_OpeningFcn, ...
                   'gui_OutputFcn',  @bpmconfigurator_OutputFcn, ...
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


% --- Executes just before bpmconfigurator is made visible.
function bpmconfigurator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bpmconfigurator (see VARARGIN)

% Choose default command line output for bpmconfigurator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bpmconfigurator wait for user response (see UIRESUME)
% uiwait(handles.figure1);
AO = {};
setappdata(handles.figure1,'AO', AO);

% init oppmenu for commands and attributes
% Mode is not read by readattribute

switch getsubmachinename
    case 'Booster_old'
        set(handles.popupmenu_Attribute,'String',{'NumSamples','Mode', ...
            'BufferFreezingEnabled','BufferFrozen'});
        set(handles.popupmenu_Command,'String',{'Init','State', ...
            'DisableBufferFreezing', 'EnableBufferFreezing', 'UnFreezeBuffer'});
    case {'Booster', 'StorageRing', 'LT2'}
        set(handles.popupmenu_Attribute,'String',{'AGCEnabled', 'DDBufferSize','Gain','DDTriggerCounter', ...
            'DDBufferFreezingEnabled','DDBufferFrozen', 'DDEnabled','SAEnabled','Switches'});
        set(handles.popupmenu_Command,'String',{'Init','State', 'Status', ...
            'DisableDD', 'DisableSA','EnableDDBufferFreezing', 'UnFreezeDDBuffer', ...
            'DisableDDBufferFreezing', 'EnableDD', 'EnableSA'});
        tablist = (0:-1:-60)';
        set(handles.popupmenu_Gain,'String', num2str(tablist));
        handles.groupID = tango_group_create('BPM'); 
        tango_group_add(handles.groupID,family2tangodev('BPMx')');
    otherwise
        error('Wrong SubMachine %s', getsubmachinename);
end

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = bpmconfigurator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_Command.
function popupmenu_Command_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_Command contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Command


% --- Executes during object creation, after setting all properties.
function popupmenu_Command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Apply.
function pushbutton_Apply_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer = questdlg('Do you want to apply change ?','Confirmation dialog box');

% get selected bpm
iSelected = get(handles.listbox_Bpm,'Value');

AO        = getappdata(handles.figure1,'AO');
% Status one devices
valid  = find(AO.Status);
valid = intersect(iSelected,valid);

if isempty(valid)
    disp('Non BPM selected or status 0');
    return;
end


valS = repmat('NaN',size(AO.DeviceName));
val = cellstr(valS);

switch answer
    case 'Yes'
        %get selected command
        icmd = get(handles.popupmenu_Command,'Value');
        cmdlist = get(handles.popupmenu_Command,'String');
        command = cmdlist{icmd};
        switch command
            case 'State'
                set(handles.listbox_Attribute,'String',val);
                for k=1:length(valid),
                    val0 = tango_command_inout2(AO.DeviceName{valid(k)},command);
                    val{valid(k)} = val0;
                end
                set(handles.listbox_Attribute,'String',val);
            otherwise % not output command
                for k=1:length(valid),
                    tango_command_inout2(AO.DeviceName{valid(k)},command);
                end
        end
    case {'No','Cancel'}
        return;
    otherwise
        warning('Wrong answer')
end


function edit_Attribute_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Attribute as text
%        str2double(get(hObject,'String')) returns contents of edit_Attribute as a double

answer = questdlg('Do you want to apply change ?','Confirmation dialog box');
iSelected = get(handles.listbox_Bpm,'Value');

AO     = getappdata(handles.figure1,'AO');
% Status one devices
valid  = find(AO.Status);

valid = intersect(iSelected,valid);

if isempty(valid)
    disp('Non BPM selected or status 0');
    return;
end

switch answer
    case 'Yes'

        % Get the new value
        value = get(hObject,'String');
        if iscell(value)
            value = cellstr(value);
        end
                
        iAttribute = get(handles.popupmenu_Attribute,'Value');
        attribute = get(handles.popupmenu_Attribute,'String');

        if iAttribute == 1 || iAttribute == 2 || iAttribute == 3 || iAttribute == 6  || iAttribute == 7 
            value = str2double(value);
        end
        value = repmat(value,size(valid'));
        
        % Test on variable type
        switch attribute{iAttribute}
            case {'NumSamples','DDBufferSize'}
                type = 'int32';
            case 'Switches'
                type = 'int16';
            case 'Mode'
                type = 'String';
            case  {'DDEnabled','SAEnabled','AGCEnabled'}
                type = 'uint8';
            otherwise
                type = 'double';
        end         
        
        disp([mfilename ': Processing ...']);
%         if (get(handles.checkbox_All,'Value') == 0)
             %% Get selected elements
             
            writeattribute(strcat(AO.DeviceName(valid), ...
                '/',attribute(iAttribute)), value,type);
%         else % All the same
%             writeattribute(strcat(AO.DeviceName(valid), ...
%                 '/',attribute(iAttribute)), value,type)
%         end
        disp([mfilename ': Done ']);
        % refresh display
        pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);

    case {'No','Cancel'}
        return;
    otherwise
        warning('Wrong answer')
end


% --- Executes during object creation, after setting all properties.
function edit_Attribute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Refresh.
function pushbutton_Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% refresh ALL
iBpm = get(handles.listbox_Bpm,'Value');
iAttribute = get(handles.popupmenu_Attribute,'Value');
attribute = get(handles.popupmenu_Attribute,'String');

AO = getappdata(handles.figure1,'AO');

valid  = find(AO.Status);
val = ones(size(AO.DeviceName))*NaN';
valS = repmat('NaN',size(AO.DeviceName));
val0 = readattribute(strcat(AO.DeviceName(valid),'/',char(attribute(iAttribute))));

if iscellstr(val0)
    val = cellstr(valS);
    for k=1:length(valid)
        val{valid(k)} = val0{k};
    end
else
    val(valid) = val0;
end

% unpdate listbox
set(handles.listbox_Attribute,'String',val);
% update editbox 
set(handles.edit_Attribute,'String',val(1));
set(handles.listbox_Attribute,'Value',1);
set(handles.listbox_Bpm,'Value',1);
% uncheckk buttons
set(handles.checkbox_All,'Value', 0);
set(handles.checkbox_None,'Value', 0);

% --- Executes on selection change in popupmenu_Attribute.
function popupmenu_Attribute_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_Attribute contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Attribute

% Force a refresh
bpmconfigurator('pushbutton_Refresh_Callback',hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_Attribute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_All.
function checkbox_All_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_All (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_All

val = get(handles.listbox_Bpm,'String');

if get(hObject,'Value') == 1
    set(handles.checkbox_None,'Value',0);
    set(handles.listbox_Bpm,'Value',1:length(val));
    set(handles.listbox_Attribute,'Value',1:length(val));
    set(handles.listbox_Bpm,'listboxtop',1);
    set(handles.listbox_Attribute,'listboxtop',1);
end

% --- Executes on button press in checkbox_None.
function checkbox_None_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_None (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_None

if get(hObject,'Value') == 1
    set(handles.checkbox_All,'Value',0);
    set(handles.listbox_Bpm,'Value',1);
    set(handles.listbox_Attribute,'Value',1);
end


% --- Executes on selection change in listbox_Bpm.
function listbox_Bpm_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_Bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_Bpm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_Bpm

idx = get(hObject,'Value');
set(handles.listbox_Attribute,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));

set(handles.checkbox_All,'Value',0);
set(handles.checkbox_None,'Value',0);


% --- Executes during object creation, after setting all properties.
function listbox_Bpm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_Bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_Attribute.
function listbox_Attribute_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_Attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_Attribute contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_Attribute
contents = get(hObject,'String');
idx = get(hObject,'Value');
set(handles.listbox_Bpm,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.checkbox_All,'Value',0);
set(handles.checkbox_None,'Value',0);

% Selected only first element
% If all elements are numeric, return a char array and not a cell!
if ischar(contents)
    contents = cellstr(contents);
end
set(handles.edit_Attribute,'String',contents{idx(1)});

% --- Executes during object creation, after setting all properties.
function listbox_Attribute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_Attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uimenuBooster_Callback(hObject, eventdata, handles)
% hObject    handle to uimenuBooster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AD = getad;

if isempty(AD) || ~strcmpi(AD.SubMachine,'Booster')
    setpathsoleil('Booster');
end

init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function uimenuAnneau_Callback(hObject, eventdata, handles)
% hObject    handle to uimenuAnneau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AD = getad;

if isempty(AD) || ~strcmpi(AD.SubMachine,'StorageRing')
    setpathsoleil('StorageRing');
end

init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function handles = init_uimenu(hObject, eventdata, handles)

AO = getfamilydata('BPMx');
setappdata(handles.figure1,'AO', AO);

%% Checked box
all = findobj(get(hObject,'Parent'),'Type','UImenu');
set(all, 'Checked', 'Off');
set(hObject, 'Checked', 'On');

%% Initialize popupmenu w/ BPM
listbpm = AO.DeviceName;
set(handles.listbox_Bpm,'String',listbpm);

devlist = get(handles.listbox_Bpm,'String');
val = readattribute([devlist{1},'/', 'SAEnabled']);
ii = get(handles.uipanel_mode,'Children');
if val == 1
    set(handles.uipanel_mode,'SelectedObject', ii(2));
else
    set(handles.uipanel_mode,'SelectedObject', ii(1));
end
val = readattribute([devlist{1},'/', 'AGCEnabled']);
set(handles.radiobutton_AGC,'Value', val);
%cmdlist = get(handles.popupmenu_Command,'String');


% --------------------------------------------------------------------
function uimenuLT2_Callback(hObject, eventdata, handles)
% hObject    handle to uimenuLT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AD = getad;

if isempty(AD) || ~strcmpi(AD.SubMachine,'LT2')
    setpathsoleil('LT2');
end

init_uimenu(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu_Gain.
function popupmenu_Gain_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_Gain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Gain

contents = get(hObject,'String');
att = str2double(contents(get(hObject,'Value'),:));
tango_group_write_attribute(handles.groupID,'Gain',0,att);
pause(1);
pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_TbyTmode.
function checkbox_TbyTmode_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_TbyTmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_TbyTmode

value = get(hObject,'Value');
if value == 0 % deactivation of SA mode
    tango_group_write_attribute(handles.groupID,'DDEnabled',0, uint8(0));
else % activation of SA mode
    tango_group_write_attribute(handles.groupID,'DDEnabled',0, uint8(1));
end
pause(1);
pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);

% --- Executes on button press in checkbox_SAmode.
function checkbox_SAmode_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_SAmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SAmode

value = get(hObject,'Value');
if value == 0 % deactivation of SA mode
    tango_group_write_attribute(handles.groupID,'SAEnabled',0, uint8(0));
    %% deactivate switching Switches attribute 255 to 3
    tango_group_write_attribute(handles.groupID,'Switches',0, 3);
else % activation of SA mode
    tango_group_write_attribute(handles.groupID,'SAEnabled',0, uint8(1));
    %% activate switching Digital Signal Conditioning
    tango_group_write_attribute(handles.groupID,'DSCEnabled',0, uint8(1));
end
pause(1);
pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);


% --------------------------------------------------------------------
function uipanel_mode_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radiobutton1' % SA mode
        % Active switching mecanisme (work around for now because of Device
        % bugs)
        tango_group_write_attribute(handles.groupID,'Switches',0,int16(255));
        tango_group_write_attribute(handles.groupID,'DSCEnabled',0,uint8(1));
        pause(1);
        pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);
    case 'radiobutton2'
        % Deactive switching mecanisme (work around for now because of Device
        % bugs)
        tango_group_write_attribute(handles.groupID,'Switches',0,int16(3));
        pause(1);
        pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);
    % Continue with more cases as necessary.
end


% --- Executes on button press in radiobutton_AGC.
function radiobutton_AGC_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_AGC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_AGC

value = get(hObject,'Value');
if value == 1
    tango_group_write_attribute(handles.groupID,'AGCEnabled',0,uint8(1));
    pause(1);
    pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);
else
    tango_group_write_attribute(handles.groupID,'AGCEnabled',0,uint8(0));
    pause(1);
    pushbutton_Refresh_Callback(handles.pushbutton_Refresh,eventdata, handles);
end


% --- Executes on button press in pushbutton_initALL.
function pushbutton_initALL_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_initALL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

commandName = 'Init';
tango_group_command_inout2(handles.groupID,commandName,0,0);
pause(1);

