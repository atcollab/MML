function Button = EDMShellCommand(Command, x, y, varargin)

%

% NOTES
% 1.


% Defaults
FontSize = 14;
FontWeight = 'bold';  % 'medium', 'bold'
FontName = 'helvetica';

CommandLabel = {};
ButtonLabel = '';

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
        elseif strcmpi(varargin{i},'ButtonLabel')
            ButtonLabel = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'CommandLabel')
            CommandLabel = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end


Button = {
'# (Shell Command)'
'object shellCmdClass'
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
'font "helvetica-bold-r-18.0"'
'buttonLabel ""'
'numCmds 1'
'command {'
'  0 "ShellFile"'
'}'
'endObjectProperties'
};

% 'numCmds 3
% 'commandLabel {
% '  0 "hi"
% '  1 "Label1"
% '  2 "label2"
% '}
% 'command {
% '  0 "runddd 1"
% '  1 "abc"
% '  2 "abc2"

Button{7}  = sprintf('x %d', x);
Button{8}  = sprintf('y %d', y);
Button{9}  = sprintf('w %d', Width);
Button{10} = sprintf('h %d', Height);
Button{15} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);

Button{16} = sprintf('buttonLabel "%s"', ButtonLabel);

if ischar(CommandLabel)
    CommandLabel = deblank(mat2cell(CommandLabel, ones(1,size(CommandLabel,1)),size(CommandLabel,2)));
end
if ischar(Command)
    Command = deblank(mat2cell(Command, ones(1,size(Command,1)),size(Command,2)));
    
%     if ~isempty(Command)
%         if ~(Command(1)=='/' || Command(1)=='.')
%             % Add ./
%             Command = ['./', Command];
%         end
%     end
% else
%     for i = 1:length(Command)
%         if ~isempty(Command{i})
%             if ~(Command{i}(1)=='/' || Command{i}(1)=='.')
%                 % Add ./
%                 Command{i} = ['./', Command{i}];
%             end
%         end
%     end
end

Button{17}  = sprintf('numCmds %d', length(Command));

n = 18;
Button{n} = sprintf('commandLabel {');
for i = 1:length(CommandLabel)
    n = n + 1;
    Button{n} = sprintf('  %d "%s"', i-1, CommandLabel{i});
end
n = n + 1;
Button{n} = sprintf('}');

n = n + 1;
Button{n} = sprintf('command {');
for i = 1:length(Command)
    n = n + 1;
    Button{n} = sprintf('  %d "%s"', i-1, Command{i});
end
n = n + 1;
Button{n} = sprintf('}');

n = n + 1;
Button{n} = sprintf('endObjectProperties');

   