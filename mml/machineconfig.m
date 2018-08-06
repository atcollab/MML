function machineconfig(varargin)
%MACHINECONFIG - GUI for setmachineconfig
%
%  See also plotfamily, viewfamily

% Written by Greg Portmann


% Run initialization if it has not been run (like standalone)
checkforao;


FileName = 'Golden';
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Remove structures
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Remove cells
        varargin(i) = [];
    elseif ischar(varargin{i})
        % Look for keywords
        if strcmpi(varargin{i},'struct')
            % Remove
            varargin(i) = [];
        elseif strcmpi(varargin{i},'numeric')
            % Remove
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Golden')
            % Golden file
            FileName = 'Golden';
            varargin(i) = [];
        elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
            ModeFlag = varargin{i};
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Online')
            ModeFlag = 'Online';
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Manual')
            ModeFlag = 'Manual';
            varargin(i) = [];
        elseif strcmpi(varargin{i},'physics')
            UnitsFlag = 'Physics';
            varargin(i) = [];
        elseif strcmpi(varargin{i},'hardware')
            UnitsFlag = 'Hardware';
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Display')
            DisplayFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'NoDisplay')
            DisplayFlag = 0;
            varargin(i) = [];
        end
    end
end


% Check for a lattice file input
if length(varargin) >= 1
    if ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
    end
end

if isempty(FileName)
    if any(strcmpi(getfamilydata('Machine'),{'spear3','spear'}))
        DirectoryName = getfamilydata('Directory', 'GoldenConfigFiles');
    else
        DirectoryName = getfamilydata('Directory', 'ConfigData');
    end
    [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to restore', DirectoryName);
    if FileName == 0
        fprintf('   No change to lattice (machineconfig)\n');
        return
    else
        FileName = fullfile(DirectoryName, FileName);
    end
end

if strcmpi(FileName, 'Golden') || strcmpi(FileName, 'Production')
    FigureTitle = sprintf('Saved values come from golden file: %s',    [getfamilydata('Directory', 'OpsData') getfamilydata('OpsData','LatticeFile')]);
elseif strcmpi(FileName, 'Injection')
    FigureTitle = sprintf('Saved values come from injection file: %s', [getfamilydata('Directory', 'OpsData') getfamilydata('OpsData','InjectionFile')]);
else
    %[Directory, FileNameTmp, Ext] = fileparts(FileName);
    FigureTitle = sprintf('Saved values come from file: %s', FileName);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Figure: uitable, checkboxes, etc. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Color = [.8 .8 .8];
h.figure1 = figure( ...
    'Color', Color,  ...
    'Name', FigureTitle,  ... % Title figure
    'NumberTitle', 'off', ... % Do not show figure number
    'MenuBar', 'none',    ... % Hide standard menu bar menus
    'IntegerHandle', 'Off', ...
    'Units', 'pixels');
%'Units', 'characters', ...
%'Position', [100, 300, 500, 460], ...

% Make the figure longer
ExtraHeight = 420;  % was 350
FigurePosition = get(h.figure1, 'Position');
FigurePosition(2) = FigurePosition(2) - ExtraHeight + 50; % The 50 is for no MenuBar
FigurePosition(4) = FigurePosition(4) + ExtraHeight;
set(h.figure1, 'Position', FigurePosition);

% Could add pushtool for save/restore etc.
%ht = uitoolbar(h.figure1);
%htt = uipushtool(ht,'TooltipString','Hello');


% Setpoint family table
ColNames = {'Family', 'Field', 'Select'}; % Column names
colfmt = {'char', 'char', 'logical'};       % Columns contains
coledit = [false false true];               % Editing or not
colwdt = {145 145 65};                      % Set columns width

FamilyTableHeight = 250; %320;
FamilyTableWidth    = sum(cell2mat(colwdt))+80;
FamilyTablePosition = [4 FigurePosition(4)-FamilyTableHeight-4-30 FamilyTableWidth FamilyTableHeight];

% Create the setpoint table
h.RestoreTableByFamily = uitable(...
    'Units', 'pixels', ...
    'Position', FamilyTablePosition, ...
    'Data',  {'','',false}, ...
    'ColumnName', ColNames, ...
    'ColumnFormat', colfmt, ...
    'ColumnWidth', colwdt, ...
    'ColumnEditable', coledit, ...
    'FontWeight', 'Bold', ...
    'RearrangeableColumns', 'off', ...
    'ToolTipString', '', ...
    'Tag', 'RestoreFamilyTable', ...
    'CellEditCallback',{@MachineConfig_BuildTables});
% CellSelectionCallback


% Setpoint PV table
ColNames = {'Common Name', 'Saved', 'Present', 'Difference', 'Channel Name'};
colfmt = {'char', 'numeric', 'numeric', 'numeric', 'char'}; % Columns contains
coledit = [false false false false false];  % Editing or not
colwdt = {160 90 90 90 180};  % Set columns width

TableWidth = sum(cell2mat(colwdt))+60;
SetpointTableWidth    = sum(cell2mat(colwdt))+60;
SetpointTablePosition = [4 4 SetpointTableWidth FamilyTablePosition(2)-10];

h.RestoreTableByData = uitable(...
    'Units', 'pixels', ...
    'Position', SetpointTablePosition, ...
    'Data',  {'',[],[],[],''}, ...
    'ColumnName', ColNames, ...
    'ColumnFormat', colfmt, ...
    'ColumnWidth', colwdt, ...
    'ColumnEditable', coledit, ...
    'FontWeight', 'Bold', ...
    'RearrangeableColumns', 'off', ...
    'ToolTipString', '', ...
    'Tag', 'RestoreDataTable', ...
    'CellEditCallback',{@MachineConfig_RestoreTableByData_Callback});
% CellSelectionCallback

% Monitor family table
ColNames = {'Family', 'Field', 'Select'};  % Column names
colfmt = {'char', 'char', 'logical'};      % Columns contains
coledit = [false false true];              % Editing or not
colwdt = {145 145 65};                      % Set columns width

MonitorFamilyTablePosition = [SetpointTablePosition(1)+SetpointTablePosition(3)+13 FigurePosition(4)-FamilyTableHeight-4-30 FamilyTableWidth FamilyTableHeight];

h.MonitorTableByFamily = uitable(...
    'Units', 'pixels', ...
    'Position', MonitorFamilyTablePosition, ...
    'Data',  {'','',false}, ...
    'ColumnName', ColNames, ...
    'ColumnFormat', colfmt, ...
    'ColumnWidth', colwdt, ...
    'ColumnEditable', coledit, ...
    'FontWeight', 'Bold', ...
    'RearrangeableColumns', 'off', ...
    'ToolTipString', '', ...
    'Tag', 'MonitorFamilyTable', ...
    'CellEditCallback',{@MachineConfig_BuildTables});

% Monitor PV table
ColNames = {'Common Name', 'Saved', 'Present', 'Difference', 'Channel Name'};
colfmt = {'char', 'numeric', 'numeric', 'numeric', 'char'}; % Columns contains
coledit = [false false false false false];  % Editing or not
colwdt = {160 90 90 90 180};  % Set columns width
MonitorTablePosition = [MonitorFamilyTablePosition(1) 4 SetpointTableWidth FamilyTablePosition(2)-10];
h.MonitorTableByData = uitable(...
    'Units', 'pixels', ...
    'Position', MonitorTablePosition, ...
    'Data',  {'',[],[],[],''}, ...
    'ColumnName', ColNames, ...
    'ColumnFormat', colfmt, ...
    'ColumnWidth', colwdt, ...
    'ColumnEditable', coledit, ...
    'FontWeight', 'Bold', ...
    'RearrangeableColumns', 'off', ...
    'ToolTipString', '', ...
    'Tag', 'MonitorDataTable', ...
    'CellEditCallback',{@MachineConfig_RestoreTableByData_Callback});


%%%%%%%%%%%%%%%%%%%%
% Other UIControls %
%%%%%%%%%%%%%%%%%%%%

ButtonWidth = 200;
ButtonHeight = 30;
xButton = FamilyTablePosition(1) + FamilyTablePosition(3) + 10;

%'ForegroundColor', [.7 .4 0], ...
h.Text1 = uicontrol(...
    'BackgroundColor', Color,  ...
    'HorizontalAlignment', 'center', ...
    'Style', 'text', ...
    'Units', 'pixels', ...
    'FontSize', 14, ...
    'FontWeight', 'Bold', ...
    'String', 'Restore Table', ...
    'Position', [40 FigurePosition(4)-(ButtonHeight+2) 2*ButtonWidth ButtonHeight]);

h.Text2 = uicontrol(...
    'BackgroundColor', Color,  ...
    'HorizontalAlignment', 'Left', ...
    'Style', 'text', ...
    'Units', 'pixels', ...
    'FontSize', 14, ...
    'FontWeight', 'Bold', ...
    'String', 'Saved Values for Viewing Only (No Restore)', ...
    'Position', [SetpointTablePosition(1)+SetpointTablePosition(3)+150 FigurePosition(4)-(ButtonHeight+2) 4*ButtonWidth ButtonHeight]);

h.Text3 = uicontrol(...
    'BackgroundColor', Color,  ...
    'HorizontalAlignment', 'center', ...
    'Style', 'text', ...
    'Units', 'pixels', ...
    'FontSize', 12, ...
    'String', {'Restores only the','selected items'}, ...
    'Position', [xButton FigurePosition(4)-2.5*(ButtonHeight+4) ButtonWidth 1.2*ButtonHeight]);

% Button to set the Golden to the machine
h.Restore = uicontrol(...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'FontSize', 10, ...
    'String', 'Restore Setpoints', ...
    'Position', [xButton FigurePosition(4)-3.5*(ButtonHeight+4) ButtonWidth ButtonHeight], ...
    'ToolTipString', 'Sets the saved values to the machine.', ...
    'Callback', @MachineConfig_Restore_Callback);

% Button to update everything
h.Update = uicontrol(...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'FontSize', 10, ...
    'String', 'Update', ...
    'Position', [SetpointTablePosition(1)+SetpointTablePosition(3)+4-ButtonWidth/2 FigurePosition(4)-(ButtonHeight+2) ButtonWidth ButtonHeight], ...
    'ToolTipString', 'Update the saved and present setpoints.', ...
    'Callback', @MachineConfig_Update);

% Edit button
h.Text4 = uicontrol(...
    'BackgroundColor', Color,  ...
    'HorizontalAlignment', 'center', ...
    'Style', 'text', ...
    'Units', 'pixels', ...
    'FontSize', 12, ...
    'String', {'Allow individual changes','to the present column'}, ...
    'Position', [xButton FigurePosition(4)-5.5*(ButtonHeight+4) ButtonWidth 1.3*ButtonHeight]);
h.Edit = uicontrol(...
    'Style', 'togglebutton', ...
    'Units', 'pixels', ...
    'FontSize', 10, ...
    'String', 'Edit Mode is Off', ...
    'Position', [xButton FigurePosition(4)-6.5*(ButtonHeight+4) ButtonWidth ButtonHeight], ...
    'ToolTipString', 'Allow changes to the present setpoint, or not.', ...
    'Callback', @MachineConfig_Edit_Callback);

% All on/off button for setpoints
h.RestoreSelectNone = uicontrol(...
    'Style', 'togglebutton', ...
    'Units', 'pixels', ...
    'String', 'All', ...
    'FontSize', 10, ...
    'Position', [xButton FamilyTablePosition(2) ButtonWidth/2 ButtonHeight], ...
    'Tag', 'RestoreSelectNone', ...
    'ToolTipString', 'Allow changes to the present setpoint, or not.', ...
    'Callback', @MachineConfig_Select_Callback);
h.RestoreSelectAll = uicontrol(...
    'Style', 'togglebutton', ...
    'Units', 'pixels', ...
    'String', 'None', ...
    'FontSize', 10, ...
    'Position', [xButton+ButtonWidth/2+4 FamilyTablePosition(2) ButtonWidth/2 ButtonHeight], ...
    'Tag', 'RestoreSelectAll', ...
    'ToolTipString', 'Allow changes to the present setpoint, or not.', ...
    'Callback', @MachineConfig_Select_Callback);

% All on/off button for monitors
h.MonitorSelectNone = uicontrol(...
    'Style', 'togglebutton', ...
    'Units', 'pixels', ...
    'String', 'All', ...
    'FontSize', 10, ...
    'Position', [SetpointTablePosition(1)+SetpointTablePosition(3)+MonitorFamilyTablePosition(3)+20 MonitorFamilyTablePosition(2) ButtonWidth/2 ButtonHeight], ...
    'Tag', 'MonitorSelectNone', ...
    'ToolTipString', 'Allow changes to the present setpoint, or not.', ...
    'Callback', @MachineConfig_Select_Callback);
h.MonitorSelectAll = uicontrol(...
    'Style', 'togglebutton', ...
    'Units', 'pixels', ...
    'String', 'None', ...
    'FontSize', 10, ...
    'Position', [SetpointTablePosition(1)+SetpointTablePosition(3)+MonitorFamilyTablePosition(3)+20+ButtonWidth/2+4 MonitorFamilyTablePosition(2) ButtonWidth/2 ButtonHeight], ...
    'Tag', 'MonitorSelectAll', ...
    'ToolTipString', 'Allow changes to the present setpoint, or not.', ...
    'Callback', @MachineConfig_Select_Callback);

h.Frame1 = uicontrol(...
    'BackgroundColor', [.7 .4 0], ...
    'ForegroundColor', [.7 .4 0], ...
    'Style', 'frame', ...
    'Units', 'pixels', ...
    'String', 'None', ...
    'Position', [SetpointTablePosition(1)+SetpointTablePosition(3)+4 4 5 SetpointTablePosition(4)+FamilyTablePosition(4)+4]);


%%%%%%%%%%%%%%%
% Final setup %
%%%%%%%%%%%%%%%
%FigurePosition(3) = TableWidth + 10; % Setpoint table only
FigurePosition(3) = SetpointTablePosition(1)+SetpointTablePosition(3)+TableWidth+14;
set(h.figure1, 'Position', FigurePosition);

set(h.figure1,              'Units', 'Normalized');
set(h.Frame1,               'Units', 'Normalized');
set(h.Text1,                'Units', 'Normalized');
set(h.Text2,                'Units', 'Normalized');
set(h.Text3,                'Units', 'Normalized');
set(h.Text4,                'Units', 'Normalized');
set(h.RestoreTableByFamily, 'Units', 'Normalized');
set(h.RestoreTableByData,   'Units', 'Normalized');
set(h.Restore,              'Units', 'Normalized');
set(h.Update,               'Units', 'Normalized');
set(h.Edit,                 'Units', 'Normalized');
set(h.RestoreSelectNone,    'Units', 'Normalized');
set(h.RestoreSelectAll,     'Units', 'Normalized');

set(h.MonitorTableByFamily, 'Units', 'Normalized');
set(h.MonitorTableByData,   'Units', 'Normalized');
set(h.MonitorSelectNone,    'Units', 'Normalized');
set(h.MonitorSelectAll,     'Units', 'Normalized');

% Normalize the strings
% set(h.Text1,             'FontUnits', 'Normalized');
% set(h.Text2,             'FontUnits', 'Normalized');
% set(h.Text3,             'FontUnits', 'Normalized');
% set(h.Text4,             'FontUnits', 'Normalized');
% set(h.Update,            'FontUnits', 'Normalized');
% set(h.Restore,           'FontUnits', 'Normalized');
% set(h.Edit,              'FontUnits', 'Normalized');
% set(h.RestoreSelectNone, 'FontUnits', 'Normalized');
% set(h.RestoreSelectAll,  'FontUnits', 'Normalized');
% set(h.MonitorSelectNone, 'FontUnits', 'Normalized');
% set(h.MonitorSelectAll,  'FontUnits', 'Normalized');

% Save the handles
Fields = fieldnames(h);
h.FileName = FileName;
for i = 1:length(Fields)
    set(h.(Fields{i}), 'UserData', h);
end

% Build and initialize the tables
MachineConfig_Update(h, FileName);

% Hide or set the figure handle to callback
set(h.figure1, 'HandleVisibility','Callback');



function MachineConfig_Select_Callback(varargin)

% Table handle
Tag = get(varargin{1}, 'Tag');
h = get(varargin{1}, 'UserData');

if strcmpi(Tag(1:7),'Restore')
    Table = get(h.RestoreTableByFamily, 'Data');
else
    Table = get(h.MonitorTableByFamily, 'Data');
end

for i = 1:size(Table,1)
    if strcmpi(get(varargin{1},'String'),'All')
        Table{i,3} = true;
    else
        Table{i,3} = false;
    end
end

if strcmpi(Tag(1:7),'Restore')
    set(h.RestoreTableByFamily, 'Data', Table);
    MachineConfig_BuildTables(h, 'RestoreTableOnly');
else
    set(h.MonitorTableByFamily, 'Data', Table);
    MachineConfig_BuildTables(h, 'MonitorTableOnly');
end

set(varargin{1}, 'Value', 0);




function MachineConfig_RestoreTableByData_Callback(varargin)

% Tables
h = get(varargin{1}, 'UserData');
%RestoreFamilyTable = get(h.RestoreTableByFamily, 'Data');
RestoreDataTable = get(h.RestoreTableByData, 'Data');

Index = varargin{2}.Indices;

if Index(1,2) == 3
    % Column 3 - Make setpoint change
    ChannelName = deblank(RestoreDataTable{Index(1),5});
    
    if iscell(ChannelName)
        error('ChannelName cell array issue.');
    end
    
    if isspace(ChannelName(1))
        ChannelName(1) = []; % Space was added for readability
    end
    [Family, Field, Device] = channel2family(ChannelName);
    NewSP = RestoreDataTable{Index(1),3};
    
    fprintf('   Changing %s (%s) to %f\n', RestoreDataTable{Index(1),1}, ChannelName, NewSP);
    
    % Using Family, Field, Device will catch special functions and can be used in simulate mode!
    setpv(Family, Field, NewSP, Device);
    
    % Do change the column name because it is "Present" and it look weird that the time in the Update box is different
    %ColNames = get(h, 'ColumnName');
    %ColNames{3} = datestr(now,14);
    %set(h, 'ColumnName', ColNames);
end


RestoreDataTable(:,4) = num2cell(cell2mat(RestoreDataTable(:,2)) - cell2mat(RestoreDataTable(:,3)));

set(h.RestoreTableByData, 'Data', RestoreDataTable);



function MachineConfig_Restore_Callback(varargin)
% Restore the setpoints

h = get(varargin{1}, 'UserData');

%FileName = get(varargin{1}, 'UserData');
%setmachineconfig(FileName, 0);

% Remove the unchecked Family/Fields
ConfigSetpoint = getappdata(h.figure1, 'ConfigSetpoint');

% Find the true families
Table = get(h.RestoreTableByFamily, 'Data');

for i = 1:size(Table,1)
    if ~Table{i,3}
        % Remove that field
        ConfigSetpoint.(Table{i,1}) = rmfield(ConfigSetpoint.(Table{i,1}), Table{i,2});
        
        if isempty(fieldnames(ConfigSetpoint.(Table{i,1})))
            ConfigSetpoint = rmfield(ConfigSetpoint, Table{i,1});
        end
    end
end

% Count the number of setpoint changes
N = 0;
Families = fieldnames(ConfigSetpoint);
for i = 1:length(Families)
    Fields = fieldnames(ConfigSetpoint.(Families{i}));
    for j = 1:length(Fields)
        ValueSaved = ConfigSetpoint.(Families{i}).(Fields{j}).Data;
        nNaN = sum(isnan(ValueSaved));  % Base removal on the saved values
        N = N + size(ConfigSetpoint.(Families{i}).(Fields{j}).DeviceList,1) - nNaN;
    end
end

if ~isempty(fieldnames(ConfigSetpoint))
    StartFlag = questdlg({'Are you sure you want to ',sprintf('restore %d saved values?',N)},'','Yes','No','No');
    drawnow;
    
    if ~strcmp(StartFlag,'Yes')
        fprintf('   No changes made.\n');
        return
    end
    setmachineconfig(ConfigSetpoint, 0);
    
    pause(.5);
    %MachineConfig_BuildTables(h);
    MachineConfig_Update(h, '');
end



function MachineConfig_Edit_Callback(varargin)

% Table handle
h = get(varargin{1}, 'UserData');

ColNames = get(h.RestoreTableByData, 'ColumnName');

if get(h.Edit, 'Value') == 1
    ColNames{3} = 'Present (edit)';
    coledit = [false false true false false];
    set(h.Edit, 'String', 'Edit Mode is On');
else
    ColNames{3} = 'Present';
    coledit = [false false false false false];
    set(h.Edit, 'String', 'Edit Mode is Off');
end

set(h.RestoreTableByData, 'ColumnEditable', coledit);
set(h.RestoreTableByData, 'ColumnName',     ColNames);


function MachineConfig_Update(h, FileName)
% Update the filename data and family/field table
    
if ~isstruct(h)
    h = get(h, 'UserData');
end

if isempty(FileName) || ~ischar(FileName)
    ConfigSetpoint = getappdata(h.figure1, 'ConfigSetpoint');
    ConfigMonitor  = getappdata(h.figure1, 'ConfigMonitor');
else
    if strcmpi(FileName, 'Golden') || strcmpi(FileName, 'Production')
        [ConfigSetpoint, ConfigMonitor] = getproductionlattice;
    elseif strcmpi(FileName, 'Injection')
        [ConfigSetpoint, ConfigMonitor] = getinjectionlattice;
    else
        [ConfigSetpoint, ConfigMonitor] = machineconfigsort(FileName);
    end
end

if isempty(ConfigSetpoint)
    RestoreFamilyTable = {[], [], false};
else
    m = 0;
    Families = fieldnames(ConfigSetpoint);
    for i = 1:length(Families)
        Fields = fieldnames(ConfigSetpoint.(Families{i}));
        for j = 1:length(Fields)
            if ~isempty(FileName)
                m = m + 1;
                RestoreFamilyTable{m,1} = Families{i};
                RestoreFamilyTable{m,2} = Fields{j};
                RestoreFamilyTable{m,3} = true;
            end
            
            try
                DeviceList = ConfigSetpoint.(Families{i}).(Fields{j}).DeviceList;
                ConfigSetpoint.(Families{i}).(Fields{j}).Value = getpv(Families{i}, Fields{j}, DeviceList);
            catch
                fprintf('   %s.%s is being removed from the restore\n', Families{i}, Fields{j});
                fprintf('%s\n', lasterr);
                ConfigSetpoint.(Families{i}) = rmfield(ConfigSetpoint.(Families{i}), Fields{j});
                if isempty(fieldnames(ConfigSetpoint.(Families{i})))
                    ConfigSetpoint = rmfield(ConfigSetpoint, Families{i});
                end
            end
        end
    end
end

if isempty(ConfigMonitor)
    MonitorFamilyTable = {[], [], false};
else
    m = 0;
    Families = fieldnames(ConfigMonitor);
    for i = 1:length(Families)
        Fields = fieldnames(ConfigMonitor.(Families{i}));
        for j = 1:length(Fields)
            if ~isempty(FileName)
                m = m + 1;
                MonitorFamilyTable{m,1} = Families{i};
                MonitorFamilyTable{m,2} = Fields{j};
                MonitorFamilyTable{m,3} = true;
            end
            
            try
                DeviceList = ConfigMonitor.(Families{i}).(Fields{j}).DeviceList;
                ConfigMonitor.(Families{i}).(Fields{j}).Value = getpv(Families{i}, Fields{j}, DeviceList);
            catch
                fprintf('   %s.%s is being removed from viewing\n', Families{i}, Fields{j});
                fprintf('%s\n', lasterr);
                ConfigMonitor.(Families{i}) = rmfield(ConfigMonitor.(Families{i}), Fields{j});
                if isempty(fieldnames(ConfigMonitor.(Families{i})))
                    ConfigMonitor = rmfield(ConfigMonitor, Families{i});
                end
            end
        end
    end
end

% Save
setappdata(h.figure1, 'ConfigSetpoint', ConfigSetpoint);
setappdata(h.figure1, 'ConfigMonitor',  ConfigMonitor);
if ~isempty(FileName)
    set(h.RestoreTableByFamily, 'Data', RestoreFamilyTable);
    set(h.MonitorTableByFamily, 'Data', MonitorFamilyTable);
end

MachineConfig_BuildTables(h);
set(h.Update, 'String', sprintf('Update (%s)', datestr(now,14)));


function MachineConfig_BuildTables(h, TableFlag)
% Update the PV tables

RestoreTableFlag = 1;
MonitorTableFlag = 1;

if ~isstruct(h)
    h = get(h, 'UserData');
end

if nargin >= 2 && ischar(TableFlag)
    if strcmpi(TableFlag, 'RestoreTableOnly')
        MonitorTableFlag = 0;
    elseif strcmpi(TableFlag,'MonitorTableOnly')
        RestoreTableFlag = 0;
    end
end

% Remove the unchecked Family/Fields
RestoreFamilyTable = get(h.RestoreTableByFamily, 'Data');
MonitorFamilyTable = get(h.MonitorTableByFamily, 'Data');


% Setpoint table
if RestoreTableFlag
    ConfigSetpoint = getappdata(h.figure1, 'ConfigSetpoint');
    if isempty(ConfigSetpoint)
        RestoreDataTable = {'',[],[],[],''};
        set(h.RestoreTableByData, 'Data', RestoreDataTable);
    else
        % Find the true families
        for i = 1:size(RestoreFamilyTable,1)
            if ~RestoreFamilyTable{i,3}
                % Remove that field, if it exists
                if isfield(ConfigSetpoint,(RestoreFamilyTable{i,1})) && isfield(ConfigSetpoint.(RestoreFamilyTable{i,1}), RestoreFamilyTable{i,2})
                    ConfigSetpoint.(RestoreFamilyTable{i,1}) = rmfield(ConfigSetpoint.(RestoreFamilyTable{i,1}), RestoreFamilyTable{i,2});
                end
                
                % Remove the whole family if all the fields are removed
                if isfield(ConfigSetpoint, RestoreFamilyTable{i,1}) && isempty(fieldnames(ConfigSetpoint.(RestoreFamilyTable{i,1})))
                    ConfigSetpoint = rmfield(ConfigSetpoint, RestoreFamilyTable{i,1});
                end
            end
        end
        
        if isempty(fieldnames(ConfigSetpoint))
            RestoreDataTable = {'',[],[],[],''};
            set(h.RestoreTableByData, 'Data', RestoreDataTable);
        end
               
        % Shortened the devices in a series (same channel name) if online
        FamilyCell = fieldnames(ConfigSetpoint);
        for i = 1:length(FamilyCell)
            FieldCell = fieldnames(ConfigSetpoint.(FamilyCell{i}));
            for j = 1:length(FieldCell)
                
                % Reduce the setpoints unique channelnames if online
                if strcmpi(getfamilydata(FamilyCell{i}, FieldCell{j}, 'Mode'), 'Online')
                    ChannelNames = family2channel(FamilyCell{i}, FieldCell{j}, ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DeviceList);
                    if iscell(ChannelNames)
                        [ChannelNames, m, n] = unique(ChannelNames, 'first');
                    else
                        [ChannelNames, m, n] = unique(ChannelNames, 'rows', 'first');
                    end
                    
                    % Check how many unique and non-NaN setpoints there are.
                    [Data, k, l] = unique(ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Data, 'rows', 'first');
                    Data(isnan(Data)) = [];
                    
                    if size(Data,1) > size(ChannelNames,1)
                        fprintf('   Warning:  attempting to set different setpoints for the same channel name (%s.%s)\n', FamilyCell{i}, FieldCell{j});
                    else
                        %m = sort(m);
                        ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Data       = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Data(m,:);
                        ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DeviceList = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DeviceList(m,:);
                        ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Status     = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Status(m,:);
                        ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Value      = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Value(m,:);
                        ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DataTime   = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DataTime(m,:);
                    end
                    
                    %if size(Data,1)==1 && size(ChannelNames,1)==1
                    %    % Ok to reduce
                    %    ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Data       = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Data(1,:);
                    %    ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DeviceList = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DeviceList(1,:);
                    %    ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Status     = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Status(1,:);
                    %    ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Value      = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).Value(1,:);
                    %    ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DataTime   = ConfigSetpoint.(FamilyCell{i}).(FieldCell{j}).DataTime(1,:);
                    %end
                end
            end
        end           
    end
end


% Monitor table
if MonitorTableFlag
    ConfigMonitor = getappdata(h.figure1, 'ConfigMonitor');
    if isempty(ConfigMonitor)
        MonitorDataTable = {'',[],[],[],''};
        set(h.MonitorTableByData, 'Data', MonitorDataTable);
    else       
        % Find the true families
        for i = 1:size(MonitorFamilyTable,1)
            if ~MonitorFamilyTable{i,3}         
                % Remove that field
                if isfield(ConfigMonitor, MonitorFamilyTable{i,1}) && isfield(ConfigMonitor.(MonitorFamilyTable{i,1}), MonitorFamilyTable{i,2})
                    ConfigMonitor.(MonitorFamilyTable{i,1}) = rmfield(ConfigMonitor.(MonitorFamilyTable{i,1}), MonitorFamilyTable{i,2});
                end
                
                if isfield(ConfigMonitor, MonitorFamilyTable{i,1}) && isempty(fieldnames(ConfigMonitor.(MonitorFamilyTable{i,1})))
                    ConfigMonitor = rmfield(ConfigMonitor, MonitorFamilyTable{i,1});
                end
            end
        end
        
        if isempty(fieldnames(ConfigMonitor))
            MonitorDataTable = {'',[],[],[],''};
            set(h.MonitorTableByData, 'Data', MonitorDataTable);
        end
        
        % Shortened the devices in a series (same channel name) if online
        FamilyCell = fieldnames(ConfigMonitor);
        for i = 1:length(FamilyCell)
            FieldCell = fieldnames(ConfigMonitor.(FamilyCell{i}));
            for j = 1:length(FieldCell)
                
                % Reduce the setpoints unique channelnames if online
                if strcmpi(getfamilydata(FamilyCell{i}, FieldCell{j}, 'Mode'), 'Online')
                    ChannelNames = family2channel(FamilyCell{i}, FieldCell{j}, ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).DeviceList);
                    if iscell(ChannelNames)
                        [ChannelNames, m, n] = unique(ChannelNames, 'first');
                    else
                        [ChannelNames, m, n] = unique(ChannelNames, 'rows', 'first');
                    end
                    
                    % Check how many unique and non-NaN setpoints there are.
                    [Data, k, l] = unique(ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).Data, 'rows', 'first');
                    Data(isnan(Data)) = [];
                    
                    if size(Data,1) > size(ChannelNames,1)
                        fprintf('   Warning:  multiple monitor value exist for the same channel name (%s.%s)\n', FamilyCell{i}, FieldCell{j});
                    else
                        ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).Data       = ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).Data(m,:);
                        ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).DeviceList = ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).DeviceList(m,:);
                        ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).Status     = ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).Status(m,:);
                        ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).Value      = ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).Value(m,:);
                        ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).DataTime   = ConfigMonitor.(FamilyCell{i}).(FieldCell{j}).DataTime(m,:);
                    end
                end
            end
        end 
    end
end


%%%%%%%%%%%%%
% Setpoints %
%%%%%%%%%%%%%
if RestoreTableFlag && ~isempty(ConfigSetpoint)
    if ~isempty(fieldnames(ConfigSetpoint))
        Families = fieldnames(ConfigSetpoint);
        
        % First count the Families, Fields, and Data size
        n = 0;
        for i = 1:length(Families)
            Fields = fieldnames(ConfigSetpoint.(Families{i}));
            for j = 1:length(Fields)
                % Remove if NaN is in the saved files
                ValueSaved = ConfigSetpoint.(Families{i}).(Fields{j}).Data;
                nNaN = sum(isnan(ValueSaved));  % Base removal on the saved values
                
                n = n + size(ConfigSetpoint.(Families{i}).(Fields{j}).DeviceList,1) - nNaN;
            end
        end
        RestoreDataTable = cell(n, 5);
        
        n = 0;
        for i = 1:length(Families)
            Fields = fieldnames(ConfigSetpoint.(Families{i}));
            for j = 1:length(Fields)
                ValueSaved = ConfigSetpoint.(Families{i}).(Fields{j}).Data;
                DeviceList = ConfigSetpoint.(Families{i}).(Fields{j}).DeviceList;
                CommonName = family2common(Families{i}, DeviceList);
                ChannelName = family2channel(Families{i}, Fields{j}, DeviceList);
                ValueNow = ConfigSetpoint.(Families{i}).(Fields{j}).Value;
                
                % Remove if NaN is in the saved files
                iNaN = find(isnan(ValueSaved));  % Base removal on the saved values
                % iNaN = isnan(ValueNow);  % Base removal on present values
                if iscell(CommonName)
                    CommonName(iNaN) = [];
                else
                    CommonName(iNaN,:) = [];
                end
                if iscell(ChannelName)
                    ChannelName(iNaN) = [];
                else
                    ChannelName(iNaN,:) = [];
                end
                ValueSaved(iNaN,:) = [];
                ValueNow(iNaN,:) = [];
                
                for k = 1:size(ChannelName,1)
                    n = n + 1;
                    if iscell(CommonName)
                        CName = deblank(CommonName{k});
                    else
                        CName = deblank(CommonName(k,:));
                    end
                    if length(Fields) > 1
                        RestoreDataTable{n,1} = [CName, ' (', deblank(Fields{j}), ')'];
                    else
                        RestoreDataTable{n,1} = CName;
                    end
                    RestoreDataTable{n,2} = ValueSaved(k);
                    RestoreDataTable{n,3} = ValueNow(k);
                    RestoreDataTable{n,4} = ValueSaved(k) - ValueNow(k);
                    if iscell(ChannelName)
                        RestoreDataTable{n,5} = [' ', deblank(ChannelName{k})];
                    else
                        RestoreDataTable{n,5} = [' ', deblank(ChannelName(k,:))];
                    end
                end
            end
        end
        
        set(h.RestoreTableByData, 'Data', RestoreDataTable);
    end
end


%%%%%%%%%%%
% Monitor %
%%%%%%%%%%%
if MonitorTableFlag && ~isempty(ConfigMonitor)
    if ~isempty(fieldnames(ConfigMonitor))
        Families = fieldnames(ConfigMonitor);
        
        % First count the Families, Fields, and Data size
        n = 0;
        for i = 1:length(Families)
            Fields = fieldnames(ConfigMonitor.(Families{i}));
            for j = 1:length(Fields)
                % Remove if NaN is in the saved files
                ValueSaved = ConfigMonitor.(Families{i}).(Fields{j}).Data;
                nNaN = sum(isnan(ValueSaved));  % Base removal on the saved values
                n = n + size(ConfigMonitor.(Families{i}).(Fields{j}).DeviceList,1) - nNaN;
            end
        end
        MonitorDataTable = cell(n, 5);
        
        n = 0;
        for i = 1:length(Families)
            Fields = fieldnames(ConfigMonitor.(Families{i}));
            
            for j = 1:length(Fields)
                ValueSaved = ConfigMonitor.(Families{i}).(Fields{j}).Data;
                DeviceList = ConfigMonitor.(Families{i}).(Fields{j}).DeviceList;
                CommonName = family2common(Families{i}, DeviceList);
                ChannelName = family2channel(Families{i}, Fields{j}, DeviceList);
                ValueNow = ConfigMonitor.(Families{i}).(Fields{j}).Value;
                
                % Remove if NaN is in the saved files
                iNaN = find(isnan(ValueSaved));  % Base removal on the saved values
                % iNaN = isnan(ValueNow);  % Base removal on present values
                if iscell(CommonName)
                    CommonName(iNaN) = [];
                else
                    CommonName(iNaN,:) = [];
                end
                if iscell(ChannelName)
                    ChannelName(iNaN) = [];
                else
                    ChannelName(iNaN,:) = [];
                end
                ValueSaved(iNaN,:) = [];
                ValueNow(iNaN,:) = [];
                
                for k = 1:size(ChannelName,1)
                    n = n + 1;
                    if iscell(CommonName)
                        CName = deblank(CommonName{k});
                    else
                        CName = deblank(CommonName(k,:));
                    end
                    if length(Fields) > 1
                        MonitorDataTable{n,1} = [CName ' (', deblank(Fields{j}), ')'];
                    else
                        MonitorDataTable{n,1} = CName;
                    end
                    MonitorDataTable{n,2} = ValueSaved(k);
                    MonitorDataTable{n,3} = ValueNow(k);
                    MonitorDataTable{n,4} = ValueSaved(k) - ValueNow(k);
                    if iscell(ChannelName)
                        MonitorDataTable{n,5} = [' ', deblank(ChannelName{k})];
                    else
                        MonitorDataTable{n,5} = [' ', deblank(ChannelName(k,:))];
                    end
                end
            end
        end
        
        set(h.MonitorTableByData, 'Data', MonitorDataTable);
    end
end

