function TextControl = EDMUpDownButton(PVName, x, y, varargin)

% Defaults
FontSize = 8;  %  8 10 12 14 18 24 72

FontWeight = 'medium';  % 'medium', 'bold'
HorizontalAlignment = 'center';  % 'left', 'center', 'right'
FontName = 'helvetica';

CoarseValue = 1;
FineValue = .1;

Width  = 30;
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
        elseif strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'CoarseValue')
            CoarseValue = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FineValue')
            FineValue = varargin{i+1};
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


TextControl = {
'# (Up/Down Button)'
'object activeUpdownButtonClass'
'beginObjectProperties'
'major 4'
'minor 0'
'release 0'
'x 10'
'y 10'
'w 70'
'h 20'
'fgColor index 14'
'bgColor index 60'
'topShadowColor index 0'
'botShadowColor index 14'
'controlPv "PVName"'
'coarseValue "1"'
'fineValue ".1"'
'label "< >"'
'3d'
'rate 0.1'
'font "helvetica-medium-r-18.0"'
'limitsFromDb'
'endObjectProperties'
};

TextControl{7}  = sprintf('x %d', x);
TextControl{8}  = sprintf('y %d', y);
TextControl{9}  = sprintf('w %d', Width);
TextControl{10} = sprintf('h %d', Height);

TextControl{15} = sprintf('controlPv "%s"', PVName);
TextControl{21} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);
TextControl{16} = sprintf('coarseValue "%f"', CoarseValue);
TextControl{17} = sprintf('fineValue "%f"', FineValue);

