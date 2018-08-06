function StaticText = EDMStaticText(String, x, y, varargin)

%
%   1. String - String or cell array of strings


% Defaults
FontSize = 14;         %  8 10 12 14 18 24 72
FontWeight = 'bold';  % 'medium', 'bold'
HorizontalAlignment = 'center';  % 'left', 'center', 'right'
FontName = 'helvetica';

Width  = [];  % 70
Height = 20;

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
        end
    end
end


if isempty(Width)
    WidthRatio = (5/4)*FontSize;
    if iscell(String)
        Width = 10;
        for i = 1:length(String)
            Width = max(Width, ceil(WidthRatio*length(String{i})));
        end
    else
        Width = ceil(WidthRatio*length(String));
    end
end


StaticText = {
'# (Static Text)'
'object activeXTextClass'
'beginObjectProperties'
'major 4'
'minor 1'
'release 0'
'x 51'
'y 50'
'w 70'
'h 20'
'font "helvetica-bold-r-14.0"'
'fontAlign "center"'
'fgColor index 29'
'bgColor index 0'
'useDisplayBg'
'value {'
'  ""'
'}'
%'autoSize'
'endObjectProperties'
};


StaticText{7}  = sprintf('x %d', x);
StaticText{8}  = sprintf('y %d', y);
StaticText{9}  = sprintf('w %d', Width);
StaticText{10} = sprintf('h %d', Height);
StaticText{11} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);
StaticText{12} = sprintf('fontAlign "%s"', lower(HorizontalAlignment));

if iscell(String)
    for i = 1:length(String)
        StaticText{16+i} = sprintf('  "%s"', String{i});
    end
    StaticText{16+i+1} = '}';
    StaticText{16+i+2} = 'autoSize';
    StaticText{16+i+2} = 'endObjectProperties';
else
    StaticText{17} = sprintf('  "%s"', String);
end

