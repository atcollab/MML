function [Header, TitleBar] = EDMHeader(varargin)

if nargin < 1
    TitleBar = '';
end
if nargin < 2
    WindowLocation = [60 60];
end

TitleBar = '';
FileName = '';
WindowLocation = [];
AppendFlag = 0;
Width  = [];
Height = [];
BackgroundColor = [];
ForegroundColor = [];

for i = length(varargin):-1:1
    if ischar(varargin{i}) && size(varargin{i},1)==1
        if strcmpi(varargin{i},'TitleBar')
            TitleBar = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'FileName')
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'WindowLocation')
            WindowLocation = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Append')
            AppendFlag = 1;
            varargin(i) = [];
        elseif strcmpi(varargin{i},'Width')
            Width = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'Height')
            Height = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'BackgroundColor')
            BackgroundColor = varargin{i+1};
            varargin(i:i+1) = [];
        elseif strcmpi(varargin{i},'ForegroundColor')
            ForegroundColor = varargin{i+1};
            varargin(i:i+1) = [];
        end
    end
end



Header = {
'4 0 1'
'beginScreenProperties'
'major 4'
'minor 0'
'release 1'
'x 60   '
'y 60   '
'w 100  '
'h 100  '
'font "helvetica-medium-r-18.0"'
'ctlFont "helvetica-medium-r-14.0"'
'btnFont "helvetica-medium-r-14.0"'
'fgColor index 14'
'bgColor index 4'
'textColor index 14'
'ctlFgColor1 index 14'
'ctlFgColor2 index 0'
'ctlBgColor1 index 0'
'ctlBgColor2 index 14'
'topShadowColor index 0'
'botShadowColor index 14'
'title ""'
'showGrid'
'endScreenProperties'
};


% WindowLocation, Width, Height need to be the same size 
% all the time for rewind and write to work properly
if ~isempty(WindowLocation)
    Header{6}  = sprintf('x %5s', num2str(round(WindowLocation(1))));
    Header{7}  = sprintf('y %5s', num2str(round(WindowLocation(2))));
end

if ~isempty(Width)
    Header{8} = sprintf('w %5s', num2str(round(Width)));
end
if ~isempty(Height)
    Header{9} = sprintf('h %5s', num2str(round(Height)));
end
if ~isempty(ForegroundColor)
    Header{13} = sprintf('fgColor index %s', num2str(round(ForegroundColor)));
end
if ~isempty(BackgroundColor)
    Header{14} = sprintf('bgColor index %s', num2str(round(BackgroundColor)));
end

if ~isempty(TitleBar)
    Header{22} = sprintf('title "%s"', TitleBar);
end


% Write to file or just return the cell array
if ~isempty(FileName)
    if ischar(FileName)
        fid = fopen(FileName, 'r+', 'b');
    else
        fid = FileName;
    end
        
    status = fseek(fid, 0, 'bof');
    for i = 1:length(Header)
        fprintf(fid, '%s\n', Header{i});
    end
    
    if ischar(FileName)
        fclose(fid);
    end
end

