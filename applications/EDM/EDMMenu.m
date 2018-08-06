function Button = EDMMenu(PVName, x, y, varargin)

% Defaults
FontSize = 14;
FontWeight = 'bold';    % 'medium', 'bold'
FontName = 'helvetica';
Width  = 70;
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
        elseif strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end

% # (Menu Button)
% object activeMenuButtonClass
% beginObjectProperties
% major 4
% minor 0
% release 0
% x 142
% y 111
% w 178
% h 105
% fgColor index 14
% bgColor index 0
% inconsistentColor index 14
% topShadowColor index 0
% botShadowColor index 14
% controlPv "pv"
% indicatorPv "pvrb"
% font "helvetica-medium-r-18.0"
% visPv "pvvis"
% colorPv "pvcolor"
% endObjectProperties

Button = {
'# (Menu Button)'
'object activeMenuButtonClass'
'beginObjectProperties'
'major 4'
'minor 0'
'release 0'
'x 73'
'y 131'
'w 70'
'h 20'
'fgColor index 14'
'bgColor index 31'
%'offColor index 2'
'inconsistentColor index 21'
'topShadowColor index 30'
'botShadowColor index 32'
'controlPv ""'
'indicatorPv ""'
'font "helvetica-bold-r-14.0"'
'endObjectProperties'
};

Button{7}  = sprintf('x %d', x);
Button{8}  = sprintf('y %d', y);
Button{9}  = sprintf('w %d', Width);
Button{10} = sprintf('h %d', Height);
Button{16} = sprintf('controlPv "%s"', PVName);
Button{18} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);
