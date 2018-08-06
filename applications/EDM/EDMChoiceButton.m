function ChoiceButton = EDMChoiceButton(controlPv, x, y, varargin)

% Defaults
FontSize = 12;              % 8 10 12 14 18 24 72
FontWeight = 'bold';        % 'medium', 'bold'
FontName = 'helvetica';     % 'utopia', 'courier', 'new century schoolbook', 'times'
Orientation = 'horizontal'; % 'vertical'
indicatorPv = '';
visPv = '';
colorPv = '';
Width  = 70;
Height = 20;
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
        elseif strcmpi(varargin{i},'Orientation')
            Orientation = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'AlarmSensitive')
            AlarmSensitive = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'indicatorPv')
            indicatorPv = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'visPv')
            visPv = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'colorPv')
            colorPv = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end


ChoiceButton = { 
'# (Choice Button)'
'object activeChoiceButtonClass'
'beginObjectProperties'
'major 4'
'minor 0'
'release 0'
'x 37'
'y 56'
'w 70'
'h 20'
'fgColor index 14'
'fgAlarm'
'bgColor index 6'
'selectColor index 64'
'inconsistentColor index 64'
'topShadowColor index 0'
'botShadowColor index 14'
'controlPv "SR01____FFBON__BC00"'
'indicatorPv ""'
'font "helvetica-medium-r-14.0"'
'colorPv ""'
'orientation "horizontal"'
'endObjectProperties'
};

ChoiceButton{7}  = sprintf('x %d', x);
ChoiceButton{8}  = sprintf('y %d', y);
ChoiceButton{9}  = sprintf('w %d', Width);
ChoiceButton{10} = sprintf('h %d', Height);
ChoiceButton{18} = sprintf('controlPv "%s"', controlPv);
ChoiceButton{19} = sprintf('indicatorPv "%s"', indicatorPv);
ChoiceButton{20} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);
ChoiceButton{22} = sprintf('orientation "%s"', lower(Orientation));

if strcmpi(AlarmSensitive, 'Off')
    ChoiceButton(12) = [];
end

if ~isempty(visPv)
    ChoiceButton = [ChoiceButton(1:20); {sprintf('visPv "%s"', visPv)}; ChoiceButton(21:end);];
end
if ~isempty(visPv)
    ChoiceButton = [ChoiceButton(1:21); {sprintf('colorPv "%s"', colorPv)}; ChoiceButton(22:end);];
end

