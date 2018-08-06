function ExitButton = EDMExitButton(x, y, varargin)
%
%
%   EXAMPLES
%   1. ExitButton = EDMExitButton(10, 130, 'ExitProgram')


% Defaults
FontSize = 14;              % 8 10 12 14 18 24 72
FontWeight = 'bold';        % 'medium', 'bold'
FontName = 'helvetica';     % 'utopia', 'courier', 'new century schoolbook', 'times'

FileName = '';
Width  = [];
Height = [];

ExitProgram = 0;

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
        elseif strcmpi(varargin{i},'ExitProgram')
            ExitProgram = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'FileName')
            FileName = varargin{i+1};
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


ExitButton = { 
'# (Exit Button)'
'object activeExitButtonClass'
'beginObjectProperties'
'major 4'
'minor 1'
'release 0'
'x 838'
'y 2'
'w 65'
'h 20'
'fgColor index 14'
'bgColor index 56'
'topShadowColor index 0'
'botShadowColor index 14'
'label "EXIT"'
'font "helvetica-bold-r-18.0"'
'3d'
'endObjectProperties'
};

ExitButton{7}  = sprintf('x %d', x);
ExitButton{8}  = sprintf('y %d', y);
if ~isempty(Width)
    ExitButton{9} = sprintf('w %d', round(Width));
end
if ~isempty(Height)
    ExitButton{10} = sprintf('h %d', round(Height));
end

ExitButton{16} = sprintf('font "%s-%s-r-%.1f"', lower(FontName), lower(FontWeight), FontSize);

if ExitProgram
    ExitButton{18} = 'exitProgram';
    ExitButton{19} = 'endObjectProperties';
end


% Write to file or just return the cell array
if ~isempty(FileName)
    if ischar(FileName)
        fid = fopen(FileName, 'r+', 'b');
    else
        fid = FileName;
    end
        
    status = fseek(fid, 0, 'eof');
    for i = 1:length(ExitButton)
        fprintf(fid, '%s\n', ExitButton{i});
    end
    
    if ischar(FileName)
        fclose(fid);
    end
end