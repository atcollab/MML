function TextMonitor = EDMTextMonitor(PVName, x, y, varargin)

% Defaults
FontSize = 14;
FontWeight = 'bold';  % 'medium', 'bold'
HorizontalAlignment = 'center';  % 'left', 'center', 'right'
FontName = 'helvetica';
%FontAngle = ???
Precision = '';
FieldLength = '';

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
        end
    end
end


TextMonitor = {
'# (Text Monitor)'
'object activeXTextDspClass:noedit'
'beginObjectProperties'
'major 4'
'minor 2'
'release 0'
'x 14'
'y 19'
'w 70'
'h 20'
'controlPv ""'
'font "helvetica-bold-r-14.0"'
'fontAlign "center"'
'fgColor index 14'
'bgColor index 0'
'useDisplayBg'
'autoHeight'
'limitsFromDb'
'nullColor index 0'
'useHexPrefix'
'newPos'
'objType "monitors"'
'endObjectProperties'
};

TextMonitor{7}  = sprintf('x %d', x);
TextMonitor{8}  = sprintf('y %d', y);
TextMonitor{9}  = sprintf('w %d', Width);
TextMonitor{10} = sprintf('h %d', Height);
TextMonitor{11} = sprintf('controlPv "%s"', PVName);
TextMonitor{12} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);
TextMonitor{13} = sprintf('fontAlign "%s"', lower(HorizontalAlignment));
if ~isempty(Precision)
TextMonitor{18} = sprintf('precision %d', Precision);
end

if strcmpi(AlarmBorder, 'On')
    TextMonitor = [TextMonitor(1:20); {'useAlarmBorder'}; TextMonitor(21:end);];
end

if ~isempty(FieldLength)
    TextMonitor = [TextMonitor(1:18); {sprintf('fieldLen "%d"', FieldLength)}; TextMonitor(19:end);];
end

if strcmpi(AlarmBorder, 'On') || strcmpi(AlarmSensitive, 'On')
    TextMonitor = [TextMonitor(1:19); {'fgAlarm'}; TextMonitor(20:end);];
end
