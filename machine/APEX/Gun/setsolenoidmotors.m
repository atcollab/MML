function setsolenoidmotors(varargin)
%SETSOLENOIDMOTORS - GUI for setting the solenoid motors
%
%  See also plotfamily, viewfamily

% Written by Greg Portmann


% Run initialization if it has not been run (like standalone)
checkforao;

FigureTitle = 'Solenoid Motors';

% Input checking
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
        elseif strcmpi(varargin{i},'FileName')
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
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
ExtraHeight = -80;
FigurePosition = get(h.figure1, 'Position');
FigurePosition(2) = FigurePosition(2) - ExtraHeight + 50; % The 50 is for no MenuBar
FigurePosition(4) = FigurePosition(4) + ExtraHeight;
set(h.figure1, 'Position', FigurePosition);

% Could add pushtool for save/restore etc.
%ht = uitoolbar(h.figure1);
%htt = uipushtool(ht,'TooltipString','Hello');


% Setpoint table
ColNames = {'Motor', 'Setpoint', 'Monitor'};  % Column names
colfmt = {'char', 'numeric', 'numeric'};      % Columns contains 'logical', cell of string for popup
coledit = [false true false];                 % Editing or not
colwdt = {40 105 105};                        % Set columns width
a = {
    'M1', [], []
    'M2', [], []
    'M3', [], []
    'M4', [], []
    'M5', [], []
    };

TableHeight = 125; 
TableWidth    = sum(cell2mat(colwdt))+31;
TablePosition = [4 FigurePosition(4)-TableHeight-4-30 TableWidth TableHeight];

% Create the setpoint table
h.MotorTable = uitable(...
    'Units', 'pixels', ...
    'Position', TablePosition, ...
    'Data',  a, ...
    'ColumnName', ColNames, ...
    'ColumnFormat', colfmt, ...
    'ColumnWidth', colwdt, ...
    'ColumnEditable', coledit, ...
    'FontWeight', 'Bold', ...
    'RearrangeableColumns', 'off', ...
    'ToolTipString', '', ...
    'Tag', 'MotorTable', ...
    'CellEditCallback',{@Solenoid_TableEdit});
% CellSelectionCallback


% Monitor table
ConvertedTablePosition = [TablePosition(1)+TablePosition(3)+13 FigurePosition(4)-TableHeight-4-30 TableWidth TableHeight];

h.ConvertedTable = uitable(...
    'Units', 'pixels', ...
    'Position', ConvertedTablePosition, ...
    'Data',  a, ...
    'ColumnName', ColNames, ...
    'ColumnFormat', colfmt, ...
    'ColumnWidth', colwdt, ...
    'ColumnEditable', coledit, ...
    'FontWeight', 'Bold', ...
    'RearrangeableColumns', 'off', ...
    'ToolTipString', '', ...
    'Tag', 'ConvertedTable', ...
    'CellEditCallback',{@Solenoid_TableEdit});


%%%%%%%%%%%%%%%%%%%%
% Other UIControls %
%%%%%%%%%%%%%%%%%%%%

ButtonWidth1 = 80;
ButtonHeight = 30;
h.Zero = uicontrol(...
    'Style', 'pushbutton', ...
    'Units', 'pixels', ...
    'FontSize', 10, ...
    'String', 'Zero', ...
    'Position', [ConvertedTablePosition(1)                ConvertedTablePosition(2)-ButtonHeight-2 ButtonWidth1 ButtonHeight], ...
    'ToolTipString', 'Update the saved and present setpoints.', ...
    'Callback', @Solenoid_Zero);
ButtonWidth2 = 190;
h.RelToHome = uicontrol(...
    'Style', 'togglebutton', ...
    'Units', 'pixels', ...
    'FontSize', 10, ...
    'String', 'Relative to home position', ...
    'Position', [ConvertedTablePosition(1)+ButtonWidth1+5 ConvertedTablePosition(2)-ButtonHeight-2 ButtonWidth2 ButtonHeight], ...
    'ToolTipString', 'Sets the saved values to the machine.', ...
    'Callback', @Solenoid_RelToHome);


%%%%%%%%%%%%%%%
% Final setup %
%%%%%%%%%%%%%%%
FigurePosition(3) = TablePosition(1)+2*TablePosition(3)+20;
set(h.figure1, 'Position', FigurePosition);

set(h.figure1,        'Units', 'Normalized');
set(h.MotorTable,     'Units', 'Normalized');
set(h.ConvertedTable, 'Units', 'Normalized');
set(h.Zero,           'Units', 'Normalized');
set(h.RelToHome,      'Units', 'Normalized');

% Build and initialize the tables
setappdata(0, 'SolenoidMotorHandles', h);
Solenoid_Update(h);


% Setup Timer
UpdatePeriod = .5;

t = timer;
set(t, 'StartDelay', 0);
set(t, 'Period', UpdatePeriod);
set(t, 'TimerFcn', {@Solenoid_Update, h});
%set(t, 'StartFcn', ['llrf(''Timer_Start'',',    sprintf('%.30f',handles.hMainFigure), ',',sprintf('%.30f',handles.hMainFigure), ', [])']);
%set(t, 'UserData', thehandles);
set(t, 'BusyMode', 'drop');  %'queue'
set(t, 'TasksToExecute', Inf);
%set(t, 'TasksToExecute', 50);
set(t, 'ErrorFcn', {@Solenoid_Error,h});
set(t, 'ExecutionMode', 'FixedRate');
set(t, 'Tag', 'SolenoidMotorHandles');

h.TimerHandle = t;

% Save handles
setappdata(0, 'SolenoidMotorHandles', h);

% Hide or set the figure handle to callback
set(h.figure1, 'HandleVisibility', 'Callback');

% Draw the figure
set(h.figure1, 'Visible', 'On');
drawnow expose

start(t);


function Solenoid_Zero(varargin)
h = getappdata(0, 'SolenoidMotorHandles');
set(h.RelToHome, 'Value', 0);


function Solenoid_Error(varargin)

try
    h = getappdata(0, 'SolenoidMotorHandles');
    
    %  Stop and delete the timer
    if isfield(h,'TimerHandle')
        stop(h.TimerHandle);
        delete(h.TimerHandle);
        rmappdata(0, 'SolenoidMotorHandles');
        %delete(h.figure1);
    end
catch
    fprintf('   Trouble stopping the timer (setsolenoidmotors.m).\n');
end



function Solenoid_Update(varargin)

try
    h = getappdata(0, 'SolenoidMotorHandles');
    if ~ishandle(h.figure1)
        return
    end
catch
    return
end

sp = getam('Sol1M');
am = getam('Sol1M');
a = get(h.ConvertedTable, 'Data');
for i = 1:length(sp)
    a{i,2} = sp(i);
    a{i,3} = am(i) + randn(1,1);
end
set(h.MotorTable,     'Data', a);
set(h.ConvertedTable, 'Data', a);
%pause(.2)





function Solenoid_SetMotors(varargin)

h = getappdata(0, 'SolenoidMotorHandles');





function Solenoid_Select(varargin)

h = getappdata(0, 'SolenoidMotorHandles');

% Table handle
% Tag = get(varargin{1}, 'Tag');
% h = get(varargin{1}, 'UserData');
% 
% if strcmpi(Tag(1:7),'Restore')
%     Table = get(h.MotorTable, 'Data');
% else
%     Table = get(h.ConvertedTable, 'Data');
% end
% 
% for i = 1:size(Table,1)
%     if strcmpi(get(varargin{1},'String'),'All')
%         Table{i,3} = true;
%     else
%         Table{i,3} = false;
%     end
% end
% 
% if strcmpi(Tag(1:7),'Restore')
%     set(h.MotorTable, 'Data', Table);
%   %  MachineConfig_BuildTables(h, 'RestoreTableOnly');
% else
%     set(h.ConvertedTable, 'Data', Table);
%   %  MachineConfig_BuildTables(h, 'ConvertedTableOnly');
% end
% 
% set(varargin{1}, 'Value', 0);


function Solenoid_TableEdit(varargin)

h = getappdata(0, 'SolenoidMotorHandles');

% % Table handle
% h = get(varargin{1}, 'UserData');
% 
% ColNames = get(h.RestoreTableByData, 'ColumnName');
% 
% if get(h.Edit, 'Value') == 1
%     ColNames{3} = 'Present (edit)';
%     coledit = [false false true false false];
%     set(h.Edit, 'String', 'Edit Mode is On');
% else
%     ColNames{3} = 'Present';
%     coledit = [false false false false false];
%     set(h.Edit, 'String', 'Edit Mode is Off');
% end
% 
% set(h.RestoreTableByData, 'ColumnEditable', coledit);
% set(h.RestoreTableByData, 'ColumnName',     ColNames);

