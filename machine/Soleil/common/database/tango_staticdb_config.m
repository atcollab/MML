function varargout = tango_staticdb_config(varargin)
% TANGO_STATICDB_EDITOR M-file for tango_staticdb_config.fig
%      TANGO_STATICDB_EDITOR, by itself, creates a new TANGO_STATICDB_EDITOR or raises the existing
%      singleton*.
%
%      H = TANGO_STATICDB_EDITOR returns the handle to a new TANGO_STATICDB_EDITOR or the handle to
%      the existing singleton*.
%
%      TANGO_STATICDB_EDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TANGO_STATICDB_EDITOR.M with the given input arguments.
%
%      TANGO_STATICDB_EDITOR('Property','Value',...) creates a new TANGO_STATICDB_EDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tango_staticdb_config_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tango_staticdb_config_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help tango_staticdb_config

% Last Modified by GUIDE v2.5 24-Mar-2006 11:54:22

% Laurent S. Nadolski, SOLEIL

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @tango_staticdb_config_OpeningFcn, ...
    'gui_OutputFcn',  @tango_staticdb_config_OutputFcn, ...
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


% --- Executes just before tango_staticdb_config is made visible.
function tango_staticdb_config_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tango_staticdb_config (see VARARGIN)

% Choose default command line output for tango_staticdb_config
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tango_staticdb_config wait for user response (see UIRESUME)
% uiwait(handles.figure1);

disp('TANGO Static DataBase Configurator');

set(handles.figure1,'HandleVisibility','Callback');
set(handles.listbox_log, 'String',{[datestr(now) ': application started'], ' '});

% uimenu_anneau_Callback(handles.uimenu_LT1, eventdata, handles);
%uimenu_LT1_Callback(handles.uimenu_LT1, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = tango_staticdb_config_OutputFcn(hObject, eventdata, handles)
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
family   = contents{num};

AO = getfamilydata(family);
setappdata(handles.figure1,'AO',AO);
setappdata(handles.figure1, 'Family', family);

%% Status one devices
valid  = find(AO.Status);
%% Builds up attribut list for selected family
if ~iscell(AO.DeviceName)
    AO.DeviceName = {AO.DeviceName};
end

attributeList = tango_get_attribute_list(AO.DeviceName{valid(1)});

if isnumeric(attributeList) &&  attributeList == -1
    error('Cannot communicate with device %s',AO.DeviceName{valid(1)})
end

num = get(handles.popupmenu_attribute,'Value');
if num > length(attributeList)
    num = 1;
    set(handles.popupmenu_attribute,'Value',num);
end
set(handles.popupmenu_attribute,'String',attributeList);

%setback selected elements and property to first one
set(handles.listbox_property,'Value',1);
set(handles.listbox_group,'Value',1);
set(handles.listbox_dev_property,'Value',1);

popupmenu_attribute_Callback(handles.popupmenu_attribute, eventdata, handles);

%% Build up command list
% popupmenu_group_Callback(handles.popupmenu_attribute, eventdata, handles);

commandList = tango_command_list_query(AO.DeviceName{valid(1)});

num = get(handles.popupmenu_command,'Value');
if num > length(attributeList)
    num = 1;
    set(handles.popupmenu_command,'Value',num);
end

% trick for getting a field array from a cell array
commandOutputType = eval(['{commandList.', 'out_type}']);
commandInputType  = eval(['{commandList.', 'in_type}']);
setappdata(handles.figure1,'cmd_output_type',commandOutputType);
setappdata(handles.figure1,'cmd_input_type',commandInputType);
commandList = eval(['{commandList.', 'cmd_name}']);

set(handles.popupmenu_command,'String',commandList);

%% Build up a NaN attribute value pannel
set(handles.listbox_attribute,'String', repmat('NaN',size(AO.DeviceName)));
set(handles.listbox_dev_property,'String', repmat('NaN',size(AO.DeviceName)));

%% Build up device property device list
devPropList = tango_command_list_query(AO.DeviceName{valid(1)});

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

family     = getappdata(handles.figure1,'Family');
AO         = getappdata(handles.figure1,'AO');

%% Selects valid devices
valid  = find(AO.Status);
%% Builds up property list for selected family

if ~iscell(AO.DeviceName)
    AO.DeviceName = cellstr(AO.DeviceName);
end
    
propertyList = fieldnames(tango_attribute_query(AO.DeviceName{valid(1)}, attribute));

num = get(hObject,'Value');
if num > length(propertyList)
    num = 1;
    set(handles.popupmenu_property,'Value',num);
end
set(handles.popupmenu_property,'String',propertyList);

% Reset to first item in selection list
set(handles.listbox_property,'Value',1);
set(handles.listbox_group,'Value',1);
set(handles.listbox_attribute,'Value',1);

popupmenu_property_Callback(handles.popupmenu_property, eventdata, handles);

%set(handles.radiobutton_property,'Value',1);

% Update handles structure
guidata(hObject, handles);

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


% --- Executes on selection change in popupmenu_property.
function popupmenu_property_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_property (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_property contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_property

contents  = get(hObject,'String');
num       = get(hObject,'Value');
property  = contents{num};

attribute  = get(handles.popupmenu_attribute,'String');
iattribute = get(handles.popupmenu_attribute,'Value');
AO         = getappdata(handles.figure1,'AO');


% Status one devices
valid  = find(AO.Status);

% Update Group list

if ~iscell(AO.DeviceName) 
    AO.DeviceName = {AO.DeviceName};
end

set(handles.listbox_group,'String',AO.DeviceName(valid));

% Contruct DeviceName/AttributName list
fullTangoNames = strcat(AO.DeviceName(valid), '/', attribute{iattribute});

% Builds up property list
list = tango_get_attribute_property(fullTangoNames, property);
set(handles.listbox_property,'String',list);
% Reset to first item in selection list
set(handles.listbox_property,'Value',1);
set(handles.listbox_group,'Value',1);
set(handles.listbox_attribute,'Value',1);
set(handles.checkbox_all,'Value',0);

writelog(['Values for property ''' char(property) ''' refreshed'],handles);

%popupmenu_command_Callback(handles.popupmenu_property, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_property_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_property (see GCBO)
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

idx = get(hObject,'Value');

set(handles.listbox_attribute,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_property,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_dev_property,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.checkbox_all,'Value',0);

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

contents = get(hObject,'String');
idx = get(hObject,'Value');

set(handles.listbox_group,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_attribute,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_dev_property,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.checkbox_all,'Value',0);

set(handles.edit_value,'String',contents{idx(1)});

%select radiobutton
set(handles.radiobutton_property,'Value',1);

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
val = get(handles.listbox_group,'String');

if get(hObject,'Value') == 1
    set(handles.listbox_group,'Value',1:length(val));
    set(handles.listbox_attribute,'Value',1:length(val));
    set(handles.listbox_property,'Value',1:length(val));
    set(handles.listbox_dev_property,'Value',1:length(val));
    set(handles.listbox_group,'listboxtop',1);
    set(handles.listbox_attribute,'listboxtop',1);
    set(handles.listbox_property,'listboxtop',1);
    set(handles.listbox_dev_property,'listboxtop',1);
end

function edit_value_Callback(hObject, eventdata, handles)
% hObject    handle to edit_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_value as text
%        str2double(get(hObject,'String')) returns contents of edit_value as a double

% First of all, ask for confirmation
answer = questdlg('Do you want to apply change ?','Confirmation dialog box');

switch answer
    case 'Yes'

        % Get the new value 
        % Need to force char array
        value = char(get(hObject,'String'));       

        attribute  = get(handles.popupmenu_attribute,'String');
        iattribute = get(handles.popupmenu_attribute,'Value');
        property   = get(handles.popupmenu_property,'String');
        iproperty  = get(handles.popupmenu_property,'Value');        
        iSelected  = get(handles.listbox_group,'Value');
        Family     = getappdata(handles.figure1, 'Family');
        DeviceName = family2tangodev(Family);

        switch get(handles.radiobutton_property,'Value')

            case 1 % property change

                %% Get selected element                
                writelog(['Please wait: writting property ' property{iproperty}  '...'], handles);
                
                tango_set_attribute_property(strcat(DeviceName(iSelected), ...
                    '/',attribute{iattribute}),property{iproperty}, value)
                
                writelog('Properties written', handles);
                
                % refresh display
                popupmenu_property_Callback(handles.popupmenu_property,eventdata, handles);

            case 0 %attribute change
                                               
               writelog(['Please wait: writting attributes ', attribute{iattribute}, '  ...'], handles);
 
               value = repmat(value,size(DeviceName(iSelected),1),1);
               writeattribute(strcat(DeviceName(iSelected), ...
                   '/',attribute{iattribute}), value, 'QueryDB');

               writelog('Attributes written', handles);

                % refresh display
                pushbutton_refresh_Callback(handles.pushbutton_refresh,eventdata, handles);
        end
    case {'No','Cancel'}
        return;
    otherwise
        warning('Wrong answer')
end




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

% -------------------------------------------------------------------------
function uimenu_LT1_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_LT1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AD = getad;

if isempty(AD)
    LT1init;
elseif ~strcmpi(AD.Machine,'LT1')
    LT1init;
end

writelog('LT1 loaded',handles);
handles = init_uimenu(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

% -------------------------------------------------------------------------
function handles = init_uimenu(hObject, eventdata, handles)

%% Checked box
all = findobj(get(hObject,'Parent'),'Type','UImenu');
set(all, 'Checked', 'Off');
set(hObject, 'Checked', 'On');

%% Initialize popupmenu w/ first element, first attribute, first property
listfamily = fieldnames(getfamilydata);
set(handles.popupmenu_group,'String',listfamily);

popupmenu_group_Callback(handles.popupmenu_group, eventdata, handles);

% --------------------------------------------------------------------
function uimenu_booster_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_booster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AD = getad;

if isempty(AD)
    boosterinit;
elseif ~strcmpi(AD.Machine,'Booster')
    boosterinit
end

writelog('Booster loaded',handles);
init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function uimenu_LT2_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_LT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AD = getad;

if isempty(AD)
    LT2init
elseif ~strcmpi(AD.Machine,'LT2')
    LT2init;
end

writelog('LT2 loaded',handles);

init_uimenu(hObject, eventdata, handles);

% --------------------------------------------------------------------
function uimenu_anneau_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_anneau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

machineName = getsubmachinename;

if isempty(machineName)
    soleilinit;
elseif ~strcmpi(machineName,'StorageRing')
    soleilinit
end

writelog('Ring loaded',handles);

init_uimenu(hObject, eventdata, handles);

% --- Executes on selection change in listbox_attribute.
function listbox_attribute_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_attribute contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_attribute

contents = get(hObject,'String');
idx = get(hObject,'Value');
set(handles.listbox_group,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_property,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_dev_property,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.checkbox_all,'Value',0);

% Selected only first element
% If all elements are numeric, return a char array and not a cell!
if ischar(contents)
    contents = cellstr(contents);
end
set(handles.edit_value,'String',contents{idx(1)});

%select radiobutton
set(handles.radiobutton_attribute,'Value',1);

% --- Executes during object creation, after setting all properties.
function listbox_attribute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_attribute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_command.
function popupmenu_command_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_command contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_command

contents  = get(hObject,'String');
num       = get(hObject,'Value');
command  = contents{num};

setappdata(handles.figure1,'command', command);

% --- Executes during object creation, after setting all properties.
function popupmenu_command_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_command (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_apply.
function pushbutton_apply_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Apply command

answer = questdlg('Do you want to apply change ?','Confirmation dialog box');

switch answer
    case 'Yes'
        % get selected device
        iSelected = get(handles.listbox_group,'Value');

        Family = getappdata(handles.figure1, 'Family');
        DeviceName = family2tangodev(Family);

        if isempty(iSelected)
            writelog('Non device names selected or status 0',handles);
            return;
        end

        valS = repmat('NaN',size(DeviceName));
        val = cellstr(valS);
        %get selected command
        icmd    = get(handles.popupmenu_command,'Value');
        cmdlist = get(handles.popupmenu_command,'String');
        command = cmdlist{icmd};
        
        writelog(['Applying command: ' command], handles);
        set(handles.listbox_attribute,'String',val);
        
        commandOutputType = getappdata(handles.figure1,'cmd_output_type');
        commandOutputType = commandOutputType{icmd};
        commandInputType  = getappdata(handles.figure1,'cmd_input_type');
        commandInputType  = commandInputType{icmd};

        switch commandOutputType
            case {'1-by-n char'}        
                for k = 1:length(iSelected),
                    val0 = tango_command_inout2(DeviceName{iSelected(k)},command);
                    val{iSelected(k)} = val0;
                end
                set(handles.listbox_attribute,'String',val);
            otherwise % not output command
                for k=1:length(iSelected),
                    tango_command_inout2(DeviceName{iSelected(k)},command);
                end
        end
        writelog('Command applied', handles);
    case {'No','Cancel'}
        return;
    otherwise
        warning('Wrong answer')
end


% --- Executes on button press in pushbutton_refresh.
function pushbutton_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% attributes
% refresh ALL
ifamily = get(handles.popupmenu_group,'Value');
family = get(handles.popupmenu_group,'String');

Family = family{ifamily};
DeviceName = family2tangodev(Family);

if isempty(Family)
    writelog('No machine loaded!',handles);
    return
end

iattribute = get(handles.popupmenu_attribute,'Value');
attribute  = get(handles.popupmenu_attribute,'String');
iSelected  = get(handles.listbox_group,'Value');

val  = ones(size(DeviceName))*NaN';
valS = repmat('NaN',size(DeviceName));
%val0 = readattribute(strcat(DeviceName,'/',char(attribute(iattribute))));
val0 = readattribute(strcat(DeviceName(iSelected),'/',char(attribute(iattribute))));

if iscellstr(val0) % See timestamp for MON as an example
    val = cellstr(valS);
    val(iSelected,:) = val0;
else
    val(iSelected) = val0;
end

% % update listbox
 set(handles.listbox_attribute,'String',val);
% % update editbox     
% set(handles.edit_value,'String',val(1));
% set(handles.listbox_attribute,'Value',1);
% set(handles.listbox_group,'Value',1);
% set(handles.listbox_dev_property,'Value',1);
% set(handles.listbox_property,'Value',1);
% % uncheck buttons
% set(handles.checkbox_all,'Value', 0);

writelog(['Values for attribute ''' char(attribute(iattribute)) ''' refreshed'],handles);

% --- Executes on selection change in listbox_log.
function listbox_log_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_log contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_log


% --- Executes during object creation, after setting all properties.
function listbox_log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function writelog(strvalue, handles)
% Add stuff in the logging window

str = get(handles.listbox_log, 'String');
str = {str{:} [datestr(now) ': ' strvalue]};
% update logging window
set(handles.listbox_log, 'String',str,'ListBoxTop',length(str));


% --- Executes on selection change in listbox_dev_property.
function listbox_dev_property_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_dev_property (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_dev_property contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_dev_property
contents = get(hObject,'String');
idx = get(hObject,'Value');

set(handles.listbox_group,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_attribute,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_property,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.listbox_dev_property,'Value',idx,'ListBoxTop',get(hObject,'ListboxTop'));
set(handles.checkbox_all,'Value',0);

set(handles.edit_value,'String',contents{idx(1)});


% --- Executes during object creation, after setting all properties.
function listbox_dev_property_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_dev_property (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_dev_prop.
function popupmenu_dev_prop_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_dev_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_dev_prop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_dev_prop
contents  = get(hObject,'String');
num       = get(hObject,'Value');
devproperty  = contents{num};

setappdata(handles.figure1,'devproperty', devproperty);


% --- Executes during object creation, after setting all properties.
function popupmenu_dev_prop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dev_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dev_propvalue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dev_propvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dev_propvalue as text
%        str2double(get(hObject,'String')) returns contents of edit_dev_propvalue as a double
% First of all, ask for confirmation
answer = questdlg('Do you want to apply change ?','Confirmation dialog box');

switch answer
    case 'Yes'

        % Get the new value
        % Need to force char array
        value = char(get(hObject,'String'));

        propertyname  = get(handles.edit_dev_propname,'String');
        propertyvalue = get(handles.edit_dev_propvalue,'String');
        Family        = getappdata(handles.figure1, 'Family');
        DeviceName    = family2tangodev(Family);

        iSelected = get(handles.listbox_group,'Value');

        val = tango_get_device_property(DeviceName(iSelected), ...
            propertyname);

        %% Get selected element
        if isempty(val)
            writelog(['Cancelled: property ' str2mat(propertyvalue)  'not defined'], handles);
            set(handles.listbox_dev_property,'String', repmat('NaN',size(DeviceName)));
        else
            writelog(['Please wait: writting DEVICE property ' str2mat(propertyvalue)  '...'], handles);

            tango_set_device_property(DeviceName(iSelected), ...
                propertyname, propertyvalue);

            writelog('Device properties written', handles);

            % refresh display
            pushbutton_dev_prop_Callback(handles.edit_dev_propvalue,eventdata, handles);
        end
    case {'No','Cancel'}
        return;
    otherwise
        warning('Wrong answer')
end


% --- Executes during object creation, after setting all properties.
function edit_dev_propvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dev_propvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dev_propname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dev_propname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dev_propname as text
%        str2double(get(hObject,'String')) returns contents of edit_dev_propname as a double


% --- Executes during object creation, after setting all properties.
function edit_dev_propname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dev_propname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_dev_prop.
function pushbutton_dev_prop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dev_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ifamily = get(handles.popupmenu_group,'Value');
family  = get(handles.popupmenu_group,'String');

Family        = family{ifamily};
DeviceName    = family2tangodev(Family);

if isempty(Family)
    writelog('No machine loaded!',handles);
    return
end

val = ones(size(DeviceName))*NaN';
valS = repmat('NaN',size(DeviceName));

property  = get(handles.edit_dev_propname,'String');

val0 = tango_get_device_property(DeviceName,property);

if isempty(val0)
    writelog(['Property ''' property ''' not defined'],handles);
    return;
end

if iscellstr(val0)
    val = cellstr(val0);
else
    val = val0;
end

% unpdate listbox
set(handles.listbox_dev_property,'String',val);
% update editbox     
set(handles.edit_value,'String',val(1));
set(handles.listbox_attribute,'Value',1);
set(handles.listbox_group,'Value',1);
set(handles.listbox_dev_property,'Value',1);
set(handles.listbox_property,'Value',1);
% uncheckk buttons
set(handles.checkbox_all,'Value', 0);

writelog(['Values for property ''' property ''' refreshed'],handles);

