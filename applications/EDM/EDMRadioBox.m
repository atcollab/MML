function RadioBox = EDMRadioBox(PVName, x, y, varargin)

% Defaults
FontSize = 14;
FontWeight = 'bold';  % 'medium', 'bold'
FontName = 'helvetica';

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
        end
    end
end


RadioBox = {
'# (Radio Box)'
'object activeRadioButtonClass'
'beginObjectProperties'
'major 4'
'minor 0'
'release 0'
'x 32'
'y 62'
'w 20'
'h 20'
'fgColor index 14'
'bgColor index 0'
'buttonColor index 14'
'selectColor index 14'
'topShadowColor index 0'
'botShadowColor index 14'
'controlPv ""'
'font "helvetica-medium-r-14.0"'
'endObjectProperties'
};

RadioBox{7}  = sprintf('x %d', x);
RadioBox{8}  = sprintf('y %d', y);
RadioBox{17} = sprintf('controlPv "%s"', PVName);
RadioBox{18} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);


