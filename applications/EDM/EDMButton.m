function Button = EDMButton(PVName, x, y, varargin)

% Defaults
FontSize = 14;
FontWeight = 'bold';    % 'medium', 'bold'
FontName = 'helvetica';
LabelType = 'PV State'; % 'PV State' or 'Literal'
ButtonType = 'Toggle';  % 'Toggle' or 'Push'
OnLabel = '';
OffLabel = '';
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
        elseif strcmpi(varargin{i},'ButtonType')
            ButtonType = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'LabelType')
            LabelType = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'OnLabel')
            OnLabel = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'OffLabel')
            OffLabel = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end


Button = {
'# (Button)'
'object activeButtonClass'
'beginObjectProperties'
'major 4'
'minor 0'
'release 0'
'x 73'
'y 131'
'w 70'
'h 20'
'fgColor index 14'
'onColor index 0'
'offColor index 2'
'inconsistentColor index 14'
'topShadowColor index 0'
'botShadowColor index 14'
'controlPv ""'
%indicatorPv "ETI_Reset_TRIPSA"
%onLabel "Reset"
%offLabel "Reset"
%'labelType "literal"'
%'buttonType "push"'
'3d'
'font "helvetica-bold-r-14.0"'
'objType "controls"'
'endObjectProperties'
};

Button{7}  = sprintf('x %d', x);
Button{8}  = sprintf('y %d', y);
Button{9}  = sprintf('w %d', Width);
Button{10} = sprintf('h %d', Height);
Button{17} = sprintf('controlPv "%s"', PVName);
Button{19} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);

if strcmpi(ButtonType, 'Push')
    Button = [
        Button(1:17)
        'buttonType "push"'
        Button(18:end)
        ];
end

if strcmpi(LabelType, 'Literal')
    Button = [
        Button(1:17)
        'labelType "literal"'
        Button(18:end)
        ];
end

if ~isempty(OffLabel)
    Button = [
        Button(1:17)
        sprintf('offLabel "%s"', OffLabel)
        Button(18:end)
        ];
end
if ~isempty(OnLabel)
    Button = [
        Button(1:17)
        sprintf('onLabel "%s"', OnLabel)
        Button(18:end)
        ];
end