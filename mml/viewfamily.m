function viewfamily(varargin)
%VEIWFAMILY - View all the fields for a family
%
%  viewfamily
%  viewfamily(Family)
%
%  See also plotfamily, machineconfig

%  Written by Greg Portmann


% Run initialization if it has not been run (like standalone)
checkforao;


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
FamilyInput = '';
if length(varargin) >= 1
    if ischar(varargin{1})
        FamilyInput = varargin{1};
        varargin(1) = [];
    end
end


% Build Family menu
FamilyNames = getfamilylist('Cell');


% Create a figure that will have a uitable, axes and checkboxes
h_fig = figure( ...
    'NumberTitle', 'off', ... % Do not show figure number
    'MenuBar', 'none',    ... % Hide standard menu bar menus
    'Units', 'pixels',    ...
    'ResizeFcn', @ViewFamily_Resize_Callback);
%'Units', 'characters', ...
%'Position', [100, 300, 500, 460], ...
Menu1 = uimenu(h_fig, 'Label', 'Family');
%set(Menu1, 'Position', 3);
%set(Menu1, 'Separator', 'On');


% Make the figure longer
ExtraHeight = 150;
pFig = get(h_fig, 'Position');
pFig(2) = pFig(2) - ExtraHeight;
pFig(4) = pFig(4) + ExtraHeight;
set(h_fig, 'Position', pFig);


i0 = 0;
Family1 = '';
for i = 1:size(FamilyNames,1)
    FamilyNames{i} = FamilyNames{i};
    
    try
        spos = getspos(FamilyNames{i});
    catch
        spos = [];
    end
    
    % Only include if there are S-position for the family
    if ~isempty(spos)
        Menu2 = uimenu(Menu1, 'Label', FamilyNames{i});
        set(Menu2, 'UserData', FamilyNames{i});
        set(Menu2, 'Callback', @ViewFamily_Table_Callback);
        
        % Remember of the first family or FamilyInput
        if isempty(FamilyInput)
            if i0 == 0
                i0 = i;
                Family1 = FamilyNames{i};
                h1 = Menu2;
            end
        else
            if strcmpi(FamilyInput, FamilyNames{i})
                i0 = i;
                Family1 = FamilyNames{i};
                h1 = Menu2;
            end
        end
        % Skip family
    end
end

if isempty(Family1)
    close(h_fig);
    error('Starting family not found in the MML.');
end
        

if isempty(FamilyInput)
    FamilyInput = Family1;
end


% Create table
TableWidth = 500;
h_table = uitable(...
    'Units', 'pixels', ...
    'Position', [4 4 TableWidth pFig(4)-40], ...
    'ColumnName', {''}, ...
    'ColumnFormat', {'char'}, ...
    'ColumnWidth', {100}, ...
    'ColumnEditable', false, ...
    'FontWeight', 'Bold', ...
    'RearrangeableColumns', 'on', ...
    'RowName', 'Numbered', ...
    'RowStriping', 'on', ...
    'ToolTipString', '', ...
    'UserData', FamilyInput, ...
    'CellEditCallback', @ViewFamily_Set_Table_Callback);

% Button to update everything
pFig = get(h_fig, 'Position');
h_update = uicontrol(...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'String', sprintf('Update (%s)', datestr(now,14)), ...
    'Position', [4 pFig(4)-30 175 25], ...
    'ToolTipString', 'Update the stored and present setpoints.', ...
    'UserData', h_table, ...
    'Callback', @ViewFamily_Update_Callback);

% Edit button
pFig = get(h_fig, 'Position');
h_edit = uicontrol(...
    'Style', 'togglebutton', ...
    'Units', 'pixels', ...
    'String', 'Edit Mode is Off', ...
    'Position', [195 pFig(4)-30 150 25], ...
    'ToolTipString', 'Allow changes to the present setpoint, or not.', ...
    'UserData', h_table, ...
    'Callback', @ViewFamily_Edit_Callback);


%pFig(3) = TableWidth + 10;
%set(h_fig, 'Position', pFig);

set(h_fig,   'Units', 'Normalized');
set(h_table,  'Units', 'Normalized');
set(h_update, 'Units', 'Normalized');
set(h_edit,   'Units', 'Normalized');

setappdata(h_fig, 'TableHandle', h_table);
setappdata(h_fig, 'UpdateHandle', h_update);
setappdata(h_fig, 'EditHandle', h_edit);

ViewFamily_Table_Callback(h1, h_fig)

set(h_fig, 'HandleVisibility','Callback');



function ViewFamily_Table_Callback(h, h_fig)

if nargin < 2 || isempty(h_fig)
    h_fig = gcbf;
end
h_table = getappdata(h_fig, 'TableHandle');

Family = get(h, 'UserData');
set(h_table, 'UserData', Family);

[FamilyFlag, AOStruct] = isfamily(Family);

if ~FamilyFlag
    disp('Not a famly.');
    return
end

FieldNames = fieldnames(AOStruct);

iCol = 1;
ColumnNames{iCol} = Family; %'Common Name';
ColumnFormat{iCol} = 'char';
ColumnEdit(1,iCol) = false;
ColumnWidth{iCol} = 160;

for j = 1:length(FieldNames)
    % Is it a "real" field
    if isfield(AOStruct.(FieldNames{j}),'MemberOf') || isfield(AOStruct.(FieldNames{j}),'ChannelNames') || isfield(AOStruct.(FieldNames{j}),'SpecialFunctionGet') || isfield(AOStruct.(FieldNames{j}),'SpecialFunctionSet')
        iCol = iCol + 1;
        ColumnNames{iCol} = sprintf('%s', FieldNames{j});
        if ismemberof(Family, FieldNames{j},'Boolean Control') || ismemberof(Family, FieldNames{j},'BooleanControl')
            ColumnFormat{iCol} = 'logical'; % 'char'
        elseif ismemberof(Family, FieldNames{j},'Boolean Monitor') || ismemberof(Family, FieldNames{j},'BooleanMonitor')
            ColumnFormat{iCol} = 'char'; 
        else
            ColumnFormat{iCol} = 'numeric'; % 'char'
        end
        ColumnEdit(1,iCol) = false;
        ColumnWidth{iCol} = 90;
    end
end

% Display only power supplies if online
if strcmpi(getmode(Family,ColumnNames{2}), 'Online')
    CommonNames = family2common(Family, family2dev(Family,1,1));
else
    CommonNames = family2common(Family);
end
for k = 1:size(CommonNames,1)
    if iscell(CommonNames)
        Table{k,1} = deblank(CommonNames{k});
    else
        Table{k,1} = deblank(CommonNames(k,:));
    end
end

set(h_table, 'Data', Table);
set(h_table, 'ColumnName', ColumnNames);
set(h_table, 'ColumnFormat', ColumnFormat);
set(h_table, 'ColumnEditable', ColumnEdit);
set(h_table, 'ColumnWidth', ColumnWidth);
%set(h_table, 'ColumnWidth', 'auto');

set(h_table, 'Units', 'Pixels');
set(h_fig,  'Units', 'Pixels');
pFig = get(h_fig, 'Position');
TableWidth = sum(cell2mat(ColumnWidth))+60;

if TableWidth < 500
    TableWidth = 500;
end
set(h_table, 'Position', [4 4 TableWidth pFig(4)-40]);

pFig(3) = TableWidth + 10;
set(h_fig, 'Position', pFig);

set(h_table, 'Units', 'Normalized');
set(h_fig,   'Units', 'Normalized');


% title
MachineName     = getfamilydata('Machine');
SubMachineName  = getfamilydata('SubMachine');
OperationalMode = getfamilydata('OperationalMode');
try
    ModeString = getmode(Family);
catch
    ModeString = '';
end
try
    if isdeployed
        TitleString = sprintf('View Family:  %s  -  %s  -  %s  (%s - Standalone)', MachineName, SubMachineName, OperationalMode, ModeString);
    else
        TitleString = sprintf('View Family:  %s  -  %s  -  %s  (%s)', MachineName, SubMachineName, OperationalMode, ModeString);
    end
catch
    TitleString = sprintf('View Family:  %s  -  %s  -  %s  (%s)', MachineName, SubMachineName, OperationalMode, ModeString);
end
set(h_fig, 'Name', TitleString);

ViewFamily_Update_Callback(h, h_fig);
ViewFamily_Edit_Callback(h, h_fig);



function ViewFamily_Update_Callback(h_update, h_fig)

if nargin < 2 || isempty(h_fig)
    h_fig = gcbf;
end
h_table  = getappdata(h_fig, 'TableHandle');
h_update = getappdata(h_fig, 'UpdateHandle');
Family       = get(h_table, 'UserData');
CommonNames  = get(h_table, 'ColumnName');
ColumnFormat = get(h_table, 'ColumnFormat');
%ColumnWidth = get(h_table, 'ColumnWidth');

% Number of columns for Online vs Model is being determines by the first field
if strcmpi(getmode(Family,CommonNames{2}), 'Online')
    DeviceList = family2dev(Family,1,1);
else
    DeviceList = family2dev(Family,1,0);
end

% New table
Table = get(h_table, 'Data');
for j = 2:length(CommonNames)
    try
        if ismemberof(Family, CommonNames{j},'BooleanMonitor') || ismemberof(Family, CommonNames{j},'Boolean Monitor')
            ValueNow = getpv(Family, CommonNames{j}, DeviceList, 'char');
        else
            ValueNow = getpv(Family, CommonNames{j}, DeviceList);
        end
    catch
        ValueNow = NaN * ones(size(DeviceList,1),1);
        fprintf('   Problem with %s family\n', Family);
        fprintf('%s\n', lasterr);
    end
    
    for k = 1:size(ValueNow,1)
        if isnan(ValueNow(k))
            Table{k,j} = [];
        elseif strcmpi(ColumnFormat{j}, 'logical')
            if ValueNow(k)
                Table{k,j} = true;
            else
                Table{k,j} = false;
            end
        else
            Table{k,j} = ValueNow(k,:);
            %Table{k,j} = deblank(ValueNow(k,:));
        end
    end
end

set(h_update, 'String', sprintf('Update (%s)', datestr(now,14)));

set(h_table, 'Data', Table);

% Don't change the column widths (this does not work???)
%set(h_table, 'ColumnWidth', ColumnWidth);




function ViewFamily_Edit_Callback(h_edit, h_fig)
if nargin < 2 || isempty(h_fig)
    h_fig = gcbf;
end
h_edit  = getappdata(h_fig, 'EditHandle');
h_table = getappdata(h_fig, 'TableHandle');
Family      = get(h_table, 'UserData');
CommonNames = get(h_table, 'ColumnName');

ColumnEdit(1,1) = false;
if get(h_edit, 'Value') == 1
    for j = 2:length(CommonNames)
        if ismemberof(Family, CommonNames{j},'Setpoint') || ismemberof(Family, CommonNames{j},'Control') || ismemberof(Family, CommonNames{j},'Boolean Control') || ismemberof(Family, CommonNames{j},'BooleanControl')
            ColumnEdit(1,j) = true;         
        else
            ColumnEdit(1,j) = false;
        end
    end
    
    set(h_edit, 'String', 'Edit Mode is On');
else
    for j = 2:size(CommonNames,1)
        ColumnEdit(1,j) = false;
    end
    set(h_edit, 'String', 'Edit Mode is Off');
end

set(h_table, 'ColumnEditable', ColumnEdit);




function ViewFamily_Set_Table_Callback(varargin)

h_table = varargin{1};
Index = varargin{2}.Indices;
Table = get(h_table, 'Data');

Family = get(h_table, 'UserData');
CommonNames = get(h_table, 'ColumnName');
Field = CommonNames{Index(2)};
NewSP = Table{Index(1),Index(2)};

if islogical(NewSP)
    NewSP = double(NewSP);
end

% Using Family, Field, Device will catch special functions and can be used in simulate mode!
DeviceList = family2dev(Family);
fprintf('   Changing %s.%s(%d,%d) to %f\n', Family, Field, DeviceList(Index(1),:), NewSP);
setpv(Family, Field, NewSP, DeviceList(Index(1),:));

% Update here
%for i = 1:10;
pause(.2);
ViewFamily_Table_Callback(h_table);
%end


function ViewFamily_Resize_Callback(varargin)
h_fig   = varargin{1};
h_table  = getappdata(h_fig, 'TableHandle');
h_update = getappdata(h_fig, 'UpdateHandle');
h_edit   = getappdata(h_fig, 'EditHandle');

set(h_fig, 'Units', 'Pixels');
pFig = get(h_fig, 'Position');

if ~isempty(h_table)
    set(h_table, 'Units', 'Pixels');
    pTable = get(h_table, 'Position');
    pTable(4) = pFig(4)-40;
    set(h_table, 'Position', pTable);
    set(h_table,  'Units', 'Normalized');
end

if ~isempty(h_update)
    set(h_update, 'Units', 'Pixels');
    %pUpdate = get(h_update, 'Position');
    %pUpdate(2) = pFig(4)-30;
    pUpdate = [4 pFig(4)-30 175 25];
    set(h_update, 'Position', pUpdate);
    set(h_update, 'Units', 'Normalized');
end

if ~isempty(h_edit)
    set(h_edit, 'Units', 'Pixels');
    %pEdit = get(h_edit, 'Position');
    %pEdit(2) = pFig(4)-30;
    pEdit = [195 pFig(4)-30 150 25];
    set(h_edit, 'Position', pEdit);
    set(h_edit, 'Units', 'Normalized');
end

set(h_fig, 'Units', 'Normalized');