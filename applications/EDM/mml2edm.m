function  [xmax, ymax, TitleBar]= mml2edm(Family, varargin)

% TitleBar
% TableTitle
% FileName
%
% ChannelNames  - Cell array of channel names (cell matrix for multiple columns)
%                 (family2channel(Family, Field, DeviceList))
% ChannelLabels = family2common(Family, DeviceList);
% ChannelLabelWidth
% ChannelType - Cell array of types ('Monitor', 'Boolean Control', 'Boolean Monitor')
% ColumnLabels
%
% ColumnWidth - Cell of widths (not including the first column of row labels)


if nargin < 1
    error('Family input must exist');
end

% Initialize
OnSleepTime = .1;
xBorder = 3;
yBorder = 2;
yHeight = 20;

BMWidth = 30;
BCWidth = 70;
MonitorWidth = 70;
ControlWidth = 70;
UpDownWidth = 30;
RelatedDisplayWidth = 80;
% UpDownCoarseValue = 1;
% UpDownFineValue = .1;


ChannelLabelWidth = [];
ScaleColumnWidth = 1;

% Inputs and defaults
ChannelNames = {};
ChannelType = {};
ChannelLabels = {};
ColumnLabels = {};
ColumnWidth = {};
RowLabels = 'On';
TitleBar = '';
TableTitle = '';
FileName = '';
Fields = {};
SP_AM = 'Off';
GoldenSetpoints = 'Off';
BC_SetAllButton = 'On';
SP_SetAllButton = 'On';
SP_BackgroundColor = [];
UpDownButton = 'Off';
MoreButton = 'Off';
RelatedDisplay = {};
WindowLocation = [60 60];
AppendFlag = 0;
xStart = 0;
yStart = 0;
EyeAide = 'Off';
MotifWidget = '';
HorizontalAlignment = 'right';  % 'left', 'center', 'right'
Precision = 3;
FieldLength = [];
DeviceList = [];

BCButtonType = '';  %  Reset or Choice
indicatorPv = '';
visPv = '';
colorPv = '';

for i = length(varargin):-1:1
    if ischar(varargin{i}) && size(varargin{i},1)==1
        if strcmpi(varargin{i},'TitleBar')
            TitleBar = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'TableTitle')
            TableTitle = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'RowLabels')
            RowLabels = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FileName')
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Fields')
            Fields = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ChannelNames')
            ChannelNames = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ChannelType')
            ChannelType = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ChannelLabels')
            ChannelLabels = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ColumnLabels')
            ColumnLabels = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'BCButtonType')
            BCButtonType = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'BC_SetAllButton')
            BC_SetAllButton = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'SP_SetAllButton')
            SP_SetAllButton = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'MoreButton')
            MoreButton = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'RelatedDisplay')
            RelatedDisplay = varargin{i+1};
            MoreButton = 'On';
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'SP-AM')
            SP_AM = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'UpDownButton')
            UpDownButton = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'GoldenSetpoints')
            GoldenSetpoints = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'EyeAide')
            EyeAide = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'MotifWidget')
            MotifWidget = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'WindowLocation')
            WindowLocation = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Append')
            AppendFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'ScaleColumnWidth')
            ScaleColumnWidth = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ChannelLabelWidth') || strcmpi(varargin{i},'CommonNameWidth')
            ChannelLabelWidth = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ColumnWidth')
            ColumnWidth = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'xStart')
            xStart = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'yStart')
            yStart = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontSize')
            FontSize = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontWeight')
            FontWeight = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FontName')
            FontName = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'HorizontalAlignment')
            HorizontalAlignment = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Precision')
            Precision = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FieldLength')
            FieldLength = varargin{i+1};
            varargin(i:i+1) = [];
%         elseif strcmpi(varargin{i},'indicatorPv')
%             indicatorPv = varargin{i+1};
%             varargin(i:i+1) = [];
%         elseif strcmpi(varargin{i},'visPv')
%             visPv = varargin{i+1};
%             varargin(i:i+1) = [];
%         elseif strcmpi(varargin{i},'colorPv')
%             colorPv = varargin{i+1};
%             varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'SP_BackgroundColor')
            SP_BackgroundColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'DeviceList')
            DeviceList = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end


% Column scaling
BMWidth = ceil(ScaleColumnWidth * BMWidth);
if  ~strcmpi(BCButtonType, 'Reset')
    BCWidth = ceil(ScaleColumnWidth * BCWidth);
end
MonitorWidth = ceil(ScaleColumnWidth * MonitorWidth);
ControlWidth = ceil(ScaleColumnWidth * ControlWidth);


if isempty(FileName)
    FileName = sprintf('MML2EDM_%s.edl', deblank(Family(1,:)));
end
if isempty(TitleBar)
    TitleBar = deblank(Family(1,:));
end
if isempty(TitleBar)
    TableTitle = deblank(Family(1,:));
end


%%%%%%%%%%%%%%%%%%%
% MML Conversions %
%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    [FamilyFlag, AOStruct] = isfamily(deblank(Family{1}));
else
    [FamilyFlag, AOStruct] = isfamily(deblank(Family(1,:)));
end
FamilyFlag = FamilyFlag(1);

if ~FamilyFlag
    ChannelNames = Family;
else
    if isempty(DeviceList)
        DeviceList = family2dev(Family, 1, 1);
    end
    
    ChannelLabels = family2common(Family, DeviceList);
    if ~iscell(ChannelLabels)
        ChannelLabels = deblank(mat2cell(ChannelLabels, ones(1,size(ChannelLabels,1)),size(ChannelLabels,2)));
    end
    
    % Just an ALS thing
    if isempty(Fields)
        Fields = defaultfieldnames(Family);
        for j = length(Fields):-1:1
            if ~isfield(AOStruct, Fields{j})
                % Remove fields not in the MML
                Fields(j) = [];
            end
        end        
        if isempty(Fields)
            Fields = fieldnames(AOStruct);
        end
    end
    
    % Force fields to be a row cell
    Fields = Fields(:)';
    
    if strcmpi(MoreButton, 'On')
        Fields{length(Fields)+1} = 'More';
    end
    
    % Where to put the SP-AM field
    if strcmpi(SP_AM, 'On')
        HitFlag = 0;
        for j = 1:length(Fields)
            if strcmpi(Fields{j}, 'Ready')
                HitFlag = 1;
                break;
            end
        end
        if HitFlag
            Fields = [Fields(1:j-1), 'SP-AM', Fields(j:end)];
        else
            for j = 1:length(Fields)
                if strcmpi(Fields{j}, 'Monitor')
                    break;
                end
            end
            Fields = [Fields(1:j), 'SP-AM', Fields(j+1:end)];
        end
    end
    
    
    i = 0;
    if isempty(ColumnLabels)
        for j = 1:length(Fields)
            if strcmpi(Fields{j}, 'SP-AM')
                % Add SP-AM Column
                i = i + 1;
                ColumnLabels{i} = 'SP-AM';
            else
                i = i + 1;
                %ColumnLabels = sprintf('%s', Fields{j});
                ColumnLabels{i} = Fields{j};
            end
        end
    end
    
    if isempty(ChannelType)
        for j = 1:length(Fields)
            %if isfield(AOStruct,Fields{j}) && isfield(AOStruct.(Fields{j}),'MemberOf') && isfield(AOStruct.(Fields{j}),'ChannelNames') && ~isempty(AOStruct.(Fields{j}).ChannelNames)
                if ismemberof(Family, Fields{j}, 'Boolean Monitor') || ismemberof(Family, Fields{j}, 'BooleanMonitor')
                    % Boolean Monitor
                    ChannelType{j} = 'Boolean Monitor';
                elseif ismemberof(Family, Fields{j}, 'Boolean Control') || ismemberof(Family, Fields{j}, 'BooleanControl')
                    % Boolean Control
                    ChannelType{j} = 'Boolean Control';
                elseif strcmpi(Fields{j},'SP-AM')
                    % SP-AM
                    ChannelType{j} = 'SP-AM';
                elseif ismemberof(Family, Fields{j}, 'Monitor')
                    % Monitor
                    ChannelType{j} = 'Monitor';
                elseif strcmpi(Fields{j}, 'More')
                    % More related display
                    ChannelType{j} = 'Related Display';
                else
                    % Control
                    ChannelType{j} = 'Control';
                end
            %end
        end
    else
        if strcmpi(MoreButton, 'On')
            % More related display
            ChannelType{length(ChannelType)+1} = 'Related Display';
        end
    end
    
    for j = 1:length(Fields)
        if strcmpi(Fields{j},'SP-AM')
            % Add SP-AM Column
            ChannelNames{j} = [];
        else
            
            PVCell = family2channel(Family, Fields{j}, DeviceList);
            %PVCell = AOStruct.(Fields{j}).ChannelNames;
            %PVCell = unique(PVCell, 'rows');
            
            if ~iscell(PVCell)
                PVCell = deblank(mat2cell(PVCell, ones(1,size(PVCell,1)),size(PVCell,2)));
            end
            
            ChannelNames{j} = PVCell;
        end
    end
end


%%%%%%%%%%%%%%%%%%
% Input Checking %
%%%%%%%%%%%%%%%%%%

% ChannelNames must be a cell of cells
if ~iscell(ChannelNames)
    % Just a string or string matrix
    ChannelNames{1}{1} = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
else
    % The contents of each cell must be a cell of strings
    for j = 1:length(ChannelNames)
        if ~iscell(ChannelNames{j})
            ChannelNames{j} = deblank(mat2cell(ChannelNames{j}, ones(1,size(ChannelNames{j},1)),size(ChannelNames{j},2)));
        end
    end
end


% Check cell and array sizes
% if length(ChannelNames) ~= length(ColumnLabels)
%     error('Channel name columns must equal column labels');
% end

if isempty(ColumnLabels)
    ColumnLabels{1} = '';
end

% Presently golden values are only known for family inputs
if ~FamilyFlag
    GoldenSetpoints = 'Off';
end
    
if isempty(ChannelType)
    for j = 1:length(ColumnLabels)
        ChannelType{j,1} = 'Monitor';
    end
end


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%
xStart = xStart + xBorder;
yStart = yStart + yBorder;
x = xStart;
y = yStart + 30;  % Leave room for a title
yTable = y;

xmax = x;
ymax = y;


L = 1;
for i = 1:length(ChannelLabels)
    L = max(L, size(ChannelLabels{i}, 2));
end
if isempty(ChannelLabelWidth)
    if L < 6
        ChannelLabelWidth = ceil(11*L);  % Must be an integer
    elseif L < 9
        ChannelLabelWidth = ceil(10*L);  % Must be an integer
    else
        ChannelLabelWidth = ceil(9.25*L);  % Must be an integer
    end
end


% Start the output file
[Header, TitleBar] = EDMHeader('TitleBar', TitleBar, 'WindowLocation', WindowLocation);


if AppendFlag
    fid = fopen(FileName, 'r+', 'b');
    status = fseek(fid, 0, 'eof');
else
    fid = fopen(FileName, 'w', 'b');
    WriteEDMFile(fid, Header);
end


% Build ColumnWidth
if isempty(ColumnWidth)
    for j = 1:length(ChannelType)
        if strcmpi(ChannelType{j},'Boolean Monitor') || strcmpi(ChannelType{j},'BooleanMonitor')
            % Boolean Monitor
            ColumnWidth{j} = BMWidth;
        elseif strcmpi(ChannelType{j},'Boolean Control') || strcmpi(ChannelType{j},'BooleanControl')
            % Boolean Control
            if strcmpi(Fields{j}, 'OnControl') || strcmpi(Fields{j}, 'BulkOn')
                ColumnWidth{j} = BCWidth;
            else
                ColumnWidth{j} = BCWidth + 30;
            end
        elseif strcmpi(ChannelType{j},'Monitor')
            % Monitor
            ColumnWidth{j} = MonitorWidth;
        elseif strcmpi(ChannelType{j},'SP-AM')
            % Special field: SP-AM
            ColumnWidth{j} = BMWidth*1.5;
        elseif strcmpi(ChannelType{j},'Related Display')
            % More related display
            ColumnWidth{j} = RelatedDisplayWidth;
        else
            % Control
            ColumnWidth{j} = ControlWidth;
        end
    end
else
    % ???, not sure if More is included already
    if strcmpi(MoreButton, 'On')
        % More related display
        ColumnWidth{length(ColumnWidth)+1} = RelatedDisplayWidth;
    end
end

% First lay down the lines (or rectangles)
if strcmpi(EyeAide, 'On')
    yTmp = y;
    
    Width = xBorder;
    
    % Row labels
    if strcmpi(RowLabels, 'On')
        Width = ChannelLabelWidth + xBorder;
    end
    
    % Golden Setpoints
    if strcmpi(GoldenSetpoints, 'On')
        Width = Width + MonitorWidth + xBorder;
    end
    
    % Add width of all the data columns
    for j = 1:length(ChannelType)
        if strcmpi(ChannelType{j},'Boolean Monitor') || strcmpi(ChannelType{j},'BooleanMonitor')
            % Boolean Monitor
            Width = Width + ColumnWidth{j} + xBorder;
        elseif strcmpi(ChannelType{j},'SP-AM')
            % SP - AM
            Width = Width + ColumnWidth{j} + xBorder; % + round(100*Width);
        elseif strcmpi(ChannelType{j},'Boolean Control') || strcmpi(ChannelType{j},'BooleanControl')
            % Boolean Control
            Width = Width + ColumnWidth{j} + xBorder;
        elseif strcmpi(ChannelType{j},'Monitor')
            % Monitor
            Width = Width + ColumnWidth{j} + xBorder;
        elseif strcmpi(ChannelType{j},'Related Display')
            % Related Display
            Width = Width + ColumnWidth{j} + xBorder;
        else
            % Control
            Width = Width + ColumnWidth{j} + xBorder;
            if strcmpi(UpDownButton, 'On')
                Width = Width + UpDownWidth + xBorder;
            end
        end
    end
    %Width = Width + 2*xBorder;

    for i = 1:length(ChannelLabels)+1
        y = y + yHeight + yBorder;
        EDMLine([x x+Width], [y-round(yBorder/2) y-round(yBorder/2)], 'FileName', fid, 'Width', Width, 'Height', 0, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %if rem(i,2) == 1
        %    EDMRectangle(x, y, 'FileName', fid, 'Width', Width, 'Height', yHeight, 'LineWidth', 1, 'LineColor', 2, 'FillColor', 2);
        %end
    end
    y = yTmp;
end


% Common name column for row labels
if strcmpi(RowLabels, 'On')
    WriteEDMFile(fid, EDMStaticText('Name', x, y, 'HorizontalAlignment', 'left', 'Width', ChannelLabelWidth));
    y = y + yHeight + yBorder;
    for i = 1:length(ChannelLabels)
        if ~isempty(ChannelLabels{i})
            WriteEDMFile(fid, EDMStaticText(ChannelLabels{i}, x, y, 'HorizontalAlignment', 'left', 'Width', ChannelLabelWidth));
        end
        y = y + yHeight + yBorder;
    end
    x = x + ChannelLabelWidth + xBorder;
    y = yTable;
end


% Golden Setpoints
if strcmpi(GoldenSetpoints, 'On') && any(strcmpi('Setpoint',Fields))
    Golden = getproductionlattice(Family, 'Setpoint');  % Structure output if it exists
    if ~isempty(Golden)
        iDev = findrowindex(DeviceList, Golden.DeviceList);
        Golden.Data = Golden.Data(iDev,:);
        Golden.DeviceList = Golden.DeviceList(iDev,:);
        
        % Column header
        %HeaderName = {'Golden', Golden.TimeStamp};
        HeaderName = 'Golden';
        WriteEDMFile(fid, EDMStaticText(HeaderName, x-3, y, 'Width', MonitorWidth+6, 'HorizontalAlignment', 'center'));
        y = y + yHeight + yBorder;
        
        NumberOfFloats = 0;
        for i = 1:size(Golden.Data,1)
            if rem(Golden.Data(i),1) ~= 0
                NumberOfFloats = NumberOfFloats + 1;
            end
        end
        
        for i = 1:length(ChannelLabels)
            if ~isempty(ChannelLabels{i})
                
                % Look for Golden Value
                iDev = findrowindex(DeviceList(i,:), Golden.DeviceList);
                if ~isempty(iDev)
                    GoldenValue = Golden.Data(iDev);
                else
                    GoldenValue = NaN;
                end
                
                if strcmpi(HorizontalAlignment, 'right')
                    if NumberOfFloats == 0
                        TextMonitor = EDMStaticText(sprintf('%d ', GoldenValue), x,   y, 'Width', MonitorWidth-7, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    else
                        TextMonitor = EDMStaticText(sprintf('%.3f',GoldenValue), x,   y, 'Width', MonitorWidth-7, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    end
                elseif strcmpi(HorizontalAlignment, 'left')
                    if NumberOfFloats == 0
                        TextMonitor = EDMStaticText(sprintf('%d',  GoldenValue), x+5, y, 'Width', MonitorWidth-5, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    else
                        TextMonitor = EDMStaticText(sprintf('%.3f',GoldenValue), x+5, y, 'Width', MonitorWidth-5, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    end
                else
                    if NumberOfFloats == 0
                        TextMonitor = EDMStaticText(sprintf('%d',  GoldenValue), x,   y, 'Width', MonitorWidth,   'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    else
                        TextMonitor = EDMStaticText(sprintf('%.3f',GoldenValue), x,   y, 'Width', MonitorWidth,   'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                    end
                end
                WriteEDMFile(fid, TextMonitor);
                
                %WriteEDMFile(fid, EDMStaticText(sprintf(' %.1f',GoldenValue), x, y, 'HorizontalAlignment', 'left', 'Width', ChannelLabelWidth));
            end
            y = y + yHeight + yBorder;
        end
        x = x + MonitorWidth + xBorder;
        y = yTable;
    end
end


for j = 1:length(ChannelType)
    PVCell = ChannelNames{j};

    % Column header
    %if ismemberof(Family, Fields{j},'Boolean Monitor') || ismemberof(Family, Fields{j},'BooleanMonitor')
    %    WriteEDMFile(fid, EDMStaticText(Fields{j}, x, y, 'HorizontalAlignment', 'left'));
    %else
    %    WriteEDMFile(fid, EDMStaticText(Fields{j}, x, y, 'HorizontalAlignment', 'center'));
    %end
    %y = y + yHeight + yBorder;

    if strcmpi(ChannelType{j},'Boolean Monitor') || strcmpi(ChannelType{j},'BooleanMonitor')
        % Boolean Monitor
        if strcmpi(ColumnLabels{j}, 'Ready')
            HeaderName = 'Rdy';
        elseif strcmpi(ColumnLabels{j}, 'BulkOn')
            HeaderName = 'On';
        else
            HeaderName = ColumnLabels{j};
        end
        WriteEDMFile(fid, EDMStaticText(HeaderName, x-3, y, 'Width', ColumnWidth{j}+6, 'HorizontalAlignment', 'center'));
        y = y + yHeight + yBorder;

        for i = 1:length(PVCell)
            if ~isempty(PVCell{i})
                % Based on severity
                WriteEDMFile(fid, EDMRectangle(x+6, y+1, 'AlarmPV', PVCell{i}, 'Width', ColumnWidth{j}-12, 'Height', 18));
                
                % 2 Rectangles: VisibleIf Zero -> Red(20) or NotVisibleIf Zero -> Green (15)
                %WriteEDMFile(fid, EDMRectangle(x+6, y+1,    'VisibleIf', PVCell{i}, 'FillColor', 20, 'LineColor', 20, 'Width', ColumnWidth{j}-12, 'Height', 18));
                %WriteEDMFile(fid, EDMRectangle(x+6, y+1, 'NotVisibleIf', PVCell{i}, 'FillColor', 15, 'LineColor', 15, 'Width', ColumnWidth{j}-12, 'Height', 18));
            end
            y = y + yHeight + yBorder;
        end
        x = x + ColumnWidth{j} + xBorder;

    elseif strcmpi(ChannelType{j},'Boolean Control') || strcmpi(ChannelType{j},'BooleanControl')
        % Boolean Control
        if strcmpi(ColumnLabels{j}, 'OnControl')
            HeaderName = 'On Ctrl';
        elseif strcmpi(ColumnLabels{j}, 'BulkControl')
            HeaderName = 'Bulk Ctrl';
        else
            HeaderName = ColumnLabels{j};
        end
        WriteEDMFile(fid, EDMStaticText(HeaderName, x-3, y, 'Width', ColumnWidth{j}+6, 'HorizontalAlignment', 'center'));
        y = y + yHeight + yBorder;

        for i = 1:length(PVCell)
            if ~isempty(PVCell{i})
                if  strcmpi(BCButtonType, 'Reset') || strcmpi(ColumnLabels{j}, 'Reset')                   
                    WriteEDMFile(fid, EDMResetButton(PVCell{i}, x, y, 'Width', ColumnWidth{j}));
                else
                    %WriteEDMFile(fid, EDMButton(PVCell{i}, x, y, 'Width', ColumnWidth{j}, 'ButtonType', 'Push'));
                    %WriteEDMFile(fid, EDMButton(PVCell{i}, x, y, 'Width', ColumnWidth{j}, 'ButtonType', 'Toggle'));
                    if strcmpi(Fields{j}, 'OnControl') %|| strcmpi(Fields{j}, 'BulkControl')
                        WriteEDMFile(fid, EDMChoiceButton(PVCell{i}, x, y, 'Width', ColumnWidth{j}, 'indicatorPv', ChannelNames{j-1}{i}));
                    else
                        WriteEDMFile(fid, EDMChoiceButton(PVCell{i}, x, y, 'Width', ColumnWidth{j}));
                    end
                end
            end
            y = y + yHeight + yBorder;
        end

        if FamilyFlag && strcmpi(BC_SetAllButton,'On') && length(PVCell) > 1
            % Make the shell command
            if strcmpi(Fields{j}, 'OnControl')
                FileName = mml2caput(Family, Fields{j}, '', DeviceList, '', OnSleepTime);
            else
                FileName = mml2caput(Family, Fields{j}, '', DeviceList);
            end

            WriteEDMFile(fid, EDMShellCommand( ...
                {sprintf('sh %s 1',FileName),sprintf('sh %s 0',FileName)}, x, y, 'Width', ColumnWidth{j}, 'ButtonLabel', 'ALL', ...
                'CommandLabel', {sprintf('%s.%s On',Family, Fields{j}),sprintf('%s.%s Off',Family, Fields{j})}));
            y = y + yHeight + yBorder;
        end

        x = x + ColumnWidth{j} + xBorder;
        
        
    elseif strcmpi(ChannelType{j},'SP-AM')
        % Add SP-AM Column
        WriteEDMFile(fid, EDMStaticText(ColumnLabels{j}, x-3, y, 'Width', ColumnWidth{j}+6, 'FontSize', 12, 'HorizontalAlignment', 'center'));
        y = y + yHeight + yBorder;
        
        for i = 1:size(DeviceList,1)
            [visPV, Tol] = epicscalcrecord_sp_am(Family, DeviceList(i,:));
            %fprintf('%s\n', visPV);
            WriteEDMFile(fid, EDMRectangle(x+6+7, y+1, 'VisibleIf',    visPV, 'Range', [Tol 1000000], 'LineColor', 20, 'FillColor', 20, 'Width', ColumnWidth{j}-12-15, 'Height', 18));
            WriteEDMFile(fid, EDMRectangle(x+6+7, y+1, 'NotVisibleIf', visPV, 'Range', [Tol 1000000], 'LineColor', 18, 'FillColor', 18, 'Width', ColumnWidth{j}-12-15, 'Height', 18));
            y = y + yHeight + yBorder;
        end
        
        x = x + ColumnWidth{j} + xBorder;
        

    elseif strcmpi(ChannelType{j},'Monitor')
        % Monitor
        WriteEDMFile(fid, EDMStaticText(ColumnLabels{j}, x-3, y, 'Width', ColumnWidth{j}+6, 'HorizontalAlignment', 'center'));
        y = y + yHeight + yBorder;

        for i = 1:length(PVCell)
            if ~isempty(PVCell{i})
                if strcmpi(HorizontalAlignment, 'right')
                    TextMonitor = EDMTextMonitor(PVCell{i}, x,   y, 'Width', ColumnWidth{j}-7, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                elseif strcmpi(HorizontalAlignment, 'left')
                    TextMonitor = EDMTextMonitor(PVCell{i}, x+5, y, 'Width', ColumnWidth{j}-5, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                else
                    TextMonitor = EDMTextMonitor(PVCell{i}, x,   y, 'Width', ColumnWidth{j},   'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength);
                end
                %TextMonitor = EDMTextMonitor(PVCell{i}, x, y, 'HorizontalAlignment','right', 'Precision',3);
                WriteEDMFile(fid, TextMonitor);
            end
            y = y + yHeight + yBorder;
        end
        x = x + ColumnWidth{j} + xBorder;
        
        
    elseif strcmpi(ChannelType{j},'Control')
        % Control
        WriteEDMFile(fid, EDMStaticText(ColumnLabels{j}, x-3, y, 'Width', ColumnWidth{j}+6, 'HorizontalAlignment', 'center'));
        y = y + yHeight + yBorder;
        
        for i = 1:length(PVCell)
            if ~isempty(PVCell{i})
                % Adjust the width a like for visibility reasons
                if any(strcmpi(MotifWidget,{'On','Yes'}))
                    % MotifWidget
                    Width = ColumnWidth{j};
                else
                    if strcmpi(HorizontalAlignment, 'right')
                        Width = ColumnWidth{j}-7;
                    elseif strcmpi(HorizontalAlignment, 'left')
                        Width = ColumnWidth{j}-5;
                    else
                        Width = ColumnWidth{j};
                    end
                end
                TextControl = EDMTextControl(PVCell{i}, x, y, 'Width', Width, 'HorizontalAlignment', HorizontalAlignment, 'Precision', Precision, 'FieldLength', FieldLength, 'MotifWidget', MotifWidget, 'BackgroundColor', SP_BackgroundColor);
                WriteEDMFile(fid, TextControl);
            end
            y = y + yHeight + yBorder;
        end
        
        
        if FamilyFlag && strcmpi(SP_SetAllButton,'On')
            % Make the shell command for Max, Save, Zero, Min
            FileNameCell = {};
            ExtraButton = 0;
            if strcmpi(Fields{j}, 'Setpoint')
                % Save file - must be there already (likely from setmachineconfig_*)
                FileNameSaved = sprintf('%s_%s_MachineSave.sh', Family, Fields{j});
                if exist(FileNameSaved, 'file')
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', FileNameSaved];
                    CommandLabelCell{length(FileNameCell)} = 'Restore the Golden Values';
                    
                    % Add a blank
                    FileNameCell{length(FileNameCell)+1}   = ' ';  % Note: space is needed for EDM
                    CommandLabelCell{length(FileNameCell)} = '-------------------------';
                    
                    ExtraButton = 1;
                end
                
                if ~all(maxpv(Family, Fields{j}, DeviceList) == 0) && ~any(abs(maxpv(Family, Fields{j}, DeviceList)) == Inf)
                    % Max
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, 'Max', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = 'Maximum';
                    % 75% Max
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, '75%Max', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = '75% Maximum';
                    % 50% Max
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, '50%Max', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = '50% Maximum';
                    % 25% Max
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, '25%Max', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = '25% Maximum';
                end
                
                % Zero
                FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, 'Zero', DeviceList, '', 0)];
                CommandLabelCell{length(FileNameCell)} = 'Zero';
                
                if ~all(minpv(Family, Fields{j}, DeviceList) == 0) && ~any(abs(minpv(Family, Fields{j}, DeviceList)) == Inf)
                    % 25% Min
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, '25%Min', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = '25% Minimum';                    
                    % 50% Min
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, '50%Min', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = '50% Minimum';
                    % 75% Min
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, '75%Min', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = '75% Minimum';
                    % Min
                    FileNameCell{length(FileNameCell)+1}   = ['sh ', mml2caput(Family, Fields{j}, 'Min', DeviceList, '', 0)];
                    CommandLabelCell{length(FileNameCell)} = 'Minimum';
                end
                
                if ExtraButton || length(PVCell) > 1
                    WriteEDMFile(fid, EDMShellCommand( ...
                        FileNameCell, x, y, 'Width', Width, 'ButtonLabel', 'ALL', ...
                        'CommandLabel', CommandLabelCell));
                    y = y + yHeight + yBorder;
                end
            end
        end
        
        x = x + ColumnWidth{j} + xBorder;
        
        
        % UpDownButton
        if strcmpi(UpDownButton, 'On')
            if y > ymax
                ymax = y;
            end
            
            % Return to the top of the table
            y = yTable;
            
            y = y + yHeight + yBorder;  % For column header
            for i = 1:length(PVCell)
                if ~isempty(PVCell{i})
                    UpDownButton = EDMUpDownButton(PVCell{i}, x, y, 'Width', UpDownWidth, 'HorizontalAlignment', HorizontalAlignment);
                    WriteEDMFile(fid, UpDownButton);
                    y = y + yHeight + yBorder;
                end
            end
            
            x = x + UpDownWidth + xBorder;
        end
        
    elseif strcmpi(ChannelType{j}, 'Related Display')
        % Related Display
        
        x = x + xBorder;
        
        % Skip column header
        %WriteEDMFile(fid, EDMStaticText(ColumnLabels{j}, x-3, y, 'Width', ColumnWidth{j}+6, 'HorizontalAlignment', 'center'));
        y = y + yHeight + yBorder;
        
        DeviceType = getfamilydata(Family, 'DeviceType', DeviceList);
        BaseName   = getfamilydata(Family, 'BaseName',   DeviceList);
               
        for i = 1:length(DeviceType)
            if ~isempty(RelatedDisplay)
                WriteEDMFile(fid, EDMRelatedDisplay(RelatedDisplay{i}, ...
                    x, y, 'Width', ColumnWidth{j}, 'ButtonLabel', 'More ...', 'FontSize',10));
                
            elseif strcmpi(DeviceType{i}, 'Caen') || strcmpi(DeviceType{i}, 'Caen SY3634') || strcmpi(DeviceType{i}, 'Caen SY3662')
                if strcmpi(getfamilydata('Machine'), 'ALS')
                    ii = strfind(BaseName{i},':');
                    if isempty(ii)
                        fprintf('   Skipping Related Display for %s\n', BaseName{i});
                    else
                        % Make this more robust???
                        MacroStr = sprintf('P=%s:,R=%s:', BaseName{i}(1:ii(1)-1), BaseName{i}(ii(1)+1:end));  % Like 'P=GTL:,R=BC1:'
                        WriteEDMFile(fid, EDMRelatedDisplay( ...
                            '/usr/local/epics/R3.14.12/modules/instrument/CaenA36xx/head/opi/CaenA36xx.edl', ...
                            x, y, 'Width', ColumnWidth{j}, 'ButtonLabel', 'Caen ...', 'Macro', MacroStr, 'FontSize',10));
                    end
                elseif strcmpi(getfamilydata('Machine'), 'APEX')
                    % Make this more robust???
                    MacroStr = sprintf('P=%s,R=%s:', BaseName{i}(1:end-1), BaseName{i}(end));
                    WriteEDMFile(fid, EDMRelatedDisplay( ...
                        '/usr/local/epics/R3.14.12/modules/R1/instrument/CaenA36xx/CaenA36xx-1.2a/opi/CaenA36xx.edl', ...
                        x, y, 'Width', ColumnWidth{j}, 'ButtonLabel', 'Caen ...', 'Macro', MacroStr, 'FontSize',10));
                else
                    fprintf('   Skipping Related Display for %s\n', BaseName{i});
                end
                
            elseif strcmpi(DeviceType{i}, 'IRM')
                MacroStr = sprintf('P=irm:,R=%s:', BaseName{i}(5:7));
                WriteEDMFile(fid, EDMRelatedDisplay('/vxboot/siocirm/boot/opi/IRM_Overall.edl', ...
                    x, y, 'Width', ColumnWidth{j}, 'ButtonLabel', 'IRM ...', 'Macro', MacroStr, 'FontSize',10));
                %WriteEDMFile(fid, EDMShellCommand(sprintf('sh runIRM.sh %s', BaseName{i}(5:7)), ...
                %    x, y, 'Width', ColumnWidth{j}, 'ButtonLabel', 'IRM ...', 'FontSize',10));
                
                %%WriteEDMFile(fid, EDMRelatedDisplay('/home/als/physbase/hlc/IRM/IRM.edl', ...
                
            elseif strcmpi(DeviceType{i}, 'TDK')
                ii = strfind(BaseName{i},':');
                MacroStr = sprintf('ps=%s', BaseName{i});  % Like 'ps=s07shf1'
                WriteEDMFile(fid, EDMRelatedDisplay( ...
                    '/home/als/physbase/hlc/General/genesys_ps_diagnostics.edl', ...
                    x, y, 'Width', ColumnWidth{j}, 'ButtonLabel', 'TDK ...', 'Macro', MacroStr, 'FontSize',10));
            else
                
            end
            
            y = y + yHeight + yBorder;
        end
        x = x + ColumnWidth{j} + xBorder;
        
    else
        error(sprintf('ChannelType = %s, unknown method', ChannelType{j}));
    end


    % Keep track of the extent of the table
    if x > xmax
        xmax = x;
    end
    if y > ymax
        ymax = y;
    end

    % Return to the top of the table
    y = yTable;
end



% Add a title across the top
%L = 8*length(ColumnLabels);  % Just a guess
%xTitle = round((xmax-xStart)/2 + xStart - L/2);
%StaticText = EDMStaticText(sprintf('%s', Family), xTitle, yStart+2, 'Width', round(L)+25, 'FontSize',18, 'FontWeight','bold', 'HorizontalAlignment','center');
L = 13*length(TableTitle);  % Just a guess
xTitle = round((xmax-xStart)/2 + xStart - L/2);
StaticText = EDMStaticText(sprintf('%s', TableTitle), xTitle, yStart+2, 'Width', round(L)+25, 'Height', 30, 'FontSize',24, 'FontWeight','bold', 'HorizontalAlignment','center');
WriteEDMFile(fid, StaticText);


if  ymax > 1500   %  I'm not sure when the slider appears
    % To account for a window slider
    Width  = xmax+30;
    Height = 1220;
else
    Width  = xmax + 10;
    Height = ymax + 10;
end
EDMHeader('FileName', fid, 'TitleBar', TitleBar, 'WindowLocation', WindowLocation, 'Width', Width, 'Height', Height);


fclose(fid);



function WriteEDMFile(fid, Header)

for i = 1:length(Header)
    fprintf(fid, '%s\n', Header{i});
end
fprintf(fid, '\n');



function Fields = defaultfieldnames(Family)

Fields = {};

if strcmpi(getfamilydata('Machine'), 'ALS')
    % ALS Only
    if any(strcmpi(Family, {'HCM','VCM'}))
        Fields = {
            'Setpoint'
           %'DAC'
            'Monitor'
            'Trim'
            'FF1'
            'FF2'
           %'FFMultiplier'
           %'RampRate'
           %'TimeConstant'
            'Voltage'
            'Leakage'
            'Ready'
            'On'
            'OnControl'
           %'BulkOn'
           %'BulkControl'
            };
        
        if strcmpi(getfamilydata('SubMachine'),'StorageRing')
            Fields{length(Fields)+1} = 'DAC';
            Fields{length(Fields)+1} = 'RampRate';
            Fields{length(Fields)+1} = 'Reset';
        end
      
    elseif any(strcmpi(Family, {'QF','QD'}))
        Fields = {
            'Setpoint'
            'Monitor'
            'FF'
           %'FFMultiplier'
           %'DAC'
           %'RampRate'
           %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
           %'BulkOn'
           %'BulkControl'
            };
        
        if strcmpi(getfamilydata('SubMachine'),'StorageRing')
            Fields{length(Fields)+1} = 'Reset';
        end
        
    elseif any(strcmpi(Family, {'QFA','QDA','Q','BuckingCoil'}))
        Fields = {
            'Setpoint'
            'Monitor'
           %'DAC'
           %'RampRate'
           %'TimeConstant'
            'Voltage'
            'Leakage'
            'Ready'
            'On'
            'OnControl'
           %'BulkOn'
           %'BulkControl'
            };
        if strcmpi(getfamilydata('SubMachine'),'StorageRing')
            Fields{length(Fields)+1} = 'Reset';
        end
        
    elseif any(strcmpi(Family, {'SQSHF'}))
        Fields = {
            'Setpoint'
            'Monitor'
           %'DAC'
           %'RampRate'
           %'TimeConstant'
            'Voltage'
            'Leakage'
            'Ready'
            'On'
            'OnControl'
           %'BulkOn'
           %'BulkControl'
           %'Reset'
            };
        
    elseif any(strcmpi(Family, {'SQSF','SQSD'}))
        Fields = {
            'Setpoint'
            'Monitor'
            %'DAC'
            'RampRate'
            %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
            'Reset'
            };
        
    elseif any(strcmpi(Family, {'SQEPU'}))
        Fields = {
            'Setpoint'
            'Monitor'
            'FF'
            %'FFMultiplier'
            'Sum'
            'DAC'
            'RampRate'
            'Ready'
            'On'
            'OnControl'
           %'Reset'
            };
        
    elseif any(strcmpi(Family, {'SHF','SHD'}))
        Fields = {
            'Setpoint'
            'Monitor'
            'Ready'
            'On'
            'OnControl'
            %'Reset'
            };
    elseif any(strcmpi(Family, {'BEND','SF','SD'}))
        Fields = {
            'Setpoint'
            'Monitor'
            %'DAC'
            'RampRate'
            %'TimeConstant'
            'Ready'
            'On'
            'OnControl'
            %'Reset'
            };
    elseif any(strcmpi(Family, {'SOL'}))
        Fields = {
            'Setpoint'
            'Monitor'
            'Ready'
            'On'
            'OnControl'
            };
    elseif any(strcmpi(Family, {'GunTiming','BRTiming','SRTiming'}))
        Fields = {
            'Setpoint'
            'Monitor'
            };
    end
end

% Default field list
if isempty(Fields)
    AO = getfamilydata(Family);
    if isfield(AO, 'FamilyName')
        AO = rmfield(AO, 'FamilyName');
    end
    if isfield(AO, 'MemberOf')
        AO = rmfield(AO, 'MemberOf');
    end
    if isfield(AO, 'DeviceList')
        AO = rmfield(AO, 'DeviceList');
    end
    if isfield(AO, 'ElementList')
        AO = rmfield(AO, 'ElementList');
    end
    if isfield(AO, 'Status')
        AO = rmfield(AO, 'Status');
    end
    if isfield(AO, 'Position')
        AO = rmfield(AO, 'Position');
    end
    if isfield(AO, 'CommonNames')
        AO = rmfield(AO, 'CommonNames');
    end
    
    Fields = fieldnames(AO);
end


