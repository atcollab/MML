function TextControl = EDMTextControl(PVName, x, y, varargin)

% Defaults
FontSize = 14;
FontWeight = 'bold';  % 'medium', 'bold'
HorizontalAlignment = 'center';  % 'left', 'center', 'right'
FontName = 'helvetica';
%FontAngle = ???
Precision = '';
FieldLength = '';
MotifWidget = '';  % On/Off
ForegroundColor = [];
BackgroundColor = 3;

Width  = 70;
Height = 20;

AlarmBorder = 'Off';
AlarmSensitive = 'Off';

for i = length(varargin):-1:1
    if ischar(varargin{i}) && size(varargin{i},1)==1
        if strcmpi(varargin{i},'FontSize')
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
        elseif strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'AlarmBorder')
            AlarmBorder = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'AlarmSensitive')
            AlarmSensitive = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'MotifWidget')
            MotifWidget = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ForegroundColor')
            ForegroundColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'BackgroundColor')
            BackgroundColor = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end


TextControl = {
'# (Text Control)'
'object activeXTextDspClass'
'beginObjectProperties'
'major 4'
'minor 2'
'release 0'
'x 13'
'y 46'
'w 70'
'h 20'
'controlPv ""'
'font "helvetica-bold-r-14.0"'
'fontAlign "center"'
'fgColor index 14'
'bgColor index 0'
'useDisplayBg'
'editable'
'autoHeight'
'motifWidget'
'limitsFromDb'
'nullColor index 0'
'smartRefresh'
'useHexPrefix'
'newPos'
'objType "controls"'
'endObjectProperties'
};

% 'fastUpdate'

TextControl{7}  = sprintf('x %d', x);
TextControl{8}  = sprintf('y %d', y);
TextControl{9}  = sprintf('w %d', Width);
TextControl{10} = sprintf('h %d', Height);
TextControl{11} = sprintf('controlPv "%s"', PVName);
TextControl{12} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);
TextControl{13} = sprintf('fontAlign "%s"', lower(HorizontalAlignment));

if ~isempty(Precision)
    TextControl{20} = sprintf('precision %d', Precision);
end

if strcmpi(AlarmBorder, 'On')
    TextControl = [TextControl(1:23); {'useAlarmBorder'}; TextControl(24:end);];
end

if ~isempty(FieldLength)
    TextControl = [TextControl(1:20); {sprintf('fieldLen "%d"', FieldLength)}; TextControl(21:end);];
end

if strcmpi(AlarmBorder, 'On') || strcmpi(AlarmSensitive, 'On')
    TextControl = [TextControl(1:14); {'fgAlarm'}; TextControl(15:end);];
end

% Remove the MotifWidget
if ~any(strcmpi(MotifWidget,{'On','Yes'}))
    TextControl(19) = [];
end

if ~isempty(ForegroundColor)
    % Change FG color
    TextControl{14} = sprintf('fgColor index %d', ForegroundColor); 
end

if ~isempty(BackgroundColor)
    % Change BG color
    TextControl{15} = sprintf('bgColor index %d', BackgroundColor); 
    TextControl(16) = [];
end



