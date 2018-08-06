function Button = EDMRelatedDisplay(Command, x, y, varargin)

% Defaults
FontSize = 14;
FontWeight = 'bold';  % 'medium', 'bold'
FontName = 'helvetica';

ForegroundColor = [];  % 14
BackgroundColor = [];  % 61

Width  = 70;
Height = 20;

CommandLabel = {};
ButtonLabel = '';

Macro = {};

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
        elseif strcmpi(varargin{i},'ForegroundColor')
            ForegroundColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'BackgroundColor')
            BackgroundColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'CommandLabel')
            CommandLabel = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ButtonLabel')
            ButtonLabel = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Macro')
            Macro = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end


Button = {
'# (Related Display)'
'object relatedDisplayClass'
'beginObjectProperties'
'major 4'
'minor 2'
'release 0'
'x 18'
'y 137'
'w 70'
'h 20'
'fgColor index 14'
'bgColor index 61'
'topShadowColor index 0'
'botShadowColor index 14'
'font "helvetica-bold-r-14.0"'
'buttonLabel ""'
'numPvs 4'
'numDsps 1'
'displayFileName {'
'  0 "LMI.edl"'
'}'
'icon'
'endObjectProperties'
};


if ischar(CommandLabel)
    CommandLabel = deblank(mat2cell(CommandLabel, ones(1,size(CommandLabel,1)),size(CommandLabel,2)));
end
if ischar(Command)
    Command = deblank(mat2cell(Command, ones(1,size(Command,1)),size(Command,2)));
end
if ischar(Macro)
    Macro = deblank(mat2cell(Macro, ones(1,size(Macro,1)),size(Macro,2)));
end


Button{7}  = sprintf('x %d', x);
Button{8}  = sprintf('y %d', y);
Button{9}  = sprintf('w %d', Width);
Button{10} = sprintf('h %d', Height);

if ~isempty(ForegroundColor)
    % Change FG color
    Button{11} = sprintf('fgColor index %d', ForegroundColor); 
end

if ~isempty(BackgroundColor)
    % Change BG color
    Button{12} = sprintf('bgColor index %d', BackgroundColor); 
end

Button{15} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);

Button{16} = sprintf('buttonLabel "%s"', ButtonLabel);

Button{20} = sprintf('  0 "%s"', Command{1});


% Macros
if ~isempty(Macro)
    n = length(Button);
    n = n - 1;
    Button{n} = sprintf('symbols {');
    for i = 1:length(Macro)
        n = n + 1;
        Button{n} = sprintf('  %d "%s"', i-1, Macro{i});
    end
    n = n + 1;
    Button{n} = sprintf('}');
    
    
    n = n + 1;
    Button{n} = sprintf('icon');
    n = n + 1;
    Button{n} = sprintf('endObjectProperties');
end

% if ischar(CommandLabel)
%     CommandLabel = deblank(mat2cell(CommandLabel, ones(1,size(CommandLabel,1)),size(CommandLabel,2)));
% end

